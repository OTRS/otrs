package Excel::Writer::XLSX::Package::VML;

###############################################################################
#
# VML - A class for writing the Excel XLSX VML files.
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

    my $self               = shift;
    my $data_id            = shift;
    my $vml_shape_id       = shift;
    my $comments_data      = shift;
    my $buttons_data       = shift;
    my $header_images_data = shift;
    my $z_index            = 1;


    $self->_write_xml_namespace;

    # Write the o:shapelayout element.
    $self->_write_shapelayout( $data_id );

    if ( defined $buttons_data && @$buttons_data ) {

        # Write the v:shapetype element.
        $self->_write_button_shapetype();

        for my $button ( @$buttons_data ) {

            # Write the v:shape element.
            $self->_write_button_shape( ++$vml_shape_id, $z_index++, $button );
        }
    }

    if ( defined $comments_data && @$comments_data ) {

        # Write the v:shapetype element.
        $self->_write_comment_shapetype();

        for my $comment ( @$comments_data ) {

            # Write the v:shape element.
            $self->_write_comment_shape( ++$vml_shape_id, $z_index++,
                $comment );
        }
    }

    if ( defined $header_images_data && @$header_images_data ) {

        # Write the v:shapetype element.
        $self->_write_image_shapetype();

        my $index = 1;
        for my $image ( @$header_images_data ) {

            # Write the v:shape element.
            $self->_write_image_shape( ++$vml_shape_id, $index++, $image );
        }
    }


    $self->xml_end_tag( 'xml' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# _pixels_to_points()
#
# Convert comment vertices from pixels to points.
#
sub _pixels_to_points {

    my $self     = shift;
    my $vertices = shift;

    my (
        $col_start, $row_start, $x1,    $y1,
        $col_end,   $row_end,   $x2,    $y2,
        $left,      $top,       $width, $height
    ) = @$vertices;

    for my $pixels ( $left, $top, $width, $height ) {
        $pixels *= 0.75;
    }

    return ( $left, $top, $width, $height );
}


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_xml_namespace()
#
# Write the <xml> element. This is the root element of VML.
#
sub _write_xml_namespace {

    my $self    = shift;
    my $schema  = 'urn:schemas-microsoft-com:';
    my $xmlns   = $schema . 'vml';
    my $xmlns_o = $schema . 'office:office';
    my $xmlns_x = $schema . 'office:excel';

    my @attributes = (
        'xmlns:v' => $xmlns,
        'xmlns:o' => $xmlns_o,
        'xmlns:x' => $xmlns_x,
    );

    $self->xml_start_tag( 'xml', @attributes );
}


##############################################################################
#
# _write_shapelayout()
#
# Write the <o:shapelayout> element.
#
sub _write_shapelayout {

    my $self    = shift;
    my $data_id = shift;
    my $ext     = 'edit';

    my @attributes = ( 'v:ext' => $ext );

    $self->xml_start_tag( 'o:shapelayout', @attributes );

    # Write the o:idmap element.
    $self->_write_idmap( $data_id );

    $self->xml_end_tag( 'o:shapelayout' );
}


##############################################################################
#
# _write_idmap()
#
# Write the <o:idmap> element.
#
sub _write_idmap {

    my $self    = shift;
    my $ext     = 'edit';
    my $data_id = shift;

    my @attributes = (
        'v:ext' => $ext,
        'data'  => $data_id,
    );

    $self->xml_empty_tag( 'o:idmap', @attributes );
}


##############################################################################
#
# _write_comment_shapetype()
#
# Write the <v:shapetype> element.
#
sub _write_comment_shapetype {

    my $self      = shift;
    my $id        = '_x0000_t202';
    my $coordsize = '21600,21600';
    my $spt       = 202;
    my $path      = 'm,l,21600r21600,l21600,xe';

    my @attributes = (
        'id'        => $id,
        'coordsize' => $coordsize,
        'o:spt'     => $spt,
        'path'      => $path,
    );

    $self->xml_start_tag( 'v:shapetype', @attributes );

    # Write the v:stroke element.
    $self->_write_stroke();

    # Write the v:path element.
    $self->_write_comment_path( 't', 'rect' );

    $self->xml_end_tag( 'v:shapetype' );
}


##############################################################################
#
# _write_button_shapetype()
#
# Write the <v:shapetype> element.
#
sub _write_button_shapetype {

    my $self      = shift;
    my $id        = '_x0000_t201';
    my $coordsize = '21600,21600';
    my $spt       = 201;
    my $path      = 'm,l,21600r21600,l21600,xe';

    my @attributes = (
        'id'        => $id,
        'coordsize' => $coordsize,
        'o:spt'     => $spt,
        'path'      => $path,
    );

    $self->xml_start_tag( 'v:shapetype', @attributes );

    # Write the v:stroke element.
    $self->_write_stroke();

    # Write the v:path element.
    $self->_write_button_path( 't', 'rect' );

    # Write the o:lock element.
    $self->_write_shapetype_lock();

    $self->xml_end_tag( 'v:shapetype' );
}


##############################################################################
#
# _write_image_shapetype()
#
# Write the <v:shapetype> element.
#
sub _write_image_shapetype {

    my $self             = shift;
    my $id               = '_x0000_t75';
    my $coordsize        = '21600,21600';
    my $spt              = 75;
    my $o_preferrelative = 't';
    my $path             = 'm@4@5l@4@11@9@11@9@5xe';
    my $filled           = 'f';
    my $stroked          = 'f';

    my @attributes = (
        'id'               => $id,
        'coordsize'        => $coordsize,
        'o:spt'            => $spt,
        'o:preferrelative' => $o_preferrelative,
        'path'             => $path,
        'filled'           => $filled,
        'stroked'          => $stroked,
    );

    $self->xml_start_tag( 'v:shapetype', @attributes );

    # Write the v:stroke element.
    $self->_write_stroke();

    # Write the v:formulas element.
    $self->_write_formulas();

    # Write the v:path element.
    $self->_write_image_path();

    # Write the o:lock element.
    $self->_write_aspect_ratio_lock();

    $self->xml_end_tag( 'v:shapetype' );
}


##############################################################################
#
# _write_stroke()
#
# Write the <v:stroke> element.
#
sub _write_stroke {

    my $self      = shift;
    my $joinstyle = 'miter';

    my @attributes = ( 'joinstyle' => $joinstyle );

    $self->xml_empty_tag( 'v:stroke', @attributes );
}


##############################################################################
#
# _write_comment_path()
#
# Write the <v:path> element.
#
sub _write_comment_path {

    my $self            = shift;
    my $gradientshapeok = shift;
    my $connecttype     = shift;
    my @attributes      = ();

    push @attributes, ( 'gradientshapeok' => 't' ) if $gradientshapeok;
    push @attributes, ( 'o:connecttype' => $connecttype );

    $self->xml_empty_tag( 'v:path', @attributes );
}


##############################################################################
#
# _write_button_path()
#
# Write the <v:path> element.
#
sub _write_button_path {

    my $self        = shift;
    my $shadowok    = 'f';
    my $extrusionok = 'f';
    my $strokeok    = 'f';
    my $fillok      = 'f';
    my $connecttype = 'rect';

    my @attributes = (
        'shadowok'      => $shadowok,
        'o:extrusionok' => $extrusionok,
        'strokeok'      => $strokeok,
        'fillok'        => $fillok,
        'o:connecttype' => $connecttype,
    );

    $self->xml_empty_tag( 'v:path', @attributes );
}


##############################################################################
#
# _write_image_path()
#
# Write the <v:path> element.
#
sub _write_image_path {

    my $self            = shift;
    my $extrusionok     = 'f';
    my $gradientshapeok = 't';
    my $connecttype     = 'rect';

    my @attributes = (
        'o:extrusionok'   => $extrusionok,
        'gradientshapeok' => $gradientshapeok,
        'o:connecttype'   => $connecttype,
    );

    $self->xml_empty_tag( 'v:path', @attributes );
}


##############################################################################
#
# _write_shapetype_lock()
#
# Write the <o:lock> element.
#
sub _write_shapetype_lock {

    my $self      = shift;
    my $ext       = 'edit';
    my $shapetype = 't';

    my @attributes = (
        'v:ext'     => $ext,
        'shapetype' => $shapetype,
    );

    $self->xml_empty_tag( 'o:lock', @attributes );
}


##############################################################################
#
# _write_rotation_lock()
#
# Write the <o:lock> element.
#
sub _write_rotation_lock {

    my $self     = shift;
    my $ext      = 'edit';
    my $rotation = 't';

    my @attributes = (
        'v:ext'    => $ext,
        'rotation' => $rotation,
    );

    $self->xml_empty_tag( 'o:lock', @attributes );
}


##############################################################################
#
# _write_aspect_ratio_lock()
#
# Write the <o:lock> element.
#
sub _write_aspect_ratio_lock {

    my $self        = shift;
    my $ext         = 'edit';
    my $aspectratio = 't';

    my @attributes = (
        'v:ext'       => $ext,
        'aspectratio' => $aspectratio,
    );

    $self->xml_empty_tag( 'o:lock', @attributes );
}

##############################################################################
#
# _write_comment_shape()
#
# Write the <v:shape> element.
#
sub _write_comment_shape {

    my $self       = shift;
    my $id         = shift;
    my $z_index    = shift;
    my $comment    = shift;
    my $type       = '#_x0000_t202';
    my $insetmode  = 'auto';
    my $visibility = 'hidden';

    # Set the shape index.
    $id = '_x0000_s' . $id;

    # Get the comment parameters
    my $row       = $comment->[0];
    my $col       = $comment->[1];
    my $string    = $comment->[2];
    my $author    = $comment->[3];
    my $visible   = $comment->[4];
    my $fillcolor = $comment->[5];
    my $vertices  = $comment->[6];

    my ( $left, $top, $width, $height ) = $self->_pixels_to_points( $vertices );

    # Set the visibility.
    $visibility = 'visible' if $visible;

    my $style =
        'position:absolute;'
      . 'margin-left:'
      . $left . 'pt;'
      . 'margin-top:'
      . $top . 'pt;'
      . 'width:'
      . $width . 'pt;'
      . 'height:'
      . $height . 'pt;'
      . 'z-index:'
      . $z_index . ';'
      . 'visibility:'
      . $visibility;


    my @attributes = (
        'id'          => $id,
        'type'        => $type,
        'style'       => $style,
        'fillcolor'   => $fillcolor,
        'o:insetmode' => $insetmode,
    );

    $self->xml_start_tag( 'v:shape', @attributes );

    # Write the v:fill element.
    $self->_write_comment_fill();

    # Write the v:shadow element.
    $self->_write_shadow();

    # Write the v:path element.
    $self->_write_comment_path( undef, 'none' );

    # Write the v:textbox element.
    $self->_write_comment_textbox();

    # Write the x:ClientData element.
    $self->_write_comment_client_data( $row, $col, $visible, $vertices );

    $self->xml_end_tag( 'v:shape' );
}


##############################################################################
#
# _write_button_shape()
#
# Write the <v:shape> element.
#
sub _write_button_shape {

    my $self       = shift;
    my $id         = shift;
    my $z_index    = shift;
    my $button     = shift;
    my $type       = '#_x0000_t201';

    # Set the shape index.
    $id = '_x0000_s' . $id;

    # Get the button parameters
    my $row       = $button->{_row};
    my $col       = $button->{_col};
    my $vertices  = $button->{_vertices};

    my ( $left, $top, $width, $height ) = $self->_pixels_to_points( $vertices );

    my $style =
        'position:absolute;'
      . 'margin-left:'
      . $left . 'pt;'
      . 'margin-top:'
      . $top . 'pt;'
      . 'width:'
      . $width . 'pt;'
      . 'height:'
      . $height . 'pt;'
      . 'z-index:'
      . $z_index . ';'
      . 'mso-wrap-style:tight';


    my @attributes = (
        'id'          => $id,
        'type'        => $type,
        'style'       => $style,
        'o:button'    => 't',
        'fillcolor'   => 'buttonFace [67]',
        'strokecolor' => 'windowText [64]',
        'o:insetmode' => 'auto',
    );

    $self->xml_start_tag( 'v:shape', @attributes );

    # Write the v:fill element.
    $self->_write_button_fill();

    # Write the o:lock element.
    $self->_write_rotation_lock();

    # Write the v:textbox element.
    $self->_write_button_textbox( $button->{_font} );

    # Write the x:ClientData element.
    $self->_write_button_client_data( $button );

    $self->xml_end_tag( 'v:shape' );
}


##############################################################################
#
# _write_image_shape()
#
# Write the <v:shape> element.
#
sub _write_image_shape {

    my $self       = shift;
    my $id         = shift;
    my $index      = shift;
    my $image_data = shift;
    my $type       = '#_x0000_t75';

    # Set the shape index.
    $id = '_x0000_s' . $id;

    # Get the image parameters
    my $width    = $image_data->[0];
    my $height   = $image_data->[1];
    my $name     = $image_data->[2];
    my $position = $image_data->[3];
    my $x_dpi    = $image_data->[4];
    my $y_dpi    = $image_data->[5];

    # Scale the height/width by the resolution, relative to 72dpi.
    $width  = $width  * 72 / $x_dpi;
    $height = $height * 72 / $y_dpi;

    # Excel uses a rounding based around 72 and 96 dpi.
    $width  = 72/96 * int($width  * 96/72 + 0.25);
    $height = 72/96 * int($height * 96/72 + 0.25);

    my $style =
        'position:absolute;'
      . 'margin-left:0;'
      . 'margin-top:0;'
      . 'width:'
      . $width . 'pt;'
      . 'height:'
      . $height . 'pt;'
      . 'z-index:'
      . $index;

    my @attributes = (
        'id'     => $position,
        'o:spid' => $id,
        'type'   => $type,
        'style'  => $style,
    );

    $self->xml_start_tag( 'v:shape', @attributes );

    # Write the v:imagedata element.
    $self->_write_imagedata( $index, $name );

    # Write the o:lock element.
    $self->_write_rotation_lock();

    $self->xml_end_tag( 'v:shape' );
}

##############################################################################
#
# _write_comment_fill()
#
# Write the <v:fill> element.
#
sub _write_comment_fill {

    my $self    = shift;
    my $color_2 = '#ffffe1';

    my @attributes = ( 'color2' => $color_2 );

    $self->xml_empty_tag( 'v:fill', @attributes );
}


##############################################################################
#
# _write_button_fill()
#
# Write the <v:fill> element.
#
sub _write_button_fill {

    my $self             = shift;
    my $color_2          = 'buttonFace [67]';
    my $detectmouseclick = 't';

    my @attributes = (
        'color2'             => $color_2,
        'o:detectmouseclick' => $detectmouseclick,
    );

    $self->xml_empty_tag( 'v:fill', @attributes );
}


##############################################################################
#
# _write_shadow()
#
# Write the <v:shadow> element.
#
sub _write_shadow {

    my $self     = shift;
    my $on       = 't';
    my $color    = 'black';
    my $obscured = 't';

    my @attributes = (
        'on'       => $on,
        'color'    => $color,
        'obscured' => $obscured,
    );

    $self->xml_empty_tag( 'v:shadow', @attributes );
}


##############################################################################
#
# _write_comment_textbox()
#
# Write the <v:textbox> element.
#
sub _write_comment_textbox {

    my $self  = shift;
    my $style = 'mso-direction-alt:auto';

    my @attributes = ( 'style' => $style );

    $self->xml_start_tag( 'v:textbox', @attributes );

    # Write the div element.
    $self->_write_div( 'left' );

    $self->xml_end_tag( 'v:textbox' );
}


##############################################################################
#
# _write_button_textbox()
#
# Write the <v:textbox> element.
#
sub _write_button_textbox {

    my $self  = shift;
    my $font  = shift;
    my $style = 'mso-direction-alt:auto';

    my @attributes = ( 'style' => $style, 'o:singleclick' => 'f' );

    $self->xml_start_tag( 'v:textbox', @attributes );

    # Write the div element.
    $self->_write_div( 'center', $font );

    $self->xml_end_tag( 'v:textbox' );
}


##############################################################################
#
# _write_div()
#
# Write the <div> element.
#
sub _write_div {

    my $self  = shift;
    my $align = shift;
    my $font  = shift;
    my $style = 'text-align:' . $align;

    my @attributes = ( 'style' => $style );

    $self->xml_start_tag( 'div', @attributes );


    if ( $font ) {

        # Write the font element.
        $self->_write_font( $font );
    }

    $self->xml_end_tag( 'div' );
}

##############################################################################
#
# _write_font()
#
# Write the <font> element.
#
sub _write_font {

    my $self    = shift;
    my $font    = shift;
    my $caption = $font->{_caption};
    my $face    = 'Calibri';
    my $size    = 220;
    my $color   = '#000000';

    my @attributes = (
        'face'  => $face,
        'size'  => $size,
        'color' => $color,
    );

    $self->xml_data_element( 'font', $caption, @attributes );
}


##############################################################################
#
# _write_comment_client_data()
#
# Write the <x:ClientData> element.
#
sub _write_comment_client_data {

    my $self        = shift;
    my $row         = shift;
    my $col         = shift;
    my $visible     = shift;
    my $vertices    = shift;
    my $object_type = 'Note';

    my @attributes = ( 'ObjectType' => $object_type );

    $self->xml_start_tag( 'x:ClientData', @attributes );

    # Write the x:MoveWithCells element.
    $self->_write_move_with_cells();

    # Write the x:SizeWithCells element.
    $self->_write_size_with_cells();

    # Write the x:Anchor element.
    $self->_write_anchor( $vertices );

    # Write the x:AutoFill element.
    $self->_write_auto_fill();

    # Write the x:Row element.
    $self->_write_row( $row );

    # Write the x:Column element.
    $self->_write_column( $col );

    # Write the x:Visible element.
    $self->_write_visible() if $visible;

    $self->xml_end_tag( 'x:ClientData' );
}


##############################################################################
#
# _write_button_client_data()
#
# Write the <x:ClientData> element.
#
sub _write_button_client_data {

    my $self      = shift;
    my $button    = shift;
    my $row       = $button->{_row};
    my $col       = $button->{_col};
    my $macro     = $button->{_macro};
    my $vertices  = $button->{_vertices};


    my $object_type = 'Button';

    my @attributes = ( 'ObjectType' => $object_type );

    $self->xml_start_tag( 'x:ClientData', @attributes );

    # Write the x:Anchor element.
    $self->_write_anchor( $vertices );

    # Write the x:PrintObject element.
    $self->_write_print_object();

    # Write the x:AutoFill element.
    $self->_write_auto_fill();

    # Write the x:FmlaMacro element.
    $self->_write_fmla_macro( $macro );

    # Write the x:TextHAlign element.
    $self->_write_text_halign();

    # Write the x:TextVAlign element.
    $self->_write_text_valign();

    $self->xml_end_tag( 'x:ClientData' );
}


##############################################################################
#
# _write_move_with_cells()
#
# Write the <x:MoveWithCells> element.
#
sub _write_move_with_cells {

    my $self = shift;

    $self->xml_empty_tag( 'x:MoveWithCells' );
}


##############################################################################
#
# _write_size_with_cells()
#
# Write the <x:SizeWithCells> element.
#
sub _write_size_with_cells {

    my $self = shift;

    $self->xml_empty_tag( 'x:SizeWithCells' );
}


##############################################################################
#
# _write_visible()
#
# Write the <x:Visible> element.
#
sub _write_visible {

    my $self = shift;

    $self->xml_empty_tag( 'x:Visible' );
}


##############################################################################
#
# _write_anchor()
#
# Write the <x:Anchor> element.
#
sub _write_anchor {

    my $self     = shift;
    my $vertices = shift;

    my ( $col_start, $row_start, $x1, $y1, $col_end, $row_end, $x2, $y2 ) =
      @$vertices;

    my $data = join ", ",
      ( $col_start, $x1, $row_start, $y1, $col_end, $x2, $row_end, $y2 );

    $self->xml_data_element( 'x:Anchor', $data );
}


##############################################################################
#
# _write_auto_fill()
#
# Write the <x:AutoFill> element.
#
sub _write_auto_fill {

    my $self = shift;
    my $data = 'False';

    $self->xml_data_element( 'x:AutoFill', $data );
}


##############################################################################
#
# _write_row()
#
# Write the <x:Row> element.
#
sub _write_row {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'x:Row', $data );
}


##############################################################################
#
# _write_column()
#
# Write the <x:Column> element.
#
sub _write_column {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'x:Column', $data );
}


##############################################################################
#
# _write_print_object()
#
# Write the <x:PrintObject> element.
#
sub _write_print_object {

    my $self = shift;
    my $data = 'False';

    $self->xml_data_element( 'x:PrintObject', $data );
}


##############################################################################
#
# _write_text_halign()
#
# Write the <x:TextHAlign> element.
#
sub _write_text_halign {

    my $self = shift;
    my $data = 'Center';

    $self->xml_data_element( 'x:TextHAlign', $data );
}


##############################################################################
#
# _write_text_valign()
#
# Write the <x:TextVAlign> element.
#
sub _write_text_valign {

    my $self = shift;
    my $data = 'Center';

    $self->xml_data_element( 'x:TextVAlign', $data );
}


##############################################################################
#
# _write_fmla_macro()
#
# Write the <x:FmlaMacro> element.
#
sub _write_fmla_macro {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'x:FmlaMacro', $data );
}

##############################################################################
#
# _write_imagedata()
#
# Write the <v:imagedata> element.
#
sub _write_imagedata {

    my $self    = shift;
    my $index   = shift;
    my $o_title = shift;

    my @attributes = (
        'o:relid' => 'rId' . $index,
        'o:title' => $o_title,
    );

    $self->xml_empty_tag( 'v:imagedata', @attributes );
}



##############################################################################
#
# _write_formulas()
#
# Write the <v:formulas> element.
#
sub _write_formulas {

    my $self                 = shift;

    $self->xml_start_tag( 'v:formulas' );

    # Write the v:f elements.
    $self->_write_f('if lineDrawn pixelLineWidth 0');
    $self->_write_f('sum @0 1 0');
    $self->_write_f('sum 0 0 @1');
    $self->_write_f('prod @2 1 2');
    $self->_write_f('prod @3 21600 pixelWidth');
    $self->_write_f('prod @3 21600 pixelHeight');
    $self->_write_f('sum @0 0 1');
    $self->_write_f('prod @6 1 2');
    $self->_write_f('prod @7 21600 pixelWidth');
    $self->_write_f('sum @8 21600 0');
    $self->_write_f('prod @7 21600 pixelHeight');
    $self->_write_f('sum @10 21600 0');

    $self->xml_end_tag( 'v:formulas' );
}


##############################################################################
#
# _write_f()
#
# Write the <v:f> element.
#
sub _write_f {

    my $self = shift;
    my $eqn  = shift;

    my @attributes = ( 'eqn' => $eqn );

    $self->xml_empty_tag( 'v:f', @attributes );
}

1;


__END__

=pod

=head1 NAME

VML - A class for writing the Excel XLSX VML files.

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
