package YarnList;
use warnings;
use strict;
use Log;
use Data::Dumper;
use Gtk2::SimpleList;
use notebook_tab;
use Popup;
use Yarn::EditYarn;
use Yarn::YarnDB;
our @ISA = ('notebook_tab');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'Yarn List');
	
	$self->{list} = new Gtk2::SimpleList( 	'id' 		=> 'hidden',
						'Yarn Code'	=> 'text',
						'Yarn name'	=> 'text',
						'Yarn type'	=> 'text',
						'Thickness'	=> 'text',
						'Unit'		=> 'text',
						'Twist'		=> 'text',
						'Name'		=> 'text',);
	@{$self->{list}->{data}} = @{YarnDB->get_yarn_list()};
	$self->{list}->signal_connect(row_activated => sub {
		$self->{edit} = new EditYarn($self->{tab},$self->{list}->{data}[$_[1]->to_string][0]);
	});
	$self->{win}->add_with_viewport($self->{list});
	$self->{win}->show_all();
}

