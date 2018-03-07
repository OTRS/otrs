package Sisimai::Reason::MailerError;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'mailererror' }
sub description { 'Email returned due to a mailer program has not exited successfully' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $regex = qr{(?>
         \Aprocmail:[ ]    # procmail
        |bin/(?:procmail|maildrop)
        |command[ ](?:
             failed:[ ]
            |died[ ]with[ ]status[ ]\d+
            |output:
            )
        |exit[ ]\d+
        |mailer[ ]error
        |pipe[ ]to[ ][|][/].+
        |x[-]unix[;][ ]\d+  # X-UNIX; 127
        )
    }x;

    return 1 if $argv1 =~ $regex;
    return 0;
}

sub true {
    # The bounce reason is mailer error or not
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is mailer error
    #                                   0: is not mailer error
    # @see http://www.ietf.org/rfc/rfc2822.txt
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::MailerError - Bounce reason is C<mailererror> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::MailerError;
    print Sisimai::Reason::MailerError->match('X-Unix; 255');   # 1

=head1 DESCRIPTION

Sisimai::Reason::MailerError checks the bounce reason is C<mailererror> or not.
This class is called only Sisimai::Reason class.

This is the error that a mailer program has not exited successfully or exited
unexpectedly on a destination mail server.

    X-Actual-Recipient: X-Unix; |/home/kijitora/mail/catch.php
    Diagnostic-Code: X-Unix; 255

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<mailererror>.

    print Sisimai::Reason::MailerError->text;  # mailererror

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::MailerError->match('X-Unix; 255');   # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<mailererror>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2017 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
