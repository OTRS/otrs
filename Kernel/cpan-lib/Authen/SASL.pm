# Copyright (c) 2002 Graham Barr <gbarr@pobox.com>. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Authen::SASL;

use strict;
use vars qw($VERSION @Plugins);
use Carp;

$VERSION = "2.03";

@Plugins = qw(
	Authen::SASL::Cyrus
	Authen::SASL::Perl
);

sub new {
  my $pkg = shift;
  my %opt = ((@_ % 2 ? 'mechanism' : ()), @_);

  my $self = bless {
    mechanism => $opt{mechanism} || $opt{mech},
    callback  => {},
  }, $pkg;

  $self->callback(%{$opt{callback}}) if ref($opt{callback}) eq 'HASH';

  # Compat
  $self->callback(user => ($self->{user} = $opt{user})) if exists $opt{user};
  $self->callback(pass => $opt{password}) if exists $opt{password};
  $self->callback(pass => $opt{response}) if exists $opt{response};

  $self;
}


sub mechanism {
  my $self = shift;
  @_ ? $self->{mechanism} = shift
     : $self->{mechanism};
}

sub callback {
  my $self = shift;

  return $self->{callback}{$_[0]} if @_ == 1;

  my %new = @_;
  @{$self->{callback}}{keys %new} = values %new;

  $self->{callback};
}

# The list of packages should not really be hardcoded here
# We need some way to discover what plugins are installed

sub client_new { # $self, $service, $host, $secflags
  my $self = shift;

  foreach my $pkg (@Plugins) {
    if (eval "require $pkg") {
      return ($self->{conn} = $pkg->client_new($self, @_));
    }
  }

  croak "Cannot find a SASL Connection library";
}

# Compat.
sub user {
  my $self = shift;
  my $user = $self->{callback}{user};
  $self->{callback}{user} = shift if @_;
  $user;
}

sub challenge {
  my $self = shift;
  $self->{conn}->client_step(@_);
}

sub initial {
  my $self = shift;
  $self->client_new($self)->client_start;
}

sub name {
  my $self = shift;
  $self->{conn} ? $self->{conn}->mechanism : ($self->{mechanism} =~ /(\S+)/)[0];
}

1;
