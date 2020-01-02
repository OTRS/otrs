# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
## nofilter(TidyAll::Plugin::OTRS::Perl::LayoutObject)
package Kernel::System::SysConfig;

use strict;
use warnings;

use Time::HiRes();
use utf8;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);
use Kernel::Config;

use parent qw(Kernel::System::AsynchronousExecutor);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Language',
    'Kernel::Output::HTML::SysConfig',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Package',
    'Kernel::System::Storable',
    'Kernel::System::SysConfig::DB',
    'Kernel::System::SysConfig::Migration',
    'Kernel::System::SysConfig::XML',
    'Kernel::System::User',
    'Kernel::System::YAML',
);

=head1 NAME

Kernel::System::SysConfig - Functions to manage system configuration settings.

=head1 DESCRIPTION

All functions to manage system configuration settings.

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

=cut

## no critic (StringyEval)

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{ConfigObject} = $Kernel::OM->Get('Kernel::Config');

    # get home directory
    $Self->{Home} = $Self->{ConfigObject}->Get('Home');

    # set utf-8 if used
    $Self->{utf8}     = 1;
    $Self->{FileMode} = ':utf8';

    $Self->{ConfigDefaultObject} = Kernel::Config->new( Level => 'Default' );
    $Self->{ConfigObject}        = Kernel::Config->new( Level => 'First' );
    $Self->{ConfigClearObject}   = Kernel::Config->new( Level => 'Clear' );

    # Load base files.
    my $BaseDir = $Self->{Home} . '/Kernel/System/SysConfig/Base/';

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    FILENAME:
    for my $Filename (qw(Framework.pm OTRSBusiness.pm)) {
        my $BaseFile = $BaseDir . $Filename;
        next FILENAME if !-e $BaseFile;

        $BaseFile =~ s{\A.*\/(.+?).pm\z}{$1}xms;
        my $BaseClassName = "Kernel::System::SysConfig::Base::$BaseFile";
        if ( !$MainObject->RequireBaseClass($BaseClassName) ) {
            $Self->FatalDie(
                Message => "Could not load class $BaseClassName.",
            );
        }

    }

    return $Self;
}

=head2 SettingGet()

Get SysConfig setting attributes.

    my %Setting = $SysConfigObject->SettingGet(
        Name            => 'Setting::Name',  # (required) Setting name
        Default         => 1,                # (optional) Returns the default setting attributes only
        ModifiedID      => '123',            # (optional) Get setting value for given ModifiedID.
        TargetUserID    => 1,                # (optional) Get setting value for specific user.
        Deployed        => 1,                # (optional) Get deployed setting value. Default 0.
        OverriddenInXML => 1,                # (optional) Consider changes made in perl files. Default 0.
        Translate       => 1,                # (optional) Translate translatable strings in EffectiveValue. Default 0.
        NoLog           => 1,                # (optional) Do not log error if a setting does not exist.
        NoCache         => 1,                # (optional) Do not create cache.
        UserID          => 1,                # Required only if OverriddenInXML is set.
    );

Returns:

    %Setting = (
        DefaultID                => 123,
        ModifiedID               => 456,         # optional
        Name                     => "ProductName",
        Description              => "Defines the name of the application ...",
        Navigation               => "ASimple::Path::Structure",
        IsInvisible              => 1,           # 1 or 0
        IsReadonly               => 0,           # 1 or 0
        IsRequired               => 1,           # 1 or 0
        IsModified               => 1,           # 1 or 0
        IsValid                  => 1,           # 1 or 0
        HasConfigLevel           => 200,
        UserModificationPossible => 0,           # 1 or 0
        UserModificationActive   => 0,           # 1 or 0
        UserPreferencesGroup     => 'Advanced',  # optional
        XMLContentRaw            => "The XML structure as it is on the config file",
        XMLContentParsed         => "XML parsed to Perl",
        XMLFilename              => "Framework.xml",
        EffectiveValue           => "Product 6",
        IsDirty                  => 1,           # 1 or 0
        ExclusiveLockGUID        => 'A32CHARACTERLONGSTRINGFORLOCKING',
        ExclusiveLockUserID      => 1,
        ExclusiveLockExpiryTime  => '2016-05-29 11:09:04',
        CreateTime               => "2016-05-29 11:04:04",
        CreateBy                 => 1,
        ChangeTime               => "2016-05-29 11:04:04",
        ChangeBy                 => 1,
        DefaultValue             => 'Old default value',
        OverriddenFileName        => '/opt/otrs/Kernel/Config/Files/ZZZ.pm',
    );

=cut

sub SettingGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{Name} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need Name!',
        );
        return;
    }

    if ( $Param{OverriddenInXML} && !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'UserID is needed when OverriddenInXML is set!',
        );
        return;
    }

    $Param{Translate} //= 0;    # don't translate by default

    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Get default setting.
    my %Setting = $SysConfigDBObject->DefaultSettingGet(
        Name    => $Param{Name},
        NoCache => $Param{NoCache},
    );

    # setting was not found
    if ( !%Setting ) {

        # do not log an error if parameter NoLog is true
        if ( !$Param{NoLog} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Setting $Param{Name} is invalid!",
            );
        }

        return;
    }

    $Setting{DefaultValue} = $Setting{EffectiveValue};

    # Return default setting if specified (otherwise continue with modified setting).
    if ( $Param{Default} ) {
        return %Setting;
    }

    # Check if modified setting available
    my %ModifiedSetting;
    if ( $Param{ModifiedID} ) {

        # Get settings with given ModifiedID.
        %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            ModifiedID => $Param{ModifiedID},
            IsGlobal   => 1,
            NoCache    => $Param{NoCache},
        );

        # prevent using both parameters.
        $Param{Deployed}     = undef;
        $Param{TargetUserID} = undef;
    }
    else {

        # Get latest modified setting.
        %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            Name     => $Param{Name},
            IsGlobal => 1,
            NoCache  => $Param{NoCache},
        );
    }

    if ( $Param{TargetUserID} ) {

        if ( IsHashRefWithData( \%ModifiedSetting ) ) {

            # There is modified setting, but we need last deployed version.
            %ModifiedSetting = $SysConfigDBObject->ModifiedSettingVersionGetLast(
                Name => $ModifiedSetting{Name},
            );

            # Use global (deployed) modified settings as "default" (if any)
            if ( IsHashRefWithData( \%ModifiedSetting ) ) {
                %Setting = (
                    %Setting,
                    %ModifiedSetting,
                );
            }
        }

        # get user specific settings
        %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            Name         => $Param{Name},
            TargetUserID => $Param{TargetUserID},
        );

        # prevent using both parameters.
        $Param{Deployed} = undef;
    }

    if ( $Param{Deployed} ) {

        # get the previous deployed state of this setting
        my %SettingDeployed = $SysConfigDBObject->ModifiedSettingVersionGetLast(
            Name => $Setting{Name},
        );

        if ( !IsHashRefWithData( \%SettingDeployed ) ) {

            # if this setting was never deployed before, get the default state

            # Get default version.
            %SettingDeployed = $SysConfigDBObject->DefaultSettingGet(
                DefaultID => $Setting{DefaultID},
                NoCache   => $Param{NoCache},
            );
        }

        if ( IsHashRefWithData( \%SettingDeployed ) ) {
            %Setting = (
                %Setting,
                %SettingDeployed
            );
        }
    }

    # default
    $Setting{IsModified} = 0;

    if ( IsHashRefWithData( \%ModifiedSetting ) ) {

        my $IsModified = DataIsDifferent(
            Data1 => \$Setting{EffectiveValue},
            Data2 => \$ModifiedSetting{EffectiveValue},
        ) || 0;

        $IsModified ||= $ModifiedSetting{IsValid} != $Setting{IsValid};
        $IsModified ||= $ModifiedSetting{UserModificationActive} != $Setting{UserModificationActive};

        $Setting{IsModified} = $IsModified ? 1 : 0;

        if ( !$Param{Deployed} ) {

            # Update setting attributes.
            ATTRIBUTE:
            for my $Attribute (
                qw(ModifiedID IsValid UserModificationActive EffectiveValue IsDirty
                CreateTime CreateBy ChangeTime ChangeBy SettingUID
                )
                )
            {
                next ATTRIBUTE if !defined $ModifiedSetting{$Attribute};

                $Setting{$Attribute} = $ModifiedSetting{$Attribute};
            }
        }
    }

    if ( $Param{OverriddenInXML} ) {

        # get the previous deployed state of this setting
        my %SettingDeployed = $SysConfigDBObject->ModifiedSettingVersionGetLast(
            Name => $Setting{Name},
        );

        if ( !IsHashRefWithData( \%SettingDeployed ) ) {

            # if this setting was never deployed before, get the default state

            # Get default version.
            %SettingDeployed = $SysConfigDBObject->DefaultSettingGet(
                DefaultID => $Setting{DefaultID},
                NoCache   => $Param{NoCache},
            );
        }

        # Get real EffectiveValue - EffectiveValue from DB could be modified in the ZZZAbc.pm file.
        my $LoadedEffectiveValue = $Self->GlobalEffectiveValueGet(
            SettingName => $Setting{Name},
        );

        my $IsOverridden = DataIsDifferent(
            Data1 => $SettingDeployed{EffectiveValue} // {},
            Data2 => $LoadedEffectiveValue            // {},
        );

        if ($IsOverridden) {
            $Setting{OverriddenFileName} = $Self->OverriddenFileNameGet(
                SettingName    => $Setting{Name},
                EffectiveValue => $Setting{EffectiveValue},
                UserID         => $Param{UserID},
            );

            # Update EffectiveValue.
            if ( $Setting{OverriddenFileName} ) {
                $Setting{EffectiveValue} = $LoadedEffectiveValue;
            }
        }
    }

    if ( $Param{Translate} ) {

        if (%ModifiedSetting) {
            $Setting{XMLContentParsed}->{Value} = $Self->SettingModifiedXMLContentParsedGet(
                ModifiedSetting => {
                    EffectiveValue => $Setting{EffectiveValue},
                },
                DefaultSetting => {
                    XMLContentParsed => $Setting{XMLContentParsed},
                },
            );
        }

        # Update EffectiveValue with translated strings
        $Setting{EffectiveValue} = $Self->SettingEffectiveValueGet(
            Value     => $Setting{XMLContentParsed}->{Value},
            Translate => 1,
        );

        $Setting{Description} = $Kernel::OM->Get('Kernel::Language')->Translate(
            $Setting{Description},
        );
    }

    # If setting is overridden in the perl file, using the "delete" statement, EffectiveValue is undef.
    $Setting{EffectiveValue} //= '';

    # Return updated default.
    return %Setting;
}

=head2 SettingUpdate()

Update an existing SysConfig Setting.

    my %Result = $SysConfigObject->SettingUpdate(
        Name                   => 'Setting::Name',           # (required) setting name
        IsValid                => 1,                         # (optional) 1 or 0, modified 0
        EffectiveValue         => $SettingEffectiveValue,    # (optional)
        UserModificationActive => 0,                         # (optional) 1 or 0, modified 0
        TargetUserID           => 2,                         # (optional) ID of the user for which the modified setting is meant,
                                                             #   leave it undef for global changes.
        ExclusiveLockGUID      => $LockingString,            # the GUID used to locking the setting
        UserID                 => 1,                         # (required) UserID
        NoValidation           => 1,                         # (optional) no value type validation.
    );

Returns:

    %Result = (
        Success => 1,        # or false in case of an error
        Error   => undef,    # error message
    );

=cut

sub SettingUpdate {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Name UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    if ( !$Param{TargetUserID} && !$Param{ExclusiveLockGUID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need TargetUserID or ExclusiveLockGUID!",
        );
    }

    my %Result = (
        Success => 1,
    );

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Get default setting
    my %Setting = $SysConfigDBObject->DefaultSettingGet(
        Name => $Param{Name},
    );

    # Make sure that required settings can't be disabled.
    if ( $Setting{IsRequired} ) {
        $Param{IsValid} = 1;
    }

    # Return if setting does not exists.
    if ( !%Setting ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Setting $Param{Name} does not exists!",
        );

        %Result = (
            Success => 0,
            Error   => $Kernel::OM->Get('Kernel::Language')->Translate(
                "Setting %s does not exists!",
                $Param{Name},
            ),
        );
        return %Result;
    }

    # Default should be locked (for global updates).
    my $LockedByUser;
    if ( !$Param{TargetUserID} ) {
        $LockedByUser = $SysConfigDBObject->DefaultSettingIsLockedByUser(
            DefaultID           => $Setting{DefaultID},
            ExclusiveLockUserID => $Param{UserID},
            ExclusiveLockGUID   => $Param{ExclusiveLockGUID},
        );

        if ( !$LockedByUser ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Setting $Param{Name} is not locked to this user!",
            );

            %Result = (
                Success => 0,
                Error   => $Kernel::OM->Get('Kernel::Language')->Translate(
                    "Setting %s is not locked to this user!",
                    $Param{Name},
                ),
            );
            return %Result;
        }
    }

    # Do not perform EffectiveValueCheck if user wants to disable the setting.
    if ( $Param{IsValid} ) {

        # Effective value must match in structure to the default and individual values should be
        #   valid according to its value types.
        my %EffectiveValueCheck = $Self->SettingEffectiveValueCheck(
            XMLContentParsed => $Setting{XMLContentParsed},
            EffectiveValue   => $Param{EffectiveValue},
            NoValidation     => $Param{NoValidation} //= 0,
            UserID           => $Param{UserID},
        );

        if ( !$EffectiveValueCheck{Success} ) {
            my $Error = $EffectiveValueCheck{Error} || 'Unknown error!';

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "EffectiveValue is invalid! $Error",
            );

            %Result = (
                Success => 0,
                Error   => $Kernel::OM->Get('Kernel::Language')->Translate(
                    "Setting value is not valid!",
                ),
            );
            return %Result;
        }
    }

    # Get modified setting (if any).
    my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
        Name     => $Param{Name},
        IsGlobal => 1,
    );

    if ( !defined $Param{EffectiveValue} ) {

        # In the case that we want only to enable/disable setting,
        #    old effective value will be preserved.
        $Param{EffectiveValue} = $ModifiedSetting{EffectiveValue} // $Setting{EffectiveValue};
    }

    my $UserModificationActive = $Param{UserModificationActive} //= $Setting{UserModificationActive};

    if ( $Param{TargetUserID} ) {
        if ( IsHashRefWithData( \%ModifiedSetting ) ) {

            # override default setting with global modified setting
            %Setting = (
                %Setting,
                %ModifiedSetting,
            );
        }

        %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            Name         => $Param{Name},
            TargetUserID => $Param{TargetUserID},
        );

        $UserModificationActive = undef;    # prevent setting this value

        my %GlobalSetting = $Self->SettingGet(
            Name            => $Param{Name},
            OverriddenInXML => 1,
            UserID          => 1,
        );

        $Setting{EffectiveValue} = $GlobalSetting{EffectiveValue};
    }

    # Add new modified setting (if there wasn't).
    if ( !%ModifiedSetting ) {

        # Check if provided EffectiveValue is same as in Default
        my $IsDifferent = DataIsDifferent(
            Data1 => \$Setting{EffectiveValue},
            Data2 => \$Param{EffectiveValue},
        ) || 0;

        if ( defined $Param{IsValid} ) {
            $IsDifferent ||= $Setting{IsValid} != $Param{IsValid};
        }

        $IsDifferent ||= $Setting{UserModificationActive} != $Param{UserModificationActive};

        if ($IsDifferent) {

            my $ModifiedID = $SysConfigDBObject->ModifiedSettingAdd(
                DefaultID              => $Setting{DefaultID},
                Name                   => $Setting{Name},
                IsValid                => $Param{IsValid} //= $Setting{IsValid},
                EffectiveValue         => $Param{EffectiveValue},
                UserModificationActive => $UserModificationActive,
                TargetUserID           => $Param{TargetUserID},
                ExclusiveLockGUID      => $Param{ExclusiveLockGUID},
                UserID                 => $Param{UserID},
            );
            if ( !$ModifiedID ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not add modified setting!",
                );
                %Result = (
                    Success => 0,
                    Error   => $Kernel::OM->Get('Kernel::Language')->Translate(
                        "Could not add modified setting!",
                    ),
                );
                return %Result;
            }
        }
    }
    else {

        # Check if provided EffectiveValue is same as in last modified EffectiveValue
        my $IsDifferent = DataIsDifferent(
            Data1 => \$ModifiedSetting{EffectiveValue},
            Data2 => \$Param{EffectiveValue},
        ) || 0;

        if ( defined $Param{IsValid} ) {
            $IsDifferent ||= $ModifiedSetting{IsValid} != $Param{IsValid};
        }

        $IsDifferent ||= $ModifiedSetting{UserModificationActive} != $Param{UserModificationActive};

        if ($IsDifferent) {

            my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGetLast(
                Name => $ModifiedSetting{Name},
            );

            my $EffectiveValueModifiedSinceDeployment = 1;
            if ( $ModifiedSettingVersion{ModifiedVersionID} ) {

                my %ModifiedSettingLastDeployed = $SysConfigDBObject->ModifiedSettingVersionGet(
                    ModifiedVersionID => $ModifiedSettingVersion{ModifiedVersionID},
                );

                $EffectiveValueModifiedSinceDeployment = DataIsDifferent(
                    Data1 => \$ModifiedSettingLastDeployed{EffectiveValue},
                    Data2 => \$Param{EffectiveValue},
                ) || 0;

                if ( defined $Param{IsValid} ) {
                    $EffectiveValueModifiedSinceDeployment ||= $ModifiedSettingLastDeployed{IsValid} != $Param{IsValid};
                }

                $EffectiveValueModifiedSinceDeployment
                    ||= $ModifiedSettingLastDeployed{UserModificationActive} != $Param{UserModificationActive};

            }
            elsif ( !IsHashRefWithData( \%ModifiedSettingVersion ) ) {
                $EffectiveValueModifiedSinceDeployment = DataIsDifferent(
                    Data1 => \$Setting{EffectiveValue},
                    Data2 => \$Param{EffectiveValue},
                ) || 0;

                if ( defined $Param{IsValid} ) {
                    $EffectiveValueModifiedSinceDeployment ||= $Setting{IsValid} != $Param{IsValid};
                }

                $EffectiveValueModifiedSinceDeployment
                    ||= $Setting{UserModificationActive} != $Param{UserModificationActive};
            }

            # Update the existing modified setting.
            my $Success = $SysConfigDBObject->ModifiedSettingUpdate(
                ModifiedID             => $ModifiedSetting{ModifiedID},
                DefaultID              => $Setting{DefaultID},
                Name                   => $Setting{Name},
                IsValid                => $Param{IsValid} //= $ModifiedSetting{IsValid},
                EffectiveValue         => $Param{EffectiveValue},
                UserModificationActive => $UserModificationActive,
                TargetUserID           => $Param{TargetUserID} //= $ModifiedSetting{TargetUserID},
                ExclusiveLockGUID      => $Param{ExclusiveLockGUID},
                UserID                 => $Param{UserID},
                IsDirty                => $EffectiveValueModifiedSinceDeployment ? 1 : 0,
            );
            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not update modified setting!",
                );
                %Result = (
                    Success => 0,
                    Error   => $Kernel::OM->Get('Kernel::Language')->Translate(
                        "Could not update modified setting!",
                    ),
                );
                return %Result;
            }
        }
    }

    # When a setting is set to invalid all modified settings for users has to be removed.
    if (
        !$Param{IsValid}
        && !$Param{TargetUserID}
        && $Self->can('UserSettingValueDelete')    # OTRS Business Solution™
        )
    {
        $Self->UserSettingValueDelete(
            Name       => $Setting{Name},
            ModifiedID => 'All',
            UserID     => $Param{UserID},
        );
    }

    if ( !$Param{TargetUserID} ) {

        # Unlock setting so it can be locked again afterwards.
        my $Success = $SysConfigDBObject->DefaultSettingUnlock(
            DefaultID => $Setting{DefaultID},
        );
        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Setting could not be unlocked!",
            );
            %Result = (
                Success => 0,
                Error   => $Kernel::OM->Get('Kernel::Language')->Translate(
                    "Setting could not be unlocked!",
                ),
            );
            return %Result;
        }
    }

    return %Result;
}

=head2 SettingLock()

Lock setting(s) to the particular user.

    my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
        DefaultID => 1,                     # the ID of the setting that needs to be locked
                                            #    or
        Name      => 'SettingName',         # the Name of the setting that needs to be locked
                                            #    or
        LockAll   => 1,                     # system locks all settings
        Force     => 1,                     # (optional) Force locking (do not check if it's already locked by another user). Default: 0.
        UserID    => 1,                     # (required)
    );

Returns:

    $ExclusiveLockGUID = 'azzHab72wIlAXDrxHexsI5aENsESxAO7';     # Setting locked

    or

    $ExclusiveLockGUID = undef;     # Not locked

=cut

sub SettingLock {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DefaultSettingLock(%Param);
}

=head2 SettingUnlock()

Unlock particular or all Setting(s).

    my $Success = $SysConfigObject->SettingUnlock(
        DefaultID => 1,                     # the ID of the setting that needs to be unlocked
                                            #   or
        Name      => 'SettingName',         # the name of the setting that needs to be locked
                                            #   or
        UnlockAll => 1,                     # unlock all settings
    );

Returns:

    $Success = 1;

=cut

sub SettingUnlock {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DefaultSettingUnlock(%Param);
}

=head2 SettingLockCheck()

Check setting lock status.

    my %Result = $SysConfigObject->SettingLockCheck(
        DefaultID           => 1,                     # the ID of the setting that needs to be checked
        ExclusiveLockGUID   => 1,                     # lock GUID
        ExclusiveLockUserID => 1,                     # UserID
    );

Returns:

    %Result = (
        Locked => 1,                        # lock status;
                                            # 0 - unlocked
                                            # 1 - locked to another user
                                            # 2 - locked to provided user
        User   => {                         # User data, provided only if Locked = 1
            UserLogin => ...,
            UserFirstname => ...,
            UserLastname => ...,
            ...
        },
    );

=cut

sub SettingLockCheck {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(DefaultID ExclusiveLockGUID ExclusiveLockUserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my %Result = (
        Locked => 0,
    );

    my $LockedByUser = $SysConfigDBObject->DefaultSettingIsLockedByUser(
        DefaultID           => $Param{DefaultID},
        ExclusiveLockUserID => $Param{ExclusiveLockUserID},
        ExclusiveLockGUID   => $Param{ExclusiveLockGUID},
    );

    if ($LockedByUser) {

        # setting locked to the provided user
        $Result{Locked} = 2;
    }
    else {
        # check if setting is locked to another user
        my $UserID = $SysConfigDBObject->DefaultSettingIsLocked(
            DefaultID     => $Param{DefaultID},
            GetLockUserID => 1,
        );

        if ($UserID) {

            # get user data
            $Result{Locked} = 1;

            my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
                UserID => $UserID,
            );

            $Result{User} = \%User;
        }
    }

    return %Result;
}

=head2 SettingEffectiveValueGet()

Calculate effective value for a given parsed XML structure.

    my $Result = $SysConfigObject->SettingEffectiveValueGet(
        Translate => 1,                      # (optional) Translate translatable strings. Default 0.
        Value  => [                          # (required) parsed XML structure
            {
                'Item' => [
                    {
                        'ValueType' => 'String',
                        'Content' => '3600',
                        'ValueRegex' => ''
                    },
                ],
            },
            Objects => {
                Select => { ... },
                PerlModule => { ... },
                # ...
            }
        ];
    );

Returns:

    $Result = '3600';

=cut

sub SettingEffectiveValueGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Value)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %ForbiddenValueTypes = %{ $Self->{ForbiddenValueTypes} || {} };

    if ( !%ForbiddenValueTypes ) {
        %ForbiddenValueTypes = $Self->ForbiddenValueTypesGet();
        $Self->{ForbiddenValueTypes} = \%ForbiddenValueTypes;
    }

    $Param{Translate} //= 0;

    my $Result;

    my %Objects;
    if ( $Param{Objects} ) {
        %Objects = %{ $Param{Objects} };
    }

    # Make sure structure is correct.
    return $Result if !IsArrayRefWithData( $Param{Value} );
    return $Result if !IsHashRefWithData( $Param{Value}->[0] );

    my %Attributes;

    if ( $Param{Value}->[0]->{Item} ) {

        # Make sure structure is correct.
        return $Result if !IsArrayRefWithData( $Param{Value}->[0]->{Item} );
        return $Result if !IsHashRefWithData( $Param{Value}->[0]->{Item}->[0] );

        # Set default ValueType.
        my $ValueType = "String";

        if ( $Param{Value}->[0]->{Item}->[0]->{ValueType} ) {
            $ValueType = $Param{Value}->[0]->{Item}->[0]->{ValueType};
        }

        if ( !$Objects{$ValueType} ) {

            # Make sure value type backend is available and syntactically correct.
            my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
                "Kernel::System::SysConfig::ValueType::$ValueType",
            );

            return $Result if !$Loaded;

            $Objects{$ValueType} = $Kernel::OM->Get(
                "Kernel::System::SysConfig::ValueType::$ValueType",
            );
        }

        # Create a local clone of the value to prevent any modification.
        my $Value = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
            Data => $Param{Value}->[0]->{Item},
        );

        $Result = $Objects{$ValueType}->EffectiveValueGet(
            Value     => $Value,
            Translate => $Param{Translate},
        );
    }
    elsif ( $Param{Value}->[0]->{Hash} ) {

        # Make sure structure is correct.
        return {} if !IsArrayRefWithData( $Param{Value}->[0]->{Hash} );
        return {} if !IsHashRefWithData( $Param{Value}->[0]->{Hash}->[0] );
        return {} if !IsArrayRefWithData( $Param{Value}->[0]->{Hash}->[0]->{Item} );

        # Check for additional attributes in the DefaultItem.
        if (
            $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}
            && ref $Param{Value}->[0]->{Hash}->[0]->{DefaultItem} eq 'ARRAY'
            && scalar $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}
            && ref $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0] eq 'HASH'
            )
        {
            %Attributes = ();

            my @ValueAttributeList = $Self->ValueAttributeList();

            ATTRIBUTE:
            for my $Attribute ( sort keys %{ $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0] } ) {
                if (
                    ( grep { $_ eq $Attribute } qw (Array Hash) )
                    && $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{$Attribute}->[0]->{DefaultItem}
                    )
                {
                    $Attributes{DefaultItem}
                        = $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{$Attribute}->[0]->{DefaultItem};
                }
                next ATTRIBUTE if grep { $Attribute eq $_ } ( qw (Array Hash), @ValueAttributeList );

                if (
                    $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{Item}
                    && $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{ValueType}
                    )
                {
                    my $DefaultItemValueType = $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{ValueType};
                    if ( $ForbiddenValueTypes{$DefaultItemValueType} ) {
                        my $SubValueType
                            = $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{Item}->[0]->{ValueType};

                        if ( !grep { $_ eq $SubValueType } @{ $ForbiddenValueTypes{$DefaultItemValueType} } ) {
                            next ATTRIBUTE;
                        }
                    }
                }

                $Attributes{$Attribute} = $Param{Value}->[0]->{Hash}->[0]->{DefaultItem}->[0]->{$Attribute};
            }
        }

        ITEM:
        for my $Item ( @{ $Param{Value}->[0]->{Hash}->[0]->{Item} } ) {

            next ITEM if !IsHashRefWithData($Item);
            next ITEM if !defined $Item->{Key};

            if ( $Item->{Hash} || $Item->{Array} ) {

                my $ItemKey = $Item->{Hash} ? 'Hash' : 'Array';

                ATTRIBUTE:
                for my $Attribute ( sort keys %Attributes ) {
                    next ATTRIBUTE if defined $Item->{$Attribute};    # skip redefined values

                    $Item->{$ItemKey}->[0]->{$Attribute} = $Attributes{$Attribute};
                }

                my $Value = $Self->SettingEffectiveValueGet(
                    Value     => [$Item],
                    Objects   => \%Objects,
                    Translate => $Param{Translate},
                );

                $Result->{ $Item->{Key} } = $Value;
            }
            elsif ( $Attributes{ValueType} || $Item->{ValueType} ) {

                # Create a local clone of the item to prevent any modification.
                my $Clone = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
                    Data => $Item,
                );

                ATTRIBUTE:
                for my $Attribute ( sort keys %Attributes ) {
                    next ATTRIBUTE if defined $Clone->{$Attribute};    # skip redefined values

                    $Clone->{$Attribute} = $Attributes{$Attribute};
                }

                my $Value = $Self->SettingEffectiveValueGet(
                    Value => [
                        {
                            Item => [$Clone],
                        },
                    ],
                    Objects   => \%Objects,
                    Translate => $Param{Translate},
                );

                $Result->{ $Item->{Key} } = $Value;
            }
            else {

                $Item->{Content} //= '';

                # Remove empty space at start and the end (with new lines).
                $Item->{Content} =~ s{^\n\s*(.*?)\n\s*$}{$1}gsmx;

                $Result->{ $Item->{Key} } = $Item->{Content};
            }
        }
    }
    elsif ( $Param{Value}->[0]->{Array} ) {

        # Make sure structure is correct
        return [] if !IsArrayRefWithData( $Param{Value}->[0]->{Array} );
        return [] if !IsHashRefWithData( $Param{Value}->[0]->{Array}->[0] );
        return [] if !IsArrayRefWithData( $Param{Value}->[0]->{Array}->[0]->{Item} );

        # Check for additional attributes in the DefaultItem.
        if (
            $Param{Value}->[0]->{Array}->[0]->{DefaultItem}
            && ref $Param{Value}->[0]->{Array}->[0]->{DefaultItem} eq 'ARRAY'
            && scalar $Param{Value}->[0]->{Array}->[0]->{DefaultItem}
            && ref $Param{Value}->[0]->{Array}->[0]->{DefaultItem}->[0] eq 'HASH'
            )
        {
            %Attributes = ();

            ATTRIBUTE:
            for my $Attribute ( sort keys %{ $Param{Value}->[0]->{Array}->[0]->{DefaultItem}->[0] } ) {
                if (
                    ( grep { $_ eq $Attribute } qw (Array Hash) )
                    && $Param{Value}->[0]->{Array}->[0]->{DefaultItem}->[0]->{$Attribute}->[0]->{DefaultItem}
                    )
                {
                    $Attributes{DefaultItem}
                        = $Param{Value}->[0]->{Array}->[0]->{DefaultItem}->[0]->{$Attribute}->[0]->{DefaultItem};
                }
                next ATTRIBUTE if grep { $Attribute eq $_ } qw (Array Hash Content SelectedID);

                $Attributes{$Attribute} = $Param{Value}->[0]->{Array}->[0]->{DefaultItem}->[0]->{$Attribute};
            }
        }

        my @Items;

        ITEM:
        for my $Item ( @{ $Param{Value}->[0]->{Array}->[0]->{Item} } ) {
            next ITEM if !IsHashRefWithData($Item);

            if ( $Item->{Hash} || $Item->{Array} ) {
                my $ItemKey = $Item->{Hash} ? 'Hash' : 'Array';

                ATTRIBUTE:
                for my $Attribute ( sort keys %Attributes ) {
                    next ATTRIBUTE if defined $Item->{$Attribute};    # skip redefined values

                    $Item->{$ItemKey}->[0]->{$Attribute} = $Attributes{$Attribute};
                }

                my $Value = $Self->SettingEffectiveValueGet(
                    Value     => [$Item],
                    Objects   => \%Objects,
                    Translate => $Param{Translate},
                );

                push @Items, $Value;
            }
            elsif ( $Attributes{ValueType} ) {

                # Create a local clone of the item to prevent any modification.
                my $Clone = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
                    Data => $Item,
                );

                ATTRIBUTE:
                for my $Attribute ( sort keys %Attributes ) {
                    next ATTRIBUTE if defined $Clone->{$Attribute};    # skip redefined values

                    $Clone->{$Attribute} = $Attributes{$Attribute};
                }

                my $Value = $Self->SettingEffectiveValueGet(
                    Value => [
                        {
                            Item => [$Clone],
                        },
                    ],
                    Objects   => \%Objects,
                    Translate => $Param{Translate},
                );

                push @Items, $Value;
            }
            else {
                $Item->{Content} //= '';

                # Remove empty space at start and the end (with new lines).
                $Item->{Content} =~ s{^\n\s*(.*?)\n\s*$}{$1}gsmx;

                push @Items, $Item->{Content};
            }
        }
        $Result = \@Items;
    }

    return $Result;
}

=head2 SettingRender()

Wrapper for Kernel::Output::HTML::SysConfig::SettingRender() - Returns the specific HTML for the setting.

    my $HTMLStr = $SysConfigObject->SettingRender(
        Setting   => {
            Name             => 'Setting Name',
            XMLContentParsed => $XMLParsedToPerl,
            EffectiveValue   => "Product 6",        # or a complex structure
            DefaultValue     => "Product 5",        # or a complex structure
            IsAjax           => 1,                  # (optional) is AJAX request. Default 0.
            # ...
        },
        RW => 1,                                    # (optional) Allow editing. Default 0.
    );

Returns:

    $HTMLStr = '<div class="Setting"><div class "Field"...</div></div>'        # or false in case of an error

=cut

sub SettingRender {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::Output::HTML::SysConfig')->SettingRender(%Param);
}

=head2 SettingAddItem()

Wrapper for Kernel::Output::HTML::SysConfig::SettingAddItem() - Returns response that is sent when user adds new array/hash item.

    my %Result = $SysConfigObject->SettingAddItem(
        SettingStructure  => [],         # (required) array that contains structure
                                         #  where a new item should be inserted (can be empty)
        Setting           => {           # (required) Setting hash (from SettingGet())
            'DefaultID' => '8905',
            'DefaultValue' => [ 'Item 1', 'Item 2' ],
            'Description' => 'Simple array item(Min 1, Max 3).',
            'Name' => 'TestArray',
            ...
        },
        Key               => 'HashKey',  # (optional) hash key
        IDSuffix          => '_Array3,   # (optional) suffix that will be added to all input/select fields
                                         #    (it is used in the JS on Update, during EffectiveValue calculation)
        Value             => [           # (optional) Perl structure
            {
                'Array' => [
                    'Item' => [
                        {
                        'Content' => 'Item 1',
                        },
                        ...
                    ],
                ],
            },
        ],
        AddSettingContent => 0,          # (optional) if enabled, result will be inside of div with class "SettingContent"
    );

Returns:

    %Result = (
        'Item' => '<div class=\'SettingContent\'>
<input type=\'text\' id=\'TestArray_Array4\'
        value=\'Default value\' name=\'TestArray\' class=\' Entry\'/></div>',
    );

    or

    %Result = (
        'Error' => 'Error description',
    );

=cut

sub SettingAddItem {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::Output::HTML::SysConfig')->SettingAddItem(%Param);
}

=head2 SettingsUpdatedList()

Checks which settings has been updated from provided Setting list and returns updated values.

    my @List = $SysConfigObject->SettingsUpdatedList(
        Settings => [                                               # (required) List of settings that needs to be checked
            {
                SettingName           => 'SettingName',
                ChangeTime            => '2017-01-13 11:23:07',
                IsLockedByAnotherUser => 0,
            },
            ...
        ],
        UserID => 1,                                                # (required) Current user id
    );

Returns:

    @List = [
        {
            ChangeTime            => '2017-01-07 11:29:38',
            IsLockedByAnotherUser => 1,
            IsModified            => 1,
            SettingName           => 'SettingName',
        },
        ...
    ];

=cut

sub SettingsUpdatedList {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Settings UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my @Result;

    SETTING:
    for my $Setting ( @{ $Param{Settings} } ) {
        next SETTING if !IsHashRefWithData($Setting);

        my %SettingData = $Self->SettingGet(
            Name => $Setting->{SettingName},
        );

        my $LockedUserID = $SysConfigDBObject->DefaultSettingIsLocked(
            Name          => $Setting->{SettingName},
            GetLockUserID => 1,
        );

        my $IsLockedByAnotherUser = $LockedUserID ? 1 : 0;

        # Skip if setting was locked by current user during AJAX call.
        next SETTING if $LockedUserID == $Param{UserID};

        my $Updated = $SettingData{ChangeTime} ne $Setting->{ChangeTime};
        $Updated ||= $IsLockedByAnotherUser != $Setting->{IsLockedByAnotherUser};

        $Setting->{IsLockedByAnotherUser} = $IsLockedByAnotherUser;

        next SETTING if !$Updated;

        push @Result, $Setting;
    }

    return @Result;
}

=head2 SettingEffectiveValueCheck()

Check if provided EffectiveValue matches structure defined in DefaultSetting. Also returns EffectiveValue that might be changed.

    my %Result = $SysConfigObject->SettingEffectiveValueCheck(
        EffectiveValue => 'open',     # (optional)
        XMLContentParsed => {         # (required)
            Value => [
                {
                    'Item' => [
                        {
                            'Content' => "Scalar value",
                        },
                    ],
                },
            ],
        },
        StoreCache            => 1,               # (optional) Store result in the Cache. Default 0.
        SettingUID            => 'Default1234'    # (required if StoreCache)
        NoValidation          => 1,               # (optional) no value type validation.
        CurrentSystemTime     => 1507894796935,   # (optional) Use provided 1507894796935, otherwise calculate
        ExpireTime            => 1507894896935,   # (optional) Use provided ExpireTime for cache, otherwise calculate
        UserID                => 1,               # (required) UserID
    );

Returns:

    %Result = (
        EffectiveValue => 'closed',    # Note that resulting effective value can be different
        Success        => 1,
        Error          => undef,
    );

=cut

sub SettingEffectiveValueCheck {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(XMLContentParsed UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    $Param{EffectiveValue} //= '';
    $Param{NoValidation}   //= 0;

    my $StoreCache = $Param{StoreCache};

    if ( $Param{StoreCache} && !$Param{SettingUID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "SettingEffectiveValueCheck() called with StoreCache but without SettingUID parameter!"
        );
        $StoreCache = 0;    # Fallback, do not use cache.
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType = 'SysConfigPersistent';
    my $CacheKey  = "EffectiveValueCheck::$Param{NoValidation}";
    my $SettingKey;

    my $Cache;

    my $DateTimeObject;

    my $CurrentSystemTime = $Param{CurrentSystemTime};

    # Get current system time, if not provided.
    if ( !$CurrentSystemTime ) {
        $DateTimeObject    = $Kernel::OM->Create('Kernel::System::DateTime');
        $CurrentSystemTime = $DateTimeObject->ToEpoch();
    }

    my $ExpireTime = $Param{ExpireTime};

    # Get cache expire time, if not provided.
    if ( !$ExpireTime ) {
        if ( !$DateTimeObject ) {
            $DateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
        }

        # Set expire date.
        $DateTimeObject->Add(
            Months => 1,
        );

        $ExpireTime = $DateTimeObject->ToEpoch();
    }

    if ( $Param{SettingUID} ) {

        my $MainObject     = $Kernel::OM->Get('Kernel::System::Main');
        my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

        my $ValueString = $Param{EffectiveValue};
        if ( ref $ValueString ) {
            my $String = $StorableObject->Serialize(
                Data => $Param{EffectiveValue},
            );
            $ValueString = $MainObject->MD5sum(
                String => \$String,
            );
        }

        $SettingKey = "$Param{SettingUID}::${ValueString}";

        $Cache = $CacheObject->Get(
            Type => $CacheType,
            Key  => $CacheKey,
        );

        if ( $Cache && !$Self->{EffectiveValueCheckCacheDeleted} ) {

            # Delete all expired keys.
            my @ExpiredKeys = grep { $CurrentSystemTime > ( $Cache->{$_}->{ExpireTime} || 0 ) } keys %{$Cache};
            delete @{$Cache}{@ExpiredKeys};

            if (@ExpiredKeys) {

                # Update cache.
                $CacheObject->Set(
                    Type  => $CacheType,
                    Key   => $CacheKey,
                    Value => $Cache,
                    TTL   => 20 * 24 * 60 * 60,
                );
            }

            # Remember delete in this round
            $Self->{EffectiveValueCheckCacheDeleted} = 1;
        }

        if (
            ref $Cache eq 'HASH'
            && $Cache->{$SettingKey}
            )
        {
            return %{ $Cache->{$SettingKey} };
        }
    }

    my %Result = (
        Success => 0,
    );

    my %Parameters = %{ $Param{Parameters} || {} };
    my $Value      = $Param{XMLContentParsed}->{Value};

    if ( $Value->[0]->{Item} || $Value->[0]->{ValueType} ) {

        # get ValueType from parent or use default
        my $ValueType = $Parameters{ValueType} || $Value->[0]->{ValueType} || 'String';

        # ValueType is defined explicitly(override parent definition)
        if (
            $Value->[0]->{Item}
            && $Value->[0]->{Item}->[0]->{ValueType}
            )
        {
            $ValueType = $Value->[0]->{Item}->[0]->{ValueType};
        }

        my %ForbiddenValueTypes = %{ $Self->{ForbiddenValueTypes} || {} };

        if ( !%ForbiddenValueTypes ) {
            %ForbiddenValueTypes = $Self->ForbiddenValueTypesGet();
            $Self->{ForbiddenValueTypes} = \%ForbiddenValueTypes;
        }

        my @SkipValueTypes;

        for my $Item ( sort keys %ForbiddenValueTypes ) {
            if ( !grep { $_ eq $ForbiddenValueTypes{$Item} } @SkipValueTypes ) {
                push @SkipValueTypes, @{ $ForbiddenValueTypes{$Item} };
            }
        }

        if (
            $Param{NoValidation}
            || grep { $_ eq $ValueType } @SkipValueTypes
            )
        {
            $Result{Success}        = 1;
            $Result{EffectiveValue} = $Param{EffectiveValue};
            return %Result;
        }

        my $BackendObject = $Self->{ValueTypeBackendObject}->{$ValueType} || '';

        if ( !$BackendObject ) {

            my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
                "Kernel::System::SysConfig::ValueType::$ValueType",
            );

            if ( !$Loaded ) {
                $Result{Error} = "Kernel::System::SysConfig::ValueType::$ValueType";
                return %Result;
            }

            $BackendObject = $Kernel::OM->Get(
                "Kernel::System::SysConfig::ValueType::$ValueType",
            );

            $Self->{ValueTypeBackendObject}->{$ValueType} = $BackendObject;
        }

        %Result = $BackendObject->SettingEffectiveValueCheck(%Param);
        $Param{EffectiveValue} = $Result{EffectiveValue} if $Result{Success};
    }
    elsif ( $Value->[0]->{Hash} ) {

        if ( ref $Param{EffectiveValue} ne 'HASH' ) {
            $Result{Error} = 'Its not a hash!';
            return %Result;
        }

        PARAMETER:
        for my $Parameter ( sort keys %{ $Value->[0]->{Hash}->[0] } ) {

            next PARAMETER if !grep { $_ eq $Parameter } qw(MinItems MaxItems);

            $Parameters{$Parameter} = $Value->[0]->{Hash}->[0]->{$Parameter} || '';
        }

        if ( $Parameters{MinItems} && $Parameters{MinItems} > keys %{ $Param{EffectiveValue} } ) {
            $Result{Error} = "Number of items in hash is less than MinItems($Parameters{MinItems})!";
            return %Result;
        }

        if ( $Parameters{MaxItems} && $Parameters{MaxItems} < keys %{ $Param{EffectiveValue} } ) {
            $Result{Error} = "Number of items in hash is more than MaxItems($Parameters{MaxItems})!";
            return %Result;
        }

        my @Items = ();

        if (
            scalar @{ $Value->[0]->{Hash} }
            && $Value->[0]->{Hash}->[0]->{Item}
            && ref $Value->[0]->{Hash}->[0]->{Item} eq 'ARRAY'
            )
        {
            @Items = @{ $Value->[0]->{Hash}->[0]->{Item} };
        }

        my $DefaultItem;

        KEY:
        for my $Key ( sort keys %{ $Param{EffectiveValue} } ) {
            $DefaultItem = $Value->[0]->{Hash}->[0]->{DefaultItem};

            if ( $Value->[0]->{Hash}->[0]->{Item} ) {
                my @ItemWithSameKey = grep { $Key eq ( $Value->[0]->{Hash}->[0]->{Item}->[$_]->{Key} || '' ) }
                    0 .. scalar @{ $Value->[0]->{Hash}->[0]->{Item} };
                if ( scalar @ItemWithSameKey ) {
                    $DefaultItem = [
                        $Value->[0]->{Hash}->[0]->{Item}->[ $ItemWithSameKey[0] ],
                    ];
                }

                my $StructureType;
                if ( $DefaultItem->[0]->{Array} ) {
                    $StructureType = 'Array';
                }
                elsif ( $DefaultItem->[0]->{Hash} ) {
                    $StructureType = 'Hash';
                }

                # check if default item is defined in this sub-structure
                if (
                    $StructureType
                    && !$DefaultItem->[0]->{$StructureType}->[0]->{DefaultItem}
                    && $Value->[0]->{Hash}->[0]->{DefaultItem}
                    && $Value->[0]->{Hash}->[0]->{DefaultItem}->[0]->{$StructureType}
                    && $Value->[0]->{Hash}->[0]->{DefaultItem}->[0]->{$StructureType}->[0]->{DefaultItem}
                    )
                {
                    # Default Item is not defined here, but it's defined in previous call.
                    $DefaultItem->[0]->{$StructureType}->[0]->{DefaultItem} =
                        $Value->[0]->{Hash}->[0]->{DefaultItem}->[0]->{$StructureType}->[0]->{DefaultItem};
                }
            }

            my $Ref = ref $Param{EffectiveValue}->{$Key};

            if ($Ref) {

                if ( IsArrayRefWithData($DefaultItem) ) {

                    my $KeyNeeded;

                    if ( $Ref eq 'HASH' ) {
                        $KeyNeeded = 'Hash';
                    }
                    elsif ( $Ref eq 'ARRAY' ) {
                        $KeyNeeded = 'Array';
                    }
                    else {
                        $Result{Error} = "Wrong format!";
                        last KEY;
                    }

                    if ( $DefaultItem->[0]->{Item} ) {

                        # So far everything is OK, we need to check deeper (recursive).
                        my %SubResult = $Self->_SettingEffectiveValueCheck(
                            XMLContentParsed => {
                                Value => $DefaultItem,
                            },
                            EffectiveValue    => $Param{EffectiveValue}->{$Key},
                            NoValidation      => $Param{NoValidation},
                            CurrentSystemTime => $Param{CurrentSystemTime},
                            ExpireTime        => $Param{ExpireTime},
                            UserID            => $Param{UserID},
                        );
                        $Param{EffectiveValue}->{$Key} = $SubResult{EffectiveValue} if $SubResult{Success};

                        if ( $SubResult{Error} ) {
                            %Result = %SubResult;
                            last KEY;
                        }
                    }
                    elsif ( !defined $DefaultItem->[0]->{$KeyNeeded} ) {
                        my $ExpectedText = '';

                        if ( $DefaultItem->[0]->{Array} ) {
                            $ExpectedText = "an array reference!";
                        }
                        elsif ( $DefaultItem->[0]->{Hash} ) {
                            $ExpectedText = "a hash reference!";
                        }
                        else {
                            $ExpectedText = "a scalar!";
                        }

                        $Result{Error} = "Item with key $Key must be $ExpectedText";
                        last KEY;
                    }
                    else {

                        # So far everything is OK, we need to check deeper (recursive).
                        my %SubResult = $Self->_SettingEffectiveValueCheck(
                            XMLContentParsed => {
                                Value => $DefaultItem,
                            },
                            EffectiveValue    => $Param{EffectiveValue}->{$Key},
                            NoValidation      => $Param{NoValidation},
                            CurrentSystemTime => $Param{CurrentSystemTime},
                            ExpireTime        => $Param{ExpireTime},
                            UserID            => $Param{UserID},
                        );
                        $Param{EffectiveValue}->{$Key} = $SubResult{EffectiveValue} if $SubResult{Success};

                        if ( $SubResult{Error} ) {
                            %Result = %SubResult;
                            last KEY;
                        }
                    }
                }
                else {
                    # Hash is empty in the Defaults, value should be scalar.
                    $Result{Error} = "Item with key $Key must be a scalar!";
                    last KEY;
                }
            }
            else {

                # scalar value
                if ( IsArrayRefWithData($DefaultItem) ) {
                    if ( $DefaultItem->[0]->{Item} || $DefaultItem->[0]->{Content} ) {

                        # So far everything is OK, we need to check deeper (recursive).
                        my %SubResult = $Self->_SettingEffectiveValueCheck(
                            XMLContentParsed => {
                                Value => [
                                    {
                                        Item => $DefaultItem,
                                    },
                                ],
                            },
                            EffectiveValue    => $Param{EffectiveValue}->{$Key},
                            NoValidation      => $Param{NoValidation},
                            CurrentSystemTime => $Param{CurrentSystemTime},
                            ExpireTime        => $Param{ExpireTime},
                            UserID            => $Param{UserID},
                        );

                        if ( $SubResult{Error} ) {
                            %Result = %SubResult;
                            last KEY;
                        }
                        else {
                            $Param{EffectiveValue}->{$Key} = $SubResult{EffectiveValue};
                        }

                    }
                    elsif ( $DefaultItem->[0]->{Hash} ) {
                        $Result{Error} = "Item with key $Key must be a hash reference!";
                        last KEY;
                    }
                    elsif ( $DefaultItem->[0]->{Array} ) {
                        $Result{Error} = "Item with key $Key must be an array reference!";
                        last KEY;
                    }
                }
            }
        }

        # Check which Value type is default
        my $DefaultValueTypeDefined = 'String';
        if (
            $Value->[0]->{Hash}->[0]->{DefaultItem}
            && $Value->[0]->{Hash}->[0]->{DefaultItem}->[0]->{ValueType}
            )
        {
            $DefaultValueTypeDefined = $Value->[0]->{Hash}->[0]->{DefaultItem}->[0]->{ValueType};
        }

        # Get persistent keys(items with value type different then value type defined in the DefaultItem)
        my @PersistentKeys;
        for my $Item ( @{ $Value->[0]->{Hash}->[0]->{Item} } ) {
            my $ValueType = $DefaultValueTypeDefined;

            if ( $Item->{ValueType} ) {
                $ValueType = $Item->{ValueType};
            }
            elsif (
                $Item->{Item}
                && $Item->{Item}->[0]->{ValueType}
                )
            {
                $ValueType = $Item->{Item}->[0]->{ValueType};
            }

            if ( $ValueType ne $DefaultValueTypeDefined && $Item->{Key} ) {
                push @PersistentKeys, $Item->{Key};
            }
        }

        # Validate if all persistent keys are present
        PERSISTENT_KEY:
        for my $Key (@PersistentKeys) {
            if ( !defined $Param{EffectiveValue}->{$Key} ) {
                $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate( "Missing key %s!", $Key );
                last PERSISTENT_KEY;
            }
        }

        if ( $Result{Error} ) {
            return %Result;
        }

        $Result{Success} = 1;
    }
    elsif ( $Value->[0]->{Array} ) {

        if ( ref $Param{EffectiveValue} ne 'ARRAY' ) {
            $Result{Error} = 'Its not an array!';
            return %Result;
        }

        PARAMETER:
        for my $Parameter ( sort keys %{ $Value->[0]->{Array}->[0] } ) {
            next PARAMETER if !grep { $_ eq $Parameter } qw(MinItems MaxItems);

            $Parameters{$Parameter} = $Value->[0]->{Array}->[0]->{$Parameter} || '';
        }

        if ( $Parameters{MinItems} && $Parameters{MinItems} > scalar @{ $Param{EffectiveValue} } ) {
            $Result{Error} = "Number of items in array is less than MinItems($Parameters{MinItems})!";
            return %Result;
        }

        if ( $Parameters{MaxItems} && $Parameters{MaxItems} < scalar @{ $Param{EffectiveValue} } ) {
            $Result{Error} = "Number of items in array is more than MaxItems($Parameters{MaxItems})!";
            return %Result;
        }

        my @Items = ();
        if (
            scalar @{ $Value->[0]->{Array} }
            && $Value->[0]->{Array}->[0]->{Item}
            && ref $Value->[0]->{Array}->[0]->{Item} eq 'ARRAY'
            )
        {
            @Items = @{ $Value->[0]->{Array}->[0]->{Item} };
        }

        my $DefaultItem;

        INDEX:
        for my $Index ( 0 .. scalar @{ $Param{EffectiveValue} } - 1 ) {

            $DefaultItem = $Value->[0]->{Array}->[0]->{DefaultItem};

            my $Ref = ref $Param{EffectiveValue}->[$Index];
            if ($Ref) {
                if ($DefaultItem) {
                    my $KeyNeeded;

                    if ( $Ref eq 'HASH' ) {
                        $KeyNeeded = 'Hash';
                    }
                    elsif ( $Ref eq 'ARRAY' ) {
                        $KeyNeeded = 'Array';
                    }
                    else {
                        $Result{Error} = "Wrong format!";
                        last INDEX;
                    }

                    if ( $DefaultItem->[0]->{Item} ) {

                        # So far everything is OK, we need to check deeper (recursive).
                        my %SubResult = $Self->_SettingEffectiveValueCheck(
                            XMLContentParsed => {
                                Value => [
                                    {
                                        Item => $DefaultItem,
                                    },
                                ],
                            },
                            EffectiveValue    => $Param{EffectiveValue}->[$Index],
                            NoValidation      => $Param{NoValidation},
                            CurrentSystemTime => $Param{CurrentSystemTime},
                            ExpireTime        => $Param{ExpireTime},
                            UserID            => $Param{UserID},
                        );
                        $Param{EffectiveValue}->[$Index] = $SubResult{EffectiveValue} if $SubResult{Success};

                        if ( $SubResult{Error} ) {
                            %Result = %SubResult;
                            last INDEX;
                        }
                    }
                    elsif ( !defined $DefaultItem->[0]->{$KeyNeeded} ) {
                        my $ExpectedText = '';

                        if ( $DefaultItem->[0]->{Array} ) {
                            $ExpectedText = "an array reference!";
                        }
                        elsif ( $DefaultItem->[0]->{Hash} ) {
                            $ExpectedText = "a hash reference!";
                        }
                        elsif ( $DefaultItem->[0]->{Content} ) {
                            $ExpectedText = "a scalar!";
                        }

                        $Result{Error} = "Item with index $Index must be $ExpectedText";
                        last INDEX;
                    }
                    else {

                        # So far everything is OK, we need to check deeper (recursive).
                        my %SubResult = $Self->_SettingEffectiveValueCheck(
                            XMLContentParsed => {
                                Value => $DefaultItem,
                            },
                            EffectiveValue    => $Param{EffectiveValue}->[$Index],
                            NoValidation      => $Param{NoValidation},
                            CurrentSystemTime => $Param{CurrentSystemTime},
                            ExpireTime        => $Param{ExpireTime},
                            UserID            => $Param{UserID},
                        );
                        $Param{EffectiveValue}->[$Index] = $SubResult{EffectiveValue} if $SubResult{Success};

                        if ( $SubResult{Error} ) {
                            %Result = %SubResult;
                            last INDEX;
                        }
                    }
                }
                else {

                    # Array is empty in the Defaults, value should be scalar.
                    $Result{Error} = "Item with index $Index must be a scalar!";
                    last INDEX;
                }
            }
            else {

                # scalar
                if ($DefaultItem) {

                    if ( $DefaultItem->[0]->{Item} || $DefaultItem->[0]->{ValueType} ) {

                        # Item with ValueType

                        # So far everything is OK, we need to check deeper (recursive).
                        my %SubResult = $Self->_SettingEffectiveValueCheck(
                            XMLContentParsed => {
                                Value => [
                                    {
                                        Item => $DefaultItem,
                                    },
                                ],
                            },
                            EffectiveValue    => $Param{EffectiveValue}->[$Index],
                            NoValidation      => $Param{NoValidation},
                            CurrentSystemTime => $Param{CurrentSystemTime},
                            ExpireTime        => $Param{ExpireTime},
                            UserID            => $Param{UserID},
                        );
                        $Param{EffectiveValue}->[$Index] = $SubResult{EffectiveValue} if $SubResult{Success};

                        if ( $SubResult{Error} ) {
                            %Result = %SubResult;
                            last INDEX;
                        }
                    }
                    elsif ( $DefaultItem->[0]->{Hash} ) {
                        $Result{Error} = "Item with index $Index must be a hash reference!";
                        last INDEX;
                    }
                    elsif ( $DefaultItem->[0]->{Array} ) {
                        $Result{Error} = "Item with index $Index must be an array reference!";
                        last INDEX;
                    }
                }
            }
        }
        if ( $Result{Error} ) {
            return %Result;
        }

        $Result{Success} = 1;
    }

    if ( $Result{Success} ) {
        $Result{EffectiveValue} = $Param{EffectiveValue};
    }

    $Result{ExpireTime} = $ExpireTime;

    if ($StoreCache) {

        $Cache->{$SettingKey} = \%Result;

        $CacheObject->Set(
            Type  => $CacheType,
            Key   => $CacheKey,
            Value => $Cache,
            TTL   => 20 * 24 * 60 * 60,
        );
    }

    return %Result;
}

=head2 SettingReset()

Reset the modified value to the default value.

    my $Result = $SysConfigObject->SettingReset(
        Name                  => 'Setting Name',                # (required) Setting name
        TargetUserID          => 2,                             # (optional) UserID for settings in AgentPreferences
                                                                # or
        ExclusiveLockGUID     => $LockingString,                # (optional) the GUID used to locking the setting
        UserID                => 1,                             # (required) UserID that creates modification
    );

Returns:

    $Result = 1;        # or false in case of an error

=cut

sub SettingReset {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Name ExclusiveLockGUID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Check if the setting exists.
    my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
        Name => $Param{Name},
    );

    return if !%DefaultSetting;

    # Default should be locked.
    my $LockedByUser = $SysConfigDBObject->DefaultSettingIsLockedByUser(
        DefaultID           => $DefaultSetting{DefaultID},
        ExclusiveLockUserID => $Param{UserID},
        ExclusiveLockGUID   => $Param{ExclusiveLockGUID},
    );

    if ( !$LockedByUser ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Setting $Param{Name} is not locked to this user!",
        );
        return;
    }

    my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
        Name     => $Param{Name},
        IsGlobal => 1,
    );

    # Setting already had default value.
    return 1 if !%ModifiedSetting;

    my %SettingDeployed = $Self->SettingGet(
        Name     => $Param{Name},
        Deployed => 1,
    );

    my $IsModified = DataIsDifferent(
        Data1 => \$SettingDeployed{EffectiveValue},
        Data2 => \$DefaultSetting{EffectiveValue},
    ) || 0;

    $IsModified ||= $SettingDeployed{IsValid} != $DefaultSetting{IsValid};
    $IsModified ||= $SettingDeployed{UserModificationActive} != $DefaultSetting{UserModificationActive};
    $ModifiedSetting{IsDirty} = $IsModified ? 1 : 0;

    # Copy values from default.
    for my $Field (qw(IsValid UserModificationActive EffectiveValue)) {
        $ModifiedSetting{$Field} = $DefaultSetting{$Field};
    }

    # Set reset flag.
    $ModifiedSetting{ResetToDefault} = 1;

    # Delete modified setting.
    my $ResetResult = $SysConfigDBObject->ModifiedSettingUpdate(
        %ModifiedSetting,
        ExclusiveLockGUID => $Param{ExclusiveLockGUID},
        UserID            => $Param{UserID},
    );

    if ( !$ResetResult ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "System was unable to update Modified setting: $Param{Name}!",
        );
    }

    return $ResetResult;
}

=head2 ConfigurationTranslatedGet()

Returns a hash with all settings and translated metadata.

    my %Result = $SysConfigObject->ConfigurationTranslatedGet();

Returns:

    %Result = (
       'ACL::CacheTTL' => {
            'Category' => 'OTRS',
            'IsInvisible' => '0',
            'Metadata' => "ACL::CacheTTL--- '3600'
Cache-Zeit in Sekunden f\x{fc}r Datenbank ACL-Backends.",
        ...
    );

=cut

sub ConfigurationTranslatedGet {
    my ( $Self, %Param ) = @_;

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');
    my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType = 'SysConfig';
    my $CacheKey  = "ConfigurationTranslatedGet::$LanguageObject->{UserLanguage}";

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my @SettingList = $Self->ConfigurationList(
        IncludeInvisible => 1,
    );

    my %Result;

    for my $Setting (@SettingList) {

        my %SettingTranslated = $Self->_SettingTranslatedGet(
            Language => $LanguageObject->{UserLanguage},
            Name     => $Setting->{Name},
        );

        # Append to the result.
        $Result{ $Setting->{Name} } = $SettingTranslated{ $Setting->{Name} };
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%Result,
        TTL   => $Self->{CacheTTL} || 24 * 60 * 60,
    );

    return %Result;
}

=head2 SettingNavigationToPath()

Returns path structure for given navigation group.

    my @Path = $SysConfigObject->SettingNavigationToPath(
        Navigation => 'Frontend::Agent::ToolBarModule',  # (optional)
    );

Returns:

    @Path = (
        {
            'Value' => 'Frontend',
            'Name' => 'Frontend',
        },
        {
            'Value' => 'Frontend::Agent',
            'Name' => 'Agent',
        },
        ...
    );

=cut

sub SettingNavigationToPath {
    my ( $Self, %Param ) = @_;

    my @NavigationNames = split( '::', $Param{Navigation} );
    my @Path;

    INDEX:
    for my $Index ( 0 .. $#NavigationNames ) {

        $Path[$Index]->{Name} = $NavigationNames[$Index];

        my @SubArray = @NavigationNames[ 0 .. $Index ];
        $Path[$Index]->{Value} = join '::', @SubArray;
    }

    return @Path;
}

=head2 ConfigurationTranslatableStrings()

Returns a unique list of all translatable strings from the default settings.

    my @TranslatableStrings = $SysConfigObject->ConfigurationTranslatableStrings();

=cut

sub ConfigurationTranslatableStrings {
    my ( $Self, %Param ) = @_;

    # Reset translation list.
    $Self->{ConfigurationTranslatableStrings} = {};

    # Get all default settings.
    my @SettingsList = $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DefaultSettingListGet();

    SETTING:
    for my $Setting (@SettingsList) {

        next SETTING if !$Setting;
        next SETTING if !defined $Setting->{XMLContentParsed};

        # Get translatable strings.
        $Self->_ConfigurationTranslatableStrings( Data => $Setting->{XMLContentParsed} );

    }

    my @Strings;
    for my $Key ( sort keys %{ $Self->{ConfigurationTranslatableStrings} } ) {
        push @Strings, $Key;
    }
    return @Strings;
}

=head2 ConfigurationEntitiesGet()

Get all entities that are referred in any enabled Setting in complete SysConfig.

    my %Result = $SysConfigObject->ConfigurationEntitiesGet();

Returns:

    %Result = (
        'Priority' => {
            '3 normal' => [
                'Ticket::Frontend::AgentTicketNote###PriorityDefault',
                'Ticket::Frontend::AgentTicketPhone###Priority',
                ...
            ],
        },
        'Queue' => {
            'Postmaster' => [
                'Ticket::Frontend::CustomerTicketMessage###QueueDefault',
            ],
            'Raw' => [
                'PostmasterDefaultQueue',
            ],
        },
        ...
    );

=cut

sub ConfigurationEntitiesGet {
    my ( $Self, %Param ) = @_;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType = "SysConfigEntities";
    my $CacheKey  = "UsedEntities";

    my $CacheData = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    # Return cached data if available.
    return %{$CacheData} if $CacheData;

    my %Result = ();

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my @EntitySettings = $SysConfigDBObject->DefaultSettingSearch(
        Search => 'ValueEntityType',
    );

    SETTING:
    for my $SettingName (@EntitySettings) {

        my %Setting = $SysConfigDBObject->DefaultSettingGet(
            Name => $SettingName,
        );

        # Check if there is modified value.
        my %ModifiedSetting = $SysConfigDBObject->ModifiedSettingGet(
            Name => $SettingName,
        );

        if (%ModifiedSetting) {
            my $XMLContentParsed = $Self->SettingModifiedXMLContentParsedGet(
                ModifiedSetting => \%ModifiedSetting,
                DefaultSetting  => \%Setting,
            );

            $Setting{XMLContentParsed}->{Value} = $XMLContentParsed;
        }

        %Result = $Self->_ConfigurationEntitiesGet(
            Value  => $Setting{XMLContentParsed}->{Value},
            Result => \%Result,
            Name   => $Setting{XMLContentParsed}->{Name},
        );
    }

    # Cache the results.
    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%Result,
        TTL   => 30 * 24 * 60 * 60,
    );

    return %Result;
}

=head2 ConfigurationEntityCheck()

Check if there are any enabled settings that refers to the provided Entity.

    my @Result = $SysConfigObject->ConfigurationEntityCheck(
        EntityType  => 'Priority',
        EntityName  => '3 normal',
    );

Returns:

    @Result = (
        'Ticket::Frontend::AgentTicketNote###PriorityDefault',
        'Ticket::Frontend::AgentTicketPhone###Priority',
        'Ticket::Frontend::AgentTicketBulk###PriorityDefault',
        ...
    );

=cut

sub ConfigurationEntityCheck {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(EntityType EntityName)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }
    if ( !$Param{EntityType} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "EntityType is invalid!"
        );
        return;
    }

    # If name is an empty string there is nothing to do, return an empty array.
    return () if !$Param{EntityName};

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType = "SysConfigEntities";
    my $CacheKey  = "ConfigurationEntityCheck::$Param{EntityType}::$Param{EntityName}";

    my $CacheData = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    # Return cached data if available.
    return @{$CacheData} if $CacheData;

    my %EntitySettings = $Self->ConfigurationEntitiesGet();

    my @Result = ();

    for my $EntityType ( sort keys %EntitySettings ) {

        # Check conditions.
        if (
            $EntityType eq $Param{EntityType}
            && $EntitySettings{$EntityType}{ $Param{EntityName} }
            )
        {
            @Result = @{ $EntitySettings{$EntityType}->{ $Param{EntityName} } };
        }
    }

    # Cache the results.
    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \@Result,
        TTL   => 30 * 24 * 60 * 60,
    );

    return @Result;
}

=head2 ConfigurationXML2DB()

Load Settings defined in XML files to the database.

    my $Success = $SysConfigObject->ConfigurationXML2DB(
        UserID    => 1,                  # UserID
        Directory => '/some/folder',     # (optional) Provide directory where XML files are stored (default: Kernel/Config/Files/XML).
        Force     => 1,                  # (optional) Force Setting update, even if it's locked by another user. Default: 0.
        CleanUp   => 1,                  # (optional) Remove all settings that are not present in XML files. Default: 0.
    );

Returns:

    $Success = 1;       # or false in case of an error.

=cut

sub ConfigurationXML2DB {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!"
        );
        return;
    }

    my $Directory = $Param{Directory} || "$Self->{Home}/Kernel/Config/Files/XML/";

    if ( !-e $Directory ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Directory '$Directory' does not exists",
        );

        return;
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Load xml config files, ordered by file name
    my @Files = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => "*.xml",
    );

    my $CacheObject        = $Kernel::OM->Get('Kernel::System::Cache');
    my $SysConfigXMLObject = $Kernel::OM->Get('Kernel::System::SysConfig::XML');
    my $SysConfigDBObject  = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my %SettingsByInit = (
        Framework   => [],
        Application => [],
        Config      => [],
        Changes     => [],
    );

    my %Data;
    FILE:
    for my $File (@Files) {

        my $MD5Sum = $MainObject->MD5sum(
            Filename => $File,
        );

        # Cleanup filename for cache type
        my $Filename = $File;
        $Filename =~ s{\/\/}{\/}g;
        $Filename =~ s{\A .+ Kernel/Config/Files/XML/ (.+)\.xml\z}{$1}msx;
        $Filename =~ s{\A .+ scripts/test/sample/SysConfig/XML/ (.+)\.xml\z}{$1}msx;

        my $CacheType = 'SysConfigPersistent';
        my $CacheKey  = "ConfigurationXML2DB::${Filename}::${MD5Sum}";

        my $Cache = $CacheObject->Get(
            Type => $CacheType,
            Key  => $CacheKey,
        );

        if (
            ref $Cache eq 'HASH'
            && $Cache->{Init}
            && ref $Cache->{Settings} eq 'ARRAY'
            )
        {
            @{ $SettingsByInit{ $Cache->{Init} } }
                = ( @{ $SettingsByInit{ $Cache->{Init} } }, @{ $Cache->{Settings} } );
            next FILE;
        }

        # Read XML file.
        my $ConfigFile = $MainObject->FileRead(
            Location => $File,
            Mode     => 'utf8',
            Result   => 'SCALAR',
        );
        if ( !ref $ConfigFile || !${$ConfigFile} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't open file $File: $!",
            );
            next FILE;
        }

        # Check otrs_config Init attribute.
        $$ConfigFile =~ m{<otrs_config.*?init="(.*?)"}gsmx;
        my $InitValue = $1;

        # Check if InitValue is Valid.
        if ( !defined $SettingsByInit{$InitValue} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Invalid otrs_config Init value ($InitValue)! Allowed values: Framework, Application, Config, Changes.",
            );
            next FILE;
        }

        my $XMLFilename = $File;
        $XMLFilename =~ s{$Directory(.*\.xml)\z}{$1}gmsx;
        $XMLFilename =~ s{\A/}{}gmsx;

        # Remove comments.
        ${$ConfigFile} =~ s{<!--.*?-->}{}gs;

        my @ParsedSettings = $SysConfigXMLObject->SettingListParse(
            XMLInput    => ${$ConfigFile},
            XMLFilename => $XMLFilename,
        );

        @{ $SettingsByInit{$InitValue} } = ( @{ $SettingsByInit{$InitValue} }, @ParsedSettings );

        # There might be an error parsing file. If we cache the result, error message will not be present.
        if (@ParsedSettings) {
            $CacheObject->Set(
                Key   => $CacheKey,
                Type  => $CacheType,
                Value => {
                    Init     => $InitValue,
                    Settings => \@ParsedSettings,
                },
                TTL => 60 * 60 * 24 * 20,
            );
        }
    }

    # Combine everything together in the correct order.
    my %Settings;
    for my $Init (qw(Framework Application Config Changes)) {
        SETTING:
        for my $Setting ( @{ $SettingsByInit{$Init} } ) {
            my $Name = $Setting->{XMLContentParsed}->{Name};
            next SETTING if !$Name;

            $Settings{$Name} = $Setting;
        }
    }

    # Find and remove all settings that are in DB, but are not defined in XML files.
    if ( $Param{CleanUp} ) {
        $Self->_DBCleanUp( Settings => \%Settings );
    }

    # Lock all settings to be able to update them if needed.
    my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
        UserID  => $Param{UserID},
        LockAll => 1,
    );
    if ( !$ExclusiveLockGUID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "System was unable to lock Default Settings ",
        );
        return;
    }

    my @SettingList = $Self->ConfigurationList(
        IncludeInvisible => 1,
    );

    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

    if ( !@SettingList ) {
        my $Success = $Self->_DefaultSettingAddBulk(
            Settings    => \%Settings,
            SettingList => \@SettingList,
            UserID      => $Param{UserID},
        );

        return if !$Success;
    }
    else {

        my %DefaultSettingsAdd;

        # Build setting list hash, to avoid slow grep expressions.
        my %SettingListLookup = map { $_->{Name} => $_ } @SettingList;

        # Create/Update settings in DB.
        SETTING:
        for my $SettingName ( sort keys %Settings ) {

            my $DefaultSetting = $SettingListLookup{$SettingName};

            if ( IsHashRefWithData($DefaultSetting) ) {

                # Compare new Setting XML with the old one (skip if there is no difference).
                my $Updated = $Settings{$SettingName}->{XMLContentRaw} ne $DefaultSetting->{XMLContentRaw};
                $Updated ||= $Settings{$SettingName}->{XMLFilename} ne $DefaultSetting->{XMLFilename};

                next SETTING if !$Updated;

                # Create a local clone of the value to prevent any modification.
                my $Value = $StorableObject->Clone(
                    Data => $Settings{$SettingName}->{XMLContentParsed}->{Value},
                );

                my $EffectiveValue = $Self->SettingEffectiveValueGet(
                    Value => $Value,
                );

                # Update default setting.
                my $Success = $SysConfigDBObject->DefaultSettingUpdate(
                    DefaultID      => $DefaultSetting->{DefaultID},
                    Name           => $Settings{$SettingName}->{XMLContentParsed}->{Name},
                    Description    => $Settings{$SettingName}->{XMLContentParsed}->{Description}->[0]->{Content} || '',
                    Navigation     => $Settings{$SettingName}->{XMLContentParsed}->{Navigation}->[0]->{Content} || '',
                    IsInvisible    => $Settings{$SettingName}->{XMLContentParsed}->{Invisible} || 0,
                    IsReadonly     => $Settings{$SettingName}->{XMLContentParsed}->{ReadOnly} || 0,
                    IsRequired     => $Settings{$SettingName}->{XMLContentParsed}->{Required} || 0,
                    IsValid        => $Settings{$SettingName}->{XMLContentParsed}->{Valid} || 0,
                    HasConfigLevel => $Settings{$SettingName}->{XMLContentParsed}->{ConfigLevel} || 100,
                    UserModificationPossible => $Settings{$SettingName}->{XMLContentParsed}->{UserModificationPossible}
                        || 0,
                    UserModificationActive => $Settings{$SettingName}->{XMLContentParsed}->{UserModificationActive}
                        || 0,
                    UserPreferencesGroup => $Settings{$SettingName}->{XMLContentParsed}->{UserPreferencesGroup},
                    XMLContentRaw        => $Settings{$SettingName}->{XMLContentRaw},
                    XMLContentParsed     => $Settings{$SettingName}->{XMLContentParsed},
                    XMLFilename          => $Settings{$SettingName}->{XMLFilename},
                    EffectiveValue       => $EffectiveValue,
                    UserID               => $Param{UserID},
                    ExclusiveLockGUID    => $ExclusiveLockGUID,
                );
                if ( !$Success ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message =>
                            "DefaultSettingUpdate failed for Config Item: $SettingName!",
                    );
                }

                my @ModifiedList = $SysConfigDBObject->ModifiedSettingListGet(
                    Name => $Settings{$SettingName}->{XMLContentParsed}->{Name},
                );

                for my $ModifiedSetting (@ModifiedList) {

                    # So far everything is OK, if the structure or values does
                    # not match anymore, modified values must be deleted.
                    my %ValueCheckResult = $Self->SettingEffectiveValueCheck(
                        EffectiveValue   => $ModifiedSetting->{EffectiveValue},
                        XMLContentParsed => $Settings{$SettingName}->{XMLContentParsed},
                        SettingUID       => $ModifiedSetting->{SettingUID},
                        StoreCache       => 1,
                        UserID           => $Param{UserID},
                    );

                    if ( !$ValueCheckResult{Success} ) {

                        $SysConfigDBObject->ModifiedSettingDelete(
                            ModifiedID => $ModifiedSetting->{ModifiedID},
                        );

                        $Kernel::OM->Get('Kernel::System::Log')->Log(
                            Priority => 'error',
                            Message  => $ValueCheckResult{Error},
                        );
                    }
                }
            }
            else {

                # Create a local clone of the value to prevent any modification.
                my $Value = $StorableObject->Clone(
                    Data => $Settings{$SettingName}->{XMLContentParsed}->{Value},
                );

                my $EffectiveValue = $Self->SettingEffectiveValueGet(
                    Value => $Value,
                );

                $DefaultSettingsAdd{ $Settings{$SettingName}->{XMLContentParsed}->{Name} } = {
                    Name           => $Settings{$SettingName}->{XMLContentParsed}->{Name},
                    Description    => $Settings{$SettingName}->{XMLContentParsed}->{Description}->[0]->{Content} || '',
                    Navigation     => $Settings{$SettingName}->{XMLContentParsed}->{Navigation}->[0]->{Content} || '',
                    IsInvisible    => $Settings{$SettingName}->{XMLContentParsed}->{Invisible} || 0,
                    IsReadonly     => $Settings{$SettingName}->{XMLContentParsed}->{ReadOnly} || 0,
                    IsRequired     => $Settings{$SettingName}->{XMLContentParsed}->{Required} || 0,
                    IsValid        => $Settings{$SettingName}->{XMLContentParsed}->{Valid} || 0,
                    HasConfigLevel => $Settings{$SettingName}->{XMLContentParsed}->{ConfigLevel} || 100,
                    UserModificationPossible => $Settings{$SettingName}->{XMLContentParsed}->{UserModificationPossible}
                        || 0,
                    UserModificationActive => $Settings{$SettingName}->{XMLContentParsed}->{UserModificationActive}
                        || 0,
                    UserPreferencesGroup => $Settings{$SettingName}->{XMLContentParsed}->{UserPreferencesGroup},
                    XMLContentRaw        => $Settings{$SettingName}->{XMLContentRaw},
                    XMLContentParsed     => $Settings{$SettingName}->{XMLContentParsed},
                    XMLFilename          => $Settings{$SettingName}->{XMLFilename},
                    EffectiveValue       => $EffectiveValue,
                    NoCleanup            => 1,
                    UserID               => $Param{UserID},
                };

                # Delete individual cache.
                $CacheObject->Delete(
                    Type => 'SysConfigDefault',
                    Key  => 'DefaultSettingGet::' . $Settings{$SettingName}->{XMLContentParsed}->{Name},
                );
            }
        }

        if (%DefaultSettingsAdd) {
            my $Success = $Self->_DefaultSettingAddBulk(
                Settings    => \%DefaultSettingsAdd,
                SettingList => \@SettingList,
                UserID      => $Param{UserID},
            );
            return if !$Success;
        }
    }

    # Unlock all the settings so they can be locked again afterwards.
    $SysConfigDBObject->DefaultSettingUnlock(
        UnlockAll => 1,
    );

    return 1;
}

=head2 ConfigurationNavigationTree()

Returns navigation tree in the hash format.

    my %Result = $SysConfigObject->ConfigurationNavigationTree(
        RootNavigation         => 'Parent',     # (optional) If provided only sub groups of the root navigation are returned.
        UserModificationActive => 1,            # (optional) Return settings that can be modified on user level only.
        IsValid                => 1,            # (optional) By default, display all settings.
        Category               => 'OTRS'        # (optional)
    );

Returns:

    %Result = (
        'Core' => {
            'Core::Cache' => {},
            'Core::CustomerCompany' => {},
            'Core::CustomerUser' => {},
            'Core::Daemon' => {
                'Core::Daemon::ModuleRegistration' => {},
            },
            ...
        'Crypt' =>{
            ...
        },
        ...
    );

=cut

sub ConfigurationNavigationTree {
    my ( $Self, %Param ) = @_;

    $Param{RootNavigation}         //= '';
    $Param{UserModificationActive} //= '0';

    my $CacheType = 'SysConfigNavigation';
    my $CacheKey  = "NavigationTree::$Param{RootNavigation}::$Param{UserModificationActive}";
    if ( defined $Param{IsValid} ) {
        if ( $Param{IsValid} ) {
            $CacheKey .= '::Valid';
        }
        else {
            $CacheKey .= '::Invalid';
        }
    }
    if ( defined $Param{Category} && $Param{Category} ) {
        if ( $Param{Category} eq 'All' ) {
            delete $Param{Category};
        }
        else {
            $CacheKey .= "::Category=$Param{Category}";
        }
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my %CategoryOptions;
    if ( $Param{Category} ) {
        my %Categories = $Self->ConfigurationCategoriesGet();
        if ( $Categories{ $Param{Category} } ) {
            %CategoryOptions = (
                Category      => $Param{Category},
                CategoryFiles => $Categories{ $Param{Category} }->{Files},
            );
        }
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Get all default settings
    my @SettingsRaw = $SysConfigDBObject->DefaultSettingListGet(
        %CategoryOptions,
        UserModificationActive => $Param{UserModificationActive} || undef,
        IsValid                => $Param{IsValid},
    );

    # For AgentPreference take into account which settings are Forbidden to update by user or disabled when counting
    #   settings. See bug#13488 (https://bugs.otrs.org/show_bug.cgi?id=13488).
    if ( $Param{Action} && $Param{Action} eq 'AgentPreferences' ) {

        # Get List of all modified settings which are valid and forbidden to update by user.
        my @ForbiddenSettings = $SysConfigDBObject->ModifiedSettingListGet(
            %CategoryOptions,
            UserModificationActive => 0,
            IsValid                => 1,
        );

        # Get List of all modified settings which are invalid and allowed to update by user.
        my @InvalidSettings = $SysConfigDBObject->ModifiedSettingListGet(
            %CategoryOptions,
            UserModificationActive => 1,
            IsValid                => 0,
        );

        my @ModifiedSettings;
        for my $Setting (@SettingsRaw) {
            push @ModifiedSettings, $Setting
                if !grep { $_->{Name} eq $Setting->{Name} } ( @ForbiddenSettings, @InvalidSettings );
        }
        @SettingsRaw = @ModifiedSettings;

        # Add settings which by default are not UserModifiedActive and are changed, to the navigation list
        #   in preference screen. Please see bug#13489 for more information.
        @ModifiedSettings = $SysConfigDBObject->ModifiedSettingListGet(
            %CategoryOptions,
            UserModificationActive => 1,
            IsValid                => 1,
        );
        for my $Setting (@ModifiedSettings) {
            my %DefaultSetting = $SysConfigDBObject->DefaultSettingGet(
                Name => $Setting->{Name},
            );
            if ( !grep { $_->{Name} eq $DefaultSetting{Name} } @SettingsRaw ) {
                push @SettingsRaw, \%DefaultSetting;
            }
        }
    }

    my @Settings;

    # Skip invisible settings from the navigation tree
    SETTING:
    for my $Setting (@SettingsRaw) {
        next SETTING if $Setting->{IsInvisible};

        push @Settings, {
            Name       => $Setting->{Name},
            Navigation => $Setting->{Navigation},
        };
    }

    my %Result = ();

    my @RootNavigation;
    if ( $Param{RootNavigation} ) {
        @RootNavigation = split "::", $Param{RootNavigation};
    }

    # Remember ancestors.
    for my $Index ( 1 .. $#RootNavigation ) {
        $RootNavigation[$Index] = $RootNavigation[ $Index - 1 ] . '::' . $RootNavigation[$Index];
    }

    SETTING:
    for my $Setting (@Settings) {
        next SETTING if !$Setting->{Navigation};
        my @Path = split "::", $Setting->{Navigation};

        # Remember ancestors.
        for my $Index ( 1 .. $#Path ) {
            $Path[$Index] = $Path[ $Index - 1 ] . '::' . $Path[$Index];
        }

        # Check if RootNavigation matches current setting.
        for my $Index ( 0 .. $#RootNavigation ) {
            next SETTING if !$Path[$Index];

            if ( $RootNavigation[$Index] ne $Path[$Index] ) {
                next SETTING;
            }
        }

        # Remove root groups from Path.
        for my $Index ( 0 .. $#RootNavigation ) {
            shift @Path;
        }

        %Result = $Self->_NavigationTree(
            Tree  => \%Result,
            Array => \@Path,
        );
    }

 # Until now we have structure of the Navigation tree without sub-node count. We need this number to disable
 # click on empty nodes. We could implement that in the _NavigationTree, but it's not efficient(loop of 1800+ settings).
 # Instead, we extend result in the _NavigationTreeNodeCount.
    %Result = $Self->_NavigationTreeNodeCount(
        Tree     => \%Result,
        Settings => \@Settings,
    );

    # Cache the results.
    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%Result,
        TTL   => 30 * 24 * 60 * 60,
    );

    return %Result;
}

=head2 ConfigurationListGet()

Returns list of settings that matches provided parameters.

    my @List = $SysConfigObject->ConfigurationListGet(
        Navigation           => 'SomeNavigationGroup',  # (optional) limit to the settings that have provided navigation
        TargetUserID         => 2,                      # (optional) if provided, system returns setting for particular user only,
                                                        #       otherwise, returns global setting list
        IsValid              => 1,                      # (optional) by default returns valid and invalid settings.
        Invisible            => 0,                      # (optional) Include Invisible settings. By default, not included.
        UserPreferencesGroup => 'Advanced',             # (optional) filter list by group.
        Translate            => 0,                      # (optional) Translate translatable string in EffectiveValue. Default 0.
        OverriddenInXML      => 1,                      # (optional) Consider changes made in Perl files. Default 0. Use it in modules only!
        UserID               => 1,                      # Required if OverriddenInXML is set.
    );

Returns:

    @List = (
        {
            DefaultID                => 123,
            ModifiedID               => 456,     # if modified
            Name                     => "ProductName",
            Description              => "Defines the name of the application ...",
            Navigation               => "ASimple::Path::Structure",
            IsInvisible              => 1,
            IsReadonly               => 0,
            IsRequired               => 1,
            IsValid                  => 1,
            HasConfigLevel           => 200,
            UserModificationPossible => 0,          # 1 or 0
            UserModificationActive   => 0,          # 1 or 0
            UserPreferencesGroup     => 'Advanced', # optional
            XMLContentRaw            => "The XML structure as it is on the config file",
            XMLContentParsed         => "XML parsed to Perl",
            XMLFilename              => "Daemon.xml",
            EffectiveValue           => "Product 6",
            DefaultValue             => "Product 5",
            IsModified               => 1,       # 1 or 0
            IsDirty                  => 1,       # 1 or 0
            ExclusiveLockGUID        => 'A32CHARACTERLONGSTRINGFORLOCKING',
            ExclusiveLockUserID      => 1,
            ExclusiveLockExpiryTime  => '2016-05-29 11:09:04',
            CreateTime               => "2016-05-29 11:04:04",
            ChangeTime               => "2016-05-29 11:04:04",
            OverriddenFileName        => 'ZZZDefauls.pm'
        },
        {
            DefaultID     => 321,
            Name          => 'FieldName',
            # ...
            CreateTime    => '2010-09-11 10:08:00',
            ChangeTime    => '2011-01-01 01:01:01',
        },
        # ...
    );

=cut

sub ConfigurationListGet {
    my ( $Self, %Param ) = @_;

    if ( $Param{OverriddenInXML} && !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'UserID is needed when OverriddenInXML is set!',
        );
        return;
    }

    my $ConfigObject      = $Kernel::OM->Get('Kernel::Config');
    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    $Param{Translate} //= 0;    # don't translate by default

    my %CategoryOptions;
    if ( $Param{Category} ) {
        my %Categories = $Self->ConfigurationCategoriesGet();
        if ( $Categories{ $Param{Category} } ) {
            %CategoryOptions = (
                Category      => $Param{Category},
                CategoryFiles => $Categories{ $Param{Category} }->{Files},
            );
        }
    }

    # Get all default settings for this navigation group.
    my @ConfigurationList = $SysConfigDBObject->DefaultSettingListGet(
        Navigation               => $Param{Navigation},
        UserModificationPossible => $Param{TargetUserID} ? 1 : undef,
        UserPreferencesGroup     => $Param{UserPreferencesGroup} || undef,
        IsInvisible              => $Param{Invisible} ? undef : 0,
        %CategoryOptions,
    );

    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

    # Update setting values with the modified settings.
    SETTING:
    for my $Setting (@ConfigurationList) {

        if ( $Param{TargetUserID} ) {
            my %SettingGlobal = $Self->SettingGet(
                Name      => $Setting->{Name},
                IsGlobal  => 1,
                Translate => $Param{Translate},
            );

            if ( %SettingGlobal && $SettingGlobal{ModifiedID} ) {

                # There is modified setting, but we need last deployed version.
                my %SettingDeployed = $SysConfigDBObject->ModifiedSettingVersionGetLast(
                    Name => $Setting->{Name},
                );

                if ( !IsHashRefWithData( \%SettingDeployed ) ) {
                    %SettingDeployed = $Self->SettingGet(
                        Name      => $Setting->{Name},
                        Default   => 1,
                        Translate => $Param{Translate},
                    );
                }

                $Setting = {
                    %SettingGlobal,
                    %SettingDeployed,
                };
            }
            else {

                # Use default value.
                my %SettingDefault = $Self->SettingGet(
                    Name      => $Setting->{Name},
                    Default   => 1,
                    Translate => $Param{Translate},
                );

                $Setting = \%SettingDefault;
            }
        }

        # Remember default value.
        $Setting->{DefaultValue} = $Setting->{EffectiveValue};
        if ( ref $Setting->{EffectiveValue} ) {
            $Setting->{DefaultValue} = $StorableObject->Clone(
                Data => $Setting->{EffectiveValue},
            );
        }

        my %ModifiedSetting = $Self->SettingGet(
            Name            => $Setting->{Name},
            TargetUserID    => $Param{TargetUserID} // undef,
            Translate       => $Param{Translate},
            OverriddenInXML => $Param{OverriddenInXML},
            UserID          => $Param{UserID},
        );

        # Skip if setting is invalid.
        next SETTING if !IsHashRefWithData( \%ModifiedSetting );
        next SETTING if !defined $ModifiedSetting{EffectiveValue};

        # Mark setting as modified.
        my $IsModified = DataIsDifferent(
            Data1 => \$Setting->{EffectiveValue},
            Data2 => \$ModifiedSetting{EffectiveValue},
        ) || 0;

        $IsModified ||= $ModifiedSetting{IsValid} != $Setting->{IsValid};
        $IsModified ||= $ModifiedSetting{UserModificationActive} != $Setting->{UserModificationActive};

        $Setting->{IsModified} = $IsModified ? 1 : 0;

        # Update setting attributes.
        ATTRIBUTE:
        for my $Attribute (
            qw(ModifiedID IsValid UserModificationActive UserPreferencesGroup EffectiveValue IsDirty ChangeTime XMLContentParsed SettingUID OverriddenFileName)
            )
        {
            next ATTRIBUTE if !defined $ModifiedSetting{$Attribute};

            $Setting->{$Attribute} = $ModifiedSetting{$Attribute};
        }
    }

    if ( defined $Param{IsValid} ) {
        @ConfigurationList = grep { $_->{IsValid} == $Param{IsValid} } @ConfigurationList;
    }

    if ( $Param{TargetUserID} ) {

        # List contains all settings that can be activated. Get only those that are really activated.
        @ConfigurationList = grep { $_->{UserModificationActive} } @ConfigurationList;
    }

    return @ConfigurationList;
}

=head2 ConfigurationList()

Wrapper of Kernel::System::SysConfig::DB::DefaultSettingList() - Get list of all settings.

    my @SettingList = $SysConfigObject->ConfigurationList();

Returns:

    @SettingList = (
        {
            DefaultID => '123',
            Name      => 'SettingName1',
            IsDirty   => 1,
        },
        {
            DefaultID => '124',
            Name      => 'SettingName2',
            IsDirty   => 0
        },
        ...
    );

=cut

sub ConfigurationList {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DefaultSettingList(%Param);
}

=head2 ConfigurationInvalidList()

Returns list of enabled settings that have invalid effective value.

    my @List = $SysConfigObject->ConfigurationInvalidList(
        CachedOnly  => 0,   # (optional) Default 0. If enabled, system will return cached value.
                            #                 If there is no cache yet, system will return empty list, but
                            #                 it will also trigger async call to generate cache.
        Undeployed  => 1,   # (optional) Default 0. Check settings that are not deployed as well.
        NoCache     => 1,   # (optional) Default 0. If enabled, system won't check the cached value.
    );

Returns:

    @List = ( "Setting1", "Setting5", ... );

=cut

sub ConfigurationInvalidList {
    my ( $Self, %Param ) = @_;

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType = 'SysConfig';
    my $CacheKey  = 'ConfigurationInvalidList';

    if ( $Param{Undeployed} ) {
        $CacheKey .= '::Undeployed';
    }

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return @{$Cache} if ref $Cache eq 'ARRAY' && !$Param{NoCache};

    if ( $Param{CachedOnly} ) {

        # There is no cache but caller expects quick answer. Return empty array, but create cache in async call.
        $Self->AsyncCall(
            ObjectName               => 'Kernel::System::SysConfig',
            FunctionName             => 'ConfigurationInvalidList',
            FunctionParams           => {},
            MaximumParallelInstances => 1,
        );

        return ();
    }

    my @SettingsEnabled = $Self->ConfigurationListGet(
        IsValid   => 1,
        Translate => 0,
    );

    my @InvalidSettings;

    my $DateTimeObject    = $Kernel::OM->Create('Kernel::System::DateTime');
    my $CurrentSystemTime = $DateTimeObject->ToEpoch();

    $DateTimeObject->Add(
        Months => 1,
    );
    my $ExpireTime = $DateTimeObject->ToEpoch();

    for my $Setting (@SettingsEnabled) {
        my %SettingData = $Self->SettingGet(
            Name     => $Setting->{Name},
            Deployed => $Param{Undeployed} ? undef : 1,
            NoCache  => $Param{NoCache},
        );

        my %EffectiveValueCheck = $Self->SettingEffectiveValueCheck(
            EffectiveValue    => $SettingData{EffectiveValue},
            XMLContentParsed  => $Setting->{XMLContentParsed},
            CurrentSystemTime => $CurrentSystemTime,
            ExpireTime        => $ExpireTime,
            UserID            => 1,
        );

        if ( $EffectiveValueCheck{Error} ) {
            push @InvalidSettings, $Setting->{Name};
        }
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \@InvalidSettings,
        TTL   => 60 * 60,             # 1 hour
    );

    return @InvalidSettings;
}

=head2 ConfigurationDeploy()

Write configuration items from database into a perl module file.

    my %Result = $SysConfigObject->ConfigurationDeploy(
        Comments            => "Some comments",     # (optional)
        NoValidation        => 0,                   # (optional) 1 or 0, default 0, skips settings validation
        UserID              => 123,                 # if ExclusiveLockGUID is used, UserID must match the user that creates the lock
        Force               => 1,                   # (optional) proceed even if lock is set to another user
        NotDirty            => 1,                   # (optional) do not use any values from modified dirty settings
        AllSettings         => 1,                   # (optional) use dirty modified settings from all users
        DirtySettings       => [                    # (optional) use only this dirty modified settings from the current user
            'SettingOne',
            'SettingTwo',
        ],
    );

Returns:

    %Result = (
        Success => 1,           # Deployment successful.
    );

    or

    %Result = (
        Success => 0,           # Deployment failed.
        Error   => 'Error...',  # Error message (if available)
    );

=cut

sub ConfigurationDeploy {
    my ( $Self, %Param ) = @_;

    my %Result = (
        Success => 0,
    );

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need UserID!",
        );

        return %Result;
    }
    if ( !IsPositiveInteger( $Param{UserID} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "UserID is invalid!",
        );
        return %Result;
    }

    my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

    if ( $Param{AllSettings} ) {
        $Param{NotDirty}      = 0;
        $Param{DirtySettings} = undef;
    }
    elsif ( $Param{NotDirty} ) {
        $Param{AllSettings}   = 0;
        $Param{DirtySettings} = undef;
    }

    $Param{NoValidation} //= 0;

    my $BasePath = 'Kernel/Config/Files/';

    # Parameter 'FileName' is intentionally not documented in the API as it is only used for testing.
    my $TargetPath = $BasePath . ( $Param{FileName} || "ZZZAAuto.pm" );

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my @UserDirtySettings = $SysConfigDBObject->ModifiedSettingListGet(
        IsDirty  => 1,
        ChangeBy => $Param{UserID},
    );
    my %UserDirtySettingsLookup = map { $_->{Name} => 1 } @UserDirtySettings;

    # Determine dirty settings to deploy (if not specified get all dirty settings from current user).
    if ( !$Param{DirtySettings} && !$Param{AllSettings} && !$Param{NotDirty} ) {
        @{ $Param{DirtySettings} } = keys %UserDirtySettingsLookup;
    }
    elsif ( $Param{DirtySettings} && !$Param{AllSettings} && !$Param{NotDirty} ) {

        my @DirtySettings;

        SETTING:
        for my $Setting ( @{ $Param{DirtySettings} } ) {
            next SETTING if !$UserDirtySettingsLookup{$Setting};
            push @DirtySettings, $Setting;
        }

        $Param{DirtySettings} = \@DirtySettings;
    }

    my @DirtyDefaultList = $SysConfigDBObject->DefaultSettingList(
        IsDirty => 1,
    );

    my $AddNewDeployment;

    # Check if deployment is really needed
    if ( $Param{NotDirty} ) {

        # Check if default settings are to be deployed
        if (@DirtyDefaultList) {
            $AddNewDeployment = 1;
        }
    }
    elsif ( $Param{AllSettings} ) {

        # Check if default settings are to be deployed
        if (@DirtyDefaultList) {
            $AddNewDeployment = 1;
        }
        else {

            my @DirtyModifiedSettings = $SysConfigDBObject->ModifiedSettingListGet(
                IsDirty => 1,
            );

            # Check if modified settings are to be deployed
            if (@DirtyModifiedSettings) {
                $AddNewDeployment = 1;
            }
        }
    }
    elsif ( $Param{DirtySettings} ) {

        # Check if default settings or user modified settings are to be deployed
        if ( @DirtyDefaultList || IsArrayRefWithData( $Param{DirtySettings} ) ) {
            $AddNewDeployment = 1;
        }
    }

    # In case none of the previous options applied and there is no deployment in the database,
    #   a new deployment is needed.
    my %LastDeployment = $SysConfigDBObject->DeploymentGetLast();
    if ( !%LastDeployment ) {
        $AddNewDeployment = 1;
    }

    my $EffectiveValueStrg = '';

    my @Settings = $Self->_GetSettingsToDeploy(
        %Param,
        NoCache => %LastDeployment ? 0 : 1,    # do not cache only during initial rebuild config
    );

    my %EffectiveValueCheckResult;

    my $MainObject     = $Kernel::OM->Get('Kernel::System::Main');
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

    my $DateTimeObject    = $Kernel::OM->Create('Kernel::System::DateTime');
    my $CurrentSystemTime = $DateTimeObject->ToEpoch();

    $DateTimeObject->Add(
        Months => 1,
    );
    my $ExpireTime = $DateTimeObject->ToEpoch();

    SETTING:
    for my $CurrentSetting (@Settings) {
        next SETTING if !$CurrentSetting->{IsValid};

        my %EffectiveValueCheck = $Self->SettingEffectiveValueCheck(
            XMLContentParsed  => $CurrentSetting->{XMLContentParsed},
            EffectiveValue    => $CurrentSetting->{EffectiveValue},
            NoValidation      => $Param{NoValidation},
            SettingUID        => $CurrentSetting->{SettingUID},
            CurrentSystemTime => $CurrentSystemTime,
            ExpireTime        => $ExpireTime,
            UserID            => $Param{UserID},
        );

        # Instead of caching for each setting(1800+), skip caching, but remember results and cache only once.
        my $ValueString = $Param{EffectiveValue} // '';
        if ( ref $ValueString ) {
            my $String = $StorableObject->Serialize(
                Data => $Param{EffectiveValue},
            );
            $ValueString = $MainObject->MD5sum(
                String => \$String,
            );
        }

        my $SettingKey = "$CurrentSetting->{SettingUID}::${ValueString}";
        $EffectiveValueCheckResult{$SettingKey} = \%EffectiveValueCheck;

        next SETTING if $EffectiveValueCheck{Success};

        # Check if setting is overridden, in this case allow deployment.
        my $OverriddenFileName = $Self->OverriddenFileNameGet(
            SettingName    => $CurrentSetting->{Name},
            UserID         => $Param{UserID},
            EffectiveValue => $CurrentSetting->{EffectiveValue},
        );

        if ($OverriddenFileName) {

            # Setting in the DB has invalid value, but it's overridden in perl file.

            # Note: This check can't be moved to the SettingEffectiveValueCheck(), since it works with Cache,
            # so if perl file is updated, changes won't be reflected.
            next SETTING;
        }

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Setting $CurrentSetting->{Name} Effective value is not correct: $EffectiveValueCheck{Error}",
        );

        $Result{Error} = $LanguageObject->Translate( "Invalid setting: %s", $CurrentSetting->{Name} );
        return %Result;
    }

    # Set cache for SettingEffectiveValueCheck().
    $Self->_SettingEffectiveValueCheckCacheSet(
        Value        => \%EffectiveValueCheckResult,
        NoValidation => $Param{NoValidation},
    );

    # Combine settings effective values into a perl string
    if ( IsArrayRefWithData( \@Settings ) ) {
        $EffectiveValueStrg = $Self->_EffectiveValues2PerlFile(
            Settings   => \@Settings,
            TargetPath => $TargetPath,
        );
        if ( !defined $EffectiveValueStrg ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not combine settings values into a perl hash",
            );

            $Result{Error} = $LanguageObject->Translate("Could not combine settings values into a perl hash.");
            return %Result;
        }
    }

    # Force new deployment if current DB settings are different from the last deployment.
    if ( !$AddNewDeployment ) {

        # Remove CurrentDeploymentID line for easy compare.
        my $LastDeploymentStrg = $LastDeployment{EffectiveValueStrg};
        $LastDeploymentStrg =~ s{\$Self->\{'CurrentDeploymentID'\} [ ] = [ ] '\d+';\n}{}msx;

        if ( $EffectiveValueStrg ne $LastDeploymentStrg ) {
            $AddNewDeployment = 1;
        }
    }

    if ($AddNewDeployment) {

        # Lock the deployment to be able add it to the DB.
        my $ExclusiveLockGUID = $SysConfigDBObject->DeploymentLock(
            UserID => $Param{UserID},
            Force  => $Param{Force},
        );
        if ( !$ExclusiveLockGUID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can not lock the deployment for UserID '$Param{UserID}'!",
            );

            $Result{Error} = $LanguageObject->Translate(
                "Can not lock the deployment for UserID '%s'!",
                $Param{UserID},
            );
            return %Result;
        }

        # Get system time stamp (string formatted).
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime'
        );
        my $TimeStamp = $DateTimeObject->ToString();

        my $HandleSettingsSuccess = $Self->_HandleSettingsToDeploy(
            %Param,
            DeploymentExclusiveLockGUID => $ExclusiveLockGUID,
            DeploymentTimeStamp         => $TimeStamp,
        );

        my $DeploymentID;

        if ($HandleSettingsSuccess) {

            # Add a new deployment in the DB.
            $DeploymentID = $SysConfigDBObject->DeploymentAdd(
                Comments            => $Param{Comments},
                EffectiveValueStrg  => \$EffectiveValueStrg,
                ExclusiveLockGUID   => $ExclusiveLockGUID,
                DeploymentTimeStamp => $TimeStamp,
                UserID              => $Param{UserID},
            );
            if ( !$DeploymentID ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not create the deployment in the DB!",
                );

            }
        }

        # Unlock the deployment, so new deployments can be added afterwards.
        my $Unlock = $SysConfigDBObject->DeploymentUnlock(
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => $Param{UserID},
        );
        if ( !$Unlock ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not remove deployment lock for UserID '$Param{UserID}'",
            );
        }

        # Make sure to return on errors after we unlock the deployment.
        if ( !$HandleSettingsSuccess || !$DeploymentID ) {
            return %Result;
        }

        # If setting is updated on global level, check all user specific settings, maybe it's needed
        #   to remove duplicates.
        if ( $Self->can('UserConfigurationResetToGlobal') ) {    # OTRS Business Solution™

            my @DeployedSettings;
            if ( $Param{DirtySettings} ) {
                @DeployedSettings = @{ $Param{DirtySettings} };
            }
            else {
                for my $Setting (@Settings) {
                    push @DeployedSettings, $Setting->{Name};
                }
            }

            if ( scalar @DeployedSettings ) {
                $Self->UserConfigurationResetToGlobal(
                    Settings => \@DeployedSettings,
                    UserID   => $Param{UserID},
                );
            }
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Delete categories cache.
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => 'ConfigurationCategoriesGet',
        );

        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => 'ConfigurationInvalidList',
        );
        $CacheObject->Delete(
            Type => 'SysConfig',
            Key  => 'ConfigurationInvalidList::Undeployed',
        );
    }
    else {
        $EffectiveValueStrg = $LastDeployment{EffectiveValueStrg};
    }

    # Base folder for deployment could be not present.
    if ( !-d $BasePath ) {
        mkdir $BasePath;
    }

    $Result{Success} = $Self->_FileWriteAtomic(
        Filename => "$Self->{Home}/$TargetPath",
        Content  => \$EffectiveValueStrg,
    );

    return %Result;
}

=head2 ConfigurationDeployList()

Get deployment list with complete data.

    my @List = $SysConfigObject->ConfigurationDeployList();

Returns:

    @List = (
        {
            DeploymentID       => 123,
            Comments           => 'Some Comments',
            EffectiveValueStrg => $SettingEffectiveValues,      # String with the value of all settings,
                                                                #   as seen in the Perl configuration file.
            CreateTime         => "2016-05-29 11:04:04",
            CreateBy           => 123,
        },
        {
            DeploymentID       => 456,
            Comments           => 'Some Comments',
            EffectiveValueStrg => $SettingEffectiveValues2,     # String with the value of all settings,
                                                                #   as seen in the Perl configuration file.
            CreateTime         => "2016-05-29 12:00:01",
            CreateBy           => 123,
        },
        # ...
    );

=cut

sub ConfigurationDeployList {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DeploymentListGet();
}

=head2 ConfigurationDeploySync()
Updates C<ZZZAAuto.pm> to the latest deployment found in the database.

    my $Success = $SysConfigObject->ConfigurationDeploySync();

=cut

sub ConfigurationDeploySync {
    my ( $Self, %Param ) = @_;

    my $Home       = $Self->{Home};
    my $TargetPath = "$Home/Kernel/Config/Files/ZZZAAuto.pm";

    if ( -e $TargetPath ) {
        if ( !require $TargetPath ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not load $TargetPath, $1",
            );
            return;
        }

        do $TargetPath;
    }

    $Kernel::OM->ObjectsDiscard(
        Objects => [ 'Kernel::Config', ],
    );

    my $CurrentDeploymentID = $Kernel::OM->Get('Kernel::Config')->Get('CurrentDeploymentID') || 0;

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Check that all deployments are valid, but wait if there are deployments in add procedure
    my $CleanupSuccess;
    TRY:
    for my $Try ( 1 .. 40 ) {
        $CleanupSuccess = $SysConfigDBObject->DeploymentListCleanup();
        last TRY if !$CleanupSuccess;
        last TRY if $CleanupSuccess == 1;
        sleep .5;
    }
    if ( $CleanupSuccess != 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "There are invalid deployments in the database that could not be removed!",
        );
        return;
    }

    my %LastDeployment = $SysConfigDBObject->DeploymentGetLast();

    if ( !%LastDeployment ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "No deployments found in Database!",
        );
        return;
    }

    if ( $CurrentDeploymentID ne $LastDeployment{DeploymentID} ) {

        # Write latest deployment to ZZZAAuto.pm
        my $EffectiveValueStrg = $LastDeployment{EffectiveValueStrg};
        my $Success            = $Self->_FileWriteAtomic(
            Filename => $TargetPath,
            Content  => \$EffectiveValueStrg,
        );

        return if !$Success;
    }

    # Sync also user specific settings (if available).
    return 1 if !$Self->can('UserConfigurationDeploySync');    # OTRS Business Solution™
    $Self->UserConfigurationDeploySync();

    return 1;
}

=head2 ConfigurationDeployCleanup()

Cleanup old deployments from the database.

    my $Success = $SysConfigObject->ConfigurationDeployCleanup();

Returns:

    $Success = 1;       # or false in case of an error

=cut

sub ConfigurationDeployCleanup {
    my ( $Self, %Param ) = @_;

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my @List    = $SysConfigDBObject->DeploymentListGet();
    my @ListIDs = map { $_->{DeploymentID} } @List;

    my $RemainingDeploments = $Kernel::OM->Get('Kernel::Config')->Get('SystemConfiguration::MaximumDeployments') // 20;
    @ListIDs = splice( @ListIDs, $RemainingDeploments );

    DEPLOYMENT:
    for my $DeploymentID (@ListIDs) {

        my $Success = $SysConfigDBObject->DeploymentDelete(
            DeploymentID => $DeploymentID,
        );

        if ( !$Success ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "Was not possible to delete deployment $DeploymentID!",
            );
            next DEPLOYMENT;
        }
    }

    return 1;
}

=head2 ConfigurationDeployGet()

Wrapper of Kernel::System::SysConfig::DB::DeploymentGet() - Get deployment information.

    my %Deployment = $SysConfigObject->ConfigurationDeployGet(
        DeploymentID => 123,
    );

Returns:

    %Deployment = (
        DeploymentID       => 123,
        Comments           => 'Some Comments',
        EffectiveValueStrg => $SettingEffectiveValues,      # String with the value of all settings,
                                                            #   as seen in the Perl configuration file.
        CreateTime         => "2016-05-29 11:04:04",
        CreateBy           => 123,
    );

=cut

sub ConfigurationDeployGet {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DeploymentGet(%Param);
}

=head2 ConfigurationDeployGetLast()

Wrapper of Kernel::System::SysConfig::DBDeploymentGetLast() - Get last deployment information.

    my %Deployment = $SysConfigObject->ConfigurationDeployGetLast();

Returns:

    %Deployment = (
        DeploymentID       => 123,
        Comments           => 'Some Comments',
        EffectiveValueStrg => $SettingEffectiveValues,      # String with the value of all settings,
                                                            #   as seen in the Perl configuration file.
        CreateTime         => "2016-05-29 11:04:04",
        CreateBy           => 123,
    );

=cut

sub ConfigurationDeployGetLast {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DeploymentGetLast();
}

=head2 ConfigurationDeploySettingsListGet()

Gets full modified settings information contained on a given deployment.

    my @List = $SysConfigObject->ConfigurationDeploySettingsListGet(
        DeploymentID => 123,
    );

Returns:

    @List = (
        {
            DefaultID                => 123,
            ModifiedID               => 456,
            ModifiedVersionID        => 789,
            Name                     => "ProductName",
            Description              => "Defines the name of the application ...",
            Navigation               => "ASimple::Path::Structure",
            IsInvisible              => 1,
            IsReadonly               => 0,
            IsRequired               => 1,
            IsValid                  => 1,
            HasConfigLevel           => 200,
            UserModificationPossible => 0,       # 1 or 0
            XMLContentRaw            => "The XML structure as it is on the config file",
            XMLContentParsed         => "XML parsed to Perl",
            EffectiveValue           => "Product 6",
            DefaultValue             => "Product 5",
            IsModified               => 1,       # 1 or 0
            IsDirty                  => 1,       # 1 or 0
            ExclusiveLockGUID        => 'A32CHARACTERLONGSTRINGFORLOCKING',
            ExclusiveLockUserID      => 1,
            ExclusiveLockExpiryTime  => '2016-05-29 11:09:04',
            CreateTime               => "2016-05-29 11:04:04",
            ChangeTime               => "2016-05-29 11:04:04",
        },
        {
            DefaultID         => 321,
            ModifiedID        => 654,
            ModifiedVersionID => 987,
             Name             => 'FieldName',
            # ...
            CreateTime => '2010-09-11 10:08:00',
            ChangeTime => '2011-01-01 01:01:01',
        },
        # ...
    );

=cut

sub ConfigurationDeploySettingsListGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{DeploymentID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need DeploymentID",
        );
        return;
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # get modified version of this deployment
    my %ModifiedVersionList = $SysConfigDBObject->DeploymentModifiedVersionList(
        DeploymentID => $Param{DeploymentID},
    );

    my @ModifiedVersions = sort keys %ModifiedVersionList;

    my @Settings;
    for my $ModifiedVersionID ( sort @ModifiedVersions ) {

        my %Versions;

        # Get the modified version.
        my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGet(
            ModifiedVersionID => $ModifiedVersionID,
        );

        # Get default version.
        my %DefaultSetting = $SysConfigDBObject->DefaultSettingVersionGet(
            DefaultVersionID => $ModifiedSettingVersion{DefaultVersionID},
        );

        # Update default setting attributes.
        for my $Attribute (
            qw(ModifiedID IsValid EffectiveValue IsDirty CreateTime ChangeTime)
            )
        {
            $DefaultSetting{$Attribute} = $ModifiedSettingVersion{$Attribute};
        }

        $DefaultSetting{ModifiedVersionID} = $ModifiedVersionID;

        push @Settings, \%DefaultSetting;
    }

    return @Settings;
}

=head2 ConfigurationIsDirtyCheck()

Check if there are not deployed changes on system configuration.

    my $Result = $SysConfigObject->ConfigurationIsDirtyCheck(
        UserID => 123,      # optional, the user that changes a modified setting
    );

Returns:

    $Result = 1;    # or 0 if configuration is not dirty.

=cut

sub ConfigurationIsDirtyCheck {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::SysConfig::DB')->ConfigurationIsDirty(%Param);
}

=head2 ConfigurationDump()

Creates a YAML file with the system configuration settings.

    my $ConfigurationDumpYAML = $SysConfigObject->ConfigurationDump(
        OnlyValues           => 0,  # optional, default 0, dumps only the setting effective value instead of the whole setting attributes.
        SkipDefaultSettings  => 0,  # optional, default 0, do not include default settings
        SkipModifiedSettings => 0,  # optional, default 0, do not include modified settings
        SkipUserSettings     => 0,  # optional, default 0, do not include user settings
        DeploymentID         => 123, # optional, if it is provided the modified settings are retrieved from versions
    );

Returns:

    my $ConfigurationDumpYAML = '---
Default:
  Setting1:
    DefaultID: 23766
    Name: Setting1
    # ...
  Setting2:
  # ...
Modified:
  Setting1
    DefaultID: 23776
    ModifiedID: 1250
    Name: Setting1
    # ...
  # ...
JDoe:
  Setting2
    DefaultID: 23777
    ModifiedID: 1251
    Name: Setting2
    # ...
  # ...
# ...

or

    my $ConfigurationDumpYAML = $SysConfigObject->ConfigurationDump(
        OnlyValues => 1,
    );

Returns:

    my $ConfigurationDumpYAML = '---
Default:
  Setting1: Test
  Setting2: Test
  # ...
Modified:
  Setting1: TestUpdate
  # ...
JDoe:
  Setting2: TestUser
  # ...
# ...
';

=cut

sub ConfigurationDump {
    my ( $Self, %Param ) = @_;

    my $Result = {};

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    if ( !$Param{SkipDefaultSettings} ) {

        my @SettingsList = $SysConfigDBObject->DefaultSettingListGet();

        SETTING:
        for my $Setting (@SettingsList) {
            if ( $Param{OnlyValues} ) {
                $Result->{Default}->{ $Setting->{Name} } = $Setting->{EffectiveValue};
                next SETTING;
            }
            $Result->{Default}->{ $Setting->{Name} } = $Setting;
        }

    }

    if ( !$Param{SkipModifiedSettings} || !$Param{SkipUserSettings} ) {
        my @SettingsList;

        if ( !$Param{DeploymentID} ) {
            @SettingsList = $SysConfigDBObject->ModifiedSettingListGet();
        }
        else {
            # Get the modified versions involved into the deployment
            my %ModifiedVersionList = $SysConfigDBObject->DeploymentModifiedVersionList(
                DeploymentID => $Param{DeploymentID},
            );

            return if !%ModifiedVersionList;

            my @ModifiedVersions = sort keys %ModifiedVersionList;

            MODIFIEDVERSIONID:
            for my $ModifiedVersionID (@ModifiedVersions) {

                my %ModifiedSettingVersion = $SysConfigDBObject->ModifiedSettingVersionGet(
                    ModifiedVersionID => $ModifiedVersionID,
                );
                next MODIFIEDVERSIONID if !%ModifiedSettingVersion;

                push @SettingsList, \%ModifiedSettingVersion;
            }
        }

        if ( !$Param{SkipModifiedSettings} ) {
            SETTING:
            for my $Setting (@SettingsList) {
                next SETTING if $Setting->{TargetUserID};

                if ( $Param{OnlyValues} ) {
                    $Result->{'Modified'}->{ $Setting->{Name} } = $Setting->{EffectiveValue};
                    next SETTING;
                }
                $Result->{'Modified'}->{ $Setting->{Name} } = $Setting;
            }
        }

        if ( !$Param{SkipUserSettings} && $Self->can('UserConfigurationDump') ) {    # OTRS Business Solution™
            my %UserSettings = $Self->UserConfigurationDump(
                SettingList => \@SettingsList,
                OnlyValues  => $Param{OnlyValues},
            );
            if ( scalar keys %UserSettings ) {
                %{$Result} = ( %{$Result}, %UserSettings );
            }
        }
    }

    my $YAMLString = $Kernel::OM->Get('Kernel::System::YAML')->Dump(
        Data => $Result,
    );

    return $YAMLString;
}

=head2 ConfigurationLoad()

Takes a YAML file with settings definition and try to import it into the system.

    my $Success = $SysConfigObject->ConfigurationLoad(
        ConfigurationYAML   => $YAMLString,     # a YAML string in the format of L<ConfigurationDump()>
        UserID              => 123,
    );

=cut

sub ConfigurationLoad {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(ConfigurationYAML UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    my %ConfigurationRaw
        = %{ $Kernel::OM->Get('Kernel::System::YAML')->Load( Data => $Param{ConfigurationYAML} ) || {} };

    if ( !%ConfigurationRaw ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "ConfigurationYAML is invalid!",
        );

        return;
    }

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');

    # Get the configuration sections to import (skip Default and non existing users).
    my $ValidSections;
    my %Configuration;
    SECTION:
    for my $Section ( sort keys %ConfigurationRaw ) {

        next SECTION if $Section eq 'Default';

        if ( $Section eq 'Modified' ) {
            $Configuration{$Section} = $ConfigurationRaw{$Section};
            next SECTION;
        }

        my $UserID = $UserObject->UserLookup(
            UserLogin => $Section,
            Silent    => 1,
        );

        if ( !$UserID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "Settings for user $Section could not be added! User does not exists.",
            );
            next SECTION;
        }

        $Configuration{$UserID} = $ConfigurationRaw{$Section};

    }

    # Early return if there is nothing to update.
    return 1 if !%Configuration;

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
    my $Result            = 1;

    SECTION:
    for my $Section ( sort keys %Configuration ) {

        my $UserID      = '';
        my $ScopeString = '(global)';

        my $TargetUserID = undef;
        if ( lc $Section ne lc 'Modified' ) {
            $TargetUserID = $Section;
            $UserID       = $Section;
            $ScopeString  = "(for user $Section)";
        }

        SETTINGNAME:
        for my $SettingName ( sort keys %{ $Configuration{$Section} } ) {

            my %CurrentSetting = $Self->SettingGet(
                Name => $SettingName,
            );

            # Set error in case non existing settings (either default or modified);
            if ( !%CurrentSetting ) {
                $Result = '-1';
                next SETTINGNAME;
            }

            my $ExclusiveLockGUID = $SysConfigDBObject->DefaultSettingLock(
                Name   => $SettingName,
                Force  => 1,
                UserID => $UserID || $Param{UserID},
            );

            my $UserModificationActive = $TargetUserID ? undef : $CurrentSetting{UserModificationActive};

            my %Result = $Self->SettingUpdate(
                Name                   => $SettingName,
                IsValid                => $Configuration{$Section}->{$SettingName}->{IsValid},
                EffectiveValue         => $Configuration{$Section}->{$SettingName}->{EffectiveValue},
                UserModificationActive => $UserModificationActive,
                TargetUserID           => $TargetUserID,
                ExclusiveLockGUID      => $ExclusiveLockGUID,
                UserID                 => $UserID || $Param{UserID},
            );
            if ( !$Result{Success} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Setting $SettingName $ScopeString was not correctly updated!",
                );

                $Result = '-1';
            }
        }

        # Only deploy user specific settings;
        next SECTION if !$TargetUserID;
        next SECTION if !$Self->can('UserConfigurationDeploy');    # OTRS Business Solution™

        # Deploy user configuration requires another package to be installed.
        my $Success = $Self->UserConfigurationDeploy(
            TargetUserID => $TargetUserID,
            UserID       => $Param{UserID},
        );

    }

    return $Result;
}

=head2 ConfigurationDirtySettingsList()

Returns a list of setting names that are dirty.

    my @Result = $SysConfigObject->ConfigurationDirtySettingsList(
        ChangeBy => 123,
    );

Returns:

    $Result = ['SettingA', 'SettingB', 'SettingC'];

=cut

sub ConfigurationDirtySettingsList {
    my ( $Self, %Param ) = @_;

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my @DefaultSettingsList = $SysConfigDBObject->DefaultSettingListGet(
        IsDirty => 1,
    );
    @DefaultSettingsList = map { $_->{Name} } @DefaultSettingsList;

    my @ModifiedSettingsList = $SysConfigDBObject->ModifiedSettingListGet(
        IsDirty  => 1,
        IsGlobal => 1,
        ChangeBy => $Param{ChangeBy} || undef,
    );
    @ModifiedSettingsList = map { $_->{Name} } @ModifiedSettingsList;

    # Combine Default and Modified dirty settings.
    my @ListNames = ( @DefaultSettingsList, @ModifiedSettingsList );
    my %Names     = map { $_ => 1 } @ListNames;
    @ListNames = sort keys %Names;

    return @ListNames;
}

=head2 ConfigurationLockedSettingsList()

Returns a list of setting names that are locked in general or by user.

    my @Result = $SysConfigObject->ConfigurationLockedSettingsList(
        ExclusiveLockUserID       => 2, # Optional, ID of the user for which the default setting is locked
    );

Returns:

    $Result = ['SettingA', 'SettingB', 'SettingC'];

=cut

sub ConfigurationLockedSettingsList {
    my ( $Self, %Param ) = @_;

    my @DefaultSettingsList = $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DefaultSettingListGet(
        Locked => 1,
    );

    return if !IsArrayRefWithData( \@DefaultSettingsList );

    if ( $Param{ExclusiveLockUserID} ) {
        @DefaultSettingsList
            = map { $_->{Name} } grep { $_->{ExclusiveLockUserID} eq $Param{ExclusiveLockUserID} } @DefaultSettingsList;
    }
    else {
        @DefaultSettingsList = map { $_->{Name} } @DefaultSettingsList;
    }

    return @DefaultSettingsList;
}

=head2 ConfigurationSearch()

Returns a list of setting names.

    my @Result = $SysConfigObject->ConfigurationSearch(
        Search           => 'The search string', # (optional)
        Category         => 'OTRS'               # (optional)
        IncludeInvisible => 1,                   # (optional) Default 0.
    );

Returns:

    $Result = ['SettingA', 'SettingB', 'SettingC'];

=cut

sub ConfigurationSearch {
    my ( $Self, %Param ) = @_;

    if ( !$Param{Search} && !$Param{Category} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Search or Category is needed",
        );
        return;
    }

    $Param{Search}   ||= '';
    $Param{Category} ||= '';

    my $Search = lc $Param{Search};

    my %Settings = $Self->ConfigurationTranslatedGet(
        IncludeInvisible => $Param{IncludeInvisible},
    );

    my %Result;

    SETTING:
    for my $SettingName ( sort keys %Settings ) {

        # check category
        if (
            $Param{Category}                    &&
            $Param{Category} ne 'All'           &&
            $Settings{$SettingName}->{Category} &&
            $Settings{$SettingName}->{Category} ne $Param{Category}
            )
        {
            next SETTING;
        }

        # check invisible
        if (
            !$Param{IncludeInvisible}
            && $Settings{$SettingName}->{IsInvisible}
            )
        {
            next SETTING;
        }

        if ( !$Param{Search} ) {
            $Result{$SettingName} = 1;
            next SETTING;
        }

        $Param{Search} =~ s{ +}{ }g;
        my @SearchTerms = split ' ', $Param{Search};

        SEARCHTERM:
        for my $SearchTerm (@SearchTerms) {

            # do not search with the x and/or g modifier as it would produce wrong search results!
            if ( $Settings{$SettingName}->{Metadata} =~ m{\Q$SearchTerm\E}msi ) {

                next SEARCHTERM if $Result{$SettingName};

                $Result{$SettingName} = 1;
            }
        }
    }

    return ( sort keys %Result );
}

=head2 ConfigurationCategoriesGet()

Returns a list of categories with their filenames.

    my %Categories = $SysConfigObject->ConfigurationCategoriesGet();

Returns:

    %Categories = (
        All => {
            DisplayName => 'All Settings',
            Files => [],
        },
        OTRS => {
            DisplayName => 'OTRS',
            Files       => ['Calendar.xml', CloudServices.xml', 'Daemon.xml', 'Framework.xml', 'GenericInterface.xml', 'ProcessManagement.xml', 'Ticket.xml' ],
        },
        # ...
    );

=cut

sub ConfigurationCategoriesGet {
    my ( $Self, %Param ) = @_;

    my $CacheType = 'SysConfig';
    my $CacheKey  = 'ConfigurationCategoriesGet';

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    # Set framework files.
    my %Result = (
        All => {
            DisplayName => Translatable('All Settings'),
            Files       => [],
        },
        OTRS => {
            DisplayName => 'OTRS',
            Files       => [
                'Calendar.xml', 'CloudServices.xml', 'Daemon.xml', 'Framework.xml',
                'GenericInterface.xml', 'ProcessManagement.xml', 'Ticket.xml',
            ],
        },
    );

    my @PackageList = $Kernel::OM->Get('Kernel::System::Package')->RepositoryList();

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # Get files from installed packages.
    PACKAGE:
    for my $Package (@PackageList) {

        next PACKAGE if !$Package->{Name}->{Content};
        next PACKAGE if !IsArrayRefWithData( $Package->{Filelist} );

        my @XMLFiles;
        FILE:
        for my $File ( @{ $Package->{Filelist} } ) {
            $File->{Location} =~ s/\/\//\//g;
            my $Search = 'Kernel/Config/Files/XML/';

            if ( substr( $File->{Location}, 0, length $Search ) ne $Search ) {
                next FILE;
            }

            my $Filename = $File->{Location};
            $Filename =~ s{\AKernel/Config/Files/XML/(.+\.xml)\z}{$1}msxi;
            push @XMLFiles, $Filename;
        }

        next PACKAGE if !@XMLFiles;

        my $PackageName = $Package->{Name}->{Content};
        my $DisplayName = $ConfigObject->Get("SystemConfiguration::Category::Name::$PackageName") || $PackageName;

        # special treatment for OTRS Business Solution™
        if ( $DisplayName eq 'OTRSBusiness' ) {
            $DisplayName = 'OTRS Business Solution™';
        }

        $Result{$PackageName} = {
            DisplayName => $DisplayName,
            Files       => \@XMLFiles,
        };
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%Result,
        TTL   => 24 * 3600 * 30,    # 1 month
    );

    return %Result;
}

=head2 ForbiddenValueTypesGet()

Returns a hash of forbidden value types.

    my %ForbiddenValueTypes = $SysConfigObject->ForbiddenValueTypesGet();

Returns:

    %ForbiddenValueType = (
        String => [],
        Select => ['Option'],
        ...
    );

=cut

sub ForbiddenValueTypesGet {
    my ( $Self, %Param ) = @_;

    my $CacheType = 'SysConfig';
    my $CacheKey  = 'ForbiddenValueTypesGet';

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @ValueTypes = $Self->_ValueTypesList();

    my %Result;

    for my $ValueType (@ValueTypes) {

        my $Loaded = $MainObject->Require(
            "Kernel::System::SysConfig::ValueType::$ValueType",
        );

        if ($Loaded) {
            my $ValueTypeObject = $Kernel::OM->Get(
                "Kernel::System::SysConfig::ValueType::$ValueType",
            );

            my @ForbiddenValueTypes = $ValueTypeObject->ForbiddenValueTypes();
            if ( scalar @ForbiddenValueTypes ) {
                $Result{$ValueType} = \@ForbiddenValueTypes;
            }
        }
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%Result,
        TTL   => 24 * 3600,    # 1 day
    );

    return %Result;
}

=head2 ValueAttributeList()

Returns a hash of forbidden value types.

    my @ValueAttributeList = $SysConfigObject->ValueAttributeList();

Returns:

    @ValueAttributeList = (
        "Content",
        "SelectedID",
    );

=cut

sub ValueAttributeList {

    my ( $Self, %Param ) = @_;

    my $CacheType = 'SysConfig';
    my $CacheKey  = 'ValueAttributeList';

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return @{$Cache} if ref $Cache eq 'ARRAY';

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @ValueTypes = $Self->_ValueTypesList();

    my @Result;

    for my $ValueType (@ValueTypes) {

        my $Loaded = $MainObject->Require(
            "Kernel::System::SysConfig::ValueType::$ValueType",
        );

        if ($Loaded) {
            my $ValueTypeObject = $Kernel::OM->Get(
                "Kernel::System::SysConfig::ValueType::$ValueType",
            );

            my $ValueAttribute = $ValueTypeObject->ValueAttributeGet();
            if ( !grep { $_ eq $ValueAttribute } @Result ) {
                push @Result, $ValueAttribute;
            }
        }
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \@Result,
        TTL   => 24 * 3600,    # 1 day
    );

    return @Result;
}

=head2 SettingsSet()

This method locks provided settings(by force), updates them and deploys the changes (by force).

    my $Success = $SysConfigObject->SettingsSet(
        UserID   => 1,                                      # (required) UserID
        Comments => 'Deployment comment',                   # (optional) Comment
        Settings => [                                       # (required) List of settings to update.
            {
                Name                   => 'Setting::Name',  # (required)
                EffectiveValue         => 'Value',          # (optional)
                IsValid                => 1,                # (optional)
                UserModificationActive => 1,                # (optional)
            },
            ...
        ],
    );

Returns:

    $Success = 1;

=cut

sub SettingsSet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{UserID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Needed UserID!"
        );

        return;
    }

    if ( !IsArrayRefWithData( $Param{Settings} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Settings must be array with data!"
        );

        return;
    }

    my @DeploySettings;

    for my $Setting ( @{ $Param{Settings} } ) {

        my $ExclusiveLockGUID = $Self->SettingLock(
            Name   => $Setting->{Name},
            Force  => 1,
            UserID => $Param{UserID},
        );

        return if !$ExclusiveLockGUID;

        my %UpdateResult = $Self->SettingUpdate(
            %{$Setting},
            ExclusiveLockGUID => $ExclusiveLockGUID,
            UserID            => $Param{UserID},
        );

        if ( $UpdateResult{Success} ) {
            push @DeploySettings, $Setting->{Name};
        }
    }

    # Deploy successfully updated settings.
    my %DeploymentResult = $Self->ConfigurationDeploy(
        Comments      => $Param{Comments} || '',
        UserID        => $Param{UserID},
        Force         => 1,
        DirtySettings => \@DeploySettings,
    );

    return $DeploymentResult{Success};
}

=head2 OverriddenFileNameGet()

Returns file name which overrides setting Effective value.

    my $FileName = $SysConfigObject->OverriddenFileNameGet(
        SettingName    => 'Setting::Name',  # (required)
        UserID         => 1,                # (required)
        EffectiveValue => '3',              # (optional) EffectiveValue stored in the DB.
    );

Returns:

    $FileName = 'ZZZUpdate.pm';

=cut

sub OverriddenFileNameGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(SettingName UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $LoadedEffectiveValue = $Self->GlobalEffectiveValueGet(
        SettingName => $Param{SettingName},
    );
    my @SettingStructure = split( '###', $Param{SettingName} );

    my $EffectiveValue = $Param{EffectiveValue};

    # Replace config variables in effective values.
    # NOTE: First level only, make sure to update this code once same mechanism has been improved in Defaults.pm.
    #   Please see bug#12916 and bug#13376 for more information.
    $EffectiveValue =~ s/\<OTRS_CONFIG_(.+?)\>/$ConfigObject->{$1}/g;

    my $IsOverridden = DataIsDifferent(
        Data1 => $EffectiveValue       // {},
        Data2 => $LoadedEffectiveValue // {},
    );

    # This setting is not Overridden in perl file, return.
    return if !$IsOverridden;

    my $Result;

    my $Home      = $ConfigObject->Get('Home');
    my $Directory = "$Home/Kernel/Config/Files";

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # Get all .pm files that start with 'ZZZ'.
    my @FilesInDirectory = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => 'ZZZ*.pm',
    );

    my @Modules;

    FILE:
    for my $File (@FilesInDirectory) {

        # Get only file name, without full path and extension.
        $File =~ m{^.*/(.*?)\.pm$};
        my $FileName = $1;

        # Skip the file that was regularly deployed.
        next FILE if $FileName eq 'ZZZAAuto';

        push @Modules, {
            "Kernel::Config::Files::$FileName" => $File,
        };
    }

    # Check Config.pm as well.
    push @Modules, {
        'Kernel::Config' => 'Kernel/Config.pm',
    };

    # Get effective values. Try cached version first.
    my $ConfigFromDB = {};
    if ( $Self->{ConfigFromDB} ) {
        $ConfigFromDB = $Self->{ConfigFromDB};
    }

    # Check if we have a valid ZZZAAuto.pm. It is regarded as a reliable source of information.
    elsif (
        -f $Self->{Home} . '/Kernel/Config/Files/ZZZAAuto.pm'
        && $MainObject->Require('Kernel::Config::Files::ZZZAAuto')
        )
    {
        Kernel::Config::Files::ZZZAAuto->Load($ConfigFromDB);

        return if !$ConfigFromDB;
        $Self->{ConfigFromDB} = $ConfigFromDB;
    }

    # Try retrieving data from DB.
    elsif ( my %LastDeployment = $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DeploymentGetLast() ) {
        return if !$LastDeployment{EffectiveValueStrg};

        {
            eval $LastDeployment{EffectiveValueStrg};
            Kernel::Config::Files::ZZZAAuto->Load($ConfigFromDB);
        }

        return if !$ConfigFromDB;
        $Self->{ConfigFromDB} = $ConfigFromDB;
    }

    # No usable data found. This should only happen during initial setup before the initial deployment.
    else {
        return;
    }

    for my $Module (@Modules) {
        my $ModuleName = ( keys %{$Module} )[0];

        # Check if this module overrides our setting.
        my $SettingFound = $Self->_IsOverriddenInModule(
            Module           => $ModuleName,
            SettingStructure => \@SettingStructure,
            ConfigFromDB     => $ConfigFromDB,
        );

        if ($SettingFound) {
            $Result = $Module->{$ModuleName};
        }
    }

    if ($Result) {
        $Result =~ s/^$Home\/?(.*)$/$1/;
    }

    return $Result;
}

=head2 GlobalEffectiveValueGet()

Returns global effective value for provided setting name.

    my $EffectiveValue = $SysConfigObject->GlobalEffectiveValueGet(
        SettingName    => 'Setting::Name',  # (required)
    );

Returns:

    $EffectiveValue = 'test';

=cut

sub GlobalEffectiveValueGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    if ( !$Param{SettingName} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need SettingName!",
        );
        return;
    }

    my $GlobalConfigObject = Kernel::Config->new();

    my $LoadedEffectiveValue;

    my @SettingStructure = split( '###', $Param{SettingName} );
    for my $Key (@SettingStructure) {
        if ( !defined $LoadedEffectiveValue ) {

            # first iteration
            $LoadedEffectiveValue = $GlobalConfigObject->Get($Key);
        }
        elsif ( ref $LoadedEffectiveValue eq 'HASH' ) {
            $LoadedEffectiveValue = $LoadedEffectiveValue->{$Key};
        }
    }

    return $LoadedEffectiveValue;
}

=head1 PRIVATE INTERFACE

=head2 _IsOverriddenInModule()

Helper method to check if setting is overridden in specific module.

    my $Overridden = $SysConfigObject->_IsOverriddenInModule(
        Module               => "Kernel::Config::Files::ZZZAAuto",
        SettingStructure     => [ 'DashboardBackend', '0000-ProductNotify' ],
        LoadedEffectiveValue => 'Value',
    );

=cut

sub _IsOverriddenInModule {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Module SettingStructure ConfigFromDB)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    if ( !IsArrayRefWithData( $Param{SettingStructure} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "SettingStructure must be an array!"
        );
        return;
    }

    my $Result;

    my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require(
        $Param{Module},
        Silent => 1,
    );

    # If module couldn't be loaded, there is no user specific setting.
    return $Result if !$Loaded;

    # Get effective value from the DB.
    my $OverriddenSettings = $Kernel::OM->Get('Kernel::System::Storable')->Clone(
        Data => $Param{ConfigFromDB},
    );

    if ( $Param{Module} eq 'Kernel::Config' ) {
        bless( $OverriddenSettings, 'Kernel::Config' );
        $OverriddenSettings->Load();
    }
    else {
        # Apply changes from this file only.
        $Param{Module}->Load($OverriddenSettings);
    }

    # OverriddenSettings contains EffectiveValues from DB, overridden by provided Module,
    # so we can compare if setting was changed in this file.

    # Loaded hash is empty, return.
    return $Result if !IsHashRefWithData($OverriddenSettings) && ref $OverriddenSettings ne 'Kernel::Config';

    # Check if this file overrides our setting.
    my $SettingFound = 0;
    my $LoadedEffectiveValue;
    my $ConfigFromDB;

    KEY:
    for my $Key ( @{ $Param{SettingStructure} } ) {
        if ( !defined $LoadedEffectiveValue ) {

            # First iteration.
            $LoadedEffectiveValue = $OverriddenSettings->{$Key};
            $ConfigFromDB         = $Param{ConfigFromDB}->{$Key};

            if ( defined $ConfigFromDB && !defined $LoadedEffectiveValue ) {

                # Setting is overridden using the "delete" statement.
                $SettingFound = 1;
            }
            elsif (
                DataIsDifferent(
                    Data1 => $LoadedEffectiveValue // {},
                    Data2 => $ConfigFromDB         // {},
                )
                )
            {
                $SettingFound = 1;
            }
            else {
                last KEY;
            }
        }
        elsif ( ref $LoadedEffectiveValue eq 'HASH' ) {
            $LoadedEffectiveValue = $LoadedEffectiveValue->{$Key};
            $ConfigFromDB         = $ConfigFromDB->{$Key};

            if ( defined $ConfigFromDB && !defined $LoadedEffectiveValue ) {

                # Setting is overridden using the "delete" statement.
                $SettingFound = 1;
            }
            elsif (
                DataIsDifferent(
                    Data1 => $LoadedEffectiveValue // {},
                    Data2 => $ConfigFromDB         // {},
                )
                )
            {
                $SettingFound = 1;
            }
            else {
                $SettingFound = 0;
            }
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Unhandled exception!"
            );
        }
    }

    return $SettingFound;
}

=head2 _FileWriteAtomic()

Writes a file in an atomic operation. This is achieved by creating
a temporary file, filling and renaming it. This avoids inconsistent states
when the file is updated.

    my $Success = $SysConfigObject->_FileWriteAtomic(
        Filename => "$Self->{Home}/Kernel/Config/Files/ZZZAAuto.pm",
        Content  => \$NewContent,
    );

=cut

sub _FileWriteAtomic {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Filename Content)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    my $TempFilename = $Param{Filename} . '.' . $$;
    my $FH;

    ## no critic
    if ( !open( $FH, ">$Self->{FileMode}", $TempFilename ) ) {
        ## use critic

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't open file $TempFilename: $!",
        );
        return;
    }

    print $FH ${ $Param{Content} };
    close $FH;

    if ( !rename $TempFilename, $Param{Filename} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not rename $TempFilename to $Param{Filename}: $!"
        );
        return;
    }

    return 1;
}

=head2 _ConfigurationTranslatableStrings()

Gathers strings marked as translatable from a setting XML parsed content and saves it on
ConfigurationTranslatableStrings global variable.

    $SysConfigObject->_ConfigurationTranslatableStrings(
        Data => $Data,      # could be SCALAR, ARRAY or HASH
    );

=cut

sub _ConfigurationTranslatableStrings {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Data)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # Start recursion if its an array.
    if ( ref $Param{Data} eq 'ARRAY' ) {

        KEY:
        for my $Key ( @{ $Param{Data} } ) {
            next KEY if !$Key;
            $Self->_ConfigurationTranslatableStrings( Data => $Key );
        }
        return;
    }

    # Start recursion if its a Hash.
    if ( ref $Param{Data} eq 'HASH' ) {
        for my $Key ( sort keys %{ $Param{Data} } ) {
            if (
                ref $Param{Data}->{$Key} eq ''
                && $Param{Data}->{Translatable}
                && $Param{Data}->{Content}
                )
            {
                return if !$Param{Data}->{Content};
                return if $Param{Data}->{Content} =~ /^\d+$/;
                $Self->{ConfigurationTranslatableStrings}->{ $Param{Data}->{Content} } = 1;
            }
            $Self->_ConfigurationTranslatableStrings( Data => $Param{Data}->{$Key} );
        }
    }
    return;
}

=head2 _DBCleanUp();

Removes all settings defined in the database (including default and modified) that are not included
in the settings parameter

    my $Success = $SysConfigObject->_DBCleanUp(
        Settings => {
            'ACL::CacheTTL' => {
                XMLContentParsed => '
                    <Setting Name="SettingName" Required="1" Valid="1">
                        <Description Translatable="1">Test.</Description>
                        # ...
                    </Setting>',
                XMLContentRaw => {
                    Description => [
                        {
                            Content      => 'Test.',
                            Translatable => '1',
                        },
                    ],
                    Name  => 'Test',
                    # ...
                },
            # ...
        };
    );

Returns:

    $Success = 1;       # or false in case of a failure

=cut

sub _DBCleanUp {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Settings)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }
    if ( !IsHashRefWithData( $Param{Settings} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Settings must be an HashRef!"
        );
        return;
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my @SettingsDB = $SysConfigDBObject->DefaultSettingList(
        IncludeInvisible => 1,
    );

    my ( $DefaultUpdated, $ModifiedUpdated );

    for my $SettingDB (@SettingsDB) {

        # Cleanup database if the setting is not present in the XML files.
        if ( !$Param{Settings}->{ $SettingDB->{Name} } ) {

            # Get all modified settings.
            my @ModifiedSettings = $SysConfigDBObject->ModifiedSettingListGet(
                Name => $SettingDB->{Name},
            );

            for my $ModifiedSetting (@ModifiedSettings) {

                # Delete from modified table.
                my $SuccessDeleteModified = $SysConfigDBObject->ModifiedSettingDelete(
                    ModifiedID => $ModifiedSetting->{ModifiedID},
                );
                if ( !$SuccessDeleteModified ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "System couldn't delete $SettingDB->{Name} from DB (sysconfig_modified)!"
                    );
                }
            }

            my @ModifiedSettingVersions = $SysConfigDBObject->ModifiedSettingVersionListGet(
                Name => $SettingDB->{Name},
            );

            for my $ModifiedSettingVersion (@ModifiedSettingVersions) {

                # Delete from modified table.
                my $SuccessDeleteModifiedVersion = $SysConfigDBObject->ModifiedSettingVersionDelete(
                    ModifiedVersionID => $ModifiedSettingVersion->{ModifiedVersionID},
                );
                if ( !$SuccessDeleteModifiedVersion ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message  => "System couldn't delete $SettingDB->{Name} from DB (sysconfig_modified_version)!"
                    );
                }
            }

            # Delete from default table.
            my $SuccessDefaultSetting = $SysConfigDBObject->DefaultSettingDelete(
                Name => $SettingDB->{Name},
            );
            if ( !$SuccessDefaultSetting ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "System couldn't delete $SettingDB->{Name} from DB (sysconfig_default)!"
                );
            }
        }
    }

    return 1;
}

=head2 _NavigationTree();

Returns navigation as a tree (in a hash).

    my %Result = $SysConfigObject->_NavigationTree(
        'Array' => [                            # Array of setting navigation items
            'Core',
            'Core::CustomerUser',
            'Frontend',
        ],
        'Tree' => {                             # Result from previous recursive call
            'Core' => {
                'Core::CustomerUser' => {},
            },
        },
    );

Returns:

    %Result = (
        'Core' => {
            'Core::CustomerUser' => {},
        },
        'Frontend' => {},
    );

=cut

sub _NavigationTree {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Tree Array)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Result = %{ $Param{Tree} };

    return %Result if !IsArrayRefWithData( $Param{Array} );

    # Check if first item exists.
    if ( !defined $Result{ $Param{Array}->[0] } ) {
        $Result{ $Param{Array}->[0] } = {
            Subitems => {},
        };
    }

    # Check if it's deeper tree.
    if ( scalar @{ $Param{Array} } > 1 ) {
        my @SubArray = splice( @{ $Param{Array} }, 1 );
        my %Hash     = $Self->_NavigationTree(
            Tree  => $Result{ $Param{Array}->[0] }->{Subitems},
            Array => \@SubArray,
        );

        if (%Hash) {
            $Result{ $Param{Array}->[0] } = {
                Subitems => \%Hash,
            };
        }
    }

    return %Result;
}

sub _NavigationTreeNodeCount {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Settings)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Result = %{ $Param{Tree} // {} };

    NODE_NAME:
    for my $NodeName ( sort keys %Result ) {

        my @Matches = grep { $_->{Navigation} eq $NodeName } @{ $Param{Settings} };
        $Result{$NodeName}->{Count} = scalar @Matches;

        my %SubResult = $Self->_NavigationTreeNodeCount(
            Tree     => $Result{$NodeName}->{Subitems},
            Settings => $Param{Settings},
        );

        $Result{$NodeName}->{Subitems} = {
            %{ $Result{$NodeName}->{Subitems} },
            %SubResult,
        };
    }

    return %Result;
}

=head2 _ConfigurationEntitiesGet();

Returns hash of used entities for provided Setting value.

    my %Result = $SysConfigObject->_ConfigurationEntitiesGet(
        'Name'   => 'Ticket::Frontend::AgentTicketPriority###Entity',   # setting name
        'Result' => {},                                                 # result from previous recursive call
        'Value'  => [                                                   # setting Value
            {
                'Item' => [
                    {
                        'Content'         => '3 medium',
                        'ValueEntityType' => 'Priority',
                        'ValueRegex'      => '',
                        'ValueType'       => 'Entity',
                    },
                ],
            },
        ],
    );

Returns:

    %Result = {
        'Priority' => {
            '3 medium' => [
                'Ticket::Frontend::AgentTicketPriority###Entity',
            ],
        },
    };

=cut

sub _ConfigurationEntitiesGet {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Value Result Name)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my %Result          = %{ $Param{Result} || {} };
    my $ValueEntityType = $Param{ValueEntityType} || '';

    if ( ref $Param{Value} eq 'ARRAY' ) {
        for my $Item ( @{ $Param{Value} } ) {
            %Result = $Self->_ConfigurationEntitiesGet(
                %Param,
                Value  => $Item,
                Result => \%Result,
            );
        }
    }
    elsif ( ref $Param{Value} eq 'HASH' ) {
        if ( $Param{Value}->{ValueEntityType} ) {
            $ValueEntityType = $Param{Value}->{ValueEntityType};
        }

        if ( $Param{Value}->{Content} ) {

            # If there is no hash item, create new.
            if ( !defined $Result{$ValueEntityType} ) {
                $Result{$ValueEntityType} = {};
            }

            # Extract value (without white space).
            my $Value = $Param{Value}->{Content};
            $Value =~ s{^\s*(.*?)\s*$}{$1}gsmx;
            $Value //= '';

            # If there is no array, create
            if ( !IsArrayRefWithData( $Result{$ValueEntityType}->{$Value} ) ) {
                $Result{$ValueEntityType}->{$Value} = [];
            }

            # Check if current config is not in the array.
            if ( !grep { $_ eq $Param{Name} } @{ $Result{$ValueEntityType}->{$Value} } ) {
                push @{ $Result{$ValueEntityType}->{$Value} }, $Param{Name};
            }
        }
        else {
            for my $Key (qw(Item Hash Array)) {
                if ( defined $Param{Value}->{$Key} ) {

                    # Contains children
                    %Result = $Self->_ConfigurationEntitiesGet(
                        %Param,
                        ValueEntityType => $ValueEntityType,
                        Value           => $Param{Value}->{$Key},
                        Result          => \%Result,
                    );
                }
            }
        }
    }

    return %Result;
}

=head2 _EffectiveValues2PerlFile()

Converts effective values from settings into a combined perl hash ready to write into a file.

    my $FileString = $SysConfigObject->_EffectiveValues2PerlFile(
        Settings  => [
            {
                Name           => 'SettingName',
                IsValid        => 1,
                EffectiveValue => $ValueStructure,
            },
            {
                Name           => 'AnotherSettingName',
                IsValid        => 0,
                EffectiveValue => $AnotherValueStructure,
            },
            # ...
        ],
        TargetPath => 'Kernel/Config/Files/ZZZAAuto.pm',
    );

=cut

sub _EffectiveValues2PerlFile {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Settings TargetPath)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }
    if ( !IsArrayRefWithData( $Param{Settings} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Settings parameter is invalid!",
        );

        return;
    }

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $PerlHashStrg;

    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');
    my $CacheObject    = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType = 'SysConfigPersistent';
    my $CacheKey  = 'EffectiveValues2PerlFile';

    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    ) // {};

    my $DateTimeObject    = $Kernel::OM->Create('Kernel::System::DateTime');
    my $CurrentSystemTime = $DateTimeObject->ToEpoch();

    $DateTimeObject->Add(
        Months => 1,
    );
    my $ExpireTime = $DateTimeObject->ToEpoch();

    my $CacheDifferent;

    # Delete all expired keys.
    my @ExpiredKeys = grep { $CurrentSystemTime > $Cache->{$_}->{ExpireTime} } keys %{$Cache};
    delete @{$Cache}{@ExpiredKeys};

    # If there are expired keys, cache needs to be set to a new value.
    $CacheDifferent = scalar @ExpiredKeys ? 1 : 0;

    # Convert all settings from DB format to perl file.
    for my $Setting ( @{ $Param{Settings} } ) {

        my $Name = $Setting->{Name};
        $Name =~ s/\\/\\\\/g;
        $Name =~ s/'/\'/g;
        $Name =~ s/###/'}->{'/g;

        if ( $Setting->{IsValid} ) {

            my $EffectiveValue;

            my $ValueString = $Setting->{EffectiveValue} // '';
            if ( ref $ValueString ) {
                my $String = $StorableObject->Serialize(
                    Data => $Setting->{EffectiveValue},
                );
                $ValueString = $MainObject->MD5sum(
                    String => \$String,
                );
            }

            if (
                $Cache->{$ValueString}
                && $Cache->{$ValueString}->{Value}
                )
            {
                $EffectiveValue = $Cache->{$ValueString}->{Value};
            }
            else {
                $EffectiveValue = $MainObject->Dump( $Setting->{EffectiveValue} );

                $Cache->{$ValueString} = {
                    Value      => $EffectiveValue,
                    ExpireTime => $ExpireTime,
                };

                # Cache has been changed, it needs to be set.
                $CacheDifferent = 1;
            }

            $EffectiveValue =~ s/\$VAR1 =//;
            $PerlHashStrg .= "\$Self->{'$Name'} = $EffectiveValue";
        }
        elsif ( eval( '$Self->{ConfigDefaultObject}->{\'' . $Name . '\'}' ) ) {
            $PerlHashStrg .= "delete \$Self->{'$Name'};\n";
        }
    }

    if ($CacheDifferent) {

        $CacheObject->Set(
            Type  => $CacheType,
            Key   => $CacheKey,
            Value => $Cache,
            TTL   => 20 * 24 * 60 * 60,
        );
    }

    chomp $PerlHashStrg;

    # Convert TargetPath to Package.
    my $TargetPath = $Param{TargetPath};
    $TargetPath =~ s{(.*)\.(?:.*)}{$1}msx;
    $TargetPath =~ s{ / }{::}msxg;

    # Write default config file.
    my $FileStrg = <<"EOF";
# OTRS config file (automatically generated)
# VERSION:2.0
package $TargetPath;
use strict;
use warnings;
no warnings 'redefine'; ## no critic
EOF

    if ( $Self->{utf8} ) {
        $FileStrg .= "use utf8;\n";
    }

    $FileStrg .= <<"EOF";
sub Load {
    my (\$File, \$Self) = \@_;
$PerlHashStrg
    return;
}
1;
EOF

    return $FileStrg;
}

=head2 _SettingEffectiveValueCheck()

Recursive helper for SettingEffectiveValueCheck().

    my %Result = $SysConfigObject->_SettingEffectiveValueCheck(
        EffectiveValue => 'open',                           # (optional) The EffectiveValue to be checked,
                                                            #   (could be also a complex structure).
        XMLContentParsed => {                               # (required) The XMLContentParsed value from Default Setting.
            Value => [
                {
                    'Item' => [
                        {
                            'Content' => "Scalar value",
                        },
                    ],
                },
            ],
        },
        NoValidation        => $Param{NoValidation},        # (optional), skip validation
        CurrentSystemTime   => 1507894796935,               # (optional) Use provided 1507894796935, otherwise calculate
        ExpireTime          => 1507894896935,               # (optional) Use provided ExpireTime for cache, otherwise calculate
        UserID              => 1,                           # (required) UserID
    );

Returns:

    %Result = (
        EffectiveValue => 'closed',    # Note that EffectiveValue can be changed.
        Success        => 1,           # or false in case of fail
        Error          => undef,       # or error string
    );

=cut

sub _SettingEffectiveValueCheck {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(XMLContentParsed UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # So far everything is OK, we need to check deeper (recursive).
    my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');

    my $Default = $StorableObject->Clone(
        Data => $Param{XMLContentParsed},
    );

    my $EffectiveValue = $Param{EffectiveValue};

    if ( ref $Param{EffectiveValue} ) {
        $EffectiveValue = $StorableObject->Clone(
            Data => $Param{EffectiveValue},
        );
    }

    return $Self->SettingEffectiveValueCheck(
        XMLContentParsed  => $Default,
        EffectiveValue    => $EffectiveValue,
        NoValidation      => $Param{NoValidation},
        CurrentSystemTime => $Param{CurrentSystemTime},
        ExpireTime        => $Param{ExpireTime},
        UserID            => $Param{UserID},
    );
}

=head2 _SettingEffectiveValueCheckCacheSet()
Sets cache for EffectiveValueCheck to the provided value.

    $SysConfigObject->_SettingEffectiveValueCheckCacheSet(
        Value => {                              (required)
            Default180920170714165331 => {
                Success => 1,
            },
            ...
        },
        NoValidation => 0,                      (optional)
    );

=cut

sub _SettingEffectiveValueCheckCacheSet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Value)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $CacheType = 'SysConfigPersistent';
    my $CacheKey  = "EffectiveValueCheck::$Param{NoValidation}";

    return $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => $Param{Value},
        TTL   => 20 * 24 * 60 * 60,
    );
}

=head2 _GetSettingsToDeploy()

Returns the correct list of settings for a deployment taking the settings from different sources:

    NotDirty:      fetch default settings plus already deployed modified settings.
    AllSettings:   fetch default settings plus all modified settings already deployed or not.
    DirtySettings: fetch default settings plus already deployed settings plus all not deployed settings in the list.

    my @SettingList = $SysConfigObject->_GetSettingsToDeploy(
        NotDirty      => 1,                                         # optional - exclusive (1||0)
        All           => 1,                                         # optional - exclusive (1||0)
        DirtySettings => [ 'SettingName1', 'SettingName2' ],        # optional - exclusive
    );

    @SettingList = (
        {
            DefaultID                => 123,
            Name                     => "ProductName",
            Description              => "Defines the name of the application ...",
            Navigation               => "ASimple::Path::Structure",
            IsInvisible              => 1,
            IsReadonly               => 0,
            IsRequired               => 1,
            IsValid                  => 1,
            HasConfigLevel           => 200,
            UserModificationPossible => 0,          # 1 or 0
            UserModificationActive   => 0,          # 1 or 0
            UserPreferencesGroup     => 'Advanced', # optional
            XMLContentRaw            => "The XML structure as it is on the config file",
            XMLContentParsed         => "XML parsed to Perl",
            EffectiveValue           => "Product 6",
            DefaultValue             => "Product 5",
            IsModified               => 1,       # 1 or 0
            IsDirty                  => 1,       # 1 or 0
            ExclusiveLockGUID        => 'A32CHARACTERLONGSTRINGFORLOCKING',
            ExclusiveLockUserID      => 1,
            ExclusiveLockExpiryTime  => '2016-05-29 11:09:04',
            CreateTime               => "2016-05-29 11:04:04",
            ChangeTime               => "2016-05-29 11:04:04",
        },
        {
            DefaultID => 321,
            Name      => 'FieldName',
            # ...
            CreateTime => '2010-09-11 10:08:00',
            ChangeTime => '2011-01-01 01:01:01',
        },
        # ...
    );

=cut

sub _GetSettingsToDeploy {
    my ( $Self, %Param ) = @_;

    if ( !$Param{NotDirty} && !$Param{DirtySettings} ) {
        $Param{AllSettings} = 1;
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    my @DefaultSettingsList = $SysConfigDBObject->DefaultSettingListGet(
        NoCache => $Param{NoCache},
    );

    # Create a lookup table for the default settings (for easy adding modified).
    my %SettingsLookup = map { $_->{Name} => $_ } @DefaultSettingsList;

    my @ModifiedSettingsList;

    # Use if - else statement, as the gathering of the settings could be expensive.
    if ( $Param{NotDirty} ) {
        @ModifiedSettingsList = $SysConfigDBObject->ModifiedSettingVersionListGetLast();
    }
    else {
        @ModifiedSettingsList = $SysConfigDBObject->ModifiedSettingListGet(
            IsGlobal => 1,
        );
    }

    if ( $Param{AllSettings} || $Param{NotDirty} ) {

        # Create a lookup table for the modified settings (for easy merging with defaults).
        my %ModifiedSettingsLookup = map { $_->{Name} => $_ } @ModifiedSettingsList;

        # Merge modified into defaults.
        KEY:
        for my $Key ( sort keys %SettingsLookup ) {
            next KEY if !$ModifiedSettingsLookup{$Key};

            $SettingsLookup{$Key} = {
                %{ $SettingsLookup{$Key} },
                %{ $ModifiedSettingsLookup{$Key} },
            };
        }

        my @Settings = map { $SettingsLookup{$_} } ( sort keys %SettingsLookup );

        return @Settings;
    }

    my %DirtySettingsLookup = map { $_ => 1 } @{ $Param{DirtySettings} };

    SETTING:
    for my $Setting (@ModifiedSettingsList) {

        my $SettingName = $Setting->{Name};

        # Skip invalid settings (all modified needs to have a default).
        next SETTING if !$SettingsLookup{$SettingName};

        # Remember modified.
        my %ModifiedSetting = %{$Setting};

        # If setting is not in the given list, then do not use current value but last deployed.
        if ( $Setting->{IsDirty} && !$DirtySettingsLookup{$SettingName} ) {
            %ModifiedSetting = $SysConfigDBObject->ModifiedSettingVersionGetLast(
                Name => $Setting->{Name},
            );

            # If there is not previous version then skip to keep the default intact.
            next SETTING if !%ModifiedSetting;
        }

        $SettingsLookup{$SettingName} = {
            %{ $SettingsLookup{$SettingName} },
            %ModifiedSetting,
        };
    }

    my @Settings = map { $SettingsLookup{$_} } ( sort keys %SettingsLookup );

    return @Settings;
}

=head2 _HandleSettingsToDeploy()

Creates modified versions of dirty settings to deploy and removed the dirty flag.

    NotDirty:      Removes dirty flag just for default settings
    AllSettings:   Create a version for all dirty settings and removed dirty flags for all default and modified settings
    DirtySettings: Create a version and remove dirty fag for the modified settings in the list, remove dirty flag for all default settings

    my $Success = $SysConfigObject->_HandleSettingsToDeploy(
        NotDirty            => 1,                                         # optional - exclusive (1||0)
        AllSettings         => 1,                                         # optional - exclusive (1||0)
        DirtySettings       => [ 'SettingName1', 'SettingName2' ],        # optional - exclusive
        DeploymentTimeStamp => 2017-12-12 12:00:00'
        UserID              => 123,
    );

Returns:

    $Success = 1;       # or false in case of a failure

=cut

sub _HandleSettingsToDeploy {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(UserID DeploymentTimeStamp)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed",
            );
            return;
        }
    }

    if ( !$Param{NotDirty} && !$Param{DirtySettings} ) {
        $Param{AllSettings} = 1;
    }

    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');

    # Remove is dirty flag for default settings.
    my $DefaultCleanup = $SysConfigDBObject->DefaultSettingDirtyCleanUp(
        AllSettings => $Param{AllSettings},
    );
    if ( !$DefaultCleanup ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not remove IsDirty flag from default settings",
        );
    }

    return 1 if $Param{NotDirty};

    my %DirtySettingsLookup = map { $_ => 1 } @{ $Param{DirtySettings} // [] };

    # Get all dirty modified settings.
    my @DirtyModifiedList = $SysConfigDBObject->ModifiedSettingListGet(
        IsGlobal => 1,
        IsDirty  => 1,
    );

    my %VersionsAdded;
    my @ModifiedDeleted;
    my @ModifiedIDs;
    my $Error;

    # Create a new version for the modified settings.
    SETTING:
    for my $Setting (@DirtyModifiedList) {

        # Skip setting if it is not in the list (and it is not a full deployment)
        next SETTING if !$Param{AllSettings} && !$DirtySettingsLookup{ $Setting->{Name} };

        my %DefaultSettingVersionGetLast = $SysConfigDBObject->DefaultSettingVersionGetLast(
            DefaultID => $Setting->{DefaultID},
        );

        my $ModifiedVersionID = $SysConfigDBObject->ModifiedSettingVersionAdd(
            %{$Setting},
            DefaultVersionID    => $DefaultSettingVersionGetLast{DefaultVersionID},
            DeploymentTimeStamp => $Param{DeploymentTimeStamp},
            UserID              => $Param{UserID},
        );

        if ( !$ModifiedVersionID ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not create a modified setting version for $Setting->{Name}! Rolling back.",
            );
            $Error = 1;
            last SETTING;
        }

        $VersionsAdded{ $Setting->{Name} } = $ModifiedVersionID;

        if ( !$Setting->{ResetToDefault} ) {
            push @ModifiedIDs, $Setting->{ModifiedID};
            next SETTING;
        }

        # In case a setting value reset, delete the modified value.
        my $ModifiedDelete = $SysConfigDBObject->ModifiedSettingDelete(
            ModifiedID => $Setting->{ModifiedID},
        );

        if ( !$ModifiedDelete ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Could not delete the modified setting for $Setting->{Name} on reset action! Rolling back.",
            );
            $Error = 1;
            last SETTING;
        }

        push @ModifiedDeleted, $Setting;
    }

    # In case of an error:
    #   Remove "all" added versions for "all" settings for this deployment.
    #   Restore "all" deleted modified settings.
    if ($Error) {
        for my $SettingName ( sort keys %VersionsAdded ) {
            my $Success = $SysConfigDBObject->ModifiedSettingVersionDelete(
                ModifiedVersionID => $VersionsAdded{$SettingName},
            );
        }

        for my $Setting (@ModifiedDeleted) {
            my $Success = $SysConfigDBObject->ModifiedSettingAdd(
                %{$Setting},
                DeploymentExclusiveLockGUID => $Param{DeploymentExclusiveLockGUID},
                UserID                      => $Setting->{ChangeBy},
            );
        }

        return;
    }

    # Do not clean dirty flag if no setting version was created and it is not a full deployment
    return 1 if !$Param{AllSettings} && !@ModifiedIDs;

    my %Options;
    if ( !$Param{AllSettings} ) {
        $Options{ModifiedIDs} = \@ModifiedIDs;
    }

    # Remove is dirty flag for modified settings.
    my $ModifiedCleanup = $SysConfigDBObject->ModifiedSettingDirtyCleanUp(%Options);
    if ( !$ModifiedCleanup ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not remove IsDirty flag from modified settings",
        );
    }

    return 1;
}

=head2 _SettingTranslatedGet()

Helper method for ConfigurationTranslatedGet().

    my %Result = $SysConfigObject->_SettingTranslatedGet(
        Language => 'de',               # (required) User language
        Name     => 'SettingName',      # (required) Setting name
        Silent   => 1,                  # (optional) Default 1
    );

Returns:

    %Result = (
       'ACL::CacheTTL' => {
            'Category' => 'OTRS',
            'IsInvisible' => '0',
            'Metadata' => "ACL::CacheTTL--- '3600'
Cache-Zeit in Sekunden f\x{fc}r Datenbank ACL-Backends.",
    );

=cut

sub _SettingTranslatedGet {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Language Name)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    my $CacheType = 'SysConfig';
    my $CacheKey  = "SettingTranslatedGet::$Param{Language}::$Param{Name}";

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return %{$Cache} if ref $Cache eq 'HASH';

    my $YAMLObject = $Kernel::OM->Get('Kernel::System::YAML');
    my %Categories = $Self->ConfigurationCategoriesGet();

    my %SettingTranslated = $Self->SettingGet(
        Name      => $Param{Name},
        Translate => 1,
    );

    my $Metadata = $Param{Name};
    $Metadata .= $YAMLObject->Dump(
        Data => $SettingTranslated{EffectiveValue},
    );
    $Metadata .= $SettingTranslated{Description};

    my %Result;
    $Result{ $Param{Name} }->{Metadata} = lc $Metadata;

    # Check setting category.
    my $SettingCategory;

    my $Silent = $Param{Silent} // 1;

    CATEGORY:
    for my $Category ( sort keys %Categories ) {
        if ( grep { $_ eq $SettingTranslated{XMLFilename} } @{ $Categories{$Category}->{Files} } ) {
            $SettingCategory = $Category;
            last CATEGORY;
        }
    }

    if ( !$SettingCategory ) {
        if ( !$Silent ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Category couldn't be determined for $Param{Name}!",
            );
        }
        $SettingCategory = '-Unknown-';
    }
    $Result{ $Param{Name} }->{Category}    = $SettingCategory;
    $Result{ $Param{Name} }->{IsInvisible} = $SettingTranslated{IsInvisible};

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \%Result,
        TTL   => $Self->{CacheTTL} || 24 * 60 * 60,
    );

    return %Result;
}

=head2 _ValueTypesList()

Returns a hash of forbidden value types.

    my @ValueTypes = $SysConfigObject->_ValueTypesList();

Returns:

    @ValueTypes = (
        "Checkbox",
        "Select",
        ...
    );

=cut

sub _ValueTypesList {
    my ( $Self, %Param ) = @_;

    my $CacheType = 'SysConfig';
    my $CacheKey  = '_ValueTypesList';

    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

    # Return cache.
    my $Cache = $CacheObject->Get(
        Type => $CacheType,
        Key  => $CacheKey,
    );

    return @{$Cache} if ref $Cache eq 'ARRAY';

    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @Files = $MainObject->DirectoryRead(
        Directory => $Self->{Home} . "/Kernel/System/SysConfig/ValueType",
        Filter    => '*.pm',
    );

    my @Result;
    for my $File (@Files) {

        my $ValueType = $File;

        # Remove folder path.
        $ValueType =~ s{^.*/}{}sm;

        # Remove extension
        $ValueType =~ s{\.pm$}{}sm;

        push @Result, $ValueType;
    }

    $CacheObject->Set(
        Type  => $CacheType,
        Key   => $CacheKey,
        Value => \@Result,
        TTL   => 24 * 3600,    # 1 day
    );

    return @Result;
}

=head2 _DefaultSettingAddBulk()

Helper method for ConfigurationXML2DB() - bulk insert.

    my $Success = $SysConfigObject->_DefaultSettingAddBulk(
        Settings => {                   # (required) Hash of settings to insert
            'SettingName' => {

            },
            ...
        },
        SettingList => [                # (required) List of settings
            ...
        ],
        UserID => 1,                    # (required) UserID
    );

=cut

sub _DefaultSettingAddBulk {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(Settings SettingList UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check needed stuff.
    if ( ref $Param{Settings} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Settings must be a HASH ref!",
        );
        return;
    }

    my $StorableObject    = $Kernel::OM->Get('Kernel::System::Storable');
    my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
    my $YAMLObject        = $Kernel::OM->Get('Kernel::System::YAML');

    my %Settings    = %{ $Param{Settings} };
    my @SettingList = @{ $Param{SettingList} };

    for my $SettingName ( sort keys %{ $Param{Settings} } ) {

        # Create a local clone of the value to prevent any modification.
        my $Value = $StorableObject->Clone(
            Data => $Settings{$SettingName}->{XMLContentParsed}->{Value},
        );

        $Settings{$SettingName}->{EffectiveValue} = $Self->SettingEffectiveValueGet(
            Value => $Value,
        );

        # Serialize values that doesn't have string representation.
        $Settings{$SettingName}->{EffectiveValue} = $YAMLObject->Dump(
            Data => $Settings{$SettingName}->{EffectiveValue},
        );
        $Settings{$SettingName}->{XMLContentParsedYAML} = $YAMLObject->Dump(
            Data => $Settings{$SettingName}->{XMLContentParsed},
        );
    }

    my $Success = $SysConfigDBObject->DefaultSettingBulkAdd(
        Settings    => \%Settings,
        SettingList => \@SettingList,
        UserID      => $Param{UserID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "System was unable to rebuild config!"
        );
        return;
    }

    # Get again all settings.
    @SettingList = $Self->ConfigurationList(
        IncludeInvisible => 1,
    );

    $Success = $SysConfigDBObject->DefaultSettingVersionBulkAdd(
        Settings    => \%Settings,
        SettingList => \@SettingList,
        UserID      => $Param{UserID},
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "System was unable to rebuild config!"
        );
        return;
    }

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
