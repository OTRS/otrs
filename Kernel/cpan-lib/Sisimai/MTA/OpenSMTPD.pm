package Sisimai::MTA::OpenSMTPD;
use parent 'Sisimai::MTA';
use feature ':5.10';
use strict;
use warnings;

my $Re0 = {
    'from'     => qr/\AMailer Daemon [<][^ ]+[@]/,
    'subject'  => qr/\ADelivery status notification/,
    'received' => qr/[ ][(]OpenSMTPD[)][ ]with[ ]/,
};
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
my $Re1 = {
    'begin'  => qr/\A[ \t]*This is the MAILER-DAEMON, please DO NOT REPLY to this e[-]?mail[.]\z/,
    'rfc822' => qr/\A[ \t]*Below is a copy of the original message:\z/,
    'endof'  => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
};
my $ReFailure = {
    'expired' => qr{
        # smtpd/queue.c:221|  envelope_set_errormsg(&evp, "Envelope expired");
        Envelope[ ]expired
    }x,
    'hostunknown' => qr{(?:
        # smtpd/mta.c:976|  relay->failstr = "Invalid domain name";
         Invalid[ ]domain[ ]name
        # smtpd/mta.c:980|  relay->failstr = "Domain does not exist";
        |Domain[ ]does[ ]not[ ]exist
        )
    }x,
    'notaccept' => qr{
        # smtp/mta.c:1085|  relay->failstr = "Destination seem to reject all mails";
        Destination[ ]seem[ ]to[ ]reject[ ]all[ ]mails
    }x,
    'networkerror' => qr{(?>
        #  smtpd/mta.c:972|  relay->failstr = "Temporary failure in MX lookup";
         Address[ ]family[ ]mismatch[ ]on[ ]destination[ ]MXs
        |All[ ]routes[ ]to[ ]destination[ ]blocked
        |bad[ ]DNS[ ]lookup[ ]error[ ]code
        |Could[ ]not[ ]retrieve[ ]source[ ]address
        |Loop[ ]detected
        |Network[ ]error[ ]on[ ]destination[ ]MXs
        |No[ ](?>
             MX[ ]found[ ]for[ ](?:domain|destination)
            |valid[ ]route[ ]to[ ](?:remote[ ]MX|destination)
            )
        |Temporary[ ]failure[ ]in[ ]MX[ ]lookup
        )
    }x,
    'securityerror' => qr{
        # smtpd/mta.c:1013|  relay->failstr = "Could not retrieve credentials";
        Could[ ]not[ ]retrieve[ ]credentials
    }x,
};
my $Indicators = __PACKAGE__->INDICATORS;

sub pattern     { return $Re0 }
sub description { 'OpenSMTPD' }

sub scan {
    # Detect an error from OpenSMTPD
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
    # @since v4.0.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless $mhead->{'subject'} =~ $Re0->{'subject'};
    return undef unless $mhead->{'from'}    =~ $Re0->{'from'};
    return undef unless grep { $_ =~ $Re0->{'received'} } @{ $mhead->{'received'} };

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

    for my $e ( @hasdivided ) {
        # Read each line between $Re1->{'begin'} and $Re1->{'rfc822'}.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            if( $e =~ $Re1->{'begin'} ) {
                $readcursor |= $Indicators->{'deliverystatus'};
                next;
            }
        }

        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( $e =~ $Re1->{'rfc822'} ) {
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

            if( $e =~ m/\A([^ ]+?[@][^ ]+?):?[ ](.+)\z/ ) {
                # kijitora@example.jp: 550 5.2.2 <kijitora@example>... Mailbox Full
                if( length $v->{'recipient'} ) {
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
    require Sisimai::String;

    for my $e ( @$dscontents ) {
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        SESSION: for my $r ( keys %$ReFailure ) {
            # Verify each regular expression of session errors
            next unless $e->{'diagnosis'} =~ $ReFailure->{ $r };
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

Sisimai::MTA::OpenSMTPD - bounce mail parser class for C<OpenSMTPD>.

=head1 SYNOPSIS

    use Sisimai::MTA::OpenSMTPD;

=head1 DESCRIPTION

Sisimai::MTA::OpenSMTPD parses a bounce email which created by C<OpenSMTPD>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::MTA::OpenSMTPD->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::MTA::OpenSMTPD->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
