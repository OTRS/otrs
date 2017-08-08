package Sisimai::MSP::JP::EZweb;
use parent 'Sisimai::MSP';
use feature ':5.10';
use strict;
use warnings;

my $Re0 = {
    'from'       => qr/[<]?(?>postmaster[@]ezweb[.]ne[.]jp)[>]?/i,
    'subject'    => qr/\AMail System Error - Returned Mail\z/,
    'received'   => qr/\Afrom[ ](?:.+[.])?ezweb[.]ne[.]jp[ ]/,
    'message-id' => qr/[@].+[.]ezweb[.]ne[.]jp[>]\z/,
};
my $Re1 = {
    'begin'    => qr{\A(?:
         The[ ]user[(]s[)][ ]
        |Your[ ]message[ ]
        |Each[ ]of[ ]the[ ]following
        |[<][^ ]+[@][^ ]+[>]\z
        )
    }x,
    'rfc822'   => qr#\A(?:[-]{50}|Content-Type:[ ]*message/rfc822)#,
    'boundary' => qr/\A__SISIMAI_PSEUDO_BOUNDARY__\z/,
    'endof'    => qr/\A__END_OF_EMAIL_MESSAGE__\z/,
};
my $ReFailure = {
    #'notaccept' => [ qr/The following recipients did not receive this message:/ ],
    'mailboxfull' => [
        qr/The user[(]s[)] account is temporarily over quota/,
    ],
    'suspend' => [
        # http://www.naruhodo-au.kddi.com/qa3429203.html
        # The recipient may be unpaid user...?
        qr/The user[(]s[)] account is disabled[.]/,
        qr/The user[(]s[)] account is temporarily limited[.]/,
    ],
    'expired' => [
        # Your message was not delivered within 0 days and 1 hours.
        # Remote host is not responding.
        qr/Your message was not delivered within /,
    ],
    'onhold' => [
        qr/Each of the following recipients was rejected by a remote mail server/,
    ],
};
my $Indicators = __PACKAGE__->INDICATORS;

sub headerlist  { return ['X-SPASIGN'] }
sub pattern     { return $Re0 }
sub description { 'au EZweb: http://www.au.kddi.com/mobile/' }

sub scan {
    # Detect an error from EZweb
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
    my $match = 0;

    # Pre-process email headers of NON-STANDARD bounce message au by EZweb, as
    # known as ezweb.ne.jp.
    #   Subject: Mail System Error - Returned Mail
    #   From: <Postmaster@ezweb.ne.jp>
    #   Received: from ezweb.ne.jp (wmflb12na02.ezweb.ne.jp [222.15.69.197])
    #   Received: from nmomta.auone-net.jp ([aaa.bbb.ccc.ddd]) by ...
    #
    $match++ if $mhead->{'from'}     =~ $Re0->{'from'};
    $match++ if $mhead->{'subject'}  =~ $Re0->{'subject'};
    $match++ if grep { $_ =~ $Re0->{'received'} } @{ $mhead->{'received'} };
    if( defined $mhead->{'message-id'} ) {
        $match++ if $mhead->{'message-id'} =~ $Re0->{'message-id'};
    }
    return undef if $match < 2;

    require Sisimai::String;
    require Sisimai::Address;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $v = undef;

    if( $mhead->{'content-type'} ) {
        # Get the boundary string and set regular expression for matching with
        # the boundary string.
        require Sisimai::MIME;
        my $b0 = Sisimai::MIME->boundary($mhead->{'content-type'}, 1);
        if( length $b0 ) {
            # Convert to regular expression
            $Re1->{'boundary'} = qr/\A\Q$b0\E\z/;
        }
    }
    my @rxmessages = (); map { push @rxmessages, @{ $ReFailure->{ $_ } } } (keys %$ReFailure);

    for my $e ( @hasdivided ) {
        # Read each line between $Re1->{'begin'} and $Re1->{'rfc822'}.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            $readcursor |= $Indicators->{'deliverystatus'} if $e =~ $Re1->{'begin'};
        }

        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( $e =~ $Re1->{'rfc822'} || $e =~ $Re1->{'boundary'} ) {
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

            # The user(s) account is disabled.
            #
            # <***@ezweb.ne.jp>: 550 user unknown (in reply to RCPT TO command)
            # 
            #  -- OR --
            # Each of the following recipients was rejected by a remote
            # mail server.
            #
            #    Recipient: <******@ezweb.ne.jp>
            #    >>> RCPT TO:<******@ezweb.ne.jp>
            #    <<< 550 <******@ezweb.ne.jp>: User unknown
            $v = $dscontents->[-1];

            if( $e =~ m/\A[<]([^ ]+[@][^ ]+)[>]\z/ ||
                $e =~ m/\A[<]([^ ]+[@][^ ]+)[>]:?(.*)\z/ ||
                $e =~ m/\A[ \t]+Recipient: [<]([^ ]+[@][^ ]+)[>]/ ) {

                if( length $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }

                my $r = Sisimai::Address->s3s4($1);
                if( Sisimai::RFC5322->is_emailaddress($r) ) {
                    $v->{'recipient'} = $r;
                    $recipients++;
                }

            } elsif( $e =~ m/\A[Ss]tatus:[ ]*(\d[.]\d+[.]\d+)/ ) {
                # Status: 5.1.1
                # Status:5.2.0
                # Status: 5.1.0 (permanent failure)
                $v->{'status'} = $1;

            } elsif( $e =~ m/\A[Aa]ction:[ ]*(.+)\z/ ) {
                # Action: failed
                $v->{'action'} = lc $1;

            } elsif( $e =~ m/\A[Rr]emote-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                # Remote-MTA: DNS; mx.example.jp
                $v->{'rhost'} = lc $1;

            } elsif( $e =~ m/\A[Ll]ast-[Aa]ttempt-[Dd]ate:[ ]*(.+)\z/ ) {
                # Last-Attempt-Date: Fri, 14 Feb 2014 12:30:08 -0500
                $v->{'date'} = $1;

            } else {
                next if Sisimai::String->is_8bit(\$e);
                if( $e =~ m/\A[ \t]+[>]{3}[ \t]+([A-Z]{4})/ ) {
                    #    >>> RCPT TO:<******@ezweb.ne.jp>
                    $v->{'command'} = $1;

                } else {
                    # Check error message
                    if( grep { $e =~ $_ } @rxmessages ) {
                        # Check with regular expressions of each error
                        $v->{'diagnosis'} .= ' '.$e;
                    } else {
                        # >>> 550
                        $v->{'alterrors'} .= ' '.$e;
                    }
                }
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

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
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        if( defined $mhead->{'x-spasign'} && $mhead->{'x-spasign'} eq 'NG' ) {
            # Content-Type: text/plain; ..., X-SPASIGN: NG (spamghetti, au by EZweb)
            # Filtered recipient returns message that include 'X-SPASIGN' header
            $e->{'reason'} = 'filtered';

        } else {
            if( $e->{'command'} eq 'RCPT' ) {
                # set "userunknown" when the remote server rejected after RCPT
                # command.
                $e->{'reason'} = 'userunknown';

            } else {
                # SMTP command is not RCPT
                SESSION: for my $r ( keys %$ReFailure ) {
                    # Verify each regular expression of session errors
                    PATTERN: for my $rr ( @{ $ReFailure->{ $r } } ) {
                        # Check each regular expression
                        next(PATTERN) unless $e->{'diagnosis'} =~ $rr;
                        $e->{'reason'} = $r;
                        last(SESSION);
                    }
                }
            }
        }

        unless( $e->{'reason'} ) {
            # The value of "reason" is not set yet.
            unless( $e->{'recipient'} =~ m/[@]ezweb[.]ne[.]jp\z/ ) {
                # Deal as "userunknown" when the domain part of the recipient
                # is "ezweb.ne.jp".
                $e->{'reason'} = 'userunknown';
            }
        }
        $e->{'agent'} = __PACKAGE__->smtpagent;
    }
    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__
=encoding utf-8

=head1 NAME

Sisimai::MSP::JP::EZweb - bounce mail parser class for C<au EZweb>.

=head1 SYNOPSIS

    use Sisimai::MSP::JP::EZweb;

=head1 DESCRIPTION

Sisimai::MSP::JP::EZweb parses a bounce email which created by C<au EZweb>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::MSP::JP::EZweb->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::MSP::JP::EZweb->smtpagent;

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

