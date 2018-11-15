package Sisimai::Bite::Email::Office365;
use parent 'Sisimai::Bite::Email';
use feature ':5.10';
use strict;
use warnings;

my $Indicators = __PACKAGE__->INDICATORS;
my $StartingOf = {
    'rfc822' => ['Content-Type: message/rfc822'],
    'error'  => ['Diagnostic information for administrators:'],
    'eoerr'  => ['Original message headers:'],
};
my $MarkingsOf = {
    'message' => qr{\A(?:
         Delivery[ ]has[ ]failed[ ]to[ ]these[ ]recipients[ ]or[ ]groups:
        |.+[ ]rejected[ ]your[ ]message[ ]to[ ]the[ ]following[ ]e[-]?mail[ ]addresses:
        )
    }x,
};
my $StatusList = {
    # https://support.office.com/en-us/article/Email-non-delivery-reports-in-Office-365-51daa6b9-2e35-49c4-a0c9-df85bf8533c3
    qr/\A4[.]4[.]7\z/        => 'expired',
    qr/\A4[.]4[.]312\z/      => 'networkerror',
    qr/\A4[.]4[.]316\z/      => 'expired',
    qr/\A4[.]7[.]26\z/       => 'securityerror',
    qr/\A4[.]7[.][56]\d\d\z/ => 'blocked',
    qr/\A4[.]7[.]8[5-9]\d\z/ => 'blocked',
    qr/\A5[.]4[.]1\z/        => 'norelaying',
    qr/\A5[.]4[.]6\z/        => 'networkerror',
    qr/\A5[.]4[.]312\z/      => 'networkerror',
    qr/\A5[.]4[.]316\z/      => 'expired',
    qr/\A5[.]6[.]11\z/       => 'contenterror',
    qr/\A5[.]7[.]1\z/        => 'rejected',
    qr/\A5[.]7[.]1[23]\z/    => 'rejected',
    qr/\A5[.]7[.]124\z/      => 'rejected',
    qr/\A5[.]7[.]13[3-6]\z/  => 'rejected',
    qr/\A5[.]7[.]25\z/       => 'networkerror',
    qr/\A5[.]7[.]50[1-3]\z/  => 'spamdetected',
    qr/\A5[.]7[.]50[4-5]\z/  => 'filtered',
    qr/\A5[.]7[.]50[6-7]\z/  => 'blocked',
    qr/\A5[.]7[.]508\z/      => 'toomanyconn',
    qr/\A5[.]7[.]509\z/      => 'securityerror',
    qr/\A5[.]7[.]510\z/      => 'notaccept',
    qr/\A5[.]7[.]511\z/      => 'rejected',
    qr/\A5[.]7[.]512\z/      => 'securityerror',
    qr/\A5[.]7[.]60[6-9]\z/  => 'blocked',
    qr/\A5[.]7[.]6[1-4]\d\z/ => 'blocked',
    qr/\A5[.]7[.]7[0-4]\d\z/ => 'toomanyconn',
};
my $ReCommands = {
    'RCPT' => qr/unknown recipient or mailbox unavailable ->.+[<]?.+[@].+[.][a-zA-Z]+[>]?/,
};

sub headerlist  { 
    # X-MS-Exchange-Message-Is-Ndr:
    # X-Microsoft-Antispam-PRVS: <....@...outlook.com>
    # X-Exchange-Antispam-Report-Test: UriScan:;
    # X-Exchange-Antispam-Report-CFA-Test:
    # X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2015 23:34:45.6789 (JST)
    # X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
    # X-MS-Exchange-Transport-CrossTenantHeadersStamped: ...
    return [
        'X-MS-Exchange-Message-Is-Ndr',
        'X-Microsoft-Antispam-PRVS',
        'X-Exchange-Antispam-Report-Test',
        'X-Exchange-Antispam-Report-CFA-Test',
        'X-MS-Exchange-CrossTenant-OriginalArrivalTime',
        'X-MS-Exchange-CrossTenant-FromEntityHeader',
        'X-MS-Exchange-Transport-CrossTenantHeadersStamped',
    ]
}
sub description { 'Microsoft Office 365: http://office.microsoft.com/' }
sub scan {
    # Detect an error from Microsoft Office 365
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
    # @since v4.1.3
    my $class = shift;
    my $mhead = shift // return undef;
    my $mbody = shift // return undef;
    my $match = 0;
    my $tryto = qr/.+[.](?:outbound[.]protection|prod)[.]outlook[.]com\b/;

    $match++ if index($mhead->{'subject'}, 'Undeliverable:') > -1;
    $match++ if $mhead->{'x-ms-exchange-message-is-ndr'};
    $match++ if $mhead->{'x-microsoft-antispam-prvs'};
    $match++ if $mhead->{'x-exchange-antispam-report-test'};
    $match++ if $mhead->{'x-exchange-antispam-report-cfa-test'};
    $match++ if $mhead->{'x-ms-exchange-crosstenant-originalarrivaltime'};
    $match++ if $mhead->{'x-ms-exchange-crosstenant-fromentityheader'};
    $match++ if $mhead->{'x-ms-exchange-transport-crosstenantheadersstamped'};
    $match++ if grep { $_ =~ $tryto } @{ $mhead->{'received'} };
    if( defined $mhead->{'message-id'} ) {
        # Message-ID: <00000000-0000-0000-0000-000000000000@*.*.prod.outlook.com>
        $match++ if $mhead->{'message-id'} =~ $tryto;
    }
    return undef if $match < 2;

    my $dscontents = [__PACKAGE__->DELIVERYSTATUS];
    my @hasdivided = split("\n", $$mbody);
    my $rfc822part = '';    # (String) message/rfc822-headers part
    my $rfc822list = [];    # (Array) Each line in message/rfc822 part string
    my $blanklines = 0;     # (Integer) The number of blank lines
    my $readcursor = 0;     # (Integer) Points the current cursor position
    my $recipients = 0;     # (Integer) The number of 'Final-Recipient' header
    my $connheader = {};
    my $endoferror = 0;     # (Integer) Flag for the end of error messages
    my $htmlbegins = 0;     # (Integer) Flag for HTML part
    my $v = undef;

    for my $e ( @hasdivided ) {
        # Read each line between the start of the message and the start of rfc822 part.
        unless( $readcursor ) {
            # Beginning of the bounce message or delivery status part
            if( $e =~ $MarkingsOf->{'message'} ) {
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

            # kijitora@example.com<mailto:kijitora@example.com>
            # The email address wasn't found at the destination domain. It might
            # be misspelled or it might not exist any longer. Try retyping the
            # address and resending the message.
            $v = $dscontents->[-1];

            if( $e =~ /\A.+[@].+[<]mailto:(.+[@].+)[>]\z/ ) {
                # kijitora@example.com<mailto:kijitora@example.com>
                if( $v->{'recipient'} ) {
                    # There are multiple recipient addresses in the message body.
                    push @$dscontents, __PACKAGE__->DELIVERYSTATUS;
                    $v = $dscontents->[-1];
                }
                $v->{'recipient'} = $1;
                $recipients++;

            } elsif( $e =~ /\AGenerating server: (.+)\z/ ) {
                # Generating server: FFFFFFFFFFFF.e0.prod.outlook.com
                $connheader->{'lhost'} = lc $1;

            } else {
                if( $endoferror ) {
                    # After "Original message headers:"
                    if( $htmlbegins ) {
                        # <html> .. </html>
                        $htmlbegins = 0 if index($e, '</html>') == 0;
                        next;
                    }

                    if( $e =~ /\AAction:[ ]*(.+)\z/ ) {
                        # Action: failed
                        $v->{'action'} = lc $1;

                    } elsif( $e =~ /\AStatus:[ ]*(\d[.]\d+[.]\d+)/ ) {
                        # Status:5.2.0
                        $v->{'status'} = $1;

                    } elsif( $e =~ /\AReporting-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                        # Reporting-MTA: dns;BLU004-OMC3S13.hotmail.example.com
                        $connheader->{'lhost'} = lc $1;

                    } elsif( $e =~ /\AReceived-From-MTA:[ ]*(?:DNS|dns);[ ]*(.+)\z/ ) {
                        # Reporting-MTA: dns;BLU004-OMC3S13.hotmail.example.com
                        $connheader->{'rhost'} = lc $1;

                    } elsif( $e =~ /\AArrival-Date:[ ]*(.+)\z/ ) {
                        # Arrival-Date: Wed, 29 Apr 2009 16:03:18 +0900
                        next if $connheader->{'date'};
                        $connheader->{'date'} = $1;

                    } else {
                        $htmlbegins = 1 if index($e, '<html>') == 0;
                    }
                } else {
                    if( $e eq $StartingOf->{'error'}->[0] ) {
                        # Diagnostic information for administrators:
                        $v->{'diagnosis'} = $e;

                    } else {
                        # kijitora@example.com
                        # Remote Server returned '550 5.1.10 RESOLVER.ADR.RecipientNotFound; Recipien=
                        # t not found by SMTP address lookup'
                        next unless $v->{'diagnosis'};
                        if( $e eq $StartingOf->{'eoerr'}->[0] ) {
                            # Original message headers:
                            $endoferror = 1;
                            next;
                        }
                        $v->{'diagnosis'} .= ' '.$e;
                    }
                }
            }
        } # End of if: rfc822
    }
    return undef unless $recipients;

    for my $e ( @$dscontents ) {
        # Set default values if each value is empty.
        map { $e->{ $_ } ||= $connheader->{ $_ } || '' } keys %$connheader;

        $e->{'agent'}     = __PACKAGE__->smtpagent;
        $e->{'diagnosis'} = Sisimai::String->sweep($e->{'diagnosis'});

        if( ! $e->{'status'} || substr($e->{'status'}, -4, 4) eq '.0.0' ) {
            # There is no value of Status header or the value is 5.0.0, 4.0.0
            my $r = Sisimai::SMTP::Status->find($e->{'diagnosis'});
            $e->{'status'} = $r if $r;
        }

        for my $p ( keys %$ReCommands ) {
            # Try to match with regular expressions defined in ReCommands
            next unless $e->{'diagnosis'} =~ $ReCommands->{ $p };
            $e->{'command'} = $p;
            last;
        }

        next unless $e->{'status'};

        # Find the error code from $StatusList
        for my $f ( keys %$StatusList ) {
            # Try to match with each key as a regular expression
            next unless $e->{'status'} =~ $f;
            $e->{'reason'} = $StatusList->{ $f };
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

Sisimai::Bite::Email::Office365 - bounce mail parser class for Microsoft Office 365.

=head1 SYNOPSIS

    use Sisimai::Bite::Email::Office365;

=head1 DESCRIPTION

Sisimai::Bite::Email::Office365 parses a bounce email which created by Microsoft
Office 365. Methods in the module are called from only Sisimai::Message.

=head1 CLASS METHODS

=head2 C<B<description()>>

C<description()> returns description string of this module.

    print Sisimai::Bite::Email::Office365->description;

=head2 C<B<smtpagent()>>

C<smtpagent()> returns MTA name.

    print Sisimai::Bite::Email::Office365->smtpagent;

=head2 C<B<scan(I<header data>, I<reference to body string>)>>

C<scan()> method parses a bounced email and return results as a array reference.
See Sisimai::Message for more details.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

