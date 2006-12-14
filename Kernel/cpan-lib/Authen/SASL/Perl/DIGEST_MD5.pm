# Copyright (c) 2003-2005 Graham Barr, Djamel Boudjerda, Paul Connolly, Julian Onions and Nexor.
# All rights reserved. This program is free software; you can redistribute 
# it and/or modify it under the same terms as Perl itself.

# See http://www.ietf.org/rfc/rfc2831.txt for details

package Authen::SASL::Perl::DIGEST_MD5;

use strict;
use vars qw($VERSION @ISA $CNONCE);
use Digest::MD5 qw(md5_hex md5);

$VERSION = "1.05";
@ISA = qw(Authen::SASL::Perl);

my %secflags = (
  noplaintext => 1,
  noanonymous => 1,
);

# some have to be quoted - some don't - sigh!
my %qdval; @qdval{qw(username authzid realm nonce cnonce digest-uri)} = ();

my %multi; @multi{qw(realm auth-param)} = ();
my @required = qw(algorithm nonce);

sub _order { 3 }
sub _secflags {
  shift;
  scalar grep { $secflags{$_} } @_;
}

sub mechanism { 'DIGEST-MD5' }

# no initial value passed to the server
sub client_start {
  '';
}

sub client_step    # $self, $server_sasl_credentials
{
  my ($self, $challenge) = @_;
  $self->{server_params} = \my %sparams;

  # Parse response parameters
  while($challenge =~ s/^(?:\s*,)?\s*(\w+)=("([^\\"]+|\\.)*"|[^,]+)\s*//) {
    my ($k, $v) = ($1,$2);
    if ($v =~ /^"(.*)"$/s) {
      ($v = $1) =~ s/\\(.)/$1/g;
    }
    if (exists $multi{$k}) {
      my $aref = $sparams{$k} ||= [];
      push @$aref, $v;
    }
    elsif (defined $sparams{$k}) {
      return $self->set_error("Bad challenge: '$challenge'");
    }
    else {
      $sparams{$k} = $v;
    }
  }

  return $self->set_error("Bad challenge: '$challenge'")
    if length $challenge;

  # qop in server challenge is optional: if not there "auth" is assumed
  return $self->set_error("Server does not support auth (qop = $sparams{'qop'})")
    if ($sparams{qop} && ! grep { /^auth$/ } split(/,/, $sparams{'qop'}));

  # check required fields in server challenge
  if (my @missing = grep { !exists $sparams{$_} } @required) {
    return $self->set_error("Server did not provide required field(s): @missing")
  }

  my %response = (
    nonce        => $sparams{'nonce'},
    cnonce       => md5_hex($CNONCE || join (":", $$, time, rand)),
    'digest-uri' => $self->service . '/' . $self->host,
    qop          => 'auth',		# we currently support 'auth' only
    # calc how often the server nonce has been seen; server expects "00000001"
    nc           => sprintf("%08d",     ++$self->{nonce}{$sparams{'nonce'}}),
    charset      => $sparams{'charset'},
  );

  # let caller-provided fields override defaults: authorization ID, service name, realm

  my $s_realm = $sparams{realm} || [];
  my $realm = $self->_call('realm', @$s_realm);
  unless (defined $realm) {
    # If the user does not pick a realm, use the first from the server
    $realm = $s_realm->[0];
  }
  if (defined $realm) {
    $response{realm} = $realm;
  }

  my $authzid = $self->_call('authname');
  if (defined $authzid) {
    $response{authzid} = $authzid;
  }

  my $serv_name = $self->_call('serv');
  if (defined $serv_name) {
    $response{'digest-uri'} .= '/' . $serv_name;
  }

  my $user = $self->_call('user');
  return $self->set_error("Username is required")
    unless defined $user;
  $response{username} = $user;

  my $password = $self->_call('pass');
  return $self->set_error("Password is required")
    unless defined $password;

  # Generate the response value

  $realm = "" unless defined $realm;
  my $A1 = join (":", 
    md5(join (":", $user, $realm, $password)),
    @response{defined($authzid) ? qw(nonce cnonce authzid) : qw(nonce cnonce)}
  );

  my $A2 = "AUTHENTICATE:" . $response{'digest-uri'};

  $A2 .= ":00000000000000000000000000000000"
    if $response{'qop'} and $response{'qop'} =~ /^auth-(conf|int)$/;

  $response{'response'} = md5_hex(
    join (":", md5_hex($A1), @response{qw(nonce nc cnonce qop)}, md5_hex($A2))
  );

  join (",", map { _qdval($_, $response{$_}) } sort keys %response);
}

sub _qdval {
  my ($k, $v) = @_;

  if (!defined $v) {
    return;
  }
  elsif (exists $qdval{$k}) {
    $v =~ s/([\\"])/\\$1/g;
    return qq{$k="$v"};
  }

  return "$k=$v";
}

1;

__END__

=head1 NAME

Authen::SASL::Perl::DIGEST_MD5 - Digest MD5 Authentication class

=head1 SYNOPSIS

  use Authen::SASL qw(Perl);

  $sasl = Authen::SASL->new(
    mechanism => 'DIGEST-MD5',
    callback  => {
      user => $user, 
      pass => $pass,
      serv => $serv
    },
  );

=head1 DESCRIPTION

This method implements the client part of the DIGEST-MD5 SASL algorithm,
as described in RFC-2831.

This module only implements the I<auth> operation which offers authentication
but neither integrity protection not encryption.

=head2 CALLBACK

The callbacks used are:

=over 4

=item authname

The authorization id to use after successful authentication

=item user

The username to be used in the response

=item pass

The password to be used in the response

=item serv

The service name when authenticating to a replicated service

=item realm

The authentication realm when overriding the server-provided default.
If not given the server-provided value is used.

The callback will be passed the list of realms that the server provided
in the initial response.

=back

=head1 SEE ALSO

L<Authen::SASL>,
L<Authen::SASL::Perl>

=head1 AUTHORS

Graham Barr, Djamel Boudjerda (NEXOR), Paul Connolly, Julian Onions (NEXOR)

Please report any bugs, or post any suggestions, to the perl-ldap mailing list
<perl-ldap@perl.org>

=head1 COPYRIGHT 

Copyright (c) 2003-2005 Graham Barr, Djamel Boudjerda, Paul Connolly,
Julian Onions, Nexor and Peter Marschall.
All rights reserved. This program is free software; you can redistribute 
it and/or modify it under the same terms as Perl itself.

=cut
