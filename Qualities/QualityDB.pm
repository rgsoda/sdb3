package QualityDB;
use DBI;
use Data::Dumper;

sub get_quality_type_list {
	my $self = shift;
	my $q = "select quality_type_id,quality_type from quality_type order by quality_type";
	my $query = $main::pg->{dbh}->prepare_cached($q);
	$query->execute;
	return $query->fetchall_arrayref;
}

sub get_quality_list {
	my $self = shift;
	my $q = "SELECT t1.quality_id,t1.polish_quality_name,t1.danish_quality_name,t2.quality_type,t1.raw_gramma,t1.raw_width,t1.machine_width,t1.machine_fin from quality t1 natural join quality_type t2 order by t1.polish_quality_name;";
	my $query = $main::pg->{dbh}->prepare_cached($q);
	$query->execute;
	return $query->fetchall_arrayref;
}
sub add_quality {
	my $self = shift;
	my $order_data = shift;
	my @ret;
	eval {
		$main::pg->{dbh}->begin_work;
		my @fields = sort keys %$order_data;
		my @values =  @{$order_data}{@fields};
		my $q = sprintf 'insert into quality (%s) values (%s)',join(',',@fields),join(',',('?')x@values);
		my $query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute(@values);

		$q = 'select currval(\'quality_quality_id_seq\')';
		$query = $main::pg->{dbh}->prepare_cached($q);
		$query->execute;
		my $quality_id;# = shift @{$query->fetchrow_arrayref};
		while( my $row = $query->fetchrow_arrayref){
			warn Dumper $row;
			$quality_id = $row->[0];
		}
		
		while(my $composition = shift){
			warn Dumper $composition;
			@fields = sort keys %$composition;
			@values =  @{$composition}{@fields};
			$q = sprintf 'insert into composition (quality_id,%s) values (?,%s)',join(',',@fields),join(',',('?')x@values);
			$query = $main::pg->{dbh}->prepare_cached($q);
			$query->execute($quality_id,@values);

		}
		$main::pg->{dbh}->commit;
	};
	if( $@ ) {
		warn "Transaction failed: ".$main::pg->{dbh}->errstr;
		eval { $main::pg->{dbh}->rollback; };
		return undef;
	}
	return $order_id;
}

sub get_quality {
	my $self = shift;
	my $quality_id = shift;
	my $q = "select t1.*,t2.quality_type from quality t1 natural join quality_type t2 where t1.quality_id = ?";
	my $query = $main::pg->{dbh}->prepare_cached($q);
	$query->execute($quality_id);


	my $qc = "select t1.yarn_id,t3.yarn_name,t1.percentage from composition t1 natural join yarn t2 natural join yarn_code t3 where quality_id = ?";
	my $queryc = $main::pg->{dbh}->prepare_cached($qc);
	$queryc->execute($quality_id);
	return $query->fetchrow_hashref,$queryc->fetchall_arrayref;

}
sub update_quality {
    my $self = shift;
    my $q_new = shift;
    my $c_new = shift;
    my $q_old = shift;
    my $c_old = shift;
    
    #TODO 
}

sub get_yarn_list {
	
	my $self = shift;
	my $q = "select yarn_id,yarn_code,yarn_name,yarn_type,thickness,unit,twist,name from yarn natural join yarn_code natural join yarn_type";
	my $query = $main::pg->{dbh}->prepare_cached($q);
	$query->execute;
	return $query->fetchall_arrayref;
}

1;

