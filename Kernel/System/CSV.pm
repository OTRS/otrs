# --
# Kernel/System/CSV.pm - all csv functions
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: CSV.pm,v 1.1 2006-03-17 11:24:10 rk Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::CSV;

use strict;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.1 $';
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

    return $Self;
}


=item GenerateCSV()

returns a csv based on a array

    $CSV = $LayoutObject->OutputCSV(
        Head => ['RowA', 'RowB', ],
        Data => [
            [1,4],
            [7,3],
            [1,9],
            [34,4],
        ],
    );

=cut

sub GenerateCSV {
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



=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=head1 VERSION

$Revision: 1.1 $ $Date: 2006-03-17 11:24:10 $

=cut

1;

