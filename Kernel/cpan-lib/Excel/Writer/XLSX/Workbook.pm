package Excel::Writer::XLSX::Workbook;

###############################################################################
#
# Workbook - A class for writing Excel Workbooks.
#
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
use IO::File;
use File::Find;
use File::Temp qw(tempfile);
use File::Basename 'fileparse';
use Archive::Zip;
use Excel::Writer::XLSX::Worksheet;
use Excel::Writer::XLSX::Chartsheet;
use Excel::Writer::XLSX::Format;
use Excel::Writer::XLSX::Shape;
use Excel::Writer::XLSX::Chart;
use Excel::Writer::XLSX::Package::Packager;
use Excel::Writer::XLSX::Package::XMLwriter;
use Excel::Writer::XLSX::Utility qw(xl_cell_to_rowcol xl_rowcol_to_cell);

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
    my $self  = Excel::Writer::XLSX::Package::XMLwriter->new();

    $self->{_filename} = $_[0] || '';
    my $options = $_[1] || {};

    $self->{_tempdir}            = undef;
    $self->{_date_1904}          = 0;
    $self->{_activesheet}        = 0;
    $self->{_firstsheet}         = 0;
    $self->{_selected}           = 0;
    $self->{_fileclosed}         = 0;
    $self->{_filehandle}         = undef;
    $self->{_internal_fh}        = 0;
    $self->{_sheet_name}         = 'Sheet';
    $self->{_chart_name}         = 'Chart';
    $self->{_sheetname_count}    = 0;
    $self->{_chartname_count}    = 0;
    $self->{_worksheets}         = [];
    $self->{_charts}             = [];
    $self->{_drawings}           = [];
    $self->{_sheetnames}         = {};
    $self->{_formats}            = [];
    $self->{_xf_formats}         = [];
    $self->{_xf_format_indices}  = {};
    $self->{_dxf_formats}        = [];
    $self->{_dxf_format_indices} = {};
    $self->{_palette}            = [];
    $self->{_font_count}         = 0;
    $self->{_num_format_count}   = 0;
    $self->{_defined_names}      = [];
    $self->{_named_ranges}       = [];
    $self->{_custom_colors}      = [];
    $self->{_doc_properties}     = {};
    $self->{_custom_properties}  = [];
    $self->{_createtime}         = [ gmtime() ];
    $self->{_num_vml_files}      = 0;
    $self->{_num_comment_files}  = 0;
    $self->{_optimization}       = 0;
    $self->{_x_window}           = 240;
    $self->{_y_window}           = 15;
    $self->{_window_width}       = 16095;
    $self->{_window_height}      = 9660;
    $self->{_tab_ratio}          = 500;
    $self->{_excel2003_style}    = 0;

    $self->{_default_format_properties} = {};

    if ( exists $options->{tempdir} ) {
        $self->{_tempdir} = $options->{tempdir};
    }

    if ( exists $options->{date_1904} ) {
        $self->{_date_1904} = $options->{date_1904};
    }

    if ( exists $options->{optimization} ) {
        $self->{_optimization} = $options->{optimization};
    }

    if ( exists $options->{default_format_properties} ) {
        $self->{_default_format_properties} =
          $options->{default_format_properties};
    }

    if ( exists $options->{excel2003_style} ) {
        $self->{_excel2003_style} = 1;
    }

    # Structures for the shared strings data.
    $self->{_str_total}  = 0;
    $self->{_str_unique} = 0;
    $self->{_str_table}  = {};
    $self->{_str_array}  = [];

    # Formula calculation default settings.
    $self->{_calc_id}      = 124519;
    $self->{_calc_mode}    = 'auto';
    $self->{_calc_on_load} = 1;


    bless $self, $class;

    # Add the default cell format.
    if ( $self->{_excel2003_style} ) {
        $self->add_format( xf_index => 0, font_family => 0 );
    }
    else {
        $self->add_format( xf_index => 0 );
    }

    # Check for a filename unless it is an existing filehandle
    if ( not ref $self->{_filename} and $self->{_filename} eq '' ) {
        carp 'Filename required by Excel::Writer::XLSX->new()';
        return undef;
    }


    # If filename is a reference we assume that it is a valid filehandle.
    if ( ref $self->{_filename} ) {

        $self->{_filehandle}  = $self->{_filename};
        $self->{_internal_fh} = 0;
    }
    elsif ( $self->{_filename} eq '-' ) {

        # Support special filename/filehandle '-' for backward compatibility.
        binmode STDOUT;
        $self->{_filehandle}  = \*STDOUT;
        $self->{_internal_fh} = 0;
    }
    else {
        my $fh = IO::File->new( $self->{_filename}, 'w' );

        return undef unless defined $fh;

        $self->{_filehandle}  = $fh;
        $self->{_internal_fh} = 1;
    }


    # Set colour palette.
    $self->set_color_palette();

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

    # Prepare format object for passing to Style.pm.
    $self->_prepare_format_properties();

    $self->xml_declaration;

    # Write the root workbook element.
    $self->_write_workbook();

    # Write the XLSX file version.
    $self->_write_file_version();

    # Write the workbook properties.
    $self->_write_workbook_pr();

    # Write the workbook view properties.
    $self->_write_book_views();

    # Write the worksheet names and ids.
    $self->_write_sheets();

    # Write the workbook defined names.
    $self->_write_defined_names();

    # Write the workbook calculation properties.
    $self->_write_calc_pr();

    # Write the workbook extension storage.
    #$self->_write_ext_lst();

    # Close the workbook tag.
    $self->xml_end_tag( 'workbook' );

    # Close the XML writer filehandle.
    $self->xml_get_fh()->close();
}


###############################################################################
#
# close()
#
# Calls finalization methods.
#
sub close {

    my $self = shift;

    # In case close() is called twice, by user and by DESTROY.
    return if $self->{_fileclosed};

    # Test filehandle in case new() failed and the user didn't check.
    return undef if !defined $self->{_filehandle};

    $self->{_fileclosed} = 1;
    $self->_store_workbook();

    # Return the file close value.
    if ( $self->{_internal_fh} ) {
        return $self->{_filehandle}->close();
    }
    else {
        # Return true and let users deal with their own filehandles.
        return 1;
    }
}


###############################################################################
#
# DESTROY()
#
# Close the workbook if it hasn't already been explicitly closed.
#
sub DESTROY {

    my $self = shift;

    local ( $@, $!, $^E, $? );

    $self->close() if not $self->{_fileclosed};
}


###############################################################################
#
# sheets(slice,...)
#
# An accessor for the _worksheets[] array
#
# Returns: an optionally sliced list of the worksheet objects in a workbook.
#
sub sheets {

    my $self = shift;

    if ( @_ ) {

        # Return a slice of the array
        return @{ $self->{_worksheets} }[@_];
    }
    else {

        # Return the entire list
        return @{ $self->{_worksheets} };
    }
}


###############################################################################
#
# get_worksheet_by_name(name)
#
# Return a worksheet object in the workbook using the sheetname.
#
sub get_worksheet_by_name {

    my $self      = shift;
    my $sheetname = shift;

    return undef if not defined $sheetname;

    return $self->{_sheetnames}->{$sheetname};
}


###############################################################################
#
# worksheets()
#
# An accessor for the _worksheets[] array.
# This method is now deprecated. Use the sheets() method instead.
#
# Returns: an array reference
#
sub worksheets {

    my $self = shift;

    return $self->{_worksheets};
}


###############################################################################
#
# add_worksheet($name)
#
# Add a new worksheet to the Excel workbook.
#
# Returns: reference to a worksheet object
#
sub add_worksheet {

    my $self  = shift;
    my $index = @{ $self->{_worksheets} };
    my $name  = $self->_check_sheetname( $_[0] );
    my $fh    = undef;

    # Porters take note, the following scheme of passing references to Workbook
    # data (in the \$self->{_foo} cases) instead of a reference to the Workbook
    # itself is a workaround to avoid circular references between Workbook and
    # Worksheet objects. Feel free to implement this in any way the suits your
    # language.
    #
    my @init_data = (
        $fh,
        $name,
        $index,

        \$self->{_activesheet},
        \$self->{_firstsheet},

        \$self->{_str_total},
        \$self->{_str_unique},
        \$self->{_str_table},

        $self->{_date_1904},
        $self->{_palette},
        $self->{_optimization},
        $self->{_tempdir},
        $self->{_excel2003_style},

    );

    my $worksheet = Excel::Writer::XLSX::Worksheet->new( @init_data );
    $self->{_worksheets}->[$index] = $worksheet;
    $self->{_sheetnames}->{$name} = $worksheet;

    return $worksheet;
}


###############################################################################
#
# add_chart( %args )
#
# Create a chart for embedding or as a new sheet.
#
sub add_chart {

    my $self  = shift;
    my %arg   = @_;
    my $name  = '';
    my $index = @{ $self->{_worksheets} };
    my $fh    = undef;

    # Type must be specified so we can create the required chart instance.
    my $type = $arg{type};
    if ( !defined $type ) {
        croak "Must define chart type in add_chart()";
    }

    # Ensure that the chart defaults to non embedded.
    my $embedded = $arg{embedded} || 0;

    # Check the worksheet name for non-embedded charts.
    if ( !$embedded ) {
        $name = $self->_check_sheetname( $arg{name}, 1 );
    }


    my @init_data = (

        $fh,
        $name,
        $index,

        \$self->{_activesheet},
        \$self->{_firstsheet},

        \$self->{_str_total},
        \$self->{_str_unique},
        \$self->{_str_table},

        $self->{_date_1904},
        $self->{_palette},
        $self->{_optimization},
    );


    my $chart = Excel::Writer::XLSX::Chart->factory( $type, $arg{subtype} );

    # If the chart isn't embedded let the workbook control it.
    if ( !$embedded ) {

        my $drawing    = Excel::Writer::XLSX::Drawing->new();
        my $chartsheet = Excel::Writer::XLSX::Chartsheet->new( @init_data );

        $chart->{_palette} = $self->{_palette};

        $chartsheet->{_chart}   = $chart;
        $chartsheet->{_drawing} = $drawing;

        $self->{_worksheets}->[$index] = $chartsheet;
        $self->{_sheetnames}->{$name} = $chartsheet;

        push @{ $self->{_charts} }, $chart;

        return $chartsheet;
    }
    else {

        # Set the embedded chart name if present.
        $chart->{_chart_name} = $arg{name} if $arg{name};

        # Set index to 0 so that the activate() and set_first_sheet() methods
        # point back to the first worksheet if used for embedded charts.
        $chart->{_index}   = 0;
        $chart->{_palette} = $self->{_palette};
        $chart->_set_embedded_config_data();
        push @{ $self->{_charts} }, $chart;

        return $chart;
    }

}


###############################################################################
#
# _check_sheetname( $name )
#
# Check for valid worksheet names. We check the length, if it contains any
# invalid characters and if the name is unique in the workbook.
#
sub _check_sheetname {

    my $self         = shift;
    my $name         = shift || "";
    my $chart        = shift || 0;
    my $invalid_char = qr([\[\]:*?/\\]);

    # Increment the Sheet/Chart number used for default sheet names below.
    if ( $chart ) {
        $self->{_chartname_count}++;
    }
    else {
        $self->{_sheetname_count}++;
    }

    # Supply default Sheet/Chart name if none has been defined.
    if ( $name eq "" ) {

        if ( $chart ) {
            $name = $self->{_chart_name} . $self->{_chartname_count};
        }
        else {
            $name = $self->{_sheet_name} . $self->{_sheetname_count};
        }
    }

    # Check that sheet name is <= 31. Excel limit.
    croak "Sheetname $name must be <= 31 chars" if length $name > 31;

    # Check that sheetname doesn't contain any invalid characters
    if ( $name =~ $invalid_char ) {
        croak 'Invalid character []:*?/\\ in worksheet name: ' . $name;
    }

    # Check that the worksheet name doesn't already exist since this is a fatal
    # error in Excel 97. The check must also exclude case insensitive matches.
    foreach my $worksheet ( @{ $self->{_worksheets} } ) {
        my $name_a = $name;
        my $name_b = $worksheet->{_name};

        if ( lc( $name_a ) eq lc( $name_b ) ) {
            croak "Worksheet name '$name', with case ignored, is already used.";
        }
    }

    return $name;
}


###############################################################################
#
# add_format(%properties)
#
# Add a new format to the Excel workbook.
#
sub add_format {

    my $self = shift;

    my @init_data =
      ( \$self->{_xf_format_indices}, \$self->{_dxf_format_indices} );

    # Change default format style for Excel2003/XLS format.
    if ( $self->{_excel2003_style} ) {
        push @init_data, ( font => 'Arial', size => 10, theme => -1 );
    }

    # Add the default format properties.
    push @init_data, %{ $self->{_default_format_properties} };

    # Add the user defined properties.
    push @init_data, @_;

    my $format = Excel::Writer::XLSX::Format->new( @init_data );

    push @{ $self->{_formats} }, $format;    # Store format reference

    return $format;
}


###############################################################################
#
# add_shape(%properties)
#
# Add a new shape to the Excel workbook.
#
sub add_shape {

    my $self  = shift;
    my $fh    = undef;
    my $shape = Excel::Writer::XLSX::Shape->new( $fh, @_ );

    $shape->{_palette} = $self->{_palette};


    push @{ $self->{_shapes} }, $shape;    # Store shape reference.

    return $shape;
}

###############################################################################
#
# set_1904()
#
# Set the date system: 0 = 1900 (the default), 1 = 1904
#
sub set_1904 {

    my $self = shift;

    if ( defined( $_[0] ) ) {
        $self->{_date_1904} = $_[0];
    }
    else {
        $self->{_date_1904} = 1;
    }
}


###############################################################################
#
# get_1904()
#
# Return the date system: 0 = 1900, 1 = 1904
#
sub get_1904 {

    my $self = shift;

    return $self->{_date_1904};
}


###############################################################################
#
# set_custom_color()
#
# Change the RGB components of the elements in the colour palette.
#
sub set_custom_color {

    my $self = shift;


    # Match a HTML #xxyyzz style parameter
    if ( defined $_[1] and $_[1] =~ /^#(\w\w)(\w\w)(\w\w)/ ) {
        @_ = ( $_[0], hex $1, hex $2, hex $3 );
    }


    my $index = $_[0] || 0;
    my $red   = $_[1] || 0;
    my $green = $_[2] || 0;
    my $blue  = $_[3] || 0;

    my $aref = $self->{_palette};

    # Check that the colour index is the right range
    if ( $index < 8 or $index > 64 ) {
        carp "Color index $index outside range: 8 <= index <= 64";
        return 0;
    }

    # Check that the colour components are in the right range
    if (   ( $red < 0 or $red > 255 )
        || ( $green < 0 or $green > 255 )
        || ( $blue < 0  or $blue > 255 ) )
    {
        carp "Color component outside range: 0 <= color <= 255";
        return 0;
    }

    $index -= 8;    # Adjust colour index (wingless dragonfly)

    # Set the RGB value.
    my @rgb = ( $red, $green, $blue );
    $aref->[$index] = [@rgb];

    # Store the custom colors for the style.xml file.
    push @{ $self->{_custom_colors} }, sprintf "FF%02X%02X%02X", @rgb;

    return $index + 8;
}


###############################################################################
#
# set_color_palette()
#
# Sets the colour palette to the Excel defaults.
#
sub set_color_palette {

    my $self = shift;

    $self->{_palette} = [
        [ 0x00, 0x00, 0x00, 0x00 ],    # 8
        [ 0xff, 0xff, 0xff, 0x00 ],    # 9
        [ 0xff, 0x00, 0x00, 0x00 ],    # 10
        [ 0x00, 0xff, 0x00, 0x00 ],    # 11
        [ 0x00, 0x00, 0xff, 0x00 ],    # 12
        [ 0xff, 0xff, 0x00, 0x00 ],    # 13
        [ 0xff, 0x00, 0xff, 0x00 ],    # 14
        [ 0x00, 0xff, 0xff, 0x00 ],    # 15
        [ 0x80, 0x00, 0x00, 0x00 ],    # 16
        [ 0x00, 0x80, 0x00, 0x00 ],    # 17
        [ 0x00, 0x00, 0x80, 0x00 ],    # 18
        [ 0x80, 0x80, 0x00, 0x00 ],    # 19
        [ 0x80, 0x00, 0x80, 0x00 ],    # 20
        [ 0x00, 0x80, 0x80, 0x00 ],    # 21
        [ 0xc0, 0xc0, 0xc0, 0x00 ],    # 22
        [ 0x80, 0x80, 0x80, 0x00 ],    # 23
        [ 0x99, 0x99, 0xff, 0x00 ],    # 24
        [ 0x99, 0x33, 0x66, 0x00 ],    # 25
        [ 0xff, 0xff, 0xcc, 0x00 ],    # 26
        [ 0xcc, 0xff, 0xff, 0x00 ],    # 27
        [ 0x66, 0x00, 0x66, 0x00 ],    # 28
        [ 0xff, 0x80, 0x80, 0x00 ],    # 29
        [ 0x00, 0x66, 0xcc, 0x00 ],    # 30
        [ 0xcc, 0xcc, 0xff, 0x00 ],    # 31
        [ 0x00, 0x00, 0x80, 0x00 ],    # 32
        [ 0xff, 0x00, 0xff, 0x00 ],    # 33
        [ 0xff, 0xff, 0x00, 0x00 ],    # 34
        [ 0x00, 0xff, 0xff, 0x00 ],    # 35
        [ 0x80, 0x00, 0x80, 0x00 ],    # 36
        [ 0x80, 0x00, 0x00, 0x00 ],    # 37
        [ 0x00, 0x80, 0x80, 0x00 ],    # 38
        [ 0x00, 0x00, 0xff, 0x00 ],    # 39
        [ 0x00, 0xcc, 0xff, 0x00 ],    # 40
        [ 0xcc, 0xff, 0xff, 0x00 ],    # 41
        [ 0xcc, 0xff, 0xcc, 0x00 ],    # 42
        [ 0xff, 0xff, 0x99, 0x00 ],    # 43
        [ 0x99, 0xcc, 0xff, 0x00 ],    # 44
        [ 0xff, 0x99, 0xcc, 0x00 ],    # 45
        [ 0xcc, 0x99, 0xff, 0x00 ],    # 46
        [ 0xff, 0xcc, 0x99, 0x00 ],    # 47
        [ 0x33, 0x66, 0xff, 0x00 ],    # 48
        [ 0x33, 0xcc, 0xcc, 0x00 ],    # 49
        [ 0x99, 0xcc, 0x00, 0x00 ],    # 50
        [ 0xff, 0xcc, 0x00, 0x00 ],    # 51
        [ 0xff, 0x99, 0x00, 0x00 ],    # 52
        [ 0xff, 0x66, 0x00, 0x00 ],    # 53
        [ 0x66, 0x66, 0x99, 0x00 ],    # 54
        [ 0x96, 0x96, 0x96, 0x00 ],    # 55
        [ 0x00, 0x33, 0x66, 0x00 ],    # 56
        [ 0x33, 0x99, 0x66, 0x00 ],    # 57
        [ 0x00, 0x33, 0x00, 0x00 ],    # 58
        [ 0x33, 0x33, 0x00, 0x00 ],    # 59
        [ 0x99, 0x33, 0x00, 0x00 ],    # 60
        [ 0x99, 0x33, 0x66, 0x00 ],    # 61
        [ 0x33, 0x33, 0x99, 0x00 ],    # 62
        [ 0x33, 0x33, 0x33, 0x00 ],    # 63
    ];

    return 0;
}


###############################################################################
#
# set_tempdir()
#
# Change the default temp directory.
#
sub set_tempdir {

    my $self = shift;
    my $dir  = shift;

    croak "$dir is not a valid directory" if defined $dir and not -d $dir;

    $self->{_tempdir} = $dir;

}


###############################################################################
#
# define_name()
#
# Create a defined name in Excel. We handle global/workbook level names and
# local/worksheet names.
#
sub define_name {

    my $self        = shift;
    my $name        = shift;
    my $formula     = shift;
    my $sheet_index = undef;
    my $sheetname   = '';
    my $full_name   = $name;

    # Remove the = sign from the formula if it exists.
    $formula =~ s/^=//;

    # Local defined names are formatted like "Sheet1!name".
    if ( $name =~ /^(.*)!(.*)$/ ) {
        $sheetname   = $1;
        $name        = $2;
        $sheet_index = $self->_get_sheet_index( $sheetname );
    }
    else {
        $sheet_index = -1;    # Use -1 to indicate global names.
    }

    # Warn if the sheet index wasn't found.
    if ( !defined $sheet_index ) {
        carp "Unknown sheet name $sheetname in defined_name()";
        return -1;
    }

    # Warn if the name contains invalid chars as defined by Excel help.
    if ( $name !~ m/^[\w\\][\w\\.]*$/ || $name =~ m/^\d/ ) {
        carp "Invalid character in name '$name' used in defined_name()";
        return -1;
    }

    # Warn if the name looks like a cell name.
    if ( $name =~ m/^[a-zA-Z][a-zA-Z]?[a-dA-D]?[0-9]+$/ ) {
        carp "Invalid name '$name' looks like a cell name in defined_name()";
        return -1;
    }

    # Warn if the name looks like a R1C1.
    if ( $name =~ m/^[rcRC]$/ || $name =~ m/^[rcRC]\d+[rcRC]\d+$/ ) {
        carp "Invalid name '$name' like a RC cell ref in defined_name()";
        return -1;
    }

    push @{ $self->{_defined_names} }, [ $name, $sheet_index, $formula ];
}


###############################################################################
#
# set_size()
#
# Set the workbook size.
#
sub set_size {

    my $self   = shift;
    my $width  = shift;
    my $height = shift;

    if ( !$width ) {
        $self->{_window_width} = 16095;
    }
    else {
        # Convert to twips at 96 dpi.
        $self->{_window_width} = int( $width * 1440 / 96 );
    }

    if ( !$height ) {
        $self->{_window_height} = 9660;
    }
    else {
        # Convert to twips at 96 dpi.
        $self->{_window_height} = int( $height * 1440 / 96 );
    }
}


###############################################################################
#
# set_properties()
#
# Set the document properties such as Title, Author etc. These are written to
# property sets in the OLE container.
#
sub set_properties {

    my $self  = shift;
    my %param = @_;

    # Ignore if no args were passed.
    return -1 unless @_;

    # List of valid input parameters.
    my %valid = (
        title          => 1,
        subject        => 1,
        author         => 1,
        keywords       => 1,
        comments       => 1,
        last_author    => 1,
        created        => 1,
        category       => 1,
        manager        => 1,
        company        => 1,
        status         => 1,
        hyperlink_base => 1,
    );

    # Check for valid input parameters.
    for my $parameter ( keys %param ) {
        if ( not exists $valid{$parameter} ) {
            carp "Unknown parameter '$parameter' in set_properties()";
            return -1;
        }
    }

    # Set the creation time unless specified by the user.
    if ( !exists $param{created} ) {
        $param{created} = $self->{_createtime};
    }


    $self->{_doc_properties} = \%param;
}


###############################################################################
#
# set_custom_property()
#
# Set a user defined custom document property.
#
sub set_custom_property {

    my $self  = shift;
    my $name  = shift;
    my $value = shift;
    my $type  = shift;


    # Valid types.
    my %valid_type = (
        'text'       => 1,
        'date'       => 1,
        'number'     => 1,
        'number_int' => 1,
        'bool'       => 1,
    );

    if ( !defined $name || !defined $value ) {
        carp "The name and value parameters must be defined "
          . "in set_custom_property()";

        return -1;
    }

    # Determine the type for strings and numbers if it hasn't been specified.
    if ( !$type ) {
        if ( $value =~ /^\d+$/ ) {
            $type = 'number_int';
        }
        elsif ( $value =~
            /^([+-]?)(?=[0-9]|\.[0-9])[0-9]*(\.[0-9]*)?([Ee]([+-]?[0-9]+))?$/ )
        {
            $type = 'number';
        }
        else {
            $type = 'text';
        }
    }

    # Check for valid validation types.
    if ( !exists $valid_type{$type} ) {
        carp "Unknown custom type '$type' in set_custom_property()";
        return -1;
    }

    #  Check for strings longer than Excel's limit of 255 chars.
    if ( $type eq 'text' and length $value > 255 ) {
        carp "Length of text custom value '$value' exceeds "
          . "Excel's limit of 255 in set_custom_property()";
        return -1;
    }
    if ( length $value > 255 ) {
        carp "Length of custom name '$name' exceeds "
          . "Excel's limit of 255 in set_custom_property()";
        return -1;
    }

    push @{ $self->{_custom_properties} }, [ $name, $value, $type ];
}



###############################################################################
#
# add_vba_project()
#
# Add a vbaProject binary to the XLSX file.
#
sub add_vba_project {

    my $self        = shift;
    my $vba_project = shift;

    croak "No vbaProject.bin specified in add_vba_project()"
      if not $vba_project;

    croak "Couldn't locate $vba_project in add_vba_project(): $!"
      unless -e $vba_project;

    $self->{_vba_project} = $vba_project;
}


###############################################################################
#
# set_vba_name()
#
# Set the VBA name for the workbook.
#
sub set_vba_name {

    my $self         = shift;
    my $vba_codemame = shift;

    if ( $vba_codemame ) {
        $self->{_vba_codename} = $vba_codemame;
    }
    else {
        $self->{_vba_codename} = 'ThisWorkbook';
    }
}


###############################################################################
#
# set_calc_mode()
#
# Set the Excel caclcuation mode for the workbook.
#
sub set_calc_mode {

    my $self    = shift;
    my $mode    = shift || 'auto';
    my $calc_id = shift;

    $self->{_calc_mode} = $mode;

    if ( $mode eq 'manual' ) {
        $self->{_calc_mode}    = 'manual';
        $self->{_calc_on_load} = 0;
    }
    elsif ( $mode eq 'auto_except_tables' ) {
        $self->{_calc_mode} = 'autoNoTable';
    }

    $self->{_calc_id} = $calc_id if defined $calc_id;
}


###############################################################################
#
# _store_workbook()
#
# Assemble worksheets into a workbook.
#
sub _store_workbook {

    my $self     = shift;
    my $tempdir  = File::Temp->newdir( DIR => $self->{_tempdir} );
    my $packager = Excel::Writer::XLSX::Package::Packager->new();
    my $zip      = Archive::Zip->new();


    # Add a default worksheet if non have been added.
    $self->add_worksheet() if not @{ $self->{_worksheets} };

    # Ensure that at least one worksheet has been selected.
    if ( $self->{_activesheet} == 0 ) {
        $self->{_worksheets}->[0]->{_selected} = 1;
        $self->{_worksheets}->[0]->{_hidden}   = 0;
    }

    # Set the active sheet.
    for my $sheet ( @{ $self->{_worksheets} } ) {
        $sheet->{_active} = 1 if $sheet->{_index} == $self->{_activesheet};
    }

    # Convert the SST strings data structure.
    $self->_prepare_sst_string_data();

    # Prepare the worksheet VML elements such as comments and buttons.
    $self->_prepare_vml_objects();

    # Set the defined names for the worksheets such as Print Titles.
    $self->_prepare_defined_names();

    # Prepare the drawings, charts and images.
    $self->_prepare_drawings();

    # Add cached data to charts.
    $self->_add_chart_data();

    # Prepare the worksheet tables.
    $self->_prepare_tables();

    # Package the workbook.
    $packager->_add_workbook( $self );
    $packager->_set_package_dir( $tempdir );
    $packager->_create_package();

    # Free up the Packager object.
    $packager = undef;

    # Add the files to the zip archive. Due to issues with Archive::Zip in
    # taint mode we can't use addTree() so we have to build the file list
    # with File::Find and pass each one to addFile().
    my @xlsx_files;

    my $wanted = sub { push @xlsx_files, $File::Find::name if -f };

    File::Find::find(
        {
            wanted          => $wanted,
            untaint         => 1,
            untaint_pattern => qr|^(.+)$|
        },
        $tempdir
    );

    # Store the xlsx component files with the temp dir name removed.
    for my $filename ( @xlsx_files ) {
        my $short_name = $filename;
        $short_name =~ s{^\Q$tempdir\E/?}{};
        $zip->addFile( $filename, $short_name );
    }


    if ( $self->{_internal_fh} ) {

        if ( $zip->writeToFileHandle( $self->{_filehandle} ) != 0 ) {
            carp 'Error writing zip container for xlsx file.';
        }
    }
    else {

        # Archive::Zip needs to rewind a filehandle to write the zip headers.
        # This won't work for arbitrary user defined filehandles so we use
        # a temp file based filehandle to create the zip archive and then
        # stream that to the filehandle.
        my $tmp_fh = tempfile( DIR => $self->{_tempdir} );
        my $is_seekable = 1;

        if ( $zip->writeToFileHandle( $tmp_fh, $is_seekable ) != 0 ) {
            carp 'Error writing zip container for xlsx file.';
        }

        my $buffer;
        seek $tmp_fh, 0, 0;

        while ( read( $tmp_fh, $buffer, 4_096 ) ) {
            local $\ = undef;    # Protect print from -l on commandline.
            print { $self->{_filehandle} } $buffer;
        }
    }
}


###############################################################################
#
# _prepare_sst_string_data()
#
# Convert the SST string data from a hash to an array.
#
sub _prepare_sst_string_data {

    my $self = shift;

    my @strings;
    $#strings = $self->{_str_unique} - 1;    # Pre-extend array

    while ( my $key = each %{ $self->{_str_table} } ) {
        $strings[ $self->{_str_table}->{$key} ] = $key;
    }

    # The SST data could be very large, free some memory (maybe).
    $self->{_str_table} = undef;
    $self->{_str_array} = \@strings;

}


###############################################################################
#
# _prepare_format_properties()
#
# Prepare all of the format properties prior to passing them to Styles.pm.
#
sub _prepare_format_properties {

    my $self = shift;

    # Separate format objects into XF and DXF formats.
    $self->_prepare_formats();

    # Set the font index for the format objects.
    $self->_prepare_fonts();

    # Set the number format index for the format objects.
    $self->_prepare_num_formats();

    # Set the border index for the format objects.
    $self->_prepare_borders();

    # Set the fill index for the format objects.
    $self->_prepare_fills();


}


###############################################################################
#
# _prepare_formats()
#
# Iterate through the XF Format objects and separate them into XF and DXF
# formats.
#
sub _prepare_formats {

    my $self = shift;

    for my $format ( @{ $self->{_formats} } ) {
        my $xf_index  = $format->{_xf_index};
        my $dxf_index = $format->{_dxf_index};

        if ( defined $xf_index ) {
            $self->{_xf_formats}->[$xf_index] = $format;
        }

        if ( defined $dxf_index ) {
            $self->{_dxf_formats}->[$dxf_index] = $format;
        }
    }
}


###############################################################################
#
# _set_default_xf_indices()
#
# Set the default index for each format. This is mainly used for testing.
#
sub _set_default_xf_indices {

    my $self = shift;

    for my $format ( @{ $self->{_formats} } ) {
        $format->get_xf_index();
    }
}


###############################################################################
#
# _prepare_fonts()
#
# Iterate through the XF Format objects and give them an index to non-default
# font elements.
#
sub _prepare_fonts {

    my $self = shift;

    my %fonts;
    my $index = 0;

    for my $format ( @{ $self->{_xf_formats} } ) {
        my $key = $format->get_font_key();

        if ( exists $fonts{$key} ) {

            # Font has already been used.
            $format->{_font_index} = $fonts{$key};
            $format->{_has_font}   = 0;
        }
        else {

            # This is a new font.
            $fonts{$key}           = $index;
            $format->{_font_index} = $index;
            $format->{_has_font}   = 1;
            $index++;
        }
    }

    $self->{_font_count} = $index;

    # For the DXF formats we only need to check if the properties have changed.
    for my $format ( @{ $self->{_dxf_formats} } ) {

        # The only font properties that can change for a DXF format are: color,
        # bold, italic, underline and strikethrough.
        if (   $format->{_color}
            || $format->{_bold}
            || $format->{_italic}
            || $format->{_underline}
            || $format->{_font_strikeout} )
        {
            $format->{_has_dxf_font} = 1;
        }
    }
}


###############################################################################
#
# _prepare_num_formats()
#
# Iterate through the XF Format objects and give them an index to non-default
# number format elements.
#
# User defined records start from index 0xA4.
#
sub _prepare_num_formats {

    my $self = shift;

    my %num_formats;
    my $index            = 164;
    my $num_format_count = 0;

    for my $format ( @{ $self->{_xf_formats} }, @{ $self->{_dxf_formats} } ) {
        my $num_format = $format->{_num_format};

        # Check if $num_format is an index to a built-in number format.
        # Also check for a string of zeros, which is a valid number format
        # string but would evaluate to zero.
        #
        if ( $num_format =~ m/^\d+$/ && $num_format !~ m/^0+\d/ ) {

            # Index to a built-in number format.
            $format->{_num_format_index} = $num_format;
            next;
        }


        if ( exists( $num_formats{$num_format} ) ) {

            # Number format has already been used.
            $format->{_num_format_index} = $num_formats{$num_format};
        }
        else {

            # Add a new number format.
            $num_formats{$num_format} = $index;
            $format->{_num_format_index} = $index;
            $index++;

            # Only increase font count for XF formats (not for DXF formats).
            if ( $format->{_xf_index} ) {
                $num_format_count++;
            }
        }
    }

    $self->{_num_format_count} = $num_format_count;
}


###############################################################################
#
# _prepare_borders()
#
# Iterate through the XF Format objects and give them an index to non-default
# border elements.
#
sub _prepare_borders {

    my $self = shift;

    my %borders;
    my $index = 0;

    for my $format ( @{ $self->{_xf_formats} } ) {
        my $key = $format->get_border_key();

        if ( exists $borders{$key} ) {

            # Border has already been used.
            $format->{_border_index} = $borders{$key};
            $format->{_has_border}   = 0;
        }
        else {

            # This is a new border.
            $borders{$key}           = $index;
            $format->{_border_index} = $index;
            $format->{_has_border}   = 1;
            $index++;
        }
    }

    $self->{_border_count} = $index;

    # For the DXF formats we only need to check if the properties have changed.
    for my $format ( @{ $self->{_dxf_formats} } ) {
        my $key = $format->get_border_key();

        if ( $key =~ m/[^0:]/ ) {
            $format->{_has_dxf_border} = 1;
        }
    }

}


###############################################################################
#
# _prepare_fills()
#
# Iterate through the XF Format objects and give them an index to non-default
# fill elements.
#
# The user defined fill properties start from 2 since there are 2 default
# fills: patternType="none" and patternType="gray125".
#
sub _prepare_fills {

    my $self = shift;

    my %fills;
    my $index = 2;    # Start from 2. See above.

    # Add the default fills.
    $fills{'0:0:0'}  = 0;
    $fills{'17:0:0'} = 1;


    # Store the DXF colours separately since them may be reversed below.
    for my $format ( @{ $self->{_dxf_formats} } ) {
        if (   $format->{_pattern}
            || $format->{_bg_color}
            || $format->{_fg_color} )
        {
            $format->{_has_dxf_fill} = 1;
            $format->{_dxf_bg_color} = $format->{_bg_color};
            $format->{_dxf_fg_color} = $format->{_fg_color};
        }
    }


    for my $format ( @{ $self->{_xf_formats} } ) {

        # The following logical statements jointly take care of special cases
        # in relation to cell colours and patterns:
        # 1. For a solid fill (_pattern == 1) Excel reverses the role of
        #    foreground and background colours, and
        # 2. If the user specifies a foreground or background colour without
        #    a pattern they probably wanted a solid fill, so we fill in the
        #    defaults.
        #
        if (   $format->{_pattern} == 1
            && $format->{_bg_color} ne '0'
            && $format->{_fg_color} ne '0' )
        {
            my $tmp = $format->{_fg_color};
            $format->{_fg_color} = $format->{_bg_color};
            $format->{_bg_color} = $tmp;
        }

        if (   $format->{_pattern} <= 1
            && $format->{_bg_color} ne '0'
            && $format->{_fg_color} eq '0' )
        {
            $format->{_fg_color} = $format->{_bg_color};
            $format->{_bg_color} = 0;
            $format->{_pattern}  = 1;
        }

        if (   $format->{_pattern} <= 1
            && $format->{_bg_color} eq '0'
            && $format->{_fg_color} ne '0' )
        {
            $format->{_bg_color} = 0;
            $format->{_pattern}  = 1;
        }


        my $key = $format->get_fill_key();

        if ( exists $fills{$key} ) {

            # Fill has already been used.
            $format->{_fill_index} = $fills{$key};
            $format->{_has_fill}   = 0;
        }
        else {

            # This is a new fill.
            $fills{$key}           = $index;
            $format->{_fill_index} = $index;
            $format->{_has_fill}   = 1;
            $index++;
        }
    }

    $self->{_fill_count} = $index;


}


###############################################################################
#
# _prepare_defined_names()
#
# Iterate through the worksheets and store any defined names in addition to
# any user defined names. Stores the defined names for the Workbook.xml and
# the named ranges for App.xml.
#
sub _prepare_defined_names {

    my $self = shift;

    my @defined_names = @{ $self->{_defined_names} };

    for my $sheet ( @{ $self->{_worksheets} } ) {

        # Check for Print Area settings.
        if ( $sheet->{_autofilter} ) {

            my $range  = $sheet->{_autofilter};
            my $hidden = 1;

            # Store the defined names.
            push @defined_names,
              [ '_xlnm._FilterDatabase', $sheet->{_index}, $range, $hidden ];

        }

        # Check for Print Area settings.
        if ( $sheet->{_print_area} ) {

            my $range = $sheet->{_print_area};

            # Store the defined names.
            push @defined_names,
              [ '_xlnm.Print_Area', $sheet->{_index}, $range ];
        }

        # Check for repeat rows/cols. aka, Print Titles.
        if ( $sheet->{_repeat_cols} || $sheet->{_repeat_rows} ) {
            my $range = '';

            if ( $sheet->{_repeat_cols} && $sheet->{_repeat_rows} ) {
                $range = $sheet->{_repeat_cols} . ',' . $sheet->{_repeat_rows};
            }
            else {
                $range = $sheet->{_repeat_cols} . $sheet->{_repeat_rows};
            }

            # Store the defined names.
            push @defined_names,
              [ '_xlnm.Print_Titles', $sheet->{_index}, $range ];
        }

    }

    @defined_names          = _sort_defined_names( @defined_names );
    $self->{_defined_names} = \@defined_names;
    $self->{_named_ranges}  = _extract_named_ranges( @defined_names );
}


###############################################################################
#
# _sort_defined_names()
#
# Sort internal and user defined names in the same order as used by Excel.
# This may not be strictly necessary but unsorted elements caused a lot of
# issues in the Spreadsheet::WriteExcel binary version. Also makes
# comparison testing easier.
#
sub _sort_defined_names {

    my @names = @_;

    #<<< Perltidy ignore this.

    @names = sort {
        # Primary sort based on the defined name.
        _normalise_defined_name( $a->[0] )
        cmp
        _normalise_defined_name( $b->[0] )

        ||
        # Secondary sort based on the sheet name.
        _normalise_sheet_name( $a->[2] )
        cmp
        _normalise_sheet_name( $b->[2] )

    } @names;
    #>>>

    return @names;
}

# Used in the above sort routine to normalise the defined names. Removes any
# leading '_xmln.' from internal names and lowercases the strings.
sub _normalise_defined_name {
    my $name = shift;

    $name =~ s/^_xlnm.//;
    $name = lc $name;

    return $name;
}

# Used in the above sort routine to normalise the worksheet names for the
# secondary sort. Removes leading quote and lowercases the strings.
sub _normalise_sheet_name {
    my $name = shift;

    $name =~ s/^'//;
    $name = lc $name;

    return $name;
}


###############################################################################
#
# _extract_named_ranges()
#
# Extract the named ranges from the sorted list of defined names. These are
# used in the App.xml file.
#
sub _extract_named_ranges {

    my @defined_names = @_;
    my @named_ranges;

    NAME:
    for my $defined_name ( @defined_names ) {

        my $name  = $defined_name->[0];
        my $index = $defined_name->[1];
        my $range = $defined_name->[2];

        # Skip autoFilter ranges.
        next NAME if $name eq '_xlnm._FilterDatabase';

        # We are only interested in defined names with ranges.
        if ( $range =~ /^([^!]+)!/ ) {
            my $sheet_name = $1;

            # Match Print_Area and Print_Titles xlnm types.
            if ( $name =~ /^_xlnm\.(.*)$/ ) {
                my $xlnm_type = $1;
                $name = $sheet_name . '!' . $xlnm_type;
            }
            elsif ( $index != -1 ) {
                $name = $sheet_name . '!' . $name;
            }

            push @named_ranges, $name;
        }
    }

    return \@named_ranges;
}


###############################################################################
#
# _prepare_drawings()
#
# Iterate through the worksheets and set up any chart or image drawings.
#
sub _prepare_drawings {

    my $self         = shift;
    my $chart_ref_id = 0;
    my $image_ref_id = 0;
    my $drawing_id   = 0;

    for my $sheet ( @{ $self->{_worksheets} } ) {

        my $chart_count = scalar @{ $sheet->{_charts} };
        my $image_count = scalar @{ $sheet->{_images} };
        my $shape_count = scalar @{ $sheet->{_shapes} };

        my $header_image_count = scalar @{ $sheet->{_header_images} };
        my $footer_image_count = scalar @{ $sheet->{_footer_images} };
        my $has_drawing        = 0;


        # Check that some image or drawing needs to be processed.
        if (   !$chart_count
            && !$image_count
            && !$shape_count
            && !$header_image_count
            && !$footer_image_count )
        {
            next;
        }

        # Don't increase the drawing_id header/footer images.
        if ( $chart_count || $image_count || $shape_count ) {
            $drawing_id++;
            $has_drawing = 1;
        }

        # Prepare the worksheet charts.
        for my $index ( 0 .. $chart_count - 1 ) {
            $chart_ref_id++;
            $sheet->_prepare_chart( $index, $chart_ref_id, $drawing_id );
        }

        # Prepare the worksheet images.
        for my $index ( 0 .. $image_count - 1 ) {

            my $filename = $sheet->{_images}->[$index]->[2];

            my ( $type, $width, $height, $name, $x_dpi, $y_dpi ) =
              $self->_get_image_properties( $filename );

            $image_ref_id++;

            $sheet->_prepare_image(
                $index, $image_ref_id, $drawing_id,
                $width, $height,       $name,
                $type,  $x_dpi,        $y_dpi
            );
        }

        # Prepare the worksheet shapes.
        for my $index ( 0 .. $shape_count - 1 ) {
            $sheet->_prepare_shape( $index, $drawing_id );
        }

        # Prepare the header images.
        for my $index ( 0 .. $header_image_count - 1 ) {

            my $filename = $sheet->{_header_images}->[$index]->[0];
            my $position = $sheet->{_header_images}->[$index]->[1];

            my ( $type, $width, $height, $name, $x_dpi, $y_dpi ) =
              $self->_get_image_properties( $filename );

            $image_ref_id++;

            $sheet->_prepare_header_image( $image_ref_id, $width, $height,
                $name, $type, $position, $x_dpi, $y_dpi );
        }

        # Prepare the footer images.
        for my $index ( 0 .. $footer_image_count - 1 ) {

            my $filename = $sheet->{_footer_images}->[$index]->[0];
            my $position = $sheet->{_footer_images}->[$index]->[1];

            my ( $type, $width, $height, $name, $x_dpi, $y_dpi ) =
              $self->_get_image_properties( $filename );

            $image_ref_id++;

            $sheet->_prepare_header_image( $image_ref_id, $width, $height,
                $name, $type, $position, $x_dpi, $y_dpi );
        }


        if ( $has_drawing ) {
            my $drawing = $sheet->{_drawing};
            push @{ $self->{_drawings} }, $drawing;
        }
    }


    # Remove charts that were created but not inserted into worksheets.
    my @chart_data;

    for my $chart ( @{ $self->{_charts} } ) {
        if ( $chart->{_id} != -1 ) {
            push @chart_data, $chart;
        }
    }

    # Sort the workbook charts references into the order that the were
    # written from the worksheets above.
    @chart_data = sort { $a->{_id} <=> $b->{_id} } @chart_data;

    $self->{_charts} = \@chart_data;
    $self->{_drawing_count} = $drawing_id;
}


###############################################################################
#
# _prepare_vml_objects()
#
# Iterate through the worksheets and set up the VML objects.
#
sub _prepare_vml_objects {

    my $self           = shift;
    my $comment_id     = 0;
    my $vml_drawing_id = 0;
    my $vml_data_id    = 1;
    my $vml_header_id  = 0;
    my $vml_shape_id   = 1024;
    my $vml_files      = 0;
    my $comment_files  = 0;
    my $has_button     = 0;

    for my $sheet ( @{ $self->{_worksheets} } ) {

        next if !$sheet->{_has_vml} and !$sheet->{_has_header_vml};
        $vml_files = 1;


        if ( $sheet->{_has_vml} ) {

            $comment_files++ if $sheet->{_has_comments};
            $comment_id++    if $sheet->{_has_comments};
            $vml_drawing_id++;

            my $count =
              $sheet->_prepare_vml_objects( $vml_data_id, $vml_shape_id,
                $vml_drawing_id, $comment_id );

            # Each VML file should start with a shape id incremented by 1024.
            $vml_data_id  += 1 * int(    ( 1024 + $count ) / 1024 );
            $vml_shape_id += 1024 * int( ( 1024 + $count ) / 1024 );

        }

        if ( $sheet->{_has_header_vml} ) {
            $vml_header_id++;
            $vml_drawing_id++;
            $sheet->_prepare_header_vml_objects( $vml_header_id,
                $vml_drawing_id );
        }

        # Set the sheet vba_codename if it has a button and the workbook
        # has a vbaProject binary.
        if ( $sheet->{_buttons_array} ) {
            $has_button = 1;

            if ( $self->{_vba_project} && !$sheet->{_vba_codename} ) {
                $sheet->set_vba_name();
            }
        }

    }

    $self->{_num_vml_files}     = $vml_files;
    $self->{_num_comment_files} = $comment_files;

    # Add a font format for cell comments.
    if ( $comment_files > 0 ) {
        my $format = Excel::Writer::XLSX::Format->new(
            \$self->{_xf_format_indices},
            \$self->{_dxf_format_indices},
            font          => 'Tahoma',
            size          => 8,
            color_indexed => 81,
            font_only     => 1,
        );

        $format->get_xf_index();

        push @{ $self->{_formats} }, $format;
    }

    # Set the workbook vba_codename if one of the sheets has a button and
    # the workbook has a vbaProject binary.
    if ( $has_button && $self->{_vba_project} && !$self->{_vba_codename} ) {
        $self->set_vba_name();
    }
}


###############################################################################
#
# _prepare_tables()
#
# Set the table ids for the worksheet tables.
#
sub _prepare_tables {

    my $self     = shift;
    my $table_id = 0;
    my $seen     = {};

    for my $sheet ( @{ $self->{_worksheets} } ) {

        my $table_count = scalar @{ $sheet->{_tables} };

        next unless $table_count;

        $sheet->_prepare_tables( $table_id + 1, $seen );

        $table_id += $table_count;
    }
}


###############################################################################
#
# _add_chart_data()
#
# Add "cached" data to charts to provide the numCache and strCache data for
# series and title/axis ranges.
#
sub _add_chart_data {

    my $self = shift;
    my %worksheets;
    my %seen_ranges;
    my @charts;

    # Map worksheet names to worksheet objects.
    for my $worksheet ( @{ $self->{_worksheets} } ) {
        $worksheets{ $worksheet->{_name} } = $worksheet;
    }

    # Build an array of the worksheet charts including any combined charts.
    for my $chart ( @{ $self->{_charts} } ) {
        push @charts, $chart;

        if ($chart->{_combined}) {
            push @charts, $chart->{_combined};
        }
    }


    CHART:
    for my $chart ( @charts ) {

        RANGE:
        while ( my ( $range, $id ) = each %{ $chart->{_formula_ids} } ) {

            # Skip if the series has user defined data.
            if ( defined $chart->{_formula_data}->[$id] ) {
                if (   !exists $seen_ranges{$range}
                    || !defined $seen_ranges{$range} )
                {
                    my $data = $chart->{_formula_data}->[$id];
                    $seen_ranges{$range} = $data;
                }
                next RANGE;
            }

            # Check to see if the data is already cached locally.
            if ( exists $seen_ranges{$range} ) {
                $chart->{_formula_data}->[$id] = $seen_ranges{$range};
                next RANGE;
            }

            # Convert the range formula to a sheet name and cell range.
            my ( $sheetname, @cells ) = $self->_get_chart_range( $range );

            # Skip if we couldn't parse the formula.
            next RANGE if !defined $sheetname;

            # Handle non-contiguous ranges: (Sheet1!$A$1:$A$2,Sheet1!$A$4:$A$5).
            # We don't try to parse the ranges. We just return an empty list.
            if ( $sheetname =~ m/^\([^,]+,/ ) {
                $chart->{_formula_data}->[$id] = [];
                $seen_ranges{$range} = [];
                next RANGE;
            }

            # Die if the name is unknown since it indicates a user error in
            # a chart series formula.
            if ( !exists $worksheets{$sheetname} ) {
                die "Unknown worksheet reference '$sheetname' in range "
                  . "'$range' passed to add_series().\n";
            }

            # Find the worksheet object based on the sheet name.
            my $worksheet = $worksheets{$sheetname};

            # Get the data from the worksheet table.
            my @data = $worksheet->_get_range_data( @cells );

            # Convert shared string indexes to strings.
            for my $token ( @data ) {
                if ( ref $token ) {
                    $token = $self->{_str_array}->[ $token->{sst_id} ];

                    # Ignore rich strings for now. Deparse later if necessary.
                    if ( $token =~ m{^<r>} && $token =~ m{</r>$} ) {
                        $token = '';
                    }
                }
            }

            # Add the data to the chart.
            $chart->{_formula_data}->[$id] = \@data;

            # Store range data locally to avoid lookup if seen again.
            $seen_ranges{$range} = \@data;
        }
    }
}


###############################################################################
#
# _get_chart_range()
#
# Convert a range formula such as Sheet1!$B$1:$B$5 into a sheet name and cell
# range such as ( 'Sheet1', 0, 1, 4, 1 ).
#
sub _get_chart_range {

    my $self  = shift;
    my $range = shift;
    my $cell_1;
    my $cell_2;
    my $sheetname;
    my $cells;

    # Split the range formula into sheetname and cells at the last '!'.
    my $pos = rindex $range, '!';
    if ( $pos > 0 ) {
        $sheetname = substr $range, 0, $pos;
        $cells = substr $range, $pos + 1;
    }
    else {
        return undef;
    }

    # Split the cell range into 2 cells or else use single cell for both.
    if ( $cells =~ ':' ) {
        ( $cell_1, $cell_2 ) = split /:/, $cells;
    }
    else {
        ( $cell_1, $cell_2 ) = ( $cells, $cells );
    }

    # Remove leading/trailing apostrophes and convert escaped quotes to single.
    $sheetname =~ s/^'//g;
    $sheetname =~ s/'$//g;
    $sheetname =~ s/''/'/g;

    my ( $row_start, $col_start ) = xl_cell_to_rowcol( $cell_1 );
    my ( $row_end,   $col_end )   = xl_cell_to_rowcol( $cell_2 );

    # Check that we have a 1D range only.
    if ( $row_start != $row_end && $col_start != $col_end ) {
        return undef;
    }

    return ( $sheetname, $row_start, $col_start, $row_end, $col_end );
}


###############################################################################
#
# _store_externs()
#
# Write the EXTERNCOUNT and EXTERNSHEET records. These are used as indexes for
# the NAME records.
#
sub _store_externs {

    my $self = shift;

}


###############################################################################
#
# _store_names()
#
# Write the NAME record to define the print area and the repeat rows and cols.
#
sub _store_names {

    my $self = shift;

}


###############################################################################
#
# _quote_sheetname()
#
# Sheetnames used in references should be quoted if they contain any spaces,
# special characters or if the look like something that isn't a sheet name.
# TODO. We need to handle more special cases.
#
sub _quote_sheetname {

    my $self      = shift;
    my $sheetname = $_[0];

    if ( $sheetname =~ /^Sheet\d+$/ ) {
        return $sheetname;
    }
    else {
        return qq('$sheetname');
    }
}


###############################################################################
#
# _get_image_properties()
#
# Extract information from the image file such as dimension, type, filename,
# and extension. Also keep track of previously seen images to optimise out
# any duplicates.
#
sub _get_image_properties {

    my $self     = shift;
    my $filename = shift;

    my $type;
    my $width;
    my $height;
    my $x_dpi = 96;
    my $y_dpi = 96;
    my $image_name;


    ( $image_name ) = fileparse( $filename );

    # Open the image file and import the data.
    my $fh = FileHandle->new( $filename );
    croak "Couldn't import $filename: $!" unless defined $fh;
    binmode $fh;

    # Slurp the file into a string and do some size calcs.
    my $data = do { local $/; <$fh> };
    my $size = length $data;


    if ( unpack( 'x A3', $data ) eq 'PNG' ) {

        # Test for PNGs.
        ( $type, $width, $height, $x_dpi, $y_dpi ) =
          $self->_process_png( $data, $filename );

        $self->{_image_types}->{png} = 1;
    }
    elsif ( unpack( 'n', $data ) == 0xFFD8 ) {

        # Test for JPEG files.
        ( $type, $width, $height, $x_dpi, $y_dpi ) =
          $self->_process_jpg( $data, $filename );

        $self->{_image_types}->{jpeg} = 1;
    }
    elsif ( unpack( 'A2', $data ) eq 'BM' ) {

        # Test for BMPs.
        ( $type, $width, $height ) = $self->_process_bmp( $data, $filename );

        $self->{_image_types}->{bmp} = 1;
    }
    else {
        croak "Unsupported image format for file: $filename\n";
    }

    push @{ $self->{_images} }, [ $filename, $type ];

    # Set a default dpi for images with 0 dpi.
    $x_dpi = 96 if $x_dpi == 0;
    $y_dpi = 96 if $y_dpi == 0;

    $fh->close;

    return ( $type, $width, $height, $image_name, $x_dpi, $y_dpi );
}


###############################################################################
#
# _process_png()
#
# Extract width and height information from a PNG file.
#
sub _process_png {

    my $self     = shift;
    my $data     = $_[0];
    my $filename = $_[1];

    my $type   = 'png';
    my $width  = 0;
    my $height = 0;
    my $x_dpi  = 96;
    my $y_dpi  = 96;

    my $offset      = 8;
    my $data_length = length $data;

    # Search through the image data to read the height and width in the
    # IHDR element. Also read the DPI in the pHYs element.
    while ( $offset < $data_length ) {

        my $length = unpack "N",  substr $data, $offset + 0, 4;
        my $type   = unpack "A4", substr $data, $offset + 4, 4;

        if ( $type eq "IHDR" ) {
            $width  = unpack "N", substr $data, $offset + 8,  4;
            $height = unpack "N", substr $data, $offset + 12, 4;
        }

        if ( $type eq "pHYs" ) {
            my $x_ppu = unpack "N", substr $data, $offset + 8,  4;
            my $y_ppu = unpack "N", substr $data, $offset + 12, 4;
            my $units = unpack "C", substr $data, $offset + 16, 1;

            if ( $units == 1 ) {
                $x_dpi = $x_ppu * 0.0254;
                $y_dpi = $y_ppu * 0.0254;
            }
        }

        $offset = $offset + $length + 12;

        last if $type eq "IEND";
    }

    if ( not defined $height ) {
        croak "$filename: no size data found in png image.\n";
    }

    return ( $type, $width, $height, $x_dpi, $y_dpi );
}


###############################################################################
#
# _process_bmp()
#
# Extract width and height information from a BMP file.
#
# Most of the checks came from old Spredsheet::WriteExcel code.
#
sub _process_bmp {

    my $self     = shift;
    my $data     = $_[0];
    my $filename = $_[1];
    my $type     = 'bmp';


    # Check that the file is big enough to be a bitmap.
    if ( length $data <= 0x36 ) {
        croak "$filename doesn't contain enough data.";
    }


    # Read the bitmap width and height. Verify the sizes.
    my ( $width, $height ) = unpack "x18 V2", $data;

    if ( $width > 0xFFFF ) {
        croak "$filename: largest image width $width supported is 65k.";
    }

    if ( $height > 0xFFFF ) {
        croak "$filename: largest image height supported is 65k.";
    }

    # Read the bitmap planes and bpp data. Verify them.
    my ( $planes, $bitcount ) = unpack "x26 v2", $data;

    if ( $bitcount != 24 ) {
        croak "$filename isn't a 24bit true color bitmap.";
    }

    if ( $planes != 1 ) {
        croak "$filename: only 1 plane supported in bitmap image.";
    }


    # Read the bitmap compression. Verify compression.
    my $compression = unpack "x30 V", $data;

    if ( $compression != 0 ) {
        croak "$filename: compression not supported in bitmap image.";
    }

    return ( $type, $width, $height );
}


###############################################################################
#
# _process_jpg()
#
# Extract width and height information from a JPEG file.
#
sub _process_jpg {

    my $self     = shift;
    my $data     = $_[0];
    my $filename = $_[1];
    my $type     = 'jpeg';
    my $x_dpi    = 96;
    my $y_dpi    = 96;
    my $width;
    my $height;

    my $offset      = 2;
    my $data_length = length $data;

    # Search through the image data to read the height and width in the
    # 0xFFC0/C2 element. Also read the DPI in the 0xFFE0 element.
    while ( $offset < $data_length ) {

        my $marker = unpack "n", substr $data, $offset + 0, 2;
        my $length = unpack "n", substr $data, $offset + 2, 2;

        if ( $marker == 0xFFC0 || $marker == 0xFFC2 ) {
            $height = unpack "n", substr $data, $offset + 5, 2;
            $width  = unpack "n", substr $data, $offset + 7, 2;
        }

        if ( $marker == 0xFFE0 ) {
            my $units     = unpack "C", substr $data, $offset + 11, 1;
            my $x_density = unpack "n", substr $data, $offset + 12, 2;
            my $y_density = unpack "n", substr $data, $offset + 14, 2;

            if ( $units == 1 ) {
                $x_dpi = $x_density;
                $y_dpi = $y_density;
            }

            if ( $units == 2 ) {
                $x_dpi = $x_density * 2.54;
                $y_dpi = $y_density * 2.54;
            }
        }

        $offset = $offset + $length + 2;
        last if $marker == 0xFFDA;
    }

    if ( not defined $height ) {
        croak "$filename: no size data found in jpeg image.\n";
    }

    return ( $type, $width, $height, $x_dpi, $y_dpi );
}


###############################################################################
#
# _get_sheet_index()
#
# Convert a sheet name to its index. Return undef otherwise.
#
sub _get_sheet_index {

    my $self        = shift;
    my $sheetname   = shift;
    my $sheet_index = undef;

    $sheetname =~ s/^'//;
    $sheetname =~ s/'$//;

    if ( exists $self->{_sheetnames}->{$sheetname} ) {
        return $self->{_sheetnames}->{$sheetname}->{_index};
    }
    else {
        return undef;
    }
}


###############################################################################
#
# set_optimization()
#
# Set the speed/memory optimisation level.
#
sub set_optimization {

    my $self = shift;
    my $level = defined $_[0] ? $_[0] : 1;

    croak "set_optimization() must be called before add_worksheet()"
      if $self->sheets();

    $self->{_optimization} = $level;
}


###############################################################################
#
# Deprecated methods for backwards compatibility.
#
###############################################################################

# No longer required by Excel::Writer::XLSX.
sub compatibility_mode { }
sub set_codepage       { }


###############################################################################
#
# XML writing methods.
#
###############################################################################


###############################################################################
#
# _write_workbook()
#
# Write <workbook> element.
#
sub _write_workbook {

    my $self    = shift;
    my $schema  = 'http://schemas.openxmlformats.org';
    my $xmlns   = $schema . '/spreadsheetml/2006/main';
    my $xmlns_r = $schema . '/officeDocument/2006/relationships';

    my @attributes = (
        'xmlns'   => $xmlns,
        'xmlns:r' => $xmlns_r,
    );

    $self->xml_start_tag( 'workbook', @attributes );
}


###############################################################################
#
# write_file_version()
#
# Write the <fileVersion> element.
#
sub _write_file_version {

    my $self          = shift;
    my $app_name      = 'xl';
    my $last_edited   = 4;
    my $lowest_edited = 4;
    my $rup_build     = 4505;

    my @attributes = (
        'appName'      => $app_name,
        'lastEdited'   => $last_edited,
        'lowestEdited' => $lowest_edited,
        'rupBuild'     => $rup_build,
    );

    if ( $self->{_vba_project} ) {
        push @attributes, codeName => '{37E998C4-C9E5-D4B9-71C8-EB1FF731991C}';
    }

    $self->xml_empty_tag( 'fileVersion', @attributes );
}


###############################################################################
#
# _write_workbook_pr()
#
# Write <workbookPr> element.
#
sub _write_workbook_pr {

    my $self                   = shift;
    my $date_1904              = $self->{_date_1904};
    my $show_ink_annotation    = 0;
    my $auto_compress_pictures = 0;
    my $default_theme_version  = 124226;
    my $codename               = $self->{_vba_codename};
    my @attributes;

    push @attributes, ( 'codeName' => $codename ) if $codename;
    push @attributes, ( 'date1904' => 1 )         if $date_1904;
    push @attributes, ( 'defaultThemeVersion' => $default_theme_version );

    $self->xml_empty_tag( 'workbookPr', @attributes );
}


###############################################################################
#
# _write_book_views()
#
# Write <bookViews> element.
#
sub _write_book_views {

    my $self = shift;

    $self->xml_start_tag( 'bookViews' );
    $self->_write_workbook_view();
    $self->xml_end_tag( 'bookViews' );
}

###############################################################################
#
# _write_workbook_view()
#
# Write <workbookView> element.
#
sub _write_workbook_view {

    my $self          = shift;
    my $x_window      = $self->{_x_window};
    my $y_window      = $self->{_y_window};
    my $window_width  = $self->{_window_width};
    my $window_height = $self->{_window_height};
    my $tab_ratio     = $self->{_tab_ratio};
    my $active_tab    = $self->{_activesheet};
    my $first_sheet   = $self->{_firstsheet};

    my @attributes = (
        'xWindow'      => $x_window,
        'yWindow'      => $y_window,
        'windowWidth'  => $window_width,
        'windowHeight' => $window_height,
    );

    # Store the tabRatio attribute when it isn't the default.
    push @attributes, ( tabRatio => $tab_ratio ) if $tab_ratio != 500;

    # Store the firstSheet attribute when it isn't the default.
    push @attributes, ( firstSheet => $first_sheet + 1 ) if $first_sheet > 0;

    # Store the activeTab attribute when it isn't the first sheet.
    push @attributes, ( activeTab => $active_tab ) if $active_tab > 0;

    $self->xml_empty_tag( 'workbookView', @attributes );
}

###############################################################################
#
# _write_sheets()
#
# Write <sheets> element.
#
sub _write_sheets {

    my $self   = shift;
    my $id_num = 1;

    $self->xml_start_tag( 'sheets' );

    for my $worksheet ( @{ $self->{_worksheets} } ) {
        $self->_write_sheet( $worksheet->{_name}, $id_num++,
            $worksheet->{_hidden} );
    }

    $self->xml_end_tag( 'sheets' );
}


###############################################################################
#
# _write_sheet()
#
# Write <sheet> element.
#
sub _write_sheet {

    my $self     = shift;
    my $name     = shift;
    my $sheet_id = shift;
    my $hidden   = shift;
    my $r_id     = 'rId' . $sheet_id;

    my @attributes = (
        'name'    => $name,
        'sheetId' => $sheet_id,
    );

    push @attributes, ( 'state' => 'hidden' ) if $hidden;
    push @attributes, ( 'r:id' => $r_id );


    $self->xml_empty_tag( 'sheet', @attributes );
}


###############################################################################
#
# _write_calc_pr()
#
# Write <calcPr> element.
#
sub _write_calc_pr {

    my $self            = shift;
    my $calc_id         = $self->{_calc_id};
    my $concurrent_calc = 0;

    my @attributes = ( calcId => $calc_id );

    if ( $self->{_calc_mode} eq 'manual' ) {
        push @attributes, 'calcMode'   => 'manual';
        push @attributes, 'calcOnSave' => 0;
    }
    elsif ( $self->{_calc_mode} eq 'autoNoTable' ) {
        push @attributes, calcMode => 'autoNoTable';
    }

    if ( $self->{_calc_on_load} ) {
        push @attributes, 'fullCalcOnLoad' => 1;
    }


    $self->xml_empty_tag( 'calcPr', @attributes );
}


###############################################################################
#
# _write_ext_lst()
#
# Write <extLst> element.
#
sub _write_ext_lst {

    my $self = shift;

    $self->xml_start_tag( 'extLst' );
    $self->_write_ext();
    $self->xml_end_tag( 'extLst' );
}


###############################################################################
#
# _write_ext()
#
# Write <ext> element.
#
sub _write_ext {

    my $self     = shift;
    my $xmlns_mx = 'http://schemas.microsoft.com/office/mac/excel/2008/main';
    my $uri      = 'http://schemas.microsoft.com/office/mac/excel/2008/main';

    my @attributes = (
        'xmlns:mx' => $xmlns_mx,
        'uri'      => $uri,
    );

    $self->xml_start_tag( 'ext', @attributes );
    $self->_write_mx_arch_id();
    $self->xml_end_tag( 'ext' );
}

###############################################################################
#
# _write_mx_arch_id()
#
# Write <mx:ArchID> element.
#
sub _write_mx_arch_id {

    my $self  = shift;
    my $Flags = 2;

    my @attributes = ( 'Flags' => $Flags, );

    $self->xml_empty_tag( 'mx:ArchID', @attributes );
}


##############################################################################
#
# _write_defined_names()
#
# Write the <definedNames> element.
#
sub _write_defined_names {

    my $self = shift;

    return unless @{ $self->{_defined_names} };

    $self->xml_start_tag( 'definedNames' );

    for my $aref ( @{ $self->{_defined_names} } ) {
        $self->_write_defined_name( $aref );
    }

    $self->xml_end_tag( 'definedNames' );
}


##############################################################################
#
# _write_defined_name()
#
# Write the <definedName> element.
#
sub _write_defined_name {

    my $self = shift;
    my $data = shift;

    my $name   = $data->[0];
    my $id     = $data->[1];
    my $range  = $data->[2];
    my $hidden = $data->[3];

    my @attributes = ( 'name' => $name );

    push @attributes, ( 'localSheetId' => $id ) if $id != -1;
    push @attributes, ( 'hidden'       => 1 )   if $hidden;

    $self->xml_data_element( 'definedName', $range, @attributes );
}


1;


__END__


=head1 NAME

Workbook - A class for writing Excel Workbooks.

=head1 SYNOPSIS

See the documentation for L<Excel::Writer::XLSX>

=head1 DESCRIPTION

This module is used in conjunction with L<Excel::Writer::XLSX>.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

(c) MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.
