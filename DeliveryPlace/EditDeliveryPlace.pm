package EditDeliveryPlace;
use warnings;
use strict;
use Data::Dumper;
use DeliveryPlace::DeliveryPlaceDB;
use DeliveryPlace::DeliveryPlaceDetails;
our @ISA = ('DeliveryPlaceDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'Edit Delivery Place');
	$self->{delivery_place_id} = shift;
	$self->{old_data} = DeliveryPlaceDB->get_delivery_place($self->{delivery_place_id});
	warn Dumper $self->{old_data};
	
	$self->{data_hash}->{$_} = $self->{old_data}->{$_} for keys %{$self->{old_hash}};

	
	for(qw/country_entry address_entry city_entry/){
		$self->{$_}->set_validator(\&Validators::always_valid);
	}
	for(qw/country_entry address_entry city_entry/){
		$self->{$_}->{already_focused} = 1;
	}
	
	$self->{update_button} = new_from_stock Gtk2::Button('gtk-apply');
	$self->{buttons}->add($self->{update_button});
		
	$self->{country_entry}->set_text($self->{old_data}->{country});
	$self->{address_entry}->set_text($self->{old_data}->{address});
	$self->{city_entry}->set_text($self->{old_data}->{city});
	
	$self->{history}->get_buffer->set_text($self->{old_data}->{associate_history});
		
	$self->{update_button}->signal_connect('clicked' => \&update,$self); 

	$self->{buttons}->show_all;
	bless $self,$class;
}

sub update {
	my $self = pop;
	$self->{data_hash}->{country} = $self->{country_entry}->get_text;
	$self->{data_hash}->{address} = $self->{address_entry}->get_text;
	$self->{data_hash}->{city} = $self->{city_entry}->get_text;

	if(DeliveryPlaceDB->update_delivery_place($self->{delivery_place_id},$self->{data_hash},$self->{old_data})){
		print "Delivery Place Edited Successfully";
		$self->{win}->destroy;
	}
};
1;

