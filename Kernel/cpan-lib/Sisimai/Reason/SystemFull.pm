package Sisimai::Reason::SystemFull;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'systemfull' }
sub description { "Email rejected due to a destination mail server's disk is full" }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.0.0
    my $class = shift;
    my $argv1 = shift // return undef;
    my $index = [
        'mail system full',
        'requested mail action aborted: exceeded storage allocation',   # MS Exchange
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}

sub true {
    # The bounce reason is system full or not
    # @param    [Sisimai::Data] argvs   Object to be detected the reason
    # @return   [Integer]               1: is system full
    #                                   0: is not system full
    # @see http://www.ietf.org/rfc/rfc2822.txt
    return undef;
}

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::SystemFull - Bounce reason is C<systemfull> or not.

=head1 SYNOPSIS

    use Sisimai::Reason::SystemFull;
    print Sisimai::Reason::SystemFull->match('Mail System Full');   # 1

=head1 DESCRIPTION

Sisimai::Reason::SystemFull checks the bounce reason is C<systemfull> or not.
This class is called only Sisimai::Reason class.

This is the error that a destination mail server's disk (or spool) is full.
Sisimai will set C<systemfull> to the reason of email bounce if the value of
Status: field in a bounce email is C<4.3.1> or C<5.3.1>.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<systemfull>.

    print Sisimai::Reason::SystemFull->text;  # systemfull

=head2 C<B<match(I<string>)>>

C<match()> returns 1 if the argument matched with patterns defined in this class.

    print Sisimai::Reason::SystemFull->match('Mail System Full');   # 1

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> returns 1 if the bounce reason is C<systemfull>. The argument must be
Sisimai::Data object and this method is called only from Sisimai::Reason class.

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2014-2016,2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut
