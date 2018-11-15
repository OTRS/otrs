package Sisimai::Reason::Expired;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'expired' }
sub description { 'Delivery time has expired due to a connection failure' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $index = [
        'connection timed out',
        'could not find a gateway for',
        'delivery time expired',
        'failed to deliver to domain ',
        'giving up on',
        'has been delayed',
        'it has not been collected after',
        'message expired after sitting in queue for',
        'message expired, connection refulsed',
        'message timed out',
        'retry time not reached for any host after a long failure period',
        'server did not respond',
        'this message has been in the queue too long',
        'unable to deliver message after multiple retries',
        'was not reachable within the allowed queue period',
        'your message could not be delivered for more than',
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # Delivery expired due to connection failure or network error
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is expired
    #                                   0: is not expired
    # @see      http://www.ietf.org/rfc/rfc2822.txt
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Expired - Bounce reason is C<expired> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::Expired;
    print Sisimai::Reason::Expired->match('400 Delivery time expired');   # 1

=head1 DESCRIPTION

Sisimai::Reason::Expired checks the bounce reason is C<expired> or not. This
class is called only Sisimai::Reason class.

This is the error that delivery time has expired due to connection failure or
network error and the message you sent has been in the queue for long time.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<expired>.

    print Sisimai::Reason::Expired->text;  # expired

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::Expired->match('400 Delivery time expired');   # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<expired>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

