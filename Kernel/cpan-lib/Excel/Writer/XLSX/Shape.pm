package Excel::Writer::XLSX::Shape;

###############################################################################
#
# Shape - A class for writing Excel shapes.
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
use Exporter;

our @ISA     = qw(Exporter);
our $VERSION = '0.95';
our $AUTOLOAD;

###############################################################################
#
# new()
#
sub new {

    my $class      = shift;
    my $fh         = shift;
    my $self       = Excel::Writer::XLSX::Package::XMLwriter->new( $fh );

    my %properties = @_;

    $self->{_name} = undef;
    $self->{_type} = 'rect';

    # Is a Connector shape. 1/0 Value is a hash lookup from type.
    $self->{_connect} = 0;

    # Is a Drawing. Always 0, since a single shape never fills an entire sheet.
    $self->{_drawing} = 0;

    # OneCell or Absolute: options to move and/or size with cells.
    $self->{_editAs} = '';

    # Auto-incremented, unless supplied by user.
    $self->{_id} = 0;

    # Shape text (usually centered on shape geometry).
    $self->{_text} = 0;

    # Shape stencil mode.  A copy (child) is created when inserted.
    # The link to parent is broken.
    $self->{_stencil} = 1;

    # Index to _shapes array when inserted.
    $self->{_element} = -1;

    # Shape ID of starting connection, if any.
    $self->{_start} = undef;

    # Shape vertex, starts at 0, numbered clockwise from 12 o'clock.
    $self->{_start_index} = undef;

    $self->{_end}       = undef;
    $self->{_end_index} = undef;

    # Number and size of adjustments for shapes (usually connectors).
    $self->{_adjustments} = [];

    # Start and end sides. t)op, b)ottom, l)eft, or r)ight.
    $self->{_start_side} = '';
    $self->{_end_side}   = '';

    # Flip shape Horizontally. eg. arrow left to arrow right.
    $self->{_flip_h} = 0;

    # Flip shape Vertically. eg. up arrow to down arrow.
    $self->{_flip_v} = 0;

    # shape rotation (in degrees 0-360).
    $self->{_rotation} = 0;

    # An alternate way to create a text box, because Excel allows it.
    # It is just a rectangle with text.
    $self->{_txBox} = 0;

    # Shape outline colour, or 0 for noFill (default black).
    $self->{_line} = '000000';

    # Line type: dash, sysDot, dashDot, lgDash, lgDashDot, lgDashDotDot.
    $self->{_line_type} = '';

    # Line weight (integer).
    $self->{_line_weight} = 1;

    # Shape fill colour, or 0 for noFill (default noFill).
    $self->{_fill} = 0;

    # Formatting for shape text, if any.
    $self->{_format} = {};

    # copy of colour palette table from Workbook.pm.
    $self->{_palette} = [];

    # Vertical alignment: t, ctr, b.
    $self->{_valign} = 'ctr';

    # Alignment: l, ctr, r, just
    $self->{_align} = 'ctr';

    $self->{_x_offset} = 0;
    $self->{_y_offset} = 0;

    # Scale factors, which also may be set when the shape is inserted.
    $self->{_scale_x} = 1;
    $self->{_scale_y} = 1;

    # Default size, which can be modified and/or scaled.
    $self->{_width}  = 50;
    $self->{_height} = 50;

    # Initial assignment. May be modified when prepared.
    $self->{_column_start} = 0;
    $self->{_row_start}    = 0;
    $self->{_x1}           = 0;
    $self->{_y1}           = 0;
    $self->{_column_end}   = 0;
    $self->{_row_end}      = 0;
    $self->{_x2}           = 0;
    $self->{_y2}           = 0;
    $self->{_x_abs}        = 0;
    $self->{_y_abs}        = 0;

    # Override default properties with passed arguments
    while ( my ( $key, $value ) = each( %properties ) ) {

        # Strip leading "-" from Tk style properties e.g. -color => 'red'.
        $key =~ s/^-//;

        # Add leading underscore "_" to internal hash keys, if not supplied.
        $key = "_" . $key unless $key =~ m/^_/;

        $self->{$key} = $value;
    }

    bless $self, $class;
    return $self;
}


###############################################################################
#
# set_properties( name => 'Shape 1', type => 'rect' )
#
# Set shape properties.
#
sub set_properties {

    my $self       = shift;
    my %properties = @_;

    # Update properties with passed arguments.
    while ( my ( $key, $value ) = each( %properties ) ) {

        # Strip leading "-" from Tk style properties e.g. -color => 'red'.
        $key =~ s/^-//;

        # Add leading underscore "_" to internal hash keys, if not supplied.
        $key = "_" . $key unless $key =~ m/^_/;

        if ( !exists $self->{$key} ) {
            warn "Unknown shape property: $key. Property not set.\n";
            next;
        }

        $self->{$key} = $value;
    }
}


###############################################################################
#
# set_adjustment( adj1, adj2, adj3, ... )
#
# Set the shape adjustments array (as a reference).
#
sub set_adjustments {

    my $self = shift;
    $self->{_adjustments} = \@_;
}


###############################################################################
#
# AUTOLOAD. Deus ex machina.
#
# Dynamically create set/get methods that aren't already defined.
#
sub AUTOLOAD {

    my $self = shift;

    # Ignore calls to DESTROY.
    return if $AUTOLOAD =~ /::DESTROY$/;

    # Check for a valid method names, i.e. "set_xxx_Cy".
    $AUTOLOAD =~ /.*::(get|set)(\w+)/ or die "Unknown method: $AUTOLOAD\n";

    # Match the function (get or set) and attribute, i.e. "_xxx_yyy".
    my $gs        = $1;
    my $attribute = $2;

    # Check that the attribute exists.
    exists $self->{$attribute} or die "Unknown method: $AUTOLOAD\n";

    # The attribute value
    my $value;

    # set_property() pattern.
    # When a method is AUTOLOADED we store a new anonymous
    # sub in the appropriate slot in the symbol table. The speeds up subsequent
    # calls to the same method.
    #
    no strict 'refs';    # To allow symbol table hackery

    $value = $_[0];
    $value = 1 if not defined $value;    # The default value is always 1

    if ( $gs eq 'set' ) {
        *{$AUTOLOAD} = sub {
            my $self  = shift;
            my $value = shift;

            $value = 1 if not defined $value;
            $self->{$attribute} = $value;
        };

        $self->{$attribute} = $value;
    }
    else {
        *{$AUTOLOAD} = sub {
            my $self = shift;
            return $self->{$attribute};
        };

        # Let AUTOLOAD return the attribute for the first invocation
        return $self->{$attribute};
    }
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


1;

__END__

=head1 NAME

Shape - A class for creating Excel Drawing shapes

=head1 SYNOPSIS

To create a simple Excel file containing shapes using L<Excel::Writer::XLSX>:

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'shape.xlsx' );
    my $worksheet = $workbook->add_worksheet();

    # Add a default rectangle shape.
    my $rect = $workbook->add_shape();

    # Add an ellipse with centered text.
    my $ellipse = $workbook->add_shape(
        type => 'ellipse',
        text => "Hello\nWorld"
    );

    # Add a plus shape.
    my $plus = $workbook->add_shape( type => 'plus');

    # Insert the shapes in the worksheet.
    $worksheet->insert_shape( 'B3', $rect );
    $worksheet->insert_shape( 'C3', $ellipse );
    $worksheet->insert_shape( 'D3', $plus );


=head1 DESCRIPTION

The C<Excel::Writer::XLSX::Shape> module is used to create Shape objects for L<Excel::Writer::XLSX>.

A Shape object is created via the Workbook C<add_shape()> method:

    my $shape_rect = $workbook->add_shape( type => 'rect' );

Once the object is created it can be inserted into a worksheet using the C<insert_shape()> method:

    $worksheet->insert_shape('A1', $shape_rect);

A Shape can be inserted multiple times if required.

    $worksheet->insert_shape('A1', $shape_rect);
    $worksheet->insert_shape('B2', $shape_rect, 20, 30);


=head1 METHODS

=head2 add_shape( %properties )

The C<add_shape()> Workbook method specifies the properties of the Shape in hash C<< property => value >> format:

    my $shape = $workbook->add_shape( %properties );

The available properties are shown below.

=head2 insert_shape( $row, $col, $shape, $x, $y, $scale_x, $scale_y )

The C<insert_shape()> Worksheet method sets the location and scale of the shape object within the worksheet.

    # Insert the shape into the worksheet.
    $worksheet->insert_shape( 'E2', $shape );

Using the cell location and the C<$x> and C<$y> cell offsets it is possible to position a shape anywhere on the canvas of a worksheet.

A more detailed explanation of the C<insert_shape()> method is given in the main L<Excel::Writer::XLSX> documentation.


=head1 SHAPE PROPERTIES

Any shape property can be queried or modified by the corresponding get/set method:

    my $ellipse = $workbook->add_shape( %properties );
    $ellipse->set_type( 'plus' );    # No longer an ellipse!
    my $type = $ellipse->get_type();  # Find out what it really is.

Multiple shape properties may also be modified in one go by using the C<set_properties()> method:

    $shape->set_properties( type => 'ellipse', text => 'Hello' );

The properties of a shape object that can be defined via C<add_shape()> are shown below.

=head2 name

Defines the name of the shape. This is an optional property and the shape will be given a default name if not supplied. The name is generally only used by Excel Macros to refer to the object.

=head2 type

Defines the type of the object such as C<rect>, C<ellipse> or C<triangle>:

    my $ellipse = $workbook->add_shape( type => 'ellipse' );

The default type is C<rect>.

The full list of available shapes is shown below.

See also the C<shapes_all.pl> program in the C<examples> directory of the distro. It creates an example workbook with all supported shapes labelled with their shape names.


=over 4

=item * Basic Shapes

    blockArc              can            chevron       cube          decagon
    diamond               dodecagon      donut         ellipse       funnel
    gear6                 gear9          heart         heptagon      hexagon
    homePlate             lightningBolt  line          lineInv       moon
    nonIsoscelesTrapezoid noSmoking      octagon       parallelogram pentagon
    pie                   pieWedge       plaque        rect          round1Rect
    round2DiagRect        round2SameRect roundRect     rtTriangle    smileyFace
    snip1Rect             snip2DiagRect  snip2SameRect snipRoundRect star10
    star12                star16         star24        star32        star4
    star5                 star6          star7         star8         sun
    teardrop              trapezoid      triangle

=item * Arrow Shapes

    bentArrow        bentUpArrow       circularArrow     curvedDownArrow
    curvedLeftArrow  curvedRightArrow  curvedUpArrow     downArrow
    leftArrow        leftCircularArrow leftRightArrow    leftRightCircularArrow
    leftRightUpArrow leftUpArrow       notchedRightArrow quadArrow
    rightArrow       stripedRightArrow swooshArrow       upArrow
    upDownArrow      uturnArrow

=item * Connector Shapes

    bentConnector2   bentConnector3   bentConnector4
    bentConnector5   curvedConnector2 curvedConnector3
    curvedConnector4 curvedConnector5 straightConnector1

=item * Callout Shapes

    accentBorderCallout1  accentBorderCallout2  accentBorderCallout3
    accentCallout1        accentCallout2        accentCallout3
    borderCallout1        borderCallout2        borderCallout3
    callout1              callout2              callout3
    cloudCallout          downArrowCallout      leftArrowCallout
    leftRightArrowCallout quadArrowCallout      rightArrowCallout
    upArrowCallout        upDownArrowCallout    wedgeEllipseCallout
    wedgeRectCallout      wedgeRoundRectCallout

=item * Flow Chart Shapes

    flowChartAlternateProcess  flowChartCollate        flowChartConnector
    flowChartDecision          flowChartDelay          flowChartDisplay
    flowChartDocument          flowChartExtract        flowChartInputOutput
    flowChartInternalStorage   flowChartMagneticDisk   flowChartMagneticDrum
    flowChartMagneticTape      flowChartManualInput    flowChartManualOperation
    flowChartMerge             flowChartMultidocument  flowChartOfflineStorage
    flowChartOffpageConnector  flowChartOnlineStorage  flowChartOr
    flowChartPredefinedProcess flowChartPreparation    flowChartProcess
    flowChartPunchedCard       flowChartPunchedTape    flowChartSort
    flowChartSummingJunction   flowChartTerminator

=item * Action Shapes

    actionButtonBackPrevious actionButtonBeginning actionButtonBlank
    actionButtonDocument     actionButtonEnd       actionButtonForwardNext
    actionButtonHelp         actionButtonHome      actionButtonInformation
    actionButtonMovie        actionButtonReturn    actionButtonSound

=item * Chart Shapes

Not to be confused with Excel Charts.

    chartPlus chartStar chartX

=item * Math Shapes

    mathDivide mathEqual mathMinus mathMultiply mathNotEqual mathPlus

=item * Stars and Banners

    arc            bevel          bracePair  bracketPair chord
    cloud          corner         diagStripe doubleWave  ellipseRibbon
    ellipseRibbon2 foldedCorner   frame      halfFrame   horizontalScroll
    irregularSeal1 irregularSeal2 leftBrace  leftBracket leftRightRibbon
    plus           ribbon         ribbon2    rightBrace  rightBracket
    verticalScroll wave

=item * Tab Shapes

    cornerTabs plaqueTabs squareTabs

=back

=head2 text

This property is used to make the shape act like a text box.

    my $rect = $workbook->add_shape( type => 'rect', text => "Hello\nWorld" );

The text is super-imposed over the shape. The text can be wrapped using the newline character C<\n>.

=head2 id

Identification number for internal identification. This number will be auto-assigned, if not assigned, or if it is a duplicate.

=head2 format

Workbook format for decorating the shape text (font family, size, and decoration).

=head2 start, start_index

Shape indices of the starting point for a connector and the index of the connection. Index numbers are zero-based, start from the top dead centre and are counted clockwise.

Indices are typically created for vertices and centre points of shapes. They are the blue connection points that appear when connection shapes are selected manually in Excel.

=head2 end, end_index

Same as above but for end points and end connections.


=head2 start_side, end_side

This is either the letter C<b> or C<r> for the bottom or right side of the shape to be connected to and from.

If the C<start>, C<start_index>, and C<start_side> parameters are defined for a connection shape, the shape will be auto located and linked to the starting and ending shapes respectively. This can be very useful for flow and organisation charts.

=head2 flip_h, flip_v

Set this value to 1, to flip the shape horizontally and/or vertically.

=head2 rotation

Shape rotation, in degrees, from 0 to 360.

=head2 line, fill

Shape colour for the outline and fill. Colours may be specified as a colour index, or in RGB format, i.e. C<AA00FF>.

See C<COLOURS IN EXCEL> in the main documentation for more information.

=head2 line_type

Line type for shape outline. The default is solid. The list of possible values is:

    dash, sysDot, dashDot, lgDash, lgDashDot, lgDashDotDot, solid

=head2 valign, align

Text alignment within the shape.

Vertical alignment can be:

    Setting     Meaning
    =======     =======
    t           Top
    ctr         Centre
    b           Bottom

Horizontal alignment can be:

    Setting     Meaning
    =======     =======
    l           Left
    r           Right
    ctr         Centre
    just        Justified

The default is to centre both horizontally and vertically.

=head2 scale_x, scale_y

Scale factor in x and y dimension, for scaling the shape width and height. The default value is 1.

Scaling may be set on the shape object or via C<insert_shape()>.

=head2 adjustments

Adjustment of shape vertices. Most shapes do not use this. For some shapes, there is a single adjustment to modify the geometry. For instance, the plus shape has one adjustment to control the width of the spokes.

Connectors can have a number of adjustments to control the shape routing. Typically, a connector will have 3 to 5 handles for routing the shape. The adjustment is in percent of the distance from the starting shape to the ending shape, alternating between the x and y dimension. Adjustments may be negative, to route the shape away from the endpoint.

=head2 stencil

Shapes work in stencil mode by default. That is, once a shape is inserted, its connection is separated from its master. The master shape may be modified after an instance is inserted, and only subsequent insertions will show the modifications.

This is helpful for Org charts, where an employee shape may be created once, and then the text of the shape is modified for each employee.

The C<insert_shape()> method returns a reference to the inserted shape (the child).

Stencil mode can be turned off, allowing for shape(s) to be modified after insertion. In this case the C<insert_shape()> method returns a reference to the inserted shape (the master). This is not very useful for inserting multiple shapes, since the x/y coordinates also gets modified.

=head1 TIPS

Use C<< $worksheet->hide_gridlines(2) >> to prepare a blank canvas without gridlines.

Shapes do not need to fit on one page. Excel will split a large drawing into multiple pages if required. Use the page break preview to show page boundaries superimposed on the drawing.

Connected shapes will auto-locate in Excel if you move either the starting shape or the ending shape separately. However, if you select both shapes (lasso or control-click), the connector will move with it, and the shape adjustments will not re-calculate.

=head1 EXAMPLE

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'shape.xlsx' );
    my $worksheet = $workbook->add_worksheet();

    # Add a default rectangle shape.
    my $rect = $workbook->add_shape();

    # Add an ellipse with centered text.
    my $ellipse = $workbook->add_shape(
        type => 'ellipse',
        text => "Hello\nWorld"
    );

    # Add a plus shape.
    my $plus = $workbook->add_shape( type => 'plus');

    # Insert the shapes in the worksheet.
    $worksheet->insert_shape( 'B3', $rect );
    $worksheet->insert_shape( 'C3', $ellipse );
    $worksheet->insert_shape( 'D3', $plus );


See also the C<shapes_*.pl> program in the C<examples> directory of the distro.

=head1 TODO

=over 4

=item * Add shapes which have custom geometries.

=item * Provide better integration of workbook formats for shapes.

=item * Add further validation of shape properties to prevent creation of workbooks that will not open.

=item * Auto connect shapes that are not anchored to cell A1.

=item * Add automatic shape connection to shape vertices besides the object centre.

=item * Improve automatic shape connection to shapes with concave sides (e.g. chevron).

=back

=head1 AUTHOR

Dave Clarke dclarke@cpan.org

=head1 COPYRIGHT

(c) MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.
