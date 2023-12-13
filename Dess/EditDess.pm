package EditDess;
use warnings;
use strict;
use Data::Dumper;
use Dess::DessDetails;
use Dess::DessDB;
our @ISA = ('DessDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'Edit Dess');
	$self->{dess_id} = shift;
	($self->{old_data},$self->{dess_old_data}) = DessDB->get_dess($self->{dess_id});
	$self->{data_hash}->{$_} = $self->{old_data}->{$_} for keys %{$self->{old_hash}};

	for(qw/associate_entry quality_entry finish_gramma finish_width/){
		$self->{$_}->set_validator(\&Validators::always_valid);
	}
	for(qw/finish_gramma finish_width/){
		$self->{$_}->{already_focused} = 1;
	}
	
	$self->{update_button} = new_from_stock Gtk2::Button('gtk-apply');
	$self->{hbox_buttons}->add($self->{update_button});
	$self->{remove_button} = new_from_stock Gtk2::Button('gtk-remove');
	$self->{hbox_buttons}->add($self->{remove_button});
	
	$self->{associate_entry}->{entry}->set_text($self->{old_data}->{associate});
	$self->{quality_entry}->{entry}->set_text($self->{old_data}->{quality});
	$self->{finish_gramma_entry}->{entry}->set_text($self->{old_data}->{finish_gramma});	
	$self->{finish_width_entry}->{entry}->set_text($self->{old_data}->{finish_width});

	$self->{update_button}->signal_connect('clicked' => \&update,$self); 

	$self->{hbox_buttons}->show_all;
	bless $self,$class;
}

sub update {
	my $self = pop;
	$self->{data_hash}{finish_gramma} = $self->{finish_gramma_entry}->get_text();
        $self->{data_hash}{finish_width} = $self->{finish_width_entry}->get_text();

	if(DessDB->update_dess($self->{dess_id},$self->{data_hash})){
		print "Dess Edited Successfully";
		$self->{win}->destroy;
	}
};
1;

