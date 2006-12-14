# Copyright (c) 2006 Simon Wilkinson
# All rights reserved. This program is free software; you can redistribute
# it and/or modify it under the same terms as Perl itself.

package Authen::SASL::Perl::GSSAPI;

use strict;

use vars qw($VERSION @ISA);
use GSSAPI;

$VERSION= "0.02";
@ISA = qw(Authen::SASL::Perl);

my %secflags = (
  noplaintext => 1,
  noanonymous => 1,
);

sub _order { 4 }
sub _secflags {
  shift;
  scalar grep { $secflags{$_} } @_;
}

sub mechanism { 'GSSAPI' }

sub client_start {
  my $self = shift;
  my $status;
  my $principal = $self->service.'@'.$self->host;

  # GSSAPI::Name->import is the *constructor*,
  # storing the new GSSAPI::Name into $target.
  # GSSAPI::Name->import is not the standard
  # import() method as used in Perl normally
  my $target;
  $status = GSSAPI::Name->import($target, $principal, 
				      gss_nt_service_name)
    or return $self->set_error("GSSAPI Error : ".$status);
  $self->{gss_name} = $target;
  $self->{gss_ctx} = new GSSAPI::Context;
  $self->{gss_state} = 0;
  return $self->client_step('');
}

sub client_step
{
  my ($self, $challenge) = @_;

  my $status;

  if ($self->{gss_state} == 0) {
    my $outtok;
    my $flags;
    $status = $self->{gss_ctx}->init(GSS_C_NO_CREDENTIAL, $self->{gss_name}, 
				     gss_mech_krb5, 
				     GSS_C_INTEG_FLAG | GSS_C_MUTUAL_FLAG, 
				     0, GSS_C_NO_CHANNEL_BINDINGS, $challenge, undef, 
				     $outtok, $flags, undef);

    if (GSSAPI::Status::GSS_ERROR($status->major)) {
      return $self->set_error("GSSAPI Error : ".$status);
    }
    if ($status->major == GSS_S_COMPLETE) {
      $self->{gss_state} = 1;
    }
    return $outtok;
  }
  elsif ($self->{gss_state} == 1) {
    # If the server has an empty output token when it COMPLETEs, Cyrus SASL
    # kindly sends us that empty token. We need to ignore it, which introduces
    # another round into the process. 
    return ''  if ($challenge eq '');
 
    my $unwrapped;
    $status = $self->{gss_ctx}->unwrap($challenge, $unwrapped, undef, undef)
      or return $self->set_error("GSSAPI Error : ".$status);

    # XXX - Security layer support will require us to decode this packet
    return $self->set_error("GSSAPI Error : invalid security layer token")
      if (length($unwrapped) != 4);
    # the security layers the server supports: bitmask of
    # 1 = no security layer, 2 = integrity protection, 4 = confidelity protection
    my $layer = ord(substr($unwrapped, 0, 1));

    # Need to set message to be 0x01, 0x00, 0x00, 0x00 for no security layers
    my $message = pack('CCCC', 0x01, 0x00, 0x00, 0x01);
    $message .= $self->_call('user') if ( $self->_call('user') ) ;

    my $outtok;
    $status = $self->{gss_ctx}->wrap(0, 0, $message, undef, $outtok)
      or return $self->set_error("GSSAPI Error : ".$status);
    
    $self->{gss_state} = 0;
    return $outtok;
  }
}

__END__

=head1 NAME

Authen::SASL::Perl::GSSAPI - GSSAPI (Kerberosv5) Authentication class

=head1 SYNOPSIS

  use Authen::SASL qw(Perl);

  $sasl = Authen::SASL->new( mechanism => 'GSSAPI' );

  $sasl->client_start( $service, $host );

=head1 DESCRIPTION

This method implements the client part of the GSSAPI SASL algorithm.

With a valid Kerberos 5 credentials cache (aka TGT) it allows
to connect to I<service>@I<host> given as the first two parameters
to Authen::SASL's client_start() method.

Please note that this module does not currently implement a SASL
security layer following authentication. Unless the connection is
protected by other means, such as TLS, it will be vulnerable to
man-in-the-middle attacks. If security layers are required, then the
Authen::SASL::Cyrus GSSAPI module should be used instead.

=head2 CALLBACK

The callbacks used are:

=over 4

=item user

The username to be used in the response

=back


=head1 SEE ALSO

L<Authen::SASL>,
L<Authen::SASL::Perl>

=head1 AUTHORS

Written by Simon Wilkinson, with patches and extensions by Achim Grolms
and Peter Marschall.

Please report any bugs, or post any suggestions, to the perl-ldap mailing list
<perl-ldap@perl.org>

=head1 COPYRIGHT 

Copyright (c) 2006 Simon Wilkinson, Achim Grolms and Peter Marschall.
All rights reserved. This program is free software; you can redistribute 
it and/or modify it under the same terms as Perl itself.

=cut
