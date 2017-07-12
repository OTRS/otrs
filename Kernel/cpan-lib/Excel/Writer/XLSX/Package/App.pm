package Excel::Writer::XLSX::Package::App;

###############################################################################
#
# App - A class for writing the Excel XLSX app.xml file.
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
use Carp;
use Excel::Writer::XLSX::Package::XMLwriter;

our @ISA     = qw(Excel::Writer::XLSX::Package::XMLwriter);
our $VERSION = '0.95';


###############################################################################
#
# Public and private API methods.
#
###############################################################################


###############################################################################
#
# new()
#
# Constructor.
#
sub new {

    my $class = shift;
    my $fh    = shift;
    my $self  = Excel::Writer::XLSX::Package::XMLwriter->new( $fh );

    $self->{_part_names}    = [];
    $self->{_heading_pairs} = [];
    $self->{_properties}    = {};

    bless $self, $class;

    return $self;
}


###############################################################################
#
# _assemble_xml_file()
#
# Assemble and write the XML file.
#
sub _assemble_xml_file {

    my $self = shift;

    $self->xml_declaration;
    $self->_write_properties();
    $self->_write_application();
    $self->_write_doc_security();
    $self->_write_scale_crop();
    $self->_write_heading_pairs();
    $self->_write_titles_of_parts();
    $self->_write_manager();
    $self->_write_company();
    $self->_write_links_up_to_date();
    $self->_write_shared_doc();
    $self->_write_hyperlink_base();
    $self->_write_hyperlinks_changed();
    $self->_write_app_version();

    $self->xml_end_tag( 'Properties' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# _add_part_name()
#
# Add the name of a workbook Part such as 'Sheet1' or 'Print_Titles'.
#
sub _add_part_name {

    my $self      = shift;
    my $part_name = shift;

    push @{ $self->{_part_names} }, $part_name;
}


###############################################################################
#
# _add_heading_pair()
#
# Add the name of a workbook Heading Pair such as 'Worksheets', 'Charts' or
# 'Named Ranges'.
#
sub _add_heading_pair {

    my $self         = shift;
    my $heading_pair = shift;

    return unless $heading_pair->[1];  # Ignore empty pairs such as chartsheets.

    my @vector = (
        [ 'lpstr', $heading_pair->[0] ],    # Data name
        [ 'i4',    $heading_pair->[1] ],    # Data size
    );

    push @{ $self->{_heading_pairs} }, @vector;
}


###############################################################################
#
# _set_properties()
#
# Set the document properties.
#
sub _set_properties {

    my $self       = shift;
    my $properties = shift;

    $self->{_properties} = $properties;
}


###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_properties()
#
# Write the <Properties> element.
#
sub _write_properties {

    my $self     = shift;
    my $schema   = 'http://schemas.openxmlformats.org/officeDocument/2006/';
    my $xmlns    = $schema . 'extended-properties';
    my $xmlns_vt = $schema . 'docPropsVTypes';

    my @attributes = (
        'xmlns'    => $xmlns,
        'xmlns:vt' => $xmlns_vt,
    );

    $self->xml_start_tag( 'Properties', @attributes );
}

###############################################################################
#
# _write_application()
#
# Write the <Application> element.
#
sub _write_application {

    my $self = shift;
    my $data = 'Microsoft Excel';

    $self->xml_data_element( 'Application', $data );
}


###############################################################################
#
# _write_doc_security()
#
# Write the <DocSecurity> element.
#
sub _write_doc_security {

    my $self = shift;
    my $data = 0;

    $self->xml_data_element( 'DocSecurity', $data );
}


###############################################################################
#
# _write_scale_crop()
#
# Write the <ScaleCrop> element.
#
sub _write_scale_crop {

    my $self = shift;
    my $data = 'false';

    $self->xml_data_element( 'ScaleCrop', $data );
}


###############################################################################
#
# _write_heading_pairs()
#
# Write the <HeadingPairs> element.
#
sub _write_heading_pairs {

    my $self = shift;

    $self->xml_start_tag( 'HeadingPairs' );

    $self->_write_vt_vector( 'variant', $self->{_heading_pairs} );

    $self->xml_end_tag( 'HeadingPairs' );
}


###############################################################################
#
# _write_titles_of_parts()
#
# Write the <TitlesOfParts> element.
#
sub _write_titles_of_parts {

    my $self = shift;

    $self->xml_start_tag( 'TitlesOfParts' );

    my @parts_data;

    for my $part_name ( @{ $self->{_part_names} } ) {
        push @parts_data, [ 'lpstr', $part_name ];
    }

    $self->_write_vt_vector( 'lpstr', \@parts_data );

    $self->xml_end_tag( 'TitlesOfParts' );
}


###############################################################################
#
# _write_vt_vector()
#
# Write the <vt:vector> element.
#
sub _write_vt_vector {

    my $self      = shift;
    my $base_type = shift;
    my $data      = shift;
    my $size      = @$data;

    my @attributes = (
        'size'     => $size,
        'baseType' => $base_type,
    );

    $self->xml_start_tag( 'vt:vector', @attributes );

    for my $aref ( @$data ) {
        $self->xml_start_tag( 'vt:variant' ) if $base_type eq 'variant';
        $self->_write_vt_data( @$aref );
        $self->xml_end_tag( 'vt:variant' ) if $base_type eq 'variant';
    }

    $self->xml_end_tag( 'vt:vector' );
}


##############################################################################
#
# _write_vt_data()
#
# Write the <vt:*> elements such as <vt:lpstr> and <vt:if>.
#
sub _write_vt_data {

    my $self = shift;
    my $type = shift;
    my $data = shift;

    $self->xml_data_element( "vt:$type", $data );
}


###############################################################################
#
# _write_company()
#
# Write the <Company> element.
#
sub _write_company {

    my $self = shift;
    my $data = $self->{_properties}->{company} || '';

    $self->xml_data_element( 'Company', $data );
}


###############################################################################
#
# _write_manager()
#
# Write the <Manager> element.
#
sub _write_manager {

    my $self = shift;
    my $data = $self->{_properties}->{manager};

    return unless $data;

    $self->xml_data_element( 'Manager', $data );
}


###############################################################################
#
# _write_links_up_to_date()
#
# Write the <LinksUpToDate> element.
#
sub _write_links_up_to_date {

    my $self = shift;
    my $data = 'false';

    $self->xml_data_element( 'LinksUpToDate', $data );
}


###############################################################################
#
# _write_shared_doc()
#
# Write the <SharedDoc> element.
#
sub _write_shared_doc {

    my $self = shift;
    my $data = 'false';

    $self->xml_data_element( 'SharedDoc', $data );
}


###############################################################################
#
# _write_hyperlink_base()
#
# Write the <HyperlinkBase> element.
#
sub _write_hyperlink_base {

    my $self = shift;
    my $data = $self->{_properties}->{hyperlink_base};

    return unless $data;

    $self->xml_data_element( 'HyperlinkBase', $data );
}


###############################################################################
#
# _write_hyperlinks_changed()
#
# Write the <HyperlinksChanged> element.
#
sub _write_hyperlinks_changed {

    my $self = shift;
    my $data = 'false';

    $self->xml_data_element( 'HyperlinksChanged', $data );
}


###############################################################################
#
# _write_app_version()
#
# Write the <AppVersion> element.
#
sub _write_app_version {

    my $self = shift;
    my $data = '12.0000';

    $self->xml_data_element( 'AppVersion', $data );
}


1;


__END__

=pod

=head1 NAME

App - A class for writing the Excel XLSX app.xml file.

=head1 SYNOPSIS

See the documentation for L<Excel::Writer::XLSX>.

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Writer::XLSX>.

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
