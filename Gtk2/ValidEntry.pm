package Gtk2::ValidEntry;

use strict;
use Gtk2;

use constant VALID_RED => 24000;
use constant VALID_GREEN => 65535;
use constant VALID_BLUE => 24000;
use constant INVALID_RED => 65535;
use constant INVALID_GREEN => 24000;
use constant INVALID_BLUE => 24000;


use Glib::Object::Subclass
    Gtk2::Entry::,
        signals => {
			activate 		=> \&update_validity,
			'focus-out-event' 	=> \&update_validity,
			changed			=> \&update_validity,
		},
	properties => [
		Glib::ParamSpec->int(
			'valid_red','Valid Red',
			'Red component for valid entry',
			0,65535,VALID_RED,
			['readable']
		),
		Glib::ParamSpec->int(
			'valid_green','Valid Green',
			'Green component for valid entry',
			0,65535,VALID_GREEN,
			['readable']
		),
		Glib::ParamSpec->int(
			'valid_blue','Valid Blue',
			'Blue component for valid entry',
			0,65535,VALID_BLUE,
			['readable']
		),
		Glib::ParamSpec->int(
			'invalid_red','Inalid Red',
			'Red component for invalid entry',
			0,65535,INVALID_RED,
			['readable']
		),
		Glib::ParamSpec->int(
			'invalid_green','Invalid Green',
			'Green component for invalid entry',
			0,65535,INVALID_GREEN,
			['readable']
		),
		Glib::ParamSpec->int(
			'invalid_blue','Invalid Blue',
			'Blue component for invalid entry',
			0,65535,INVALID_BLUE,
			['readable']
		),
	];

sub new {
	use Data::Dumper;
	warn Dumper @_;
	my $class = shift;
	my $self = $class->SUPER::new;
	$self->{validator} = shift;
	my $text = shift;
	my $tooltip = new Gtk2::Tooltips;
	$tooltip->set_tip($self,$text,undef) if $text ne '';
	$self->set_text($text || '');
	if($self->{label_in_widget} = $text){
		$self->signal_connect(grab_focus => \&grab_focus);
		$self->modify_base('normal',$self->{invalid_colour});
	}
	bless $self,$class;
}

sub INIT_INSTANCE {
	my $self = shift;
	$self->{valid_colour} = Gtk2::Gdk::Color->new (VALID_RED,VALID_GREEN,VALID_BLUE);
	$self->{invalid_colour} = Gtk2::Gdk::Color->new (INVALID_RED,INVALID_GREEN,INVALID_BLUE);
	$self->modify_base('normal',$self->{invalid_colour});
	
}

sub set_validator {
	my $self = shift;
	$self->{validator} = shift;
}

sub update_validity {
	my $self = shift;
	my $t = $self->get_text;
	if(defined $self->{validator}){
		if(&{$self->{validator}}($self)){
			$self->modify_base('normal',$self->{valid_colour});
		}else {
			$self->modify_base('normal',$self->{invalid_colour});
		}
	} else {
		$self->modify_base('normal',$self->{invalid_colour});
	}	
	$self->signal_chain_from_overridden(@_);
}

sub grab_focus {
	my $self = shift; 
	$self->set_text('') unless $self->{already_focused}; 
	$self->{already_focused} = 1;
}


1;
