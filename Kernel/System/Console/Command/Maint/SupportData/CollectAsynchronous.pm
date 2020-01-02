# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::SupportData::CollectAsynchronous;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::SupportDataCollector',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Collect certain support data asynchronously.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Collecting asynchronous support data...</yellow>\n");

    my %Result = $Kernel::OM->Get('Kernel::System::SupportDataCollector')->CollectAsynchronous();

    if ( !$Result{Success} ) {
        $Self->PrintError("Asynchronous data collection was not successful.");
        $Self->PrintError("$Result{ErrorMessage}");
        return $Self->ExitCodeError();
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
