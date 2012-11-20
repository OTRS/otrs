# --
# Kernel/Modules/AdminProcessManagement.pm - process management
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AdminProcessManagement.pm,v 1.41 2012-11-20 14:41:47 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AdminProcessManagement;

use strict;
use warnings;

use YAML;

use Kernel::System::JSON;
use Kernel::System::DynamicField;
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Activity;
use Kernel::System::ProcessManagement::DB::ActivityDialog;
use Kernel::System::ProcessManagement::DB::Process;
use Kernel::System::ProcessManagement::DB::Process::State;
use Kernel::System::ProcessManagement::DB::Transition;
use Kernel::System::ProcessManagement::DB::TransitionAction;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.41 $) [1];

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
    $Self->{JSONObject}         = Kernel::System::JSON->new( %{$Self} );
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new( %{$Self} );
    $Self->{ProcessObject}      = Kernel::System::ProcessManagement::DB::Process->new( %{$Self} );
    $Self->{EntityObject}       = Kernel::System::ProcessManagement::DB::Entity->new( %{$Self} );
    $Self->{ActivityObject}     = Kernel::System::ProcessManagement::DB::Activity->new( %{$Self} );

    $Self->{ActivityDialogObject}
        = Kernel::System::ProcessManagement::DB::ActivityDialog->new( %{$Self} );

    $Self->{StateObject} = Kernel::System::ProcessManagement::DB::Process::State->new( %{$Self} );

    $Self->{TransitionObject}
        = Kernel::System::ProcessManagement::DB::Transition->new( %{$Self} );

    $Self->{TransitionActionObject}
        = Kernel::System::ProcessManagement::DB::TransitionAction->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{Subaction} = $Self->{ParamObject}->GetParam( Param => 'Subaction' ) || '';

    my $ProcessID = $Self->{ParamObject}->GetParam( Param => 'ID' )       || '';
    my $EntityID  = $Self->{ParamObject}->GetParam( Param => 'EntityID' ) || '';

    # get the list of updated or deleted entities
    my $EntitySyncStateList = $Self->{EntityObject}->EntitySyncStateList(
        UserID => $Self->{UserID}
    );

    my $SynchronizeMessage
        = 'Process Management information from database is not in sync with the system configuration, please synchronize all processes.';

    if ( IsArrayRefWithData($EntitySyncStateList) ) {

        # create a notification if system is not up to date
        $Param{NotifyData} = [
            {
                Info => $SynchronizeMessage,
            },
        ];
    }

    # ------------------------------------------------------------ #
    # ProcessImport
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ProcessImport' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my $FormID = $Self->{ParamObject}->GetParam( Param => 'FormID' ) || '';
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'string',
        );

        my $ProcessData = YAML::Load( $UploadStuff{Content} );
        if ( ref $ProcessData ne 'HASH' ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message =>
                    "Couldn't read process configuration file. Please make sure you file is valid.",
            );
        }

        # collect all used fields and make sure they're present
        my @UsedDynamicFields;
        for my $ActivityDialog ( sort keys %{ $ProcessData->{ActivityDialogs} } ) {
            for my $FieldName (
                sort
                keys %{ $ProcessData->{ActivityDialogs}->{$ActivityDialog}->{Config}->{Fields} }
                )
            {
                if ( $FieldName =~ s{DynamicField_(\w+)}{$1}xms ) {
                    push @UsedDynamicFields, $FieldName;
                }
            }
        }

        # get all present dynamic fields and check if the fields used in the config are beyond them
        my $DynamicFieldList = $Self->{DynamicFieldObject}->DynamicFieldList(
            ResultType => 'HASH',
        );
        my @PresentDynamicFieldNames = values %{$DynamicFieldList};

        my @MissingDynamicFieldNames;
        for my $UsedDynamicFieldName (@UsedDynamicFields) {
            if ( !grep { $_ eq $UsedDynamicFieldName } @PresentDynamicFieldNames ) {
                push @MissingDynamicFieldNames, $UsedDynamicFieldName;
            }
        }

        if ( $#MissingDynamicFieldNames > -1 ) {
            my $MissingDynamicFields = join( ', ', @MissingDynamicFieldNames );
            return $Self->{LayoutObject}->ErrorScreen(
                Message =>
                    "The following dynamic fields are missing: $MissingDynamicFields. Import has been stopped.",
            );
        }

        # make sure all activities and dialogs are present
        my @UsedActivityDialogs;
        for my $ActivityEntityID ( @{ $ProcessData->{Process}->{Activities} } ) {
            if ( ref $ProcessData->{Activities}->{$ActivityEntityID} ne 'HASH' ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Missing data for Activity $ActivityEntityID.",
                );
            }
            else {
                for my $UsedActivityDialog (
                    @{ $ProcessData->{Activities}->{$ActivityEntityID}->{ActivityDialogs} }
                    )
                {
                    push @UsedActivityDialogs, $UsedActivityDialog;
                }
            }
        }

        for my $ActivityDialogEntityID (@UsedActivityDialogs) {
            if ( ref $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID} ne 'HASH' ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Missing data for ActivityDialog $ActivityDialogEntityID.",
                );
            }
        }

        # make sure all transitions are present
        for my $TransitionEntityID ( @{ $ProcessData->{Process}->{Transitions} } ) {
            if ( ref $ProcessData->{Transitions}->{$TransitionEntityID} ne 'HASH' ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Missing data for Transition $TransitionEntityID.",
                );
            }
        }

        # make sure all transition actions are present
        for my $TransitionActionEntityID ( @{ $ProcessData->{Process}->{TransitionActions} } ) {
            if ( ref $ProcessData->{TransitionActions}->{$TransitionActionEntityID} ne 'HASH' ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Missing data for TransitionAction $TransitionActionEntityID.",
                );
            }
        }

        # add activity dialogs
        my %ActivityDialogMapping;
        for my $ActivityDialogEntityID ( sort keys %{ $ProcessData->{ActivityDialogs} } ) {

            # get next EntityID
            my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
                EntityType => 'ActivityDialog',
                UserID     => $Self->{UserID},
            );

            my $ID = $Self->{ActivityDialogObject}->ActivityDialogAdd(
                EntityID => $EntityID,
                Name     => $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID}->{Name},
                Config   => $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID}->{Config},
                UserID   => $Self->{UserID},
            );

            if ( !$ID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "ActivityDialog '"
                        . $ProcessData->{ActivityDialogs}->{$ActivityDialogEntityID}->{Name}
                        . "' could not be added. Stopping import.",
                );
            }

       # add the new EntityID to our mapping so we can later replace occurrences of the old EntityID
            $ActivityDialogMapping{$ActivityDialogEntityID} = $EntityID;
        }

        # add transition actions
        my %TransitionActionMapping;
        for my $TransitionActionEntityID ( sort keys %{ $ProcessData->{TransitionActions} } ) {

            # get next EntityID
            my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
                EntityType => 'TransitionAction',
                UserID     => $Self->{UserID},
            );

            my $ID = $Self->{TransitionActionObject}->TransitionActionAdd(
                EntityID => $EntityID,
                Name     => $ProcessData->{TransitionActions}->{$TransitionActionEntityID}->{Name},
                Config => $ProcessData->{TransitionActions}->{$TransitionActionEntityID}->{Config},
                UserID => $Self->{UserID},
            );

            if ( !$ID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "TransitionAction '"
                        . $ProcessData->{TransitionActions}->{$TransitionActionEntityID}->{Name}
                        . "' could not be added. Stopping import.",
                );
            }

       # add the new EntityID to our mapping so we can later replace occurrences of the old EntityID
            $TransitionActionMapping{$TransitionActionEntityID} = $EntityID;
        }

        # add transitions
        my %TransitionMapping;
        for my $TransitionEntityID ( sort keys %{ $ProcessData->{Transitions} } ) {

            # get next EntityID
            my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
                EntityType => 'Transition',
                UserID     => $Self->{UserID},
            );

            my $ID = $Self->{TransitionObject}->TransitionAdd(
                EntityID => $EntityID,
                Name     => $ProcessData->{Transitions}->{$TransitionEntityID}->{Name},
                Config   => $ProcessData->{Transitions}->{$TransitionEntityID}->{Config},
                UserID   => $Self->{UserID},
            );

            if ( !$ID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Transition '"
                        . $ProcessData->{Transitions}->{$TransitionEntityID}->{Name}
                        . "' could not be added. Stopping import.",
                );
            }

       # add the new EntityID to our mapping so we can later replace occurrences of the old EntityID
            $TransitionMapping{$TransitionEntityID} = $EntityID;
        }

        # add activities
        my %ActivityMapping;
        for my $ActivityEntityID ( sort keys %{ $ProcessData->{Activities} } ) {

            # get next EntityID
            my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
                EntityType => 'Activity',
                UserID     => $Self->{UserID},
            );

            # search and replace ocurrences of old ActivityDialog ids by the new ones
            my $Config = YAML::Dump( $ProcessData->{Activities}->{$ActivityEntityID}->{Config} );
            $Config =~ s{(AD\d+)}{$ActivityDialogMapping{$1}}xmsg;
            $Config = YAML::Load($Config);

            my $ID = $Self->{ActivityObject}->ActivityAdd(
                EntityID => $EntityID,
                Name     => $ProcessData->{Activities}->{$ActivityEntityID}->{Name},
                Config   => $Config,
                UserID   => $Self->{UserID},
            );

            if ( !$ID ) {
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "Activity '"
                        . $ProcessData->{Activities}->{$ActivityEntityID}->{Name}
                        . "' could not be added. Stopping import.",
                );
            }

       # add the new EntityID to our mapping so we can later replace occurrences of the old EntityID
            $ActivityMapping{$ActivityEntityID} = $EntityID;
        }

        # generate EntityID for the process itself
        my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
            EntityType => 'Process',
            UserID     => $Self->{UserID},
        );

        # layout: search and replace ocurrences of old Activity ids by the new ones
        my $Layout = YAML::Dump( $ProcessData->{Process}->{Layout} );
        $Layout =~ s{(\s+)(A\d+)}{$1$ActivityMapping{$2}}xmsg;
        $Layout = YAML::Load($Layout);

        # config: search and replace ocurrences of old object ids by the new ones
        my $Config = YAML::Dump( $ProcessData->{Process}->{Config} );
        $Config =~ s{(\s+)(A\d+)}{$1$ActivityMapping{$2}}xmsg;
        $Config =~ s{(\s+)(AD\d+)}{$1$ActivityDialogMapping{$2}}xmsg;
        $Config =~ s{(\s+)(T\d+)}{$1$TransitionMapping{$2}}xmsg;
        $Config =~ s{(\s+)(TA\d+)}{$1$TransitionActionMapping{$2}}xmsg;
        $Config = YAML::Load($Config);

        # now add the process
        my $ID = $Self->{ProcessObject}->ProcessAdd(
            EntityID      => $EntityID,
            Name          => $ProcessData->{Process}->{Name},
            StateEntityID => $ProcessData->{Process}->{StateEntityID},
            Layout        => $Layout,
            Config        => $Config,
            UserID        => $Self->{UserID},
        );

        if ( !$ID ) {

            # roll back all changes
            for my $ActivityDialogEntityID ( values %ActivityDialogMapping ) {

                my $ActivityDialogData = $Self->{ActivityDialogObject}->ActivityDialogGet(
                    EntityID => $ActivityDialogEntityID,
                    UserID   => $Self->{UserID},
                );
                my $Success = $Self->{ActivityDialogObject}->ActivityDialogDelete(
                    ID     => $ActivityDialogData->{ID},
                    UserID => $Self->{UserID},
                );
                if ( !$Success ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "ActivityDialog '"
                            . $ActivityDialogData->{Name}
                            . "' could not be deleted.",
                    );
                }
            }
            for my $TransitionActionEntityID ( values %TransitionActionMapping ) {

                my $TransitionActionData = $Self->{TransitionActionObject}->TransitionActionGet(
                    EntityID => $TransitionActionEntityID,
                    UserID   => $Self->{UserID},
                );
                my $Success = $Self->{TransitionActionObject}->TransitionActionDelete(
                    ID     => $TransitionActionData->{ID},
                    UserID => $Self->{UserID},
                );
                if ( !$Success ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "TransitionAction '"
                            . $TransitionActionData->{Name}
                            . "' could not be deleted.",
                    );
                }
            }
            for my $TransitionEntityID ( values %TransitionMapping ) {

                my $TransitionData = $Self->{TransitionObject}->TransitionGet(
                    EntityID => $TransitionEntityID,
                    UserID   => $Self->{UserID},
                );
                my $Success = $Self->{TransitionObject}->TransitionDelete(
                    ID     => $TransitionData->{ID},
                    UserID => $Self->{UserID},
                );
                if ( !$Success ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message  => "Transition '"
                            . $TransitionData->{Name}
                            . "' could not be deleted.",
                    );
                }
            }
            for my $ActivityEntityID ( values %ActivityMapping ) {

                my $ActivityData = $Self->{ActivityObject}->ActivityGet(
                    EntityID => $ActivityEntityID,
                    UserID   => $Self->{UserID},
                );
                my $Success = $Self->{ActivityObject}->ActivityDelete(
                    ID     => $ActivityData->{ID},
                    UserID => $Self->{UserID},
                );
                if ( !$Success ) {
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Activity '" . $ActivityData->{Name} . "' could not be deleted.",
                    );
                }
            }

            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Process could not be imported. All changes have been rolled back.",
            );
        }
        else {

            $Param{NotifyData} = [
                {
                    Info =>
                        'Process '
                        . $ProcessData->{Process}->{Name}
                        . ' and all its data has been imported sucessfully.',
                },
                {
                    Info => $SynchronizeMessage,
                },
            ];

            return $Self->_ShowOverview(
                %Param,
            );
        }
    }

    # ------------------------------------------------------------ #
    # ProcessExport
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessExport' ) {

        # check for ProcessID
        my $ProcessID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';
        if ( !$ProcessID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need ProcessID!",
            );
        }

        my %ProcessData;

        # get process data
        my $Process = $Self->{ProcessObject}->ProcessGet(
            ID     => $ProcessID,
            UserID => $Self->{UserID},
        );
        if ( !$Process ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Unknown Process $ProcessID!",
            );
        }
        $ProcessData{Process} = $Process;

        # get all used activities
        for my $ActivityEntityID ( @{ $Process->{Activities} } ) {

            my $Activity = $Self->{ActivityObject}->ActivityGet(
                EntityID => $ActivityEntityID,
                UserID   => $Self->{UserID},
            );
            $ProcessData{Activities}->{$ActivityEntityID} = $Activity;

            # get all used activity dialogs
            for my $ActivityDialogEntityID ( @{ $Activity->{ActivityDialogs} } ) {

                my $ActivityDialog = $Self->{ActivityDialogObject}->ActivityDialogGet(
                    EntityID => $ActivityDialogEntityID,
                    UserID   => $Self->{UserID},
                );
                $ProcessData{ActivityDialogs}->{$ActivityDialogEntityID} = $ActivityDialog;
            }
        }

        # get all used transitions
        for my $TransitionEntityID ( @{ $Process->{Transitions} } ) {

            my $Transition = $Self->{TransitionObject}->TransitionGet(
                EntityID => $TransitionEntityID,
                UserID   => $Self->{UserID},
            );
            $ProcessData{Transitions}->{$TransitionEntityID} = $Transition;
        }

        # get all used transition actions
        for my $TransitionActionEntityID ( @{ $Process->{TransitionActions} } ) {

            my $TransitionAction = $Self->{TransitionActionObject}->TransitionActionGet(
                EntityID => $TransitionActionEntityID,
                UserID   => $Self->{UserID},
            );
            $ProcessData{TransitionActions}->{$TransitionActionEntityID} = $TransitionAction;
        }

        # convert the processdata hash to string
        my $ProcessData = YAML::Dump( \%ProcessData );

        # send the result to the browser
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $ProcessData,
            Type        => 'attachment',
            Filename    => 'Export_ProcessEntityID_' . $Process->{EntityID} . '.yml',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # ProcessNew
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessNew' ) {

        return $Self->_ShowEdit(
            %Param,
            Action => 'New',
        );
    }

    # ------------------------------------------------------------ #
    # ProcessNewAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessNewAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get process data
        my $ProcessData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams;

        # set new confguration
        $ProcessData->{Name}                  = $GetParam->{Name};
        $ProcessData->{Config}->{Description} = $GetParam->{Description};
        $ProcessData->{StateEntityID}         = $GetParam->{StateEntityID};

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{Description} ) {

            # add server error error class
            $Error{DescriptionServerError}        = 'ServerError';
            $Error{DescriptionServerErrorMessage} = 'This field is required';
        }

        # check if state exists
        my $StateList = $Self->{StateObject}->StateList( UserID => $Self->{UserID} );

        if ( !$StateList->{ $GetParam->{StateEntityID} } )
        {

            # add server error error class
            $Error{StateEntityIDServerError} = 'ServerError';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                ProcessData => $ProcessData,
                Action      => 'New',
            );
        }

        # generate entity ID
        my $EntityID = $Self->{EntityObject}->EntityIDGenerate(
            EntityType => 'Process',
            UserID     => $Self->{UserID},
        );

        # show error if can't generate a new EntityID
        if ( !$EntityID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error generating a new EntityID for this Process",
            );
        }

        # otherwise save configuration and return to overview screen
        my $ProcessID = $Self->{ProcessObject}->ProcessAdd(
            Name          => $ProcessData->{Name},
            EntityID      => $EntityID,
            StateEntityID => $ProcessData->{StateEntityID},
            Layout        => {},
            Config        => $ProcessData->{Config},
            UserID        => $Self->{UserID},
        );

        # show error if can't create
        if ( !$ProcessID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error creating the Process",
            );
        }

        # set entitty sync state
        my $Success = $Self->{EntityObject}->EntitySyncStateSet(
            EntityType => 'Process',
            EntityID   => $EntityID,
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error setting the entity sync status for Process "
                    . "entity:$EntityID",
            );
        }

        # return to overview
        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
    }

    # ------------------------------------------------------------ #
    # ProcessEdit
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessEdit' ) {

        # check for ProcessID
        if ( !$ProcessID ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Need ProcessID!",
            );
        }

        # set screens path in session
        my @ScreensPath = (
            {
                Action    => $Self->{Action}    || '',
                Subaction => $Self->{Subaction} || '',
                Parameters => 'ID=' . $ProcessID . ';EntityID=' . $EntityID
            }
        );

        # convert screens patch to string (JSON)
        my $JSONScreensPath = $Self->{LayoutObject}->JSONEncode(
            Data => \@ScreensPath,
        );

        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'ProcessManagementScreensPath',
            Value     => $JSONScreensPath,
        );

        # get Process data
        my $ProcessData = $Self->{ProcessObject}->ProcessGet(
            ID     => $ProcessID,
            UserID => $Self->{UserID},
        );

        # check for valid Process data
        if ( !IsHashRefWithData($ProcessData) ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "Could not get data for ProcessID $ProcessID",
            );
        }

        return $Self->_ShowEdit(
            %Param,
            ProcessID   => $ProcessID,
            ProcessData => $ProcessData,
            Action      => 'Edit',
        );
    }

    # ------------------------------------------------------------ #
    # ProcessEditAction
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessEditAction' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # get webserice configuration
        my $ProcessData;

        # get parameter from web browser
        my $GetParam = $Self->_GetParams;

        # set new confguration
        $ProcessData->{Name}                          = $GetParam->{Name};
        $ProcessData->{EntityID}                      = $GetParam->{EntityID};
        $ProcessData->{ProcessLayout}                 = $GetParam->{ProcessLayout};
        $ProcessData->{StateEntityID}                 = $GetParam->{StateEntityID};
        $ProcessData->{Config}->{Description}         = $GetParam->{Description};
        $ProcessData->{Config}->{Path}                = $GetParam->{Path};
        $ProcessData->{Config}->{StartActivity}       = $GetParam->{StartActivity};
        $ProcessData->{Config}->{StartActivityDialog} = $GetParam->{StartActivityDialog};

        # check required parameters
        my %Error;
        if ( !$GetParam->{Name} ) {

            # add server error error class
            $Error{NameServerError}        = 'ServerError';
            $Error{NameServerErrorMessage} = 'This field is required';
        }

        if ( !$GetParam->{Description} ) {

            # add server error error class
            $Error{DescriptionServerError}        = 'ServerError';
            $Error{DescriptionServerErrorMessage} = 'This field is required';
        }

        # check if state exists
        my $StateList = $Self->{StateObject}->StateList( UserID => $Self->{UserID} );

        if ( !$StateList->{ $GetParam->{StateEntityID} } )
        {

            # add server error error class
            $Error{StateEntityIDServerError} = 'ServerError';
        }

        # if there is an error return to edit screen
        if ( IsHashRefWithData( \%Error ) ) {
            return $Self->_ShowEdit(
                %Error,
                %Param,
                ProcessData => $ProcessData,
                Action      => 'Edit',
            );
        }

        # otherwise save configuration and return to overview screen
        my $Success = $Self->{ProcessObject}->ProcessUpdate(
            ID            => $ProcessID,
            Name          => $ProcessData->{Name},
            EntityID      => $ProcessData->{EntityID},
            StateEntityID => $ProcessData->{StateEntityID},
            Layout        => $ProcessData->{ProcessLayout},
            Config        => $ProcessData->{Config},
            UserID        => $Self->{UserID},
        );

        # show error if can't update
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error updating the Process",
            );
        }

        # set entitty sync state
        $Success = $Self->{EntityObject}->EntitySyncStateSet(
            EntityType => 'Process',
            EntityID   => $ProcessData->{EntityID},
            SyncState  => 'not_sync',
            UserID     => $Self->{UserID},
        );

        # show error if can't set
        if ( !$Success ) {
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error setting the entity sync status for Process "
                    . "entity:$ProcessData->{EntityID}",
            );
        }

        if ( $Self->{ParamObject}->GetParam( Param => 'ContinueAfterSave' ) eq '1' ) {

          # if the user would like to continue editing the process, just redirect to the edit screen
            return $Self->{LayoutObject}->Redirect(
                OP =>
                    "Action=AdminProcessManagement;Subaction=ProcessEdit;ID=$ProcessID;EntityID=$ProcessData->{EntityID}"
            );
        }
        else {

            # otherwise return to overview
            return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
        }
    }

    # ------------------------------------------------------------ #
    # ProcessDeleteCheck AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessDeleteCheck' ) {

        # check for ProcessID
        return if !$ProcessID;

        my $CheckResult = $Self->_CheckProcessDelete( ID => $ProcessID );

        # build JSON output
        my $JSON = $Self->{LayoutObject}->JSONEncode(
            Data => {
                %{$CheckResult},
            },
        );

        # send JSON response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # ProcessDelete AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessDelete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # check for ProcessID
        return if !$ProcessID;

        my $CheckResult = $Self->_CheckProcessDelete( ID => $ProcessID );

        my $JSON;
        if ( $CheckResult->{Success} ) {

            my $Success = $Self->{ProcessObject}->ProcessDelete(
                ID     => $ProcessID,
                UserID => $Self->{UserID},
            );

            my %DeleteResult = (
                Success => $Success,
            );

            if ( !$Success ) {
                $DeleteResult{Message} = 'Process:$ProcessID could not be deleted';
            }
            else {

                # set entitty sync state
                my $Success = $Self->{EntityObject}->EntitySyncStateSet(
                    EntityType => 'Process',
                    EntityID   => $CheckResult->{ProcessData}->{EntityID},
                    SyncState  => 'deleted',
                    UserID     => $Self->{UserID},
                );

                # show error if cant set
                if ( !$Success ) {
                    $DeleteResult{Success} = $Success;
                    $DeleteResult{Message} = "There was an error setting the entity sync status "
                        . "for Process entity:$CheckResult->{ProcessData}->{EntityID}"
                }
            }

            # build JSON output
            $JSON = $Self->{LayoutObject}->JSONEncode(
                Data => {
                    %DeleteResult,
                },
            );
        }
        else {

            # build JSON output
            $JSON = $Self->{LayoutObject}->JSONEncode(
                Data => {
                    %{$CheckResult},
                },
            );
        }

        # send JSON response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # ProcessSync
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'ProcessSync' ) {

        my $Location
            = $Self->{ConfigObject}->Get('Home') . '/Kernel/Config/Files/ZZZProcessManagement.pm';

        my $ProcessDump = $Self->{ProcessObject}->ProcessDump(
            ResultType => 'FILE',
            Location   => $Location,
            UserID     => $Self->{UserID},
        );

        if ($ProcessDump) {

            my $Success = $Self->{EntityObject}->EntitySyncStatePurge(
                UserID => $Self->{UserID},
            );

            if ($Success) {
                return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
            }
            else {

                # show error if can't set state
                return $Self->{LayoutObject}->ErrorScreen(
                    Message => "There was an error setting the entity sync status.",
                );
            }
        }
        else {

            # show error if can't synch
            return $Self->{LayoutObject}->ErrorScreen(
                Message => "There was an error synchronizing the processes.",
            );
        }
    }

    # ------------------------------------------------------------ #
    # EntityUsageCheck AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'EntityUsageCheck' ) {

        my %GetParam;
        for my $Param (qw(EntityType EntityID)) {
            $GetParam{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        # check needed information
        return if !$GetParam{EntityType};
        return if !$GetParam{EntityID};

        my $EntityCheck = $Self->_CheckEntityUsage(%GetParam);

        # build JSON output
        my $JSON = $Self->{LayoutObject}->JSONEncode(
            Data => {
                %{$EntityCheck},
            },
        );

        # send JSON response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # EntityDelete AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'EntityDelete' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        my %GetParam;
        for my $Param (qw(EntityType EntityID ItemID)) {
            $GetParam{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        # check needed information
        return if !$GetParam{EntityType};
        return if !$GetParam{EntityID};
        return if !$GetParam{ItemID};

        return if $GetParam{EntityType} ne 'Activity'
            && $GetParam{EntityType} ne 'ActivityDialog'
            && $GetParam{EntityType} ne 'Transition'
            && $GetParam{EntityType} ne 'TransitionAction';

        my $EntityCheck = $Self->_CheckEntityUsage(%GetParam);

        my $JSON;
        if ( !$EntityCheck->{Deleteable} ) {
            $JSON = $Self->{LayoutObject}->JSONEncode(
                Data => {
                    Success => 0,
                    Message => "The $GetParam{EntityType}:$GetParam{EntityID} is still in use",
                },
            );
        }
        else {

            # get entity
            my $Method = $GetParam{EntityType} . 'Get';
            my $Entity = $Self->{ $GetParam{EntityType} . 'Object' }->$Method(
                ID     => $GetParam{ItemID},
                UserID => $Self->{UserID},
            );

            if ( $Entity->{EntityID} ne $GetParam{EntityID} ) {
                $JSON = $Self->{LayoutObject}->JSONEncode(
                    Data => {
                        Success => 0,
                        Message => "The $GetParam{EntityType}:$GetParam{ItemID} has a different"
                            . " EntityID",
                    },
                );
            }
            else {

                # delete entity
                $Method = $GetParam{EntityType} . 'Delete';
                my $Success = $Self->{ $GetParam{EntityType} . 'Object' }->$Method(
                    ID     => $GetParam{ItemID},
                    UserID => $Self->{UserID},
                );

                my $Message;
                if ( !$Success ) {
                    $Success = 0;
                    $Message = "Could not delete $GetParam{EntityType}:$GetParam{ItemID}";
                }
                else {

                    # set entitty sync state
                    my $Success = $Self->{EntityObject}->EntitySyncStateSet(
                        EntityType => $GetParam{EntityType},
                        EntityID   => $Entity->{EntityID},
                        SyncState  => 'deleted',
                        UserID     => $Self->{UserID},
                    );

                    # show error if cant set
                    if ( !$Success ) {
                        $Success = 0;
                        $Message = "There was an error setting the entity sync status for "
                            . "$GetParam{EntityType} entity:$Entity->{EntityID}"
                    }
                }

                # build JSON output
                $JSON = $Self->{LayoutObject}->JSONEncode(
                    Data => {
                        Success => $Success,
                        Message => $Message,
                    },
                );
            }
        }

        # send JSON response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # EntityGet AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'EntityGet' ) {

        my %GetParam;
        for my $Param (qw(EntityType EntityID ItemID)) {
            $GetParam{$Param} = $Self->{ParamObject}->GetParam( Param => $Param ) || '';
        }

        # check needed information
        return if !$GetParam{EntityType};
        return if !$GetParam{EntityID} && !$GetParam{ItemID};

        return if $GetParam{EntityType} ne 'Activity'
            && $GetParam{EntityType} ne 'ActivityDialog'
            && $GetParam{EntityType} ne 'Transition'
            && $GetParam{EntityType} ne 'TransitionAction'
            && $GetParam{EntityType} ne 'Process';

        # get entity
        my $Method = $GetParam{EntityType} . 'Get';

        my $EntityData;
        if ( $GetParam{ItemID} && $GetParam{ItemID} ne '' ) {
            $EntityData = $Self->{ $GetParam{EntityType} . 'Object' }->$Method(
                ID     => $GetParam{ItemID},
                UserID => $Self->{UserID},
            );
        }
        else {
            $EntityData = $Self->{ $GetParam{EntityType} . 'Object' }->$Method(
                EntityID => $GetParam{EntityID},
                UserID   => $Self->{UserID},
            );
        }

        my $JSON;
        if ( !IsHashRefWithData($EntityData) ) {
            $JSON = $Self->{LayoutObject}->JSONEncode(
                Data => {
                    Success => 0,
                    Message => "Could not get $GetParam{EntityType}",
                },
            );
        }
        else {

            # build JSON output
            $JSON = $Self->{LayoutObject}->JSONEncode(
                Data => {
                    Success    => 1,
                    EntityData => $EntityData,
                },
            );
        }

        # send JSON response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # UpdateSyncMessage AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UpdateSyncMessage' ) {

        # get the list of updated or deleted entities
        my $EntitySyncStateList = $Self->{EntityObject}->EntitySyncStateList(
            UserID => $Self->{UserID}
        );

        # prevent errors by defining $Output as an empty string instead of undef
        my $Output = '';
        if ( IsArrayRefWithData($EntitySyncStateList) ) {
            $Output = $Self->{LayoutObject}->Notify(
                Info => $SynchronizeMessage,
            );
        }

        # send HTML response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Content     => $Output,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # UpdateAccordion AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UpdateAccordion' ) {

        # ouput available process elements in the accordion
        for my $Element (qw(Activity ActivityDialog Transition TransitionAction)) {

            my $ElementMethod = $Element . 'ListGet';

            # get a list of all elements with details
            my $ElementList
                = $Self->{ $Element . 'Object' }->$ElementMethod( UserID => $Self->{UserID} );

            # check there are elements to display
            if ( IsArrayRefWithData($ElementList) ) {
                for my $ElementData ( @{$ElementList} ) {

                    my $AvailableIn = '';
                    if ( $Element eq "ActivityDialog" ) {
                        my $ConfigAvailableIn = $ElementData->{Config}->{Interface};

                        if ( defined $ConfigAvailableIn ) {
                            my $InterfaceLength = scalar @{$ConfigAvailableIn};
                            if ( $InterfaceLength == 2 ) {
                                $AvailableIn = 'A/C';
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
                    }

                    # print each element in the accordion
                    $Self->{LayoutObject}->Block(
                        Name => $Element . 'Row',
                        Data => {
                            %{$ElementData},
                            AvailableIn => $AvailableIn,    #only used for ActivityDialogs
                        },
                    );
                }
            }
            else {

                # print no data found in the accordion
                $Self->{LayoutObject}->Block(
                    Name => $Element . 'NoDataRow',
                    Data => {},
                );
            }
        }

        my $Output = $Self->{LayoutObject}->Output(
            TemplateFile => "AdminProcessManagementProcessAccordion",
            Data         => {},
        );

        # send HTML response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html',
            Content     => $Output,
            Type        => 'inline',
            NoCache     => 1,
        );

    }

    # ------------------------------------------------------------ #
    # UpdateScreensPath AJAX
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'UpdateScreensPath' ) {

        my $Success = 1;
        my $Message = '';
        for my $Needed (qw(ProcessID ProcessEntityID)) {

            $Param{$Needed} = $Self->{ParamObject}->GetParam( Param => $Needed ) || '';
            if ( !$Param{$Needed} ) {
                $Success = 0;
                $Message = 'Need $Needed!';
            }
        }

        if ($Success) {

            $Self->_PushSessionScreen(
                ID        => $Param{ProcessID},
                EntityID  => $Param{ProcessEntityID},
                Subaction => 'ProcessEdit',
                Action    => 'AdminProcessManagement',
            );
        }

        # build JSON output
        my $JSON = $Self->{LayoutObject}->JSONEncode(
            Data => {
                Success => $Success,
                Message => $Message,
            },
        );

        # send JSON response
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # ------------------------------------------------------------ #
    # Overview
    # ------------------------------------------------------------ #
    else {
        return $Self->_ShowOverview(
            %Param,
        );
    }
}

sub _ShowOverview {
    my ( $Self, %Param ) = @_;

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # show notifications if any
    if ( $Param{NotifyData} ) {
        for my $Notification ( @{ $Param{NotifyData} } ) {
            $Output .= $Self->{LayoutObject}->Notify(
                %{$Notification},
            );
        }
    }

    # get a process list
    my $ProcessList = $Self->{ProcessObject}->ProcessList( UserID => $Self->{UserID} );

    if ( IsHashRefWithData($ProcessList) ) {

        # get each process data
        for my $ProcessID ( sort keys %{$ProcessList} ) {
            my $ProcessData = $Self->{ProcessObject}->ProcessGet(
                ID     => $ProcessID,
                UserID => $Self->{UserID},
            );

            # print each process in overview table
            $Self->{LayoutObject}->Block(
                Name => 'ProcessRow',
                Data => {
                    %{$ProcessData},
                    Description => $ProcessData->{Config}->{Description},
                    }
            );
        }
    }
    else {

        # print no data found message
        $Self->{LayoutObject}->Block(
            Name => 'ProcessNoDataRow',
            Data => {},
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AdminProcessManagement',
        Data         => \%Param,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}

sub _ShowEdit {
    my ( $Self, %Param ) = @_;

    # get process information
    my $ProcessData = $Param{ProcessData} || {};

    if ( defined $Param{Action} && $Param{Action} eq 'Edit' ) {

        # check if process is inactive and show delete action
        my $State = $Self->{StateObject}->StateLookup(
            EntityID => $ProcessData->{StateEntityID},
            UserID   => $Self->{UserID},
        );
        if ( $State eq 'Inactive' ) {
            $Self->{LayoutObject}->Block(
                Name => 'ProcessDeleteAction',
                Data => {
                    %{$ProcessData},
                },
            );
        }

        # ouput available process elements in the accordion
        for my $Element (qw(Activity ActivityDialog Transition TransitionAction)) {

            my $ElementMethod = $Element . 'ListGet';

            # get a list of all elements with details
            my $ElementList
                = $Self->{ $Element . 'Object' }->$ElementMethod( UserID => $Self->{UserID} );

            # check there are elements to display
            if ( IsArrayRefWithData($ElementList) ) {
                for my $ElementData ( @{$ElementList} ) {

                    my $AvailableIn = '';
                    if ( $Element eq "ActivityDialog" ) {
                        my $ConfigAvailableIn = $ElementData->{Config}->{Interface};

                        if ( defined $ConfigAvailableIn ) {
                            my $InterfaceLength = scalar @{$ConfigAvailableIn};
                            if ( $InterfaceLength == 2 ) {
                                $AvailableIn = 'A/C';
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
                    }

                    # print each element in the accordion
                    $Self->{LayoutObject}->Block(
                        Name => $Element . 'Row',
                        Data => {
                            %{$ElementData},
                            AvailableIn => $AvailableIn,    #only used for ActivityDialogs
                        },
                    );
                }
            }
            else {

                # print no data found in the accordion
                $Self->{LayoutObject}->Block(
                    Name => $Element . 'NoDataRow',
                    Data => {},
                );
            }
        }
    }

    # get a list of all states
    my $StateList = $Self->{StateObject}->StateList( UserID => $Self->{UserID} );

    # get the 'inactive' state for init
    my $InactiveStateID;
    for my $StateID ( sort keys %{$StateList} ) {
        if ( $StateList->{$StateID} =~ m{Inactive}xmsi ) {
            $InactiveStateID = $StateID;
        }
    }

    my $StateError = '';
    if ( $Param{StateEntityIDServerError} ) {
        $StateError = $Param{StateEntityIDServerError};
    }

    # create estate selection
    $Param{StateSelection} = $Self->{LayoutObject}->BuildSelection(
        Data => $StateList || {},
        Name => 'StateEntityID',
        ID   => 'StateEntityID',
        SelectedID => $ProcessData->{StateEntityID}
            || $InactiveStateID,    # select inactive by default
        Sort        => 'AlphanumericKey',
        Translation => 1,
        Class       => 'W50pc ' . $StateError,
    );

    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # show notifications if any
    if ( $Param{NotifyData} ) {
        for my $Notification ( @{ $Param{NotifyData} } ) {
            $Output .= $Self->{LayoutObject}->Notify(
                %{$Notification},
            );
        }
    }

    # set db dump as config settings
    my $ProcessDump = $Self->{ProcessObject}->ProcessDump(
        ResultType => 'HASH',
        UserID     => $Self->{UserID},
    );
    my $ProcessConfigJSON = $Self->{LayoutObject}->JSONEncode(
        Data => $ProcessDump->{Process},
    );
    my $ActivityConfigJSON = $Self->{LayoutObject}->JSONEncode(
        Data => $ProcessDump->{Activity},
    );
    my $ActivityDialogConfigJSON = $Self->{LayoutObject}->JSONEncode(
        Data => $ProcessDump->{ActivityDialog},
    );
    my $TransitionConfigJSON = $Self->{LayoutObject}->JSONEncode(
        Data => $ProcessDump->{Transition},
    );
    my $TransitionActionConfigJSON = $Self->{LayoutObject}->JSONEncode(
        Data => $ProcessDump->{TransitionAction},
    );

    my $ProcessLayoutJSON = $Self->{LayoutObject}->JSONEncode(
        Data => $ProcessData->{Layout},
    );

    $Self->{LayoutObject}->Block(
        Name => 'ConfigSet',
        Data => {
            ProcessConfig          => $ProcessConfigJSON,
            ProcessLayout          => $ProcessLayoutJSON,
            ActivityConfig         => $ActivityConfigJSON,
            ActivityDialogConfig   => $ActivityDialogConfigJSON,
            TransitionConfig       => $TransitionConfigJSON,
            TransitionActionConfig => $TransitionActionConfigJSON,
        },
    );

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => "AdminProcessManagementProcess$Param{Action}",
        Data         => {
            %Param,
            %{$ProcessData},
            Description => $ProcessData->{Config}->{Description} || '',
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
        qw( Name EntityID ProcessLayout Path StartActivity StartActivityDialog Description StateEntityID )
        )
    {
        $GetParam->{$ParamName} = $Self->{ParamObject}->GetParam( Param => $ParamName ) || '';
    }

    if ( $GetParam->{ProcessLayout} ) {
        $GetParam->{ProcessLayout} = $Self->{JSONObject}->Decode(
            Data => $GetParam->{ProcessLayout},
        );
    }

    if ( $GetParam->{Path} ) {
        $GetParam->{Path} = $Self->{JSONObject}->Decode(
            Data => $GetParam->{Path},
        );
    }

    return $GetParam;
}

sub _CheckProcessDelete {
    my ( $Self, %Param ) = @_;

    # get Process data
    my $ProcessData = $Self->{ProcessObject}->ProcessGet(
        ID     => $Param{ID},
        UserID => $Self->{UserID},
    );

    # check for valid Process data
    if ( !IsHashRefWithData($ProcessData) ) {
        return {
            Success => 0,
            Message => "Could not get data for ProcessID $Param{ID}",
        };
    }

    # check that the Process is in Inactive state
    my $State = $Self->{StateObject}->StateLookup(
        EntityID => $ProcessData->{StateEntityID},
        UserID   => $Self->{UserID},
    );

    if ( $State ne 'Inactive' ) {
        return {
            Success => 0,
            Message => "Process:$Param{ID} is not Inactive",
        };
    }

    return {
        Success     => 1,
        ProcessData => $ProcessData,
    };
}

sub _CheckEntityUsage {
    my ( $Self, %Param ) = @_;

    my %Config = (
        Activity => {
            Parent => 'Process',
            Method => 'ProcessListGet',
            Array  => 'Activities',
        },
        ActivityDialog => {
            Parent => 'Activity',
            Method => 'ActivityListGet',
            Array  => 'ActivityDialogs',
        },
        Transition => {
            Parent => 'Process',
            Method => 'ProcessListGet',
            Array  => 'Transitions',
        },
        TransitionAction => {
            Parent => 'Transition',
            Method => 'TransitionListGet',
            Array  => 'TransitionActions',
        },
    );

    return if !$Config{ $Param{EntityType} };

    my $Parent = $Config{ $Param{EntityType} }->{Parent};
    my $Method = $Config{ $Param{EntityType} }->{Method};
    my $Array  = $Config{ $Param{EntityType} }->{Array};

    # get a list of parents with all the details
    my $List = $Self->{ $Parent . 'Object' }->$Method(
        UserID => 1,
    );

    my @Usage;

    # search entity id in all parents
    PARENT:
    for my $ParentData ( @{$List} ) {
        next PARENT if !$ParentData;
        next PARENT if !$ParentData->{$Array};

        ENTITY:
        for my $EntityID ( @{ $ParentData->{$Array} } ) {
            if ( $EntityID eq $Param{EntityID} ) {
                push @Usage, $ParentData->{Name};
                last ENTITY;
            }
        }
    }

    my $Deleteable = 0;

    if ( scalar @Usage == 0 ) {
        $Deleteable = 1;
    }

    return {
        Deleteable => $Deleteable,
        Usage      => \@Usage,
    };
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

sub _GetFullProcessConfig {
    my ( $Self, %Param )

}

1;
