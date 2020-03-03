package Math::Random::ISAAC::PP;
BEGIN {
  $Math::Random::ISAAC::PP::VERSION = '1.004';
}
# ABSTRACT: Pure Perl port of the ISAAC PRNG algorithm

use strict;
use warnings;
use Carp ();


sub new {
  my ($class, @seed) = @_;

  my $seedsize = scalar(@seed);

  my @mm;
  $#mm = $#seed = 255; # predeclare arrays with 256 slots

  # Zero-fill our seed data
  for ($seedsize .. 255) {
    $seed[$_] = 0;
  }

  my $self = {
    randrsl   => \@seed,
    randcnt   => 0,
    randmem   => \@mm,

    randa     => 0,
    randb     => 0,
    randc     => 0,
  };

  bless($self, $class);

  $self->_randinit();

  return $self;
}


# This package should have an interface similar to the builtin Perl
# random number routines; these are methods, not functions, so they
# are not problematic
## no critic (ProhibitBuiltinHomonyms)

sub rand {
  my ($self) = @_;

  return ($self->irand() / (2**32-1));
}


sub irand {
  my ($self) = @_;

  # Reset the sequence if we run out of random stuff
  if (!$self->{randcnt}--)
  {
    # Call method like this because of our hack above
    _isaac($self);
    $self->{randcnt} = 255;
  }

  return sprintf('%u', $self->{randrsl}->[$self->{randcnt}]);
}

# C-style for loops are used a lot since this is a port of the C version
## no critic (ProhibitCStyleForLoops)

# Numbers are specified in hex, so they don't need separators
## no critic (RequireNumberSeparators)

sub _isaac {
  my ($self) = @_;

  # Use integer math
  use integer;

  my $mm = $self->{randmem};
  my $r = $self->{randrsl};

  # $a and $b are reserved (see 'sort')
  my $aa = $self->{randa};
  my $bb = ($self->{randb} + (++$self->{randc})) & 0xffffffff;

  my ($x, $y); # temporary storage

  # The C code deals with two halves of the randmem separately; we deal with
  # it here in one loop, by adding the &0xff parts. These calls represent the
  # rngstep() macro, but it's inlined here for speed.
  for (my $i = 0; $i < 256; $i += 4)
  {
    $x = $mm->[$i  ];
    $aa = (($aa ^ ($aa << 13)) + $mm->[($i   + 128) & 0xff]);
    $aa &= 0xffffffff; # Mask out high bits for 64-bit systems
    $mm->[$i  ] = $y = ($mm->[($x >> 2) & 0xff] + $aa + $bb) & 0xffffffff;
    $r->[$i  ] = $bb = ($mm->[($y >> 10) & 0xff] + $x) & 0xffffffff;

    # I don't actually know why the "0x03ffffff" stuff is for. It was in
    # John L. Allen's code. If you can explain this please file a bug report.
    $x = $mm->[$i+1];
    $aa = (($aa ^ (0x03ffffff & ($aa >> 6))) + $mm->[($i+1+128) & 0xff]);
    $aa &= 0xffffffff;
    $mm->[$i+1] = $y = ($mm->[($x >> 2) & 0xff] + $aa + $bb) & 0xffffffff;
    $r->[$i+1] = $bb = ($mm->[($y >> 10) & 0xff] + $x) & 0xffffffff;

    $x = $mm->[$i+2];
    $aa = (($aa ^ ($aa << 2)) + $mm->[($i+2 + 128) & 0xff]);
    $aa &= 0xffffffff;
    $mm->[$i+2] = $y = ($mm->[($x >> 2) & 0xff] + $aa + $bb) & 0xffffffff;
    $r->[$i+2] = $bb = ($mm->[($y >> 10) & 0xff] + $x) & 0xffffffff;

    $x = $mm->[$i+3];
    $aa = (($aa ^ (0x0000ffff & ($aa >> 16))) + $mm->[($i+3 + 128) & 0xff]);
    $aa &= 0xffffffff;
    $mm->[$i+3] = $y = ($mm->[($x >> 2) & 0xff] + $aa + $bb) & 0xffffffff;
    $r->[$i+3] = $bb = ($mm->[($y >> 10) & 0xff] + $x) & 0xffffffff;
  }

  $self->{randb} = $bb;
  $self->{randa} = $aa;

  return;
}

sub _randinit
{
  my ($self) = @_;

  use integer;

  # $a and $b are reserved (see 'sort'); $i is the iterator
  my ($c, $d, $e, $f, $g, $h, $j, $k);
  $c=$d=$e=$f=$g=$h=$j=$k = 0x9e3779b9; # The golden ratio

  my $mm = $self->{randmem};
  my $r = $self->{randrsl};

  for (1..4)
  {
    $c ^= $d << 11;
    $f += $c;
    $d += $e;

    $d ^= 0x3fffffff & ($e >> 2);
    $g += $d;
    $e += $f;

    $e ^= $f << 8;
    $h += $e;
    $f += $g;

    $f ^= 0x0000ffff & ($g >> 16);
    $j += $f;
    $g += $h;

    $g ^= $h << 10;
    $k += $g;
    $h += $j;

    $h ^= 0x0fffffff & ($j >> 4);
    $c += $h;
    $j += $k;

    $j ^= $k << 8;
    $d += $j;
    $k += $c;

    $k ^= 0x007fffff & ($c >> 9);
    $e += $k;
    $c += $d;
  }

  for (my $i = 0; $i < 256; $i += 8)
  {
    $c += $r->[$i  ];
    $d += $r->[$i+1];
    $e += $r->[$i+2];
    $f += $r->[$i+3];
    $g += $r->[$i+4];
    $h += $r->[$i+5];
    $j += $r->[$i+6];
    $k += $r->[$i+7];

    $c ^= $d << 11;
    $f += $c;
    $d += $e;

    $d ^= 0x3fffffff & ($e >> 2);
    $g += $d;
    $e += $f;

    $e ^= $f << 8;
    $h += $e;
    $f += $g;

    $f ^= 0x0000ffff & ($g >> 16);
    $j += $f;
    $g += $h;

    $g ^= $h << 10;
    $k += $g;
    $h += $j;

    $h ^= 0x0fffffff & ($j >> 4);
    $c += $h;
    $j += $k;

    $j ^= $k << 8;
    $d += $j;
    $k += $c;

    $k ^= 0x007fffff & ($c >> 9);
    $e += $k;
    $c += $d;

    $mm->[$i  ] = $c;
    $mm->[$i+1] = $d;
    $mm->[$i+2] = $e;
    $mm->[$i+3] = $f;
    $mm->[$i+4] = $g;
    $mm->[$i+5] = $h;
    $mm->[$i+6] = $j;
    $mm->[$i+7] = $k;
  }

  for (my $i = 0; $i < 256; $i += 8)
  {
    $c += $mm->[$i  ];
    $d += $mm->[$i+1];
    $e += $mm->[$i+2];
    $f += $mm->[$i+3];
    $g += $mm->[$i+4];
    $h += $mm->[$i+5];
    $j += $mm->[$i+6];
    $k += $mm->[$i+7];

    $c ^= $d << 11;
    $f += $c;
    $d += $e;

    $d ^= 0x3fffffff & ($e >> 2);
    $g += $d;
    $e += $f;

    $e ^= $f << 8;
    $h += $e;
    $f += $g;

    $f ^= 0x0000ffff & ($g >> 16);
    $j += $f;
    $g += $h;

    $g ^= $h << 10;
    $k += $g;
    $h += $j;

    $h ^= 0x0fffffff & ($j >> 4);
    $c += $h;
    $j += $k;

    $j ^= $k << 8;
    $d += $j;
    $k += $c;

    $k ^= 0x007fffff & ($c >> 9);
    $e += $k;
    $c += $d;

    $mm->[$i  ] = $c;
    $mm->[$i+1] = $d;
    $mm->[$i+2] = $e;
    $mm->[$i+3] = $f;
    $mm->[$i+4] = $g;
    $mm->[$i+5] = $h;
    $mm->[$i+6] = $j;
    $mm->[$i+7] = $k;
  }

  $self->_isaac();
  $self->{randcnt} = 256;

  return;
}


1;

__END__
=pod

=head1 NAME

Math::Random::ISAAC::PP - Pure Perl port of the ISAAC PRNG algorithm

=head1 VERSION

version 1.004

=head1 SYNOPSIS

This module implements the same interface as C<Math::Random::ISAAC> and can be
used as a drop-in replacement. However, it is recommended that you let the
C<Math::Random::ISAAC> module decide whether to use the PurePerl or XS version
of this module, instead of choosing manually.

Selecting the backend to use manually really only has two uses:

=over

=item *

If you are trying to avoid the small overhead incurred with dispatching method
calls to the appropriate backend modules.

=item *

If you are testing the module for performance and wish to explicitly decide
which module you would like to use.

=back

Example code:

  # With Math::Random::ISAAC
  my $rng = Math::Random::ISAAC->new(time);
  my $rand = $rng->rand();

  # With Math::Random::ISAAC::PP
  my $rng = Math::Random::ISAAC::PP->new(time);
  my $rand = $rng->rand();

=head1 DESCRIPTION

See L<Math::Random::ISAAC> for the full description.

=head1 METHODS

=head2 new

  Math::Random::ISAAC::PP->new( @seeds )

Implements the interface as specified in C<Math::Random::ISAAC>

=head2 rand

  $rng->rand()

Implements the interface as specified in C<Math::Random::ISAAC>

=head2 irand

  $rng->irand()

Implements the interface as specified in C<Math::Random::ISAAC>

=head1 SEE ALSO

L<Math::Random::ISAAC>

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website
http://rt.cpan.org/NoAuth/Bugs.html?Dist=Math-Random-ISAAC

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Jonathan Yu <jawnsy@cpan.org>

=head1 COPYRIGHT AND LICENSE

Legally speaking, this package and its contents are:

  Copyright (c) 2011 by Jonathan Yu <jawnsy@cpan.org>.

But this is really just a legal technicality that allows the author to
offer this package under the public domain and also a variety of licensing
options. For all intents and purposes, this is public domain software,
which means you can do whatever you want with it.

The software is provided "AS IS", without warranty of any kind, express or
implied, including but not limited to the warranties of merchantability,
fitness for a particular purpose and noninfringement. In no event shall the
authors or copyright holders be liable for any claim, damages or other
liability, whether in an action of contract, tort or otherwise, arising from,
out of or in connection with the software or the use or other dealings in
the software.

=cut

