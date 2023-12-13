package NewAssociate;
use warnings;
use strict;
use Data::Dumper;
use Associate::AssociateDetails;
use Associate::AssociateDB;
our @ISA = ('AssociateDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Associate');
	
	$self->{add_button} = new_from_stock Gtk2::Button('gtk-add');

	$self->{buttons}->add($self->{add_button});
	
	$self->{add_button}->signal_connect('clicked' => sub { 
		$self->{data_hash}->{area} = $self->{area_entry}->{entry}->get_text;
		$self->{data_hash}->{company} = $self->{company_entry}->get_text;
		$self->{data_hash}->{country} = $self->{country_entry}->get_text;
		$self->{data_hash}->{address} = $self->{address_entry}->get_text;
		$self->{data_hash}->{city} = $self->{city_entry}->get_text;
		$self->{data_hash}->{nip} = $self->{nip_entry}->get_text;
		$self->{data_hash}->{regon} = $self->{regon_entry}->get_text;
		if(AssociateDB->add_associate($self->{data_hash})){
			print "Associate Added Successfully";
			$self->{win}->destroy;
		}
		
	});

	$self->{buttons}->show_all;
	bless $self,$class;
}
1;

