# --
# Kernel/Modules/AdminProcessManagementActivity.pm - process management activity
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AdminProcessManagementActivity.pm,v 1.10 2012-07-27 10:00:44 mn Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagementActivity;

use strict;
use warnings;

use List::Util qw(first);

use Kernel::System::JSON;
use Kernel::System::ProcessManagement::DB::Process;
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Activity;
use Kernel::System::ProcessManagement::DB::ActivityDialog;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.10 $) [1];

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
    $Self->{ActivityDialogObject}
        = Kernel::System::ProcessManagement::DB::ActivityDialog->new( %{$Self} );

    # get available activity dialogs
    $Self->{ActivityDialogsList}
        = $Self->{ActivityDialogObject}->ActivityDialogListGet( UserID => $Self->{UserID} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || '';

    my $ActivityID = $Self->{ParamObject}->GetParam( Param => 'ID' )       || '';
    my $EntityID   = $Self->{ParamObject}->GetParam( Param => 'EntityID' ) || '';

    my %SessionData = $Self->{SessionObject}->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );

    # convert JSON string to array
    $Self->{ScreensPath} = $Self->{JSONObject}->Decode(
        Data => $SessionData{ProcessManagementScreensPath}
    );

    # ------------------------------------------------------------ #
    # ActivityNew
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ActivityNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # ActivityNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ActivityNewAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get activity data
        my $ActivityData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams;

        # set new confguration
        $ActivityData->{Name}   = $GetParam->{Name};
        $ActivityData->{Config} = {};

        # set the rest of the config
        if ( IsArrayRefWithData( $GetParam->{ActivityDialogs} ) ) {

            # create available activity dialogs lookup tables based on DB id
            my %ActivityDialogsLookup;

            ACTIVITYDDIALOG:
            for my $ActivityDialogConfig ( @{ $Self->{ActivityDialogsList} } ) {
                next ACTIVITYDDIALOG if !$ActivityDialogConfig;
                next ACTIVITYDDIALOG if !$ActivityDialogConfig->{ID};

                $ActivityDialogsLookup{ $ActivityDialogConfig->{ID} }
                    = $ActivityDialogConfig;
            }

            my %ConfigActivityDialog;

            # set activity dialogs in config
            my $Counter = 1;
            for my $ActivityDialogID ( @{ $GetParam->{ActivityDialogs} } ) {

                # check if the activiry dialog and it's entity id are in the list
                if (
                    $ActivityDialogsLookup{$ActivityDialogID}
                    && $ActivityDialogsLookup{$ActivityDialogID}->{EntityID}
                    )
                {
                    my $EntityID = $ActivityDialogsLookup{$ActivityDialogID}->{EntityID};

                    $ConfigActivityDialog{$Counter} = $EntityID;
                    $Counter++;
                }
            }

            # set the final config value
            $ActivityData->{Config}->{ActivityDialog} = \%ConfigActivityDialog;
        }

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
                ActivityData => $ActivityData,
                Action       => 'New',
            );
        }

        # generate entity ID
        my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
            EntityType => 'Activity',
            UserID     => $Self->{UserID},
        );

        # show error if can't generate a new EntityID
        if ( !$EntityID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error generating a new EntityID for this Activity",
            );
        }

        # otherwise save configuration and return process screen
        my $ActivityID = $Self->{ActivityObject}->ActivityAdd(
            Name     => $ActivityData->{Name},
            EntityID => $EntityID,
            Config   => $ActivityData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't create
        if ( !$ActivityID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the Activity",
            );
        }

        # set entitty sync state
        my $Success = $Self->{EntityObject}->EntitySyncStateSet(
            EntityType => 'Activity',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error setting the entity sync status for Activity "
                    . "entity:$EntityID",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $Self->{ParamObject}->GetParam( Param => 'PopupRedirect' ) || '';

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $ActivityID,
                EntityID  => $ActivityData->{EntityID},
                Subaction => 'ActivityEdit'               # always use edit screen
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
                );
            }
            else {

                # redirect to last screen
                return $Self->_PopupResponse(
                    Redirect => 1,
                    Screen   => $LastScreen
                );
            }
        }
    }

    # ------------------------------------------------------------ #
    # ActivityEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ActivityEdit' ) {

        # check for ActivityID
        if ( !$ActivityID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need ActivityID!",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        # get Activity data
        my $ActivityData = $Self->{ActivityObject}->ActivityGet(
            ID     => $ActivityID,
            UserID => $Self->{UserID},
        );

        # check for valid Activity data
        if ( !IsHashRefWithData($ActivityData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for ActivityID $ActivityID",
            );
        }

        return $Self->_ShowEdit(
            %Param,
            ActivityID   => $ActivityID,
            ActivityData => $ActivityData,
            Action       => 'Edit',
        );
    }

    # ------------------------------------------------------------ #
    # ActvityEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ActivityEditAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get Activity Data
        my $ActivityData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams;

        # set new confguration
        $ActivityData->{Name}     = $GetParam->{Name};
        $ActivityData->{EntityID} = $GetParam->{EntityID};
        $ActivityData->{Config}   = {};

        # set the rest of the config
        if ( IsArrayRefWithData( $GetParam->{ActivityDialogs} ) ) {

            # create available activity dialogs lookup tables based on DB id
            my %ActivityDialogsLookup;

            ACTIVITYDDIALOG:
            for my $ActivityDialogConfig ( @{ $Self->{ActivityDialogsList} } ) {
                next ACTIVITYDDIALOG if !$ActivityDialogConfig;
                next ACTIVITYDDIALOG if !$ActivityDialogConfig->{ID};

                $ActivityDialogsLookup{ $ActivityDialogConfig->{ID} }
                    = $ActivityDialogConfig;
            }

            my %ConfigActivityDialog;

            # set activity dialogs in config
            my $Counter = 1;
            for my $ActivityDialogID ( @{ $GetParam->{ActivityDialogs} } ) {

                # check if the activity dialog and it's entity id are in the list
                if (
                    $ActivityDialogsLookup{$ActivityDialogID}
                    && $ActivityDialogsLookup{$ActivityDialogID}->{EntityID}
                    )
                {
                    my $EntityID = $ActivityDialogsLookup{$ActivityDialogID}->{EntityID};

                    $ConfigActivityDialog{$Counter} = $EntityID;
                    $Counter++;
                }
            }

            # set the final config value
            $ActivityData->{Config}->{ActivityDialog} = \%ConfigActivityDialog;
        }

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
                ActivityData => $ActivityData,
                Action       => 'Edit',
            );
        }

        # otherwise save configuration and return to overview screen
        my $Success = $Self->{ActivityObject}->ActivityUpdate(
            ID       => $ActivityID,
            Name     => $ActivityData->{Name},
            EntityID => $ActivityData->{EntityID},
            Config   => $ActivityData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't update
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error updating the Activity",
            );
        }

        # set entitty sync state
        $Success = $Self->{EntityObject}->EntitySyncStateSet(
            EntityType => 'Activity',
            EntityID   => $ActivityData->{EntityID},
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error setting the entity sync status for Activity "
                    . "entity:$ActivityData->{EntityID}",
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $Self->{ParamObject}->GetParam( Param => 'PopupRedirect' ) || '';

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $ActivityID,
                EntityID  => $ActivityData->{EntityID},
                Subaction => 'ActivityEdit'               # always use edit screen
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
                );
            }
            else {

                # redirect to last screen
                return $Self->_PopupResponse(
                    Redirect => 1,
                    Screen   => $LastScreen
                );
            }
        }
    }

    # ------------------------------------------------------------ #
    # AddActivityDialog AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'AddActivityDialog' ) {

        my %Params;
        my %Result;
        my $JSON;

        $Param{EntityID}       = $Self->{ParamObject}->GetParam( Param => 'EntityID' )       || '';
        $Param{ActivityDialog} = $Self->{ParamObject}->GetParam( Param => 'ActivityDialog' ) || '';

        # check for Parameters
        if ( !$Param{EntityID} || !$Param{ActivityDialog} ) {
            %Result = (
                Success => 0,
                Message => "Missing Parameter: Need Activity and ActivityDialog!",
            );

            $JSON = $Self->{LayoutObject}->JSONEncode( Data => \%Result );

            return $Self->{LayoutObject}->Attachment(
                ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
                Content     => $JSON,
                Type        => 'inline',
                NoCache     => 1,
            );
        }

        # get Activity data
        my $ActivityData = $Self->{ActivityObject}->ActivityGet(
            EntityID => $Param{EntityID},
            UserID   => $Self->{UserID},
        );

        # check for valid Activity data
        if ( !IsHashRefWithData($ActivityData) ) {
            %Result = (
                Success => 0,
                Message => "Activity not found!",
            );

            $JSON = $Self->{LayoutObject}->JSONEncode( Data => \%Result );

            return $Self->{LayoutObject}->Attachment(
                ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
                Content     => $JSON,
                Type        => 'inline',
                NoCache     => 1,
            );
        }

        # create available activity dialogs lookup tables based on DB id
        my %ActivityDialogsLookup;

        ACTIVITYDDIALOG:
        for my $ActivityDialogConfig ( @{ $Self->{ActivityDialogsList} } ) {
            next ACTIVITYDDIALOG if !$ActivityDialogConfig;
            next ACTIVITYDDIALOG if !$ActivityDialogConfig->{EntityID};

            $ActivityDialogsLookup{ $ActivityDialogConfig->{EntityID} }
                = $ActivityDialogConfig;
        }

        if ( !$ActivityDialogsLookup{ $Param{ActivityDialog} } ) {
            %Result = (
                Success => 0,
                Message => "ActivityDialog not found!",
            );

            $JSON = $Self->{LayoutObject}->JSONEncode( Data => \%Result );

            return $Self->{LayoutObject}->Attachment(
                ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
                Content     => $JSON,
                Type        => 'inline',
                NoCache     => 1,
            );
        }

        # Check if ActivityDialog is already assigned to Activity
        if ( ref $ActivityData->{Config}->{ActivityDialog} eq 'HASH' ) {

            my $CheckActivityDialog = first { $_ eq $Param{ActivityDialog} }
            values %{ $ActivityData->{Config}->{ActivityDialog} };

            if ($CheckActivityDialog) {
                %Result = (
                    Success => 0,
                    Message =>
                        "ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!",
                );

                $JSON = $Self->{LayoutObject}->JSONEncode( Data => \%Result );

                return $Self->{LayoutObject}->Attachment(
                    ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
                    Content     => $JSON,
                    Type        => 'inline',
                    NoCache     => 1,
                );
            }

        }

        # Add ActivityDialog to Dialog
        my @Keys = sort { $a <=> $b } keys %{ $ActivityData->{Config}->{ActivityDialog} };
        my $NewKey = 1;
        if (@Keys) {
            my $LastKey = pop @Keys;
            $NewKey = $LastKey + 1;
        }

        $ActivityData->{Config}->{ActivityDialog}->{$NewKey} = $Param{ActivityDialog};

        # Save Activity to DB
        my $Success = $Self->{ActivityObject}->ActivityUpdate(
            ID       => $ActivityData->{ID},
            Name     => $ActivityData->{Name},
            EntityID => $ActivityData->{EntityID},
            Config   => $ActivityData->{Config},
            UserID   => $Self->{UserID},
        );

        if ( !$Success ) {
            %Result = (
                Success => 0,
                Message => "Error while saving the Activity to the database!",
            );

            $JSON = $Self->{LayoutObject}->JSONEncode( Data => \%Result );

            return $Self->{LayoutObject}->Attachment(
                ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
                Content     => $JSON,
                Type        => 'inline',
                NoCache     => 1,
            );
        }

        # Get new Activity Config as JSON
        my $ProcessDump = $Self->{ProcessObject}->ProcessDump(
            ResultType => 'HASH',
            UserID     => $Self->{UserID},
        );
        my $ActivityConfig = $ProcessDump->{Activity}->{ $Param{EntityID} };

        %Result = (
            Success        => 1,
            Activity       => $Param{EntityID},
            ActivityConfig => $ActivityConfig,
        );

        $JSON = $Self->{LayoutObject}->JSONEncode( Data => \%Result );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
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

    # get Activity information
    my $ActivityData = $Param{ActivityData} || {};

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
    my @AvailableActivityDialogs = @{ $Self->{ActivityDialogsList} };

    # create available activity dialogs lookup tables based on entity id
    my %AvailableActivityDialogsLookup;

    ACTIVITYDDIALOG:
    for my $ActivityDialogConfig (@AvailableActivityDialogs) {
        next ACTIVITYDDIALOG if !$ActivityDialogConfig;
        next ACTIVITYDDIALOG if !$ActivityDialogConfig->{EntityID};

        $AvailableActivityDialogsLookup{ $ActivityDialogConfig->{EntityID} }
            = $ActivityDialogConfig;
    }

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {

        # get used activity dialogs in activity
        my %AssignedActivityDialogs;

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

        # display available activity dialogs
        for my $EntityID ( sort keys %AvailableActivityDialogsLookup ) {

            my $ActivityDialogData = $AvailableActivityDialogsLookup{$EntityID};

            $Self->{LayoutObject}->Block(
                Name => 'AvailableActivityDialogRow',
                Data => {
                    ID       => $ActivityDialogData->{ID},
                    EntityID => $ActivityDialogData->{EntityID},
                    Name     => $ActivityDialogData->{Name},
                },
            );
        }

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

        $Param{Title} = "Edit Activity \"$ActivityData->{Name}\"";
    }
    else {

        # display available activity dialogs
        for my $EntityID ( sort keys %AvailableActivityDialogsLookup ) {

            my $ActivityDialogData = $AvailableActivityDialogsLookup{$EntityID};

            $Self->{LayoutObject}->Block(
                Name => 'AvailableActivityDialogRow',
                Data => {
                    ID       => $ActivityDialogData->{ID},
                    EntityID => $ActivityDialogData->{EntityID},
                    Name     => $ActivityDialogData->{Name},
                },
            );
        }

        $Param{Title} = 'Create New Activity';
    }

    my $Output = $Self->{LayoutObject}->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementActivity",
        Data         => {
            %Param,
            %{$ActivityData},
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
        qw( Name EntityID )
        )
    {
        $GetParam->{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
    }

    my $ActivityDialogs = $Self->{ParamObject}->GetParam( Param => 'ActivityDialogs' ) || '';

    if ($ActivityDialogs) {
        $GetParam->{ActivityDialogs} = $Self->{JSONObject}->Decode(
            Data => $ActivityDialogs,
        );
    }
    else {
        $GetParam->{ActivityDialogs} = '';
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
                %{ $Param{Screen} },
            },
        );
    }
    elsif ( $Param{ClosePopup} && $Param{ClosePopup} eq 1 ) {
        $Self->{LayoutObject}->Block(
            Name => 'ClosePopup',
            Data => {},
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
