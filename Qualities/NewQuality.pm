package NewQuality;
use warnings;
use strict;
use Data::Dumper;
use Qualities::QualityDetails;
use Qualities::QualityDB;
our @ISA = ('QualityDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Quality');
	
	$self->{add_button} = new_from_stock Gtk2::Button('gtk-add');
	$self->{hbox_buttons}->add($self->{add_button});
	
        $self->{add_button}->signal_connect('clicked' => sub {
                $self->{data_hash}{polish_quality_name} = $self->{pl_no_entry}->get_text();
                $self->{data_hash}{danish_quality_name} = $self->{dk_no_entry}->get_text();
                $self->{data_hash}{machine_width} 	= $self->{m_br_entry}->get_text();
                $self->{data_hash}{machine_fin} 	= $self->{m_fin_entry}->get_text();
                $self->{data_hash}{raw_gramma} 		= $self->{gramma_entry}->get_text();
                $self->{data_hash}{raw_width} 		= $self->{width_entry}->get_text();
                $self->{data_hash}{raw_twice} 		= 'false';

		for (@{$self->{list}->{data}}) {
			push @{$self->{yarn_data_hash}}, { 'yarn_id' => @{$_}[0], 'percentage' => @{$_}[2] };
		}
                QualityDB->add_quality($self->{data_hash},@{$self->{yarn_data_hash}});
                $self->{win}->destroy;

        });
	
	$self->{hbox_buttons}->show_all;
	bless $self,$class;
}
1;

