package Excel::Writer::XLSX::Chart::Stock;

###############################################################################
#
# Stock - A class for writing Excel Stock charts.
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
    $self->{_show_crosses}  = 0;
    $self->{_hi_low_lines}  = {};
    $self->{_date_category} = 1;

    # Override and reset the default axis values.
    $self->{_x_axis}->{_defaults}->{num_format}  = 'dd/mm/yyyy';
    $self->{_x2_axis}->{_defaults}->{num_format} = 'dd/mm/yyyy';
    $self->set_x_axis();
    $self->set_x2_axis();

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

    # Write the c:stockChart element.
    $self->_write_stock_chart( @_ );
}


##############################################################################
#
# _write_stock_chart()
#
# Write the <c:stockChart> element.
# Overridden to add hi_low_lines(). TODO. Refactor up into the SUPER class.
#
sub _write_stock_chart {

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

    # Add default formatting to the series data.
    $self->_modify_series_formatting();

    $self->xml_start_tag( 'c:stockChart' );

    # Write the series elements.
    $self->_write_ser( $_ ) for @series;

    # Write the c:dropLines element.
    $self->_write_drop_lines();

    # Write the c:hiLowLines element.
    $self->_write_hi_low_lines() if $args{primary_axes};

    # Write the c:upDownBars element.
    $self->_write_up_down_bars();

    # Write the c:marker element.
    $self->_write_marker_value();

    # Write the c:axId elements
    $self->_write_axis_ids( %args );

    $self->xml_end_tag( 'c:stockChart' );
}


##############################################################################
#
# _modify_series_formatting()
#
# Add default formatting to the series data.
#
sub _modify_series_formatting {

    my $self = shift;

    my $index = 0;
    for my $series ( @{ $self->{_series} } ) {
        if ( $index % 4 != 3 ) {
            if ( !$series->{_line}->{_defined} ) {
                $series->{_line} = {
                    width    => 2.25,
                    none     => 1,
                    _defined => 1,
                };
            }

            if ( !$series->{_marker} ) {
                if ( $index % 4 == 2 ) {
                    $series->{_marker} = { type => 'dot', size => 3 };
                }
                else {
                    $series->{_marker} = { type => 'none' };

                }
            }
        }
        $index++;
    }
}


1;


__END__


=head1 NAME

Stock - A class for writing Excel Stock charts.

=head1 SYNOPSIS

To create a simple Excel file with a Stock chart using Excel::Writer::XLSX:

    #!/usr/bin/perl -w

    use strict;
    use Excel::Writer::XLSX;

    my $workbook  = Excel::Writer::XLSX->new( 'chart.xlsx' );
    my $worksheet = $workbook->add_worksheet();

    my $chart = $workbook->add_chart( type => 'stock' );

    # Add a series for each High-Low-Close.
    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$6',
        values     => '=Sheet1!$B$2:$B$6'
    );

    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$6',
        values     => '=Sheet1!$C$2:$C$6'
    );

    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$6',
        values     => '=Sheet1!$D$2:$D$6'
    );

    # Add the worksheet data the chart refers to.
    # ... See the full example below.

    __END__


=head1 DESCRIPTION

This module implements Stock charts for L<Excel::Writer::XLSX>. The chart object is created via the Workbook C<add_chart()> method:

    my $chart = $workbook->add_chart( type => 'stock' );

Once the object is created it can be configured via the following methods that are common to all chart classes:

    $chart->add_series();
    $chart->set_x_axis();
    $chart->set_y_axis();
    $chart->set_title();

These methods are explained in detail in L<Excel::Writer::XLSX::Chart>. Class specific methods or settings, if any, are explained below.

=head1 Stock Chart Methods

There aren't currently any stock chart specific methods. See the TODO section of L<Excel::Writer::XLSX::Chart>.

The default Stock chart is a High-Low-Close chart. A series must be added for each of these data sources.


=head1 EXAMPLE

Here is a complete example that demonstrates most of the available features when creating a Stock chart.

    #!/usr/bin/perl

    use strict;
    use warnings;
    use Excel::Writer::XLSX;
    use Excel::Writer::XLSX;

    my $workbook    = Excel::Writer::XLSX->new( 'chart_stock.xlsx' );
    my $worksheet   = $workbook->add_worksheet();
    my $bold        = $workbook->add_format( bold => 1 );
    my $date_format = $workbook->add_format( num_format => 'dd/mm/yyyy' );
    my $chart       = $workbook->add_chart( type => 'stock', embedded => 1 );


    # Add the worksheet data that the charts will refer to.
    my $headings = [ 'Date', 'High', 'Low', 'Close' ];
    my $data = [

        [ '2007-01-01T', '2007-01-02T', '2007-01-03T', '2007-01-04T', '2007-01-05T' ],
        [ 27.2,  25.03, 19.05, 20.34, 18.5 ],
        [ 23.49, 19.55, 15.12, 17.84, 16.34 ],
        [ 25.45, 23.05, 17.32, 20.45, 17.34 ],

    ];

    $worksheet->write( 'A1', $headings, $bold );

    for my $row ( 0 .. 4 ) {
        $worksheet->write_date_time( $row+1, 0, $data->[0]->[$row], $date_format );
        $worksheet->write( $row+1, 1, $data->[1]->[$row] );
        $worksheet->write( $row+1, 2, $data->[2]->[$row] );
        $worksheet->write( $row+1, 3, $data->[3]->[$row] );

    }

    $worksheet->set_column( 'A:D', 11 );

    # Add a series for each of the High-Low-Close columns.
    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$6',
        values     => '=Sheet1!$B$2:$B$6',
    );

    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$6',
        values     => '=Sheet1!$C$2:$C$6',
    );

    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$6',
        values     => '=Sheet1!$D$2:$D$6',
    );

    # Add a chart title and some axis labels.
    $chart->set_title ( name => 'High-Low-Close', );
    $chart->set_x_axis( name => 'Date', );
    $chart->set_y_axis( name => 'Share price', );


    $worksheet->insert_chart( 'E9', $chart );

    __END__

=begin html

<p>This will produce a chart that looks like this:</p>

<p><center><img src="http://jmcnamara.github.io/excel-writer-xlsx/images/examples/stock1.jpg" width="483" height="291" alt="Chart example." /></center></p>

=end html


=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

Copyright MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

