package Sisimai::Bite::Email::MessageLabs;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['Content-Type: message/delivery-status'],
    'rfc822'  => ['Content-Type: text/rfc822-headers'],
};
my $ReFailures = {
    'userunknown'   => qr/(?:542 .+ Rejected|No such user)/,
    'securityerror' => qr/Please turn on SMTP Authentication in your mail client/,
};

# X-Msg-Ref: server-11.tower-143.messagelabs.com!1419367175!36473369!1
# X-Originating-IP: [10.245.230.38]
# X-StarScan-Received:
# X-StarScan-Version: 6.12.5; banners=-,-,-
# X-VirusChecked: Checked
sub headerlist  { return ['X-Msg-Ref'] }
sub description { 'Symantec.cloud http://www.messagelabs.com' }
sub scan {
    # Detect an error from MessageLabs.com
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
    # @since v4.1.10
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless defined $mhead->{'x-msg-ref'};
    return undef unless rindex($mhead->{'from'}, 'MAILER-DAEMON@messagelabs.com') > -1;
    return undef unless index($mhead->{'subject'}, 'Mail Delivery Failure') == 0;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $connvalues = 0;     # (Integer) Flag, 1 if all the value of $connheader have been set
    my $connheader = {
        'date'  => '',      # The value of Arrival-Date header
        'lhost' => '',      # The value of Reporting-MTA header
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
            if( $e eq $StartingOf->{'rfc822'}->[0] ) {
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
                # This is the mail delivery agent at messagelabs.com.
                # 
                # I was unable to deliver your message to the following addresses:
                # 
                # maria@dest.example.net
                # 
                # Reason: 550 maria@dest.example.net... No such user
                # 
                # The message subject was: Re: BOAS FESTAS!
                # The message date was: Tue, 23 Dec 2014 20:39:24 +0000
                # The message identifier was: DB/3F-17375-60D39495
                # The message reference was: server-5.tower-143.messagelabs.com!1419367172!32=
                # 691968!1
                # 
                # Please do not reply to this email as it is sent from an unattended mailbox.
                # Please visit www.messagelabs.com/support for more details
                # about this error message and instructions to resolve this issue.
                # 
                # 
                # --b0Nvs+XKfKLLRaP/Qo8jZhQPoiqeWi3KWPXMgw==
                # Content-Type: message/delivery-status
                # 
                # Reporting-MTA: dns; server-15.bemta-3.messagelabs.com
                # Arrival-Date: Tue, 23 Dec 2014 20:39:34 +0000
                # 
                # Action: failed
                # Status: 5.0.0
                # Last-Attempt-Date: Tue, 23 Dec 2014 20:39:35 +0000
                # Remote-MTA: dns; mail.dest.example.net
                # Diagnostic-Code: smtp; 550 maria@dest.example.net... No such user
                # Final-Recipient: rfc822; maria@dest.example.net
                $v = $dscontents->[-1];

                if( $e =~ /\AFinal-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ) {
                    # Final-Recipient: rfc822; maria@dest.example.net
                    if( $v->{'recipient'} ) {
                        # There are multiple recipient addresses in the message body.
                        push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                        $v = $dscontents->[-1];
                    }
                    $v->{'recipient'} = $1;
                    $recipients++;

                } elsif( $e =~ /\AAction:[ ]*(.+)\z/ ) {
                    # Action: failed
                    $v->{'action'} = lc $1;

                } elsif( $e =~ /\AStatus:[ ]*(\d[.]\d+[.]\d+)/ ) {
                    # Status: 5.0.0
                    $v->{'status'} = $1;

                } else {
                    if( $e =~ /\ADiagnostic-Code:[ ]*(.+?);[ ]*(.+)\z/ ) {
                        # Diagnostic-Code: smtp; 550 maria@dest.example.net... No such user
                        $v->{'spec'} = uc $1;
                        $v->{'diagnosis'} = $2;

                    } elsif( index($p, 'Diagnostic-Code:') == 0 && $e =~ /\A[ \t]+(.+)\z/ ) {
                        # Continued line of the value of Diagnostic-Code header
                        $v->{'diagnosis'} .= ' '.$1;
                        $e = 'Diagnostic-Code: '.$e;
                    }
                }
            } else {
                # Reporting-MTA: dns; server-15.bemta-3.messagelabs.com
                # Arrival-Date: Tue, 23 Dec 2014 20:39:34 +0000
                if( $e =~ /\AReporting-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                    # Reporting-MTA: dns; server-15.bemta-3.messagelabs.com
                    next if $connheader->{'lhost'};
                    $connheader->{'lhost'} = lc $1;
                    $connvalues++;

                } elsif( $e =~ /\AArrival-Date:[ ]*(.+)\z/ ) {
                    # Arrival-Date: Tue, 23 Dec 2014 20:39:34 +0000
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
        # Set default values if each value is empty.
        map { $e->{ $_ } ||= $connheader->{ $_ } || '' } keys %$connheader;
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        SESSION: for my $r ( keys %$ReFailures ) {
            # Verify each regular expression of session errors
            next unless $e->{'diagnosis'} =~ $ReFailures->{ $r };
            $e->{'reason'} = $r;
            last;
        }
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::MessageLabs - bounce mail parser class for C<MessageLabs>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::MessageLabs;

=head1 DESCRIPTION

Sisimai::Bite::Email::MessageLabs parses a bounce email which created by C<Symantec.cloud>:
formerly known as C<MessageLabs>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::MessageLabs->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::MessageLabs->smtpagent;

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

