# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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
    'Kernel::System::YAML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('List invalid system configuration.');
    $Self->AddOption(
        Name        => 'export-to-path',
        Description => "Export list to a YAML file instead.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

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

    my $ExportToPath = $Self->GetOption('export-to-path');

    if ($ExportToPath) {
        $Self->Print("<red>Settings with invalid values have been found.</red>\n");
    }
    else {
        $Self->Print("<red>The following settings have an invalid value:</red>\n");
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my %EffectiveValues;
    SETTINGNAME:
    for my $SettingName (@InvalidSettings) {
        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        if ($ExportToPath) {
            $EffectiveValues{$SettingName} = $Setting{EffectiveValue};
            next SETTINGNAME;
        }

        my $EffectiveValue = $MainObject->Dump(
            $Setting{EffectiveValue},
        );

        $EffectiveValue =~ s/\$VAR1 = //;

        $Self->Print("    $SettingName = $EffectiveValue");
    }

    if ($ExportToPath) {

        my $EffectiveValuesYAML = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
            Data => \%EffectiveValues,
        );

        # Write settings to a file.
        my $FileLocation = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $ExportToPath,
            Content  => \$EffectiveValuesYAML,
            Mode     => 'utf8',
        );

        # Check if target file exists.
        if ( !$FileLocation ) {
            $Self->PrintError("Could not write file $ExportToPath!\nFail.\n");
            return $Self->ExitCodeError();
        }

        $Self->Print("<green>Done.</green>\n");
    }

    return $Self->ExitCodeError();
}

1;
