# Copyright (c) 2002 Graham Barr <gbarr@pobox.com>. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Authen::SASL::Perl::LOGIN;

use strict;
use vars qw($VERSION @ISA);

$VERSION = "1.01";
@ISA	 = qw(Authen::SASL::Perl);

my %secflags = (
	noanonymous => 1,
);

sub _secflags {
  shift;
  scalar grep { $secflags{$_} } @_;
}

sub mechanism { 'LOGIN' }

sub client_start {
  my $self = shift;
  '';
}

sub client_step {
  my ($self, $string) = @_;

  $string =~ /password/i
    ? $self->_call('pass')
    : $string =~ /username/i
      ? $self->_call('user')
      : '';
}

1;

