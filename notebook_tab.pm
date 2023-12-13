package notebook_tab;
use Data::Dumper;
sub new {
	
	my $class = shift;
	my $self = {};
	$self->{tab} = shift;
	my $label = shift;
	
	print $label;
	$self->{win} = Gtk2::ScrolledWindow->new();
	$self->{win}->set_policy('automatic','automatic');
	$self->{hbox} = Gtk2::HBox->new(0);
	$self->{hbox}->set_size_request(-1,-1);
	$self->{label} = Gtk2::Label->new($label);
	$self->{button} = Gtk2::Button->new();
	$self->{button}->set_relief('none');
	$self->{button}->set_size_request(19,19);
	$self->{image} = Gtk2::Image->new_from_stock('gtk-close','menu');
	$self->{button}->add($self->{image});

	$self->{hbox}->add($self->{label});
	$self->{hbox}->add($self->{button});
	my $i = $self->{tab}->append_page_menu($self->{win},$self->{hbox},undef);
	$self->{hbox}->show_all;
	$self->{tab}->show_all;
	$self->{button}->signal_connect( 'clicked' => sub { $self->{tab}->remove_page($self->{tab}->page_num(pop)); },$self->{win});
	$self->{tab}->set_current_page($i);
	bless $self,$class;
}

1;
