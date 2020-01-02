# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Admin::Config::FixInvalid;

use strict;
use warnings;

use parent qw(Kernel::System::Console::BaseCommand);
use Kernel::System::VariableCheck qw( :all );

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Main',
    'Kernel::System::SysConfig',
    'Kernel::System::YAML',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Attempt to fix invalid system configuration settings.');
    $Self->AddOption(
        Name        => 'non-interactive',
        Description => 'Attempt to fix invalid settings without user interaction.',
        Required    => 0,
        HasValue    => 0,
    );

    $Self->AddOption(
        Name => 'values-from-path',
        Description =>
            "Read values for invalid settings from a YAML file instead of user input (takes precedence in non-interactive mode).",
        Required   => 0,
        HasValue   => 1,
        ValueRegex => qr/.*/smx,
    );

    $Self->AddOption(
        Name        => 'skip-missing',
        Description => 'Skip invalid settings whose XML configuration file is not present.',
        Required    => 0,
        HasValue    => 0,
    );

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $NonInteractive = $Self->GetOption('non-interactive') || 0;
    my $ValuesFromPath = $Self->GetOption('values-from-path');
    my $SkipMissing    = $Self->GetOption('skip-missing') || 0;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my @InvalidSettings = $SysConfigObject->ConfigurationInvalidList(
        Undeployed => 1,
        NoCache    => 1,
    );

    if ( !scalar @InvalidSettings ) {
        $Self->Print("<green>All settings are valid.</green>\n\n");

        $Self->Print("<green>Done.</green>\n") if !$NonInteractive;

        return $Self->ExitCodeOk();
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    if ($SkipMissing) {
        $Self->Print("<yellow>Skipping missing settings for now...</yellow>\n\n");
    }

    my $TargetValues;
    if ($ValuesFromPath) {

        my $Content = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $ValuesFromPath,
        );
        if ( !$Content ) {
            $Self->PrintError("Could not read YAML source from '$ValuesFromPath'.");
            return $Self->ExitCodeError();
        }

        $TargetValues = $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => ${$Content} );

        if ( !$TargetValues ) {
            $Self->PrintError('Could not parse YAML source.');
            return $Self->ExitCodeError();
        }
    }

    my @FixedSettings;
    my @NotFixedSettings;

    SETTING:
    for my $SettingName (@InvalidSettings) {
        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        # If we have a target value use it if it's valid - otherwise use normal flow.
        # This also works for missing xml files and non-entity types.
        if (
            $TargetValues
            && $TargetValues->{$SettingName}
            && $Self->_TryUpdateSetting(
                SettingName => $SettingName,
                Value       => $TargetValues->{$SettingName},
            )
            )
        {
            push @FixedSettings, $SettingName;
            $Self->Print("<green>Corrected setting via input file:</green> $SettingName\n");

            next SETTING;
        }

        # Skip setting if the original XML file does not exist.
        if ($SkipMissing) {
            my $XMLFilename = $Setting{XMLFilename};
            my $FilePath    = join '/',
                $Kernel::OM->Get('Kernel::Config')->Get('Home'),
                'Kernel/Config/Files/XML',
                $XMLFilename;

            next SETTING if !( -e $FilePath );
        }

        my $EntityType = $Setting{XMLContentRaw} =~ s{ \A .*? ValueEntityType=" ( [^"]* ) " .*? \z }{$1}xmsr;

        # Skip settings that are not related to the Entities.
        if ( $Setting{XMLContentRaw} eq $EntityType ) {    # non-match
            $Self->PrintWarning("$SettingName is not an entity value type, skipping...");
            push @NotFixedSettings, $SettingName;
            next SETTING;
        }

        # Skip settings without ValueEntityType.
        if ( !$EntityType ) {
            $Self->PrintWarning("System was unable to determine ValueEntityType for $SettingName, skipping...");
            push @NotFixedSettings, $SettingName;
            next SETTING;
        }

        # Check if Entity module exists.
        my $Loaded = $MainObject->Require(
            "Kernel::System::SysConfig::ValueType::Entity::$EntityType",
            Silent => 1,
        );

        if ( !$Loaded ) {
            $Self->PrintWarning("Kernel::System::SysConfig::ValueType::Entity::$EntityType not found, skipping...");
            push @NotFixedSettings, $SettingName;
            next SETTING;
        }

        my @List = $Kernel::OM->Get("Kernel::System::SysConfig::ValueType::Entity::$EntityType")->EntityValueList();

        if ( !scalar @List ) {
            $Self->PrintWarning("$EntityType list is empty, skipping...");
            push @NotFixedSettings, $SettingName;
            next SETTING;
        }

        # Non-interactive.
        if ($NonInteractive) {

            next SETTING if !$Self->_TryUpdateSetting(
                SettingName      => $SettingName,
                Value            => $List[0],             # Take first available option.
                NotFixedSettings => \@NotFixedSettings,
            );

            push @FixedSettings, $SettingName;
            $Self->Print("<green>Auto-corrected setting:</green> $SettingName\n");

            next SETTING;
        }

        # Ask user.
        $Self->Print("\n<yellow>$SettingName is invalid, select one of the choices below:</yellow>\n");

        my $Index = 1;
        for my $Item (@List) {
            $Self->Print("    [$Index] $Item\n");
            $Index++;
        }

        my $SelectedIndex;
        while (
            !$SelectedIndex
            || !IsPositiveInteger($SelectedIndex)
            || $SelectedIndex > scalar @List
            )
        {
            $Self->Print("\nYour choice: ");
            $SelectedIndex = <STDIN>;    ## no critic

            # Remove white space.
            $SelectedIndex =~ s{\s}{}smx;
        }

        next SETTING if !$Self->_TryUpdateSetting(
            SettingName      => $SettingName,
            Value            => $List[ $SelectedIndex - 1 ],
            NotFixedSettings => \@NotFixedSettings,
        );

        push @FixedSettings, $SettingName;
    }

    if ( scalar @FixedSettings ) {

        my %Result = $SysConfigObject->ConfigurationDeploy(
            Comments      => 'FixInvalid - Automatically fixed invalid settings',
            NoValidation  => 1,
            UserID        => 1,
            Force         => 1,
            DirtySettings => \@FixedSettings,
        );

        if ( !$Result{Success} ) {
            $Self->PrintError('Deployment failed!');
            return $Self->ExitCodeError();
        }

        $Self->Print("\n<green>Deployment successful.</green>\n");
    }

    if ( scalar @NotFixedSettings ) {
        $Self->Print(
            "\nFollowing settings were not fixed:\n"
                . join( ",\n", map {"  - $_"} @NotFixedSettings ) . "\n"
                . "\nPlease use console command (bin/otrs.Console.pl Admin::Config::Update --help) or GUI to fix them.\n\n"
        );
    }

    $Self->Print("<green>Done.</green>\n") if !$NonInteractive;

    return $Self->ExitCodeOk();
}

sub PrintWarning {
    my ( $Self, $Message ) = @_;

    return $Self->Print("<yellow>Warning: $Message</yellow>\n");
}

sub _TryUpdateSetting {
    my ( $Self, %Param ) = @_;

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        Name   => $Param{SettingName},
        Force  => 1,
        UserID => 1,
    );
    if ( !$ExclusiveLockGUID && $Param{NotFixedSettings} ) {
        $Self->PrintWarning("System was not able to lock the setting $Param{SettingName}, skipping...");
        push @{ $Param{NotFixedSettings} }, $Param{SettingName};
    }
    return if !$ExclusiveLockGUID;

    my %Update = $SysConfigObject->SettingUpdate(
        Name              => $Param{SettingName},
        IsValid           => 1,
        EffectiveValue    => $Param{Value},
        ExclusiveLockGUID => $ExclusiveLockGUID,
        UserID            => 1,
    );

    if ( !$Update{Success} && $Param{NotFixedSettings} ) {
        $Self->PrintWarning("System was not able to update the setting $Param{SettingName}, skipping...");
        push @{ $Param{NotFixedSettings} }, $Param{SettingName};
    }
    return if !$Update{Success};

    return 1;
}

1;
