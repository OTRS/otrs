package Excel::Writer::XLSX::Package::ContentTypes;

###############################################################################
#
# Excel::Writer::XLSX::Package::ContentTypes - A class for writing the Excel
# XLS [Content_Types] file.
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
# Package data.
#
###############################################################################

my $app_package  = 'application/vnd.openxmlformats-package.';
my $app_document = 'application/vnd.openxmlformats-officedocument.';

our @defaults = (
    [ 'rels', $app_package . 'relationships+xml' ],
    [ 'xml',  'application/xml' ],
);

our @overrides = (
    [ '/docProps/app.xml',    $app_document . 'extended-properties+xml' ],
    [ '/docProps/core.xml',   $app_package . 'core-properties+xml' ],
    [ '/xl/styles.xml',       $app_document . 'spreadsheetml.styles+xml' ],
    [ '/xl/theme/theme1.xml', $app_document . 'theme+xml' ],
    [ '/xl/workbook.xml',     $app_document . 'spreadsheetml.sheet.main+xml' ],
);


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

    $self->{_defaults}  = [@defaults];
    $self->{_overrides} = [@overrides];

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
    $self->_write_types();
    $self->_write_defaults();
    $self->_write_overrides();

    $self->xml_end_tag( 'Types' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# _add_default()
#
# Add elements to the ContentTypes defaults.
#
sub _add_default {

    my $self         = shift;
    my $part_name    = shift;
    my $content_type = shift;

    push @{ $self->{_defaults} }, [ $part_name, $content_type ];

}


###############################################################################
#
# _add_override()
#
# Add elements to the ContentTypes overrides.
#
sub _add_override {

    my $self         = shift;
    my $part_name    = shift;
    my $content_type = shift;

    push @{ $self->{_overrides} }, [ $part_name, $content_type ];

}


###############################################################################
#
# _add_worksheet_name()
#
# Add the name of a worksheet to the ContentTypes overrides.
#
sub _add_worksheet_name {

    my $self           = shift;
    my $worksheet_name = shift;

    $worksheet_name = "/xl/worksheets/$worksheet_name.xml";

    $self->_add_override( $worksheet_name,
        $app_document . 'spreadsheetml.worksheet+xml' );
}


###############################################################################
#
# _add_chartsheet_name()
#
# Add the name of a chartsheet to the ContentTypes overrides.
#
sub _add_chartsheet_name {

    my $self            = shift;
    my $chartsheet_name = shift;

    $chartsheet_name = "/xl/chartsheets/$chartsheet_name.xml";

    $self->_add_override( $chartsheet_name,
        $app_document . 'spreadsheetml.chartsheet+xml' );
}


###############################################################################
#
# _add_chart_name()
#
# Add the name of a chart to the ContentTypes overrides.
#
sub _add_chart_name {

    my $self       = shift;
    my $chart_name = shift;

    $chart_name = "/xl/charts/$chart_name.xml";

    $self->_add_override( $chart_name, $app_document . 'drawingml.chart+xml' );
}


###############################################################################
#
# _add_drawing_name()
#
# Add the name of a drawing to the ContentTypes overrides.
#
sub _add_drawing_name {

    my $self         = shift;
    my $drawing_name = shift;

    $drawing_name = "/xl/drawings/$drawing_name.xml";

    $self->_add_override( $drawing_name, $app_document . 'drawing+xml' );
}


###############################################################################
#
# _add_vml_name()
#
# Add the name of a VML drawing to the ContentTypes defaults.
#
sub _add_vml_name {

    my $self = shift;

    $self->_add_default( 'vml', $app_document . 'vmlDrawing' );
}


###############################################################################
#
# _add_comment_name()
#
# Add the name of a comment to the ContentTypes overrides.
#
sub _add_comment_name {

    my $self         = shift;
    my $comment_name = shift;

    $comment_name = "/xl/$comment_name.xml";

    $self->_add_override( $comment_name,
        $app_document . 'spreadsheetml.comments+xml' );
}

###############################################################################
#
# _Add_shared_strings()
#
# Add the sharedStrings link to the ContentTypes overrides.
#
sub _add_shared_strings {

    my $self = shift;

    $self->_add_override( '/xl/sharedStrings.xml',
        $app_document . 'spreadsheetml.sharedStrings+xml' );
}


###############################################################################
#
# _add_calc_chain()
#
# Add the calcChain link to the ContentTypes overrides.
#
sub _add_calc_chain {

    my $self = shift;

    $self->_add_override( '/xl/calcChain.xml',
        $app_document . 'spreadsheetml.calcChain+xml' );
}


###############################################################################
#
# _add_image_types()
#
# Add the image default types.
#
sub _add_image_types {

    my $self  = shift;
    my %types = @_;

    for my $type ( keys %types ) {
        $self->_add_default( $type, 'image/' . $type );
    }
}


###############################################################################
#
# _add_table_name()
#
# Add the name of a table to the ContentTypes overrides.
#
sub _add_table_name {

    my $self       = shift;
    my $table_name = shift;

    $table_name = "/xl/tables/$table_name.xml";

    $self->_add_override( $table_name,
        $app_document . 'spreadsheetml.table+xml' );
}


###############################################################################
#
# _add_vba_project()
#
# Add a vbaProject to the ContentTypes defaults.
#
sub _add_vba_project {

    my $self = shift;

    # Change the workbook.xml content-type from xlsx to xlsm.
    for my $aref ( @{ $self->{_overrides} } ) {
        if ( $aref->[0] eq '/xl/workbook.xml' ) {
            $aref->[1] = 'application/vnd.ms-excel.sheet.macroEnabled.main+xml';
        }
    }

    $self->_add_default( 'bin', 'application/vnd.ms-office.vbaProject' );
}


###############################################################################
#
# _add_custom_properties()
#
# Add the custom properties to the ContentTypes overrides.
#
sub _add_custom_properties {

    my $self   = shift;
    my $custom = "/docProps/custom.xml";

    $self->_add_override( $custom, $app_document . 'custom-properties+xml' );
}


###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# _write_defaults()
#
# Write out all of the <Default> types.
#
sub _write_defaults {

    my $self = shift;

    for my $aref ( @{ $self->{_defaults} } ) {
        #<<<
        $self->xml_empty_tag(
            'Default',
            'Extension',   $aref->[0],
            'ContentType', $aref->[1] );
        #>>>
    }
}


###############################################################################
#
# _write_overrides()
#
# Write out all of the <Override> types.
#
sub _write_overrides {

    my $self = shift;

    for my $aref ( @{ $self->{_overrides} } ) {
        #<<<
        $self->xml_empty_tag(
            'Override',
            'PartName',    $aref->[0],
            'ContentType', $aref->[1] );
        #>>>
    }
}


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_types()
#
# Write the <Types> element.
#
sub _write_types {

    my $self  = shift;
    my $xmlns = 'http://schemas.openxmlformats.org/package/2006/content-types';

    my @attributes = ( 'xmlns' => $xmlns, );

    $self->xml_start_tag( 'Types', @attributes );
}

###############################################################################
#
# _write_default()
#
# Write the <Default> element.
#
sub _write_default {

    my $self         = shift;
    my $extension    = shift;
    my $content_type = shift;

    my @attributes = (
        'Extension'   => $extension,
        'ContentType' => $content_type,
    );

    $self->xml_empty_tag( 'Default', @attributes );
}


###############################################################################
#
# _write_override()
#
# Write the <Override> element.
#
sub _write_override {

    my $self         = shift;
    my $part_name    = shift;
    my $content_type = shift;
    my $writer       = $self;

    my @attributes = (
        'PartName'    => $part_name,
        'ContentType' => $content_type,
    );

    $self->xml_empty_tag( 'Override', @attributes );
}


1;


__END__

=pod

=head1 NAME

Excel::Writer::XLSX::Package::ContentTypes - A class for writing the Excel XLSX [Content_Types] file.

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
