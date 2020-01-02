# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminSystemConfigurationGroup;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::Language qw(Translatable);
use Kernel::System::VariableCheck qw(IsArrayRefWithData);

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject    = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
    my $ParamObject     = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $ConfigLevel     = $Kernel::OM->Get('Kernel::Config')->Get('ConfigLevel') || 0;

    if ( $Self->{Subaction} eq 'Lock' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $SettingName = $ParamObject->GetParam( Param => 'SettingName' ) || '';

        my %Setting = $SysConfigObject->SettingGet(
            Name            => $SettingName,
            OverriddenInXML => 1,
            UserID          => $Self->{UserID},
        );

        my %Result;

        my %LockStatus = $SysConfigObject->SettingLockCheck(
            DefaultID           => $Setting{DefaultID},
            ExclusiveLockGUID   => $Setting{ExclusiveLockGUID} || '1',
            ExclusiveLockUserID => $Self->{UserID},
        );

        my $Guid;
        if ( !$LockStatus{Locked} ) {
            if ( $Setting{IsValid} ) {
                $Guid = $SysConfigObject->SettingLock(
                    UserID    => $Self->{UserID},
                    DefaultID => $Setting{DefaultID},
                );
            }
            else {
                # Setting can't be locked if it's disabled.
                $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                    "You need to enable the setting before locking!"
                );
                return $Self->_ReturnJSON( Response => \%Result );
            }
            $Setting{Locked} = $Guid ? 2 : 0;
        }
        elsif ( $LockStatus{Locked} == 1 ) {

            # append status
            %Setting = (
                %Setting,
                %LockStatus,
            );

            $Setting{Error} = '<p class="Error">'
                . $Kernel::OM->Get('Kernel::Language')->Translate(
                "You can't work on this setting because %s (%s) is currently working on it.",
                $LockStatus{User}->{UserFullname},
                $LockStatus{User}->{UserEmail},
                );
            $Setting{Error} .= "</p>";
        }

        $Setting{ExclusiveLockGUID} = $Guid || $Setting{ExclusiveLockGUID};

        $Result{Data}->{HTMLStrg} = $SysConfigObject->SettingRender(
            Setting => \%Setting,
            RW      => ( $Setting{Locked} && $Setting{Locked} == 2 ) ? 1 : 0,
            IsAjax  => 1,
            UserID  => $Self->{UserID},
        );

        # Send only useful setting attributes to reduce ammount of data transfered in the AJAX call.
        for my $Key (qw(IsModified IsDirty IsLocked Error ExclusiveLockGUID IsValid UserModificationActive)) {
            $Result{Data}->{SettingData}->{$Key} = $Setting{$Key};
        }

        if ( $Result{Data}->{HTMLStrg} =~ m{BadEffectiveValue}gsmx ) {
            $Result{Data}->{SettingData}->{Invalid} = 1;
        }

        return $Self->_ReturnJSON( Response => \%Result );
    }
    elsif ( $Self->{Subaction} eq 'Unlock' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $SettingName = $ParamObject->GetParam( Param => 'SettingName' ) || '';

        my %Result;

        my %Setting = $SysConfigObject->SettingGet(
            Name            => $SettingName,
            OverriddenInXML => 1,
            UserID          => $Self->{UserID},
        );

        my %LockStatus = $SysConfigObject->SettingLockCheck(
            DefaultID           => $Setting{DefaultID},
            ExclusiveLockGUID   => $Setting{ExclusiveLockGUID} || '1',
            ExclusiveLockUserID => $Self->{UserID},
        );

        if ( $LockStatus{Locked} == 2 ) {
            my $Success = $SysConfigObject->SettingUnlock(
                DefaultID => $Setting{DefaultID},
            );

            $Setting{Locked} = $Success ? 0 : 2;
        }
        elsif ( $LockStatus{Locked} == 1 ) {

            # append status
            %Setting = (
                %Setting,
                %LockStatus,
            );
        }

        $Result{Data}->{HTMLStrg} = $SysConfigObject->SettingRender(
            Setting => \%Setting,
            IsAjax  => 1,
            RW      => ( $Setting{Locked} && $Setting{Locked} == 2 ) ? 1 : 0,
            UserID  => $Self->{UserID},
        );

        # Send only useful setting attributes to reduce ammount of data transfered in the AJAX call.
        for my $Key (qw(IsModified IsDirty IsLocked Error ExclusiveLockGUID IsValid UserModificationActive)) {
            $Result{Data}->{SettingData}->{$Key} = $Setting{$Key};
        }

        if ( $Result{Data}->{HTMLStrg} =~ m{BadEffectiveValue}gsmx ) {
            $Result{Data}->{SettingData}->{Invalid} = 1;
        }

        return $Self->_ReturnJSON( Response => \%Result );
    }

    elsif ( $Self->{Subaction} eq 'SettingReset' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        my $SettingName  = $ParamObject->GetParam( Param => 'SettingName' )  || '';
        my $ResetOptions = $ParamObject->GetParam( Param => 'ResetOptions' ) || '';

        my %Result;

        if ( !$SettingName ) {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "Missing setting name!",
            );
            return $Self->_ReturnJSON( Response => \%Result );
        }

        if ( !$ResetOptions ) {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "Missing ResetOptions!",
            );
            return $Self->_ReturnJSON( Response => \%Result );
        }

        my @Options = split ",", $ResetOptions;

        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        if ( grep { $_ eq 'reset-globally' } @Options ) {

            # Reset globally
            my $Guid;

            if ( !$Setting{ExclusiveLockGUID} ) {

                # Setting is not locked yet.
                $Guid = $SysConfigObject->SettingLock(
                    UserID    => $Self->{UserID},
                    DefaultID => $Setting{DefaultID},
                );
            }
            elsif ( $Setting{ExclusiveLockUserID} != $Self->{UserID} ) {

                # Someone else locked the setting.
                $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                    "Setting is locked by another user!",
                );
                return $Self->_ReturnJSON( Response => \%Result );
            }
            else {

                # Already locked to this user.
                $Guid = $Setting{ExclusiveLockGUID};
            }

            if ( !$Guid ) {
                $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                    "System was not able to lock the setting!",
                );
                return $Self->_ReturnJSON( Response => \%Result );
            }

            my $Success = $SysConfigObject->SettingReset(
                Name              => $SettingName,
                ExclusiveLockGUID => $Guid,
                UserID            => $Self->{UserID},
            );

            if ( !$Success ) {
                $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                    "System was not able to reset the setting!",
                );
                return $Self->_ReturnJSON( Response => \%Result );
            }

            $SysConfigObject->SettingUnlock(
                DefaultID => $Setting{DefaultID},
            );
        }

        if (
            ( grep { $_ eq 'reset-locally' } @Options )
            && $SysConfigObject->can('UserSettingValueDelete')    # OTRS Business Solution™
            )
        {

            # Remove user's value
            my $UserValueDeleted = $SysConfigObject->UserSettingValueDelete(
                Name       => $SettingName,
                ModifiedID => 'All',
                UserID     => $Self->{UserID},
            );

            if ( !$UserValueDeleted ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message =>
                        "System was not able to delete setting values for users!"
                );
            }
        }

        %Setting = $SysConfigObject->SettingGet(
            Name            => $SettingName,
            OverriddenInXML => 1,
            UserID          => $Self->{UserID},
        );

        # Send only useful setting attributes to reduce amount of data transfered in the AJAX call.
        for my $Key (qw(IsModified IsDirty IsLocked ExclusiveLockGUID IsValid UserModificationActive)) {
            $Result{Data}->{SettingData}->{$Key} = $Setting{$Key};
        }

        $Result{Data}->{HTMLStrg} = $SysConfigObject->SettingRender(
            Setting => \%Setting,
            RW      => $Setting{ExclusiveLockGUID} ? 1 : 0,
            UserID  => $Self->{UserID},
        );

        $Result{DeploymentNeeded} = 1;

        if ( !$Result{Error} ) {
            $Result{DeploymentNeeded} = $SysConfigObject->ConfigurationIsDirtyCheck();
        }

        if ( $Result{Data}->{HTMLStrg} =~ m{BadEffectiveValue}gsmx ) {
            $Result{Data}->{SettingData}->{Invalid} = 1;
        }

        return $Self->_ReturnJSON( Response => \%Result );
    }

    elsif ( $Self->{Subaction} eq 'SettingUpdate' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

        my $SettingName            = $ParamObject->GetParam( Param => 'SettingName' ) || '';
        my $EffectiveValueJSON     = $ParamObject->GetParam( Param => 'EffectiveValue' );
        my $IsValid                = $ParamObject->GetParam( Param => 'IsValid' );
        my $UserModificationActive = $ParamObject->GetParam( Param => 'UserModificationActive' );

        my $EffectiveValue;

        if ( !defined $EffectiveValueJSON ) {
            $EffectiveValue = undef;
        }
        elsif (
            !$EffectiveValueJSON
            || $EffectiveValueJSON eq '"0"'

            )
        {
            $EffectiveValue = 0;
        }
        elsif ( $EffectiveValueJSON eq '""' ) {
            $EffectiveValue = '';
        }
        else {
            $EffectiveValue = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
                Data => $EffectiveValueJSON,
            );
        }

        my %Result;

        # Get setting
        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        # try to lock to the current user
        if (
            !$Setting{ExclusiveLockUserID}
            ||
            (
                $Setting{ExclusiveLockUserID} &&
                $Setting{ExclusiveLockUserID} != $Self->{UserID}
            )
            )
        {
            my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                DefaultID => $Setting{DefaultID},
                UserID    => $Self->{UserID},
            );

            if ($ExclusiveLockGUID) {
                $Setting{ExclusiveLockGUID} = $ExclusiveLockGUID;
            }
            else {
                $Result{Data}->{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                    "System was unable to update setting!",
                );
                return $Self->_ReturnJSON( Response => \%Result );
            }
        }

        # Detect if IsValid state is different (user pressed enable or disable).
        my $NoValidation = $IsValid // $Setting{IsValid};
        $NoValidation = $NoValidation != $Setting{IsValid};

        # Try to Update.
        my %UpdateResult = $SysConfigObject->SettingUpdate(
            Name                   => $SettingName,
            EffectiveValue         => $EffectiveValue,
            ExclusiveLockGUID      => $Setting{ExclusiveLockGUID},
            UserID                 => $Self->{UserID},
            IsValid                => $IsValid // $Setting{IsValid},
            UserModificationActive => $UserModificationActive,
            NoValidation           => $NoValidation,
        );

        if ( !$UpdateResult{Success} && !$UpdateResult{Error} ) {
            $Result{Data}->{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "System was unable to update setting!",
            );
        }
        elsif ( !$UpdateResult{Success} ) {
            $Result{Data}->{Error} = $UpdateResult{Error};

            my %LockStatus = $SysConfigObject->SettingLockCheck(
                DefaultID           => $Setting{DefaultID},
                ExclusiveLockGUID   => $Setting{ExclusiveLockGUID},
                ExclusiveLockUserID => $Self->{UserID},
            );

            # If LockStatus{Locked} = 2, setting is locked to the current user.
            $Result{Data}->{SettingData}->{IsLockedByMe} = $LockStatus{Locked} == 2 ? 1 : 0;
        }

        my %UpdatedSetting = $SysConfigObject->SettingGet(
            Name            => $SettingName,
            OverriddenInXML => 1,
            UserID          => $Self->{UserID},
        );

        $Result{Data}->{HTMLStrg} = $SysConfigObject->SettingRender(
            Setting => \%UpdatedSetting,
            RW      => $UpdatedSetting{ExclusiveLockGUID} ? 1 : 0,
            UserID  => $Self->{UserID},
        );

        for my $Key (qw(IsModified IsDirty ExclusiveLockGUID IsValid UserModificationActive)) {
            $Result{Data}->{SettingData}->{$Key} = $UpdatedSetting{$Key};
        }

        $Result{Data}->{DeploymentNeeded} = $SysConfigObject->ConfigurationIsDirtyCheck();

        if ( $Result{Data}->{HTMLStrg} =~ m{BadEffectiveValue}gsmx ) {
            $Result{Data}->{SettingData}->{Invalid} = 1;
        }

        return $Self->_ReturnJSON( Response => \%Result );
    }
    elsif ( $Self->{Subaction} eq 'SettingList' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $ParamObject    = $Kernel::OM->Get('Kernel::System::Web::Request');
        my $RootNavigation = $ParamObject->GetParam( Param => 'RootNavigation' ) || '';
        my $Category       = $ParamObject->GetParam( Param => 'Category' ) || '';
        $Category = $Category eq 'All' ? '' : $Category;

        # Get all settings by navigation group
        my @SettingList = $SysConfigObject->ConfigurationListGet(
            Navigation      => $RootNavigation,
            Translate       => 0,
            Category        => $Category,
            OverriddenInXML => 1,
            UserID          => $Self->{UserID},
        );

        # get favorites from user preferences
        my $Favourites;
        my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
            UserID => $Self->{UserID},
        );

        if ( $UserPreferences{UserSystemConfigurationFavourites} ) {
            $Favourites = $Kernel::OM->Get('Kernel::System::JSON')
                ->Decode( Data => $UserPreferences{UserSystemConfigurationFavourites} );
        }

        for my $Setting (@SettingList) {
            my %LockStatus = $SysConfigObject->SettingLockCheck(
                DefaultID           => $Setting->{DefaultID},
                ExclusiveLockGUID   => $Setting->{ExclusiveLockGUID} || '1',
                ExclusiveLockUserID => $Self->{UserID},
            );

            # TODO: This expression is slow, needs to be updated.
            # append status
            %{$Setting} = (
                %{$Setting},
                %LockStatus,
            );

            # check if this setting is a favorite of the current user
            if ( grep { $_ eq $Setting->{Name} } @{$Favourites} ) {
                $Setting->{IsFavourite} = 1;
            }

            $Setting->{HTMLStrg} = $SysConfigObject->SettingRender(
                Setting => $Setting,
                RW      => ( $Setting->{Locked} && $Setting->{Locked} == 2 ) ? 1 : 0,
                UserID  => $Self->{UserID},
                IsAjax  => 1,
            );

            if ( $Setting->{HTMLStrg} =~ m{BadEffectiveValue}gsmx ) {
                $Setting->{Invalid} = 1;
            }
        }

        my $Output = $LayoutObject->Output(
            TemplateFile => 'SystemConfiguration/SettingsList',
            Data         => {
                SettingList             => \@SettingList,
                OTRSBusinessIsInstalled => $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled(),
                ConfigLevel             => $ConfigLevel
            },
        );

        return $LayoutObject->Attachment(
            NoCache     => 1,
            ContentType => 'text/html',
            Charset     => $LayoutObject->{UserCharset},
            Content     => $Output || '',
            Type        => 'inline',
        );
    }
    elsif ( $Self->{Subaction} eq 'AddArrayItem' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
        my $SettingName = $ParamObject->GetParam( Param => 'SettingName' ) || '';

        my $IDSuffix  = $ParamObject->GetParam( Param => 'IDSuffix' )  || '';
        my $Structure = $ParamObject->GetParam( Param => 'Structure' ) || '';

        my @SettingStructure = split '\.', $Structure;
        pop @SettingStructure;

        my %Result;
        if ( !$SettingName ) {
            $Result{Error} = Translatable("Missing setting name.");
            return $Self->_ReturnJSON( Response => \%Result );
        }

        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        if ( !%Setting ) {
            $Result{Error} = Translatable("Setting not found.");
            return $Self->_ReturnJSON( Response => \%Result );
        }

        my $Value = $Setting{XMLContentParsed}->{Value}->[0];

        %Result = $SysConfigObject->SettingAddItem(
            Value            => $Value,
            IDSuffix         => $IDSuffix,
            SettingStructure => \@SettingStructure,
            Setting          => \%Setting,
            UserID           => $Self->{UserID},
        );

        if ( $Result{Item} =~ m{(input|select)} ) {
            $Result{IsComplex} = 0;
        }
        else {
            $Result{IsComplex} = 1;
        }

        return $Self->_ReturnJSON( Response => \%Result );
    }
    elsif ( $Self->{Subaction} eq 'AddHashKey' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
        my $SettingName = $ParamObject->GetParam( Param => 'SettingName' ) || '';
        my $Key         = $ParamObject->GetParam( Param => 'Key' ) || '';

        my $IDSuffix  = $ParamObject->GetParam( Param => 'IDSuffix' )  || '';
        my $Structure = $ParamObject->GetParam( Param => 'Structure' ) || '';

        my @SettingStructure = split '\.', $Structure;
        pop @SettingStructure;

        my %Result;
        for my $Needed (qw(Name Key)) {
            if ( !$Needed ) {
                $Result{Error} = Translatable("Missing setting $Needed.");
                return $Self->_ReturnJSON( Response => \%Result );
            }
        }

        my %Setting = $SysConfigObject->SettingGet(
            Name => $SettingName,
        );

        if ( !%Setting ) {
            $Result{Error} = Translatable("Setting not found.");
            return $Self->_ReturnJSON( Response => \%Result );
        }

        my $Value = $Setting{XMLContentParsed}->{Value}->[0];

        %Result = $SysConfigObject->SettingAddItem(
            Value             => $Value,
            IDSuffix          => $IDSuffix,
            SettingStructure  => \@SettingStructure,
            Setting           => \%Setting,
            Key               => $Key,
            AddSettingContent => 1,
            UserID            => $Self->{UserID},
        );

        return $Self->_ReturnJSON( Response => \%Result );
    }
    elsif ( $Self->{Subaction} eq 'CheckSettings' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $SettingsJSON = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam(
            Param => 'Settings'
        );

        my %Result = ( Data => [] );

        if ( !$SettingsJSON ) {
            $Result{Error} = $Kernel::OM->Get('Kernel::Language')->Translate(
                "Missing Settings!",
            );
            return $Self->_ReturnJSON( Response => \%Result );
        }

        my $Settings = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
            Data => $SettingsJSON,
        );

        if ( !IsArrayRefWithData($Settings) ) {
            return $Self->_ReturnJSON( Response => \%Result );
        }

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my @UpdatedSettingsList = $SysConfigObject->SettingsUpdatedList(
            Settings => $Settings,
            UserID   => $Self->{UserID},
        );

        for my $Setting (@UpdatedSettingsList) {

            my %UpdatedSetting = $SysConfigObject->SettingGet(
                Name            => $Setting->{SettingName},
                OverriddenInXML => 1,
                UserID          => $Self->{UserID},
            );

            my %Item;

            $Item{SettingData}->{IsLockedByAnotherUser} = $Setting->{IsLockedByAnotherUser};
            for my $Key (qw(ExclusiveLockGUID IsModified IsDirty IsValid UserModificationActive)) {
                $Item{SettingData}->{$Key} = $UpdatedSetting{$Key};
            }

            $Item{HTMLStrg} = $SysConfigObject->SettingRender(
                Setting => \%UpdatedSetting,
                UserID  => $Self->{UserID},
            );

            $Item{SettingData}->{DefaultID} = $UpdatedSetting{DefaultID};

            if ( $Item{HTMLStrg} =~ m{BadEffectiveValue}gsmx ) {
                $Item{SettingData}->{Invalid} = 1;
            }

            push @{ $Result{Data} }, \%Item;
        }

        return $Self->_ReturnJSON( Response => \%Result );
    }

    # Show the content of a group with all settings.
    my $Output = $LayoutObject->Header();
    $Output .= $LayoutObject->NavigationBar();

    my $RootNavigation = $ParamObject->GetParam( Param => 'RootNavigation' ) || '';

    # Get path structure to show in the bread crumbs
    my @Path = $SysConfigObject->SettingNavigationToPath(
        Navigation => $RootNavigation,
    );

    # Get navigation tree
    my %Tree = $SysConfigObject->ConfigurationNavigationTree();

    my $Category = $ParamObject->GetParam( Param => 'Category' ) || '';
    $Category = $Category eq 'All' ? '' : $Category;

    # Get all settings by navigation group
    my @SettingList = $SysConfigObject->ConfigurationListGet(
        Navigation      => $RootNavigation,
        Translate       => 0,
        Category        => $Category,
        OverriddenInXML => 1,
        UserID          => $Self->{UserID},
    );

    # get favorites from user preferences
    my $Favourites;
    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    if ( $UserPreferences{UserSystemConfigurationFavourites} ) {
        $Favourites = $Kernel::OM->Get('Kernel::System::JSON')
            ->Decode( Data => $UserPreferences{UserSystemConfigurationFavourites} );
    }

    for my $Setting (@SettingList) {
        my %LockStatus = $SysConfigObject->SettingLockCheck(
            DefaultID           => $Setting->{DefaultID},
            ExclusiveLockGUID   => $Setting->{ExclusiveLockGUID} || '1',
            ExclusiveLockUserID => $Self->{UserID},
        );

        # append status
        %{$Setting} = (
            %{$Setting},
            %LockStatus,
        );

        # check if this setting is a favorite of the current user
        if ( grep { $_ eq $Setting->{Name} } @{$Favourites} ) {
            $Setting->{IsFavourite} = 1;
        }

        $Setting->{HTMLStrg} = $SysConfigObject->SettingRender(
            Setting => $Setting,
            RW      => ( $Setting->{Locked} && $Setting->{Locked} == 2 ) ? 1 : 0,
            UserID  => $Self->{UserID},
        );

        if ( $Setting->{HTMLStrg} =~ m{BadEffectiveValue}gsmx ) {
            $Setting->{Invalid} = 1;
        }
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'AdminSystemConfigurationGroup',
        Data         => {
            Tree                    => \%Tree,
            Path                    => \@Path,
            RootNavigation          => $RootNavigation,
            SettingList             => \@SettingList,
            CategoriesStrg          => $Self->_GetCategoriesStrg(),
            InvalidSettings         => $Self->_CheckInvalidSettings(),
            OTRSBusinessIsInstalled => $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled(),
            ConfigLevel             => $ConfigLevel,
        },
    );
    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetCategoriesStrg {
    my ( $Self, %Param ) = @_;

    # get selected category
    my %UserPreferences = $Kernel::OM->Get('Kernel::System::User')->GetPreferences(
        UserID => $Self->{UserID},
    );

    my $Category = $UserPreferences{UserSystemConfigurationCategory};

    my %Categories = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationCategoriesGet();

    my %CategoryData = map { $_ => $Categories{$_}->{DisplayName} } keys %Categories;

    my $CategoriesStrg = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->BuildSelection(
        Data         => \%CategoryData,
        Name         => 'Category',
        SelectedID   => $Category || 'All',
        PossibleNone => 0,
        Translation  => 1,
        Sort         => 'AlphaNumericKey',
        Class        => 'Modernize',
        Title        => $Kernel::OM->Get('Kernel::Language')->Translate('Category Search'),
    );

    return $CategoriesStrg;
}

sub _ReturnJSON {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Response)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # JSON response
    my $JSON = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
        Data => $Param{Response},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

sub _CheckInvalidSettings {
    my ( $Self, %Param ) = @_;

    my @InvalidSettings = $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigurationInvalidList(
        CachedOnly => 1,
    );

    return 0 if !@InvalidSettings;

    return 1;
}

1;
