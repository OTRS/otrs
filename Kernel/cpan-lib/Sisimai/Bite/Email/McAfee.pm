package Sisimai::Bite::Email::McAfee;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['--- The following addresses had delivery problems ---'],
    'rfc822'  => ['Content-Type: message/rfc822'],
};
my $ReFailures = {
    'userunknown' => qr/(?: User [(].+[@].+[)] unknown[.] |550 Unknown user [^ ]+[@][^ ]+)/,
};

# X-NAI-Header: Modified by McAfee Email and Web Security Virtual Appliance
sub headerlist  { return ['X-NAI-Header'] }
sub description { 'McAfee Email Appliance' }
sub scan {
    # Detect an error from McAfee
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

    return undef unless defined $mhead->{'x-nai-header'};
    return undef unless index($mhead->{'x-nai-header'}, 'Modified by McAfee') > -1;
    return undef unless $mhead->{'subject'} eq 'Delivery Status';

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $diagnostic = '';    # (String) Alternative diagnostic message
    my $v = undef;
    my $p = '';

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

            # Content-Type: text/plain; name="deliveryproblems.txt"
            #
            #    --- The following addresses had delivery problems ---
            #
            # <user@example.com>   (User unknown user@example.com)
            #
            # --------------Boundary-00=_00000000000000000000
            # Content-Type: message/delivery-status; name="deliverystatus.txt"
            #
            $v = $dscontents->[-1];

            if( $e =~ /\A[<]([^ ]+[@][^ ]+)[>][ \t]+[(](.+)[)]\z/ ) {
                # <kijitora@example.co.jp>   (Unknown user kijitora@example.co.jp)
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $diagnostic = $2;
                $recipients++;

            } elsif( $e =~ /\AOriginal-Recipient:[ ]*([^ ]+)\z/ ) {
                # Original-Recipient: <kijitora@example.co.jp>
                $v->{'alias'} = Sisimai::Address->s3s4($1);

            } elsif( $e =~ /\AAction:[ ]*(.+)\z/ ) {
                # Action: failed
                $v->{'action'} = lc $1;

            } elsif( $e =~ /\ARemote-MTA:[ ]*(.+)\z/ ) {
                # Remote-MTA: 192.0.2.192
                $v->{'rhost'} = lc $1;

            } else {
                if( $e =~ /\ADiagnostic-Code:[ ]*(.+?);[ ]*(.+)\z/ ) {
                    # Diagnostic-Code: SMTP; 550 5.1.1 <userunknown@example.jp>... User Unknown
                    $v->{'spec'} = uc $1;
                    $v->{'diagnosis'} = $2;

                } elsif( index($p, 'Diagnostic-Code:') == 0 && $e =~ /\A\t+(.+)\z/ ) {
                    # Continued line of the value of Diagnostic-Code header
                    $v->{'diagnosis'} .= ' '.$1;
                    $e = 'Diagnostic-Code: '.$e;
                }
            }
        } # End of if: rfc822
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'} || $diagnostic);

        SESSION: for my $r ( keys %$ReFailures ) {
            # Verify each regular expression of session errors
            next unless $e->{'diagnosis'} =~ $ReFailures->{ $r };
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

Sisimai::Bite::Email::McAfee - bounce mail parser class for C<McAfee Email Appliance>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::McAfee;

=head1 DESCRIPTION

Sisimai::Bite::Email::McAfee parses a bounce email which created by
C<McAfee Email Appliance>.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::McAfee->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::McAfee->smtpagent;

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

