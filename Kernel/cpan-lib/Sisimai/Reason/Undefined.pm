package Sisimai::Reason::Undefined;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'undefined' }
sub description { 'Sisimai could not detect an error reason' }
sub match { return undef }
sub true  { return undef }
1;

__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Undefined - Sisimai could not detect the error reason.

=head1 SYNOPSIS

    use Sisimai::Reason::Undefined;
    print Sisimai::Reason::Undefined->text; # undefined

=head1 DESCRIPTION

Sisimai::Reason::Undefined is for only returning text and description.
This class is called only from Sisimai->reason method.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<undefined>.

    print Sisimai::Reason::Undefined->text;  # undefined

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
