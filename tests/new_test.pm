package new_test;
use warnings;
use strict;
use Data::Dumper;
use Gtk2::SimpleList;
use notebook_tab;
our @ISA = ('notebook_tab');

sub new {
	warn Dumper\@_;
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Test');
	$self->{vbox_main} = new Gtk2::VBox;
	$self->{hbox_main} = new Gtk2::HBox;


	$self->{head_table} = new Gtk2::Table(6,2,0);

	$self->{batch_no_entry} = new Gtk2::Entry;
	$self->{batch_no_entry}->set_text('Batch Card');
	$self->{head_table}->attach($self->{batch_no_entry},0,1,0,1,[],['shrink'],0,0);

	$self->{width_entry} = new Gtk2::Entry;
	$self->{width_entry}->set_text('Width');
	$self->{head_table}->attach($self->{width_entry},0,1,1,2,[],['shrink'],0,0);

	$self->{gramma_entry} = new Gtk2::Entry;
	$self->{gramma_entry}->set_text('Gramma');
	$self->{head_table}->attach($self->{gramma_entry},0,1,2,3,[],['shrink'],0,0);

	$self->{s_width_entry} = new Gtk2::Entry;
	$self->{s_width_entry}->set_text('Shrinkage W');
	$self->{head_table}->attach($self->{s_width_entry},0,1,3,4,[],['shrink'],0,0);

	$self->{s_lenght_entry} = new Gtk2::Entry;
	$self->{s_lenght_entry}->set_text('Shrinkage L');
	$self->{head_table}->attach($self->{s_lenght_entry},0,1,4,5,[],['shrink'],0,0);

	$self->{laundry_entry} = new Gtk2::Entry;
	$self->{laundry_entry}->set_text('Laundry Method');
	$self->{laundry_button} = new Gtk2::Button('...');
	$self->{head_table}->attach($self->{laundry_entry},0,1,5,6,[],['shrink'],0,0);
	$self->{head_table}->attach($self->{laundry_button},1,2,5,6,[],['shrink'],0,0);

	$self->{dry_entry} = new Gtk2::Entry;
	$self->{dry_entry}->set_text('Laundry Method');
	$self->{dry_button} = new Gtk2::Button('...');
	$self->{head_table}->attach($self->{dry_entry},0,1,6,7,[],['shrink'],0,0);
	$self->{head_table}->attach($self->{dry_button},1,2,6,7,[],['shrink'],0,0);

	
	$self->{pos_table} = new Gtk2::Table(12,3,0);

	$self->{acetate_entry} = new Gtk2::Entry;
	$self->{acetate_entry}->set_text('Acetate');
	$self->{pos_table}->attach($self->{acetate_entry},0,1,0,1,[],['shrink'],0,0);

	$self->{cotton_entry} = new Gtk2::Entry;
	$self->{cotton_entry}->set_text('Cotton');
	$self->{pos_table}->attach($self->{cotton_entry},0,1,1,2,[],['shrink'],0,0);

	$self->{polyamide_entry} = new Gtk2::Entry;
	$self->{polyamide_entry}->set_text('Polyamide');
	$self->{pos_table}->attach($self->{polyamide_entry},0,1,2,3,[],['shrink'],0,0);

	$self->{polyester_entry} = new Gtk2::Entry;
	$self->{polyester_entry}->set_text('Polyester');
	$self->{pos_table}->attach($self->{polyester_entry},0,1,3,4,[],['shrink'],0,0);

	$self->{acryl_entry} = new Gtk2::Entry;
	$self->{acryl_entry}->set_text('Acryl');
	$self->{pos_table}->attach($self->{acryl_entry},0,1,4,5,[],['shrink'],0,0);

	$self->{wool_entry} = new Gtk2::Entry;
	$self->{wool_entry}->set_text('Wool');
	$self->{pos_table}->attach($self->{wool_entry},0,1,5,6,[],['shrink'],0,0);

	$self->{wet_entry} = new Gtk2::Entry;
	$self->{wet_entry}->set_text('Wet');
	$self->{pos_table}->attach($self->{wet_entry},0,1,6,7,[],['shrink'],0,0);

	$self->{dry_entry} = new Gtk2::Entry;
	$self->{dry_entry}->set_text('Dry');
	$self->{pos_table}->attach($self->{dry_entry},0,1,7,8,[],['shrink'],0,0);

	$self->{grade_entry} = new Gtk2::Entry;
	$self->{grade_entry}->set_text('Grade');
	$self->{pos_table}->attach($self->{grade_entry},0,1,8,9,[],['shrink'],0,0);

	$self->{add_button} = new_from_stock Gtk2::Button('gtk-add');
	$self->{rem_button} = new_from_stock Gtk2::Button('gtk-remove');
	$self->{update_button} = new_from_stock Gtk2::Button('gtk-apply');

	$self->{hbox_buttons} = new Gtk2::HBox;
	$self->{hbox_buttons}->add($self->{add_button});
	$self->{hbox_buttons}->add($self->{update_button});
	$self->{hbox_buttons}->add($self->{rem_button});

	$self->{head_table}->attach($self->{hbox_buttons},0,1,7,8,[],['shrink'],0,0);

	$self->{hbox_main}->pack_start($self->{head_table},0,0,0);
	$self->{hbox_main}->pack_start($self->{pos_table},0,0,0);

	$self->{vbox_main}->pack_start($self->{hbox_main},0,1,0);

	$self->{win}->add_with_viewport($self->{vbox_main});
	$self->{win}->show_all;
	bless $self,$class;
}
1;

