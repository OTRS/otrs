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
package PDF::API2::Basic::PDF::Utils;

use strict;

our $VERSION = '2.033'; # VERSION

=head1 NAME

PDF::API2::Basic::PDF::Utils - Utility functions for PDF library

=head1 DESCRIPTION

A set of utility functions to save the fingers of the PDF library users!

=head1 FUNCTIONS

=cut

use PDF::API2::Basic::PDF::Array;
use PDF::API2::Basic::PDF::Bool;
use PDF::API2::Basic::PDF::Dict;
use PDF::API2::Basic::PDF::Name;
use PDF::API2::Basic::PDF::Null;
use PDF::API2::Basic::PDF::Number;
use PDF::API2::Basic::PDF::String;
use PDF::API2::Basic::PDF::Literal;

use Exporter;
use vars qw(@EXPORT @ISA);
@ISA = qw(Exporter);
@EXPORT = qw(PDFBool PDFArray PDFDict PDFName PDFNull
             PDFNum PDFStr PDFStrHex PDFUtf);

=head2 PDFBool

Creates a Bool via PDF::API2::Basic::PDF::Bool->new

=cut

sub PDFBool {
    return PDF::API2::Basic::PDF::Bool->new(@_);
}

=head2 PDFArray

Creates an array via PDF::API2::Basic::PDF::Array->new

=cut

sub PDFArray {
    return PDF::API2::Basic::PDF::Array->new(@_);
}

=head2 PDFDict

Creates a dict via PDF::API2::Basic::PDF::Dict->new

=cut

sub PDFDict {
    return PDF::API2::Basic::PDF::Dict->new(@_);
}

=head2 PDFName

Creates a name via PDF::API2::Basic::PDF::Name->new

=cut

sub PDFName {
    return PDF::API2::Basic::PDF::Name->new(@_);
}

=head2 PDFNull

Creates a null via PDF::API2::Basic::PDF::Null->new

=cut

sub PDFNull {
    return PDF::API2::Basic::PDF::Null->new(@_);
}

=head2 PDFNum

Creates a number via PDF::API2::Basic::PDF::Number->new

=cut

sub PDFNum {
    return PDF::API2::Basic::PDF::Number->new(@_);
}

=head2 PDFStr

Creates a string via PDF::API2::Basic::PDF::String->new

=cut

sub PDFStr {
    return PDF::API2::Basic::PDF::String->new(@_);
}

=head2 PDFStrHex

Creates a hex-string via PDF::API2::Basic::PDF::String->new

=cut

sub PDFStrHex {
    my $string = PDF::API2::Basic::PDF::String->new(@_);
    $string->{' ishex'} = 1;
    return $string;
}

=head2 PDFUtf

Creates a utf8-string via PDF::API2::Basic::PDF::String->new

=cut

sub PDFUtf {
    my $string = PDF::API2::Basic::PDF::String->new(@_);
    $string->{' isutf'} = 1;
    return $string;
}

1;
