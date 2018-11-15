package Sisimai::Bite::Email::MessagingServer;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = { 'message' => ['This report relates to a message you sent with the following header fields:'] };
my $MarkingsOf = { 'rfc822'  => qr!\A(?:Content-type:[ \t]*message/rfc822|Return-path:[ \t]*)! };
my $MessagesOf = { 'hostunknown' => ['Illegal host/domain name found'] };

sub description { 'Oracle Communications Messaging Server' }
sub scan {
    # Detect an error from Oracle Communications Messaging Server
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
    # @since v4.1.3
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    # 'received' => qr/[ ][(]MessagingServer[)][ ]with[ ]/,
    $match ||= 1 if rindex($mhead->{'content-type'}, 'Boundary_(ID_') > -1;
    $match ||= 1 if index($mhead->{'subject'}, 'Delivery Notification: ') == 0;
    return undef unless $match;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

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
            if( $e =~ $MarkingsOf->{'rfc822'} ) {
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

            # --Boundary_(ID_0000000000000000000000)
            # Content-type: text/plain; charset=us-ascii
            # Content-language: en-US
            # 
            # This report relates to a message you sent with the following header fields:
            # 
            #   Message-id: <CD8C6134-C312-41D5-B083-366F7FA1D752@me.example.com>
            #   Date: Fri, 21 Nov 2014 23:34:45 +0900
            #   From: Shironeko <shironeko@me.example.com>
            #   To: kijitora@example.jp
            #   Subject: Nyaaaaaaaaaaaaaaaaaaaaaan
            # 
            # Your message cannot be delivered to the following recipients:
            # 
            #   Recipient address: kijitora@example.jp
            #   Reason: Remote SMTP server has rejected address
            #   Diagnostic code: smtp;550 5.1.1 <kijitora@example.jp>... User Unknown
            #   Remote system: dns;mx.example.jp (TCP|17.111.174.67|47323|192.0.2.225|25) (6jo.example.jp ESMTP SENDMAIL-VM)
            $v = $dscontents->[-1];

            if( $e =~ /\A[ \t]+Recipient address:[ \t]*([^ ]+[@][^ ]+)\z/ ) {
                #   Recipient address: kijitora@example.jp
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = Sisimai::Address->s3s4($1);
                $recipients++;

            } elsif( $e =~ /\A[ \t]+Original address:[ \t]*([^ ]+[@][^ ]+)\z/ ) {
                #   Original address: kijitora@example.jp
                $v->{'recipient'} = Sisimai::Address->s3s4($1);

            } elsif( $e =~ /\A[ \t]+Date:[ \t]*(.+)\z/ ) {
                #   Date: Fri, 21 Nov 2014 23:34:45 +0900
                $v->{'date'} = $1;

            } elsif( $e =~ /\A[ \t]+Reason:[ \t]*(.+)\z/ ) {
                #   Reason: Remote SMTP server has rejected address
                $v->{'diagnosis'} = $1;

            } elsif( $e =~ /\A[ \t]+Diagnostic code:[ \t]*([^ ]+);(.+)\z/ ) {
                #   Diagnostic code: smtp;550 5.1.1 <kijitora@example.jp>... User Unknown
                $v->{'spec'} = uc $1;
                $v->{'diagnosis'} = $2;

            } elsif( $e =~ /\A[ \t]+Remote system:[ \t]*dns;([^ ]+)[ \t]*([^ ]+)[ \t]*.+\z/ ) {
                #   Remote system: dns;mx.example.jp (TCP|17.111.174.67|47323|192.0.2.225|25)
                #     (6jo.example.jp ESMTP SENDMAIL-VM)
                my $remotehost = $1; # remote host
                my $sessionlog = $2; # smtp session
                $v->{'rhost'} = $remotehost;

                if( $sessionlog =~ /\A[(]TCP|(.+)|\d+|(.+)|\d+[)]/ ) {
                    # The value does not include ".", use IP address instead.
                    # (TCP|17.111.174.67|47323|192.0.2.225|25)
                    $v->{'lhost'} = $1;
                    $v->{'rhost'} = $2 unless $remotehost =~ /[^.]+[.][^.]+/;
                }
            } else {
                # Original-envelope-id: 0NFC009FLKOUVMA0@mr21p30im-asmtp004.me.com
                # Reporting-MTA: dns;mr21p30im-asmtp004.me.com (tcp-daemon)
                # Arrival-date: Thu, 29 Apr 2014 23:34:45 +0000 (GMT)
                # 
                # Original-recipient: rfc822;kijitora@example.jp
                # Final-recipient: rfc822;kijitora@example.jp
                # Action: failed
                # Status: 5.1.1 (Remote SMTP server has rejected address)
                # Remote-MTA: dns;mx.example.jp (TCP|17.111.174.67|47323|192.0.2.225|25)
                #  (6jo.example.jp ESMTP SENDMAIL-VM)
                # Diagnostic-code: smtp;550 5.1.1 <kijitora@example.jp>... User Unknown
                #
                if( $e =~ /\AStatus:[ \t]*(\d[.]\d[.]\d)[ \t]*[(](.+)[)]\z/ ) {
                    # Status: 5.1.1 (Remote SMTP server has rejected address)
                    $v->{'status'} = $1;
                    $v->{'diagnosis'} ||= $2;

                } elsif( $e =~ /\AArrival-Date:[ ]*(.+)\z/ ) {
                    # Arrival-date: Thu, 29 Apr 2014 23:34:45 +0000 (GMT)
                    $v->{'date'} ||= $1;

                } elsif( $e =~ /\AReporting-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                    # Reporting-MTA: dns;mr21p30im-asmtp004.me.com (tcp-daemon)
                    my $localhost = $1;
                    $v->{'lhost'} ||= $localhost;
                    $v->{'lhost'}   = $localhost unless $v->{'lhost'} =~ /[^.]+[.][^ ]+/;
                }
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        SESSION: for my $r ( keys %$MessagesOf ) {
            # Verify each regular expression of session errors
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } @{ $MessagesOf->{ $r } };
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

Sisimai::Bite::Email::MessagingServer - bounce mail parser class for
C<Sun Java System Messaging Server> and C<Oracle Communications Messaging Server>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::MessagingServer;

=head1 DESCRIPTION

Sisimai::Bite::Email::MessagingServer parses a bounce email which created by
C<Oracle Communications Messaging Server> and C<Sun Java System Messaging Server>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::MessagingServer->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::MessagingServer->smtpagent;

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

