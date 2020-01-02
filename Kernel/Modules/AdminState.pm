# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminState;

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
    my $StateObject  = $Kernel::OM->Get('Kernel::System::State');

    # ------------------------------------------------------------ #
    # change
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Change' ) {
        my $ID     = $ParamObject->GetParam( Param => 'ID' ) || '';
        my %Data   = $StateObject->StateGet( ID => $ID );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Change',
            %Data,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminState',
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

        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID Name TypeID Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name ValidID TypeID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }
        my %StateData = $StateObject->StateGet( ID => $GetParam{ID} );

        # Check if state is present in SysConfig setting
        my $UpdateEntity    = $ParamObject->GetParam( Param => 'UpdateEntity' ) || '';
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my %StateOldData    = %StateData;
        my @IsStateInSysConfig;
        @IsStateInSysConfig = $SysConfigObject->ConfigurationEntityCheck(
            EntityType => 'State',
            EntityName => $StateData{Name},
        );
        if (@IsStateInSysConfig) {

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
            elsif ( $StateData{Name} ne $GetParam{Name} && !$UpdateEntity ) {
                $Errors{NameInvalid}              = 'ServerError';
                $Errors{InSettingNameServerError} = 'InSetting';
            }

            # Check if it has at least one valid state.
        }
        else {
            my @MergeStateList = $StateObject->StateGetStatesByType(
                StateType => ['merged'],
                Result    => 'ID',
            );

            if (
                scalar @MergeStateList == 1
                && $MergeStateList[0] eq $GetParam{ID}
                && $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( ValidID => $GetParam{ValidID} ) ne 'valid'
                )
            {
                $Errors{ValidIDInvalid}         = 'ServerError';
                $Errors{ValidOptionServerError} = 'MergeError';
            }
        }

        # if no errors occurred
        if ( !%Errors ) {

            # update the state data
            my $UpdateSuccess = $StateObject->StateUpdate(
                %GetParam,
                UserID => $Self->{UserID},
            );

            if ($UpdateSuccess) {

                if (
                    @IsStateInSysConfig
                    && $StateOldData{Name} ne $GetParam{Name}
                    && $UpdateEntity
                    )
                {
                    SETTING:
                    for my $SettingName (@IsStateInSysConfig) {

                        my %Setting = $SysConfigObject->SettingGet(
                            Name => $SettingName,
                        );

                        next SETTING if !IsHashRefWithData( \%Setting );

                        $Setting{EffectiveValue} =~ s/$StateOldData{Name}/$GetParam{Name}/g;

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
                        Comments      => "State name change",
                        DirtySettings => \@IsStateInSysConfig,
                        UserID        => $Self->{UserID},
                        Force         => 1,
                    );
                }

                # if the user would like to continue editing the state, just redirect to the edit screen
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
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Change',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminState',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------ #
    # add
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Add' ) {
        my %GetParam;
        $GetParam{Name} = $ParamObject->GetParam( Param => 'Name' );
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Self->_Edit(
            Action => 'Add',
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminState',
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

        my ( %GetParam, %Errors );
        for my $Parameter (qw(ID TypeID Name Comment ValidID)) {
            $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
        }

        # check needed data
        for my $Needed (qw(Name ValidID TypeID)) {
            if ( !$GetParam{$Needed} ) {
                $Errors{ $Needed . 'Invalid' } = 'ServerError';
            }
        }

        my @MergeStateList = $StateObject->StateGetStatesByType(
            StateType => ['merged'],
            Result    => 'ID',
        );
        if (
            !@MergeStateList
            && $Kernel::OM->Get('Kernel::System::Valid')->ValidLookup( ValidID => $GetParam{ValidID} ) ne 'valid'
            && $StateObject->StateTypeLookup( StateTypeID => $GetParam{TypeID} ) eq 'merged'
            )
        {
            $Errors{ValidIDInvalid}         = 'ServerError';
            $Errors{ValidOptionServerError} = 'MergeError';
        }

        # if no errors occurred
        if ( !%Errors ) {

            # add state
            my $StateID = $StateObject->StateAdd(
                %GetParam,
                UserID => $Self->{UserID},
            );
            if ($StateID) {
                $Self->_Overview();
                my $Output = $LayoutObject->Header();
                $Output .= $LayoutObject->NavigationBar();
                $Output .= $LayoutObject->Notify( Info => Translatable('State added!') );
                $Output .= $LayoutObject->Output(
                    TemplateFile => 'AdminState',
                    Data         => \%Param,
                );
                $Output .= $LayoutObject->Footer();
                return $Output;
            }
        }

        # something has gone wrong
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Notify( Priority => 'Error' );
        $Self->_Edit(
            Action => 'Add',
            Errors => \%Errors,
            %GetParam,
        );
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminState',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

    # ------------------------------------------------------------
    # overview
    # ------------------------------------------------------------
    else {
        $Self->_Overview();
        my $Output = $LayoutObject->Header();
        $Output .= $LayoutObject->NavigationBar();
        $Output .= $LayoutObject->Output(
            TemplateFile => 'AdminState',
            Data         => \%Param,
        );
        $Output .= $LayoutObject->Footer();
        return $Output;
    }

}

sub _Edit {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $StateObject  = $Kernel::OM->Get('Kernel::System::State');

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
    $Param{StateTypeOption} = $LayoutObject->BuildSelection(
        Data       => { $StateObject->StateTypeList( UserID => 1 ), },
        Name       => 'TypeID',
        SelectedID => $Param{TypeID},
        Class      => 'Modernize Validate_Required ' . ( $Param{Errors}->{'TypeIDInvalid'} || '' ),
    );
    $LayoutObject->Block(
        Name => 'OverviewUpdate',
        Data => {
            %Param,
            %{ $Param{Errors} },
        },
    );

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

        my $StateName = $Kernel::OM->Get('Kernel::System::State')->StateLookup(
            StateID => $Param{ID},
        );

        # Add warning in case the Type belongs a SysConfig setting.
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # In case dirty setting, disable form.
        my $IsDirtyConfig = 0;
        my @IsDirtyResult = $SysConfigObject->ConfigurationDirtySettingsList();
        my %IsDirtyList   = map { $_ => 1 } @IsDirtyResult;

        my @IsStateInSysConfig = $SysConfigObject->ConfigurationEntityCheck(
            EntityType => 'State',
            EntityName => $StateName // '',
        );
        if (@IsStateInSysConfig) {
            $LayoutObject->Block(
                Name => 'StateInSysConfig',
                Data => {
                    OldName => $StateName,
                },
            );
            for my $SettingName (@IsStateInSysConfig) {
                $LayoutObject->Block(
                    Name => 'StateInSysConfigRow',
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
                Name => 'StateInSysConfigDirty',
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

    my $StateObject = $Kernel::OM->Get('Kernel::System::State');
    my %List        = $StateObject->StateList(
        UserID => 1,
        Valid  => 0,
    );

    # if there are any states, they are shown
    if (%List) {

        # get valid list
        my %ValidList = $Kernel::OM->Get('Kernel::System::Valid')->ValidList();

        for my $ListKey ( sort { lc $List{$a} cmp lc $List{$b} } keys %List ) {

            my %Data = $StateObject->StateGet( ID => $ListKey );
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
