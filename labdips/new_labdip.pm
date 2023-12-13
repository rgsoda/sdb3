package new_labdip;
use warnings;
use strict;
use Data::Dumper;

use notebook_tab;

our @ISA = ('notebook_tab');
sub new {
	warn Dumper\@_;
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Labdip');
	$self->{vbox_main} = new Gtk2::VBox;	
	$self->{main_table} = new Gtk2::Table(9,3,0);

	$self->{order_entry} = new Gtk2::Entry;
	$self->{order_entry}->set_text('Order No');
	$self->{main_table}->attach($self->{order_entry},0,1,1,2,[],['shrink'],0,0);


	$self->{customer_entry} = new Gtk2::Entry;
	$self->{customer_entry}->set_text('Customer');
	$self->{customer_button} = new Gtk2::Button('...');
	$self->{main_table}->attach($self->{customer_entry},0,1,1,2,[],['shrink'],0,0);
	$self->{main_table}->attach($self->{customer_button},1,2,1,2,[],['shrink'],0,0);

	$self->{quality_entry} = new Gtk2::Entry;
	$self->{quality_entry}->set_text('Qyality');
	$self->{quality_button} = new Gtk2::Button('...');
	$self->{main_table}->attach($self->{quality_entry},0,1,2,3,[],['shrink'],0,0);
	$self->{main_table}->attach($self->{quality_button},1,2,2,3,[],['shrink'],0,0);

	$self->{colour_entry} = new Gtk2::Entry;
	$self->{colour_entry}->set_text('Colour');
	$self->{main_table}->attach($self->{colour_entry},0,1,3,4,[],['shrink'],0,0);

	$self->{dyehouse_entry} = new Gtk2::Entry;
	$self->{dyehouse_entry}->set_text('Dyehouse');
	$self->{dyehouse_button} = new Gtk2::Button('...');
	$self->{main_table}->attach($self->{dyehouse_entry},0,1,4,5,[],['shrink'],0,0);
	$self->{main_table}->attach($self->{dyehouse_button},1,2,4,5,[],['shrink'],0,0);

	$self->{cutting_date_entry} = new Gtk2::Entry;
	$self->{cutting_date_entry}->set_text('Cutting send date');
	$self->{cutting_date_button} = new Gtk2::Button('...');
	$self->{main_table}->attach($self->{cutting_date_entry},0,1,5,6,[],['shrink'],0,0);
	$self->{main_table}->attach($self->{cutting_date_button},1,2,5,6,[],['shrink'],0,0);

	$self->{scroll_for_labdip_notes} = new Gtk2::ScrolledWindow;
	$self->{scroll_for_labdip_notes}->set_policy('automatic','automatic');

	$self->{labdip_notes} = new Gtk2::TextView;
	$self->{scroll_for_labdip_notes}->add_with_viewport($self->{labdip_notes});
	$self->{main_table}->attach($self->{scroll_for_labdip_notes},2,3,0,6,['fill','expand'],['fill'],4,0);
	$self->{hbutton_box} = new Gtk2::HButtonBox;
	
	$self->{add_button} = new_from_stock Gtk2::Button('gtk-add');
	$self->{rem_button} = new_from_stock Gtk2::Button('gtk-remove');
	$self->{update_button} = new_from_stock Gtk2::Button('gtk-apply');

	$self->{hbutton_box}->add($self->{add_button});
	$self->{hbutton_box}->add($self->{rem_button});
	$self->{hbutton_box}->add($self->{update_button});

	$self->{main_table}->attach($self->{hbutton_box},0,3,6,7,['shrink'],['fill'],0,0);


	$self->{vbox_main}->add($self->{main_table});
        $self->{win}->add_with_viewport($self->{vbox_main});
	$self->{win}->show_all;
		
	bless $self,$class;

}

1;

