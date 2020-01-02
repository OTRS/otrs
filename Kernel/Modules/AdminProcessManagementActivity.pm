# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AdminProcessManagementActivity;

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

    my $ActivityID = $ParamObject->GetParam( Param => 'ID' )       || '';
    my $EntityID   = $ParamObject->GetParam( Param => 'EntityID' ) || '';

    my %SessionData = $Kernel::OM->Get('Kernel::System::AuthSession')->GetSessionIDData(
        SessionID => $Self->{SessionID},
    );

    # convert JSON string to array
    $Self->{ScreensPath} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
        Data => $SessionData{ProcessManagementScreensPath}
    );

    # get needed objects
    my $LayoutObject        = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $EntityObject        = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Entity');
    my $ActivityObject      = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
    my $ActivityDialogsList = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog')
        ->ActivityDialogListGet( UserID => $Self->{UserID} );

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
        $LayoutObject->ChallengeTokenCheck();

        # get activity data
        my $ActivityData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new configuration
        $ActivityData->{Name}   = $GetParam->{Name};
        $ActivityData->{Config} = {};

        # set the rest of the config
        if ( IsArrayRefWithData( $GetParam->{ActivityDialogs} ) ) {

            # create available activity dialogs lookup tables based on DB id
            my %ActivityDialogsLookup;

            ACTIVITYDDIALOG:
            for my $ActivityDialogConfig ( @{$ActivityDialogsList} ) {
                next ACTIVITYDDIALOG if !$ActivityDialogConfig;
                next ACTIVITYDDIALOG if !$ActivityDialogConfig->{ID};

                $ActivityDialogsLookup{ $ActivityDialogConfig->{ID} } = $ActivityDialogConfig;
            }

            my %ConfigActivityDialog;

            # set activity dialogs in config
            my $Counter = 1;
            for my $ActivityDialogID ( @{ $GetParam->{ActivityDialogs} } ) {

                # check if the activity dialog and its entity id are in the list
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
            $Error{NameServerErrorMessage} = Translatable('This field is required');
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
        my $EntityID = $EntityObject->EntityIDGenerate(
            EntityType => 'Activity',
            UserID     => $Self->{UserID},
        );

        # show error if can't generate a new EntityID
        if ( !$EntityID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('There was an error generating a new EntityID for this Activity'),
            );
        }

        # otherwise save configuration and return process screen
        my $ActivityID = $ActivityObject->ActivityAdd(
            Name     => $ActivityData->{Name},
            EntityID => $EntityID,
            Config   => $ActivityData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't create
        if ( !$ActivityID ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('There was an error creating the Activity'),
            );
        }

        # set entity sync state
        my $Success = $EntityObject->EntitySyncStateSet(
            EntityType => 'Activity',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'There was an error setting the entity sync status for Activity entity: %s',
                    $EntityID
                ),
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $ParamObject->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $ActivityConfig = $Self->_GetActivityConfig(
            EntityID => $EntityID,
        );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $ActivityID,
                EntityID  => $ActivityData->{EntityID},
                Subaction => 'ActivityEdit'               # always use edit screen
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
                ConfigJSON => $ActivityConfig,
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
                    ConfigJSON => $ActivityConfig,
                );
            }
            else {

                # redirect to last screen
                return $Self->_PopupResponse(
                    Redirect   => 1,
                    Screen     => $LastScreen,
                    ConfigJSON => $ActivityConfig,
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
            return $LayoutObject->ErrorScreen(
                Message => Translatable('Need ActivityID!'),
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        # get Activity data
        my $ActivityData = $ActivityObject->ActivityGet(
            ID     => $ActivityID,
            UserID => $Self->{UserID},
        );

        # check for valid Activity data
        if ( !IsHashRefWithData($ActivityData) ) {
            return $LayoutObject->ErrorScreen(
                Message =>
                    $LayoutObject->{LanguageObject}->Translate( 'Could not get data for ActivityID %s', $ActivityID ),
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
        $LayoutObject->ChallengeTokenCheck();

        # get Activity Data
        my $ActivityData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams();

        # set new configuration
        $ActivityData->{Name}     = $GetParam->{Name};
        $ActivityData->{EntityID} = $GetParam->{EntityID};
        $ActivityData->{Config}   = {};

        # set the rest of the config
        if ( IsArrayRefWithData( $GetParam->{ActivityDialogs} ) ) {

            # create available activity dialogs lookup tables based on DB id
            my %ActivityDialogsLookup;

            ACTIVITYDDIALOG:
            for my $ActivityDialogConfig ( @{$ActivityDialogsList} ) {
                next ACTIVITYDDIALOG if !$ActivityDialogConfig;
                next ACTIVITYDDIALOG if !$ActivityDialogConfig->{ID};

                $ActivityDialogsLookup{ $ActivityDialogConfig->{ID} } = $ActivityDialogConfig;
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
            $Error{NameServerErrorMessage} = Translatable('This field is required');
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
        my $Success = $ActivityObject->ActivityUpdate(
            ID       => $ActivityID,
            Name     => $ActivityData->{Name},
            EntityID => $ActivityData->{EntityID},
            Config   => $ActivityData->{Config},
            UserID   => $Self->{UserID},
        );

        # show error if can't update
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => Translatable('There was an error updating the Activity'),
            );
        }

        # set entity sync state
        $Success = $EntityObject->EntitySyncStateSet(
            EntityType => 'Activity',
            EntityID   => $ActivityData->{EntityID},
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate(
                    'There was an error setting the entity sync status for Activity entity: %s',
                    $ActivityData->{EntityID}
                ),
            );
        }

        # remove this screen from session screen path
        $Self->_PopSessionScreen( OnlyCurrent => 1 );

        my $Redirect = $ParamObject->GetParam( Param => 'PopupRedirect' ) || '';

        # get latest config data to send it back to main window
        my $ActivityConfig = $Self->_GetActivityConfig(
            EntityID => $ActivityData->{EntityID},
        );

        # check if needed to open another window or if popup should go back
        if ( $Redirect && $Redirect eq '1' ) {

            $Self->_PushSessionScreen(
                ID        => $ActivityID,
                EntityID  => $ActivityData->{EntityID},
                Subaction => 'ActivityEdit'               # always use edit screen
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
                ConfigJSON => $ActivityConfig,
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
                    ConfigJSON => $ActivityConfig,
                );
            }
            else {

                # redirect to last screen
                return $Self->_PopupResponse(
                    Redirect   => 1,
                    Screen     => $LastScreen,
                    ConfigJSON => $ActivityConfig,
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

        $Param{EntityID}       = $ParamObject->GetParam( Param => 'EntityID' )       || '';
        $Param{ActivityDialog} = $ParamObject->GetParam( Param => 'ActivityDialog' ) || '';

        # check for Parameters
        if ( !$Param{EntityID} || !$Param{ActivityDialog} ) {
            %Result = (
                Success => 0,
                Message => Translatable('Missing Parameter: Need Activity and ActivityDialog!'),
            );

            $JSON = $LayoutObject->JSONEncode( Data => \%Result );

            return $LayoutObject->Attachment(
                ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
                Content     => $JSON,
                Type        => 'inline',
                NoCache     => 1,
            );
        }

        # get Activity data
        my $ActivityData = $ActivityObject->ActivityGet(
            EntityID => $Param{EntityID},
            UserID   => $Self->{UserID},
        );

        # check for valid Activity data
        if ( !IsHashRefWithData($ActivityData) ) {
            %Result = (
                Success => 0,
                Message => Translatable('Activity not found!'),
            );

            $JSON = $LayoutObject->JSONEncode( Data => \%Result );

            return $LayoutObject->Attachment(
                ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
                Content     => $JSON,
                Type        => 'inline',
                NoCache     => 1,
            );
        }

        # create available activity dialogs lookup tables based on DB id
        my %ActivityDialogsLookup;

        ACTIVITYDDIALOG:
        for my $ActivityDialogConfig ( @{$ActivityDialogsList} ) {
            next ACTIVITYDDIALOG if !$ActivityDialogConfig;
            next ACTIVITYDDIALOG if !$ActivityDialogConfig->{EntityID};

            $ActivityDialogsLookup{ $ActivityDialogConfig->{EntityID} } = $ActivityDialogConfig;
        }

        if ( !$ActivityDialogsLookup{ $Param{ActivityDialog} } ) {
            %Result = (
                Success => 0,
                Message => Translatable('ActivityDialog not found!'),
            );

            $JSON = $LayoutObject->JSONEncode( Data => \%Result );

            return $LayoutObject->Attachment(
                ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
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
                    Message => $LayoutObject->{LanguageObject}->Translate(
                        'ActivityDialog already assigned to Activity. You cannot add an ActivityDialog twice!'
                    ),
                );

                $JSON = $LayoutObject->JSONEncode( Data => \%Result );

                return $LayoutObject->Attachment(
                    ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
                    Content     => $JSON,
                    Type        => 'inline',
                    NoCache     => 1,
                );
            }

        }

        # Add ActivityDialog to Dialog
        my @Keys   = sort { $a <=> $b } keys %{ $ActivityData->{Config}->{ActivityDialog} };
        my $NewKey = 1;
        if (@Keys) {
            my $LastKey = pop @Keys;
            $NewKey = $LastKey + 1;
        }

        $ActivityData->{Config}->{ActivityDialog}->{$NewKey} = $Param{ActivityDialog};

        # Save Activity to DB
        my $Success = $ActivityObject->ActivityUpdate(
            ID       => $ActivityData->{ID},
            Name     => $ActivityData->{Name},
            EntityID => $ActivityData->{EntityID},
            Config   => $ActivityData->{Config},
            UserID   => $Self->{UserID},
        );

        if ( !$Success ) {
            %Result = (
                Success => 0,
                Message => Translatable('Error while saving the Activity to the database!'),
            );

            $JSON = $LayoutObject->JSONEncode( Data => \%Result );

            return $LayoutObject->Attachment(
                ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
                Content     => $JSON,
                Type        => 'inline',
                NoCache     => 1,
            );
        }

        my $ActivityConfig = $Self->_GetActivityConfig(
            EntityID => $Param{EntityID},
        );

        %Result = (
            Success        => 1,
            Activity       => $Param{EntityID},
            ActivityConfig => $ActivityConfig,
        );

        $JSON = $LayoutObject->JSONEncode( Data => \%Result );

        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
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

sub _GetActivityConfig {
    my ( $Self, %Param ) = @_;

    # Get new Activity Config as JSON
    my $ProcessDump = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessDump(
        ResultType => 'HASH',
        UserID     => $Self->{UserID},
    );

    my %ActivityConfig;
    $ActivityConfig{Activity} = ();
    $ActivityConfig{Activity}->{ $Param{EntityID} } = $ProcessDump->{Activity}->{ $Param{EntityID} };

    return \%ActivityConfig;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get Activity information
    my $ActivityData = $Param{ActivityData} || {};

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
    my @AvailableActivityDialogs = @{ $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog')
            ->ActivityDialogListGet( UserID => $Self->{UserID} ) };

    # create available activity dialogs lookup tables based on entity id
    my %AvailableActivityDialogsLookup;

    ACTIVITYDDIALOG:
    for my $ActivityDialogConfig (@AvailableActivityDialogs) {
        next ACTIVITYDDIALOG if !$ActivityDialogConfig;
        next ACTIVITYDDIALOG if !$ActivityDialogConfig->{EntityID};

        $AvailableActivityDialogsLookup{ $ActivityDialogConfig->{EntityID} } = $ActivityDialogConfig;
    }

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {

        # get used activity dialogs in activity
        my %AssignedActivityDialogs;

        if ( IsHashRefWithData( $ActivityData->{Config}->{ActivityDialog} ) ) {
            ACTIVITYDIALOG:
            for my $Order ( sort keys %{ $ActivityData->{Config}->{ActivityDialog} } ) {
                next ACTIVITYDIALOG if !$Order;
                my $EntityID = $ActivityData->{Config}->{ActivityDialog}->{$Order};
                next ACTIVITYDIALOG if !$ActivityData->{Config}->{ActivityDialog}->{$Order};

                $AssignedActivityDialogs{$EntityID} = $AvailableActivityDialogsLookup{$EntityID};
            }
        }

        # remove used activity dialogs from available list
        for my $EntityID ( sort keys %AssignedActivityDialogs ) {
            delete $AvailableActivityDialogsLookup{$EntityID};
        }

        # display available activity dialogs
        for my $EntityID ( sort keys %AvailableActivityDialogsLookup ) {

            my $ActivityDialogData = $AvailableActivityDialogsLookup{$EntityID};

            my $AvailableIn       = '';
            my $ConfigAvailableIn = $ActivityDialogData->{Config}->{Interface};

            if ( defined $ConfigAvailableIn ) {
                my $InterfaceLength = scalar @{$ConfigAvailableIn};
                if ( $InterfaceLength == 2 ) {
                    $AvailableIn = 'A, C';
                }
                elsif ( $InterfaceLength == 1 ) {
                    $AvailableIn = substr( $ConfigAvailableIn->[0], 0, 1 );
                }
                else {
                    $AvailableIn = 'A';
                }
            }
            else {
                $AvailableIn = 'A';
            }

            $LayoutObject->Block(
                Name => 'AvailableActivityDialogRow',
                Data => {
                    ID          => $ActivityDialogData->{ID},
                    EntityID    => $ActivityDialogData->{EntityID},
                    Name        => $ActivityDialogData->{Name},
                    AvailableIn => $AvailableIn,
                },
            );
        }

        # display used activity dialogs
        for my $Order ( sort { $a <=> $b } keys %{ $ActivityData->{Config}->{ActivityDialog} } ) {

            my $ActivityDialogData = $AssignedActivityDialogs{ $ActivityData->{Config}->{ActivityDialog}->{$Order} };

            my $AvailableIn       = '';
            my $ConfigAvailableIn = $ActivityDialogData->{Config}->{Interface};

            if ( defined $ConfigAvailableIn ) {
                my $InterfaceLength = scalar @{$ConfigAvailableIn};
                if ( $InterfaceLength == 2 ) {
                    $AvailableIn = 'A, C';
                }
                elsif ( $InterfaceLength == 1 ) {
                    $AvailableIn = substr( $ConfigAvailableIn->[0], 0, 1 );
                }
                else {
                    $AvailableIn = 'A';
                }
            }
            else {
                $AvailableIn = 'A';
            }

            $LayoutObject->Block(
                Name => 'AssignedActivityDialogRow',
                Data => {
                    ID          => $ActivityDialogData->{ID},
                    EntityID    => $ActivityDialogData->{EntityID},
                    Name        => $ActivityDialogData->{Name},
                    AvailableIn => $AvailableIn,
                },
            );
        }

        # display other affected processes by editing this activity (if applicable)
        my $AffectedProcesses = $Self->_CheckActivityUsage(
            EntityID => $ActivityData->{EntityID},
        );

        if ( @{$AffectedProcesses} ) {

            $LayoutObject->Block(
                Name => 'EditWarning',
                Data => {
                    ProcessList => join( ', ', @{$AffectedProcesses} ),
                }
            );
        }

        $Param{Title} = $LayoutObject->{LanguageObject}->Translate(
            'Edit Activity "%s"',
            $ActivityData->{Name}
        );
    }
    else {

        # display available activity dialogs
        for my $EntityID ( sort keys %AvailableActivityDialogsLookup ) {

            my $ActivityDialogData = $AvailableActivityDialogsLookup{$EntityID};

            my $AvailableIn       = '';
            my $ConfigAvailableIn = $ActivityDialogData->{Config}->{Interface};

            if ( defined $ConfigAvailableIn ) {
                my $InterfaceLength = scalar @{$ConfigAvailableIn};
                if ( $InterfaceLength == 2 ) {
                    $AvailableIn = 'A, C';
                }
                elsif ( $InterfaceLength == 1 ) {
                    $AvailableIn = substr( $ConfigAvailableIn->[0], 0, 1 );
                }
                else {
                    $AvailableIn = 'A';
                }
            }
            else {
                $AvailableIn = 'A';
            }

            $LayoutObject->Block(
                Name => 'AvailableActivityDialogRow',
                Data => {
                    ID          => $ActivityDialogData->{ID},
                    EntityID    => $ActivityDialogData->{EntityID},
                    Name        => $ActivityDialogData->{Name},
                    AvailableIn => $AvailableIn,
                },
            );
        }

        $Param{Title} = Translatable('Create New Activity');
    }

    my $Output = $LayoutObject->Header(
        Value => $Param{Title},
        Type  => 'Small',
    );
    $Output .= $LayoutObject->Output(
        TemplateFile => "AdminProcessManagementActivity",
        Data         => {
            %Param,
            %{$ActivityData},
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
    for my $ParamName (
        qw( Name EntityID )
        )
    {
        $GetParam->{$ParamName} = $ParamObject->GetParam( Param => $ParamName ) || '';
    }

    my $ActivityDialogs = $ParamObject->GetParam( Param => 'ActivityDialogs' ) || '';

    if ($ActivityDialogs) {
        $GetParam->{ActivityDialogs} = $Kernel::OM->Get('Kernel::System::JSON')->Decode(
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
        Action    => $Self->{Action} || '',
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

sub _CheckActivityUsage {
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
        next PARENT if !$ParentData->{Activities};

        ENTITY:
        for my $EntityID ( @{ $ParentData->{Activities} } ) {
            if ( $EntityID eq $Param{EntityID} ) {
                push @Usage, $ParentData->{Name};
                last ENTITY;
            }
        }
    }

    return \@Usage;
}

1;
