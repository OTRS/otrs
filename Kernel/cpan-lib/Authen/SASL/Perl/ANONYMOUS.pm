# Copyright (c) 2002 Graham Barr <gbarr@pobox.com>. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Authen::SASL::Perl::ANONYMOUS;

use strict;
use vars qw($VERSION @ISA);

$VERSION = "1.00";
@ISA	 = qw(Authen::SASL::Perl);

my %secflags = (
	noplaintext => 1,
);

sub _secflags {
  shift;
  grep { $secflags{$_} } @_;
}

sub mechanism { 'ANONYMOUS' }

sub client_start {
  shift->_call('authname')
}

sub client_step {
  shift->_call('authname')
}

1;
