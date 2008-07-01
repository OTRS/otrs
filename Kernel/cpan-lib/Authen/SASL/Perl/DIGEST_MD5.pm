# Copyright (c) 2003-2005 Graham Barr, Djamel Boudjerda, Paul Connolly, Julian Onions and Nexor.
# All rights reserved. This program is free software; you can redistribute 
# it and/or modify it under the same terms as Perl itself.

# See http://www.ietf.org/rfc/rfc2831.txt for details

package Authen::SASL::Perl::DIGEST_MD5;

use strict;
use vars qw($VERSION @ISA $CNONCE);
use Digest::MD5 qw(md5_hex md5);
use Digest::HMAC_MD5 qw(hmac_md5);

$VERSION = "1.06";
@ISA = qw(Authen::SASL::Perl);

my %secflags = (
  noplaintext => 1,
  noanonymous => 1,
);

# some have to be quoted - some don't - sigh!
my %qdval; @qdval{qw(username authzid realm nonce cnonce digest-uri)} = ();

my %multi; @multi{qw(realm auth-param)} = ();
my @required = qw(algorithm nonce);

# we use indices to deal with layer calculations internally
my @layertypes = (undef, 'auth', 'auth-int', 'auth-conf');

sub _order { 3 }
sub _secflags {
  shift;
  scalar grep { $secflags{$_} } @_;
}

sub mechanism { 'DIGEST-MD5' }

sub _init {
  my ($pkg, $self) = @_;
  bless $self, $pkg;

  # set default security properties
  $self->property('minssf',      0);
  $self->property('maxssf',      int 2**31 - 1);    # XXX - arbitrary "high" value
  $self->property('maxbuf',      0xFFFFFF);         # maximum supported by GSSAPI mech
  $self->property('externalssf', 0);
  $self;
}

# no initial value passed to the server
sub client_start {
  my $self = shift;

  $self->{state}     = 0;
  $self->{layer}     = undef;
  $self->{sndseqnum} = 0;
  $self->{rcvseqnum} = 0;

  # reset properties for new session
  $self->property(maxout => undef);
  $self->property(ssf    => undef);
  '';
}

sub client_step {   # $self, $server_sasl_credentials
  my ($self, $challenge) = @_;
  $self->{server_params} = \my %sparams;

  # Parse response parameters
  while($challenge =~ s/^(?:\s*,)*\s*(\w+)=("([^\\"]+|\\.)*"|[^,]+)\s*(?:,\s*)*//) {
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

  if ($self->{state} == 1) {

    # check server's `rspauth' response
    return $self->set_error("Server did not send rspauth in step 2")
      unless ($sparams{rspauth});
    return $self->set_error("Invalid rspauth in step 2")
      unless ($self->{rspauth} eq $sparams{rspauth});

    # all is well
    return '';
  }

  # check required fields in server challenge
  if (my @missing = grep { !exists $sparams{$_} } @required) {
    return $self->set_error("Server did not provide required field(s): @missing")
  }

  my %response = (
    nonce        => $sparams{'nonce'},
    cnonce       => md5_hex($CNONCE || join (":", $$, time, rand)),
    'digest-uri' => $self->service . '/' . $self->host,
    # calc how often the server nonce has been seen; server expects "00000001"
    nc           => sprintf("%08d",     ++$self->{nonce}{$sparams{'nonce'}}),
    charset      => $sparams{'charset'},
  );

  # calculate qop
  return $self->set_error("Server qop too weak (qop = $sparams{'qop'})")
    unless ($self->{layer} = $self->_layer($sparams{qop}));

  $response{qop} = $layertypes[$self->{layer}];

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

  $self->property('maxout',$sparams{server_maxbuf} || 65536);
  $self->property('ssf',$self->{layer}-1) if ($self->{layer});

  # Generate the response value
  $self->{state} = 1;

  $realm = "" unless defined $realm;
  my $A1 = join (":", 
    md5(join (":", $user, $realm, $password)),
    @response{defined($authzid) ? qw(nonce cnonce authzid) : qw(nonce cnonce)}
  );

  # pre-compute MD5(A1) and HEX(MD5(A1)); these are used multiple times below
  my $hdA1 = unpack("H*",(my $dA1 = md5($A1)));

  # derive keys for layer encryption / integrity
  $self->{kic} = md5($dA1,
	'Digest session key to client-to-server signing key magic constant');

  $self->{kis} = md5($dA1,
	'Digest session key to server-to-client signing key magic constant');

# no encryption support yet
#  $self->{kcc} = md5($dA1,
#	'Digest H(A1) key to client-to-server signing key magic constant');
#
#  $self->{kcs} = md5($dA1,
#	'Digest H(A1) key to server-to-client signing key magic constant');

  my $A2 = "AUTHENTICATE:" . $response{'digest-uri'};
  $A2 .= ":00000000000000000000000000000000" if ($self->{layer} > 1);

  $response{'response'} = md5_hex(
    join (":", $hdA1, @response{qw(nonce nc cnonce qop)}, md5_hex($A2))
  );

  # calculate server `rspauth' response, so we can check in step 2
  # the only difference here is in the A2 string which from which
  # `AUTHENTICATE' is omitted in the calculation of `rspauth'
  $A2 = ":" . $response{'digest-uri'};
  $A2 .= ":00000000000000000000000000000000" if ($self->{layer} > 1);

  $self->{rspauth} = md5_hex(
    join (":", $hdA1, @response{qw(nonce nc cnonce qop)}, md5_hex($A2))
  );

  # finally, return our response token
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

sub _layer {
  my ($self, $sqop) = @_;

  # construct server qop mask
  # qop in server challenge is optional: if not there "auth" is assumed
  my $smask = 0;
  map {
    m/^auth$/      and $smask |= 1;
    m/^auth-int$/  and $smask |= 2;
    m/^auth-conf$/ and $smask |= 4;
  } split(/,/, $sqop || 'auth');

  # construct our qop mask
  my $cmask  = 0;
  my $maxssf = $self->property('maxssf') - $self->property('externalssf');
  $maxssf = 0 if ($maxssf < 0);
  my $minssf = $self->property('minssf') - $self->property('externalssf');
  $minssf = 0 if ($minssf < 0);

  return undef if ($maxssf < $minssf);    # sanity check

  # ssf values > 1 mean integrity and confidentiality
  # ssf == 1 means integrity but no confidentiality
  # ssf < 1 means neither integrity nor confidentiality
  # no security layer can be had if buffer size is 0
  $cmask |= 1 if ($minssf < 1);
  $cmask |= 2 if ($minssf <= 1 and $maxssf >= 1);

# no encryption support yet
#	$cmask |= 4 if ($maxssf > 1);


  # find common bits
  $cmask &= $smask;

  return 4 if ($cmask & 4);
  return 2 if ($cmask & 2);
  return 1 if ($cmask & 1);

  return undef;
}


sub encode {  # input: self, plaintext buffer,length (length not used here)
  my $self   = shift;
  my $seqnum = pack('N', $self->{sndseqnum}++);
  my $mac    = substr(hmac_md5($seqnum . $_[0], $self->{kic}), 0, 10);
  return $_[0] . $mac . pack('n', 1) . $seqnum;
}

sub decode {  # input: self, cipher buffer,length
  my ($self, $buf, $len) = @_;
  return if ($len <= 16);

  my ($mac, $type, $seqnum) = unpack('a[10]na[4]', substr($buf, -16, 16, ''));
  my $check = substr(hmac_md5($seqnum . $buf, $self->{kis}), 0, 10);
  return if ($mac ne $check);
  return if (unpack('N', $seqnum) != $self->{rcvseqnum});
  $self->{rcvseqnum}++;

  return $buf;
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
as described in RFC 2831.

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

=head2 PROPERTIES

The properties used are:

=over 4

=item maxbuf

The maximum buffer size for receiving cipher text

=item minssf

The minimum SSF value that should be provided by the SASL security layer.
The default is 0

=item maxssf

The maximum SSF value that should be provided by the SASL security layer.
The default is 2**31

=item externalssf

The SSF value provided by an underlying external security layer.
The default is 0

=item ssf

The actual SSF value provided by the SASL security layer after the SASL
authentication phase has been completed. This value is read-only and set
by the implementation after the SASL authentication phase has been completed.

=item maxout

The maximum plaintext buffer size for sending data to the peer.
This value is set by the implementation after the SASL authentication
phase has been completed and a SASL security layer is in effect.

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
