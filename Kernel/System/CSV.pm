# --
# Kernel/System/CSV.pm - all csv functions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: CSV.pm,v 1.10 2007-01-20 23:11:33 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CSV;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.10 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # check needed objects
    foreach (qw(LogObject)) {
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
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my @Head = ();
    my @Data = (['##No Data##']);
    # check required params
    foreach (qw(Data)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => "error", Message => "Got no $_ param!");
            return;
        }
    }
    if ($Param{Head}) {
        @Head = @{$Param{Head}};
    }
    if ($Param{Data}) {
        @Data = @{$Param{Data}};
    }

    # if we have head param fill in header
    foreach my $Entry (@Head) {
        # csv quote
        $Entry =~ s/"/""/g if ($Entry);
        $Entry = '' if (!defined($Entry));
        $Output .= "\"$Entry\";";
    }
    if ($Output) {
        $Output .= "\n";
    }
    # fill in data
    foreach my $EntryRow (@Data) {
        foreach my $Entry (@{$EntryRow}) {
            # csv quote
            $Entry =~ s/"/""/g if ($Entry);
            $Entry = '' if (!defined($Entry));
            $Output .= "\"$Entry\";";
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
    my $Self = shift;
    my %Param = @_;
    my @Array = ();

    # get separator
    if (!defined($Param{Separator}) || $Param{Separator} eq '') {
        $Param{Separator} = ';';
    }

    # a better solution can be the use of
    # use Text::ParseWords;
    # for more information read "PerlKochbuch" page 32

    # get separator
    if (!defined($Param{Quote})) {
        $Param{Quote} = '"';
    }

    # if you change the split options, remember that each value can include \n
    my @Lines = split(/$Param{Quote}$Param{Separator}\n/, $Param{String});

    foreach (@Lines) {
        my @Fields = split(/$Param{Quote}$Param{Separator}$Param{Quote}/, $_);
        $Fields[0] =~ s/^$Param{Quote}//mgs;
        #$Fields[$#Fields] =~ s/$Param{Quote}$//mgs;

        push(@Array, \@Fields);
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

$Revision: 1.10 $ $Date: 2007-01-20 23:11:33 $

=cut