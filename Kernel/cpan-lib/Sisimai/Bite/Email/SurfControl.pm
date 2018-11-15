package Sisimai::Bite::Email::SurfControl;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['Your message could not be sent.'],
    'rfc822'  => ['Content-Type: message/rfc822'],
};

# X-SEF-ZeroHour-RefID: fgs=000000000
# X-SEF-Processed: 0_0_0_000__2010_04_29_23_34_45
# X-Mailer: SurfControl E-mail Filter
sub headerlist  { return ['X-SEF-Processed', 'X-Mailer'] }
sub description { 'WebSense SurfControl' }
sub scan {
    # Detect an error from SurfControl
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
    # @since v4.1.2
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;

    # 'from'     => qr/ [(]Mail Delivery System[)]\z/,
    return undef unless $mhead->{'x-sef-processed'};
    return undef unless $mhead->{'x-mailer'};
    return undef unless $mhead->{'x-mailer'} eq 'SurfControl E-mail Filter';

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
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

            # Your message could not be sent.
            # A transcript of the attempts to send the message follows.
            # The number of attempts made: 1
            # Addressed To: kijitora@example.com
            #
            # Thu 29 Apr 2010 23:34:45 +0900
            # Failed to send to identified host,
            # kijitora@example.com: [192.0.2.5], 550 kijitora@example.com... No such user
            # --- Message non-deliverable.
            $v = $dscontents->[-1];

            if( $e =~ /\AAddressed To:[ \t]*([^ ]+?[@][^ ]+?)\z/ ) {
                # Addressed To: kijitora@example.com
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } elsif( $e =~ /\A(?:Sun|Mon|Tue|Wed|Thu|Fri|Sat)[ \t,]/ ) {
                # Thu 29 Apr 2010 23:34:45 +0900
                $v->{'date'} = $e;

            } elsif( $e =~ /\A[^ ]+[@][^ ]+:[ \t]*\[(\d+[.]\d+[.]\d+[.]\d)\],[ \t]*(.+)\z/ ) {
                # kijitora@example.com: [192.0.2.5], 550 kijitora@example.com... No such user
                $v->{'rhost'} = $1;
                $v->{'diagnosis'} = $2;

            } else {
                # Fallback, parse RFC3464 headers.
                if( $e =~ /\ADiagnostic-Code:[ ]*(.+?);[ ]*(.+)\z/ ) {
                    # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                    $v->{'spec'} = uc $1;
                    $v->{'diagnosis'} = $2;

                } elsif( index($p, 'Diagnostic-Code:') == 0 && $e =~ /\A[ \t]+(.+)\z/ ) {
                    # Continued line of the value of Diagnostic-Code header
                    $v->{'diagnosis'} .= ' '.$1;
                    $e = 'Diagnostic-Code: '.$e;

                } elsif( $e =~ /\AAction:[ ]*(.+)\z/ ) {
                    # Action: failed
                    $v->{'action'} = lc $1;

                } elsif( $e =~ /\AStatus:[ ]*(\d[.]\d+[.]\d+)/ ) {
                    # Status: 5.0.-
                    $v->{'status'} = $1;
                }
            }
        } # End of if: rfc822
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'agent'}     = __PACKAGE__->smtpagent;
    }

    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::SurfControl - bounce mail parser class for C<SurfControl>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::SurfControl;

=head1 DESCRIPTION

Sisimai::Bite::Email::SurfControl parses a bounce email which created by
C<WebSense SurfControl>. Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::SurfControl->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::SurfControl->smtpagent;

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

