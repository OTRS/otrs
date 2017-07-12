package Excel::Writer::XLSX::Chart::Column;

###############################################################################
#
# Column - A class for writing Excel Column charts.
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

    $self->{_subtype} = $self->{_subtype} || 'clustered';
    $self->{_horiz_val_axis} = 0;

    # Override and reset the default axis values.
    if ( $self->{_subtype} eq 'percent_stacked' ) {
        $self->{_y_axis}->{_defaults}->{num_format} = '0%';
    }

    $self->set_y_axis();

    # Set the available data label positions for this chart type.
    $self->{_label_position_default} = 'outside_end';
    $self->{_label_positions} = {
        center      => 'ctr',
        inside_base => 'inBase',
        inside_end  => 'inEnd',
        outside_end => 'outEnd',
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

    # Write the c:barChart element.
    $self->_write_bar_chart( @_ );
}


##############################################################################
#
# _write_bar_chart()
#
# Write the <c:barChart> element.
#
sub _write_bar_chart {

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

    my $subtype = $self->{_subtype};
    $subtype = 'percentStacked' if $subtype eq 'percent_stacked';

    # Set a default overlap for stacked charts.
    if ($self->{_subtype} =~ /stacked/) {
        if (!defined $self->{_series_overlap_1}) {
            $self->{_series_overlap_1} = 100;
        }
    }

    $self->xml_start_tag( 'c:barChart' );

    # Write the c:barDir element.
    $self->_write_bar_dir();

    # Write the c:grouping element.
    $self->_write_grouping( $subtype );

    # Write the c:ser elements.
    $self->_write_ser( $_ ) for @series;

    # Write the c:marker element.
    $self->_write_marker_value();

    if ( $args{primary_axes} ) {
        # Write the c:gapWidth element.
        $self->_write_gap_width( $self->{_series_gap_1} );

        # Write the c:overlap element.
        $self->_write_overlap( $self->{_series_overlap_1} );
    }
    else {
        # Write the c:gapWidth element.
        $self->_write_gap_width( $self->{_series_gap_2} );

        # Write the c:overlap element.
        $self->_write_overlap( $self->{_series_overlap_2} );
    }

    # Write the c:axId elements
    $self->_write_axis_ids( %args );

    $self->xml_end_tag( 'c:barChart' );
}


##############################################################################
#
# _write_bar_dir()
#
# Write the <c:barDir> element.
#
sub _write_bar_dir {

    my $self = shift;
    my $val  = 'col';

    my @attributes = ( 'val' => $val );

    $self->xml_empty_tag( 'c:barDir', @attributes );
}


##############################################################################
#
# _write_err_dir()
#
# Write the <c:errDir> element. Overridden from Chart class since it is not
# used in Bar charts.
#
sub _write_err_dir {}


1;


__END__


=head1 NAME

Column - A class for writing Excel Column charts.

=head1 SYNOPSIS

To create a simple Excel file with a Column chart using Excel::Writer::XLSX:

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart.xlsx' );
    my $worksheet = $workbook->add_worksheet();

    my $chart     = $workbook->add_chart( type => 'column' );

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

This module implements Column charts for L<Excel::Writer::XLSX>. The chart object is created via the Workbook C<add_chart()> method:

    my $chart = $workbook->add_chart( type => 'column' );

Once the object is created it can be configured via the following methods that are common to all chart classes:

    $chart->add_series();
    $chart->set_x_axis();
    $chart->set_y_axis();
    $chart->set_title();

These methods are explained in detail in L<Excel::Writer::XLSX::Chart>. Class specific methods or settings, if any, are explained below.

=head1 Column Chart Subtypes

The C<Column> chart module also supports the following sub-types:

    stacked
    percent_stacked

These can be specified at creation time via the C<add_chart()> Worksheet method:

    my $chart = $workbook->add_chart( type => 'column', subtype => 'stacked' );

=head1 EXAMPLE

Here is a complete example that demonstrates most of the available features when creating a chart.

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart_column.xlsx' );
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

<p><center><img src="http://jmcnamara.github.io/excel-writer-xlsx/images/examples/column1.jpg" width="483" height="291" alt="Chart example." /></center></p>

=end html


=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

Copyright MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

