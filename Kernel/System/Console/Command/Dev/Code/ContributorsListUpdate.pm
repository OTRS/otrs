# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Dev::Code::ContributorsListUpdate;

use strict;
use warnings;

use IO::File;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Update the list of contributors based on git commit information.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    chdir $Kernel::OM->Get('Kernel::Config')->Get('Home');

    my @Lines = qx{git log --format="%aN <%aE>"};
    my %Seen;
    map { $Seen{$_}++ } @Lines;

    my $FileHandle = IO::File->new( 'AUTHORS.md', 'w' );
    $FileHandle->print("The following persons contributed to OTRS:\n\n");

    AUTHOR:
    for my $Author ( sort keys %Seen ) {
        chomp $Author;
        if ( $Author =~ m/^[^<>]+ \s <>\s?$/smx ) {
            $Self->Print("<yellow>Could not find Author $Author, skipping.</yellow>\n");
            next AUTHOR;
        }
        $FileHandle->print("* $Author\n");
    }

    $FileHandle->close();

    return $Self->ExitCodeOk();
}

1;
