package Sisimai::Reason::Rejected;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'rejected' }
sub description { "Email rejected due to a sender's email address (envelope from)" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $isnot = [
        '5.1.0 address rejected',
        'recipient address rejected',
        'sender ip address rejected',
    ];
    my $index = [
        '<> invalid sender',
        'address rejected',
        'administrative prohibition',
        'batv failed to verify',    # SoniWall
        'batv validation failure',  # SoniWall
        'backscatter protection detected an invalid or expired email address',  # MDaemon
        'bogus mail from',          # IMail - block empty sender
        'connections not accepted from servers without a valid sender domain',
        'denied [bouncedeny]',      # McAfee
        'delivery not authorized, message refused',
        'does not exist e2110',
        'domain of sender address ',
        'emetteur invalide',
        'empty envelope senders not allowed',
        'error: no third-party dsns',   # SpamWall - block empty sender
        'from: domain is invalid. please provide a valid from:',
        'fully qualified email address required',   # McAfee
        'invalid domain, see <url:',
        'mail from not owned by user',
        'message rejected: email address is not verified',
        'mx records for ',
        'null sender is not allowed',
        'recipient not accepted. (batv: no tag',
        'returned mail not accepted here',
        'rfc 1035 violation: recursive cname records for',
        'rule imposed mailbox access for',  # MailMarshal
        'sender email address rejected',
        'sender is spammer',
        'sender not pre-approved',
        'sender rejected',
        'sender domain is empty',
        'sender verify failed', # Exim callout
        'syntax error: empty email address',
        'the message has been rejected by batv defense',
        'transaction failed unsigned dsn for',
        'unroutable sender address',
        'you are sending to/from an address that has been blacklisted',
    ];

    return 0 if grep { rindex($argv1, $_) > -1 } @$isnot;
    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # Rejected by the envelope sender address or not
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is rejected
    #                                   0: is not rejected by the sender
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return undef;

    my $tempreason = Sisimai::SMTP::Status->name($argvs->deliverystatus) || 'undefined';
    my $diagnostic = lc $argvs->diagnosticcode;

    return 1 if $argvs->reason eq 'rejected';
    return 1 if $tempreason eq 'rejected';  # Delivery status code points "rejected".

    # Check the value of Diagnosic-Code: header with patterns
    if( $argvs->smtpcommand eq 'MAIL' ) {
        # The session was rejected at 'MAIL FROM' command
        return 1 if __PACKAGE__->match($diagnostic);

    } elsif( $argvs->smtpcommand eq 'DATA' ) {
        # The session was rejected at 'DATA' command
        if( $tempreason ne 'userunknown' ) {
            # Except "userunknown"
            return 1 if __PACKAGE__->match($diagnostic);
        }
    } elsif( $tempreason =~ /\A(?:onhold|undefined|securityerror|systemerror)\z/ ) {
        # Try to match with message patterns when the temporary reason
        # is "onhold", "undefined", "securityerror", or "systemerror"
        return 1 if __PACKAGE__->match($diagnostic);
    }
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Rejected - Bounce reason is C<rejected> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::Rejected;
    print Sisimai::Reason::Rejected->match('550 Address rejected');   # 1

=head1 DESCRIPTION

Sisimai::Reason::Rejected checks the bounce reason is C<rejected> or not. This
class is called only Sisimai::Reason class.

This is the error that a connection to destination server was rejected by a 
sender's email address (envelope from). Sisimai set C<rejected> to the reason
of email bounce if the value of Status: field in a bounce email is C<5.1.8> or
the connection has been rejected due to the argument of SMTP MAIL command.

    <kijitora@example.org>:
    Connected to 192.0.2.225 but sender was rejected.
    Remote host said: 550 5.7.1 <root@nijo.example.jp>... Access denied

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<rejected>.

    print Sisimai::Reason::Rejected->text;  # rejected

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::Rejected->match('550 Address rejected');   # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<rejected>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

