# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::Config::Update;

use strict;
use warnings;

use Kernel::System::VariableCheck qw( IsHashRefWithData );

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
    'Kernel::System::YAML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Update the value of a setting.');
    $Self->AddOption(
        Name        => 'setting-name',
        Description => "The name of the setting.",
        Required    => 1,
        HasValue    => 1,
        ValueRegex  => qr/.*/,
    );
    $Self->AddOption(
        Name        => 'source-path',
        Description => "Specify the source location of the setting value YAML file.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'value',
        Description => "Specify single line setting value.",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/.*/smx,
    );
    $Self->AddOption(
        Name        => 'valid',
        Description => "Specify validity of the setting ( 0 or 1 ).",
        Required    => 0,
        HasValue    => 1,
        ValueRegex  => qr/0|1/smx,
    );
    $Self->AddOption(
        Name        => 'reset',
        Description => "Reset setting to default value.",
        Required    => 0,
        HasValue    => 0,
    );
    $Self->AddOption(
        Name        => 'no-deploy',
        Description => "Specify that the update of this setting should not be deployed.",
        Required    => 0,
        HasValue    => 0,
        ValueRegex  => qr/.*/smx,
    );

    return;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # Perform any custom validations here. Command execution can be stopped with die().

    my %Setting = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
        Name    => $Self->GetOption('setting-name'),
        Default => 1,
    );

    if ( !%Setting ) {
        die "setting-name is invalid!";
    }

    return if $Self->GetOption('reset');
    return if defined $Self->GetOption('valid');

    my $SourcePath = $Self->GetOption('source-path');

    my $Value = $Self->GetOption('value');

    if ( $SourcePath && $Value ) {
        die "source-path or value is required but not both!";
    }

    if ( !$SourcePath && !defined $Value ) {
        die "source-path or value is required!";
    }

    if ( $SourcePath && !-e $SourcePath ) {
        die "File $SourcePath does not exists!";
    }

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $SettingReset = $Self->GetOption('reset');
    my $SettingValid = $Self->GetOption('valid');

    if ($SettingReset) {
        $Self->Print("<yellow>Resetting setting value...</yellow>\n\n");
    }
    elsif ( defined $SettingValid ) {
        $Self->Print("<yellow>Updating setting valid state...</yellow>\n\n");
    }
    else {
        $Self->Print("<yellow>Updating setting value...</yellow>\n\n");
    }

    my $SourcePath = $Self->GetOption('source-path');

    my $EffectiveValue = $Self->GetOption('value');

    if ($SourcePath) {

        my $YAMLContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location        => $SourcePath,
            Mode            => 'utf8',
            Type            => 'Local',
            Result          => 'SCALAR',
            DisableWarnings => 1,
        );

        if ( !$YAMLContentRef ) {
            $Self->PrintError("Could not read $SourcePath!");
            return $Self->ExitCodeError();
        }

        $EffectiveValue = $Kernel::OM->Get('Kernel::System::YAML')->Load(
            Data => ${$YAMLContentRef},
        );

        if ( !defined $EffectiveValue ) {
            $Self->PrintError("The content of $SourcePath is invalid");
            return $Self->ExitCodeError();
        }
    }

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $SettingName = $Self->GetOption('setting-name');

    # Get default setting.
    my %Setting = $SysConfigObject->SettingGet(
        Name    => $SettingName,
        Default => 1,
    );

    if ( !IsHashRefWithData( \%Setting ) ) {
        $Self->PrintError("Setting doesn't exists!");
        return $Self->ExitCodeError();
    }

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        UserID    => 1,
        Force     => 1,
        DefaultID => $Setting{DefaultID},
    );

    my $Success;
    if ($SettingReset) {
        $Success = $SysConfigObject->SettingReset(
            Name              => $SettingName,
            TargetUserID      => 1,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Success ) {
            $Self->PrintError("Setting could not be resetted!");
            return $Self->ExitCodeError();
        }
    }
    elsif ( defined $SettingValid ) {

        # Get current setting value.
        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        # Update setting with modified 'IsValid' param.
        $Success = $SysConfigObject->SettingUpdate(
            Name              => $SettingName,
            IsValid           => $SettingValid,
            EffectiveValue    => $Setting{EffectiveValue},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );
        if ( !$Success ) {
            $Self->PrintError("Setting valid state could not be updated!");
            return $Self->ExitCodeError();
        }
    }
    else {
        $Success = $SysConfigObject->SettingUpdate(
            Name              => $SettingName,
            EffectiveValue    => $EffectiveValue,
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => 1,
        );

        if ( !$Success ) {
            $Self->PrintError("Setting could not be updated!");
            return $Self->ExitCodeError();
        }
    }

    $Success = $SysConfigObject->SettingUnlock(
        UserID    => 1,
        DefaultID => $Setting{DefaultID},
    );

    if ( $Self->GetOption('no-deploy') ) {
        $Self->Print("<green>Done.</green>\n");
        return $Self->ExitCodeOk();
    }

    my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
        Comments      => "Admin::Config::Update $SettingName",
        UserID        => 1,
        Force         => 1,
        DirtySettings => [$SettingName],
    );

    if ( !$DeploymentResult{Success} ) {
        $Self->PrintError("Deployment failed!\n");
        return $Self->ExitCodeError();
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
