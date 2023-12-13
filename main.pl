#!/usr/bin/perl
use main_ui;
use Data::Dumper;
use Gtk2 qw/-init -threads-init/;
use DB::pg;


our $LOG;
our $pg = new DB::pg;

our $gui = main_ui->new();
$gui->{win}->show_all;
Gtk2->main;
