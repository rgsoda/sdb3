package Gtk2::PopupCalendarEntry;

use Data::Dumper;
use Popup;
use Gtk2;
use Gtk2::ValidEntry;
use Validators;
use warnings;
use strict;

use Glib::Object::Subclass
    Gtk2::HBox::,
    	signals => {
   # 		changed => \&do_changed,
#		clicked => \&do_clicked,
	},
	properties => [];


sub new {
	my $class = shift;
	my $self = $class->SUPER::new;
	$self->{export} = (shift || \$self->{dummy});
	$self->{validator} = (shift || \&Validators::is_valid);
	$self->{entry} = new Gtk2::ValidEntry($self->{validator},$self->{value_label});
	my $text = shift;
	$self->{entry}->set_text($text || '');
	$self->{entry}->can_focus(0);
	$self->{entry}->set_editable(0);
					
	$self->{button} = new Gtk2::Button('...');
	my $tooltip = new Gtk2::Tooltips;
	$tooltip->set_tip($self->{button},$text,undef);
	$self->pack_start($self->{entry},1,1,0);	
	$self->pack_start($self->{button},1,1,0);
	
	$self->{button}->signal_connect(clicked => \&button_clicked,$self);

	bless $self,$class;
}

sub get_entry { 
	my $self = shift;
	return $self->{entry};
}
sub get_button { 
	my $self = shift;
	return $self->{button};
}

sub set_validator {
	my $self = shift;
	$self->{entry}->set_validator(@_);
}
sub set_text {
	my $self = shift;
	$self->{entry}->set_text(@_);
}
sub get_text {
	my $self = shift;
	$self->{entry}->get_text(@_);
}

sub button_clicked {
	my $self = pop;
	my $calendar = new Gtk2::Calendar;
	my $popup = new Gtk2::Popup($calendar);
	$popup->set_size_request(250,165);
	$popup->show_all;
	$calendar->signal_connect('day-selected-double-click' => sub {
	    my( $year, $month, $day) = $calendar->get_date;
	    $self->{entry}->{valid} = 1;
	    $self->{entry}->set_text(${$self->{export}} = sprintf('%04d-%02d-%02d',$year,$month,$day));
	    $popup->destroy;
	});
}

sub select {
	my $self = shift;
	$self->{id} = shift;
#	for(0 .. $#{$self->{widget}->{data}}){
#		if($self->{widget}->{data}->[0] eq $id){
#			warn '!!!';
#			$self->{widget}->select($_);
#			return
#		}
#	}
}

1;
