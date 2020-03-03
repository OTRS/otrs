package Devel::TypeTiny::Perl58Compat;

use 5.006;
use strict;
use warnings;

our $AUTHORITY = 'cpan:TOBYINK';
our $VERSION   = '1.010000';

$VERSION =~ tr/_//d;

#### re doesn't provide is_regexp in Perl < 5.10

eval 'require re';

unless (exists &re::is_regexp)
{
	require B;
	*re::is_regexp = sub {
		eval { B::svref_2object($_[0])->MAGIC->TYPE eq 'r' };
	};
}

#### Done!

5.8;

__END__

=pod

=encoding utf-8

=for stopwords pragmas

=head1 NAME

Devel::TypeTiny::Perl58Compat - shims to allow Type::Tiny to run on Perl 5.8.x

=head1 STATUS

This module is considered part of Type-Tiny's internals. It is not
covered by the
L<Type-Tiny stability policy|Type::Tiny::Manual::Policies/"STABILITY">.

=head1 DESCRIPTION

This is not considered part of Type::Tiny's public API.

Currently this module just has one job: it patches L<re> to provide a
C<is_regexp> function, as this was only added in Perl 5.9.5.

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

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

