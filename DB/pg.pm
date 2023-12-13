package DB::pg;
use DBI;
use Data::Dumper;
sub new {
	my $class = shift;
	my $self = {
			username => 'sontex',
			password => 'sontex',
			dbname => 'sdb3',
			dbhost => 'box',
		
	};
	my %params = @_;
	$self->{dbh} = DBI->connect("dbi:Pg:dbname=$self->{dbname};host=$self->{dbhost}", $self->{username} , $self->{password},
					{ RaiseError => 1, AutoCommit => 1 }) || return undef;
	$self->{log} = $self->{dbh}->prepare_cached('insert into log(query,params) values (?,?)');
	$self->{option_types} = {};
	$self->{option_id} = {};

	my $opts = $self->{dbh}->prepare('select option_id,option_name,option_type from options');
	$opts->execute;
	while(my $row = $opts->fetchrow_arrayref){
		$self->{option_types}->{$$row[1]} = $$row[2];		
		$self->{option_id}->{$$row[1]} = $$row[0];		
	}
	
	bless $self,$class;
}

sub connect {
	my $self = shift;
	$self->{dbh} = DBI->connect("dbi:Pg:dbname=$self->{dbname};host=$self->{dbhost}", $self->{username} , $self->{password},
					{ RaiseError => 1, AutoCommit => 0 }) || return undef;
}
sub log {
	my $self = shift;
	my $query = shift;
	my $params;
	if(ref $_[0]){
		$params = '{'.join(',', map {s/"/\\"/g; $_ = '"'.$_.'"'} @{$_[0]} ).'}';
	}elsif($#_){
		$params = '{'.join(',', map {s/"/\\"/g; $_ = '"'.$_.'"'} @_ ).'}';
	}
	$self->{log}->execute($query,$params);
}
	

1;
