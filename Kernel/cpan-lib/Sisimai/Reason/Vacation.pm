package Sisimai::Reason::Vacation;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'vacation' }
sub description { 'Email replied automatically due to a recipient is out of office' }
sub match {
    # Try to match that the given text and regular expressions
    # @param    [String] argv1  String to be matched with regular expressions
    # @return   [Integer]       0: Did not match
    #                           1: Matched
    # @since v4.22.3
    my $class = shift;
    my $argv1 = shift // return undef;
    my $index = [
        'i am away on vacation',
        'i am away until',
        'i am out of the office',
        'i will be traveling for work on',
    ];

    return 1 if grep { rindex($argv1, $_) > -1 } @$index;
    return 0;
}
sub true  { return undef }
1;

__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Vacation - A recipient is out of office

=head1 SYNOPSIS

    use Sisimai::Reason::Vacation;
    print Sisimai::Reason::Vacation->text; # vacation

=head1 DESCRIPTION

Sisimai::Reason::Vacation is for only returning text and description.
This class is called only from Sisimai->reason method.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<vacation>.

    print Sisimai::Reason::Vacation->text;  # vacation

=head2 C<B<match(I<string>)>>

C<match()> always return undef

=head2 C<B<true(I<Sisimai::Data>)>>

C<true()> always return undef

=head1 AUTHOR

azumakuniyuki

=head1 COPYRIGHT

Copyright (C) 2016-2018 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

