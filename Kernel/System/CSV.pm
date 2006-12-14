# --
# Kernel/System/CSV.pm - all csv functions
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: CSV.pm,v 1.8 2006-12-14 12:07:58 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CSV;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.8 $';
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
    my $LogObject    = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $CSVObject = Kernel::System::CSV->new(
        LogObject => $LogObject,
    );

=cut

sub new {
    my $Type  = shift;
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
        Head => ['RowA', 'RowB', ],
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
    foreach (qw(Data)){
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
    my @Lines = split(/\n/, $Param{String});

    # get separator
    if (!defined($Param{Separator}) || $Param{Separator} eq '') {
        $Param{Separator} = ';';
    }
    foreach (@Lines) {
        my @Fields = split(/$Param{Separator}/, $_);
        push(@Array, \@Fields);
    }

    # text quoting
    if (defined($Param{Quote}) && $Param{Quote} ne '') {
        foreach my $Field (@Array) {
            foreach my $Index (0..scalar@{$Field}) {
                if (defined($Field->[$Index]) && $Field->[$Index] =~ /^$Param{Quote}(.*)$Param{Quote}$/) {
                    $Field->[$Index] = $1;
                }
            }
        }
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

$Revision: 1.8 $ $Date: 2006-12-14 12:07:58 $

=cut
