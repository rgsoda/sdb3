package NewYarn;
use warnings;
use strict;
use Data::Dumper;
use Yarn::YarnDetails;
use Yarn::YarnDB;

our @ISA = ('YarnDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Yarn');
	
	$self->{add_button} = new_from_stock Gtk2::Button('gtk-add');

	$self->{buttons}->add($self->{add_button});
	
	$self->{add_button}->signal_connect('clicked' => sub { 
		$self->{data_hash}{name} = $self->{name_entry}->get_text(); 
		$self->{data_hash}{thickness} = $self->{thickness_entry}->get_text(); 
		if(YarnDB->add_yarn($self->{data_hash})){
			print "Yarn Added Successfully";
			$self->{win}->destroy;
		}
		
	});

	$self->{buttons}->show_all;
	bless $self,$class;
}
1;

