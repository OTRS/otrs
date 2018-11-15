package Sisimai::Bite::Email::GSuite;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $MarkingsOf = {
    'message' => qr/\A[*][*][ ].+[ ][*][*]\z/,
    'error'   => qr/\AThe[ ]response([ ]from[ ]the[ ]remote[ ]server)?[ ]was:\z/,
    'html'    => qr{\AContent-Type:[ ]*text/html;[ ]*charset=['"]?(?:UTF|utf)[-]8['"]?\z},
    'rfc822'  => qr{\AContent-Type:[ ]*(?:message/rfc822|text/rfc822-headers)\z},
};
my $MessagesOf = {
    'userunknown'  => ["because the address couldn't be found. Check for typos or unnecessary spaces and try again."],
    'notaccept'    => ['Null MX'],
    'networkerror' => [' responded with code NXDOMAIN'],
};

sub headerlist  { return ['X-Gm-Message-State'] }
sub description { 'G Suite: https://gsuite.google.com/' }
sub scan {
    # Detect an error from G Suite (Transfer from G Suite to a destination host)
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
    # @since v4.21.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    return undef unless rindex($mhead->{'from'}, '<mailer-daemon@googlemail.com>') > -1;
    return undef unless index($mhead->{'subject'}, 'Delivery Status Notification') > -1;
    return undef unless $mhead->{'x-gm-message-state'};

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $endoferror = 0;     # (Integer) Flag for a blank line after error messages
    my $emptylines = 0;     # (Integer) The number of empty lines
    my $connvalues = 0;     # (Integer) Flag, 1 if all the value of $connheader have been set
    my $anotherset = {      # (Hash) Another error information
        'diagnosis' => '',
    };
    my $connheader = {
        'date'  => '',      # The value of Arrival-Date header
        'lhost' => '',      # The value of Reporting-MTA header
    };
    my $v = undef;

    for my $e ( @hasdivided ) {
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            $readcursor |= $Indicators->{'deliverystatus'} if $e =~ $MarkingsOf->{'message'};
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

            if( $connvalues == scalar(keys %$connheader) ) {
                # Final-Recipient: rfc822; kijitora@example.de
                # Action: failed
                # Status: 5.0.0
                # Remote-MTA: dns; 192.0.2.222 (192.0.2.222, the server for the domain.)
                # Diagnostic-Code: smtp; 550 #5.1.0 Address rejected.
                # Last-Attempt-Date: Fri, 24 Mar 2017 23:34:10 -0700 (PDT)
                $v = $dscontents->[-1];

                if( $e =~ /\AFinal-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ) {
                    # Final-Recipient: rfc822; kijitora@example.de
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

                } elsif( $e =~ /\ARemote-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                    # Remote-MTA: dns; 192.0.2.222 (192.0.2.222, the server for the domain.)
                    $v->{'rhost'} = lc $1;
                    $v->{'rhost'} = '' if $v->{'rhost'} =~ /\A\s+\z/;  # Remote-MTA: DNS; 

                } elsif( $e =~ /\ALast-Attempt-Date:[ ]*(.+)\z/ ) {
                    # Last-Attempt-Date: Fri, 24 Mar 2017 23:34:10 -0700 (PDT)
                    $v->{'date'} = $1;

                } else {
                    if( $e =~ /\ADiagnostic-Code:[ ]*(.+?);[ ]*(.+)\z/ ) {
                        # Diagnostic-Code: smtp; 550 #5.1.0 Address rejected.
                        $v->{'spec'} = uc $1;
                        $v->{'diagnosis'} = $2;

                    } else {
                        # Append error messages continued from the previous line
                        if( ! $endoferror && $v->{'diagnosis'} ) {
                            $endoferror ||= 1 if $e eq '';
                            $endoferror ||= 1 if index($e, '--') == 0;

                            next if $endoferror;
                            next unless index($e, ' ') == 0;
                            $v->{'diagnosis'} .= $e;
                        }
                    }
                }
            } else {
                # Reporting-MTA: dns; googlemail.com
                # Received-From-MTA: dns; sironeko@example.jp
                # Arrival-Date: Fri, 24 Mar 2017 23:34:07 -0700 (PDT)
                # X-Original-Message-ID: <06C1ED5C-7E02-4036-AEE1-AA448067FB2C@example.jp>
                if( $e =~ /\AReporting-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                    # Reporting-MTA: dns; googlemail.com
                    next if $connheader->{'lhost'};
                    $connheader->{'lhost'} = lc $1;
                    $connvalues++;

                } elsif( $e =~ /\AArrival-Date:[ ]*(.+)\z/ ) {
                    # Arrival-Date: Wed, 29 Apr 2009 16:03:18 +0900
                    next if $connheader->{'date'};
                    $connheader->{'date'} = $1;
                    $connvalues++;

                } else {
                    # Detect SMTP session error or connection error
                    if( $e =~ $MarkingsOf->{'error'} ) {
                        # The response from the remote server was:
                        $anotherset->{'diagnosis'} .= $e;

                    } else {
                        # ** Address not found **
                        #
                        # Your message wasn't delivered to * because the address couldn't be found.
                        # Check for typos or unnecessary spaces and try again.
                        #
                        # The response from the remote server was:
                        # 550 #5.1.0 Address rejected.
                        next if $e =~ $MarkingsOf->{'html'};

                        if( $anotherset->{'diagnosis'} ) {
                            # Continued error messages from the previous line like
                            # "550 #5.1.0 Address rejected."
                            next if $e =~ /\AContent-Type:/;
                            next if $emptylines > 5;
                            unless( length $e ) {
                                # Count and next()
                                $emptylines += 1;
                                next;
                            }
                            $anotherset->{'diagnosis'} .= ' '.$e

                        } else {
                            # ** Address not found **
                            #
                            # Your message wasn't delivered to * because the address couldn't be found.
                            # Check for typos or unnecessary spaces and try again.
                            next unless $e;
                            next unless $e =~ $MarkingsOf->{'message'};
                            $anotherset->{'diagnosis'} = $e;
                        }
                    }
                }
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        map { $e->{ $_ } ||= $connheader->{ $_ } || '' } keys %$connheader;

        if( exists $anotherset->{'diagnosis'} && $anotherset->{'diagnosis'} ) {
            # Copy alternative error message
            $e->{'diagnosis'} ||= $anotherset->{'diagnosis'};
            if( $e->{'diagnosis'} =~ /\A\d+\z/ ) {
                # Override the value of diagnostic code message
                $e->{'diagnosis'} = $anotherset->{'diagnosis'};

            } else {
                # More detailed error message is in "$anotherset"
                my $as = undef; # status
                my $ar = undef; # replycode

                if( $e->{'status'} eq '' || $e->{'status'} eq '5.0.0' || $e->{'status'} eq '4.0.0' ) {
                    # Check the value of D.S.N. in $anotherset
                    $as = Sisimai::SMTP::Status->find($anotherset->{'diagnosis'});
                    if( length($as) > 0 && substr($as, -4, 4) ne '.0.0' ) {
                        # The D.S.N. is neither an empty nor *.0.0
                        $e->{'status'} = $as;
                    }
                }

                if( $e->{'replycode'} eq '' || $e->{'replycode'} eq '500' || $e->{'replycode'} eq '400' ) {
                    # Check the value of SMTP reply code in $anotherset
                    $ar = Sisimai::SMTP::Reply->find($anotherset->{'diagnosis'});
                    if( length($ar) > 0 && substr($ar, -2, 2) ne '00' ) {
                        # The SMTP reply code is neither an empty nor *00
                        $e->{'replycode'} = $ar;
                    }
                }

                if( $as || $ar && ( length($anotherset->{'diagnosis'}) > length($e->{'diagnosis'}) ) ) {
                    # Update the error message in $e->{'diagnosis'}
                    $e->{'diagnosis'} = $anotherset->{'diagnosis'};
                }
            }
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'agent'}     = __PACKAGE__->smtpagent;

        for my $q ( keys %$MessagesOf ) {
            # Guess an reason of the bounce
            next unless grep { index($e->{'diagnosis'}, $_) > -1 } @{ $MessagesOf->{ $q } };
            $e->{'reason'} = $q;
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

Sisimai::Bite::Email::GSuite - bounce mail parser class for C<G Suite>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::GSuite;

=head1 DESCRIPTION

Sisimai::Bite::Email::GSuite parses a bounce email which created by C<G Suite>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::GSuite->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::GSuite->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

