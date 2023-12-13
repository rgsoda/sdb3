
sub add_order {
	my $self = shift;
	my $order_data = shift;
	my @ret;
	eval {
		$self->{dbh}->begin_work;
		my @fields = sort keys %$order_data;
		my @values =  @{$order_data}{@fields};
		my $q = sprintf 'insert into order (%s) values (%s)',join(',',@fields),join(',',('?')x@values);
		my $query = $self->{dbh}->prepare_cached($q);
		$query->execute(@values);
		$self->log($q,@values);
		
		$q = 'select currval(\'order_order_id_seq\')';
		$query = $self->{dbh}->prepare_cached($q);
		$query->execute;
		my $order_id = shift @{$query->fetchrow_arrayref};
		while(my ($position,$options) = (shift,shift)){
			delete $position->{position};
			$position->{order_id} = $order_id;
			@fields = sort keys %$position;
			@values =  @{$position}{@fields};
			$q = sprintf 'insert into position (%s) values (%s)',
					join(',',('position',@fields)),
					join(',',("coalesce((select max(position)+1 from order_item where order_id = ?),1)",('?')x@values));
			my $query = $self->{dbh}->prepare_cached($q);
			$query->execute($order_id,@values);
			$self->log($q,@values);
			for(keys %$options){
				$q = "insert into order_item_options 
					(option_id,order_id,position,$self->{option_types}->{$_}_value) values 
					(?,(select max(position) from order_item where order_id = ?),?,?)";
				@values = ($self->{option_id}->{$_},$order_id,$order_id,$options->{$_});
				$query = $self->{dbh}->prepare_cached($q);
				$query->execute(@values);
				$self->log($q,@values);
			}
		}
		$self->{dbh}->commit;
		$params = '{'.join(',', map {$_ = '"'.$_.'"'} @$params ).'}';
	$self->{log}
	}
}

sub edit_order {
	my $self = shift;
	my $order_id = shift;
	my $order_data = shift;
	
	my @fields = sort keys %$order_data;
	my @values =  @{$order_data}{@fields};
	my $q = sprintf 'update order set %s where order_id = ?', join(',',map {$_ = "$_ = ?";} @fields);
	my $query = $self->{dbh}->prepare_cached($q);
	eval {
		$self->{dbh}->begin_work;
		$query->execute(@values,$order_id);
		$self->{dbh}->commit;
	};
	if($@){
		warn "Transaction failed: ".$self->{dbh}->errstr;
		eval { $self->{dbh}->rollback; };
		return undef;
	}
	return $order_id;
}


