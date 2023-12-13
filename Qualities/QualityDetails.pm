package QualityDetails;
use warnings;
use strict;
use Data::Dumper;
use Gtk2::SimpleList;
use Qualities::QualityTypeList;
use notebook_tab;
use Qualities::YarnList;
our @ISA = ('notebook_tab');

sub new {
	my $class = shift;
	my $self = $class->SUPER::new(shift,'New Quality');
	$self->{hbox_main} = new Gtk2::HBox;
	$self->{vbox_main} = new Gtk2::VBox;

	$self->{head_table} = new Gtk2::VBox;
	$self->{hbox_buttons} = new Gtk2::HBox;

	$self->{pl_no_entry} = new Gtk2::ValidEntry(\&Validators::text_valid,'Polish No',1);
	$self->{head_table}->pack_start($self->{pl_no_entry},0,0,0);

	$self->{dk_no_entry} = new Gtk2::ValidEntry(\&Validators::text_valid,'Danish No',1);
	$self->{head_table}->pack_start($self->{dk_no_entry},0,0,0);

	$self->{type_entry} = new Gtk2::PopupEntry(\$self->{data_hash}->{quality_type_id},undef,'Quality Type','QualityTypeList');
	$self->{head_table}->pack_start($self->{type_entry},0,0,0);

	$self->{m_br_entry} = new Gtk2::ValidEntry(\&Validators::numeric_valid,'Machine BR',1);
	$self->{head_table}->pack_start($self->{m_br_entry},0,0,0);

	$self->{m_fin_entry} = new Gtk2::ValidEntry(\&Validators::numeric_valid,'Machine Fin',1);
	$self->{head_table}->pack_start($self->{m_fin_entry},0,0,0);

	$self->{gramma_entry} = new Gtk2::ValidEntry(\&Validators::numeric_valid,'Raw Gramma',1);
	$self->{head_table}->pack_start($self->{gramma_entry},0,0,0);

	$self->{width_entry} = new Gtk2::ValidEntry(\&Validators::numeric_valid,'Width Gramma',1);
	$self->{head_table}->pack_start($self->{width_entry},0,0,0);

	$self->{head_table}->pack_start($self->{hbox_buttons},0,0,0);
	$self->{hbox_main}->pack_start($self->{head_table},0,0,0);
	
	$self->{scroll_for_list} = new Gtk2::ScrolledWindow;
	$self->{scroll_for_list}->set_policy('automatic','automatic');

        $self->{list} = Gtk2::SimpleList->new (                                                                                                    
                                                'ID' => 'hidden',
                                                'Yarn Name' => 'text',
                                                ' % ' => 'int',
                                                );

	$self->{scroll_for_list}->add_with_viewport($self->{list});
	$self->{hbuttonbox} = new Gtk2::HBox;
	$self->{yarn_n_entry} = new Gtk2::PopupEntry(\$self->{temp},undef,'Yarn','Qualities::YarnList');
	$self->{yarn_perc_entry} = new Gtk2::ValidEntry(\&Validators::numeric_valid,'Prec %',1);

	$self->{rem_y_button} = new_from_stock Gtk2::Button('gtk-remove');
	$self->{add_y_button} = new_from_stock Gtk2::Button('gtk-add');

	$self->{add_y_button}->signal_connect('clicked' => sub {
		push @{$self->{list}->{data}}, [$self->{temp}, $self->{yarn_n_entry}->{entry}->get_text, $self->{yarn_perc_entry}->get_text];
	});

	$self->{rem_y_button}->signal_connect('clicked' => sub {
	        for (reverse $self->{list}->get_selected_indices){
                	splice @{$self->{list}->{data}}, $_,1;
        	}
	});

	$self->{hbuttonbox}->pack_start($self->{yarn_n_entry},0,0,0);
	$self->{hbuttonbox}->pack_start($self->{yarn_perc_entry},0,0,0);
	$self->{hbuttonbox}->pack_start($self->{add_y_button},0,0,0);
	$self->{hbuttonbox}->pack_start($self->{rem_y_button},0,0,0);

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


	$self->{vbox_small} = new Gtk2::VBox;
	$self->{vbox_small}->pack_start($self->{scroll_for_list},1,1,1);
	$self->{vbox_small}->pack_start($self->{hbuttonbox},0,1,1);

	$self->{hbox_main}->pack_start($self->{vbox_small},0,1,1);
	$self->{vbox_main}->pack_start($self->{hbox_main},0,1,1);
	$self->{win}->add_with_viewport($self->{vbox_main});
	$self->{win}->show_all;

	bless $self,$class;
}
1;

