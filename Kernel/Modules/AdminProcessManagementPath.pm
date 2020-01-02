# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminProcessManagementPath;

use strict;
use warnings;

use List::Util qw(first);

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

    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    $Self->{Subaction} = $ParamObject->GetParam( Param => 'Subaction' ) || '';

    my %SessionData = $Kernel::OM->Get('Kernel::System::AuthSession')->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );

    my $JSONObject = $Kernel::OM->Get('Kernel::System::JSON');

    # convert JSON string to array
    $Self->{ScreensPath} = $JSONObject->Decode(
        Data => $SessionData{ProcessManagementScreensPath}
    );

    my $TransitionObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');

    # get available transitions
    $Self->{TransitionList} = $TransitionObject->TransitionListGet( UserID => $Self->{UserID} );

    # get available transition actions
    $Self->{TransitionActionList} = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction')
        ->TransitionActionListGet( UserID => $Self->{UserID} );

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

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
        $LayoutObject->ChallengeTokenCheck();

        my $TransferData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # merge changed data into process config
        $TransferData->{ProcessEntityID}    = $GetParam->{ProcessEntityID};
        $TransferData->{TransitionEntityID} = $GetParam->{TransitionEntityID};
        $TransferData->{ProcessData}        = $GetParam->{ProcessData};
        $TransferData->{TransitionInfo}     = $GetParam->{TransitionInfo};

        for my $Needed (qw(ProcessEntityID TransitionEntityID ProcessData TransitionInfo)) {

            # Send needed data to JS.
            $LayoutObject->AddJSData(
                Key   => $Needed,
                Value => $TransferData->{$Needed}
            );

            # show error if can't update
            if ( !$TransferData->{$Needed} ) {

                return $LayoutObject->ErrorScreen(
                    Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s!', $Needed ),
                );
            }
        }

        my $ProcessData = $JSONObject->Decode( Data => $TransferData->{ProcessData} );
        my $DataToMerge = $JSONObject->Decode( Data => $TransferData->{TransitionInfo} );

        # delete the "old" transition key from path hash
        delete $ProcessData->{ $TransferData->{ProcessEntityID} }->{Path}
            ->{ $DataToMerge->{StartActivityEntityID} }->{ $TransferData->{TransitionEntityID} };

        # insert the "new" transition entry into path hash
        $ProcessData->{ $TransferData->{ProcessEntityID} }->{Path}
            ->{ $DataToMerge->{StartActivityEntityID} }->{ $DataToMerge->{NewTransitionEntityID} } = {
            TransitionAction => $DataToMerge->{NewTransitionActions},
            ActivityEntityID => $DataToMerge->{NewTransitionActivityID},
            };

        my $ReturnConfig;
        $ReturnConfig->{Process} = $ProcessData;

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $ParamObject->GetParam( Param => 'PopupRedirect' ) || '';

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            my $RedirectAction    = $ParamObject->GetParam( Param => 'PopupRedirectAction' )    || '';
            my $RedirectSubaction = $ParamObject->GetParam( Param => 'PopupRedirectSubaction' ) || '';
            my $RedirectID        = $ParamObject->GetParam( Param => 'PopupRedirectID' )        || '';
            my $RedirectEntityID  = $ParamObject->GetParam( Param => 'PopupRedirectEntityID' )  || '';

            # when redirecting to the transition dialog, we need the new TransitionID
            # because the ID was possibly changed in this dialog
            # the value is stored in data-entity
            # when redirecting to the transition action dialog, data-entity contains
            # the transition action ID, but still we need the transition ID for going back

            my $EntityID;

            if (
                $RedirectSubaction eq 'TransitionActionEdit'
                || $RedirectSubaction eq 'TransitionActionNew'
                )
            {
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
                my $Transition = $TransitionObject->TransitionGet(
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
                ConfigJSON => $ReturnConfig,
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
                    ConfigJSON => $ReturnConfig,
                );
            }
            else {

                # redirect to last screen
                return $Self->_PopupResponse(
                    Redirect   => 1,
                    Screen     => $LastScreen,
                    ConfigJSON => $ReturnConfig,
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
            ConfigJSON => '',
        );
    }

    # ------------------------------------------------------------ #
    # Error
    # ------------------------------------------------------------ #
    else {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('This subaction is not valid'),
        );
    }
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

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

        $AvailableTransitionActionsLookup{ $TransitionActionConfig->{EntityID} } = $TransitionActionConfig;
    }

    # collect possible transitions and build selection
    my %TransitionList;
    for my $Transition ( @{ $Self->{TransitionList} } ) {
        $TransitionList{ $Transition->{EntityID} } = $Transition->{Name};
    }

    # fix sorting by names
    my @TransitionList;
    for my $TransitionID (
        sort { lc $TransitionList{$a} cmp lc $TransitionList{$b} }
        keys %TransitionList
        )
    {
        push @TransitionList, {
            Key   => $TransitionID,
            Value => $TransitionList{$TransitionID},
        };
    }

    $Param{Transition} = $LayoutObject->BuildSelection(
        Data        => \@TransitionList,
        Name        => "Transition",
        ID          => "Transition",
        Title       => $LayoutObject->{LanguageObject}->Translate("Transition"),
        Translation => 1,
        Class       => 'W50pc',
    );

    # display available transition actions
    for my $EntityID ( sort keys %AvailableTransitionActionsLookup ) {

        my $TransitionActionData = $AvailableTransitionActionsLookup{$EntityID};

        $LayoutObject->Block(
            Name => 'AvailableTransitionActionRow',
            Data => {
                ID       => $TransitionActionData->{ID},
                EntityID => $TransitionActionData->{EntityID},
                Name     => $TransitionActionData->{Name},
            },
        );
    }
    $Param{Title} = Translatable('Edit Path');

    # send data to JS
    for my $AddJSData (qw(TransitionEntityID ProcessEntityID StartActivityID)) {
        $LayoutObject->AddJSData(
            Key   => $AddJSData,
            Value => $Param{$AddJSData}
        );
    }

    my $Output = $LayoutObject->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );
    $Output .= $LayoutObject->Output(
        TemplateFile => "AdminProcessManagementPath",
        Data         => {
            %Param,
        },
    );

    $Output .= $LayoutObject->Footer();

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
        $GetParam->{$ParamName} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => $ParamName )
            || '';
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
        Action          => $Self->{Action} || '',
        Subaction       => $Param{Subaction},
        ID              => $Param{ID},
        EntityID        => $Param{EntityID},
        StartActivityID => $Param{StartActivityID},
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

        # send data to JS
        $LayoutObject->AddJSData(
            Key   => 'Redirect',
            Value => {
                ConfigJSON => $Param{ConfigJSON},
                %{ $Param{Screen} },
            }
        );
    }
    elsif ( $Param{ClosePopup} && $Param{ClosePopup} eq 1 ) {

        # send data to JS
        $LayoutObject->AddJSData(
            Key   => 'ClosePopup',
            Value => {
                ConfigJSON => $Param{ConfigJSON},
            }
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

1;
