package EditQuality;
use warnings;
use strict;
use Data::Dumper;
use Qualities::QualityDetails;
use Qualities::QualityDB;
our @ISA = ('QualityDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'Edit Quality');
	$self->{quality_id} = shift;
	($self->{old_data},$self->{composition_old_data}) = QualityDB->get_quality($self->{quality_id});
	$self->{data_hash}->{$_} = $self->{old_data}->{$_} for keys %{$self->{old_hash}};
	$self->{composition_data_hash}->{$_} = $self->{composition_old_data}->{$_} for keys %{$self->{composition_old_hash}};

	for(qw/pl_no_entry dk_no_entry m_br_entry m_fin_entry gramma_entry width_entry type_entry/){
		$self->{$_}->set_validator(\&Validators::always_valid);
	}
	for(qw/type_entry/){
		$self->{$_}->{already_focused} = 1;
	}
	
	$self->{update_button} = new_from_stock Gtk2::Button('gtk-apply');
	$self->{hbox_buttons}->add($self->{update_button});
	$self->{remove_button} = new_from_stock Gtk2::Button('gtk-remove');
	$self->{hbox_buttons}->add($self->{remove_button});
	
	$self->{pl_no_entry}->set_text($self->{old_data}->{polish_quality_name});
	$self->{dk_no_entry}->set_text($self->{old_data}->{danish_quality_name});
	$self->{m_br_entry}->set_text($self->{old_data}->{machine_width});
	$self->{m_fin_entry}->set_text($self->{old_data}->{machine_fin});
	$self->{gramma_entry}->set_text($self->{old_data}->{raw_gramma});
	$self->{width_entry}->set_text($self->{old_data}->{raw_width});
	$self->{type_entry}->{entry}->set_text($self->{old_data}->{quality_type});
	@{$self->{list}->{data}} = @{$self->{composition_old_data}};



	
	$self->{update_button}->signal_connect('clicked' => \&update,$self); 

	$self->{hbox_buttons}->show_all;
	bless $self,$class;
}

sub update {
	my $self = pop;
	$self->{data_hash}{polish_quality_name} = $self->{pl_no_entry}->get_text();
        $self->{data_hash}{danish_quality_name} = $self->{dk_no_entry}->get_text();
        $self->{data_hash}{machine_width} 	= $self->{m_br_entry}->get_text();
        $self->{data_hash}{machine_fin} 	= $self->{m_fin_entry}->get_text();
        $self->{data_hash}{raw_gramma} 		= $self->{gramma_entry}->get_text();
        $self->{data_hash}{raw_width} 		= $self->{width_entry}->get_text();
        $self->{data_hash}{raw_twice} 		= 'false';
        for (@{$self->{list}->{data}}) {
		push @{$self->{composition_data_hash}}, { 'yarn_id' => @{$_}[0], 'percentage' => @{$_}[2] };
	}
	if(QualityDB->update_quality($self->{quality_id},$self->{data_hash},$self->{composition_data_hash},$self->{old_data},$self->{composition_old_data})){
		print "Quality Edited Successfully";
		$self->{win}->destroy;
	}
};
1;

