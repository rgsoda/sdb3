package Log;
use strict;
use warnings;
use Gtk2;

sub new {
	my $class = shift;
	my $self = {};
 	$self->{expander} = Gtk2::Expander->new_with_mnemonic('Log');
	$self->{expander}->set_expanded(0);
	$self->{textview} = new Gtk2::TextView;
	$self->{textview}->set_editable(0);
	$self->{textview}->set_cursor_visible(0);
	$self->{buffer} = $self->{textview}->get_buffer;
	$self->{scroll} = new Gtk2::ScrolledWindow;
        $self->{scroll}->set_policy('never','automatic');
        $self->{scroll}->add_with_viewport($self->{textview});
	$self->{expander}->add($self->{scroll});
	$self->{height} = $self->{expander}->size_request->height;
	
	bless $self,$class;
}


sub put_log {
	my $self  = shift;
	my $text  = shift;
	$self->{buffer}->insert($self->{buffer}->get_start_iter,$text."\n");
	$self->{expander}->set_label("Log: ".$text);

}
1;

package LogHandler;
use warnings;
use strict;
use Gtk2;

sub TIEHANDLE {
	my $class = shift;
	my $self = {'log'=>shift};
	bless $self,$class;
}

sub null {
	return undef;
}
*WRITE = \&null;
*PRINTF = \&null;
*READ = \&null;
*READLINE = \&null;
*GETC = \&null;
*CLOSE = \&null;
*UNTIE = \&null;
*DESTROY = \&null;

sub PRINT {
	my $self = shift;
	my $text = shift;
	my @time = localtime;
	my $time = sprintf('%02d:%02d.%02d',$time[2],$time[1],$time[0]);
	$self->{'log'}->{buffer}->insert($self->{'log'}->{buffer}->get_start_iter,"$time -> $text\n");
	$self->{'log'}->{expander}->set_label("Log: $time ->  $text");
}


*new=*TIEHANDLE;
1;
