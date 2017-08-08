package Sisimai::Reason::Feedback;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'feedback' }
sub description { 'Email forwarded to the sender as a complaint message from your mailbox provider' }
sub match { return undef }
sub true  { return undef }
1;

__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Feedback - Email forwarded as a complaint message

=head1 SYNOPSIS

    use Sisimai::Reason::Feedback;
    print Sisimai::Reason::Feedback->text; # feedback

=head1 DESCRIPTION

Sisimai::Reason::Feedback is for only returning text and description.
This class is called only from Sisimai->reason method and Sisimai::ARF class.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<feedback>.

    print Sisimai::Reason::Feedback->text;  # feedback

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

