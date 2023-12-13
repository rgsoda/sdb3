package EditYarn;
use warnings;
use strict;
use Data::Dumper;
use Yarn::YarnDetails;
use Yarn::YarnDB;
our @ISA = ('YarnDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'Edit Yarn');
	$self->{yarn_id} = shift;
	$self->{old_data} = YarnDB->get_yarn($self->{yarn_id});
	
	$self->{data_hash}->{$_} = $self->{old_data}->{$_} for keys %{$self->{old_hash}};

	
	for(qw/yarn_code_entry yarn_type_entry yarn_unit_entry yarn_twist_entry/){
		$self->{$_}->set_validator(\&Validators::always_valid);
	}
	for(qw/name_entry thickness_entry/){
		$self->{$_}->{already_focused} = 1;
	}
	
	$self->{update_button} = new_from_stock Gtk2::Button('gtk-apply');
	$self->{buttons}->add($self->{update_button});
#	$self->{remove_button} = new_from_stock Gtk2::Button('gtk-remove');
#	$self->{buttons}->add($self->{remove_button});

	$self->{yarn_code_entry}->set_text($self->{old_data}->{yarn_code});
	$self->{yarn_code_entry}->select($self->{old_data}->{yarn_code_id});
	
	$self->{yarn_type_entry}->set_text($self->{old_data}->{yarn_type});
	$self->{yarn_type_entry}->select($self->{old_data}->{yarn_type_id});
		
	$self->{thickness_entry}->set_text($self->{old_data}->{thickness});
	
	$self->{yarn_unit_entry}->set_text($self->{old_data}->{unit});
	$self->{yarn_unit_entry}->select($self->{old_data}->{unit});
	
	$self->{yarn_twist_entry}->set_text($self->{old_data}->{twist});
	$self->{yarn_twist_entry}->select($self->{old_data}->{twist});
	
	$self->{name_entry}->set_text($self->{old_data}->{name});
	
	$self->{history}->get_buffer->set_text($self->{old_data}->{yarn_history});
		
	$self->{update_button}->signal_connect('clicked' => \&update,$self); 

	$self->{buttons}->show_all;
	bless $self,$class;
}

sub update {
	my $self = pop;
	$self->{data_hash}->{name} = $self->{name_entry}->get_text(); 
	$self->{data_hash}->{thickness} = $self->{thickness_entry}->get_text();
	$self->{data_hash}->{yarn_code} = $self->{yarn_code_entry}->get_text;
	$self->{data_hash}->{yarn_type} = $self->{yarn_type_entry}->get_text;
	
	if(YarnDB->update_yarn($self->{yarn_id},$self->{data_hash},$self->{old_data})){
		print "Yarn Edited Successfully";
		$self->{win}->destroy;
	}
};
1;

