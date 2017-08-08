package Sisimai::Rhost::GoogleApps;
use feature ':5.10';
use strict;
use warnings;

my $CodeTable = {
    'X.1.1' => [
        {
            'reason' => 'userunknown',
            'regexp' => [ qr/The email account that you tried to reach does not exist[.]/ ],
        }
    ],
    'X.1.2' => [
        {
            'reason' => 'hostunknown',
            'regexp' => [ qr/We weren't able to find the recipient domain[.]/ ],
        },
    ],
    'X.2.1' => [
        {
            'reason' => 'undefined',
            'regexp' => [
                qr/The user you are trying to contact is receiving mail too quickly[.]/,
                qr/The user you are trying to contact is receiving mail at a rate/,
            ],
        },
        {
            'reason' => 'suspend',
            'regexp' => [ qr/The email account that you tried to reach is disabled[.]/ ],
        },
    ],
    'X.2.2' => [
        {
            'reason' => 'mailboxfull',
            'regexp' => [ qr/The email account that you tried to reach is over quota[.]/ ],
        },
    ],
    'X.2.3' => [
        {
            'reason' => 'exceedlimit',
            'regexp' => [ qr/Your message exceeded Google's message size limits[.]/ ],
        },
    ],
    'X.3.0' => [
        {
            'reason' => 'undefined',
            'regexp' => [
                qr/Mail server temporarily rejected message[.]/,
                qr/Multiple destination domains per transaction is unsupported[.]/,
            ],
        },
    ],
    'X.4.2' => [
        {
            'reason' => 'expired',
            'regexp' => [ qr/Timeout [-] closing connection[.]/ ],
        },
    ],
    'X.4.5' => [
        {
            'reason' => 'undefined',
            'regexp' => [ qr/Server busy, try again later[.]/ ],
        },
        {
            'reason' => 'exceedlimit',
            'regexp' => [ qr/Daily sending quota exceeded[.]/ ],
        },
    ],
    'X.5.0' => [
        {
            'reason' => 'undefined',
            'regexp' => [ 
                qr/SMTP protocol violation, see RFC 2821[.]/,
                qr/SMTP protocol violation, no commands allowed to pipeline after STARTTLS/,
            ],
        },
    ],
    'X.5.1' => [
        {
            'reason' => 'syntaxerror',
            'regexp' => [
                qr/STARTTLS may not be repeated[.]/,
                qr/Too many unrecognized commands, goodbye[.]/,
                qr/Unimplemented command[.]/,
                qr/Unrecognized command[.]/,
                qr|EHLO/HELO first[.]|,
                qr/MAIL first[.]/,
                qr/RCPT first[.]/,
            ],
        },
        {
            'reason' => 'securityerror',
            'regexp' => [ qr/Authentication Required[.]/ ],
        },
    ],
    'X.5.2' => [
        {
            'reason' => 'undefined',
            'regexp' => [ qr/Cannot Decode response[.]/ ],
        },
        {
            'reason' => 'syntaxerror',
            'regexp' => [ qr/Syntax error[.]/ ],
        },
    ],
    'X.5.3' => [
        {
            'reason' => 'undefined',
            'regexp' => [
                qr/Domain policy size per transaction exceeded[,]/,
                qr/Your message has too many recipients[.]/,
            ],
        },
    ],
    'X.5.4' => [
        {
            'reason' => 'syntaxerror',
            'regexp' => [ qr/Optional Argument not permitted for that AUTH mode[.]/ ],
        },
    ],
    'X.6.0' => [
        {
            'reason' => 'contenterror',
            'regexp' => [
                qr/Mail message is malformed[.]/,
                qr/Message exceeded 50 hops/,
            ],
        },
    ],
    'X.7.0' => [
        {
            'reason' => 'blocked',
            'regexp' => [
                qr/IP not in whitelist for RCPT domain, closing connection[.]/,
                qr/Our system has detected an unusual rate of unsolicited mail originating from your IP address[.]/,
            ],
        },
        {
            'reason' => 'expired',
            'regexp' => [
                qr/Temporary System Problem. Try again later[.]/,
                qr/Try again later, closing connection[.]/,
            ],
        },
        {
            'reason' => 'securityerror',
            'regexp' => [
                qr/TLS required for RCPT domain, closing connection[.]/,
                qr/No identity changes permitted[.]/,
                qr/Must issue a STARTTLS command first[.]/,
                qr/Too Many Unauthenticated commands[.]/,
            ],
        },
        {
            'reason' => 'systemerror',
            'regexp' => [ qr/Cannot authenticate due to temporary system problem[.]/ ],
        },
        {
            'reason' => 'norelaying',
            'regexp' => [ qr/Mail relay denied[.]/ ],
        },
        {
            'reason' => 'rejected',
            'regexp' => [ qr/Mail Sending denied[.]/ ],
        },
    ],
    'X.7.1' => [
        {
            'reason' => 'securityerror',
            'regexp' => [
                qr/Application-specific password required[.]/,
                qr/Please log in with your web browser and then try again[.]/,
                qr/Username and Password not accepted[.]/,
            ],
        },
        {
            'reason' => 'mailboxfull',
            'regexp' => [ qr/Email quota exceeded[.]/ ],
        },
        {
            'reason' => 'blocked',
            'regexp' => [
                qr/Our system has detected an unusual rate of unsolicited mail originating from your IP address[.]/,
                qr/The IP you[']re using to send mail is not authorized to send email directly to our servers[.]/,
            ],
        },
        {
            'reason' => 'contenterror',
            'regexp' => [ qr/Our system has detected that this message is likely unsolicited mail[.]/ ],
        },
        {
            'reason' => 'filtered',
            'regexp' => [ qr/The user or domain that you are sending to [(]or from[)] has a policy/ ],
        },
        {
            'reason' => 'rejected',
            'regexp' => [ qr/Unauthenticated email is not accepted from this domain[.]/ ],
        },
    ],
    'X.7.4' => [
        {
            'reason' => 'securityerror',
            'regexp' => [ qr/Unrecognized Authentication Type[.]/ ],
        },
    ],
};

sub get {
    # Detect bounce reason from Google Apps
    # @param    [Sisimai::Data] argvs   Parsed email object
    # @return   [String]                The bounce reason for Google Apps
    # @see      https://support.google.com/a/answer/3726730?hl=en
    my $class = shift;
    my $argvs = shift // return undef;

    return undef unless ref $argvs eq 'Sisimai::Data';
    return $argvs->reason if length $argvs->reason;

    my $statuscode =  $argvs->deliverystatus;
       $statuscode =~ s/\A\d[.](\d+[.]\d+)\z/X.$1/;

    my $statusmesg = $argvs->diagnosticcode;
    my $reasontext = '';
    my $errortable = $CodeTable->{ $statuscode } || [];

    for my $e ( @$errortable ) {
        # Try to match
        next unless grep { $statusmesg =~ $_ } @{ $e->{'regexp'} };
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

Copyright (C) 2014-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
