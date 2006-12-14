# Copyright (c) 2002 Graham Barr <gbarr@pobox.com>. All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Authen::SASL::Perl::PLAIN;

use strict;
use vars qw($VERSION @ISA);

$VERSION = "1.04";
@ISA	 = qw(Authen::SASL::Perl);

my %secflags = (
	noanonymous => 1,
);

sub _order { 1 }
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
  } qw(authname user pass);

  join("\0", @parts);
}

1;

__END__

=head1 NAME

Authen::SASL::Perl::PLAIN - Plain Login Authentication class

=head1 SYNOPSIS

  use Authen::SASL qw(Perl);

  $sasl = Authen::SASL->new(
    mechanism => 'PLAIN',
    callback  => {
      user => $user,
      pass => $pass
    },
  );

=head1 DESCRIPTION

This method implements the client part of the PLAIN SASL algorithm,
as described in RFC 2595 resp. IETF Draft draft-ietf-sasl-plain-04.txt
from February 2004.

=head2 CALLBACK

The callbacks used are:

=over 4

=item authname

The authorization id to use after successful authentication

=item user

The username to be used for authentication

=item pass

The user's password to be used for authentication

=back

=head1 SEE ALSO

L<Authen::SASL>,
L<Authen::SASL::Perl>

=head1 AUTHORS

Software written by Graham Barr <gbarr@pobox.com>,
documentation written by Peter Marschall <peter@adpm.de>.

Please report any bugs, or post any suggestions, to the perl-ldap mailing list
<perl-ldap@perl.org>

=head1 COPYRIGHT 

Copyright (c) 2002-2004 Graham Barr.
All rights reserved. This program is free software; you can redistribute 
it and/or modify it under the same terms as Perl itself.

Documentation Copyright (c) 2004 Peter Marschall.
All rights reserved.  This documentation is distributed,
and may be redistributed, under the same terms as Perl itself. 

=cut
