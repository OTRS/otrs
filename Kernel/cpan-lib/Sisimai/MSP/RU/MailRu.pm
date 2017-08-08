package Sisimai::MSP::RU::MailRu;
use parent 'Sisimai::MTA';
use feature ':5.10';
use strict;
use warnings;

# Based on Sisimai::MTA::Exim
my $Re0 = {
    'from'      => qr/[<]?mailer-daemon[@].*mail[.]ru[>]?/i,
    'subject'   => qr{(?:
         Mail[ ]delivery[ ]failed(:[ ]returning[ ]message[ ]to[ ]sender)?
        |Warning:[ ]message[ ].+[ ]delayed[ ]+
        |Delivery[ ]Status[ ]Notification
        |Mail[ ]failure
        |Message[ ]frozen
        |error[(]s[)][ ]in[ ]forwarding[ ]or[ ]filtering
        )
    }x,
    'message-id'=> qr/\A[<]\w+[-]\w+[-]\w+[@].*mail[.]ru[>]\z/,
    # Message-Id: <E1P1YNN-0003AD-Ga@*.mail.ru>
};
my $Re1 = {
    'rfc822' => qr/\A------ This is a copy of the message.+headers[.] ------\z/,
    'begin'  => qr/\AThis message was created automatically by mail delivery software[.]/,
    'endof'  => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
};
my $ReCommand = [
    qr/SMTP error from remote (?:mail server|mailer) after ([A-Za-z]{4})/,
    qr/SMTP error from remote (?:mail server|mailer) after end of ([A-Za-z]{4})/,
];
my $ReFailure = {
    'expired' => qr{(?:
         retry[ ]timeout[ ]exceeded
        |No[ ]action[ ]is[ ]required[ ]on[ ]your[ ]part
        )
    }x,
    'userunknown' => qr{
        user[ ]not[ ]found
    }x,
    'hostunknown' => qr{(?>
         all[ ](?:
             host[ ]address[ ]lookups[ ]failed[ ]permanently
            |relevant[ ]MX[ ]records[ ]point[ ]to[ ]non[-]existent[ ]hosts
            )
        |Unrouteable[ ]address
        )
    }x,
    'mailboxfull' => qr{(?:
         mailbox[ ]is[ ]full:?
        |error:[ ]quota[ ]exceed
        )
    }x,
    'notaccept' => qr{(?:
         an[ ]MX[ ]or[ ]SRV[ ]record[ ]indicated[ ]no[ ]SMTP[ ]service
        |no[ ]host[ ]found[ ]for[ ]existing[ ]SMTP[ ]connection
        )
    }x,
    'systemerror' => qr{(?:
         delivery[ ]to[ ](?:file|pipe)[ ]forbidden
        |local[ ]delivery[ ]failed
        )
    }x,
    'contenterror' => qr{
        Too[ ]many[ ]["]Received["][ ]headers[ ]
    }x,
};
my $Indicators = __PACKAGE__->INDICATORS;

sub headerlist  { return ['X-Failed-Recipients'] }
sub pattern     { return $Re0 }
sub description { '@mail.ru: https://mail.ru' }

sub scan {
    # Detect an error from @mail.ru
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
    # @since v4.1.4
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless $mhead->{'from'}       =~ $Re0->{'from'};
    return undef unless $mhead->{'subject'}    =~ $Re0->{'subject'};
    return undef unless $mhead->{'message-id'} =~ $Re0->{'message-id'};

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

            # Это письмо создано автоматически
            # сервером Mail.Ru, # отвечать на него не
            # нужно.
            #
            # К сожалению, Ваше письмо не может
            # быть# доставлено одному или нескольким
            # получателям:
            #
            # **********************
            #
            # This message was created automatically by mail delivery software.
            #
            # A message that you sent could not be delivered to one or more of its
            # recipients. This is a permanent error. The following address(es) failed:
            #
            #  kijitora@example.jp
            #    SMTP error from remote mail server after RCPT TO:<kijitora@example.jp>:
            #    host neko.example.jp [192.0.2.222]: 550 5.1.1 <kijitora@example.jp>... User Unknown
            $v = $dscontents->[-1];

            if( $e =~ m/\A[ \t]+([^ \t]+[@][^ \t]+[.][a-zA-Z]+)\z/ ) {
                #   kijitora@example.jp
                if( length $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } elsif( scalar @$dscontents == $recipients ) {
                # Error message
                next unless length $e;
                $v->{'diagnosis'} .= $e.' ';

            } else {
                # Error message when email address above does not include '@'
                # and domain part.
                next unless $e =~ m/\A[ \t]{4}/;
                $v->{'alterrors'} .= $e.' ';
            }
        } # End of if: rfc822
    }

    unless( $recipients ) {
        # Fallback for getting recipient addresses
        if( defined $mhead->{'x-failed-recipients'} ) {
            # X-Failed-Recipients: kijitora@example.jp
            my @rcptinhead = split(',', $mhead->{'x-failed-recipients'});
            map { $_ =~ y/ //d } @rcptinhead;
            $recipients = scalar @rcptinhead;

            for my $e ( @rcptinhead ) {
                # Insert each recipient address into @$dscontents
                $dscontents->[-1]->{'recipient'} = $e;
                next if scalar @$dscontents == $recipients;
                push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
            }
        }
    }
    return undef unless $recipients;

    if( scalar @{ $mhead->{'received'} } ) {
        # Get the name of local MTA
        # Received: from marutamachi.example.org (c192128.example.net [192.0.2.128])
        $localhost0 = $1 if $mhead->{'received'}->[-1] =~ m/from[ \t]([^ ]+) /;
    }

    require Sisimai::String;
    for my $e ( @$dscontents ) {
        if( exists $e->{'alterrors'} && length $e->{'alterrors'} ) {
            # Copy alternative error message
            $e->{'diagnosis'} ||= $e->{'alterrors'};
            if( $e->{'diagnosis'} =~ m/\A[-]+/ || $e->{'diagnosis'} =~ m/__\z/ ) {
                # Override the value of diagnostic code message
                $e->{'diagnosis'} = $e->{'alterrors'} if length $e->{'alterrors'};
            }
            delete $e->{'alterrors'};
        }
        $e->{'diagnosis'} =  Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'diagnosis'} =~ s{\b__.+\z}{};

        unless( $e->{'rhost'} ) {
            # Get the remote host name
            if( $e->{'diagnosis'} =~ m/host[ \t]+([^ \t]+)[ \t]\[.+\]:[ \t]/ ) {
                # host neko.example.jp [192.0.2.222]: 550 5.1.1 <kijitora@example.jp>... User Unknown
                $e->{'rhost'} = $1;
            }

            unless( $e->{'rhost'} ) {
                if( scalar @{ $mhead->{'received'} } ) {
                    # Get localhost and remote host name from Received header.
                    my $r0 = $mhead->{'received'};
                    $e->{'rhost'} = pop @{ Sisimai::RFC5322->received($r0->[-1]) };
                }
            }
        }
        $e->{'lhost'} ||= $localhost0;

        unless( $e->{'command'} ) {
            # Get the SMTP command name for the session
            SMTP: for my $r ( @$ReCommand ) {
                # Verify each regular expression of SMTP commands
                next unless $e->{'diagnosis'} =~ $r;
                $e->{'command'} = uc $1;
                last;
            }

            REASON: while(1) {
                # Detect the reason of bounce
                if( $e->{'command'} eq 'MAIL' ) {
                    # MAIL | Connected to 192.0.2.135 but sender was rejected.
                    $e->{'reason'} = 'rejected';

                } elsif( $e->{'command'} =~ m/\A(?:HELO|EHLO)\z/ ) {
                    # HELO | Connected to 192.0.2.135 but my name was rejected.
                    $e->{'reason'} = 'blocked';

                } else {
                    SESSION: for my $r ( keys %$ReFailure ) {
                        # Verify each regular expression of session errors
                        next unless $e->{'diagnosis'} =~ $ReFailure->{ $r };
                        $e->{'reason'} = $r;
                        last;
                    }
                }
                last;
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

Sisimai::MSP::RU::MailRu - bounce mail parser class for C<@mail.ru>.

=head1 SYNOPSIS

    use Sisimai::MSP::RU::MailRu;

=head1 DESCRIPTION

Sisimai::MSP::RU::MailRu parses a bounce email which created by C<@mail.ru>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::MSP::RU::MailRu->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::MSP::RU::MailRu->smtpagent;

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
