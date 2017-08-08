package Sisimai::MTA::X4;
use parent 'Sisimai::MTA';
use feature ':5.10';
use strict;
use warnings;

my $Re0 = {
    'subject'  => qr{\A(?:
         failure[ ]notice
        |Permanent[ ]Delivery[ ]Failure
        )
    }xi,
    'received' => qr/\A[(]qmail[ ]+\d+[ ]+invoked[ ]+for[ ]+bounce[)]/,
};
#  qmail-remote.c:248|    if (code >= 500) {
#  qmail-remote.c:249|      out("h"); outhost(); out(" does not like recipient.\n");
#  qmail-remote.c:265|  if (code >= 500) quit("D"," failed on DATA command");
#  qmail-remote.c:271|  if (code >= 500) quit("D"," failed after I sent the message");
#
# Characters: K,Z,D in qmail-qmqpc.c, qmail-send.c, qmail-rspawn.c
#  K = success, Z = temporary error, D = permanent error
#
# MTA module for qmail clones
my $Re1 = {
    'begin'  => qr{\A(?>
         He/Her[ ]is[ ]not.+[ ]user
        |Hi[.][ ].+[ ]unable[ ]to[ ]deliver[ ]your[ ]message[ ]to[ ]the[ ]following[ ]addresses
        |Su[ ]mensaje[ ]no[ ]pudo[ ]ser[ ]entregado
        |This[ ]is[ ]the[ ](?:
             machine[ ]generated[ ]message[ ]from[ ]mail[ ]service
            |mail[ ]delivery[ ]agent[ ]at
            )
        |Unable[ ]to[ ]deliver[ ]message[ ]to[ ]the[ ]following[ ]address
        |Unfortunately,[ ]your[ ]mail[ ]was[ ]not[ ]delivered[ ]to[ ]the[ ]following[ ]address:
        |Your[ ](?:
             mail[ ]message[ ]to[ ]the[ ]following[ ]address
            |message[ ]to[ ]the[ ]following[ ]addresses
            )
        |We're[ ]sorry[.]
        )
    }ix,
    'rfc822' => qr{\A(?:
         ---[ ]Below[ ]this[ ]line[ ]is[ ]a[ ]copy[ ]of[ ]the[ ]message[.]
        |---[ ]Original[ ]message[ ]follows[.]
        )
    }xi,
    'error'  => qr/\ARemote host said:/,
    'sorry'  => qr/\A[Ss]orry[,.][ ]/,
    'endof'  => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
};

my $ReSMTP = {
    # Error text regular expressions which defined in qmail-remote.c
    # qmail-remote.c:225|  if (smtpcode() != 220) quit("ZConnected to "," but greeting failed");
    'conn'  => qr/(?:Error:)?Connected[ ]to[ ].+[ ]but[ ]greeting[ ]failed[.]/x,
    # qmail-remote.c:231|  if (smtpcode() != 250) quit("ZConnected to "," but my name was rejected");
    'ehlo'  => qr/(?:Error:)?Connected[ ]to[ ].+[ ]but[ ]my[ ]name[ ]was[ ]rejected[.]/x,
    # qmail-remote.c:238|  if (code >= 500) quit("DConnected to "," but sender was rejected");
    # reason = rejected
    'mail'  => qr/(?:Error:)?Connected[ ]to[ ].+[ ]but[ ]sender[ ]was[ ]rejected[.]/x,
    # qmail-remote.c:249|  out("h"); outhost(); out(" does not like recipient.\n");
    # qmail-remote.c:253|  out("s"); outhost(); out(" does not like recipient.\n");
    # reason = userunknown
    'rcpt'  => qr/(?:Error:)?.+[ ]does[ ]not[ ]like[ ]recipient[.]/x,
    # qmail-remote.c:265|  if (code >= 500) quit("D"," failed on DATA command");
    # qmail-remote.c:266|  if (code >= 400) quit("Z"," failed on DATA command");
    # qmail-remote.c:271|  if (code >= 500) quit("D"," failed after I sent the message");
    # qmail-remote.c:272|  if (code >= 400) quit("Z"," failed after I sent the message");
    'data'  => qr{(?:
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

my $ReLDAP = {
    # qmail-ldap-1.03-20040101.patch:19817 - 19866
    'suspend'     => qr/Mailaddress is administrative?le?y disabled/,            # 5.2.1
    'userunknown' => qr/[Ss]orry, no mailbox here by that name/,                 # 5.1.1
    'exceedlimit' => qr/The message exeeded the maximum size the user accepts/,  # 5.2.3
    'systemerror' => qr{(?>
         Automatic[ ]homedir[ ]creator[ ]crashed                    # 4.3.0
        |Illegal[ ]value[ ]in[ ]LDAP[ ]attribute                    # 5.3.5
        |LDAP[ ]attribute[ ]is[ ]not[ ]given[ ]but[ ]mandatory      # 5.3.5
        |Timeout[ ]while[ ]performing[ ]search[ ]on[ ]LDAP[ ]server # 4.4.3
        |Too[ ]many[ ]results[ ]returned[ ]but[ ]needs[ ]to[ ]be[ ]unique # 5.3.5
        |Permanent[ ]error[ ]while[ ]executing[ ]qmail[-]forward    # 5.4.4
        |Temporary[ ](?:
             error[ ](?:
                 in[ ]automatic[ ]homedir[ ]creation    # 4.3.0 or 5.3.0
                |while[ ]executing[ ]qmail[-]forward    # 4.4.4
                )
            |failure[ ]in[ ]LDAP[ ]lookup               # 4.4.3
            )
        |Unable[ ]to[ ](?:
             contact[ ]LDAP[ ]server                            # 4.4.3
            |login[ ]into[ ]LDAP[ ]server,[ ]bad[ ]credentials  # 4.4.3
            )
        )
    }x,
};

# userunknown + expired
my $ReOnHold  = qr/\A[^ ]+ does not like recipient[.][ \t]+.+this message has been in the queue too long[.]\z/;

# qmail-remote-fallback.patch
my $ReCommand = qr/Sorry,[ ]no[ ]SMTP[ ]connection[ ]got[ ]far[ ]enough;[ ]most[ ]progress[ ]was[ ]([A-Z]{4})[ ]/x;
my $ReFailure = {
    # qmail-local.c:589|  strerr_die1x(100,"Sorry, no mailbox here by that name. (#5.1.1)");
    # qmail-remote.c:253|  out("s"); outhost(); out(" does not like recipient.\n");
    'userunknown' => qr{(?:
         no[ ]mailbox[ ]here[ ]by[ ]that[ ]name
        |[ ]does[ ]not[ ]like[ ]recipient[.]
        )
    }x,
    # error_str.c:192|  X(EDQUOT,"disk quota exceeded")
    'mailboxfull' => qr/disk[ ]quota[ ]exceeded/x,
    # qmail-qmtpd.c:233| ... result = "Dsorry, that message size exceeds my databytes limit (#5.3.4)";
    # qmail-smtpd.c:391| ... out("552 sorry, that message size exceeds my databytes limit (#5.3.4)\r\n"); return;
    'mesgtoobig'  => qr/Message[ ]size[ ]exceeds[ ]fixed[ ]maximum[ ]message[ ]size:/x,
    # qmail-remote.c:68|  Sorry, I couldn't find any host by that name. (#4.1.2)\n"); zerodie();
    # qmail-remote.c:78|  Sorry, I couldn't find any host named ");
    'hostunknown' => qr/\ASorry[,][ ]I[ ]couldn[']t[ ]find[ ]any[ ]host[ ]/x,
    'systemerror' => qr{(?>
         bad[ ]interpreter:[ ]No[ ]such[ ]file[ ]or[ ]directory
        |system[ ]error
        |Unable[ ]to\b
        )
    }x,
    'networkerror' => qr{Sorry(?:
         [,][ ]I[ ]wasn[']t[ ]able[ ]to[ ]establish[ ]an[ ]SMTP[ ]connection
        |[,][ ]I[ ]couldn[']t[ ]find[ ]a[ ]mail[ ]exchanger[ ]or[ ]IP[ ]address
        |[.][ ]Although[ ]I[']m[ ]listed[ ]as[ ]a[ ]best[-]preference[ ]MX[ ]
            or[ ]A[ ]for[ ]that[ ]host
        )
    }x,
    'systemfull' => qr/Requested action not taken: mailbox unavailable [(]not enough free space[)]/,
};

# qmail-send.c:922| ... (&dline[c],"I'm not going to try again; this message has been in the queue too long.\n")) nomem();
my $ReDelayed  = qr{this[ ]message[ ]has[ ]been[ ]in[ ]the[ ]queue[ ]too[ ]long[.]\z}x;
my $Indicators = __PACKAGE__->INDICATORS;

sub pattern     { return $Re0 }
sub description { 'Unknown MTA #4 qmail clones' }

sub scan {
    # Detect an error from Unknown MTA #4, qmail clones
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
    # @since v4.1.23
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;

    # Pre process email headers and the body part of the message which generated
    # by qmail, see http://cr.yp.to/qmail.html
    #   e.g.) Received: (qmail 12345 invoked for bounce); 29 Apr 2009 12:34:56 -0000
    #         Subject: failure notice
    $match ||= 1 if $mhead->{'subject'} =~ $Re0->{'subject'};
    $match ||= 1 if grep { $_ =~ $Re0->{'received'} } @{ $mhead->{'received'} };
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

            # <kijitora@example.jp>:
            # 192.0.2.153 does not like recipient.
            # Remote host said: 550 5.1.1 <kijitora@example.jp>... User Unknown
            # Giving up on 192.0.2.153.
            $v = $dscontents->[-1];

            if( $e =~ m/\A(?:To[ ]*:)?[<](.+[@].+)[>]:[ \t]*\z/ ) {
                # <kijitora@example.jp>:
                if( length $v->{'recipient'} ) {
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
                $v->{'alterrors'}  = $e if $e =~ $Re1->{'error'};

                next if $v->{'rhost'};
                $v->{'rhost'} = $1 if $e =~ $ReHost;
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    require Sisimai::String;
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
                $e->{'command'} = uc $1 if $e->{'diagnosis'} =~ $ReCommand;
            }
        }

        # Detect the reason of bounce
        if( $e->{'command'} eq 'MAIL' ) {
            # MAIL | Connected to 192.0.2.135 but sender was rejected.
            $e->{'reason'} = 'rejected';

        } elsif( $e->{'command'} =~ m/\A(?:HELO|EHLO)\z/ ) {
            # HELO | Connected to 192.0.2.135 but my name was rejected.
            $e->{'reason'} = 'blocked';

        } else {
            # Try to match with each error message in the table
            if( $e->{'diagnosis'} =~ $ReOnHold ) {
                # To decide the reason require pattern match with 
                # Sisimai::Reason::* modules
                $e->{'reason'} = 'onhold';

            } else {
                SESSION: for my $r ( keys %$ReFailure ) {
                    # Verify each regular expression of session errors
                    if( $e->{'alterrors'} ) {
                        # Check the value of "alterrors"
                        next unless $e->{'alterrors'} =~ $ReFailure->{ $r };
                        $e->{'reason'} = $r;
                    }
                    last if $e->{'reason'};

                    next unless $e->{'diagnosis'} =~ $ReFailure->{ $r };
                    $e->{'reason'} = $r;
                    last;
                }

                unless( $e->{'reason'} ) {
                    LDAP: for my $r ( keys %$ReLDAP ) {
                        # Verify each regular expression of LDAP errors
                        next unless $e->{'diagnosis'} =~ $ReLDAP->{ $r };
                        $e->{'reason'} = $r;
                        last;
                    }
                }

                unless( $e->{'reason'} ) {
                    $e->{'reason'} = 'expired' if $e->{'diagnosis'} =~ $ReDelayed;
                }
            }
        }
        $e->{'command'} ||= '';
        $e->{'agent'}  = __PACKAGE__->smtpagent;
    }

    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::MTA::X4 - bounce mail parser class for Unknown MTA which is developed
as a C<qmail> clone.

=head1 SYNOPSIS

    use Sisimai::MTA::X4;

=head1 DESCRIPTION

Sisimai::MTA::X4 parses a bounce email which created by some C<qmail> clone.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::MTA::X4->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::MTA::X4->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

