package Sisimai::Bite::Email::X5;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => ['Content-Type: message/delivery-status'],
    'rfc822'  => ['Content-Type: message/rfc822'],
};

sub description { 'Unknown MTA #5' }
sub scan {
    # Detect an error from Unknown MTA #5
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
    # @since v4.13.0
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;
    my $plain = '';

    $match++ if defined $mhead->{'to'} && rindex($mhead->{'to'}, 'NotificationRecipients') > -1;
    if( rindex($mhead->{'from'}, 'TWFpbCBEZWxpdmVyeSBTdWJzeXN0ZW0') > -1 ) {
        # From: "=?iso-2022-jp?B?TWFpbCBEZWxpdmVyeSBTdWJzeXN0ZW0=?=" <...>
        #       Mail Delivery Subsystem
        for my $f ( split(' ', $mhead->{'from'}) ) {
            # Check each element of From: header
            next unless Sisimai::MIME->is_mimeencoded(\$f);
            $match++ if rindex(Sisimai::MIME->mimedecode([$f]), 'Mail Delivery Subsystem') > -1;
            last;
        }
    }

    if( Sisimai::MIME->is_mimeencoded(\$mhead->{'subject'}) ) {
        # Subject: =?iso-2022-jp?B?UmV0dXJuZWQgbWFpbDogVXNlciB1bmtub3du?=
        $plain = Sisimai::MIME->mimedecode([$mhead->{'subject'}]);
        $match++ if rindex($plain, 'Mail Delivery Subsystem') > -1;
    }
    return undef if $match < 2;

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
            if( index($e, $StartingOf->{'message'}->[0]) == 0 ) {
                $readcursor |= $Indicators->{'deliverystatus'};
                next;
            }
        }

        unless( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Beginning of the original message part
            if( index($e, $StartingOf->{'rfc822'}->[0]) == 0 ) {
                $readcursor |= $Indicators->{'message-rfc822'};
                next;
            }
        }

        if( $readcursor & $Indicators->{'message-rfc822'} ) {
            # Before "message/rfc822"
            next unless length $e;
            $v = $dscontents->[-1];

            if( $e =~ /\AFinal-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ) {
                # Final-Recipient: RFC822; kijitora@example.jp
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } elsif( $e =~ /\AX-Actual-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ||
                     $e =~ /\AOriginal-Recipient:[ ]*(?:RFC|rfc)822;[ ]*([^ ]+)\z/ ) {
                # X-Actual-Recipient: RFC822; kijitora@example.co.jp
                # Original-Recipient: rfc822;kijitora@example.co.jp
                $v->{'alias'} = $1;

            } elsif( $e =~ /\AAction:[ ]*(.+)\z/ ) {
                # Action: failed
                $v->{'action'} = lc $1;

            } elsif( $e =~ /\AStatus:[ ]*(\d[.]\d+[.]\d+)/ ) {
                # Status: 5.1.1
                $v->{'status'} = $1;

            } elsif( $e =~ /\AReporting-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                # Reporting-MTA: dns; mx.example.jp
                $v->{'lhost'} = lc $1;

            } elsif( $e =~ /\ARemote-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                # Remote-MTA: DNS; mx.example.jp
                $v->{'rhost'} = lc $1;

            } elsif( $e =~ /\ALast-Attempt-Date:[ ]*(.+)\z/ ) {
                # Last-Attempt-Date: Fri, 14 Feb 2014 12:30:08 -0500
                $v->{'date'} = $1;

            } else {
                # Get an error message from Diagnostic-Code: field
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
            # After "message/rfc822"
            next unless $recipients;
            next unless $readcursor & $Indicators->{'deliverystatus'};

            unless( length $e ) {
                $blanklines++;
                last if $blanklines > 1;
                next;
            }
            push @$rfc822list, $e;
        }
    } continue {
        # Save the current line for the next loop
        $p = $e;
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        $e->{'diagnosis'} ||= Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'agent'}       = __PACKAGE__->smtpagent;
    }

    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::X5 - bounce mail parser class for unknown MTA #5.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::X5;

=head1 DESCRIPTION

Sisimai::Bite::Email::X5 parses a bounce email which created by Unknown MTA #5.
Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::X5->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::X5->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

