# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Loader::CacheGenerate;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Loader',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Generate the CSS/JS loader cache.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Generating loader cache files...</yellow>\n");

    # Force loader also on development systems where it might be turned off.
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'Loader::Enabled::JS',
        Value => 1,
    );
    $Kernel::OM->Get('Kernel::Config')->Set(
        Key   => 'Loader::Enabled::CSS',
        Value => 1,
    );
    my @FrontendModules = $Kernel::OM->Get('Kernel::System::Loader')->CacheGenerate();
    if ( !@FrontendModules ) {
        $Self->PrintError("Loader cache files could not be generated.");
        return $Self->ExitCodeError();
    }
    $Self->Print("<green>Done.</green>\n");

    return $Self->ExitCodeOk();
}

1;
