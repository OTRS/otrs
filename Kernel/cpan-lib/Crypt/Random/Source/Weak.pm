package Crypt::Random::Source::Weak;
# ABSTRACT: Abstract base class for weak random data sources

our $VERSION = '0.14';

use Moo;
use namespace::clean;

sub is_strong { 0 }

1;

=pod

=encoding UTF-8

=head1 NAME

Crypt::Random::Source::Weak - Abstract base class for weak random data sources

=head1 VERSION

version 0.14

=head1 SYNOPSIS

    use Moo;
    extends qw(Crypt::Random::Source::Weak);

=head1 DESCRIPTION

This is an abstract base class. There isn't much to describe.

=head1 METHODS

=head2 is_strong

Returns false

=head1 SUPPORT

Bugs may be submitted through L<the RT bug tracker|https://rt.cpan.org/Public/Dist/Display.html?Name=Crypt-Random-Source>
(or L<bug-Crypt-Random-Source@rt.cpan.org|mailto:bug-Crypt-Random-Source@rt.cpan.org>).

=head1 AUTHOR

יובל קוג'מן (Yuval Kogman) <nothingmuch@woobling.org>

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2008 by Yuval Kogman.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__END__


# ex: set sw=4 et:
