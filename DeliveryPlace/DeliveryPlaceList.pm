package DeliveryPlaceList;
use warnings;
use strict;
use Log;
use Data::Dumper;
use Gtk2::SimpleList;
use notebook_tab;
use Popup;
use DeliveryPlace::EditDeliveryPlace;
use DeliveryPlace::DeliveryPlaceDB;

our @ISA = ('notebook_tab');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'Delivery Place List');
	
	$self->{list} = new Gtk2::SimpleList( 	'id' 		=> 'hidden',
						'Country'	=> 'text',
						'Address'	=> 'text',
						'City'		=> 'text',
						,);
	@{$self->{list}->{data}} = @{DeliveryPlaceDB->get_delivery_place_list()};
	$self->{list}->signal_connect(row_activated => sub {
		$self->{edit} = new EditDeliveryPlace($self->{tab},$self->{list}->{data}[$_[1]->to_string][0]);
	});
	$self->{win}->add_with_viewport($self->{list});
	$self->{win}->show_all();
}

