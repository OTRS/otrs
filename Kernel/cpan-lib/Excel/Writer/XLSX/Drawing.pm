package Excel::Writer::XLSX::Drawing;

###############################################################################
#
# Drawing - A class for writing the Excel XLSX drawing.xml file.
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
use Excel::Writer::XLSX::Worksheet;

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

    $self->{_drawings}    = [];
    $self->{_embedded}    = 0;
    $self->{_orientation} = 0;

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

    # Write the xdr:wsDr element.
    $self->_write_drawing_workspace();

    if ( $self->{_embedded} ) {

        my $index = 0;
        for my $dimensions ( @{ $self->{_drawings} } ) {

            # Write the xdr:twoCellAnchor element.
            $self->_write_two_cell_anchor( ++$index, @$dimensions );
        }

    }
    else {
        my $index = 0;

        # Write the xdr:absoluteAnchor element.
        $self->_write_absolute_anchor( ++$index );
    }

    $self->xml_end_tag( 'xdr:wsDr' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# _add_drawing_object()
#
# Add a chart, image or shape sub object to the drawing.
#
sub _add_drawing_object {

    my $self = shift;

    push @{ $self->{_drawings} }, [@_];
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


##############################################################################
#
# _write_drawing_workspace()
#
# Write the <xdr:wsDr> element.
#
sub _write_drawing_workspace {

    my $self      = shift;
    my $schema    = 'http://schemas.openxmlformats.org/drawingml/';
    my $xmlns_xdr = $schema . '2006/spreadsheetDrawing';
    my $xmlns_a   = $schema . '2006/main';

    my @attributes = (
        'xmlns:xdr' => $xmlns_xdr,
        'xmlns:a'   => $xmlns_a,
    );

    $self->xml_start_tag( 'xdr:wsDr', @attributes );
}


##############################################################################
#
# _write_two_cell_anchor()
#
# Write the <xdr:twoCellAnchor> element.
#
sub _write_two_cell_anchor {

    my $self            = shift;
    my $index           = shift;
    my $type            = shift;
    my $col_from        = shift;
    my $row_from        = shift;
    my $col_from_offset = shift;
    my $row_from_offset = shift;
    my $col_to          = shift;
    my $row_to          = shift;
    my $col_to_offset   = shift;
    my $row_to_offset   = shift;
    my $col_absolute    = shift;
    my $row_absolute    = shift;
    my $width           = shift;
    my $height          = shift;
    my $description     = shift;
    my $shape           = shift;

    my @attributes = ();


    # Add attribute for images.
    if ( $type == 2 ) {
        push @attributes, ( editAs => 'oneCell' );
    }

    # Add editAs attribute for shapes.
    push @attributes, ( editAs => $shape->{_editAs} ) if $shape->{_editAs};

    $self->xml_start_tag( 'xdr:twoCellAnchor', @attributes );

    # Write the xdr:from element.
    $self->_write_from(
        $col_from,
        $row_from,
        $col_from_offset,
        $row_from_offset,

    );

    # Write the xdr:from element.
    $self->_write_to(
        $col_to,
        $row_to,
        $col_to_offset,
        $row_to_offset,

    );

    if ( $type == 1 ) {

        # Graphic frame.

        # Write the xdr:graphicFrame element for charts.
        $self->_write_graphic_frame( $index, $description );
    }
    elsif ( $type == 2 ) {

        # Write the xdr:pic element.
        $self->_write_pic( $index, $col_absolute, $row_absolute, $width,
            $height, $description );
    }
    else {

        # Write the xdr:sp element for shapes.
        $self->_write_sp( $index, $col_absolute, $row_absolute, $width, $height,
            $shape );
    }

    # Write the xdr:clientData element.
    $self->_write_client_data();

    $self->xml_end_tag( 'xdr:twoCellAnchor' );
}


##############################################################################
#
# _write_absolute_anchor()
#
# Write the <xdr:absoluteAnchor> element.
#
sub _write_absolute_anchor {

    my $self  = shift;
    my $index = shift;

    $self->xml_start_tag( 'xdr:absoluteAnchor' );

    # Different co-ordinates for horizonatal (= 0) and vertical (= 1).
    if ( $self->{_orientation} == 0 ) {

        # Write the xdr:pos element.
        $self->_write_pos( 0, 0 );

        # Write the xdr:ext element.
        $self->_write_ext( 9308969, 6078325 );

    }
    else {

        # Write the xdr:pos element.
        $self->_write_pos( 0, -47625 );

        # Write the xdr:ext element.
        $self->_write_ext( 6162675, 6124575 );

    }


    # Write the xdr:graphicFrame element.
    $self->_write_graphic_frame( $index );

    # Write the xdr:clientData element.
    $self->_write_client_data();

    $self->xml_end_tag( 'xdr:absoluteAnchor' );
}


##############################################################################
#
# _write_from()
#
# Write the <xdr:from> element.
#
sub _write_from {

    my $self       = shift;
    my $col        = shift;
    my $row        = shift;
    my $col_offset = shift;
    my $row_offset = shift;

    $self->xml_start_tag( 'xdr:from' );

    # Write the xdr:col element.
    $self->_write_col( $col );

    # Write the xdr:colOff element.
    $self->_write_col_off( $col_offset );

    # Write the xdr:row element.
    $self->_write_row( $row );

    # Write the xdr:rowOff element.
    $self->_write_row_off( $row_offset );

    $self->xml_end_tag( 'xdr:from' );
}


##############################################################################
#
# _write_to()
#
# Write the <xdr:to> element.
#
sub _write_to {

    my $self       = shift;
    my $col        = shift;
    my $row        = shift;
    my $col_offset = shift;
    my $row_offset = shift;

    $self->xml_start_tag( 'xdr:to' );

    # Write the xdr:col element.
    $self->_write_col( $col );

    # Write the xdr:colOff element.
    $self->_write_col_off( $col_offset );

    # Write the xdr:row element.
    $self->_write_row( $row );

    # Write the xdr:rowOff element.
    $self->_write_row_off( $row_offset );

    $self->xml_end_tag( 'xdr:to' );
}


##############################################################################
#
# _write_col()
#
# Write the <xdr:col> element.
#
sub _write_col {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'xdr:col', $data );
}


##############################################################################
#
# _write_col_off()
#
# Write the <xdr:colOff> element.
#
sub _write_col_off {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'xdr:colOff', $data );
}


##############################################################################
#
# _write_row()
#
# Write the <xdr:row> element.
#
sub _write_row {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'xdr:row', $data );
}


##############################################################################
#
# _write_row_off()
#
# Write the <xdr:rowOff> element.
#
sub _write_row_off {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'xdr:rowOff', $data );
}


##############################################################################
#
# _write_pos()
#
# Write the <xdr:pos> element.
#
sub _write_pos {

    my $self = shift;
    my $x    = shift;
    my $y    = shift;

    my @attributes = (
        'x' => $x,
        'y' => $y,
    );

    $self->xml_empty_tag( 'xdr:pos', @attributes );
}


##############################################################################
#
# _write_ext()
#
# Write the <xdr:ext> element.
#
sub _write_ext {

    my $self = shift;
    my $cx   = shift;
    my $cy   = shift;

    my @attributes = (
        'cx' => $cx,
        'cy' => $cy,
    );

    $self->xml_empty_tag( 'xdr:ext', @attributes );
}


##############################################################################
#
# _write_graphic_frame()
#
# Write the <xdr:graphicFrame> element.
#
sub _write_graphic_frame {

    my $self  = shift;
    my $index = shift;
    my $name  = shift;
    my $macro = '';

    my @attributes = ( 'macro' => $macro );

    $self->xml_start_tag( 'xdr:graphicFrame', @attributes );

    # Write the xdr:nvGraphicFramePr element.
    $self->_write_nv_graphic_frame_pr( $index, $name );

    # Write the xdr:xfrm element.
    $self->_write_xfrm();

    # Write the a:graphic element.
    $self->_write_atag_graphic( $index );

    $self->xml_end_tag( 'xdr:graphicFrame' );
}


##############################################################################
#
# _write_nv_graphic_frame_pr()
#
# Write the <xdr:nvGraphicFramePr> element.
#
sub _write_nv_graphic_frame_pr {

    my $self  = shift;
    my $index = shift;
    my $name  = shift;

    if ( !$name ) {
        $name = 'Chart ' . $index;
    }

    $self->xml_start_tag( 'xdr:nvGraphicFramePr' );

    # Write the xdr:cNvPr element.
    $self->_write_c_nv_pr( $index + 1, $name );

    # Write the xdr:cNvGraphicFramePr element.
    $self->_write_c_nv_graphic_frame_pr();

    $self->xml_end_tag( 'xdr:nvGraphicFramePr' );
}


##############################################################################
#
# _write_c_nv_pr()
#
# Write the <xdr:cNvPr> element.
#
sub _write_c_nv_pr {

    my $self  = shift;
    my $id    = shift;
    my $name  = shift;
    my $descr = shift;

    my @attributes = (
        'id'   => $id,
        'name' => $name,
    );

    # Add description attribute for images.
    if ( defined $descr ) {
        push @attributes, ( descr => $descr );
    }

    $self->xml_empty_tag( 'xdr:cNvPr', @attributes );
}


##############################################################################
#
# _write_c_nv_graphic_frame_pr()
#
# Write the <xdr:cNvGraphicFramePr> element.
#
sub _write_c_nv_graphic_frame_pr {

    my $self = shift;

    if ( $self->{_embedded} ) {
        $self->xml_empty_tag( 'xdr:cNvGraphicFramePr' );
    }
    else {
        $self->xml_start_tag( 'xdr:cNvGraphicFramePr' );

        # Write the a:graphicFrameLocks element.
        $self->_write_a_graphic_frame_locks();

        $self->xml_end_tag( 'xdr:cNvGraphicFramePr' );
    }
}


##############################################################################
#
# _write_a_graphic_frame_locks()
#
# Write the <a:graphicFrameLocks> element.
#
sub _write_a_graphic_frame_locks {

    my $self   = shift;
    my $no_grp = 1;

    my @attributes = ( 'noGrp' => $no_grp );

    $self->xml_empty_tag( 'a:graphicFrameLocks', @attributes );
}


##############################################################################
#
# _write_xfrm()
#
# Write the <xdr:xfrm> element.
#
sub _write_xfrm {

    my $self = shift;

    $self->xml_start_tag( 'xdr:xfrm' );

    # Write the xfrmOffset element.
    $self->_write_xfrm_offset();

    # Write the xfrmOffset element.
    $self->_write_xfrm_extension();

    $self->xml_end_tag( 'xdr:xfrm' );
}


##############################################################################
#
# _write_xfrm_offset()
#
# Write the <a:off> xfrm sub-element.
#
sub _write_xfrm_offset {

    my $self = shift;
    my $x    = 0;
    my $y    = 0;

    my @attributes = (
        'x' => $x,
        'y' => $y,
    );

    $self->xml_empty_tag( 'a:off', @attributes );
}


##############################################################################
#
# _write_xfrm_extension()
#
# Write the <a:ext> xfrm sub-element.
#
sub _write_xfrm_extension {

    my $self = shift;
    my $x    = 0;
    my $y    = 0;

    my @attributes = (
        'cx' => $x,
        'cy' => $y,
    );

    $self->xml_empty_tag( 'a:ext', @attributes );
}


##############################################################################
#
# _write_atag_graphic()
#
# Write the <a:graphic> element.
#
sub _write_atag_graphic {

    my $self  = shift;
    my $index = shift;

    $self->xml_start_tag( 'a:graphic' );

    # Write the a:graphicData element.
    $self->_write_atag_graphic_data( $index );

    $self->xml_end_tag( 'a:graphic' );
}


##############################################################################
#
# _write_atag_graphic_data()
#
# Write the <a:graphicData> element.
#
sub _write_atag_graphic_data {

    my $self  = shift;
    my $index = shift;
    my $uri   = 'http://schemas.openxmlformats.org/drawingml/2006/chart';

    my @attributes = ( 'uri' => $uri, );

    $self->xml_start_tag( 'a:graphicData', @attributes );

    # Write the c:chart element.
    $self->_write_c_chart( 'rId' . $index );

    $self->xml_end_tag( 'a:graphicData' );
}


##############################################################################
#
# _write_c_chart()
#
# Write the <c:chart> element.
#
sub _write_c_chart {

    my $self    = shift;
    my $r_id    = shift;
    my $schema  = 'http://schemas.openxmlformats.org/';
    my $xmlns_c = $schema . 'drawingml/2006/chart';
    my $xmlns_r = $schema . 'officeDocument/2006/relationships';


    my @attributes = (
        'xmlns:c' => $xmlns_c,
        'xmlns:r' => $xmlns_r,
        'r:id'    => $r_id,
    );

    $self->xml_empty_tag( 'c:chart', @attributes );
}


##############################################################################
#
# _write_client_data()
#
# Write the <xdr:clientData> element.
#
sub _write_client_data {

    my $self = shift;

    $self->xml_empty_tag( 'xdr:clientData' );
}


##############################################################################
#
# _write_sp()
#
# Write the <xdr:sp> element.
#
sub _write_sp {

    my $self         = shift;
    my $index        = shift;
    my $col_absolute = shift;
    my $row_absolute = shift;
    my $width        = shift;
    my $height       = shift;
    my $shape        = shift;

    if ( $shape->{_connect} ) {
        my @attributes = ( macro => '' );
        $self->xml_start_tag( 'xdr:cxnSp', @attributes );

        # Write the xdr:nvCxnSpPr element.
        $self->_write_nv_cxn_sp_pr( $index, $shape );

        # Write the xdr:spPr element.
        $self->_write_xdr_sp_pr( $index, $col_absolute, $row_absolute, $width,
            $height, $shape );

        $self->xml_end_tag( 'xdr:cxnSp' );
    }
    else {

        # Add attribute for shapes.
        my @attributes = ( macro => '', textlink => '' );
        $self->xml_start_tag( 'xdr:sp', @attributes );

        # Write the xdr:nvSpPr element.
        $self->_write_nv_sp_pr( $index, $shape );

        # Write the xdr:spPr element.
        $self->_write_xdr_sp_pr( $index, $col_absolute, $row_absolute, $width,
            $height, $shape );

        # Write the xdr:txBody element.
        if ( $shape->{_text} ) {
            $self->_write_txBody( $col_absolute, $row_absolute, $width, $height,
                $shape );
        }

        $self->xml_end_tag( 'xdr:sp' );
    }
}
##############################################################################
#
# _write_nv_cxn_sp_pr()
#
# Write the <xdr:nvCxnSpPr> element.
#
sub _write_nv_cxn_sp_pr {

    my $self  = shift;
    my $index = shift;
    my $shape = shift;

    $self->xml_start_tag( 'xdr:nvCxnSpPr' );

    $shape->{_name} = join( ' ', $shape->{_type}, $index )
      unless defined $shape->{_name};
    $self->_write_c_nv_pr( $shape->{_id}, $shape->{_name} );

    $self->xml_start_tag( 'xdr:cNvCxnSpPr' );

    my @attributes = ( noChangeShapeType => '1' );
    $self->xml_empty_tag( 'a:cxnSpLocks', @attributes );

    if ( $shape->{_start} ) {
        @attributes =
          ( 'id' => $shape->{_start}, 'idx' => $shape->{_start_index} );
        $self->xml_empty_tag( 'a:stCxn', @attributes );
    }

    if ( $shape->{_end} ) {
        @attributes = ( 'id' => $shape->{_end}, 'idx' => $shape->{_end_index} );
        $self->xml_empty_tag( 'a:endCxn', @attributes );
    }
    $self->xml_end_tag( 'xdr:cNvCxnSpPr' );
    $self->xml_end_tag( 'xdr:nvCxnSpPr' );
}


##############################################################################
#
# _write_nv_sp_pr()
#
# Write the <xdr:NvSpPr> element.
#
sub _write_nv_sp_pr {

    my $self  = shift;
    my $index = shift;
    my $shape = shift;

    my @attributes = ();

    $self->xml_start_tag( 'xdr:nvSpPr' );

    my $shape_name = $shape->{_type} . ' ' . $index;

    $self->_write_c_nv_pr( $shape->{_id}, $shape_name );

    @attributes = ( 'txBox' => 1 ) if $shape->{_txBox};

    $self->xml_start_tag( 'xdr:cNvSpPr', @attributes );

    @attributes = ( noChangeArrowheads => '1' );

    $self->xml_empty_tag( 'a:spLocks', @attributes );

    $self->xml_end_tag( 'xdr:cNvSpPr' );
    $self->xml_end_tag( 'xdr:nvSpPr' );
}


##############################################################################
#
# _write_pic()
#
# Write the <xdr:pic> element.
#
sub _write_pic {

    my $self         = shift;
    my $index        = shift;
    my $col_absolute = shift;
    my $row_absolute = shift;
    my $width        = shift;
    my $height       = shift;
    my $description  = shift;

    $self->xml_start_tag( 'xdr:pic' );

    # Write the xdr:nvPicPr element.
    $self->_write_nv_pic_pr( $index, $description );

    # Write the xdr:blipFill element.
    $self->_write_blip_fill( $index );

    # Pictures are rectangle shapes by default.
    my $shape = { _type => 'rect' };

    # Write the xdr:spPr element.
    $self->_write_sp_pr( $col_absolute, $row_absolute, $width, $height,
        $shape );

    $self->xml_end_tag( 'xdr:pic' );
}


##############################################################################
#
# _write_nv_pic_pr()
#
# Write the <xdr:nvPicPr> element.
#
sub _write_nv_pic_pr {

    my $self        = shift;
    my $index       = shift;
    my $description = shift;

    $self->xml_start_tag( 'xdr:nvPicPr' );

    # Write the xdr:cNvPr element.
    $self->_write_c_nv_pr( $index + 1, 'Picture ' . $index, $description );

    # Write the xdr:cNvPicPr element.
    $self->_write_c_nv_pic_pr();

    $self->xml_end_tag( 'xdr:nvPicPr' );
}


##############################################################################
#
# _write_c_nv_pic_pr()
#
# Write the <xdr:cNvPicPr> element.
#
sub _write_c_nv_pic_pr {

    my $self = shift;

    $self->xml_start_tag( 'xdr:cNvPicPr' );

    # Write the a:picLocks element.
    $self->_write_a_pic_locks();

    $self->xml_end_tag( 'xdr:cNvPicPr' );
}


##############################################################################
#
# _write_a_pic_locks()
#
# Write the <a:picLocks> element.
#
sub _write_a_pic_locks {

    my $self             = shift;
    my $no_change_aspect = 1;

    my @attributes = ( 'noChangeAspect' => $no_change_aspect );

    $self->xml_empty_tag( 'a:picLocks', @attributes );
}


##############################################################################
#
# _write_blip_fill()
#
# Write the <xdr:blipFill> element.
#
sub _write_blip_fill {

    my $self  = shift;
    my $index = shift;

    $self->xml_start_tag( 'xdr:blipFill' );

    # Write the a:blip element.
    $self->_write_a_blip( $index );

    # Write the a:stretch element.
    $self->_write_a_stretch();

    $self->xml_end_tag( 'xdr:blipFill' );
}


##############################################################################
#
# _write_a_blip()
#
# Write the <a:blip> element.
#
sub _write_a_blip {

    my $self    = shift;
    my $index   = shift;
    my $schema  = 'http://schemas.openxmlformats.org/officeDocument/';
    my $xmlns_r = $schema . '2006/relationships';
    my $r_embed = 'rId' . $index;

    my @attributes = (
        'xmlns:r' => $xmlns_r,
        'r:embed' => $r_embed,
    );

    $self->xml_empty_tag( 'a:blip', @attributes );
}


##############################################################################
#
# _write_a_stretch()
#
# Write the <a:stretch> element.
#
sub _write_a_stretch {

    my $self = shift;

    $self->xml_start_tag( 'a:stretch' );

    # Write the a:fillRect element.
    $self->_write_a_fill_rect();

    $self->xml_end_tag( 'a:stretch' );
}


##############################################################################
#
# _write_a_fill_rect()
#
# Write the <a:fillRect> element.
#
sub _write_a_fill_rect {

    my $self = shift;

    $self->xml_empty_tag( 'a:fillRect' );
}


##############################################################################
#
# _write_sp_pr()
#
# Write the <xdr:spPr> element, for charts.
#
sub _write_sp_pr {

    my $self         = shift;
    my $col_absolute = shift;
    my $row_absolute = shift;
    my $width        = shift;
    my $height       = shift;
    my $shape        = shift || {};

    $self->xml_start_tag( 'xdr:spPr' );

    # Write the a:xfrm element.
    $self->_write_a_xfrm( $col_absolute, $row_absolute, $width, $height );

    # Write the a:prstGeom element.
    $self->_write_a_prst_geom( $shape );

    $self->xml_end_tag( 'xdr:spPr' );
}


##############################################################################
#
# _write_xdr_sp_pr()
#
# Write the <xdr:spPr> element for shapes.
#
sub _write_xdr_sp_pr {

    my $self         = shift;
    my $index        = shift;
    my $col_absolute = shift;
    my $row_absolute = shift;
    my $width        = shift;
    my $height       = shift;
    my $shape        = shift;

    my @attributes = ( 'bwMode' => 'auto' );

    $self->xml_start_tag( 'xdr:spPr', @attributes );

    # Write the a:xfrm element.
    $self->_write_a_xfrm( $col_absolute, $row_absolute, $width, $height,
        $shape );

    # Write the a:prstGeom element.
    $self->_write_a_prst_geom( $shape );

    my $fill = $shape->{_fill};

    if ( length $fill > 1 ) {

        # Write the a:solidFill element.
        $self->_write_a_solid_fill( $fill );
    }
    else {
        $self->xml_empty_tag( 'a:noFill' );
    }

    # Write the a:ln element.
    $self->_write_a_ln( $shape );

    $self->xml_end_tag( 'xdr:spPr' );
}

##############################################################################
#
# _write_a_xfrm()
#
# Write the <a:xfrm> element.
#
sub _write_a_xfrm {

    my $self         = shift;
    my $col_absolute = shift;
    my $row_absolute = shift;
    my $width        = shift;
    my $height       = shift;
    my $shape        = shift || {};
    my @attributes   = ();

    my $rotation = $shape->{_rotation} || 0;
    $rotation *= 60000;

    push( @attributes, ( 'rot'   => $rotation ) ) if $rotation;
    push( @attributes, ( 'flipH' => 1 ) )         if $shape->{_flip_h};
    push( @attributes, ( 'flipV' => 1 ) )         if $shape->{_flip_v};

    $self->xml_start_tag( 'a:xfrm', @attributes );

    # Write the a:off element.
    $self->_write_a_off( $col_absolute, $row_absolute );

    # Write the a:ext element.
    $self->_write_a_ext( $width, $height );

    $self->xml_end_tag( 'a:xfrm' );
}


##############################################################################
#
# _write_a_off()
#
# Write the <a:off> element.
#
sub _write_a_off {

    my $self = shift;
    my $x    = shift;
    my $y    = shift;

    my @attributes = (
        'x' => $x,
        'y' => $y,
    );

    $self->xml_empty_tag( 'a:off', @attributes );
}


##############################################################################
#
# _write_a_ext()
#
# Write the <a:ext> element.
#
sub _write_a_ext {

    my $self = shift;
    my $cx   = shift;
    my $cy   = shift;

    my @attributes = (
        'cx' => $cx,
        'cy' => $cy,
    );

    $self->xml_empty_tag( 'a:ext', @attributes );
}


##############################################################################
#
# _write_a_prst_geom()
#
# Write the <a:prstGeom> element.
#
sub _write_a_prst_geom {

    my $self = shift;
    my $shape = shift || {};

    my @attributes = ();

    @attributes = ( 'prst' => $shape->{_type} ) if $shape->{_type};

    $self->xml_start_tag( 'a:prstGeom', @attributes );

    # Write the a:avLst element.
    $self->_write_a_av_lst( $shape );

    $self->xml_end_tag( 'a:prstGeom' );
}


##############################################################################
#
# _write_a_av_lst()
#
# Write the <a:avLst> element.
#
sub _write_a_av_lst {

    my $self        = shift;
    my $shape       = shift || {};
    my $adjustments = [];

    if ( defined $shape->{_adjustments} ) {
        $adjustments = $shape->{_adjustments};
    }

    if ( @$adjustments ) {
        $self->xml_start_tag( 'a:avLst' );

        my $i = 0;
        foreach my $adj ( @{$adjustments} ) {
            $i++;

            # Only connectors have multiple adjustments.
            my $suffix = $shape->{_connect} ? $i : '';

            # Scale Adjustments: 100,000 = 100%.
            my $adj_int = int( $adj * 1000 );

            my @attributes =
              ( name => 'adj' . $suffix, fmla => "val $adj_int" );

            $self->xml_empty_tag( 'a:gd', @attributes );
        }
        $self->xml_end_tag( 'a:avLst' );
    }
    else {
        $self->xml_empty_tag( 'a:avLst' );
    }
}


##############################################################################
#
# _write_a_solid_fill()
#
# Write the <a:solidFill> element.
#
sub _write_a_solid_fill {

    my $self = shift;
    my $rgb  = shift;

    $rgb = '000000' unless defined $rgb;

    my @attributes = ( 'val' => $rgb );

    $self->xml_start_tag( 'a:solidFill' );

    $self->xml_empty_tag( 'a:srgbClr', @attributes );

    $self->xml_end_tag( 'a:solidFill' );
}


##############################################################################
#
# _write_a_ln()
#
# Write the <a:ln> element.
#
sub _write_a_ln {

    my $self = shift;
    my $shape = shift || {};

    my $weight = $shape->{_line_weight};

    my @attributes = ( 'w' => $weight * 9525 );

    $self->xml_start_tag( 'a:ln', @attributes );

    my $line = $shape->{_line};

    if ( length $line > 1 ) {

        # Write the a:solidFill element.
        $self->_write_a_solid_fill( $line );
    }
    else {
        $self->xml_empty_tag( 'a:noFill' );
    }

    if ( $shape->{_line_type} ) {

        @attributes = ( 'val' => $shape->{_line_type} );
        $self->xml_empty_tag( 'a:prstDash', @attributes );
    }

    if ( $shape->{_connect} ) {
        $self->xml_empty_tag( 'a:round' );
    }
    else {
        @attributes = ( 'lim' => 800000 );
        $self->xml_empty_tag( 'a:miter', @attributes );
    }

    $self->xml_empty_tag( 'a:headEnd' );
    $self->xml_empty_tag( 'a:tailEnd' );

    $self->xml_end_tag( 'a:ln' );
}


##############################################################################
#
# _write_txBody
#
# Write the <xdr:txBody> element.
#
sub _write_txBody {

    my $self         = shift;
    my $col_absolute = shift;
    my $row_absolute = shift;
    my $width        = shift;
    my $height       = shift;
    my $shape        = shift;

    my @attributes = (
        vertOverflow => "clip",
        wrap         => "square",
        lIns         => "27432",
        tIns         => "22860",
        rIns         => "27432",
        bIns         => "22860",
        anchor       => $shape->{_valign},
        upright      => "1",
    );

    $self->xml_start_tag( 'xdr:txBody' );
    $self->xml_empty_tag( 'a:bodyPr', @attributes );
    $self->xml_empty_tag( 'a:lstStyle' );

    $self->xml_start_tag( 'a:p' );

    my $rotation = $shape->{_format}->{_rotation};
    $rotation = 0 unless defined $rotation;
    $rotation *= 60000;

    @attributes = ( algn => $shape->{_align}, rtl => $rotation );
    $self->xml_start_tag( 'a:pPr', @attributes );

    @attributes = ( sz => "1000" );
    $self->xml_empty_tag( 'a:defRPr', @attributes );

    $self->xml_end_tag( 'a:pPr' );
    $self->xml_start_tag( 'a:r' );

    my $size = $shape->{_format}->{_size};
    $size = 8 unless defined $size;
    $size *= 100;

    my $bold = $shape->{_format}->{_bold};
    $bold = 0 unless defined $bold;

    my $italic = $shape->{_format}->{_italic};
    $italic = 0 unless defined $italic;

    my $underline = $shape->{_format}->{_underline};
    $underline = $underline ? 'sng' : 'none';

    my $strike = $shape->{_format}->{_font_strikeout};
    $strike = $strike ? 'Strike' : 'noStrike';

    @attributes = (
        lang     => "en-US",
        sz       => $size,
        b        => $bold,
        i        => $italic,
        u        => $underline,
        strike   => $strike,
        baseline => 0,
    );

    $self->xml_start_tag( 'a:rPr', @attributes );

    my $color = $shape->{_format}->{_color};
    if ( defined $color ) {
        $color = $shape->_get_palette_color( $color );
        $color =~ s/^FF//;    # Remove leading FF from rgb for shape color.
    }
    else {
        $color = '000000';
    }

    $self->_write_a_solid_fill( $color );

    my $font = $shape->{_format}->{_font};
    $font = 'Calibri' unless defined $font;
    @attributes = ( typeface => $font );
    $self->xml_empty_tag( 'a:latin', @attributes );

    $self->xml_empty_tag( 'a:cs', @attributes );

    $self->xml_end_tag( 'a:rPr' );

    $self->xml_data_element( 'a:t', $shape->{_text} );

    $self->xml_end_tag( 'a:r' );
    $self->xml_end_tag( 'a:p' );
    $self->xml_end_tag( 'xdr:txBody' );

}


1;
__END__

=pod

=head1 NAME

Drawing - A class for writing the Excel XLSX drawing.xml file.

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
