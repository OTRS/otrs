package Excel::Writer::XLSX::Chart::Pie;

###############################################################################
#
# Pie - A class for writing Excel Pie charts.
#
# Used in conjunction with Excel::Writer::XLSX::Chart.
#
# See formatting note in Excel::Writer::XLSX::Chart.
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
use Excel::Writer::XLSX::Chart;

our @ISA     = qw(Excel::Writer::XLSX::Chart);
our $VERSION = '0.95';


###############################################################################
#
# new()
#
#
sub new {

    my $class = shift;
    my $self  = Excel::Writer::XLSX::Chart->new( @_ );

    $self->{_vary_data_color} = 1;
    $self->{_rotation}        = 0;

    # Set the available data label positions for this chart type.
    $self->{_label_position_default} = 'best_fit';
    $self->{_label_positions} = {
        center      => 'ctr',
        inside_end  => 'inEnd',
        outside_end => 'outEnd',
        best_fit    => 'bestFit',
    };

    bless $self, $class;
    return $self;
}


###############################################################################
#
# set_rotation()
#
# Set the Pie/Doughnut chart rotation: the angle of the first slice.
#
sub set_rotation {

    my $self     = shift;
    my $rotation = shift;

    return if !defined $rotation;

    if ( $rotation >= 0 && $rotation <= 360 ) {
        $self->{_rotation} = $rotation;
    }
    else {
        carp "Chart rotation $rotation outside range: 0 <= rotation <= 360";
    }
}


##############################################################################
#
# _write_chart_type()
#
# Override the virtual superclass method with a chart specific method.
#
sub _write_chart_type {

    my $self = shift;

    # Write the c:pieChart element.
    $self->_write_pie_chart( @_ );
}


##############################################################################
#
# _write_pie_chart()
#
# Write the <c:pieChart> element.  Over-ridden method to remove axis_id code
# since Pie charts don't require val and cat axes.
#
sub _write_pie_chart {

    my $self = shift;

    $self->xml_start_tag( 'c:pieChart' );

    # Write the c:varyColors element.
    $self->_write_vary_colors();

    # Write the series elements.
    $self->_write_ser( $_ ) for @{ $self->{_series} };

    # Write the c:firstSliceAng element.
    $self->_write_first_slice_ang();

    $self->xml_end_tag( 'c:pieChart' );
}


###############################################################################
#
# combine()
#
# Override parent method to add a warning.
#
sub combine {

    my $self  = shift;
    my $chart = shift;

    carp "Combined chart not currently supported for Pie charts";
    return;
}


##############################################################################
#
# _write_plot_area().
#
# Over-ridden method to remove the cat_axis() and val_axis() code since
# Pie/Doughnut charts don't require those axes.
#
# Write the <c:plotArea> element.
#
sub _write_plot_area {

    my $self = shift;

    $self->xml_start_tag( 'c:plotArea' );

    # Write the c:layout element.
    $self->_write_layout( $self->{_plotarea}->{_layout}, 'plot' );

    # Write the subclass chart type element.
    $self->_write_chart_type();

    $self->xml_end_tag( 'c:plotArea' );
}


##############################################################################
#
# _write_legend().
#
# Over-ridden method to add <c:txPr> to legend.
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

    # Write the c:overlay element.
    $self->_write_overlay() if $overlay;

    # Write the c:txPr element. Over-ridden.
    $self->_write_tx_pr_legend( 0, $font );

    $self->xml_end_tag( 'c:legend' );
}


##############################################################################
#
# _write_tx_pr_legend()
#
# Write the <c:txPr> element for legends.
#
sub _write_tx_pr_legend {

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
    $self->_write_a_p_legend( $font );

    $self->xml_end_tag( 'c:txPr' );
}


##############################################################################
#
# _write_a_p_legend()
#
# Write the <a:p> element for legends.
#
sub _write_a_p_legend {

    my $self = shift;
    my $font = shift;

    $self->xml_start_tag( 'a:p' );

    # Write the a:pPr element.
    $self->_write_a_p_pr_legend( $font );

    # Write the a:endParaRPr element.
    $self->_write_a_end_para_rpr();

    $self->xml_end_tag( 'a:p' );
}


##############################################################################
#
# _write_a_p_pr_legend()
#
# Write the <a:pPr> element for legends.
#
sub _write_a_p_pr_legend {

    my $self = shift;
    my $font = shift;
    my $rtl  = 0;

    my @attributes = ( 'rtl' => $rtl );

    $self->xml_start_tag( 'a:pPr', @attributes );

    # Write the a:defRPr element.
    $self->_write_a_def_rpr( $font );

    $self->xml_end_tag( 'a:pPr' );
}


##############################################################################
#
# _write_vary_colors()
#
# Write the <c:varyColors> element.
#
sub _write_vary_colors {

    my $self = shift;
    my $val  = 1;

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:varyColors', @attributes );
}


##############################################################################
#
# _write_first_slice_ang()
#
# Write the <c:firstSliceAng> element.
#
sub _write_first_slice_ang {

    my $self = shift;
    my $val  = $self->{_rotation};

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:firstSliceAng', @attributes );
}

1;


__END__


=head1 NAME

Pie - A class for writing Excel Pie charts.

=head1 SYNOPSIS

To create a simple Excel file with a Pie chart using Excel::Writer::XLSX:

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart.xlsx' );
    my $worksheet = $workbook->add_worksheet();

    my $chart     = $workbook->add_chart( type => 'pie' );

    # Configure the chart.
    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$7',
        values     => '=Sheet1!$B$2:$B$7',
    );

    # Add the worksheet data the chart refers to.
    my $data = [
        [ 'Category', 2, 3, 4, 5, 6, 7 ],
        [ 'Value',    1, 4, 5, 2, 1, 5 ],
    ];

    $worksheet->write( 'A1', $data );

    __END__

=head1 DESCRIPTION

This module implements Pie charts for L<Excel::Writer::XLSX>. The chart object is created via the Workbook C<add_chart()> method:

    my $chart = $workbook->add_chart( type => 'pie' );

Once the object is created it can be configured via the following methods that are common to all chart classes:

    $chart->add_series();
    $chart->set_title();

These methods are explained in detail in L<Excel::Writer::XLSX::Chart>. Class specific methods or settings, if any, are explained below.

=head1 Pie Chart Methods

=head2 set_rotation()

The C<set_rotation()> method is used to set the rotation of the first segment of a Pie/Doughnut chart. This has the effect of rotating the entire chart:

    $chart->set_rotation( 90 );

The angle of rotation must be C<< 0 <= rotation <= 360 >>.


=head2 User defined colors

It is possible to define chart colors for most types of Excel::Writer::XLSX charts via the add_series() method. However, Pie/Doughnut charts are a special case since each segment is represented as a point so it is necessary to assign formatting to each point in the series:

    $chart->add_series(
        values => '=Sheet1!$A$1:$A$3',
        points => [
            { fill => { color => '#FF0000' } },
            { fill => { color => '#CC0000' } },
            { fill => { color => '#990000' } },
        ],
    );

See the main L<Excel::Writer::XLSX::Chart> documentation for more details.

Pie charts support leader lines:

    $chart->add_series(
        name        => 'Pie sales data',
        categories  => [ 'Sheet1', 1, 3, 0, 0 ],
        values      => [ 'Sheet1', 1, 3, 1, 1 ],
        data_labels => {
            series_name  => 1,
            percentage   => 1,
            leader_lines => 1,
            position     => 'outside_end'
        },
    );

Note: Even when leader lines are turned on they aren't automatically visible in Excel or Excel::Writer::XLSX. Due to an Excel limitation (or design) leader lines only appear if the data label is moved manually or if the data labels are very close and need to be adjusted automatically.

=head2 Unsupported Methods

A Pie chart doesn't have an X or Y axis so the following common chart methods are ignored.

    $chart->set_x_axis();
    $chart->set_y_axis();

=head1 EXAMPLE

Here is a complete example that demonstrates most of the available features when creating a chart.

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart_pie.xlsx' );
    my $worksheet = $workbook->add_worksheet();
    my $bold      = $workbook->add_format( bold => 1 );

    # Add the worksheet data that the charts will refer to.
    my $headings = [ 'Category', 'Values' ];
    my $data = [
        [ 'Apple', 'Cherry', 'Pecan' ],
        [ 60,       30,       10     ],
    ];

    $worksheet->write( 'A1', $headings, $bold );
    $worksheet->write( 'A2', $data );

    # Create a new chart object. In this case an embedded chart.
    my $chart = $workbook->add_chart( type => 'pie', embedded => 1 );

    # Configure the series. Note the use of the array ref to define ranges:
    # [ $sheetname, $row_start, $row_end, $col_start, $col_end ].
    $chart->add_series(
        name       => 'Pie sales data',
        categories => [ 'Sheet1', 1, 3, 0, 0 ],
        values     => [ 'Sheet1', 1, 3, 1, 1 ],
    );

    # Add a title.
    $chart->set_title( name => 'Popular Pie Types' );

    # Set an Excel chart style. Colors with white outline and shadow.
    $chart->set_style( 10 );

    # Insert the chart into the worksheet (with an offset).
    $worksheet->insert_chart( 'C2', $chart, 25, 10 );

    __END__


=begin html

<p>This will produce a chart that looks like this:</p>

<p><center><img src="http://jmcnamara.github.io/excel-writer-xlsx/images/examples/pie1.jpg" width="483" height="291" alt="Chart example." /></center></p>

=end html


=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

Copyright MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.
