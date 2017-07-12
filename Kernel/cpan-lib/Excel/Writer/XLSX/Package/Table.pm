package Excel::Writer::XLSX::Package::Table;

###############################################################################
#
# Table - A class for writing the Excel XLSX Table file.
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

    $self->{_properties} = {};

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

    # Write the table element.
    $self->_write_table();

    # Write the autoFilter element.
    $self->_write_auto_filter();

    # Write the tableColumns element.
    $self->_write_table_columns();

    # Write the tableStyleInfo element.
    $self->_write_table_style_info();


    # Close the table tag.
    $self->xml_end_tag( 'table' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# _set_properties()
#
# Set the document properties.
#
sub _set_properties {

    my $self       = shift;
    my $properties = shift;

    $self->{_properties} = $properties;
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
# _write_table()
#
# Write the <table> element.
#
sub _write_table {

    my $self             = shift;
    my $schema           = 'http://schemas.openxmlformats.org/';
    my $xmlns            = $schema . 'spreadsheetml/2006/main';
    my $id               = $self->{_properties}->{_id};
    my $name             = $self->{_properties}->{_name};
    my $display_name     = $self->{_properties}->{_name};
    my $ref              = $self->{_properties}->{_range};
    my $totals_row_shown = $self->{_properties}->{_totals_row_shown};
    my $header_row_count = $self->{_properties}->{_header_row_count};

    my @attributes = (
        'xmlns'       => $xmlns,
        'id'          => $id,
        'name'        => $name,
        'displayName' => $display_name,
        'ref'         => $ref,
    );

    push @attributes, ( 'headerRowCount' => 0 ) if !$header_row_count;

    if ( $totals_row_shown ) {
        push @attributes, ( 'totalsRowCount' => 1 );
    }
    else {
        push @attributes, ( 'totalsRowShown' => 0 );
    }


    $self->xml_start_tag( 'table', @attributes );
}


##############################################################################
#
# _write_auto_filter()
#
# Write the <autoFilter> element.
#
sub _write_auto_filter {

    my $self       = shift;
    my $autofilter = $self->{_properties}->{_autofilter};

    return unless $autofilter;

    my @attributes = ( 'ref' => $autofilter, );

    $self->xml_empty_tag( 'autoFilter', @attributes );
}


##############################################################################
#
# _write_table_columns()
#
# Write the <tableColumns> element.
#
sub _write_table_columns {

    my $self    = shift;
    my @columns = @{ $self->{_properties}->{_columns} };

    my $count = scalar @columns;

    my @attributes = ( 'count' => $count, );

    $self->xml_start_tag( 'tableColumns', @attributes );

    for my $col_data ( @columns ) {

        # Write the tableColumn element.
        $self->_write_table_column( $col_data );
    }

    $self->xml_end_tag( 'tableColumns' );
}


##############################################################################
#
# _write_table_column()
#
# Write the <tableColumn> element.
#
sub _write_table_column {

    my $self     = shift;
    my $col_data = shift;

    my @attributes = (
        'id'   => $col_data->{_id},
        'name' => $col_data->{_name},
    );


    if ( $col_data->{_total_string} ) {
        push @attributes, ( totalsRowLabel => $col_data->{_total_string} );
    }
    elsif ( $col_data->{_total_function} ) {
        push @attributes, ( totalsRowFunction => $col_data->{_total_function} );
    }


    if ( defined $col_data->{_format} ) {
        push @attributes, ( dataDxfId => $col_data->{_format} );
    }

    if ( $col_data->{_formula} ) {
        $self->xml_start_tag( 'tableColumn', @attributes );

        # Write the calculatedColumnFormula element.
        $self->_write_calculated_column_formula( $col_data->{_formula} );

        $self->xml_end_tag( 'tableColumn' );
    }
    else {
        $self->xml_empty_tag( 'tableColumn', @attributes );
    }

}


##############################################################################
#
# _write_table_style_info()
#
# Write the <tableStyleInfo> element.
#
sub _write_table_style_info {

    my $self  = shift;
    my $props = $self->{_properties};

    my $name                = $props->{_style};
    my $show_first_column   = $props->{_show_first_col};
    my $show_last_column    = $props->{_show_last_col};
    my $show_row_stripes    = $props->{_show_row_stripes};
    my $show_column_stripes = $props->{_show_col_stripes};

    my @attributes = (
        'name'              => $name,
        'showFirstColumn'   => $show_first_column,
        'showLastColumn'    => $show_last_column,
        'showRowStripes'    => $show_row_stripes,
        'showColumnStripes' => $show_column_stripes,
    );

    $self->xml_empty_tag( 'tableStyleInfo', @attributes );
}


##############################################################################
#
# _write_calculated_column_formula()
#
# Write the <calculatedColumnFormula> element.
#
sub _write_calculated_column_formula {

    my $self    = shift;
    my $formula = shift;

    $self->xml_data_element( 'calculatedColumnFormula', $formula );
}


1;


__END__

=pod

=head1 NAME

Table - A class for writing the Excel XLSX Table file.

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
