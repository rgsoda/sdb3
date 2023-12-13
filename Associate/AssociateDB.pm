package AssociateDB;
use DBI;
use Data::Dumper;

sub add_associate {
	my $self = shift;
	my $associate_data = shift;
	my @ret;
	eval {
		$main::pg->{dbh}->begin_work;
		my @fields = sort keys %$associate_data;
		my @values =  @{$associate_data}{@fields};
		my $q = sprintf 'insert into associate (%s) values (%s)',join(',',@fields),join(',',('?')x@values);
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
}
sub get_associate {
	my $self = shift;
	my $q = "select * from associate where associate_id = ?";
	my $query = $main::pg->{dbh}->prepare_cached($q,undef,1);
	$query->execute(shift);
	
	return $query->fetchrow_hashref;

}

sub get_associate_list {
	my $self = shift;
	my $q = "select associate_id,area,company,country,address,city,nip,regon from associate order by area";
	my $query = $main::pg->{dbh}->prepare_cached($q,undef,1);
	$query->execute();
	
	return $query->fetchall_arrayref;

}
sub update_associate {
	my $self = shift;
	my $associate_id = shift;
	my $new = shift;
	my $old = shift;
	my @update_fields  = ('area', 'company', 'country', 'address', 'city', 'nip','regon');
	my @history_fields  = ('area', 'company', 'country', 'address', 'city', 'nip','regon');

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
		my $q = "update associate set $updates where associate_id = ?";
		my $query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute(@update_values,$associate_id);
		$main::pg->log($q,@update_values);
	
		$q = "update associate set associate_last_changed = now(), associate_history = associate_history || '\\n' || $history where associate_id = ?";
		$query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute(@history_values,$yarn_id);
		$main::pg->log($q,@history_values);
		
		$main::pg->{dbh}->commit;
	};
	if( $@ ) {
		warn "Transaction failed: ".$main::pg->{dbh}->errstr;
		eval { $main::pg->{dbh}->rollback; };
		return undef;
	}
	return 1;
}
1;


