# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Console::Command::Admin::SysConifg::UnlockAll;

use strict;
use warnings;

use base qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::SysConfig',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Unlock all settings.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Unlocking all settings...</yellow>\n");

    my $Success = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingUnlock(
        UnlockAll => 1,
    );

    return $Self->ExitCodeError(1) if !$Success;

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
