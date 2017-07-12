package Excel::Writer::XLSX::Package::XMLwriter;

###############################################################################
#
# XMLwriter - A base class for the Excel::Writer::XLSX writer classes.
#
# Used in conjunction with Excel::Writer::XLSX
#
# Copyright 2000-2016, John McNamara, jmcnamara@cpan.org
#
# Documentation after __END__
#

# perltidy with the following options: -mbl=2 -pt=0 -nola

use 5.008002;
use strict;
use warnings;
use Exporter;
use Carp;
use IO::File;

our @ISA     = qw(Exporter);
our $VERSION = '0.95';

#
# NOTE: this module is a light weight re-implementation of XML::Writer. See
# the Pod docs below for a full explanation. The methods  are implemented
# for speed rather than readability since they are used heavily in tight
# loops by Excel::Writer::XLSX.
#

# Note "local $\ = undef" protect print statements from -l on commandline.


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;

    # FH may be undef and set later in _set_xml_writer(), see below.
    my $fh = shift;

    my $self = { _fh => $fh };

    bless $self, $class;

    return $self;
}


###############################################################################
#
# _set_xml_writer()
#
# Set the XML writer filehandle for the object. This can either be done
# in the constructor (usually for testing since the file name isn't generally
# known at that stage) or later via this method.
#
sub _set_xml_writer {

    my $self     = shift;
    my $filename = shift;

    my $fh = IO::File->new( $filename, 'w' );
    croak "Couldn't open file $filename for writing.\n" unless $fh;

    binmode $fh, ':utf8';

    $self->{_fh} = $fh;
}


###############################################################################
#
# xml_declaration()
#
# Write the XML declaration.
#
sub xml_declaration {

    my $self = shift;
    local $\ = undef;

    print { $self->{_fh} }
      qq(<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n);

}


###############################################################################
#
# xml_start_tag()
#
# Write an XML start tag with optional attributes.
#
sub xml_start_tag {

    my $self = shift;
    my $tag  = shift;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;
        $value = _escape_attributes( $value );

        $tag .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<$tag>";
}


###############################################################################
#
# xml_start_tag_unencoded()
#
# Write an XML start tag with optional, unencoded, attributes.
# This is a minor speed optimisation for elements that don't need encoding.
#
sub xml_start_tag_unencoded {

    my $self = shift;
    my $tag  = shift;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;

        $tag .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<$tag>";
}


###############################################################################
#
# xml_end_tag()
#
# Write an XML end tag.
#
sub xml_end_tag {

    my $self = shift;
    my $tag  = shift;
    local $\ = undef;

    print { $self->{_fh} } "</$tag>";
}


###############################################################################
#
# xml_empty_tag()
#
# Write an empty XML tag with optional attributes.
#
sub xml_empty_tag {

    my $self = shift;
    my $tag  = shift;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;
        $value = _escape_attributes( $value );

        $tag .= qq( $key="$value");
    }

    local $\ = undef;

    print { $self->{_fh} } "<$tag/>";
}


###############################################################################
#
# xml_empty_tag_unencoded()
#
# Write an empty XML tag with optional, unencoded, attributes.
# This is a minor speed optimisation for elements that don't need encoding.
#
sub xml_empty_tag_unencoded {

    my $self = shift;
    my $tag  = shift;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;

        $tag .= qq( $key="$value");
    }

    local $\ = undef;

    print { $self->{_fh} } "<$tag/>";
}


###############################################################################
#
# xml_data_element()
#
# Write an XML element containing data with optional attributes.
# XML characters in the data are encoded.
#
sub xml_data_element {

    my $self    = shift;
    my $tag     = shift;
    my $data    = shift;
    my $end_tag = $tag;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;
        $value = _escape_attributes( $value );

        $tag .= qq( $key="$value");
    }

    $data = _escape_data( $data );

    local $\ = undef;
    print { $self->{_fh} } "<$tag>$data</$end_tag>";
}


###############################################################################
#
# xml_data_element_unencoded()
#
# Write an XML unencoded element containing data with optional attributes.
# This is a minor speed optimisation for elements that don't need encoding.
#
sub xml_data_element_unencoded {

    my $self    = shift;
    my $tag     = shift;
    my $data    = shift;
    my $end_tag = $tag;

    while ( @_ ) {
        my $key   = shift @_;
        my $value = shift @_;

        $tag .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<$tag>$data</$end_tag>";
}


###############################################################################
#
# xml_string_element()
#
# Optimised tag writer for <c> cell string elements in the inner loop.
#
sub xml_string_element {

    my $self  = shift;
    my $index = shift;
    my $attr  = '';

    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<c$attr t=\"s\"><v>$index</v></c>";
}


###############################################################################
#
# xml_si_element()
#
# Optimised tag writer for shared strings <si> elements.
#
sub xml_si_element {

    my $self   = shift;
    my $string = shift;
    my $attr   = '';


    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    $string = _escape_data( $string );

    local $\ = undef;
    print { $self->{_fh} } "<si><t$attr>$string</t></si>";
}


###############################################################################
#
# xml_rich_si_element()
#
# Optimised tag writer for shared strings <si> rich string elements.
#
sub xml_rich_si_element {

    my $self   = shift;
    my $string = shift;


    local $\ = undef;
    print { $self->{_fh} } "<si>$string</si>";
}


###############################################################################
#
# xml_number_element()
#
# Optimised tag writer for <c> cell number elements in the inner loop.
#
sub xml_number_element {

    my $self   = shift;
    my $number = shift;
    my $attr   = '';

    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<c$attr><v>$number</v></c>";
}


###############################################################################
#
# xml_formula_element()
#
# Optimised tag writer for <c> cell formula elements in the inner loop.
#
sub xml_formula_element {

    my $self    = shift;
    my $formula = shift;
    my $result  = shift;
    my $attr    = '';

    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    $formula = _escape_data( $formula );

    local $\ = undef;
    print { $self->{_fh} } "<c$attr><f>$formula</f><v>$result</v></c>";
}


###############################################################################
#
# xml_inline_string()
#
# Optimised tag writer for inlineStr cell elements in the inner loop.
#
sub xml_inline_string {

    my $self     = shift;
    my $string   = shift;
    my $preserve = shift;
    my $attr     = '';
    my $t_attr   = '';

    # Set the <t> attribute to preserve whitespace.
    $t_attr = ' xml:space="preserve"' if $preserve;

    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    $string = _escape_data( $string );

    local $\ = undef;
    print { $self->{_fh} }
      "<c$attr t=\"inlineStr\"><is><t$t_attr>$string</t></is></c>";
}


###############################################################################
#
# xml_rich_inline_string()
#
# Optimised tag writer for rich inlineStr cell elements in the inner loop.
#
sub xml_rich_inline_string {

    my $self   = shift;
    my $string = shift;
    my $attr   = '';

    while ( @_ ) {
        my $key   = shift;
        my $value = shift;
        $attr .= qq( $key="$value");
    }

    local $\ = undef;
    print { $self->{_fh} } "<c$attr t=\"inlineStr\"><is>$string</is></c>";
}


###############################################################################
#
# xml_get_fh()
#
# Return the output filehandle.
#
sub xml_get_fh {

    my $self = shift;

    return $self->{_fh};
}


###############################################################################
#
# _escape_attributes()
#
# Escape XML characters in attributes.
#
sub _escape_attributes {

    my $str = $_[0];

    return $str if $str !~ m/["&<>\n]/;

    for ( $str ) {
        s/&/&amp;/g;
        s/"/&quot;/g;
        s/</&lt;/g;
        s/>/&gt;/g;
        s/\n/&#xA;/g;
    }

    return $str;
}


###############################################################################
#
# _escape_data()
#
# Escape XML characters in data sections. Note, this is different from
# _escape_attributes() in that double quotes are not escaped by Excel.
#
sub _escape_data {

    my $str = $_[0];

    return $str if $str !~ m/[&<>]/;

    for ( $str ) {
        s/&/&amp;/g;
        s/</&lt;/g;
        s/>/&gt;/g;
    }

    return $str;
}


1;


__END__

=pod

=head1 NAME

XMLwriter - A base class for the Excel::Writer::XLSX writer classes.

=head1 DESCRIPTION

This module is used by L<Excel::Writer::XLSX> for writing XML documents. It is a light weight re-implementation of L<XML::Writer>.

XMLwriter is approximately twice as fast as L<XML::Writer>. This speed is achieved at the expense of error and correctness checking. In addition not all of the L<XML::Writer> methods are implemented. As such, XMLwriter is not recommended for use outside of Excel::Writer::XLSX.

=head1 SEE ALSO

L<XML::Writer>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

(c) MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

=head1 LICENSE

Either the Perl Artistic Licence L<http://dev.perl.org/licenses/artistic.html> or the GPL L<http://www.opensource.org/licenses/gpl-license.php>.

=head1 DISCLAIMER OF WARRANTY

See the documentation for L<Excel::Writer::XLSX>.

=cut
