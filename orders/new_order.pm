package new_order;

use warnings;
use strict;
use Data::Dumper;
use Gtk2::SimpleList;
use notebook_tab;
our @ISA = ('notebook_tab');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Order');
	$self->{vbox_main} = new Gtk2::VBox;
	$self->{hbox_small} = new Gtk2::HBox;
	$self->{hbox_buttons} = new Gtk2::HBox;
	$self->{hbox_total} = new Gtk2::HBox;


	$self->{head_frame} = new Gtk2::Frame('Header');
	$self->{pos_frame} = new Gtk2::Frame('Positions');
	$self->{list_frame} = new Gtk2::Frame('List');

	$self->{hbox_total}->pack_start($self->{head_frame},1,1,0);
	$self->{vbox_small} = new Gtk2::VBox;
	$self->{hbox_small}->pack_start($self->{pos_frame},0,1,0);
	$self->{hbox_small}->pack_start($self->{list_frame},1,1,0);
	$self->{vbox_small}->pack_start($self->{hbox_small},1,1,0);

	$self->{expander_head} = Gtk2::Expander->new_with_mnemonic('Header');
        $self->{expander_head}->set_expanded(1);
	$self->{expander_pos} = Gtk2::Expander->new_with_mnemonic('Positions');
        $self->{expander_pos}->set_expanded(1);
	$self->{expander_knit} = Gtk2::Expander->new_with_mnemonic('Knitting Order');
        $self->{expander_knit}->set_expanded(0);
	$self->{expander_dye} = Gtk2::Expander->new_with_mnemonic('Dye Order');
        $self->{expander_dye}->set_expanded(0);

	#$self->{expander_head}->add($self->{hbox_total});
	#$self->{expander_head}->add($self->{hbox_total});

	$self->{vbox_main}->pack_start($self->{expander_head},0,1,0);
	$self->{vbox_main}->pack_start($self->{expander_pos},0,1,0);
	$self->{vbox_main}->pack_start($self->{expander_knit},0,0,0);
	$self->{vbox_main}->pack_start($self->{expander_dye},0,0,0);


	$self->{head_table} = new Gtk2::Table(4,2,0);

	$self->{customer_entry} = new Gtk2::Entry;
	$self->{customer_entry}->set_text('Customer');
	$self->{customer_button} = new Gtk2::Button('...');
	$self->{customer_button}->signal_connect('clicked' => \&widgets::popup_customer_list,$self->{customer_entry});
	$self->{head_table}->attach($self->{customer_entry},0,1,0,1,[],['shrink'],0,0);
	$self->{head_table}->attach($self->{customer_button},1,2,0,1,[],['shrink'],0,0);

	$self->{quality_entry} = new Gtk2::Entry;
	$self->{quality_entry}->set_text('Quality');
	$self->{quality_button} = new Gtk2::Button('...');
	$self->{head_table}->attach($self->{quality_entry},0,1,1,2,[],['shrink'],0,0);
	$self->{head_table}->attach($self->{quality_button},1,2,1,2,[],['shrink'],0,0);

	$self->{scroll_for_order_notes} = new Gtk2::ScrolledWindow;
	$self->{scroll_for_order_notes}->set_policy('automatic','automatic');

	$self->{order_notes} = new Gtk2::TextView;
	$self->{scroll_for_order_notes}->add_with_viewport($self->{order_notes});

	$self->{head_table}->attach($self->{scroll_for_order_notes},2,3,0,2,['fill','expand'],['fill'],4,0);
	$self->{head_frame}->add($self->{head_table});	

	$self->{pos_table} = new Gtk2::Table(12,3,0);

	$self->{delivery_entry} = new Gtk2::Entry;
	$self->{delivery_entry}->set_text('Customer');
	$self->{delivery_button} = new Gtk2::Button('...');
	$self->{pos_table}->attach($self->{delivery_entry},0,1,0,1,[],['shrink'],0,0);
	$self->{pos_table}->attach($self->{delivery_button},1,2,0,1,[],['shrink'],0,0);

	$self->{dyehouse_entry} = new Gtk2::Entry;
	$self->{dyehouse_entry}->set_text('Quality');
	$self->{dyehouse_button} = new Gtk2::Button('...');
	$self->{pos_table}->attach($self->{dyehouse_entry},0,1,1,2,[],['shrink'],0,0);
	$self->{pos_table}->attach($self->{dyehouse_button},1,2,1,2,[],['shrink'],0,0);

	$self->{quantity_kg_entry} = new Gtk2::Entry;
	$self->{quantity_kg_entry}->set_text('Quantity kg');
	$self->{pos_table}->attach($self->{quantity_kg_entry},0,1,2,3,[],['shrink'],0,0);

	$self->{quantity_mtr_entry} = new Gtk2::Entry;
	$self->{quantity_mtr_entry}->set_text('Quantity mtr');
	$self->{pos_table}->attach($self->{quantity_mtr_entry},0,1,3,4,[],['shrink'],0,0);

	$self->{colour_entry} = new Gtk2::Entry;
	$self->{colour_entry}->set_text('Colour');
	$self->{colour_button} = new Gtk2::Button('...');
	$self->{pos_table}->attach($self->{colour_entry},0,1,4,5,[],['shrink'],0,0);
	$self->{pos_table}->attach($self->{colour_button},1,2,4,5,[],['shrink'],0,0);

	$self->{options_entry} = new Gtk2::Entry;
	$self->{options_entry}->set_text('Options');
	$self->{options_button} = new Gtk2::Button('...');
	$self->{pos_table}->attach($self->{options_entry},0,1,5,6,[],['shrink'],0,0);
	$self->{pos_table}->attach($self->{options_button},1,2,5,6,[],['shrink'],0,0);

	$self->{price_entry} = new Gtk2::Entry;
	$self->{price_entry}->set_text('Price');
	$self->{price_button} = new Gtk2::Button('...');
	$self->{pos_table}->attach($self->{price_entry},0,1,6,7,[],['shrink'],0,0);
	$self->{pos_table}->attach($self->{price_button},1,2,6,7,[],['shrink'],0,0);

	$self->{req_date_entry} = new Gtk2::Entry;
	$self->{req_date_entry}->set_text('Requested date');
	$self->{req_date_button} = new Gtk2::Button('...');
	$self->{pos_table}->attach($self->{req_date_entry},0,1,8,9,[],['shrink'],0,0);
	$self->{pos_table}->attach($self->{req_date_button},1,2,8,9,[],['shrink'],0,0);

	$self->{confirm_date_entry} = new Gtk2::Entry;
	$self->{confirm_date_entry}->set_text('Confirmed date');
	$self->{confirm_date_button} = new Gtk2::Button('...');
	$self->{pos_table}->attach($self->{confirm_date_entry},0,1,9,10,[],['shrink'],0,0);
	$self->{pos_table}->attach($self->{confirm_date_button},1,2,9,10,[],['shrink'],0,0);

	$self->{dye_with_date_entry} = new Gtk2::Entry;
	$self->{dye_with_date_entry}->set_text('Dye with');
	$self->{dye_with_date_button} = new Gtk2::Button('...');
	$self->{pos_table}->attach($self->{dye_with_date_entry},0,1,10,11,[],['shrink'],0,0);
	$self->{pos_table}->attach($self->{dye_with_date_button},1,2,10,11,[],['shrink'],0,0);

	$self->{scroll_for_pos_notes} = new Gtk2::ScrolledWindow;
	$self->{scroll_for_pos_notes}->set_policy('automatic','automatic');

	$self->{pos_notes} = new Gtk2::TextView;
	$self->{scroll_for_pos_notes}->add_with_viewport($self->{pos_notes});
	
	$self->{add_button} = new_from_stock Gtk2::Button('gtk-add');
	$self->{rem_button} = new_from_stock Gtk2::Button('gtk-remove');
	$self->{update_button} = new_from_stock Gtk2::Button('gtk-apply');
	$self->{accept_button} = new_from_stock Gtk2::Button('gtk-apply');


	$self->{pos_table}->attach($self->{scroll_for_pos_notes},0,1,11,12,['fill'],['fill'],0,0);

	$self->{hbox_buttons}->add($self->{add_button});
	$self->{hbox_buttons}->add($self->{rem_button});
	$self->{hbox_buttons}->add($self->{accept_button});

	$self->{expander_head}->add($self->{hbox_total});
	$self->{vbox_small}->pack_start($self->{hbox_buttons},0,0,0);
	$self->{expander_pos}->add($self->{vbox_small});

	$self->{pos_frame}->add($self->{pos_table});	

	$self->{vboxpos} = new Gtk2::VBox();

	$self->{scroll_for_list} = new Gtk2::ScrolledWindow;
	$self->{scroll_for_list}->set_policy('automatic','automatic');

        $self->{list} = Gtk2::SimpleList->new (                                                                                                    
                                                'ID' => 'hidden',
                                                'Done ?' => 'bool',
                                                'Kg/Mtr' => 'int',
                                                'Knitted' => 'scalar',
                                                'Invoiced' => 'scalar',
                                                '' => 'text',
                                                'Raw' => 'bool',
                                                'Colour' => 'text',
                                                'Price' => 'scalar',
                                                'Currency' => 'text',
                                                'Requested date' => 'text',
                                                'Confirmed date' => 'text',
                                                'Notes' => 'text',
                                                'Sleeve' => 'bool',
                                                'Enzym' => 'bool',
                                                'ForFix' => 'bool',
                                                '2xDye' => 'bool',
                                                'Bruss' => 'bool',
                                                'XSoft' => 'bool',
                                                'ForPrint' => 'bool',
                                                );

	$self->{scroll_for_list}->add_with_viewport($self->{list});
	$self->{vboxpos}->pack_start($self->{scroll_for_list},1,1,0);

	#$self->{scroll_for_list}->add_with_viewport($self->{vboxpos});

	$self->{list_frame}->add($self->{vboxpos});	

	$self->{win}->add_with_viewport($self->{vbox_main});
	$self->{win}->show_all;
	bless $self,$class;
}
1;

