# --
# Kernel/Modules/AdminProcessManagement.pm - process management
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: AdminProcessManagement.pm,v 1.26 2012-08-16 10:24:58 mn Exp $
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
use Kernel::System::ProcessManagement::DB::Entity;
use Kernel::System::ProcessManagement::DB::Activity;
use Kernel::System::ProcessManagement::DB::ActivityDialog;
use Kernel::System::ProcessManagement::DB::Process;
use Kernel::System::ProcessManagement::DB::Process::State;
use Kernel::System::ProcessManagement::DB::Transition;
use Kernel::System::ProcessManagement::DB::TransitionAction;

use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.26 $) [1];

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

    if ( IsArrayRefWithData($EntitySyncStateList) ) {

        # create a notification if system is not up to date
        $Param{NotifyData} = [
            {
                Info =>
                    'Process Management information from database is not in sync with the system configuration, please synchronize all the Processes.',
            },
        ];
    }

    # ------------------------------------------------------------ #
    # ProcessExport
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'ProcessExport' ) {

        my $ProcessID = $Self->{ParamObject}->GetParam( Param => 'ID' ) || '';

        # check for ProcessID
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

        # TODO Implement
        # currently it only deletes the sync flags for the entities

        my $Success = $Self->{EntityObject}->EntitySyncStatePurge(
            UserID => $Self->{UserID},
        );

        return $Self->{LayoutObject}->Redirect( OP => "Action=$Self->{Action}" );
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
    for my $StateID ( keys %{$StateList} ) {
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

    $GetParam->{ProcessLayout} = $Self->{JSONObject}->Decode(
        Data => $GetParam->{ProcessLayout},
    );

    $GetParam->{Path} = $Self->{JSONObject}->Decode(
        Data => $GetParam->{Path},
    );

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
