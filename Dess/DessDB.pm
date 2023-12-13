package DessDB;
use DBI;
use Data::Dumper;

sub get_quality_list {
	my $self = shift;
	my $q = "select quality_id,polish_quality_name,quality_type,raw_gramma,raw_width from quality natural join quality_type order by quality_type";
	my $query = $main::pg->{dbh}->prepare_cached($q);
	$query->execute;
	return $query->fetchall_arrayref;
}

sub get_customer_list {
	my $self = shift;
	my $q = "select customer_id,name from customer order by name";
	my $query = $main::pg->{dbh}->prepare_cached($q);
	$query->execute;
	return $query->fetchall_arrayref;
}

sub add_dess {
	my $self = shift;
	my $dess_data = shift;
	warn Dumper $dess_data;
	my @ret;
	eval {
		$main::pg->{dbh}->begin_work;
		my @fields = sort keys %$dess_data;
		my @values =  @{$dess_data}{@fields};
		my $q = sprintf 'insert into quality_finish (%s) values (%s)',join(',',@fields),join(',',('?')x@values);
		warn $q;
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


1;

