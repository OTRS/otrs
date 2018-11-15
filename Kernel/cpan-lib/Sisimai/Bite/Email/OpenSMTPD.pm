package Sisimai::Bite::Email::OpenSMTPD;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    # http://www.openbsd.org/cgi-bin/man.cgi?query=smtpd&sektion=8
    # opensmtpd-5.4.2p1/smtpd/
    #   bounce.c/317:#define NOTICE_INTRO \
    #   bounce.c/318:    "    Hi!\n\n"    \
    #   bounce.c/319:    "    This is the MAILER-DAEMON, please DO NOT REPLY to this e-mail.\n"
    #   bounce.c/320:
    #   bounce.c/321:const char *notice_error =
    #   bounce.c/322:    "    An error has occurred while attempting to deliver a message for\n"
    #   bounce.c/323:    "    the following list of recipients:\n\n";
    #   bounce.c/324:
    #   bounce.c/325:const char *notice_warning =
    #   bounce.c/326:    "    A message is delayed for more than %s for the following\n"
    #   bounce.c/327:    "    list of recipients:\n\n";
    #   bounce.c/328:
    #   bounce.c/329:const char *notice_warning2 =
    #   bounce.c/330:    "    Please note that this is only a temporary failure report.\n"
    #   bounce.c/331:    "    The message is kept in the queue for up to %s.\n"
    #   bounce.c/332:    "    You DO NOT NEED to re-send the message to these recipients.\n\n";
    #   bounce.c/333:
    #   bounce.c/334:const char *notice_success =
    #   bounce.c/335:    "    Your message was successfully delivered to these recipients.\n\n";
    #   bounce.c/336:
    #   bounce.c/337:const char *notice_relay =
    #   bounce.c/338:    "    Your message was relayed to these recipients.\n\n";
    #   bounce.c/339:
    'message' => ['    This is the MAILER-DAEMON, please DO NOT REPLY to this'],
    'rfc822'  => ['    Below is a copy of the original message:'],
};
my $MessagesOf = {
    # smtpd/queue.c:221|  envelope_set_errormsg(&evp, "Envelope expired");
    'expired'     => ['Envelope expired'],
    'hostunknown' => [
        # smtpd/mta.c:976|  relay->failstr = "Invalid domain name";
        # smtpd/mta.c:980|  relay->failstr = "Domain does not exist";
        'Invalid domain name',
        'Domain does not exist',
    ],
    # smtp/mta.c:1085|  relay->failstr = "Destination seem to reject all mails";
    'notaccept'   => ['Destination seem to reject all mails'],
    'networkerror'=> [
        #  smtpd/mta.c:972|  relay->failstr = "Temporary failure in MX lookup";
        'Address family mismatch on destination MXs',
        'All routes to destination blocked',
        'bad DNS lookup error code',
        'Could not retrieve source address',
        'Loop detected',
        'Network error on destination MXs',
        'No MX found for domain',
        'No MX found for destination',
        'No valid route to remote MX',
        'No valid route to destination',
        'Temporary failure in MX lookup',
    ],
    # smtpd/mta.c:1013|  relay->failstr = "Could not retrieve credentials";
    'securityerror' => ['Could not retrieve credentials'],
};

sub description { 'OpenSMTPD' }
sub scan {
    # Detect an error from OpenSMTPD
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

    return undef unless index($mhead->{'subject'}, 'Delivery status notification') > -1;
    return undef unless index($mhead->{'from'}, 'Mailer Daemon <') > -1;
    return undef unless grep { rindex($_, ' (OpenSMTPD) with ') > -1 } @{ $mhead->{'received'} };

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
            if( index($e, $StartingOf->{'message'}->[0]) > -1 ) {
                $readcursor |= $Indicators->{'deliverystatus'};
                next;
            }
        }

        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( index($e, $StartingOf->{'rfc822'}->[0]) > -1 ) {
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

            #    Hi!
            #
            #    This is the MAILER-DAEMON, please DO NOT REPLY to this e-mail.
            #
            #    An error has occurred while attempting to deliver a message for
            #    the following list of recipients:
            #
            # kijitora@example.jp: 550 5.2.2 <kijitora@example>... Mailbox Full
            #
            #    Below is a copy of the original message:
            $v = $dscontents->[-1];

            if( $e =~ /\A([^ ]+?[@][^ ]+?):?[ ](.+)\z/ ) {
                # kijitora@example.jp: 550 5.2.2 <kijitora@example>... Mailbox Full
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $v->{'diagnosis'} = $2;
                $recipients++;
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

Sisimai::Bite::Email::OpenSMTPD - bounce mail parser class for C<OpenSMTPD>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::OpenSMTPD;

=head1 DESCRIPTION

Sisimai::Bite::Email::OpenSMTPD parses a bounce email which created by C<OpenSMTPD>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::OpenSMTPD->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::OpenSMTPD->smtpagent;

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
