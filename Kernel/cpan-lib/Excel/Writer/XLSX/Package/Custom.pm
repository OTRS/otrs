package Excel::Writer::XLSX::Package::Custom;

###############################################################################
#
# Custom - A class for writing the Excel XLSX custom.xml file for custom
# workbook properties.
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

    $self->{_properties} = [];
    $self->{_pid}        = 1;

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

    $self->_write_properties();

    $self->xml_end_tag( 'Properties' );

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


###############################################################################
#
# _write_properties()
#
# Write the <Properties> element.
#
sub _write_properties {

    my $self     = shift;
    my $schema   = 'http://schemas.openxmlformats.org/officeDocument/2006/';
    my $xmlns    = $schema . 'custom-properties';
    my $xmlns_vt = $schema . 'docPropsVTypes';

    my @attributes = (
        'xmlns'    => $xmlns,
        'xmlns:vt' => $xmlns_vt,
    );

    $self->xml_start_tag( 'Properties', @attributes );

    for my $property ( @{ $self->{_properties} } ) {

        # Write the property element.
        $self->_write_property( $property );
    }
}

##############################################################################
#
# _write_property()
#
# Write the <property> element.
#
sub _write_property {

    my $self     = shift;
    my $property = shift;
    my $fmtid    = '{D5CDD505-2E9C-101B-9397-08002B2CF9AE}';

    $self->{_pid}++;

    my ( $name, $value, $type ) = @$property;


    my @attributes = (
        'fmtid' => $fmtid,
        'pid'   => $self->{_pid},
        'name'  => $name,
    );

    $self->xml_start_tag( 'property', @attributes );

    if ( $type eq 'date' ) {

        # Write the vt:filetime element.
        $self->_write_vt_filetime( $value );
    }
    elsif ( $type eq 'number' ) {

        # Write the vt:r8 element.
        $self->_write_vt_r8( $value );
    }
    elsif ( $type eq 'number_int' ) {

        # Write the vt:i4 element.
        $self->_write_vt_i4( $value );
    }
    elsif ( $type eq 'bool' ) {

        # Write the vt:bool element.
        $self->_write_vt_bool( $value );
    }
    else {

        # Write the vt:lpwstr element.
        $self->_write_vt_lpwstr( $value );
    }


    $self->xml_end_tag( 'property' );
}


##############################################################################
#
# _write_vt_lpwstr()
#
# Write the <vt:lpwstr> element.
#
sub _write_vt_lpwstr {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'vt:lpwstr', $data );
}


##############################################################################
#
# _write_vt_i4()
#
# Write the <vt:i4> element.
#
sub _write_vt_i4 {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'vt:i4', $data );
}


##############################################################################
#
# _write_vt_r8()
#
# Write the <vt:r8> element.
#
sub _write_vt_r8 {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'vt:r8', $data );
}


##############################################################################
#
# _write_vt_bool()
#
# Write the <vt:bool> element.
#
sub _write_vt_bool {

    my $self = shift;
    my $data = shift;

    if ( $data ) {
        $data = 'true';
    }
    else {
        $data = 'false';
    }

    $self->xml_data_element( 'vt:bool', $data );
}

##############################################################################
#
# _write_vt_filetime()
#
# Write the <vt:filetime> element.
#
sub _write_vt_filetime {

    my $self = shift;
    my $data = shift;

    $self->xml_data_element( 'vt:filetime', $data );
}


1;


__END__

=pod

=head1 NAME

Custom - A class for writing the Excel XLSX custom.xml file.

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
