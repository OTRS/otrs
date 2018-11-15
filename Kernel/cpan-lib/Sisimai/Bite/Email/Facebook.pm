package Sisimai::Bite::Email::Facebook;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['This message was created automatically by Facebook.'],
    'rfc822'  => ['Content-Disposition: inline'],
};
my $ErrorCodes = {
    # http://postmaster.facebook.com/response_codes
    # NOT TESTD EXCEPT RCP-P2
    'userunknown' => [
        'RCP-P1',   # The attempted recipient address does not exist.
        'INT-P1',   # The attempted recipient address does not exist.
        'INT-P3',   # The attempted recpient group address does not exist.
        'INT-P4',   # The attempted recipient address does not exist.
    ],
    'filtered' => [
        'RCP-P2',   # The attempted recipient's preferences prevent messages from being delivered.
        'RCP-P3',   # The attempted recipient's privacy settings blocked the delivery.
    ],
    'mesgtoobig' => [
        'MSG-P1',   # The message exceeds Facebook's maximum allowed size.
        'INT-P2',   # The message exceeds Facebook's maximum allowed size.
    ],
    'contenterror' => [
        'MSG-P2',   # The message contains an attachment type that Facebook does not accept.
        'MSG-P3',   # The message contains multiple instances of a header field that can only be present once. Please see RFC 5322, section 3.6 for more information
        'POL-P6',   # The message contains a url that has been blocked by Facebook.
        'POL-P7',   # The message does not comply with Facebook's abuse policies and will not be accepted.
    ],
    'securityerror' => [
        'POL-P1',   # Your mail server's IP Address is listed on the Spamhaus PBL.
        'POL-P2',   # Facebook will no longer accept mail from your mail server's IP Address.
        'POL-P5',   # The message contains a virus.
        'POL-P7',   # The message does not comply with Facebook's Domain Authentication requirements.
    ],
    'notaccept' => [
        'POL-P3',   # Facebook is not accepting messages from your mail server. This will persist for 4 to 8 hours.
        'POL-P4',   # Facebook is not accepting messages from your mail server. This will persist for 24 to 48 hours.
        'POL-T1',   # Facebook is not accepting messages from your mail server, but they may be retried later. This will persist for 1 to 2 hours.
        'POL-T2',   # Facebook is not accepting messages from your mail server, but they may be retried later. This will persist for 4 to 8 hours.
        'POL-T3',   # Facebook is not accepting messages from your mail server, but they may be retried later. This will persist for 24 to 48 hours.
    ],
    'rejected' => [
        'DNS-P1',   # Your SMTP MAIL FROM domain does not exist.
        'DNS-P2',   # Your SMTP MAIL FROM domain does not have an MX record.
        'DNS-T1',   # Your SMTP MAIL FROM domain exists but does not currently resolve.
        'DNS-P3',   # Your mail server does not have a reverse DNS record.
        'DNS-T2',   # You mail server's reverse DNS record does not currently resolve.
    ],
    'systemerror' => [
        'CON-T1',   # Facebook's mail server currently has too many connections open to allow another one.
    ],
    'toomanyconn' => [
        'CON-T3',   # Your mail server has opened too many new connections to Facebook's mail servers in a short period of time.
    ],
    'suspend' => [
        'RCP-T4',   # The attempted recipient address is currently deactivated. The user may or may not reactivate it.
    ],
    'undefined' => [
        'RCP-T1',   # The attempted recipient address is not currently available due to an internal system issue. This is a temporary condition.
        'MSG-T1',   # The number of recipients on the message exceeds Facebook's allowed maximum.
        'CON-T2',   # Your mail server currently has too many connections open to Facebook's mail servers.
        'CON-T4',   # Your mail server has exceeded the maximum number of recipients for its current connection.
    ],
};

sub description { 'Facebook: https://www.facebook.com' }
sub scan {
    # Detect an error from Facebook
    # @param         [Hash] mhead       Message headers of a bounce email
    # @options mhead [String] from      From header
    # @options mhead [String] date      Date header
    # @options mhead [String] subject   Subject header
    # @options mhead [Array]  received  Received headers
    # @options mhead [String] others    Other required headers
    # @param         [String] mbody     Message body of a bounce email
    # @return        [Hash, Undef]      Bounce data list and message/rfc822 part
    #                                   or Undef if it failed to parse or the
    #                                   arguments are missing
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless $mhead->{'from'} eq 'Facebook <mailer-daemon@mx.facebook.com>';
    return undef unless $mhead->{'subject'} eq 'Sorry, your message could not be delivered';

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $fbresponse = '';    # (String) Response code from Facebook
    my $connvalues = 0;     # (Integer) Flag, 1 if all the value of $connheader have been set
    my $connheader = {
        'date'    => '',    # The value of Arrival-Date header
        'lhost'   => '',    # The value of Reporting-MTA header
    };
    my $v = undef;
    my $p = '';

    for my $e ( @hasdivided ) {
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            if( index($e, $StartingOf->{'message'}->[0]) == 0 ) {
                $readcursor |= $Indicators->{'deliverystatus'};
                next;
            }
        }

        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( index($e, $StartingOf->{'rfc822'}->[0]) == 0 ) {
                $readcursor |= $Indicators->{'message-rfc822'};
                next;
            }
        }

        if( $readcursor & $Indicators->{'message-rfc822'} ) {
            # After "message/rfc822"
            unless( length $e ) {
                $blanklines++;
                last if $blanklines > 1;
                next;
            }
            push @$rfc822list, $e;

        } else {
            # Before "message/rfc822"
            next unless $readcursor & $Indicators->{'deliverystatus'};
            next unless length $e;

            if( $connvalues == scalar(keys %$connheader) ) {
                # Reporting-MTA: dns; 10.138.205.200
                # Arrival-Date: Thu, 23 Jun 2011 02:29:43 -0700
                $v = $dscontents->[-1];

                if( $e =~ /\AFinal-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ) {
                    # Final-Recipient: RFC822; userunknown@example.jp
                    if( $v->{'recipient'} ) {
                        # There are multiple recipient addresses in the message body.
                        push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                        $v = $dscontents->[-1];
                    }
                    $v->{'recipient'} = $1;
                    $recipients++;

                } elsif( $e =~ /\AX-Actual-Recipient:[ ]*(?:RFC|rfc)822;[ ]*(.+)\z/ ) {
                    # X-Actual-Recipient: RFC822; kijitora@example.co.jp
                    $v->{'alias'} = $1;

                } elsif( $e =~ /\AAction:[ ]*(.+)\z/ ) {
                    # Action: failed
                    $v->{'action'} = lc $1;

                } elsif( $e =~ /\AStatus:[ ]*(\d[.]\d+[.]\d+)/ ) {
                    # Status: 5.1.1
                    # Status:5.2.0
                    # Status: 5.1.0 (permanent failure)
                    $v->{'status'} = $1;

                } elsif( $e =~ /\ARemote-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                    # Remote-MTA: DNS; mx.example.jp
                    $v->{'rhost'} = lc $1;

                } elsif( $e =~ /\ALast-Attempt-Date:[ ]*(.+)\z/ ) {
                    # Last-Attempt-Date: Fri, 14 Feb 2014 12:30:08 -0500
                    $v->{'date'} = $1;

                } else {
                    if( $e =~ /\ADiagnostic-Code:[ ]*(.+?);[ ]*(.+)\z/ ) {
                        # Diagnostic-Code: smtp; 550 5.1.1 RCP-P2 
                        #     http://postmaster.facebook.com/response_codes?ip=192.0.2.135#rcp Refused due to recipient preferences
                        $v->{'spec'} = uc $1;
                        $v->{'diagnosis'} = $2;

                    } elsif( index($p, 'Diagnostic-Code:') == 0 && $e =~ /\A[ \t]+(.+)\z/ ) {
                        # Continued line of the value of Diagnostic-Code header
                        $v->{'diagnosis'} .= ' '.$1;
                        $e = 'Diagnostic-Code: '.$e;
                    }
                }
            } else {
                if( $e =~ /\AReporting-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                    # Reporting-MTA: dns; mx.example.jp
                    next if $connheader->{'lhost'};
                    $connheader->{'lhost'} = lc $1;
                    $connvalues++;

                } elsif( $e =~ /\AArrival-Date:[ ]*(.+)\z/ ) {
                    # Arrival-Date: Wed, 29 Apr 2009 16:03:18 +0900
                    next if $connheader->{'date'};
                    $connheader->{'date'} = $1;
                    $connvalues++;
                }
            }
        } # End of if: rfc822
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'lhost'}   ||= $connheader->{'lhost'};
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        if( $e->{'diagnosis'} =~ /\b([A-Z]{3})[-]([A-Z])(\d)\b/ ) {
            # Diagnostic-Code: smtp; 550 5.1.1 RCP-P2 
            my $lhs = $1;
            my $rhs = $2;
            my $num = $3;
            $fbresponse = sprintf("%s-%s%d", $lhs, $rhs, $num);
        }

        SESSION: for my $r ( keys %$ErrorCodes ) {
            # Verify each regular expression of session errors
            PATTERN: for my $rr ( @{ $ErrorCodes->{ $r } } ) {
                # Check each regular expression
                next(PATTERN) unless $fbresponse eq $rr;
                $e->{'reason'} = $r;
                last(SESSION);
            }
        }

        # http://postmaster.facebook.com/response_codes
        #   Facebook System Resource Issues
        #   These codes indicate a temporary issue internal to Facebook's 
        #   system. Administrators observing these issues are not required to
        #   take any action to correct them.
        next if $e->{'reason'};

        # * INT-Tx
        #
        # https://groups.google.com/forum/#!topic/cdmix/eXfi4ddgYLQ
        # This block has not been tested because we have no email sample
        # including "INT-T?" error code.
        next unless $fbresponse =~ /\AINT-T\d+\z/;
        $e->{'reason'} = 'systemerror';
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::Facebook - bounce mail parser class for C<Facebook>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::Facebook;

=head1 DESCRIPTION

Sisimai::Bite::Email::Facebook parses a bounce email which created by C<Facebook>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::Facebook->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::Facebook->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
