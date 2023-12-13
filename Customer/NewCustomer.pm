package NewCustomer;
use warnings;
use strict;
use Data::Dumper;
use Customer::CustomerDetails;
use Customer::CustomerDB;
our @ISA = ('CustomerDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New customer');
	
	$self->{add_button} = new_from_stock Gtk2::Button('gtk-add');

	$self->{buttons}->add($self->{add_button});
	
	$self->{add_button}->signal_connect('clicked' => sub { 
		$self->{data_hash}->{name} = $self->{name_entry}->get_text;
		$self->{data_hash}->{country} = $self->{country_entry}->get_text;
		$self->{data_hash}->{address} = $self->{address_entry}->get_text;
		$self->{data_hash}->{city} = $self->{city_entry}->get_text;
		$self->{data_hash}->{nip} = $self->{nip_entry}->get_text;
		$self->{data_hash}->{regon} = $self->{regon_entry}->get_text;
		$self->{data_hash}->{email} = $self->{email_entry}->get_text;		
		$self->{data_hash}->{contact_person} = $self->{contact_person_entry}->get_text;	
		$self->{data_hash}->{phone} = $self->{phone_entry}->get_text;	
		if(CustomerDB->add_customer($self->{data_hash})){
			print "customer Added Successfully";
			$self->{win}->destroy;
		}
		
	});

	$self->{buttons}->show_all;
	bless $self,$class;
}
1;

