# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::Config::Read;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::SysConfig',
    'Kernel::System::Main',
    'Kernel::System::YAML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Gather the value of a setting.');
    $Self->AddOption(
        Name        => 'setting-name',
        Description => "The name of the setting.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/,
    );
    $Self->AddOption(
        Name        => 'target-path',
        Description => "Specify the output location of the setting value YAML file.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Gathering setting value...</yellow>\n");

    my $SettingName = $Self->GetOption('setting-name');

    my %Setting = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
        Name => $SettingName,
    );

    # Return if there was no setting.
    if ( !%Setting ) {
        $Self->Print("<red>Fail.</red>\n");
        return $Self->ExitCodeError();
    }

    # Return if setting is invalid or not visible
    if ( !$Setting{IsValid} || $Setting{IsInvisible} ) {
        $Self->PrintError("Setting is invalid!\nFail.");
        return $Self->ExitCodeError();
    }

    # Return if not effectiveValue.
    if ( !defined $Setting{EffectiveValue} ) {
        $Self->PrintError("No effective value found for setting: $SettingName!.\nFail.");
        return $Self->ExitCodeError();
    }

    # Dump config as string.
    my $TargetPath         = $Self->GetOption('target-path');
    my $EffectiveValueYAML = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
        Data => $Setting{EffectiveValue},
    );

    if ($TargetPath) {

        # Write configuration in a file.
        my $FileLocation = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location => $TargetPath,
            Content  => \$EffectiveValueYAML,
            Mode     => 'utf8',
        );

        # Check if target file exists.
        if ( !$FileLocation ) {
            $Self->PrintError("Could not write file $TargetPath!\nFail.\n");
            return $Self->ExitCodeError();
        }

        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    # Send value to standard output
    $Self->Print("\nSetting: <yellow>$SettingName</yellow>");
    if ( !ref $Setting{EffectiveValue} ) {
        $Self->Print("\n$Setting{EffectiveValue}\n\n");
    }
    else {
        $Self->Print(" (YAML)\n$EffectiveValueYAML\n");
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
