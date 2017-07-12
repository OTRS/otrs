package Excel::Writer::XLSX::Package::Styles;

###############################################################################
#
# Styles - A class for writing the Excel XLSX styles file.
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

    $self->{_xf_formats}       = undef;
    $self->{_palette}          = [];
    $self->{_font_count}       = 0;
    $self->{_num_format_count} = 0;
    $self->{_border_count}     = 0;
    $self->{_fill_count}       = 0;
    $self->{_custom_colors}    = [];
    $self->{_dxf_formats}      = [];

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

    # Add the style sheet.
    $self->_write_style_sheet();

    # Write the number formats.
    $self->_write_num_fmts();

    # Write the fonts.
    $self->_write_fonts();

    # Write the fills.
    $self->_write_fills();

    # Write the borders element.
    $self->_write_borders();

    # Write the cellStyleXfs element.
    $self->_write_cell_style_xfs();

    # Write the cellXfs element.
    $self->_write_cell_xfs();

    # Write the cellStyles element.
    $self->_write_cell_styles();

    # Write the dxfs element.
    $self->_write_dxfs();

    # Write the tableStyles element.
    $self->_write_table_styles();

    # Write the colors element.
    $self->_write_colors();

    # Close the style sheet tag.
    $self->xml_end_tag( 'styleSheet' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# _set_style_properties()
#
# Pass in the Format objects and other properties used to set the styles.
#
sub _set_style_properties {

    my $self = shift;

    $self->{_xf_formats}       = shift;
    $self->{_palette}          = shift;
    $self->{_font_count}       = shift;
    $self->{_num_format_count} = shift;
    $self->{_border_count}     = shift;
    $self->{_fill_count}       = shift;
    $self->{_custom_colors}    = shift;
    $self->{_dxf_formats}      = shift;
}


###############################################################################
#
# Internal methods.
#
###############################################################################


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
# XML writing methods.
#
###############################################################################


##############################################################################
#
# _write_style_sheet()
#
# Write the <styleSheet> element.
#
sub _write_style_sheet {

    my $self  = shift;
    my $xmlns = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';

    my @attributes = ( 'xmlns' => $xmlns );

    $self->xml_start_tag( 'styleSheet', @attributes );
}


##############################################################################
#
# _write_num_fmts()
#
# Write the <numFmts> element.
#
sub _write_num_fmts {

    my $self  = shift;
    my $count = $self->{_num_format_count};

    return unless $count;

    my @attributes = ( 'count' => $count );

    $self->xml_start_tag( 'numFmts', @attributes );

    # Write the numFmts elements.
    for my $format ( @{ $self->{_xf_formats} } ) {

        # Ignore built-in number formats, i.e., < 164.
        next unless $format->{_num_format_index} >= 164;
        $self->_write_num_fmt( $format->{_num_format_index},
            $format->{_num_format} );
    }

    $self->xml_end_tag( 'numFmts' );
}


##############################################################################
#
# _write_num_fmt()
#
# Write the <numFmt> element.
#
sub _write_num_fmt {

    my $self        = shift;
    my $num_fmt_id  = shift;
    my $format_code = shift;

    my %format_codes = (
        0  => 'General',
        1  => '0',
        2  => '0.00',
        3  => '#,##0',
        4  => '#,##0.00',
        5  => '($#,##0_);($#,##0)',
        6  => '($#,##0_);[Red]($#,##0)',
        7  => '($#,##0.00_);($#,##0.00)',
        8  => '($#,##0.00_);[Red]($#,##0.00)',
        9  => '0%',
        10 => '0.00%',
        11 => '0.00E+00',
        12 => '# ?/?',
        13 => '# ??/??',
        14 => 'm/d/yy',
        15 => 'd-mmm-yy',
        16 => 'd-mmm',
        17 => 'mmm-yy',
        18 => 'h:mm AM/PM',
        19 => 'h:mm:ss AM/PM',
        20 => 'h:mm',
        21 => 'h:mm:ss',
        22 => 'm/d/yy h:mm',
        37 => '(#,##0_);(#,##0)',
        38 => '(#,##0_);[Red](#,##0)',
        39 => '(#,##0.00_);(#,##0.00)',
        40 => '(#,##0.00_);[Red](#,##0.00)',
        41 => '_(* #,##0_);_(* (#,##0);_(* "-"_);_(@_)',
        42 => '_($* #,##0_);_($* (#,##0);_($* "-"_);_(@_)',
        43 => '_(* #,##0.00_);_(* (#,##0.00);_(* "-"??_);_(@_)',
        44 => '_($* #,##0.00_);_($* (#,##0.00);_($* "-"??_);_(@_)',
        45 => 'mm:ss',
        46 => '[h]:mm:ss',
        47 => 'mm:ss.0',
        48 => '##0.0E+0',
        49 => '@',
    );

    # Set the format code for built-in number formats.
    if ( $num_fmt_id < 164 ) {
        if ( exists $format_codes{$num_fmt_id} ) {
            $format_code = $format_codes{$num_fmt_id};
        }
        else {
            $format_code = 'General';
        }
    }

    my @attributes = (
        'numFmtId'   => $num_fmt_id,
        'formatCode' => $format_code,
    );

    $self->xml_empty_tag( 'numFmt', @attributes );
}


##############################################################################
#
# _write_fonts()
#
# Write the <fonts> element.
#
sub _write_fonts {

    my $self  = shift;
    my $count = $self->{_font_count};

    my @attributes = ( 'count' => $count );

    $self->xml_start_tag( 'fonts', @attributes );

    # Write the font elements for format objects that have them.
    for my $format ( @{ $self->{_xf_formats} } ) {
        $self->_write_font( $format ) if $format->{_has_font};
    }

    $self->xml_end_tag( 'fonts' );
}


##############################################################################
#
# _write_font()
#
# Write the <font> element.
#
sub _write_font {

    my $self       = shift;
    my $format     = shift;
    my $dxf_format = shift;

    $self->xml_start_tag( 'font' );

    # The condense and extend elements are mainly used in dxf formats.
    $self->_write_condense() if $format->{_font_condense};
    $self->_write_extend()   if $format->{_font_extend};

    $self->xml_empty_tag( 'b' )       if $format->{_bold};
    $self->xml_empty_tag( 'i' )       if $format->{_italic};
    $self->xml_empty_tag( 'strike' )  if $format->{_font_strikeout};
    $self->xml_empty_tag( 'outline' ) if $format->{_font_outline};
    $self->xml_empty_tag( 'shadow' )  if $format->{_font_shadow};

    # Handle the underline variants.
    $self->_write_underline( $format->{_underline} ) if $format->{_underline};

    $self->_write_vert_align( 'superscript' ) if $format->{_font_script} == 1;
    $self->_write_vert_align( 'subscript' )   if $format->{_font_script} == 2;

    if ( !$dxf_format ) {
        $self->xml_empty_tag( 'sz', 'val', $format->{_size} );
    }

    my $theme = $format->{_theme};


    if ( $theme == -1 ) {
        # Ignore for excel2003_style.
    }
    elsif ( $theme ) {
        $self->_write_color( 'theme' => $theme );
    }
    elsif ( my $index = $format->{_color_indexed} ) {
        $self->_write_color( 'indexed' => $index );
    }
    elsif ( my $color = $format->{_color} ) {
        $color = $self->_get_palette_color( $color );

        $self->_write_color( 'rgb' => $color );
    }
    elsif ( !$dxf_format ) {
        $self->_write_color( 'theme' => 1 );
    }

    if ( !$dxf_format ) {
        $self->xml_empty_tag( 'name',   'val', $format->{_font} );

        if ($format->{_font_family}) {
            $self->xml_empty_tag( 'family', 'val', $format->{_font_family} );
        }

        if ($format->{_font_charset}) {
            $self->xml_empty_tag( 'charset', 'val', $format->{_font_charset} );
        }

        if ( $format->{_font} eq 'Calibri' && !$format->{_hyperlink} ) {
            $self->xml_empty_tag(

                'scheme',
                'val' => $format->{_font_scheme}
            );
        }
    }

    $self->xml_end_tag( 'font' );
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

    $self->xml_empty_tag( 'u', @attributes );

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

    $self->xml_empty_tag( 'vertAlign', @attributes );
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
# _write_fills()
#
# Write the <fills> element.
#
sub _write_fills {

    my $self  = shift;
    my $count = $self->{_fill_count};

    my @attributes = ( 'count' => $count );

    $self->xml_start_tag( 'fills', @attributes );

    # Write the default fill element.
    $self->_write_default_fill( 'none' );
    $self->_write_default_fill( 'gray125' );

    # Write the fill elements for format objects that have them.
    for my $format ( @{ $self->{_xf_formats} } ) {
        $self->_write_fill( $format ) if $format->{_has_fill};
    }

    $self->xml_end_tag( 'fills' );
}


##############################################################################
#
# _write_default_fill()
#
# Write the <fill> element for the default fills.
#
sub _write_default_fill {

    my $self         = shift;
    my $pattern_type = shift;

    $self->xml_start_tag( 'fill' );

    $self->xml_empty_tag( 'patternFill', 'patternType', $pattern_type );

    $self->xml_end_tag( 'fill' );
}


##############################################################################
#
# _write_fill()
#
# Write the <fill> element.
#
sub _write_fill {

    my $self       = shift;
    my $format     = shift;
    my $dxf_format = shift;
    my $pattern    = $format->{_pattern};
    my $bg_color   = $format->{_bg_color};
    my $fg_color   = $format->{_fg_color};

    # Colors for dxf formats are handled differently from normal formats since
    # the normal format reverses the meaning of BG and FG for solid fills.
    if ( $dxf_format ) {
        $bg_color = $format->{_dxf_bg_color};
        $fg_color = $format->{_dxf_fg_color};
    }


    my @patterns = qw(
      none
      solid
      mediumGray
      darkGray
      lightGray
      darkHorizontal
      darkVertical
      darkDown
      darkUp
      darkGrid
      darkTrellis
      lightHorizontal
      lightVertical
      lightDown
      lightUp
      lightGrid
      lightTrellis
      gray125
      gray0625

    );


    $self->xml_start_tag( 'fill' );

    # The "none" pattern is handled differently for dxf formats.
    if ( $dxf_format && $format->{_pattern} <= 1 ) {
        $self->xml_start_tag( 'patternFill' );
    }
    else {
        $self->xml_start_tag(
            'patternFill',
            'patternType',
            $patterns[ $format->{_pattern} ]

        );
    }

    if ( $fg_color ) {
        $fg_color = $self->_get_palette_color( $fg_color );
        $self->xml_empty_tag( 'fgColor', 'rgb' => $fg_color );
    }

    if ( $bg_color ) {
        $bg_color = $self->_get_palette_color( $bg_color );
        $self->xml_empty_tag( 'bgColor', 'rgb' => $bg_color );
    }
    else {
        if ( !$dxf_format ) {
            $self->xml_empty_tag( 'bgColor', 'indexed' => 64 );
        }
    }

    $self->xml_end_tag( 'patternFill' );
    $self->xml_end_tag( 'fill' );
}


##############################################################################
#
# _write_borders()
#
# Write the <borders> element.
#
sub _write_borders {

    my $self  = shift;
    my $count = $self->{_border_count};

    my @attributes = ( 'count' => $count );

    $self->xml_start_tag( 'borders', @attributes );

    # Write the border elements for format objects that have them.
    for my $format ( @{ $self->{_xf_formats} } ) {
        $self->_write_border( $format ) if $format->{_has_border};
    }

    $self->xml_end_tag( 'borders' );
}


##############################################################################
#
# _write_border()
#
# Write the <border> element.
#
sub _write_border {

    my $self       = shift;
    my $format     = shift;
    my $dxf_format = shift;
    my @attributes = ();


    # Diagonal borders add attributes to the <border> element.
    if ( $format->{_diag_type} == 1 ) {
        push @attributes, ( diagonalUp => 1 );
    }
    elsif ( $format->{_diag_type} == 2 ) {
        push @attributes, ( diagonalDown => 1 );
    }
    elsif ( $format->{_diag_type} == 3 ) {
        push @attributes, ( diagonalUp   => 1 );
        push @attributes, ( diagonalDown => 1 );
    }

    # Ensure that a default diag border is set if the diag type is set.
    if ( $format->{_diag_type} && !$format->{_diag_border} ) {
        $format->{_diag_border} = 1;
    }

    # Write the start border tag.
    $self->xml_start_tag( 'border', @attributes );

    # Write the <border> sub elements.
    $self->_write_sub_border(
        'left',
        $format->{_left},
        $format->{_left_color}

    );

    $self->_write_sub_border(
        'right',
        $format->{_right},
        $format->{_right_color}

    );

    $self->_write_sub_border(
        'top',
        $format->{_top},
        $format->{_top_color}

    );

    $self->_write_sub_border(
        'bottom',
        $format->{_bottom},
        $format->{_bottom_color}

    );

    # Condition DXF formats don't allow diagonal borders
    if ( !$dxf_format ) {
        $self->_write_sub_border(
            'diagonal',
            $format->{_diag_border},
            $format->{_diag_color}

        );
    }

    if ( $dxf_format ) {
        $self->_write_sub_border( 'vertical' );
        $self->_write_sub_border( 'horizontal' );
    }

    $self->xml_end_tag( 'border' );
}


##############################################################################
#
# _write_sub_border()
#
# Write the <border> sub elements such as <right>, <top>, etc.
#
sub _write_sub_border {

    my $self  = shift;
    my $type  = shift;
    my $style = shift;
    my $color = shift;
    my @attributes;

    if ( !$style ) {
        $self->xml_empty_tag( $type );
        return;
    }

    my @border_styles = qw(
      none
      thin
      medium
      dashed
      dotted
      thick
      double
      hair
      mediumDashed
      dashDot
      mediumDashDot
      dashDotDot
      mediumDashDotDot
      slantDashDot

    );


    push @attributes, ( style => $border_styles[$style] );

    $self->xml_start_tag( $type, @attributes );

    if ( $color ) {
        $color = $self->_get_palette_color( $color );
        $self->xml_empty_tag( 'color', 'rgb' => $color );
    }
    else {
        $self->xml_empty_tag( 'color', 'auto' => 1 );
    }

    $self->xml_end_tag( $type );
}


##############################################################################
#
# _write_cell_style_xfs()
#
# Write the <cellStyleXfs> element.
#
sub _write_cell_style_xfs {

    my $self  = shift;
    my $count = 1;

    my @attributes = ( 'count' => $count );

    $self->xml_start_tag( 'cellStyleXfs', @attributes );

    # Write the style_xf element.
    $self->_write_style_xf();

    $self->xml_end_tag( 'cellStyleXfs' );
}


##############################################################################
#
# _write_cell_xfs()
#
# Write the <cellXfs> element.
#
sub _write_cell_xfs {

    my $self    = shift;
    my @formats = @{ $self->{_xf_formats} };

    # Workaround for when the last format is used for the comment font
    # and shouldn't be used for cellXfs.
    my $last_format = $formats[-1];

    if ( $last_format->{_font_only} ) {
        pop @formats;
    }

    my $count = scalar @formats;
    my @attributes = ( 'count' => $count );

    $self->xml_start_tag( 'cellXfs', @attributes );

    # Write the xf elements.
    for my $format ( @formats ) {
        $self->_write_xf( $format );
    }

    $self->xml_end_tag( 'cellXfs' );
}


##############################################################################
#
# _write_style_xf()
#
# Write the style <xf> element.
#
sub _write_style_xf {

    my $self       = shift;
    my $num_fmt_id = 0;
    my $font_id    = 0;
    my $fill_id    = 0;
    my $border_id  = 0;

    my @attributes = (
        'numFmtId' => $num_fmt_id,
        'fontId'   => $font_id,
        'fillId'   => $fill_id,
        'borderId' => $border_id,
    );

    $self->xml_empty_tag( 'xf', @attributes );
}


##############################################################################
#
# _write_xf()
#
# Write the <xf> element.
#
sub _write_xf {

    my $self        = shift;
    my $format      = shift;
    my $num_fmt_id  = $format->{_num_format_index};
    my $font_id     = $format->{_font_index};
    my $fill_id     = $format->{_fill_index};
    my $border_id   = $format->{_border_index};
    my $xf_id       = 0;
    my $has_align   = 0;
    my $has_protect = 0;

    my @attributes = (
        'numFmtId' => $num_fmt_id,
        'fontId'   => $font_id,
        'fillId'   => $fill_id,
        'borderId' => $border_id,
        'xfId'     => $xf_id,
    );


    if ( $format->{_num_format_index} > 0 ) {
        push @attributes, ( 'applyNumberFormat' => 1 );
    }

    # Add applyFont attribute if XF format uses a font element.
    if ( $format->{_font_index} > 0 ) {
        push @attributes, ( 'applyFont' => 1 );
    }

    # Add applyFill attribute if XF format uses a fill element.
    if ( $format->{_fill_index} > 0 ) {
        push @attributes, ( 'applyFill' => 1 );
    }

    # Add applyBorder attribute if XF format uses a border element.
    if ( $format->{_border_index} > 0 ) {
        push @attributes, ( 'applyBorder' => 1 );
    }

    # Check if XF format has alignment properties set.
    my ( $apply_align, @align ) = $format->get_align_properties();

    # Check if an alignment sub-element should be written.
    $has_align = 1 if $apply_align && @align;

    # We can also have applyAlignment without a sub-element.
    if ( $apply_align ) {
        push @attributes, ( 'applyAlignment' => 1 );
    }

    # Check for cell protection properties.
    my @protection = $format->get_protection_properties();

    if ( @protection ) {
        push @attributes, ( 'applyProtection' => 1 );
        $has_protect = 1;
    }

    # Write XF with sub-elements if required.
    if ( $has_align || $has_protect ) {
        $self->xml_start_tag( 'xf', @attributes );
        $self->xml_empty_tag( 'alignment',  @align )      if $has_align;
        $self->xml_empty_tag( 'protection', @protection ) if $has_protect;
        $self->xml_end_tag( 'xf' );
    }
    else {
        $self->xml_empty_tag( 'xf', @attributes );
    }
}


##############################################################################
#
# _write_cell_styles()
#
# Write the <cellStyles> element.
#
sub _write_cell_styles {

    my $self  = shift;
    my $count = 1;

    my @attributes = ( 'count' => $count );

    $self->xml_start_tag( 'cellStyles', @attributes );

    # Write the cellStyle element.
    $self->_write_cell_style();

    $self->xml_end_tag( 'cellStyles' );
}


##############################################################################
#
# _write_cell_style()
#
# Write the <cellStyle> element.
#
sub _write_cell_style {

    my $self       = shift;
    my $name       = 'Normal';
    my $xf_id      = 0;
    my $builtin_id = 0;

    my @attributes = (
        'name'      => $name,
        'xfId'      => $xf_id,
        'builtinId' => $builtin_id,
    );

    $self->xml_empty_tag( 'cellStyle', @attributes );
}


##############################################################################
#
# _write_dxfs()
#
# Write the <dxfs> element.
#
sub _write_dxfs {

    my $self    = shift;
    my $formats = $self->{_dxf_formats};

    my $count = scalar @{$formats};

    my @attributes = ( 'count' => $count );

    if ( $count ) {
        $self->xml_start_tag( 'dxfs', @attributes );

        # Write the font elements for format objects that have them.
        for my $format ( @{ $self->{_dxf_formats} } ) {
            $self->xml_start_tag( 'dxf' );
            $self->_write_font( $format, 1 ) if $format->{_has_dxf_font};

            if ( $format->{_num_format_index} ) {
                $self->_write_num_fmt( $format->{_num_format_index},
                    $format->{_num_format} );
            }

            $self->_write_fill( $format, 1 ) if $format->{_has_dxf_fill};
            $self->_write_border( $format, 1 ) if $format->{_has_dxf_border};
            $self->xml_end_tag( 'dxf' );
        }

        $self->xml_end_tag( 'dxfs' );
    }
    else {
        $self->xml_empty_tag( 'dxfs', @attributes );
    }

}


##############################################################################
#
# _write_table_styles()
#
# Write the <tableStyles> element.
#
sub _write_table_styles {

    my $self                = shift;
    my $count               = 0;
    my $default_table_style = 'TableStyleMedium9';
    my $default_pivot_style = 'PivotStyleLight16';

    my @attributes = (
        'count'             => $count,
        'defaultTableStyle' => $default_table_style,
        'defaultPivotStyle' => $default_pivot_style,
    );

    $self->xml_empty_tag( 'tableStyles', @attributes );
}


##############################################################################
#
# _write_colors()
#
# Write the <colors> element.
#
sub _write_colors {

    my $self          = shift;
    my @custom_colors = @{ $self->{_custom_colors} };

    return unless @custom_colors;

    $self->xml_start_tag( 'colors' );
    $self->_write_mru_colors( @custom_colors );
    $self->xml_end_tag( 'colors' );
}


##############################################################################
#
# _write_mru_colors()
#
# Write the <mruColors> element for the most recently used colours.
#
sub _write_mru_colors {

    my $self          = shift;
    my @custom_colors = @_;

    # Limit the mruColors to the last 10.
    my $count = @custom_colors;
    if ( $count > 10 ) {
        splice @custom_colors, 0, ( $count - 10 );
    }

    $self->xml_start_tag( 'mruColors' );

    # Write the custom colors in reverse order.
    for my $color ( reverse @custom_colors ) {
        $self->_write_color( 'rgb' => $color );
    }

    $self->xml_end_tag( 'mruColors' );
}


##############################################################################
#
# _write_condense()
#
# Write the <condense> element.
#
sub _write_condense {

    my $self = shift;
    my $val  = 0;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'condense', @attributes );
}


##############################################################################
#
# _write_extend()
#
# Write the <extend> element.
#
sub _write_extend {

    my $self = shift;
    my $val  = 0;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'extend', @attributes );
}


1;


__END__

=pod

=head1 NAME

Styles - A class for writing the Excel XLSX styles file.

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
