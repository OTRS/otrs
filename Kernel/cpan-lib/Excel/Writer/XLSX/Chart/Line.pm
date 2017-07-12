package Excel::Writer::XLSX::Chart::Line;

###############################################################################
#
# Line - A class for writing Excel Line charts.
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

    $self->{_default_marker} = { type => 'none' };
    $self->{_smooth_allowed} = 1;

    # Set the available data label positions for this chart type.
    $self->{_label_position_default} = 'right';
    $self->{_label_positions} = {
        center      => 'ctr',
        right       => 'r',
        left        => 'l',
        above       => 't',
        below       => 'b',
        # For backward compatibility.
        top         => 't',
        bottom      => 'b',
    };

    bless $self, $class;
    return $self;
}


##############################################################################
#
# _write_chart_type()
#
# Override the virtual superclass method with a chart specific method.
#
sub _write_chart_type {

    my $self = shift;

    # Write the c:lineChart element.
    $self->_write_line_chart( @_ );
}


##############################################################################
#
# _write_line_chart()
#
# Write the <c:lineChart> element.
#
sub _write_line_chart {

    my $self = shift;
    my %args = @_;

    my @series;
    if ( $args{primary_axes} ) {
        @series = $self->_get_primary_axes_series;
    }
    else {
        @series = $self->_get_secondary_axes_series;
    }

    return unless scalar @series;

    $self->xml_start_tag( 'c:lineChart' );

    # Write the c:grouping element.
    $self->_write_grouping( 'standard' );

    # Write the series elements.
    $self->_write_series( $_ ) for @series;

    # Write the c:dropLines element.
    $self->_write_drop_lines();

    # Write the c:hiLowLines element.
    $self->_write_hi_low_lines();

    # Write the c:upDownBars element.
    $self->_write_up_down_bars();

    # Write the c:marker element.
    $self->_write_marker_value();

    # Write the c:axId elements
    $self->_write_axis_ids( %args );

    $self->xml_end_tag( 'c:lineChart' );
}


##############################################################################
#
# _write_d_pt_point()
#
# Write an individual <c:dPt> element. Override the parent method to add
# markers.
#
sub _write_d_pt_point {

    my $self   = shift;
    my $index = shift;
    my $point = shift;

        $self->xml_start_tag( 'c:dPt' );

        # Write the c:idx element.
        $self->_write_idx( $index );

        $self->xml_start_tag( 'c:marker' );

        # Write the c:spPr element.
        $self->_write_sp_pr( $point );

        $self->xml_end_tag( 'c:marker' );

        $self->xml_end_tag( 'c:dPt' );
}


1;


__END__


=head1 NAME

Line - A class for writing Excel Line charts.

=head1 SYNOPSIS

To create a simple Excel file with a Line chart using Excel::Writer::XLSX:

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart.xlsx' );
    my $worksheet = $workbook->add_worksheet();

    my $chart     = $workbook->add_chart( type => 'line' );

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

This module implements Line charts for L<Excel::Writer::XLSX>. The chart object is created via the Workbook C<add_chart()> method:

    my $chart = $workbook->add_chart( type => 'line' );

Once the object is created it can be configured via the following methods that are common to all chart classes:

    $chart->add_series();
    $chart->set_x_axis();
    $chart->set_y_axis();
    $chart->set_title();

These methods are explained in detail in L<Excel::Writer::XLSX::Chart>. Class specific methods or settings, if any, are explained below.

=head1 Line Chart Methods

There aren't currently any line chart specific methods. See the TODO section of L<Excel::Writer::XLSX::Chart>.

=head1 EXAMPLE

Here is a complete example that demonstrates most of the available features when creating a chart.

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart_line.xlsx' );
    my $worksheet = $workbook->add_worksheet();
    my $bold      = $workbook->add_format( bold => 1 );

    # Add the worksheet data that the charts will refer to.
    my $headings = [ 'Number', 'Batch 1', 'Batch 2' ];
    my $data = [
        [ 2, 3, 4, 5, 6, 7 ],
        [ 10, 40, 50, 20, 10, 50 ],
        [ 30, 60, 70, 50, 40, 30 ],

    ];

    $worksheet->write( 'A1', $headings, $bold );
    $worksheet->write( 'A2', $data );

    # Create a new chart object. In this case an embedded chart.
    my $chart = $workbook->add_chart( type => 'line', embedded => 1 );

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

    # Set an Excel chart style. Colors with white outline and shadow.
    $chart->set_style( 10 );

    # Insert the chart into the worksheet (with an offset).
    $worksheet->insert_chart( 'D2', $chart, 25, 10 );

    __END__


=begin html

<p>This will produce a chart that looks like this:</p>

<p><center><img src="http://jmcnamara.github.io/excel-writer-xlsx/images/examples/line1.jpg" width="483" height="291" alt="Chart example." /></center></p>

=end html


=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

Copyright MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

