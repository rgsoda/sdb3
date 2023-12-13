package NewOrder;
use warnings;
use strict;
use Data::Dumper;
use Order::OrderDetails;
use Order::OrderDB;
our @ISA = ('OrderDetails');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Order');
	
	$self->{add_button} = new_from_stock Gtk2::Button('gtk-add');
	$self->{hbox_buttons}->add($self->{add_button});
	
        $self->{add_button}->signal_connect('clicked' => sub {
                $self->{data_hash}{order_notes} = $self->{customer_entry}->get_text();


		for (@{$self->{list}->{data}}) {
			push @{$self->{yarn_data_hash}}, { 'yarn_id' => @{$_}[0], 'percentage' => @{$_}[2] };
		}
                QualityDB->add_quality($self->{data_hash},@{$self->{yarn_data_hash}});
                $self->{win}->destroy;

        });
	
	$self->{hbox_buttons}->show_all;
	bless $self,$class;
}
1;

