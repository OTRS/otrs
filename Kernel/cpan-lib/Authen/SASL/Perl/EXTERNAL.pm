# Copyright (c) 1998-2002 Graham Barr <gbarr@pobox.com> and 2001 Chris Ridd
# <chris.ridd@messagingdirect.com>.  All rights reserved.  This program
# is free software; you can redistribute it and/or modify it under the
# same terms as Perl itself.

package Authen::SASL::Perl::EXTERNAL;

use strict;
use vars qw($VERSION @ISA);

$VERSION = "1.00";
@ISA	 = qw(Authen::SASL::Perl);

my %secflags = (
	noplaintext  => 1,
	nodictionary => 1,
);

sub _secflags {
  shift;
  grep { $secflags{$_} } @_;
}

sub mechanism { 'EXTERNAL' }

sub client_start {
  ''
}

sub client_step {
  shift->_call('user');
}

1;

