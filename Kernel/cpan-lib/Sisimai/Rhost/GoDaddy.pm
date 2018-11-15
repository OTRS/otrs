package Sisimai::Rhost::GoDaddy;
use feature ':5.10';
use strict;
use warnings;

# https://www.godaddy.com/help/what-does-my-email-bounceback-mean-3568
my $ErrorCodes = {
    'IB103' => 'blocked',       # 554 Connection refused. This IP has a poor reputation on Cloudmark Sender Intelligence (CSI). IB103
    'IB104' => 'blocked',       # 554 Connection refused. This IP is listed on the Spamhaus Block List (SBL). IB104
    'IB105' => 'blocked',       # 554 Connection refused. This IP is listed on the Exploits Block List (XBL). IB105
    'IB106' => 'blocked',       # 554 Connection refused. This IP is listed on the Policy Block List (PBL). IB106
    'IB007' => 'toomanyconn',   # 421 Connection refused, too many sessions from This IP. Please lower the number of concurrent sessions. IB007
    'IB101' => 'expired',       # 421 Server temporarily unavailable. Try again later. IB101
    'IB108' => 'blocked',       # 421 Temporarily rejected. Reverse DNS for this IP failed. IB108
    'IB110' => 'blocked',       # 554 This IP has been temporarily blocked for attempting to send too many messages containing content judged to be spam by the Internet community. IB110
    'IB111' => 'blocked',       # 554 This IP has been blocked for the day, for attempting to send too many messages containing content judged to be spam by the Internet community. IB111
    'IB112' => 'blocked',       # 554 This IP has been temporarily blocked for attempting to mail too many invalid recipients. IB112
    'IB113' => 'blocked',       # 554 This IP has been blocked for the day, for attempting to mail too many invalid recipients. IB113
    'IB212' => 'spamdetected',  # 552 This message has been rejected due to content judged to be spam by the Internet community. IB212
    'IB401' => 'securityerror', # 535 Authentication not allowed on IBSMTP Servers. IB401
    'IB501' => 'rejected',      # 550 holly@coolexample.com Blank From: addresses are not allowed. Please provide a valid From. IB501
    'IB502' => 'rejected',      # 550 holly@coolexample.com IP addresses are not allowed as a From: Address. Please provide a valid From. IB502
    'IB504' => 'toomanyconn',   # 550 This IP has sent too many messages this hour. IB504
    'IB506' => 'rejected',      # 550 coolexample.com From: Domain is invalid. Please provide a valid From: IB506
    'IB508' => 'rejected',      # 550 holly@coolexample.com Invalid SPF record. Please inspect your SPF settings, and try again. IB508
    'IB510' => 'toomanyconn',   # 550 This message has exceeded the max number of messages per session. Please open a new session and try again. IB510
    'IB607' => 'toomanyconn',   # 550 This IP has sent too many to too many recipients this hour. IB607
    'IB705' => 'virusdetected', # 552 Virus infected message rejected. IB705

};
my $MessagesOf = {
    'blocked'     => ['553 http://www.spamhaus.org/query/bl?ip=', '554 RBL Reject.'],
    'expired'     => ['Delivery timeout', "451 Sorry, I wasn't able to establish an SMTP connection."],
    'suspend'     => ['Account disabled'],
    'mailboxfull' => ['Account storage limit'],
    'userunknown' => ['Account does not exist', '550 Recipient not found.'],
};

sub get {
    # Detect bounce reason from GoDaddy (smtp.secureserver.net)
    # @param    [Sisimai::Data] argvs   Parsed email object
    # @return   [String]                The bounce reason for GoDaddy
    # @see      https://www.godaddy.com/help/what-does-my-email-bounceback-mean-3568
    my $class = shift;
    my $argvs = shift // return undef;
    return $argvs->reason if $argvs->reason;

    my $statusmesg = $argvs->diagnosticcode;
    my $reasontext = '';

    if( $statusmesg =~ /\s(IB\d{3})\b/ ) {
        # 192.0.2.22 has sent to too many recipients this hour. IB607 ...
        $reasontext = $ErrorCodes->{ $1 };
    } else {
        # 553 http://www.spamhaus.org/query/bl?ip=192.0.0.222
        for my $e ( keys %$MessagesOf ) {
            for my $f ( @{ $MessagesOf->{ $e } } ) {
                next if index($statusmesg, $f) == -1;
                $reasontext = $e;
                last
            }
            last if $reasontext;
        }
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::GoDaddy - Detect the bounce reason returned from GoDaddy.

=head1 SYNOPSIS

    use Sisimai::Rhost;

=head1 DESCRIPTION

Sisimai::Rhost detects the bounce reason from the content of Sisimai::Data
object as an argument of get() method when the value of C<rhost> of the object
end with "secureserver.net". This class is called only Sisimai::Data class.

=head1 CLASS METHODS

=head2 C<B<get(I<Sisimai::Data Object>)>>

C<get()> detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

