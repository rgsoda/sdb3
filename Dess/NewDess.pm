package NewDess;
use warnings;
use strict;
use Data::Dumper;
use Dess::DessDetails;
use Dess::DessTypeList;
use Dess::DessDB;
our @ISA = ('DessDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Dess');
	
	$self->{add_button} = new_from_stock Gtk2::Button('gtk-add');
	$self->{hbox_buttons}->add($self->{add_button});
	
        $self->{add_button}->signal_connect('clicked' => sub {
                $self->{data_hash}{finish_gramma} = $self->{finish_gramma_entry}->get_text();
                $self->{data_hash}{finish_width} = $self->{finish_width_entry}->get_text();		

                DessDB->add_dess($self->{data_hash});
                $self->{win}->destroy;

        });
	
	$self->{hbox_buttons}->show_all;
	bless $self,$class;
}
1;

