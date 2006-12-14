# Copyright (c) 2002 Graham Barr <gbarr@pobox.com>. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Authen::SASL::Perl;

use strict;
use vars qw($VERSION);
use Carp;

$VERSION = "1.05";

my %secflags = (
	noplaintext  => 1,
	noanonymous  => 1,
	nodictionary => 1,
);
my %have;

sub client_new {
  my ($pkg, $parent, $service, $host, $secflags) = @_;

  my @sec = grep { $secflags{$_} } split /\W+/, lc($secflags || '');

  my $self = {
    callback => { %{$parent->callback} },
    service  => $service  || '',
    host     => $host     || '',
  };

  my @mpkg = sort {
    $b->_order <=> $a->_order
  } grep {
    my $have = $have{$_} ||= (eval "require $_;" and $_->can('_secflags')) ? 1 : -1;
    $have > 0 and $_->_secflags(@sec) == @sec
  } map {
    (my $mpkg = __PACKAGE__ . "::$_") =~ s/-/_/g;
    $mpkg;
  } split /[^-\w]+/, $parent->mechanism
    or croak "No SASL mechanism found\n";

  $mpkg[0]->_init($self);
}

sub _order   { 0 }
sub code     { defined(shift->{error}) || 0 }
sub error    { shift->{error}    }
sub service  { shift->{service}  }
sub host     { shift->{host}     }

sub set_error {
  my $self = shift;
  $self->{error} = shift;
  return;
}

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
  my ($self, $name) = splice(@_,0,2);

  my $cb = $self->{callback}{$name};

  return undef unless defined $cb;

  my $value;

  if (ref($cb) eq 'ARRAY') {
    my @args = @$cb;
    $cb = shift @args;
    $value = $cb->($self, @args);
  }
  elsif (ref($cb) eq 'CODE') {
    $value = $cb->($self, @_);
  }
  else {
    $value = $cb;
  }

  $self->{answer}{$name} = $value
    unless $name eq 'pass'; # Do not store password

  return $value;
}

# TODO: Need a better name than this
sub answer {
  my ($self, $name) = @_;
  $self->{answer}{$name};
}

sub _secflags { 0 }

sub securesocket { $_[1] }

1;


