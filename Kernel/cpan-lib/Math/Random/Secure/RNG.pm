package Math::Random::Secure::RNG;
$Math::Random::Secure::RNG::VERSION = '0.080001';
# ABSTRACT: The underlying PRNG, as an object.

use Moo;
use Math::Random::ISAAC;
use Crypt::Random::Source::Factory;
use constant ON_WINDOWS => $^O =~ /Win32/i ? 1 : 0;
use if ON_WINDOWS, 'Crypt::Random::Source::Strong::Win32';

has seeder => (
  is => 'ro',
  lazy => 1,
  builder => '_build_seeder',
);
# Default to a 512-bit key, which should be impossible to break. I wrote
# to the author of ISAAC and he said it's fine to not use a full 256
# integers to seed ISAAC.
has seed_size => (
  is => 'ro',
  # isa => 'Int',
  default => 64,
);

has seed => (
  is => 'rw',
  isa => \&_check_seed,
  lazy => 1,
  builder => '_build_seed',
  clearer => 'clear_seed',
  predicate => 'has_seed',
);

has rng => (
  is => 'ro',
  lazy => 1,
  builder => '_build_rng',
  handles => ['irand', 'rand'],
  clearer => 'clear_rng',
);

has _for_pid => (
  is => 'rw',
  default => sub { $$ },
);

sub _clear_for_pid { shift->_for_pid($$) }

before qw(irand rand) => '_maybe_clear_seed';

sub _maybe_clear_seed {
  my $self = shift;

  if ($self->_for_pid != $$) {
    $self->clear_seed;
    $self->_clear_for_pid;
  }
}


sub BUILD {
  my ($self) = @_;

  if ($self->seed_size < 8) {
    warn "Setting seed_size to less than 8 is not recommended";
  }
}

sub _check_seed {
  my ($seed) = @_;
  if (length($seed) < 8) {
    warn "Your seed is less than 8 bytes (64 bits). It could be"
      . " easy to crack";
  }
  # If it looks like we were seeded with a 32-bit integer, warn the
  # user that they are making a dangerous, easily-crackable mistake.
  # We do this during BUILD so that it happens during srand() in
  # Math::Secure::RNG.
  elsif (length($seed) <= 10 and $seed =~ /^\d+$/) {
    warn "RNG seeded with a 32-bit integer, this is easy to crack";
  }

  # _check_seed is used as a type constraint, so needs to return 1.
  return 1;
}

sub _build_seeder {
  my $factory = Crypt::Random::Source::Factory->new();
  # On Windows, we want to always pick Crypt::Random::Source::Strong::Win32,
  # which this will do.
  if (ON_WINDOWS) {
    return $factory->get_strong;
  }

  my $source = $factory->get;
  # Never allow rand() to be used as a source, it cannot possibly be
  # cryptographically strong with 2^15 or 2^32 bits for its seed.
  if ($source->isa('Crypt::Random::Source::Weak::rand')) {
    $source = $factory->get_strong;
  }
  return $source;
}

sub _build_seed {
  my ($self) = @_;
  return $self->seeder->get($self->seed_size);
}

sub _build_rng {
  my ($self) = @_;
  my @seed_ints = unpack('L*', $self->seed);
  my $rng = Math::Random::ISAAC->new(@seed_ints);
  # One part of having a cryptographically-secure RNG is not being
  # able to see the seed in the internal state of the RNG.
  $self->clear_seed;
  # It's faster to skip the frontend interface of Math::Random::ISAAC
  # and just use the backend directly. However, in case the internal
  # code of Math::Random::ISAAC changes at some point, we do make sure
  # that the {backend} element actually exists first.
  return $rng->{backend} ? $rng->{backend} : $rng;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Math::Random::Secure::RNG - The underlying PRNG, as an object.

=head1 VERSION

version 0.080001

=head1 SYNOPSIS

 use Math::Random::Secure::RNG;
 my $rng = Math::Random::Secure::RNG->new();
 my $int = $rng->irand();

=head1 DESCRIPTION

This represents a random number generator, as an object.

Generally, you shouldn't have to worry about this, and you should just use
L<Math::Random::Secure>. But if for some reason you want to modify how the
random number generator works or you want an object-oriented interface
to a random-number generator, you can use this.

=head1 METHODS

=head2 irand

Generates a random unsigned 32-bit integer.

=head2 rand

Generates a random floating-point number greater than or equal to 0
and less than 1.

=head1 ATTRIBUTES

These are all options that can be passed to C<new()> or called as methods
on an existing object.

=head2 rng

The underlying random number generator. Defaults to an instance of
L<Math::Random::ISAAC>.

=head2 seed

The random data used to seed L</rng>, as a string of bytes. This should
be large enough to properly seed L</rng>. This means I<minimally>, it
should be 8 bytes (64 bits) and more ideally, 32 bytes (256 bits) or 64
bytes (512 bits). For an idea of how large your seed should be, see
L<http://burtleburtle.net/bob/crypto/magnitude.html#brute> for information
on how long it would take to brute-force seeds of each size.

Note that C<seed> should not be an integer, but a B<string of bytes>.

It is very important that the seed be large enough, and also that the seed
be very random. B<There are serious attacks possible against random number
generators that are seeded with non-random data or with insufficient random
data.>

By default, we use a 512-bit (64 byte) seed. If
L<Moore's Law|http://en.wikipedia.org/wiki/Moore's_law> continues to hold
true, it will be approximately 1000 years before computers can brute-force a
512-bit (64 byte) seed at any reasonable speed (and physics suggests that
computers will never actually become that fast, although there could always
be improvements or new methods of computing we can't now imagine, possibly
making Moore's Law continue to hold true forever).

If you pass this to C<new()>, L</seeder> and L</seed_size> will be ignored.

=head2 seeder

An instance of L<Crypt::Random::Source::Base> that will be used to
get the seed for L</rng>.

=head2 seed_size

How much data (in bytes) should be read using L</seeder> to seed L</rng>.
Defaults to 64 bytes (which is 512 bits).

See L</seed> for more info about what is a reasonable seed size.

=head1 SEE ALSO

L<Math::Random::Secure>

=head1 AUTHORS

=over 4

=item *

Max Kanat-Alexander <mkanat@cpan.org>

=item *

Arthur Axel "fREW" Schmidt <math-random-secure@afoolishmanifesto.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2010 by BugzillaSource, Inc.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=cut
