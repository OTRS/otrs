package Excel::Writer::XLSX::Package::Packager;

###############################################################################
#
# Packager - A class for creating the Excel XLSX package.
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
use File::Copy;
use Excel::Writer::XLSX::Package::App;
use Excel::Writer::XLSX::Package::Comments;
use Excel::Writer::XLSX::Package::ContentTypes;
use Excel::Writer::XLSX::Package::Core;
use Excel::Writer::XLSX::Package::Custom;
use Excel::Writer::XLSX::Package::Relationships;
use Excel::Writer::XLSX::Package::SharedStrings;
use Excel::Writer::XLSX::Package::Styles;
use Excel::Writer::XLSX::Package::Table;
use Excel::Writer::XLSX::Package::Theme;
use Excel::Writer::XLSX::Package::VML;

our @ISA     = qw(Exporter);
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

    $self->{_package_dir}      = '';
    $self->{_workbook}         = undef;
    $self->{_worksheet_count}  = 0;
    $self->{_chartsheet_count} = 0;
    $self->{_chart_count}      = 0;
    $self->{_drawing_count}    = 0;
    $self->{_table_count}      = 0;
    $self->{_named_ranges}     = [];


    bless $self, $class;

    return $self;
}


###############################################################################
#
# _set_package_dir()
#
# Set the XLSX OPC package directory.
#
sub _set_package_dir {

    my $self = shift;

    $self->{_package_dir} = shift;
}


###############################################################################
#
# _add_workbook()
#
# Add the Excel::Writer::XLSX::Workbook object to the package.
#
sub _add_workbook {

    my $self        = shift;
    my $workbook    = shift;

    $self->{_workbook}          = $workbook;
    $self->{_chart_count}       = scalar @{ $workbook->{_charts} };
    $self->{_drawing_count}     = scalar @{ $workbook->{_drawings} };
    $self->{_num_vml_files}     = $workbook->{_num_vml_files};
    $self->{_num_comment_files} = $workbook->{_num_comment_files};
    $self->{_named_ranges}      = $workbook->{_named_ranges};

    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {
        if ( $worksheet->{_is_chartsheet} ) {
            $self->{_chartsheet_count}++;
        }
        else {
            $self->{_worksheet_count}++;
        }
    }
}


###############################################################################
#
# _create_package()
#
# Write the xml files that make up the XLXS OPC package.
#
sub _create_package {

    my $self = shift;

    $self->_write_worksheet_files();
    $self->_write_chartsheet_files();
    $self->_write_workbook_file();
    $self->_write_chart_files();
    $self->_write_drawing_files();
    $self->_write_vml_files();
    $self->_write_comment_files();
    $self->_write_table_files();
    $self->_write_shared_strings_file();
    $self->_write_app_file();
    $self->_write_core_file();
    $self->_write_custom_file();
    $self->_write_content_types_file();
    $self->_write_styles_file();
    $self->_write_theme_file();
    $self->_write_root_rels_file();
    $self->_write_workbook_rels_file();
    $self->_write_worksheet_rels_files();
    $self->_write_chartsheet_rels_files();
    $self->_write_drawing_rels_files();
    $self->_add_image_files();
    $self->_add_vba_project();
}


###############################################################################
#
# _write_workbook_file()
#
# Write the workbook.xml file.
#
sub _write_workbook_file {

    my $self     = shift;
    my $dir      = $self->{_package_dir};
    my $workbook = $self->{_workbook};

    _mkdir( $dir . '/xl' );

    $workbook->_set_xml_writer( $dir . '/xl/workbook.xml' );
    $workbook->_assemble_xml_file();
}


###############################################################################
#
# _write_worksheet_files()
#
# Write the worksheet files.
#
sub _write_worksheet_files {

    my $self = shift;
    my $dir  = $self->{_package_dir};

    _mkdir( $dir . '/xl' );
    _mkdir( $dir . '/xl/worksheets' );

    my $index = 1;
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {
        next if $worksheet->{_is_chartsheet};

        $worksheet->_set_xml_writer(
            $dir . '/xl/worksheets/sheet' . $index++ . '.xml' );
        $worksheet->_assemble_xml_file();

    }
}


###############################################################################
#
# _write_chartsheet_files()
#
# Write the chartsheet files.
#
sub _write_chartsheet_files {

    my $self = shift;
    my $dir  = $self->{_package_dir};

    my $index = 1;
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {
        next unless $worksheet->{_is_chartsheet};

        _mkdir( $dir . '/xl' );
        _mkdir( $dir . '/xl/chartsheets' );

        $worksheet->_set_xml_writer(
            $dir . '/xl/chartsheets/sheet' . $index++ . '.xml' );
        $worksheet->_assemble_xml_file();

    }
}


###############################################################################
#
# _write_chart_files()
#
# Write the chart files.
#
sub _write_chart_files {

    my $self = shift;
    my $dir  = $self->{_package_dir};

    return unless @{ $self->{_workbook}->{_charts} };

    _mkdir( $dir . '/xl' );
    _mkdir( $dir . '/xl/charts' );

    my $index = 1;
    for my $chart ( @{ $self->{_workbook}->{_charts} } ) {
        $chart->_set_xml_writer(
            $dir . '/xl/charts/chart' . $index++ . '.xml' );
        $chart->_assemble_xml_file();

    }
}


###############################################################################
#
# _write_drawing_files()
#
# Write the drawing files.
#
sub _write_drawing_files {

    my $self = shift;
    my $dir  = $self->{_package_dir};

    return unless $self->{_drawing_count};

    _mkdir( $dir . '/xl' );
    _mkdir( $dir . '/xl/drawings' );

    my $index = 1;
    for my $drawing ( @{ $self->{_workbook}->{_drawings} } ) {
        $drawing->_set_xml_writer(
            $dir . '/xl/drawings/drawing' . $index++ . '.xml' );
        $drawing->_assemble_xml_file();
    }
}


###############################################################################
#
# _write_vml_files()
#
# Write the comment VML files.
#
sub _write_vml_files {

    my $self = shift;
    my $dir  = $self->{_package_dir};

    my $index = 1;
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {

        next if !$worksheet->{_has_vml} and !$worksheet->{_has_header_vml};

        _mkdir( $dir . '/xl' );
        _mkdir( $dir . '/xl/drawings' );

        if ( $worksheet->{_has_vml} ) {
            my $vml = Excel::Writer::XLSX::Package::VML->new();

            $vml->_set_xml_writer(
                $dir . '/xl/drawings/vmlDrawing' . $index . '.vml' );
            $vml->_assemble_xml_file(
                $worksheet->{_vml_data_id},    $worksheet->{_vml_shape_id},
                $worksheet->{_comments_array}, $worksheet->{_buttons_array},
                undef
            );

            $index++;
        }

        if ( $worksheet->{_has_header_vml} ) {
            my $vml = Excel::Writer::XLSX::Package::VML->new();

            $vml->_set_xml_writer(
                $dir . '/xl/drawings/vmlDrawing' . $index . '.vml' );
            $vml->_assemble_xml_file(
                $worksheet->{_vml_header_id},
                $worksheet->{_vml_header_id} * 1024,
                undef, undef, $worksheet->{_header_images_array}
            );

            $self->_write_vml_drawing_rels_file($worksheet, $index);

            $index++;
        }
    }
}


###############################################################################
#
# _write_comment_files()
#
# Write the comment files.
#
sub _write_comment_files {

    my $self = shift;
    my $dir  = $self->{_package_dir};

    my $index = 1;
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {
        next unless $worksheet->{_has_comments};

        my $comment = Excel::Writer::XLSX::Package::Comments->new();

        _mkdir( $dir . '/xl' );
        _mkdir( $dir . '/xl/drawings' );

        $comment->_set_xml_writer( $dir . '/xl/comments' . $index++ . '.xml' );
        $comment->_assemble_xml_file( $worksheet->{_comments_array} );
    }
}


###############################################################################
#
# _write_shared_strings_file()
#
# Write the sharedStrings.xml file.
#
sub _write_shared_strings_file {

    my $self = shift;
    my $dir  = $self->{_package_dir};
    my $sst  = Excel::Writer::XLSX::Package::SharedStrings->new();

    my $total    = $self->{_workbook}->{_str_total};
    my $unique   = $self->{_workbook}->{_str_unique};
    my $sst_data = $self->{_workbook}->{_str_array};

    return unless $total > 0;

    _mkdir( $dir . '/xl' );

    $sst->_set_string_count( $total );
    $sst->_set_unique_count( $unique );
    $sst->_add_strings( $sst_data );

    $sst->_set_xml_writer( $dir . '/xl/sharedStrings.xml' );
    $sst->_assemble_xml_file();
}


###############################################################################
#
# _write_app_file()
#
# Write the app.xml file.
#
sub _write_app_file {

    my $self       = shift;
    my $dir        = $self->{_package_dir};
    my $properties = $self->{_workbook}->{_doc_properties};
    my $app        = Excel::Writer::XLSX::Package::App->new();

    _mkdir( $dir . '/docProps' );

    # Add the Worksheet heading pairs.
    $app->_add_heading_pair( [ 'Worksheets', $self->{_worksheet_count} ] );

    # Add the Chartsheet heading pairs.
    $app->_add_heading_pair( [ 'Charts', $self->{_chartsheet_count} ] );

    # Add the Worksheet parts.
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {
        next if $worksheet->{_is_chartsheet};
        $app->_add_part_name( $worksheet->get_name() );
    }

    # Add the Chartsheet parts.
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {
        next unless $worksheet->{_is_chartsheet};
        $app->_add_part_name( $worksheet->get_name() );
    }

    # Add the Named Range heading pairs.
    if ( my $range_count = scalar @{ $self->{_named_ranges} } ) {
        $app->_add_heading_pair( [ 'Named Ranges', $range_count ] );
    }

    # Add the Named Ranges parts.
    for my $named_range ( @{ $self->{_named_ranges} } ) {
        $app->_add_part_name( $named_range );
    }

    $app->_set_properties( $properties );

    $app->_set_xml_writer( $dir . '/docProps/app.xml' );
    $app->_assemble_xml_file();
}


###############################################################################
#
# _write_core_file()
#
# Write the core.xml file.
#
sub _write_core_file {

    my $self       = shift;
    my $dir        = $self->{_package_dir};
    my $properties = $self->{_workbook}->{_doc_properties};
    my $core       = Excel::Writer::XLSX::Package::Core->new();

    _mkdir( $dir . '/docProps' );

    $core->_set_properties( $properties );
    $core->_set_xml_writer( $dir . '/docProps/core.xml' );
    $core->_assemble_xml_file();
}


###############################################################################
#
# _write_custom_file()
#
# Write the custom.xml file.
#
sub _write_custom_file {

    my $self       = shift;
    my $dir        = $self->{_package_dir};
    my $properties = $self->{_workbook}->{_custom_properties};
    my $custom     = Excel::Writer::XLSX::Package::Custom->new();

    return if !@$properties;

    _mkdir( $dir . '/docProps' );

    $custom->_set_properties( $properties );
    $custom->_set_xml_writer( $dir . '/docProps/custom.xml' );
    $custom->_assemble_xml_file();
}


###############################################################################
#
# _write_content_types_file()
#
# Write the ContentTypes.xml file.
#
sub _write_content_types_file {

    my $self    = shift;
    my $dir     = $self->{_package_dir};
    my $content = Excel::Writer::XLSX::Package::ContentTypes->new();

    $content->_add_image_types( %{ $self->{_workbook}->{_image_types} } );

    my $worksheet_index  = 1;
    my $chartsheet_index = 1;
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {
        if ( $worksheet->{_is_chartsheet} ) {
            $content->_add_chartsheet_name( 'sheet' . $chartsheet_index++ );
        }
        else {
            $content->_add_worksheet_name( 'sheet' . $worksheet_index++ );
        }
    }

    for my $i ( 1 .. $self->{_chart_count} ) {
        $content->_add_chart_name( 'chart' . $i );
    }

    for my $i ( 1 .. $self->{_drawing_count} ) {
        $content->_add_drawing_name( 'drawing' . $i );
    }

    if ( $self->{_num_vml_files} ) {
        $content->_add_vml_name();
    }

    for my $i ( 1 .. $self->{_table_count} ) {
        $content->_add_table_name( 'table' . $i );
    }

    for my $i ( 1 .. $self->{_num_comment_files} ) {
        $content->_add_comment_name( 'comments' . $i );
    }

    # Add the sharedString rel if there is string data in the workbook.
    if ( $self->{_workbook}->{_str_total} ) {
        $content->_add_shared_strings();
    }

    # Add vbaProject if present.
    if ( $self->{_workbook}->{_vba_project} ) {
        $content->_add_vba_project();
    }

    # Add the custom properties if present.
    if ( @{ $self->{_workbook}->{_custom_properties} } ) {
        $content->_add_custom_properties();
    }

    $content->_set_xml_writer( $dir . '/[Content_Types].xml' );
    $content->_assemble_xml_file();
}


###############################################################################
#
# _write_styles_file()
#
# Write the style xml file.
#
sub _write_styles_file {

    my $self             = shift;
    my $dir              = $self->{_package_dir};
    my $xf_formats       = $self->{_workbook}->{_xf_formats};
    my $palette          = $self->{_workbook}->{_palette};
    my $font_count       = $self->{_workbook}->{_font_count};
    my $num_format_count = $self->{_workbook}->{_num_format_count};
    my $border_count     = $self->{_workbook}->{_border_count};
    my $fill_count       = $self->{_workbook}->{_fill_count};
    my $custom_colors    = $self->{_workbook}->{_custom_colors};
    my $dxf_formats      = $self->{_workbook}->{_dxf_formats};

    my $rels = Excel::Writer::XLSX::Package::Styles->new();

    _mkdir( $dir . '/xl' );

    $rels->_set_style_properties(
        $xf_formats,
        $palette,
        $font_count,
        $num_format_count,
        $border_count,
        $fill_count,
        $custom_colors,
        $dxf_formats,

    );

    $rels->_set_xml_writer( $dir . '/xl/styles.xml' );
    $rels->_assemble_xml_file();
}


###############################################################################
#
# _write_theme_file()
#
# Write the style xml file.
#
sub _write_theme_file {

    my $self = shift;
    my $dir  = $self->{_package_dir};
    my $rels = Excel::Writer::XLSX::Package::Theme->new();

    _mkdir( $dir . '/xl' );
    _mkdir( $dir . '/xl/theme' );

    $rels->_set_xml_writer( $dir . '/xl/theme/theme1.xml' );
    $rels->_assemble_xml_file();
}


###############################################################################
#
# _write_table_files()
#
# Write the table files.
#
sub _write_table_files {

    my $self = shift;
    my $dir  = $self->{_package_dir};

    my $index = 1;
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {
        my @table_props = @{ $worksheet->{_tables} };

        next unless @table_props;

        _mkdir( $dir . '/xl' );
        _mkdir( $dir . '/xl/tables' );

        for my $table_props ( @table_props ) {

            my $table = Excel::Writer::XLSX::Package::Table->new();

            $table->_set_xml_writer(
                $dir . '/xl/tables/table' . $index++ . '.xml' );

            $table->_set_properties( $table_props );

            $table->_assemble_xml_file();

            $self->{_table_count}++;
        }
    }
}


###############################################################################
#
# _write_root_rels_file()
#
# Write the _rels/.rels xml file.
#
sub _write_root_rels_file {

    my $self = shift;
    my $dir  = $self->{_package_dir};
    my $rels = Excel::Writer::XLSX::Package::Relationships->new();

    _mkdir( $dir . '/_rels' );

    $rels->_add_document_relationship( '/officeDocument', 'xl/workbook.xml' );

    $rels->_add_package_relationship( '/metadata/core-properties',
        'docProps/core.xml' );

    $rels->_add_document_relationship( '/extended-properties',
        'docProps/app.xml' );

    if ( @{ $self->{_workbook}->{_custom_properties} } ) {
        $rels->_add_document_relationship( '/custom-properties',
            'docProps/custom.xml' );
    }

    $rels->_set_xml_writer( $dir . '/_rels/.rels' );
    $rels->_assemble_xml_file();
}


###############################################################################
#
# _write_workbook_rels_file()
#
# Write the _rels/.rels xml file.
#
sub _write_workbook_rels_file {

    my $self = shift;
    my $dir  = $self->{_package_dir};
    my $rels = Excel::Writer::XLSX::Package::Relationships->new();

    _mkdir( $dir . '/xl' );
    _mkdir( $dir . '/xl/_rels' );

    my $worksheet_index  = 1;
    my $chartsheet_index = 1;

    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {
        if ( $worksheet->{_is_chartsheet} ) {
            $rels->_add_document_relationship( '/chartsheet',
                'chartsheets/sheet' . $chartsheet_index++ . '.xml' );
        }
        else {
            $rels->_add_document_relationship( '/worksheet',
                'worksheets/sheet' . $worksheet_index++ . '.xml' );
        }
    }

    $rels->_add_document_relationship( '/theme',  'theme/theme1.xml' );
    $rels->_add_document_relationship( '/styles', 'styles.xml' );

    # Add the sharedString rel if there is string data in the workbook.
    if ( $self->{_workbook}->{_str_total} ) {
        $rels->_add_document_relationship( '/sharedStrings',
            'sharedStrings.xml' );
    }

    # Add vbaProject if present.
    if ( $self->{_workbook}->{_vba_project} ) {
        $rels->_add_ms_package_relationship( '/vbaProject', 'vbaProject.bin' );
    }

    $rels->_set_xml_writer( $dir . '/xl/_rels/workbook.xml.rels' );
    $rels->_assemble_xml_file();
}


###############################################################################
#
# _write_worksheet_rels_files()
#
# Write the worksheet .rels files for worksheets that contain links to external
# data such as hyperlinks or drawings.
#
sub _write_worksheet_rels_files {

    my $self = shift;
    my $dir  = $self->{_package_dir};

    my $index = 0;
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {

        next if $worksheet->{_is_chartsheet};

        $index++;

        my @external_links = (
            @{ $worksheet->{_external_hyper_links} },
            @{ $worksheet->{_external_drawing_links} },
            @{ $worksheet->{_external_vml_links} },
            @{ $worksheet->{_external_table_links} },
            @{ $worksheet->{_external_comment_links} },
        );

        next unless @external_links;

        # Create the worksheet .rels dirs.
        _mkdir( $dir . '/xl' );
        _mkdir( $dir . '/xl/worksheets' );
        _mkdir( $dir . '/xl/worksheets/_rels' );

        my $rels = Excel::Writer::XLSX::Package::Relationships->new();

        for my $link_data ( @external_links ) {
            $rels->_add_worksheet_relationship( @$link_data );
        }

        # Create the .rels file such as /xl/worksheets/_rels/sheet1.xml.rels.
        $rels->_set_xml_writer(
            $dir . '/xl/worksheets/_rels/sheet' . $index . '.xml.rels' );
        $rels->_assemble_xml_file();
    }
}


###############################################################################
#
# _write_chartsheet_rels_files()
#
# Write the chartsheet .rels files for links to drawing files.
#
sub _write_chartsheet_rels_files {

    my $self = shift;
    my $dir  = $self->{_package_dir};


    my $index = 0;
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {

        next unless $worksheet->{_is_chartsheet};

        $index++;

        my @external_links = @{ $worksheet->{_external_drawing_links} };

        next unless @external_links;

        # Create the chartsheet .rels dir.
        _mkdir( $dir . '/xl' );
        _mkdir( $dir . '/xl/chartsheets' );
        _mkdir( $dir . '/xl/chartsheets/_rels' );

        my $rels = Excel::Writer::XLSX::Package::Relationships->new();

        for my $link_data ( @external_links ) {
            $rels->_add_worksheet_relationship( @$link_data );
        }

        # Create the .rels file such as /xl/chartsheets/_rels/sheet1.xml.rels.
        $rels->_set_xml_writer(
            $dir . '/xl/chartsheets/_rels/sheet' . $index . '.xml.rels' );
        $rels->_assemble_xml_file();
    }
}


###############################################################################
#
# _write_drawing_rels_files()
#
# Write the drawing .rels files for worksheets that contain charts or drawings.
#
sub _write_drawing_rels_files {

    my $self = shift;
    my $dir  = $self->{_package_dir};


    my $index = 0;
    for my $worksheet ( @{ $self->{_workbook}->{_worksheets} } ) {

        if ( @{ $worksheet->{_drawing_links} } || $worksheet->{_has_shapes} ) {
            $index++;
        }

        next unless @{ $worksheet->{_drawing_links} };

        # Create the drawing .rels dir.
        _mkdir( $dir . '/xl' );
        _mkdir( $dir . '/xl/drawings' );
        _mkdir( $dir . '/xl/drawings/_rels' );

        my $rels = Excel::Writer::XLSX::Package::Relationships->new();

        for my $drawing_data ( @{ $worksheet->{_drawing_links} } ) {
            $rels->_add_document_relationship( @$drawing_data );
        }

        # Create the .rels file such as /xl/drawings/_rels/sheet1.xml.rels.
        $rels->_set_xml_writer(
            $dir . '/xl/drawings/_rels/drawing' . $index . '.xml.rels' );
        $rels->_assemble_xml_file();
    }
}


###############################################################################
#
# _write_vml_drawing_rels_files()
#
# Write the vmlDdrawing .rels files for worksheets with images in header or
# footers.
#
sub _write_vml_drawing_rels_file {

    my $self      = shift;
    my $worksheet = shift;
    my $index     = shift;
    my $dir       = $self->{_package_dir};


    # Create the drawing .rels dir.
    _mkdir( $dir . '/xl' );
    _mkdir( $dir . '/xl/drawings' );
    _mkdir( $dir . '/xl/drawings/_rels' );

    my $rels = Excel::Writer::XLSX::Package::Relationships->new();

    for my $drawing_data ( @{ $worksheet->{_vml_drawing_links} } ) {
        $rels->_add_document_relationship( @$drawing_data );
    }

    # Create the .rels file such as /xl/drawings/_rels/vmlDrawing1.vml.rels.
    $rels->_set_xml_writer(
        $dir . '/xl/drawings/_rels/vmlDrawing' . $index . '.vml.rels' );
    $rels->_assemble_xml_file();

}


###############################################################################
#
# _add_image_files()
#
# Write the /xl/media/image?.xml files.
#
sub _add_image_files {

    my $self     = shift;
    my $dir      = $self->{_package_dir};
    my $workbook = $self->{_workbook};
    my $index    = 1;

    for my $image ( @{ $workbook->{_images} } ) {
        my $filename  = $image->[0];
        my $extension = '.' . $image->[1];

        _mkdir( $dir . '/xl' );
        _mkdir( $dir . '/xl/media' );

        copy( $filename, $dir . '/xl/media/image' . $index++ . $extension );
    }
}


###############################################################################
#
# _add_vba_project()
#
# Write the vbaProject.bin file.
#
sub _add_vba_project {

    my $self        = shift;
    my $dir         = $self->{_package_dir};
    my $vba_project = $self->{_workbook}->{_vba_project};

    return unless $vba_project;

    _mkdir( $dir . '/xl' );

    copy( $vba_project, $dir . '/xl/vbaProject.bin' );
}


###############################################################################
#
# _mkdir()
#
# Wrapper function for Perl's mkdir to allow error trapping.
#
sub _mkdir {

    my $dir = shift;

    return if -e $dir;

    my $ret = mkdir( $dir );

    if ( !$ret ) {
        croak "Couldn't create sub directory $dir: $!";
    }
}


1;


__END__

=pod

=head1 NAME

Packager - A class for creating the Excel XLSX package.

=head1 SYNOPSIS

See the documentation for L<Excel::Writer::XLSX>.

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Writer::XLSX> to create an Excel XLSX container file.

From Wikipedia: I<The Open Packaging Conventions (OPC) is a container-file technology initially created by Microsoft to store a combination of XML and non-XML files that together form a single entity such as an Open XML Paper Specification (OpenXPS) document>. L<http://en.wikipedia.org/wiki/Open_Packaging_Conventions>.

At its simplest an Excel XLSX file contains the following elements:

     ____ [Content_Types].xml
    |
    |____ docProps
    | |____ app.xml
    | |____ core.xml
    |
    |____ xl
    | |____ workbook.xml
    | |____ worksheets
    | | |____ sheet1.xml
    | |
    | |____ styles.xml
    | |
    | |____ theme
    | | |____ theme1.xml
    | |
    | |_____rels
    |   |____ workbook.xml.rels
    |
    |_____rels
      |____ .rels


The C<Excel::Writer::XLSX::Package::Packager> class co-ordinates the classes that represent the elements of the package and writes them into the XLSX file.

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
