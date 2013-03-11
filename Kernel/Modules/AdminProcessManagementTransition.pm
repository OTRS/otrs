# --
# Kernel/Modules/AdminProcessManagementTransition.pm - process management transition
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagementTransition;

use strict;
use warnings;

use Kernel::System::JSON;
use Kernel::System::ProcessManagement::DB::Process;
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Activity;
use Kernel::System::ProcessManagement::DB::Transition;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for my $Needed (
        qw(ParamObject DBObject LayoutObject ConfigObject LogObject MainObject EncodeObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }

    # create additional objects
    $Self->{JSONObject}     = Kernel::System::JSON->new( %{$Self} );
    $Self->{ProcessObject}  = Kernel::System::ProcessManagement::DB::Process->new( %{$Self} );
    $Self->{EntityObject}   = Kernel::System::ProcessManagement::DB::Entity->new( %{$Self} );
    $Self->{ActivityObject} = Kernel::System::ProcessManagement::DB::Activity->new( %{$Self} );
    $Self->{TransitionObject}
        = Kernel::System::ProcessManagement::DB::Transition->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || '';

    my $TransitionID = $Self->{ParamObject}->GetParam( Param => 'ID' )       || '';
    my $EntityID     = $Self->{ParamObject}->GetParam( Param => 'EntityID' ) || '';

    my %SessionData = $Self->{SessionObject}->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );

    # convert JSON string to array
    $Self->{ScreensPath} = $Self->{JSONObject}->Decode(
        Data => $SessionData{ProcessManagementScreensPath}
    );

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
        $Self->{LayoutObject}->ChallengeTokenCheck();

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
        my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
            EntityType => 'Transition',
            UserID     => $Self->{UserID},
        );

        # show error if can't generate a new EntityID
        if ( !$EntityID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error generating a new EntityID for this Transition",
            );
        }

        # otherwise save configuration and return process screen
        my $TransitionID = $Self->{TransitionObject}->TransitionAdd(
            Name     => $TransitionData->{Name},
            EntityID => $EntityID,
            Config   => $TransitionData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't create
        if ( !$TransitionID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the Transition",
            );
        }

        # set entity sync state
        my $Success = $Self->{EntityObject}->EntitySyncStateSet(
            EntityType => 'Transition',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error setting the entity sync status for Transition "
                    . "entity:$EntityID",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $Self->{ParamObject}->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $TransitionConfig = $Self->_GetTransitionConfig(
            EntityID => $EntityID,
        );

        my $ConfigJSON = $Self->{LayoutObject}->JSONEncode( Data => $TransitionConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $TransitionID,
                EntityID  => $EntityID,
                Subaction => 'TransitionEdit'    # always use edit screen
            );

            my $RedirectAction
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectAction' ) || '';
            my $RedirectSubaction
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectSubaction' ) || '';
            my $RedirectID = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectID' ) || '';
            my $RedirectEntityID
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectEntityID' ) || '';

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
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need TransitionID!",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        # get Transition data
        my $TransitionData = $Self->{TransitionObject}->TransitionGet(
            ID     => $TransitionID,
            UserID => $Self->{UserID},
        );

        # check for valid Transition data
        if ( !IsHashRefWithData($TransitionData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
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
        $Self->{LayoutObject}->ChallengeTokenCheck();

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
        my $Success = $Self->{TransitionObject}->TransitionUpdate(
            ID       => $TransitionID,
            EntityID => $EntityID,
            Name     => $TransitionData->{Name},
            Config   => $TransitionData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't update
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error updating the Transition",
            );
        }

        # set entity sync state
        $Success = $Self->{EntityObject}->EntitySyncStateSet(
            EntityType => 'Transition',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error setting the entity sync status for Transition "
                    . "entity:$TransitionData->{EntityID}",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $Self->{ParamObject}->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $TransitionConfig = $Self->_GetTransitionConfig(
            EntityID => $TransitionData->{EntityID},
        );

        my $ConfigJSON = $Self->{LayoutObject}->JSONEncode( Data => $TransitionConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $TransitionID,
                EntityID  => $TransitionData->{EntityID},
                Subaction => 'TransitionEdit'               # always use edit screen
            );

            my $RedirectAction
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectAction' ) || '';
            my $RedirectSubaction
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectSubaction' ) || '';
            my $RedirectID = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectID' ) || '';
            my $RedirectEntityID
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectEntityID' ) || '';

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
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "This subaction is not valid",
        );
    }
}

sub _GetTransitionConfig {
    my ( $Self, %Param ) = @_;

    # Get new Transition Config as JSON
    my $ProcessDump = $Self->{ProcessObject}->ProcessDump(
        ResultType => 'HASH',
        UserID     => $Self->{UserID},
    );

    my %TransitionConfig;
    $TransitionConfig{Transition} = ();
    $TransitionConfig{Transition}->{ $Param{EntityID} }
        = $ProcessDump->{Transition}->{ $Param{EntityID} };

    return \%TransitionConfig;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get Transition information
    my $TransitionData = $Param{TransitionData} || {};

    # check if last screen action is main screen
    if ( $Self->{ScreensPath}->[-1]->{Action} eq 'AdminProcessManagement' ) {

        # show close popup link
        $Self->{LayoutObject}->Block(
            Name => 'ClosePopup',
            Data => {},
        );
    }
    else {

        # show go back link
        $Self->{LayoutObject}->Block(
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

    my $Output = $Self->{LayoutObject}->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );

    $Param{FreshConditionLinking} = $Self->{LayoutObject}->BuildSelection(
        Data => [ 'and', 'or', 'xor' ],
        Name => "ConditionLinking[_INDEX_]",
        Sort => 'AlphanumericKey',
        Translation => 1,
        Class       => 'W50pc',
    );

    $Param{FreshConditionFieldType} = $Self->{LayoutObject}->BuildSelection(
        Data => {
            'String' => 'String',

# disable hash and array selection here, because there is no practical way to enter the needed data in the GUI
# TODO: implement a possibility to enter the data in a correct way in the GUI
#'Hash'   => 'Hash',
#'Array'  => 'Array',
            'Regexp' => 'Regexp',
            'Module' => 'Transition Validation Module'
        },
        SelectedID  => 'String',
        Name        => "ConditionFieldType[_INDEX_][_FIELDINDEX_]",
        Sort        => 'AlphanumericKey',
        Translation => 1,
    );

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {

        $Param{OverallConditionLinking} = $Self->{LayoutObject}->BuildSelection(
            Data => [ 'and', 'or', 'xor' ],
            Name => 'OverallConditionLinking',
            ID   => 'OverallConditionLinking',
            Sort => 'AlphanumericKey',
            Translation   => 1,
            Class         => 'W50pc',
            SelectedValue => $TransitionData->{Config}->{ConditionLinking},
        );

        my @Conditions = sort keys %{ $TransitionData->{Config}->{Condition} };

        for my $Condition (@Conditions) {

            my %ConditionData = %{ $TransitionData->{Config}->{Condition}->{$Condition} };

            my $ConditionLinking = $Self->{LayoutObject}->BuildSelection(
                Data => [ 'and', 'or', 'xor' ],
                Name => "ConditionLinking[$Condition]",
                Sort => 'AlphanumericKey',
                Translation   => 1,
                Class         => 'W50pc',
                SelectedValue => $ConditionData{ConditionLinking},
            );

            $Self->{LayoutObject}->Block(
                Name => 'ConditionItemEditRow',
                Data => {
                    ConditionLinking => $ConditionLinking,
                    Index            => $Condition,
                },
            );

            my @Fields = sort keys %{ $ConditionData{Fields} };
            for my $Field (@Fields) {

                my %FieldData          = %{ $ConditionData{Fields}->{$Field} };
                my $ConditionFieldType = $Self->{LayoutObject}->BuildSelection(
                    Data => {
                        'String' => 'String',

# disable hash and array selection here, because there is no practical way to enter the needed data in the GUI
# TODO: implement a possibility to enter the data in a correct way in the GUI
#'Hash'   => 'Hash',
#'Array'  => 'Array',
                        'Regexp' => 'Regexp',
                        'Module' => 'Transition Validation Module'
                    },
                    Name          => "ConditionFieldType[$Condition][$Field]",
                    Sort          => 'AlphanumericKey',
                    Translation   => 1,
                    SelectedValue => $FieldData{Type},
                );

                # show fields
                $Self->{LayoutObject}->Block(
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

            $Self->{LayoutObject}->Block(
                Name => 'EditWarning',
                Data => {
                    ProcessList => join( ', ', @{$AffectedProcesses} ),
                    }
            );
        }
    }
    else {

        $Param{OverallConditionLinking} = $Self->{LayoutObject}->BuildSelection(
            Data => [ 'and', 'or', 'xor' ],
            Name => 'OverallConditionLinking',
            ID   => 'OverallConditionLinking',
            Sort => 'AlphanumericKey',
            Translation => 1,
            Class       => 'W50pc',
        );

        $Param{ConditionLinking} = $Self->{LayoutObject}->BuildSelection(
            Data => [ 'and', 'or', 'xor' ],
            Name => 'ConditionLinking[_INDEX_]',
            Sort => 'AlphanumericKey',
            Translation => 1,
            Class       => 'W50pc',
        );

        $Param{ConditionFieldType} = $Self->{LayoutObject}->BuildSelection(
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

        $Self->{LayoutObject}->Block(
            Name => 'ConditionItemInitRow',
            Data => {
                %Param,
            },
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementTransition",
        Data         => {
            %Param,
            %{$TransitionData},
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    # get parameters from web browser
    $GetParam->{Name} = $Self->{ParamObject}->GetParam( Param => 'Name' ) || '';
    $GetParam->{ConditionConfig} = $Self->{ParamObject}->GetParam( Param => 'ConditionConfig' )
        || '';

    my $Config = $Self->{JSONObject}->Decode(
        Data => $GetParam->{ConditionConfig}
    );
    $GetParam->{Config} = {};
    $GetParam->{Config}->{Condition} = $Config;
    $GetParam->{Config}->{ConditionLinking}
        = $Self->{ParamObject}->GetParam( Param => 'OverallConditionLinking' ) || '';

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
    my $JSONScreensPath = $Self->{LayoutObject}->JSONEncode(
        Data => $Self->{ScreensPath},
    );

    # update session
    $Self->{SessionObject}->UpdateSessionID(
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
    my $JSONScreensPath = $Self->{LayoutObject}->JSONEncode(
        Data => $Self->{ScreensPath},
    );

    # update session
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'ProcessManagementScreensPath',
        Value     => $JSONScreensPath,
    );

    return 1;
}

sub _PopupResponse {
    my ( $Self, %Param ) = @_;

    if ( $Param{Redirect} && $Param{Redirect} eq 1 ) {
        $Self->{LayoutObject}->Block(
            Name => 'Redirect',
            Data => {
                ConfigJSON => $Param{ConfigJSON},
                %{ $Param{Screen} },
            },
        );
    }
    elsif ( $Param{ClosePopup} && $Param{ClosePopup} eq 1 ) {
        $Self->{LayoutObject}->Block(
            Name => 'ClosePopup',
            Data => {
                ConfigJSON => $Param{ConfigJSON},
            },
        );
    }

    my $Output = $Self->{LayoutObject}->Header( Type => 'Small' );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementPopupResponse",
        Data         => {},
    );
    $Output .= $Self->{LayoutObject}->Footer( Type => 'Small' );

    return $Output;
}

sub _CheckTransitionUsage {
    my ( $Self, %Param ) = @_;

    # get a list of parents with all the details
    my $List = $Self->{ProcessObject}->ProcessListGet(
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
