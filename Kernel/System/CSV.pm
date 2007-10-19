# --
# Kernel/System/CSV.pm - all csv functions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CSV.pm,v 1.13 2007-10-19 06:07:06 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CSV;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

=head1 NAME

Kernel::System::CSV - CVS lib

=head1 SYNOPSIS

All csv functions.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $CSVObject = Kernel::System::CSV->new(
        LogObject => $LogObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

=item Array2CSV()

Returns a csv formatted string based on a array with head data.

    $CSV = $CSVObject->Array2CSV(
        Head => ['RowA', 'RowB', ],   # optional
        Data => [
            [1,4],
            [7,3],
            [1,9],
            [34,4],
        ],
    );

=cut

sub Array2CSV {
    my ( $Self, %Param ) = @_;

    my $Output = '';
    my @Head   = ();
    my @Data   = ( ['##No Data##'] );

    # check required params
    for (qw(Data)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => "error", Message => "Got no $_ param!" );
            return;
        }
    }
    if ( $Param{Head} ) {
        @Head = @{ $Param{Head} };
    }
    if ( $Param{Data} ) {
        @Data = @{ $Param{Data} };
    }

    # if we have head param fill in header
    for my $Entry (@Head) {

        # csv quote
        $Entry =~ s/"/""/g if ($Entry);
        $Entry = '' if ( !defined($Entry) );
        $Output .= "\"$Entry\";";
    }
    if ($Output) {
        $Output .= "\n";
    }

    # fill in data
    for my $EntryRow (@Data) {
        for my $Entry ( @{$EntryRow} ) {
            # Copy $Entry because otherwise you maniplate the content
            # of the original $Param{Data}!!!! Array in Array Referenc
            my $Content = $Entry;

            # csv quote
            $Content =~ s/"/""/g if ($Content);
            $Content = '' if ( !defined($Content) );
            $Output .= "\"$Content\";";
        }
        $Output .= "\n";
    }

    return $Output;
}

=item CSV2Array()

Returns an array with parsed csv data.

    my $RefArray = $CSVObject->CSV2Array(
        String => $CSVString,
        Separator => ';', # optional separator (default is ;)
        Quote => '"',     # optional quote (default is ")
    );

=cut

sub CSV2Array {
    my ( $Self, %Param ) = @_;

    my @Array = ();

    # get separator
    if ( !defined( $Param{Separator} ) || $Param{Separator} eq '' ) {
        $Param{Separator} = ';';
    }

    # a better solution can be the use of
    # use Text::ParseWords;
    # for more information read "PerlKochbuch" page 32

    # get separator
    if ( !defined( $Param{Quote} ) ) {
        $Param{Quote} = '"';
    }

    # if you change the split options, remember that each value can include \n
    my @Lines = split( /$Param{Quote}$Param{Separator}\n/, $Param{String} );
    for my $Line (@Lines) {
        my @Fields = split( /$Param{Quote}$Param{Separator}$Param{Quote}/, $Line );
        $Fields[0] =~ s/^$Param{Quote}//mgs;

        for my $Field (@Fields) {
            $Field =~ s/$Param{Quote}$Param{Quote}/$Param{Quote}/g;
        }

        push( @Array, \@Fields );
    }

    return \@Array;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.13 $ $Date: 2007-10-19 06:07:06 $

=cut
