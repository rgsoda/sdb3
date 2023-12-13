package YarnDB;
use DBI;
use Data::Dumper;

sub get_yarn_type_list {
	my $self = shift;
	my $q = "select yarn_type_id,yarn_type from yarn_type order by yarn_type desc";
	my $query = $main::pg->{dbh}->prepare_cached($q);
	$query->execute;
	return $query->fetchall_arrayref;
}
sub get_yarn_code_list {
	
	my $self = shift;
	my $q = "select yarn_code_id,yarn_code,yarn_name from yarn_code order by yarn_code desc";
	my $query = $main::pg->{dbh}->prepare_cached($q);
	$query->execute;
	return $query->fetchall_arrayref;
}
sub get_yarn_list {
	
	my $self = shift;
	my $q = "select yarn_id,yarn_code,yarn_name,yarn_type,thickness,unit,twist,name from yarn natural join yarn_code natural join yarn_type";
	my $query = $main::pg->{dbh}->prepare_cached($q);
	$query->execute;
	return $query->fetchall_arrayref;
}

sub add_yarn {
	my $self = shift;
	my $yarn_data = shift;
#DEBUG:	warn Dumper $yarn_data;
	my @ret;
	eval {
		$main::pg->{dbh}->begin_work;
		my @fields = sort keys %$yarn_data;
		my @values =  @{$yarn_data}{@fields};
		my $q = sprintf 'insert into yarn (%s) values (%s)',join(',',@fields),join(',',('?')x@values);
		my $query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute(@values);
		$self->log($q,@values);
		$main::pg->{dbh}->commit;
	};
	if( $@ ) {
		warn "Transaction failed: ".$main::pg->{dbh}->errstr;
		eval { $main::pg->{dbh}->rollback; };
		return undef;
	}
}
sub get_yarn {
	my $self = shift;
	my $q = "select t1.*,t3.yarn_type,t2.yarn_name,t2.yarn_code from yarn t1 natural join yarn_code t2 natural join yarn_type t3 where yarn_id = ?";
	my $query = $main::pg->{dbh}->prepare_cached($q,undef,1);
	$query->execute(shift);
	
	return $query->fetchrow_hashref;

}

sub update_yarn {
	my $self = shift;
	my $yarn_id = shift;
	my $new = shift;
	my $old = shift;
	my @update_fields  = ('yarn_type_id', 'yarn_code_id', 'twist', 'name', 'thickness', 'unit');					      
	my @history_fields = ('yarn_type'   , 'yarn_code'   , 'twist', 'name', 'thickness', 'unit');

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
		my $q = "update yarn set $updates where yarn_id = ?";
		my $query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute(@update_values,$yarn_id);
		$main::pg->log($q,@update_values);
	
		$q = "update yarn set yarn_last_changed = now(), yarn_history = yarn_history || '\\n' || $history where yarn_id = ?";
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


