package Excel::Writer::XLSX::Chart;

###############################################################################
#
# Chart - A class for writing Excel Charts.
#
#
# Used in conjunction with Excel::Writer::XLSX.
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
use Excel::Writer::XLSX::Format;
use Excel::Writer::XLSX::Package::XMLwriter;
use Excel::Writer::XLSX::Utility qw(xl_cell_to_rowcol
  xl_rowcol_to_cell
  xl_col_to_name xl_range
  xl_range_formula
  quote_sheetname );

our @ISA     = qw(Excel::Writer::XLSX::Package::XMLwriter);
our $VERSION = '0.95';


###############################################################################
#
# factory()
#
# Factory method for returning chart objects based on their class type.
#
sub factory {

    my $current_class  = shift;
    my $chart_subclass = shift;

    $chart_subclass = ucfirst lc $chart_subclass;

    my $module = "Excel::Writer::XLSX::Chart::" . $chart_subclass;

    eval "require $module";

    # TODO. Need to re-raise this error from Workbook::add_chart().
    die "Chart type '$chart_subclass' not supported in add_chart()\n" if $@;

    my $fh = undef;
    return $module->new( $fh, @_ );
}


###############################################################################
#
# new()
#
# Default constructor for sub-classes.
#
sub new {

    my $class = shift;
    my $fh    = shift;
    my $self  = Excel::Writer::XLSX::Package::XMLwriter->new( $fh );

    $self->{_subtype}           = shift;
    $self->{_sheet_type}        = 0x0200;
    $self->{_orientation}       = 0x0;
    $self->{_series}            = [];
    $self->{_embedded}          = 0;
    $self->{_id}                = -1;
    $self->{_series_index}      = 0;
    $self->{_style_id}          = 2;
    $self->{_axis_ids}          = [];
    $self->{_axis2_ids}         = [];
    $self->{_cat_has_num_fmt}   = 0;
    $self->{_requires_category} = 0;
    $self->{_legend_position}   = 'right';
    $self->{_cat_axis_position} = 'b';
    $self->{_val_axis_position} = 'l';
    $self->{_formula_ids}       = {};
    $self->{_formula_data}      = [];
    $self->{_horiz_cat_axis}    = 0;
    $self->{_horiz_val_axis}    = 1;
    $self->{_protection}        = 0;
    $self->{_chartarea}         = {};
    $self->{_plotarea}          = {};
    $self->{_x_axis}            = {};
    $self->{_y_axis}            = {};
    $self->{_y2_axis}           = {};
    $self->{_x2_axis}           = {};
    $self->{_chart_name}        = '';
    $self->{_show_blanks}       = 'gap';
    $self->{_show_hidden_data}  = 0;
    $self->{_show_crosses}      = 1;
    $self->{_width}             = 480;
    $self->{_height}            = 288;
    $self->{_x_scale}           = 1;
    $self->{_y_scale}           = 1;
    $self->{_x_offset}          = 0;
    $self->{_y_offset}          = 0;
    $self->{_table}             = undef;
    $self->{_smooth_allowed}    = 0;
    $self->{_cross_between}     = 'between';
    $self->{_date_category}     = 0;
    $self->{_already_inserted}  = 0;
    $self->{_combined}          = undef;
    $self->{_is_secondary}      = 0;

    $self->{_label_positions}          = {};
    $self->{_label_position_default}   = '';

    bless $self, $class;
    $self->_set_default_properties();
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

    $self->xml_declaration();

    # Write the c:chartSpace element.
    $self->_write_chart_space();

    # Write the c:lang element.
    $self->_write_lang();

    # Write the c:style element.
    $self->_write_style();

    # Write the c:protection element.
    $self->_write_protection();

    # Write the c:chart element.
    $self->_write_chart();

    # Write the c:spPr element for the chartarea formatting.
    $self->_write_sp_pr( $self->{_chartarea} );

    # Write the c:printSettings element.
    $self->_write_print_settings() if $self->{_embedded};

    # Close the worksheet tag.
    $self->xml_end_tag( 'c:chartSpace' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# Public methods.
#
###############################################################################


###############################################################################
#
# add_series()
#
# Add a series and it's properties to a chart.
#
sub add_series {

    my $self = shift;
    my %arg  = @_;

    # Check that the required input has been specified.
    if ( !exists $arg{values} ) {
        croak "Must specify 'values' in add_series()";
    }

    if ( $self->{_requires_category} && !exists $arg{categories} ) {
        croak "Must specify 'categories' in add_series() for this chart type";
    }

    # Convert aref params into a formula string.
    my $values     = $self->_aref_to_formula( $arg{values} );
    my $categories = $self->_aref_to_formula( $arg{categories} );

    # Switch name and name_formula parameters if required.
    my ( $name, $name_formula ) =
      $self->_process_names( $arg{name}, $arg{name_formula} );

    # Get an id for the data equivalent to the range formula.
    my $cat_id  = $self->_get_data_id( $categories,   $arg{categories_data} );
    my $val_id  = $self->_get_data_id( $values,       $arg{values_data} );
    my $name_id = $self->_get_data_id( $name_formula, $arg{name_data} );

    # Set the line properties for the series.
    my $line = $self->_get_line_properties( $arg{line} );

    # Allow 'border' as a synonym for 'line' in bar/column style charts.
    if ( $arg{border} ) {
        $line = $self->_get_line_properties( $arg{border} );
    }

    # Set the fill properties for the series.
    my $fill = $self->_get_fill_properties( $arg{fill} );

    # Set the pattern properties for the series.
    my $pattern = $self->_get_pattern_properties( $arg{pattern} );

    # Set the gradient fill properties for the series.
    my $gradient = $self->_get_gradient_properties( $arg{gradient} );

    # Pattern fill overrides solid fill.
    if ( $pattern ) {
        $fill = undef;
    }

    # Gradient fill overrides solid and pattern fills.
    if ( $gradient ) {
        $pattern = undef;
        $fill    = undef;
    }

    # Set the marker properties for the series.
    my $marker = $self->_get_marker_properties( $arg{marker} );

    # Set the trendline properties for the series.
    my $trendline = $self->_get_trendline_properties( $arg{trendline} );

    # Set the line smooth property for the series.
    my $smooth = $arg{smooth};

    # Set the error bars properties for the series.
    my $y_error_bars = $self->_get_error_bars_properties( $arg{y_error_bars} );
    my $x_error_bars = $self->_get_error_bars_properties( $arg{x_error_bars} );

    # Set the point properties for the series.
    my $points = $self->_get_points_properties($arg{points});

    # Set the labels properties for the series.
    my $labels = $self->_get_labels_properties( $arg{data_labels} );

    # Set the "invert if negative" fill property.
    my $invert_if_neg = $arg{invert_if_negative};

    # Set the secondary axis properties.
    my $x2_axis = $arg{x2_axis};
    my $y2_axis = $arg{y2_axis};

    # Store secondary status for combined charts.
    if ($x2_axis || $y2_axis) {
        $self->{_is_secondary} = 1;
    }

    # Set the gap for Bar/Column charts.
    if ( defined $arg{gap} ) {
        if ($y2_axis) {
            $self->{_series_gap_2} = $arg{gap};
        }
        else {
            $self->{_series_gap_1} = $arg{gap};
        }
    }

    # Set the overlap for Bar/Column charts.
    if ( defined $arg{overlap} ) {
        if ($y2_axis) {
            $self->{_series_overlap_2} = $arg{overlap};
        }
        else {
            $self->{_series_overlap_1} = $arg{overlap};
        }
    }

    # Add the user supplied data to the internal structures.
    %arg = (
        _values        => $values,
        _categories    => $categories,
        _name          => $name,
        _name_formula  => $name_formula,
        _name_id       => $name_id,
        _val_data_id   => $val_id,
        _cat_data_id   => $cat_id,
        _line          => $line,
        _fill          => $fill,
        _pattern       => $pattern,
        _gradient      => $gradient,
        _marker        => $marker,
        _trendline     => $trendline,
        _smooth        => $smooth,
        _labels        => $labels,
        _invert_if_neg => $invert_if_neg,
        _x2_axis       => $x2_axis,
        _y2_axis       => $y2_axis,
        _points        => $points,
        _error_bars =>
          { _x_error_bars => $x_error_bars, _y_error_bars => $y_error_bars },
    );


    push @{ $self->{_series} }, \%arg;
}


###############################################################################
#
# set_x_axis()
#
# Set the properties of the X-axis.
#
sub set_x_axis {

    my $self = shift;

    my $axis = $self->_convert_axis_args( $self->{_x_axis}, @_ );

    $self->{_x_axis} = $axis;
}


###############################################################################
#
# set_y_axis()
#
# Set the properties of the Y-axis.
#
sub set_y_axis {

    my $self = shift;

    my $axis = $self->_convert_axis_args( $self->{_y_axis}, @_ );

    $self->{_y_axis} = $axis;
}


###############################################################################
#
# set_x2_axis()
#
# Set the properties of the secondary X-axis.
#
sub set_x2_axis {

    my $self = shift;

    my $axis = $self->_convert_axis_args( $self->{_x2_axis}, @_ );

    $self->{_x2_axis} = $axis;
}


###############################################################################
#
# set_y2_axis()
#
# Set the properties of the secondary Y-axis.
#
sub set_y2_axis {

    my $self = shift;

    my $axis = $self->_convert_axis_args( $self->{_y2_axis}, @_ );

    $self->{_y2_axis} = $axis;
}


###############################################################################
#
# set_title()
#
# Set the properties of the chart title.
#
sub set_title {

    my $self = shift;
    my %arg  = @_;

    my ( $name, $name_formula ) =
      $self->_process_names( $arg{name}, $arg{name_formula} );

    my $data_id = $self->_get_data_id( $name_formula, $arg{data} );

    $self->{_title_name}    = $name;
    $self->{_title_formula} = $name_formula;
    $self->{_title_data_id} = $data_id;

    # Set the font properties if present.
    $self->{_title_font} = $self->_convert_font_args( $arg{name_font} );

    # Set the title layout.
    $self->{_title_layout} = $self->_get_layout_properties( $arg{layout}, 1 );

    # Set the title overlay option.
    $self->{_title_overlay} = $arg{overlay};

    # Set the no automatic title option.
    $self->{_title_none} = $arg{none};
}


###############################################################################
#
# set_legend()
#
# Set the properties of the chart legend.
#
sub set_legend {

    my $self = shift;
    my %arg  = @_;

    $self->{_legend_position}      = $arg{position} || 'right';
    $self->{_legend_delete_series} = $arg{delete_series};
    $self->{_legend_font}          = $self->_convert_font_args( $arg{font} );

    # Set the legend layout.
    $self->{_legend_layout} = $self->_get_layout_properties( $arg{layout} );

    # Turn off the legend.
    if ( $arg{none} ) {
        $self->{_legend_position} = 'none';
    }
}


###############################################################################
#
# set_plotarea()
#
# Set the properties of the chart plotarea.
#
sub set_plotarea {

    my $self = shift;

    # Convert the user defined properties to internal properties.
    $self->{_plotarea} = $self->_get_area_properties( @_ );
}


###############################################################################
#
# set_chartarea()
#
# Set the properties of the chart chartarea.
#
sub set_chartarea {

    my $self = shift;

    # Convert the user defined properties to internal properties.
    $self->{_chartarea} = $self->_get_area_properties( @_ );
}


###############################################################################
#
# set_style()
#
# Set on of the 48 built-in Excel chart styles. The default style is 2.
#
sub set_style {

    my $self = shift;
    my $style_id = defined $_[0] ? $_[0] : 2;

    if ( $style_id < 0 || $style_id > 48 ) {
        $style_id = 2;
    }

    $self->{_style_id} = $style_id;
}


###############################################################################
#
# show_blanks_as()
#
# Set the option for displaying blank data in a chart. The default is 'gap'.
#
sub show_blanks_as {

    my $self   = shift;
    my $option = shift;

    return unless $option;

    my %valid = (
        gap  => 1,
        zero => 1,
        span => 1,

    );

    if ( !exists $valid{$option} ) {
        warn "Unknown show_blanks_as() option '$option'\n";
        return;
    }

    $self->{_show_blanks} = $option;
}


###############################################################################
#
# show_hidden_data()
#
# Display data in hidden rows or columns.
#
sub show_hidden_data {

    my $self = shift;

    $self->{_show_hidden_data} = 1;
}


###############################################################################
#
# set_size()
#
# Set dimensions or scale for the chart.
#
sub set_size {

    my $self = shift;
    my %args = @_;

    $self->{_width}    = $args{width}    if $args{width};
    $self->{_height}   = $args{height}   if $args{height};
    $self->{_x_scale}  = $args{x_scale}  if $args{x_scale};
    $self->{_y_scale}  = $args{y_scale}  if $args{y_scale};
    $self->{_x_offset} = $args{x_offset} if $args{x_offset};
    $self->{_y_offset} = $args{y_offset} if $args{y_offset};

}

# Backward compatibility with poorly chosen method name.
*size = *set_size;


###############################################################################
#
# set_table()
#
# Set properties for an axis data table.
#
sub set_table {

    my $self = shift;
    my %args = @_;

    my %table = (
        _horizontal => 1,
        _vertical   => 1,
        _outline    => 1,
        _show_keys  => 0,
    );

    $table{_horizontal} = $args{horizontal} if defined $args{horizontal};
    $table{_vertical}   = $args{vertical}   if defined $args{vertical};
    $table{_outline}    = $args{outline}    if defined $args{outline};
    $table{_show_keys}  = $args{show_keys}  if defined $args{show_keys};
    $table{_font}       = $self->_convert_font_args( $args{font} );

    $self->{_table} = \%table;
}


###############################################################################
#
# set_up_down_bars()
#
# Set properties for the chart up-down bars.
#
sub set_up_down_bars {

    my $self = shift;
    my %args = @_;

    # Map border to line.
    if ( defined $args{up}->{border} ) {
        $args{up}->{line} = $args{up}->{border};
    }
    if ( defined $args{down}->{border} ) {
        $args{down}->{line} = $args{down}->{border};
    }

    # Set the up and down bar properties.
    my $up_line   = $self->_get_line_properties( $args{up}->{line} );
    my $down_line = $self->_get_line_properties( $args{down}->{line} );
    my $up_fill   = $self->_get_fill_properties( $args{up}->{fill} );
    my $down_fill = $self->_get_fill_properties( $args{down}->{fill} );

    $self->{_up_down_bars} = {
        _up => {
            _line => $up_line,
            _fill => $up_fill,
        },
        _down => {
            _line => $down_line,
            _fill => $down_fill,
        },
    };
}


###############################################################################
#
# set_drop_lines()
#
# Set properties for the chart drop lines.
#
sub set_drop_lines {

    my $self = shift;
    my %args = @_;

    # Set the drop line properties.
    my $line = $self->_get_line_properties( $args{line} );

    $self->{_drop_lines} = { _line => $line };
}


###############################################################################
#
# set_high_low_lines()
#
# Set properties for the chart high-low lines.
#
sub set_high_low_lines {

    my $self = shift;
    my %args = @_;

    # Set the drop line properties.
    my $line = $self->_get_line_properties( $args{line} );

    $self->{_hi_low_lines} = { _line => $line };
}


###############################################################################
#
# combine()
#
# Add another chart to create a combined chart.
#
sub combine {

    my $self  = shift;
    my $chart = shift;

    $self->{_combined} = $chart;
}


###############################################################################
#
# Internal methods. The following section of methods are used for the internal
# structuring of the Chart object and file format.
#
###############################################################################


###############################################################################
#
# _convert_axis_args()
#
# Convert user defined axis values into private hash values.
#
sub _convert_axis_args {

    my $self = shift;
    my $axis = shift;
    my %arg  = ( %{ $axis->{_defaults} }, @_ );

    my ( $name, $name_formula ) =
      $self->_process_names( $arg{name}, $arg{name_formula} );

    my $data_id = $self->_get_data_id( $name_formula, $arg{data} );

    $axis = {
        _defaults          => $axis->{_defaults},
        _name              => $name,
        _formula           => $name_formula,
        _data_id           => $data_id,
        _reverse           => $arg{reverse},
        _min               => $arg{min},
        _max               => $arg{max},
        _minor_unit        => $arg{minor_unit},
        _major_unit        => $arg{major_unit},
        _minor_unit_type   => $arg{minor_unit_type},
        _major_unit_type   => $arg{major_unit_type},
        _log_base          => $arg{log_base},
        _crossing          => $arg{crossing},
        _position_axis     => $arg{position_axis},
        _position          => $arg{position},
        _label_position    => $arg{label_position},
        _num_format        => $arg{num_format},
        _num_format_linked => $arg{num_format_linked},
        _interval_unit     => $arg{interval_unit},
        _interval_tick     => $arg{interval_tick},
        _visible           => defined $arg{visible} ? $arg{visible} : 1,
        _text_axis         => 0,
    };

    # Map major_gridlines properties.
    if ( $arg{major_gridlines} && $arg{major_gridlines}->{visible} ) {
        $axis->{_major_gridlines} =
          $self->_get_gridline_properties( $arg{major_gridlines} );
    }

    # Map minor_gridlines properties.
    if ( $arg{minor_gridlines} && $arg{minor_gridlines}->{visible} ) {
        $axis->{_minor_gridlines} =
          $self->_get_gridline_properties( $arg{minor_gridlines} );
    }

    # Convert the display units.
    $axis->{_display_units} = $self->_get_display_units( $arg{display_units} );
    if ( defined $arg{display_units_visible} ) {
        $axis->{_display_units_visible} = $arg{display_units_visible};
    }
    else {
        $axis->{_display_units_visible} = 1;
    }

    # Only use the first letter of bottom, top, left or right.
    if ( defined $axis->{_position} ) {
        $axis->{_position} = substr lc $axis->{_position}, 0, 1;
    }

    # Set the position for a category axis on or between the tick marks.
    if ( defined $axis->{_position_axis} ) {
        if ( $axis->{_position_axis} eq 'on_tick' ) {
            $axis->{_position_axis} = 'midCat';
        }
        elsif ( $axis->{_position_axis} eq 'between' ) {

            # Doesn't need to be modified.
        }
        else {
            # Otherwise use the default value.
            $axis->{_position_axis} = undef;
        }
    }

    # Set the category axis as a date axis.
    if ( $arg{date_axis} ) {
        $self->{_date_category} = 1;
    }

    # Set the category axis as a text axis.
    if ( $arg{text_axis} ) {
        $self->{_date_category} = 0;
        $axis->{_text_axis} = 1;
    }


    # Set the font properties if present.
    $axis->{_num_font}  = $self->_convert_font_args( $arg{num_font} );
    $axis->{_name_font} = $self->_convert_font_args( $arg{name_font} );

    # Set the axis name layout.
    $axis->{_layout} = $self->_get_layout_properties( $arg{name_layout}, 1 );

    # Set the line properties for the axis.
    $axis->{_line} = $self->_get_line_properties( $arg{line} );

    # Set the fill properties for the axis.
    $axis->{_fill} = $self->_get_fill_properties( $arg{fill} );

    # Set the tick marker types.
    $axis->{_minor_tick_mark} = $self->_get_tick_type($arg{minor_tick_mark});
    $axis->{_major_tick_mark} = $self->_get_tick_type($arg{major_tick_mark});


    return $axis;
}


###############################################################################
#
# _convert_fonts_args()
#
# Convert user defined font values into private hash values.
#
sub _convert_font_args {

    my $self = shift;
    my $args = shift;

    return unless $args;

    my $font = {
        _name         => $args->{name},
        _color        => $args->{color},
        _size         => $args->{size},
        _bold         => $args->{bold},
        _italic       => $args->{italic},
        _underline    => $args->{underline},
        _pitch_family => $args->{pitch_family},
        _charset      => $args->{charset},
        _baseline     => $args->{baseline} || 0,
        _rotation     => $args->{rotation},
    };

    # Convert font size units.
    $font->{_size} *= 100 if $font->{_size};

    # Convert rotation into 60,000ths of a degree.
    if ( $font->{_rotation} ) {
        $font->{_rotation} = 60_000 * int( $font->{_rotation} );
    }

    return $font;
}


###############################################################################
#
# _aref_to_formula()
#
# Convert and aref of row col values to a range formula.
#
sub _aref_to_formula {

    my $self = shift;
    my $data = shift;

    # If it isn't an array ref it is probably a formula already.
    return $data if !ref $data;

    my $formula = xl_range_formula( @$data );

    return $formula;
}


###############################################################################
#
# _process_names()
#
# Switch name and name_formula parameters if required.
#
sub _process_names {

    my $self         = shift;
    my $name         = shift;
    my $name_formula = shift;

    if ( defined $name ) {

        if ( ref $name eq 'ARRAY' ) {
            my $cell = xl_rowcol_to_cell( $name->[1], $name->[2], 1, 1 );
            $name_formula = quote_sheetname( $name->[0] ) . '!' . $cell;
            $name         = '';
        }
        elsif ( $name =~ m/^=[^!]+!\$/ ) {

            # Name looks like a formula, use it to set name_formula.
            $name_formula = $name;
            $name         = '';
        }
    }

    return ( $name, $name_formula );
}


###############################################################################
#
# _get_data_type()
#
# Find the overall type of the data associated with a series.
#
# TODO. Need to handle date type.
#
sub _get_data_type {

    my $self = shift;
    my $data = shift;

    # Check for no data in the series.
    return 'none' if !defined $data;
    return 'none' if @$data == 0;

    if (ref $data->[0] eq 'ARRAY') {
        return 'multi_str'
    }

    # If the token isn't a number assume it is a string.
    for my $token ( @$data ) {
        next if !defined $token;
        return 'str'
          if $token !~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/;
    }

    # The series data was all numeric.
    return 'num';
}


###############################################################################
#
# _get_data_id()
#
# Assign an id to a each unique series formula or title/axis formula. Repeated
# formulas such as for categories get the same id. If the series or title
# has user specified data associated with it then that is also stored. This
# data is used to populate cached Excel data when creating a chart.
# If there is no user defined data then it will be populated by the parent
# workbook in Workbook::_add_chart_data()
#
sub _get_data_id {

    my $self    = shift;
    my $formula = shift;
    my $data    = shift;
    my $id;

    # Ignore series without a range formula.
    return unless $formula;

    # Strip the leading '=' from the formula.
    $formula =~ s/^=//;

    # Store the data id in a hash keyed by the formula and store the data
    # in a separate array with the same id.
    if ( !exists $self->{_formula_ids}->{$formula} ) {

        # Haven't seen this formula before.
        $id = @{ $self->{_formula_data} };

        push @{ $self->{_formula_data} }, $data;
        $self->{_formula_ids}->{$formula} = $id;
    }
    else {

        # Formula already seen. Return existing id.
        $id = $self->{_formula_ids}->{$formula};

        # Store user defined data if it isn't already there.
        if ( !defined $self->{_formula_data}->[$id] ) {
            $self->{_formula_data}->[$id] = $data;
        }
    }

    return $id;
}


###############################################################################
#
# _get_color()
#
# Convert the user specified colour index or string to a rgb colour.
#
sub _get_color {

    my $self  = shift;
    my $color = shift;

    # Convert a HTML style #RRGGBB color.
    if ( defined $color and $color =~ /^#[0-9a-fA-F]{6}$/ ) {
        $color =~ s/^#//;
        return uc $color;
    }

    my $index = &Excel::Writer::XLSX::Format::_get_color( $color );

    # Set undefined colors to black.
    if ( !$index ) {
        $index = 0x08;
        warn "Unknown color '$color' used in chart formatting. "
          . "Converting to black.\n";
    }

    return $self->_get_palette_color( $index );
}


###############################################################################
#
# _get_palette_color()
#
# Convert from an Excel internal colour index to a XML style #RRGGBB index
# based on the default or user defined values in the Workbook palette.
# Note: This version doesn't add an alpha channel.
#
sub _get_palette_color {

    my $self    = shift;
    my $index   = shift;
    my $palette = $self->{_palette};

    # Adjust the colour index.
    $index -= 8;

    # Palette is passed in from the Workbook class.
    my @rgb = @{ $palette->[$index] };

    return sprintf "%02X%02X%02X", @rgb[0, 1, 2];
}


###############################################################################
#
# _get_swe_line_pattern()
#
# Get the Spreadsheet::WriteExcel line pattern for backward compatibility.
#
sub _get_swe_line_pattern {

    my $self    = shift;
    my $value   = lc shift;
    my $default = 'solid';
    my $pattern;

    my %patterns = (
        0              => 'solid',
        1              => 'dash',
        2              => 'dot',
        3              => 'dash_dot',
        4              => 'long_dash_dot_dot',
        5              => 'none',
        6              => 'solid',
        7              => 'solid',
        8              => 'solid',
        'solid'        => 'solid',
        'dash'         => 'dash',
        'dot'          => 'dot',
        'dash-dot'     => 'dash_dot',
        'dash-dot-dot' => 'long_dash_dot_dot',
        'none'         => 'none',
        'dark-gray'    => 'solid',
        'medium-gray'  => 'solid',
        'light-gray'   => 'solid',
    );

    if ( exists $patterns{$value} ) {
        $pattern = $patterns{$value};
    }
    else {
        $pattern = $default;
    }

    return $pattern;
}


###############################################################################
#
# _get_swe_line_weight()
#
# Get the Spreadsheet::WriteExcel line weight for backward compatibility.
#
sub _get_swe_line_weight {

    my $self    = shift;
    my $value   = lc shift;
    my $default = 1;
    my $weight;

    my %weights = (
        1          => 0.25,
        2          => 1,
        3          => 2,
        4          => 3,
        'hairline' => 0.25,
        'narrow'   => 1,
        'medium'   => 2,
        'wide'     => 3,
    );

    if ( exists $weights{$value} ) {
        $weight = $weights{$value};
    }
    else {
        $weight = $default;
    }

    return $weight;
}


###############################################################################
#
# _get_line_properties()
#
# Convert user defined line properties to the structure required internally.
#
sub _get_line_properties {

    my $self = shift;
    my $line = shift;

    return { _defined => 0 } unless $line;

    # Copy the user supplied properties.
    $line = { %$line };

    my %dash_types = (
        solid               => 'solid',
        round_dot           => 'sysDot',
        square_dot          => 'sysDash',
        dash                => 'dash',
        dash_dot            => 'dashDot',
        long_dash           => 'lgDash',
        long_dash_dot       => 'lgDashDot',
        long_dash_dot_dot   => 'lgDashDotDot',
        dot                 => 'dot',
        system_dash_dot     => 'sysDashDot',
        system_dash_dot_dot => 'sysDashDotDot',
    );

    # Check the dash type.
    my $dash_type = $line->{dash_type};

    if ( defined $dash_type ) {
        if ( exists $dash_types{$dash_type} ) {
            $line->{dash_type} = $dash_types{$dash_type};
        }
        else {
            warn "Unknown dash type '$dash_type'\n";
            return;
        }
    }

    $line->{_defined} = 1;

    return $line;
}


###############################################################################
#
# _get_fill_properties()
#
# Convert user defined fill properties to the structure required internally.
#
sub _get_fill_properties {

    my $self = shift;
    my $fill = shift;

    return { _defined => 0 } unless $fill;

    $fill->{_defined} = 1;

    return $fill;
}


###############################################################################
#
# _get_pattern_properties()
#
# Convert user defined pattern properties to the structure required internally.
#
sub _get_pattern_properties {

    my $self    = shift;
    my $args    = shift;
    my $pattern = {};

    return unless $args;

    # Check the pattern type is present.
    if ( !$args->{pattern} ) {
        carp "Pattern must include 'pattern'";
        return;
    }

    # Check the foreground color is present.
    if ( !$args->{fg_color} ) {
        carp "Pattern must include 'fg_color'";
        return;
    }

    my %types = (
        'percent_5'                 => 'pct5',
        'percent_10'                => 'pct10',
        'percent_20'                => 'pct20',
        'percent_25'                => 'pct25',
        'percent_30'                => 'pct30',
        'percent_40'                => 'pct40',

        'percent_50'                => 'pct50',
        'percent_60'                => 'pct60',
        'percent_70'                => 'pct70',
        'percent_75'                => 'pct75',
        'percent_80'                => 'pct80',
        'percent_90'                => 'pct90',

        'light_downward_diagonal'   => 'ltDnDiag',
        'light_upward_diagonal'     => 'ltUpDiag',
        'dark_downward_diagonal'    => 'dkDnDiag',
        'dark_upward_diagonal'      => 'dkUpDiag',
        'wide_downward_diagonal'    => 'wdDnDiag',
        'wide_upward_diagonal'      => 'wdUpDiag',

        'light_vertical'            => 'ltVert',
        'light_horizontal'          => 'ltHorz',
        'narrow_vertical'           => 'narVert',
        'narrow_horizontal'         => 'narHorz',
        'dark_vertical'             => 'dkVert',
        'dark_horizontal'           => 'dkHorz',

        'dashed_downward_diagonal'  => 'dashDnDiag',
        'dashed_upward_diagonal'    => 'dashUpDiag',
        'dashed_horizontal'         => 'dashHorz',
        'dashed_vertical'           => 'dashVert',
        'small_confetti'            => 'smConfetti',
        'large_confetti'            => 'lgConfetti',

        'zigzag'                    => 'zigZag',
        'wave'                      => 'wave',
        'diagonal_brick'            => 'diagBrick',
        'horizontal_brick'          => 'horzBrick',
        'weave'                     => 'weave',
        'plaid'                     => 'plaid',

        'divot'                     => 'divot',
        'dotted_grid'               => 'dotGrid',
        'dotted_diamond'            => 'dotDmnd',
        'shingle'                   => 'shingle',
        'trellis'                   => 'trellis',
        'sphere'                    => 'sphere',

        'small_grid'                => 'smGrid',
        'large_grid'                => 'lgGrid',
        'small_check'               => 'smCheck',
        'large_check'               => 'lgCheck',
        'outlined_diamond'          => 'openDmnd',
        'solid_diamond'             => 'solidDmnd',
    );

    # Check for valid types.
    my $pattern_type = $args->{pattern};

    if ( exists $types{$pattern_type} ) {
        $pattern->{pattern} = $types{$pattern_type};
    }
    else {
        carp "Unknown pattern type '$pattern_type'";
        return;
    }

    # Specify a default background color.
    if ( !$args->{bg_color} ) {
        $pattern->{bg_color} = '#FFFFFF';
    }
    else {
        $pattern->{bg_color} = $args->{bg_color};
    }

    $pattern->{fg_color} = $args->{fg_color};

    return $pattern;
}


###############################################################################
#
# _get_gradient_properties()
#
# Convert user defined gradient to the structure required internally.
#
sub _get_gradient_properties {

    my $self     = shift;
    my $args     = shift;
    my $gradient = {};

    my %types    = (
        linear      => 'linear',
        radial      => 'circle',
        rectangular => 'rect',
        path        => 'shape'
    );

    return unless $args;

    # Check the colors array exists and is valid.
    if ( !$args->{colors} || ref $args->{colors} ne 'ARRAY' ) {
        carp "Gradient must include colors array";
        return;
    }

    # Check the colors array has the required number of entries.
    if ( @{ $args->{colors} } < 2 ) {
        carp "Gradient colors array must at least 2 values";
        return;
    }

    $gradient->{_colors} = $args->{colors};

    if ( $args->{positions} ) {

        # Check the positions array has the right number of entries.
        if ( @{ $args->{positions} } != @{ $args->{colors} } ) {
            carp "Gradient positions not equal to number of colors";
            return;
        }

        # Check the positions are in the correct range.
        for my $pos ( @{ $args->{positions} } ) {
            if ( $pos < 0 || $pos > 100 ) {
                carp "Gradient position '", $pos,
                  "' must be in range 0 <= pos <= 100";
                return;
            }
        }

        $gradient->{_positions} = $args->{positions};
    }
    else {
        # Use the default gradient positions.
        if ( @{ $args->{colors} } == 2 ) {
            $gradient->{_positions} = [ 0, 100 ];
        }
        elsif ( @{ $args->{colors} } == 3 ) {
            $gradient->{_positions} = [ 0, 50, 100 ];
        }
        elsif ( @{ $args->{colors} } == 4 ) {
            $gradient->{_positions} = [ 0, 33, 66, 100 ];
        }
        else {
            carp "Must specify gradient positions";
            return;
        }
    }

    # Set the gradient angle.
    if ( defined $args->{angle} ) {
        my $angle = $args->{angle};

        if ( $angle < 0 || $angle > 359.9 ) {
            carp "Gradient angle '", $angle,
              "' must be in range 0 <= pos < 360";
            return;
        }
        $gradient->{_angle} = $angle;
    }
    else {
        $gradient->{_angle} = 90;
    }

    # Set the gradient type.
    if ( defined $args->{type} ) {
        my $type = $args->{type};

        if ( !exists $types{$type} ) {
            carp "Unknown gradient type '", $type, "'";
            return;
        }
        $gradient->{_type} = $types{$type};
    }
    else {
        $gradient->{_type} = 'linear';
    }

    return $gradient;
}


###############################################################################
#
# _get_marker_properties()
#
# Convert user defined marker properties to the structure required internally.
#
sub _get_marker_properties {

    my $self   = shift;
    my $marker = shift;

    return if !$marker && ref $marker ne 'HASH';

    # Copy the user supplied properties.
    $marker = { %$marker };

    my %types = (
        automatic  => 'automatic',
        none       => 'none',
        square     => 'square',
        diamond    => 'diamond',
        triangle   => 'triangle',
        x          => 'x',
        star       => 'star',
        dot        => 'dot',
        short_dash => 'dot',
        dash       => 'dash',
        long_dash  => 'dash',
        circle     => 'circle',
        plus       => 'plus',
        picture    => 'picture',
    );

    # Check for valid types.
    my $marker_type = $marker->{type};

    if ( defined $marker_type ) {
        if ( $marker_type eq 'automatic' ) {
            $marker->{automatic} = 1;
        }

        if ( exists $types{$marker_type} ) {
            $marker->{type} = $types{$marker_type};
        }
        else {
            warn "Unknown marker type '$marker_type'\n";
            return;
        }
    }

    # Set the line properties for the marker..
    my $line = $self->_get_line_properties( $marker->{line} );

    # Allow 'border' as a synonym for 'line'.
    if ( $marker->{border} ) {
        $line = $self->_get_line_properties( $marker->{border} );
    }

    # Set the fill properties for the marker.
    my $fill = $self->_get_fill_properties( $marker->{fill} );

    # Set the pattern properties for the series.
    my $pattern = $self->_get_pattern_properties( $marker->{pattern} );

    # Set the gradient fill properties for the series.
    my $gradient = $self->_get_gradient_properties( $marker->{gradient} );

    # Pattern fill overrides solid fill.
    if ( $pattern ) {
        $fill = undef;
    }

    # Gradient fill overrides solid and pattern fills.
    if ( $gradient ) {
        $pattern = undef;
        $fill    = undef;
    }

    $marker->{_line}     = $line;
    $marker->{_fill}     = $fill;
    $marker->{_pattern}  = $pattern;
    $marker->{_gradient} = $gradient;

    return $marker;
}


###############################################################################
#
# _get_trendline_properties()
#
# Convert user defined trendline properties to the structure required
# internally.
#
sub _get_trendline_properties {

    my $self      = shift;
    my $trendline = shift;

    return if !$trendline && ref $trendline ne 'HASH';

    # Copy the user supplied properties.
    $trendline = { %$trendline };

    my %types = (
        exponential    => 'exp',
        linear         => 'linear',
        log            => 'log',
        moving_average => 'movingAvg',
        polynomial     => 'poly',
        power          => 'power',
    );

    # Check the trendline type.
    my $trend_type = $trendline->{type};

    if ( exists $types{$trend_type} ) {
        $trendline->{type} = $types{$trend_type};
    }
    else {
        warn "Unknown trendline type '$trend_type'\n";
        return;
    }

    # Set the line properties for the trendline..
    my $line = $self->_get_line_properties( $trendline->{line} );

    # Allow 'border' as a synonym for 'line'.
    if ( $trendline->{border} ) {
        $line = $self->_get_line_properties( $trendline->{border} );
    }

    # Set the fill properties for the trendline.
    my $fill = $self->_get_fill_properties( $trendline->{fill} );

    # Set the pattern properties for the series.
    my $pattern = $self->_get_pattern_properties( $trendline->{pattern} );

    # Set the gradient fill properties for the series.
    my $gradient = $self->_get_gradient_properties( $trendline->{gradient} );

    # Pattern fill overrides solid fill.
    if ( $pattern ) {
        $fill = undef;
    }

    # Gradient fill overrides solid and pattern fills.
    if ( $gradient ) {
        $pattern = undef;
        $fill    = undef;
    }

    $trendline->{_line}     = $line;
    $trendline->{_fill}     = $fill;
    $trendline->{_pattern}  = $pattern;
    $trendline->{_gradient} = $gradient;

    return $trendline;
}


###############################################################################
#
# _get_error_bars_properties()
#
# Convert user defined error bars properties to structure required internally.
#
sub _get_error_bars_properties {

    my $self = shift;
    my $args = shift;

    return if !$args && ref $args ne 'HASH';

    # Copy the user supplied properties.
    $args = { %$args };


    # Default values.
    my $error_bars = {
        _type         => 'fixedVal',
        _value        => 1,
        _endcap       => 1,
        _direction    => 'both',
        _plus_values  => [1],
        _minus_values => [1],
        _plus_data    => [],
        _minus_data   => [],
    };

    my %types = (
        fixed              => 'fixedVal',
        percentage         => 'percentage',
        standard_deviation => 'stdDev',
        standard_error     => 'stdErr',
        custom             => 'cust',
    );

    # Check the error bars type.
    my $error_type = $args->{type};

    if ( exists $types{$error_type} ) {
        $error_bars->{_type} = $types{$error_type};
    }
    else {
        warn "Unknown error bars type '$error_type'\n";
        return;
    }

    # Set the value for error types that require it.
    if ( defined $args->{value} ) {
        $error_bars->{_value} = $args->{value};
    }

    # Set the end-cap style.
    if ( defined $args->{end_style} ) {
        $error_bars->{_endcap} = $args->{end_style};
    }

    # Set the error bar direction.
    if ( defined $args->{direction} ) {
        if ( $args->{direction} eq 'minus' ) {
            $error_bars->{_direction} = 'minus';
        }
        elsif ( $args->{direction} eq 'plus' ) {
            $error_bars->{_direction} = 'plus';
        }
        else {
            # Default to 'both'.
        }
    }

    # Set any custom values.
    if ( defined $args->{plus_values} ) {
        $error_bars->{_plus_values} = $args->{plus_values};
    }
    if ( defined $args->{minus_values} ) {
        $error_bars->{_minus_values} = $args->{minus_values};
    }
    if ( defined $args->{plus_data} ) {
        $error_bars->{_plus_data} = $args->{plus_data};
    }
    if ( defined $args->{minus_data} ) {
        $error_bars->{_minus_data} = $args->{minus_data};
    }

    # Set the line properties for the error bars.
    $error_bars->{_line} = $self->_get_line_properties( $args->{line} );

    return $error_bars;
}


###############################################################################
#
# _get_gridline_properties()
#
# Convert user defined gridline properties to the structure required internally.
#
sub _get_gridline_properties {

    my $self = shift;
    my $args = shift;
    my $gridline;

    # Set the visible property for the gridline.
    $gridline->{_visible} = $args->{visible};

    # Set the line properties for the gridline..
    $gridline->{_line} = $self->_get_line_properties( $args->{line} );

    return $gridline;
}


###############################################################################
#
# _get_labels_properties()
#
# Convert user defined labels properties to the structure required internally.
#
sub _get_labels_properties {

    my $self   = shift;
    my $labels = shift;

    return if !$labels && ref $labels ne 'HASH';

    # Copy the user supplied properties.
    $labels = { %$labels };

    # Map user defined label positions to Excel positions.
    if ( my $position = $labels->{position} ) {

        if ( exists $self->{_label_positions}->{$position} ) {
            if ($position eq $self->{_label_position_default}) {
                $labels->{position} = undef;
            }
            else {
                $labels->{position} = $self->{_label_positions}->{$position};
            }
        }
        else {
            carp "Unsupported label position '$position' for this chart type";
            return undef
        }
    }

    # Map the user defined label separator to the Excel separator.
    if ( my $separator = $labels->{separator} ) {

        my %separators = (
            ','  => ', ',
            ';'  => '; ',
            '.'  => '. ',
            "\n" => "\n",
            ' '  => ' '
        );

        if ( exists $separators{$separator} ) {
            $labels->{separator} = $separators{$separator};
        }
        else {
            carp "Unsupported label separator";
            return undef
        }
    }

    if ($labels->{font}) {
        $labels->{font} = $self->_convert_font_args( $labels->{font} );
    }

    return $labels;
}


###############################################################################
#
# _get_area_properties()
#
# Convert user defined area properties to the structure required internally.
#
sub _get_area_properties {

    my $self = shift;
    my %arg  = @_;
    my $area = {};


    # Map deprecated Spreadsheet::WriteExcel fill colour.
    if ( $arg{color} ) {
        $arg{fill}->{color} = $arg{color};
    }

    # Map deprecated Spreadsheet::WriteExcel line_weight.
    if ( $arg{line_weight} ) {
        my $width = $self->_get_swe_line_weight( $arg{line_weight} );
        $arg{border}->{width} = $width;
    }

    # Map deprecated Spreadsheet::WriteExcel line_pattern.
    if ( $arg{line_pattern} ) {
        my $pattern = $self->_get_swe_line_pattern( $arg{line_pattern} );

        if ( $pattern eq 'none' ) {
            $arg{border}->{none} = 1;
        }
        else {
            $arg{border}->{dash_type} = $pattern;
        }
    }

    # Map deprecated Spreadsheet::WriteExcel line colour.
    if ( $arg{line_color} ) {
        $arg{border}->{color} = $arg{line_color};
    }


    # Handle Excel::Writer::XLSX style properties.

    # Set the line properties for the chartarea.
    my $line = $self->_get_line_properties( $arg{line} );

    # Allow 'border' as a synonym for 'line'.
    if ( $arg{border} ) {
        $line = $self->_get_line_properties( $arg{border} );
    }

    # Set the fill properties for the chartarea.
    my $fill = $self->_get_fill_properties( $arg{fill} );

    # Set the pattern properties for the series.
    my $pattern = $self->_get_pattern_properties( $arg{pattern} );

    # Set the gradient fill properties for the series.
    my $gradient = $self->_get_gradient_properties( $arg{gradient} );

    # Pattern fill overrides solid fill.
    if ( $pattern ) {
        $fill = undef;
    }

    # Gradient fill overrides solid and pattern fills.
    if ( $gradient ) {
        $pattern = undef;
        $fill    = undef;
    }

    # Set the plotarea layout.
    my $layout = $self->_get_layout_properties( $arg{layout} );

    $area->{_line}     = $line;
    $area->{_fill}     = $fill;
    $area->{_pattern}  = $pattern;
    $area->{_gradient} = $gradient;
    $area->{_layout}   = $layout;

    return $area;
}


###############################################################################
#
# _get_layout_properties()
#
# Convert user defined layout properties to the format required internally.
#
sub _get_layout_properties {

    my $self    = shift;
    my $args    = shift;
    my $is_text = shift;
    my $layout  = {};
    my @properties;
    my %allowable;

    return if !$args;

    if ( $is_text ) {
        @properties = ( 'x', 'y' );
    }
    else {
        @properties = ( 'x', 'y', 'width', 'height' );
    }

    # Check for valid properties.
    @allowable{@properties} = undef;

    for my $key ( keys %$args ) {

        if ( !exists $allowable{$key} ) {
            warn "Property '$key' not allowed in layout options\n";
            return;
        }
    }

    # Set the layout properties.
    for my $property ( @properties ) {

        if ( !exists $args->{$property} ) {
            warn "Property '$property' must be specified in layout options\n";
            return;
        }

        my $value = $args->{$property};

        if ( $value !~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/ ) {
            warn "Property '$property' value '$value' must be numeric"
              . " in layout options\n";
            return;
        }

        if ( $value < 0 || $value > 1 ) {
            warn "Property '$property' value '$value' must be in range "
              . "0 < x <= 1 in layout options\n";
            return;
        }

        # Convert to the format used by Excel for easier testing
        $layout->{$property} = sprintf "%.17g", $value;
    }

    return $layout;
}


###############################################################################
#
# _get_points_properties()
#
# Convert user defined points properties to structure required internally.
#
sub _get_points_properties {

    my $self        = shift;
    my $user_points = shift;
    my @points;

    return unless $user_points;

    for my $user_point ( @$user_points ) {

        my $point;

        if ( defined $user_point ) {

            # Set the line properties for the point.
            my $line = $self->_get_line_properties( $user_point->{line} );

            # Allow 'border' as a synonym for 'line'.
            if ( $user_point->{border} ) {
                $line = $self->_get_line_properties( $user_point->{border} );
            }

            # Set the fill properties for the chartarea.
            my $fill = $self->_get_fill_properties( $user_point->{fill} );


            # Set the pattern properties for the series.
            my $pattern =
              $self->_get_pattern_properties( $user_point->{pattern} );

            # Set the gradient fill properties for the series.
            my $gradient =
              $self->_get_gradient_properties( $user_point->{gradient} );

            # Pattern fill overrides solid fill.
            if ( $pattern ) {
                $fill = undef;
            }

            # Gradient fill overrides solid and pattern fills.
            if ( $gradient ) {
                $pattern = undef;
                $fill    = undef;
            }
                        # Gradient fill overrides solid fill.
            if ( $gradient ) {
                $fill = undef;
            }

            $point->{_line}     = $line;
            $point->{_fill}     = $fill;
            $point->{_pattern}  = $pattern;
            $point->{_gradient} = $gradient;
        }

        push @points, $point;
    }

    return \@points;
}


###############################################################################
#
# _get_display_units()
#
# Convert user defined display units to internal units.
#
sub _get_display_units {

    my $self          = shift;
    my $display_units = shift;

    return if !$display_units;

    my %types = (
        'hundreds'          => 'hundreds',
        'thousands'         => 'thousands',
        'ten_thousands'     => 'tenThousands',
        'hundred_thousands' => 'hundredThousands',
        'millions'          => 'millions',
        'ten_millions'      => 'tenMillions',
        'hundred_millions'  => 'hundredMillions',
        'billions'          => 'billions',
        'trillions'         => 'trillions',
    );

    if ( exists $types{$display_units} ) {
        $display_units = $types{$display_units};
    }
    else {
        warn "Unknown display_units type '$display_units'\n";
        return;
    }

    return $display_units;
}



###############################################################################
#
# _get_tick_type()
#
# Convert user tick types to internal units.
#
sub _get_tick_type {

    my $self      = shift;
    my $tick_type = shift;

    return if !$tick_type;

    my %types = (
        'outside' => 'out',
        'inside'  => 'in',
        'none'    => 'none',
        'cross'   => 'cross',
    );

    if ( exists $types{$tick_type} ) {
        $tick_type = $types{$tick_type};
    }
    else {
        warn "Unknown tick_type type '$tick_type'\n";
        return;
    }

    return $tick_type;
}


###############################################################################
#
# _get_primary_axes_series()
#
# Returns series which use the primary axes.
#
sub _get_primary_axes_series {

    my $self = shift;
    my @primary_axes_series;

    for my $series ( @{ $self->{_series} } ) {
        push @primary_axes_series, $series unless $series->{_y2_axis};
    }

    return @primary_axes_series;
}


###############################################################################
#
# _get_secondary_axes_series()
#
# Returns series which use the secondary axes.
#
sub _get_secondary_axes_series {

    my $self = shift;
    my @secondary_axes_series;

    for my $series ( @{ $self->{_series} } ) {
        push @secondary_axes_series, $series if $series->{_y2_axis};
    }

    return @secondary_axes_series;
}


###############################################################################
#
# _add_axis_ids()
#
# Add unique ids for primary or secondary axes
#
sub _add_axis_ids {

    my $self       = shift;
    my %args       = @_;
    my $chart_id   = 5001 + $self->{_id};
    my $axis_count = 1 + @{ $self->{_axis2_ids} } + @{ $self->{_axis_ids} };

    my $id1 = sprintf '%04d%04d', $chart_id, $axis_count;
    my $id2 = sprintf '%04d%04d', $chart_id, $axis_count + 1;

    push @{ $self->{_axis_ids} },  $id1, $id2 if $args{primary_axes};
    push @{ $self->{_axis2_ids} }, $id1, $id2 if !$args{primary_axes};
}


##############################################################################
#
# _get_font_style_attributes.
#
# Get the font style attributes from a font hashref.
#
sub _get_font_style_attributes {

    my $self = shift;
    my $font = shift;

    return () unless $font;

    my @attributes;
    push @attributes, ( 'sz' => $font->{_size} )   if $font->{_size};
    push @attributes, ( 'b'  => $font->{_bold} )   if defined $font->{_bold};
    push @attributes, ( 'i'  => $font->{_italic} ) if defined $font->{_italic};
    push @attributes, ( 'u' => 'sng' ) if defined $font->{_underline};

    # Turn off baseline when testing fonts that don't have it.
    if ($font->{_baseline} != -1) {
        push @attributes, ( 'baseline' => $font->{_baseline} );
    }

    return @attributes;
}


##############################################################################
#
# _get_font_latin_attributes.
#
# Get the font latin attributes from a font hashref.
#
sub _get_font_latin_attributes {

    my $self = shift;
    my $font = shift;

    return () unless $font;

    my @attributes;
    push @attributes, ( 'typeface' => $font->{_name} ) if $font->{_name};

    push @attributes, ( 'pitchFamily' => $font->{_pitch_family} )
      if defined $font->{_pitch_family};

    push @attributes, ( 'charset' => $font->{_charset} )
      if defined $font->{_charset};

    return @attributes;
}


###############################################################################
#
# Config data.
#
###############################################################################

###############################################################################
#
# _set_default_properties()
#
# Setup the default properties for a chart.
#
sub _set_default_properties {

    my $self = shift;

    # Set the default axis properties.
    $self->{_x_axis}->{_defaults} = {
        num_format      => 'General',
        major_gridlines => { visible => 0 }
    };

    $self->{_y_axis}->{_defaults} = {
        num_format      => 'General',
        major_gridlines => { visible => 1 }
    };

    $self->{_x2_axis}->{_defaults} = {
        num_format     => 'General',
        label_position => 'none',
        crossing       => 'max',
        visible        => 0
    };

    $self->{_y2_axis}->{_defaults} = {
        num_format      => 'General',
        major_gridlines => { visible => 0 },
        position        => 'right',
        visible         => 1
    };

    $self->set_x_axis();
    $self->set_y_axis();

    $self->set_x2_axis();
    $self->set_y2_axis();
}


###############################################################################
#
# _set_embedded_config_data()
#
# Setup the default configuration data for an embedded chart.
#
sub _set_embedded_config_data {

    my $self = shift;

    $self->{_embedded} = 1;
}


###############################################################################
#
# XML writing methods.
#
###############################################################################


##############################################################################
#
# _write_chart_space()
#
# Write the <c:chartSpace> element.
#
sub _write_chart_space {

    my $self    = shift;
    my $schema  = 'http://schemas.openxmlformats.org/';
    my $xmlns_c = $schema . 'drawingml/2006/chart';
    my $xmlns_a = $schema . 'drawingml/2006/main';
    my $xmlns_r = $schema . 'officeDocument/2006/relationships';

    my @attributes = (
        'xmlns:c' => $xmlns_c,
        'xmlns:a' => $xmlns_a,
        'xmlns:r' => $xmlns_r,
    );

    $self->xml_start_tag( 'c:chartSpace', @attributes );
}


##############################################################################
#
# _write_lang()
#
# Write the <c:lang> element.
#
sub _write_lang {

    my $self = shift;
    my $val  = 'en-US';

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:lang', @attributes );
}


##############################################################################
#
# _write_style()
#
# Write the <c:style> element.
#
sub _write_style {

    my $self     = shift;
    my $style_id = $self->{_style_id};

    # Don't write an element for the default style, 2.
    return if $style_id == 2;

    my @attributes = ( 'val' => $style_id );

    $self->xml_empty_tag( 'c:style', @attributes );
}


##############################################################################
#
# _write_chart()
#
# Write the <c:chart> element.
#
sub _write_chart {

    my $self = shift;

    $self->xml_start_tag( 'c:chart' );

    # Write the chart title elements.

    if ( $self->{_title_none} ) {

        # Turn off the title.
        $self->_write_auto_title_deleted();
    }
    else {
        my $title;
        if ( $title = $self->{_title_formula} ) {
            $self->_write_title_formula(

                $title,
                $self->{_title_data_id},
                undef,
                $self->{_title_font},
                $self->{_title_layout},
                $self->{_title_overlay}
            );
        }
        elsif ( $title = $self->{_title_name} ) {
            $self->_write_title_rich(

                $title,
                undef,
                $self->{_title_font},
                $self->{_title_layout},
                $self->{_title_overlay}
            );
        }
    }

    # Write the c:plotArea element.
    $self->_write_plot_area();

    # Write the c:legend element.
    $self->_write_legend();

    # Write the c:plotVisOnly element.
    $self->_write_plot_vis_only();

    # Write the c:dispBlanksAs element.
    $self->_write_disp_blanks_as();

    $self->xml_end_tag( 'c:chart' );
}


##############################################################################
#
# _write_disp_blanks_as()
#
# Write the <c:dispBlanksAs> element.
#
sub _write_disp_blanks_as {

    my $self = shift;
    my $val  = $self->{_show_blanks};

    # Ignore the default value.
    return if $val eq 'gap';

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:dispBlanksAs', @attributes );
}


##############################################################################
#
# _write_plot_area()
#
# Write the <c:plotArea> element.
#
sub _write_plot_area {

    my $self = shift;
    my $second_chart = $self->{_combined};

    $self->xml_start_tag( 'c:plotArea' );

    # Write the c:layout element.
    $self->_write_layout( $self->{_plotarea}->{_layout}, 'plot' );

    # Write the subclass chart type elements for primary and secondary axes.
    $self->_write_chart_type( primary_axes => 1 );
    $self->_write_chart_type( primary_axes => 0 );


    # Configure a combined chart if present.
    if ( $second_chart ) {

        # Secondary axis has unique id otherwise use same as primary.
        if ( $second_chart->{_is_secondary} ) {
            $second_chart->{_id} = 1000 + $self->{_id};
        }
        else {
            $second_chart->{_id} = $self->{_id};
        }

        # Shart the same filehandle for writing.
        $second_chart->{_fh} = $self->{_fh};

        # Share series index with primary chart.
        $second_chart->{_series_index} = $self->{_series_index};

        # Write the subclass chart type elements for combined chart.
        $second_chart->_write_chart_type( primary_axes => 1 );
        $second_chart->_write_chart_type( primary_axes => 0 );
    }

    # Write the category and value elements for the primary axes.
    my @args = (
        x_axis   => $self->{_x_axis},
        y_axis   => $self->{_y_axis},
        axis_ids => $self->{_axis_ids}
    );

    if ( $self->{_date_category} ) {
        $self->_write_date_axis( @args );
    }
    else {
        $self->_write_cat_axis( @args );
    }

    $self->_write_val_axis( @args );

    # Write the category and value elements for the secondary axes.
    @args = (
        x_axis   => $self->{_x2_axis},
        y_axis   => $self->{_y2_axis},
        axis_ids => $self->{_axis2_ids}
    );

    $self->_write_val_axis( @args );

    # Write the secondary axis for the secondary chart.
    if ( $second_chart && $second_chart->{_is_secondary} ) {

        @args = (
             x_axis   => $second_chart->{_x2_axis},
             y_axis   => $second_chart->{_y2_axis},
             axis_ids => $second_chart->{_axis2_ids}
            );

        $second_chart->_write_val_axis( @args );
    }


    if ( $self->{_date_category} ) {
        $self->_write_date_axis( @args );
    }
    else {
        $self->_write_cat_axis( @args );
    }

    # Write the c:dTable element.
    $self->_write_d_table();

    # Write the c:spPr element for the plotarea formatting.
    $self->_write_sp_pr( $self->{_plotarea} );

    $self->xml_end_tag( 'c:plotArea' );
}


##############################################################################
#
# _write_layout()
#
# Write the <c:layout> element.
#
sub _write_layout {

    my $self   = shift;
    my $layout = shift;
    my $type   = shift;

    if ( !$layout ) {
        # Automatic layout.
        $self->xml_empty_tag( 'c:layout' );
    }
    else {
        # User defined manual layout.
        $self->xml_start_tag( 'c:layout' );
        $self->_write_manual_layout( $layout, $type );
        $self->xml_end_tag( 'c:layout' );
    }
}

##############################################################################
#
# _write_manual_layout()
#
# Write the <c:manualLayout> element.
#
sub _write_manual_layout {

    my $self   = shift;
    my $layout = shift;
    my $type   = shift;

    $self->xml_start_tag( 'c:manualLayout' );

    # Plotarea has a layoutTarget element.
    if ( $type eq 'plot' ) {
        $self->xml_empty_tag( 'c:layoutTarget', ( 'val' => 'inner' ) );
    }

    # Set the x, y positions.
    $self->xml_empty_tag( 'c:xMode', ( 'val' => 'edge' ) );
    $self->xml_empty_tag( 'c:yMode', ( 'val' => 'edge' ) );
    $self->xml_empty_tag( 'c:x', ( 'val' => $layout->{x} ) );
    $self->xml_empty_tag( 'c:y', ( 'val' => $layout->{y} ) );

    # For plotarea and legend set the width and height.
    if ( $type ne 'text' ) {
        $self->xml_empty_tag( 'c:w', ( 'val' => $layout->{width} ) );
        $self->xml_empty_tag( 'c:h', ( 'val' => $layout->{height} ) );
    }

    $self->xml_end_tag( 'c:manualLayout' );
}

##############################################################################
#
# _write_chart_type()
#
# Write the chart type element. This method should be overridden by the
# subclasses.
#
sub _write_chart_type {

    my $self = shift;
}


##############################################################################
#
# _write_grouping()
#
# Write the <c:grouping> element.
#
sub _write_grouping {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:grouping', @attributes );
}


##############################################################################
#
# _write_series()
#
# Write the series elements.
#
sub _write_series {

    my $self   = shift;
    my $series = shift;

    $self->_write_ser( $series );
}


##############################################################################
#
# _write_ser()
#
# Write the <c:ser> element.
#
sub _write_ser {

    my $self   = shift;
    my $series = shift;
    my $index  = $self->{_series_index}++;

    $self->xml_start_tag( 'c:ser' );

    # Write the c:idx element.
    $self->_write_idx( $index );

    # Write the c:order element.
    $self->_write_order( $index );

    # Write the series name.
    $self->_write_series_name( $series );

    # Write the c:spPr element.
    $self->_write_sp_pr( $series );

    # Write the c:marker element.
    $self->_write_marker( $series->{_marker} );

    # Write the c:invertIfNegative element.
    $self->_write_c_invert_if_negative( $series->{_invert_if_neg} );

    # Write the c:dPt element.
    $self->_write_d_pt( $series->{_points} );

    # Write the c:dLbls element.
    $self->_write_d_lbls( $series->{_labels} );

    # Write the c:trendline element.
    $self->_write_trendline( $series->{_trendline} );

    # Write the c:errBars element.
    $self->_write_error_bars( $series->{_error_bars} );

    # Write the c:cat element.
    $self->_write_cat( $series );

    # Write the c:val element.
    $self->_write_val( $series );

    # Write the c:smooth element.
    if ( $self->{_smooth_allowed} ) {
        $self->_write_c_smooth( $series->{_smooth} );
    }

    $self->xml_end_tag( 'c:ser' );
}


##############################################################################
#
# _write_idx()
#
# Write the <c:idx> element.
#
sub _write_idx {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:idx', @attributes );
}


##############################################################################
#
# _write_order()
#
# Write the <c:order> element.
#
sub _write_order {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:order', @attributes );
}


##############################################################################
#
# _write_series_name()
#
# Write the series name.
#
sub _write_series_name {

    my $self   = shift;
    my $series = shift;

    my $name;
    if ( $name = $series->{_name_formula} ) {
        $self->_write_tx_formula( $name, $series->{_name_id} );
    }
    elsif ( $name = $series->{_name} ) {
        $self->_write_tx_value( $name );
    }

}


##############################################################################
#
# _write_cat()
#
# Write the <c:cat> element.
#
sub _write_cat {

    my $self    = shift;
    my $series  = shift;
    my $formula = $series->{_categories};
    my $data_id = $series->{_cat_data_id};
    my $data;

    if ( defined $data_id ) {
        $data = $self->{_formula_data}->[$data_id];
    }

    # Ignore <c:cat> elements for charts without category values.
    return unless $formula;

    $self->xml_start_tag( 'c:cat' );

    # Check the type of cached data.
    my $type = $self->_get_data_type( $data );

    if ( $type eq 'str' ) {

        $self->{_cat_has_num_fmt} = 0;

        # Write the c:numRef element.
        $self->_write_str_ref( $formula, $data, $type );
    }
    elsif ( $type eq 'multi_str') {

        $self->{_cat_has_num_fmt} = 0;

        # Write the c:multiLvLStrRef element.
        $self->_write_multi_lvl_str_ref( $formula, $data );
    }
    else {

        $self->{_cat_has_num_fmt} = 1;

        # Write the c:numRef element.
        $self->_write_num_ref( $formula, $data, $type );
    }


    $self->xml_end_tag( 'c:cat' );
}


##############################################################################
#
# _write_val()
#
# Write the <c:val> element.
#
sub _write_val {

    my $self    = shift;
    my $series  = shift;
    my $formula = $series->{_values};
    my $data_id = $series->{_val_data_id};
    my $data    = $self->{_formula_data}->[$data_id];

    $self->xml_start_tag( 'c:val' );

    # Unlike Cat axes data should only be numeric.

    # Write the c:numRef element.
    $self->_write_num_ref( $formula, $data, 'num' );

    $self->xml_end_tag( 'c:val' );
}


##############################################################################
#
# _write_num_ref()
#
# Write the <c:numRef> element.
#
sub _write_num_ref {

    my $self    = shift;
    my $formula = shift;
    my $data    = shift;
    my $type    = shift;

    $self->xml_start_tag( 'c:numRef' );

    # Write the c:f element.
    $self->_write_series_formula( $formula );

    if ( $type eq 'num' ) {

        # Write the c:numCache element.
        $self->_write_num_cache( $data );
    }
    elsif ( $type eq 'str' ) {

        # Write the c:strCache element.
        $self->_write_str_cache( $data );
    }

    $self->xml_end_tag( 'c:numRef' );
}


##############################################################################
#
# _write_str_ref()
#
# Write the <c:strRef> element.
#
sub _write_str_ref {

    my $self    = shift;
    my $formula = shift;
    my $data    = shift;
    my $type    = shift;

    $self->xml_start_tag( 'c:strRef' );

    # Write the c:f element.
    $self->_write_series_formula( $formula );

    if ( $type eq 'num' ) {

        # Write the c:numCache element.
        $self->_write_num_cache( $data );
    }
    elsif ( $type eq 'str' ) {

        # Write the c:strCache element.
        $self->_write_str_cache( $data );
    }

    $self->xml_end_tag( 'c:strRef' );
}


##############################################################################
#
# _write_multi_lvl_str_ref()
#
# Write the <c:multiLvLStrRef> element.
#
sub _write_multi_lvl_str_ref {

    my $self    = shift;
    my $formula = shift;
    my $data    = shift;
    my $count   = @$data;

    return if !$count;

    $self->xml_start_tag( 'c:multiLvlStrRef' );

    # Write the c:f element.
    $self->_write_series_formula( $formula );

    $self->xml_start_tag( 'c:multiLvlStrCache' );

    # Write the c:ptCount element.
    $count = @{ $data->[-1] };
    $self->_write_pt_count( $count );

    # Write the data arrays in reverse order.
    for my $aref ( reverse @$data ) {
        $self->xml_start_tag( 'c:lvl' );

        for my $i ( 0 .. @$aref - 1 ) {
            # Write the c:pt element.
            $self->_write_pt( $i, $aref->[$i] );
        }

        $self->xml_end_tag( 'c:lvl' );
    }

    $self->xml_end_tag( 'c:multiLvlStrCache' );

    $self->xml_end_tag( 'c:multiLvlStrRef' );
}


##############################################################################
#
# _write_series_formula()
#
# Write the <c:f> element.
#
sub _write_series_formula {

    my $self    = shift;
    my $formula = shift;

    # Strip the leading '=' from the formula.
    $formula =~ s/^=//;

    $self->xml_data_element( 'c:f', $formula );
}


##############################################################################
#
# _write_axis_ids()
#
# Write the <c:axId> elements for the primary or secondary axes.
#
sub _write_axis_ids {

    my $self = shift;
    my %args = @_;

    # Generate the axis ids.
    $self->_add_axis_ids( %args );

    if ( $args{primary_axes} ) {

        # Write the axis ids for the primary axes.
        $self->_write_axis_id( $self->{_axis_ids}->[0] );
        $self->_write_axis_id( $self->{_axis_ids}->[1] );
    }
    else {
        # Write the axis ids for the secondary axes.
        $self->_write_axis_id( $self->{_axis2_ids}->[0] );
        $self->_write_axis_id( $self->{_axis2_ids}->[1] );
    }
}


##############################################################################
#
# _write_axis_id()
#
# Write the <c:axId> element.
#
sub _write_axis_id {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:axId', @attributes );
}


##############################################################################
#
# _write_cat_axis()
#
# Write the <c:catAx> element. Usually the X axis.
#
sub _write_cat_axis {

    my $self     = shift;
    my %args     = @_;
    my $x_axis   = $args{x_axis};
    my $y_axis   = $args{y_axis};
    my $axis_ids = $args{axis_ids};

    # if there are no axis_ids then we don't need to write this element
    return unless $axis_ids;
    return unless scalar @$axis_ids;

    my $position = $self->{_cat_axis_position};
    my $horiz    = $self->{_horiz_cat_axis};

    # Overwrite the default axis position with a user supplied value.
    $position = $x_axis->{_position} || $position;

    $self->xml_start_tag( 'c:catAx' );

    $self->_write_axis_id( $axis_ids->[0] );

    # Write the c:scaling element.
    $self->_write_scaling( $x_axis->{_reverse} );

    $self->_write_delete( 1 ) unless $x_axis->{_visible};

    # Write the c:axPos element.
    $self->_write_axis_pos( $position, $y_axis->{_reverse} );

    # Write the c:majorGridlines element.
    $self->_write_major_gridlines( $x_axis->{_major_gridlines} );

    # Write the c:minorGridlines element.
    $self->_write_minor_gridlines( $x_axis->{_minor_gridlines} );

    # Write the axis title elements.
    my $title;
    if ( $title = $x_axis->{_formula} ) {

        $self->_write_title_formula( $title, $x_axis->{_data_id}, $horiz,
            $x_axis->{_name_font}, $x_axis->{_layout} );
    }
    elsif ( $title = $x_axis->{_name} ) {
        $self->_write_title_rich( $title, $horiz, $x_axis->{_name_font},
            $x_axis->{_layout} );
    }

    # Write the c:numFmt element.
    $self->_write_cat_number_format( $x_axis );

    # Write the c:majorTickMark element.
    $self->_write_major_tick_mark( $x_axis->{_major_tick_mark} );

    # Write the c:minorTickMark element.
    $self->_write_minor_tick_mark( $x_axis->{_minor_tick_mark} );

    # Write the c:tickLblPos element.
    $self->_write_tick_label_pos( $x_axis->{_label_position} );

    # Write the c:spPr element for the axis line.
    $self->_write_sp_pr( $x_axis );

    # Write the axis font elements.
    $self->_write_axis_font( $x_axis->{_num_font} );

    # Write the c:crossAx element.
    $self->_write_cross_axis( $axis_ids->[1] );

    if ( $self->{_show_crosses} || $x_axis->{_visible} ) {

        # Note, the category crossing comes from the value axis.
        if ( !defined $y_axis->{_crossing} || $y_axis->{_crossing} eq 'max' ) {

            # Write the c:crosses element.
            $self->_write_crosses( $y_axis->{_crossing} );
        }
        else {

            # Write the c:crossesAt element.
            $self->_write_c_crosses_at( $y_axis->{_crossing} );
        }
    }

    # Write the c:auto element.
    if (!$x_axis->{_text_axis}) {
        $self->_write_auto( 1 );
    }

    # Write the c:labelAlign element.
    $self->_write_label_align( 'ctr' );

    # Write the c:labelOffset element.
    $self->_write_label_offset( 100 );

    # Write the c:tickLblSkip element.
    $self->_write_tick_lbl_skip( $x_axis->{_interval_unit} );

    # Write the c:tickMarkSkip element.
    $self->_write_tick_mark_skip( $x_axis->{_interval_tick} );

    $self->xml_end_tag( 'c:catAx' );
}


##############################################################################
#
# _write_val_axis()
#
# Write the <c:valAx> element. Usually the Y axis.
#
# TODO. Maybe should have a _write_cat_val_axis() method as well for scatter.
#
sub _write_val_axis {

    my $self     = shift;
    my %args     = @_;
    my $x_axis   = $args{x_axis};
    my $y_axis   = $args{y_axis};
    my $axis_ids = $args{axis_ids};
    my $position = $args{position} || $self->{_val_axis_position};
    my $horiz    = $self->{_horiz_val_axis};

    return unless $axis_ids && scalar @$axis_ids;

    # Overwrite the default axis position with a user supplied value.
    $position = $y_axis->{_position} || $position;

    $self->xml_start_tag( 'c:valAx' );

    $self->_write_axis_id( $axis_ids->[1] );

    # Write the c:scaling element.
    $self->_write_scaling(
        $y_axis->{_reverse}, $y_axis->{_min},
        $y_axis->{_max},     $y_axis->{_log_base}
    );

    $self->_write_delete( 1 ) unless $y_axis->{_visible};

    # Write the c:axPos element.
    $self->_write_axis_pos( $position, $x_axis->{_reverse} );

    # Write the c:majorGridlines element.
    $self->_write_major_gridlines( $y_axis->{_major_gridlines} );

    # Write the c:minorGridlines element.
    $self->_write_minor_gridlines( $y_axis->{_minor_gridlines} );

    # Write the axis title elements.
    my $title;
    if ( $title = $y_axis->{_formula} ) {
        $self->_write_title_formula( $title, $y_axis->{_data_id}, $horiz,
            $y_axis->{_name_font}, $y_axis->{_layout} );
    }
    elsif ( $title = $y_axis->{_name} ) {
        $self->_write_title_rich( $title, $horiz, $y_axis->{_name_font},
            $y_axis->{_layout} );
    }

    # Write the c:numberFormat element.
    $self->_write_number_format( $y_axis );

    # Write the c:majorTickMark element.
    $self->_write_major_tick_mark( $y_axis->{_major_tick_mark} );

    # Write the c:minorTickMark element.
    $self->_write_minor_tick_mark( $y_axis->{_minor_tick_mark} );

    # Write the c:tickLblPos element.
    $self->_write_tick_label_pos( $y_axis->{_label_position} );

    # Write the c:spPr element for the axis line.
    $self->_write_sp_pr( $y_axis );

    # Write the axis font elements.
    $self->_write_axis_font( $y_axis->{_num_font} );

    # Write the c:crossAx element.
    $self->_write_cross_axis( $axis_ids->[0] );

    # Note, the category crossing comes from the value axis.
    if ( !defined $x_axis->{_crossing} || $x_axis->{_crossing} eq 'max' ) {

        # Write the c:crosses element.
        $self->_write_crosses( $x_axis->{_crossing} );
    }
    else {

        # Write the c:crossesAt element.
        $self->_write_c_crosses_at( $x_axis->{_crossing} );
    }

    # Write the c:crossBetween element.
    $self->_write_cross_between( $x_axis->{_position_axis} );

    # Write the c:majorUnit element.
    $self->_write_c_major_unit( $y_axis->{_major_unit} );

    # Write the c:minorUnit element.
    $self->_write_c_minor_unit( $y_axis->{_minor_unit} );

    # Write the c:dispUnits element.
    $self->_write_disp_units( $y_axis->{_display_units},
        $y_axis->{_display_units_visible} );

    $self->xml_end_tag( 'c:valAx' );
}


##############################################################################
#
# _write_cat_val_axis()
#
# Write the <c:valAx> element. This is for the second valAx in scatter plots.
# Usually the X axis.
#
sub _write_cat_val_axis {

    my $self     = shift;
    my %args     = @_;
    my $x_axis   = $args{x_axis};
    my $y_axis   = $args{y_axis};
    my $axis_ids = $args{axis_ids};
    my $position = $args{position} || $self->{_val_axis_position};
    my $horiz    = $self->{_horiz_val_axis};

    return unless $axis_ids && scalar @$axis_ids;

    # Overwrite the default axis position with a user supplied value.
    $position = $x_axis->{_position} || $position;

    $self->xml_start_tag( 'c:valAx' );

    $self->_write_axis_id( $axis_ids->[0] );

    # Write the c:scaling element.
    $self->_write_scaling(
        $x_axis->{_reverse}, $x_axis->{_min},
        $x_axis->{_max},     $x_axis->{_log_base}
    );

    $self->_write_delete( 1 ) unless $x_axis->{_visible};

    # Write the c:axPos element.
    $self->_write_axis_pos( $position, $y_axis->{_reverse} );

    # Write the c:majorGridlines element.
    $self->_write_major_gridlines( $x_axis->{_major_gridlines} );

    # Write the c:minorGridlines element.
    $self->_write_minor_gridlines( $x_axis->{_minor_gridlines} );

    # Write the axis title elements.
    my $title;
    if ( $title = $x_axis->{_formula} ) {
        $self->_write_title_formula( $title, $x_axis->{_data_id}, $horiz,
            $x_axis->{_name_font}, $x_axis->{_layout} );
    }
    elsif ( $title = $x_axis->{_name} ) {
        $self->_write_title_rich( $title, $horiz, $x_axis->{_name_font},
            $x_axis->{_layout} );
    }

    # Write the c:numberFormat element.
    $self->_write_number_format( $x_axis );

    # Write the c:majorTickMark element.
    $self->_write_major_tick_mark( $x_axis->{_major_tick_mark} );

    # Write the c:minorTickMark element.
    $self->_write_minor_tick_mark( $x_axis->{_minor_tick_mark} );

    # Write the c:tickLblPos element.
    $self->_write_tick_label_pos( $x_axis->{_label_position} );

    # Write the c:spPr element for the axis line.
    $self->_write_sp_pr( $x_axis );

    # Write the axis font elements.
    $self->_write_axis_font( $x_axis->{_num_font} );

    # Write the c:crossAx element.
    $self->_write_cross_axis( $axis_ids->[1] );

    # Note, the category crossing comes from the value axis.
    if ( !defined $y_axis->{_crossing} || $y_axis->{_crossing} eq 'max' ) {

        # Write the c:crosses element.
        $self->_write_crosses( $y_axis->{_crossing} );
    }
    else {

        # Write the c:crossesAt element.
        $self->_write_c_crosses_at( $y_axis->{_crossing} );
    }

    # Write the c:crossBetween element.
    $self->_write_cross_between( $y_axis->{_position_axis} );

    # Write the c:majorUnit element.
    $self->_write_c_major_unit( $x_axis->{_major_unit} );

    # Write the c:minorUnit element.
    $self->_write_c_minor_unit( $x_axis->{_minor_unit} );

    # Write the c:dispUnits element.
    $self->_write_disp_units( $x_axis->{_display_units},
        $x_axis->{_display_units_visible} );

    $self->xml_end_tag( 'c:valAx' );
}


##############################################################################
#
# _write_date_axis()
#
# Write the <c:dateAx> element. Usually the X axis.
#
sub _write_date_axis {

    my $self     = shift;
    my %args     = @_;
    my $x_axis   = $args{x_axis};
    my $y_axis   = $args{y_axis};
    my $axis_ids = $args{axis_ids};

    return unless $axis_ids && scalar @$axis_ids;

    my $position = $self->{_cat_axis_position};

    # Overwrite the default axis position with a user supplied value.
    $position = $x_axis->{_position} || $position;

    $self->xml_start_tag( 'c:dateAx' );

    $self->_write_axis_id( $axis_ids->[0] );

    # Write the c:scaling element.
    $self->_write_scaling(
        $x_axis->{_reverse}, $x_axis->{_min},
        $x_axis->{_max},     $x_axis->{_log_base}
    );

    $self->_write_delete( 1 ) unless $x_axis->{_visible};

    # Write the c:axPos element.
    $self->_write_axis_pos( $position, $y_axis->{_reverse} );

    # Write the c:majorGridlines element.
    $self->_write_major_gridlines( $x_axis->{_major_gridlines} );

    # Write the c:minorGridlines element.
    $self->_write_minor_gridlines( $x_axis->{_minor_gridlines} );

    # Write the axis title elements.
    my $title;
    if ( $title = $x_axis->{_formula} ) {
        $self->_write_title_formula( $title, $x_axis->{_data_id}, undef,
            $x_axis->{_name_font}, $x_axis->{_layout} );
    }
    elsif ( $title = $x_axis->{_name} ) {
        $self->_write_title_rich( $title, undef, $x_axis->{_name_font},
            $x_axis->{_layout} );
    }

    # Write the c:numFmt element.
    $self->_write_number_format( $x_axis );

    # Write the c:majorTickMark element.
    $self->_write_major_tick_mark( $x_axis->{_major_tick_mark} );

    # Write the c:minorTickMark element.
    $self->_write_minor_tick_mark( $x_axis->{_minor_tick_mark} );

    # Write the c:tickLblPos element.
    $self->_write_tick_label_pos( $x_axis->{_label_position} );

    # Write the c:spPr element for the axis line.
    $self->_write_sp_pr( $x_axis );

    # Write the axis font elements.
    $self->_write_axis_font( $x_axis->{_num_font} );

    # Write the c:crossAx element.
    $self->_write_cross_axis( $axis_ids->[1] );

    if ( $self->{_show_crosses} || $x_axis->{_visible} ) {

        # Note, the category crossing comes from the value axis.
        if ( !defined $y_axis->{_crossing} || $y_axis->{_crossing} eq 'max' ) {

            # Write the c:crosses element.
            $self->_write_crosses( $y_axis->{_crossing} );
        }
        else {

            # Write the c:crossesAt element.
            $self->_write_c_crosses_at( $y_axis->{_crossing} );
        }
    }

    # Write the c:auto element.
    $self->_write_auto( 1 );

    # Write the c:labelOffset element.
    $self->_write_label_offset( 100 );

    # Write the c:tickLblSkip element.
    $self->_write_tick_lbl_skip( $x_axis->{_interval_unit} );

    # Write the c:tickMarkSkip element.
    $self->_write_tick_mark_skip( $x_axis->{_interval_tick} );

    # Write the c:majorUnit element.
    $self->_write_c_major_unit( $x_axis->{_major_unit} );

    # Write the c:majorTimeUnit element.
    if ( defined $x_axis->{_major_unit} ) {
        $self->_write_c_major_time_unit( $x_axis->{_major_unit_type} );
    }

    # Write the c:minorUnit element.
    $self->_write_c_minor_unit( $x_axis->{_minor_unit} );

    # Write the c:minorTimeUnit element.
    if ( defined $x_axis->{_minor_unit} ) {
        $self->_write_c_minor_time_unit( $x_axis->{_minor_unit_type} );
    }

    $self->xml_end_tag( 'c:dateAx' );
}


##############################################################################
#
# _write_scaling()
#
# Write the <c:scaling> element.
#
sub _write_scaling {

    my $self     = shift;
    my $reverse  = shift;
    my $min      = shift;
    my $max      = shift;
    my $log_base = shift;

    $self->xml_start_tag( 'c:scaling' );

    # Write the c:logBase element.
    $self->_write_c_log_base( $log_base );

    # Write the c:orientation element.
    $self->_write_orientation( $reverse );

    # Write the c:max element.
    $self->_write_c_max( $max );

    # Write the c:min element.
    $self->_write_c_min( $min );

    $self->xml_end_tag( 'c:scaling' );
}


##############################################################################
#
# _write_c_log_base()
#
# Write the <c:logBase> element.
#
sub _write_c_log_base {

    my $self = shift;
    my $val  = shift;

    return unless $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:logBase', @attributes );
}


##############################################################################
#
# _write_orientation()
#
# Write the <c:orientation> element.
#
sub _write_orientation {

    my $self    = shift;
    my $reverse = shift;
    my $val     = 'minMax';

    $val = 'maxMin' if $reverse;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:orientation', @attributes );
}


##############################################################################
#
# _write_c_max()
#
# Write the <c:max> element.
#
sub _write_c_max {

    my $self = shift;
    my $max  = shift;

    return unless defined $max;

    my @attributes = ( 'val' => $max );

    $self->xml_empty_tag( 'c:max', @attributes );
}


##############################################################################
#
# _write_c_min()
#
# Write the <c:min> element.
#
sub _write_c_min {

    my $self = shift;
    my $min  = shift;

    return unless defined $min;

    my @attributes = ( 'val' => $min );

    $self->xml_empty_tag( 'c:min', @attributes );
}


##############################################################################
#
# _write_axis_pos()
#
# Write the <c:axPos> element.
#
sub _write_axis_pos {

    my $self    = shift;
    my $val     = shift;
    my $reverse = shift;

    if ( $reverse ) {
        $val = 'r' if $val eq 'l';
        $val = 't' if $val eq 'b';
    }

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:axPos', @attributes );
}


##############################################################################
#
# _write_number_format()
#
# Write the <c:numberFormat> element. Note: It is assumed that if a user
# defined number format is supplied (i.e., non-default) then the sourceLinked
# attribute is 0. The user can override this if required.
#
sub _write_number_format {

    my $self          = shift;
    my $axis          = shift;
    my $format_code   = $axis->{_num_format};
    my $source_linked = 1;

    # Check if a user defined number format has been set.
    if ( $format_code ne $axis->{_defaults}->{num_format} ) {
        $source_linked = 0;
    }

    # User override of sourceLinked.
    if ( $axis->{_num_format_linked} ) {
        $source_linked = 1;
    }

    my @attributes = (
        'formatCode'   => $format_code,
        'sourceLinked' => $source_linked,
    );

    $self->xml_empty_tag( 'c:numFmt', @attributes );
}


##############################################################################
#
# _write_cat_number_format()
#
# Write the <c:numFmt> element. Special case handler for category axes which
# don't always have a number format.
#
sub _write_cat_number_format {

    my $self           = shift;
    my $axis           = shift;
    my $format_code    = $axis->{_num_format};
    my $source_linked  = 1;
    my $default_format = 1;

    # Check if a user defined number format has been set.
    if ( $format_code ne $axis->{_defaults}->{num_format} ) {
        $source_linked  = 0;
        $default_format = 0;
    }

    # User override of linkedSource.
    if ( $axis->{_num_format_linked} ) {
        $source_linked = 1;
    }

    # Skip if cat doesn't have a num format (unless it is non-default).
    if ( !$self->{_cat_has_num_fmt} && $default_format ) {
        return;
    }

    my @attributes = (
        'formatCode'   => $format_code,
        'sourceLinked' => $source_linked,
    );

    $self->xml_empty_tag( 'c:numFmt', @attributes );
}


##############################################################################
#
# _write_number_format()
#
# Write the <c:numberFormat> element for data labels.
#
sub _write_data_label_number_format {

    my $self          = shift;
    my $format_code   = shift;
    my $source_linked = 0;

    my @attributes = (
        'formatCode'   => $format_code,
        'sourceLinked' => $source_linked,
    );

    $self->xml_empty_tag( 'c:numFmt', @attributes );
}


##############################################################################
#
# _write_major_tick_mark()
#
# Write the <c:majorTickMark> element.
#
sub _write_major_tick_mark {

    my $self = shift;
    my $val  = shift;

    return unless $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:majorTickMark', @attributes );
}


##############################################################################
#
# _write_minor_tick_mark()
#
# Write the <c:minorTickMark> element.
#
sub _write_minor_tick_mark {

    my $self = shift;
    my $val  = shift;

    return unless $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:minorTickMark', @attributes );
}


##############################################################################
#
# _write_tick_label_pos()
#
# Write the <c:tickLblPos> element.
#
sub _write_tick_label_pos {

    my $self = shift;
    my $val = shift || 'nextTo';

    if ( $val eq 'next_to' ) {
        $val = 'nextTo';
    }

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:tickLblPos', @attributes );
}


##############################################################################
#
# _write_cross_axis()
#
# Write the <c:crossAx> element.
#
sub _write_cross_axis {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:crossAx', @attributes );
}


##############################################################################
#
# _write_crosses()
#
# Write the <c:crosses> element.
#
sub _write_crosses {

    my $self = shift;
    my $val = shift || 'autoZero';

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:crosses', @attributes );
}


##############################################################################
#
# _write_c_crosses_at()
#
# Write the <c:crossesAt> element.
#
sub _write_c_crosses_at {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:crossesAt', @attributes );
}


##############################################################################
#
# _write_auto()
#
# Write the <c:auto> element.
#
sub _write_auto {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:auto', @attributes );
}


##############################################################################
#
# _write_label_align()
#
# Write the <c:labelAlign> element.
#
sub _write_label_align {

    my $self = shift;
    my $val  = 'ctr';

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:lblAlgn', @attributes );
}


##############################################################################
#
# _write_label_offset()
#
# Write the <c:labelOffset> element.
#
sub _write_label_offset {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:lblOffset', @attributes );
}


##############################################################################
#
# _write_tick_lbl_skip()
#
# Write the <c:tickLblSkip> element.
#
sub _write_tick_lbl_skip {

    my $self = shift;
    my $val  = shift;

    return unless $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:tickLblSkip', @attributes );
}


##############################################################################
#
# _write_tick_mark_skip()
#
# Write the <c:tickMarkSkip> element.
#
sub _write_tick_mark_skip {

    my $self = shift;
    my $val  = shift;

    return unless $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:tickMarkSkip', @attributes );
}


##############################################################################
#
# _write_major_gridlines()
#
# Write the <c:majorGridlines> element.
#
sub _write_major_gridlines {

    my $self      = shift;
    my $gridlines = shift;

    return unless $gridlines;
    return unless $gridlines->{_visible};

    if ( $gridlines->{_line}->{_defined} ) {
        $self->xml_start_tag( 'c:majorGridlines' );

        # Write the c:spPr element.
        $self->_write_sp_pr( $gridlines );

        $self->xml_end_tag( 'c:majorGridlines' );
    }
    else {
        $self->xml_empty_tag( 'c:majorGridlines' );
    }
}


##############################################################################
#
# _write_minor_gridlines()
#
# Write the <c:minorGridlines> element.
#
sub _write_minor_gridlines {

    my $self      = shift;
    my $gridlines = shift;

    return unless $gridlines;
    return unless $gridlines->{_visible};

    if ( $gridlines->{_line}->{_defined} ) {
        $self->xml_start_tag( 'c:minorGridlines' );

        # Write the c:spPr element.
        $self->_write_sp_pr( $gridlines );

        $self->xml_end_tag( 'c:minorGridlines' );
    }
    else {
        $self->xml_empty_tag( 'c:minorGridlines' );
    }
}


##############################################################################
#
# _write_cross_between()
#
# Write the <c:crossBetween> element.
#
sub _write_cross_between {

    my $self = shift;

    my $val = shift || $self->{_cross_between};

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:crossBetween', @attributes );
}


##############################################################################
#
# _write_c_major_unit()
#
# Write the <c:majorUnit> element.
#
sub _write_c_major_unit {

    my $self = shift;
    my $val  = shift;

    return unless $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:majorUnit', @attributes );
}


##############################################################################
#
# _write_c_minor_unit()
#
# Write the <c:minorUnit> element.
#
sub _write_c_minor_unit {

    my $self = shift;
    my $val  = shift;

    return unless $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:minorUnit', @attributes );
}


##############################################################################
#
# _write_c_major_time_unit()
#
# Write the <c:majorTimeUnit> element.
#
sub _write_c_major_time_unit {

    my $self = shift;
    my $val = shift || 'days';

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:majorTimeUnit', @attributes );
}


##############################################################################
#
# _write_c_minor_time_unit()
#
# Write the <c:minorTimeUnit> element.
#
sub _write_c_minor_time_unit {

    my $self = shift;
    my $val = shift || 'days';

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:minorTimeUnit', @attributes );
}


##############################################################################
#
# _write_legend()
#
# Write the <c:legend> element.
#
sub _write_legend {

    my $self          = shift;
    my $position      = $self->{_legend_position};
    my $font          = $self->{_legend_font};
    my @delete_series = ();
    my $overlay       = 0;

    if ( defined $self->{_legend_delete_series}
        && ref $self->{_legend_delete_series} eq 'ARRAY' )
    {
        @delete_series = @{ $self->{_legend_delete_series} };
    }

    if ( $position =~ s/^overlay_// ) {
        $overlay = 1;
    }

    my %allowed = (
        right  => 'r',
        left   => 'l',
        top    => 't',
        bottom => 'b',
    );

    return if $position eq 'none';
    return unless exists $allowed{$position};

    $position = $allowed{$position};

    $self->xml_start_tag( 'c:legend' );

    # Write the c:legendPos element.
    $self->_write_legend_pos( $position );

    # Remove series labels from the legend.
    for my $index ( @delete_series ) {

        # Write the c:legendEntry element.
        $self->_write_legend_entry( $index );
    }

    # Write the c:layout element.
    $self->_write_layout( $self->{_legend_layout}, 'legend' );

    # Write the c:txPr element.
    if ( $font ) {
        $self->_write_tx_pr( undef, $font );
    }

    # Write the c:overlay element.
    $self->_write_overlay() if $overlay;

    $self->xml_end_tag( 'c:legend' );
}


##############################################################################
#
# _write_legend_pos()
#
# Write the <c:legendPos> element.
#
sub _write_legend_pos {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:legendPos', @attributes );
}


##############################################################################
#
# _write_legend_entry()
#
# Write the <c:legendEntry> element.
#
sub _write_legend_entry {

    my $self  = shift;
    my $index = shift;

    $self->xml_start_tag( 'c:legendEntry' );

    # Write the c:idx element.
    $self->_write_idx( $index );

    # Write the c:delete element.
    $self->_write_delete( 1 );

    $self->xml_end_tag( 'c:legendEntry' );
}


##############################################################################
#
# _write_overlay()
#
# Write the <c:overlay> element.
#
sub _write_overlay {

    my $self = shift;
    my $val  = 1;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:overlay', @attributes );
}


##############################################################################
#
# _write_plot_vis_only()
#
# Write the <c:plotVisOnly> element.
#
sub _write_plot_vis_only {

    my $self = shift;
    my $val  = 1;

    # Ignore this element if we are plotting hidden data.
    return if $self->{_show_hidden_data};

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:plotVisOnly', @attributes );
}


##############################################################################
#
# _write_print_settings()
#
# Write the <c:printSettings> element.
#
sub _write_print_settings {

    my $self = shift;

    $self->xml_start_tag( 'c:printSettings' );

    # Write the c:headerFooter element.
    $self->_write_header_footer();

    # Write the c:pageMargins element.
    $self->_write_page_margins();

    # Write the c:pageSetup element.
    $self->_write_page_setup();

    $self->xml_end_tag( 'c:printSettings' );
}


##############################################################################
#
# _write_header_footer()
#
# Write the <c:headerFooter> element.
#
sub _write_header_footer {

    my $self = shift;

    $self->xml_empty_tag( 'c:headerFooter' );
}


##############################################################################
#
# _write_page_margins()
#
# Write the <c:pageMargins> element.
#
sub _write_page_margins {

    my $self   = shift;
    my $b      = 0.75;
    my $l      = 0.7;
    my $r      = 0.7;
    my $t      = 0.75;
    my $header = 0.3;
    my $footer = 0.3;

    my @attributes = (
        'b'      => $b,
        'l'      => $l,
        'r'      => $r,
        't'      => $t,
        'header' => $header,
        'footer' => $footer,
    );

    $self->xml_empty_tag( 'c:pageMargins', @attributes );
}


##############################################################################
#
# _write_page_setup()
#
# Write the <c:pageSetup> element.
#
sub _write_page_setup {

    my $self = shift;

    $self->xml_empty_tag( 'c:pageSetup' );
}


##############################################################################
#
# _write_auto_title_deleted()
#
# Write the <c:autoTitleDeleted> element.
#
sub _write_auto_title_deleted {

    my $self = shift;

    my @attributes = ( 'val' => 1 );

    $self->xml_empty_tag( 'c:autoTitleDeleted', @attributes );
}


##############################################################################
#
# _write_title_rich()
#
# Write the <c:title> element for a rich string.
#
sub _write_title_rich {

    my $self    = shift;
    my $title   = shift;
    my $horiz   = shift;
    my $font    = shift;
    my $layout  = shift;
    my $overlay = shift;

    $self->xml_start_tag( 'c:title' );

    # Write the c:tx element.
    $self->_write_tx_rich( $title, $horiz, $font );

    # Write the c:layout element.
    $self->_write_layout( $layout, 'text' );

    # Write the c:overlay element.
    $self->_write_overlay() if $overlay;

    $self->xml_end_tag( 'c:title' );
}


##############################################################################
#
# _write_title_formula()
#
# Write the <c:title> element for a rich string.
#
sub _write_title_formula {

    my $self    = shift;
    my $title   = shift;
    my $data_id = shift;
    my $horiz   = shift;
    my $font    = shift;
    my $layout  = shift;
    my $overlay = shift;

    $self->xml_start_tag( 'c:title' );

    # Write the c:tx element.
    $self->_write_tx_formula( $title, $data_id );

    # Write the c:layout element.
    $self->_write_layout( $layout, 'text' );

    # Write the c:overlay element.
    $self->_write_overlay() if $overlay;

    # Write the c:txPr element.
    $self->_write_tx_pr( $horiz, $font );

    $self->xml_end_tag( 'c:title' );
}


##############################################################################
#
# _write_tx_rich()
#
# Write the <c:tx> element.
#
sub _write_tx_rich {

    my $self  = shift;
    my $title = shift;
    my $horiz = shift;
    my $font  = shift;

    $self->xml_start_tag( 'c:tx' );

    # Write the c:rich element.
    $self->_write_rich( $title, $horiz, $font );

    $self->xml_end_tag( 'c:tx' );
}


##############################################################################
#
# _write_tx_value()
#
# Write the <c:tx> element with a simple value such as for series names.
#
sub _write_tx_value {

    my $self  = shift;
    my $title = shift;

    $self->xml_start_tag( 'c:tx' );

    # Write the c:v element.
    $self->_write_v( $title );

    $self->xml_end_tag( 'c:tx' );
}


##############################################################################
#
# _write_tx_formula()
#
# Write the <c:tx> element.
#
sub _write_tx_formula {

    my $self    = shift;
    my $title   = shift;
    my $data_id = shift;
    my $data;

    if ( defined $data_id ) {
        $data = $self->{_formula_data}->[$data_id];
    }

    $self->xml_start_tag( 'c:tx' );

    # Write the c:strRef element.
    $self->_write_str_ref( $title, $data, 'str' );

    $self->xml_end_tag( 'c:tx' );
}


##############################################################################
#
# _write_rich()
#
# Write the <c:rich> element.
#
sub _write_rich {

    my $self     = shift;
    my $title    = shift;
    my $horiz    = shift;
    my $rotation = undef;
    my $font     = shift;

    if ( $font && exists $font->{_rotation} ) {
        $rotation = $font->{_rotation};
    }

    $self->xml_start_tag( 'c:rich' );

    # Write the a:bodyPr element.
    $self->_write_a_body_pr( $rotation, $horiz );

    # Write the a:lstStyle element.
    $self->_write_a_lst_style();

    # Write the a:p element.
    $self->_write_a_p_rich( $title, $font );

    $self->xml_end_tag( 'c:rich' );
}


##############################################################################
#
# _write_a_body_pr()
#
# Write the <a:bodyPr> element.
sub _write_a_body_pr {

    my $self  = shift;
    my $rot   = shift;
    my $horiz = shift;

    my @attributes = ();

    if ( !defined $rot && $horiz ) {
        $rot = -5400000;
    }

    push @attributes, ( 'rot' => $rot ) if defined $rot;
    push @attributes, ( 'vert' => 'horz' ) if $horiz;

    $self->xml_empty_tag( 'a:bodyPr', @attributes );
}


##############################################################################
#
# _write_a_lst_style()
#
# Write the <a:lstStyle> element.
#
sub _write_a_lst_style {

    my $self = shift;

    $self->xml_empty_tag( 'a:lstStyle' );
}


##############################################################################
#
# _write_a_p_rich()
#
# Write the <a:p> element for rich string titles.
#
sub _write_a_p_rich {

    my $self  = shift;
    my $title = shift;
    my $font  = shift;

    $self->xml_start_tag( 'a:p' );

    # Write the a:pPr element.
    $self->_write_a_p_pr_rich( $font );

    # Write the a:r element.
    $self->_write_a_r( $title, $font );

    $self->xml_end_tag( 'a:p' );
}


##############################################################################
#
# _write_a_p_formula()
#
# Write the <a:p> element for formula titles.
#
sub _write_a_p_formula {

    my $self = shift;
    my $font = shift;

    $self->xml_start_tag( 'a:p' );

    # Write the a:pPr element.
    $self->_write_a_p_pr_formula( $font );

    # Write the a:endParaRPr element.
    $self->_write_a_end_para_rpr();

    $self->xml_end_tag( 'a:p' );
}


##############################################################################
#
# _write_a_p_pr_rich()
#
# Write the <a:pPr> element for rich string titles.
#
sub _write_a_p_pr_rich {

    my $self = shift;
    my $font = shift;

    $self->xml_start_tag( 'a:pPr' );

    # Write the a:defRPr element.
    $self->_write_a_def_rpr( $font );

    $self->xml_end_tag( 'a:pPr' );
}


##############################################################################
#
# _write_a_p_pr_formula()
#
# Write the <a:pPr> element for formula titles.
#
sub _write_a_p_pr_formula {

    my $self = shift;
    my $font = shift;

    $self->xml_start_tag( 'a:pPr' );

    # Write the a:defRPr element.
    $self->_write_a_def_rpr( $font );

    $self->xml_end_tag( 'a:pPr' );
}


##############################################################################
#
# _write_a_def_rpr()
#
# Write the <a:defRPr> element.
#
sub _write_a_def_rpr {

    my $self      = shift;
    my $font      = shift;
    my $has_color = 0;

    my @style_attributes = $self->_get_font_style_attributes( $font );
    my @latin_attributes = $self->_get_font_latin_attributes( $font );

    $has_color = 1 if $font && $font->{_color};

    if ( @latin_attributes || $has_color ) {
        $self->xml_start_tag( 'a:defRPr', @style_attributes );


        if ( $has_color ) {
            $self->_write_a_solid_fill( { color => $font->{_color} } );
        }

        if ( @latin_attributes ) {
            $self->_write_a_latin( @latin_attributes );
        }

        $self->xml_end_tag( 'a:defRPr' );
    }
    else {
        $self->xml_empty_tag( 'a:defRPr', @style_attributes );
    }
}


##############################################################################
#
# _write_a_end_para_rpr()
#
# Write the <a:endParaRPr> element.
#
sub _write_a_end_para_rpr {

    my $self = shift;
    my $lang = 'en-US';

    my @attributes = ( 'lang' => $lang );

    $self->xml_empty_tag( 'a:endParaRPr', @attributes );
}


##############################################################################
#
# _write_a_r()
#
# Write the <a:r> element.
#
sub _write_a_r {

    my $self  = shift;
    my $title = shift;
    my $font  = shift;

    $self->xml_start_tag( 'a:r' );

    # Write the a:rPr element.
    $self->_write_a_r_pr( $font );

    # Write the a:t element.
    $self->_write_a_t( $title );

    $self->xml_end_tag( 'a:r' );
}


##############################################################################
#
# _write_a_r_pr()
#
# Write the <a:rPr> element.
#
sub _write_a_r_pr {

    my $self      = shift;
    my $font      = shift;
    my $has_color = 0;
    my $lang      = 'en-US';

    my @style_attributes = $self->_get_font_style_attributes( $font );
    my @latin_attributes = $self->_get_font_latin_attributes( $font );

    $has_color = 1 if $font && $font->{_color};

    # Add the lang type to the attributes.
    @style_attributes = ( 'lang' => $lang, @style_attributes );


    if ( @latin_attributes || $has_color ) {
        $self->xml_start_tag( 'a:rPr', @style_attributes );


        if ( $has_color ) {
            $self->_write_a_solid_fill( { color => $font->{_color} } );
        }

        if ( @latin_attributes ) {
            $self->_write_a_latin( @latin_attributes );
        }

        $self->xml_end_tag( 'a:rPr' );
    }
    else {
        $self->xml_empty_tag( 'a:rPr', @style_attributes );
    }


}


##############################################################################
#
# _write_a_t()
#
# Write the <a:t> element.
#
sub _write_a_t {

    my $self  = shift;
    my $title = shift;

    $self->xml_data_element( 'a:t', $title );
}


##############################################################################
#
# _write_tx_pr()
#
# Write the <c:txPr> element.
#
sub _write_tx_pr {

    my $self     = shift;
    my $horiz    = shift;
    my $font     = shift;
    my $rotation = undef;

    if ( $font && exists $font->{_rotation} ) {
        $rotation = $font->{_rotation};
    }

    $self->xml_start_tag( 'c:txPr' );

    # Write the a:bodyPr element.
    $self->_write_a_body_pr( $rotation, $horiz );

    # Write the a:lstStyle element.
    $self->_write_a_lst_style();

    # Write the a:p element.
    $self->_write_a_p_formula( $font );

    $self->xml_end_tag( 'c:txPr' );
}


##############################################################################
#
# _write_marker()
#
# Write the <c:marker> element.
#
sub _write_marker {

    my $self = shift;
    my $marker = shift || $self->{_default_marker};

    return unless $marker;
    return if $marker->{automatic};

    $self->xml_start_tag( 'c:marker' );

    # Write the c:symbol element.
    $self->_write_symbol( $marker->{type} );

    # Write the c:size element.
    my $size = $marker->{size};
    $self->_write_marker_size( $size ) if $size;

    # Write the c:spPr element.
    $self->_write_sp_pr( $marker );

    $self->xml_end_tag( 'c:marker' );
}


##############################################################################
#
# _write_marker_value()
#
# Write the <c:marker> element without a sub-element.
#
sub _write_marker_value {

    my $self  = shift;
    my $style = $self->{_default_marker};

    return unless $style;

    my @attributes = ( 'val' => 1 );

    $self->xml_empty_tag( 'c:marker', @attributes );
}


##############################################################################
#
# _write_marker_size()
#
# Write the <c:size> element.
#
sub _write_marker_size {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:size', @attributes );
}


##############################################################################
#
# _write_symbol()
#
# Write the <c:symbol> element.
#
sub _write_symbol {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:symbol', @attributes );
}


##############################################################################
#
# _write_sp_pr()
#
# Write the <c:spPr> element.
#
sub _write_sp_pr {

    my $self   = shift;
    my $series = shift;

    if (    !$series->{_line}->{_defined}
        and !$series->{_fill}->{_defined}
        and !$series->{_pattern}
        and !$series->{_gradient} )
    {
        return;
    }


    $self->xml_start_tag( 'c:spPr' );

    # Write the fill elements for solid charts such as pie/doughnut and bar.
    if ( $series->{_fill}->{_defined} ) {

        if ( $series->{_fill}->{none} ) {

            # Write the a:noFill element.
            $self->_write_a_no_fill();
        }
        else {
            # Write the a:solidFill element.
            $self->_write_a_solid_fill( $series->{_fill} );
        }
    }

    if ( $series->{_pattern} ) {

        # Write the a:pattFill element.
        $self->_write_a_patt_fill( $series->{_pattern} );
    }

    if ( $series->{_gradient} ) {

        # Write the a:gradFill element.
        $self->_write_a_grad_fill( $series->{_gradient} );
    }


    # Write the a:ln element.
    if ( $series->{_line}->{_defined} ) {
        $self->_write_a_ln( $series->{_line} );
    }

    $self->xml_end_tag( 'c:spPr' );
}


##############################################################################
#
# _write_a_ln()
#
# Write the <a:ln> element.
#
sub _write_a_ln {

    my $self       = shift;
    my $line       = shift;
    my @attributes = ();

    # Add the line width as an attribute.
    if ( my $width = $line->{width} ) {

        # Round width to nearest 0.25, like Excel.
        $width = int( ( $width + 0.125 ) * 4 ) / 4;

        # Convert to internal units.
        $width = int( 0.5 + ( 12700 * $width ) );

        @attributes = ( 'w' => $width );
    }

    $self->xml_start_tag( 'a:ln', @attributes );

    # Write the line fill.
    if ( $line->{none} ) {

        # Write the a:noFill element.
        $self->_write_a_no_fill();
    }
    elsif ( $line->{color} ) {

        # Write the a:solidFill element.
        $self->_write_a_solid_fill( $line );
    }

    # Write the line/dash type.
    if ( my $type = $line->{dash_type} ) {

        # Write the a:prstDash element.
        $self->_write_a_prst_dash( $type );
    }

    $self->xml_end_tag( 'a:ln' );
}


##############################################################################
#
# _write_a_no_fill()
#
# Write the <a:noFill> element.
#
sub _write_a_no_fill {

    my $self = shift;

    $self->xml_empty_tag( 'a:noFill' );
}


##############################################################################
#
# _write_a_solid_fill()
#
# Write the <a:solidFill> element.
#
sub _write_a_solid_fill {

    my $self = shift;
    my $fill = shift;

    $self->xml_start_tag( 'a:solidFill' );

    if ( $fill->{color} ) {

        my $color = $self->_get_color( $fill->{color} );

        # Write the a:srgbClr element.
        $self->_write_a_srgb_clr( $color, $fill->{transparency} );
    }

    $self->xml_end_tag( 'a:solidFill' );
}


##############################################################################
#
# _write_a_srgb_clr()
#
# Write the <a:srgbClr> element.
#
sub _write_a_srgb_clr {

    my $self         = shift;
    my $color        = shift;
    my $transparency = shift;

    my @attributes = ( 'val' => $color );

    if ( $transparency ) {
        $self->xml_start_tag( 'a:srgbClr', @attributes );

        # Write the a:alpha element.
        $self->_write_a_alpha( $transparency );

        $self->xml_end_tag( 'a:srgbClr' );
    }
    else {
        $self->xml_empty_tag( 'a:srgbClr', @attributes );
    }
}


##############################################################################
#
# _write_a_alpha()
#
# Write the <a:alpha> element.
#
sub _write_a_alpha {

    my $self = shift;
    my $val  = shift;

    $val = ( 100 - int( $val ) ) * 1000;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'a:alpha', @attributes );
}


##############################################################################
#
# _write_a_prst_dash()
#
# Write the <a:prstDash> element.
#
sub _write_a_prst_dash {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'a:prstDash', @attributes );
}


##############################################################################
#
# _write_trendline()
#
# Write the <c:trendline> element.
#
sub _write_trendline {

    my $self      = shift;
    my $trendline = shift;

    return unless $trendline;

    $self->xml_start_tag( 'c:trendline' );

    # Write the c:name element.
    $self->_write_name( $trendline->{name} );

    # Write the c:spPr element.
    $self->_write_sp_pr( $trendline );

    # Write the c:trendlineType element.
    $self->_write_trendline_type( $trendline->{type} );

    # Write the c:order element for polynomial trendlines.
    if ( $trendline->{type} eq 'poly' ) {
        $self->_write_trendline_order( $trendline->{order} );
    }

    # Write the c:period element for moving average trendlines.
    if ( $trendline->{type} eq 'movingAvg' ) {
        $self->_write_period( $trendline->{period} );
    }

    # Write the c:forward element.
    $self->_write_forward( $trendline->{forward} );

    # Write the c:backward element.
    $self->_write_backward( $trendline->{backward} );

    if ( defined $trendline->{intercept} ) {
        # Write the c:intercept element.
        $self->_write_intercept( $trendline->{intercept} );
    }

    if ($trendline->{display_r_squared}) {
        # Write the c:dispRSqr element.
        $self->_write_disp_rsqr();
    }

    if ($trendline->{display_equation}) {
        # Write the c:dispEq element.
        $self->_write_disp_eq();

        # Write the c:trendlineLbl element.
        $self->_write_trendline_lbl();
    }

    $self->xml_end_tag( 'c:trendline' );
}


##############################################################################
#
# _write_trendline_type()
#
# Write the <c:trendlineType> element.
#
sub _write_trendline_type {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:trendlineType', @attributes );
}


##############################################################################
#
# _write_name()
#
# Write the <c:name> element.
#
sub _write_name {

    my $self = shift;
    my $data = shift;

    return unless defined $data;

    $self->xml_data_element( 'c:name', $data );
}


##############################################################################
#
# _write_trendline_order()
#
# Write the <c:order> element.
#
sub _write_trendline_order {

    my $self = shift;
    my $val = defined $_[0] ? $_[0] : 2;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:order', @attributes );
}


##############################################################################
#
# _write_period()
#
# Write the <c:period> element.
#
sub _write_period {

    my $self = shift;
    my $val = defined $_[0] ? $_[0] : 2;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:period', @attributes );
}


##############################################################################
#
# _write_forward()
#
# Write the <c:forward> element.
#
sub _write_forward {

    my $self = shift;
    my $val  = shift;

    return unless $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:forward', @attributes );
}


##############################################################################
#
# _write_backward()
#
# Write the <c:backward> element.
#
sub _write_backward {

    my $self = shift;
    my $val  = shift;

    return unless $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:backward', @attributes );
}


##############################################################################
#
# _write_intercept()
#
# Write the <c:intercept> element.
#
sub _write_intercept {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:intercept', @attributes );
}


##############################################################################
#
# _write_disp_eq()
#
# Write the <c:dispEq> element.
#
sub _write_disp_eq {

    my $self = shift;

    my @attributes = ( 'val' => 1 );

    $self->xml_empty_tag( 'c:dispEq', @attributes );
}


##############################################################################
#
# _write_disp_rsqr()
#
# Write the <c:dispRSqr> element.
#
sub _write_disp_rsqr {

    my $self = shift;

    my @attributes = ( 'val' => 1 );

    $self->xml_empty_tag( 'c:dispRSqr', @attributes );
}

##############################################################################
#
# _write_trendline_lbl()
#
# Write the <c:trendlineLbl> element.
#
sub _write_trendline_lbl {

    my $self = shift;

    $self->xml_start_tag( 'c:trendlineLbl' );

    # Write the c:layout element.
    $self->_write_layout();

    # Write the c:numFmt element.
    $self->_write_trendline_num_fmt();

    $self->xml_end_tag( 'c:trendlineLbl' );
}

##############################################################################
#
# _write_trendline_num_fmt()
#
# Write the <c:numFmt> element.
#
sub _write_trendline_num_fmt {

    my $self          = shift;
    my $format_code   = 'General';
    my $source_linked = 0;

    my @attributes = (
        'formatCode'   => $format_code,
        'sourceLinked' => $source_linked,
    );

    $self->xml_empty_tag( 'c:numFmt', @attributes );
}

##############################################################################
#
# _write_hi_low_lines()
#
# Write the <c:hiLowLines> element.
#
sub _write_hi_low_lines {

    my $self = shift;

    my $hi_low_lines = $self->{_hi_low_lines};

    return unless $hi_low_lines;

    if ( $hi_low_lines->{_line}->{_defined} ) {

        $self->xml_start_tag( 'c:hiLowLines' );

        # Write the c:spPr element.
        $self->_write_sp_pr( $hi_low_lines );

        $self->xml_end_tag( 'c:hiLowLines' );
    }
    else {
        $self->xml_empty_tag( 'c:hiLowLines' );
    }
}


#############################################################################
#
# _write_drop_lines()
#
# Write the <c:dropLines> element.
#
sub _write_drop_lines {

    my $self = shift;

    my $drop_lines = $self->{_drop_lines};

    return unless $drop_lines;

    if ( $drop_lines->{_line}->{_defined} ) {

        $self->xml_start_tag( 'c:dropLines' );

        # Write the c:spPr element.
        $self->_write_sp_pr( $drop_lines );

        $self->xml_end_tag( 'c:dropLines' );
    }
    else {
        $self->xml_empty_tag( 'c:dropLines' );
    }
}


##############################################################################
#
# _write_overlap()
#
# Write the <c:overlap> element.
#
sub _write_overlap {

    my $self = shift;
    my $val  = shift;

    return if !defined $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:overlap', @attributes );
}


##############################################################################
#
# _write_num_cache()
#
# Write the <c:numCache> element.
#
sub _write_num_cache {

    my $self  = shift;
    my $data  = shift;
    my $count = @$data;

    $self->xml_start_tag( 'c:numCache' );

    # Write the c:formatCode element.
    $self->_write_format_code( 'General' );

    # Write the c:ptCount element.
    $self->_write_pt_count( $count );

    for my $i ( 0 .. $count - 1 ) {
        my $token = $data->[$i];

        # Write non-numeric data as 0.
        if ( defined $token
            && $token !~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/ )
        {
            $token = 0;
        }

        # Write the c:pt element.
        $self->_write_pt( $i, $token );
    }

    $self->xml_end_tag( 'c:numCache' );
}


##############################################################################
#
# _write_str_cache()
#
# Write the <c:strCache> element.
#
sub _write_str_cache {

    my $self  = shift;
    my $data  = shift;
    my $count = @$data;

    $self->xml_start_tag( 'c:strCache' );

    # Write the c:ptCount element.
    $self->_write_pt_count( $count );

    for my $i ( 0 .. $count - 1 ) {

        # Write the c:pt element.
        $self->_write_pt( $i, $data->[$i] );
    }

    $self->xml_end_tag( 'c:strCache' );
}


##############################################################################
#
# _write_format_code()
#
# Write the <c:formatCode> element.
#
sub _write_format_code {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'c:formatCode', $data );
}


##############################################################################
#
# _write_pt_count()
#
# Write the <c:ptCount> element.
#
sub _write_pt_count {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:ptCount', @attributes );
}


##############################################################################
#
# _write_pt()
#
# Write the <c:pt> element.
#
sub _write_pt {

    my $self  = shift;
    my $idx   = shift;
    my $value = shift;

    return if !defined $value;

    my @attributes = ( 'idx' => $idx );

    $self->xml_start_tag( 'c:pt', @attributes );

    # Write the c:v element.
    $self->_write_v( $value );

    $self->xml_end_tag( 'c:pt' );
}


##############################################################################
#
# _write_v()
#
# Write the <c:v> element.
#
sub _write_v {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'c:v', $data );
}


##############################################################################
#
# _write_protection()
#
# Write the <c:protection> element.
#
sub _write_protection {

    my $self = shift;

    return unless $self->{_protection};

    $self->xml_empty_tag( 'c:protection' );
}


##############################################################################
#
# _write_d_pt()
#
# Write the <c:dPt> elements.
#
sub _write_d_pt {

    my $self   = shift;
    my $points = shift;
    my $index  = -1;

    return unless $points;

    for my $point ( @$points ) {

        $index++;
        next unless $point;

        $self->_write_d_pt_point( $index, $point );
    }
}


##############################################################################
#
# _write_d_pt_point()
#
# Write an individual <c:dPt> element.
#
sub _write_d_pt_point {

    my $self   = shift;
    my $index = shift;
    my $point = shift;

        $self->xml_start_tag( 'c:dPt' );

        # Write the c:idx element.
        $self->_write_idx( $index );

        # Write the c:spPr element.
        $self->_write_sp_pr( $point );

        $self->xml_end_tag( 'c:dPt' );

}


##############################################################################
#
# _write_d_lbls()
#
# Write the <c:dLbls> element.
#
sub _write_d_lbls {

    my $self   = shift;
    my $labels = shift;

    return unless $labels;

    $self->xml_start_tag( 'c:dLbls' );

    # Write the c:numFmt element.
    if ( $labels->{num_format} ) {
        $self->_write_data_label_number_format( $labels->{num_format} );
    }

    # Write the data label font elements.
    if ($labels->{font} ) {
        $self->_write_axis_font( $labels->{font} );
    }

    # Write the c:dLblPos element.
    $self->_write_d_lbl_pos( $labels->{position} ) if $labels->{position};

    # Write the c:showLegendKey element.
    $self->_write_show_legend_key() if $labels->{legend_key};

    # Write the c:showVal element.
    $self->_write_show_val() if $labels->{value};

    # Write the c:showCatName element.
    $self->_write_show_cat_name() if $labels->{category};

    # Write the c:showSerName element.
    $self->_write_show_ser_name() if $labels->{series_name};

    # Write the c:showPercent element.
    $self->_write_show_percent() if $labels->{percentage};

    # Write the c:separator element.
    $self->_write_separator($labels->{separator}) if $labels->{separator};

    # Write the c:showLeaderLines element.
    $self->_write_show_leader_lines() if $labels->{leader_lines};

    $self->xml_end_tag( 'c:dLbls' );
}

##############################################################################
#
# _write_show_legend_key()
#
# Write the <c:showLegendKey> element.
#
sub _write_show_legend_key {

    my $self = shift;
    my $val  = 1;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:showLegendKey', @attributes );
}

##############################################################################
#
# _write_show_val()
#
# Write the <c:showVal> element.
#
sub _write_show_val {

    my $self = shift;
    my $val  = 1;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:showVal', @attributes );
}


##############################################################################
#
# _write_show_cat_name()
#
# Write the <c:showCatName> element.
#
sub _write_show_cat_name {

    my $self = shift;
    my $val  = 1;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:showCatName', @attributes );
}


##############################################################################
#
# _write_show_ser_name()
#
# Write the <c:showSerName> element.
#
sub _write_show_ser_name {

    my $self = shift;
    my $val  = 1;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:showSerName', @attributes );
}


##############################################################################
#
# _write_show_percent()
#
# Write the <c:showPercent> element.
#
sub _write_show_percent {

    my $self = shift;
    my $val  = 1;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:showPercent', @attributes );
}

##############################################################################
#
# _write_separator()
#
# Write the <c:separator> element.
#
sub _write_separator {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'c:separator', $data );
}

##############################################################################
#
# _write_show_leader_lines()
#
# Write the <c:showLeaderLines> element.
#
sub _write_show_leader_lines {

    my $self = shift;
    my $val  = 1;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:showLeaderLines', @attributes );
}


##############################################################################
#
# _write_d_lbl_pos()
#
# Write the <c:dLblPos> element.
#
sub _write_d_lbl_pos {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:dLblPos', @attributes );
}


##############################################################################
#
# _write_delete()
#
# Write the <c:delete> element.
#
sub _write_delete {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:delete', @attributes );
}


##############################################################################
#
# _write_c_invert_if_negative()
#
# Write the <c:invertIfNegative> element.
#
sub _write_c_invert_if_negative {

    my $self   = shift;
    my $invert = shift;
    my $val    = 1;

    return unless $invert;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:invertIfNegative', @attributes );
}


##############################################################################
#
# _write_axis_font()
#
# Write the axis font elements.
#
sub _write_axis_font {

    my $self = shift;
    my $font = shift;

    return unless $font;

    $self->xml_start_tag( 'c:txPr' );
    $self->_write_a_body_pr($font->{_rotation});
    $self->_write_a_lst_style();
    $self->xml_start_tag( 'a:p' );

    $self->_write_a_p_pr_rich( $font );

    $self->_write_a_end_para_rpr();
    $self->xml_end_tag( 'a:p' );
    $self->xml_end_tag( 'c:txPr' );
}


##############################################################################
#
# _write_a_latin()
#
# Write the <a:latin> element.
#
sub _write_a_latin {

    my $self       = shift;
    my @attributes = @_;

    $self->xml_empty_tag( 'a:latin', @attributes );
}


##############################################################################
#
# _write_d_table()
#
# Write the <c:dTable> element.
#
sub _write_d_table {

    my $self  = shift;
    my $table = $self->{_table};

    return if !$table;

    $self->xml_start_tag( 'c:dTable' );

    if ( $table->{_horizontal} ) {

        # Write the c:showHorzBorder element.
        $self->_write_show_horz_border();
    }

    if ( $table->{_vertical} ) {

        # Write the c:showVertBorder element.
        $self->_write_show_vert_border();
    }

    if ( $table->{_outline} ) {

        # Write the c:showOutline element.
        $self->_write_show_outline();
    }

    if ( $table->{_show_keys} ) {

        # Write the c:showKeys element.
        $self->_write_show_keys();
    }

    if ( $table->{_font} ) {
        # Write the table font.
        $self->_write_tx_pr( undef, $table->{_font} );
    }

    $self->xml_end_tag( 'c:dTable' );
}


##############################################################################
#
# _write_show_horz_border()
#
# Write the <c:showHorzBorder> element.
#
sub _write_show_horz_border {

    my $self = shift;

    my @attributes = ( 'val' => 1 );

    $self->xml_empty_tag( 'c:showHorzBorder', @attributes );
}

##############################################################################
#
# _write_show_vert_border()
#
# Write the <c:showVertBorder> element.
#
sub _write_show_vert_border {

    my $self = shift;

    my @attributes = ( 'val' => 1 );

    $self->xml_empty_tag( 'c:showVertBorder', @attributes );
}


##############################################################################
#
# _write_show_outline()
#
# Write the <c:showOutline> element.
#
sub _write_show_outline {

    my $self = shift;

    my @attributes = ( 'val' => 1 );

    $self->xml_empty_tag( 'c:showOutline', @attributes );
}


##############################################################################
#
# _write_show_keys()
#
# Write the <c:showKeys> element.
#
sub _write_show_keys {

    my $self = shift;

    my @attributes = ( 'val' => 1 );

    $self->xml_empty_tag( 'c:showKeys', @attributes );
}


##############################################################################
#
# _write_error_bars()
#
# Write the X and Y error bars.
#
sub _write_error_bars {

    my $self       = shift;
    my $error_bars = shift;

    return unless $error_bars;

    if ( $error_bars->{_x_error_bars} ) {
        $self->_write_err_bars( 'x', $error_bars->{_x_error_bars} );
    }

    if ( $error_bars->{_y_error_bars} ) {
        $self->_write_err_bars( 'y', $error_bars->{_y_error_bars} );
    }

}


##############################################################################
#
# _write_err_bars()
#
# Write the <c:errBars> element.
#
sub _write_err_bars {

    my $self       = shift;
    my $direction  = shift;
    my $error_bars = shift;

    return unless $error_bars;

    $self->xml_start_tag( 'c:errBars' );

    # Write the c:errDir element.
    $self->_write_err_dir( $direction );

    # Write the c:errBarType element.
    $self->_write_err_bar_type( $error_bars->{_direction} );

    # Write the c:errValType element.
    $self->_write_err_val_type( $error_bars->{_type} );

    if ( !$error_bars->{_endcap} ) {

        # Write the c:noEndCap element.
        $self->_write_no_end_cap();
    }

    if ( $error_bars->{_type} eq 'stdErr' ) {

        # Don't need to write a c:errValType tag.
    }
    elsif ( $error_bars->{_type} eq 'cust' ) {

        # Write the custom error tags.
        $self->_write_custom_error( $error_bars );
    }
    else {
        # Write the c:val element.
        $self->_write_error_val( $error_bars->{_value} );
    }

    # Write the c:spPr element.
    $self->_write_sp_pr( $error_bars );

    $self->xml_end_tag( 'c:errBars' );
}


##############################################################################
#
# _write_err_dir()
#
# Write the <c:errDir> element.
#
sub _write_err_dir {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:errDir', @attributes );
}


##############################################################################
#
# _write_err_bar_type()
#
# Write the <c:errBarType> element.
#
sub _write_err_bar_type {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:errBarType', @attributes );
}


##############################################################################
#
# _write_err_val_type()
#
# Write the <c:errValType> element.
#
sub _write_err_val_type {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:errValType', @attributes );
}


##############################################################################
#
# _write_no_end_cap()
#
# Write the <c:noEndCap> element.
#
sub _write_no_end_cap {

    my $self = shift;

    my @attributes = ( 'val' => 1 );

    $self->xml_empty_tag( 'c:noEndCap', @attributes );
}


##############################################################################
#
# _write_error_val()
#
# Write the <c:val> element for error bars.
#
sub _write_error_val {

    my $self = shift;
    my $val  = shift;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:val', @attributes );
}


##############################################################################
#
# _write_custom_error()
#
# Write the custom error bars tags.
#
sub _write_custom_error {

    my $self       = shift;
    my $error_bars = shift;

    if ( $error_bars->{_plus_values} ) {

        # Write the c:plus element.
        $self->xml_start_tag( 'c:plus' );

        if ( ref $error_bars->{_plus_values} eq 'ARRAY' ) {
            $self->_write_num_lit( $error_bars->{_plus_values} );
        }
        else {
            $self->_write_num_ref( $error_bars->{_plus_values},
                $error_bars->{_plus_data}, 'num' );
        }

        $self->xml_end_tag( 'c:plus' );
    }

    if ( $error_bars->{_minus_values} ) {

        # Write the c:minus element.
        $self->xml_start_tag( 'c:minus' );

        if ( ref $error_bars->{_minus_values} eq 'ARRAY' ) {
            $self->_write_num_lit( $error_bars->{_minus_values} );
        }
        else {
            $self->_write_num_ref( $error_bars->{_minus_values},
                $error_bars->{_minus_data}, 'num' );
        }

        $self->xml_end_tag( 'c:minus' );
    }
}



##############################################################################
#
# _write_num_lit()
#
# Write the <c:numLit> element for literal number list elements.
#
sub _write_num_lit {

    my $self = shift;
    my $data  = shift;
    my $count = @$data;


    # Write the c:numLit element.
    $self->xml_start_tag( 'c:numLit' );

    # Write the c:formatCode element.
    $self->_write_format_code( 'General' );

    # Write the c:ptCount element.
    $self->_write_pt_count( $count );

    for my $i ( 0 .. $count - 1 ) {
        my $token = $data->[$i];

        # Write non-numeric data as 0.
        if ( defined $token
            && $token !~ /^([+-]?)(?=\d|\.\d)\d*(\.\d*)?([Ee]([+-]?\d+))?$/ )
        {
            $token = 0;
        }

        # Write the c:pt element.
        $self->_write_pt( $i, $token );
    }

    $self->xml_end_tag( 'c:numLit' );


}


##############################################################################
#
# _write_up_down_bars()
#
# Write the <c:upDownBars> element.
#
sub _write_up_down_bars {

    my $self         = shift;
    my $up_down_bars = $self->{_up_down_bars};

    return unless $up_down_bars;

    $self->xml_start_tag( 'c:upDownBars' );

    # Write the c:gapWidth element.
    $self->_write_gap_width( 150 );

    # Write the c:upBars element.
    $self->_write_up_bars( $up_down_bars->{_up} );

    # Write the c:downBars element.
    $self->_write_down_bars( $up_down_bars->{_down} );

    $self->xml_end_tag( 'c:upDownBars' );
}


##############################################################################
#
# _write_gap_width()
#
# Write the <c:gapWidth> element.
#
sub _write_gap_width {

    my $self = shift;
    my $val  = shift;

    return if !defined $val;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:gapWidth', @attributes );
}

##############################################################################
#
# _write_up_bars()
#
# Write the <c:upBars> element.
#
sub _write_up_bars {

    my $self   = shift;
    my $format = shift;

    if ( $format->{_line}->{_defined} || $format->{_fill}->{_defined} ) {

        $self->xml_start_tag( 'c:upBars' );

        # Write the c:spPr element.
        $self->_write_sp_pr( $format );

        $self->xml_end_tag( 'c:upBars' );
    }
    else {
        $self->xml_empty_tag( 'c:upBars' );
    }
}


##############################################################################
#
# _write_down_bars()
#
# Write the <c:downBars> element.
#
sub _write_down_bars {

    my $self   = shift;
    my $format = shift;

    if ( $format->{_line}->{_defined} || $format->{_fill}->{_defined} ) {

        $self->xml_start_tag( 'c:downBars' );

        # Write the c:spPr element.
        $self->_write_sp_pr( $format );

        $self->xml_end_tag( 'c:downBars' );
    }
    else {
        $self->xml_empty_tag( 'c:downBars' );
    }
}


##############################################################################
#
# _write_c_smooth()
#
# Write the <c:smooth> element.
#
sub _write_c_smooth {

    my $self    = shift;
    my $smooth  = shift;

    return unless $smooth;

    my @attributes = ( 'val' => 1 );

    $self->xml_empty_tag( 'c:smooth', @attributes );
}

##############################################################################
#
# _write_disp_units()
#
# Write the <c:dispUnits> element.
#
sub _write_disp_units {

    my $self    = shift;
    my $units   = shift;
    my $display = shift;

    return if not $units;

    my @attributes = ( 'val' => $units );

    $self->xml_start_tag( 'c:dispUnits' );

    $self->xml_empty_tag( 'c:builtInUnit', @attributes );

    if ( $display ) {
        $self->xml_start_tag( 'c:dispUnitsLbl' );
        $self->xml_empty_tag( 'c:layout' );
        $self->xml_end_tag( 'c:dispUnitsLbl' );
    }

    $self->xml_end_tag( 'c:dispUnits' );
}


##############################################################################
#
# _write_a_grad_fill()
#
# Write the <a:gradFill> element.
#
sub _write_a_grad_fill {

    my $self     = shift;
    my $gradient = shift;


    my @attributes = (
        'flip'         => 'none',
        'rotWithShape' => 1,
    );


    if ( $gradient->{_type} eq 'linear' ) {
        @attributes = ();
    }

    $self->xml_start_tag( 'a:gradFill', @attributes );

    # Write the a:gsLst element.
    $self->_write_a_gs_lst( $gradient );

    if ( $gradient->{_type} eq 'linear' ) {
        # Write the a:lin element.
        $self->_write_a_lin( $gradient->{_angle} );
    }
    else {
        # Write the a:path element.
        $self->_write_a_path( $gradient->{_type} );

        # Write the a:tileRect element.
        $self->_write_a_tile_rect( $gradient->{_type} );
    }

    $self->xml_end_tag( 'a:gradFill' );
}


##############################################################################
#
# _write_a_gs_lst()
#
# Write the <a:gsLst> element.
#
sub _write_a_gs_lst {

    my $self      = shift;
    my $gradient  = shift;
    my $positions = $gradient->{_positions};
    my $colors    = $gradient->{_colors};

    $self->xml_start_tag( 'a:gsLst' );

    for my $i ( 0 .. @$colors -1 ) {

        my $pos = int($positions->[$i] * 1000);

        my @attributes = ( 'pos' => $pos );
        $self->xml_start_tag( 'a:gs', @attributes );

        my $color = $self->_get_color( $colors->[$i] );

        # Write the a:srgbClr element.
        # TODO: Wait for a feature request to support transparency.
        $self->_write_a_srgb_clr( $color );

        $self->xml_end_tag( 'a:gs' );
    }

    $self->xml_end_tag( 'a:gsLst' );
}


##############################################################################
#
# _write_a_lin()
#
# Write the <a:lin> element.
#
sub _write_a_lin {

    my $self   = shift;
    my $angle  = shift;
    my $scaled = 0;

    $angle = int( 60000 * $angle );

    my @attributes = (
        'ang'    => $angle,
        'scaled' => $scaled,
    );

    $self->xml_empty_tag( 'a:lin', @attributes );
}

##############################################################################
#
# _write_a_path()
#
# Write the <a:path> element.
#
sub _write_a_path {

    my $self = shift;
    my $type = shift;


    my @attributes = ( 'path' => $type );

    $self->xml_start_tag( 'a:path', @attributes );

    # Write the a:fillToRect element.
    $self->_write_a_fill_to_rect( $type );

    $self->xml_end_tag( 'a:path' );
}


##############################################################################
#
# _write_a_fill_to_rect()
#
# Write the <a:fillToRect> element.
#
sub _write_a_fill_to_rect {

    my $self       = shift;
    my $type       = shift;
    my @attributes = ();

    if ( $type eq 'shape' ) {
        @attributes = (
            'l' => 50000,
            't' => 50000,
            'r' => 50000,
            'b' => 50000,
        );

    }
    else {
        @attributes = (
            'l' => 100000,
            't' => 100000,
        );
    }


    $self->xml_empty_tag( 'a:fillToRect', @attributes );
}


##############################################################################
#
# _write_a_tile_rect()
#
# Write the <a:tileRect> element.
#
sub _write_a_tile_rect {

    my $self       = shift;
    my $type       = shift;
    my @attributes = ();

    if ( $type eq 'shape' ) {
        @attributes = ();
    }
    else {
        @attributes = (
            'r' => -100000,
            'b' => -100000,
        );
    }

    $self->xml_empty_tag( 'a:tileRect', @attributes );
}


##############################################################################
#
# _write_a_patt_fill()
#
# Write the <a:pattFill> element.
#
sub _write_a_patt_fill {

    my $self     = shift;
    my $pattern  = shift;

    my @attributes = ( 'prst' => $pattern->{pattern} );

    $self->xml_start_tag( 'a:pattFill', @attributes );

    # Write the a:fgClr element.
    $self->_write_a_fg_clr( $pattern->{fg_color} );

    # Write the a:bgClr element.
    $self->_write_a_bg_clr( $pattern->{bg_color} );

    $self->xml_end_tag( 'a:pattFill' );
}


##############################################################################
#
# _write_a_fg_clr()
#
# Write the <a:fgClr> element.
#
sub _write_a_fg_clr {

    my $self  = shift;
    my $color = shift;

    $color = $self->_get_color( $color );

    $self->xml_start_tag( 'a:fgClr' );

    # Write the a:srgbClr element.
    $self->_write_a_srgb_clr( $color );

    $self->xml_end_tag( 'a:fgClr' );
}



##############################################################################
#
# _write_a_bg_clr()
#
# Write the <a:bgClr> element.
#
sub _write_a_bg_clr {

    my $self  = shift;
    my $color = shift;

    $color = $self->_get_color( $color );

    $self->xml_start_tag( 'a:bgClr' );

    # Write the a:srgbClr element.
    $self->_write_a_srgb_clr( $color );

    $self->xml_end_tag( 'a:bgClr' );
}


1;

__END__


=head1 NAME

Chart - A class for writing Excel Charts.

=head1 SYNOPSIS

To create a simple Excel file with a chart using Excel::Writer::XLSX:

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart.xlsx' );
    my $worksheet = $workbook->add_worksheet();

    # Add the worksheet data the chart refers to.
    my $data = [
        [ 'Category', 2, 3, 4, 5, 6, 7 ],
        [ 'Value',    1, 4, 5, 2, 1, 5 ],

    ];

    $worksheet->write( 'A1', $data );

    # Add a worksheet chart.
    my $chart = $workbook->add_chart( type => 'column' );

    # Configure the chart.
    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$B$2:$B$7',
    );

    __END__


=head1 DESCRIPTION

The C<Chart> module is an abstract base class for modules that implement charts in L<Excel::Writer::XLSX>. The information below is applicable to all of the available subclasses.

The C<Chart> module isn't used directly. A chart object is created via the Workbook C<add_chart()> method where the chart type is specified:

    my $chart = $workbook->add_chart( type => 'column' );

Currently the supported chart types are:

=over

=item * C<area>

Creates an Area (filled line) style chart. See L<Excel::Writer::XLSX::Chart::Area>.

=item * C<bar>

Creates a Bar style (transposed histogram) chart. See L<Excel::Writer::XLSX::Chart::Bar>.

=item * C<column>

Creates a column style (histogram) chart. See L<Excel::Writer::XLSX::Chart::Column>.

=item * C<line>

Creates a Line style chart. See L<Excel::Writer::XLSX::Chart::Line>.

=item * C<pie>

Creates a Pie style chart. See L<Excel::Writer::XLSX::Chart::Pie>.

=item * C<doughnut>

Creates a Doughnut style chart. See L<Excel::Writer::XLSX::Chart::Doughnut>.

=item * C<scatter>

Creates a Scatter style chart. See L<Excel::Writer::XLSX::Chart::Scatter>.

=item * C<stock>

Creates a Stock style chart. See L<Excel::Writer::XLSX::Chart::Stock>.

=item * C<radar>

Creates a Radar style chart. See L<Excel::Writer::XLSX::Chart::Radar>.

=back

Chart subtypes are also supported in some cases:

    $workbook->add_chart( type => 'bar', subtype => 'stacked' );

The currently available subtypes are:

    area
        stacked
        percent_stacked

    bar
        stacked
        percent_stacked

    column
        stacked
        percent_stacked

    scatter
        straight_with_markers
        straight
        smooth_with_markers
        smooth

    radar
        with_markers
        filled

More charts and sub-types will be supported in time. See the L</TODO> section.


=head1 CHART METHODS

Methods that are common to all chart types are documented below. See the documentation for each of the above chart modules for chart specific information.

=head2 add_series()

In an Excel chart a "series" is a collection of information such as values, X axis labels and the formatting that define which data is plotted.

With an Excel::Writer::XLSX chart object the C<add_series()> method is used to set the properties for a series:

    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$10', # Optional.
        values     => '=Sheet1!$B$2:$B$10', # Required.
        line       => { color => 'blue' },
    );

The properties that can be set are:

=over

=item * C<values>

This is the most important property of a series and must be set for every chart object. It links the chart with the worksheet data that it displays. A formula or array ref can be used for the data range, see below.

=item * C<categories>

This sets the chart category labels. The category is more or less the same as the X axis. In most chart types the C<categories> property is optional and the chart will just assume a sequential series from C<1 .. n>.

=item * C<name>

Set the name for the series. The name is displayed in the chart legend and in the formula bar. The name property is optional and if it isn't supplied it will default to C<Series 1 .. n>.

=item * C<line>

Set the properties of the series line type such as colour and width. See the L</CHART FORMATTING> section below.

=item * C<border>

Set the border properties of the series such as colour and style. See the L</CHART FORMATTING> section below.

=item * C<fill>

Set the fill properties of the series such as colour. See the L</CHART FORMATTING> section below.

=item * C<pattern>

Set the pattern properties of the series. See the L</CHART FORMATTING> section below.

=item * C<gradien>

Set the gradient properties of the series. See the L</CHART FORMATTING> section below.

=item * C<marker>

Set the properties of the series marker such as style and colour. See the L</SERIES OPTIONS> section below.

=item * C<trendline>

Set the properties of the series trendline such as linear, polynomial and moving average types. See the L</SERIES OPTIONS> section below.

=item * C<smooth>

The C<smooth> option is used to set the smooth property of a line series. See the L</SERIES OPTIONS> section below.

=item * C<y_error_bars>

Set vertical error bounds for a chart series. See the L</SERIES OPTIONS> section below.

=item * C<x_error_bars>

Set horizontal error bounds for a chart series. See the L</SERIES OPTIONS> section below.

=item * C<data_labels>

Set data labels for the series. See the L</SERIES OPTIONS> section below.

=item * C<points>

Set properties for individual points in a series. See the L</SERIES OPTIONS> section below.

=item * C<invert_if_negative>

Invert the fill colour for negative values. Usually only applicable to column and bar charts.

=item * C<overlap>

Set the overlap between series in a Bar/Column chart. The range is +/- 100. Default is 0.

    overlap => 20,

Note, it is only necessary to apply this property to one series of the chart.

=item * C<gap>

Set the gap between series in a Bar/Column chart. The range is 0 to 500. Default is 150.

    gap => 200,

Note, it is only necessary to apply this property to one series of the chart.

=back

The C<categories> and C<values> can take either a range formula such as C<=Sheet1!$A$2:$A$7> or, more usefully when generating the range programmatically, an array ref with zero indexed row/column values:

     [ $sheetname, $row_start, $row_end, $col_start, $col_end ]

The following are equivalent:

    $chart->add_series( categories => '=Sheet1!$A$2:$A$7'      ); # Same as ...
    $chart->add_series( categories => [ 'Sheet1', 1, 6, 0, 0 ] ); # Zero-indexed.

You can add more than one series to a chart. In fact, some chart types such as C<stock> require it. The series numbering and order in the Excel chart will be the same as the order in which they are added in Excel::Writer::XLSX.

    # Add the first series.
    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$B$2:$B$7',
        name       => 'Test data series 1',
    );

    # Add another series. Same categories. Different range values.
    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$C$2:$C$7',
        name       => 'Test data series 2',
    );

It is also possible to specify non-contiguous ranges:

    $chart->add_series(
        categories      => '=(Sheet1!$A$1:$A$9,Sheet1!$A$14:$A$25)',
        values          => '=(Sheet1!$B$1:$B$9,Sheet1!$B$14:$B$25)',
    );


=head2 set_x_axis()

The C<set_x_axis()> method is used to set properties of the X axis.

    $chart->set_x_axis( name => 'Quarterly results' );

The properties that can be set are:

    name
    name_font
    name_layout
    num_font
    num_format
    line
    fill
    pattern
    gradient
    min
    max
    minor_unit
    major_unit
    interval_unit
    interval_tick
    crossing
    reverse
    position_axis
    log_base
    label_position
    major_gridlines
    minor_gridlines
    visible
    date_axis
    text_axis
    minor_unit_type
    major_unit_type
    minor_tick_mark
    major_tick_mark
    display_units
    display_units_visible

These are explained below. Some properties are only applicable to value or category axes, as indicated. See L<Value and Category Axes> for an explanation of Excel's distinction between the axis types.

=over

=item * C<name>


Set the name (title or caption) for the axis. The name is displayed below the X axis. The C<name> property is optional. The default is to have no axis name. (Applicable to category and value axes).

    $chart->set_x_axis( name => 'Quarterly results' );

The name can also be a formula such as C<=Sheet1!$A$1>.

=item * C<name_font>

Set the font properties for the axis title. (Applicable to category and value axes).

    $chart->set_x_axis( name_font => { name => 'Arial', size => 10 } );

=item * C<name_layout>

Set the C<(x, y)> position of the axis caption in chart relative units. (Applicable to category and value axes).

    $chart->set_x_axis(
        name        => 'X axis',
        name_layout => {
            x => 0.34,
            y => 0.85,
        }
    );

See the L</CHART LAYOUT> section below.

=item * C<num_font>

Set the font properties for the axis numbers. (Applicable to category and value axes).

    $chart->set_x_axis( num_font => { bold => 1, italic => 1 } );

See the L</CHART FONTS> section below.

=item * C<num_format>

Set the number format for the axis. (Applicable to category and value axes).

    $chart->set_x_axis( num_format => '#,##0.00' );
    $chart->set_y_axis( num_format => '0.00%'    );

The number format is similar to the Worksheet Cell Format C<num_format> apart from the fact that a format index cannot be used. The explicit format string must be used as shown above. See L<Excel::Writer::XLSX/set_num_format()> for more information.

=item * C<line>

Set the properties of the axis line type such as colour and width. See the L</CHART FORMATTING> section below.

    $chart->set_x_axis( line => { none => 1 });


=item * C<fill>

Set the fill properties of the axis such as colour. See the L</CHART FORMATTING> section below. Note, in Excel the axis fill is applied to the area of the numbers of the axis and not to the area of the axis bounding box. That background is set from the chartarea fill.

=item * C<pattern>

Set the pattern properties of the axis such as colour. See the L</CHART FORMATTING> section below.

=item * C<gradient>

Set the gradient properties of the axis such as colour. See the L</CHART FORMATTING> section below.

=item * C<min>

Set the minimum value for the axis range. (Applicable to value axes only.)

    $chart->set_x_axis( min => 20 );

=item * C<max>

Set the maximum value for the axis range. (Applicable to value axes only.)

    $chart->set_x_axis( max => 80 );

=item * C<minor_unit>

Set the increment of the minor units in the axis range. (Applicable to value axes only.)

    $chart->set_x_axis( minor_unit => 0.4 );

=item * C<major_unit>

Set the increment of the major units in the axis range. (Applicable to value axes only.)

    $chart->set_x_axis( major_unit => 2 );

=item * C<interval_unit>

Set the interval unit for a category axis. (Applicable to category axes only.)

    $chart->set_x_axis( interval_unit => 2 );

=item * C<interval_tick>

Set the tick interval for a category axis. (Applicable to category axes only.)

    $chart->set_x_axis( interval_tick => 4 );

=item * C<crossing>

Set the position where the y axis will cross the x axis. (Applicable to category and value axes.)

The C<crossing> value can either be the string C<'max'> to set the crossing at the maximum axis value or a numeric value.

    $chart->set_x_axis( crossing => 3 );
    # or
    $chart->set_x_axis( crossing => 'max' );

B<For category axes the numeric value must be an integer> to represent the category number that the axis crosses at. For value axes it can have any value associated with the axis.

If crossing is omitted (the default) the crossing will be set automatically by Excel based on the chart data.

=item * C<position_axis>

Position the axis on or between the axis tick marks. (Applicable to category axes only.)

There are two allowable values C<on_tick> and C<between>:

    $chart->set_x_axis( position_axis => 'on_tick' );
    $chart->set_x_axis( position_axis => 'between' );

=item * C<reverse>

Reverse the order of the axis categories or values. (Applicable to category and value axes.)

    $chart->set_x_axis( reverse => 1 );

=item * C<log_base>

Set the log base of the axis range. (Applicable to value axes only.)

    $chart->set_x_axis( log_base => 10 );

=item * C<label_position>

Set the "Axis labels" position for the axis. The following positions are available:

    next_to (the default)
    high
    low
    none

=item * C<major_gridlines>

Configure the major gridlines for the axis. The available properties are:

    visible
    line

For example:

    $chart->set_x_axis(
        major_gridlines => {
            visible => 1,
            line    => { color => 'red', width => 1.25, dash_type => 'dash' }
        }
    );

The C<visible> property is usually on for the X-axis but it depends on the type of chart.

The C<line> property sets the gridline properties such as colour and width. See the L</CHART FORMATTING> section below.

=item * C<minor_gridlines>

This takes the same options as C<major_gridlines> above.

The minor gridline C<visible> property is off by default for all chart types.

=item * C<visible>

Configure the visibility of the axis.

    $chart->set_x_axis( visible => 0 );


=item * C<date_axis>

This option is used to treat a category axis with date or time data as a Date Axis. (Applicable to category axes only.)

    $chart->set_x_axis( date_axis => 1 );

This option also allows you to set C<max> and C<min> values for a category axis which isn't allowed by Excel for non-date category axes.

See L<Date Category Axes> for more details.

=item * C<text_axis>

This option is used to treat a category axis explicitly as a Text Axis. (Applicable to category axes only.)

    $chart->set_x_axis( text_axis => 1 );


=item * C<minor_unit_type>

For C<date_axis> axes, see above, this option is used to set the type of the minor units. (Applicable to date category axes only.)

    $chart->set_x_axis(
        date_axis         => 1,
        minor_unit        => 4,
        minor_unit_type   => 'months',
    );

The allowable values for this option are C<days>, C<months> and C<years>.

=item * C<major_unit_type>

Same as C<minor_unit_type>, see above, but for major axes unit types.

More than one property can be set in a call to C<set_x_axis()>:

    $chart->set_x_axis(
        name => 'Quarterly results',
        min  => 10,
        max  => 80,
    );

=item * C<major_tick_mark>

Set the axis major tick mark type to one of the following values:

    none
    inside
    outside
    cross   (inside and outside)

For example:

    $chart->set_x_axis( major_tick_mark => 'none',
                        minor_tick_mark => 'inside' );

=item * C<minor_tick_mark>

Set the axis minor tick mark type. Same as C<major_tick_mark>, see above.

=item * C<display_units>

Set the display units for the axis. This can be useful if the axis numbers are very large but you don't want to represent them in scientific notation. (Applicable to value axes only.) The available display units are:

    hundreds
    thousands
    ten_thousands
    hundred_thousands
    millions
    ten_millions
    hundred_millions
    billions
    trillions

Example:

    $chart->set_x_axis( display_units => 'thousands' )
    $chart->set_y_axis( display_units => 'millions' )


* C<display_units_visible>

Control the visibility of the display units turned on by the previous option. This option is on by default. (Applicable to value axes only.)::

    $chart->set_x_axis( display_units         => 'thousands',
                        display_units_visible => 0 )

=back

=head2 set_y_axis()

The C<set_y_axis()> method is used to set properties of the Y axis. The properties that can be set are the same as for C<set_x_axis>, see above.


=head2 set_x2_axis()

The C<set_x2_axis()> method is used to set properties of the secondary X axis.
The properties that can be set are the same as for C<set_x_axis>, see above.
The default properties for this axis are:

    label_position => 'none',
    crossing       => 'max',
    visible        => 0,


=head2 set_y2_axis()

The C<set_y2_axis()> method is used to set properties of the secondary Y axis.
The properties that can be set are the same as for C<set_x_axis>, see above.
The default properties for this axis are:

    major_gridlines => { visible => 0 }


=head2 combine()

The chart C<combine()> method is used to combine two charts of different
types, for example a column and line chart:

    my $column_chart = $workbook->add_chart( type => 'column', embedded => 1 );

    # Configure the data series for the primary chart.
    $column_chart->add_series(...);

    # Create a new column chart. This will use this as the secondary chart.
    my $line_chart = $workbook->add_chart( type => 'line', embedded => 1 );

    # Configure the data series for the secondary chart.
    $line_chart->add_series(...);

    # Combine the charts.
    $column_chart->combine( $line_chart );

See L<Combined Charts> for more details.


=head2 set_size()

The C<set_size()> method is used to set the dimensions of the chart. The size properties that can be set are:

     width
     height
     x_scale
     y_scale
     x_offset
     y_offset

The C<width> and C<height> are in pixels. The default chart width is 480 pixels and the default height is 288 pixels. The size of the chart can be modified by setting the C<width> and C<height> or by setting the C<x_scale> and C<y_scale>:

    $chart->set_size( width => 720, height => 576 );

    # Same as:

    $chart->set_size( x_scale => 1.5, y_scale => 2 );

The C<x_offset> and C<y_offset> position the top left corner of the chart in the cell that it is inserted into.


Note: the C<x_scale>, C<y_scale>, C<x_offset> and C<y_offset> parameters can also be set via the C<insert_chart()> method:

    $worksheet->insert_chart( 'E2', $chart, 2, 4, 1.5, 2 );


=head2 set_title()

The C<set_title()> method is used to set properties of the chart title.

    $chart->set_title( name => 'Year End Results' );

The properties that can be set are:

=over

=item * C<name>

Set the name (title) for the chart. The name is displayed above the chart. The name can also be a formula such as C<=Sheet1!$A$1>. The name property is optional. The default is to have no chart title.

=item * C<name_font>

Set the font properties for the chart title. See the L</CHART FONTS> section below.

=item * C<overlay>

Allow the title to be overlaid on the chart. Generally used with the layout property below.

=item * C<layout>

Set the C<(x, y)> position of the title in chart relative units:

    $chart->set_title(
        name    => 'Title',
        overlay => 1,
        layout  => {
            x => 0.42,
            y => 0.14,
        }
    );

See the L</CHART LAYOUT> section below.

=item * C<none>

By default Excel adds an automatic chart title to charts with a single series and a user defined series name. The C<none> option turns this default title off. It also turns off all other C<set_title()> options.

    $chart->set_title( none => 1 );

=back


=head2 set_legend()

The C<set_legend()> method is used to set properties of the chart legend.


The properties that can be set are:

=over

=item * C<none>

The C<none> option turns off the chart legend. In Excel chart legends are on by default:

    $chart->set_legend( none => 1 );

Note, for backward compatibility, it is also possible to turn off the legend via the C<position> property:

    $chart->set_legend( position => 'none' );

=item * C<position>

Set the position of the chart legend.

    $chart->set_legend( position => 'bottom' );

The default legend position is C<right>. The available positions are:

    top
    bottom
    left
    right
    overlay_left
    overlay_right
    none

=item * C<layout>

Set the C<(x, y)> position of the legend in chart relative units:

    $chart->set_legend(
        layout => {
            x      => 0.80,
            y      => 0.37,
            width  => 0.12,
            height => 0.25,
        }
    );

See the L</CHART LAYOUT> section below.


=item * C<delete_series>

This allows you to remove 1 or more series from the legend (the series will still display on the chart). This property takes an array ref as an argument and the series are zero indexed:

    # Delete/hide series index 0 and 2 from the legend.
    $chart->set_legend( delete_series => [0, 2] );

=item * C<font>

Set the font properties of the chart legend:

    $chart->set_legend( font => { bold => 1, italic => 1 } );

See the L</CHART FONTS> section below.


=back


=head2 set_chartarea()

The C<set_chartarea()> method is used to set the properties of the chart area.

    $chart->set_chartarea(
        border => { none  => 1 },
        fill   => { color => 'red' }
    );

The properties that can be set are:

=over

=item * C<border>

Set the border properties of the chartarea such as colour and style. See the L</CHART FORMATTING> section below.

=item * C<fill>

Set the fill properties of the chartarea such as colour. See the L</CHART FORMATTING> section below.

=item * C<pattern>

Set the pattern fill properties of the chartarea. See the L</CHART FORMATTING> section below.

=item * C<gradient>

Set the gradient fill properties of the chartarea. See the L</CHART FORMATTING> section below.


=back

=head2 set_plotarea()

The C<set_plotarea()> method is used to set properties of the plot area of a chart.

    $chart->set_plotarea(
        border => { color => 'yellow', width => 1, dash_type => 'dash' },
        fill   => { color => '#92D050' }
    );

The properties that can be set are:

=over

=item * C<border>

Set the border properties of the plotarea such as colour and style. See the L</CHART FORMATTING> section below.

=item * C<fill>

Set the fill properties of the plotarea such as colour. See the L</CHART FORMATTING> section below.


=item * C<pattern>

Set the pattern fill properties of the plotarea. See the L</CHART FORMATTING> section below.

=item * C<gradient>

Set the gradient fill properties of the plotarea. See the L</CHART FORMATTING> section below.

=item * C<layout>

Set the C<(x, y)> position of the plotarea in chart relative units:

    $chart->set_plotarea(
        layout => {
            x      => 0.35,
            y      => 0.26,
            width  => 0.62,
            height => 0.50,
        }
    );

See the L</CHART LAYOUT> section below.

=back


=head2 set_style()

The C<set_style()> method is used to set the style of the chart to one of the 42 built-in styles available on the 'Design' tab in Excel:

    $chart->set_style( 4 );

The default style is 2.


=head2 set_table()

The C<set_table()> method adds a data table below the horizontal axis with the data used to plot the chart.

    $chart->set_table();

The available options, with default values are:

    vertical   => 1    # Display vertical lines in the table.
    horizontal => 1    # Display horizontal lines in the table.
    outline    => 1    # Display an outline in the table.
    show_keys  => 0    # Show the legend keys with the table data.
    font       => {}   # Standard chart font properties.

The data table can only be shown with Bar, Column, Line, Area and stock charts. For font properties see the L</CHART FONTS> section below.


=head2 set_up_down_bars

The C<set_up_down_bars()> method adds Up-Down bars to Line charts to indicate the difference between the first and last data series.

    $chart->set_up_down_bars();

It is possible to format the up and down bars to add C<fill>, C<pattern>, C<gradient> and C<border> properties if required. See the L</CHART FORMATTING> section below.

    $chart->set_up_down_bars(
        up   => { fill => { color => 'green' } },
        down => { fill => { color => 'red' } },
    );

Up-down bars can only be applied to Line charts and to Stock charts (by default).


=head2 set_drop_lines

The C<set_drop_lines()> method adds Drop Lines to charts to show the Category value of points in the data.

    $chart->set_drop_lines();

It is possible to format the Drop Line C<line> properties if required. See the L</CHART FORMATTING> section below.

    $chart->set_drop_lines( line => { color => 'red', dash_type => 'square_dot' } );

Drop Lines are only available in Line, Area and Stock charts.


=head2 set_high_low_lines

The C<set_high_low_lines()> method adds High-Low lines to charts to show the maximum and minimum values of points in a Category.

    $chart->set_high_low_lines();

It is possible to format the High-Low Line C<line> properties if required. See the L</CHART FORMATTING> section below.

    $chart->set_high_low_lines( line => { color => 'red' } );

High-Low Lines are only available in Line and Stock charts.


=head2 show_blanks_as()

The C<show_blanks_as()> method controls how blank data is displayed in a chart.

    $chart->show_blanks_as( 'span' );

The available options are:

        gap    # Blank data is shown as a gap. The default.
        zero   # Blank data is displayed as zero.
        span   # Blank data is connected with a line.


=head2 show_hidden_data()

Display data in hidden rows or columns on the chart.

    $chart->show_hidden_data();


=head1 SERIES OPTIONS

This section details the following properties of C<add_series()> in more detail:

    marker
    trendline
    y_error_bars
    x_error_bars
    data_labels
    points
    smooth

=head2 Marker

The marker format specifies the properties of the markers used to distinguish series on a chart. In general only Line and Scatter chart types and trendlines use markers.

The following properties can be set for C<marker> formats in a chart.

    type
    size
    border
    fill
    pattern
    gradient

The C<type> property sets the type of marker that is used with a series.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        marker     => { type => 'diamond' },
    );

The following C<type> properties can be set for C<marker> formats in a chart. These are shown in the same order as in the Excel format dialog.

    automatic
    none
    square
    diamond
    triangle
    x
    star
    short_dash
    long_dash
    circle
    plus

The C<automatic> type is a special case which turns on a marker using the default marker style for the particular series number.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        marker     => { type => 'automatic' },
    );

If C<automatic> is on then other marker properties such as size, border or fill cannot be set.

The C<size> property sets the size of the marker and is generally used in conjunction with C<type>.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        marker     => { type => 'diamond', size => 7 },
    );

Nested C<border> and C<fill> properties can also be set for a marker. See the L</CHART FORMATTING> section below.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        marker     => {
            type    => 'square',
            size    => 5,
            border  => { color => 'red' },
            fill    => { color => 'yellow' },
        },
    );


=head2 Trendline

A trendline can be added to a chart series to indicate trends in the data such as a moving average or a polynomial fit.

The following properties can be set for trendlines in a chart series.

    type
    order               (for polynomial trends)
    period              (for moving average)
    forward             (for all except moving average)
    backward            (for all except moving average)
    name
    line
    intercept           (for exponential, linear and polynomial only)
    display_equation    (for all except moving average)
    display_r_squared   (for all except moving average)


The C<type> property sets the type of trendline in the series.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        trendline  => { type => 'linear' },
    );

The available C<trendline> types are:

    exponential
    linear
    log
    moving_average
    polynomial
    power

A C<polynomial> trendline can also specify the C<order> of the polynomial. The default value is 2.

    $chart->add_series(
        values    => '=Sheet1!$B$1:$B$5',
        trendline => {
            type  => 'polynomial',
            order => 3,
        },
    );

A C<moving_average> trendline can also specify the C<period> of the moving average. The default value is 2.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        trendline  => {
            type   => 'moving_average',
            period => 3,
        },
    );

The C<forward> and C<backward> properties set the forecast period of the trendline.

    $chart->add_series(
        values    => '=Sheet1!$B$1:$B$5',
        trendline => {
            type     => 'linear',
            forward  => 0.5,
            backward => 0.5,
        },
    );

The C<name> property sets an optional name for the trendline that will appear in the chart legend. If it isn't specified the Excel default name will be displayed. This is usually a combination of the trendline type and the series name.

    $chart->add_series(
        values    => '=Sheet1!$B$1:$B$5',
        trendline => {
            type => 'linear',
            name => 'Interpolated trend',
        },
    );

The C<intercept> property sets the point where the trendline crosses the Y (value) axis:

    $chart->add_series(
        values    => '=Sheet1!$B$1:$B$5',
        trendline => {
            type      => 'linear',
            intercept => 0.8,
        },
    );


The C<display_equation> property displays the trendline equation on the chart.

    $chart->add_series(
        values    => '=Sheet1!$B$1:$B$5',
        trendline => {
            type             => 'linear',
            display_equation => 1,
        },
    );

The C<display_r_squared> property displays the R squared value of the trendline on the chart.

    $chart->add_series(
        values    => '=Sheet1!$B$1:$B$5',
        trendline => {
            type              => 'linear',
            display_r_squared => 1
        },
    );


Several of these properties can be set in one go:

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        trendline  => {
            type              => 'polynomial',
            name              => 'My trend name',
            order             => 2,
            forward           => 0.5,
            backward          => 0.5,
            intercept         => 1.5,
            display_equation  => 1,
            display_r_squared => 1,
            line              => {
                color     => 'red',
                width     => 1,
                dash_type => 'long_dash',
            }
        },
    );

Trendlines cannot be added to series in a stacked chart or pie chart, radar chart, doughnut or (when implemented) to 3D, or surface charts.

=head2 Error Bars

Error bars can be added to a chart series to indicate error bounds in the data. The error bars can be vertical C<y_error_bars> (the most common type) or horizontal C<x_error_bars> (for Bar and Scatter charts only).

The following properties can be set for error bars in a chart series.

    type
    value        (for all types except standard error and custom)
    plus_values  (for custom only)
    minus_values (for custom only)
    direction
    end_style
    line

The C<type> property sets the type of error bars in the series.

    $chart->add_series(
        values       => '=Sheet1!$B$1:$B$5',
        y_error_bars => { type => 'standard_error' },
    );

The available error bars types are available:

    fixed
    percentage
    standard_deviation
    standard_error
    custom

All error bar types, except for C<standard_error> and C<custom> must also have a value associated with it for the error bounds:

    $chart->add_series(
        values       => '=Sheet1!$B$1:$B$5',
        y_error_bars => {
            type  => 'percentage',
            value => 5,
        },
    );

The C<custom> error bar type must specify C<plus_values> and C<minus_values> which should either by a C<Sheet1!$A$1:$A$5> type range formula or an arrayref of
values:

    $chart->add_series(
        categories   => '=Sheet1!$A$1:$A$5',
        values       => '=Sheet1!$B$1:$B$5',
        y_error_bars => {
            type         => 'custom',
            plus_values  => '=Sheet1!$C$1:$C$5',
            minus_values => '=Sheet1!$D$1:$D$5',
        },
    );

    # or


    $chart->add_series(
        categories   => '=Sheet1!$A$1:$A$5',
        values       => '=Sheet1!$B$1:$B$5',
        y_error_bars => {
            type         => 'custom',
            plus_values  => [1, 1, 1, 1, 1],
            minus_values => [2, 2, 2, 2, 2],
        },
    );

Note, as in Excel the items in the C<minus_values> do not need to be negative.

The C<direction> property sets the direction of the error bars. It should be one of the following:

    plus    # Positive direction only.
    minus   # Negative direction only.
    both    # Plus and minus directions, The default.

The C<end_style> property sets the style of the error bar end cap. The options are 1 (the default) or 0 (for no end cap):

    $chart->add_series(
        values       => '=Sheet1!$B$1:$B$5',
        y_error_bars => {
            type      => 'fixed',
            value     => 2,
            end_style => 0,
            direction => 'minus'
        },
    );



=head2 Data Labels

Data labels can be added to a chart series to indicate the values of the plotted data points.

The following properties can be set for C<data_labels> formats in a chart.

    value
    category
    series_name
    position
    percentage
    leader_lines
    separator
    legend_key
    num_format
    font

The C<value> property turns on the I<Value> data label for a series.

    $chart->add_series(
        values      => '=Sheet1!$B$1:$B$5',
        data_labels => { value => 1 },
    );

The C<category> property turns on the I<Category Name> data label for a series.

    $chart->add_series(
        values      => '=Sheet1!$B$1:$B$5',
        data_labels => { category => 1 },
    );


The C<series_name> property turns on the I<Series Name> data label for a series.

    $chart->add_series(
        values      => '=Sheet1!$B$1:$B$5',
        data_labels => { series_name => 1 },
    );

The C<position> property is used to position the data label for a series.

    $chart->add_series(
        values      => '=Sheet1!$B$1:$B$5',
        data_labels => { value => 1, position => 'center' },
    );

In Excel the data label positions vary for different chart types. The allowable positions are:

    |  Position     |  Line     |  Bar      |  Pie      |  Area     |
    |               |  Scatter  |  Column   |  Doughnut |  Radar    |
    |               |  Stock    |           |           |           |
    |---------------|-----------|-----------|-----------|-----------|
    |  center       |  Yes      |  Yes      |  Yes      |  Yes*     |
    |  right        |  Yes*     |           |           |           |
    |  left         |  Yes      |           |           |           |
    |  above        |  Yes      |           |           |           |
    |  below        |  Yes      |           |           |           |
    |  inside_base  |           |  Yes      |           |           |
    |  inside_end   |           |  Yes      |  Yes      |           |
    |  outside_end  |           |  Yes*     |  Yes      |           |
    |  best_fit     |           |           |  Yes*     |           |

Note: The * indicates the default position for each chart type in Excel, if a position isn't specified.

The C<percentage> property is used to turn on the display of data labels as a I<Percentage> for a series. It is mainly used for pie and doughnut charts.

    $chart->add_series(
        values      => '=Sheet1!$B$1:$B$5',
        data_labels => { percentage => 1 },
    );

The C<leader_lines> property is used to turn on  I<Leader Lines> for the data label for a series. It is mainly used for pie charts.

    $chart->add_series(
        values      => '=Sheet1!$B$1:$B$5',
        data_labels => { value => 1, leader_lines => 1 },
    );

Note: Even when leader lines are turned on they aren't automatically visible in Excel or Excel::Writer::XLSX. Due to an Excel limitation (or design) leader lines only appear if the data label is moved manually or if the data labels are very close and need to be adjusted automatically.

The C<separator> property is used to change the separator between multiple data label items:

    $chart->add_series(
        values      => '=Sheet1!$B$1:$B$5',
        data_labels => { percentage => 1 },
        data_labels => { value => 1, category => 1, separator => "\n" },
    );

The separator value must be one of the following strings:

            ','
            ';'
            '.'
            "\n"
            ' '

The C<legend_key> property is used to turn on  I<Legend Key> for the data label for a series:

    $chart->add_series(
        values      => '=Sheet1!$B$1:$B$5',
        data_labels => { value => 1, legend_key => 1 },
    );


The C<num_format> property is used to set the number format for the data labels.

    $chart->add_series(
        values      => '=Sheet1!$A$1:$A$5',
        data_labels => { value => 1, num_format => '#,##0.00' },
    );

The number format is similar to the Worksheet Cell Format C<num_format> apart from the fact that a format index cannot be used. The explicit format string must be used as shown above. See L<Excel::Writer::XLSX/set_num_format()> for more information.

The C<font> property is used to set the font properties of the data labels in a series:

    $chart->add_series(
        values      => '=Sheet1!$A$1:$A$5',
        data_labels => {
            value => 1,
            font  => { name => 'Consolas' }
        },
    );

The C<font> property is also used to rotate the data labels in a series:

    $chart->add_series(
        values      => '=Sheet1!$A$1:$A$5',
        data_labels => {
            value => 1,
            font  => { rotation => 45 }
        },
    );

See the L</CHART FONTS> section below.


=head2 Points

In general formatting is applied to an entire series in a chart. However, it is occasionally required to format individual points in a series. In particular this is required for Pie and Doughnut charts where each segment is represented by a point.

In these cases it is possible to use the C<points> property of C<add_series()>:

    $chart->add_series(
        values => '=Sheet1!$A$1:$A$3',
        points => [
            { fill => { color => '#FF0000' } },
            { fill => { color => '#CC0000' } },
            { fill => { color => '#990000' } },
        ],
    );

The C<points> property takes an array ref of format options (see the L</CHART FORMATTING> section below). To assign default properties to points in a series pass C<undef> values in the array ref:

    # Format point 3 of 3 only.
    $chart->add_series(
        values => '=Sheet1!$A$1:$A$3',
        points => [
            undef,
            undef,
            { fill => { color => '#990000' } },
        ],
    );

    # Format the first point only.
    $chart->add_series(
        values => '=Sheet1!$A$1:$A$3',
        points => [ { fill => { color => '#FF0000' } } ],
    );

=head2 Smooth

The C<smooth> option is used to set the smooth property of a line series. It is only applicable to the C<Line> and C<Scatter> chart types.

    $chart->add_series( values => '=Sheet1!$C$1:$C$5',
                        smooth => 1 );


=head1 CHART FORMATTING

The following chart formatting properties can be set for any chart object that they apply to (and that are supported by Excel::Writer::XLSX) such as chart lines, column fill areas, plot area borders, markers, gridlines and other chart elements documented above.

    line
    border
    fill
    pattern
    gradient

Chart formatting properties are generally set using hash refs.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        line       => { color => 'blue' },
    );

In some cases the format properties can be nested. For example a C<marker> may contain C<border> and C<fill> sub-properties.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        line       => { color => 'blue' },
        marker     => {
            type    => 'square',
            size    => 5,
            border  => { color => 'red' },
            fill    => { color => 'yellow' },
        },
    );

=head2 Line

The line format is used to specify properties of line objects that appear in a chart such as a plotted line on a chart or a border.

The following properties can be set for C<line> formats in a chart.

    none
    color
    width
    dash_type


The C<none> property is uses to turn the C<line> off (it is always on by default except in Scatter charts). This is useful if you wish to plot a series with markers but without a line.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        line       => { none => 1 },
    );


The C<color> property sets the color of the C<line>.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        line       => { color => 'red' },
    );

The available colours are shown in the main L<Excel::Writer::XLSX> documentation. It is also possible to set the colour of a line with a HTML style RGB colour:

    $chart->add_series(
        line       => { color => '#FF0000' },
    );


The C<width> property sets the width of the C<line>. It should be specified in increments of 0.25 of a point as in Excel.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        line       => { width => 3.25 },
    );

The C<dash_type> property sets the dash style of the line.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        line       => { dash_type => 'dash_dot' },
    );

The following C<dash_type> values are available. They are shown in the order that they appear in the Excel dialog.

    solid
    round_dot
    square_dot
    dash
    dash_dot
    long_dash
    long_dash_dot
    long_dash_dot_dot

The default line style is C<solid>.

More than one C<line> property can be specified at a time:

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        line       => {
            color     => 'red',
            width     => 1.25,
            dash_type => 'square_dot',
        },
    );

=head2 Border

The C<border> property is a synonym for C<line>.

It can be used as a descriptive substitute for C<line> in chart types such as Bar and Column that have a border and fill style rather than a line style. In general chart objects with a C<border> property will also have a fill property.


=head2 Solid Fill

The fill format is used to specify filled areas of chart objects such as the interior of a column or the background of the chart itself.

The following properties can be set for C<fill> formats in a chart.

    none
    color
    transparency

The C<none> property is used to turn the C<fill> property off (it is generally on by default).


    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        fill       => { none => 1 },
    );

The C<color> property sets the colour of the C<fill> area.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        fill       => { color => 'red' },
    );

The available colours are shown in the main L<Excel::Writer::XLSX> documentation. It is also possible to set the colour of a fill with a HTML style RGB colour:

    $chart->add_series(
        fill       => { color => '#FF0000' },
    );

The C<transparency> property sets the transparency of the solid fill color in the integer range 1 - 100:

    $chart->set_chartarea( fill => { color => 'yellow', transparency => 75 } );

The C<fill> format is generally used in conjunction with a C<border> format which has the same properties as a C<line> format.

    $chart->add_series(
        values     => '=Sheet1!$B$1:$B$5',
        border     => { color => 'red' },
        fill       => { color => 'yellow' },
    );



=head2 Pattern Fill

The pattern fill format is used to specify pattern filled areas of chart objects such as the interior of a column or the background of the chart itself.

The following properties can be set for C<pattern> fill formats in a chart:

    pattern:   the pattern to be applied (required)
    fg_color:  the foreground color of the pattern (required)
    bg_color:  the background color (optional, defaults to white)


For example:

    $chart->set_plotarea(
        pattern => {
            pattern  => 'percent_5',
            fg_color => 'red',
            bg_color => 'yellow',
        }
    );

The following patterns can be applied:

    percent_5
    percent_10
    percent_20
    percent_25
    percent_30
    percent_40
    percent_50
    percent_60
    percent_70
    percent_75
    percent_80
    percent_90
    light_downward_diagonal
    light_upward_diagonal
    dark_downward_diagonal
    dark_upward_diagonal
    wide_downward_diagonal
    wide_upward_diagonal
    light_vertical
    light_horizontal
    narrow_vertical
    narrow_horizontal
    dark_vertical
    dark_horizontal
    dashed_downward_diagonal
    dashed_upward_diagonal
    dashed_horizontal
    dashed_vertical
    small_confetti
    large_confetti
    zigzag
    wave
    diagonal_brick
    horizontal_brick
    weave
    plaid
    divot
    dotted_grid
    dotted_diamond
    shingle
    trellis
    sphere
    small_grid
    large_grid
    small_check
    large_check
    outlined_diamond
    solid_diamond


The foreground color, C<fg_color>, is a required parameter and can be a Html style C<#RRGGBB> string or a limited number of named colors. The available colours are shown in the main L<Excel::Writer::XLSX> documentation.

The background color, C<bg_color>, is optional and defaults to black.

If a pattern fill is used on a chart object it overrides the solid fill properties of the object.


=head2 Gradient Fill

The gradient fill format is used to specify gradient filled areas of chart objects such as the interior of a column or the background of the chart itself.


The following properties can be set for C<gradient> fill formats in a chart:

    colors:    a list of colors
    positions: an optional list of positions for the colors
    type:      the optional type of gradient fill
    angle:     the optional angle of the linear fill

The C<colors> property sets a list of colors that define the C<gradient>:

    $chart->set_plotarea(
        gradient => { colors => [ '#DDEBCF', '#9CB86E', '#156B13' ] }
    );

Excel allows between 2 and 10 colors in a gradient but it is unlikely that you will require more than 2 or 3.

As with solid or pattern fill it is also possible to set the colors of a gradient with a Html style C<#RRGGBB> string or a limited number of named colors. The available colours are shown in the main L<Excel::Writer::XLSX> documentation:

    $chart->add_series(
        values   => '=Sheet1!$A$1:$A$5',
        gradient => { colors => [ 'red', 'green' ] }
    );

The C<positions> defines an optional list of positions, between 0 and 100, of
where the colors in the gradient are located. Default values are provided for
C<colors> lists of between 2 and 4 but they can be specified if required:

    $chart->add_series(
        values   => '=Sheet1!$A$1:$A$5',
        gradient => {
            colors    => [ '#DDEBCF', '#156B13' ],
            positions => [ 10,        90 ],
        }
    );

The C<type> property can have one of the following values:

    linear        (the default)
    radial
    rectangular
    path

For example:

    $chart->add_series(
        values   => '=Sheet1!$A$1:$A$5',
        gradient => {
            colors => [ '#DDEBCF', '#9CB86E', '#156B13' ],
            type   => 'radial'
        }
    );

If C<type> isn't specified it defaults to C<linear>.

For a C<linear> fill the angle of the gradient can also be specified:

    $chart->add_series(
        values   => '=Sheet1!$A$1:$A$5',
        gradient => { colors => [ '#DDEBCF', '#9CB86E', '#156B13' ],
                      angle => 30 }
    );

The default angle is 90 degrees.

If gradient fill is used on a chart object it overrides the solid fill and pattern fill properties of the object.




=head1 CHART FONTS

The following font properties can be set for any chart object that they apply to (and that are supported by Excel::Writer::XLSX) such as chart titles, axis labels, axis numbering and data labels. They correspond to the equivalent Worksheet cell Format object properties. See L<Excel::Writer::XLSX/FORMAT_METHODS> for more information.

    name
    size
    bold
    italic
    underline
    rotation
    color

The following explains the available font properties:

=over

=item * C<name>

Set the font name:

    $chart->set_x_axis( num_font => { name => 'Arial' } );

=item * C<size>

Set the font size:

    $chart->set_x_axis( num_font => { name => 'Arial', size => 10 } );

=item * C<bold>

Set the font bold property, should be 0 or 1:

    $chart->set_x_axis( num_font => { bold => 1 } );

=item * C<italic>

Set the font italic property, should be 0 or 1:

    $chart->set_x_axis( num_font => { italic => 1 } );

=item * C<underline>

Set the font underline property, should be 0 or 1:

    $chart->set_x_axis( num_font => { underline => 1 } );

=item * C<rotation>

Set the font rotation in the range -90 to 90:

    $chart->set_x_axis( num_font => { rotation => 45 } );

This is useful for displaying large axis data such as dates in a more compact format.

=item * C<color>

Set the font color property. Can be a color index, a color name or HTML style RGB colour:

    $chart->set_x_axis( num_font => { color => 'red' } );
    $chart->set_y_axis( num_font => { color => '#92D050' } );

=back

Here is an example of Font formatting in a Chart program:

    # Format the chart title.
    $chart->set_title(
        name      => 'Sales Results Chart',
        name_font => {
            name  => 'Calibri',
            color => 'yellow',
        },
    );

    # Format the X-axis.
    $chart->set_x_axis(
        name      => 'Month',
        name_font => {
            name  => 'Arial',
            color => '#92D050'
        },
        num_font => {
            name  => 'Courier New',
            color => '#00B0F0',
        },
    );

    # Format the Y-axis.
    $chart->set_y_axis(
        name      => 'Sales (1000 units)',
        name_font => {
            name      => 'Century',
            underline => 1,
            color     => 'red'
        },
        num_font => {
            bold   => 1,
            italic => 1,
            color  => '#7030A0',
        },
    );



=head1 CHART LAYOUT

The position of the chart in the worksheet is controlled by the C<set_size()> method shown above.

It is also possible to change the layout of the following chart sub-objects:

    plotarea
    legend
    title
    x_axis caption
    y_axis caption

Here are some examples:

    $chart->set_plotarea(
        layout => {
            x      => 0.35,
            y      => 0.26,
            width  => 0.62,
            height => 0.50,
        }
    );

    $chart->set_legend(
        layout => {
            x      => 0.80,
            y      => 0.37,
            width  => 0.12,
            height => 0.25,
        }
    );

    $chart->set_title(
        name   => 'Title',
        layout => {
            x => 0.42,
            y => 0.14,
        }
    );

    $chart->set_x_axis(
        name        => 'X axis',
        name_layout => {
            x => 0.34,
            y => 0.85,
        }
    );

Note that it is only possible to change the width and height for the C<plotarea> and C<legend> objects. For the other text based objects the width and height are changed by the font dimensions.

The layout units must be a float in the range C<0 < x <= 1> and are expressed as a percentage of the chart dimensions as shown below:

=begin html

<p><center><img src="http://jmcnamara.github.io/excel-writer-xlsx/images/examples/layout.png" width="826" height="423" alt="Chart object layout." /></center></p>

=end html

From this the layout units are calculated as follows:

    layout:
        width  = w / W
        height = h / H
        x      = a / W
        y      = b / H

These units are slightly cumbersome but are required by Excel so that the chart object positions remain relative to each other if the chart is resized by the user.

Note that for C<plotarea> the origin is the top left corner in the plotarea itself and does not take into account the axes.


=head1 WORKSHEET METHODS

In Excel a chartsheet (i.e, a chart that isn't embedded) shares properties with data worksheets such as tab selection, headers, footers, margins, and print properties.

In Excel::Writer::XLSX you can set chartsheet properties using the same methods that are used for Worksheet objects.

The following Worksheet methods are also available through a non-embedded Chart object:

    get_name()
    activate()
    select()
    hide()
    set_first_sheet()
    protect()
    set_zoom()
    set_tab_color()

    set_landscape()
    set_portrait()
    set_paper()
    set_margins()
    set_header()
    set_footer()

See L<Excel::Writer::XLSX> for a detailed explanation of these methods.

=head1 EXAMPLE

Here is a complete example that demonstrates some of the available features when creating a chart.

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart.xlsx' );
    my $worksheet = $workbook->add_worksheet();
    my $bold      = $workbook->add_format( bold => 1 );

    # Add the worksheet data that the charts will refer to.
    my $headings = [ 'Number', 'Batch 1', 'Batch 2' ];
    my $data = [
        [ 2,  3,  4,  5,  6,  7 ],
        [ 10, 40, 50, 20, 10, 50 ],
        [ 30, 60, 70, 50, 40, 30 ],

    ];

    $worksheet->write( 'A1', $headings, $bold );
    $worksheet->write( 'A2', $data );

    # Create a new chart object. In this case an embedded chart.
    my $chart = $workbook->add_chart( type => 'column', embedded => 1 );

    # Configure the first series.
    $chart->add_series(
        name       => '=Sheet1!$B$1',
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$B$2:$B$7',
    );

    # Configure second series. Note alternative use of array ref to define
    # ranges: [ $sheetname, $row_start, $row_end, $col_start, $col_end ].
    $chart->add_series(
        name       => '=Sheet1!$C$1',
        categories => [ 'Sheet1', 1, 6, 0, 0 ],
        values     => [ 'Sheet1', 1, 6, 2, 2 ],
    );

    # Add a chart title and some axis labels.
    $chart->set_title ( name => 'Results of sample analysis' );
    $chart->set_x_axis( name => 'Test number' );
    $chart->set_y_axis( name => 'Sample length (mm)' );

    # Set an Excel chart style. Blue colors with white outline and shadow.
    $chart->set_style( 11 );

    # Insert the chart into the worksheet (with an offset).
    $worksheet->insert_chart( 'D2', $chart, 25, 10 );

    __END__

=begin html

<p>This will produce a chart that looks like this:</p>

<p><center><img src="http://jmcnamara.github.io/excel-writer-xlsx/images/examples/area1.jpg" width="527" height="320" alt="Chart example." /></center></p>

=end html


=head1 Value and Category Axes

Excel differentiates between a chart axis that is used for series B<categories> and an axis that is used for series B<values>.

In the example above the X axis is the category axis and each of the values is evenly spaced. The Y axis (in this case) is the value axis and points are displayed according to their value.

Since Excel treats the axes differently it also handles their formatting differently and exposes different properties for each.

As such some of C<Excel::Writer::XLSX> axis properties can be set for a value axis, some can be set for a category axis and some properties can be set for both.

For example the C<min> and C<max> properties can only be set for value axes and C<reverse> can be set for both. The type of axis that a property applies to is shown in the C<set_x_axis()> section of the documentation above.

Some charts such as C<Scatter> and C<Stock> have two value axes.

Date Axes are a special type of category axis which are explained below.

=head1 Date Category Axes

Date Category Axes are category axes that display time or date information. In Excel::Writer::XLSX Date Category Axes are set using the C<date_axis> option:

    $chart->set_x_axis( date_axis => 1 );

In general you should also specify a number format for a date axis although Excel will usually default to the same format as the data being plotted:

    $chart->set_x_axis(
        date_axis         => 1,
        num_format        => 'dd/mm/yyyy',
    );

Excel doesn't normally allow minimum and maximum values to be set for category axes. However, date axes are an exception. The C<min> and C<max> values should be set as Excel times or dates:

    $chart->set_x_axis(
        date_axis         => 1,
        min               => $worksheet->convert_date_time('2013-01-02T'),
        max               => $worksheet->convert_date_time('2013-01-09T'),
        num_format        => 'dd/mm/yyyy',
    );

For date axes it is also possible to set the type of the major and minor units:

    $chart->set_x_axis(
        date_axis         => 1,
        minor_unit        => 4,
        minor_unit_type   => 'months',
        major_unit        => 1,
        major_unit_type   => 'years',
        num_format        => 'dd/mm/yyyy',
    );


=head1 Secondary Axes

It is possible to add a secondary axis of the same type to a chart by setting the C<y2_axis> or C<x2_axis> property of the series:

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart_secondary_axis.xlsx' );
    my $worksheet = $workbook->add_worksheet();

    # Add the worksheet data that the charts will refer to.
    my $data = [
        [ 2,  3,  4,  5,  6,  7 ],
        [ 10, 40, 50, 20, 10, 50 ],

    ];

    $worksheet->write( 'A1', $data );

    # Create a new chart object. In this case an embedded chart.
    my $chart = $workbook->add_chart( type => 'line', embedded => 1 );

    # Configure a series with a secondary axis
    $chart->add_series(
        values  => '=Sheet1!$A$1:$A$6',
        y2_axis => 1,
    );

    $chart->add_series(
        values => '=Sheet1!$B$1:$B$6',
    );


    # Insert the chart into the worksheet.
    $worksheet->insert_chart( 'D2', $chart );

    __END__

It is also possible to have a secondary, combined, chart either with a shared or secondary axis, see below.

=head1 Combined Charts

It is also possible to combine two different chart types, for example a column and line chart to create a Pareto chart using the Chart C<combine()> method:


=begin html

<p><center><img src="https://raw.githubusercontent.com/jmcnamara/XlsxWriter/master/dev/docs/source/_images/chart_pareto.png" alt="Chart image." /></center></p>

=end html


Here is a simpler example:

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart_combined.xlsx' );
    my $worksheet = $workbook->add_worksheet();
    my $bold      = $workbook->add_format( bold => 1 );

    # Add the worksheet data that the charts will refer to.
    my $headings = [ 'Number', 'Batch 1', 'Batch 2' ];
    my $data = [
        [ 2,  3,  4,  5,  6,  7 ],
        [ 10, 40, 50, 20, 10, 50 ],
        [ 30, 60, 70, 50, 40, 30 ],

    ];

    $worksheet->write( 'A1', $headings, $bold );
    $worksheet->write( 'A2', $data );

    #
    # In the first example we will create a combined column and line chart.
    # They will share the same X and Y axes.
    #

    # Create a new column chart. This will use this as the primary chart.
    my $column_chart = $workbook->add_chart( type => 'column', embedded => 1 );

    # Configure the data series for the primary chart.
    $column_chart->add_series(
        name       => '=Sheet1!$B$1',
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$B$2:$B$7',
    );

    # Create a new column chart. This will use this as the secondary chart.
    my $line_chart = $workbook->add_chart( type => 'line', embedded => 1 );

    # Configure the data series for the secondary chart.
    $line_chart->add_series(
        name       => '=Sheet1!$C$1',
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$C$2:$C$7',
    );

    # Combine the charts.
    $column_chart->combine( $line_chart );

    # Add a chart title and some axis labels. Note, this is done via the
    # primary chart.
    $column_chart->set_title( name => 'Combined chart - same Y axis' );
    $column_chart->set_x_axis( name => 'Test number' );
    $column_chart->set_y_axis( name => 'Sample length (mm)' );


    # Insert the chart into the worksheet
    $worksheet->insert_chart( 'E2', $column_chart );

=begin html

<p><center><img src="https://raw.githubusercontent.com/jmcnamara/XlsxWriter/master/dev/docs/source/_images/chart_combined1.png" alt="Chart image." /></center></p>

=end html



The secondary chart can also be placed on a secondary axis using the methods shown in the previous section.

In this case it is just necessary to add a C<y2_axis> parameter to the series and, if required, add a title using C<set_y2_axis()> B<of the secondary chart>. The following are the additions to the previous example to place the secondary chart on the secondary axis:

    ...

    $line_chart->add_series(
        name       => '=Sheet1!$C$1',
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$C$2:$C$7',
        y2_axis    => 1,
    );

    ...

    # Note: the y2 properites are on the secondary chart.
    $line_chart2->set_y2_axis( name => 'Target length (mm)' );


=begin html

<p><center><img src="https://raw.githubusercontent.com/jmcnamara/XlsxWriter/master/dev/docs/source/_images/chart_combined2.png" alt="Chart image." /></center></p>

=end html


The examples above use the concept of a I<primary> and I<secondary> chart. The primary chart is the chart that defines the primary X and Y axis. It is also used for setting all chart properties apart from the secondary data series. For example the chart title and axes properties should be set via the primary chart (except for the the secondary C<y2> axis properties which should be applied to the secondary chart).

See also C<chart_combined.pl> and C<chart_pareto.pl> examples in the distro for more detailed
examples.

There are some limitations on combined charts:

=over

=item * Pie charts cannot currently be combined.

=item * Scatter charts cannot currently be used as a primary chart but they can be used as a secondary chart.

=item * Bar charts can only combined secondary charts on a secondary axis. This is an Excel limitation.

=back



=head1 TODO

Chart features that are on the TODO list and will hopefully be added are:

=over

=item * Add more chart sub-types.

=item * Additional formatting options.

=item * More axis controls.

=item * 3D charts.

=item * Additional chart types.

=back

If you are interested in sponsoring a feature to have it implemented or expedited let me know.


=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

Copyright MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.
