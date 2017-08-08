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
    my $regex = qr{(?>
         domain[ ](?:
             does[ ]not[ ]exist
            |must[ ]exist
            |is[ ]not[ ]reachable
            )
        |host[ ](?:
             or[ ]domain[ ]name[ ]not[ ]found
            |unknown
            |unreachable
            )
        |Mail[ ]domain[ ]mentioned[ ]in[ ]email[ ]address[ ]is[ ]unknown
        |name[ ]or[ ]service[ ]not[ ]known
        |no[ ]such[ ]domain
        |recipient[ ](?:
            address[ ]rejected:[ ]unknown[ ]domain[ ]name
            domain[ ]must[ ]exist
            )
        |unknown[ ]host
        )
    }ix;

    return 1 if $argv1 =~ $regex;
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

    return undef unless ref $argvs eq 'Sisimai::Data';
    return 1 if $argvs->reason eq __PACKAGE__->text;

    require Sisimai::SMTP::Status;
    my $statuscode = $argvs->deliverystatus // '';
    my $diagnostic = $argvs->diagnosticcode // '';
    my $tempreason = Sisimai::SMTP::Status->name($statuscode);
    my $reasontext = __PACKAGE__->text;
    my $v = 0;

    if( $tempreason eq $reasontext ) {
        # Status: 5.1.2
        # Diagnostic-Code: SMTP; 550 Host unknown
        $v = 1;

    } else {
        # Check the value of Diagnosic-Code: header with patterns
        $v = 1 if __PACKAGE__->match($diagnostic);
    }

    return $v;
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

Copyright (C) 2014-2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
