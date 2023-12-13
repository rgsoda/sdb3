package EditCustomer;
use warnings;
use strict;
use Data::Dumper;
use Customer::CustomerDetails;
use Customer::CustomerDB;
our @ISA = ('CustomerDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'Edit Customer');
	$self->{customer_id} = shift;
	$self->{old_data} = CustomerDB->get_customer($self->{customer_id});
	warn Dumper $self->{old_data};
	
	$self->{data_hash}->{$_} = $self->{old_data}->{$_} for keys %{$self->{old_hash}};

	
	for(qw/name_entry country_entry address_entry city_entry nip_entry regon_entry contact_person_entry email_entry phone_entry/){
		$self->{$_}->set_validator(\&Validators::always_valid);
	}
	for(qw/name_entry country_entry address_entry city_entry nip_entry regon_entry contact_person_entry email_entry phone_entry/){
		$self->{$_}->{already_focused} = 1;
	}
	
	$self->{update_button} = new_from_stock Gtk2::Button('gtk-apply');
	$self->{buttons}->add($self->{update_button});
		
	$self->{name_entry}->set_text($self->{old_data}->{name});
	$self->{country_entry}->set_text($self->{old_data}->{country});
	$self->{address_entry}->set_text($self->{old_data}->{address});
	$self->{city_entry}->set_text($self->{old_data}->{city});
	$self->{nip_entry}->set_text($self->{old_data}->{nip});
	$self->{regon_entry}->set_text($self->{old_data}->{regon});
	$self->{email_entry}->set_text($self->{old_data}->{email});	
	$self->{contact_person_entry}->set_text($self->{old_data}->{contact_person});	
	$self->{phone_entry}->set_text($self->{old_data}->{phone});
	$self->{history}->get_buffer->set_text($self->{old_data}->{customer_history});
		
	$self->{update_button}->signal_connect('clicked' => \&update,$self); 

	$self->{buttons}->show_all;
	bless $self,$class;
}

sub update {
	my $self = pop;
	$self->{data_hash}->{name} = $self->{name_entry}->get_text;
	$self->{data_hash}->{country} = $self->{country_entry}->get_text;
	$self->{data_hash}->{address} = $self->{address_entry}->get_text;
	$self->{data_hash}->{city} = $self->{city_entry}->get_text;
	$self->{data_hash}->{nip} = $self->{nip_entry}->get_text;
	$self->{data_hash}->{regon} = $self->{regon_entry}->get_text;
	$self->{data_hash}->{contact_person} = $self->{contact_person_entry}->get_text;	
	$self->{data_hash}->{email} = $self->{email_entry}->get_text;
	$self->{data_hash}->{phone} = $self->{phone_entry}->get_text;
	if(CustomerDB->update_customer($self->{customer_id},$self->{data_hash},$self->{old_data})){
		print "Customer Edited Successfully";
		$self->{win}->destroy;
	}
};
1;

