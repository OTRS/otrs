package Crypt::Random::Source::Base;
# ABSTRACT: Abstract base class for L<Crypt::Random::Source> classes

our $VERSION = '0.14';

use Moo;
use namespace::clean;

sub available { 0 }

sub rank { 0 }

sub seed { }

sub get { die "abstract" }

# cannibalized from IO::Scalar
sub read {
    my $self = $_[0];
    my $n    = $_[2];
    my $off  = $_[3] || 0;

    my $read = $self->get($n);
    $n = length($read);
    ($off ? substr($_[1], $off) : $_[1]) = $read;
    return $n;
}

sub get_data {
    my ( $self, %params ) = @_;

    if ( my $n = $params{Length} ) {
        return $self->get($n);
    } else {
        my $size = $params{Size};

        if (ref $size && ref $size eq "Math::Pari") {
            $size = Math::Pari::pari2num($size);
        }

        return $self->get( int($size / 8) + 1 );
    }
}

1;

=pod

=encoding UTF-8

=head1 NAME

Crypt::Random::Source::Base - Abstract base class for L<Crypt::Random::Source> classes

=head1 VERSION

version 0.14

=head1 SYNOPSIS

    use Moo;
    extends qw(Crypt::Random::Source::Base);

=head1 DESCRIPTION

This is an abstract base class.

In the future it will be a role.

=head1 METHODS

=head2 get $n, %args

Gets C<$n> random bytes and returns them as a string.

This method may produce fatal errors if the source was unable to provide enough
data.

=head2 read $buf, $n, [ $off ]

This method is cannibalized from L<IO::Scalar>. It provides an L<IO::Handle>
work-alike.

Note that subclasses override this to operate on a real handle directly if
available.

=head2 seed @stuff

On supporting sources this method will add C<@stuff>, whatever it may be, to
the random seed.

Some sources may not support this, so be careful.

=head2 available

This is a class method, such that when it returns true calling C<new> without
arguments on the class should provide a working source of random data.

This is use by L<Crypt::Random::Source::Factory>.

=head2 rank

This is a class method, with some futz value for a ranking, to help known good
sources be tried before known bad (slower, less available) sources.

=head2 get_data %Params

Provided for compatibility with L<Crypt::Random>

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
