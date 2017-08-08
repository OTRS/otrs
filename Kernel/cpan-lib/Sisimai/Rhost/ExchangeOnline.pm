package Sisimai::Rhost::ExchangeOnline;
use feature ':5.10';
use strict;
use warnings;

# https://technet.microsoft.com/en-us/library/bb232118
my $CodeTable = {
    qr/\A4[.]3[.]1\z/ => [
        {
            'reason' => 'systemfull',
            'regexp' => qr/Insufficient system resources/,
        },
    ],
    qr/\A4[.]3[.]2\z/ => [
        {
            'reason' => 'notaccept',
            'regexp' => qr/System not accepting network messages/,
        },
    ],
    qr/\A4[.]4[.][17]\z/ => [
        {
            'reason' => 'expired',
            'regexp' => qr/(?:Connection[ ]timed[ ]out|Message[ ]expired)/x,
        },
    ],
    qr/\A4[.]4[.]2\z/ => [
        {
            'reason' => 'blocked',
            'regexp' => qr/Connection dropped/,
        },
    ],
    qr/\A4[.]7[.]26\z/ => [
        {
            'reason' => 'securityerror',
            'regexp' => qr/Access denied, a message sent over IPv6 .+ must pass either SPF or DKIM validation, this message is not signed/,
        },
    ],
    qr/\A4[.]7[.][568]\d{2}\z/ => [
        {
            'reason' => 'securityerror',
            'regexp' => qr/Access denied, please try again later/,
        },
    ],
    qr/\A5[.]0[.]0\z/ => [
        {
            'reason' => 'blocked',
            'regexp' => qr|HELO / EHLO requires domain address|,
        },
    ],
    qr/\A5[.]1[.][07]\z/ => [
        {
            'reason' => 'rejected',
            'regexp' => qr/(?:Sender[ ]denied|Invalid[ ]address)/x,
        },
    ],
    qr/\A5[.]1[.][123]\z/ => [
        {
            'reason' => 'userunknown',
            'regexp' => qr{(?:
                 Bad[ ]destination[ ]mailbox[ ]address
                |Invalid[ ]X[.]400[ ]address
                |Invalid[ ]recipient[ ]address
                )
            }x,
        },
    ],
    qr/\A5[.]1[.]4\z/ => [
        {
            'reason' => 'systemerror',
            'regexp' => qr/Destination mailbox address ambiguous/,
        },
    ],
    qr/\A5[.]2[.]1\z/ => [
        {
            'reason' => 'suspend',
            'regexp' => qr/Mailbox cannot be accessed/,
        },
    ],
    qr/\A5[.]2[.]2\z/ => [
        {
            'reason' => 'mailboxfull',
            'regexp' => qr/Mailbox full/,
        },
    ],
    qr/\A5[.]2[.]3\z/ => [
        {
            'reason' => 'exceedlimit',
            'regexp' => qr/Message too large/,
        },
    ],
    qr/\A5[.]2[.]4\z/ => [
        {
            'reason' => 'systemerror',
            'regexp' => qr/Mailing list expansion problem/,
        },
    ],
    qr/\A5[.]3[.]3\z/ => [
        {
            'reason' => 'systemfull',
            'regexp' => qr/Unrecognized command/,
        },
    ],
    qr/\A5[.]3[.]4\z/ => [
        {
            'reason' => 'mesgtoobig',
            'regexp' => qr/Message too big for system/,
        },
    ],
    qr/\A5[.]3[.]5\z/ => [
        {
            'reason' => 'systemerror',
            'regexp' => qr/System incorrectly configured/,
        },
    ],
    qr/\A5[.]4[.][46]\z/ => [
        {
            'reason' => 'networkerror',
            'regexp' => qr/(?:Invalid[ ]arguments|Routing[ ]loop[ ]detected)/x,
        },
    ],
    qr/\A5[.]5[.]2\z/ => [
        {
            'reason' => 'syntaxerror',
            'regexp' => qr/Send hello first/,
        },
    ],
    qr/\A5[.]5[.]3\z/ => [
        {
            'reason' => 'syntaxerror',
            'regexp' => qr/Too many recipients/,
        },
    ],
    qr/\A5[.]5[.]4\z/ => [
        {
            'reason' => 'filtered',
            'regexp' => qr/Invalid domain name/,
        },
    ],
    qr/\A5[.]5[.]6\z/ => [
        {
            'reason' => 'contenterror',
            'regexp' => qr/Invalid message content/,
        },
    ],
    qr/\A5[.]7[.][13]\z/ => [
        {
            'reason' => 'securityerror',
            'regexp' => qr/(?:Delivery[ ]not[ ]authorized|Not[ ]Authorized)/x,
        },
    ],
    qr/\A5[.]7[.]1\z/ => [
        {
            'reason' => 'securityerror',
            'regexp' => qr/(?:Delivery[ ]not[ ]authorized|Client[ ]was[ ]not[ ]authenticated)/x,
        },
        {
            'reason' => 'norelaying',
            'regexp' => qr/Unable to relay/,
        },
    ],
    qr/\A5[.]7[.]25\z/ => [
        {
            'reason' => 'securityerror',
            'regexp' => qr/Access denied, the sending IPv6 address .+ must have a reverse DNS record/,
        },
    ],
    qr/\A5[.]7[.]50[1-3]\z/ => [
        {
            'reason' => 'spamdetected',
            'regexp' => qr/Access[ ]denied,[ ](?:spam[ ]abuse[ ]detected|banned[ ]sender)/x,
        },
    ],
    qr/\A5[.]7[.]50[457]\z/ => [
        {
            'reason' => 'filtered',
            'regexp' => qr{(?>
                 Recipient[ ]address[ ]rejected:[ ]Access[ ]denied
                |Access[ ]denied,[ ](?:
                     banned[ ]recipient
                    |rejected[ ]by[ ]recipient
                    )
                )
            },
        },
    ],
    qr/\A5[.]7[.]506\z/ => [
        {
            'reason' => 'blocked',
            'regexp' => qr/Access Denied, Bad HELO/,
        },
    ],
    qr/\A5[.]7[.]508\z/ => [
        {
            'reason' => 'toomanyconn',
            'regexp' => qr/Access denied, .+ has exceeded permitted limits within .+ range/,
        },
    ],
    qr/\A5[.]7[.]509\z/ => [
        {
            'reason' => 'securityerror',
            'regexp' => qr/Access denied, sending domain .+ does not pass DMARC verification/,
        },
    ],
    qr/\A5[.]7[.]510\z/ => [
        {
            'reason' => 'notaccept',
            'regexp' => qr/Access denied, .+ does not accept email over IPv6/,
        },
    ],
    qr/\A5[.]7[.]511\z/ => [
        {
            'reason' => 'blocked',
            'regexp' => qr/Access denied, banned sender/,
        },
    ],
    qr/\A5[.]7[.]512\z/ => [
        {
            'reason' => 'contenterror',
            'regexp' => qr/Access denied, message must be RFC 5322 section 3[.]6[.]2 compliant/,
        },
    ],
    qr/\A5[.]7[.]6\d{2}\z/ => [
        {
            'reason' => 'blocked',
            'regexp' => qr/Access[ ]denied,[ ]banned[ ]sending[ ]IP[ ].+/,
        },
    ],
    qr/\A5[.]7[.]7\d{2}\z/ => [
        {
            'reason' => 'toomanyconn',
            'regexp' => qr/Access denied, tenant has exceeded threshold/,
        },
    ],
};

sub get {
    # Detect bounce reason from Exchange 2013 and Office 365
    # @param    [Sisimai::Data] argvs   Parsed email object
    # @return   [String]                The bounce reason for Exchange Online
    # @see      https://technet.microsoft.com/en-us/library/bb232118
    my $class = shift;
    my $argvs = shift // return undef;

    return undef unless ref $argvs eq 'Sisimai::Data';
    return $argvs->reason if length $argvs->reason;

    my $statuscode = $argvs->deliverystatus;
    my $statusmesg = $argvs->diagnosticcode;
    my $reasontext = '';

    for my $e ( keys %$CodeTable ) {
        # Try to match with each regular expression of delivery status codes
        next unless $statuscode =~ $e;
        for my $f ( @{ $CodeTable->{ $e } } ) {
            # Try to match with each regular expression of error messages
            next unless $statusmesg =~ $f->{'regexp'};
            $reasontext = $f->{'reason'};
            last;
        }
        last;
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::ExchangeOnline - Detect the bounce reason returned from on-premises
Exchange 2013 and Office 365.

=head1 SYNOPSIS

    use Sisimai::Rhost;

=head1 DESCRIPTION

Sisimai::Rhost detects the bounce reason from the content of Sisimai::Data
object as an argument of get() method when the value of C<rhost> of the object
is "*.protection.outlook.com". This class is called only Sisimai::Data class.

=head1 CLASS METHODS

=head2 C<B<get(I<Sisimai::Data Object>)>>

C<get()> detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

