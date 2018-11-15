package Sisimai::Rhost::GoogleApps;
use feature ':5.10';
use strict;
use warnings;

my $StatusList = {
    # https://support.google.com/a/answer/3726730
    'X.1.1' => [{ 'reason' => 'userunknown', 'string' => ['The email account that you tried to reach does not exist.'] }],
    'X.1.2' => [{ 'reason' => 'hostunknown', 'string' => ["We weren't able to find the recipient domain."] }],
    'X.2.1' => [
        { 'reason' => 'suspend',   'string' => ['The email account that you tried to reach is disabled.'] },
        { 'reason' => 'undefined', 'string' => ['The user you are trying to contact is receiving mail ']  },
    ],
    'X.2.2' => [{ 'reason' => 'mailboxfull', 'string' => ['The email account that you tried to reach is over quota.'] }],
    'X.2.3' => [{ 'reason' => 'exceedlimit', 'string' => ["Your message exceeded Google's message size limits."] }],
    'X.3.0' => [
        { 'reason' => 'syntaxerror', 'string' => ['Multiple destination domains per transaction is unsupported.'] },
        { 'reason' => 'undefined',   'string' => ['Mail server temporarily rejected message.'] },
    ],
    'X.4.2' => [{ 'reason' => 'expired', 'string' => ['Timeout - closing connection.'] }],
    'X.4.5' => [
        { 'reason' => 'exceedlimit', 'string' => ['Daily sending quota exceeded.'] },
        { 'reason' => 'undefined',   'string' => ['Server busy, try again later.'] },
    ],
    'X.5.0' => [{ 'reason' => 'syntaxerror', 'string' => ['SMTP protocol violation'] }],
    'X.5.1' => [
        { 'reason' => 'securityerror', 'string' => ['Authentication Required.'] },
        {
            'reason' => 'syntaxerror',
            'string' => [
                'STARTTLS may not be repeated',
                'Too many unrecognized commands, goodbye.',
                'Unimplemented command.',
                'Unrecognized command.',
                'EHLO/HELO first.',
                'MAIL first.',
                'RCPT first.',
            ],
        },
    ],
    'X.5.2' => [
        { 'reason' => 'securityerror', 'string' => ['Cannot Decode response.'] },   # 2FA related error, maybe.
        { 'reason' => 'syntaxerror',   'string' => ['Syntax error.'] },
    ],
    'X.5.3' => [
        { 'reason' => 'mailboxfull',    'string' => ['Domain policy size per transaction exceeded,'] },
        { 'reason' => 'policyviolation','string' => ['Your message has too many recipients.'] },
    ],
    'X.5.4' => [{ 'reason' => 'syntaxerror', 'string' => ['Optional Argument not permitted for that AUTH mode.'] }],
    'X.6.0' => [
        { 'reason' => 'contenterror', 'string' => ['Mail message is malformed.'] },
        { 'reason' => 'networkerror', 'string' => ['Message exceeded 50 hops'] }
    ],
    'X.7.0' => [
        {
            'reason' => 'blocked',
            'string' => [
                'IP not in whitelist for RCPT domain, closing connection.',
                'Our system has detected an unusual rate of unsolicited mail originating from your IP address.',
            ],
        },
        {
            'reason' => 'expired',
            'string' => [
                'Temporary System Problem. Try again later.',
                'Try again later, closing connection.',
            ],
        },
        {
            'reason' => 'securityerror',
            'string' => [
                'TLS required for RCPT domain, closing connection.',
                'No identity changes permitted.',
                'Must issue a STARTTLS command first.',
                'Too Many Unauthenticated commands.',
            ],
        },
        { 'reason' => 'systemerror', 'string' => ['Cannot authenticate due to temporary system problem.'] },
        { 'reason' => 'norelaying',  'string' => ['Mail relay denied.'] },
        { 'reason' => 'rejected',    'string' => ['Mail Sending denied.'] },
    ],
    'X.7.1' => [
        { 'reason' => 'mailboxfull', 'string' => ['Email quota exceeded.'] },
        {
            'reason' => 'securityerror',
            'string' => [
                'Application-specific password required.',
                'Please log in with your web browser and then try again.',
                'Username and Password not accepted.',
            ],
        },
        {
            'reason' => 'blocked',
            'string' => [
                'Our system has detected an unusual rate of unsolicited mail originating from your IP address.',
                "The IP you're using to send mail is not authorized to send email directly to our servers.",
            ],
        },
        { 'reason' => 'spamdetected',   'string' => ['Our system has detected that this message is likely unsolicited mail.'] },
        { 'reason' => 'policyviolation','string' => ['The user or domain that you are sending to (or from) has a policy'] },
        { 'reason' => 'rejected',       'string' => ['Unauthenticated email is not accepted from this domain.'] },
    ],
    'X.7.4' => [{ 'reason' => 'syntaxerror', 'string' => ['Unrecognized Authentication Type.'] }],
};

sub get {
    # Detect bounce reason from Google Apps
    # @param    [Sisimai::Data] argvs   Parsed email object
    # @return   [String]                The bounce reason for Google Apps
    # @see      https://support.google.com/a/answer/3726730?hl=en
    my $class = shift;
    my $argvs = shift // return undef;
    return $argvs->reason if $argvs->reason;

    my $reasontext = '';
    my $statuscode = $argvs->deliverystatus;

    substr($statuscode, 0, 1, 'X');
    return '' unless scalar @{ $StatusList->{ $statuscode } };

    for my $e ( @{ $StatusList->{ $statuscode } } ) {
        # Try to match
        next unless grep { rindex($argvs->diagnosticcode, $_) > -1 } @{ $e->{'string'} };
        $reasontext = $e->{'reason'};
        last;
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Rhost::GoogleApps - Detect the bounce reason returned from Google Apps.

=head1 SYNOPSIS

    use Sisimai::Rhost;

=head1 DESCRIPTION

Sisimai::Rhost detects the bounce reason from the content of Sisimai::Data
object as an argument of get() method when the value of C<rhost> of the object
is "aspmx.l.google.com". This class is called only Sisimai::Data class.

=head1 CLASS METHODS

=head2 C<B<get(I<Sisimai::Data Object>)>>

C<get()> detects the bounce reason.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
