package Sisimai::Bite::Email::Sendmail;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    # Error text regular expressions which defined in sendmail/savemail.c
    #   savemail.c:1040|if (printheader && !putline("   ----- Transcript of session follows -----\n",
    #   savemail.c:1041|          mci))
    #   savemail.c:1042|  goto writeerr;
    'rfc822'  => ['Content-Type: message/rfc822', 'Content-Type: text/rfc822-headers'],
    'message' => ['   ----- Transcript of session follows -----'],
    'error'   => ['... while talking to '],
};

sub description { 'V8Sendmail: /usr/sbin/sendmail' }
sub scan {
    # Parse bounce messages from Sendmail
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

    return undef unless $mhead->{'subject'} =~ /(?:see transcript for details\z|\AWarning: )/;
    unless( lc($mhead->{'subject'}) =~ /\A[ \t]*fwd?:/ ) {
        # Fwd: Returned mail: see transcript for details
        # Do not execute this code if the bounce mail is a forwarded message.
        return undef unless index($mhead->{'from'}, 'Mail Delivery Subsystem') > -1;
    }

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position

    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $commandtxt = '';    # (String) SMTP Command name begin with the string '>>>'
    my $esmtpreply = '';    # (String) Reply from remote server on SMTP session
    my $sessionerr = 0;     # (Integer) Flag, 1 if it is SMTP session error
    my $connvalues = 0;     # (Integer) Flag, 1 if all the value of $connheader have been set
    my $connheader = {
        'date'  => '',      # The value of Arrival-Date header
        'rhost' => '',      # The value of Reporting-tTA headed
    };
    my $anotherset = {};    # Another error information
    my $v = undef;
    my $p = '';

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
            if( index($e, $StartingOf->{'rfc822'}->[0]) == 0 ||
                index($e, $StartingOf->{'rfc822'}->[1]) == 0 ) {
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
                # Final-Recipient: RFC822; userunknown@example.jp
                # X-Actual-Recipient: RFC822; kijitora@example.co.jp
                # Action: failed
                # Status: 5.1.1
                # Remote-MTA: DNS; mx.example.jp
                # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                # Last-Attempt-Date: Fri, 14 Feb 2014 12:30:08 -0500
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
                    $v->{'rhost'} = '' if $v->{'rhost'} =~ /\A\s+\z/;  # Remote-MTA: DNS; 

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
                # ----- Transcript of session follows -----
                # ... while talking to mta.example.org.:
                # >>> DATA
                # <<< 550 Unknown user recipient@example.jp
                # 554 5.0.0 Service unavailable
                # ...
                # Reporting-MTA: dns; mx.example.jp
                # Received-From-MTA: DNS; x1x2x3x4.dhcp.example.ne.jp
                # Arrival-Date: Wed, 29 Apr 2009 16:03:18 +0900
                if( $e =~ /\A[>]{3}[ ]+([A-Z]{4})[ ]?/ ) {
                    # >>> DATA
                    $commandtxt = $1;

                } elsif( $e =~ /\A[<]{3}[ ]+(.+)\z/ ) {
                    # <<< Response
                    $esmtpreply = $1;

                } elsif( $e =~ /\AReporting-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                    # Reporting-MTA: dns; mx.example.jp
                    next if $connheader->{'rhost'};
                    $connheader->{'rhost'} = lc $1;
                    $connvalues++;

                } elsif( $e =~ /\AReceived-From-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                    # Received-From-MTA: DNS; x1x2x3x4.dhcp.example.ne.jp
                    next if( exists $connheader->{'lhost'} && $connheader->{'lhost'} );

                    # The value of "lhost" is optional
                    $connheader->{'lhost'} = lc $1;
                    $connvalues++;

                } elsif( $e =~ /\AArrival-Date:[ ]*(.+)\z/ ) {
                    # Arrival-Date: Wed, 29 Apr 2009 16:03:18 +0900
                    next if $connheader->{'date'};
                    $connheader->{'date'} = $1;
                    $connvalues++;

                } else {
                    # Detect SMTP session error or connection error
                    next if $sessionerr;
                    if( index($e, $StartingOf->{'error'}->[0]) == 0 ) { 
                        # ----- Transcript of session follows -----
                        # ... while talking to mta.example.org.:
                        $sessionerr = 1;
                        next;
                    }

                    if( $e =~ /\A[<](.+)[>][.]+ (.+)\z/ ) {
                        # <kijitora@example.co.jp>... Deferred: Name server: example.co.jp.: host name lookup failure
                        $anotherset->{'recipient'} = $1;
                        $anotherset->{'diagnosis'} = $2;

                    } else {
                        # ----- Transcript of session follows -----
                        # Message could not be delivered for too long
                        # Message will be deleted from queue
                        next if $e =~ /\A[ \t]*[-]+/;
                        if( $e =~ /\A[45]\d\d[ \t]([45][.]\d[.]\d)[ \t].+/ ) {
                            # 550 5.1.2 <kijitora@example.org>... Message
                            #
                            # DBI connect('dbname=...')
                            # 554 5.3.0 unknown mailer error 255
                            $anotherset->{'status'} = $1;
                            $anotherset->{'diagnosis'} .= ' '.$e;

                        } elsif( index($e, 'Message: ') == 0 || index($e, 'Warning: ') == 0 ) {
                            # Message could not be delivered for too long
                            # Warning: message still undelivered after 4 hours
                            $anotherset->{'diagnosis'} .= ' '.$e;
                        }
                    }
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

        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'command'} ||= $commandtxt || '';
        $e->{'command'} ||= 'EHLO' if $esmtpreply;

        if( exists $anotherset->{'diagnosis'} && $anotherset->{'diagnosis'} ) {
            # Copy alternative error message
            $e->{'diagnosis'}   = $anotherset->{'diagnosis'} if $e->{'diagnosis'} =~ /\A[ \t]+\z/;
            $e->{'diagnosis'} ||= $anotherset->{'diagnosis'};
            $e->{'diagnosis'}   = $anotherset->{'diagnosis'} if $e->{'diagnosis'} =~ /\A\d+\z/;
        }
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        if( exists $anotherset->{'status'} && $anotherset->{'status'} ) {
            # Check alternative status code
            if( ! $e->{'status'} || $e->{'status'} !~ /\A[45][.]\d[.]\d\z/ ) {
                # Override alternative status code
                $e->{'status'} = $anotherset->{'status'};
            }
        }

        unless( $e->{'recipient'} =~ /\A[^ ]+[@][^ ]+\z/ ) {
            # @example.jp, no local part
            # Get email address from the value of Diagnostic-Code header
            $e->{'recipient'} = $1 if $e->{'diagnosis'} =~ /[<]([^ ]+[@][^ ]+)[>]/;
        }
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::Sendmail - bounce mail parser class for v8 Sendmail.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::Sendmail;

=head1 DESCRIPTION

Sisimai::Bite::Email::Sendmail parses a bounce email which created by v8 Sendmail.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::Sendmail->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::Sendmail->smtpagent;

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
