package Yarn::YarnCodeList;

use strict;
use warnings;
use Gtk2::Popup;
use Gtk2::SimpleList;
use Yarn::YarnDB;

use Glib::Object::Subclass
    Gtk2::Popup::,
	signals => {},
	properties => [];
our @ISA = ('Gtk2::Popup');

sub new {
	my $list =  	Gtk2::SimpleList->new (                       
				'ID'	    => 'hidden',
				'Yarn Code' => 'text',
				'Yarn Name' => 'text',
			);
	@{$list->{data}} = @{YarnDB->get_yarn_code_list()};
	my $class = shift;
	my $self = $class->SUPER::new($list);
	$self->{entry} = shift;
	$self->{val} = shift;
	my $id = shift;
	
	for(0 .. $#{$list->{data}}){
		if($list->{data}[$_][0] eq $id){
			$list->select($_);
		}
	}

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

