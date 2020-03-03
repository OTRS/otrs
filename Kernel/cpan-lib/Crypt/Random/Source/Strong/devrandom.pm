package Crypt::Random::Source::Strong::devrandom;
# ABSTRACT: A strong random data source using F</dev/random>

our $VERSION = '0.14';

use Moo;

extends qw(
    Crypt::Random::Source::Strong
    Crypt::Random::Source::Base::RandomDevice
);

use namespace::clean;

sub default_path { "/dev/random" }

1;

=pod

=encoding UTF-8

=head1 NAME

Crypt::Random::Source::Strong::devrandom - A strong random data source using F</dev/random>

=head1 VERSION

version 0.14

=head1 SYNOPSIS

    use Crypt::Random::Source::Strong::devrandom;

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
