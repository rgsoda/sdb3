package DeliveryPlaceDetails;
use warnings;
use strict;
use Data::Dumper;
use notebook_tab;
use Gtk2::ValidEntry;
use Validators;
use Gtk2::PopupEntry;
use Gtk2;
our @ISA = ('notebook_tab');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,shift);
	
	$self->{data_hash} = { 
		'country'	=> undef,
		'address'	=> undef,
		'city' 		=> undef,
	};
	
	my $hbox = new Gtk2::HBox;
	my $vbox = new Gtk2::VBox;
	my $vbox_main = new Gtk2::VBox;

	$self->{country_entry} = new Gtk2::ValidEntry(\&Validators::text_valid,'Country',1);
	$vbox->pack_start($self->{country_entry},1,1,0);

	$self->{address_entry} = new Gtk2::ValidEntry(\&Validators::text_valid,'Address',1);
	$vbox->pack_start($self->{address_entry},1,1,0);

	$self->{city_entry} = new Gtk2::ValidEntry(\&Validators::text_valid,'City',1);
	$vbox->pack_start($self->{city_entry},1,1,0);

	$self->{buttons} = new Gtk2::HButtonBox;
	
	$vbox->pack_start($self->{buttons},1,1,0);
	
	my $expander = new_with_mnemonic Gtk2::Expander('History');
	$expander->set_expanded(0);
	$vbox_main->pack_end($expander,1,1,0);
	$vbox_main->pack_end(new Gtk2::HSeparator,0,1,0);
	
	my $scroll = new Gtk2::ScrolledWindow;
	$scroll->set_policy('automatic','automatic');
	$expander->add($scroll);

	$self->{history} = new Gtk2::TextView;
	$self->{history}->set_editable(0);
	$self->{history}->set_cursor_visible(0);
	$scroll->add_with_viewport($self->{history});


	$hbox->pack_start($vbox,0,0,5);
	$vbox_main->pack_start($hbox,0,1,0);

	$self->{win}->add_with_viewport($vbox_main);
	$self->{win}->show_all;
	bless $self,$class;
}
1;

