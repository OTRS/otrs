package Excel::Writer::XLSX::Worksheet;

###############################################################################
#
# Worksheet - A class for writing Excel Worksheets.
#
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
use File::Temp 'tempfile';
use List::Util qw(max min);
use Excel::Writer::XLSX::Format;
use Excel::Writer::XLSX::Drawing;
use Excel::Writer::XLSX::Package::XMLwriter;
use Excel::Writer::XLSX::Utility qw(xl_cell_to_rowcol
                                    xl_rowcol_to_cell
                                    xl_col_to_name
                                    xl_range
                                    quote_sheetname);

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

    my $class  = shift;
    my $fh     = shift;
    my $self   = Excel::Writer::XLSX::Package::XMLwriter->new( $fh );
    my $rowmax = 1_048_576;
    my $colmax = 16_384;
    my $strmax = 32767;

    $self->{_name}            = $_[0];
    $self->{_index}           = $_[1];
    $self->{_activesheet}     = $_[2];
    $self->{_firstsheet}      = $_[3];
    $self->{_str_total}       = $_[4];
    $self->{_str_unique}      = $_[5];
    $self->{_str_table}       = $_[6];
    $self->{_date_1904}       = $_[7];
    $self->{_palette}         = $_[8];
    $self->{_optimization}    = $_[9] || 0;
    $self->{_tempdir}         = $_[10];
    $self->{_excel2003_style} = $_[11];

    $self->{_ext_sheets}    = [];
    $self->{_fileclosed}    = 0;
    $self->{_excel_version} = 2007;

    $self->{_xls_rowmax} = $rowmax;
    $self->{_xls_colmax} = $colmax;
    $self->{_xls_strmax} = $strmax;
    $self->{_dim_rowmin} = undef;
    $self->{_dim_rowmax} = undef;
    $self->{_dim_colmin} = undef;
    $self->{_dim_colmax} = undef;

    $self->{_colinfo}    = {};
    $self->{_selections} = [];
    $self->{_hidden}     = 0;
    $self->{_active}     = 0;
    $self->{_tab_color}  = 0;

    $self->{_panes}       = [];
    $self->{_active_pane} = 3;
    $self->{_selected}    = 0;

    $self->{_page_setup_changed} = 0;
    $self->{_paper_size}         = 0;
    $self->{_orientation}        = 1;

    $self->{_print_options_changed} = 0;
    $self->{_hcenter}               = 0;
    $self->{_vcenter}               = 0;
    $self->{_print_gridlines}       = 0;
    $self->{_screen_gridlines}      = 1;
    $self->{_print_headers}         = 0;

    $self->{_header_footer_changed} = 0;
    $self->{_header}                = '';
    $self->{_footer}                = '';
    $self->{_header_footer_aligns}  = 1;
    $self->{_header_footer_scales}  = 1;
    $self->{_header_images}         = [];
    $self->{_footer_images}         = [];

    $self->{_margin_left}   = 0.7;
    $self->{_margin_right}  = 0.7;
    $self->{_margin_top}    = 0.75;
    $self->{_margin_bottom} = 0.75;
    $self->{_margin_header} = 0.3;
    $self->{_margin_footer} = 0.3;

    $self->{_repeat_rows} = '';
    $self->{_repeat_cols} = '';
    $self->{_print_area}  = '';

    $self->{_page_order}     = 0;
    $self->{_black_white}    = 0;
    $self->{_draft_quality}  = 0;
    $self->{_print_comments} = 0;
    $self->{_page_start}     = 0;

    $self->{_fit_page}   = 0;
    $self->{_fit_width}  = 0;
    $self->{_fit_height} = 0;

    $self->{_hbreaks} = [];
    $self->{_vbreaks} = [];

    $self->{_protect}  = 0;
    $self->{_password} = undef;

    $self->{_set_cols} = {};
    $self->{_set_rows} = {};

    $self->{_zoom}              = 100;
    $self->{_zoom_scale_normal} = 1;
    $self->{_print_scale}       = 100;
    $self->{_right_to_left}     = 0;
    $self->{_show_zeros}        = 1;
    $self->{_leading_zeros}     = 0;

    $self->{_outline_row_level} = 0;
    $self->{_outline_col_level} = 0;
    $self->{_outline_style}     = 0;
    $self->{_outline_below}     = 1;
    $self->{_outline_right}     = 1;
    $self->{_outline_on}        = 1;
    $self->{_outline_changed}   = 0;

    $self->{_original_row_height} = 15;
    $self->{_default_row_height}  = 15;
    $self->{_default_row_pixels}  = 20;
    $self->{_default_col_pixels}  = 64;
    $self->{_default_row_zeroed}  = 0;

    $self->{_names} = {};

    $self->{_write_match} = [];


    $self->{_table} = {};
    $self->{_merge} = [];

    $self->{_has_vml}             = 0;
    $self->{_has_header_vml}      = 0;
    $self->{_has_comments}        = 0;
    $self->{_comments}            = {};
    $self->{_comments_array}      = [];
    $self->{_comments_author}     = '';
    $self->{_comments_visible}    = 0;
    $self->{_vml_shape_id}        = 1024;
    $self->{_buttons_array}       = [];
    $self->{_header_images_array} = [];

    $self->{_autofilter}   = '';
    $self->{_filter_on}    = 0;
    $self->{_filter_range} = [];
    $self->{_filter_cols}  = {};

    $self->{_col_sizes}        = {};
    $self->{_row_sizes}        = {};
    $self->{_col_formats}      = {};
    $self->{_col_size_changed} = 0;
    $self->{_row_size_changed} = 0;

    $self->{_last_shape_id}          = 1;
    $self->{_rel_count}              = 0;
    $self->{_hlink_count}            = 0;
    $self->{_hlink_refs}             = [];
    $self->{_external_hyper_links}   = [];
    $self->{_external_drawing_links} = [];
    $self->{_external_comment_links} = [];
    $self->{_external_vml_links}     = [];
    $self->{_external_table_links}   = [];
    $self->{_drawing_links}          = [];
    $self->{_vml_drawing_links}      = [];
    $self->{_charts}                 = [];
    $self->{_images}                 = [];
    $self->{_tables}                 = [];
    $self->{_sparklines}             = [];
    $self->{_shapes}                 = [];
    $self->{_shape_hash}             = {};
    $self->{_has_shapes}             = 0;
    $self->{_drawing}                = 0;

    $self->{_horizontal_dpi} = 0;
    $self->{_vertical_dpi}   = 0;

    $self->{_rstring}      = '';
    $self->{_previous_row} = 0;

    if ( $self->{_optimization} == 1 ) {
        my $fh = tempfile( DIR => $self->{_tempdir} );
        binmode $fh, ':utf8';

        $self->{_cell_data_fh} = $fh;
        $self->{_fh}           = $fh;
    }

    $self->{_validations}  = [];
    $self->{_cond_formats} = {};
    $self->{_dxf_priority} = 1;

    if ( $self->{_excel2003_style} ) {
        $self->{_original_row_height}  = 12.75;
        $self->{_default_row_height}   = 12.75;
        $self->{_default_row_pixels}   = 17;
        $self->{_margin_left}          = 0.75;
        $self->{_margin_right}         = 0.75;
        $self->{_margin_top}           = 1;
        $self->{_margin_bottom}        = 1;
        $self->{_margin_header}        = 0.5;
        $self->{_margin_footer}        = 0.5;
        $self->{_header_footer_aligns} = 0;
    }

    bless $self, $class;
    return $self;
}

###############################################################################
#
# _set_xml_writer()
#
# Over-ridden to ensure that write_single_row() is called for the final row
# when optimisation mode is on.
#
sub _set_xml_writer {

    my $self     = shift;
    my $filename = shift;

    if ( $self->{_optimization} == 1 ) {
        $self->_write_single_row();
    }

    $self->SUPER::_set_xml_writer( $filename );
}


###############################################################################
#
# _assemble_xml_file()
#
# Assemble and write the XML file.
#
sub _assemble_xml_file {

    my $self = shift;

    $self->xml_declaration();

    # Write the root worksheet element.
    $self->_write_worksheet();

    # Write the worksheet properties.
    $self->_write_sheet_pr();

    # Write the worksheet dimensions.
    $self->_write_dimension();

    # Write the sheet view properties.
    $self->_write_sheet_views();

    # Write the sheet format properties.
    $self->_write_sheet_format_pr();

    # Write the sheet column info.
    $self->_write_cols();

    # Write the worksheet data such as rows columns and cells.
    if ( $self->{_optimization} == 0 ) {
        $self->_write_sheet_data();
    }
    else {
        $self->_write_optimized_sheet_data();
    }

    # Write the sheetProtection element.
    $self->_write_sheet_protection();

    # Write the worksheet calculation properties.
    #$self->_write_sheet_calc_pr();

    # Write the worksheet phonetic properties.
    if ($self->{_excel2003_style}) {
        $self->_write_phonetic_pr();
    }

    # Write the autoFilter element.
    $self->_write_auto_filter();

    # Write the mergeCells element.
    $self->_write_merge_cells();

    # Write the conditional formats.
    $self->_write_conditional_formats();

    # Write the dataValidations element.
    $self->_write_data_validations();

    # Write the hyperlink element.
    $self->_write_hyperlinks();

    # Write the printOptions element.
    $self->_write_print_options();

    # Write the worksheet page_margins.
    $self->_write_page_margins();

    # Write the worksheet page setup.
    $self->_write_page_setup();

    # Write the headerFooter element.
    $self->_write_header_footer();

    # Write the rowBreaks element.
    $self->_write_row_breaks();

    # Write the colBreaks element.
    $self->_write_col_breaks();

    # Write the drawing element.
    $self->_write_drawings();

    # Write the legacyDrawing element.
    $self->_write_legacy_drawing();

    # Write the legacyDrawingHF element.
    $self->_write_legacy_drawing_hf();

    # Write the tableParts element.
    $self->_write_table_parts();

    # Write the extLst and sparklines.
    $self->_write_ext_sparklines();

    # Close the worksheet tag.
    $self->xml_end_tag( 'worksheet' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# _close()
#
# Write the worksheet elements.
#
sub _close {

    # TODO. Unused. Remove after refactoring.
    my $self       = shift;
    my $sheetnames = shift;
    my $num_sheets = scalar @$sheetnames;
}


###############################################################################
#
# get_name().
#
# Retrieve the worksheet name.
#
sub get_name {

    my $self = shift;

    return $self->{_name};
}


###############################################################################
#
# select()
#
# Set this worksheet as a selected worksheet, i.e. the worksheet has its tab
# highlighted.
#
sub select {

    my $self = shift;

    $self->{_hidden}   = 0;    # Selected worksheet can't be hidden.
    $self->{_selected} = 1;
}


###############################################################################
#
# activate()
#
# Set this worksheet as the active worksheet, i.e. the worksheet that is
# displayed when the workbook is opened. Also set it as selected.
#
sub activate {

    my $self = shift;

    $self->{_hidden}   = 0;    # Active worksheet can't be hidden.
    $self->{_selected} = 1;
    ${ $self->{_activesheet} } = $self->{_index};
}


###############################################################################
#
# hide()
#
# Hide this worksheet.
#
sub hide {

    my $self = shift;

    $self->{_hidden} = 1;

    # A hidden worksheet shouldn't be active or selected.
    $self->{_selected} = 0;
    ${ $self->{_activesheet} } = 0;
    ${ $self->{_firstsheet} }  = 0;
}


###############################################################################
#
# set_first_sheet()
#
# Set this worksheet as the first visible sheet. This is necessary
# when there are a large number of worksheets and the activated
# worksheet is not visible on the screen.
#
sub set_first_sheet {

    my $self = shift;

    $self->{_hidden} = 0;    # Active worksheet can't be hidden.
    ${ $self->{_firstsheet} } = $self->{_index};
}


###############################################################################
#
# protect( $password )
#
# Set the worksheet protection flags to prevent modification of worksheet
# objects.
#
sub protect {

    my $self     = shift;
    my $password = shift || '';
    my $options  = shift || {};

    if ( $password ne '' ) {
        $password = $self->_encode_password( $password );
    }

    # Default values for objects that can be protected.
    my %defaults = (
        sheet                 => 1,
        content               => 0,
        objects               => 0,
        scenarios             => 0,
        format_cells          => 0,
        format_columns        => 0,
        format_rows           => 0,
        insert_columns        => 0,
        insert_rows           => 0,
        insert_hyperlinks     => 0,
        delete_columns        => 0,
        delete_rows           => 0,
        select_locked_cells   => 1,
        sort                  => 0,
        autofilter            => 0,
        pivot_tables          => 0,
        select_unlocked_cells => 1,
    );


    # Overwrite the defaults with user specified values.
    for my $key ( keys %{$options} ) {

        if ( exists $defaults{$key} ) {
            $defaults{$key} = $options->{$key};
        }
        else {
            carp "Unknown protection object: $key\n";
        }
    }

    # Set the password after the user defined values.
    $defaults{password} = $password;

    $self->{_protect} = \%defaults;
}


###############################################################################
#
# _encode_password($password)
#
# Based on the algorithm provided by Daniel Rentz of OpenOffice.
#
sub _encode_password {

    use integer;

    my $self      = shift;
    my $plaintext = $_[0];
    my $password;
    my $count;
    my @chars;
    my $i = 0;

    $count = @chars = split //, $plaintext;

    foreach my $char ( @chars ) {
        my $low_15;
        my $high_15;
        $char    = ord( $char ) << ++$i;
        $low_15  = $char & 0x7fff;
        $high_15 = $char & 0x7fff << 15;
        $high_15 = $high_15 >> 15;
        $char    = $low_15 | $high_15;
    }

    $password = 0x0000;
    $password ^= $_ for @chars;
    $password ^= $count;
    $password ^= 0xCE4B;

    return sprintf "%X", $password;
}


###############################################################################
#
# set_column($firstcol, $lastcol, $width, $format, $hidden, $level)
#
# Set the width of a single column or a range of columns.
# See also: _write_col_info
#
sub set_column {

    my $self = shift;
    my @data = @_;
    my $cell = $data[0];

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $cell =~ /^\D/ ) {
        @data = $self->_substitute_cellref( @_ );

        # Returned values $row1 and $row2 aren't required here. Remove them.
        shift @data;    # $row1
        splice @data, 1, 1;    # $row2
    }

    return if @data < 3;       # Ensure at least $firstcol, $lastcol and $width
    return if not defined $data[0];    # Columns must be defined.
    return if not defined $data[1];

    # Assume second column is the same as first if 0. Avoids KB918419 bug.
    $data[1] = $data[0] if $data[1] == 0;

    # Ensure 2nd col is larger than first. Also for KB918419 bug.
    ( $data[0], $data[1] ) = ( $data[1], $data[0] ) if $data[0] > $data[1];


    # Check that cols are valid and store max and min values with default row.
    # NOTE: The check shouldn't modify the row dimensions and should only modify
    #       the column dimensions in certain cases.
    my $ignore_row = 1;
    my $ignore_col = 1;
    $ignore_col = 0 if ref $data[3];          # Column has a format.
    $ignore_col = 0 if $data[2] && $data[4];  # Column has a width but is hidden

    return -2
      if $self->_check_dimensions( 0, $data[0], $ignore_row, $ignore_col );
    return -2
      if $self->_check_dimensions( 0, $data[1], $ignore_row, $ignore_col );

    # Set the limits for the outline levels (0 <= x <= 7).
    $data[5] = 0 unless defined $data[5];
    $data[5] = 0 if $data[5] < 0;
    $data[5] = 7 if $data[5] > 7;

    if ( $data[5] > $self->{_outline_col_level} ) {
        $self->{_outline_col_level} = $data[5];
    }

    # Store the column data based on the first column. Padded for sorting.
    $self->{_colinfo}->{ sprintf "%05d", $data[0] } = [@data];

    # Store the column change to allow optimisations.
    $self->{_col_size_changed} = 1;

    # Store the col sizes for use when calculating image vertices taking
    # hidden columns into account. Also store the column formats.
    my $width = $data[4] ? 0 : $data[2];    # Set width to zero if hidden.
    my $format = $data[3];

    my ( $firstcol, $lastcol ) = @data;

    foreach my $col ( $firstcol .. $lastcol ) {
        $self->{_col_sizes}->{$col} = $width;
        $self->{_col_formats}->{$col} = $format if $format;
    }
}


###############################################################################
#
# set_selection()
#
# Set which cell or cells are selected in a worksheet.
#
sub set_selection {

    my $self = shift;
    my $pane;
    my $active_cell;
    my $sqref;

    return unless @_;

    # Check for a cell reference in A1 notation and substitute row and column.
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }


    # There should be either 2 or 4 arguments.
    if ( @_ == 2 ) {

        # Single cell selection.
        $active_cell = xl_rowcol_to_cell( $_[0], $_[1] );
        $sqref = $active_cell;
    }
    elsif ( @_ == 4 ) {

        # Range selection.
        $active_cell = xl_rowcol_to_cell( $_[0], $_[1] );

        my ( $row_first, $col_first, $row_last, $col_last ) = @_;

        # Swap last row/col for first row/col as necessary
        if ( $row_first > $row_last ) {
            ( $row_first, $row_last ) = ( $row_last, $row_first );
        }

        if ( $col_first > $col_last ) {
            ( $col_first, $col_last ) = ( $col_last, $col_first );
        }

        # If the first and last cell are the same write a single cell.
        if ( ( $row_first == $row_last ) && ( $col_first == $col_last ) ) {
            $sqref = $active_cell;
        }
        else {
            $sqref = xl_range( $row_first, $row_last, $col_first, $col_last );
        }

    }
    else {

        # User supplied wrong number or arguments.
        return;
    }

    # Selection isn't set for cell A1.
    return if $sqref eq 'A1';

    $self->{_selections} = [ [ $pane, $active_cell, $sqref ] ];
}


###############################################################################
#
# freeze_panes( $row, $col, $top_row, $left_col )
#
# Set panes and mark them as frozen.
#
sub freeze_panes {

    my $self = shift;

    return unless @_;

    # Check for a cell reference in A1 notation and substitute row and column.
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    my $row      = shift;
    my $col      = shift || 0;
    my $top_row  = shift || $row;
    my $left_col = shift || $col;
    my $type     = shift || 0;

    $self->{_panes} = [ $row, $col, $top_row, $left_col, $type ];
}


###############################################################################
#
# split_panes( $y, $x, $top_row, $left_col )
#
# Set panes and mark them as split.
#
# Implementers note. The API for this method doesn't map well from the XLS
# file format and isn't sufficient to describe all cases of split panes.
# It should probably be something like:
#
#     split_panes( $y, $x, $top_row, $left_col, $offset_row, $offset_col )
#
# I'll look at changing this if it becomes an issue.
#
sub split_panes {

    my $self = shift;

    # Call freeze panes but add the type flag for split panes.
    $self->freeze_panes( @_[ 0 .. 3 ], 2 );
}

# Older method name for backwards compatibility.
*thaw_panes = *split_panes;


###############################################################################
#
# set_portrait()
#
# Set the page orientation as portrait.
#
sub set_portrait {

    my $self = shift;

    $self->{_orientation}        = 1;
    $self->{_page_setup_changed} = 1;
}


###############################################################################
#
# set_landscape()
#
# Set the page orientation as landscape.
#
sub set_landscape {

    my $self = shift;

    $self->{_orientation}        = 0;
    $self->{_page_setup_changed} = 1;
}


###############################################################################
#
# set_page_view()
#
# Set the page view mode for Mac Excel.
#
sub set_page_view {

    my $self = shift;

    $self->{_page_view} = defined $_[0] ? $_[0] : 1;
}


###############################################################################
#
# set_tab_color()
#
# Set the colour of the worksheet tab.
#
sub set_tab_color {

    my $self  = shift;
    my $color = &Excel::Writer::XLSX::Format::_get_color( $_[0] );

    $self->{_tab_color} = $color;
}


###############################################################################
#
# set_paper()
#
# Set the paper type. Ex. 1 = US Letter, 9 = A4
#
sub set_paper {

    my $self       = shift;
    my $paper_size = shift;

    if ( $paper_size ) {
        $self->{_paper_size}         = $paper_size;
        $self->{_page_setup_changed} = 1;
    }
}


###############################################################################
#
# set_header()
#
# Set the page header caption and optional margin.
#
sub set_header {

    my $self    = shift;
    my $string  = $_[0] || '';
    my $margin  = $_[1] || 0.3;
    my $options = $_[2] || {};


    # Replace the Excel placeholder &[Picture] with the internal &G.
    $string =~ s/&\[Picture\]/&G/g;

    if ( length $string >= 255 ) {
        carp 'Header string must be less than 255 characters';
        return;
    }

    if ( defined $options->{align_with_margins} ) {
        $self->{_header_footer_aligns} = $options->{align_with_margins};
    }

    if ( defined $options->{scale_with_doc} ) {
        $self->{_header_footer_scales} = $options->{scale_with_doc};
    }

    # Reset the array in case the function is called more than once.
    $self->{_header_images} = [];

    if ( $options->{image_left} ) {
        push @{ $self->{_header_images} }, [ $options->{image_left}, 'LH' ];
    }

    if ( $options->{image_center} ) {
        push @{ $self->{_header_images} }, [ $options->{image_center}, 'CH' ];
    }

    if ( $options->{image_right} ) {
        push @{ $self->{_header_images} }, [ $options->{image_right}, 'RH' ];
    }

    my $placeholder_count = () = $string =~ /&G/g;
    my $image_count = @{ $self->{_header_images} };

    if ( $image_count != $placeholder_count ) {
        warn "Number of header images ($image_count) doesn't match placeholder "
          . "count ($placeholder_count) in string: $string\n";
        $self->{_header_images} = [];
        return;
    }

    if ( $image_count ) {
        $self->{_has_header_vml} = 1;
    }

    $self->{_header}                = $string;
    $self->{_margin_header}         = $margin;
    $self->{_header_footer_changed} = 1;
}


###############################################################################
#
# set_footer()
#
# Set the page footer caption and optional margin.
#
sub set_footer {

    my $self    = shift;
    my $string  = $_[0] || '';
    my $margin  = $_[1] || 0.3;
    my $options = $_[2] || {};


    # Replace the Excel placeholder &[Picture] with the internal &G.
    $string =~ s/&\[Picture\]/&G/g;

    if ( length $string >= 255 ) {
        carp 'Footer string must be less than 255 characters';
        return;
    }

    if ( defined $options->{align_with_margins} ) {
        $self->{_header_footer_aligns} = $options->{align_with_margins};
    }

    if ( defined $options->{scale_with_doc} ) {
        $self->{_header_footer_scales} = $options->{scale_with_doc};
    }

    # Reset the array in case the function is called more than once.
    $self->{_footer_images} = [];

    if ( $options->{image_left} ) {
        push @{ $self->{_footer_images} }, [ $options->{image_left}, 'LF' ];
    }

    if ( $options->{image_center} ) {
        push @{ $self->{_footer_images} }, [ $options->{image_center}, 'CF' ];
    }

    if ( $options->{image_right} ) {
        push @{ $self->{_footer_images} }, [ $options->{image_right}, 'RF' ];
    }

    my $placeholder_count = () = $string =~ /&G/g;
    my $image_count = @{ $self->{_footer_images} };

    if ( $image_count != $placeholder_count ) {
        warn "Number of footer images ($image_count) doesn't match placeholder "
          . "count ($placeholder_count) in string: $string\n";
        $self->{_footer_images} = [];
        return;
    }

    if ( $image_count ) {
        $self->{_has_header_vml} = 1;
    }

    $self->{_footer}                = $string;
    $self->{_margin_footer}         = $margin;
    $self->{_header_footer_changed} = 1;
}


###############################################################################
#
# center_horizontally()
#
# Center the page horizontally.
#
sub center_horizontally {

    my $self = shift;

    $self->{_print_options_changed} = 1;
    $self->{_hcenter}               = 1;
}


###############################################################################
#
# center_vertically()
#
# Center the page horizontally.
#
sub center_vertically {

    my $self = shift;

    $self->{_print_options_changed} = 1;
    $self->{_vcenter}               = 1;
}


###############################################################################
#
# set_margins()
#
# Set all the page margins to the same value in inches.
#
sub set_margins {

    my $self = shift;

    $self->set_margin_left( $_[0] );
    $self->set_margin_right( $_[0] );
    $self->set_margin_top( $_[0] );
    $self->set_margin_bottom( $_[0] );
}


###############################################################################
#
# set_margins_LR()
#
# Set the left and right margins to the same value in inches.
#
sub set_margins_LR {

    my $self = shift;

    $self->set_margin_left( $_[0] );
    $self->set_margin_right( $_[0] );
}


###############################################################################
#
# set_margins_TB()
#
# Set the top and bottom margins to the same value in inches.
#
sub set_margins_TB {

    my $self = shift;

    $self->set_margin_top( $_[0] );
    $self->set_margin_bottom( $_[0] );
}


###############################################################################
#
# set_margin_left()
#
# Set the left margin in inches.
#
sub set_margin_left {

    my $self    = shift;
    my $margin  = shift;
    my $default = 0.7;

    # Add 0 to ensure the argument is numeric.
    if   ( defined $margin ) { $margin = 0 + $margin }
    else                     { $margin = $default }

    $self->{_margin_left} = $margin;
}


###############################################################################
#
# set_margin_right()
#
# Set the right margin in inches.
#
sub set_margin_right {

    my $self    = shift;
    my $margin  = shift;
    my $default = 0.7;

    # Add 0 to ensure the argument is numeric.
    if   ( defined $margin ) { $margin = 0 + $margin }
    else                     { $margin = $default }

    $self->{_margin_right} = $margin;
}


###############################################################################
#
# set_margin_top()
#
# Set the top margin in inches.
#
sub set_margin_top {

    my $self    = shift;
    my $margin  = shift;
    my $default = 0.75;

    # Add 0 to ensure the argument is numeric.
    if   ( defined $margin ) { $margin = 0 + $margin }
    else                     { $margin = $default }

    $self->{_margin_top} = $margin;
}


###############################################################################
#
# set_margin_bottom()
#
# Set the bottom margin in inches.
#
sub set_margin_bottom {


    my $self    = shift;
    my $margin  = shift;
    my $default = 0.75;

    # Add 0 to ensure the argument is numeric.
    if   ( defined $margin ) { $margin = 0 + $margin }
    else                     { $margin = $default }

    $self->{_margin_bottom} = $margin;
}


###############################################################################
#
# repeat_rows($first_row, $last_row)
#
# Set the rows to repeat at the top of each printed page.
#
sub repeat_rows {

    my $self = shift;

    my $row_min = $_[0];
    my $row_max = $_[1] || $_[0];    # Second row is optional


    # Convert to 1 based.
    $row_min++;
    $row_max++;

    my $area = '$' . $row_min . ':' . '$' . $row_max;

    # Build up the print titles "Sheet1!$1:$2"
    my $sheetname = quote_sheetname( $self->{_name} );
    $area = $sheetname . "!" . $area;

    $self->{_repeat_rows} = $area;
}


###############################################################################
#
# repeat_columns($first_col, $last_col)
#
# Set the columns to repeat at the left hand side of each printed page. This is
# stored as a <NamedRange> element.
#
sub repeat_columns {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );

        # Returned values $row1 and $row2 aren't required here. Remove them.
        shift @_;    # $row1
        splice @_, 1, 1;    # $row2
    }

    my $col_min = $_[0];
    my $col_max = $_[1] || $_[0];    # Second col is optional

    # Convert to A notation.
    $col_min = xl_col_to_name( $_[0], 1 );
    $col_max = xl_col_to_name( $_[1], 1 );

    my $area = $col_min . ':' . $col_max;

    # Build up the print area range "=Sheet2!C1:C2"
    my $sheetname = quote_sheetname( $self->{_name} );
    $area = $sheetname . "!" . $area;

    $self->{_repeat_cols} = $area;
}


###############################################################################
#
# print_area($first_row, $first_col, $last_row, $last_col)
#
# Set the print area in the current worksheet. This is stored as a <NamedRange>
# element.
#
sub print_area {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    return if @_ != 4;    # Require 4 parameters

    my ( $row1, $col1, $row2, $col2 ) = @_;

    # Ignore max print area since this is the same as no print area for Excel.
    if (    $row1 == 0
        and $col1 == 0
        and $row2 == $self->{_xls_rowmax} - 1
        and $col2 == $self->{_xls_colmax} - 1 )
    {
        return;
    }

    # Build up the print area range "=Sheet2!R1C1:R2C1"
    my $area = $self->_convert_name_area( $row1, $col1, $row2, $col2 );

    $self->{_print_area} = $area;
}


###############################################################################
#
# autofilter($first_row, $first_col, $last_row, $last_col)
#
# Set the autofilter area in the worksheet.
#
sub autofilter {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    return if @_ != 4;    # Require 4 parameters

    my ( $row1, $col1, $row2, $col2 ) = @_;

    # Reverse max and min values if necessary.
    ( $row1, $row2 ) = ( $row2, $row1 ) if $row2 < $row1;
    ( $col1, $col2 ) = ( $col2, $col1 ) if $col2 < $col1;

    # Build up the print area range "Sheet1!$A$1:$C$13".
    my $area = $self->_convert_name_area( $row1, $col1, $row2, $col2 );
    my $ref = xl_range( $row1, $row2, $col1, $col2 );

    $self->{_autofilter}     = $area;
    $self->{_autofilter_ref} = $ref;
    $self->{_filter_range}   = [ $col1, $col2 ];
}


###############################################################################
#
# filter_column($column, $criteria, ...)
#
# Set the column filter criteria.
#
sub filter_column {

    my $self       = shift;
    my $col        = $_[0];
    my $expression = $_[1];

    croak "Must call autofilter() before filter_column()"
      unless $self->{_autofilter};
    croak "Incorrect number of arguments to filter_column()"
      unless @_ == 2;


    # Check for a column reference in A1 notation and substitute.
    if ( $col =~ /^\D/ ) {
        my $col_letter = $col;

        # Convert col ref to a cell ref and then to a col number.
        ( undef, $col ) = $self->_substitute_cellref( $col . '1' );

        croak "Invalid column '$col_letter'" if $col >= $self->{_xls_colmax};
    }

    my ( $col_first, $col_last ) = @{ $self->{_filter_range} };

    # Reject column if it is outside filter range.
    if ( $col < $col_first or $col > $col_last ) {
        croak "Column '$col' outside autofilter() column range "
          . "($col_first .. $col_last)";
    }


    my @tokens = $self->_extract_filter_tokens( $expression );

    croak "Incorrect number of tokens in expression '$expression'"
      unless ( @tokens == 3 or @tokens == 7 );


    @tokens = $self->_parse_filter_expression( $expression, @tokens );

    # Excel handles single or double custom filters as default filters. We need
    # to check for them and handle them accordingly.
    if ( @tokens == 2 && $tokens[0] == 2 ) {

        # Single equality.
        $self->filter_column_list( $col, $tokens[1] );
    }
    elsif (@tokens == 5
        && $tokens[0] == 2
        && $tokens[2] == 1
        && $tokens[3] == 2 )
    {

        # Double equality with "or" operator.
        $self->filter_column_list( $col, $tokens[1], $tokens[4] );
    }
    else {

        # Non default custom filter.
        $self->{_filter_cols}->{$col} = [@tokens];
        $self->{_filter_type}->{$col} = 0;

    }

    $self->{_filter_on} = 1;
}


###############################################################################
#
# filter_column_list($column, @matches )
#
# Set the column filter criteria in Excel 2007 list style.
#
sub filter_column_list {

    my $self   = shift;
    my $col    = shift;
    my @tokens = @_;

    croak "Must call autofilter() before filter_column_list()"
      unless $self->{_autofilter};
    croak "Incorrect number of arguments to filter_column_list()"
      unless @tokens;

    # Check for a column reference in A1 notation and substitute.
    if ( $col =~ /^\D/ ) {
        my $col_letter = $col;

        # Convert col ref to a cell ref and then to a col number.
        ( undef, $col ) = $self->_substitute_cellref( $col . '1' );

        croak "Invalid column '$col_letter'" if $col >= $self->{_xls_colmax};
    }

    my ( $col_first, $col_last ) = @{ $self->{_filter_range} };

    # Reject column if it is outside filter range.
    if ( $col < $col_first or $col > $col_last ) {
        croak "Column '$col' outside autofilter() column range "
          . "($col_first .. $col_last)";
    }

    $self->{_filter_cols}->{$col} = [@tokens];
    $self->{_filter_type}->{$col} = 1;           # Default style.
    $self->{_filter_on}           = 1;
}


###############################################################################
#
# _extract_filter_tokens($expression)
#
# Extract the tokens from the filter expression. The tokens are mainly non-
# whitespace groups. The only tricky part is to extract string tokens that
# contain whitespace and/or quoted double quotes (Excel's escaped quotes).
#
# Examples: 'x <  2000'
#           'x >  2000 and x <  5000'
#           'x = "foo"'
#           'x = "foo bar"'
#           'x = "foo "" bar"'
#
sub _extract_filter_tokens {

    my $self       = shift;
    my $expression = $_[0];

    return unless $expression;

    my @tokens = ( $expression =~ /"(?:[^"]|"")*"|\S+/g );    #"

    # Remove leading and trailing quotes and unescape other quotes
    for ( @tokens ) {
        s/^"//;                                               #"
        s/"$//;                                               #"
        s/""/"/g;                                             #"
    }

    return @tokens;
}


###############################################################################
#
# _parse_filter_expression(@token)
#
# Converts the tokens of a possibly conditional expression into 1 or 2
# sub expressions for further parsing.
#
# Examples:
#          ('x', '==', 2000) -> exp1
#          ('x', '>',  2000, 'and', 'x', '<', 5000) -> exp1 and exp2
#
sub _parse_filter_expression {

    my $self       = shift;
    my $expression = shift;
    my @tokens     = @_;

    # The number of tokens will be either 3 (for 1 expression)
    # or 7 (for 2  expressions).
    #
    if ( @tokens == 7 ) {

        my $conditional = $tokens[3];

        if ( $conditional =~ /^(and|&&)$/ ) {
            $conditional = 0;
        }
        elsif ( $conditional =~ /^(or|\|\|)$/ ) {
            $conditional = 1;
        }
        else {
            croak "Token '$conditional' is not a valid conditional "
              . "in filter expression '$expression'";
        }

        my @expression_1 =
          $self->_parse_filter_tokens( $expression, @tokens[ 0, 1, 2 ] );
        my @expression_2 =
          $self->_parse_filter_tokens( $expression, @tokens[ 4, 5, 6 ] );

        return ( @expression_1, $conditional, @expression_2 );
    }
    else {
        return $self->_parse_filter_tokens( $expression, @tokens );
    }
}


###############################################################################
#
# _parse_filter_tokens(@token)
#
# Parse the 3 tokens of a filter expression and return the operator and token.
#
sub _parse_filter_tokens {

    my $self       = shift;
    my $expression = shift;
    my @tokens     = @_;

    my %operators = (
        '==' => 2,
        '='  => 2,
        '=~' => 2,
        'eq' => 2,

        '!=' => 5,
        '!~' => 5,
        'ne' => 5,
        '<>' => 5,

        '<'  => 1,
        '<=' => 3,
        '>'  => 4,
        '>=' => 6,
    );

    my $operator = $operators{ $tokens[1] };
    my $token    = $tokens[2];


    # Special handling of "Top" filter expressions.
    if ( $tokens[0] =~ /^top|bottom$/i ) {

        my $value = $tokens[1];

        if (   $value =~ /\D/
            or $value < 1
            or $value > 500 )
        {
            croak "The value '$value' in expression '$expression' "
              . "must be in the range 1 to 500";
        }

        $token = lc $token;

        if ( $token ne 'items' and $token ne '%' ) {
            croak "The type '$token' in expression '$expression' "
              . "must be either 'items' or '%'";
        }

        if ( $tokens[0] =~ /^top$/i ) {
            $operator = 30;
        }
        else {
            $operator = 32;
        }

        if ( $tokens[2] eq '%' ) {
            $operator++;
        }

        $token = $value;
    }


    if ( not $operator and $tokens[0] ) {
        croak "Token '$tokens[1]' is not a valid operator "
          . "in filter expression '$expression'";
    }


    # Special handling for Blanks/NonBlanks.
    if ( $token =~ /^blanks|nonblanks$/i ) {

        # Only allow Equals or NotEqual in this context.
        if ( $operator != 2 and $operator != 5 ) {
            croak "The operator '$tokens[1]' in expression '$expression' "
              . "is not valid in relation to Blanks/NonBlanks'";
        }

        $token = lc $token;

        # The operator should always be 2 (=) to flag a "simple" equality in
        # the binary record. Therefore we convert <> to =.
        if ( $token eq 'blanks' ) {
            if ( $operator == 5 ) {
                $token = ' ';
            }
        }
        else {
            if ( $operator == 5 ) {
                $operator = 2;
                $token    = 'blanks';
            }
            else {
                $operator = 5;
                $token    = ' ';
            }
        }
    }


    # if the string token contains an Excel match character then change the
    # operator type to indicate a non "simple" equality.
    if ( $operator == 2 and $token =~ /[*?]/ ) {
        $operator = 22;
    }


    return ( $operator, $token );
}


###############################################################################
#
# _convert_name_area($first_row, $first_col, $last_row, $last_col)
#
# Convert zero indexed rows and columns to the format required by worksheet
# named ranges, eg, "Sheet1!$A$1:$C$13".
#
sub _convert_name_area {

    my $self = shift;

    my $row_num_1 = $_[0];
    my $col_num_1 = $_[1];
    my $row_num_2 = $_[2];
    my $col_num_2 = $_[3];

    my $range1       = '';
    my $range2       = '';
    my $row_col_only = 0;
    my $area;

    # Convert to A1 notation.
    my $col_char_1 = xl_col_to_name( $col_num_1, 1 );
    my $col_char_2 = xl_col_to_name( $col_num_2, 1 );
    my $row_char_1 = '$' . ( $row_num_1 + 1 );
    my $row_char_2 = '$' . ( $row_num_2 + 1 );

    # We need to handle some special cases that refer to rows or columns only.
    if ( $row_num_1 == 0 and $row_num_2 == $self->{_xls_rowmax} - 1 ) {
        $range1       = $col_char_1;
        $range2       = $col_char_2;
        $row_col_only = 1;
    }
    elsif ( $col_num_1 == 0 and $col_num_2 == $self->{_xls_colmax} - 1 ) {
        $range1       = $row_char_1;
        $range2       = $row_char_2;
        $row_col_only = 1;
    }
    else {
        $range1 = $col_char_1 . $row_char_1;
        $range2 = $col_char_2 . $row_char_2;
    }

    # A repeated range is only written once (if it isn't a special case).
    if ( $range1 eq $range2 && !$row_col_only ) {
        $area = $range1;
    }
    else {
        $area = $range1 . ':' . $range2;
    }

    # Build up the print area range "Sheet1!$A$1:$C$13".
    my $sheetname = quote_sheetname( $self->{_name} );
    $area = $sheetname . "!" . $area;

    return $area;
}


###############################################################################
#
# hide_gridlines()
#
# Set the option to hide gridlines on the screen and the printed page.
#
# This was mainly useful for Excel 5 where printed gridlines were on by
# default.
#
sub hide_gridlines {

    my $self = shift;
    my $option =
      defined $_[0] ? $_[0] : 1;    # Default to hiding printed gridlines

    if ( $option == 0 ) {
        $self->{_print_gridlines}       = 1;    # 1 = display, 0 = hide
        $self->{_screen_gridlines}      = 1;
        $self->{_print_options_changed} = 1;
    }
    elsif ( $option == 1 ) {
        $self->{_print_gridlines}  = 0;
        $self->{_screen_gridlines} = 1;
    }
    else {
        $self->{_print_gridlines}  = 0;
        $self->{_screen_gridlines} = 0;
    }
}


###############################################################################
#
# print_row_col_headers()
#
# Set the option to print the row and column headers on the printed page.
# See also the _store_print_headers() method below.
#
sub print_row_col_headers {

    my $self = shift;
    my $headers = defined $_[0] ? $_[0] : 1;

    if ( $headers ) {
        $self->{_print_headers}         = 1;
        $self->{_print_options_changed} = 1;
    }
    else {
        $self->{_print_headers} = 0;
    }
}


###############################################################################
#
# fit_to_pages($width, $height)
#
# Store the vertical and horizontal number of pages that will define the
# maximum area printed.
#
sub fit_to_pages {

    my $self = shift;

    $self->{_fit_page}           = 1;
    $self->{_fit_width}          = defined $_[0] ? $_[0] : 1;
    $self->{_fit_height}         = defined $_[1] ? $_[1] : 1;
    $self->{_page_setup_changed} = 1;
}


###############################################################################
#
# set_h_pagebreaks(@breaks)
#
# Store the horizontal page breaks on a worksheet.
#
sub set_h_pagebreaks {

    my $self = shift;

    push @{ $self->{_hbreaks} }, @_;
}


###############################################################################
#
# set_v_pagebreaks(@breaks)
#
# Store the vertical page breaks on a worksheet.
#
sub set_v_pagebreaks {

    my $self = shift;

    push @{ $self->{_vbreaks} }, @_;
}


###############################################################################
#
# set_zoom( $scale )
#
# Set the worksheet zoom factor.
#
sub set_zoom {

    my $self = shift;
    my $scale = $_[0] || 100;

    # Confine the scale to Excel's range
    if ( $scale < 10 or $scale > 400 ) {
        carp "Zoom factor $scale outside range: 10 <= zoom <= 400";
        $scale = 100;
    }

    $self->{_zoom} = int $scale;
}


###############################################################################
#
# set_print_scale($scale)
#
# Set the scale factor for the printed page.
#
sub set_print_scale {

    my $self = shift;
    my $scale = $_[0] || 100;

    # Confine the scale to Excel's range
    if ( $scale < 10 or $scale > 400 ) {
        carp "Print scale $scale outside range: 10 <= zoom <= 400";
        $scale = 100;
    }

    # Turn off "fit to page" option.
    $self->{_fit_page} = 0;

    $self->{_print_scale}        = int $scale;
    $self->{_page_setup_changed} = 1;
}


###############################################################################
#
# print_black_and_white()
#
# Set the option to print the worksheet in black and white.
#
sub print_black_and_white {

    my $self = shift;

    $self->{_black_white} = 1;
}


###############################################################################
#
# keep_leading_zeros()
#
# Causes the write() method to treat integers with a leading zero as a string.
# This ensures that any leading zeros such, as in zip codes, are maintained.
#
sub keep_leading_zeros {

    my $self = shift;

    if ( defined $_[0] ) {
        $self->{_leading_zeros} = $_[0];
    }
    else {
        $self->{_leading_zeros} = 1;
    }
}


###############################################################################
#
# show_comments()
#
# Make any comments in the worksheet visible.
#
sub show_comments {

    my $self = shift;

    $self->{_comments_visible} = defined $_[0] ? $_[0] : 1;
}


###############################################################################
#
# set_comments_author()
#
# Set the default author of the cell comments.
#
sub set_comments_author {

    my $self = shift;

    $self->{_comments_author} = $_[0] if defined $_[0];
}


###############################################################################
#
# right_to_left()
#
# Display the worksheet right to left for some eastern versions of Excel.
#
sub right_to_left {

    my $self = shift;

    $self->{_right_to_left} = defined $_[0] ? $_[0] : 1;
}


###############################################################################
#
# hide_zero()
#
# Hide cell zero values.
#
sub hide_zero {

    my $self = shift;

    $self->{_show_zeros} = defined $_[0] ? not $_[0] : 0;
}


###############################################################################
#
# print_across()
#
# Set the order in which pages are printed.
#
sub print_across {

    my $self = shift;
    my $page_order = defined $_[0] ? $_[0] : 1;

    if ( $page_order ) {
        $self->{_page_order}         = 1;
        $self->{_page_setup_changed} = 1;
    }
    else {
        $self->{_page_order} = 0;
    }
}


###############################################################################
#
# set_start_page()
#
# Set the start page number.
#
sub set_start_page {

    my $self = shift;
    return unless defined $_[0];

    $self->{_page_start}   = $_[0];
}


###############################################################################
#
# set_first_row_column()
#
# Set the topmost and leftmost visible row and column.
# TODO: Document this when tested fully for interaction with panes.
#
sub set_first_row_column {

    my $self = shift;

    my $row = $_[0] || 0;
    my $col = $_[1] || 0;

    $row = $self->{_xls_rowmax} if $row > $self->{_xls_rowmax};
    $col = $self->{_xls_colmax} if $col > $self->{_xls_colmax};

    $self->{_first_row} = $row;
    $self->{_first_col} = $col;
}


###############################################################################
#
# add_write_handler($re, $code_ref)
#
# Allow the user to add their own matches and handlers to the write() method.
#
sub add_write_handler {

    my $self = shift;

    return unless @_ == 2;
    return unless ref $_[1] eq 'CODE';

    push @{ $self->{_write_match} }, [@_];
}


###############################################################################
#
# write($row, $col, $token, $format)
#
# Parse $token and call appropriate write method. $row and $column are zero
# indexed. $format is optional.
#
# Returns: return value of called subroutine
#
sub write {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    my $token = $_[2];

    # Handle undefs as blanks
    $token = '' unless defined $token;


    # First try user defined matches.
    for my $aref ( @{ $self->{_write_match} } ) {
        my $re  = $aref->[0];
        my $sub = $aref->[1];

        if ( $token =~ /$re/ ) {
            my $match = &$sub( $self, @_ );
            return $match if defined $match;
        }
    }


    # Match an array ref.
    if ( ref $token eq "ARRAY" ) {
        return $self->write_row( @_ );
    }

    # Match integer with leading zero(s)
    elsif ( $self->{_leading_zeros} and $token =~ /^0\d+$/ ) {
        return $self->write_string( @_ );
    }

    # Match number
    elsif ( $token =~ /^([+-]?)(?=[0-9]|\.[0-9])[0-9]*(\.[0-9]*)?([Ee]([+-]?[0-9]+))?$/ ) {
        return $self->write_number( @_ );
    }

    # Match http, https or ftp URL
    elsif ( $token =~ m|^[fh]tt?ps?://| ) {
        return $self->write_url( @_ );
    }

    # Match mailto:
    elsif ( $token =~ m/^mailto:/ ) {
        return $self->write_url( @_ );
    }

    # Match internal or external sheet link
    elsif ( $token =~ m[^(?:in|ex)ternal:] ) {
        return $self->write_url( @_ );
    }

    # Match formula
    elsif ( $token =~ /^=/ ) {
        return $self->write_formula( @_ );
    }

    # Match array formula
    elsif ( $token =~ /^{=.*}$/ ) {
        return $self->write_formula( @_ );
    }

    # Match blank
    elsif ( $token eq '' ) {
        splice @_, 2, 1;    # remove the empty string from the parameter list
        return $self->write_blank( @_ );
    }

    # Default: match string
    else {
        return $self->write_string( @_ );
    }
}


###############################################################################
#
# write_row($row, $col, $array_ref, $format)
#
# Write a row of data starting from ($row, $col). Call write_col() if any of
# the elements of the array ref are in turn array refs. This allows the writing
# of 1D or 2D arrays of data in one go.
#
# Returns: the first encountered error value or zero for no errors
#
sub write_row {

    my $self = shift;


    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    # Catch non array refs passed by user.
    if ( ref $_[2] ne 'ARRAY' ) {
        croak "Not an array ref in call to write_row()$!";
    }

    my $row     = shift;
    my $col     = shift;
    my $tokens  = shift;
    my @options = @_;
    my $error   = 0;
    my $ret;

    for my $token ( @$tokens ) {

        # Check for nested arrays
        if ( ref $token eq "ARRAY" ) {
            $ret = $self->write_col( $row, $col, $token, @options );
        }
        else {
            $ret = $self->write( $row, $col, $token, @options );
        }

        # Return only the first error encountered, if any.
        $error ||= $ret;
        $col++;
    }

    return $error;
}


###############################################################################
#
# write_col($row, $col, $array_ref, $format)
#
# Write a column of data starting from ($row, $col). Call write_row() if any of
# the elements of the array ref are in turn array refs. This allows the writing
# of 1D or 2D arrays of data in one go.
#
# Returns: the first encountered error value or zero for no errors
#
sub write_col {

    my $self = shift;


    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    # Catch non array refs passed by user.
    if ( ref $_[2] ne 'ARRAY' ) {
        croak "Not an array ref in call to write_col()$!";
    }

    my $row     = shift;
    my $col     = shift;
    my $tokens  = shift;
    my @options = @_;
    my $error   = 0;
    my $ret;

    for my $token ( @$tokens ) {

        # write() will deal with any nested arrays
        $ret = $self->write( $row, $col, $token, @options );

        # Return only the first error encountered, if any.
        $error ||= $ret;
        $row++;
    }

    return $error;
}


###############################################################################
#
# write_comment($row, $col, $comment)
#
# Write a comment to the specified row and column (zero indexed).
#
# Returns  0 : normal termination
#         -1 : insufficient number of arguments
#         -2 : row or column out of range
#
sub write_comment {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    if ( @_ < 3 ) { return -1 }    # Check the number of args

    my $row = $_[0];
    my $col = $_[1];

    # Check for pairs of optional arguments, i.e. an odd number of args.
    croak "Uneven number of additional arguments" unless @_ % 2;

    # Check that row and col are valid and store max and min values
    return -2 if $self->_check_dimensions( $row, $col );

    $self->{_has_vml}      = 1;
    $self->{_has_comments} = 1;

    # Process the properties of the cell comment.
    $self->{_comments}->{$row}->{$col} = [ $self->_comment_params( @_ ) ];
}


###############################################################################
#
# write_number($row, $col, $num, $format)
#
# Write a double to the specified row and column (zero indexed).
# An integer can be written as a double. Excel will display an
# integer. $format is optional.
#
# Returns  0 : normal termination
#         -1 : insufficient number of arguments
#         -2 : row or column out of range
#
sub write_number {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    if ( @_ < 3 ) { return -1 }    # Check the number of args


    my $row  = $_[0];              # Zero indexed row
    my $col  = $_[1];              # Zero indexed column
    my $num  = $_[2] + 0;
    my $xf   = $_[3];              # The cell format
    my $type = 'n';                # The data type

    # Check that row and col are valid and store max and min values
    return -2 if $self->_check_dimensions( $row, $col );

    # Write previous row if in in-line string optimization mode.
    if ( $self->{_optimization} == 1 && $row > $self->{_previous_row} ) {
        $self->_write_single_row( $row );
    }

    $self->{_table}->{$row}->{$col} = [ $type, $num, $xf ];

    return 0;
}


###############################################################################
#
# write_string ($row, $col, $string, $format)
#
# Write a string to the specified row and column (zero indexed).
# $format is optional.
# Returns  0 : normal termination
#         -1 : insufficient number of arguments
#         -2 : row or column out of range
#         -3 : long string truncated to 32767 chars
#
sub write_string {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    if ( @_ < 3 ) { return -1 }    # Check the number of args

    my $row  = $_[0];              # Zero indexed row
    my $col  = $_[1];              # Zero indexed column
    my $str  = $_[2];
    my $xf   = $_[3];              # The cell format
    my $type = 's';                # The data type
    my $index;
    my $str_error = 0;

    # Check that row and col are valid and store max and min values
    return -2 if $self->_check_dimensions( $row, $col );

    # Check that the string is < 32767 chars
    if ( length $str > $self->{_xls_strmax} ) {
        $str = substr( $str, 0, $self->{_xls_strmax} );
        $str_error = -3;
    }

    # Write a shared string or an in-line string based on optimisation level.
    if ( $self->{_optimization} == 0 ) {
        $index = $self->_get_shared_string_index( $str );
    }
    else {
        $index = $str;
    }

    # Write previous row if in in-line string optimization mode.
    if ( $self->{_optimization} == 1 && $row > $self->{_previous_row} ) {
        $self->_write_single_row( $row );
    }

    $self->{_table}->{$row}->{$col} = [ $type, $index, $xf ];

    return $str_error;
}


###############################################################################
#
# write_rich_string( $row, $column, $format, $string, ..., $cell_format )
#
# The write_rich_string() method is used to write strings with multiple formats.
# The method receives string fragments prefixed by format objects. The final
# format object is used as the cell format.
#
# Returns  0 : normal termination.
#         -1 : insufficient number of arguments.
#         -2 : row or column out of range.
#         -3 : long string truncated to 32767 chars.
#         -4 : 2 consecutive formats used.
#
sub write_rich_string {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    if ( @_ < 3 ) { return -1 }    # Check the number of args

    my $row    = shift;            # Zero indexed row.
    my $col    = shift;            # Zero indexed column.
    my $str    = '';
    my $xf     = undef;
    my $type   = 's';              # The data type.
    my $length = 0;                # String length.
    my $index;
    my $str_error = 0;

    # Check that row and col are valid and store max and min values
    return -2 if $self->_check_dimensions( $row, $col );


    # If the last arg is a format we use it as the cell format.
    if ( ref $_[-1] ) {
        $xf = pop @_;
    }


    # Create a temp XML::Writer object and use it to write the rich string
    # XML to a string.
    open my $str_fh, '>', \$str or die "Failed to open filehandle: $!";
    binmode $str_fh, ':utf8';

    my $writer = Excel::Writer::XLSX::Package::XMLwriter->new( $str_fh );

    $self->{_rstring} = $writer;

    # Create a temp format with the default font for unformatted fragments.
    my $default = Excel::Writer::XLSX::Format->new();

    # Convert the list of $format, $string tokens to pairs of ($format, $string)
    # except for the first $string fragment which doesn't require a default
    # formatting run. Use the default for strings without a leading format.
    my @fragments;
    my $last = 'format';
    my $pos  = 0;

    for my $token ( @_ ) {
        if ( !ref $token ) {

            # Token is a string.
            if ( $last ne 'format' ) {

                # If previous token wasn't a format add one before the string.
                push @fragments, ( $default, $token );
            }
            else {

                # If previous token was a format just add the string.
                push @fragments, $token;
            }

            $length += length $token;    # Keep track of actual string length.
            $last = 'string';
        }
        else {

            # Can't allow 2 formats in a row.
            if ( $last eq 'format' && $pos > 0 ) {
                return -4;
            }

            # Token is a format object. Add it to the fragment list.
            push @fragments, $token;
            $last = 'format';
        }

        $pos++;
    }


    # If the first token is a string start the <r> element.
    if ( !ref $fragments[0] ) {
        $self->{_rstring}->xml_start_tag( 'r' );
    }

    # Write the XML elements for the $format $string fragments.
    for my $token ( @fragments ) {
        if ( ref $token ) {

            # Write the font run.
            $self->{_rstring}->xml_start_tag( 'r' );
            $self->_write_font( $token );
        }
        else {

            # Write the string fragment part, with whitespace handling.
            my @attributes = ();

            if ( $token =~ /^\s/ || $token =~ /\s$/ ) {
                push @attributes, ( 'xml:space' => 'preserve' );
            }

            $self->{_rstring}->xml_data_element( 't', $token, @attributes );
            $self->{_rstring}->xml_end_tag( 'r' );
        }
    }

    # Check that the string is < 32767 chars.
    if ( $length > $self->{_xls_strmax} ) {
        return -3;
    }


    # Write a shared string or an in-line string based on optimisation level.
    if ( $self->{_optimization} == 0 ) {
        $index = $self->_get_shared_string_index( $str );
    }
    else {
        $index = $str;
    }

    # Write previous row if in in-line string optimization mode.
    if ( $self->{_optimization} == 1 && $row > $self->{_previous_row} ) {
        $self->_write_single_row( $row );
    }

    $self->{_table}->{$row}->{$col} = [ $type, $index, $xf ];

    return 0;
}


###############################################################################
#
# write_blank($row, $col, $format)
#
# Write a blank cell to the specified row and column (zero indexed).
# A blank cell is used to specify formatting without adding a string
# or a number.
#
# A blank cell without a format serves no purpose. Therefore, we don't write
# a BLANK record unless a format is specified. This is mainly an optimisation
# for the write_row() and write_col() methods.
#
# Returns  0 : normal termination (including no format)
#         -1 : insufficient number of arguments
#         -2 : row or column out of range
#
sub write_blank {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    # Check the number of args
    return -1 if @_ < 2;

    # Don't write a blank cell unless it has a format
    return 0 if not defined $_[2];

    my $row  = $_[0];    # Zero indexed row
    my $col  = $_[1];    # Zero indexed column
    my $xf   = $_[2];    # The cell format
    my $type = 'b';      # The data type

    # Check that row and col are valid and store max and min values
    return -2 if $self->_check_dimensions( $row, $col );

    # Write previous row if in in-line string optimization mode.
    if ( $self->{_optimization} == 1 && $row > $self->{_previous_row} ) {
        $self->_write_single_row( $row );
    }

    $self->{_table}->{$row}->{$col} = [ $type, undef, $xf ];

    return 0;
}


###############################################################################
#
# write_formula($row, $col, $formula, $format)
#
# Write a formula to the specified row and column (zero indexed).
#
# $format is optional.
#
# Returns  0 : normal termination
#         -1 : insufficient number of arguments
#         -2 : row or column out of range
#
sub write_formula {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    if ( @_ < 3 ) { return -1 }    # Check the number of args

    my $row     = $_[0];           # Zero indexed row
    my $col     = $_[1];           # Zero indexed column
    my $formula = $_[2];           # The formula text string
    my $xf      = $_[3];           # The format object.
    my $value   = $_[4];           # Optional formula value.
    my $type    = 'f';             # The data type

    # Hand off array formulas.
    if ( $formula =~ /^{=.*}$/ ) {
        return $self->write_array_formula( $row, $col, $row, $col, $formula,
            $xf, $value );
    }

    # Check that row and col are valid and store max and min values
    return -2 if $self->_check_dimensions( $row, $col );

    # Remove the = sign if it exists.
    $formula =~ s/^=//;

    # Write previous row if in in-line string optimization mode.
    if ( $self->{_optimization} == 1 && $row > $self->{_previous_row} ) {
        $self->_write_single_row( $row );
    }

    $self->{_table}->{$row}->{$col} = [ $type, $formula, $xf, $value ];

    return 0;
}


###############################################################################
#
# write_array_formula($row1, $col1, $row2, $col2, $formula, $format)
#
# Write an array formula to the specified row and column (zero indexed).
#
# $format is optional.
#
# Returns  0 : normal termination
#         -1 : insufficient number of arguments
#         -2 : row or column out of range
#
sub write_array_formula {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    if ( @_ < 5 ) { return -1 }    # Check the number of args

    my $row1    = $_[0];           # First row
    my $col1    = $_[1];           # First column
    my $row2    = $_[2];           # Last row
    my $col2    = $_[3];           # Last column
    my $formula = $_[4];           # The formula text string
    my $xf      = $_[5];           # The format object.
    my $value   = $_[6];           # Optional formula value.
    my $type    = 'a';             # The data type

    # Swap last row/col with first row/col as necessary
    ( $row1, $row2 ) = ( $row2, $row1 ) if $row1 > $row2;
    ( $col1, $col2 ) = ( $col1, $col2 ) if $col1 > $col2;


    # Check that row and col are valid and store max and min values
    return -2 if $self->_check_dimensions( $row2, $col2 );


    # Define array range
    my $range;

    if ( $row1 == $row2 and $col1 == $col2 ) {
        $range = xl_rowcol_to_cell( $row1, $col1 );

    }
    else {
        $range =
            xl_rowcol_to_cell( $row1, $col1 ) . ':'
          . xl_rowcol_to_cell( $row2, $col2 );
    }

    # Remove array formula braces and the leading =.
    $formula =~ s/^{(.*)}$/$1/;
    $formula =~ s/^=//;

    # Write previous row if in in-line string optimization mode.
    my $row = $row1;
    if ( $self->{_optimization} == 1 && $row > $self->{_previous_row} ) {
        $self->_write_single_row( $row );
    }

    $self->{_table}->{$row1}->{$col1} =
      [ $type, $formula, $xf, $range, $value ];


    # Pad out the rest of the area with formatted zeroes.
    if ( !$self->{_optimization} ) {
        for my $row ( $row1 .. $row2 ) {
            for my $col ( $col1 .. $col2 ) {
                next if $row == $row1 and $col == $col1;
                $self->write_number( $row, $col, 0, $xf );
            }
        }
    }

    return 0;
}


###############################################################################
#
# write_blank($row, $col, $format)
#
# Write a boolean value to the specified row and column (zero indexed).
#
# Returns  0 : normal termination (including no format)
#         -2 : row or column out of range
#
sub write_boolean {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    my $row  = $_[0];            # Zero indexed row
    my $col  = $_[1];            # Zero indexed column
    my $val  = $_[2] ? 1 : 0;    # Boolean value.
    my $xf   = $_[3];            # The cell format
    my $type = 'l';              # The data type

    # Check that row and col are valid and store max and min values
    return -2 if $self->_check_dimensions( $row, $col );

    # Write previous row if in in-line string optimization mode.
    if ( $self->{_optimization} == 1 && $row > $self->{_previous_row} ) {
        $self->_write_single_row( $row );
    }

    $self->{_table}->{$row}->{$col} = [ $type, $val, $xf ];

    return 0;
}


###############################################################################
#
# outline_settings($visible, $symbols_below, $symbols_right, $auto_style)
#
# This method sets the properties for outlining and grouping. The defaults
# correspond to Excel's defaults.
#
sub outline_settings {

    my $self = shift;

    $self->{_outline_on}    = defined $_[0] ? $_[0] : 1;
    $self->{_outline_below} = defined $_[1] ? $_[1] : 1;
    $self->{_outline_right} = defined $_[2] ? $_[2] : 1;
    $self->{_outline_style} = $_[3] || 0;

    $self->{_outline_changed} = 1;
}


###############################################################################
#
# Escape urls like Excel.
#
sub _escape_url {

    my $url = shift;

    # Don't escape URL if it looks already escaped.
    return $url if $url =~ /%[0-9a-fA-F]{2}/;

    # Escape the URL escape symbol.
    $url =~ s/%/%25/g;

    # Escape whitespace in URL.
    $url =~ s/[\s\x00]/%20/g;

    # Escape other special characters in URL.
    $url =~ s/(["<>[\]`^{}])/sprintf '%%%x', ord $1/eg;

    return $url;
}


###############################################################################
#
# write_url($row, $col, $url, $string, $format)
#
# Write a hyperlink. This is comprised of two elements: the visible label and
# the invisible link. The visible label is the same as the link unless an
# alternative string is specified. The label is written using the
# write_string() method. Therefore the max characters string limit applies.
# $string and $format are optional and their order is interchangeable.
#
# The hyperlink can be to a http, ftp, mail, internal sheet, or external
# directory url.
#
# Returns  0 : normal termination
#         -1 : insufficient number of arguments
#         -2 : row or column out of range
#         -3 : long string truncated to 32767 chars
#         -4 : URL longer than 255 characters
#         -5 : Exceeds limit of 65_530 urls per worksheet
#
sub write_url {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    if ( @_ < 3 ) { return -1 }    # Check the number of args


    # Reverse the order of $string and $format if necessary. We work on a copy
    # in order to protect the callers args. We don't use "local @_" in case of
    # perl50005 threads.
    my @args = @_;
    ( $args[3], $args[4] ) = ( $args[4], $args[3] ) if ref $args[3];


    my $row       = $args[0];    # Zero indexed row
    my $col       = $args[1];    # Zero indexed column
    my $url       = $args[2];    # URL string
    my $str       = $args[3];    # Alternative label
    my $xf        = $args[4];    # Cell format
    my $tip       = $args[5];    # Tool tip
    my $type      = 'l';         # XML data type
    my $link_type = 1;
    my $external  = 0;

    # The displayed string defaults to the url string.
    $str = $url unless defined $str;

    # Remove the URI scheme from internal links.
    if ( $url =~ s/^internal:// ) {
        $str =~ s/^internal://;
        $link_type = 2;
    }

    # Remove the URI scheme from external links and change the directory
    # separator from Unix to Dos.
    if ( $url =~ s/^external:// ) {
        $str =~ s/^external://;
        $url =~ s[/][\\]g;
        $str =~ s[/][\\]g;
        $external = 1;
    }

    # Strip the mailto header.
    $str =~ s/^mailto://;

    # Check that row and col are valid and store max and min values
    return -2 if $self->_check_dimensions( $row, $col );

    # Check that the string is < 32767 chars
    my $str_error = 0;
    if ( length $str > $self->{_xls_strmax} ) {
        $str = substr( $str, 0, $self->{_xls_strmax} );
        $str_error = -3;
    }

    # Copy string for use in hyperlink elements.
    my $url_str = $str;

    # External links to URLs and to other Excel workbooks have slightly
    # different characteristics that we have to account for.
    if ( $link_type == 1 ) {

        # Split url into the link and optional anchor/location.
        ( $url, $url_str ) = split /#/, $url, 2;

        $url = _escape_url( $url );

        # Escape the anchor for hyperlink style urls only.
        if ( $url_str && !$external ) {
            $url_str = _escape_url( $url_str );
        }

        # Add the file:/// URI to the url for Windows style "C:/" link and
        # Network shares.
        if ( $url =~ m{^\w:} || $url =~ m{^\\\\} ) {
            $url = 'file:///' . $url;
        }

        # Convert a ./dir/file.xlsx link to dir/file.xlsx.
        $url =~ s{^.\\}{};
    }

    # Excel limits the escaped URL and location/anchor to 255 characters.
    my $tmp_url_str = $url_str || '';

    if ( length $url > 255 || length $tmp_url_str > 255 ) {
        carp "Ignoring URL '$url' where link or anchor > 255 characters "
          . "since it exceeds Excel's limit for URLS. See LIMITATIONS "
          . "section of the Excel::Writer::XLSX documentation.";
        return -4;
    }

    # Check the limit of URLS per worksheet.
    $self->{_hlink_count}++;

    if ( $self->{_hlink_count} > 65_530 ) {
        carp "Ignoring URL '$url' since it exceeds Excel's limit of 65,530 "
          . "URLS per worksheet. See LIMITATIONS section of the "
          . "Excel::Writer::XLSX documentation.";
        return -5;
    }


    # Write previous row if in in-line string optimization mode.
    if ( $self->{_optimization} == 1 && $row > $self->{_previous_row} ) {
        $self->_write_single_row( $row );
    }

    # Write the hyperlink string.
    $self->write_string( $row, $col, $str, $xf );

    # Store the hyperlink data in a separate structure.
    $self->{_hyperlinks}->{$row}->{$col} = {
        _link_type => $link_type,
        _url       => $url,
        _str       => $url_str,
        _tip       => $tip
    };

    return $str_error;
}


###############################################################################
#
# write_date_time ($row, $col, $string, $format)
#
# Write a datetime string in ISO8601 "yyyy-mm-ddThh:mm:ss.ss" format as a
# number representing an Excel date. $format is optional.
#
# Returns  0 : normal termination
#         -1 : insufficient number of arguments
#         -2 : row or column out of range
#         -3 : Invalid date_time, written as string
#
sub write_date_time {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    if ( @_ < 3 ) { return -1 }    # Check the number of args

    my $row  = $_[0];              # Zero indexed row
    my $col  = $_[1];              # Zero indexed column
    my $str  = $_[2];
    my $xf   = $_[3];              # The cell format
    my $type = 'n';                # The data type


    # Check that row and col are valid and store max and min values
    return -2 if $self->_check_dimensions( $row, $col );

    my $str_error = 0;
    my $date_time = $self->convert_date_time( $str );

    # If the date isn't valid then write it as a string.
    if ( !defined $date_time ) {
        return $self->write_string( @_ );
    }

    # Write previous row if in in-line string optimization mode.
    if ( $self->{_optimization} == 1 && $row > $self->{_previous_row} ) {
        $self->_write_single_row( $row );
    }

    $self->{_table}->{$row}->{$col} = [ $type, $date_time, $xf ];

    return $str_error;
}


###############################################################################
#
# convert_date_time($date_time_string)
#
# The function takes a date and time in ISO8601 "yyyy-mm-ddThh:mm:ss.ss" format
# and converts it to a decimal number representing a valid Excel date.
#
# Dates and times in Excel are represented by real numbers. The integer part of
# the number stores the number of days since the epoch and the fractional part
# stores the percentage of the day in seconds. The epoch can be either 1900 or
# 1904.
#
# Parameter: Date and time string in one of the following formats:
#               yyyy-mm-ddThh:mm:ss.ss  # Standard
#               yyyy-mm-ddT             # Date only
#                         Thh:mm:ss.ss  # Time only
#
# Returns:
#            A decimal number representing a valid Excel date, or
#            undef if the date is invalid.
#
sub convert_date_time {

    my $self      = shift;
    my $date_time = $_[0];

    my $days    = 0;    # Number of days since epoch
    my $seconds = 0;    # Time expressed as fraction of 24h hours in seconds

    my ( $year, $month, $day );
    my ( $hour, $min,   $sec );


    # Strip leading and trailing whitespace.
    $date_time =~ s/^\s+//;
    $date_time =~ s/\s+$//;

    # Check for invalid date char.
    return if $date_time =~ /[^0-9T:\-\.Z]/;

    # Check for "T" after date or before time.
    return unless $date_time =~ /\dT|T\d/;

    # Strip trailing Z in ISO8601 date.
    $date_time =~ s/Z$//;


    # Split into date and time.
    my ( $date, $time ) = split /T/, $date_time;


    # We allow the time portion of the input DateTime to be optional.
    if ( $time ne '' ) {

        # Match hh:mm:ss.sss+ where the seconds are optional
        if ( $time =~ /^(\d\d):(\d\d)(:(\d\d(\.\d+)?))?/ ) {
            $hour = $1;
            $min  = $2;
            $sec  = $4 || 0;
        }
        else {
            return undef;    # Not a valid time format.
        }

        # Some boundary checks
        return if $hour >= 24;
        return if $min >= 60;
        return if $sec >= 60;

        # Excel expresses seconds as a fraction of the number in 24 hours.
        $seconds = ( $hour * 60 * 60 + $min * 60 + $sec ) / ( 24 * 60 * 60 );
    }


    # We allow the date portion of the input DateTime to be optional.
    return $seconds if $date eq '';


    # Match date as yyyy-mm-dd.
    if ( $date =~ /^(\d\d\d\d)-(\d\d)-(\d\d)$/ ) {
        $year  = $1;
        $month = $2;
        $day   = $3;
    }
    else {
        return undef;    # Not a valid date format.
    }

    # Set the epoch as 1900 or 1904. Defaults to 1900.
    my $date_1904 = $self->{_date_1904};


    # Special cases for Excel.
    if ( not $date_1904 ) {
        return $seconds      if $date eq '1899-12-31';    # Excel 1900 epoch
        return $seconds      if $date eq '1900-01-00';    # Excel 1900 epoch
        return 60 + $seconds if $date eq '1900-02-29';    # Excel false leapday
    }


    # We calculate the date by calculating the number of days since the epoch
    # and adjust for the number of leap days. We calculate the number of leap
    # days by normalising the year in relation to the epoch. Thus the year 2000
    # becomes 100 for 4 and 100 year leapdays and 400 for 400 year leapdays.
    #
    my $epoch  = $date_1904 ? 1904 : 1900;
    my $offset = $date_1904 ? 4    : 0;
    my $norm   = 300;
    my $range  = $year - $epoch;


    # Set month days and check for leap year.
    my @mdays = ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );
    my $leap = 0;
    $leap = 1 if $year % 4 == 0 and $year % 100 or $year % 400 == 0;
    $mdays[1] = 29 if $leap;


    # Some boundary checks
    return if $year < $epoch or $year > 9999;
    return if $month < 1     or $month > 12;
    return if $day < 1       or $day > $mdays[ $month - 1 ];

    # Accumulate the number of days since the epoch.
    $days = $day;    # Add days for current month
    $days += $mdays[$_] for 0 .. $month - 2;    # Add days for past months
    $days += $range * 365;                      # Add days for past years
    $days += int( ( $range ) / 4 );             # Add leapdays
    $days -= int( ( $range + $offset ) / 100 ); # Subtract 100 year leapdays
    $days += int( ( $range + $offset + $norm ) / 400 );  # Add 400 year leapdays
    $days -= $leap;                                      # Already counted above


    # Adjust for Excel erroneously treating 1900 as a leap year.
    $days++ if $date_1904 == 0 and $days > 59;

    return $days + $seconds;
}


###############################################################################
#
# set_row($row, $height, $XF, $hidden, $level, $collapsed)
#
# This method is used to set the height and XF format for a row.
#
sub set_row {

    my $self      = shift;
    my $row       = shift;         # Row Number.
    my $height    = shift;         # Row height.
    my $xf        = shift;         # Format object.
    my $hidden    = shift || 0;    # Hidden flag.
    my $level     = shift || 0;    # Outline level.
    my $collapsed = shift || 0;    # Collapsed row.
    my $min_col   = 0;

    return unless defined $row;    # Ensure at least $row is specified.

    # Get the default row height.
    my $default_height = $self->{_default_row_height};

    # Use min col in _check_dimensions(). Default to 0 if undefined.
    if ( defined $self->{_dim_colmin} ) {
        $min_col = $self->{_dim_colmin};
    }

    # Check that row is valid.
    return -2 if $self->_check_dimensions( $row, $min_col );

    $height = $default_height if !defined $height;

    # If the height is 0 the row is hidden and the height is the default.
    if ( $height == 0 ) {
        $hidden = 1;
        $height = $default_height;
    }

    # Set the limits for the outline levels (0 <= x <= 7).
    $level = 0 if $level < 0;
    $level = 7 if $level > 7;

    if ( $level > $self->{_outline_row_level} ) {
        $self->{_outline_row_level} = $level;
    }

    # Store the row properties.
    $self->{_set_rows}->{$row} = [ $height, $xf, $hidden, $level, $collapsed ];

    # Store the row change to allow optimisations.
    $self->{_row_size_changed} = 1;

    if ($hidden) {
        $height = 0;
    }

    # Store the row sizes for use when calculating image vertices.
    $self->{_row_sizes}->{$row} = $height;
}


###############################################################################
#
# set_default_row()
#
# Set the default row properties
#
sub set_default_row {

    my $self        = shift;
    my $height      = shift || $self->{_original_row_height};
    my $zero_height = shift || 0;

    if ( $height != $self->{_original_row_height} ) {
        $self->{_default_row_height} = $height;

        # Store the row change to allow optimisations.
        $self->{_row_size_changed} = 1;
    }

    if ( $zero_height ) {
        $self->{_default_row_zeroed} = 1;
    }
}


###############################################################################
#
# merge_range($first_row, $first_col, $last_row, $last_col, $string, $format)
#
# Merge a range of cells. The first cell should contain the data and the others
# should be blank. All cells should contain the same format.
#
sub merge_range {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }
    croak "Incorrect number of arguments" if @_ < 6;
    croak "Fifth parameter must be a format object" unless ref $_[5];

    my $row_first  = shift;
    my $col_first  = shift;
    my $row_last   = shift;
    my $col_last   = shift;
    my $string     = shift;
    my $format     = shift;
    my @extra_args = @_;      # For write_url().

    # Excel doesn't allow a single cell to be merged
    if ( $row_first == $row_last and $col_first == $col_last ) {
        croak "Can't merge single cell";
    }

    # Swap last row/col with first row/col as necessary
    ( $row_first, $row_last ) = ( $row_last, $row_first )
      if $row_first > $row_last;
    ( $col_first, $col_last ) = ( $col_last, $col_first )
      if $col_first > $col_last;

    # Check that column number is valid and store the max value
    return if $self->_check_dimensions( $row_last, $col_last );

    # Store the merge range.
    push @{ $self->{_merge} }, [ $row_first, $col_first, $row_last, $col_last ];

    # Write the first cell
    $self->write( $row_first, $col_first, $string, $format, @extra_args );

    # Pad out the rest of the area with formatted blank cells.
    for my $row ( $row_first .. $row_last ) {
        for my $col ( $col_first .. $col_last ) {
            next if $row == $row_first and $col == $col_first;
            $self->write_blank( $row, $col, $format );
        }
    }
}


###############################################################################
#
# merge_range_type()
#
# Same as merge_range() above except the type of write() is specified.
#
sub merge_range_type {

    my $self = shift;
    my $type = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    my $row_first = shift;
    my $col_first = shift;
    my $row_last  = shift;
    my $col_last  = shift;
    my $format;

    # Get the format. It can be in different positions for the different types.
    if (   $type eq 'array_formula'
        || $type eq 'blank'
        || $type eq 'rich_string' )
    {

        # The format is the last element.
        $format = $_[-1];
    }
    else {

        # Or else it is after the token.
        $format = $_[1];
    }

    # Check that there is a format object.
    croak "Format object missing or in an incorrect position"
      unless ref $format;

    # Excel doesn't allow a single cell to be merged
    if ( $row_first == $row_last and $col_first == $col_last ) {
        croak "Can't merge single cell";
    }

    # Swap last row/col with first row/col as necessary
    ( $row_first, $row_last ) = ( $row_last, $row_first )
      if $row_first > $row_last;
    ( $col_first, $col_last ) = ( $col_last, $col_first )
      if $col_first > $col_last;

    # Check that column number is valid and store the max value
    return if $self->_check_dimensions( $row_last, $col_last );

    # Store the merge range.
    push @{ $self->{_merge} }, [ $row_first, $col_first, $row_last, $col_last ];

    # Write the first cell
    if ( $type eq 'string' ) {
        $self->write_string( $row_first, $col_first, @_ );
    }
    elsif ( $type eq 'number' ) {
        $self->write_number( $row_first, $col_first, @_ );
    }
    elsif ( $type eq 'blank' ) {
        $self->write_blank( $row_first, $col_first, @_ );
    }
    elsif ( $type eq 'date_time' ) {
        $self->write_date_time( $row_first, $col_first, @_ );
    }
    elsif ( $type eq 'rich_string' ) {
        $self->write_rich_string( $row_first, $col_first, @_ );
    }
    elsif ( $type eq 'url' ) {
        $self->write_url( $row_first, $col_first, @_ );
    }
    elsif ( $type eq 'formula' ) {
        $self->write_formula( $row_first, $col_first, @_ );
    }
    elsif ( $type eq 'array_formula' ) {
        $self->write_formula_array( $row_first, $col_first, @_ );
    }
    else {
        croak "Unknown type '$type'";
    }

    # Pad out the rest of the area with formatted blank cells.
    for my $row ( $row_first .. $row_last ) {
        for my $col ( $col_first .. $col_last ) {
            next if $row == $row_first and $col == $col_first;
            $self->write_blank( $row, $col, $format );
        }
    }
}


###############################################################################
#
# data_validation($row, $col, {...})
#
# This method handles the interface to Excel data validation.
# Somewhat ironically this requires a lot of validation code since the
# interface is flexible and covers a several types of data validation.
#
# We allow data validation to be called on one cell or a range of cells. The
# hashref contains the validation parameters and must be the last param:
#    data_validation($row, $col, {...})
#    data_validation($first_row, $first_col, $last_row, $last_col, {...})
#
# Returns  0 : normal termination
#         -1 : insufficient number of arguments
#         -2 : row or column out of range
#         -3 : incorrect parameter.
#
sub data_validation {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    # Check for a valid number of args.
    if ( @_ != 5 && @_ != 3 ) { return -1 }

    # The final hashref contains the validation parameters.
    my $param = pop;

    # Make the last row/col the same as the first if not defined.
    my ( $row1, $col1, $row2, $col2 ) = @_;
    if ( !defined $row2 ) {
        $row2 = $row1;
        $col2 = $col1;
    }

    # Check that row and col are valid without storing the values.
    return -2 if $self->_check_dimensions( $row1, $col1, 1, 1 );
    return -2 if $self->_check_dimensions( $row2, $col2, 1, 1 );


    # Check that the last parameter is a hash list.
    if ( ref $param ne 'HASH' ) {
        carp "Last parameter '$param' in data_validation() must be a hash ref";
        return -3;
    }

    # List of valid input parameters.
    my %valid_parameter = (
        validate      => 1,
        criteria      => 1,
        value         => 1,
        source        => 1,
        minimum       => 1,
        maximum       => 1,
        ignore_blank  => 1,
        dropdown      => 1,
        show_input    => 1,
        input_title   => 1,
        input_message => 1,
        show_error    => 1,
        error_title   => 1,
        error_message => 1,
        error_type    => 1,
        other_cells   => 1,
    );

    # Check for valid input parameters.
    for my $param_key ( keys %$param ) {
        if ( not exists $valid_parameter{$param_key} ) {
            carp "Unknown parameter '$param_key' in data_validation()";
            return -3;
        }
    }

    # Map alternative parameter names 'source' or 'minimum' to 'value'.
    $param->{value} = $param->{source}  if defined $param->{source};
    $param->{value} = $param->{minimum} if defined $param->{minimum};

    # 'validate' is a required parameter.
    if ( not exists $param->{validate} ) {
        carp "Parameter 'validate' is required in data_validation()";
        return -3;
    }


    # List of  valid validation types.
    my %valid_type = (
        'any'          => 'none',
        'any value'    => 'none',
        'whole number' => 'whole',
        'whole'        => 'whole',
        'integer'      => 'whole',
        'decimal'      => 'decimal',
        'list'         => 'list',
        'date'         => 'date',
        'time'         => 'time',
        'text length'  => 'textLength',
        'length'       => 'textLength',
        'custom'       => 'custom',
    );


    # Check for valid validation types.
    if ( not exists $valid_type{ lc( $param->{validate} ) } ) {
        carp "Unknown validation type '$param->{validate}' for parameter "
          . "'validate' in data_validation()";
        return -3;
    }
    else {
        $param->{validate} = $valid_type{ lc( $param->{validate} ) };
    }

    # No action is required for validation type 'any'
    # unless there are input messages.
    if (   $param->{validate} eq 'none'
        && !defined $param->{input_message}
        && !defined $param->{input_title} )
    {
        return 0;
    }

    # The any, list and custom validations don't have a criteria
    # so we use a default of 'between'.
    if (   $param->{validate} eq 'none'
        || $param->{validate} eq 'list'
        || $param->{validate} eq 'custom' )
    {
        $param->{criteria} = 'between';
        $param->{maximum}  = undef;
    }

    # 'criteria' is a required parameter.
    if ( not exists $param->{criteria} ) {
        carp "Parameter 'criteria' is required in data_validation()";
        return -3;
    }


    # List of valid criteria types.
    my %criteria_type = (
        'between'                  => 'between',
        'not between'              => 'notBetween',
        'equal to'                 => 'equal',
        '='                        => 'equal',
        '=='                       => 'equal',
        'not equal to'             => 'notEqual',
        '!='                       => 'notEqual',
        '<>'                       => 'notEqual',
        'greater than'             => 'greaterThan',
        '>'                        => 'greaterThan',
        'less than'                => 'lessThan',
        '<'                        => 'lessThan',
        'greater than or equal to' => 'greaterThanOrEqual',
        '>='                       => 'greaterThanOrEqual',
        'less than or equal to'    => 'lessThanOrEqual',
        '<='                       => 'lessThanOrEqual',
    );

    # Check for valid criteria types.
    if ( not exists $criteria_type{ lc( $param->{criteria} ) } ) {
        carp "Unknown criteria type '$param->{criteria}' for parameter "
          . "'criteria' in data_validation()";
        return -3;
    }
    else {
        $param->{criteria} = $criteria_type{ lc( $param->{criteria} ) };
    }


    # 'Between' and 'Not between' criteria require 2 values.
    if ( $param->{criteria} eq 'between' || $param->{criteria} eq 'notBetween' )
    {
        if ( not exists $param->{maximum} ) {
            carp "Parameter 'maximum' is required in data_validation() "
              . "when using 'between' or 'not between' criteria";
            return -3;
        }
    }
    else {
        $param->{maximum} = undef;
    }


    # List of valid error dialog types.
    my %error_type = (
        'stop'        => 0,
        'warning'     => 1,
        'information' => 2,
    );

    # Check for valid error dialog types.
    if ( not exists $param->{error_type} ) {
        $param->{error_type} = 0;
    }
    elsif ( not exists $error_type{ lc( $param->{error_type} ) } ) {
        carp "Unknown criteria type '$param->{error_type}' for parameter "
          . "'error_type' in data_validation()";
        return -3;
    }
    else {
        $param->{error_type} = $error_type{ lc( $param->{error_type} ) };
    }


    # Convert date/times value if required.
    if ( $param->{validate} eq 'date' || $param->{validate} eq 'time' ) {
        if ( $param->{value} =~ /T/ ) {
            my $date_time = $self->convert_date_time( $param->{value} );

            if ( !defined $date_time ) {
                carp "Invalid date/time value '$param->{value}' "
                  . "in data_validation()";
                return -3;
            }
            else {
                $param->{value} = $date_time;
            }
        }
        if ( defined $param->{maximum} && $param->{maximum} =~ /T/ ) {
            my $date_time = $self->convert_date_time( $param->{maximum} );

            if ( !defined $date_time ) {
                carp "Invalid date/time value '$param->{maximum}' "
                  . "in data_validation()";
                return -3;
            }
            else {
                $param->{maximum} = $date_time;
            }
        }
    }

    # Check that the input title doesn't exceed the maximum length.
    if ( $param->{input_title} and length $param->{input_title} > 32 ) {
        carp "Length of input title '$param->{input_title}'"
          . " exceeds Excel's limit of 32";
        return -3;
    }

    # Check that the error title don't exceed the maximum length.
    if ( $param->{error_title} and length $param->{error_title} > 32 ) {
        carp "Length of error title '$param->{error_title}'"
          . " exceeds Excel's limit of 32";
        return -3;
    }

    # Check that the input message don't exceed the maximum length.
    if ( $param->{input_message} and length $param->{input_message} > 255 ) {
        carp "Length of input message '$param->{input_message}'"
          . " exceeds Excel's limit of 255";
        return -3;
    }

    # Check that the error message don't exceed the maximum length.
    if ( $param->{error_message} and length $param->{error_message} > 255 ) {
        carp "Length of error message '$param->{error_message}'"
          . " exceeds Excel's limit of 255";
        return -3;
    }

    # Check that the input list don't exceed the maximum length.
    if ( $param->{validate} eq 'list' ) {

        if ( ref $param->{value} eq 'ARRAY' ) {

            my $formula = join ',', @{ $param->{value} };
            if ( length $formula > 255 ) {
                carp "Length of list items '$formula' exceeds Excel's "
                  . "limit of 255, use a formula range instead";
                return -3;
            }
        }
    }

    # Set some defaults if they haven't been defined by the user.
    $param->{ignore_blank} = 1 if !defined $param->{ignore_blank};
    $param->{dropdown}     = 1 if !defined $param->{dropdown};
    $param->{show_input}   = 1 if !defined $param->{show_input};
    $param->{show_error}   = 1 if !defined $param->{show_error};


    # These are the cells to which the validation is applied.
    $param->{cells} = [ [ $row1, $col1, $row2, $col2 ] ];

    # A (for now) undocumented parameter to pass additional cell ranges.
    if ( exists $param->{other_cells} ) {

        push @{ $param->{cells} }, @{ $param->{other_cells} };
    }

    # Store the validation information until we close the worksheet.
    push @{ $self->{_validations} }, $param;
}


###############################################################################
#
# conditional_formatting($row, $col, {...})
#
# This method handles the interface to Excel conditional formatting.
#
# We allow the format to be called on one cell or a range of cells. The
# hashref contains the formatting parameters and must be the last param:
#    conditional_formatting($row, $col, {...})
#    conditional_formatting($first_row, $first_col, $last_row, $last_col, {...})
#
# Returns  0 : normal termination
#         -1 : insufficient number of arguments
#         -2 : row or column out of range
#         -3 : incorrect parameter.
#
sub conditional_formatting {

    my $self       = shift;
    my $user_range = '';

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {

        # Check for a user defined multiple range like B3:K6,B8:K11.
        if ( $_[0] =~ /,/ ) {
            $user_range = $_[0];
            $user_range =~ s/^=//;
            $user_range =~ s/\s*,\s*/ /g;
            $user_range =~ s/\$//g;
        }

        @_ = $self->_substitute_cellref( @_ );
    }

    # Check for a valid number of args.
    if ( @_ != 5 && @_ != 3 ) { return -1 }

    # The final hashref contains the validation parameters.
    my $options = pop;

    # Make the last row/col the same as the first if not defined.
    my ( $row1, $col1, $row2, $col2 ) = @_;
    if ( !defined $row2 ) {
        $row2 = $row1;
        $col2 = $col1;
    }

    # Check that row and col are valid without storing the values.
    return -2 if $self->_check_dimensions( $row1, $col1, 1, 1 );
    return -2 if $self->_check_dimensions( $row2, $col2, 1, 1 );


    # Check that the last parameter is a hash list.
    if ( ref $options ne 'HASH' ) {
        carp "Last parameter in conditional_formatting() "
          . "must be a hash ref";
        return -3;
    }

    # Copy the user params.
    my $param = {%$options};

    # List of valid input parameters.
    my %valid_parameter = (
        type         => 1,
        format       => 1,
        criteria     => 1,
        value        => 1,
        minimum      => 1,
        maximum      => 1,
        stop_if_true => 1,
        min_type     => 1,
        mid_type     => 1,
        max_type     => 1,
        min_value    => 1,
        mid_value    => 1,
        max_value    => 1,
        min_color    => 1,
        mid_color    => 1,
        max_color    => 1,
        bar_color    => 1,
    );

    # Check for valid input parameters.
    for my $param_key ( keys %$param ) {
        if ( not exists $valid_parameter{$param_key} ) {
            carp "Unknown parameter '$param_key' in conditional_formatting()";
            return -3;
        }
    }

    # 'type' is a required parameter.
    if ( not exists $param->{type} ) {
        carp "Parameter 'type' is required in conditional_formatting()";
        return -3;
    }


    # List of  valid validation types.
    my %valid_type = (
        'cell'          => 'cellIs',
        'date'          => 'date',
        'time'          => 'time',
        'average'       => 'aboveAverage',
        'duplicate'     => 'duplicateValues',
        'unique'        => 'uniqueValues',
        'top'           => 'top10',
        'bottom'        => 'top10',
        'text'          => 'text',
        'time_period'   => 'timePeriod',
        'blanks'        => 'containsBlanks',
        'no_blanks'     => 'notContainsBlanks',
        'errors'        => 'containsErrors',
        'no_errors'     => 'notContainsErrors',
        '2_color_scale' => '2_color_scale',
        '3_color_scale' => '3_color_scale',
        'data_bar'      => 'dataBar',
        'formula'       => 'expression',
    );


    # Check for valid validation types.
    if ( not exists $valid_type{ lc( $param->{type} ) } ) {
        carp "Unknown validation type '$param->{type}' for parameter "
          . "'type' in conditional_formatting()";
        return -3;
    }
    else {
        $param->{direction} = 'bottom' if $param->{type} eq 'bottom';
        $param->{type} = $valid_type{ lc( $param->{type} ) };
    }


    # List of valid criteria types.
    my %criteria_type = (
        'between'                  => 'between',
        'not between'              => 'notBetween',
        'equal to'                 => 'equal',
        '='                        => 'equal',
        '=='                       => 'equal',
        'not equal to'             => 'notEqual',
        '!='                       => 'notEqual',
        '<>'                       => 'notEqual',
        'greater than'             => 'greaterThan',
        '>'                        => 'greaterThan',
        'less than'                => 'lessThan',
        '<'                        => 'lessThan',
        'greater than or equal to' => 'greaterThanOrEqual',
        '>='                       => 'greaterThanOrEqual',
        'less than or equal to'    => 'lessThanOrEqual',
        '<='                       => 'lessThanOrEqual',
        'containing'               => 'containsText',
        'not containing'           => 'notContains',
        'begins with'              => 'beginsWith',
        'ends with'                => 'endsWith',
        'yesterday'                => 'yesterday',
        'today'                    => 'today',
        'last 7 days'              => 'last7Days',
        'last week'                => 'lastWeek',
        'this week'                => 'thisWeek',
        'next week'                => 'nextWeek',
        'last month'               => 'lastMonth',
        'this month'               => 'thisMonth',
        'next month'               => 'nextMonth',
    );

    # Check for valid criteria types.
    if ( defined $param->{criteria}
        && exists $criteria_type{ lc( $param->{criteria} ) } )
    {
        $param->{criteria} = $criteria_type{ lc( $param->{criteria} ) };
    }

    # Convert date/times value if required.
    if ( $param->{type} eq 'date' || $param->{type} eq 'time' ) {
        $param->{type} = 'cellIs';

        if ( defined $param->{value} && $param->{value} =~ /T/ ) {
            my $date_time = $self->convert_date_time( $param->{value} );

            if ( !defined $date_time ) {
                carp "Invalid date/time value '$param->{value}' "
                  . "in conditional_formatting()";
                return -3;
            }
            else {
                $param->{value} = $date_time;
            }
        }

        if ( defined $param->{minimum} && $param->{minimum} =~ /T/ ) {
            my $date_time = $self->convert_date_time( $param->{minimum} );

            if ( !defined $date_time ) {
                carp "Invalid date/time value '$param->{minimum}' "
                  . "in conditional_formatting()";
                return -3;
            }
            else {
                $param->{minimum} = $date_time;
            }
        }

        if ( defined $param->{maximum} && $param->{maximum} =~ /T/ ) {
            my $date_time = $self->convert_date_time( $param->{maximum} );

            if ( !defined $date_time ) {
                carp "Invalid date/time value '$param->{maximum}' "
                  . "in conditional_formatting()";
                return -3;
            }
            else {
                $param->{maximum} = $date_time;
            }
        }
    }

    # Set the formatting range.
    my $range      = '';
    my $start_cell = '';    # Use for formulas.

    # Swap last row/col for first row/col as necessary
    if ( $row1 > $row2 ) {
        ( $row1, $row2 ) = ( $row2, $row1 );
    }

    if ( $col1 > $col2 ) {
        ( $col1, $col2 ) = ( $col2, $col1 );
    }

    # If the first and last cell are the same write a single cell.
    if ( ( $row1 == $row2 ) && ( $col1 == $col2 ) ) {
        $range = xl_rowcol_to_cell( $row1, $col1 );
        $start_cell = $range;
    }
    else {
        $range = xl_range( $row1, $row2, $col1, $col2 );
        $start_cell = xl_rowcol_to_cell( $row1, $col1 );
    }

    # Override with user defined multiple range if provided.
    if ( $user_range ) {
        $range = $user_range;
    }

    # Get the dxf format index.
    if ( defined $param->{format} && ref $param->{format} ) {
        $param->{format} = $param->{format}->get_dxf_index();
    }

    # Set the priority based on the order of adding.
    $param->{priority} = $self->{_dxf_priority}++;

    # Special handling of text criteria.
    if ( $param->{type} eq 'text' ) {

        if ( $param->{criteria} eq 'containsText' ) {
            $param->{type}    = 'containsText';
            $param->{formula} = sprintf 'NOT(ISERROR(SEARCH("%s",%s)))',
              $param->{value}, $start_cell;
        }
        elsif ( $param->{criteria} eq 'notContains' ) {
            $param->{type}    = 'notContainsText';
            $param->{formula} = sprintf 'ISERROR(SEARCH("%s",%s))',
              $param->{value}, $start_cell;
        }
        elsif ( $param->{criteria} eq 'beginsWith' ) {
            $param->{type}    = 'beginsWith';
            $param->{formula} = sprintf 'LEFT(%s,%d)="%s"',
              $start_cell, length( $param->{value} ), $param->{value};
        }
        elsif ( $param->{criteria} eq 'endsWith' ) {
            $param->{type}    = 'endsWith';
            $param->{formula} = sprintf 'RIGHT(%s,%d)="%s"',
              $start_cell, length( $param->{value} ), $param->{value};
        }
        else {
            carp "Invalid text criteria '$param->{criteria}' "
              . "in conditional_formatting()";
        }
    }

    # Special handling of time time_period criteria.
    if ( $param->{type} eq 'timePeriod' ) {

        if ( $param->{criteria} eq 'yesterday' ) {
            $param->{formula} = sprintf 'FLOOR(%s,1)=TODAY()-1', $start_cell;
        }
        elsif ( $param->{criteria} eq 'today' ) {
            $param->{formula} = sprintf 'FLOOR(%s,1)=TODAY()', $start_cell;
        }
        elsif ( $param->{criteria} eq 'tomorrow' ) {
            $param->{formula} = sprintf 'FLOOR(%s,1)=TODAY()+1', $start_cell;
        }
        elsif ( $param->{criteria} eq 'last7Days' ) {
            $param->{formula} =
              sprintf 'AND(TODAY()-FLOOR(%s,1)<=6,FLOOR(%s,1)<=TODAY())',
              $start_cell, $start_cell;
        }
        elsif ( $param->{criteria} eq 'lastWeek' ) {
            $param->{formula} =
              sprintf 'AND(TODAY()-ROUNDDOWN(%s,0)>=(WEEKDAY(TODAY())),'
              . 'TODAY()-ROUNDDOWN(%s,0)<(WEEKDAY(TODAY())+7))',
              $start_cell, $start_cell;
        }
        elsif ( $param->{criteria} eq 'thisWeek' ) {
            $param->{formula} =
              sprintf 'AND(TODAY()-ROUNDDOWN(%s,0)<=WEEKDAY(TODAY())-1,'
              . 'ROUNDDOWN(%s,0)-TODAY()<=7-WEEKDAY(TODAY()))',
              $start_cell, $start_cell;
        }
        elsif ( $param->{criteria} eq 'nextWeek' ) {
            $param->{formula} =
              sprintf 'AND(ROUNDDOWN(%s,0)-TODAY()>(7-WEEKDAY(TODAY())),'
              . 'ROUNDDOWN(%s,0)-TODAY()<(15-WEEKDAY(TODAY())))',
              $start_cell, $start_cell;
        }
        elsif ( $param->{criteria} eq 'lastMonth' ) {
            $param->{formula} =
              sprintf
              'AND(MONTH(%s)=MONTH(TODAY())-1,OR(YEAR(%s)=YEAR(TODAY()),'
              . 'AND(MONTH(%s)=1,YEAR(A1)=YEAR(TODAY())-1)))',
              $start_cell, $start_cell, $start_cell;
        }
        elsif ( $param->{criteria} eq 'thisMonth' ) {
            $param->{formula} =
              sprintf 'AND(MONTH(%s)=MONTH(TODAY()),YEAR(%s)=YEAR(TODAY()))',
              $start_cell, $start_cell;
        }
        elsif ( $param->{criteria} eq 'nextMonth' ) {
            $param->{formula} =
              sprintf
              'AND(MONTH(%s)=MONTH(TODAY())+1,OR(YEAR(%s)=YEAR(TODAY()),'
              . 'AND(MONTH(%s)=12,YEAR(%s)=YEAR(TODAY())+1)))',
              $start_cell, $start_cell, $start_cell, $start_cell;
        }
        else {
            carp "Invalid time_period criteria '$param->{criteria}' "
              . "in conditional_formatting()";
        }
    }


    # Special handling of blanks/error types.
    if ( $param->{type} eq 'containsBlanks' ) {
        $param->{formula} = sprintf 'LEN(TRIM(%s))=0', $start_cell;
    }

    if ( $param->{type} eq 'notContainsBlanks' ) {
        $param->{formula} = sprintf 'LEN(TRIM(%s))>0', $start_cell;
    }

    if ( $param->{type} eq 'containsErrors' ) {
        $param->{formula} = sprintf 'ISERROR(%s)', $start_cell;
    }

    if ( $param->{type} eq 'notContainsErrors' ) {
        $param->{formula} = sprintf 'NOT(ISERROR(%s))', $start_cell;
    }


    # Special handling for 2 color scale.
    if ( $param->{type} eq '2_color_scale' ) {
        $param->{type} = 'colorScale';

        # Color scales don't use any additional formatting.
        $param->{format} = undef;

        # Turn off 3 color parameters.
        $param->{mid_type}  = undef;
        $param->{mid_color} = undef;

        $param->{min_type}  ||= 'min';
        $param->{max_type}  ||= 'max';
        $param->{min_value} ||= 0;
        $param->{max_value} ||= 0;
        $param->{min_color} ||= '#FF7128';
        $param->{max_color} ||= '#FFEF9C';

        $param->{max_color} = $self->_get_palette_color( $param->{max_color} );
        $param->{min_color} = $self->_get_palette_color( $param->{min_color} );
    }


    # Special handling for 3 color scale.
    if ( $param->{type} eq '3_color_scale' ) {
        $param->{type} = 'colorScale';

        # Color scales don't use any additional formatting.
        $param->{format} = undef;

        $param->{min_type}  ||= 'min';
        $param->{mid_type}  ||= 'percentile';
        $param->{max_type}  ||= 'max';
        $param->{min_value} ||= 0;
        $param->{mid_value} = 50 unless defined $param->{mid_value};
        $param->{max_value} ||= 0;
        $param->{min_color} ||= '#F8696B';
        $param->{mid_color} ||= '#FFEB84';
        $param->{max_color} ||= '#63BE7B';

        $param->{max_color} = $self->_get_palette_color( $param->{max_color} );
        $param->{mid_color} = $self->_get_palette_color( $param->{mid_color} );
        $param->{min_color} = $self->_get_palette_color( $param->{min_color} );
    }


    # Special handling for data bar.
    if ( $param->{type} eq 'dataBar' ) {

        # Color scales don't use any additional formatting.
        $param->{format} = undef;

        $param->{min_type}  ||= 'min';
        $param->{max_type}  ||= 'max';
        $param->{min_value} ||= 0;
        $param->{max_value} ||= 0;
        $param->{bar_color} ||= '#638EC6';

        $param->{bar_color} = $self->_get_palette_color( $param->{bar_color} );
    }


    # Store the validation information until we close the worksheet.
    push @{ $self->{_cond_formats}->{$range} }, $param;
}


###############################################################################
#
# add_table()
#
# Add an Excel table to a worksheet.
#
sub add_table {

    my $self       = shift;
    my $user_range = '';
    my %table;
    my @col_formats;

    # We would need to order the write statements very carefully within this
    # function to support optimisation mode. Disable add_table() when it is
    # on for now.
    if ( $self->{_optimization} == 1 ) {
        carp "add_table() isn't supported when set_optimization() is on";
        return -1;
    }

    # Check for a cell reference in A1 notation and substitute row and column
    if ( @_ && $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    # Check for a valid number of args.
    if ( @_ < 4 ) {
        carp "Not enough parameters to add_table()";
        return -1;
    }

    my ( $row1, $col1, $row2, $col2 ) = @_;

    # Check that row and col are valid without storing the values.
    return -2 if $self->_check_dimensions( $row1, $col1, 1, 1 );
    return -2 if $self->_check_dimensions( $row2, $col2, 1, 1 );


    # The final hashref contains the validation parameters.
    my $param = $_[4] || {};

    # Check that the last parameter is a hash list.
    if ( ref $param ne 'HASH' ) {
        carp "Last parameter '$param' in add_table() must be a hash ref";
        return -3;
    }


    # List of valid input parameters.
    my %valid_parameter = (
        autofilter     => 1,
        banded_columns => 1,
        banded_rows    => 1,
        columns        => 1,
        data           => 1,
        first_column   => 1,
        header_row     => 1,
        last_column    => 1,
        name           => 1,
        style          => 1,
        total_row      => 1,
    );

    # Check for valid input parameters.
    for my $param_key ( keys %$param ) {
        if ( not exists $valid_parameter{$param_key} ) {
            carp "Unknown parameter '$param_key' in add_table()";
            return -3;
        }
    }

    # Turn on Excel's defaults.
    $param->{banded_rows} = 1 if !defined $param->{banded_rows};
    $param->{header_row}  = 1 if !defined $param->{header_row};
    $param->{autofilter}  = 1 if !defined $param->{autofilter};

    # Set the table options.
    $table{_show_first_col}   = $param->{first_column}   ? 1 : 0;
    $table{_show_last_col}    = $param->{last_column}    ? 1 : 0;
    $table{_show_row_stripes} = $param->{banded_rows}    ? 1 : 0;
    $table{_show_col_stripes} = $param->{banded_columns} ? 1 : 0;
    $table{_header_row_count} = $param->{header_row}     ? 1 : 0;
    $table{_totals_row_shown} = $param->{total_row}      ? 1 : 0;


    # Set the table name.
    if ( defined $param->{name} ) {
        my $name = $param->{name};

        # Warn if the name contains invalid chars as defined by Excel help.
        if ( $name !~ m/^[\w\\][\w\\.]*$/ || $name =~ m/^\d/ ) {
            carp "Invalid character in name '$name' used in add_table()";
            return -3;
        }

        # Warn if the name looks like a cell name.
        if ( $name =~ m/^[a-zA-Z][a-zA-Z]?[a-dA-D]?[0-9]+$/ ) {
            carp "Invalid name '$name' looks like a cell name in add_table()";
            return -3;
        }

        # Warn if the name looks like a R1C1.
        if ( $name =~ m/^[rcRC]$/ || $name =~ m/^[rcRC]\d+[rcRC]\d+$/ ) {
            carp "Invalid name '$name' like a RC cell ref in add_table()";
            return -3;
        }

        $table{_name} = $param->{name};
    }

    # Set the table style.
    if ( defined $param->{style} ) {
        $table{_style} = $param->{style};

        # Remove whitespace from style name.
        $table{_style} =~ s/\s//g;
    }
    else {
        $table{_style} = "TableStyleMedium9";
    }


    # Swap last row/col for first row/col as necessary.
    if ( $row1 > $row2 ) {
        ( $row1, $row2 ) = ( $row2, $row1 );
    }

    if ( $col1 > $col2 ) {
        ( $col1, $col2 ) = ( $col2, $col1 );
    }


    # Set the data range rows (without the header and footer).
    my $first_data_row = $row1;
    my $last_data_row  = $row2;
    $first_data_row++ if $param->{header_row};
    $last_data_row--  if $param->{total_row};


    # Set the table and autofilter ranges.
    $table{_range}   = xl_range( $row1, $row2,          $col1, $col2 );
    $table{_a_range} = xl_range( $row1, $last_data_row, $col1, $col2 );


    # If the header row if off the default is to turn autofilter off.
    if ( !$param->{header_row} ) {
        $param->{autofilter} = 0;
    }

    # Set the autofilter range.
    if ( $param->{autofilter} ) {
        $table{_autofilter} = $table{_a_range};
    }

    # Add the table columns.
    my $col_id = 1;
    for my $col_num ( $col1 .. $col2 ) {

        # Set up the default column data.
        my $col_data = {
            _id             => $col_id,
            _name           => 'Column' . $col_id,
            _total_string   => '',
            _total_function => '',
            _formula        => '',
            _format         => undef,
            _name_format    => undef,
        };

        # Overwrite the defaults with any use defined values.
        if ( $param->{columns} ) {

            # Check if there are user defined values for this column.
            if ( my $user_data = $param->{columns}->[ $col_id - 1 ] ) {

                # Map user defined values to internal values.
                $col_data->{_name} = $user_data->{header}
                  if $user_data->{header};

                # Get the header format if defined.
                $col_data->{_name_format} = $user_data->{header_format};

                # Handle the column formula.
                if ( $user_data->{formula} ) {
                    my $formula = $user_data->{formula};

                    # Remove the leading = from formula.
                    $formula =~ s/^=//;

                    # Covert Excel 2010 "@" ref to 2007 "#This Row".
                    $formula =~ s/@/[#This Row],/g;

                    $col_data->{_formula} = $formula;

                    for my $row ( $first_data_row .. $last_data_row ) {
                        $self->write_formula( $row, $col_num, $formula,
                            $user_data->{format} );
                    }
                }

                # Handle the function for the total row.
                if ( $user_data->{total_function} ) {
                    my $function = $user_data->{total_function};

                    # Massage the function name.
                    $function = lc $function;
                    $function =~ s/_//g;
                    $function =~ s/\s//g;

                    $function = 'countNums' if $function eq 'countnums';
                    $function = 'stdDev'    if $function eq 'stddev';

                    $col_data->{_total_function} = $function;

                    my $formula = _table_function_to_formula(
                        $function,
                        $col_data->{_name}

                    );

                    my $value = $user_data->{total_value} || 0;

                    $self->write_formula( $row2, $col_num, $formula,
                        $user_data->{format}, $value );

                }
                elsif ( $user_data->{total_string} ) {

                    # Total label only (not a function).
                    my $total_string = $user_data->{total_string};
                    $col_data->{_total_string} = $total_string;

                    $self->write_string( $row2, $col_num, $total_string,
                        $user_data->{format} );
                }

                # Get the dxf format index.
                if ( defined $user_data->{format} && ref $user_data->{format} )
                {
                    $col_data->{_format} =
                      $user_data->{format}->get_dxf_index();
                }

                # Store the column format for writing the cell data.
                # It doesn't matter if it is undefined.
                $col_formats[ $col_id - 1 ] = $user_data->{format};
            }
        }

        # Store the column data.
        push @{ $table{_columns} }, $col_data;

        # Write the column headers to the worksheet.
        if ( $param->{header_row} ) {
            $self->write_string( $row1, $col_num, $col_data->{_name},
                $col_data->{_name_format} );
        }

        $col_id++;
    }    # Table columns.


    # Write the cell data if supplied.
    if ( my $data = $param->{data} ) {

        my $i = 0;    # For indexing the row data.
        for my $row ( $first_data_row .. $last_data_row ) {
            my $j = 0;    # For indexing the col data.

            for my $col ( $col1 .. $col2 ) {

                my $token = $data->[$i]->[$j];

                if ( defined $token ) {
                    $self->write( $row, $col, $token, $col_formats[$j] );
                }

                $j++;
            }
            $i++;
        }
    }


    # Store the table data.
    push @{ $self->{_tables} }, \%table;

    return \%table;
}


###############################################################################
#
# add_sparkline()
#
# Add sparklines to the worksheet.
#
sub add_sparkline {

    my $self      = shift;
    my $param     = shift;
    my $sparkline = {};

    # Check that the last parameter is a hash list.
    if ( ref $param ne 'HASH' ) {
        carp "Parameter list in add_sparkline() must be a hash ref";
        return -1;
    }

    # List of valid input parameters.
    my %valid_parameter = (
        location        => 1,
        range           => 1,
        type            => 1,
        high_point      => 1,
        low_point       => 1,
        negative_points => 1,
        first_point     => 1,
        last_point      => 1,
        markers         => 1,
        style           => 1,
        series_color    => 1,
        negative_color  => 1,
        markers_color   => 1,
        first_color     => 1,
        last_color      => 1,
        high_color      => 1,
        low_color       => 1,
        max             => 1,
        min             => 1,
        axis            => 1,
        reverse         => 1,
        empty_cells     => 1,
        show_hidden     => 1,
        plot_hidden     => 1,
        date_axis       => 1,
        weight          => 1,
    );

    # Check for valid input parameters.
    for my $param_key ( keys %$param ) {
        if ( not exists $valid_parameter{$param_key} ) {
            carp "Unknown parameter '$param_key' in add_sparkline()";
            return -2;
        }
    }

    # 'location' is a required parameter.
    if ( not exists $param->{location} ) {
        carp "Parameter 'location' is required in add_sparkline()";
        return -3;
    }

    # 'range' is a required parameter.
    if ( not exists $param->{range} ) {
        carp "Parameter 'range' is required in add_sparkline()";
        return -3;
    }


    # Handle the sparkline type.
    my $type = $param->{type} || 'line';

    if ( $type ne 'line' && $type ne 'column' && $type ne 'win_loss' ) {
        carp "Parameter 'type' must be 'line', 'column' "
          . "or 'win_loss' in add_sparkline()";
        return -4;
    }

    $type = 'stacked' if $type eq 'win_loss';
    $sparkline->{_type} = $type;


    # We handle single location/range values or array refs of values.
    if ( ref $param->{location} ) {
        $sparkline->{_locations} = $param->{location};
        $sparkline->{_ranges}    = $param->{range};
    }
    else {
        $sparkline->{_locations} = [ $param->{location} ];
        $sparkline->{_ranges}    = [ $param->{range} ];
    }

    my $range_count    = @{ $sparkline->{_ranges} };
    my $location_count = @{ $sparkline->{_locations} };

    # The ranges and locations must match.
    if ( $range_count != $location_count ) {
        carp "Must have the same number of location and range "
          . "parameters in add_sparkline()";
        return -5;
    }

    # Store the count.
    $sparkline->{_count} = @{ $sparkline->{_locations} };


    # Get the worksheet name for the range conversion below.
    my $sheetname = quote_sheetname( $self->{_name} );

    # Cleanup the input ranges.
    for my $range ( @{ $sparkline->{_ranges} } ) {

        # Remove the absolute reference $ symbols.
        $range =~ s{\$}{}g;

        # Remove the = from xl_range_formula(.
        $range =~ s{^=}{};

        # Convert a simple range into a full Sheet1!A1:D1 range.
        if ( $range !~ /!/ ) {
            $range = $sheetname . "!" . $range;
        }
    }

    # Cleanup the input locations.
    for my $location ( @{ $sparkline->{_locations} } ) {
        $location =~ s{\$}{}g;
    }

    # Map options.
    $sparkline->{_high}     = $param->{high_point};
    $sparkline->{_low}      = $param->{low_point};
    $sparkline->{_negative} = $param->{negative_points};
    $sparkline->{_first}    = $param->{first_point};
    $sparkline->{_last}     = $param->{last_point};
    $sparkline->{_markers}  = $param->{markers};
    $sparkline->{_min}      = $param->{min};
    $sparkline->{_max}      = $param->{max};
    $sparkline->{_axis}     = $param->{axis};
    $sparkline->{_reverse}  = $param->{reverse};
    $sparkline->{_hidden}   = $param->{show_hidden};
    $sparkline->{_weight}   = $param->{weight};

    # Map empty cells options.
    my $empty = $param->{empty_cells} || '';

    if ( $empty eq 'zero' ) {
        $sparkline->{_empty} = 0;
    }
    elsif ( $empty eq 'connect' ) {
        $sparkline->{_empty} = 'span';
    }
    else {
        $sparkline->{_empty} = 'gap';
    }


    # Map the date axis range.
    my $date_range = $param->{date_axis};

    if ( $date_range && $date_range !~ /!/ ) {
        $date_range = $sheetname . "!" . $date_range;
    }
    $sparkline->{_date_axis} = $date_range;


    # Set the sparkline styles.
    my $style_id = $param->{style} || 0;
    my $style = $Excel::Writer::XLSX::Package::Theme::spark_styles[$style_id];

    $sparkline->{_series_color}   = $style->{series};
    $sparkline->{_negative_color} = $style->{negative};
    $sparkline->{_markers_color}  = $style->{markers};
    $sparkline->{_first_color}    = $style->{first};
    $sparkline->{_last_color}     = $style->{last};
    $sparkline->{_high_color}     = $style->{high};
    $sparkline->{_low_color}      = $style->{low};

    # Override the style colours with user defined colors.
    $self->_set_spark_color( $sparkline, $param, 'series_color' );
    $self->_set_spark_color( $sparkline, $param, 'negative_color' );
    $self->_set_spark_color( $sparkline, $param, 'markers_color' );
    $self->_set_spark_color( $sparkline, $param, 'first_color' );
    $self->_set_spark_color( $sparkline, $param, 'last_color' );
    $self->_set_spark_color( $sparkline, $param, 'high_color' );
    $self->_set_spark_color( $sparkline, $param, 'low_color' );

    push @{ $self->{_sparklines} }, $sparkline;
}


###############################################################################
#
# insert_button()
#
# Insert a button form object into the worksheet.
#
sub insert_button {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    # Check the number of args.
    if ( @_ < 3 ) { return -1 }

    my $button = $self->_button_params( @_ );

    push @{ $self->{_buttons_array} }, $button;

    $self->{_has_vml} = 1;
}


###############################################################################
#
# set_vba_name()
#
# Set the VBA name for the worksheet.
#
sub set_vba_name {

    my $self         = shift;
    my $vba_codemame = shift;

    if ( $vba_codemame ) {
        $self->{_vba_codename} = $vba_codemame;
    }
    else {
        $self->{_vba_codename} = $self->{_name};
    }
}


###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# _table_function_to_formula
#
# Convert a table total function to a worksheet formula.
#
sub _table_function_to_formula {

    my $function = shift;
    my $col_name = shift;
    my $formula  = '';

    my %subtotals = (
        average   => 101,
        countNums => 102,
        count     => 103,
        max       => 104,
        min       => 105,
        stdDev    => 107,
        sum       => 109,
        var       => 110,
    );

    if ( exists $subtotals{$function} ) {
        my $func_num = $subtotals{$function};
        $formula = qq{SUBTOTAL($func_num,[$col_name])};
    }
    else {
        carp "Unsupported function '$function' in add_table()";
    }

    return $formula;
}


###############################################################################
#
# _set_spark_color()
#
# Set the sparkline colour.
#
sub _set_spark_color {

    my $self        = shift;
    my $sparkline   = shift;
    my $param       = shift;
    my $user_color  = shift;
    my $spark_color = '_' . $user_color;

    return unless $param->{$user_color};

    $sparkline->{$spark_color} =
      { _rgb => $self->_get_palette_color( $param->{$user_color} ) };
}


###############################################################################
#
# _get_palette_color()
#
# Convert from an Excel internal colour index to a XML style #RRGGBB index
# based on the default or user defined values in the Workbook palette.
#
sub _get_palette_color {

    my $self    = shift;
    my $index   = shift;
    my $palette = $self->{_palette};

    # Handle colours in #XXXXXX RGB format.
    if ( $index =~ m/^#([0-9A-F]{6})$/i ) {
        return "FF" . uc( $1 );
    }

    # Adjust the colour index.
    $index -= 8;

    # Palette is passed in from the Workbook class.
    my @rgb = @{ $palette->[$index] };

    return sprintf "FF%02X%02X%02X", @rgb[0, 1, 2];
}


###############################################################################
#
# _substitute_cellref()
#
# Substitute an Excel cell reference in A1 notation for  zero based row and
# column values in an argument list.
#
# Ex: ("A4", "Hello") is converted to (3, 0, "Hello").
#
sub _substitute_cellref {

    my $self = shift;
    my $cell = uc( shift );

    # Convert a column range: 'A:A' or 'B:G'.
    # A range such as A:A is equivalent to A1:Rowmax, so add rows as required
    if ( $cell =~ /\$?([A-Z]{1,3}):\$?([A-Z]{1,3})/ ) {
        my ( $row1, $col1 ) = $self->_cell_to_rowcol( $1 . '1' );
        my ( $row2, $col2 ) =
          $self->_cell_to_rowcol( $2 . $self->{_xls_rowmax} );
        return $row1, $col1, $row2, $col2, @_;
    }

    # Convert a cell range: 'A1:B7'
    if ( $cell =~ /\$?([A-Z]{1,3}\$?\d+):\$?([A-Z]{1,3}\$?\d+)/ ) {
        my ( $row1, $col1 ) = $self->_cell_to_rowcol( $1 );
        my ( $row2, $col2 ) = $self->_cell_to_rowcol( $2 );
        return $row1, $col1, $row2, $col2, @_;
    }

    # Convert a cell reference: 'A1' or 'AD2000'
    if ( $cell =~ /\$?([A-Z]{1,3}\$?\d+)/ ) {
        my ( $row1, $col1 ) = $self->_cell_to_rowcol( $1 );
        return $row1, $col1, @_;

    }

    croak( "Unknown cell reference $cell" );
}


###############################################################################
#
# _cell_to_rowcol($cell_ref)
#
# Convert an Excel cell reference in A1 notation to a zero based row and column
# reference; converts C1 to (0, 2).
#
# See also: http://www.perlmonks.org/index.pl?node_id=270352
#
# Returns: ($row, $col, $row_absolute, $col_absolute)
#
#
sub _cell_to_rowcol {

    my $self = shift;

    my $cell = $_[0];
    $cell =~ /(\$?)([A-Z]{1,3})(\$?)(\d+)/;

    my $col_abs = $1 eq "" ? 0 : 1;
    my $col     = $2;
    my $row_abs = $3 eq "" ? 0 : 1;
    my $row     = $4;

    # Convert base26 column string to number
    # All your Base are belong to us.
    my @chars = split //, $col;
    my $expn = 0;
    $col = 0;

    while ( @chars ) {
        my $char = pop( @chars );    # LS char first
        $col += ( ord( $char ) - ord( 'A' ) + 1 ) * ( 26**$expn );
        $expn++;
    }

    # Convert 1-index to zero-index
    $row--;
    $col--;

    # TODO Check row and column range
    return $row, $col, $row_abs, $col_abs;
}


###############################################################################
#
# _xl_rowcol_to_cell($row, $col)
#
# Optimised version of xl_rowcol_to_cell from Utility.pm for the inner loop
# of _write_cell().
#

our @col_names = ( 'A' .. 'XFD' );

sub _xl_rowcol_to_cell {
    return $col_names[ $_[1] ] . ( $_[0] + 1 );
}


###############################################################################
#
# _sort_pagebreaks()
#
# This is an internal method that is used to filter elements of the array of
# pagebreaks used in the _store_hbreak() and _store_vbreak() methods. It:
#   1. Removes duplicate entries from the list.
#   2. Sorts the list.
#   3. Removes 0 from the list if present.
#
sub _sort_pagebreaks {

    my $self = shift;

    return () unless @_;

    my %hash;
    my @array;

    @hash{@_} = undef;    # Hash slice to remove duplicates
    @array = sort { $a <=> $b } keys %hash;    # Numerical sort
    shift @array if $array[0] == 0;            # Remove zero

    # The Excel 2007 specification says that the maximum number of page breaks
    # is 1026. However, in practice it is actually 1023.
    my $max_num_breaks = 1023;
    splice( @array, $max_num_breaks ) if @array > $max_num_breaks;

    return @array;
}


###############################################################################
#
# _check_dimensions($row, $col, $ignore_row, $ignore_col)
#
# Check that $row and $col are valid and store max and min values for use in
# other methods/elements.
#
# The $ignore_row/$ignore_col flags is used to indicate that we wish to
# perform the dimension check without storing the value.
#
# The ignore flags are use by set_row() and data_validate.
#
sub _check_dimensions {

    my $self       = shift;
    my $row        = $_[0];
    my $col        = $_[1];
    my $ignore_row = $_[2];
    my $ignore_col = $_[3];


    return -2 if not defined $row;
    return -2 if $row >= $self->{_xls_rowmax};

    return -2 if not defined $col;
    return -2 if $col >= $self->{_xls_colmax};

    # In optimization mode we don't change dimensions for rows that are
    # already written.
    if ( !$ignore_row && !$ignore_col && $self->{_optimization} == 1 ) {
        return -2 if $row < $self->{_previous_row};
    }

    if ( !$ignore_row ) {

        if ( not defined $self->{_dim_rowmin} or $row < $self->{_dim_rowmin} ) {
            $self->{_dim_rowmin} = $row;
        }

        if ( not defined $self->{_dim_rowmax} or $row > $self->{_dim_rowmax} ) {
            $self->{_dim_rowmax} = $row;
        }
    }

    if ( !$ignore_col ) {

        if ( not defined $self->{_dim_colmin} or $col < $self->{_dim_colmin} ) {
            $self->{_dim_colmin} = $col;
        }

        if ( not defined $self->{_dim_colmax} or $col > $self->{_dim_colmax} ) {
            $self->{_dim_colmax} = $col;
        }
    }

    return 0;
}


###############################################################################
#
#  _position_object_pixels()
#
# Calculate the vertices that define the position of a graphical object within
# the worksheet in pixels.
#
#         +------------+------------+
#         |     A      |      B     |
#   +-----+------------+------------+
#   |     |(x1,y1)     |            |
#   |  1  |(A1)._______|______      |
#   |     |    |              |     |
#   |     |    |              |     |
#   +-----+----|    Object    |-----+
#   |     |    |              |     |
#   |  2  |    |______________.     |
#   |     |            |        (B2)|
#   |     |            |     (x2,y2)|
#   +---- +------------+------------+
#
# Example of an object that covers some of the area from cell A1 to cell B2.
#
# Based on the width and height of the object we need to calculate 8 vars:
#
#     $col_start, $row_start, $col_end, $row_end, $x1, $y1, $x2, $y2.
#
# We also calculate the absolute x and y position of the top left vertex of
# the object. This is required for images.
#
#    $x_abs, $y_abs
#
# The width and height of the cells that the object occupies can be variable
# and have to be taken into account.
#
# The values of $col_start and $row_start are passed in from the calling
# function. The values of $col_end and $row_end are calculated by subtracting
# the width and height of the object from the width and height of the
# underlying cells.
#
sub _position_object_pixels {

    my $self = shift;

    my $col_start;    # Col containing upper left corner of object.
    my $x1;           # Distance to left side of object.

    my $row_start;    # Row containing top left corner of object.
    my $y1;           # Distance to top of object.

    my $col_end;      # Col containing lower right corner of object.
    my $x2;           # Distance to right side of object.

    my $row_end;      # Row containing bottom right corner of object.
    my $y2;           # Distance to bottom of object.

    my $width;        # Width of object frame.
    my $height;       # Height of object frame.

    my $x_abs = 0;    # Absolute distance to left side of object.
    my $y_abs = 0;    # Absolute distance to top  side of object.

    ( $col_start, $row_start, $x1, $y1, $width, $height ) = @_;

    # Adjust start column for negative offsets.
    while ( $x1 < 0 && $col_start > 0) {
        $x1 += $self->_size_col( $col_start  - 1);
        $col_start--;
    }

    # Adjust start row for negative offsets.
    while ( $y1 < 0 && $row_start > 0) {
        $y1 += $self->_size_row( $row_start - 1);
        $row_start--;
    }

    # Ensure that the image isn't shifted off the page at top left.
    $x1 = 0 if $x1 < 0;
    $y1 = 0 if $y1 < 0;

    # Calculate the absolute x offset of the top-left vertex.
    if ( $self->{_col_size_changed} ) {
        for my $col_id ( 0 .. $col_start -1 ) {
            $x_abs += $self->_size_col( $col_id );
        }
    }
    else {
        # Optimisation for when the column widths haven't changed.
        $x_abs += $self->{_default_col_pixels} * $col_start;
    }

    $x_abs += $x1;

    # Calculate the absolute y offset of the top-left vertex.
    # Store the column change to allow optimisations.
    if ( $self->{_row_size_changed} ) {
        for my $row_id ( 0 .. $row_start -1 ) {
            $y_abs += $self->_size_row( $row_id );
        }
    }
    else {
        # Optimisation for when the row heights haven't changed.
        $y_abs += $self->{_default_row_pixels} * $row_start;
    }

    $y_abs += $y1;


    # Adjust start column for offsets that are greater than the col width.
    while ( $x1 >= $self->_size_col( $col_start ) ) {
        $x1 -= $self->_size_col( $col_start );
        $col_start++;
    }

    # Adjust start row for offsets that are greater than the row height.
    while ( $y1 >= $self->_size_row( $row_start ) ) {
        $y1 -= $self->_size_row( $row_start );
        $row_start++;
    }

    # Initialise end cell to the same as the start cell.
    $col_end = $col_start;
    $row_end = $row_start;

    $width  = $width + $x1;
    $height = $height + $y1;


    # Subtract the underlying cell widths to find the end cell of the object.
    while ( $width >= $self->_size_col( $col_end ) ) {
        $width -= $self->_size_col( $col_end );
        $col_end++;
    }


    # Subtract the underlying cell heights to find the end cell of the object.
    while ( $height >= $self->_size_row( $row_end ) ) {
        $height -= $self->_size_row( $row_end );
        $row_end++;
    }

    # The end vertices are whatever is left from the width and height.
    $x2 = $width;
    $y2 = $height;

    return (
        $col_start, $row_start, $x1, $y1,
        $col_end,   $row_end,   $x2, $y2,
        $x_abs,     $y_abs

    );
}


###############################################################################
#
#  _position_object_emus()
#
# Calculate the vertices that define the position of a graphical object within
# the worksheet in EMUs.
#
# The vertices are expressed as English Metric Units (EMUs). There are 12,700
# EMUs per point. Therefore, 12,700 * 3 /4 = 9,525 EMUs per pixel.
#
sub _position_object_emus {

    my $self       = shift;

    my (
        $col_start, $row_start, $x1, $y1,
        $col_end,   $row_end,   $x2, $y2,
        $x_abs,     $y_abs

    ) = $self->_position_object_pixels( @_ );

    # Convert the pixel values to EMUs. See above.
    $x1    = int( 0.5 + 9_525 * $x1 );
    $y1    = int( 0.5 + 9_525 * $y1 );
    $x2    = int( 0.5 + 9_525 * $x2 );
    $y2    = int( 0.5 + 9_525 * $y2 );
    $x_abs = int( 0.5 + 9_525 * $x_abs );
    $y_abs = int( 0.5 + 9_525 * $y_abs );

    return (
        $col_start, $row_start, $x1, $y1,
        $col_end,   $row_end,   $x2, $y2,
        $x_abs,     $y_abs

    );
}


###############################################################################
#
#  _position_shape_emus()
#
# Calculate the vertices that define the position of a shape object within
# the worksheet in EMUs.  Save the vertices with the object.
#
# The vertices are expressed as English Metric Units (EMUs). There are 12,700
# EMUs per point. Therefore, 12,700 * 3 /4 = 9,525 EMUs per pixel.
#
sub _position_shape_emus {

    my $self  = shift;
    my $shape = shift;

    my (
        $col_start, $row_start, $x1, $y1,    $col_end,
        $row_end,   $x2,        $y2, $x_abs, $y_abs
      )
      = $self->_position_object_pixels(
        $shape->{_column_start},
        $shape->{_row_start},
        $shape->{_x_offset},
        $shape->{_y_offset},
        $shape->{_width} * $shape->{_scale_x},
        $shape->{_height} * $shape->{_scale_y},
        $shape->{_drawing}
      );

    # Now that x2/y2 have been calculated with a potentially negative
    # width/height we use the absolute value and convert to EMUs.
    $shape->{_width_emu}  = int( abs( $shape->{_width} * 9_525 ) );
    $shape->{_height_emu} = int( abs( $shape->{_height} * 9_525 ) );

    $shape->{_column_start} = int( $col_start );
    $shape->{_row_start}    = int( $row_start );
    $shape->{_column_end}   = int( $col_end );
    $shape->{_row_end}      = int( $row_end );

    # Convert the pixel values to EMUs. See above.
    $shape->{_x1}    = int( $x1 * 9_525 );
    $shape->{_y1}    = int( $y1 * 9_525 );
    $shape->{_x2}    = int( $x2 * 9_525 );
    $shape->{_y2}    = int( $y2 * 9_525 );
    $shape->{_x_abs} = int( $x_abs * 9_525 );
    $shape->{_y_abs} = int( $y_abs * 9_525 );
}

###############################################################################
#
# _size_col($col)
#
# Convert the width of a cell from user's units to pixels. Excel rounds the
# column width to the nearest pixel. If the width hasn't been set by the user
# we use the default value. If the column is hidden it has a value of zero.
#
sub _size_col {

    my $self = shift;
    my $col  = shift;

    my $max_digit_width = 7;    # For Calabri 11.
    my $padding         = 5;
    my $pixels;

    # Look up the cell value to see if it has been changed.
    if ( exists $self->{_col_sizes}->{$col}
        and defined $self->{_col_sizes}->{$col} )
    {
        my $width = $self->{_col_sizes}->{$col};

        # Convert to pixels.
        if ( $width == 0 ) {
            $pixels = 0;
        }
        elsif ( $width < 1 ) {
            $pixels = int( $width * ( $max_digit_width + $padding ) + 0.5 );
        }
        else {
            $pixels = int( $width * $max_digit_width + 0.5 ) + $padding;
        }
    }
    else {
        $pixels = $self->{_default_col_pixels};
    }

    return $pixels;
}


###############################################################################
#
# _size_row($row)
#
# Convert the height of a cell from user's units to pixels. If the height
# hasn't been set by the user we use the default value. If the row is hidden
# it has a value of zero.
#
sub _size_row {

    my $self = shift;
    my $row  = shift;
    my $pixels;

    # Look up the cell value to see if it has been changed
    if ( exists $self->{_row_sizes}->{$row} ) {
        my $height = $self->{_row_sizes}->{$row};

        if ( $height == 0 ) {
            $pixels = 0;
        }
        else {
            $pixels = int( 4 / 3 * $height );
        }
    }
    else {
        $pixels = int( 4 / 3 * $self->{_default_row_height} );
    }

    return $pixels;
}


###############################################################################
#
# _get_shared_string_index()
#
# Add a string to the shared string table, if it isn't already there, and
# return the string index.
#
sub _get_shared_string_index {

    my $self = shift;
    my $str  = shift;

    # Add the string to the shared string table.
    if ( not exists ${ $self->{_str_table} }->{$str} ) {
        ${ $self->{_str_table} }->{$str} = ${ $self->{_str_unique} }++;
    }

    ${ $self->{_str_total} }++;
    my $index = ${ $self->{_str_table} }->{$str};

    return $index;
}


###############################################################################
#
# insert_chart( $row, $col, $chart, $x, $y, $x_scale, $y_scale )
#
# Insert a chart into a worksheet. The $chart argument should be a Chart
# object or else it is assumed to be a filename of an external binary file.
# The latter is for backwards compatibility.
#
sub insert_chart {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column.
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    my $row      = $_[0];
    my $col      = $_[1];
    my $chart    = $_[2];
    my $x_offset = $_[3] || 0;
    my $y_offset = $_[4] || 0;
    my $x_scale  = $_[5] || 1;
    my $y_scale  = $_[6] || 1;

    croak "Insufficient arguments in insert_chart()" unless @_ >= 3;

    if ( ref $chart ) {

        # Check for a Chart object.
        croak "Not a Chart object in insert_chart()"
          unless $chart->isa( 'Excel::Writer::XLSX::Chart' );

        # Check that the chart is an embedded style chart.
        croak "Not a embedded style Chart object in insert_chart()"
          unless $chart->{_embedded};

    }

    # Ensure a chart isn't inserted more than once.
    if (   $chart->{_already_inserted}
        || $chart->{_combined} && $chart->{_combined}->{_already_inserted} )
    {
        carp "Chart cannot be inserted in a worksheet more than once";
        return;
    }
    else {
        $chart->{_already_inserted} = 1;

        if ( $chart->{_combined} ) {
            $chart->{_combined}->{_already_inserted} = 1;
        }
    }

    # Use the values set with $chart->set_size(), if any.
    $x_scale  = $chart->{_x_scale}  if $chart->{_x_scale} != 1;
    $y_scale  = $chart->{_y_scale}  if $chart->{_y_scale} != 1;
    $x_offset = $chart->{_x_offset} if $chart->{_x_offset};
    $y_offset = $chart->{_y_offset} if $chart->{_y_offset};

    push @{ $self->{_charts} },
      [ $row, $col, $chart, $x_offset, $y_offset, $x_scale, $y_scale ];
}


###############################################################################
#
# _prepare_chart()
#
# Set up chart/drawings.
#
sub _prepare_chart {

    my $self         = shift;
    my $index        = shift;
    my $chart_id     = shift;
    my $drawing_id   = shift;
    my $drawing_type = 1;

    my ( $row, $col, $chart, $x_offset, $y_offset, $x_scale, $y_scale ) =
      @{ $self->{_charts}->[$index] };

    $chart->{_id} = $chart_id - 1;

    # Use user specified dimensions, if any.
    my $width  = $chart->{_width}  if $chart->{_width};
    my $height = $chart->{_height} if $chart->{_height};

    $width  = int( 0.5 + ( $width  * $x_scale ) );
    $height = int( 0.5 + ( $height * $y_scale ) );

    my @dimensions =
      $self->_position_object_emus( $col, $row, $x_offset, $y_offset, $width,
        $height);

    # Set the chart name for the embedded object if it has been specified.
    my $name = $chart->{_chart_name};

    # Create a Drawing object to use with worksheet unless one already exists.
    if ( !$self->{_drawing} ) {

        my $drawing = Excel::Writer::XLSX::Drawing->new();
        $drawing->_add_drawing_object( $drawing_type, @dimensions, 0, 0,
            $name );
        $drawing->{_embedded} = 1;

        $self->{_drawing} = $drawing;

        push @{ $self->{_external_drawing_links} },
          [ '/drawing', '../drawings/drawing' . $drawing_id . '.xml' ];
    }
    else {
        my $drawing = $self->{_drawing};
        $drawing->_add_drawing_object( $drawing_type, @dimensions, 0, 0,
            $name );

    }

    push @{ $self->{_drawing_links} },
      [ '/chart', '../charts/chart' . $chart_id . '.xml' ];
}


###############################################################################
#
# _get_range_data
#
# Returns a range of data from the worksheet _table to be used in chart
# cached data. Strings are returned as SST ids and decoded in the workbook.
# Return undefs for data that doesn't exist since Excel can chart series
# with data missing.
#
sub _get_range_data {

    my $self = shift;

    return () if $self->{_optimization};

    my @data;
    my ( $row_start, $col_start, $row_end, $col_end ) = @_;

    # TODO. Check for worksheet limits.

    # Iterate through the table data.
    for my $row_num ( $row_start .. $row_end ) {

        # Store undef if row doesn't exist.
        if ( !exists $self->{_table}->{$row_num} ) {
            push @data, undef;
            next;
        }

        for my $col_num ( $col_start .. $col_end ) {

            if ( my $cell = $self->{_table}->{$row_num}->{$col_num} ) {

                my $type  = $cell->[0];
                my $token = $cell->[1];


                if ( $type eq 'n' ) {

                    # Store a number.
                    push @data, $token;
                }
                elsif ( $type eq 's' ) {

                    # Store a string.
                    if ( $self->{_optimization} == 0 ) {
                        push @data, { 'sst_id' => $token };
                    }
                    else {
                        push @data, $token;
                    }
                }
                elsif ( $type eq 'f' ) {

                    # Store a formula.
                    push @data, $cell->[3] || 0;
                }
                elsif ( $type eq 'a' ) {

                    # Store an array formula.
                    push @data, $cell->[4] || 0;
                }
                elsif ( $type eq 'b' ) {

                    # Store a empty cell.
                    push @data, '';
                }
            }
            else {

                # Store undef if col doesn't exist.
                push @data, undef;
            }
        }
    }

    return @data;
}


###############################################################################
#
# insert_image( $row, $col, $filename, $x, $y, $x_scale, $y_scale )
#
# Insert an image into the worksheet.
#
sub insert_image {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column.
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    my $row      = $_[0];
    my $col      = $_[1];
    my $image    = $_[2];
    my $x_offset = $_[3] || 0;
    my $y_offset = $_[4] || 0;
    my $x_scale  = $_[5] || 1;
    my $y_scale  = $_[6] || 1;

    croak "Insufficient arguments in insert_image()" unless @_ >= 3;
    croak "Couldn't locate $image: $!" unless -e $image;

    push @{ $self->{_images} },
      [ $row, $col, $image, $x_offset, $y_offset, $x_scale, $y_scale ];
}


###############################################################################
#
# _prepare_image()
#
# Set up image/drawings.
#
sub _prepare_image {

    my $self         = shift;
    my $index        = shift;
    my $image_id     = shift;
    my $drawing_id   = shift;
    my $width        = shift;
    my $height       = shift;
    my $name         = shift;
    my $image_type   = shift;
    my $x_dpi        = shift;
    my $y_dpi        = shift;
    my $drawing_type = 2;
    my $drawing;

    my ( $row, $col, $image, $x_offset, $y_offset, $x_scale, $y_scale ) =
      @{ $self->{_images}->[$index] };

    $width  *= $x_scale;
    $height *= $y_scale;

    $width  *= 96 / $x_dpi;
    $height *= 96 / $y_dpi;

    my @dimensions =
      $self->_position_object_emus( $col, $row, $x_offset, $y_offset, $width,
        $height);

    # Convert from pixels to emus.
    $width  = int( 0.5 + ( $width * 9_525 ) );
    $height = int( 0.5 + ( $height * 9_525 ) );

    # Create a Drawing object to use with worksheet unless one already exists.
    if ( !$self->{_drawing} ) {

        $drawing = Excel::Writer::XLSX::Drawing->new();
        $drawing->{_embedded} = 1;

        $self->{_drawing} = $drawing;

        push @{ $self->{_external_drawing_links} },
          [ '/drawing', '../drawings/drawing' . $drawing_id . '.xml' ];
    }
    else {
        $drawing = $self->{_drawing};
    }

    $drawing->_add_drawing_object( $drawing_type, @dimensions, $width, $height,
        $name );


    push @{ $self->{_drawing_links} },
      [ '/image', '../media/image' . $image_id . '.' . $image_type ];
}


###############################################################################
#
# _prepare_header_image()
#
# Set up an image without a drawing object for header/footer images.
#
sub _prepare_header_image {

    my $self       = shift;
    my $image_id   = shift;
    my $width      = shift;
    my $height     = shift;
    my $name       = shift;
    my $image_type = shift;
    my $position   = shift;
    my $x_dpi      = shift;
    my $y_dpi      = shift;

    # Strip the extension from the filename.
    $name =~ s/\.[^\.]+$//;

    push @{ $self->{_header_images_array} },
      [ $width, $height, $name, $position, $x_dpi, $y_dpi ];

    push @{ $self->{_vml_drawing_links} },
      [ '/image', '../media/image' . $image_id . '.' . $image_type ];
}


###############################################################################
#
# insert_shape( $row, $col, $shape, $x, $y, $x_scale, $y_scale )
#
# Insert a shape into the worksheet.
#
sub insert_shape {

    my $self = shift;

    # Check for a cell reference in A1 notation and substitute row and column.
    if ( $_[0] =~ /^\D/ ) {
        @_ = $self->_substitute_cellref( @_ );
    }

    # Check the number of arguments.
    croak "Insufficient arguments in insert_shape()" unless @_ >= 3;

    my $shape = $_[2];

    # Verify we are being asked to insert a "shape" object.
    croak "Not a Shape object in insert_shape()"
      unless $shape->isa( 'Excel::Writer::XLSX::Shape' );

    # Set the shape properties.
    $shape->{_row_start}    = $_[0];
    $shape->{_column_start} = $_[1];
    $shape->{_x_offset}     = $_[3] || 0;
    $shape->{_y_offset}     = $_[4] || 0;

    # Override shape scale if supplied as an argument.  Otherwise, use the
    # existing shape scale factors.
    $shape->{_scale_x} = $_[5] if defined $_[5];
    $shape->{_scale_y} = $_[6] if defined $_[6];

    # Assign a shape ID.
    my $needs_id = 1;
    while ( $needs_id ) {
        my $id = $shape->{_id} || 0;
        my $used = exists $self->{_shape_hash}->{$id} ? 1 : 0;

        # Test if shape ID is already used. Otherwise assign a new one.
        if ( !$used && $id != 0 ) {
            $needs_id = 0;
        }
        else {
            $shape->{_id} = ++$self->{_last_shape_id};
        }
    }

    $shape->{_element} = $#{ $self->{_shapes} } + 1;

    # Allow lookup of entry into shape array by shape ID.
    $self->{_shape_hash}->{ $shape->{_id} } = $shape->{_element};

    # Create link to Worksheet color palette.
    $shape->{_palette} = $self->{_palette};

    if ( $shape->{_stencil} ) {

        # Insert a copy of the shape, not a reference so that the shape is
        # used as a stencil. Previously stamped copies don't get modified
        # if the stencil is modified.
        my $insert = { %{$shape} };

       # For connectors change x/y coords based on location of connected shapes.
        $self->_auto_locate_connectors( $insert );

        # Bless the copy into this class, so AUTOLOADED _get, _set methods
        #still work on the child.
        bless $insert, ref $shape;

        push @{ $self->{_shapes} }, $insert;
        return $insert;
    }
    else {

       # For connectors change x/y coords based on location of connected shapes.
        $self->_auto_locate_connectors( $shape );

        # Insert a link to the shape on the list of shapes. Connection to
        # the parent shape is maintained
        push @{ $self->{_shapes} }, $shape;
        return $shape;
    }
}


###############################################################################
#
# _prepare_shape()
#
# Set up drawing shapes
#
sub _prepare_shape {

    my $self       = shift;
    my $index      = shift;
    my $drawing_id = shift;
    my $shape      = $self->{_shapes}->[$index];
    my $drawing;
    my $drawing_type = 3;

    # Create a Drawing object to use with worksheet unless one already exists.
    if ( !$self->{_drawing} ) {

        $drawing              = Excel::Writer::XLSX::Drawing->new();
        $drawing->{_embedded} = 1;
        $self->{_drawing}     = $drawing;

        push @{ $self->{_external_drawing_links} },
          [ '/drawing', '../drawings/drawing' . $drawing_id . '.xml' ];

        $self->{_has_shapes} = 1;
    }
    else {
        $drawing = $self->{_drawing};
    }

    # Validate the he shape against various rules.
    $self->_validate_shape( $shape, $index );

    $self->_position_shape_emus( $shape );

    my @dimensions = (
        $shape->{_column_start}, $shape->{_row_start},
        $shape->{_x1},           $shape->{_y1},
        $shape->{_column_end},   $shape->{_row_end},
        $shape->{_x2},           $shape->{_y2},
        $shape->{_x_abs},        $shape->{_y_abs},
        $shape->{_width_emu},    $shape->{_height_emu},
    );

    $drawing->_add_drawing_object( $drawing_type, @dimensions, $shape->{_name},
        $shape );
}


###############################################################################
#
# _auto_locate_connectors()
#
# Re-size connector shapes if they are connected to other shapes.
#
sub _auto_locate_connectors {

    my $self  = shift;
    my $shape = shift;

    # Valid connector shapes.
    my $connector_shapes = {
        straightConnector => 1,
        Connector         => 1,
        bentConnector     => 1,
        curvedConnector   => 1,
        line              => 1,
    };

    my $shape_base = $shape->{_type};

    # Remove the number of segments from end of type.
    chop $shape_base;

    $shape->{_connect} = $connector_shapes->{$shape_base} ? 1 : 0;

    return unless $shape->{_connect};

    # Both ends have to be connected to size it.
    return unless ( $shape->{_start} and $shape->{_end} );

    # Both ends need to provide info about where to connect.
    return unless ( $shape->{_start_side} and $shape->{_end_side} );

    my $sid = $shape->{_start};
    my $eid = $shape->{_end};

    my $slink_id = $self->{_shape_hash}->{$sid};
    my ( $sls, $els );
    if ( defined $slink_id ) {
        $sls = $self->{_shapes}->[$slink_id];    # Start linked shape.
    }
    else {
        warn "missing start connection for '$shape->{_name}', id=$sid\n";
        return;
    }

    my $elink_id = $self->{_shape_hash}->{$eid};
    if ( defined $elink_id ) {
        $els = $self->{_shapes}->[$elink_id];    # Start linked shape.
    }
    else {
        warn "missing end connection for '$shape->{_name}', id=$eid\n";
        return;
    }

    # Assume shape connections are to the middle of an object, and
    # not a corner (for now).
    my $connect_type = $shape->{_start_side} . $shape->{_end_side};
    my $smidx        = $sls->{_x_offset} + $sls->{_width} / 2;
    my $emidx        = $els->{_x_offset} + $els->{_width} / 2;
    my $smidy        = $sls->{_y_offset} + $sls->{_height} / 2;
    my $emidy        = $els->{_y_offset} + $els->{_height} / 2;
    my $netx         = abs( $smidx - $emidx );
    my $nety         = abs( $smidy - $emidy );

    if ( $connect_type eq 'bt' ) {
        my $sy = $sls->{_y_offset} + $sls->{_height};
        my $ey = $els->{_y_offset};

        $shape->{_width} = abs( int( $emidx - $smidx ) );
        $shape->{_x_offset} = int( min( $smidx, $emidx ) );
        $shape->{_height} =
          abs(
            int( $els->{_y_offset} - ( $sls->{_y_offset} + $sls->{_height} ) )
          );
        $shape->{_y_offset} = int(
            min( ( $sls->{_y_offset} + $sls->{_height} ), $els->{_y_offset} ) );
        $shape->{_flip_h} = ( $smidx < $emidx ) ? 1 : 0;
        $shape->{_rotation} = 90;

        if ( $sy > $ey ) {
            $shape->{_flip_v} = 1;

            # Create 3 adjustments for an end shape vertically above a
            # start shape. Adjustments count from the upper left object.
            if ( $#{ $shape->{_adjustments} } < 0 ) {
                $shape->{_adjustments} = [ -10, 50, 110 ];
            }

            $shape->{_type} = 'bentConnector5';
        }
    }
    elsif ( $connect_type eq 'rl' ) {
        $shape->{_width} =
          abs(
            int( $els->{_x_offset} - ( $sls->{_x_offset} + $sls->{_width} ) ) );
        $shape->{_height} = abs( int( $emidy - $smidy ) );
        $shape->{_x_offset} =
          min( $sls->{_x_offset} + $sls->{_width}, $els->{_x_offset} );
        $shape->{_y_offset} = min( $smidy, $emidy );

        $shape->{_flip_h} = 1 if ( $smidx < $emidx ) and ( $smidy > $emidy );
        $shape->{_flip_h} = 1 if ( $smidx > $emidx ) and ( $smidy < $emidy );
        if ( $smidx > $emidx ) {

            # Create 3 adjustments if end shape is left of start
            if ( $#{ $shape->{_adjustments} } < 0 ) {
                $shape->{_adjustments} = [ -10, 50, 110 ];
            }

            $shape->{_type} = 'bentConnector5';
        }
    }
    else {
        warn "Connection $connect_type not implemented yet\n";
    }
}


###############################################################################
#
# _validate_shape()
#
# Check shape attributes to ensure they are valid.
#
sub _validate_shape {

    my $self  = shift;
    my $shape = shift;
    my $index = shift;

    if ( !grep ( /^$shape->{_align}$/, qw[l ctr r just] ) ) {
        croak "Shape $index ($shape->{_type}) alignment ($shape->{align}), "
          . "not in ('l', 'ctr', 'r', 'just')\n";
    }

    if ( !grep ( /^$shape->{_valign}$/, qw[t ctr b] ) ) {
        croak "Shape $index ($shape->{_type}) vertical alignment "
          . "($shape->{valign}), not ('t', 'ctr', 'b')\n";
    }
}


###############################################################################
#
# _prepare_vml_objects()
#
# Turn the HoH that stores the comments into an array for easier handling
# and set the external links for comments and buttons.
#
sub _prepare_vml_objects {

    my $self           = shift;
    my $vml_data_id    = shift;
    my $vml_shape_id   = shift;
    my $vml_drawing_id = shift;
    my $comment_id     = shift;
    my @comments;


    # We sort the comments by row and column but that isn't strictly required.
    my @rows = sort { $a <=> $b } keys %{ $self->{_comments} };

    for my $row ( @rows ) {
        my @cols = sort { $a <=> $b } keys %{ $self->{_comments}->{$row} };

        for my $col ( @cols ) {

            # Set comment visibility if required and not already user defined.
            if ( $self->{_comments_visible} ) {
                if ( !defined $self->{_comments}->{$row}->{$col}->[4] ) {
                    $self->{_comments}->{$row}->{$col}->[4] = 1;
                }
            }

            # Set comment author if not already user defined.
            if ( !defined $self->{_comments}->{$row}->{$col}->[3] ) {
                $self->{_comments}->{$row}->{$col}->[3] =
                  $self->{_comments_author};
            }

            push @comments, $self->{_comments}->{$row}->{$col};
        }
    }

    push @{ $self->{_external_vml_links} },
      [ '/vmlDrawing', '../drawings/vmlDrawing' . $vml_drawing_id . '.vml' ];

    if ( $self->{_has_comments} ) {

        $self->{_comments_array} = \@comments;

        push @{ $self->{_external_comment_links} },
          [ '/comments', '../comments' . $comment_id . '.xml' ];
    }

    my $count         = scalar @comments;
    my $start_data_id = $vml_data_id;

    # The VML o:idmap data id contains a comma separated range when there is
    # more than one 1024 block of comments, like this: data="1,2".
    for my $i ( 1 .. int( $count / 1024 ) ) {
        $vml_data_id = "$vml_data_id," . ( $start_data_id + $i );
    }

    $self->{_vml_data_id}  = $vml_data_id;
    $self->{_vml_shape_id} = $vml_shape_id;

    return $count;
}


###############################################################################
#
# _prepare_header_vml_objects()
#
# Set up external linkage for VML header/footer images.
#
sub _prepare_header_vml_objects {

    my $self           = shift;
    my $vml_header_id  = shift;
    my $vml_drawing_id = shift;

    $self->{_vml_header_id} = $vml_header_id;

    push @{ $self->{_external_vml_links} },
      [ '/vmlDrawing', '../drawings/vmlDrawing' . $vml_drawing_id . '.vml' ];
}


###############################################################################
#
# _prepare_tables()
#
# Set the table ids for the worksheet tables.
#
sub _prepare_tables {

    my $self     = shift;
    my $table_id = shift;
    my $seen     = shift;


    for my $table ( @{ $self->{_tables} } ) {

        $table-> {_id} = $table_id;

        # Set the table name unless defined by the user.
        if ( !defined $table->{_name} ) {

            # Set a default name.
            $table->{_name} = 'Table' . $table_id;
        }

        # Check for duplicate table names.
        my $name = lc $table->{_name};

        if ( exists $seen->{$name} ) {
            die "error: invalid duplicate table name '$table->{_name}' found";
        }
        else {
            $seen->{$name} = 1;
        }

        # Store the link used for the rels file.
        my $link = [ '/table', '../tables/table' . $table_id . '.xml' ];

        push @{ $self->{_external_table_links} }, $link;
        $table_id++;
    }
}


###############################################################################
#
# _comment_params()
#
# This method handles the additional optional parameters to write_comment() as
# well as calculating the comment object position and vertices.
#
sub _comment_params {

    my $self = shift;

    my $row    = shift;
    my $col    = shift;
    my $string = shift;

    my $default_width  = 128;
    my $default_height = 74;

    my %params = (
        author     => undef,
        color      => 81,
        start_cell => undef,
        start_col  => undef,
        start_row  => undef,
        visible    => undef,
        width      => $default_width,
        height     => $default_height,
        x_offset   => undef,
        x_scale    => 1,
        y_offset   => undef,
        y_scale    => 1,
    );


    # Overwrite the defaults with any user supplied values. Incorrect or
    # misspelled parameters are silently ignored.
    %params = ( %params, @_ );


    # Ensure that a width and height have been set.
    $params{width}  = $default_width  if not $params{width};
    $params{height} = $default_height if not $params{height};


    # Limit the string to the max number of chars.
    my $max_len = 32767;

    if ( length( $string ) > $max_len ) {
        $string = substr( $string, 0, $max_len );
    }


    # Set the comment background colour.
    my $color    = $params{color};
    my $color_id = &Excel::Writer::XLSX::Format::_get_color( $color );

    if ( $color_id =~ m/^#[0-9A-F]{6}$/i ) {
        $params{color} = $color_id;
    }
    elsif ( $color_id == 0 ) {
        $params{color} = '#ffffe1';
    }
    else {
        my $palette = $self->{_palette};

        # Get the RGB color from the palette.
        my @rgb = @{ $palette->[ $color_id - 8 ] };
        my $rgb_color = sprintf "%02x%02x%02x", @rgb[0, 1, 2];

        # Minor modification to allow comparison testing. Change RGB colors
        # from long format, ffcc00 to short format fc0 used by VML.
        $rgb_color =~ s/^([0-9a-f])\1([0-9a-f])\2([0-9a-f])\3$/$1$2$3/;

        $params{color} = sprintf "#%s [%d]", $rgb_color, $color_id;
    }


    # Convert a cell reference to a row and column.
    if ( defined $params{start_cell} ) {
        my ( $row, $col ) = $self->_substitute_cellref( $params{start_cell} );
        $params{start_row} = $row;
        $params{start_col} = $col;
    }


    # Set the default start cell and offsets for the comment. These are
    # generally fixed in relation to the parent cell. However there are
    # some edge cases for cells at the, er, edges.
    #
    my $row_max = $self->{_xls_rowmax};
    my $col_max = $self->{_xls_colmax};

    if ( not defined $params{start_row} ) {

        if    ( $row == 0 )            { $params{start_row} = 0 }
        elsif ( $row == $row_max - 3 ) { $params{start_row} = $row_max - 7 }
        elsif ( $row == $row_max - 2 ) { $params{start_row} = $row_max - 6 }
        elsif ( $row == $row_max - 1 ) { $params{start_row} = $row_max - 5 }
        else                           { $params{start_row} = $row - 1 }
    }

    if ( not defined $params{y_offset} ) {

        if    ( $row == 0 )            { $params{y_offset} = 2 }
        elsif ( $row == $row_max - 3 ) { $params{y_offset} = 16 }
        elsif ( $row == $row_max - 2 ) { $params{y_offset} = 16 }
        elsif ( $row == $row_max - 1 ) { $params{y_offset} = 14 }
        else                           { $params{y_offset} = 10 }
    }

    if ( not defined $params{start_col} ) {

        if    ( $col == $col_max - 3 ) { $params{start_col} = $col_max - 6 }
        elsif ( $col == $col_max - 2 ) { $params{start_col} = $col_max - 5 }
        elsif ( $col == $col_max - 1 ) { $params{start_col} = $col_max - 4 }
        else                           { $params{start_col} = $col + 1 }
    }

    if ( not defined $params{x_offset} ) {

        if    ( $col == $col_max - 3 ) { $params{x_offset} = 49 }
        elsif ( $col == $col_max - 2 ) { $params{x_offset} = 49 }
        elsif ( $col == $col_max - 1 ) { $params{x_offset} = 49 }
        else                           { $params{x_offset} = 15 }
    }


    # Scale the size of the comment box if required.
    if ( $params{x_scale} ) {
        $params{width} = $params{width} * $params{x_scale};
    }

    if ( $params{y_scale} ) {
        $params{height} = $params{height} * $params{y_scale};
    }

    # Round the dimensions to the nearest pixel.
    $params{width}  = int( 0.5 + $params{width} );
    $params{height} = int( 0.5 + $params{height} );

    # Calculate the positions of comment object.
    my @vertices = $self->_position_object_pixels(
        $params{start_col}, $params{start_row}, $params{x_offset},
        $params{y_offset},  $params{width},     $params{height}
    );

    # Add the width and height for VML.
    push @vertices, ( $params{width}, $params{height} );

    return (
        $row,
        $col,
        $string,

        $params{author},
        $params{visible},
        $params{color},

        [@vertices]
    );
}


###############################################################################
#
# _button_params()
#
# This method handles the parameters passed to insert_button() as well as
# calculating the comment object position and vertices.
#
sub _button_params {

    my $self   = shift;
    my $row    = shift;
    my $col    = shift;
    my $params = shift;
    my $button = { _row => $row, _col => $col };

    my $button_number = 1 + @{ $self->{_buttons_array} };

    # Set the button caption.
    my $caption = $params->{caption};

    # Set a default caption if none was specified by user.
    if ( !defined $caption ) {
        $caption = 'Button ' . $button_number;
    }

    $button->{_font}->{_caption} = $caption;


    # Set the macro name.
    if ( $params->{macro} ) {
        $button->{_macro} = '[0]!' . $params->{macro};
    }
    else {
        $button->{_macro} = '[0]!Button' . $button_number . '_Click';
    }


    # Ensure that a width and height have been set.
    my $default_width  = $self->{_default_col_pixels};
    my $default_height = $self->{_default_row_pixels};
    $params->{width}  = $default_width  if !$params->{width};
    $params->{height} = $default_height if !$params->{height};

    # Set the x/y offsets.
    $params->{x_offset}  = 0  if !$params->{x_offset};
    $params->{y_offset}  = 0  if !$params->{y_offset};

    # Scale the size of the comment box if required.
    if ( $params->{x_scale} ) {
        $params->{width} = $params->{width} * $params->{x_scale};
    }

    if ( $params->{y_scale} ) {
        $params->{height} = $params->{height} * $params->{y_scale};
    }

    # Round the dimensions to the nearest pixel.
    $params->{width}  = int( 0.5 + $params->{width} );
    $params->{height} = int( 0.5 + $params->{height} );

    $params->{start_row} = $row;
    $params->{start_col} = $col;

    # Calculate the positions of comment object.
    my @vertices = $self->_position_object_pixels(
        $params->{start_col}, $params->{start_row}, $params->{x_offset},
        $params->{y_offset},  $params->{width},     $params->{height}
    );

    # Add the width and height for VML.
    push @vertices, ( $params->{width}, $params->{height} );

    $button->{_vertices} = \@vertices;

    return $button;
}


###############################################################################
#
# Deprecated methods for backwards compatibility.
#
###############################################################################


# This method was mainly only required for Excel 5.
sub write_url_range { }

# Deprecated UTF-16 method required for the Excel 5 format.
sub write_utf16be_string {

    my $self = shift;

    # Convert A1 notation if present.
    @_ = $self->_substitute_cellref( @_ ) if $_[0] =~ /^\D/;

    # Check the number of args.
    return -1 if @_ < 3;

    # Convert UTF16 string to UTF8.
    require Encode;
    my $utf8_string = Encode::decode( 'UTF-16BE', $_[2] );

    return $self->write_string( $_[0], $_[1], $utf8_string, $_[3] );
}

# Deprecated UTF-16 method required for the Excel 5 format.
sub write_utf16le_string {

    my $self = shift;

    # Convert A1 notation if present.
    @_ = $self->_substitute_cellref( @_ ) if $_[0] =~ /^\D/;

    # Check the number of args.
    return -1 if @_ < 3;

    # Convert UTF16 string to UTF8.
    require Encode;
    my $utf8_string = Encode::decode( 'UTF-16LE', $_[2] );

    return $self->write_string( $_[0], $_[1], $utf8_string, $_[3] );
}

# No longer required. Was used to avoid slow formula parsing.
sub store_formula {

    my $self   = shift;
    my $string = shift;

    my @tokens = split /(\$?[A-I]?[A-Z]\$?\d+)/, $string;

    return \@tokens;
}

# No longer required. Was used to avoid slow formula parsing.
sub repeat_formula {

    my $self = shift;

    # Convert A1 notation if present.
    @_ = $self->_substitute_cellref( @_ ) if $_[0] =~ /^\D/;

    if ( @_ < 2 ) { return -1 }    # Check the number of args

    my $row         = shift;       # Zero indexed row
    my $col         = shift;       # Zero indexed column
    my $formula_ref = shift;       # Array ref with formula tokens
    my $format      = shift;       # XF format
    my @pairs       = @_;          # Pattern/replacement pairs


    # Enforce an even number of arguments in the pattern/replacement list.
    croak "Odd number of elements in pattern/replacement list" if @pairs % 2;

    # Check that $formula is an array ref.
    croak "Not a valid formula" if ref $formula_ref ne 'ARRAY';

    my @tokens = @$formula_ref;

    # Allow the user to specify the result of the formula by appending a
    # result => $value pair to the end of the arguments.
    my $value = undef;
    if ( @pairs && $pairs[-2] eq 'result' ) {
        $value = pop @pairs;
        pop @pairs;
    }

    # Make the substitutions.
    while ( @pairs ) {
        my $pattern = shift @pairs;
        my $replace = shift @pairs;

        foreach my $token ( @tokens ) {
            last if $token =~ s/$pattern/$replace/;
        }
    }

    my $formula = join '', @tokens;

    return $self->write_formula( $row, $col, $formula, $format, $value );
}


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_worksheet()
#
# Write the <worksheet> element. This is the root element of Worksheet.
#
sub _write_worksheet {

    my $self                   = shift;
    my $schema                 = 'http://schemas.openxmlformats.org/';
    my $xmlns                  = $schema . 'spreadsheetml/2006/main';
    my $xmlns_r                = $schema . 'officeDocument/2006/relationships';
    my $xmlns_mc               = $schema . 'markup-compatibility/2006';

    my @attributes = (
        'xmlns'   => $xmlns,
        'xmlns:r' => $xmlns_r,
    );

    if ( $self->{_excel_version} == 2010 ) {
        push @attributes, ( 'xmlns:mc' => $xmlns_mc );

        push @attributes,
          (     'xmlns:x14ac' => 'http://schemas.microsoft.com/'
              . 'office/spreadsheetml/2009/9/ac' );

        push @attributes, ( 'mc:Ignorable' => 'x14ac' );

    }

    $self->xml_start_tag( 'worksheet', @attributes );
}


###############################################################################
#
# _write_sheet_pr()
#
# Write the <sheetPr> element for Sheet level properties.
#
sub _write_sheet_pr {

    my $self       = shift;
    my @attributes = ();

    if (   !$self->{_fit_page}
        && !$self->{_filter_on}
        && !$self->{_tab_color}
        && !$self->{_outline_changed}
        && !$self->{_vba_codename} )
    {
        return;
    }


    my $codename = $self->{_vba_codename};
    push @attributes, ( 'codeName'   => $codename ) if $codename;
    push @attributes, ( 'filterMode' => 1 )         if $self->{_filter_on};

    if (   $self->{_fit_page}
        || $self->{_tab_color}
        || $self->{_outline_changed} )
    {
        $self->xml_start_tag( 'sheetPr', @attributes );
        $self->_write_tab_color();
        $self->_write_outline_pr();
        $self->_write_page_set_up_pr();
        $self->xml_end_tag( 'sheetPr' );
    }
    else {
        $self->xml_empty_tag( 'sheetPr', @attributes );
    }
}


##############################################################################
#
# _write_page_set_up_pr()
#
# Write the <pageSetUpPr> element.
#
sub _write_page_set_up_pr {

    my $self = shift;

    return unless $self->{_fit_page};

    my @attributes = ( 'fitToPage' => 1 );

    $self->xml_empty_tag( 'pageSetUpPr', @attributes );
}


###############################################################################
#
# _write_dimension()
#
# Write the <dimension> element. This specifies the range of cells in the
# worksheet. As a special case, empty spreadsheets use 'A1' as a range.
#
sub _write_dimension {

    my $self = shift;
    my $ref;

    if ( !defined $self->{_dim_rowmin} && !defined $self->{_dim_colmin} ) {

        # If the min dims are undefined then no dimensions have been set
        # and we use the default 'A1'.
        $ref = 'A1';
    }
    elsif ( !defined $self->{_dim_rowmin} && defined $self->{_dim_colmin} ) {

        # If the row dims aren't set but the column dims are then they
        # have been changed via set_column().

        if ( $self->{_dim_colmin} == $self->{_dim_colmax} ) {

            # The dimensions are a single cell and not a range.
            $ref = xl_rowcol_to_cell( 0, $self->{_dim_colmin} );
        }
        else {

            # The dimensions are a cell range.
            my $cell_1 = xl_rowcol_to_cell( 0, $self->{_dim_colmin} );
            my $cell_2 = xl_rowcol_to_cell( 0, $self->{_dim_colmax} );

            $ref = $cell_1 . ':' . $cell_2;
        }

    }
    elsif ($self->{_dim_rowmin} == $self->{_dim_rowmax}
        && $self->{_dim_colmin} == $self->{_dim_colmax} )
    {

        # The dimensions are a single cell and not a range.
        $ref = xl_rowcol_to_cell( $self->{_dim_rowmin}, $self->{_dim_colmin} );
    }
    else {

        # The dimensions are a cell range.
        my $cell_1 =
          xl_rowcol_to_cell( $self->{_dim_rowmin}, $self->{_dim_colmin} );
        my $cell_2 =
          xl_rowcol_to_cell( $self->{_dim_rowmax}, $self->{_dim_colmax} );

        $ref = $cell_1 . ':' . $cell_2;
    }


    my @attributes = ( 'ref' => $ref );

    $self->xml_empty_tag( 'dimension', @attributes );
}


###############################################################################
#
# _write_sheet_views()
#
# Write the <sheetViews> element.
#
sub _write_sheet_views {

    my $self = shift;

    my @attributes = ();

    $self->xml_start_tag( 'sheetViews', @attributes );
    $self->_write_sheet_view();
    $self->xml_end_tag( 'sheetViews' );
}


###############################################################################
#
# _write_sheet_view()
#
# Write the <sheetView> element.
#
# Sample structure:
#     <sheetView
#         showGridLines="0"
#         showRowColHeaders="0"
#         showZeros="0"
#         rightToLeft="1"
#         tabSelected="1"
#         showRuler="0"
#         showOutlineSymbols="0"
#         view="pageLayout"
#         zoomScale="121"
#         zoomScaleNormal="121"
#         workbookViewId="0"
#      />
#
sub _write_sheet_view {

    my $self             = shift;
    my $gridlines        = $self->{_screen_gridlines};
    my $show_zeros       = $self->{_show_zeros};
    my $right_to_left    = $self->{_right_to_left};
    my $tab_selected     = $self->{_selected};
    my $view             = $self->{_page_view};
    my $zoom             = $self->{_zoom};
    my $workbook_view_id = 0;
    my @attributes       = ();

    # Hide screen gridlines if required
    if ( !$gridlines ) {
        push @attributes, ( 'showGridLines' => 0 );
    }

    # Hide zeroes in cells.
    if ( !$show_zeros ) {
        push @attributes, ( 'showZeros' => 0 );
    }

    # Display worksheet right to left for Hebrew, Arabic and others.
    if ( $right_to_left ) {
        push @attributes, ( 'rightToLeft' => 1 );
    }

    # Show that the sheet tab is selected.
    if ( $tab_selected ) {
        push @attributes, ( 'tabSelected' => 1 );
    }


    # Turn outlines off. Also required in the outlinePr element.
    if ( !$self->{_outline_on} ) {
        push @attributes, ( "showOutlineSymbols" => 0 );
    }

    # Set the page view/layout mode if required.
    # TODO. Add pageBreakPreview mode when requested.
    if ( $view ) {
        push @attributes, ( 'view' => 'pageLayout' );
    }

    # Set the zoom level.
    if ( $zoom != 100 ) {
        push @attributes, ( 'zoomScale' => $zoom ) unless $view;
        push @attributes, ( 'zoomScaleNormal' => $zoom )
          if $self->{_zoom_scale_normal};
    }

    push @attributes, ( 'workbookViewId' => $workbook_view_id );

    if ( @{ $self->{_panes} } || @{ $self->{_selections} } ) {
        $self->xml_start_tag( 'sheetView', @attributes );
        $self->_write_panes();
        $self->_write_selections();
        $self->xml_end_tag( 'sheetView' );
    }
    else {
        $self->xml_empty_tag( 'sheetView', @attributes );
    }
}


###############################################################################
#
# _write_selections()
#
# Write the <selection> elements.
#
sub _write_selections {

    my $self = shift;

    for my $selection ( @{ $self->{_selections} } ) {
        $self->_write_selection( @$selection );
    }
}


###############################################################################
#
# _write_selection()
#
# Write the <selection> element.
#
sub _write_selection {

    my $self        = shift;
    my $pane        = shift;
    my $active_cell = shift;
    my $sqref       = shift;
    my @attributes  = ();

    push @attributes, ( 'pane'       => $pane )        if $pane;
    push @attributes, ( 'activeCell' => $active_cell ) if $active_cell;
    push @attributes, ( 'sqref'      => $sqref )       if $sqref;

    $self->xml_empty_tag( 'selection', @attributes );
}


###############################################################################
#
# _write_sheet_format_pr()
#
# Write the <sheetFormatPr> element.
#
sub _write_sheet_format_pr {

    my $self               = shift;
    my $base_col_width     = 10;
    my $default_row_height = $self->{_default_row_height};
    my $row_level          = $self->{_outline_row_level};
    my $col_level          = $self->{_outline_col_level};
    my $zero_height        = $self->{_default_row_zeroed};

    my @attributes = ( 'defaultRowHeight' => $default_row_height );

    if ( $self->{_default_row_height} != $self->{_original_row_height} ) {
        push @attributes, ( 'customHeight' => 1 );
    }

    if ( $self->{_default_row_zeroed} ) {
        push @attributes, ( 'zeroHeight' => 1 );
    }

    push @attributes, ( 'outlineLevelRow' => $row_level ) if $row_level;
    push @attributes, ( 'outlineLevelCol' => $col_level ) if $col_level;

    if ( $self->{_excel_version} == 2010 ) {
        push @attributes, ( 'x14ac:dyDescent' => '0.25' );
    }

    $self->xml_empty_tag( 'sheetFormatPr', @attributes );
}


##############################################################################
#
# _write_cols()
#
# Write the <cols> element and <col> sub elements.
#
sub _write_cols {

    my $self = shift;

    # Exit unless some column have been formatted.
    return unless %{ $self->{_colinfo} };

    $self->xml_start_tag( 'cols' );

    for my $col ( sort keys %{ $self->{_colinfo} } ) {
        $self->_write_col_info( @{ $self->{_colinfo}->{$col} } );
    }

    $self->xml_end_tag( 'cols' );
}


##############################################################################
#
# _write_col_info()
#
# Write the <col> element.
#
sub _write_col_info {

    my $self         = shift;
    my $min          = $_[0] || 0;    # First formatted column.
    my $max          = $_[1] || 0;    # Last formatted column.
    my $width        = $_[2];         # Col width in user units.
    my $format       = $_[3];         # Format index.
    my $hidden       = $_[4] || 0;    # Hidden flag.
    my $level        = $_[5] || 0;    # Outline level.
    my $collapsed    = $_[6] || 0;    # Outline level.
    my $custom_width = 1;
    my $xf_index     = 0;

    # Get the format index.
    if ( ref( $format ) ) {
        $xf_index = $format->get_xf_index();
    }

    # Set the Excel default col width.
    if ( !defined $width ) {
        if ( !$hidden ) {
            $width        = 8.43;
            $custom_width = 0;
        }
        else {
            $width = 0;
        }
    }
    else {

        # Width is defined but same as default.
        if ( $width == 8.43 ) {
            $custom_width = 0;
        }
    }


    # Convert column width from user units to character width.
    my $max_digit_width = 7;    # For Calabri 11.
    my $padding         = 5;

    if ( $width > 0 ) {
        if ( $width < 1 ) {
            $width =
              int( ( int( $width * ($max_digit_width + $padding) + 0.5 ) ) /
                  $max_digit_width *
                  256 ) / 256;
        }
        else {
            $width =
              int( ( int( $width * $max_digit_width + 0.5 ) + $padding ) /
                  $max_digit_width *
                  256 ) / 256;
        }
    }

    my @attributes = (
        'min'   => $min + 1,
        'max'   => $max + 1,
        'width' => $width,
    );

    push @attributes, ( 'style'        => $xf_index ) if $xf_index;
    push @attributes, ( 'hidden'       => 1 )         if $hidden;
    push @attributes, ( 'customWidth'  => 1 )         if $custom_width;
    push @attributes, ( 'outlineLevel' => $level )    if $level;
    push @attributes, ( 'collapsed'    => 1 )         if $collapsed;


    $self->xml_empty_tag( 'col', @attributes );
}


###############################################################################
#
# _write_sheet_data()
#
# Write the <sheetData> element.
#
sub _write_sheet_data {

    my $self = shift;

    if ( not defined $self->{_dim_rowmin} ) {

        # If the dimensions aren't defined then there is no data to write.
        $self->xml_empty_tag( 'sheetData' );
    }
    else {
        $self->xml_start_tag( 'sheetData' );
        $self->_write_rows();
        $self->xml_end_tag( 'sheetData' );

    }

}


###############################################################################
#
# _write_optimized_sheet_data()
#
# Write the <sheetData> element when the memory optimisation is on. In which
# case we read the data stored in the temp file and rewrite it to the XML
# sheet file.
#
sub _write_optimized_sheet_data {

    my $self = shift;

    if ( not defined $self->{_dim_rowmin} ) {

        # If the dimensions aren't defined then there is no data to write.
        $self->xml_empty_tag( 'sheetData' );
    }
    else {

        $self->xml_start_tag( 'sheetData' );

        my $xlsx_fh = $self->xml_get_fh();
        my $cell_fh = $self->{_cell_data_fh};

        my $buffer;

        # Rewind the temp file.
        seek $cell_fh, 0, 0;

        while ( read( $cell_fh, $buffer, 4_096 ) ) {
            local $\ = undef;    # Protect print from -l on commandline.
            print $xlsx_fh $buffer;
        }

        $self->xml_end_tag( 'sheetData' );
    }
}


###############################################################################
#
# _write_rows()
#
# Write out the worksheet data as a series of rows and cells.
#
sub _write_rows {

    my $self = shift;

    $self->_calculate_spans();

    for my $row_num ( $self->{_dim_rowmin} .. $self->{_dim_rowmax} ) {

        # Skip row if it doesn't contain row formatting, cell data or a comment.
        if (   !$self->{_set_rows}->{$row_num}
            && !$self->{_table}->{$row_num}
            && !$self->{_comments}->{$row_num} )
        {
            next;
        }

        my $span_index = int( $row_num / 16 );
        my $span       = $self->{_row_spans}->[$span_index];

        # Write the cells if the row contains data.
        if ( my $row_ref = $self->{_table}->{$row_num} ) {

            if ( !$self->{_set_rows}->{$row_num} ) {
                $self->_write_row( $row_num, $span );
            }
            else {
                $self->_write_row( $row_num, $span,
                    @{ $self->{_set_rows}->{$row_num} } );
            }


            for my $col_num ( $self->{_dim_colmin} .. $self->{_dim_colmax} ) {
                if ( my $col_ref = $self->{_table}->{$row_num}->{$col_num} ) {
                    $self->_write_cell( $row_num, $col_num, $col_ref );
                }
            }

            $self->xml_end_tag( 'row' );
        }
        elsif ( $self->{_comments}->{$row_num} ) {

            $self->_write_empty_row( $row_num, $span,
                @{ $self->{_set_rows}->{$row_num} } );
        }
        else {

            # Row attributes only.
            $self->_write_empty_row( $row_num, $span,
                @{ $self->{_set_rows}->{$row_num} } );
        }
    }
}


###############################################################################
#
# _write_single_row()
#
# Write out the worksheet data as a single row with cells. This method is
# used when memory optimisation is on. A single row is written and the data
# table is reset. That way only one row of data is kept in memory at any one
# time. We don't write span data in the optimised case since it is optional.
#
sub _write_single_row {

    my $self        = shift;
    my $current_row = shift || 0;
    my $row_num     = $self->{_previous_row};

    # Set the new previous row as the current row.
    $self->{_previous_row} = $current_row;

    # Skip row if it doesn't contain row formatting, cell data or a comment.
    if (   !$self->{_set_rows}->{$row_num}
        && !$self->{_table}->{$row_num}
        && !$self->{_comments}->{$row_num} )
    {
        return;
    }

    # Write the cells if the row contains data.
    if ( my $row_ref = $self->{_table}->{$row_num} ) {

        if ( !$self->{_set_rows}->{$row_num} ) {
            $self->_write_row( $row_num );
        }
        else {
            $self->_write_row( $row_num, undef,
                @{ $self->{_set_rows}->{$row_num} } );
        }

        for my $col_num ( $self->{_dim_colmin} .. $self->{_dim_colmax} ) {
            if ( my $col_ref = $self->{_table}->{$row_num}->{$col_num} ) {
                $self->_write_cell( $row_num, $col_num, $col_ref );
            }
        }

        $self->xml_end_tag( 'row' );
    }
    else {

        # Row attributes or comments only.
        $self->_write_empty_row( $row_num, undef,
            @{ $self->{_set_rows}->{$row_num} } );
    }

    # Reset table.
    $self->{_table} = {};

}


###############################################################################
#
# _calculate_spans()
#
# Calculate the "spans" attribute of the <row> tag. This is an XLSX
# optimisation and isn't strictly required. However, it makes comparing
# files easier.
#
# The span is the same for each block of 16 rows.
#
sub _calculate_spans {

    my $self = shift;

    my @spans;
    my $span_min;
    my $span_max;

    for my $row_num ( $self->{_dim_rowmin} .. $self->{_dim_rowmax} ) {

        # Calculate spans for cell data.
        if ( my $row_ref = $self->{_table}->{$row_num} ) {

            for my $col_num ( $self->{_dim_colmin} .. $self->{_dim_colmax} ) {
                if ( my $col_ref = $self->{_table}->{$row_num}->{$col_num} ) {

                    if ( !defined $span_min ) {
                        $span_min = $col_num;
                        $span_max = $col_num;
                    }
                    else {
                        $span_min = $col_num if $col_num < $span_min;
                        $span_max = $col_num if $col_num > $span_max;
                    }
                }
            }
        }

        # Calculate spans for comments.
        if ( defined $self->{_comments}->{$row_num} ) {

            for my $col_num ( $self->{_dim_colmin} .. $self->{_dim_colmax} ) {
                if ( defined $self->{_comments}->{$row_num}->{$col_num} ) {

                    if ( !defined $span_min ) {
                        $span_min = $col_num;
                        $span_max = $col_num;
                    }
                    else {
                        $span_min = $col_num if $col_num < $span_min;
                        $span_max = $col_num if $col_num > $span_max;
                    }
                }
            }
        }

        if ( ( ( $row_num + 1 ) % 16 == 0 )
            || $row_num == $self->{_dim_rowmax} )
        {
            my $span_index = int( $row_num / 16 );

            if ( defined $span_min ) {
                $span_min++;
                $span_max++;
                $spans[$span_index] = "$span_min:$span_max";
                $span_min = undef;
            }
        }
    }

    $self->{_row_spans} = \@spans;
}


###############################################################################
#
# _write_row()
#
# Write the <row> element.
#
sub _write_row {

    my $self      = shift;
    my $r         = shift;
    my $spans     = shift;
    my $height    = shift;
    my $format    = shift;
    my $hidden    = shift || 0;
    my $level     = shift || 0;
    my $collapsed = shift || 0;
    my $empty_row = shift || 0;
    my $xf_index  = 0;

    $height = $self->{_default_row_height} if !defined $height;

    my @attributes = ( 'r' => $r + 1 );

    # Get the format index.
    if ( ref( $format ) ) {
        $xf_index = $format->get_xf_index();
    }

    push @attributes, ( 'spans'        => $spans )    if defined $spans;
    push @attributes, ( 's'            => $xf_index ) if $xf_index;
    push @attributes, ( 'customFormat' => 1 )         if $format;

    if ( $height != $self->{_original_row_height} ) {
        push @attributes, ( 'ht' => $height );
    }

    push @attributes, ( 'hidden'       => 1 )         if $hidden;

    if ( $height != $self->{_original_row_height} ) {
        push @attributes, ( 'customHeight' => 1 );
    }

    push @attributes, ( 'outlineLevel' => $level )    if $level;
    push @attributes, ( 'collapsed'    => 1 )         if $collapsed;

    if ( $self->{_excel_version} == 2010 ) {
        push @attributes, ( 'x14ac:dyDescent' => '0.25' );
    }

    if ( $empty_row ) {
        $self->xml_empty_tag_unencoded( 'row', @attributes );
    }
    else {
        $self->xml_start_tag_unencoded( 'row', @attributes );
    }
}


###############################################################################
#
# _write_empty_row()
#
# Write and empty <row> element, i.e., attributes only, no cell data.
#
sub _write_empty_row {

    my $self = shift;

    # Set the $empty_row parameter.
    $_[7] = 1;

    $self->_write_row( @_ );
}


###############################################################################
#
# _write_cell()
#
# Write the <cell> element. This is the innermost loop so efficiency is
# important where possible. The basic methodology is that the data of every
# cell type is passed in as follows:
#
#      [ $row, $col, $aref]
#
# The aref, called $cell below, contains the following structure in all types:
#
#     [ $type, $token, $xf, @args ]
#
# Where $type:  represents the cell type, such as string, number, formula, etc.
#       $token: is the actual data for the string, number, formula, etc.
#       $xf:    is the XF format object.
#       @args:  additional args relevant to the specific data type.
#
sub _write_cell {

    my $self     = shift;
    my $row      = shift;
    my $col      = shift;
    my $cell     = shift;
    my $type     = $cell->[0];
    my $token    = $cell->[1];
    my $xf       = $cell->[2];
    my $xf_index = 0;

    my %error_codes = (
        '#DIV/0!' => 1,
        '#N/A'    => 1,
        '#NAME?'  => 1,
        '#NULL!'  => 1,
        '#NUM!'   => 1,
        '#REF!'   => 1,
        '#VALUE!' => 1,
    );

    my %boolean = ( 'TRUE' => 1, 'FALSE' => 0 );

    # Get the format index.
    if ( ref( $xf ) ) {
        $xf_index = $xf->get_xf_index();
    }

    my $range = _xl_rowcol_to_cell( $row, $col );
    my @attributes = ( 'r' => $range );

    # Add the cell format index.
    if ( $xf_index ) {
        push @attributes, ( 's' => $xf_index );
    }
    elsif ( $self->{_set_rows}->{$row} && $self->{_set_rows}->{$row}->[1] ) {
        my $row_xf = $self->{_set_rows}->{$row}->[1];
        push @attributes, ( 's' => $row_xf->get_xf_index() );
    }
    elsif ( $self->{_col_formats}->{$col} ) {
        my $col_xf = $self->{_col_formats}->{$col};
        push @attributes, ( 's' => $col_xf->get_xf_index() );
    }


    # Write the various cell types.
    if ( $type eq 'n' ) {

        # Write a number.
        $self->xml_number_element( $token, @attributes );
    }
    elsif ( $type eq 's' ) {

        # Write a string.
        if ( $self->{_optimization} == 0 ) {
            $self->xml_string_element( $token, @attributes );
        }
        else {

            my $string = $token;

            # Escape control characters. See SharedString.pm for details.
            $string =~ s/(_x[0-9a-fA-F]{4}_)/_x005F$1/g;
            $string =~ s/([\x00-\x08\x0B-\x1F])/sprintf "_x%04X_", ord($1)/eg;

            # Write any rich strings without further tags.
            if ( $string =~ m{^<r>} && $string =~ m{</r>$} ) {

                $self->xml_rich_inline_string( $string, @attributes );
            }
            else {

                # Add attribute to preserve leading or trailing whitespace.
                my $preserve = 0;
                if ( $string =~ /^\s/ || $string =~ /\s$/ ) {
                    $preserve = 1;
                }

                $self->xml_inline_string( $string, $preserve, @attributes );
            }
        }
    }
    elsif ( $type eq 'f' ) {

        # Write a formula.
        my $value = $cell->[3] || 0;

        # Check if the formula value is a string.
        if (   $value
            && $value !~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/ )
        {
            if ( exists $boolean{$value} ) {
                push @attributes, ( 't' => 'b' );
                $value = $boolean{$value};
            }
            elsif ( exists $error_codes{$value} ) {
                push @attributes, ( 't' => 'e' );
            }
            else {
                push @attributes, ( 't' => 'str' );
                $value = Excel::Writer::XLSX::Package::XMLwriter::_escape_data(
                    $value );
            }
        }

        $self->xml_formula_element( $token, $value, @attributes );

    }
    elsif ( $type eq 'a' ) {

        # Write an array formula.
        $self->xml_start_tag( 'c', @attributes );
        $self->_write_cell_array_formula( $token, $cell->[3] );
        $self->_write_cell_value( $cell->[4] );
        $self->xml_end_tag( 'c' );
    }
    elsif ( $type eq 'l' ) {

        # Write a boolean value.
        push @attributes, ( 't' => 'b' );

        $self->xml_start_tag( 'c', @attributes );
        $self->_write_cell_value( $cell->[1] );
        $self->xml_end_tag( 'c' );
    }
    elsif ( $type eq 'b' ) {

        # Write a empty cell.
        $self->xml_empty_tag( 'c', @attributes );
    }
}


###############################################################################
#
# _write_cell_value()
#
# Write the cell value <v> element.
#
sub _write_cell_value {

    my $self = shift;
    my $value = defined $_[0] ? $_[0] : '';

    $self->xml_data_element( 'v', $value );
}


###############################################################################
#
# _write_cell_formula()
#
# Write the cell formula <f> element.
#
sub _write_cell_formula {

    my $self = shift;
    my $formula = defined $_[0] ? $_[0] : '';

    $self->xml_data_element( 'f', $formula );
}


###############################################################################
#
# _write_cell_array_formula()
#
# Write the cell array formula <f> element.
#
sub _write_cell_array_formula {

    my $self    = shift;
    my $formula = shift;
    my $range   = shift;

    my @attributes = ( 't' => 'array', 'ref' => $range );

    $self->xml_data_element( 'f', $formula, @attributes );
}


##############################################################################
#
# _write_sheet_calc_pr()
#
# Write the <sheetCalcPr> element for the worksheet calculation properties.
#
sub _write_sheet_calc_pr {

    my $self              = shift;
    my $full_calc_on_load = 1;

    my @attributes = ( 'fullCalcOnLoad' => $full_calc_on_load );

    $self->xml_empty_tag( 'sheetCalcPr', @attributes );
}


###############################################################################
#
# _write_phonetic_pr()
#
# Write the <phoneticPr> element.
#
sub _write_phonetic_pr {

    my $self    = shift;
    my $font_id = 0;
    my $type    = 'noConversion';

    my @attributes = (
        'fontId' => $font_id,
        'type'   => $type,
    );

    $self->xml_empty_tag( 'phoneticPr', @attributes );
}


###############################################################################
#
# _write_page_margins()
#
# Write the <pageMargins> element.
#
sub _write_page_margins {

    my $self = shift;

    my @attributes = (
        'left'   => $self->{_margin_left},
        'right'  => $self->{_margin_right},
        'top'    => $self->{_margin_top},
        'bottom' => $self->{_margin_bottom},
        'header' => $self->{_margin_header},
        'footer' => $self->{_margin_footer},
    );

    $self->xml_empty_tag( 'pageMargins', @attributes );
}


###############################################################################
#
# _write_page_setup()
#
# Write the <pageSetup> element.
#
# The following is an example taken from Excel.
#
# <pageSetup
#     paperSize="9"
#     scale="110"
#     fitToWidth="2"
#     fitToHeight="2"
#     pageOrder="overThenDown"
#     orientation="portrait"
#     blackAndWhite="1"
#     draft="1"
#     horizontalDpi="200"
#     verticalDpi="200"
#     r:id="rId1"
# />
#
sub _write_page_setup {

    my $self       = shift;
    my @attributes = ();

    return unless $self->{_page_setup_changed};

    # Set paper size.
    if ( $self->{_paper_size} ) {
        push @attributes, ( 'paperSize' => $self->{_paper_size} );
    }

    # Set the print_scale
    if ( $self->{_print_scale} != 100 ) {
        push @attributes, ( 'scale' => $self->{_print_scale} );
    }

    # Set the "Fit to page" properties.
    if ( $self->{_fit_page} && $self->{_fit_width} != 1 ) {
        push @attributes, ( 'fitToWidth' => $self->{_fit_width} );
    }

    if ( $self->{_fit_page} && $self->{_fit_height} != 1 ) {
        push @attributes, ( 'fitToHeight' => $self->{_fit_height} );
    }

    # Set the page print direction.
    if ( $self->{_page_order} ) {
        push @attributes, ( 'pageOrder' => "overThenDown" );
    }

    # Set start page.
    if ( $self->{_page_start} > 1 ) {
        push @attributes, ( 'firstPageNumber' => $self->{_page_start} );
    }

    # Set page orientation.
    if ( $self->{_orientation} == 0 ) {
        push @attributes, ( 'orientation' => 'landscape' );
    }
    else {
        push @attributes, ( 'orientation' => 'portrait' );
    }

    # Set print in black and white option.
    if ( $self->{_black_white} ) {
        push @attributes, ( 'blackAndWhite' => 1 );
    }

    # Set start page.
    if ( $self->{_page_start} != 0 ) {
        push @attributes, ( 'useFirstPageNumber' => 1 );
    }

    # Set the DPI. Mainly only for testing.
    if ( $self->{_horizontal_dpi} ) {
        push @attributes, ( 'horizontalDpi' => $self->{_horizontal_dpi} );
    }

    if ( $self->{_vertical_dpi} ) {
        push @attributes, ( 'verticalDpi' => $self->{_vertical_dpi} );
    }


    $self->xml_empty_tag( 'pageSetup', @attributes );
}


##############################################################################
#
# _write_merge_cells()
#
# Write the <mergeCells> element.
#
sub _write_merge_cells {

    my $self         = shift;
    my $merged_cells = $self->{_merge};
    my $count        = @$merged_cells;

    return unless $count;

    my @attributes = ( 'count' => $count );

    $self->xml_start_tag( 'mergeCells', @attributes );

    for my $merged_range ( @$merged_cells ) {

        # Write the mergeCell element.
        $self->_write_merge_cell( $merged_range );
    }

    $self->xml_end_tag( 'mergeCells' );
}


##############################################################################
#
# _write_merge_cell()
#
# Write the <mergeCell> element.
#
sub _write_merge_cell {

    my $self         = shift;
    my $merged_range = shift;
    my ( $row_min, $col_min, $row_max, $col_max ) = @$merged_range;


    # Convert the merge dimensions to a cell range.
    my $cell_1 = xl_rowcol_to_cell( $row_min, $col_min );
    my $cell_2 = xl_rowcol_to_cell( $row_max, $col_max );
    my $ref    = $cell_1 . ':' . $cell_2;

    my @attributes = ( 'ref' => $ref );

    $self->xml_empty_tag( 'mergeCell', @attributes );
}


##############################################################################
#
# _write_print_options()
#
# Write the <printOptions> element.
#
sub _write_print_options {

    my $self       = shift;
    my @attributes = ();

    return unless $self->{_print_options_changed};

    # Set horizontal centering.
    if ( $self->{_hcenter} ) {
        push @attributes, ( 'horizontalCentered' => 1 );
    }

    # Set vertical centering.
    if ( $self->{_vcenter} ) {
        push @attributes, ( 'verticalCentered' => 1 );
    }

    # Enable row and column headers.
    if ( $self->{_print_headers} ) {
        push @attributes, ( 'headings' => 1 );
    }

    # Set printed gridlines.
    if ( $self->{_print_gridlines} ) {
        push @attributes, ( 'gridLines' => 1 );
    }


    $self->xml_empty_tag( 'printOptions', @attributes );
}


##############################################################################
#
# _write_header_footer()
#
# Write the <headerFooter> element.
#
sub _write_header_footer {

    my $self       = shift;
    my @attributes = ();

    if ( !$self->{_header_footer_scales} ) {
        push @attributes, ( 'scaleWithDoc' => 0 );
    }

    if ( !$self->{_header_footer_aligns} ) {
        push @attributes, ( 'alignWithMargins' => 0 );
    }

    if ( $self->{_header_footer_changed} ) {
        $self->xml_start_tag( 'headerFooter', @attributes );
        $self->_write_odd_header() if $self->{_header};
        $self->_write_odd_footer() if $self->{_footer};
        $self->xml_end_tag( 'headerFooter' );
    }
    elsif ( $self->{_excel2003_style} ) {
        $self->xml_empty_tag( 'headerFooter', @attributes );
    }
}


##############################################################################
#
# _write_odd_header()
#
# Write the <oddHeader> element.
#
sub _write_odd_header {

    my $self = shift;
    my $data = $self->{_header};

    $self->xml_data_element( 'oddHeader', $data );
}


##############################################################################
#
# _write_odd_footer()
#
# Write the <oddFooter> element.
#
sub _write_odd_footer {

    my $self = shift;
    my $data = $self->{_footer};

    $self->xml_data_element( 'oddFooter', $data );
}


##############################################################################
#
# _write_row_breaks()
#
# Write the <rowBreaks> element.
#
sub _write_row_breaks {

    my $self = shift;

    my @page_breaks = $self->_sort_pagebreaks( @{ $self->{_hbreaks} } );
    my $count       = scalar @page_breaks;

    return unless @page_breaks;

    my @attributes = (
        'count'            => $count,
        'manualBreakCount' => $count,
    );

    $self->xml_start_tag( 'rowBreaks', @attributes );

    for my $row_num ( @page_breaks ) {
        $self->_write_brk( $row_num, 16383 );
    }

    $self->xml_end_tag( 'rowBreaks' );
}


##############################################################################
#
# _write_col_breaks()
#
# Write the <colBreaks> element.
#
sub _write_col_breaks {

    my $self = shift;

    my @page_breaks = $self->_sort_pagebreaks( @{ $self->{_vbreaks} } );
    my $count       = scalar @page_breaks;

    return unless @page_breaks;

    my @attributes = (
        'count'            => $count,
        'manualBreakCount' => $count,
    );

    $self->xml_start_tag( 'colBreaks', @attributes );

    for my $col_num ( @page_breaks ) {
        $self->_write_brk( $col_num, 1048575 );
    }

    $self->xml_end_tag( 'colBreaks' );
}


##############################################################################
#
# _write_brk()
#
# Write the <brk> element.
#
sub _write_brk {

    my $self = shift;
    my $id   = shift;
    my $max  = shift;
    my $man  = 1;

    my @attributes = (
        'id'  => $id,
        'max' => $max,
        'man' => $man,
    );

    $self->xml_empty_tag( 'brk', @attributes );
}


##############################################################################
#
# _write_auto_filter()
#
# Write the <autoFilter> element.
#
sub _write_auto_filter {

    my $self = shift;
    my $ref  = $self->{_autofilter_ref};

    return unless $ref;

    my @attributes = ( 'ref' => $ref );

    if ( $self->{_filter_on} ) {

        # Autofilter defined active filters.
        $self->xml_start_tag( 'autoFilter', @attributes );

        $self->_write_autofilters();

        $self->xml_end_tag( 'autoFilter' );

    }
    else {

        # Autofilter defined without active filters.
        $self->xml_empty_tag( 'autoFilter', @attributes );
    }

}


###############################################################################
#
# _write_autofilters()
#
# Function to iterate through the columns that form part of an autofilter
# range and write the appropriate filters.
#
sub _write_autofilters {

    my $self = shift;

    my ( $col1, $col2 ) = @{ $self->{_filter_range} };

    for my $col ( $col1 .. $col2 ) {

        # Skip if column doesn't have an active filter.
        next unless $self->{_filter_cols}->{$col};

        # Retrieve the filter tokens and write the autofilter records.
        my @tokens = @{ $self->{_filter_cols}->{$col} };
        my $type   = $self->{_filter_type}->{$col};

        # Filters are relative to first column in the autofilter.
        $self->_write_filter_column( $col - $col1, $type, \@tokens );
    }
}


##############################################################################
#
# _write_filter_column()
#
# Write the <filterColumn> element.
#
sub _write_filter_column {

    my $self    = shift;
    my $col_id  = shift;
    my $type    = shift;
    my $filters = shift;

    my @attributes = ( 'colId' => $col_id );

    $self->xml_start_tag( 'filterColumn', @attributes );


    if ( $type == 1 ) {

        # Type == 1 is the new XLSX style filter.
        $self->_write_filters( @$filters );

    }
    else {

        # Type == 0 is the classic "custom" filter.
        $self->_write_custom_filters( @$filters );
    }

    $self->xml_end_tag( 'filterColumn' );
}


##############################################################################
#
# _write_filters()
#
# Write the <filters> element.
#
sub _write_filters {

    my $self    = shift;
    my @filters = @_;

    if ( @filters == 1 && $filters[0] eq 'blanks' ) {

        # Special case for blank cells only.
        $self->xml_empty_tag( 'filters', 'blank' => 1 );
    }
    else {

        # General case.
        $self->xml_start_tag( 'filters' );

        for my $filter ( @filters ) {
            $self->_write_filter( $filter );
        }

        $self->xml_end_tag( 'filters' );
    }
}


##############################################################################
#
# _write_filter()
#
# Write the <filter> element.
#
sub _write_filter {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'filter', @attributes );
}


##############################################################################
#
# _write_custom_filters()
#
# Write the <customFilters> element.
#
sub _write_custom_filters {

    my $self   = shift;
    my @tokens = @_;

    if ( @tokens == 2 ) {

        # One filter expression only.
        $self->xml_start_tag( 'customFilters' );
        $self->_write_custom_filter( @tokens );
        $self->xml_end_tag( 'customFilters' );

    }
    else {

        # Two filter expressions.

        my @attributes;

        # Check if the "join" operand is "and" or "or".
        if ( $tokens[2] == 0 ) {
            @attributes = ( 'and' => 1 );
        }
        else {
            @attributes = ( 'and' => 0 );
        }

        # Write the two custom filters.
        $self->xml_start_tag( 'customFilters', @attributes );
        $self->_write_custom_filter( $tokens[0], $tokens[1] );
        $self->_write_custom_filter( $tokens[3], $tokens[4] );
        $self->xml_end_tag( 'customFilters' );
    }
}


##############################################################################
#
# _write_custom_filter()
#
# Write the <customFilter> element.
#
sub _write_custom_filter {

    my $self       = shift;
    my $operator   = shift;
    my $val        = shift;
    my @attributes = ();

    my %operators = (
        1  => 'lessThan',
        2  => 'equal',
        3  => 'lessThanOrEqual',
        4  => 'greaterThan',
        5  => 'notEqual',
        6  => 'greaterThanOrEqual',
        22 => 'equal',
    );


    # Convert the operator from a number to a descriptive string.
    if ( defined $operators{$operator} ) {
        $operator = $operators{$operator};
    }
    else {
        croak "Unknown operator = $operator\n";
    }

    # The 'equal' operator is the default attribute and isn't stored.
    push @attributes, ( 'operator' => $operator ) unless $operator eq 'equal';
    push @attributes, ( 'val' => $val );

    $self->xml_empty_tag( 'customFilter', @attributes );
}


##############################################################################
#
# _write_hyperlinks()
#
# Process any stored hyperlinks in row/col order and write the <hyperlinks>
# element. The attributes are different for internal and external links.
#
sub _write_hyperlinks {

    my $self = shift;
    my @hlink_refs;

    # Sort the hyperlinks into row order.
    my @row_nums = sort { $a <=> $b } keys %{ $self->{_hyperlinks} };

    # Exit if there are no hyperlinks to process.
    return if !@row_nums;

    # Iterate over the rows.
    for my $row_num ( @row_nums ) {

        # Sort the hyperlinks into column order.
        my @col_nums = sort { $a <=> $b }
          keys %{ $self->{_hyperlinks}->{$row_num} };

        # Iterate over the columns.
        for my $col_num ( @col_nums ) {

            # Get the link data for this cell.
            my $link      = $self->{_hyperlinks}->{$row_num}->{$col_num};
            my $link_type = $link->{_link_type};


            # If the cell isn't a string then we have to add the url as
            # the string to display.
            my $display;
            if (   $self->{_table}
                && $self->{_table}->{$row_num}
                && $self->{_table}->{$row_num}->{$col_num} )
            {
                my $cell = $self->{_table}->{$row_num}->{$col_num};
                $display = $link->{_url} if $cell->[0] ne 's';
            }


            if ( $link_type == 1 ) {

                # External link with rel file relationship.
                push @hlink_refs,
                  [
                    $link_type,    $row_num,
                    $col_num,      ++$self->{_rel_count},
                    $link->{_str}, $display,
                    $link->{_tip}
                  ];

                # Links for use by the packager.
                push @{ $self->{_external_hyper_links} },
                  [ '/hyperlink', $link->{_url}, 'External' ];
            }
            else {

                # Internal link with rel file relationship.
                push @hlink_refs,
                  [
                    $link_type,    $row_num,      $col_num,
                    $link->{_url}, $link->{_str}, $link->{_tip}
                  ];
            }
        }
    }

    # Write the hyperlink elements.
    $self->xml_start_tag( 'hyperlinks' );

    for my $aref ( @hlink_refs ) {
        my ( $type, @args ) = @$aref;

        if ( $type == 1 ) {
            $self->_write_hyperlink_external( @args );
        }
        elsif ( $type == 2 ) {
            $self->_write_hyperlink_internal( @args );
        }
    }

    $self->xml_end_tag( 'hyperlinks' );
}


##############################################################################
#
# _write_hyperlink_external()
#
# Write the <hyperlink> element for external links.
#
sub _write_hyperlink_external {

    my $self     = shift;
    my $row      = shift;
    my $col      = shift;
    my $id       = shift;
    my $location = shift;
    my $display  = shift;
    my $tooltip  = shift;

    my $ref = xl_rowcol_to_cell( $row, $col );
    my $r_id = 'rId' . $id;

    my @attributes = (
        'ref'  => $ref,
        'r:id' => $r_id,
    );

    push @attributes, ( 'location' => $location ) if defined $location;
    push @attributes, ( 'display' => $display )   if defined $display;
    push @attributes, ( 'tooltip'  => $tooltip )  if defined $tooltip;

    $self->xml_empty_tag( 'hyperlink', @attributes );
}


##############################################################################
#
# _write_hyperlink_internal()
#
# Write the <hyperlink> element for internal links.
#
sub _write_hyperlink_internal {

    my $self     = shift;
    my $row      = shift;
    my $col      = shift;
    my $location = shift;
    my $display  = shift;
    my $tooltip  = shift;

    my $ref = xl_rowcol_to_cell( $row, $col );

    my @attributes = ( 'ref' => $ref, 'location' => $location );

    push @attributes, ( 'tooltip' => $tooltip ) if defined $tooltip;
    push @attributes, ( 'display' => $display );

    $self->xml_empty_tag( 'hyperlink', @attributes );
}


##############################################################################
#
# _write_panes()
#
# Write the frozen or split <pane> elements.
#
sub _write_panes {

    my $self  = shift;
    my @panes = @{ $self->{_panes} };

    return unless @panes;

    if ( $panes[4] == 2 ) {
        $self->_write_split_panes( @panes );
    }
    else {
        $self->_write_freeze_panes( @panes );
    }
}


##############################################################################
#
# _write_freeze_panes()
#
# Write the <pane> element for freeze panes.
#
sub _write_freeze_panes {

    my $self = shift;
    my @attributes;

    my ( $row, $col, $top_row, $left_col, $type ) = @_;

    my $y_split       = $row;
    my $x_split       = $col;
    my $top_left_cell = xl_rowcol_to_cell( $top_row, $left_col );
    my $active_pane;
    my $state;
    my $active_cell;
    my $sqref;

    # Move user cell selection to the panes.
    if ( @{ $self->{_selections} } ) {
        ( undef, $active_cell, $sqref ) = @{ $self->{_selections}->[0] };
        $self->{_selections} = [];
    }

    # Set the active pane.
    if ( $row && $col ) {
        $active_pane = 'bottomRight';

        my $row_cell = xl_rowcol_to_cell( $row, 0 );
        my $col_cell = xl_rowcol_to_cell( 0,    $col );

        push @{ $self->{_selections} },
          (
            [ 'topRight',    $col_cell,    $col_cell ],
            [ 'bottomLeft',  $row_cell,    $row_cell ],
            [ 'bottomRight', $active_cell, $sqref ]
          );
    }
    elsif ( $col ) {
        $active_pane = 'topRight';
        push @{ $self->{_selections} }, [ 'topRight', $active_cell, $sqref ];
    }
    else {
        $active_pane = 'bottomLeft';
        push @{ $self->{_selections} }, [ 'bottomLeft', $active_cell, $sqref ];
    }

    # Set the pane type.
    if ( $type == 0 ) {
        $state = 'frozen';
    }
    elsif ( $type == 1 ) {
        $state = 'frozenSplit';
    }
    else {
        $state = 'split';
    }


    push @attributes, ( 'xSplit' => $x_split ) if $x_split;
    push @attributes, ( 'ySplit' => $y_split ) if $y_split;

    push @attributes, ( 'topLeftCell' => $top_left_cell );
    push @attributes, ( 'activePane'  => $active_pane );
    push @attributes, ( 'state'       => $state );


    $self->xml_empty_tag( 'pane', @attributes );
}


##############################################################################
#
# _write_split_panes()
#
# Write the <pane> element for split panes.
#
# See also, implementers note for split_panes().
#
sub _write_split_panes {

    my $self = shift;
    my @attributes;
    my $y_split;
    my $x_split;
    my $has_selection = 0;
    my $active_pane;
    my $active_cell;
    my $sqref;

    my ( $row, $col, $top_row, $left_col, $type ) = @_;
    $y_split = $row;
    $x_split = $col;

    # Move user cell selection to the panes.
    if ( @{ $self->{_selections} } ) {
        ( undef, $active_cell, $sqref ) = @{ $self->{_selections}->[0] };
        $self->{_selections} = [];
        $has_selection = 1;
    }

    # Convert the row and col to 1/20 twip units with padding.
    $y_split = int( 20 * $y_split + 300 ) if $y_split;
    $x_split = $self->_calculate_x_split_width( $x_split ) if $x_split;

    # For non-explicit topLeft definitions, estimate the cell offset based
    # on the pixels dimensions. This is only a workaround and doesn't take
    # adjusted cell dimensions into account.
    if ( $top_row == $row && $left_col == $col ) {
        $top_row  = int( 0.5 + ( $y_split - 300 ) / 20 / 15 );
        $left_col = int( 0.5 + ( $x_split - 390 ) / 20 / 3 * 4 / 64 );
    }

    my $top_left_cell = xl_rowcol_to_cell( $top_row, $left_col );

    # If there is no selection set the active cell to the top left cell.
    if ( !$has_selection ) {
        $active_cell = $top_left_cell;
        $sqref       = $top_left_cell;
    }

    # Set the Cell selections.
    if ( $row && $col ) {
        $active_pane = 'bottomRight';

        my $row_cell = xl_rowcol_to_cell( $top_row, 0 );
        my $col_cell = xl_rowcol_to_cell( 0,        $left_col );

        push @{ $self->{_selections} },
          (
            [ 'topRight',    $col_cell,    $col_cell ],
            [ 'bottomLeft',  $row_cell,    $row_cell ],
            [ 'bottomRight', $active_cell, $sqref ]
          );
    }
    elsif ( $col ) {
        $active_pane = 'topRight';
        push @{ $self->{_selections} }, [ 'topRight', $active_cell, $sqref ];
    }
    else {
        $active_pane = 'bottomLeft';
        push @{ $self->{_selections} }, [ 'bottomLeft', $active_cell, $sqref ];
    }

    push @attributes, ( 'xSplit' => $x_split ) if $x_split;
    push @attributes, ( 'ySplit' => $y_split ) if $y_split;
    push @attributes, ( 'topLeftCell' => $top_left_cell );
    push @attributes, ( 'activePane' => $active_pane ) if $has_selection;

    $self->xml_empty_tag( 'pane', @attributes );
}


##############################################################################
#
# _calculate_x_split_width()
#
# Convert column width from user units to pane split width.
#
sub _calculate_x_split_width {

    my $self  = shift;
    my $width = shift;

    my $max_digit_width = 7;    # For Calabri 11.
    my $padding         = 5;
    my $pixels;

    # Convert to pixels.
    if ( $width < 1 ) {
        $pixels = int( $width * ( $max_digit_width + $padding ) + 0.5 );
    }
    else {
          $pixels = int( $width * $max_digit_width + 0.5 ) + $padding;
    }

    # Convert to points.
    my $points = $pixels * 3 / 4;

    # Convert to twips (twentieths of a point).
    my $twips = $points * 20;

    # Add offset/padding.
    $width = $twips + 390;

    return $width;
}


##############################################################################
#
# _write_tab_color()
#
# Write the <tabColor> element.
#
sub _write_tab_color {

    my $self        = shift;
    my $color_index = $self->{_tab_color};

    return unless $color_index;

    my $rgb = $self->_get_palette_color( $color_index );

    my @attributes = ( 'rgb' => $rgb );

    $self->xml_empty_tag( 'tabColor', @attributes );
}


##############################################################################
#
# _write_outline_pr()
#
# Write the <outlinePr> element.
#
sub _write_outline_pr {

    my $self       = shift;
    my @attributes = ();

    return unless $self->{_outline_changed};

    push @attributes, ( "applyStyles"        => 1 ) if $self->{_outline_style};
    push @attributes, ( "summaryBelow"       => 0 ) if !$self->{_outline_below};
    push @attributes, ( "summaryRight"       => 0 ) if !$self->{_outline_right};
    push @attributes, ( "showOutlineSymbols" => 0 ) if !$self->{_outline_on};

    $self->xml_empty_tag( 'outlinePr', @attributes );
}


##############################################################################
#
# _write_sheet_protection()
#
# Write the <sheetProtection> element.
#
sub _write_sheet_protection {

    my $self = shift;
    my @attributes;

    return unless $self->{_protect};

    my %arg = %{ $self->{_protect} };

    push @attributes, ( "password"    => $arg{password} ) if $arg{password};
    push @attributes, ( "sheet"       => 1 )              if $arg{sheet};
    push @attributes, ( "content"     => 1 )              if $arg{content};
    push @attributes, ( "objects"     => 1 )              if !$arg{objects};
    push @attributes, ( "scenarios"   => 1 )              if !$arg{scenarios};
    push @attributes, ( "formatCells" => 0 )              if $arg{format_cells};
    push @attributes, ( "formatColumns"    => 0 ) if $arg{format_columns};
    push @attributes, ( "formatRows"       => 0 ) if $arg{format_rows};
    push @attributes, ( "insertColumns"    => 0 ) if $arg{insert_columns};
    push @attributes, ( "insertRows"       => 0 ) if $arg{insert_rows};
    push @attributes, ( "insertHyperlinks" => 0 ) if $arg{insert_hyperlinks};
    push @attributes, ( "deleteColumns"    => 0 ) if $arg{delete_columns};
    push @attributes, ( "deleteRows"       => 0 ) if $arg{delete_rows};

    push @attributes, ( "selectLockedCells" => 1 )
      if !$arg{select_locked_cells};

    push @attributes, ( "sort"        => 0 ) if $arg{sort};
    push @attributes, ( "autoFilter"  => 0 ) if $arg{autofilter};
    push @attributes, ( "pivotTables" => 0 ) if $arg{pivot_tables};

    push @attributes, ( "selectUnlockedCells" => 1 )
      if !$arg{select_unlocked_cells};


    $self->xml_empty_tag( 'sheetProtection', @attributes );
}


##############################################################################
#
# _write_drawings()
#
# Write the <drawing> elements.
#
sub _write_drawings {

    my $self = shift;

    return unless $self->{_drawing};

    $self->_write_drawing( ++$self->{_rel_count} );
}


##############################################################################
#
# _write_drawing()
#
# Write the <drawing> element.
#
sub _write_drawing {

    my $self = shift;
    my $id   = shift;
    my $r_id = 'rId' . $id;

    my @attributes = ( 'r:id' => $r_id );

    $self->xml_empty_tag( 'drawing', @attributes );
}


##############################################################################
#
# _write_legacy_drawing()
#
# Write the <legacyDrawing> element.
#
sub _write_legacy_drawing {

    my $self = shift;
    my $id;

    return unless $self->{_has_vml};

    # Increment the relationship id for any drawings or comments.
    $id = ++$self->{_rel_count};

    my @attributes = ( 'r:id' => 'rId' . $id );

    $self->xml_empty_tag( 'legacyDrawing', @attributes );
}



##############################################################################
#
# _write_legacy_drawing_hf()
#
# Write the <legacyDrawingHF> element.
#
sub _write_legacy_drawing_hf {

    my $self = shift;
    my $id;

    return unless $self->{_has_header_vml};

    # Increment the relationship id for any drawings or comments.
    $id = ++$self->{_rel_count};

    my @attributes = ( 'r:id' => 'rId' . $id );

    $self->xml_empty_tag( 'legacyDrawingHF', @attributes );
}


#
# Note, the following font methods are, more or less, duplicated from the
# Excel::Writer::XLSX::Package::Styles class. I will look at implementing
# this is a cleaner encapsulated mode at a later stage.
#


##############################################################################
#
# _write_font()
#
# Write the <font> element.
#
sub _write_font {

    my $self   = shift;
    my $format = shift;

    $self->{_rstring}->xml_start_tag( 'rPr' );

    $self->{_rstring}->xml_empty_tag( 'b' )       if $format->{_bold};
    $self->{_rstring}->xml_empty_tag( 'i' )       if $format->{_italic};
    $self->{_rstring}->xml_empty_tag( 'strike' )  if $format->{_font_strikeout};
    $self->{_rstring}->xml_empty_tag( 'outline' ) if $format->{_font_outline};
    $self->{_rstring}->xml_empty_tag( 'shadow' )  if $format->{_font_shadow};

    # Handle the underline variants.
    $self->_write_underline( $format->{_underline} ) if $format->{_underline};

    $self->_write_vert_align( 'superscript' ) if $format->{_font_script} == 1;
    $self->_write_vert_align( 'subscript' )   if $format->{_font_script} == 2;

    $self->{_rstring}->xml_empty_tag( 'sz', 'val', $format->{_size} );

    if ( my $theme = $format->{_theme} ) {
        $self->_write_rstring_color( 'theme' => $theme );
    }
    elsif ( my $color = $format->{_color} ) {
        $color = $self->_get_palette_color( $color );

        $self->_write_rstring_color( 'rgb' => $color );
    }
    else {
        $self->_write_rstring_color( 'theme' => 1 );
    }

    $self->{_rstring}->xml_empty_tag( 'rFont', 'val', $format->{_font} );
    $self->{_rstring}
      ->xml_empty_tag( 'family', 'val', $format->{_font_family} );

    if ( $format->{_font} eq 'Calibri' && !$format->{_hyperlink} ) {
        $self->{_rstring}
          ->xml_empty_tag( 'scheme', 'val', $format->{_font_scheme} );
    }

    $self->{_rstring}->xml_end_tag( 'rPr' );
}


###############################################################################
#
# _write_underline()
#
# Write the underline font element.
#
sub _write_underline {

    my $self      = shift;
    my $underline = shift;
    my @attributes;

    # Handle the underline variants.
    if ( $underline == 2 ) {
        @attributes = ( val => 'double' );
    }
    elsif ( $underline == 33 ) {
        @attributes = ( val => 'singleAccounting' );
    }
    elsif ( $underline == 34 ) {
        @attributes = ( val => 'doubleAccounting' );
    }
    else {
        @attributes = ();    # Default to single underline.
    }

    $self->{_rstring}->xml_empty_tag( 'u', @attributes );

}


##############################################################################
#
# _write_vert_align()
#
# Write the <vertAlign> font sub-element.
#
sub _write_vert_align {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->{_rstring}->xml_empty_tag( 'vertAlign', @attributes );
}


##############################################################################
#
# _write_rstring_color()
#
# Write the <color> element.
#
sub _write_rstring_color {

    my $self  = shift;
    my $name  = shift;
    my $value = shift;

    my @attributes = ( $name => $value );

    $self->{_rstring}->xml_empty_tag( 'color', @attributes );
}


#
# End font duplication code.
#


##############################################################################
#
# _write_data_validations()
#
# Write the <dataValidations> element.
#
sub _write_data_validations {

    my $self        = shift;
    my @validations = @{ $self->{_validations} };
    my $count       = @validations;

    return unless $count;

    my @attributes = ( 'count' => $count );

    $self->xml_start_tag( 'dataValidations', @attributes );

    for my $validation ( @validations ) {

        # Write the dataValidation element.
        $self->_write_data_validation( $validation );
    }

    $self->xml_end_tag( 'dataValidations' );
}


##############################################################################
#
# _write_data_validation()
#
# Write the <dataValidation> element.
#
sub _write_data_validation {

    my $self       = shift;
    my $param      = shift;
    my $sqref      = '';
    my @attributes = ();


    # Set the cell range(s) for the data validation.
    for my $cells ( @{ $param->{cells} } ) {

        # Add a space between multiple cell ranges.
        $sqref .= ' ' if $sqref ne '';

        my ( $row_first, $col_first, $row_last, $col_last ) = @$cells;

        # Swap last row/col for first row/col as necessary
        if ( $row_first > $row_last ) {
            ( $row_first, $row_last ) = ( $row_last, $row_first );
        }

        if ( $col_first > $col_last ) {
            ( $col_first, $col_last ) = ( $col_last, $col_first );
        }

        # If the first and last cell are the same write a single cell.
        if ( ( $row_first == $row_last ) && ( $col_first == $col_last ) ) {
            $sqref .= xl_rowcol_to_cell( $row_first, $col_first );
        }
        else {
            $sqref .= xl_range( $row_first, $row_last, $col_first, $col_last );
        }
    }


    if ( $param->{validate} ne 'none' ) {

        push @attributes, ( 'type' => $param->{validate} );

        if ( $param->{criteria} ne 'between' ) {
            push @attributes, ( 'operator' => $param->{criteria} );
        }

    }

    if ( $param->{error_type} ) {
        push @attributes, ( 'errorStyle' => 'warning' )
          if $param->{error_type} == 1;
        push @attributes, ( 'errorStyle' => 'information' )
          if $param->{error_type} == 2;
    }

    push @attributes, ( 'allowBlank'       => 1 ) if $param->{ignore_blank};
    push @attributes, ( 'showDropDown'     => 1 ) if !$param->{dropdown};
    push @attributes, ( 'showInputMessage' => 1 ) if $param->{show_input};
    push @attributes, ( 'showErrorMessage' => 1 ) if $param->{show_error};

    push @attributes, ( 'errorTitle' => $param->{error_title} )
      if $param->{error_title};

    push @attributes, ( 'error' => $param->{error_message} )
      if $param->{error_message};

    push @attributes, ( 'promptTitle' => $param->{input_title} )
      if $param->{input_title};

    push @attributes, ( 'prompt' => $param->{input_message} )
      if $param->{input_message};

    push @attributes, ( 'sqref' => $sqref );

    if ( $param->{validate} eq 'none' ) {
        $self->xml_empty_tag( 'dataValidation', @attributes );
    }
    else {
        $self->xml_start_tag( 'dataValidation', @attributes );

        # Write the formula1 element.
        $self->_write_formula_1( $param->{value} );

        # Write the formula2 element.
        $self->_write_formula_2( $param->{maximum} )
          if defined $param->{maximum};

        $self->xml_end_tag( 'dataValidation' );
    }
}


##############################################################################
#
# _write_formula_1()
#
# Write the <formula1> element.
#
sub _write_formula_1 {

    my $self    = shift;
    my $formula = shift;

    # Convert a list array ref into a comma separated string.
    if ( ref $formula eq 'ARRAY' ) {
        $formula = join ',', @$formula;
        $formula = qq("$formula");
    }

    $formula =~ s/^=//;    # Remove formula symbol.

    $self->xml_data_element( 'formula1', $formula );
}


##############################################################################
#
# _write_formula_2()
#
# Write the <formula2> element.
#
sub _write_formula_2 {

    my $self    = shift;
    my $formula = shift;

    $formula =~ s/^=//;    # Remove formula symbol.

    $self->xml_data_element( 'formula2', $formula );
}


##############################################################################
#
# _write_conditional_formats()
#
# Write the Worksheet conditional formats.
#
sub _write_conditional_formats {

    my $self   = shift;
    my @ranges = sort keys %{ $self->{_cond_formats} };

    return unless scalar @ranges;

    for my $range ( @ranges ) {
        $self->_write_conditional_formatting( $range,
            $self->{_cond_formats}->{$range} );
    }
}


##############################################################################
#
# _write_conditional_formatting()
#
# Write the <conditionalFormatting> element.
#
sub _write_conditional_formatting {

    my $self   = shift;
    my $range  = shift;
    my $params = shift;

    my @attributes = ( 'sqref' => $range );

    $self->xml_start_tag( 'conditionalFormatting', @attributes );

    for my $param ( @$params ) {

        # Write the cfRule element.
        $self->_write_cf_rule( $param );
    }

    $self->xml_end_tag( 'conditionalFormatting' );
}

##############################################################################
#
# _write_cf_rule()
#
# Write the <cfRule> element.
#
sub _write_cf_rule {

    my $self  = shift;
    my $param = shift;

    my @attributes = ( 'type' => $param->{type} );

    push @attributes, ( 'dxfId' => $param->{format} )
      if defined $param->{format};

    push @attributes, ( 'priority' => $param->{priority} );

    push @attributes, ( 'stopIfTrue' => 1 )
      if defined $param->{stop_if_true};

    if ( $param->{type} eq 'cellIs' ) {
        push @attributes, ( 'operator' => $param->{criteria} );

        $self->xml_start_tag( 'cfRule', @attributes );

        if ( defined $param->{minimum} && defined $param->{maximum} ) {
            $self->_write_formula( $param->{minimum} );
            $self->_write_formula( $param->{maximum} );
        }
        else {
            $self->_write_formula( $param->{value} );
        }

        $self->xml_end_tag( 'cfRule' );
    }
    elsif ( $param->{type} eq 'aboveAverage' ) {
        if ( $param->{criteria} =~ /below/ ) {
            push @attributes, ( 'aboveAverage' => 0 );
        }

        if ( $param->{criteria} =~ /equal/ ) {
            push @attributes, ( 'equalAverage' => 1 );
        }

        if ( $param->{criteria} =~ /([123]) std dev/ ) {
            push @attributes, ( 'stdDev' => $1 );
        }

        $self->xml_empty_tag( 'cfRule', @attributes );
    }
    elsif ( $param->{type} eq 'top10' ) {
        if ( defined $param->{criteria} && $param->{criteria} eq '%' ) {
            push @attributes, ( 'percent' => 1 );
        }

        if ( $param->{direction} ) {
            push @attributes, ( 'bottom' => 1 );
        }

        my $rank = $param->{value} || 10;
        push @attributes, ( 'rank' => $rank );

        $self->xml_empty_tag( 'cfRule', @attributes );
    }
    elsif ( $param->{type} eq 'duplicateValues' ) {
        $self->xml_empty_tag( 'cfRule', @attributes );
    }
    elsif ( $param->{type} eq 'uniqueValues' ) {
        $self->xml_empty_tag( 'cfRule', @attributes );
    }
    elsif ($param->{type} eq 'containsText'
        || $param->{type} eq 'notContainsText'
        || $param->{type} eq 'beginsWith'
        || $param->{type} eq 'endsWith' )
    {
        push @attributes, ( 'operator' => $param->{criteria} );
        push @attributes, ( 'text'     => $param->{value} );

        $self->xml_start_tag( 'cfRule', @attributes );
        $self->_write_formula( $param->{formula} );
        $self->xml_end_tag( 'cfRule' );
    }
    elsif ( $param->{type} eq 'timePeriod' ) {
        push @attributes, ( 'timePeriod' => $param->{criteria} );

        $self->xml_start_tag( 'cfRule', @attributes );
        $self->_write_formula( $param->{formula} );
        $self->xml_end_tag( 'cfRule' );
    }
    elsif ($param->{type} eq 'containsBlanks'
        || $param->{type} eq 'notContainsBlanks'
        || $param->{type} eq 'containsErrors'
        || $param->{type} eq 'notContainsErrors' )
    {
        $self->xml_start_tag( 'cfRule', @attributes );
        $self->_write_formula( $param->{formula} );
        $self->xml_end_tag( 'cfRule' );
    }
    elsif ( $param->{type} eq 'colorScale' ) {

        $self->xml_start_tag( 'cfRule', @attributes );
        $self->_write_color_scale( $param );
        $self->xml_end_tag( 'cfRule' );
    }
    elsif ( $param->{type} eq 'dataBar' ) {

        $self->xml_start_tag( 'cfRule', @attributes );
        $self->_write_data_bar( $param );
        $self->xml_end_tag( 'cfRule' );
    }
    elsif ( $param->{type} eq 'expression' ) {

        $self->xml_start_tag( 'cfRule', @attributes );
        $self->_write_formula( $param->{criteria} );
        $self->xml_end_tag( 'cfRule' );
    }
}


##############################################################################
#
# _write_formula()
#
# Write the <formula> element.
#
sub _write_formula {

    my $self = shift;
    my $data = shift;

    # Remove equality from formula.
    $data =~ s/^=//;

    $self->xml_data_element( 'formula', $data );
}


##############################################################################
#
# _write_color_scale()
#
# Write the <colorScale> element.
#
sub _write_color_scale {

    my $self  = shift;
    my $param = shift;

    $self->xml_start_tag( 'colorScale' );

    $self->_write_cfvo( $param->{min_type}, $param->{min_value} );

    if ( defined $param->{mid_type} ) {
        $self->_write_cfvo( $param->{mid_type}, $param->{mid_value} );
    }

    $self->_write_cfvo( $param->{max_type}, $param->{max_value} );

    $self->_write_color( 'rgb' => $param->{min_color} );

    if ( defined $param->{mid_color} ) {
        $self->_write_color( 'rgb' => $param->{mid_color} );
    }

    $self->_write_color( 'rgb' => $param->{max_color} );

    $self->xml_end_tag( 'colorScale' );
}


##############################################################################
#
# _write_data_bar()
#
# Write the <dataBar> element.
#
sub _write_data_bar {

    my $self  = shift;
    my $param = shift;

    $self->xml_start_tag( 'dataBar' );

    $self->_write_cfvo( $param->{min_type}, $param->{min_value} );
    $self->_write_cfvo( $param->{max_type}, $param->{max_value} );

    $self->_write_color( 'rgb' => $param->{bar_color} );

    $self->xml_end_tag( 'dataBar' );
}


##############################################################################
#
# _write_cfvo()
#
# Write the <cfvo> element.
#
sub _write_cfvo {

    my $self = shift;
    my $type = shift;
    my $val  = shift;

    my @attributes = (
        'type' => $type,
        'val'  => $val
    );

    $self->xml_empty_tag( 'cfvo', @attributes );
}


##############################################################################
#
# _write_color()
#
# Write the <color> element.
#
sub _write_color {

    my $self  = shift;
    my $name  = shift;
    my $value = shift;

    my @attributes = ( $name => $value );

    $self->xml_empty_tag( 'color', @attributes );
}


##############################################################################
#
# _write_table_parts()
#
# Write the <tableParts> element.
#
sub _write_table_parts {

    my $self   = shift;
    my @tables = @{ $self->{_tables} };
    my $count  = scalar @tables;

    # Return if worksheet doesn't contain any tables.
    return unless $count;

    my @attributes = ( 'count' => $count, );

    $self->xml_start_tag( 'tableParts', @attributes );

    for my $table ( @tables ) {

        # Write the tablePart element.
        $self->_write_table_part( ++$self->{_rel_count} );

    }

    $self->xml_end_tag( 'tableParts' );
}


##############################################################################
#
# _write_table_part()
#
# Write the <tablePart> element.
#
sub _write_table_part {

    my $self = shift;
    my $id   = shift;
    my $r_id = 'rId' . $id;

    my @attributes = ( 'r:id' => $r_id, );

    $self->xml_empty_tag( 'tablePart', @attributes );
}


##############################################################################
#
# _write_ext_sparklines()
#
# Write the <extLst> element and sparkline subelements.
#
sub _write_ext_sparklines {

    my $self       = shift;
    my @sparklines = @{ $self->{_sparklines} };
    my $count      = scalar @sparklines;

    # Return if worksheet doesn't contain any sparklines.
    return unless $count;


    # Write the extLst element.
    $self->xml_start_tag( 'extLst' );

    # Write the ext element.
    $self->_write_ext();

    # Write the x14:sparklineGroups element.
    $self->_write_sparkline_groups();

    # Write the sparkline elements.
    for my $sparkline ( reverse @sparklines ) {

        # Write the x14:sparklineGroup element.
        $self->_write_sparkline_group( $sparkline );

        # Write the x14:colorSeries element.
        $self->_write_color_series( $sparkline->{_series_color} );

        # Write the x14:colorNegative element.
        $self->_write_color_negative( $sparkline->{_negative_color} );

        # Write the x14:colorAxis element.
        $self->_write_color_axis();

        # Write the x14:colorMarkers element.
        $self->_write_color_markers( $sparkline->{_markers_color} );

        # Write the x14:colorFirst element.
        $self->_write_color_first( $sparkline->{_first_color} );

        # Write the x14:colorLast element.
        $self->_write_color_last( $sparkline->{_last_color} );

        # Write the x14:colorHigh element.
        $self->_write_color_high( $sparkline->{_high_color} );

        # Write the x14:colorLow element.
        $self->_write_color_low( $sparkline->{_low_color} );

        if ( $sparkline->{_date_axis} ) {
            $self->xml_data_element( 'xm:f', $sparkline->{_date_axis} );
        }

        $self->_write_sparklines( $sparkline );

        $self->xml_end_tag( 'x14:sparklineGroup' );
    }


    $self->xml_end_tag( 'x14:sparklineGroups' );
    $self->xml_end_tag( 'ext' );
    $self->xml_end_tag( 'extLst' );
}


##############################################################################
#
# _write_sparklines()
#
# Write the <x14:sparklines> element and <x14:sparkline> subelements.
#
sub _write_sparklines {

    my $self      = shift;
    my $sparkline = shift;

    # Write the sparkline elements.
    $self->xml_start_tag( 'x14:sparklines' );

    for my $i ( 0 .. $sparkline->{_count} - 1 ) {
        my $range    = $sparkline->{_ranges}->[$i];
        my $location = $sparkline->{_locations}->[$i];

        $self->xml_start_tag( 'x14:sparkline' );
        $self->xml_data_element( 'xm:f',     $range );
        $self->xml_data_element( 'xm:sqref', $location );
        $self->xml_end_tag( 'x14:sparkline' );
    }


    $self->xml_end_tag( 'x14:sparklines' );
}


##############################################################################
#
# _write_ext()
#
# Write the <ext> element.
#
sub _write_ext {

    my $self       = shift;
    my $schema     = 'http://schemas.microsoft.com/office/';
    my $xmlns_x_14 = $schema . 'spreadsheetml/2009/9/main';
    my $uri        = '{05C60535-1F16-4fd2-B633-F4F36F0B64E0}';

    my @attributes = (
        'xmlns:x14' => $xmlns_x_14,
        'uri'       => $uri,
    );

    $self->xml_start_tag( 'ext', @attributes );
}


##############################################################################
#
# _write_sparkline_groups()
#
# Write the <x14:sparklineGroups> element.
#
sub _write_sparkline_groups {

    my $self     = shift;
    my $xmlns_xm = 'http://schemas.microsoft.com/office/excel/2006/main';

    my @attributes = ( 'xmlns:xm' => $xmlns_xm );

    $self->xml_start_tag( 'x14:sparklineGroups', @attributes );

}


##############################################################################
#
# _write_sparkline_group()
#
# Write the <x14:sparklineGroup> element.
#
# Example for order.
#
# <x14:sparklineGroup
#     manualMax="0"
#     manualMin="0"
#     lineWeight="2.25"
#     type="column"
#     dateAxis="1"
#     displayEmptyCellsAs="span"
#     markers="1"
#     high="1"
#     low="1"
#     first="1"
#     last="1"
#     negative="1"
#     displayXAxis="1"
#     displayHidden="1"
#     minAxisType="custom"
#     maxAxisType="custom"
#     rightToLeft="1">
#
sub _write_sparkline_group {

    my $self     = shift;
    my $opts     = shift;
    my $empty    = $opts->{_empty};
    my $user_max = 0;
    my $user_min = 0;
    my @a;

    if ( defined $opts->{_max} ) {

        if ( $opts->{_max} eq 'group' ) {
            $opts->{_cust_max} = 'group';
        }
        else {
            push @a, ( 'manualMax' => $opts->{_max} );
            $opts->{_cust_max} = 'custom';
        }
    }

    if ( defined $opts->{_min} ) {

        if ( $opts->{_min} eq 'group' ) {
            $opts->{_cust_min} = 'group';
        }
        else {
            push @a, ( 'manualMin' => $opts->{_min} );
            $opts->{_cust_min} = 'custom';
        }
    }


    # Ignore the default type attribute (line).
    if ( $opts->{_type} ne 'line' ) {
        push @a, ( 'type' => $opts->{_type} );
    }

    push @a, ( 'lineWeight' => $opts->{_weight} ) if $opts->{_weight};
    push @a, ( 'dateAxis' => 1 ) if $opts->{_date_axis};
    push @a, ( 'displayEmptyCellsAs' => $empty ) if $empty;

    push @a, ( 'markers'       => 1 )                  if $opts->{_markers};
    push @a, ( 'high'          => 1 )                  if $opts->{_high};
    push @a, ( 'low'           => 1 )                  if $opts->{_low};
    push @a, ( 'first'         => 1 )                  if $opts->{_first};
    push @a, ( 'last'          => 1 )                  if $opts->{_last};
    push @a, ( 'negative'      => 1 )                  if $opts->{_negative};
    push @a, ( 'displayXAxis'  => 1 )                  if $opts->{_axis};
    push @a, ( 'displayHidden' => 1 )                  if $opts->{_hidden};
    push @a, ( 'minAxisType'   => $opts->{_cust_min} ) if $opts->{_cust_min};
    push @a, ( 'maxAxisType'   => $opts->{_cust_max} ) if $opts->{_cust_max};
    push @a, ( 'rightToLeft'   => 1 )                  if $opts->{_reverse};

    $self->xml_start_tag( 'x14:sparklineGroup', @a );
}


##############################################################################
#
# _write_spark_color()
#
# Helper function for the sparkline color functions below.
#
sub _write_spark_color {

    my $self    = shift;
    my $element = shift;
    my $color   = shift;
    my @attr;

    push @attr, ( 'rgb'   => $color->{_rgb} )   if defined $color->{_rgb};
    push @attr, ( 'theme' => $color->{_theme} ) if defined $color->{_theme};
    push @attr, ( 'tint'  => $color->{_tint} )  if defined $color->{_tint};

    $self->xml_empty_tag( $element, @attr );
}


##############################################################################
#
# _write_color_series()
#
# Write the <x14:colorSeries> element.
#
sub _write_color_series {

    my $self = shift;

    $self->_write_spark_color( 'x14:colorSeries', @_ );
}


##############################################################################
#
# _write_color_negative()
#
# Write the <x14:colorNegative> element.
#
sub _write_color_negative {

    my $self = shift;

    $self->_write_spark_color( 'x14:colorNegative', @_ );
}


##############################################################################
#
# _write_color_axis()
#
# Write the <x14:colorAxis> element.
#
sub _write_color_axis {

    my $self = shift;

    $self->_write_spark_color( 'x14:colorAxis', { _rgb => 'FF000000' } );
}


##############################################################################
#
# _write_color_markers()
#
# Write the <x14:colorMarkers> element.
#
sub _write_color_markers {

    my $self = shift;

    $self->_write_spark_color( 'x14:colorMarkers', @_ );
}


##############################################################################
#
# _write_color_first()
#
# Write the <x14:colorFirst> element.
#
sub _write_color_first {

    my $self = shift;

    $self->_write_spark_color( 'x14:colorFirst', @_ );
}


##############################################################################
#
# _write_color_last()
#
# Write the <x14:colorLast> element.
#
sub _write_color_last {

    my $self = shift;

    $self->_write_spark_color( 'x14:colorLast', @_ );
}


##############################################################################
#
# _write_color_high()
#
# Write the <x14:colorHigh> element.
#
sub _write_color_high {

    my $self = shift;

    $self->_write_spark_color( 'x14:colorHigh', @_ );
}


##############################################################################
#
# _write_color_low()
#
# Write the <x14:colorLow> element.
#
sub _write_color_low {

    my $self = shift;

    $self->_write_spark_color( 'x14:colorLow', @_ );
}


1;


__END__


=head1 NAME

Worksheet - A class for writing Excel Worksheets.

=head1 SYNOPSIS

See the documentation for L<Excel::Writer::XLSX>

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Writer::XLSX>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

(c) MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.
