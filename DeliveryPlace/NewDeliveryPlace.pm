package NewDeliveryPlace;
use warnings;
use strict;
use Data::Dumper;
use DeliveryPlace::DeliveryPlaceDB;
use DeliveryPlace::DeliveryPlaceDetails;
our @ISA = ('DeliveryPlaceDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Delivery Place');
	
	$self->{add_button} = new_from_stock Gtk2::Button('gtk-add');

	$self->{buttons}->add($self->{add_button});
	
	$self->{add_button}->signal_connect('clicked' => sub { 
		$self->{data_hash}->{country} = $self->{country_entry}->get_text;
		$self->{data_hash}->{address} = $self->{address_entry}->get_text;
		$self->{data_hash}->{city} = $self->{city_entry}->get_text;
		if(DeliveryPlaceDB->add_delivery_place($self->{data_hash})){
			print "Delivery Place Added Successfully";
			$self->{win}->destroy;
		}
		
	});

	$self->{buttons}->show_all;
	bless $self,$class;
}
1;

