package Sisimai::Bite::Email::ReceivingSES;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

# http://aws.amazon.com/ses/
my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['This message could not be delivered.'],
    'rfc822'  => ['content-type: text/rfc822-headers'],
};
my $MessagesOf = {
    # The followings are error messages in Rule sets/*/Actions/Template
    'filtered'     => ['Mailbox does not exist'],
    'mesgtoobig'   => ['Message too large'],
    'mailboxfull'  => ['Mailbox full'],
    'contenterror' => ['Message content rejected'],
};

# X-SES-Outgoing: 2015.10.01-54.240.27.7
# Feedback-ID: 1.us-west-2.HX6/J9OVlHTadQhEu1+wdF9DBj6n6Pa9sW5Y/0pSOi8=:AmazonSES
sub headerlist  { return ['X-SES-Outgoing'] }
sub description { 'Amazon SES(Receiving): http://aws.amazon.com/ses/' };
sub scan {
    # Detect an error from Amazon SES/Receiving
    # @param         [Hash] mhead       Message header of a bounce email
    # @options mhead [String] from      From header
    # @options mhead [String] date      Date header
    # @options mhead [String] subject   Subject header
    # @options mhead [Array]  received  Received headers
    # @options mhead [String] others    Other required headers
    # @param         [String] mbody     Message body of a bounce email
    # @return        [Hash, Undef]      Bounce data list and message/rfc822 part
    #                                   or Undef if it failed to parse or the
    #                                   arguments are missing
    # @since v4.1.29
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # 'subject' => qr/\ADelivery Status Notification [(]Failure[)]\z/,
    # 'received'=> qr/.+[.]smtp-out[.].+[.]amazonses[.]com\b/,
    return undef unless $mhead->{'x-ses-outgoing'};

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
            if( $e eq $StartingOf->{'message'}->[0] ) {
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
                # Action: failed
                # Final-Recipient: rfc822; kijitora@neko.example.jp
                # Original-Recipient: rfc822; kijitora@neko.example.jp
                # Diagnostic-Code: smtp; 550 5.1.1 Mailbox does not exist
                # Status: 5.1.1
                $v = $dscontents->[-1];

                if( $e =~ /\AFinal-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ) {
                    # Final-Recipient: RFC822; kijitora@example.jp
                    if( $v->{'recipient'} ) {
                        # There are multiple recipient addresses in the message body.
                        push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                        $v = $dscontents->[-1];
                    }
                    $v->{'recipient'} = $1;
                    $recipients++;

                } elsif( $e =~ /\AX-Actual-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ||
                         $e =~ /\AOriginal-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ) {
                    # X-Actual-Recipient: RFC822; kijitora@example.co.jp
                    # Original-Recipient: rfc822; kijitora@example.co.jp
                    $v->{'alias'} = $1;

                } elsif( $e =~ /\AAction:[ ]*(.+)\z/ ) {
                    # Action: failed
                    $v->{'action'} = lc $1;

                } elsif( $e =~ /\AStatus:[ ]*(\d[.]\d+[.]\d+)/ ) {
                    # Status: 5.1.1
                    $v->{'status'} = $1;

                } elsif( $e =~ /\ARemote-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                    # Remote-MTA: DNS; mx.example.jp
                    $v->{'rhost'} = lc $1;

                } elsif( $e =~ /\ALast-Attempt-Date:[ ]*(.+)\z/ ) {
                    # Last-Attempt-Date: Fri, 14 Feb 2014 12:30:08 -0500
                    $v->{'date'} = $1;

                } else {
                    if( $e =~ /\ADiagnostic-Code:[ ]*(.+?);[ ]*(.+)\z/ ) {
                        # Diagnostic-Code: SMTP; 550 5.1.1 <kijitora@example.jp>... User Unknown
                        $v->{'spec'} = uc $1;
                        $v->{'diagnosis'} = $2;

                    } elsif( index($p, 'Diagnostic-Code:') == 0 && $e =~ /\A[ \t]+(.+)\z/ ) {
                        # Continued line of the value of Diagnostic-Code header
                        $v->{'diagnosis'} .= ' '.$1;
                        $e = 'Diagnostic-Code: '.$e;
                    }
                }
            } else {
                # This message could not be delivered.
                # ------=_Part_0_1984813963.1443707337938
                # Content-Type: message/delivery-status
                # Content-Transfer-Encoding: 7bit
                # Content-Description: Delivery Status Notification
                #
                # Reporting-MTA: dns; inbound-smtp.us-west-2.amazonaws.com
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
        # Set default values if each value is empty.
        map { $e->{ $_ } ||= $connheader->{ $_ } || '' } keys %$connheader;

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
        $e->{'reason'} ||= Sisimai::SMTP::Status->name($e->{'status'});
        $e->{'agent'}    = __PACKAGE__->smtpagent;
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::ReceivingSES - bounce mail parser class for C<Amazon SES>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::ReceivingSES;

=head1 DESCRIPTION

Sisimai::Bite::Email::ReceivingSES parses a bounce email which created by C<Amazon Simple Email Service>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::ReceivingSES->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::ReceivingSES->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

