package main_ui;
use warnings;
use strict;
use Gtk2;
use Gtk2::SimpleMenu;
use Data::Dumper;
use orders::new_order;
use labdips::new_labdip;
use tests::new_test;
use Qualities::NewQuality;
use Qualities::QualityList;
use Yarn::NewYarn;
use Yarn::YarnList;
use Associate::NewAssociate;
use Associate::AssociateList;
use Customer::NewCustomer;
use Customer::CustomerList;
use DeliveryPlace::NewDeliveryPlace;
use DeliveryPlace::DeliveryPlaceList;
use Dess::NewDess;
use Dess::DessList;

use DB::pg;

use Log;

our $log;

our $LOG;
sub callback
{
	warn "default";
}

sub destroy
{
	Gtk2->main_quit;
}
sub default_callback
{
	print "Default Callback:\n";
}

sub new_labdip_callback {
	my $tab = shift;
	my $labdip = new new_labdip($tab);
}
sub new_order_callback {
	my $tab = shift;
	my $order = new new_order($tab);
}
sub new_test_callback {
	my $tab = shift;
	my $test = new new_test($tab);
}
sub new_yarn_callback {
	my $tab = shift;
	my $yarn = new NewYarn($tab);
}
sub yarn_list_callback {
	my $tab = shift;
	my $yarn = new YarnList($tab);
}
sub new_quality_callback {
	my $tab = shift;
	my $quality = new NewQuality($tab);
}
sub quality_list_callback {
	my $tab = shift;
	my $quality = new QualityList($tab);
}
sub new_associate_callback {
	my $tab = shift;
	my $associate = new NewAssociate($tab);
}
sub associate_list_callback {
	my $tab = shift;
	my $associate = new AssociateList($tab);
}
sub new_customer_callback {
	my $tab = shift;
	my $customer = new NewCustomer($tab);
}
sub customer_list_callback {
	my $tab = shift;
	my $customer = new CustomerList($tab);
}
sub new_delivery_place_callback {
	my $tab = shift;
	my $delivery_place = new NewDeliveryPlace($tab);
}
sub delivery_place_list_callback {
	my $tab = shift;
	my $delivery_place = new DeliveryPlaceList($tab);
}
sub new_dess_callback {
	my $tab = shift;
	my $dess = new NewDess($tab);
}
sub dess_list_callback {
	my $tab = shift;
	my $dess = new DessList($tab);
}




sub new {
	my $class = shift;
	my $self;
	my $action = 0;
	my $menu_tree = [
		_File  => {
			item_type  => '<Branch>',
				   children => [
			   _Exit      => {
					   callback => \&destroy,
					   callback_action => $action++,
					   accelerator => '<ctrl>Q',
				   },
				   ],
		},
		       _Orders  => {
			       item_type => '<Branch>',
			       children => [
		       _New  => {
					       callback => \&new_order_callback,
					       callback_action => $action++,
					       accelerator => 'F1',

				       },
			       _All  => {
					       callback => \&callback,
					       callback_action => $action++,

				       },
			       _Opened  => {
					       callback => \&callback,
					       callback_action => $action++,
				       },
			       _Closed  => {
					       callback => \&callback,
					       callback_action => $action++,
				       },
			       _Canceled  => {
					       callback => \&callback,
					       callback_action => $action++,
				       },
			       _Define  => {
					       callback => \&callback,
					       callback_action => $action++,
				       },


			       ],
		       },
		       _Tests  => {
			       item_type => '<Branch>',
			       children => [
			       _New  => {
					       callback => \&new_test_callback,
					       callback_action => $action++,
					       accelerator => 'F2',
				       },
			       _All  => {
					       callback => \&callback,
					       callback_action => $action++,
				       },
			       _Define  => {
					       callback => \&callback,
					       callback_action => $action++,
				       },

			       ],
		       },
		       _Colors  => {
			       item_type => '<Branch>',
			       children => [
			       _New  => {
					       callback => \&new_labdip_callback,
					       callback_action => $action++,
					       accelerator => 'F3',
				       },
			       _All  => {
					       callback => \&callback,
					       callback_action => $action++,
				       },

			       ],
		       },
		       _Qualities  => {
			       item_type => '<Branch>',
			       children => [
			       _New  => {
					       callback => \&new_quality_callback,
					       callback_action => $action++,
					       accelerator => 'F4',

				       },
			       _All  => {
					       callback => \&quality_list_callback,
					       callback_action => $action++,
				       },
			       ],
		       },
		       _Dess  => {
			       item_type => '<Branch>',
			       children => [
			       _New  => {
					       callback => \&new_dess_callback,
					       callback_action => $action++,
					       accelerator => 'F5',

				       },
			       _All  => {
					       callback => \&dess_list_callback,
					       callback_action => $action++,
				       },
				],
		       },

		       _Reports  => {
			       item_type => '<Branch>',
			       children => [
			       _All  => {
					       callback => \&callback,
					       callback_action => $action++,
				       },

			       ],
		       },
		       _Yarns  => {
			       item_type => '<Branch>',
			       children => [
			       _New  => {
					       callback => \&new_yarn_callback,
					       callback_action => $action++,
					       accelerator => 'F6',

				       },

			       _All  => {
					       callback => \&yarn_list_callback,
					       callback_action => $action++,
				       },

			       ],
		       },
		       _Associates  => {
			       item_type => '<Branch>',
			       children => [
			       _New  => {
					       callback => \&new_associate_callback,
					       callback_action => $action++,
					       accelerator => 'F7',

				       },

			       _All  => {
					       callback => \&associate_list_callback,
					       callback_action => $action++,
				       },

			       ],
		       },
		       _Customers  => {
			       item_type => '<Branch>',
			       children => [
			       _New  => {
					       callback => \&new_customer_callback,
					       callback_action => $action++,
					       accelerator => 'F7',

				       },

			       _All  => {
					       callback => \&customer_list_callback,
					       callback_action => $action++,
				       },

			       ],
		       },		       
		       _DeliveryPlaces  => {
			       item_type => '<Branch>',
			       children => [
			       _New  => {
					       callback => \&new_delivery_place_callback,
					       callback_action => $action++,
					       accelerator => 'F8',

				       },

			       _All  => {
					       callback => \&delivery_place_list_callback,
					       callback_action => $action++,
				       },

			       ],
		       },


		       _Help  => {
			       item_type => '<Branch>',
			       children => [
				       _Introduction => {
					       callback => \&callback,
					       callback_action => $action++,
				       },
			       _About        => {
				       callback_action => $action++,
			       }
			       ],
		       },
		       ];


	$self->{win} = Gtk2::Window->new;
	$self->{win}->set_default_size(800,600);
	$self->{win}->signal_connect(delete_event => sub { exit });

	$self->{vbox} = Gtk2::VBox->new();	
	$self->{hbox_menu} = Gtk2::HBox->new();
	$self->{hbox_main} = Gtk2::HBox->new();	
	$self->{hbox_log}  = Gtk2::HBox->new();	

	$self->{tab} = Gtk2::Notebook->new();
	$self->{tab}->set_scrollable(1);

	$self->{hbox_main}->add($self->{tab});
	$self->{vbox}->pack_start($self->{hbox_menu},0,0,0);
	$self->{vpaned} = new Gtk2::VPaned;
	$self->{vpaned}->pack1($self->{hbox_main},1,0);
	$self->{vpaned}->pack2($self->{hbox_log},1,0);
	$self->{vbox}->pack_start($self->{vpaned},1,1,1);
	my $menu = Gtk2::SimpleMenu->new(
			menu_tree        => $menu_tree,
			default_callback => \&default_callback,
			user_data        => $self->{tab},
			);
	$self->{win}->add_accel_group($menu->{accel_group});
	$self->{hbox_menu}->add($menu->{widget});
	$log = new Log;  
	tie(*LOG,'LogHandler',$log);
	tie(*STDOUT,'LogHandler',$log);

	
	$main::LOG = \*LOG;
	print "Application started";
	$self->{hbox_log}->add($log->{expander});
	
	$self->{vpaned}->set_position(9999);
	$log->{expander}->signal_connect_after('activate' => 
			sub { 	
				if($log->{expander}->get_expanded){
					$log->{expander}->set_size_request(-1,-1);
				} else {
					$log->{expander}->set_size_request(-1,$log->{height});
				}
				$self->{vpaned}->set_position(9999);
			}
	);
	$self->{win}->add($self->{vbox});
	return $self;
}



1;

