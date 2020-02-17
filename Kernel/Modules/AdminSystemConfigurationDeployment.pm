# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminSystemConfigurationDeployment;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    # Lock the deployment
    if ( $Self->{Subaction} eq 'AJAXDeploymentIsLocked' ) {

        my $IsLocked = $Kernel::OM->Get('Kernel::System::SysConfig::DB')->DeploymentIsLocked();

        my $Result = 1;
        if ( !$IsLocked ) {
            $Result = '-1';
        }

        my $JSON = $LayoutObject->JSONEncode(
            Data => $Result,
        );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # Deploy the current configuration state.
    elsif ( $Self->{Subaction} eq 'AJAXDeployment' ) {

        # Challenge token check for write action.
        $LayoutObject->ChallengeTokenCheck();

        my $Comments         = $ParamObject->GetParam( Param => 'Comments' )         || '';
        my $AdvancedMode     = $ParamObject->GetParam( Param => 'AdvancedMode' )     || 0;
        my $SelectedSettings = $ParamObject->GetParam( Param => 'SelectedSettings' ) || '';

        if ($SelectedSettings) {
            $SelectedSettings = $Kernel::OM->Get('Kernel::System::JSON')->Decode( Data => $SelectedSettings );
        }

        my %ReturnData;

        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my %DeploymentResult = $SysConfigObject->ConfigurationDeploy(
            Comments      => $Comments,
            UserID        => $Self->{UserID},
            AllSettings   => ($AdvancedMode) ? 1 : 0,
            DirtySettings => $SelectedSettings || undef,
        );

        $ReturnData{Result} = \%DeploymentResult;

        if ( $Self->{LastEntityType} ) {

            # Unset Entity Type.
            $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key       => 'LastEntityType',
                Value     => '',
            );
            $ReturnData{RedirectURL} = $Self->{LastScreenEntity};
        }
        elsif ( $SysConfigObject->can('SettingHistory') ) {
            $ReturnData{RedirectURL} = 'Action=AdminSystemConfigurationDeploymentHistory;Subaction=DeploymentHistory';
        }

        my $JSON = $LayoutObject->JSONEncode(
            Data => \%ReturnData,
        );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # Search for settings.
    elsif ( $Self->{Subaction} eq 'Deployment' ) {

        my $SysConfigObject   = $Kernel::OM->Get('Kernel::System::SysConfig');
        my $SysConfigDBObject = $Kernel::OM->Get('Kernel::System::SysConfig::DB');
        my $AdvancedMode      = $ParamObject->GetParam( Param => 'AdvancedMode' ) || '';
        my $DeploymentRestore = $ParamObject->GetParam( Param => 'DeploymentRestore' ) || '';

        my @ModifiedSettingNames;

        if ($AdvancedMode) {
            @ModifiedSettingNames = $SysConfigObject->ConfigurationDirtySettingsList();
        }
        else {
            @ModifiedSettingNames = $SysConfigObject->ConfigurationDirtySettingsList(
                ChangeBy => $Self->{UserID}
            );
        }
        my @Settings;

        for my $SettingName ( sort @ModifiedSettingNames ) {

            my %Versions;

            # Get the current data of the setting.
            my %SettingCurrentState = $SysConfigDBObject->ModifiedSettingGet(
                Name => $SettingName,
            );

            # Get current values.
            my %CurrentValues = $SysConfigObject->SettingGet(
                Name       => $SettingName,
                ModifiedID => $SettingCurrentState{ModifiedID},
            );

            $Versions{Current} = \%CurrentValues;

            # Get default version of this setting.
            my %PreviousValues = $SysConfigObject->SettingGet(
                Name    => $SettingName,
                Default => 1,
            );

            # Get the previous deployed state of this setting.
            my %SettingPreviousState = $SysConfigDBObject->ModifiedSettingVersionGetLast(
                Name => $SettingCurrentState{Name},
            );

            # Use complementary values from previous deployed version (if any).
            if (%SettingPreviousState) {
                %PreviousValues = ( %PreviousValues, %SettingPreviousState );
            }

            $Versions{Previous} = \%PreviousValues;

            push @Settings, \%Versions;
        }

        for my $Setting (@Settings) {

            $Setting->{CurrentName}  = $Setting->{Current}->{Name};
            $Setting->{PreviousName} = $Setting->{Previous}->{Name};
            $Setting->{Navigation}   = $Setting->{Current}->{Navigation};

            # collect setting attributes
            $Setting->{PreviousIsValid} = $Setting->{Previous}->{IsValid};
            $Setting->{CurrentIsValid}  = $Setting->{Current}->{IsValid};

            # collect setting attributes
            $Setting->{PreviousUserModificationActive} = $Setting->{Previous}->{UserModificationActive};
            $Setting->{CurrentUserModificationActive}  = $Setting->{Current}->{UserModificationActive};

            $Setting->{HTMLStrg} = $SysConfigObject->SettingRender(
                Setting => $Setting->{Current},
                UserID  => $Self->{UserID},
            );
            $Setting->{PreviousHTMLStrg} = $SysConfigObject->SettingRender(
                Setting => $Setting->{Previous},
                UserID  => $Self->{UserID},
            );
        }

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();

        my $DontKnowSettings = $ParamObject->GetParam( Param => 'DontKnowSettings' ) || '';
        if ($DontKnowSettings) {
            $Output .= $LayoutObject->Notify(
                Info => $LayoutObject->{LanguageObject}->Translate(
                    "Some imported settings are not present in the current state of the configuration or it was not possible to update them. Please check the OTRS log for more information."
                ),
                Link => $LayoutObject->{Baselink} . 'Action=AdminLog',
            );
        }

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminSystemConfigurationDeployment',
            Data         => {
                SettingList             => \@Settings,
                AdvancedMode            => $AdvancedMode,
                DeploymentRestore       => $DeploymentRestore,
                Readonly                => 1,
                OTRSBusinessIsInstalled => $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled(),
            },
        );

        $Output .= $LayoutObject->Footer();
        return $Output;

    }

    else {

        # secure mode message (don't allow this action till secure mode is enabled)
        if ( !$Kernel::OM->Get('Kernel::Config')->Get('SecureMode') ) {
            return $LayoutObject->SecureMode();
        }

        return $LayoutObject->Redirect( OP => "Action=AdminSystemConfiguration" );
    }

}

1;
