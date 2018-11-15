package Sisimai::Reason::PolicyViolation;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'policyviolation' }
sub description { 'Email rejected due to policy violation on a destination host' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.22.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $index = [
        'because the recipient is not accepting mail with ',    # AOL Phoenix
        'closed mailing list',
        'denied by policy',
        'email not accepted for policy reasons',
        # http://kb.mimecast.com/Mimecast_Knowledge_Base/Administration_Console/Monitoring/Mimecast_SMTP_Error_Codes#554
        'email rejected due to security policies',
        'header are not accepted',
        'header error',
        'message given low priority',
        'message not accepted for policy reasons',
        'messages with multiple addresses',
        'rejected for policy reasons',
        'protocol violation',
        'the email address used to send your message is not subscribed to this group',
        'you have exceeded the allowable number of posts without solving a captcha',
        'you have exceeded the the allowable number of posts without solving a captcha',
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # The bounce reason is security error or not
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is policy violation
    #                                   0: is not policyviolation
    # @since v4.22.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::PolicyViolation - Bounce reason is C<policyviolation> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::PolicyViolation;
    print Sisimai::Reason::PolicyViolation->match('5.7.9 Header error');    # 1

=head1 DESCRIPTION

Sisimai::Reason::PolicyViolation checks the bounce reason is C<policyviolation>
or not. This class is called only Sisimai::Reason class.

This is the error that a policy violation was detected on a destination mail host.
When a header content or a format of the original message violates security policies,
or multiple addresses exist in the From: header, Sisimai will set C<policyviolation>.

    Action: failed
    Status: 5.7.9
    Remote-MTA: DNS; mx.example.co.jp
    Diagnostic-Code: SMTP; 554 5.7.9 Header error

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<policyviolation>.

    print Sisimai::Reason::PolicyViolation->text;  # policyviolation

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::PolicyViolation->match('5.7.9 Header error');    # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<policyviolation>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2017-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

