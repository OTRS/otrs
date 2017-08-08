package Sisimai::Reason::Delivered;
use feature ':5.10';
use strict;
use warnings;

sub text  { 'delivered' }
sub description { 'Email delivered successfully' }
sub match { return undef }
sub true  { return undef }

1;
__END__

=encoding utf-8

=head1 NAME

Sisimai::Reason::Delivered - Email delivered successfully

=head1 SYNOPSIS

    use Sisimai::Reason::Delivered;
    print Sisimai::Reason::Delivered->text; # delivered

=head1 DESCRIPTION

Sisimai::Reason::Delivered checks the email you sent is delivered successfully
or not by matching diagnostic messages with message patterns. Sisimai will set
"delivered" to the value of "reason" when Status: field in the bounce message
begins with "2" like following:

    Final-Recipient: rfc822; kijitora@neko.nyaan.jp
    Action: deliverable
    Status: 2.1.5
    Diagnostic-Code: SMTP; 250 2.1.5 OK
    
This class is called only Sisimai->reason method. This is NOT AN ERROR reason.

=head1 CLASS METHODS

=head2 C<B<text()>>

C<text()> returns string: C<delivered>.

    print Sisimai::Reason::Delivered->text;  # delivered

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
