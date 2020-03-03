package Types::Standard::Tied;

use 5.006001;
use strict;
use warnings;

BEGIN {
	$Types::Standard::Tied::AUTHORITY = 'cpan:TOBYINK';
	$Types::Standard::Tied::VERSION   = '1.010000';
}

$Types::Standard::Tied::VERSION =~ tr/_//d;

use Type::Tiny ();
use Types::Standard ();
use Types::TypeTiny ();

sub _croak ($;@) { require Error::TypeTiny; goto \&Error::TypeTiny::croak }

no warnings;

sub __constraint_generator
{
	return Types::Standard->meta->get_type('Tied') unless @_;
	
	my $param = Types::TypeTiny::to_TypeTiny(shift);
	unless (Types::TypeTiny::TypeTiny->check($param))
	{
		Types::TypeTiny::StringLike->check($param)
			or _croak("Parameter to Tied[`a] expected to be a class name; got $param");
		require Type::Tiny::Class;
		$param = "Type::Tiny::Class"->new(class => "$param");
	}
	
	my $check = $param->compiled_check;
	sub {
		$check->(tied(Scalar::Util::reftype($_) eq 'HASH' ?  %{$_} : Scalar::Util::reftype($_) eq 'ARRAY' ?  @{$_} :  Scalar::Util::reftype($_) =~ /^(SCALAR|REF)$/ ?  ${$_} : undef));
	};
}

sub __inline_generator
{
	my $param = Types::TypeTiny::to_TypeTiny(shift);
	unless (Types::TypeTiny::TypeTiny->check($param))
	{
		Types::TypeTiny::StringLike->check($param)
			or _croak("Parameter to Tied[`a] expected to be a class name; got $param");
		require Type::Tiny::Class;
		$param = "Type::Tiny::Class"->new(class => "$param");
	}
	return unless $param->can_be_inlined;
	
	sub {
		require B;
		my $var = $_[1];
		sprintf(
			"%s and do { my \$TIED = tied(Scalar::Util::reftype($var) eq 'HASH' ? \%{$var} : Scalar::Util::reftype($var) eq 'ARRAY' ? \@{$var} : Scalar::Util::reftype($var) =~ /^(SCALAR|REF)\$/ ? \${$var} : undef); %s }",
			Types::Standard::Ref()->inline_check($var),
			$param->inline_check('$TIED')
		);
	}
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Types::Standard::Tied - internals for the Types::Standard Tied type constraint

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

