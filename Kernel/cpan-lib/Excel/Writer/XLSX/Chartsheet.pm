package Excel::Writer::XLSX::Chartsheet;

###############################################################################
#
# Chartsheet - A class for writing the Excel XLSX Chartsheet files.
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
use Exporter;
use Excel::Writer::XLSX::Worksheet;

our @ISA     = qw(Excel::Writer::XLSX::Worksheet);
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
    my $self  = Excel::Writer::XLSX::Worksheet->new( @_ );

    $self->{_drawing}           = 1;
    $self->{_is_chartsheet}     = 1;
    $self->{_chart}             = undef;
    $self->{_charts}            = [1];
    $self->{_zoom_scale_normal} = 0;
    $self->{_orientation}       = 0;

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

    # Write the root chartsheet element.
    $self->_write_chartsheet();

    # Write the worksheet properties.
    $self->_write_sheet_pr();

    # Write the sheet view properties.
    $self->_write_sheet_views();

    # Write the sheetProtection element.
    $self->_write_sheet_protection();

    # Write the printOptions element.
    $self->_write_print_options();

    # Write the worksheet page_margins.
    $self->_write_page_margins();

    # Write the worksheet page setup.
    $self->_write_page_setup();

    # Write the headerFooter element.
    $self->_write_header_footer();

    # Write the drawing element.
    $self->_write_drawings();

    # Close the worksheet tag.
    $self->xml_end_tag( 'chartsheet' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# Public methods.
#
###############################################################################

# Over-ride parent protect() method to protect both worksheet and chart.
sub protect {

    my $self     = shift;
    my $password = shift || '';
    my $options  = shift || {};

    $self->{_chart}->{_protection} = 1;

    $options->{sheet}     = 0;
    $options->{content}   = 1;
    $options->{scenarios} = 1;

    $self->SUPER::protect( $password, $options );
}


###############################################################################
#
# Encapsulated Chart methods.
#
###############################################################################

sub add_series         { return shift->{_chart}->add_series( @_ ) }
sub combine            { return shift->{_chart}->combine( @_ ) }
sub set_x_axis         { return shift->{_chart}->set_x_axis( @_ ) }
sub set_y_axis         { return shift->{_chart}->set_y_axis( @_ ) }
sub set_x2_axis        { return shift->{_chart}->set_x2_axis( @_ ) }
sub set_y2_axis        { return shift->{_chart}->set_y2_axis( @_ ) }
sub set_title          { return shift->{_chart}->set_title( @_ ) }
sub set_legend         { return shift->{_chart}->set_legend( @_ ) }
sub set_plotarea       { return shift->{_chart}->set_plotarea( @_ ) }
sub set_chartarea      { return shift->{_chart}->set_chartarea( @_ ) }
sub set_style          { return shift->{_chart}->set_style( @_ ) }
sub show_blanks_as     { return shift->{_chart}->show_blanks_as( @_ ) }
sub show_hidden_data   { return shift->{_chart}->show_hidden_data( @_ ) }
sub set_size           { return shift->{_chart}->set_size( @_ ) }
sub set_table          { return shift->{_chart}->set_table( @_ ) }
sub set_up_down_bars   { return shift->{_chart}->set_up_down_bars( @_ ) }
sub set_drop_lines     { return shift->{_chart}->set_drop_lines( @_ ) }
sub set_high_low_lines { return shift->{_chart}->high_low_lines( @_ ) }



###############################################################################
#
# Internal methods.
#
###############################################################################


###############################################################################
#
# _prepare_chart()
#
# Set up chart/drawings.
#
sub _prepare_chart {

    my $self       = shift;
    my $index      = shift;
    my $chart_id   = shift;
    my $drawing_id = shift;

    $self->{_chart}->{_id} = $chart_id -1;

    my $drawing = Excel::Writer::XLSX::Drawing->new();
    $self->{_drawing} = $drawing;
    $self->{_drawing}->{_orientation} = $self->{_orientation};

    push @{ $self->{_external_drawing_links} },
      [ '/drawing', '../drawings/drawing' . $drawing_id . '.xml' ];

    push @{ $self->{_drawing_links} },
      [ '/chart', '../charts/chart' . $chart_id . '.xml' ];
}


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_chartsheet()
#
# Write the <chartsheet> element. This is the root element of Chartsheet.
#
sub _write_chartsheet {

    my $self                   = shift;
    my $schema                 = 'http://schemas.openxmlformats.org/';
    my $xmlns                  = $schema . 'spreadsheetml/2006/main';
    my $xmlns_r                = $schema . 'officeDocument/2006/relationships';
    my $xmlns_mc               = $schema . 'markup-compatibility/2006';
    my $xmlns_mv               = 'urn:schemas-microsoft-com:mac:vml';
    my $mc_ignorable           = 'mv';
    my $mc_preserve_attributes = 'mv:*';

    my @attributes = (
        'xmlns'   => $xmlns,
        'xmlns:r' => $xmlns_r,
    );

    $self->xml_start_tag( 'chartsheet', @attributes );
}


###############################################################################
#
# _write_sheet_pr()
#
# Write the <sheetPr> element for Sheet level properties.
#
sub _write_sheet_pr {

    my $self       = shift;
    my @attributes = ();


    push @attributes, ( 'filterMode' => 1 ) if $self->{_filter_on};

    if ( $self->{_fit_page} || $self->{_tab_color} ) {
        $self->xml_start_tag( 'sheetPr', @attributes );
        $self->_write_tab_color();
        $self->_write_page_set_up_pr();
        $self->xml_end_tag( 'sheetPr' );
    }
    else {
        $self->xml_empty_tag( 'sheetPr', @attributes );
    }
}

1;


__END__

=pod

=head1 NAME

Chartsheet - A class for writing the Excel XLSX Chartsheet files.

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
