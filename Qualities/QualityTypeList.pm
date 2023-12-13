package QualityTypeList;

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
	my $list =  	Gtk2::SimpleList->new (                       
				'ID'	    => 'hidden',
				'Quality Type' => 'text',
			);
			
	@{$list->{data}} = @{QualityDB->get_quality_type_list()};
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
	$self->{entry}->set_text($self->{widget}->{data}[$_[1]->to_string][1]);
	$self->close;
}
	
 
1;

