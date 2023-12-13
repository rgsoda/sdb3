package Popup;

use Gtk2;
use strict;
use warnings;
use Data::Dumper;

sub new {
	my $class = shift;
	my $self = {};
	
	$self->{win} = new Gtk2::Window('toplevel');
	$self->{win}->set_decorated(0);
	$self->{win}->set_gravity('static');
	$self->{win}->set_position('mouse');
	#$self->{p_win}->set_default_size('200','400');
	
	$self->{scroll_win} = new Gtk2::ScrolledWindow;
	$self->{scroll_win}->set_policy('never','never');
	
	$self->{main_vbox} = new Gtk2::VBox;

	$self->{vbox} = new Gtk2::VBox; # tutaj beda wsadzane stree
	$self->{hbox} = new Gtk2::HBox; # a tutaj guziorki
	

	$self->{vbox}->pack_start($self->{scroll_win},1,1,0);

	$self->{main_vbox}->pack_start($self->{vbox},1,1,0);
	$self->{main_vbox}->pack_start($self->{hbox},1,1,0);

	$self->{win}->add($self->{main_vbox});
	bless $self,$class;

}

sub close {
	my $self = shift;
	$self->{win}->destroy;
}

1;

