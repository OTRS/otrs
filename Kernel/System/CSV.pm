# --
# Kernel/System/CSV.pm - all csv functions
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CSV.pm,v 1.3 2006-03-21 11:18:29 rk Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CSV;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 SYNOPSIS

All csv functions.

=head1 PUBLIC INTERFACE

=over 4

=item new()

create a object

  my $ConfigObject = Kernel::System::CSV->new();

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

returns a csv based on a array

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
    my @Head = ('##No Head Data##');
    if ($Param{Head}) {
        @Head = @{$Param{Head}};
    }
    my @Data = (['##No Data##']);
    if ($Param{Data}) {
        @Data = @{$Param{Data}};
    }

    foreach my $Entry (@Head) {
        # csv quote
        $Entry =~ s/"/""/g if ($Entry);
        $Entry = '' if (!defined($Entry));
        $Output .= "\"$Entry\";";
    }
    $Output .= "\n";

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

returns a array with csv data

    my $RefArray = $CSVObject->CSV2Array(
        String => $CSVString,
        Separator => ';',  # optional (default: ;)
        Quote => '"',  # optional (default: ")
    );

=cut

sub CSV2Array {
    my $Self = shift;
    my %Param = @_;
    # get separator
    if (!defined($Param{Separator}) || $Param{Separator} eq '') {
        $Param{Separator} = ';';
    }
    my @Array = ();
    my @Lines = split(/\\n/, $Param{String});
    foreach (@Lines) {
        my @Fields = split(/$Param{Separator}/, $_);
        push(@Array, \@Fields);
    }
    # text quoting
    if (defined($Param{Quote}) && $Param{Quote} ne '') {
        foreach my $Line (@Array) {
            foreach my $Index (0..$#{$Line}) {
                if ($Line->[$Index] =~ /^$Param{Quote}(.*)$Param{Quote}$/) {
                    $Line->[$Index] = $1;
                }
                else {
                    $Self->{LogObject}->Log(Priority => 'error', Message => "Text quoting error in CSV String!");
                    return 0;
                }
            }
        }
    }
    return \@Array;
 }


=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.3 $ $Date: 2006-03-21 11:18:29 $

=cut

1;

