package Sisimai::Bite::Email::qmail;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    #  qmail-remote.c:248|    if (code >= 500) {
    #  qmail-remote.c:249|      out("h"); outhost(); out(" does not like recipient.\n");
    #  qmail-remote.c:265|  if (code >= 500) quit("D"," failed on DATA command");
    #  qmail-remote.c:271|  if (code >= 500) quit("D"," failed after I sent the message");
    #
    # Characters: K,Z,D in qmail-qmqpc.c, qmail-send.c, qmail-rspawn.c
    #  K = success, Z = temporary error, D = permanent error
    'message' => ['Hi. This is the qmail'],
    'rfc822'  => ['--- Below this line is a copy of the message.'],
    'error'   => ['Remote host said:'],
};

my $ReSMTP = {
    # Error text regular expressions which defined in qmail-remote.c
    # qmail-remote.c:225|  if (smtpcode() != 220) quit("ZConnected to "," but greeting failed");
    'conn' => qr/(?:Error:)?Connected to .+ but greeting failed[.]/,
    # qmail-remote.c:231|  if (smtpcode() != 250) quit("ZConnected to "," but my name was rejected");
    'ehlo' => qr/(?:Error:)?Connected to .+ but my name was rejected[.]/,
    # qmail-remote.c:238|  if (code >= 500) quit("DConnected to "," but sender was rejected");
    # reason = rejected
    'mail' => qr/(?:Error:)?Connected to .+ but sender was rejected[.]/,
    # qmail-remote.c:249|  out("h"); outhost(); out(" does not like recipient.\n");
    # qmail-remote.c:253|  out("s"); outhost(); out(" does not like recipient.\n");
    # reason = userunknown
    'rcpt' => qr/(?:Error:)?.+ does not like recipient[.]/,
    # qmail-remote.c:265|  if (code >= 500) quit("D"," failed on DATA command");
    # qmail-remote.c:266|  if (code >= 400) quit("Z"," failed on DATA command");
    # qmail-remote.c:271|  if (code >= 500) quit("D"," failed after I sent the message");
    # qmail-remote.c:272|  if (code >= 400) quit("Z"," failed after I sent the message");
    'data' => qr{(?:
         (?:Error:)?.+[ ]failed[ ]on[ ]DATA[ ]command[.]
        |(?:Error:)?.+[ ]failed[ ]after[ ]I[ ]sent[ ]the[ ]message[.]
        )
    }x,
};
my $ReHost = qr{(?:
    # qmail-remote.c:261|  if (!flagbother) quit("DGiving up on ","");
     Giving[ ]up[ ]on[ ](.+[0-9a-zA-Z])[.]?\z
    |Connected[ ]to[ ]([-0-9a-zA-Z.]+[0-9a-zA-Z])[ ]
    |remote[ ]host[ ]([-0-9a-zA-Z.]+[0-9a-zA-Z])[ ]said:
    )
}x;

# qmail-send.c:922| ... (&dline[c],"I'm not going to try again; this message has been in the queue too long.\n")) nomem();
my $HasExpired = 'this message has been in the queue too long.';
# qmail-remote-fallback.patch
my $ReCommands = qr/Sorry, no SMTP connection got far enough; most progress was ([A-Z]{4}) /;
my $ReIsOnHold = qr/\A[^ ]+ does not like recipient[.][ \t]+.+this message has been in the queue too long[.]\z/;
my $FailOnLDAP = {
    # qmail-ldap-1.03-20040101.patch:19817 - 19866
    'suspend'     => ['Mailaddress is administrative?le?y disabled'],   # 5.2.1
    'userunknown' => ['Sorry, no mailbox here by that name'],           # 5.1.1
    'exceedlimit' => ['The message exeeded the maximum size the user accepts'], # 5.2.3
    'systemerror' => [
        'Automatic homedir creator crashed',                # 4.3.0
        'Illegal value in LDAP attribute',                  # 5.3.5
        'LDAP attribute is not given but mandatory',        # 5.3.5
        'Timeout while performing search on LDAP server',   # 4.4.3
        'Too many results returned but needs to be unique', # 5.3.5
        'Permanent error while executing qmail-forward',    # 5.4.4
        'Temporary error in automatic homedir creation',    # 4.3.0 or 5.3.0
        'Temporary error while executing qmail-forward',    # 4.4.4
        'Temporary failure in LDAP lookup',                 # 4.4.3
        'Unable to contact LDAP server',                    # 4.4.3
        'Unable to login into LDAP server, bad credentials',# 4.4.3
    ],
};
my $MessagesOf = {
    # qmail-local.c:589|  strerr_die1x(100,"Sorry, no mailbox here by that name. (#5.1.1)");
    # qmail-remote.c:253|  out("s"); outhost(); out(" does not like recipient.\n");
    'userunknown' => [
        'no mailbox here by that name',
        'does not like recipient.',
    ],
    # error_str.c:192|  X(EDQUOT,"disk quota exceeded")
    'mailboxfull' => ['disk quota exceeded'],
    # qmail-qmtpd.c:233| ... result = "Dsorry, that message size exceeds my databytes limit (#5.3.4)";
    # qmail-smtpd.c:391| ... out("552 sorry, that message size exceeds my databytes limit (#5.3.4)\r\n"); return;
    'mesgtoobig'  => ['Message size exceeds fixed maximum message size:'],
    # qmail-remote.c:68|  Sorry, I couldn't find any host by that name. (#4.1.2)\n"); zerodie();
    # qmail-remote.c:78|  Sorry, I couldn't find any host named ");
    'hostunknown' => ["Sorry, I couldn't find any host "],
    'systemfull'  => ['Requested action not taken: mailbox unavailable (not enough free space)'],
    'systemerror' => [
        'bad interpreter: No such file or directory',
        'system error',
        'Unable to',
    ],
    'networkerror'=> [
        "Sorry, I wasn't able to establish an SMTP connection",
        "Sorry, I couldn't find a mail exchanger or IP address",
        "Sorry. Although I'm listed as a best-preference MX or A for that host",
    ],
};

sub description { 'qmail' }
sub scan {
    # Detect an error from qmail
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
    my $match = 0;
    my $tryto = qr/\A[(]qmail[ ]+\d+[ ]+invoked[ ]+(?:for[ ]+bounce|from[ ]+network)[)]/;

    # Pre process email headers and the body part of the message which generated
    # by qmail, see http://cr.yp.to/qmail.html
    #   e.g.) Received: (qmail 12345 invoked for bounce); 29 Apr 2009 12:34:56 -0000
    #         Subject: failure notice
    $match ||= 1 if $mhead->{'subject'} eq 'failure notice';
    $match ||= 1 if grep { $_ =~ $tryto } @{ $mhead->{'received'} };
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

            # <kijitora@example.jp>:
            # 192.0.2.153 does not like recipient.
            # Remote host said: 550 5.1.1 <kijitora@example.jp>... User Unknown
            # Giving up on 192.0.2.153.
            $v = $dscontents->[-1];

            if( $e =~ /\A(?:To[ ]*:)?[<](.+[@].+)[>]:[ \t]*\z/ ) {
                # <kijitora@example.jp>:
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } elsif( scalar @$dscontents == $recipients ) {
                # Append error message
                next unless length $e;
                $v->{'diagnosis'} .= $e.' ';
                $v->{'alterrors'}  = $e if index($e, $StartingOf->{'error'}->[0]) == 0;

                next if $v->{'rhost'};
                $v->{'rhost'} = $1 if $e =~ $ReHost;
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        if( ! $e->{'command'} ) {
            # Get the SMTP command name for the session
            SMTP: for my $r ( keys %$ReSMTP ) {
                # Verify each regular expression of SMTP commands
                next unless $e->{'diagnosis'} =~ $ReSMTP->{ $r };
                $e->{'command'} = uc $r;
                last;
            }

            unless( $e->{'command'} ) {
                # Verify each regular expression of patches
                $e->{'command'} = uc $1 if $e->{'diagnosis'} =~ $ReCommands;
            }
        }

        # Detect the reason of bounce
        if( $e->{'command'} eq 'MAIL' ) {
            # MAIL | Connected to 192.0.2.135 but sender was rejected.
            $e->{'reason'} = 'rejected';

        } elsif( $e->{'command'} eq 'HELO' || $e->{'command'} eq 'EHLO' ) {
            # HELO | Connected to 192.0.2.135 but my name was rejected.
            $e->{'reason'} = 'blocked';

        } else {
            # Try to match with each error message in the table
            if( $e->{'diagnosis'} =~ $ReIsOnHold ) {
                # To decide the reason require pattern match with 
                # Sisimai::Reason::* modules
                $e->{'reason'} = 'onhold';

            } else {
                SESSION: for my $r ( keys %$MessagesOf ) {
                    # Verify each regular expression of session errors
                    if( $e->{'alterrors'} ) {
                        # Check the value of "alterrors"
                        next unless grep { index($e->{'alterrors'}, $_) > -1 } @{ $MessagesOf->{ $r } };
                        $e->{'reason'} = $r;
                    }
                    last if $e->{'reason'};

                    next unless grep { index($e->{'diagnosis'}, $_) > -1 } @{ $MessagesOf->{ $r } };
                    $e->{'reason'} = $r;
                    last;
                }

                unless( $e->{'reason'} ) {
                    LDAP: for my $r ( keys %$FailOnLDAP ) {
                        # Verify each regular expression of LDAP errors
                        next unless grep { index($e->{'diagnosis'}, $_) > -1 } @{ $FailOnLDAP->{ $r } };
                        $e->{'reason'} = $r;
                        last;
                    }
                }

                unless( $e->{'reason'} ) {
                    $e->{'reason'} = 'expired' if index($e->{'diagnosis'}, $HasExpired) > -1;
                }
            }
        }
        $e->{'command'} ||= '';
        $e->{'status'}    = Sisimai::SMTP::Status->find($e->{'diagnosis'});
        $e->{'agent'}     = __PACKAGE__->smtpagent;
    }

    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::qmail - bounce mail parser class for C<qmail>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::qmail;

=head1 DESCRIPTION

Sisimai::Bite::Email::qmail parses a bounce email which created by C<qmail>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::qmail->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::qmail->smtpagent;

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
