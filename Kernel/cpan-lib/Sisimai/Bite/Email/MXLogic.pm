package Sisimai::Bite::Email::MXLogic;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

# Based on Sisimai::Bite::Email::Exim
my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['This message was created automatically by mail delivery software.'],
    'rfc822'  => ['Included is a copy of the message header:'],
};

my $ReCommands = [
    qr/SMTP error from remote (?:mail server|mailer) after ([A-Za-z]{4})/,
    qr/SMTP error from remote (?:mail server|mailer) after end of ([A-Za-z]{4})/,
];
my $MessagesOf = {
    'userunknown' => ['user not found'],
    'hostunknown' => [
        'all host address lookups failed permanently',
        'all relevant MX records point to non-existent hosts',
        'Unrouteable address',
    ],
    'mailboxfull' => [
        'mailbox is full',
        'error: quota exceed',
    ],
    'notaccept' => [
        'an MX or SRV record indicated no SMTP service',
        'no host found for existing SMTP connection',
    ],
    'syntaxerror' => [
        'angle-brackets nested too deep',
        'expected word or "<"',
        'domain missing in source-routed address',
        'malformed address:',
    ],
    'systemerror' => [
        'delivery to file forbidden',
        'delivery to pipe forbidden',
        'local delivery failed',
        'LMTP error after ',
    ],
    'contenterror' => ['Too many "Received" headers'],
};
my $DelayedFor = [
    'retry timeout exceeded',
    'No action is required on your part',
    'retry time not reached for any host after a long failure period',
    'all hosts have been failing for a long time and were last tried',
    'Delay reason: ',
    'has been frozen',
    'was frozen on arrival by ',
];

# X-MX-Bounce: mta/src/queue/bounce
# X-MXL-NoteHash: ffffffffffffffff-0000000000000000000000000000000000000000
# X-MXL-Hash: 4c9d4d411993da17-bbd4212b6c887f6c23bab7db4bd87ef5edc00758
sub headerlist  { return ['X-MXL-NoteHash', 'X-MXL-Hash', 'X-MX-Bounce'] }
sub description { 'McAfee SaaS' }
sub scan {
    # Detect an error from MXLogic
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
    # @since v4.1.1
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    # 'message-id' => qr/\A[<]mxl[~][0-9a-f]+/,
    $match ||= 1 if defined $mhead->{'x-mx-bounce'};
    $match ||= 1 if defined $mhead->{'x-mxl-hash'};
    $match ||= 1 if defined $mhead->{'x-mxl-notehash'};
    $match ||= 1 if index($mhead->{'from'}, 'Mail Delivery System') == 0;
    $match ||= 1 if $mhead->{'subject'} =~ qr{(?:
         Mail[ ]delivery[ ]failed(:[ ]returning[ ]message[ ]to[ ]sender)?
        |Warning:[ ]message[ ].+[ ]delayed[ ]+
        |Delivery[ ]Status[ ]Notification
        )
    }x;
    return undef unless $match;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $localhost0 = '';    # (String) Local MTA
    my $v = undef;

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

            # This message was created automatically by mail delivery software.
            #
            # A message that you sent could not be delivered to one or more of its
            # recipients. This is a permanent error. The following address(es) failed:
            #
            #  kijitora@example.jp
            #    SMTP error from remote mail server after RCPT TO:<kijitora@example.jp>:
            #    host neko.example.jp [192.0.2.222]: 550 5.1.1 <kijitora@example.jp>... User Unknown
            $v = $dscontents->[-1];

            if( $e =~ /\A[ \t]*[<]([^ ]+[@][^ ]+)[>]:(.+)\z/ ) {
                # A message that you have sent could not be delivered to one or more
                # recipients.  This is a permanent error.  The following address failed:
                #
                #  <kijitora@example.co.jp>: 550 5.1.1 ...
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $v->{'diagnosis'} = $2;
                $recipients++;

            } elsif( scalar @$dscontents == $recipients ) {
                # Error message
                next unless length $e;
                $v->{'diagnosis'} .= $e.' ';
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    if( scalar @{ $mhead->{'received'} } ) {
        # Get the name of local MTA
        # Received: from marutamachi.example.org (c192128.example.net [192.0.2.128])
        $localhost0 = $1 if $mhead->{'received'}->[-1] =~ /from[ \t]([^ ]+) /;
    }

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        $e->{'lhost'} ||= $localhost0;

        $e->{'diagnosis'} =~ s/[-]{2}.*\z//g;
        $e->{'diagnosis'} =  Sisimai::String->sweep($e->{'diagnosis'});

        unless( $e->{'rhost'} ) {
            # Get the remote host name
            # host neko.example.jp [192.0.2.222]: 550 5.1.1 <kijitora@example.jp>... User Unknown
            $e->{'rhost'} = $1 if $e->{'diagnosis'} =~ /host[ \t]+([^ \t]+)[ \t]\[.+\]:[ \t]/;

            unless( $e->{'rhost'} ) {
                if( scalar @{ $mhead->{'received'} } ) {
                    # Get localhost and remote host name from Received header.
                    $e->{'rhost'} = pop @{ Sisimai::RFC5322->received($mhead->{'received'}->[-1]) };
                }
            }
        }

        unless( $e->{'command'} ) {
            # Get the SMTP command name for the session
            SMTP: for my $r ( @$ReCommands ) {
                # Verify each regular expression of SMTP commands
                next unless $e->{'diagnosis'} =~ $r;
                $e->{'command'} = uc $1;
                last;
            }

            # Detect the reason of bounce
            if( $e->{'command'} eq 'MAIL' ) {
                # MAIL | Connected to 192.0.2.135 but sender was rejected.
                $e->{'reason'} = 'rejected';

            } elsif( $e->{'command'} eq 'HELO' || $e->{'command'} eq 'EHLO' ) {
                # HELO | Connected to 192.0.2.135 but my name was rejected.
                $e->{'reason'} = 'blocked';

            } else {
                # Verify each regular expression of session errors
                SESSION: for my $r ( keys %$MessagesOf ) {
                    # Check each regular expression
                    next unless grep { index($e->{'diagnosis'}, $_) > -1 } @{ $MessagesOf->{ $r } };
                    $e->{'reason'} = $r;
                    last;
                }

                unless( $e->{'reason'} ) {
                    # The reason "expired"
                    $e->{'reason'} = 'expired' if grep { index($e->{'diagnosis'}, $_) > -1 } @$DelayedFor;
                }
            }
        }
        $e->{'command'} ||= '';
        $e->{'agent'}     = __PACKAGE__->smtpagent;
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::MXLogic - bounce mail parser class for C<MX Logic>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::MXLogic;

=head1 DESCRIPTION

Sisimai::Bite::Email::MXLogic parses a bounce email which created by
C<McAfee SaaS (formerly MX Logic)>. Methods in the module are called from only 
Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::MXLogic->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::MXLogic->smtpagent;

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
