# --
# Kernel/Modules/AdminProcessManagementPath.pm - process management path
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagementPath;

use strict;
use warnings;

use List::Util qw(first);

use Kernel::System::JSON;
use Kernel::System::ProcessManagement::DB::Process;
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Transition;
use Kernel::System::ProcessManagement::DB::TransitionAction;

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
    $Self->{JSONObject}       = Kernel::System::JSON->new( %{$Self} );
    $Self->{ProcessObject}    = Kernel::System::ProcessManagement::DB::Process->new( %{$Self} );
    $Self->{EntityObject}     = Kernel::System::ProcessManagement::DB::Entity->new( %{$Self} );
    $Self->{TransitionObject} = Kernel::System::ProcessManagement::DB::Transition->new( %{$Self} );
    $Self->{TransitionActionObject}
        = Kernel::System::ProcessManagement::DB::TransitionAction->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || '';

    my %SessionData = $Self->{SessionObject}->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );

    # convert JSON string to array
    $Self->{ScreensPath} = $Self->{JSONObject}->Decode(
        Data => $SessionData{ProcessManagementScreensPath}
    );

    # get available transitions
    $Self->{TransitionList}
        = $Self->{TransitionObject}->TransitionListGet( UserID => $Self->{UserID} );

    # get available transition actions
    $Self->{TransitionActionList}
        = $Self->{TransitionActionObject}->TransitionActionListGet( UserID => $Self->{UserID} );

    # ------------------------------------------------------------ #
    # PathEdit
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'PathEdit' ) {

        # get path data
        my $PathData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        $PathData->{ProcessEntityID}    = $GetParam->{ProcessEntityID}    || $GetParam->{ID};
        $PathData->{TransitionEntityID} = $GetParam->{TransitionEntityID} || $GetParam->{EntityID};
        $PathData->{StartActivityID}    = $GetParam->{StartActivityID};

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        return $Self->_ShowEdit(
            %Param,
            %{$PathData},
            Action => 'Edit',
        );
    }

    # ------------------------------------------------------------ #
    # PathEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'PathEditAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $TransferData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # merge changed data into process config
        $TransferData->{ProcessEntityID}    = $GetParam->{ProcessEntityID};
        $TransferData->{TransitionEntityID} = $GetParam->{TransitionEntityID};
        $TransferData->{ProcessData}        = $GetParam->{ProcessData};
        $TransferData->{TransitionInfo}     = $GetParam->{TransitionInfo};

        for my $Needed (qw(ProcessEntityID TransitionEntityID ProcessData TransitionInfo)) {

            # show error if can't update
            if ( !$TransferData->{$Needed} ) {

                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Need $Needed!",
                );
            }
        }

        my $ProcessData = $Self->{JSONObject}->Decode( Data => $TransferData->{ProcessData} );
        my $DataToMerge = $Self->{JSONObject}->Decode( Data => $TransferData->{TransitionInfo} );

        # delete the "old" transition key from path hash
        delete $ProcessData->{ $TransferData->{ProcessEntityID} }->{Path}
            ->{ $DataToMerge->{StartActivityEntityID} }->{ $TransferData->{TransitionEntityID} };

        # insert the "new" transition entry into path hash
        $ProcessData->{ $TransferData->{ProcessEntityID} }->{Path}
            ->{ $DataToMerge->{StartActivityEntityID} }->{ $DataToMerge->{NewTransitionEntityID} }
            = {
            TransitionAction => $DataToMerge->{NewTransitionActions},
            ActivityEntityID => $DataToMerge->{NewTransitionActivityID},
            };

        my $ReturnConfig;
        $ReturnConfig->{Process} = $ProcessData;

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $Self->{ParamObject}->GetParam( Param => 'PopupRedirect' ) || '';

        my $ConfigJSON = $Self->{LayoutObject}->JSONEncode( Data => $ReturnConfig );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            my $RedirectAction
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectAction' ) || '';
            my $RedirectSubaction
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectSubaction' ) || '';
            my $RedirectID = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectID' ) || '';
            my $RedirectEntityID
                = $Self->{ParamObject}->GetParam( Param => 'PopupRedirectEntityID' ) || '';

            # when redirecting to the transition dialog, we need the new TransitionID
            # because the ID was possibly changed in this dialog
            # the value is stored in data-entity
            # when redirecting to the transition action dialog, data-entity contains
            # the transition action ID, but still we need the transition ID for going back

            my $EntityID;

            if ( $RedirectSubaction eq 'TransitionActionEdit' ) {
                $EntityID = $TransferData->{TransitionEntityID};
            }
            elsif ( $RedirectSubaction eq 'TransitionEdit' ) {
                $EntityID = $RedirectEntityID;
            }

            $Self->_PushSessionScreen(
                ID              => $TransferData->{ProcessEntityID},    # abuse!
                EntityID        => $EntityID,
                StartActivityID => $GetParam->{StartActivityID},
                Subaction       => 'PathEdit'                           # always use edit screen
            );

            # get transition id
            if ( $RedirectAction eq 'AdminProcessManagementTransition' && !$RedirectID ) {
                my $Transition = $Self->{TransitionObject}->TransitionGet(
                    EntityID => $RedirectEntityID,
                    UserID   => $Self->{UserID},
                );
                $RedirectID = $Transition->{ID};
            }

            # redirect to another popup window
            return $Self->_PopupResponse(
                Redirect => 1,
                Screen   => {
                    Action    => $RedirectAction,
                    Subaction => $RedirectSubaction,
                    ID        => $RedirectID,
                    EntityID  => $RedirectEntityID,
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

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

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
                Action    => $Self->{ScreensPath}->[-1]->{Action}    || '',
                Subaction => $Self->{ScreensPath}->[-1]->{Subaction} || '',
                ID        => $Self->{ScreensPath}->[-1]->{ID}        || '',
                EntityID  => $Self->{ScreensPath}->[-1]->{EntityID}  || '',
            },
        );
    }

    # localize available activity dialogs
    my @AvailableTransitionActions = @{ $Self->{TransitionActionList} };

    # create available transition actions lookup tables based on entity id
    my %AvailableTransitionActionsLookup;

    TRANSITIONACTION:
    for my $TransitionActionConfig (@AvailableTransitionActions) {
        next TRANSITIONACTION if !$TransitionActionConfig;
        next TRANSITIONACTION if !$TransitionActionConfig->{EntityID};

        $AvailableTransitionActionsLookup{ $TransitionActionConfig->{EntityID} }
            = $TransitionActionConfig;
    }

    # collect possible transitions and build selection
    my %TransitionList;
    for my $Transition ( @{ $Self->{TransitionList} } ) {
        $TransitionList{ $Transition->{EntityID} } = $Transition->{Name};
    }

    $Param{Transition} = $Self->{LayoutObject}->BuildSelection(
        Data        => \%TransitionList,
        Name        => "Transition",
        ID          => "Transition",
        Sort        => 'AlphanumericKey',
        Translation => 1,
        Class       => 'W50pc',
    );

    # display available transition actions
    for my $EntityID ( sort keys %AvailableTransitionActionsLookup ) {

        my $TransitionActionData = $AvailableTransitionActionsLookup{$EntityID};

        $Self->{LayoutObject}->Block(
            Name => 'AvailableTransitionActionRow',
            Data => {
                ID       => $TransitionActionData->{ID},
                EntityID => $TransitionActionData->{EntityID},
                Name     => $TransitionActionData->{Name},
            },
        );
    }
    $Param{Title} = "Edit Path";

    my $Output = $Self->{LayoutObject}->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementPath",
        Data         => {
            %Param,
        },
    );

    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _GetParams {
    my ( $Self, %Param ) = @_;

    my $GetParam;

    # get parameters from web browser
    for my $ParamName (
        qw( ID EntityID ProcessData TransitionInfo ProcessEntityID StartActivityID TransitionEntityID )
        )
    {
        $GetParam->{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
    }

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
        Subaction       => $Param{Subaction},
        ID              => $Param{ID},
        EntityID        => $Param{EntityID},
        StartActivityID => $Param{StartActivityID},
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
1;
