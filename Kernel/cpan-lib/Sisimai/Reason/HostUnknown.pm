package Sisimai::Reason::HostUnknown;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'hostunknown' }
sub description { "Delivery failed due to a domain part of a recipient's email address does not exist" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $index = [
        'domain does not exist',
        'domain is not reachable',
        'domain must exist',
        'host or domain name not found',
        'host unknown',
        'host unreachable',
        'mail domain mentioned in email address is unknown',
        'name or service not known',
        'no such domain',
        'recipient address rejected: unknown domain name',
        'recipient domain must exist',
        'the account or domain may not exist',
        'unknown host',
        'unrouteable address',
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # Whether the host is unknown or not
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is unknown host 
    #           [Integer]               0: is not unknown host.
    # @since v4.0.0
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return undef;
    return 1 if $argvs->reason eq 'hostunknown';

    my $statuscode = $argvs->deliverystatus // '';
    my $diagnostic = lc $argvs->diagnosticcode // '';

    if( Sisimai::SMTP::Status->name($statuscode) eq 'hostunknown' ) {
        # Status: 5.1.2
        # Diagnostic-Code: SMTP; 550 Host unknown
        require Sisimai::Reason::NetworkError;
        return 1 unless Sisimai::Reason::NetworkError->match($diagnostic);
    } else {
        # Check the value of Diagnosic-Code: header with patterns
        return 1 if __PACKAGE__->match($diagnostic);
    }
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::HostUnknown - Bounce reason is C<hostunknown> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::HostUnknown;
    print Sisimai::Reason::HostUnknown->match('550 5.2.1 Host Unknown');   # 1

=head1 DESCRIPTION

Sisimai::Reason::HostUnknown checks the bounce reason is C<hostunknown> or not.
This class is called only Sisimai::Reason class.

This is the error that a domain part (Right hand side of @ sign) of a 
recipient's email address does not exist. In many case, the domain part is 
misspelled, or the domain name has been expired. Sisimai will set C<hostunknown>
to the reason of email bounce if the value of Status: field in a bounce mail is
C<5.1.2>.

    Your message to the following recipients cannot be delivered:

    <kijitora@example.cat>:
    <<< No such domain.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<hostunknown>.

    print Sisimai::Reason::HostUnknown->text;  # hostunknown

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::HostUnknown->match('550 5.2.1 Host Unknown');   # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<hostunknown>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
