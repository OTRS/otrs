# Copyright (c) 2002 Graham Barr <gbarr@pobox.com>. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Authen::SASL::Perl::PLAIN;

use strict;
use vars qw($VERSION @ISA);

$VERSION = "1.00";
@ISA	 = qw(Authen::SASL::Perl);

my %secflags = (
	noanonymous => 1,
);

sub _secflags {
  shift;
  grep { $secflags{$_} } @_;
}

sub mechanism { 'PLAIN' }

sub client_start {
  my $self = shift;

  my @parts = map {
    my $v = $self->_call($_);
    defined($v) ? $v : ''
  } qw(user authname pass);

  join("\0", @parts);
}

1;
