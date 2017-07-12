#=======================================================================
#
#   THIS IS A REUSED PERL MODULE, FOR PROPER LICENCING TERMS SEE BELOW:
#
#   Copyright Martin Hosken <Martin_Hosken@sil.org>
#
#   No warranty or expression of effectiveness, least of all regarding
#   anyone's safety, is implied in this software or documentation.
#
#   This specific module is licensed under the Perl Artistic License.
#
#=======================================================================
package PDF::API2::Basic::PDF::Bool;

use base 'PDF::API2::Basic::PDF::String';

use strict;

our $VERSION = '2.033'; # VERSION

=head1 NAME

PDF::API2::Basic::PDF::Bool - A special form of L<PDF::String> which holds the strings
B<true> or B<false>

=head1 METHODS

=head2 $b->convert($str)

Converts a string into the string which will be stored.

=cut

sub convert {
    return $_[1] eq 'true';
}

=head2 as_pdf

Converts the value to a PDF output form

=cut

sub as_pdf {
    return $_[0]->{'val'} ? 'true' : 'false';
}

1;
