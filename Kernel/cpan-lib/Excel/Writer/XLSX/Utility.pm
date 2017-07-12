package Excel::Writer::XLSX::Utility;

###############################################################################
#
# Utility - Helper functions for Excel::Writer::XLSX.
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
use Exporter;
use warnings;
use autouse 'Date::Calc'  => qw(Delta_DHMS Decode_Date_EU Decode_Date_US);
use autouse 'Date::Manip' => qw(ParseDate Date_Init);

our $VERSION = '0.95';

# Row and column functions
my @rowcol = qw(
  xl_rowcol_to_cell
  xl_cell_to_rowcol
  xl_col_to_name
  xl_range
  xl_range_formula
  xl_inc_row
  xl_dec_row
  xl_inc_col
  xl_dec_col
);

# Date and Time functions
my @dates = qw(
  xl_date_list
  xl_date_1904
  xl_parse_time
  xl_parse_date
  xl_parse_date_init
  xl_decode_date_EU
  xl_decode_date_US
);

our @ISA         = qw(Exporter);
our @EXPORT_OK   = ();
our @EXPORT      = ( @rowcol, @dates, 'quote_sheetname' );
our %EXPORT_TAGS = (
    rowcol => \@rowcol,
    dates  => \@dates
);


###############################################################################
#
# xl_rowcol_to_cell($row, $col, $row_absolute, $col_absolute)
#
sub xl_rowcol_to_cell {

    my $row     = $_[0] + 1;          # Change from 0-indexed to 1 indexed.
    my $col     = $_[1];
    my $row_abs = $_[2] ? '$' : '';
    my $col_abs = $_[3] ? '$' : '';


    my $col_str = xl_col_to_name( $col, $col_abs );

    return $col_str . $row_abs . $row;
}


###############################################################################
#
# xl_cell_to_rowcol($string)
#
# Returns: ($row, $col, $row_absolute, $col_absolute)
#
# The $row_absolute and $col_absolute parameters aren't documented because they
# mainly used internally and aren't very useful to the user.
#
sub xl_cell_to_rowcol {

    my $cell = shift;

    return ( 0, 0, 0, 0 ) unless $cell;

    $cell =~ /(\$?)([A-Z]{1,3})(\$?)(\d+)/;

    my $col_abs = $1 eq "" ? 0 : 1;
    my $col     = $2;
    my $row_abs = $3 eq "" ? 0 : 1;
    my $row     = $4;

    # Convert base26 column string to number
    # All your Base are belong to us.
    my @chars = split //, $col;
    my $expn = 0;
    $col = 0;

    while ( @chars ) {
        my $char = pop( @chars );    # LS char first
        $col += ( ord( $char ) - ord( 'A' ) + 1 ) * ( 26**$expn );
        $expn++;
    }

    # Convert 1-index to zero-index
    $row--;
    $col--;

    return $row, $col, $row_abs, $col_abs;
}


###############################################################################
#
# xl_col_to_name($col, $col_absolute)
#
sub xl_col_to_name {

    my $col     = $_[0];
    my $col_abs = $_[1] ? '$' : '';
    my $col_str = '';

    # Change from 0-indexed to 1 indexed.
    $col++;

    while ( $col ) {

        # Set remainder from 1 .. 26
        my $remainder = $col % 26 || 26;

        # Convert the $remainder to a character. C-ishly.
        my $col_letter = chr( ord( 'A' ) + $remainder - 1 );

        # Accumulate the column letters, right to left.
        $col_str = $col_letter . $col_str;

        # Get the next order of magnitude.
        $col = int( ( $col - 1 ) / 26 );
    }

    return $col_abs . $col_str;
}


###############################################################################
#
# xl_range($row_1, $row_2, $col_1, $col_2, $row_abs_1, $row_abs_2, $col_abs_1, $col_abs_2)
#
sub xl_range {

    my ( $row_1,     $row_2,     $col_1,     $col_2 )     = @_[ 0 .. 3 ];
    my ( $row_abs_1, $row_abs_2, $col_abs_1, $col_abs_2 ) = @_[ 4 .. 7 ];

    my $range1 = xl_rowcol_to_cell( $row_1, $col_1, $row_abs_1, $col_abs_1 );
    my $range2 = xl_rowcol_to_cell( $row_2, $col_2, $row_abs_2, $col_abs_2 );

    return $range1 . ':' . $range2;
}


###############################################################################
#
# xl_range_formula($sheetname, $row_1, $row_2, $col_1, $col_2)
#
sub xl_range_formula {

    my ( $sheetname, $row_1, $row_2, $col_1, $col_2 ) = @_;

    $sheetname = quote_sheetname( $sheetname );

    my $range = xl_range( $row_1, $row_2, $col_1, $col_2, 1, 1, 1, 1 );

    return '=' . $sheetname . '!' . $range
}


###############################################################################
#
# quote_sheetname()
#
# Sheetnames used in references should be quoted if they contain any spaces,
# special characters or if they look like something that isn't a sheet name.
#
sub quote_sheetname {

    my $sheetname = $_[0];

    # Use Excel's conventions and quote the sheet name if it contains any
    # non-word character or if it isn't already quoted.
    if ( $sheetname =~ /\W/ && $sheetname !~ /^'/ ) {
        # Double quote any single quotes.
        $sheetname =~ s/'/''/g;
        $sheetname = q(') . $sheetname . q(');
    }

    return $sheetname;
}


###############################################################################
#
# xl_inc_row($string)
#
sub xl_inc_row {

    my $cell = shift;
    my ( $row, $col, $row_abs, $col_abs ) = xl_cell_to_rowcol( $cell );

    return xl_rowcol_to_cell( ++$row, $col, $row_abs, $col_abs );
}


###############################################################################
#
# xl_dec_row($string)
#
# Decrements the row number of an Excel cell reference in A1 notation.
# For example C4 to C3
#
# Returns: a cell reference string.
#
sub xl_dec_row {

    my $cell = shift;
    my ( $row, $col, $row_abs, $col_abs ) = xl_cell_to_rowcol( $cell );

    return xl_rowcol_to_cell( --$row, $col, $row_abs, $col_abs );
}


###############################################################################
#
# xl_inc_col($string)
#
# Increments the column number of an Excel cell reference in A1 notation.
# For example C3 to D3
#
# Returns: a cell reference string.
#
sub xl_inc_col {

    my $cell = shift;
    my ( $row, $col, $row_abs, $col_abs ) = xl_cell_to_rowcol( $cell );

    return xl_rowcol_to_cell( $row, ++$col, $row_abs, $col_abs );
}


###############################################################################
#
# xl_dec_col($string)
#
sub xl_dec_col {

    my $cell = shift;
    my ( $row, $col, $row_abs, $col_abs ) = xl_cell_to_rowcol( $cell );

    return xl_rowcol_to_cell( $row, --$col, $row_abs, $col_abs );
}


###############################################################################
#
# xl_date_list($years, $months, $days, $hours, $minutes, $seconds)
#
sub xl_date_list {

    return undef unless @_;

    my $years   = $_[0];
    my $months  = $_[1] || 1;
    my $days    = $_[2] || 1;
    my $hours   = $_[3] || 0;
    my $minutes = $_[4] || 0;
    my $seconds = $_[5] || 0;

    my @date = ( $years, $months, $days, $hours, $minutes, $seconds );
    my @epoch = ( 1899, 12, 31, 0, 0, 0 );

    ( $days, $hours, $minutes, $seconds ) = Delta_DHMS( @epoch, @date );

    my $date =
      $days + ( $hours * 3600 + $minutes * 60 + $seconds ) / ( 24 * 60 * 60 );

    # Add a day for Excel's missing leap day in 1900
    $date++ if ( $date > 59 );

    return $date;
}


###############################################################################
#
# xl_parse_time($string)
#
sub xl_parse_time {

    my $time = shift;

    if ( $time =~ /(\d+):(\d\d):?((?:\d\d)(?:\.\d+)?)?(?:\s+)?(am|pm)?/i ) {

        my $hours    = $1;
        my $minutes  = $2;
        my $seconds  = $3 || 0;
        my $meridian = lc( $4 || '' );

        # Normalise midnight and midday
        $hours = 0 if ( $hours == 12 && $meridian ne '' );

        # Add 12 hours to the pm times. Note: 12.00 pm has been set to 0.00.
        $hours += 12 if $meridian eq 'pm';

        # Calculate the time as a fraction of 24 hours in seconds
        return ( $hours * 3600 + $minutes * 60 + $seconds ) / ( 24 * 60 * 60 );

    }
    else {
        return undef;    # Not a valid time string
    }
}


###############################################################################
#
# xl_parse_date($string)
#
sub xl_parse_date {

    my $date = ParseDate( $_[0] );

    # Unpack the return value from ParseDate()
    my ( $years, $months, $days, $hours, undef, $minutes, undef, $seconds ) =
      unpack( "A4     A2      A2     A2      C        A2      C       A2",
        $date );

    # Convert to Excel date
    return xl_date_list( $years, $months, $days, $hours, $minutes, $seconds );
}


###############################################################################
#
# xl_parse_date_init("variable=value", ...)
#
sub xl_parse_date_init {

    Date_Init( @_ );    # How lazy is that.
}


###############################################################################
#
# xl_decode_date_EU($string)
#
sub xl_decode_date_EU {

    return undef unless @_;

    my $date = shift;
    my @date;
    my $time = 0;

    # Remove and decode the time portion of the string
    if ( $date =~ s/(\d+:\d\d:?(\d\d(\.\d+)?)?(\s+)?(am|pm)?)//i ) {
        $time = xl_parse_time( $1 );
    }

    # Return if the string is now blank, i.e. it contained a time only.
    return $time if $date =~ /^\s*$/;

    # Decode the date portion of the string
    @date = Decode_Date_EU( $date );
    return undef unless @date;

    return xl_date_list( @date ) + $time;
}


###############################################################################
#
# xl_decode_date_US($string)
#
sub xl_decode_date_US {

    return undef unless @_;

    my $date = shift;
    my @date;
    my $time = 0;

    # Remove and decode the time portion of the string
    if ( $date =~ s/(\d+:\d\d:?(\d\d(\.\d+)?)?(\s+)?(am|pm)?)//i ) {
        $time = xl_parse_time( $1 );
    }

    # Return if the string is now blank, i.e. it contained a time only.
    return $time if $date =~ /^\s*$/;

    # Decode the date portion of the string
    @date = Decode_Date_US( $date );
    return undef unless @date;

    return xl_date_list( @date ) + $time;
}


###############################################################################
#
# xl_decode_date_US($string)
#
sub xl_date_1904 {

    my $date = $_[0] || 0;

    if ( $date < 1462 ) {

        # before 1904
        $date = 0;
    }
    else {
        $date -= 1462;
    }

    return $date;
}


1;


__END__

=head1 NAME

Utility - Helper functions for L<Excel::Writer::XLSX>.

=head1 SYNOPSIS

Functions to help with some common tasks when using L<Excel::Writer::XLSX>.

These functions mainly relate to dealing with rows and columns in A1 notation and to handling dates and times.

    use Excel::Writer::XLSX::Utility;                     # Import everything

    ($row, $col)    = xl_cell_to_rowcol( 'C2' );          # (1, 2)
    $str            = xl_rowcol_to_cell( 1, 2 );          # C2
    $str            = xl_col_to_name( 702 );              # AAA
    $str            = xl_inc_col( 'Z1'  );                # AA1
    $str            = xl_dec_col( 'AA1' );                # Z1

    $date           = xl_date_list(2002, 1, 1);           # 37257
    $date           = xl_parse_date( '11 July 1997' );    # 35622
    $time           = xl_parse_time( '3:21:36 PM' );      # 0.64
    $date           = xl_decode_date_EU( '13 May 2002' ); # 37389

=head1 DESCRIPTION

This module provides a set of functions to help with some common tasks encountered when using the L<Excel::Writer::XLSX> module. The two main categories of function are:

Row and column functions: these are used to deal with Excel's A1 representation of cells. The functions in this category are:

    xl_rowcol_to_cell
    xl_cell_to_rowcol
    xl_col_to_name
    xl_range
    xl_range_formula
    xl_inc_row
    xl_dec_row
    xl_inc_col
    xl_dec_col

Date and Time functions: these are used to convert dates and times to the numeric format used by Excel. The functions in this category are:

    xl_date_list
    xl_date_1904
    xl_parse_time
    xl_parse_date
    xl_parse_date_init
    xl_decode_date_EU
    xl_decode_date_US

All of these functions are exported by default. However, you can use import lists if you wish to limit the functions that are imported:

    use Excel::Writer::XLSX::Utility;                  # Import everything
    use Excel::Writer::XLSX::Utility qw(xl_date_list); # xl_date_list only
    use Excel::Writer::XLSX::Utility qw(:rowcol);      # Row/col functions
    use Excel::Writer::XLSX::Utility qw(:dates);       # Date functions

=head1 ROW AND COLUMN FUNCTIONS

L<Excel::Writer::XLSX> supports two forms of notation to designate the position of cells: Row-column notation and A1 notation.

Row-column notation uses a zero based index for both row and column while A1 notation uses the standard Excel alphanumeric sequence of column letter and 1-based row. Columns range from A to XFD, i.e. 0 to 16,383, rows range from 0 to 1,048,575 in Excel 2007+. For example:

    (0, 0)      # The top left cell in row-column notation.
    ('A1')      # The top left cell in A1 notation.

    (1999, 29)  # Row-column notation.
    ('AD2000')  # The same cell in A1 notation.

Row-column notation is useful if you are referring to cells programmatically:

    for my $i ( 0 .. 9 ) {
        $worksheet->write( $i, 0, 'Hello' );    # Cells A1 to A10
    }

A1 notation is useful for setting up a worksheet manually and for working with formulas:

    $worksheet->write( 'H1', 200 );
    $worksheet->write( 'H2', '=H7+1' );

The functions in the following sections can be used for dealing with A1 notation, for example:

    ( $row, $col ) = xl_cell_to_rowcol('C2');    # (1, 2)
    $str           = xl_rowcol_to_cell( 1, 2 );  # C2


Cell references in Excel can be either relative or absolute. Absolute references are prefixed by the dollar symbol as shown below:

    A1      # Column and row are relative
    $A1     # Column is absolute and row is relative
    A$1     # Column is relative and row is absolute
    $A$1    # Column and row are absolute

An absolute reference only makes a difference if the cell is copied. Refer to the Excel documentation for further details. All of the following functions support absolute references.

=head2 xl_rowcol_to_cell($row, $col, $row_absolute, $col_absolute)

    Parameters: $row:           Integer
                $col:           Integer
                $row_absolute:  Boolean (1/0) [optional, default is 0]
                $col_absolute:  Boolean (1/0) [optional, default is 0]

    Returns:    A string in A1 cell notation


This function converts a zero based row and column cell reference to a A1 style string:

    $str = xl_rowcol_to_cell( 0, 0 );    # A1
    $str = xl_rowcol_to_cell( 0, 1 );    # B1
    $str = xl_rowcol_to_cell( 1, 0 );    # A2


The optional parameters C<$row_absolute> and C<$col_absolute> can be used to indicate if the row or column is absolute:

    $str = xl_rowcol_to_cell( 0, 0, 0, 1 );    # $A1
    $str = xl_rowcol_to_cell( 0, 0, 1, 0 );    # A$1
    $str = xl_rowcol_to_cell( 0, 0, 1, 1 );    # $A$1

See above for an explanation of absolute cell references.

=head2 xl_cell_to_rowcol($string)


    Parameters: $string         String in A1 format

    Returns:    List            ($row, $col)

This function converts an Excel cell reference in A1 notation to a zero based row and column. The function will also handle Excel's absolute, C<$>, cell notation.

    my ( $row, $col ) = xl_cell_to_rowcol('A1');      # (0, 0)
    my ( $row, $col ) = xl_cell_to_rowcol('B1');      # (0, 1)
    my ( $row, $col ) = xl_cell_to_rowcol('C2');      # (1, 2)
    my ( $row, $col ) = xl_cell_to_rowcol('$C2');     # (1, 2)
    my ( $row, $col ) = xl_cell_to_rowcol('C$2');     # (1, 2)
    my ( $row, $col ) = xl_cell_to_rowcol('$C$2');    # (1, 2)

=head2 xl_col_to_name($col, $col_absolute)

    Parameters: $col:           Integer
                $col_absolute:  Boolean (1/0) [optional, default is 0]

    Returns:    A column string name.


This function converts a zero based column reference to a string:

    $str = xl_col_to_name(0);      # A
    $str = xl_col_to_name(1);      # B
    $str = xl_col_to_name(702);    # AAA


The optional parameter C<$col_absolute> can be used to indicate if the column is absolute:

    $str = xl_col_to_name( 0, 0 );    # A
    $str = xl_col_to_name( 0, 1 );    # $A
    $str = xl_col_to_name( 1, 1 );    # $B

=head2 xl_range($row_1, $row_2, $col_1, $col_2, $row_abs_1, $row_abs_2, $col_abs_1, $col_abs_2)

    Parameters: $sheetname      String
                $row_1:         Integer
                $row_2:         Integer
                $col_1:         Integer
                $col_2:         Integer
                $row_abs_1:     Boolean (1/0) [optional, default is 0]
                $row_abs_2:     Boolean (1/0) [optional, default is 0]
                $col_abs_1:     Boolean (1/0) [optional, default is 0]
                $col_abs_2:     Boolean (1/0) [optional, default is 0]

    Returns:    A worksheet range formula as a string.

This function converts zero based row and column cell references to an A1 style range string:

    my $str = xl_range( 0, 9, 0, 0 );          # A1:A10
    my $str = xl_range( 1, 8, 2, 2 );          # C2:C9
    my $str = xl_range( 0, 3, 0, 4 );          # A1:E4
    my $str = xl_range( 0, 3, 0, 4, 1 );       # A$1:E4
    my $str = xl_range( 0, 3, 0, 4, 1, 1 );    # A$1:E$4

=head2 xl_range_formula($sheetname, $row_1, $row_2, $col_1, $col_2)

    Parameters: $sheetname      String
                $row_1:         Integer
                $row_2:         Integer
                $col_1:         Integer
                $col_2:         Integer

    Returns:    A worksheet range formula as a string.

This function converts zero based row and column cell references to an A1 style formula string:

    my $str = xl_range_formula( 'Sheet1', 0, 9,  0, 0 ); # =Sheet1!$A$1:$A$10
    my $str = xl_range_formula( 'Sheet2', 6, 65, 1, 1 ); # =Sheet2!$B$7:$B$66
    my $str = xl_range_formula( 'New data', 1, 8, 2, 2 );# ='New data'!$C$2:$C$9

This is useful for setting ranges in Chart objects:

    $chart->add_series(
        categories => xl_range_formula( 'Sheet1', 1, 9, 0, 0 ),
        values     => xl_range_formula( 'Sheet1', 1, 9, 1, 1 ),
    );

    # Which is the same as:

    $chart->add_series(
        categories => '=Sheet1!$A$2:$A$10',
        values     => '=Sheet1!$B$2:$B$10',
    );

=head2 xl_inc_row($string)


    Parameters: $string, a string in A1 format

    Returns:    Incremented string in A1 format

This functions takes a cell reference string in A1 notation and increments the row. The function will also handle Excel's absolute, C<$>, cell notation:

    my $str = xl_inc_row( 'A1' );      # A2
    my $str = xl_inc_row( 'B$2' );     # B$3
    my $str = xl_inc_row( '$C3' );     # $C4
    my $str = xl_inc_row( '$D$4' );    # $D$5

=head2 xl_dec_row($string)


    Parameters: $string, a string in A1 format

    Returns:    Decremented string in A1 format

This functions takes a cell reference string in A1 notation and decrements the row. The function will also handle Excel's absolute, C<$>, cell notation:

    my $str = xl_dec_row( 'A2' );      # A1
    my $str = xl_dec_row( 'B$3' );     # B$2
    my $str = xl_dec_row( '$C4' );     # $C3
    my $str = xl_dec_row( '$D$5' );    # $D$4

=head2 xl_inc_col($string)


    Parameters: $string, a string in A1 format

    Returns:    Incremented string in A1 format

This functions takes a cell reference string in A1 notation and increments the column. The function will also handle Excel's absolute, C<$>, cell notation:

    my $str = xl_inc_col( 'A1' );      # B1
    my $str = xl_inc_col( 'Z1' );      # AA1
    my $str = xl_inc_col( '$B1' );     # $C1
    my $str = xl_inc_col( '$D$5' );    # $E$5

=head2 xl_dec_col($string)

    Parameters: $string, a string in A1 format

    Returns:    Decremented string in A1 format

This functions takes a cell reference string in A1 notation and decrements the column. The function will also handle Excel's absolute, C<$>, cell notation:

    my $str = xl_dec_col( 'B1' );      # A1
    my $str = xl_dec_col( 'AA1' );     # Z1
    my $str = xl_dec_col( '$C1' );     # $B1
    my $str = xl_dec_col( '$E$5' );    # $D$5

=head1 TIME AND DATE FUNCTIONS

Dates and times in Excel are represented by real numbers, for example "Jan 1 2001 12:30 AM" is represented by the number 36892.521.

The integer part of the number stores the number of days since the epoch and the fractional part stores the percentage of the day in seconds.

A date or time in Excel is like any other number. To display the number as a date you must apply a number format to it: Refer to the C<set_num_format()> method in the Excel::Writer::XLSX documentation:

    $date = xl_date_list( 2001, 1, 1, 12, 30 );
    $format->set_num_format( 'mmm d yyyy hh:mm AM/PM' );
    $worksheet->write( 'A1', $date, $format );    # Jan 1 2001 12:30 AM

The date handling functions below are supplied for historical reasons. In the current version of the module it is easier to just use the C<write_date_time()> function to write dates or times. See the DATES AND TIME IN EXCEL section of the main L<Excel::Writer::XLSX> documentation for details.

In addition to using the functions below you must install the L<Date::Manip> and L<Date::Calc> modules. See L<REQUIREMENTS> and the individual requirements of each functions.

For a C<DateTime.pm> solution see the L<DateTime::Format::Excel> module.

=head2 xl_date_list($years, $months, $days, $hours, $minutes, $seconds)


    Parameters: $years:         Integer
                $months:        Integer [optional, default is 1]
                $days:          Integer [optional, default is 1]
                $hours:         Integer [optional, default is 0]
                $minutes:       Integer [optional, default is 0]
                $seconds:       Float   [optional, default is 0]

    Returns:    A number that represents an Excel date
                or undef for an invalid date.

    Requires:   Date::Calc

This function converts an array of data into a number that represents an Excel date. All of the parameters are optional except for C<$years>.

    $date1 = xl_date_list( 2002, 1, 2 );                # 2 Jan 2002
    $date2 = xl_date_list( 2002, 1, 2, 12 );            # 2 Jan 2002 12:00 pm
    $date3 = xl_date_list( 2002, 1, 2, 12, 30 );        # 2 Jan 2002 12:30 pm
    $date4 = xl_date_list( 2002, 1, 2, 12, 30, 45 );    # 2 Jan 2002 12:30:45 pm

This function can be used in conjunction with functions that parse date and time strings. In fact it is used in most of the following functions.

=head2 xl_parse_time($string)


    Parameters: $string, a textual representation of a time

    Returns:    A number that represents an Excel time
                or undef for an invalid time.

This function converts a time string into a number that represents an Excel time. The following time formats are valid:

    hh:mm       [AM|PM]
    hh:mm       [AM|PM]
    hh:mm:ss    [AM|PM]
    hh:mm:ss.ss [AM|PM]


The meridian, AM or PM, is optional and case insensitive. A 24 hour time is assumed if the meridian is omitted.

    $time1 = xl_parse_time( '12:18' );
    $time2 = xl_parse_time( '12:18:14' );
    $time3 = xl_parse_time( '12:18:14 AM' );
    $time4 = xl_parse_time( '1:18:14 AM' );

Time in Excel is expressed as a fraction of the day in seconds. Therefore you can calculate an Excel time as follows:

    $time = ( $hours * 3600 + $minutes * 60 + $seconds ) / ( 24 * 60 * 60 );

=head2 xl_parse_date($string)


    Parameters: $string, a textual representation of a date and time

    Returns:    A number that represents an Excel date
                or undef for an invalid date.

    Requires:   Date::Manip and Date::Calc

This function converts a date and time string into a number that represents an Excel date.

The parsing is performed using the C<ParseDate()> function of the L<Date::Manip> module. Refer to the C<Date::Manip> documentation for further information about the date and time formats that can be parsed. In order to use this function you will probably have to initialise some C<Date::Manip> variables via the C<xl_parse_date_init()> function, see below.

    xl_parse_date_init( "TZ=GMT", "DateFormat=non-US" );

    $date1 = xl_parse_date( "11/7/97" );
    $date2 = xl_parse_date( "Friday 11 July 1997" );
    $date3 = xl_parse_date( "10:30 AM Friday 11 July 1997" );
    $date4 = xl_parse_date( "Today" );
    $date5 = xl_parse_date( "Yesterday" );

Note, if you parse a string that represents a time but not a date this function will add the current date. If you want the time without the date you can do something like the following:

    $time  = xl_parse_date( "10:30 AM" );
    $time -= int( $time );

=head2 xl_parse_date_init("variable=value", ...)


    Parameters: A list of Date::Manip variable strings

    Returns:    A list of all the Date::Manip strings

    Requires:   Date::Manip

This function is used to initialise variables required by the L<Date::Manip> module. You should call this function before calling C<xl_parse_date()>. It need only be called once.

This function is a thin wrapper for the C<Date::Manip::Date_Init()> function. You can use C<Date_Init()>  directly if you wish. Refer to the C<Date::Manip> documentation for further information.

    xl_parse_date_init( "TZ=MST", "DateFormat=US" );
    $date1 = xl_parse_date( "11/7/97" );    # November 7th 1997

    xl_parse_date_init( "TZ=GMT", "DateFormat=non-US" );
    $date1 = xl_parse_date( "11/7/97" );    # July 11th 1997

=head2 xl_decode_date_EU($string)


    Parameters: $string, a textual representation of a date and time

    Returns:    A number that represents an Excel date
                or undef for an invalid date.

    Requires:   Date::Calc

This function converts a date and time string into a number that represents an Excel date.

The date parsing is performed using the C<Decode_Date_EU()> function of the L<Date::Calc> module. Refer to the C<Date::Calc> documentation for further information about the date formats that can be parsed. Also note the following from the C<Date::Calc> documentation:

"If the year is given as one or two digits only (i.e., if the year is less than 100), it is mapped to the window 1970 -2069 as follows:"

     0 <= $year <  70  ==>  $year += 2000;
    70 <= $year < 100  ==>  $year += 1900;

The time portion of the string is parsed using the C<xl_parse_time()> function described above.

Note: the EU in the function name means that a European date format is assumed if it is not clear from the string. See the first example below.

    $date1 = xl_decode_date_EU( "11/7/97" );                    #11 July 1997
    $date2 = xl_decode_date_EU( "Sat 12 Sept 1998" );
    $date3 = xl_decode_date_EU( "4:30 AM Sat 12 Sept 1998" );

=head2 xl_decode_date_US($string)


    Parameters: $string, a textual representation of a date and time

    Returns:    A number that represents an Excel date
                or undef for an invalid date.

    Requires:   Date::Calc

This function converts a date and time string into a number that represents an Excel date.

The date parsing is performed using the C<Decode_Date_US()> function of the L<Date::Calc> module. Refer to the C<Date::Calc> documentation for further information about the date formats that can be parsed. Also note the following from the C<Date::Calc> documentation:

"If the year is given as one or two digits only (i.e., if the year is less than 100), it is mapped to the window 1970 -2069 as follows:"

     0 <= $year <  70  ==>  $year += 2000;
    70 <= $year < 100  ==>  $year += 1900;

The time portion of the string is parsed using the C<xl_parse_time()> function described above.

Note: the US in the function name means that an American date format is assumed if it is not clear from the string. See the first example below.

    $date1 = xl_decode_date_US( "11/7/97" );                 # 7 November 1997
    $date2 = xl_decode_date_US( "Sept 12 Saturday 1998" );
    $date3 = xl_decode_date_US( "4:30 AM Sept 12 Sat 1998" );

=head2 xl_date_1904($date)


    Parameters: $date, an Excel date with a 1900 epoch

    Returns:    an Excel date with a 1904 epoch or zero if
                the $date is before 1904


This function converts an Excel date based on the 1900 epoch into a date based on the 1904 epoch.

    $date1 = xl_date_list( 2002, 1, 13 );    # 13 Jan 2002, 1900 epoch
    $date2 = xl_date_1904( $date1 );         # 13 Jan 2002, 1904 epoch

See also the C<set_1904()> workbook method in the L<Excel::Writer::XLSX> documentation.

=head1 REQUIREMENTS

The date and time functions require functions from the L<Date::Manip> and L<Date::Calc> modules. The required functions are "autoused" from these modules so that you do not have to install them unless you wish to use the date and time routines. Therefore it is possible to use the row and column functions without having C<Date::Manip> and C<Date::Calc> installed.

For more information about "autousing" refer to the documentation on the C<autouse> pragma.

=head1 BUGS

When using the autoused functions from C<Date::Manip> and C<Date::Calc> on Perl 5.6.0 with C<-w> you will get a warning like this:

    "Subroutine xxx redefined ..."

The current workaround for this is to put C<use warnings;> near the beginning of your program.

=head1 AUTHOR

John McNamara jmcnamara@cpan.org

=head1 COPYRIGHT

Copyright MM-MMXVI, John McNamara.

All Rights Reserved. This module is free software. It may be used, redistributed and/or modified under the same terms as Perl itself.

