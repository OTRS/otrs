#******************************************************************************
# $Id: POP3Client.pm,v 1.1 2008-09-08 12:32:55 martin Exp $
#
# Description:  POP3Client module - acts as interface to POP3 server
# Author:       Sean Dowd <pop3client@dowds.net>
#
# Copyright (c) 1999-2008  Sean Dowd.  All rights reserved.
# This module is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#
#******************************************************************************

package Mail::POP3Client;

use strict;
use warnings;
use Carp;
use IO::Socket qw(SOCK_STREAM);

use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;

@ISA = qw(Exporter);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(

);

my $ID =q( $Id: POP3Client.pm,v 1.1 2008-09-08 12:32:55 martin Exp $ );
$VERSION = substr q$Revision: 1.1 $, 10;


# Preloaded methods go here.

#******************************************************************************
#* constructor
#* new Mail::POP3Client( USER => user,
#*                       PASSWORD => pass,
#*                       HOST => host,
#*                       AUTH_MODE => [BEST|APOP|CRAM-MD5|PASS],
#*                       TIMEOUT => 30,
#*                       LOCALADDR => 'xxx.xxx.xxx.xxx[:xx]',
#*                       DEBUG => 1 );
#* OR (deprecated)
#* new Mail::POP3Client( user, pass, host [, port, debug, auth_mode, local_addr])
#******************************************************************************
sub new
{
  my $classname = shift;
  my $self = {
	      DEBUG => 0,
	      SERVER => "pop3",
	      PORT => 110,
	      COUNT => -1,
	      SIZE => -1,
	      ADDR => "",
	      STATE => 'DEAD',
	      MESG => 'OK',
	      BANNER => '',
	      MESG_ID => '',
	      AUTH_MODE => 'BEST',
	      EOL => "\015\012",
	      TIMEOUT => 60,
	      STRIPCR => 0,
	      LOCALADDR => undef,
	      SOCKET => undef,
	      USESSL => 0,
	     };
  $self->{tranlog} = ();
  $^O =~ /MacOS/i && ($self->{STRIPCR} = 1);
  bless( $self, $classname );
  $self->_init( @_ );

  if ( defined($self->User()) && defined($self->Pass()) )
    {
      $self->Connect();
    }

  return $self;
}



#******************************************************************************
#* initialize - check for old-style params
#******************************************************************************
sub _init {
  my $self = shift;

  # if it looks like a hash
  if ( @_ && (scalar( @_ ) % 2 == 0) )
    {
      # ... and smells like a hash...
      my %hashargs = @_;
      if ( ( defined($hashargs{USER}) &&
	     defined($hashargs{PASSWORD}) ) ||
	   defined($hashargs{HOST})
	 )
	{
	  # ... then it must be a hash!  Push all values into my internal hash.
	  foreach my $key ( keys %hashargs )
	    {
	      $self->{$key} = $hashargs{$key};
	    }
	}
      else {$self->_initOldStyle( @_ );}
    }
  else {$self->_initOldStyle( @_ );}
}

#******************************************************************************
#* initialize using the old positional parameter style new - deprecated
#******************************************************************************
sub _initOldStyle {
  my $self = shift;
  $self->User( shift );
  $self->Pass( shift );
  my $host = shift;
  $host && $self->Host( $host );
  my $port = shift;
  $port && $self->Port( $port );
  my $debug = shift;
  $debug && $self->Debug( $debug );
  my $auth_mode = shift;
  $auth_mode && ($self->{AUTH_MODE} = $auth_mode);
  my $localaddr = shift;
  $localaddr && ($self->{LOCALADDR} = $localaddr);
}

#******************************************************************************
#* What version are we?
#******************************************************************************
sub Version {
  return $VERSION;
}


#******************************************************************************
#* Is the socket alive?
#******************************************************************************
sub Alive
{
  my $me = shift;
  $me->State =~ /^AUTHORIZATION$|^TRANSACTION$/i;
} # end Alive


#******************************************************************************
#* What's the frequency Kenneth?
#******************************************************************************
sub State
{
  my $me = shift;
  my $stat = shift or return $me->{STATE};
  $me->{STATE} = $stat;
} # end Stat


#******************************************************************************
#* Got anything to say?
#******************************************************************************
sub Message
{
  my $me = shift;
  my $msg = shift or return $me->{MESG};
  $me->{MESG} = $msg;
} # end Message


#******************************************************************************
#* set/query debugging
#******************************************************************************
sub Debug
{
  my $me = shift;
  my $debug = shift or return $me->{DEBUG};
  $me->{DEBUG} = $debug;

} # end Debug


#******************************************************************************
#* set/query the port number
#******************************************************************************
sub Port
{
  my $me = shift;
  my $port = shift or return $me->{PORT};

  $me->{PORT} = $port;

} # end port


#******************************************************************************
#* set the host
#******************************************************************************
sub Host
{
  my $me = shift;
  my $host = shift or return $me->{HOST};

#  $me->{INTERNET_ADDR} = inet_aton( $host ) or
#    $me->Message( "Could not inet_aton: $host, $!") and return;
  $me->{HOST} = $host;
} # end host

#******************************************************************************
#* set the local address
#******************************************************************************
sub LocalAddr
{
  my $me = shift;
  my $addr = shift or return $me->{LOCALADDR};

  $me->{LOCALADDR} = $addr;
}


#******************************************************************************
#* query the socket to use as a file handle - allows you to set the
#* socket too to allow SSL (thanks to Jamie LeTual)
#******************************************************************************
sub Socket {
  my $me = shift;
  my $socket = shift or return $me->{'SOCKET'};
  $me->{'SOCKET'} = $socket;
}

sub AuthMode {
  my $me = shift;
  my $mode = shift;
  return $me->{'AUTH_MODE'} unless $mode;
  $me->{'AUTH_MODE'} = $mode;
}

#******************************************************************************
#* set/query the USER
#******************************************************************************
sub User
{
  my $me = shift;
  my $user = shift or return $me->{USER};
  $me->{USER} = $user;

} # end User


#******************************************************************************
#* set/query the password
#******************************************************************************
sub Pass
{
  my $me = shift;
  my $pass = shift or return $me->{PASSWORD};
  $me->{PASSWORD} = $pass;

} # end Pass

sub Password { Pass(@_); }

#******************************************************************************
#*
#******************************************************************************
sub Count
{
  my $me = shift;
  my $c = shift;
  if (defined $c and length($c) > 0) {
    $me->{COUNT} = $c;
  } else {
    return $me->{COUNT};
  }

} # end Count


#******************************************************************************
#* set/query the size of the mailbox
#******************************************************************************
sub Size
{
  my $me = shift;
  my $c = shift;
  if (defined $c and length($c) > 0) {
    $me->{SIZE} = $c;
  } else {
    return $me->{SIZE};
  }

} # end Size


#******************************************************************************
#*
#******************************************************************************
sub EOL {
  my $me = shift;
  return $me->{'EOL'};
}


#******************************************************************************
#*
#******************************************************************************
sub Close
{
  my $me = shift;

  # only send the QUIT message is the socket is still connected.  Some
  # POP3 servers close the socket after a failed authentication.  It
  # is unclear whether the RFC allows this or not, so we'll attempt to
  # check the condition of the socket before sending data here.
  if ($me->Alive() && $me->Socket() && $me->Socket()->connected() ) {
    $me->_sockprint( "QUIT", $me->EOL );

    # from Patrick Bourdon - need this because some servers do not
    # delete in all cases.  RFC says server can respond (in UPDATE
    # state only, otherwise always OK).
    my $line = $me->_sockread();
    unless (defined $line) {
	$me->Message("Socket read failed for QUIT");
	# XXX: Should add the following?
	#$me->State('DEAD');
	undef $me->{SOCKET};
	return 0;
    }
    $me->Message( $line );
    close( $me->Socket() ) or $me->Message("close failed: $!") and do {
      undef $me->{SOCKET};
      return 0;
    };
    $me->State('DEAD');
    undef $me->{SOCKET};
    $line =~ /^\+OK/i || return 0;
  }
  1;
} # end Close

sub close { Close(@_); }
sub logout { Close(@_); }

#******************************************************************************
#*
#******************************************************************************
sub DESTROY
{
  my $me = shift;
  $me->Close;
} # end DESTROY


#******************************************************************************
#* Connect to the specified POP server
#******************************************************************************
sub Connect
{
  my ($me, $host, $port) = @_;

  $host and $me->Host($host);
  $port and $me->Port($port);

  $me->Close();

  my $s = $me->{SOCKET};
  $s || do {
    if ( $me->{USESSL} ) {
      if ( $me->Port() == 110 ) { $me->Port( 995 ); }
        eval {
	  require IO::Socket::SSL;
	};
      $@ and $me->Message("Could not load IO::Socket::SSL: $@") and return 0;
      $s = IO::Socket::SSL->new( PeerAddr => $me->Host(),
				 PeerPort => $me->Port(),
				 Proto    => "tcp",
				 Type      => SOCK_STREAM,
				 LocalAddr => $me->LocalAddr(),
				 Timeout   => $me->{TIMEOUT} )
	or $me->Message( "could not connect SSL socket [$me->{HOST}, $me->{PORT}]: $!" )
	  and return 0;
      $me->{SOCKET} = $s;
      
    } else {
      $s = IO::Socket::INET->new( PeerAddr  => $me->Host(),
				  PeerPort  => $me->Port(),
				  Proto     => "tcp",
				  Type      => SOCK_STREAM,
				  LocalAddr => $me->LocalAddr(),
				  Timeout   => $me->{TIMEOUT} )
	or
	  $me->Message( "could not connect socket [$me->{HOST}, $me->{PORT}]: $!" )
	    and
	      return 0;
      $me->{SOCKET} = $s;
    }
  };

  $s->autoflush( 1 );

  defined(my $msg = $me->_sockread()) or $me->Message("Could not read") and return 0;
  chomp $msg;
  $me->{BANNER}= $msg;

  # add check for servers that return -ERR on connect (not in RFC1939)
  $me->Message($msg);
  $msg =~ /^\+OK/i || return 0;

  my $atom = qr([-_\w!#$%&'*+/=?^`{|}~]+);
  $me->{MESG_ID}= $1 if ($msg =~/(<$atom(?:\.$atom)*\@$atom(?:\.$atom)*>)/o);
  $me->Message($msg);

  $me->State('AUTHORIZATION');
  defined($me->User()) and defined($me->Pass()) and $me->Login();

} # end Connect

sub connect { Connect(@_); }

#******************************************************************************
#* login to the POP server. If the AUTH_MODE is set to BEST, and the server
#* appears to support APOP, it will try APOP, if that fails, then it will try
#* SASL CRAM-MD5 if the server appears to support it, and finally PASS.
#* If the AUTH_MODE is set to APOP, and the server appears to support APOP, it
#* will use APOP or it will fail to log in. Likewise, for AUTH_MODE CRAM-MD5,
#* no PASS-fallback is made. Otherwise password is sent in clear text.
#******************************************************************************
sub Login
{
  my $me= shift;
  return 1 if $me->State eq 'TRANSACTION';  # Already logged in

  if ($me->{AUTH_MODE} eq 'BEST') {
    my $retval;
    if ($me->{MESG_ID}) {
      $retval = $me->Login_APOP();
      return($retval) if ($me->State eq 'TRANSACTION');
    }
    my $has_cram_md5 = 0;
    foreach my $capa ($me->Capa()) {
      $capa =~ /^SASL.*?\sCRAM-MD5\b/ and $has_cram_md5 = 1 and last;
    }
    if ($has_cram_md5) {
      $retval = $me->Login_CRAM_MD5();
      return($retval) if ($me->State() eq 'TRANSACTION');
    }
  }
  elsif ($me->{AUTH_MODE} eq 'APOP') {
    return(0) if (!$me->{MESG_ID});   # fail if the server does not support APOP
    return($me->Login_APOP());
  }
  elsif ($me->{AUTH_MODE} eq 'CRAM-MD5') {
    return($me->Login_CRAM_MD5());
  }
  elsif ($me->{AUTH_MODE} ne 'PASS') {
    $me->Message("Programing error. AUTH_MODE (".$me->{AUTH_MODE}.") not BEST | APOP | CRAM-MD5 | PASS.");
    return(0);
  }
  return($me->Login_Pass());
}

sub login { Login(@_); }

#******************************************************************************
#* login to the POP server using APOP (md5) authentication.
#******************************************************************************
sub Login_APOP
{
  my $me = shift;
  eval {
    require Digest::MD5;
  };
  $@ and $me->Message("APOP failed: $@") and return 0;

  my $hash = Digest::MD5::md5_hex($me->{MESG_ID} . $me->Pass());

  $me->_checkstate('AUTHORIZATION', 'APOP') or return 0;
  $me->_sockprint( "APOP " , $me->User , ' ', $hash, $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for APOP");
      $me->State('AUTHORIZATION');
      return 0;
  }
  chomp $line;
  $me->Message($line);
  # some servers will close here...
  $me->NOOP() || do {
    $me->State('DEAD');
    undef $me->{SOCKET};
    $me->Message("APOP failed: server has closed the socket");
    return 0;
  };

  $line =~ /^\+OK/ or $me->Message("APOP failed: $line") and return 0;
  $me->State('TRANSACTION');

  $me->POPStat() or return 0;
}


#******************************************************************************
#* login to the POP server using CRAM-MD5 (RFC 2195) authentication.
#******************************************************************************
sub Login_CRAM_MD5
{
  my $me = shift;

  eval {
    require Digest::HMAC_MD5;
    require MIME::Base64;
  };
  $@ and $me->Message("AUTH CRAM-MD5 failed: $@") and return 0;

  $me->_checkstate('AUTHORIZATION', 'AUTH') or return 0;
  $me->_sockprint('AUTH CRAM-MD5', $me->EOL());
  my $line = $me->_sockread();
  chomp $line;
  $me->Message($line);

  if ($line =~ /^\+ (.+)$/) {

    my $hmac =
      Digest::HMAC_MD5::hmac_md5_hex(MIME::Base64::decode($1), $me->Pass());
    (my $response = MIME::Base64::encode($me->User() . " $hmac")) =~ s/[\r\n]//g;
    $me->_sockprint($response, $me->EOL());

    $line = $me->_sockread();
    chomp $line;
    $me->Message($line);
    $line =~ /^\+OK/ or
      $me->Message("AUTH CRAM-MD5 failed: $line") and return 0;

  } else {
    $me->Message("AUTH CRAM-MD5 failed: $line") and return 0;
  }

  $me->State('TRANSACTION');

  $me->POPStat() or return 0;
}


#******************************************************************************
#* login to the POP server using simple (cleartext) authentication.
#******************************************************************************
sub Login_Pass
{
  my $me = shift;

  $me->_checkstate('AUTHORIZATION', 'USER') or return 0;
  $me->_sockprint( "USER " , $me->User() , $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for USER");
      $me->State('AUTHORIZATION');
      return 0;
  }
  chomp $line;
  $me->Message($line);
  $line =~ /^\+/ or $me->Message("USER failed: $line") and $me->State('AUTHORIZATION')
    and return 0;
  
  $me->_sockprint( "PASS " , $me->Pass() , $me->EOL );
  $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for PASS");
      $me->State('AUTHORIZATION');
      return 0;
  }
  chomp $line;
  $me->Message($line);
  $line =~ /^\+OK/ or $me->Message("PASS failed: $line") and $me->State('AUTHORIZATION')
    and return 0;
  
  $me->State('TRANSACTION');

  ($me->POPStat() >= 0) or return 0;

} # end Login


#******************************************************************************
#* Get the Head of a message number.  If you give an optional number
#* of lines you will get the first n lines of the body also.  This
#* allows you to preview a message.
#******************************************************************************
sub Head
{
  my $me = shift;
  my $num = shift;
  my $lines = shift;
  $lines ||= 0;
  $lines =~ /\d+/ || ($lines = 0);

  my $header = '';

  $me->_checkstate('TRANSACTION', 'TOP') or return;
  $me->_sockprint( "TOP $num $lines", $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for TOP");
      return;
  }
  chomp $line;
  $line =~ /^\+OK/ or $me->Message("Bad return from TOP: $line") and return;
  $line =~ /^\+OK (\d+) / and my $buflen = $1;

  while (1) {
    $line = $me->_sockread();
    unless (defined $line) {
	$me->Message("Socket read failed for TOP");
	return;
    }
    last if $line =~ /^\.\s*$/;
    $line =~ s/^\.\././;
    $header .= $line;
  }

  return wantarray ? split(/\r?\n/, $header) : $header;
} # end Head


#******************************************************************************
#* Get the header and body of a message
#******************************************************************************
sub HeadAndBody
{
  my $me = shift;
  my $num = shift;
  my $mandb = '';

  $me->_checkstate('TRANSACTION', 'RETR') or return;
  $me->_sockprint( "RETR $num", $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for RETR");
      return;
  }
  chomp $line;
  $line =~ /^\+OK/ or $me->Message("Bad return from RETR: $line") and return;
  $line =~ /^\+OK (\d+) / and my $buflen = $1;

  while (1) {
    $line = $me->_sockread();
    unless (defined $line) {
	$me->Message("Socket read failed for RETR");
	return;
    }
    last if $line =~ /^\.\s*$/;
    # convert any '..' at the start of a line to '.'
    $line =~ s/^\.\././;
    $mandb .= $line;
  }

  return wantarray ? split(/\r?\n/, $mandb) : $mandb;

} # end HeadAndBody

sub message_string { HeadAndBody(@_); }

#******************************************************************************
#* get the head and body of a message and write it to a file handle.
#* Sends the raw data: does no CR/NL stripping or mapping.
#******************************************************************************
sub HeadAndBodyToFile
{
  local ($, , $\);
  my $me = shift;
  my $fh = shift;
  my $num = shift;
  my $body = '';

  $me->_checkstate('TRANSACTION', 'RETR') or return;
  $me->_sockprint( "RETR $num", $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for RETR");
      return 0;
  }
  chomp $line;
  $line =~ /^\+OK/ or $me->Message("Bad return from RETR: $line") and return 0;
  $line =~ /^\+OK (\d+) / and my $buflen = $1;

  while (1) {
    $line = $me->_sockread();
    unless (defined $line) {
	$me->Message("Socket read failed for RETR");
	return 0;
    }
    last if $line =~ /^\.\s*$/;
    # convert any '..' at the start of a line to '.'
    $line =~ s/^\.\././;
    print $fh $line;
  }
  return 1;
} # end BodyToFile



#******************************************************************************
#* get the body of a message
#******************************************************************************
sub Body
{
  my $me = shift;
  my $num = shift;
  my $body = '';

  $me->_checkstate('TRANSACTION', 'RETR') or return;
  $me->_sockprint( "RETR $num", $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for RETR");
      return;
  }
  chomp $line;
  $line =~ /^\+OK/ or $me->Message("Bad return from RETR: $line") and return;
  $line =~ /^\+OK (\d+) / and my $buflen = $1;

  # skip the header
  do {
    $line = $me->_sockread();
    unless (defined $line) {
	$me->Message("Socket read failed for RETR");
	return;
    }
    $line =~ s/[\r\n]//g;
  } until $line =~ /^(\s*|\.)$/;
  $line =~ /^\.\s*$/ && return;  # we found a header only!  Lotus Notes seems to do this.

  while (1) {
    $line = $me->_sockread();
    unless (defined $line) {
	$me->Message("Socket read failed for RETR");
	return;
    }
    last if $line =~ /^\.\s*$/;
    # convert any '..' at the start of a line to '.'
    $line =~ s/^\.\././;
    $body .= $line;
  }

  return wantarray ? split(/\r?\n/, $body) : $body;

} # end Body


#******************************************************************************
#* get the body of a message and write it to a file handle.  Sends the raw data:
#* does no CR/NL stripping or mapping.
#******************************************************************************
sub BodyToFile
{
  local ($, , $\);
  my $me = shift;
  my $fh = shift;
  my $num = shift;
  my $body = '';

  $me->_checkstate('TRANSACTION', 'RETR') or return;
  $me->_sockprint( "RETR $num", $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for RETR");
      return;
  }
  chomp $line;
  $line =~ /^\+OK/ or $me->Message("Bad return from RETR: $line") and return;
  $line =~ /^\+OK (\d+) / and my $buflen = $1;

  # skip the header
  do {
    $line = $me->_sockread();
    unless (defined $line) {
	$me->Message("Socket read failed for RETR");
	return;
    }
    $line =~ s/[\r\n]//g;
  } until $line =~ /^(\s*|\.)$/;
  $line =~ /^\.\s*$/ && return;  # we found a header only!  Lotus Notes seems to do this.

  while (1) {
    $line = $me->_sockread();
    unless (defined $line) {
	$me->Message("Socket read failed for RETR");
	return;
    }
    chomp $line;
    last if $line =~ /^\.\s*$/;
    # convert any '..' at the start of a line to '.'
    $line =~ s/^\.\././;
    print $fh $line, "\n";
  }
} # end BodyToFile



#******************************************************************************
#* handle a STAT command - returns the number of messages in the box
#******************************************************************************
sub POPStat
{
  my $me = shift;

  $me->_checkstate('TRANSACTION', 'STAT') or return -1;
  $me->_sockprint( "STAT", $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for STAT");
      return -1;
  }
  $line =~ /^\+OK/ or $me->Message("STAT failed: $line") and return -1;
  $line =~ /^\+OK (\d+) (\d+)/ and $me->Count($1), $me->Size($2);

  return $me->Count();
}


#******************************************************************************
#* issue the LIST command
#******************************************************************************
sub List {
  my $me = shift;
  my $num = shift || '';
  my $CMD = shift || 'LIST';
  $CMD=~ tr/a-z/A-Z/;

  $me->Alive() or return;

  my @retarray = ();
  my $ret = '';

  $me->_checkstate('TRANSACTION', $CMD) or return;
  $me->_sockprint($CMD, $num ? " $num" : '', $me->EOL());

  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for LIST");
      return;
  }
  $line =~ /^\+OK/ or $me->Message("$line") and return;
  if ($num) {
    $line =~ s/^\+OK\s*//;
    return $line;
  }
  while( defined( $line = $me->_sockread() ) ) {
    $line =~ /^\.\s*$/ and last;
    $ret .= $line;
    chomp $line;
    push(@retarray, $line);
  }
  if ($ret) {
    return wantarray ? @retarray : $ret;
  }
}

#******************************************************************************
#* issue the LIST command, but return results in an indexed array.
#******************************************************************************
sub ListArray {
  my $me = shift;
  my $num = shift || '';
  my $CMD = shift || 'LIST';
  $CMD=~ tr/a-z/A-Z/;

  $me->Alive() or return;

  my @retarray = ();
  my $ret = '';

  $me->_checkstate('TRANSACTION', $CMD) or return;
  $me->_sockprint($CMD, $num ? " $num" : '', $me->EOL());
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for LIST");
      return;
  }
  $line =~ /^\+OK/ or $me->Message("$line") and return;
  if ($num) {
    $line =~ s/^\+OK\s*//;
    return $line;
  }
  while( defined( $line = $me->_sockread() ) ) {
    $line =~ /^\.\s*$/ and last;
    $ret .= $line;
    chomp $line;
    my ($num, $uidl) = split('\s+', $line);
    $retarray[$num] = $uidl;
  }
  if ($ret) {
    return wantarray ? @retarray : $ret;
  }
}


#******************************************************************************
#* retrieve the given message number - uses HeadAndBody
#******************************************************************************
sub Retrieve {
  return HeadAndBody( @_ );
}

#******************************************************************************
#* retrieve the given message number to the given file handle- uses
#* HeadAndBodyToFile
#******************************************************************************
sub RetrieveToFile {
  return HeadAndBodyToFile( @_ );
}


#******************************************************************************
#* implement the LAST command - see the rfc (1081) OBSOLETED by RFC
#******************************************************************************
sub Last
{
  my $me = shift;

  $me->_checkstate('TRANSACTION', 'LAST') or return;
  $me->_sockprint( "LAST", $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for LAST");
      return 0;
  }

  $line =~ /\+OK (\d+)\D*$/ and return $1;
}


#******************************************************************************
#* reset the deletion stat
#******************************************************************************
sub Reset
{
  my $me = shift;

  $me->_checkstate('TRANSACTION', 'RSET') or return;
  $me->_sockprint( "RSET", $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for RSET");
      return 0;
  }
  $line =~ /^\+OK/ and return 1;
  return 0;
}


#******************************************************************************
#* delete the given message number
#******************************************************************************
sub Delete {
  my $me = shift;
  my $num = shift || return;

  $me->_checkstate('TRANSACTION', 'DELE') or return;
  $me->_sockprint( "DELE $num",  $me->EOL );
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for DELE");
      return 0;
  }
  $me->Message($line);
  $line =~ /^\+OK/ && return 1;
  return 0;
}

sub delete_message { Delete(@_); }

#******************************************************************************
#* UIDL - submitted by Dion Almaer (dion@member.com)
#******************************************************************************
sub Uidl
{
  my $me = shift;
  my $num = shift || '';

  $me->Alive() or return;

  my @retarray = ();
  my $ret = '';

  $me->_checkstate('TRANSACTION', 'UIDL') or return;
  $me->_sockprint('UIDL', $num ? " $num" : '', $me->EOL());
  my $line = $me->_sockread();
  unless (defined $line) {
      $me->Message("Socket read failed for UIDL");
      return;
  }
  $line =~ /^\+OK/ or $me->Message($line) and return;
  if ($num) {
    $line =~ s/^\+OK\s*//;
    return $line;
  }
  while( defined( $line = $me->_sockread() ) ) {
    $line =~ /^\.\s*$/ and last;
    $ret .= $line;
    chomp $line;
    my ($num, $uidl) = split('\s+', $line);
    $retarray[$num] = $uidl;
  }
  if ($ret) {
    return wantarray ? @retarray : $ret;
  }
}


#******************************************************************************
#* CAPA - query server capabilities, see RFC 2449
#******************************************************************************
sub Capa {

  my $me = shift;

  # no state check here, all are allowed

  $me->Alive() or return;

  my @retarray = ();
  my $ret = '';

  $me->_sockprint('CAPA', $me->EOL());

  my $line = $me->_sockread();
  $line =~ /^\+OK/ or $me->Message($line) and return;

  while(defined($line = $me->_sockread())) {
    $line =~ /^\.\s*$/ and last;
    $ret .= $line;
    chomp $line;
    push(@retarray, $line);
  }

  if ($ret) {
    return wantarray ? @retarray : $ret;
  }
}

#******************************************************************************
#* XTND - submitted by Chris Moates (six@mox.net)
#******************************************************************************
sub Xtnd {
  my $me = shift;
  my $xtndarg = shift || '';

  if ($xtndarg eq '') { 
    $me->Message("XTND requires a string argument");
    return;
  }

  my $s = $me->Socket();
  $me->_checkstate('TRANSACTION', 'XTND') or return;
  $me->Alive() or return;
 
  $me->_sockprint( "XTND $xtndarg", $me->EOL );
  my $line = $me->_sockread();
  $line =~ /^\+OK/ or $me->Message($line) and return;
  $line =~ s/^\+OK\s*//;
  return $line;
}

#******************************************************************************
#* NOOP - used to check socket
#******************************************************************************
sub NOOP {
  my $me = shift;

  my $s = $me->Socket();
  $me->Alive() or return 0;
 
  $me->_sockprint( "NOOP", $me->EOL );
  my $line = $me->_sockread();
#  defined( $line ) or return 0;
  $line =~ /^\+OK/ or return 0;
  return 1;
}


#******************************************************************************
#* Mail::IMAPClient compatibility functions (wsnyder@wsnyder.org)
#******************************************************************************

# Empty stubs
sub Peek {}
sub Uid {}

# Pop doesn't have concept of different folders
sub folders { return ('INBOX'); }
sub Folder { return ('INBOX'); }
sub select {}

# Message accessing
sub unseen {
    my $me = shift;
    my $count = $me->Count;
    return () if !$count;
    return ( 1..$count);
}

#*****************************************************************************
#* Check the state before issuing a command
#*****************************************************************************
sub _checkstate
{
  my ($me, $state, $cmd) = @_;
  my $currstate = $me->State();
  if ($currstate ne $state) {
    $me->Message("POP3 command $cmd may be given only in the '$state' state " .
                 "(current state is '$currstate').");
    return 0;
  } else {
    return 1;
  }
}


#*****************************************************************************
#* funnel all read/write through here to allow easier debugging
#* (mitra@earth.path.net)
#*****************************************************************************
sub _sockprint
{
  local ($, , $\);
  my $me = shift;
  my $s = $me->Socket();
  $me->Debug and Carp::carp "POP3 -> ", @_;
  my $outline = "@_";
  chomp $outline;
  push(@{$me->{tranlog}}, $outline);
  print $s @_;
}

sub _sockread
{
  my $me = shift;
  my $line = $me->Socket()->getline();
  unless (defined $line) {
      return;
  }

  # Macs seem to leave CR's or LF's sitting on the socket.  This
  # removes them.
  $me->{STRIPCR} && ($line =~ s/^[\r]+//);

  $me->Debug and Carp::carp "POP3 <- ", $line;
  $line =~ /^[\\+\\-](OK|ERR)/i && do {
    my $l = $line;
    chomp $l;
    push(@{$me->{tranlog}}, $l);
  };
  return $line;
}


# end package Mail::POP3Client

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__



################################################################################
# POD Documentation (perldoc Mail::POP3Client or pod2html this_file)
################################################################################

=head1 NAME

Mail::POP3Client - Perl 5 module to talk to a POP3 (RFC1939) server

=head1 SYNOPSIS

  use Mail::POP3Client;
  $pop = new Mail::POP3Client( USER     => "me",
			       PASSWORD => "mypassword",
			       HOST     => "pop3.do.main" );
  for( $i = 1; $i <= $pop->Count(); $i++ ) {
    foreach( $pop->Head( $i ) ) {
      /^(From|Subject):\s+/i && print $_, "\n";
    }
  }
  $pop->Close();

  # OR with SSL
  $pop = new Mail::POP3Client( USER     => "me",
			       PASSWORD => "mypassword",
			       HOST     => "pop3.do.main",
			       USESSL   => true,
			     );

  # OR
  $pop2 = new Mail::POP3Client( HOST  => "pop3.otherdo.main" );
  $pop2->User( "somebody" );
  $pop2->Pass( "doublesecret" );
  $pop2->Connect() >= 0 || die $pop2->Message();
  $pop2->Close();

  # OR to use your own SSL socket...
  my $socket = IO::Socket::SSL->new( PeerAddr => 'pop.securedo.main',
                                     PeerPort => 993,
                                     Proto    => 'tcp') || die "No socket!";
  my $pop = Mail::POP3Client->new();
  $pop->User('somebody');
  $pop->Pass('doublesecret');
  $pop->Socket($socket);
  $pop->Connect();

=head1 DESCRIPTION

This module implements an Object-Oriented interface to a POP3 server.
It implements RFC1939 (http://www.faqs.org/rfcs/rfc1939.html)

=head1 EXAMPLES

Here is a simple example to list out the From: and Subject: headers in
your remote mailbox:

  #!/usr/local/bin/perl

  use Mail::POP3Client;

  $pop = new Mail::POP3Client( USER     => "me",
			       PASSWORD => "mypassword",
			       HOST     => "pop3.do.main" );
  for ($i = 1; $i <= $pop->Count(); $i++) {
    foreach ( $pop->Head( $i ) ) {
      /^(From|Subject):\s+/i and print $_, "\n";
    }
    print "\n";
  }

=head1 CONSTRUCTORS

Old style (deprecated):
   new Mail::POP3Client( USER, PASSWORD [, HOST, PORT, DEBUG, AUTH_MODE] );

New style (shown with defaults):
   new Mail::POP3Client( USER      => "",
                         PASSWORD  => "",
                         HOST      => "pop3",
                         PORT      => 110,
                         AUTH_MODE => 'BEST',
                         DEBUG     => 0,
                         TIMEOUT   => 60,
                         LOCALADDR => 'xxx.xxx.xxx.xxx[:xx]',
                         SOCKET => undef,
                         USESSL => 0,
                       );

=over 4

=item *
USER is the userID of the account on the POP server

=item *
PASSWORD is the cleartext password for the userID

=item *
HOST is the POP server name or IP address (default = 'pop3')

=item *
PORT is the POP server port (default = 110)

=item *
DEBUG - any non-null, non-zero value turns on debugging (default = 0)

=item *
AUTH_MODE - pass 'APOP' to force APOP (MD5) authorization. (default is 'BEST')

=item *
TIMEOUT - set a timeout value for socket operations (default = 60)

=item *
LOCALADDR - allow selecting a local inet address to use

=back

=head1 METHODS

These commands are intended to make writing a POP3 client easier.
They do not necessarily map directly to POP3 commands defined in
RFC1081 or RFC1939, although all commands should be supported.  Some
commands return multiple lines as an array in an array context.

=over 8

=item I<new>( USER => 'user', PASSWORD => 'password', HOST => 'host',
              PORT => 110, DEBUG => 0, AUTH_MODE => 'BEST', TIMEOUT => 60,,
              LOCALADDR => 'xxx.xxx.xxx.xxx[:xx]', SOCKET => undef, USESSL => 0 )
)

Construct a new POP3 connection with this.  You should use the
hash-style constructor.  B<The old positional constructor is
deprecated and will be removed in a future release.  It is strongly
recommended that you convert your code to the new version.>

You should give it at least 2 arguments: USER and PASSWORD.  The
default HOST is 'pop3' which may or may not work for you.  You can
specify a different PORT (be careful here).

new will attempt to Connect to and Login to the POP3 server if you
supply a USER and PASSWORD.  If you do not supply them in the
constructor, you will need to call Connect yourself.

The valid values for AUTH_MODE are 'BEST', 'PASS', 'APOP' and 'CRAM-MD5'.
BEST says to try APOP if the server appears to support it and it can be
used to successfully log on, next try similarly with CRAM-MD5, and finally
revert to PASS. APOP and CRAM-MD5 imply that an MD5 checksum will be
used instead of sending your password in cleartext.  However,
B<if the server does not claim to support APOP or CRAM-MD5,
the cleartext method will be used. Be careful.> There are a few
servers that will send a timestamp in the banner greeting, but APOP
will not work with them (for instance if the server does not know your
password in cleartext).  If you think your authentication information
is correct, run in DEBUG mode and look for errors regarding
authorization.  If so, then you may have to use 'PASS' for that server.
The same applies to CRAM-MD5, too.

If you enable debugging with DEBUG => 1, socket traffic will be echoed
to STDERR.

Another warning, it's impossible to differentiate between a timeout
and a failure.

If you pass a true value for USESSL, the port will be changed to 995 if
it is not set or is 110.  Otherwise, it will use your port.  If USESSL
is true, IO::Socket::SSL will be loaded.  If it is not in your perl,
the call to connect will fail.

new returns a valid Mail::POP3Client object in all cases.  To test for
a connection failure, you will need to check the number of messages:
-1 indicates a connection error.  This will likely change sometime in
the future to return undef on an error, setting $! as a side effect.
This change will not happen in any 2.x version.

=item I<Head>( MESSAGE_NUMBER [, PREVIEW_LINES ] )

Get the headers of the specified message, either as an array or as a
string, depending on context.

You can also specify a number of preview lines which will be returned
with the headers.  This may not be supported by all POP3 server
implementations as it is marked as optional in the RFC.  Submitted by
Dennis Moroney <dennis@hub.iwl.net>.

=item I<Body>( MESSAGE_NUMBER )

Get the body of the specified message, either as an array of lines or
as a string, depending on context.

=item I<BodyToFile>( FILE_HANDLE, MESSAGE_NUMBER )

Get the body of the specified message and write it to the given file handle.
my $fh = new IO::Handle();
$fh->fdopen( fileno( STDOUT ), "w" );
$pop->BodyToFile( $fh, 1 );

Does no stripping of NL or CR.


=item I<HeadAndBody>( MESSAGE_NUMBER )

Get the head and body of the specified message, either as an array of
lines or as a string, depending on context.

=over 4

=item Example

foreach ( $pop->HeadAndBody( 1 ) )
   print $_, "\n";

prints out the complete text of message 1.

=back

=item I<HeadAndBodyToFile>( FILE_HANDLE, MESSAGE_NUMBER )

Get the head and body of the specified message and write it to the given file handle.
my $fh = new IO::Handle();
$fh->fdopen( fileno( STDOUT ), "w" );
$pop->HeadAndBodyToFile( $fh, 1 );

Does no stripping of NL or CR.


=item I<Retrieve>( MESSAGE_NUMBER )

Same as HeadAndBody.

=item I<RetrieveToFile>( FILE_HANDLE, MESSAGE_NUMBER )

Same as HeadAndBodyToFile.

=item I<Delete>( MESSAGE_NUMBER )

Mark the specified message number as DELETED.  Becomes effective upon
QUIT (invoking the Close method).  Can be reset with a Reset message.

=item I<Connect>

Start the connection to the POP3 server.  You can pass in the host and
port.  Returns 1 if the connection succeeds, or 0 if it fails (Message
will contain a reason).  The constructor always returns a blessed
reference to a Mail::POP3Client obhect.  This may change in a version
3.x release, but never in a 2.x release.

=item I<Close>

Close the connection gracefully.  POP3 says this will perform any
pending deletes on the server.

=item I<Alive>

Return true or false on whether the connection is active.

=item I<Socket>

Return the file descriptor for the socket, or set if supplied.

=item I<Size>

Set/Return the size of the remote mailbox.  Set by POPStat.

=item I<Count>

Set/Return the number of remote messages.  Set during Login.

=item I<Message>

The last status message received from the server or a message
describing any problem encountered.

=item I<State>

The internal state of the connection: DEAD, AUTHORIZATION, TRANSACTION.

=item I<POPStat>

Return the results of a POP3 STAT command.  Sets the size of the
mailbox.

=item I<List>([message_number])

Returns the size of the given message number when called with an
argument using the following format:

   <message_number> <size_in_bytes>

If message_number is omitted, List behaves the same as ListArray,
returning an indexed array of the sizes of each message in the same
format.

You can parse the size in bytes using split:
 ($msgnum, $size) = split('\s+', $pop -> List( n ));


=item I<ListArray>

Return a list of sizes of each message.  This returns an indexed
array, with each message number as an index (starting from 1) and the
value as the next entry on the line.  Beware that some servers send
additional info for each message for the list command.  That info may
be lost.

=item I<Uidl>( [MESSAGE_NUMBER] )

Return the unique ID for the given message (or all of them).  Returns
an indexed array with an entry for each valid message number.
Indexing begins at 1 to coincide with the server's indexing.

=item I<Capa>

Query server capabilities, as described in RFC 2449. Returns the
capabilities in an array. Valid in all states.

=item I<XTND>

Optional extended commands.  Transaction state only.

=item I<Last>

Return the number of the last message, retrieved from the server.

=item I<Reset>

Tell the server to unmark any message marked for deletion.

=item I<User>( [USER_NAME] )

Set/Return the current user name.

=item I<Pass>( [PASSWORD] )

Set/Return the current user name.

=item I<Login>

Attempt to login to the server connection.

=item I<Host>( [HOSTNAME] )

Set/Return the current host.

=item I<Port>( [PORT_NUMBER] )

Set/Return the current port number.

=back

=head1 IMAP COMPATIBILITY

Basic Mail::IMAPClient method calls are also supported: close, connect,
login, message_string, Password, and unseen.  Also, empty stubs are
provided for Folder, folders, Peek, select, and Uid.

=head1 REQUIREMENTS

This module does not have mandatory requirements for modules that are not part
of the standard Perl distribution. However, APOP needs need Digest::MD5 and
CRAM-MD5 needs Digest::HMAC_MD5 and MIME::Base64.

=head1 AUTHOR

Sean Dowd <pop3client@dowds.net>

=head1 CREDITS

Based loosely on News::NNTPClient by Rodger Anderson
<rodger@boi.hp.com>.

=head1 SEE ALSO

perl(1)

the Digest::MD5 manpage, the Digest::HMAC_MD5 manpage, the MIME::Base64 manpage

RFC 1939: Post Office Protocol - Version 3

RFC 2195: IMAP/POP AUTHorize Extension for Simple Challenge/Response

RFC 2449: POP3 Extension Mechanism

=cut
