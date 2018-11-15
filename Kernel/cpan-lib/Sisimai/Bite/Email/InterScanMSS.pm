package Sisimai::Bite::Email::InterScanMSS;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'message' => [''],
    'rfc822'  => ['Content-type: message/rfc822'],
};

sub description { 'Trend Micro InterScan Messaging Security Suite' }
sub scan {
    # Detect an error from InterScanMSS
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
    my $match = 0;
    my $tryto = [
        'Mail could not be delivered',
        # メッセージを配信できません。
        '=?iso-2022-jp?B?GyRCJWElQyU7ITwlOCRyR1s/LiRHJC0kXiQ7JHMhIxsoQg==?=',
        # メール配信に失敗しました
        '=?iso-2022-jp?B?GyRCJWEhPCVrR1s/LiRLPDpHVCQ3JF4kNyQ/GyhCDQo=?=',
    ];

    # 'received' => qr/[ ][(]InterScanMSS[)][ ]with[ ]/,
    $match ||= 1 if index($mhead->{'from'}, '"InterScan MSS"') == 0;
    $match ||= 1 if grep { $mhead->{'subject'} eq $_ } @$tryto;
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
            if( index($e, $StartingOf->{'rfc822'}->[0]) == 0 ) {
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

            # Sent <<< RCPT TO:<kijitora@example.co.jp>
            # Received >>> 550 5.1.1 <kijitora@example.co.jp>... user unknown
            $v = $dscontents->[-1];

            if( $e =~ /\A.+[<>]{3}[ \t]+.+[<]([^ ]+[@][^ ]+)[>]\z/ ||
                $e =~ /\A.+[<>]{3}[ \t]+.+[<]([^ ]+[@][^ ]+)[>]/ ) {
                # Sent <<< RCPT TO:<kijitora@example.co.jp>
                # Received >>> 550 5.1.1 <kijitora@example.co.jp>... user unknown
                my $cr = $1;
                if( $v->{'recipient'} && $cr ne $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $cr;
                $recipients = scalar @$dscontents;
            }

            if( $e =~ /\ASent[ \t]+[<]{3}[ \t]+([A-Z]{4})[ \t]/ ) {
                # Sent <<< RCPT TO:<kijitora@example.co.jp>
                $v->{'command'} = $1

            } elsif( $e =~ /\AReceived[ \t]+[>]{3}[ \t]+(\d{3}[ \t]+.+)\z/ ) {
                # Received >>> 550 5.1.1 <kijitora@example.co.jp>... user unknown
                $v->{'diagnosis'} = $1;

            } else {
                # Error message in non-English
                if( $e =~ /[ ][>]{3}[ ]([A-Z]{4})/ ) {
                    # >>> RCPT TO ...
                    $v->{'command'} = $1;

                } elsif( $e =~ /[ ][<]{3}[ ](.+)/ ) {
                    # <<< 550 5.1.1 User unknown
                    $v->{'diagnosis'} = $1;
                }
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});
        $e->{'agent'}  = __PACKAGE__->smtpagent;
    }

    $rfc822part = Sisimai::RFC5322->weedout($rfc822list);
    return { 'ds' => $dscontents, 'rfc822' => $$rfc822part };
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Bite::Email::InterScanMSS - bounce mail parser class for
C<Trend Micro InterScan Messaging Security Suite>.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::InterScanMSS;

=head1 DESCRIPTION

Sisimai::Bite::Email::InterScanMSS parses a bounce email which created by C<Trend Micro
InterScan Messaging Security Suite>. Methods in the module are called from only
Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::InterScanMSS->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::InterScanMSS->smtpagent;

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

