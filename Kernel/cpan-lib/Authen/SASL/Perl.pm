# Copyright (c) 2002 Graham Barr <gbarr@pobox.com>. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Authen::SASL::Perl;

use strict;
use vars qw($VERSION);
use Carp;

$VERSION = "1.01";

my %secflags = (
	noplaintext  => 1,
	noanonymous  => 1,
	nodictionary => 1,
);

sub client_new {
  my ($pkg, $parent, $service, $host, $secflags) = @_;

  my @sec = grep { $secflags{$_} } split /\W+/, lc($secflags || '');

  my $self = {
    callback => { %{$parent->callback} },
    service  => $service  || '',
    host     => $host     || '',
  };

  # Dumb selection;

  my @mpkg = grep {
    eval "require $_;" && $_->_secflags(@sec) == @sec
  } map {
    (my $mpkg = __PACKAGE__ . "::$_") =~ s/-/_/g;
    $mpkg;
  } split /[^-\w]+/, $parent->mechanism
    or croak "No SASL mechanism found\n";

  $mpkg[0]->_init($self);
}

sub code  { 0  }
sub error { '' }

sub service  { shift->{service}  }
sub host     { shift->{host}     }

# set/get property
sub property {
  my $self = shift;
  my $prop = $self->{property} ||= {};
  return $prop->{ $_[0] } if @_ == 1;
  my %new = @_;
  @{$prop}{keys %new} = values %new;
  1;
}

sub callback {
  my $self = shift;

  return $self->{callback}{$_[0]} if @_ == 1;

  my %new = @_;
  @{$self->{callback}}{keys %new} = values %new;

  $self->{callback};
}

# Should be defined in the mechanism sub-class
sub mechanism    { undef }
sub client_step  { undef }
sub client_start { undef }

# Private methods used by Authen::SASL::Perl that
# may be overridden in mechanism sub-calsses

sub _init {
  my ($pkg, $href) = @_;

  bless $href, $pkg;
}

sub _call {
  my ($self, $name) = @_;

  my $cb = $self->{callback}{$name};

  if (ref($cb) eq 'ARRAY') {
    my @args = @$cb;
    $cb = shift @args;
    return $cb->($self, @args);
  }
  elsif (ref($cb) eq 'CODE') {
    return $cb->($self);
  }

  return $cb;
}

sub _secflags { 0 }

sub securesocket { $_[1] }

1;


