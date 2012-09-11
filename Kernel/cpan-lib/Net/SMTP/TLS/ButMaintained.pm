package Net::SMTP::TLS::ButMaintained;
{
    $Net::SMTP::TLS::ButMaintained::VERSION = '0.20';
}

# ABSTRACT: An SMTP client supporting TLS and AUTH

use strict;
use warnings;

use Carp;

use Net::SSLeay;
use IO::Socket::INET;
use IO::Socket::SSL;
use MIME::Base64 qw[encode_base64 decode_base64];
use Digest::HMAC_MD5 qw[hmac_md5_hex];

BEGIN {    #set up Net::SSLeay's internals
    Net::SSLeay::load_error_strings();
    Net::SSLeay::SSLeay_add_ssl_algorithms();
    Net::SSLeay::randomize();
}

sub new {
    my $pkg  = shift;
    my $host = shift;
    my %args = @_;
    $args{Host} = $host;
    $args{Hello} = "localhost" if not $args{Hello};

    # make the non-SSL socket that will later be
    # transformed
    $args{sock} = new IO::Socket::INET(
        PeerAddr => $host,
        PeerPort => $args{Port} || 25,
        Proto    => 'tcp',
        Timeout  => $args{Timeout} || 5
    ) or croak "Connect failed :$@\n";

    my $me = bless \%args, $pkg;

    # read the line immediately after connecting
    my ( $rsp, $txt, $more ) = $me->_response();
    if ( not $rsp == 220 ) {
        croak "Could not connect to SMTP server: $host $txt\n";
    }

    # empty the socket of any continuation lines
    while ( $more eq '-' ) { ( $rsp, $txt, $more ) = $me->_response(); }

    $me->hello();    # the first hello, 2nd after starttls
    $me->starttls() if not $args{NoTLS};    # why we're here, after all
    $me->login() if ( $me->{User} and $me->{Password} );
    return $me;
}

# simply print a command to the server
sub _command {
    my $me      = shift;
    my $command = shift;
    $me->{sock}->printf( $command . "\015\012" );
}

# read a line from the server and parse the
# CODE SEPERATOR TEXT response format
sub _response {
    my $me   = shift;
    my $line = $me->{sock}->getline();
    my @rsp  = ( $line =~ /(\d+)(.)([^\r]*)/ );

    # reverse things so the seperator is at the end...
    # that way we don't have to get fancy with the return
    # values for calls that don't require the "more indicator"
    return ( $rsp[0], $rsp[2], $rsp[1] );
}

# issue an EHLO command using the hostname provided to the constructor via
# the Hello paramter, which defaults to localhost. After that, read
# all the ESMTP capabilities returned by the server
sub hello {
    my $me = shift;
    $me->_command( "EHLO " . $me->{Hello} );
    my ( $num, $txt, $more ) = $me->_response();
    if ( not $num == 250 ) {
        croak "EHLO command failed: $num $txt\n";
    }
    my %features = ();

    # SMTP uses the dash to seperate the status code from
    # the response text while there are more lines remaining
    while ( $more eq '-' ) {
        ( $num, $txt, $more ) = $me->_response();
        $txt =~ s/[\n|\r]//g;
        $txt =~ /(\S+)\s(.*)$/;
        my ( $feat, $parm ) = ( $txt =~ /^(\w+)[= ]*(.*)$/ );
        $features{$feat} = $parm;
    }
    $me->{features} = \%features;
    return 1;
}

# the magic! issue the STARTTLS command and
# use IO::Socket::SSL to transform that no-good
# plain old socket into an SSL socket
sub starttls {
    my $me = shift;
    $me->_command("STARTTLS");
    my ( $num, $txt ) = $me->_response();
    if ( not $num == 220 ) {
        croak "Invalid response for STARTTLS: $num $txt\n";
    }
    if ( not IO::Socket::SSL::socket_to_SSL( $me->{sock} ) ) {
        croak "Couldn't start TLS: " . IO::Socket::SSL::errstr . "\n";
    }
    $me->hello();
}

# based on the AUTH line returned in the features after EHLO,
# determine which type of authentication to perform
sub login {
    my $me   = shift;
    my $type = $me->{features}->{AUTH};
    if ( not $type ) {
        croak "Server did not return AUTH in capabilities\n";
    }
    if ( $type =~ /CRAM\-MD5/ ) {
        $me->auth_MD5();
    }
    elsif ( $type =~ /LOGIN/ ) {
        $me->auth_LOGIN();
    }
    elsif ( $type =~ /PLAIN/ ) {
        $me->auth_PLAIN();
    }
    else {
        croak "Unsupported Authentication mechanism\n";
    }
}

# perform a LOGIN authentication...
# works well on my box.
sub auth_LOGIN {
    my $me = shift;
    $me->_command("AUTH LOGIN");
    my ( $num, $txt ) = $me->_response();
    if ( not $num == 334 ) {
        croak "Cannot authenticate via LOGIN: $num $txt\n";
    }
    $me->_command( encode_base64( $me->{User}, "" ) );
    ( $num, $txt ) = $me->_response();
    if ( not $num == 334 ) {
        croak "Auth failed: $num $txt\n";
    }
    $me->_command( encode_base64( $me->{Password}, "" ) );
    ( $num, $txt ) = $me->_response();
    if ( not $num == 235 ) {
        croak "Auth failed: $num $txt\n";
    }
}

# use MD5 to login... gets the ticket from the text
# of the line returned after the auth command is issued.
# NOTE: untested
sub auth_MD5 {
    my $me = shift;
    $me->_command("AUTH CRAM-MD5");
    my ( $num, $txt ) = $me->_response();
    if ( not $num == 334 ) {
        croak "Cannot authenticate via CRAM-MD5: $num $txt\n";
    }
    my $ticket = decode_base64($txt)
      or croak "Unable to decode ticket";
    my $md5_pass = hmac_md5_hex( $ticket, $me->{Password} );
    $me->_command( encode_base64( $me->{User} . " " . $md5_pass, "" ) );
    ( $num, $txt ) = $me->_response();
    if ( not $num == 235 ) {
        croak "Auth failed: $num $txt\n";
    }
}

# perform plain authentication
sub auth_PLAIN {
    my $me   = shift;
    my $user = $me->{User};
    my $pass = $me->{Password};
    $me->_command(
        sprintf( "AUTH PLAIN %s", encode_base64( "$user\0$user\0$pass", "" ) )
    );
    my ( $num, $txt ) = $me->_response();
    if ( not $num == 235 ) {
        croak "Auth failed: $num $txt\n";
    }
}

sub _addr {
    my $addr = shift;
    $addr = "" unless defined $addr;

    return $1 if $addr =~ /(<[^>]*>)/;
    $addr =~ s/^\s+|\s+$//sg;

    "<$addr>";
}

# send the MAIL FROM: <addr> command
sub mail {
    my $me   = shift;
    my $from = shift;
    $me->_command( "MAIL FROM: " . _addr($from) );
    my ( $num, $txt ) = $me->_response();
    if ( not $num == 250 ) {
        croak "Could't set FROM: $num $txt\n";
    }
}

# send the RCPT TO: <addr> command
sub recipient {
    my $me = shift;

    my $addr;
    foreach $addr (@_) {
        $me->_command( "RCPT TO: " . _addr($addr) );
        my ( $num, $txt ) = $me->_response();
        if ( not $num == 250 ) {
            croak "Couldn't send TO <$addr>: $num $txt\n";
        }
    }
}

BEGIN {
    *to  = \&recipient;
    *cc  = \&recipient;
    *bcc = \&recipient;
}

# start the body of the message
# I would probably have designed the public methods of
# this class differently, but this is to keep with
# Net::SMTP's API
sub data {
    my $me = shift;
    $me->_command("DATA");
    my ( $num, $txt ) = $me->_response();
    if ( not $num == 354 ) {
        croak "Data failed: $num $txt\n";
    }
}

# send stuff over raw (for use as message body)
sub datasend {
    my $cmd  = shift;
    my $arr  = @_ == 1 && ref( $_[0] ) ? $_[0] : \@_;
    my $line = join( "", @$arr );

    return 0 unless defined( fileno( $cmd->{sock} ) );

    my $last_ch = $cmd->{last_ch};
    $last_ch = $cmd->{last_ch} = "\012" unless defined $last_ch;

    return 1 unless length $line;

    $line =~ tr/\r\n/\015\012/ unless "\r" eq "\015";

    my $first_ch = '';

    if ( $last_ch eq "\015" ) {
        $first_ch = "\012" if $line =~ s/^\012//;
    }
    elsif ( $last_ch eq "\012" ) {
        $first_ch = "." if $line =~ /^\./;
    }

    $line =~ s/\015?\012(\.?)/\015\012$1$1/sg;

    substr( $line, 0, 0 ) = $first_ch;

    $cmd->{last_ch} = substr( $line, -1, 1 );

    my $len    = length($line);
    my $offset = 0;
    my $win    = "";
    vec( $win, fileno( $cmd->{sock} ), 1 ) = 1;
    my $timeout = $cmd->{sock}->timeout || undef;

    local $SIG{PIPE} = 'IGNORE' unless $^O eq 'MacOS';

    while ($len) {
        my $wout;
        if ( select( undef, $wout = $win, undef, $timeout ) > 0
            or -f $cmd->{sock} )    # -f for testing on win32
        {
            my $w = syswrite( $cmd->{sock}, $line, $len, $offset );
            unless ( defined($w) ) {
                carp("Error: $!");
                return undef;
            }
            $len -= $w;
            $offset += $w;
        }
        else {
            carp("Error: Timeout");
            return undef;
        }
    }

}

# end the message body submission by a line with nothing
# but a period on it.
sub dataend {
    my $me = shift;
    $me->_command("\015\012.");
    my ( $num, $txt ) = $me->_response();
    if ( not $num == 250 ) {
        croak "Couldn't send mail: $num $txt\n";
    }
}

# politely disconnect from the SMTP server.
sub quit {
    my $me = shift;
    $me->_command("QUIT");
    my ( $num, $txt ) = $me->_response();
    if ( not $num == 221 ) {
        croak
          "An error occurred disconnecting from the mail server: $num $txt\n";
    }
}

1;

__END__

=pod

=head1 NAME

Net::SMTP::TLS::ButMaintained - An SMTP client supporting TLS and AUTH

=head1 VERSION

version 0.20

=head1 SYNOPSIS

 use Net::SMTP::TLS::ButMaintained;
 my $mailer = Net::SMTP::TLS::ButMaintained->new(
 	'your.mail.host',
	Hello	=>	'some.host.name',
 	Port	=>	25, #redundant
 	User	=>	'emailguy',
 	Password=>	's3cr3t');
 $mailer->mail('emailguy@your.mail.host');
 $mailer->to('someonecool@somewhere.else');
 $mailer->data;
 $mailer->datasend("Sent thru TLS!");
 $mailer->dataend;
 $mailer->quit;

=head1 DESCRIPTION

B<Net::SMTP::TLS::ButMaintained> is forked from L<Net::SMTP::TLS>. blame C<Evan Carroll> for the idea. :)

B<Net::SMTP::TLS::ButMaintained> is a TLS and AUTH capable SMTP client which offers an interface that users will find familiar from L<Net::SMTP>. B<Net::SMTP::TLS::ButMaintained> implements a subset of the methods provided by that module, but certainly not (yet) a complete mirror image of that API.

The methods supported by B<Net::SMTP::TLS::ButMaintained> are used in the above example. Though self explanatory for the most part, please see the perldoc for L<Net::SMTP> if you are unclear.

The differences in the methods provided are as follows:

=over

The I<mail> method does not take the options list taken by L<Net::SMTP>

The I<to> method also does not take options, and is the only method available to set the recipient (unlike the many synonyms provided by L<Net::SMTP>).

The constructor takes a limited number of L<Net::SMTP>'s parameters. The constructor for B<Net::SMTP::TLS::ButMaintained> takes the following (in addition to the hostname of the mail server, which must be the first parameter and is not explicitly named):

=over

NoTLS - In the unlikely event that you need to use this class to perform non-TLS SMTP (you ought to be using Net::SMTP itself for that...), this will turn off TLS when supplied with a true value. This will most often cause an error related to authentication when used on a server that requires TLS

Hello - hostname used in the EHLO command

Port - port to connect to the SMTP service (defaults to 25)

Timeout - Timeout for inital socket connection (defaults to 5, passed directly to L<IO::Socket::INET>)

User - username for SMTP AUTH

Password - password for SMTP AUTH

=back

=back

=head2 TLS and AUTHentication

During construction of an B<Net::SMTP::TLS::ButMaintained> instance, the full login process will occur. This involves first sending EHLO to the server, then initiating a TLS session through STARTTLS. Once this is complete, the module will attempt to login using the credentials supplied by the constructor, if such credentials have been supplied.

The AUTH method will depend on the features returned by the server after the EHLO command. Based on that, CRAM-MD5 will be used if available, followed by LOGIN, followed by PLAIN. Please note that LOGIN is the only method of authentication that has been tested. CRAM-MD5 and PLAIN login functionality was taken directly from the script mentioned in the acknowledgements section, however, I have not tested them personally.

=head2 ERROR HANDLING

This module will croak in the event of an SMTP error. Should you wish to handle this gracefully in your application, you may wrap your mail transmission in an eval {} block and check $@ afterward.

=head2 ACKNOWLEDGEMENTS

This code was blatantly plagiarized from Michal Ludvig's smtp-client.pl script. See L<http://www.logix.cz/michal/devel/smtp> for his excellent work.

Improvements courtesy of Tomek Zielinski

=head1 AUTHORS

=over 4

=item *

Alexander Christian Westholm <awestholm at verizon dawt net>

=item *

Fayland Lam <fayland@gmail.com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Alexander Christian Westholm, Fayland Lam.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
