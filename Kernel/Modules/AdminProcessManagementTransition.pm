# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagementTransition;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

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

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    $Self->{Subaction} = $ParamObject->GetParam( Param => 'Subaction' ) || '';

    my $TransitionID = $ParamObject->GetParam( Param => 'ID' )       || '';
    my $EntityID     = $ParamObject->GetParam( Param => 'EntityID' ) || '';

    my %SessionData = $Kernel::OM->Get('Kernel::System::AuthSession')->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );

    # convert JSON string to array
    $Self->{ScreensPath} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $SessionData{ProcessManagementScreensPath}
    );

    # get needed objects
    my $LayoutObject     = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $EntityObject     = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Entity');
    my $TransitionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');

    # ------------------------------------------------------------ #
    # TransitionNew
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'TransitionNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # TransitionNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionNewAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get transition action data
        my $TransitionData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new configuration
        $TransitionData->{Name}   = $GetParam->{Name};
        $TransitionData->{Config} = $GetParam->{Config};

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                TransitionData => $TransitionData,
                Action         => 'New',
            );
        }

        # generate entity ID
        my $EntityID = $EntityObject->EntityIDGenerate(
            EntityType => 'Transition',
            UserID     => $Self->{UserID},
        );

        # show error if can't generate a new EntityID
        if ( !$EntityID ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error generating a new EntityID for this Transition",
            );
        }

        # otherwise save configuration and return process screen
        my $TransitionID = $TransitionObject->TransitionAdd(
            Name     => $TransitionData->{Name},
            EntityID => $EntityID,
            Config   => $TransitionData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't create
        if ( !$TransitionID ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error creating the Transition",
            );
        }

        # set entity sync state
        my $Success = $EntityObject->EntitySyncStateSet(
            EntityType => 'Transition',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error setting the entity sync status for Transition "
                    . "entity:$EntityID",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $ParamObject->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $TransitionConfig = $Self->_GetTransitionConfig(
            EntityID => $EntityID,
        );

        my $ConfigJSON = $LayoutObject->JSONEncode( Data => $TransitionConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $TransitionID,
                EntityID  => $EntityID,
                Subaction => 'TransitionEdit'    # always use edit screen
            );

            my $RedirectAction    = $ParamObject->GetParam( Param => 'PopupRedirectAction' )    || '';
            my $RedirectSubaction = $ParamObject->GetParam( Param => 'PopupRedirectSubaction' ) || '';
            my $RedirectID        = $ParamObject->GetParam( Param => 'PopupRedirectID' )        || '';
            my $RedirectEntityID  = $ParamObject->GetParam( Param => 'PopupRedirectEntityID' )  || '';

            # redirect to another popup window
            return $Self->_PopupResponse(
                Redirect => 1,
                Screen   => {
                    Action    => $RedirectAction,
                    Subaction => $RedirectSubaction,
                    ID        => $RedirectID,
                    EntityID  => $RedirectID,
                },
                ConfigJSON => $ConfigJSON,
            );
        }
        else {

            # remove last screen
            my $LastScreen = $Self->_PopSessionScreen();

            # check if needed to return to main screen or to be redirected to last screen
            if ( $LastScreen->{Action} eq 'AdminProcessManagement' ) {

                # close the popup
                return $Self->_PopupResponse(
                    ClosePopup => 1,
                    ConfigJSON => $ConfigJSON,
                );
            }
            else {

                # redirect to last screen
                return $Self->_PopupResponse(
                    Redirect   => 1,
                    Screen     => $LastScreen,
                    ConfigJSON => $ConfigJSON,
                );
            }
        }
    }

    # ------------------------------------------------------------ #
    # TransitionEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionEdit' ) {

        # check for TransitionID
        if ( !$TransitionID ) {
            return $LayoutObject->ErrorScreen(
                Message => "Need TransitionID!",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        # get Transition data
        my $TransitionData = $TransitionObject->TransitionGet(
            ID     => $TransitionID,
            UserID => $Self->{UserID},
        );

        # check for valid Transition data
        if ( !IsHashRefWithData($TransitionData) ) {
            return $LayoutObject->ErrorScreen(
                Message => "Could not get data for TransitionID $TransitionID",
            );
        }

        return $Self->_ShowEdit(
            %Param,
            TransitionID   => $TransitionID,
            TransitionData => $TransitionData,
            Action         => 'Edit',
        );

    }

    # ------------------------------------------------------------ #
    # TransitionEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'TransitionEditAction' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        # get transition action data
        my $TransitionData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new configuration
        $TransitionData->{Name}     = $GetParam->{Name};
        $TransitionData->{EntityID} = $EntityID;
        $TransitionData->{Config}   = $GetParam->{Config};

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                TransitionData => $TransitionData,
                Action         => 'Edit',
            );
        }

        # otherwise save configuration and return to overview screen
        my $Success = $TransitionObject->TransitionUpdate(
            ID       => $TransitionID,
            EntityID => $EntityID,
            Name     => $TransitionData->{Name},
            Config   => $TransitionData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't update
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error updating the Transition",
            );
        }

        # set entity sync state
        $Success = $EntityObject->EntitySyncStateSet(
            EntityType => 'Transition',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => "There was an error setting the entity sync status for Transition "
                    . "entity:$TransitionData->{EntityID}",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $ParamObject->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $TransitionConfig = $Self->_GetTransitionConfig(
            EntityID => $TransitionData->{EntityID},
        );

        my $ConfigJSON = $LayoutObject->JSONEncode( Data => $TransitionConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $TransitionID,
                EntityID  => $TransitionData->{EntityID},
                Subaction => 'TransitionEdit'               # always use edit screen
            );

            my $RedirectAction    = $ParamObject->GetParam( Param => 'PopupRedirectAction' )    || '';
            my $RedirectSubaction = $ParamObject->GetParam( Param => 'PopupRedirectSubaction' ) || '';
            my $RedirectID        = $ParamObject->GetParam( Param => 'PopupRedirectID' )        || '';
            my $RedirectEntityID  = $ParamObject->GetParam( Param => 'PopupRedirectEntityID' )  || '';

            # redirect to another popup window
            return $Self->_PopupResponse(
                Redirect => 1,
                Screen   => {
                    Action    => $RedirectAction,
                    Subaction => $RedirectSubaction,
                    ID        => $RedirectID,
                    EntityID  => $RedirectID,
                },
                ConfigJSON => $ConfigJSON,
            );
        }
        else {

            # remove last screen
            my $LastScreen = $Self->_PopSessionScreen();

            # check if needed to return to main screen or to be redirected to last screen
            if ( $LastScreen->{Action} eq 'AdminProcessManagement' ) {

                # close the popup
                return $Self->_PopupResponse(
                    ClosePopup => 1,
                    ConfigJSON => $ConfigJSON,
                );
            }
            else {

                # redirect to last screen
                return $Self->_PopupResponse(
                    Redirect   => 1,
                    Screen     => $LastScreen,
                    ConfigJSON => $ConfigJSON,
                );
            }
        }

    }

    # ------------------------------------------------------------ #
    # Close popup
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ClosePopup' ) {

        # close the popup
        return $Self->_PopupResponse(
            ClosePopup => 1,
        );
    }

    # ------------------------------------------------------------ #
    # Error
    # ------------------------------------------------------------ #
    else {
        return $LayoutObject->ErrorScreen(
            Message => "This subaction is not valid",
        );
    }
}

sub _GetTransitionConfig {
    my ( $Self, %Param ) = @_;

    # Get new Transition Config as JSON
    my $ProcessDump = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessDump(
        ResultType => 'HASH',
        UserID     => $Self->{UserID},
    );

    my %TransitionConfig;
    $TransitionConfig{Transition} = ();
    $TransitionConfig{Transition}->{ $Param{EntityID} } = $ProcessDump->{Transition}->{ $Param{EntityID} };

    return \%TransitionConfig;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get Transition information
    my $TransitionData = $Param{TransitionData} || {};

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # check if last screen action is main screen
    if ( $Self->{ScreensPath}->[-1]->{Action} eq 'AdminProcessManagement' ) {

        # show close popup link
        $LayoutObject->Block(
            Name => 'ClosePopup',
            Data => {},
        );
    }
    else {

        # show go back link
        $LayoutObject->Block(
            Name => 'GoBack',
            Data => {
                Action          => $Self->{ScreensPath}->[-1]->{Action}          || '',
                Subaction       => $Self->{ScreensPath}->[-1]->{Subaction}       || '',
                ID              => $Self->{ScreensPath}->[-1]->{ID}              || '',
                EntityID        => $Self->{ScreensPath}->[-1]->{EntityID}        || '',
                StartActivityID => $Self->{ScreensPath}->[-1]->{StartActivityID} || '',
            },
        );
    }

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {
        $Param{Title} = "Edit Transition \"$TransitionData->{Name}\"";
    }
    else {
        $Param{Title} = 'Create New Transition';
    }

    my $Output = $LayoutObject->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );

    $Param{FreshConditionLinking} = $LayoutObject->BuildSelection(
        Data        => [ 'and', 'or', 'xor' ],
        Name        => "ConditionLinking[_INDEX_]",
        Sort        => 'AlphanumericKey',
        Translation => 1,
        Class       => 'W50pc',
    );

    $Param{FreshConditionFieldType} = $LayoutObject->BuildSelection(
        Data => {
            'String' => 'String',

          # disable hash and array selection here, because there is no practical way to enter the needed data in the GUI
          # TODO: implement a possibility to enter the data in a correct way in the GUI
          #'Hash'   => 'Hash',
          #'Array'  => 'Array',
            'Regexp' => 'Regexp',
            'Module' => 'Transition Validation Module'
        },
        SelectedID   => 'String',
        Name         => "ConditionFieldType[_INDEX_][_FIELDINDEX_]",
        Sort         => 'AlphanumericKey',
        PossibleNone => 1,
        Class        => 'Validate_Required',
        Translation  => 1,
    );

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {

        $Param{OverallConditionLinking} = $LayoutObject->BuildSelection(
            Data        => [ 'and', 'or', 'xor' ],
            Name        => 'OverallConditionLinking',
            ID          => 'OverallConditionLinking',
            Sort        => 'AlphanumericKey',
            Translation => 1,
            Class       => 'W50pc',
            SelectedID  => $TransitionData->{Config}->{ConditionLinking},
        );

        my @Conditions = sort keys %{ $TransitionData->{Config}->{Condition} };

        for my $Condition (@Conditions) {

            my %ConditionData = %{ $TransitionData->{Config}->{Condition}->{$Condition} };

            my $ConditionLinking = $LayoutObject->BuildSelection(
                Data        => [ 'and', 'or', 'xor' ],
                Name        => "ConditionLinking[$Condition]",
                Sort        => 'AlphanumericKey',
                Translation => 1,
                Class       => 'W50pc',
                SelectedID  => $ConditionData{Type},
            );

            $LayoutObject->Block(
                Name => 'ConditionItemEditRow',
                Data => {
                    ConditionLinking => $ConditionLinking,
                    Index            => $Condition,
                },
            );

            my @Fields = sort keys %{ $ConditionData{Fields} };
            for my $Field (@Fields) {

                my %FieldData          = %{ $ConditionData{Fields}->{$Field} };
                my $ConditionFieldType = $LayoutObject->BuildSelection(
                    Data => {
                        'String' => 'String',

          # disable hash and array selection here, because there is no practical way to enter the needed data in the GUI
          # TODO: implement a possibility to enter the data in a correct way in the GUI
          #'Hash'   => 'Hash',
          #'Array'  => 'Array',
                        'Regexp' => 'Regexp',
                        'Module' => 'Transition Validation Module'
                    },
                    Name         => "ConditionFieldType[$Condition][$Field]",
                    Sort         => 'AlphanumericKey',
                    Translation  => 1,
                    PossibleNone => 1,
                    Class        => 'Validate_Required',
                    SelectedID   => $FieldData{Type},
                );

                # show fields
                $LayoutObject->Block(
                    Name => "ConditionItemEditRowField",
                    Data => {
                        Index              => $Condition,
                        FieldIndex         => $Field,
                        ConditionFieldType => $ConditionFieldType,
                        %FieldData,
                    },
                );
            }
        }

        # display other affected processes by editing this activity (if applicable)
        my $AffectedProcesses = $Self->_CheckTransitionUsage(
            EntityID => $TransitionData->{EntityID},
        );

        if ( @{$AffectedProcesses} ) {

            $LayoutObject->Block(
                Name => 'EditWarning',
                Data => {
                    ProcessList => join( ', ', @{$AffectedProcesses} ),
                    }
            );
        }
    }
    else {

        $Param{OverallConditionLinking} = $LayoutObject->BuildSelection(
            Data        => [ 'and', 'or', 'xor' ],
            Name        => 'OverallConditionLinking',
            ID          => 'OverallConditionLinking',
            Sort        => 'AlphanumericKey',
            Translation => 1,
            Class       => 'W50pc',
        );

        $Param{ConditionLinking} = $LayoutObject->BuildSelection(
            Data        => [ 'and', 'or', 'xor' ],
            Name        => 'ConditionLinking[_INDEX_]',
            Sort        => 'AlphanumericKey',
            Translation => 1,
            Class       => 'W50pc',
        );

        $Param{ConditionFieldType} = $LayoutObject->BuildSelection(
            Data => {
                'String' => 'String',

          # disable hash and array selection here, because there is no practical way to enter the needed data in the GUI
          # TODO: implement a possibility to enter the data in a correct way in the GUI
          #'Hash'   => 'Hash',
          #'Array'  => 'Array',
                'Regexp' => 'Regexp',
                'Module' => 'Transition Validation Module'
            },
            Name        => 'ConditionFieldType[_INDEX_][_FIELDINDEX_]',
            Sort        => 'AlphanumericKey',
            Translation => 1,
        );

        $LayoutObject->Block(
            Name => 'ConditionItemInitRow',
            Data => {
                %Param,
            },
        );
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => "AdminProcessManagementTransition",
        Data         => {
            %Param,
            %{$TransitionData},
        },
    );

    $Output .= $LayoutObject->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get parameters from web browser
    $GetParam->{Name} = $ParamObject->GetParam( Param => 'Name' ) || '';
    $GetParam->{ConditionConfig} = $ParamObject->GetParam( Param => 'ConditionConfig' )
        || '';

    my $Config = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $GetParam->{ConditionConfig}
    );
    $GetParam->{Config} = {};
    $GetParam->{Config}->{Condition} = $Config;
    $GetParam->{Config}->{ConditionLinking} = $ParamObject->GetParam( Param => 'OverallConditionLinking' ) || '';

    return $GetParam;
}

sub _PopSessionScreen {
    my ( $Self, %Param ) = @_;

    my $LastScreen;

    if ( defined $Param{OnlyCurrent} && $Param{OnlyCurrent} == 1 ) {

        # check if last screen action is current screen action
        if ( $Self->{ScreensPath}->[-1]->{Action} eq $Self->{Action} ) {

            # remove last screen
            $LastScreen = pop @{ $Self->{ScreensPath} };
        }
    }
    else {

        # remove last screen
        $LastScreen = pop @{ $Self->{ScreensPath} };
    }

    # convert screens path to string (JSON)
    my $JSONScreensPath = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->JSONEncode(
        Data => $Self->{ScreensPath},
    );

    # update session
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ProcessManagementScreensPath',
        Value     => $JSONScreensPath,
    );

    return $LastScreen;
}

sub _PushSessionScreen {
    my ( $Self, %Param ) = @_;

    # add screen to the screen path
    push @{ $Self->{ScreensPath} }, {
        Action => $Self->{Action} || '',
        Subaction => $Param{Subaction},
        ID        => $Param{ID},
        EntityID  => $Param{EntityID},
    };

    # convert screens path to string (JSON)
    my $JSONScreensPath = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->JSONEncode(
        Data => $Self->{ScreensPath},
    );

    # update session
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ProcessManagementScreensPath',
        Value     => $JSONScreensPath,
    );

    return 1;
}

sub _PopupResponse {
    my ( $Self, %Param ) = @_;

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    if ( $Param{Redirect} && $Param{Redirect} eq 1 ) {
        $LayoutObject->Block(
            Name => 'Redirect',
            Data => {
                ConfigJSON => $Param{ConfigJSON},
                %{ $Param{Screen} },
            },
        );
    }
    elsif ( $Param{ClosePopup} && $Param{ClosePopup} eq 1 ) {
        $LayoutObject->Block(
            Name => 'ClosePopup',
            Data => {
                ConfigJSON => $Param{ConfigJSON},
            },
        );
    }

    my $Output = $LayoutObject->Header( Type => 'Small' );
    $Output .= $LayoutObject->Output(
        TemplateFile => "AdminProcessManagementPopupResponse",
        Data         => {},
    );
    $Output .= $LayoutObject->Footer( Type => 'Small' );

    return $Output;
}

sub _CheckTransitionUsage {
    my ( $Self, %Param ) = @_;

    # get a list of parents with all the details
    my $List = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessListGet(
        UserID => 1,
    );

    my @Usage;

    # search entity id in all parents
    PARENT:
    for my $ParentData ( @{$List} ) {
        next PARENT if !$ParentData;
        next PARENT if !$ParentData->{Transitions};
        ENTITY:
        for my $EntityID ( @{ $ParentData->{Transitions} } ) {
            if ( $EntityID eq $Param{EntityID} ) {
                push @Usage, $ParentData->{Name};
                last ENTITY;
            }
        }
    }

    return \@Usage;
}

1;
