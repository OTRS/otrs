package Sisimai::Bite::Email::AmazonSES;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

# http://aws.amazon.com/ses/
my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['The following message to <', 'An error occurred while trying to deliver the mail '],
    'rfc822'  => ['content-type: message/rfc822'],
};
my $MessagesOf = { 'expired' => ['Delivery expired'] };

# X-SenderID: Sendmail Sender-ID Filter v1.0.0 nijo.example.jp p7V3i843003008
# X-Original-To: 000001321defbd2a-788e31c8-2be1-422f-a8d4-cf7765cc9ed7-000000@email-bounces.amazonses.com
# X-AWS-Outgoing: 199.255.192.156
# X-SES-Outgoing: 2016.10.12-54.240.27.6
sub headerlist  { return ['X-AWS-Outgoing', 'X-SES-Outgoing', 'x-amz-sns-message-id'] }
sub description { 'Amazon SES(Sending): http://aws.amazon.com/ses/' };
sub scan {
    # Detect an error from Amazon SES
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
    # @since v4.0.2
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;
    my $xmail = $mhead->{'x-mailer'} || '';

    # 'from'    => qr/\AMAILER-DAEMON[@]email[-]bounces[.]amazonses[.]com\z/,
    # 'subject' => qr/\ADelivery Status Notification [(]Failure[)]\z/,
    return undef if index($xmail, 'Amazon WorkMail') > -1;
    $match ||= 1 if $mhead->{'x-aws-outgoing'};
    $match ||= 1 if $mhead->{'x-ses-outgoing'};
    return undef unless $match;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $connvalues = 0;     # (Integer) Flag, 1 if all the value of $connheader have been set
    my $connheader = {
        'lhost'   => '',    # The value of Reporting-MTA header
    };
    my $v = undef;
    my $p = '';

    for my $e ( @hasdivided ) {
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            if( index($e, $StartingOf->{'message'}->[0]) == 0 ||
                index($e, $StartingOf->{'message'}->[1]) == 0 ) {
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
                # Final-Recipient: rfc822;kijitora@example.jp
                # Action: failed
                # Status: 5.0.0 (permanent failure)
                # Remote-MTA: dns; [192.0.2.9]
                # Diagnostic-Code: smtp; 5.1.0 - Unknown address error 550-'5.7.1 
                #  <000001321defbd2a-788e31c8-2be1-422f-a8d4-cf7765cc9ed7-000000@email-bounces.amazonses.com>...
                #  Access denied' (delivery attempts: 0)
                #
                # --JuU8e.4gyIcCrxq.1RFbQY.3Vu7Hs+
                # content-type: message/rfc822
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

                } elsif( $e =~ /\AX-Actual-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ) {
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
                        # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                        $v->{'spec'} = uc $1;
                        $v->{'diagnosis'} = $2;

                    } elsif( index($p, 'Diagnostic-Code:') == 0 && $e =~ /\A[ \t]+(.+)\z/ ) {
                        # Continued line of the value of Diagnostic-Code header
                        $v->{'diagnosis'} .= ' '.$1;
                        $e = 'Diagnostic-Code: '.$e;
                    }
                }
            } else {
                # The following message to <kijitora@example.jp> was undeliverable.
                # The reason for the problem:
                # 5.1.0 - Unknown address error 550-'5.7.1 <0000000000000000-00000000-0000-00=
                # 00-0000-000000000000-000000@email-bounces.amazonses.com>... Access denied'
                #
                # --JuU8e.4gyIcCrxq.1RFbQY.3Vu7Hs+
                # content-type: message/delivery-status
                #
                # Reporting-MTA: dns; a192-79.smtp-out.amazonses.com
                #
                if( $e =~ /\AReporting-MTA:[ ]*[DNSdns]+;[ ]*(.+)\z/ ) {
                    # Reporting-MTA: dns; mx.example.jp
                    next if $connheader->{'lhost'};
                    $connheader->{'lhost'} = lc $1;
                    $connvalues++;
                }
            }
        } # End of if: rfc822
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }

    if( $recipients == 0 && index($$mbody, 'notificationType') > -1 ) {
        # Try to parse with Sisimai::Bite::JSON::AmazonSES module
        require Sisimai::Bite::JSON::AmazonSES;
        my $j = Sisimai::Bite::JSON::AmazonSES->scan($mhead, $mbody);

        if( ref $j->{'ds'} eq 'ARRAY' ) {
            # Update $dscontents
            $dscontents = $j->{'ds'};
            $recipients = scalar @{ $j->{'ds'} };
        }
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        map { $e->{ $_ } ||= $connheader->{ $_ } || '' } keys %$connheader;

        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} =~ s/\\n/ /g;
        $e->{'diagnosis'} =  Sisimai::String->sweep($e->{'diagnosis'});

        if( $e->{'status'} =~ /\A[45][.][01][.]0\z/ ) {
            # Get other D.S.N. value from the error message
            my $pseudostatus = '';
            my $errormessage = $e->{'diagnosis'};

            # 5.1.0 - Unknown address error 550-'5.7.1 ...
            $errormessage = $1 if $e->{'diagnosis'} =~ /["'](\d[.]\d[.]\d.+)['"]/;
            $pseudostatus = Sisimai::SMTP::Status->find($errormessage);
            $e->{'status'} = $pseudostatus if $pseudostatus;
        }

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

Sisimai::Bite::Email::AmazonSES - bounce mail parser class for C<Amazon SES>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::AmazonSES;

=head1 DESCRIPTION

Sisimai::Bite::Email::AmazonSES parses a bounce email which created by C<Amazon Simple Email Service>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::AmazonSES->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::AmazonSES->smtpagent;

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
