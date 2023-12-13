package DessList;
use warnings;
use strict;
use Log;
use Data::Dumper;
use Gtk2::SimpleList;
use notebook_tab;
use Popup;
use Dess::EditDess;
use Dess::DessDB;

our @ISA = ('notebook_tab');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'Quality List');
	
	$self->{list} = new Gtk2::SimpleList( 	'id' 		=> 'hidden',
						'Polish NO'	=> 'text',
						'Danish NO'	=> 'text',
						'Type'		=> 'text',
						'Raw Gramma'		=> 'text',
						'Raw Width'		=> 'text',
						'Mach W'	=> 'text',
						'Mach Fin'		=> 'text',
			
						);
	@{$self->{list}->{data}} = @{DessDB->get_quality_list()};
	$self->{list}->signal_connect(row_activated => sub {
		$self->{edit} = new EditQuality($self->{tab},$self->{list}->{data}[$_[1]->to_string][0]);
	});
	$self->{win}->add_with_viewport($self->{list});
	$self->{win}->show_all();
}

