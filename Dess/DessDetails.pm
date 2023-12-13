package DessDetails;
use warnings;
use strict;
use Data::Dumper;
use Gtk2::SimpleList;
use Dess::DessCustomerList;
use Dess::DessQualityList;
use notebook_tab;
use Gtk2::PopupCalendarEntry;
our @ISA = ('notebook_tab');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Dess');
	$self->{hbox_main} = new Gtk2::HBox;
	$self->{vbox_main} = new Gtk2::VBox;

	$self->{head_table} = new Gtk2::VBox;
	$self->{hbox_buttons} = new Gtk2::HBox;

	$self->{customer_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{customer_id},undef,'Customer','DessCustomerList');
	$self->{head_table}->pack_start($self->{customer_entry},0,0,0);

	$self->{quality_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{quality_id},undef,'Quality','DessQualityList');
	$self->{head_table}->pack_start($self->{quality_entry},0,0,0);

	$self->{finish_gramma_entry} = new Gtk2::ValidEntry(\&Validators::numeric_valid,'Finish Gramma',1);
	$self->{head_table}->pack_start($self->{finish_gramma_entry},0,0,0);

	$self->{finish_width_entry} = new Gtk2::ValidEntry(\&Validators::numeric_valid,'Finish Width',1);
	$self->{head_table}->pack_start($self->{finish_width_entry},0,0,0);

	$self->{twice_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{fin_twice},undef,'Type','DessTypeList');
	$self->{head_table}->pack_start($self->{twice_entry},0,0,0);

	$self->{head_table}->pack_start($self->{hbox_buttons},0,0,0);
	$self->{hbox_main}->pack_start($self->{head_table},0,0,0);
	

	$self->{hbuttonbox} = new Gtk2::HBox;

	my $expander = new_with_mnemonic Gtk2::Expander('History');
	$expander->set_expanded(0);
	$self->{vbox_main}->pack_end($expander,1,1,0);
	$self->{vbox_main}->pack_end(new Gtk2::HSeparator,0,1,0);
	
	my $scroll = new Gtk2::ScrolledWindow;
	$scroll->set_policy('automatic','automatic');
	$expander->add($scroll);

	$self->{history} = new Gtk2::TextView;
	$self->{history}->set_editable(0);
	$self->{history}->set_cursor_visible(0);
	$scroll->add_with_viewport($self->{history});

	$self->{vbox_main}->pack_start($self->{hbox_main},0,1,1);
	$self->{win}->add_with_viewport($self->{vbox_main});
	$self->{win}->show_all;

	bless $self,$class;
}
1;

