package AssociateList;
use warnings;
use strict;
use Log;
use Data::Dumper;
use Gtk2::SimpleList;
use notebook_tab;
use Popup;
use Associate::EditAssociate;
use Associate::AssociateDB;
our @ISA = ('notebook_tab');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'Associate List');
	
	$self->{list} = new Gtk2::SimpleList( 	'id' 		=> 'hidden',
						'Area'		=> 'text',
						'Company'	=> 'text',
						'Country'	=> 'text',
						'Address'	=> 'text',
						'City'		=> 'text',
						'NIP'		=> 'text',
						'Regon'		=> 'text',);
	@{$self->{list}->{data}} = @{AssociateDB->get_associate_list()};
	$self->{list}->signal_connect(row_activated => sub {
		$self->{edit} = new EditAssociate($self->{tab},$self->{list}->{data}[$_[1]->to_string][0]);
	});
	$self->{win}->add_with_viewport($self->{list});
	$self->{win}->show_all();
}

