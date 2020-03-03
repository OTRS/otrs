package Types::Standard::StrMatch;

use 5.006001;
use strict;
use warnings;

BEGIN {
	$Types::Standard::StrMatch::AUTHORITY = 'cpan:TOBYINK';
	$Types::Standard::StrMatch::VERSION   = '1.010000';
}

$Types::Standard::StrMatch::VERSION =~ tr/_//d;

use Type::Tiny ();
use Types::Standard ();
use Types::TypeTiny ();

sub _croak ($;@) { require Error::TypeTiny; goto \&Error::TypeTiny::croak }

no warnings;

our %expressions;
my $has_regexp_util;
my $serialize_regexp = sub {
	$has_regexp_util = eval {
		require Regexp::Util;
		Regexp::Util->VERSION('0.003');
		1;
	} || 0 unless defined $has_regexp_util;
	
	my $re = shift;
	my $serialized;
	if ($has_regexp_util) {
		$serialized = eval { Regexp::Util::serialize_regexp($re) };
	}
	
	unless (defined $serialized) {
		my $key = sprintf('%s|%s', ref($re), $re);
		$expressions{$key} = $re;
		$serialized = sprintf('$Types::Standard::StrMatch::expressions{%s}', B::perlstring($key));
	}
	
	return $serialized;
};

sub __constraint_generator
{
	return Types::Standard->meta->get_type('StrMatch') unless @_;
	
	my ($regexp, $checker) = @_;
	
	Types::Standard::RegexpRef->check($regexp)
		or _croak("First parameter to StrMatch[`a] expected to be a Regexp; got $regexp");
	
	if (@_ > 1)
	{
		$checker = Types::TypeTiny::to_TypeTiny($checker);
		Types::TypeTiny::TypeTiny->check($checker)
			or _croak("Second parameter to StrMatch[`a] expected to be a type constraint; got $checker")
	}
	
	$checker
		? sub {
			my $value = shift;
			return if ref($value);
			my @m = ($value =~ $regexp);
			$checker->check(\@m);
		}
		: sub {
			my $value = shift;
			!ref($value) and $value =~ $regexp;
		}
	;
}

sub __inline_generator
{
	require B;
	my ($regexp, $checker) = @_;
	my $serialized_re = $regexp->$serialize_regexp or return;
	
	if ($checker)
	{
		return unless $checker->can_be_inlined;
		
		return sub
		{
			my $v = $_[1];
			if ($Type::Tiny::AvoidCallbacks and $serialized_re =~ /Types::Standard::StrMatch::expressions/) {
				require Carp;
				Carp::carp("Cannot serialize regexp without callbacks; serializing using callbacks");
			}
			sprintf
				"!ref($v) and do { my \$m = [$v =~ %s]; %s }",
				$serialized_re,
				$checker->inline_check('$m'),
			;
		};
	}
	else
	{
		my $regexp_string = "$regexp";
		if ($regexp_string =~ /\A\(\?\^u?:\\A(\.+)\)\z/) {
			my $length = length $1;
			return sub { "!ref($_) and length($_)>=$length" };
		}
		
		if ($regexp_string =~ /\A\(\?\^u?:\\A(\.+)\\z\)\z/) {
			my $length = length $1;
			return sub { "!ref($_) and length($_)==$length" };
		}
		
		return sub
		{
			my $v = $_[1];
			if ($Type::Tiny::AvoidCallbacks and $serialized_re =~ /Types::Standard::StrMatch::expressions/) {
				require Carp;
				Carp::carp("Cannot serialize regexp without callbacks; serializing using callbacks");
			}
			"!ref($v) and $v =~ $serialized_re";
		};
	}
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Types::Standard::StrMatch - internals for the Types::Standard StrMatch type constraint

=head1 STATUS

This module is considered part of Type-Tiny's internals. It is not
covered by the
L<Type-Tiny stability policy|Type::Tiny::Manual::Policies/"STABILITY">.

=head1 DESCRIPTION

This file contains some of the guts for L<Types::Standard>.
It will be loaded on demand. You may ignore its presence.

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Types::Standard>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013-2014, 2017-2020 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

