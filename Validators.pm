package Validators;

sub is_valid {
	my $widget = pop;
	return 1 if $widget->{valid};
	return 0;
}

sub text_valid {
	my $widget = pop;
	$_ = $widget->get_text;
	return 1 if $_ ne '';
	return 0;
}

sub numeric_valid {
	my $widget = pop;
	$_ = $widget->get_text;
	return 1 if $_ =~ /^(\d)+|^(\d)*\.(\d)+/;
	return 0;
}

sub always_valid {
	return 1;
}
1;
