package CustomerDB;
use DBI;
use Data::Dumper;

sub add_customer {
	my $self = shift;
	my $customer_data = shift;
	my @ret;
	eval {
		$main::pg->{dbh}->begin_work;
		my @fields = sort keys %$customer_data;
		my @values =  @{$customer_data}{@fields};
		my $q = sprintf 'insert into customer (%s) values (%s)',join(',',@fields),join(',',('?')x@values);
		my $query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute(@values);
		$main::pg->log($q,@values);
		$main::pg->{dbh}->commit;
	};
	if( $@ ) {
		warn "Transaction failed: ".$main::pg->{dbh}->errstr;
		eval { $main::pg->{dbh}->rollback; };
		return undef;
	} return 1;
}
sub get_customer {
	my $self = shift;
	my $q = "select * from customer where customer_id = ?";
	my $query = $main::pg->{dbh}->prepare_cached($q,undef,1);
	$query->execute(shift);
	
	return $query->fetchrow_hashref;

}

sub get_customer_list {
	my $self = shift;
	my $q = "select customer_id,name,country,address,city,nip,regon,contact_person,email,phone from customer order by name";
	my $query = $main::pg->{dbh}->prepare_cached($q,undef,1);
	$query->execute();
	
	return $query->fetchall_arrayref;

}
sub update_customer {
	my $self = shift;
	my $customer_id = shift;
	my $new = shift;
	my $old = shift;
	my @update_fields  = ('company', 'country', 'address', 'city', 'nip','regon','contact_person','email','phone');
	my @history_fields  = ('company', 'country', 'address', 'city', 'nip','regon','contact_person','email','phone');

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
		my $q = "update customer set $updates where customer_id = ?";
		my $query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute(@update_values,$customer_id);
		$main::pg->log($q,@update_values);
	
		$q = "update customer set customer_last_changed = now(), customer_history = customer_history || '\\n' || $history where customer_id = ?";
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


