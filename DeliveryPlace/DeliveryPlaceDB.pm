package DeliveryPlaceDB;
use DBI;
use Data::Dumper;


sub add_delivery_place {
	my $self = shift;	
	my $delivery_place_data = shift;
	my @ret;
	eval {
		$main::pg->{dbh}->begin_work;
		my @fields = sort keys %$delivery_place_data;
		my @values =  @{$delivery_place_data}{@fields};
		my $q = sprintf 'insert into delivery_place (%s) values (%s)',join(',',@fields),join(',',('?')x@values);
		my $query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute(@values);
		$main::pg->log($q,@values);
		$main::pg->{dbh}->commit;
	};
	if( $@ ) {
		warn "Transaction failed: ".$main::pg->{dbh}->errstr;
		eval { $main::pg->{dbh}->rollback; };
		return undef;
	}
	return 1;
}


sub get_delivery_place {
	my $self = shift;
	my $q = "select * from delivery_place where delivery_place_id = ?";
	my $query = $main::pg->{dbh}->prepare_cached($q,undef,1);
	$query->execute(shift);
	
	return $query->fetchrow_hashref;

}

sub get_delivery_place_list {
	my $self = shift;
	my $q = "select delivery_place_id,country,address,city from delivery_place order by country";
	my $query = $main::pg->{dbh}->prepare_cached($q,undef,1);
	$query->execute();
	
	return $query->fetchall_arrayref;

}
sub update_delivery_place {
	my $self = shift;
	my $delivery_place_id = shift;
	my $new = shift;
	my $old = shift;
	my @update_fields  = ('country', 'address', 'city');
	my @history_fields  = ('country', 'address', 'city');

	my @history_values;
	my @update_values;
	for(reverse (0 .. $#update_fields)){
		if( ($new->{$update_fields[$_]} eq $old->{$update_fields[$_]}) or !defined $new->{$update_fields[$_]} ){
			splice @update_fields, $_,1;
			splice @history_fields, $_,1;
		} else {
			unshift @history_values, $new->{$history_fields[$_]};
			unshift @history_values, $old->{$history_fields[$_]};
			unshift @update_values, $new->{$update_fields[$_]};
		
		}	
	}
	return 1 unless scalar @update_fields;
	my $history = "get_user(CURRENT_USER) || ' (' || now() || '): ' || ".join("|| ', ' ||", map({ $_ = "'$_: '|| ? || ' => ' || ?"}  @history_fields));
	my $updates = join(', ', map ({ $_ .= ' = ?'} @update_fields));
	
	eval {
		$main::pg->{dbh}->begin_work;
		my $q = "update delivery_place set $updates where delivery_place_id = ?";
		my $query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute(@update_values,$delivery_place_id);
		$main::pg->log($q,@update_values);
	
		$q = "update delivery_place set delivery_place_last_changed = now(), delivery_place_history = delivery_place_history || '\\n' || $history where delivery_place_id = ?";
		$query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute(@history_values,$yarn_id);
		$main::pg->log($q,@history_values);
		
		$main::pg->{dbh}->commit;
	};
	if( $@ ) {
		warn "Transaction failed: ".$main::pg->errstr;
		eval { $main::pg->{dbh}->rollback; };
		return undef;
	}
	return 1;
}
1;
