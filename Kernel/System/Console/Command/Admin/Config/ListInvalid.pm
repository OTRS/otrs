# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::Config::ListInvalid;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('List invalid system configuration.');

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @InvalidSettings = $SysConfigObject->ConfigurationInvalidList(
        Undeployed => 1,
        NoCache    => 1,
    );

    if ( !scalar @InvalidSettings ) {
        $Self->Print("<green>All settings are valid.</green>\n");
        return $Self->ExitCodeOk();
    }

    $Self->Print("<red>Following settings have invalid value:</red>\n");

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    for my $SettingName (@InvalidSettings) {
        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        my $EffectiveValue = $MainObject->Dump(
            $Setting{EffectiveValue},
        );

        $EffectiveValue =~ s/\$VAR1 = //;

        $Self->Print("    $SettingName = $EffectiveValue");
    }

    return $Self->ExitCodeError();
}

1;
