# Copyright (c) 2002 Graham Barr <gbarr@pobox.com>. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Authen::SASL::Perl::CRAM_MD5;

use strict;
use vars qw($VERSION @ISA);
use Digest::HMAC_MD5 qw(hmac_md5_hex);

$VERSION = "1.00";
@ISA	 = qw(Authen::SASL::Perl);

my %secflags = (
	noplaintext => 1,
	noanonymous => 1,
);

sub _secflags {
  shift;
  scalar grep { $secflags{$_} } @_;
}

sub mechanism { 'CRAM-MD5' }

sub client_start {
  '';
}

sub client_step {
  my ($self, $string) = @_;
  my ($user, $pass) = map {
    my $v = $self->_call($_);
    defined($v) ? $v : ''
  } qw(user pass);

  $user . " " . hmac_md5_hex($string,$pass);
}

1;
