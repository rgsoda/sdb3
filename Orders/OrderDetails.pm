package OrderDetails;
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

	$self->{customer_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{customer_id},undef,'Customer','Orders::CustomerList');
	$self->{head_table}->attach($self->{associate_entry},0,1,0,1,[],['shrink'],0,0);

	$self->{dess_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{dess_id},undef,'Dess','Orders::DessList');
	$self->{head_table}->attach($self->{dess_entry},0,1,1,2,[],['shrink'],0,0);

	$self->{scroll_for_order_notes} = new Gtk2::ScrolledWindow;
	$self->{scroll_for_order_notes}->set_policy('automatic','automatic');

	$self->{order_notes} = new Gtk2::TextView;
	$self->{scroll_for_order_notes}->add_with_viewport($self->{order_notes});

	$self->{head_table}->attach($self->{scroll_for_order_notes},2,3,0,2,['fill','expand'],['fill'],4,0);
	$self->{head_frame}->add($self->{head_table});	

	$self->{pos_table} = new Gtk2::Table(14,3,0);

	$self->{delivery_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{delivery_id},undef,'Delivery','Orders::DeliveryList');
	$self->{pos_table}->attach($self->{delivery_entry},0,1,0,1,[],['shrink'],0,0);

	$self->{dyehouse_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{associate_id},undef,'Dyehouse','Orders::DyehouseList');
	$self->{pos_table}->attach($self->{dyehouse_entry},0,1,1,2,[],['shrink'],0,0);

	$self->{quantity_kg_entry} = new Gtk2::ValidEntry(\&Validators::text_valid,'Quantity KG',1);
	$self->{pos_table}->attach($self->{quantity_kg_entry},0,1,2,3,[],['shrink'],0,0);

	$self->{quantity_mtr_entry} = new Gtk2::ValidEntry(\&Validators::text_valid,'Quantity MTR',1);	
	$self->{pos_table}->attach($self->{quantity_mtr_entry},0,1,3,4,[],['shrink'],0,0);

	$self->{colour_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{colour_id},undef,'Colour','Orders::ColourList');
	$self->{pos_table}->attach($self->{colour_entry},0,1,4,5,[],['shrink'],0,0);

	$self->{options_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{option_id},undef,'Options','Orders::OptionList');
	$self->{pos_table}->attach($self->{options_entry},0,1,5,6,[],['shrink'],0,0);

	$self->{price_entry} = new Gtk2::ValidEntry(\&Validators::numeric_valid,'Price',1);
	$self->{pos_table}->attach($self->{price_entry},0,1,6,7,[],['shrink'],0,0);

	$self->{currency_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{currecny_id},undef,'Currency','Orders::CurrencyList');
	$self->{pos_table}->attach($self->{currency_entry},0,1,8,9,[],['shrink'],0,0);

	$self->{requested_date_entry} = new Gtk2::PopupCalendar(\$self->{data_hash}->{requested_date},'Requested Date');
	$self->{pos_table}->attach($self->{req_date_entry},0,1,9,10,[],['shrink'],0,0);

	$self->{confirmed_date_entry} = new Gtk2::PopupCalendar(\$self->{data_hash}->{confirmed_date},'Confirmed Date');	
	$self->{pos_table}->attach($self->{confirmed_date_entry},0,1,10,11,[],['shrink'],0,0);

	$self->{dye_with_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{dye_with_id},undef,'Currency','Orders::DyeWithList');	
	$self->{pos_table}->attach($self->{dye_with_entry},0,1,12,13,[],['shrink'],0,0);

	$self->{scroll_for_pos_notes} = new Gtk2::ScrolledWindow;
	$self->{scroll_for_pos_notes}->set_policy('automatic','automatic');

	$self->{pos_notes} = new Gtk2::TextView;
	$self->{scroll_for_pos_notes}->add_with_viewport($self->{pos_notes});
	
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

