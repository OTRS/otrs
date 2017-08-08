package Sisimai::Reason::Vacation;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'vacation' }
sub description { 'Email replied automatically due to a recipient is out of office' }
sub match { return undef }
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

Copyright (C) 2016 azumakuniyuki, All rights reserved.

=head1 LICENSE

This software is distributed under The BSD 2-Clause License.

=cut

