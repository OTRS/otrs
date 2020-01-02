# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminType;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # Store last entity screen.
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenEntity',
        Value     => $Self->{RequestedURL},
    );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $TypeObject   = $Kernel::OM->Get('Kernel::System::Type');

    # Check if ticket type is enabled.
    my $TypeNotActive;
    if ( !$Kernel::OM->Get('Kernel::Config')->Get('Ticket::Type') ) {
        $TypeNotActive = $LayoutObject->Notify(
            Priority => 'Error',
            Data     => $LayoutObject->{LanguageObject}->Translate( "Please activate %s first!", "Type" ),
            Link =>
                $LayoutObject->{Baselink}
                . 'Action=AdminSystemConfiguration;Subaction=View;Setting=Ticket%3A%3AType',
        );
    }

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID   = $ParamObject->GetParam( Param => 'ID' ) || '';
        my %Data = $TypeObject->TypeGet( ID => $ID );
        if ( !%Data ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need Type!'),
            );
        }
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $TypeNotActive;
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminType',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # change action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ChangeAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Text Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        my %Data = $TypeObject->TypeGet( ID => $GetParam{ID} );
        if ( !%Data ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need Type!'),
            );
        }

        # check if a type exists with this name
        my $NameExists = $TypeObject->NameExistsCheck(
            Name => $GetParam{Name},
            ID   => $GetParam{ID}
        );

        if ($NameExists) {
            $Errors{NameExists}    = 1;
            $Errors{'NameInvalid'} = 'ServerError';
        }

        # Check if type is present in SysConfig setting
        my $UpdateEntity    = $ParamObject->GetParam( Param => 'UpdateEntity' ) || '';
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my %TypeOldData     = %Data;
        my @IsTypeInSysConfig;
        @IsTypeInSysConfig = $SysConfigObject->ConfigurationEntityCheck(
            EntityType => 'Type',
            EntityName => $Data{Name},
        );
        if (@IsTypeInSysConfig) {

            # An entity present in SysConfig couldn't be invalidated.
            if (
                $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( ValidID => $GetParam{ValidID} )
                ne 'valid'
                )
            {
                $Errors{ValidIDInvalid}         = 'ServerError';
                $Errors{ValidOptionServerError} = 'InSetting';
            }

            # In case changing name an authorization (UpdateEntity) should be send
            elsif ( $Data{Name} ne $GetParam{Name} && !$UpdateEntity ) {
                $Errors{NameInvalid}              = 'ServerError';
                $Errors{InSettingNameServerError} = 'InSetting';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update type
            my $Update = $TypeObject->TypeUpdate(
                %GetParam,
                UserID => $Self->{UserID}
            );

            if ($Update) {

                if (
                    @IsTypeInSysConfig
                    && $TypeOldData{Name} ne $GetParam{Name}
                    && $UpdateEntity
                    )
                {
                    SETTING:
                    for my $SettingName (@IsTypeInSysConfig) {

                        my %Setting = $SysConfigObject->SettingGet(
                            Name => $SettingName,
                        );

                        next SETTING if !IsHashRefWithData( \%Setting );

                        $Setting{EffectiveValue} =~ s/$TypeOldData{Name}/$GetParam{Name}/g;

                        my $ExclusiveLockGUID = $SysConfigObject->SettingLock(
                            Name   => $Setting{Name},
                            Force  => 1,
                            UserID => $Self->{UserID}
                        );
                        $Setting{ExclusiveLockGUID} = $ExclusiveLockGUID;

                        my %UpdateSuccess = $SysConfigObject->SettingUpdate(
                            %Setting,
                            UserID => $Self->{UserID},
                        );
                    }

                    $SysConfigObject->ConfigurationDeploy(
                        Comments      => "Type name change",
                        DirtySettings => \@IsTypeInSysConfig,
                        UserID        => $Self->{UserID},
                        Force         => 1,
                    );
                }

                # if the user would like to continue editing the type, just redirect to the edit screen
                if (
                    defined $ParamObject->GetParam( Param => 'ContinueAfterSave' )
                    && ( $ParamObject->GetParam( Param => 'ContinueAfterSave' ) eq '1' )
                    )
                {
                    my $ID = $ParamObject->GetParam( Param => 'ID' ) || '';
                    return $LayoutObject->Redirect( OP => "Action=$Self->{Action};Subaction=Change;ID=$ID" );
                }
                else {

                    # otherwise return to overview
                    return $LayoutObject->Redirect( OP => "Action=$Self->{Action}" );
                }
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $TypeNotActive;
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Change',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminType',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam = ();

        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $TypeNotActive;
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminType',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add action
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        my $Note = '';
        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name Text Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name ValidID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        # check if a type exists with this name
        my $NameExists = $TypeObject->NameExistsCheck( Name => $GetParam{Name} );
        if ($NameExists) {
            $Errors{NameExists}    = 1;
            $Errors{'NameInvalid'} = 'ServerError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add type
            my $NewType = $TypeObject->TypeAdd(
                %GetParam,
                UserID => $Self->{UserID}
            );
            if ($NewType) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $TypeNotActive;
                $Output .= $LayoutObject->Notify( Info => Translatable('Type added!') );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminType',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $TypeNotActive;
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Add',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminType',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {

        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $TypeNotActive;

        $Self->_Overview();

        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminType',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionOverview' );

    # get valid list
    my %ValidList        = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();
    my %ValidListReverse = reverse %ValidList;

    $Param{ValidOption} = $LayoutObject->BuildSelection(
        Data       => \%ValidList,
        Name       => 'ValidID',
        SelectedID => $Param{ValidID} || $ValidListReverse{valid},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'ValidIDInvalid'} || '' ),
    );

    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

    # show appropriate messages for ServerError
    if ( defined $Param{Errors}->{NameExists} && $Param{Errors}->{NameExists} == 1 ) {
        $LayoutObject->Block( Name => 'ExistNameServerError' );
    }
    else {
        $LayoutObject->Block( Name => 'NameServerError' );
    }

    # Several error messages can be used for Name.
    $Param{Errors}->{InSettingNameServerError} //= 'Required';
    $LayoutObject->Block(
        Name => $Param{Errors}->{InSettingNameServerError} . 'NameServerError',
    );

    # Several error messages can be used for Valid option.
    $Param{Errors}->{ValidOptionServerError} //= 'Required';
    $LayoutObject->Block(
        Name => $Param{Errors}->{ValidOptionServerError} . 'ValidOptionServerError',
    );

    if ( $Param{ID} ) {

        my $TypeName = $Kernel::OM->Get('Kernel::System::Type')->TypeLookup( TypeID => $Param{ID} );

        # Add warning in case the Type belongs a SysConfig setting.
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # In case dirty setting, disable form.
        my $IsDirtyConfig = 0;
        my @IsDirtyResult = $SysConfigObject->ConfigurationDirtySettingsList();
        my %IsDirtyList   = map { $_ => 1 } @IsDirtyResult;

        my @IsTypeInSysConfig = $SysConfigObject->ConfigurationEntityCheck(
            EntityType => 'Type',
            EntityName => $TypeName // '',
        );
        if (@IsTypeInSysConfig) {
            $LayoutObject->Block(
                Name => 'TypeInSysConfig',
                Data => {
                    OldName => $TypeName,
                },
            );
            for my $SettingName (@IsTypeInSysConfig) {
                $LayoutObject->Block(
                    Name => 'TypeInSysConfigRow',
                    Data => {
                        SettingName => $SettingName,
                    },
                );

                # Verify if dirty setting.
                if ( $IsDirtyList{$SettingName} ) {
                    $IsDirtyConfig = 1;
                }
            }
        }

        if ($IsDirtyConfig) {
            $LayoutObject->Block(
                Name => 'TypeInSysConfigDirty',
            );
        }
    }

    return 1;
}

sub _Overview {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $LayoutObject->Block(
        Name => 'Overview',
        Data => \%Param,
    );

    $LayoutObject->Block( Name => 'ActionList' );
    $LayoutObject->Block( Name => 'ActionAdd' );
    $LayoutObject->Block( Name => 'Filter' );

    $LayoutObject->Block(
        Name => 'OverviewResult',
        Data => \%Param,
    );

    my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');
    my %List       = $TypeObject->TypeList( Valid => 0 );

    # if there are any types, they are shown
    if (%List) {

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

        for my $TypeID ( sort { $List{$a} cmp $List{$b} } keys %List ) {

            my %Data = $TypeObject->TypeGet(
                ID => $TypeID,
            );
            $LayoutObject->Block(
                Name => 'OverviewResultRow',
                Data => {
                    Valid => $ValidList{ $Data{ValidID} },
                    %Data,
                },
            );
        }
    }

    # otherwise a no data found msg is displayed
    else {
        $LayoutObject->Block(
            Name => 'NoDataFoundMsg',
            Data => {},
        );
    }
    return 1;
}

1;
