package Sisimai::Reason::NetworkError;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'networkerror' }
sub description { 'SMTP connection failed due to DNS look up failure or other network problems' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.1.12
    my $class = shift;
    my $argv1 = shift // return undef;
    my $index = [
        'could not connect and send the mail to',
        'dns records for the destination computer could not be found',
        'hop count exceeded - possible mail loop',
        'host is unreachable',
        'host not found, try again',
        'mail forwarding loop for ',
        'malformed name server reply',
        'malformed or unexpected name server reply',
        'maximum forwarding loop count exceeded',
        'message looping',
        'message probably in a routing loop',
        'no route to host',
        'too many hops',
        'unable to resolve route ',
        'unrouteable mail domain',
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # The bounce reason is network error or not
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is network error
    #                                   0: is not network error
    # @see http://www.ietf.org/rfc/rfc2822.txt
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::NetworkError - Bounce reason is C<networkerror> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::NetworkError;
    print Sisimai::Reason::NetworkError->match('554 5.4.6 Too many hops'); # 1

=head1 DESCRIPTION

Sisimai::Reason::NetworkError checks the bounce reason is C<networkerror> or not.
This class is called only Sisimai::Reason class.

This is the error that SMTP connection failed due to DNS look up failure or 
other network problems. This reason has added in Sisimai 4.1.12 and does not
exist in any version of bounceHammer.

    A message is delayed for more than 10 minutes for the following
    list of recipients:

    kijitora@neko.example.jp: Network error on destination MXs

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<networkerror>.

    print Sisimai::Reason::NetworkError->text;  # networkerror

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::NetworkError->match('5.3.5 System config error'); # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<networkerror>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

