package Gtk2::Popup;

use warnings;
use strict;

use Gtk2;

use Glib::Object::Subclass
    Gtk2::Window::,
	signals=>{
	
	
	},
	properties=>[];


sub new {
	my $class = shift;
	my $self = $class->SUPER::new('toplevel');
	$self->{widget} = shift;
	$self->set_decorated(0);
	$self->set_gravity('static');
	$self->set_position('mouse');
	$self->set_modal(1);
	$self->set_size_request(200,120);
	$self->set_transient_for($main::gui->{win});
	$self->{scroll} = new Gtk2::ScrolledWindow;
	$self->{scroll}->set_policy('automatic','automatic');
	$self->{scroll}->add_with_viewport($self->{widget});
	
	$self->SUPER::add($self->{scroll});
	bless $self, $class;
}

sub add {

	my $self = shift;
	$self->{scroll}->add_with_viewport($self->{widget} = shift);
}

sub close {
	my $self = shift;
	$self->destroy;
}


1;
