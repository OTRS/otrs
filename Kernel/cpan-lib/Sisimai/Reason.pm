package Sisimai::Reason;
use feature ':5.10';
use strict;
use warnings;

my $GetRetried = __PACKAGE__->retry;
my $ClassOrder = [
    [qw|MailboxFull MesgTooBig ExceedLimit Suspend HasMoved NoRelaying UserUnknown
        Filtered Rejected HostUnknown SpamDetected TooManyConn Blocked
    |],
    [qw|MailboxFull SpamDetected PolicyViolation VirusDetected SecurityError
        SystemError NetworkError Suspend Expired ContentError SystemFull
        NotAccept MailerError
    |],
    [qw|MailboxFull MesgTooBig ExceedLimit Suspend UserUnknown Filtered Rejected
        HostUnknown SpamDetected TooManyConn Blocked SpamDetected SecurityError
        SystemError NetworkError Suspend Expired ContentError HasMoved SystemFull
        NotAccept MailerError NoRelaying SyntaxError OnHold
    |],
];
sub retry {
    # Reason list better to retry detecting an error reason
    # @return   [Array] Reason list
    return [qw|undefined onhold systemerror securityerror networkerror hostunknown userunknown|];
}

sub index {
    # All the error reason list Sisimai support
    # @return   [Array] Reason list
    return [qw|
        Blocked ContentError ExceedLimit Expired Filtered HasMoved HostUnknown
        MailboxFull MailerError MesgTooBig NetworkError NotAccept OnHold
        Rejected NoRelaying SpamDetected VirusDetected PolicyViolation SecurityError
        Suspend SystemError SystemFull TooManyConn UserUnknown SyntaxError
    |];
}

sub get {
    # Detect the bounce reason
    # @param    [Sisimai::Data] argvs   Parsed email object
    # @return   [String, Undef]         Bounce reason or Undef if the argument
    #                                   is missing or invalid object
    # @see anotherone
    my $class = shift;
    my $argvs = shift // return undef;
    return undef unless ref $argvs eq 'Sisimai::Data';

    unless( grep { $argvs->reason eq $_ } @$GetRetried ) {
        # Return reason text already decided except reason match with the
        # regular expression of ->retry() method.
        return $argvs->reason if $argvs->reason;
    }
    return 'delivered' if substr($argvs->deliverystatus, 0, 2) eq '2.';

    my $statuscode = $argvs->deliverystatus || '';
    my $reasontext = '';
    my $modulepath = '';

    if( $argvs->diagnostictype eq 'SMTP' || $argvs->diagnostictype eq '' ) {
        # Diagnostic-Code: SMTP; ... or empty value
        for my $e ( @{ $ClassOrder->[0] } ) {
            # Check the value of Diagnostic-Code: and the value of Status:, it is a
            # deliverystats, with true() method in each Sisimai::Reason::* class.
            my $p = 'Sisimai::Reason::'.$e;
            ($modulepath = $p) =~ s|::|/|g; 
            require $modulepath.'.pm';

            next unless $p->true($argvs);
            $reasontext = $p->text;
            last;
        }
    }

    if( not $reasontext || $reasontext eq 'undefined' ) {
        # Bounce reason is not detected yet.
        $reasontext   = __PACKAGE__->anotherone($argvs);
        $reasontext   = '' if $reasontext eq 'undefined';
        $reasontext ||= 'expired' if $argvs->action eq 'delayed';

        unless( $reasontext ) {
            # Try to match with message patterns in Sisimai::Reason::Vacation
            require Sisimai::Reason::Vacation;
            $reasontext = 'vacation' if Sisimai::Reason::Vacation->match(lc $argvs->diagnosticcode);
        }
        $reasontext ||= 'onhold' if $argvs->diagnosticcode;
        $reasontext ||= 'undefined';
    }
    return $reasontext;
}

sub anotherone {
    # Detect the other bounce reason, fall back method for get()
    # @param    [Sisimai::Data] argvs   Parsed email object
    # @return   [String, Undef]         Bounce reason or Undef if the argument
    #                                   is missing or invalid object
    # @see get
    my $class = shift;
    my $argvs = shift // return undef;

    return undef unless ref $argvs eq 'Sisimai::Data';
    return $argvs->reason if $argvs->reason;

    my $diagnostic = lc $argvs->diagnosticcode // '';
    my $statuscode = $argvs->deliverystatus // '';
    my $commandtxt = $argvs->smtpcommand    // '';
    my $trytomatch = undef;
    my $reasontext = '';
    my $modulepath = '';

    require Sisimai::SMTP::Status;
    $reasontext = Sisimai::SMTP::Status->name($statuscode);

    TRY_TO_MATCH: while(1) {
        $trytomatch ||= 1 if $reasontext eq '';
        $trytomatch ||= 1 if grep { $reasontext eq $_ } @$GetRetried;
        $trytomatch ||= 1 if $argvs->diagnostictype ne 'SMTP';
        last unless $trytomatch;

        # Could not decide the reason by the value of Status:
        for my $e ( @{ $ClassOrder->[1] } ) {
            # Trying to match with other patterns in Sisimai::Reason::* classes
            my $p = 'Sisimai::Reason::'.$e;
            ($modulepath = $p) =~ s|::|/|g; 
            require $modulepath.'.pm';

            next unless $p->match($diagnostic);
            $reasontext = lc $e;
            last;
        }

        if( not $reasontext ) {
            # Check the value of Status:
            my $v = substr($statuscode, 0, 3);
            if( $v eq '5.6' || $v eq '4.6' ) {
                #  X.6.0   Other or undefined media error
                $reasontext = 'contenterror';

            } elsif( $v eq '5.7' || $v eq '4.7' ) {
                #  X.7.0   Other or undefined security status
                $reasontext = 'securityerror';

            } elsif( $argvs->diagnostictype eq 'X-UNIX' || $argvs->diagnostictype eq 'X-POSTFIX' ) {
                # Diagnostic-Code: X-UNIX; ...
                $reasontext = 'mailererror';

            } else {
                # 50X Syntax Error?
                require Sisimai::Reason::SyntaxError;
                $reasontext = 'syntaxerror' if Sisimai::Reason::SyntaxError->true($argvs);
            }
        }

        if( not $reasontext ) {
            # Check the value of Action: field, first
            if( $argvs->action =~ /\A(?:delayed|expired)/ ) {
                # Action: delayed, expired
                $reasontext = 'expired';

            } else {
                # Check the value of SMTP command
                if( $commandtxt eq 'EHLO' || $commandtxt eq 'HELO' ) {
                    # Rejected at connection or after EHLO|HELO
                    $reasontext = 'blocked';
                }
            }
        }
        last(TRY_TO_MATCH);
    }
    return $reasontext;
}

sub match {
    # Detect the bounce reason from given text
    # @param    [String] argv1  Error message
    # @return   [String]        Bounce reason
    my $class = shift;
    my $argv1 = shift // return undef;

    require Sisimai::SMTP::Status;
    my $modulepath = '';
    my $reasontext = '';
    my $statuscode = Sisimai::SMTP::Status->find($argv1);
    my $diagnostic = lc $argv1;
    my $typestring = '';
       $typestring = uc($1) if uc($argv1) =~ /\A(SMTP|X-.+);/;

    # Diagnostic-Code: SMTP; ... or empty value
    for my $e ( @{ $ClassOrder->[2] } ) {
        # Check the value of Diagnostic-Code: and the value of Status:, it is a
        # deliverystats, with true() method in each Sisimai::Reason::* class.
        my $p = 'Sisimai::Reason::'.$e;
        ($modulepath = $p) =~ s|::|/|g; 
        require $modulepath.'.pm';

        next unless $p->match($diagnostic);
        $reasontext = $p->text;
        last;
    }

    if( not $reasontext ) {
        # Check the value of $typestring
        if( $typestring eq 'X-UNIX' ) {
            # X-Unix; ...
            $reasontext = 'mailererror';

        } else {
            # Detect the bounce reason from "Status:" code
            $reasontext = Sisimai::SMTP::Status->name($statuscode) || 'undefined';
        }
    }
    return $reasontext;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason - Detect the bounce reason

=head1 SYNOPSIS

    use Sisimai::Reason;

=head1 DESCRIPTION

Sisimai::Reason detects the bounce reason from the content of Sisimai::Data
object as an argument of get() method. This class is called only Sisimai::Data
class.

=head1 CLASS METHODS

=head2 C<B<get(I<Sisimai::Data Object>)>>

C<get()> detects the bounce reason.

=head2 C<B<anotherone(I<Sisimai::Data object>)>>

C<anotherone()> is a method for detecting the bounce reason, it works as a fall
back method of get() and called only from get() method.

C<match()> detects the bounce reason from given text as a error message.

=head2 C<B<match(I<String>)>>

C<match()> is a method for detecting the bounce reason from the string given as
an argument of the method. However, this method is low analytical precision.

=head1 LIST OF BOUNCE REASONS

C<Sisimai::Reason->get()> detects the reason of bounce with parsing the bounced
messages. The following reasons will be set in the value of C<reason> property
of Sisimai::Data instance.

=head2 C<blocked>

This is the error that SMTP connection was rejected due to a client IP address
or a hostname, or the parameter of C<HELO/EHLO> command. This reason has added
in Sisimai 4.0.0 and does not exist in any version of bounceHammer.

    <kijitora@example.net>:
    Connected to 192.0.2.112 but my name was rejected.
    Remote host said: 501 5.0.0 Invalid domain name

=head2 C<contenterror>

This is the error that a destination mail server has rejected email due to
header format of the email like the following. Sisimai will set C<contenterror>
to the reason of email bounce if the value of Status: field in a bounce email
is C<5.6.*>.

=over

=item - 8 bit data in message header

=item - Too many “Received” headers

=item - Invalid MIME headers

=back

    ... while talking to g5.example.net.:
    >>> DATA
    <<< 550 5.6.9 improper use of 8-bit data in message header
    554 5.0.0 Service unavailable

=head2 C<delivered>

This is NOT AN ERROR and means the message you sent has delivered to recipients
successfully.

    Final-Recipient: rfc822; kijitora@neko.nyaan.jp
    Action: deliverable
    Status: 2.1.5
    Remote-MTA: dns; home.neko.nyaan.jp
    Diagnostic-Code: SMTP; 250 2.1.5 OK

=head2 C<exceedlimit>

This is the error that a message was rejected due to an email exceeded the
limit. The value of D.S.N. is C<5.2.3>. This reason is almost the same as
C<MesgTooBig>, we think.

    ... while talking to mx.example.org.:
    >>> MAIL From:<kijitora@example.co.jp> SIZE=16600348
    <<< 552 5.2.3 Message size exceeds fixed maximum message size (10485760)
    554 5.0.0 Service unavailable

=head2 C<expired>

This is the error that delivery time has expired due to connection failure or
network error and the message you sent has been in the queue for long time.

=head2 C<feedback>

The message you sent was forwarded to the sender as a complaint message from
your mailbox provider. When Sismai has set C<feedback> to the reason, the value
of C<feedbacktype> is also set like the following parsed data.

=head2 C<filtered>

This is the error that an email has been rejected by a header content after
SMTP DATA command.
In Japanese cellular phones, the error will incur that a sender's email address
or a domain is rejected by recipient's email configuration. Sisimai will set
C<filtered> to the reason of email bounce if the value of Status: field in a
bounce email is C<5.2.0> or C<5.2.1>.

This error reason is almost the same as UserUnknown.

    ... while talking to mfsmax.ntt.example.ne.jp.:
    >>> DATA
    <<< 550 Unknown user kijitora@ntt.example.ne.jp
    554 5.0.0 Service unavailable

=head2 C<hasmoved>

This is the error that a user's mailbox has moved (and is not forwarded
automatically). Sisimai will set C<hasmoved> to the reason of email bounce if
the value of Status: field in a bounce email is C<5.1.6>.

    <kijitora@example.go.jp>: host mx1.example.go.jp[192.0.2.127] said: 550 5.1.6 recipient
        no longer on server: kijitora@example.go.jp (in reply to RCPT TO command)

=head2 C<hostunknown>

This is the error that a domain part (Right hand side of @ sign) of a
recipient's email address does not exist. In many case, the domain part is
misspelled, or the domain name has been expired. Sisimai will set C<hostunknown>
to the reason of email bounce if the value of Status: field in a bounce mail is
C<5.1.2>.

    Your message to the following recipients cannot be delivered:

    <kijitora@example.cat>:
    <<< No such domain.

=head2 C<mailboxfull>

This is the error that a recipient's mailbox is full. Sisimai will set
C<mailboxfull> to the reason of email bounce if the value of Status: field in a
bounce email is C<4.2.2> or C<5.2.2>.

    Action: failed
    Status: 5.2.2
    Diagnostic-Code: smtp;550 5.2.2 <kijitora@example.jp>... Mailbox Full

=head2 C<mailererror>

This is the error that a mailer program has not exited successfully or exited
unexpectedly on a destination mail server.

    X-Actual-Recipient: X-Unix; |/home/kijitora/mail/catch.php
    Diagnostic-Code: X-Unix; 255

=head2 C<mesgtoobig>

This is the error that a sent email size is too big for a destination mail
server. In many case, There are many attachment files with email, or the file
size is too large. Sisimai will set C<mesgtoobig> to the reason of email bounce
if the value of Status: field in a bounce email is C<5.3.4>.

    Action: failure
    Status: 553 Exceeded maximum inbound message size

=head2 C<networkerror>

This is the error that SMTP connection failed due to DNS look up failure or
other network problems. This reason has added in Sisimai 4.1.12 and does not
exist in any version of bounceHammer.

    A message is delayed for more than 10 minutes for the following
    list of recipients:

    kijitora@neko.example.jp: Network error on destination MXs

=head2 C<norelaying>

This is the error that SMTP connection rejected with error message
C<Relaying Denied>. This reason does not exist in any version of bounceHammer.

    ... while talking to mailin-01.mx.example.com.:
    >>> RCPT To:<kijitora@example.org>
    <<< 554 5.7.1 <kijitora@example.org>: Relay access denied
    554 5.0.0 Service unavailable

=head2 C<notaccept>

This is the error that a destination mail server does ( or can ) not accept any
email. In many case, the server is high load or under the maintenance. Sisimai
will set C<notaccept> to the reason of email bounce if the value of Status:
field in a bounce email is C<5.3.2> or the value of SMTP reply code is 556.

=head2 C<onhold>

Sisimai will set C<onhold> to the reason of email bounce if there is no (or
less) detailed information about email bounce for judging the reason.

=head2 C<policyviolation>

This is the error that a policy violation was detected on a destination mail
server. This reason has been divided from C<securityerror> at Sisimai 4.22.0.

    570 5.7.7 Email not accepted for policy reasons

=head2 C<rejected>

This is the error that a connection to destination server was rejected by a
sender's email address (envelope from). Sisimai set C<rejected> to the reason
of email bounce if the value of Status: field in a bounce email is C<5.1.8> or
the connection has been rejected due to the argument of SMTP MAIL command.

    <kijitora@example.org>:
    Connected to 192.0.2.225 but sender was rejected.
    Remote host said: 550 5.7.1 <root@nijo.example.jp>... Access denied

=head2 C<securityerror>

This is the error that a security violation was detected on a destination mail
server. Depends on the security policy on the server, a sender's email address
is camouflaged address. Sisimai will set C<securityerror> to the reason of email
bounce if the value of Status: field in a bounce email is C<5.7.*>.

    Status: 5.7.0
    Remote-MTA: DNS; gmail-smtp-in.l.google.com
    Diagnostic-Code: SMTP; 552-5.7.0 Our system detected an illegal attachment on your message. Please

=head2 C<spamdetected>

This is the error that the message you sent was rejected by C<spam> filter which
is running on the remote host. This reason has added in Sisimai 4.1.25 and does
not exist in any version of bounceHammer.

    Action: failed
    Status: 5.7.1
    Diagnostic-Code: smtp; 550 5.7.1 Message content rejected, UBE, id=00000-00-000
    Last-Attempt-Date: Thu, 9 Apr 2008 23:34:45 +0900 (JST)

=head2 C<suspend>

This is the error that a recipient account is being suspended due to unpaid or
other reasons.

=head2 C<syntaxerror>

This is the error that a destination mail server could not recognize SMTP command
which is sent from a sender's MTA. This reason has been added at Sisimai v4.17.0.

=over

=item - 503 Improper sequence of commands

=item - 504 Command parameter not implemented

=back

=head2 C<systemerror>

This is the error that an email has bounced due to system error on the remote
host such as LDAP connection failure or other internal system error.

    <kijitora@example.net>:
    Unable to contact LDAP server. (#4.4.3)I'm not going to try again; this
    message has been in the queue too long.

=head2 C<systemfull>

This is the error that a destination mail server's disk (or spool) is full.
Sisimai will set C<systemfull> to the reason of email bounce if the value of
Status: field in a bounce email is C<4.3.1> or C<5.3.1>.

=head2 C<toomanyconn>

This is the error that SMTP connection was rejected temporarily due to too many
concurrency connections to the remote server. This reason has added in Sisimai
4.1.26 and does not exist in any version of bounceHammer.

    <kijitora@example.ne.jp>: host mx02.example.ne.jp[192.0.1.20] said:
        452 4.3.2 Connection rate limit exceeded. (in reply to MAIL FROM command)

=head2 C<userunknown>

This is the error that a local part (Left hand side of @ sign) of a recipient's
email address does not exist. In many case, a user has changed internet service
provider, or has quit company, or the local part is misspelled. Sisimai will set
C<userunknown> to the reason of email bounce if the value of Status: field in a
bounce email is C<5.1.1>, or connection was refused at SMTP RCPT command, or
the contents of Diagnostic-Code: field represents that it is unknown user.

    <kijitora@example.co.jp>: host mx01.example.co.jp[192.0.2.8] said:
      550 5.1.1 Address rejected kijitora@example.co.jp (in reply to
      RCPT TO command)

=head2 C<undefined>

Sisimai could not detect the error reason. In many case, error message is
written in non-English or there are no enough error message in a bounce email
to decide the reason.

=head2 C<vacation>

This is the reason that the recipient is out of office. The bounce message is
generated and returned from auto responder program. This reason has added in
Sisimai 4.1.28 and does not exist in any version of bounceHammer.

=head2 C<virusdetected>

This is the error that an email was rejected by a virus scanner at a destination
mail server. This reason has been divided from C<securityerror> at Sisimai 4.22.

    Your message was infected with a virus. You should download a virus
    scanner and check your computer for viruses.

    Sender:    <sironeko@libsisimai.org>
    Recipient: <kijitora@example.jp>

=head1 SEE ALSO

L<Sisimai::ARF>
L<http://tools.ietf.org/html/rfc5965>
L<https://libsisimai.org/en/reason/>

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
