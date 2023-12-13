package EditAssociate;
use warnings;
use strict;
use Data::Dumper;
use Associate::AssociateDetails;
use Associate::AssociateDB;
our @ISA = ('AssociateDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'Edit Associate');
	$self->{associate_id} = shift;
	$self->{old_data} = AssociateDB->get_associate($self->{associate_id});
	warn Dumper $self->{old_data};
	
	$self->{data_hash}->{$_} = $self->{old_data}->{$_} for keys %{$self->{old_hash}};

	
	for(qw/area_entry company_entry country_entry address_entry city_entry nip_entry regon_entry/){
		$self->{$_}->set_validator(\&Validators::always_valid);
	}
	for(qw/company_entry country_entry address_entry city_entry nip_entry regon_entry/){
		$self->{$_}->{already_focused} = 1;
	}
	
	$self->{update_button} = new_from_stock Gtk2::Button('gtk-apply');
	$self->{buttons}->add($self->{update_button});
		
	$self->{area_entry}->{entry}->set_text($self->{old_data}->{area});
	$self->{company_entry}->set_text($self->{old_data}->{company});
	$self->{country_entry}->set_text($self->{old_data}->{country});
	$self->{address_entry}->set_text($self->{old_data}->{address});
	$self->{city_entry}->set_text($self->{old_data}->{city});
	$self->{nip_entry}->set_text($self->{old_data}->{nip});
	$self->{regon_entry}->set_text($self->{old_data}->{regon});
	
	$self->{history}->get_buffer->set_text($self->{old_data}->{associate_history});
		
	$self->{update_button}->signal_connect('clicked' => \&update,$self); 

	$self->{buttons}->show_all;
	bless $self,$class;
}

sub update {
	my $self = pop;
	$self->{data_hash}->{area} = $self->{area_entry}->{entry}->get_text;
	$self->{data_hash}->{company} = $self->{company_entry}->get_text;
	$self->{data_hash}->{country} = $self->{country_entry}->get_text;
	$self->{data_hash}->{address} = $self->{address_entry}->get_text;
	$self->{data_hash}->{city} = $self->{city_entry}->get_text;
	$self->{data_hash}->{nip} = $self->{nip_entry}->get_text;
	$self->{data_hash}->{regon} = $self->{regon_entry}->get_text;

	if(AssociateDB->update_associate($self->{associate_id},$self->{data_hash},$self->{old_data})){
		print "Yarn Edited Successfully";
		$self->{win}->destroy;
	}
};
1;

