package Sisimai::Reason::ContentError;
use feature ':5.10';
use strict;
use warnings;

sub text { 'contenterror' }
sub description { 'Email rejected due to a header format of the email' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $index = [
        'improper use of 8-bit data in message header',
        'message header size, or recipient list, exceeds policy limit',
        'message mime complexity exceeds the policy maximum',
        'routing loop detected -- too many received: headers',
        'this message contain invalid mime headers',
        'this message contain improperly-formatted binary content',
        'this message contain text that uses unnecessary base64 encoding',
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true { 
    # Rejected email due to header format of the email
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: rejected due to content error
    #                                   0: is not content error
    # @see      http://www.ietf.org/rfc/rfc2822.txt
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::ContentError - Bounce reason is C<contenterror> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::ContentError;
    print Sisimai::Reason::ContentError->match('550 Message Filterd'); # 1

=head1 DESCRIPTION

Sisimai::Reason::ContentError checks the bounce reason is C<contenterror> or not.
This class is called only Sisimai::Reason class.

This is the error that a destination mail server has rejected email due to 
header format of the email like the following. Sisimai will set C<contenterror>
to the reason of email bounce if the value of Status: field in a bounce email 
is "5.6.*".

=over 

=item - 8 bit data in message header

=item - Too many “Received” headers

=item - Invalid MIME headers

=back

    ... while talking to g5.example.net.:
    >>> DATA
    <<< 550 5.6.9 improper use of 8-bit data in message header
    554 5.0.0 Service unavailable

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<contenterror>.

    print Sisimai::Reason::ContentError->text;  # contenterror

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::ContentError->match('550 Message Filterd'); # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<contenterror>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

