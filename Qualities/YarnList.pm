package Qualities::YarnList;

use strict;
use warnings;
use Gtk2::Popup;
use Gtk2::SimpleList;
use Qualities::QualityDB;

use Glib::Object::Subclass
    Gtk2::Popup::,
	signals => {},
	properties => [];
our @ISA = ('Gtk2::Popup');

sub new {

	my $list = new Gtk2::SimpleList( 	'id' 		=> 'hidden',
						'Yarn Code'	=> 'text',
						'Yarn name'	=> 'text',
						'Yarn type'	=> 'text',
						'Thickness'	=> 'text',
						'Unit'		=> 'text',
						'Twist'		=> 'text',
						'Name'		=> 'text',);
	@{$list->{data}} = @{QualityDB->get_yarn_list()};
	my $class = shift;
	my $self = $class->SUPER::new($list);
	$self->{entry} = shift;
	$self->{val} = shift;
	$list->signal_connect('row_activated' => \&row_activated, $self);
	bless $self, $class;
}
 

sub row_activated {
	my ($sl,$path,$column,$self) = @_;
	my $row_ref = $sl->get_row_data_from_path ($path);
	${$self->{val}} = $self->{widget}->{data}[$_[1]->to_string][0]; 	
	$self->{entry}->{valid} = 1;
	$self->{entry}->set_text($self->{widget}->{data}[$_[1]->to_string][2]);
	$self->close;
}
	
 
1;

