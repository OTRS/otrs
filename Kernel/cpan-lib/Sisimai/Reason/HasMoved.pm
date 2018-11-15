package Sisimai::Reason::HasMoved;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'hasmoved' }
sub description { "Email rejected due to user's mailbox has moved and is not forwarded automatically" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.1.25
    my $class = shift;
    my $argv1 = shift // return undef;
    my $index = [' has been replaced by '];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # Whether the address has moved or not
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: The address has moved
    #                                   0: Has not moved
    # @since v4.1.25
    # @see http://www.ietf.org/rfc/rfc2822.txt
    my $class = shift;
    my $argvs = shift // return undef;

    return 1 if $argvs->reason eq 'hasmoved';
    return 1 if __PACKAGE__->match(lc $argvs->diagnosticcode);
    return 0;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::HasMoved - Bounce reason is C<hasmoved> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::HasMoved;
    print Sisimai::Reason::HasMoved->match('address neko@example.jp has been replaced by ...');   # 1

=head1 DESCRIPTION

Sisimai::Reason::HasMoved checks the bounce reason is C<hasmoved> or not. This
class is called only Sisimai::Reason class.

This is the error that a user's mailbox has moved (and is not forwarded 
automatically). Sisimai will set C<hasmoved> to the reason of email bounce if
the value of Status: field in a bounce email is C<5.1.6>.

    <kijitora@example.go.jp>: host mx1.example.go.jp[192.0.2.127] said: 550 5.1.6 recipient
        no longer on server: kijitora@example.go.jp (in reply to RCPT TO command)

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<hasmoved>.

    print Sisimai::Reason::HasMoved->text;  # hasmoved

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::HasMoved->match('address cat@example.jp has been replaced by ');   # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<hasmoved>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2015-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
