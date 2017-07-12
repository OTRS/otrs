package Excel::Writer::XLSX::Chart::Doughnut;

###############################################################################
#
# Doughnut - A class for writing Excel Doughnut charts.
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
use Excel::Writer::XLSX::Chart::Pie;

our @ISA     = qw(Excel::Writer::XLSX::Chart::Pie);
our $VERSION = '0.95';


###############################################################################
#
# new()
#
#
sub new {

    my $class = shift;
    my $self  = Excel::Writer::XLSX::Chart::Pie->new( @_ );

    $self->{_vary_data_color} = 1;
    $self->{_hole_size}       = 50;
    $self->{_rotation}        = 0;

    bless $self, $class;
    return $self;
}


###############################################################################
#
# set_hole_size()
#
# Set the Doughnut chart hole size.
#
sub set_hole_size {

    my $self = shift;
    my $size = shift;

    return if !defined $size;

    if ( $size >= 10 && $size <= 90 ) {
        $self->{_hole_size} = $size;
    }
    else {
        carp "Hole size $size outside Excel range: 10 <= size <= 90";
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

    # Write the c:doughnutChart element.
    $self->_write_doughnut_chart( @_ );
}


##############################################################################
#
# _write_doughnut_chart()
#
# Write the <c:doughnutChart> element. Over-ridden method to remove axis_id code
# since Doughnut charts don't require val and cat axes.
#
sub _write_doughnut_chart {

    my $self = shift;

    $self->xml_start_tag( 'c:doughnutChart' );

    # Write the c:varyColors element.
    $self->_write_vary_colors();

    # Write the series elements.
    $self->_write_ser( $_ ) for @{ $self->{_series} };

    # Write the c:firstSliceAng element.
    $self->_write_first_slice_ang();

    # Write the c:holeSize element.
    $self->_write_hole_size();

    $self->xml_end_tag( 'c:doughnutChart' );
}


##############################################################################
#
# _write_hole_size()
#
# Write the <c:holeSize> element.
#
sub _write_hole_size {

    my $self = shift;
    my $val  = $self->{_hole_size};

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:holeSize', @attributes );
}

1;


__END__


=head1 NAME

Doughnut - A class for writing Excel Doughnut charts.

=head1 SYNOPSIS

To create a simple Excel file with a Doughnut chart using Excel::Writer::XLSX:

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart.xlsx' );
    my $worksheet = $workbook->add_worksheet();

    my $chart     = $workbook->add_chart( type => 'doughnut' );

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

This module implements Doughnut charts for L<Excel::Writer::XLSX>. The chart object is created via the Workbook C<add_chart()> method:

    my $chart = $workbook->add_chart( type => 'doughnut' );

Once the object is created it can be configured via the following methods that are common to all chart classes:

    $chart->add_series();
    $chart->set_title();

These methods are explained in detail in L<Excel::Writer::XLSX::Chart>. Class specific methods or settings, if any, are explained below.

=head1 Doughnut Chart Methods

=head2 set_rotation()

The C<set_rotation()> method is used to set the rotation of the first segment of a Pie/Doughnut chart. This has the effect of rotating the entire chart:

    $chart->set_rotation( 90 );

The angle of rotation must be C<< 0 <= rotation <= 360 >>.


=head2 set_hole_size()

The C<set_hole_size()> method is used to set the hole size of a Doughnut chart:

    $chart->set_hole_size( 33 );

The the hole size must be a percentage in the range  C<< 10 <= size <= 90 >>.


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

Doughnut charts support leader lines:

    $chart->add_series(
        name        => 'Doughnut sales data',
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

A Doughnut chart doesn't have an X or Y axis so the following common chart methods are ignored.

    $chart->set_x_axis();
    $chart->set_y_axis();

=head1 EXAMPLE

Here is a complete example that demonstrates most of the available features when creating a chart.

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart_doughnut.xlsx' );
    my $worksheet = $workbook->add_worksheet();
    my $bold      = $workbook->add_format( bold => 1 );

    # Add the worksheet data that the charts will refer to.
    my $headings = [ 'Category', 'Values' ];
    my $data = [
        [ 'Glazed', 'Chocolate', 'Cream' ],
        [ 50,       35,          15      ],
    ];

    $worksheet->write( 'A1', $headings, $bold );
    $worksheet->write( 'A2', $data );

    # Create a new chart object. In this case an embedded chart.
    my $chart = $workbook->add_chart( type => 'doughnut', embedded => 1 );

    # Configure the series. Note the use of the array ref to define ranges:
    # [ $sheetname, $row_start, $row_end, $col_start, $col_end ].
    $chart->add_series(
        name       => 'Doughnut sales data',
        categories => [ 'Sheet1', 1, 3, 0, 0 ],
        values     => [ 'Sheet1', 1, 3, 1, 1 ],
    );

    # Add a title.
    $chart->set_title( name => 'Popular Doughnut Types' );

    # Set an Excel chart style. Colors with white outline and shadow.
    $chart->set_style( 10 );

    # Insert the chart into the worksheet (with an offset).
    $worksheet->insert_chart( 'C2', $chart, 25, 10 );

    __END__


=begin html

<p>This will produce a chart that looks like this:</p>

<p><center><img src="http://jmcnamara.github.io/excel-writer-xlsx/images/examples/doughnut1.jpg" width="483" height="291" alt="Chart example." /></center></p>

=end html


=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

Copyright MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.
