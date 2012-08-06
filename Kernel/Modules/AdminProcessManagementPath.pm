# --
# Kernel/Modules/AdminProcessManagementPath.pm - process management activity
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AdminProcessManagementPath.pm,v 1.1 2012-08-06 15:10:47 mab Exp $
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
use Kernel::System::ProcessManagement::DB::Activity;
use Kernel::System::ProcessManagement::DB::Transition;
use Kernel::System::ProcessManagement::DB::TransitionAction;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
    $Self->{ActivityObject}   = Kernel::System::ProcessManagement::DB::Activity->new( %{$Self} );
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
    # ActivityNew
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'PathNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # ActivityNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'PathNewAction' ) {

    }

    # ------------------------------------------------------------ #
    # ActivityEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'PathEdit' ) {

        # get path data
        my $PathData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams;

        $PathData->{ProcessEntityID}    = $GetParam->{ProcessEntityID};
        $PathData->{TransitionEntityID} = $GetParam->{TransitionEntityID};

        return $Self->_ShowEdit(
            %Param,
            %{$PathData},
            Action => 'Edit',
        );
    }

    # ------------------------------------------------------------ #
    # ActvityEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'PathEditAction' ) {

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

    # localize available actvity dialogs
    my @AvailableTransitionActions = @{ $Self->{TransitionActionList} };

    # create available activity dialogs lookup tables based on entity id
    my %AvailableTransitionActionsLookup;

    TRANSITIONACTION:
    for my $TransitionActionConfig (@AvailableTransitionActions) {
        next TRANSITIONACTION if !$TransitionActionConfig;
        next TRANSITIONACTION if !$TransitionActionConfig->{EntityID};

        $AvailableTransitionActionsLookup{ $TransitionActionConfig->{EntityID} }
            = $TransitionActionConfig;
    }

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {

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

        # get used activity dialogs in activity
        my %AssignedTransitionActions;

=cut
        if ( IsHashRefWithData( $ActivityData->{Config}->{ActivityDialog} ) ) {
            ACTIVITYDIALOG:
            for my $Order ( keys %{ $ActivityData->{Config}->{ActivityDialog} } ) {
                next ACTIVITYDIALOG if !$Order;
                my $EntityID = $ActivityData->{Config}->{ActivityDialog}->{$Order};
                next ACTIVITYDIALOG if !$ActivityData->{Config}->{ActivityDialog}->{$Order};

                $AssignedActivityDialogs{$EntityID} = $AvailableActivityDialogsLookup{$EntityID};
            }
        }

        # remove used activity dialogs from available list
        for my $EntityID ( keys %AssignedActivityDialogs ) {
            delete $AvailableActivityDialogsLookup{$EntityID};
        }
=cut

        # display available activity dialogs
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

=cut
        # display used activity dialogs
        for my $Order ( sort { $a <=> $b } keys %{ $ActivityData->{Config}->{ActivityDialog} } ) {

            my $ActivityDialogData
                = $AssignedActivityDialogs{ $ActivityData->{Config}->{ActivityDialog}->{$Order} };

            $Self->{LayoutObject}->Block(
                Name => 'AssignedActivityDialogRow',
                Data => {
                    ID       => $ActivityDialogData->{ID},
                    EntityID => $ActivityDialogData->{EntityID},
                    Name     => $ActivityDialogData->{Name},
                },
            );
        }
=cut

        $Param{Title} = "Edit Path";
    }
    else {

        $Param{Title} = 'Create New Path';
    }

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
    $GetParam->{ProcessEntityID} = $Self->{ParamObject}->GetParam( Param => 'ProcessEntityID' )
        || '';
    $GetParam->{TransitionEntityID}
        = $Self->{ParamObject}->GetParam( Param => 'TransitionEntityID' )
        || '';

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
1;
