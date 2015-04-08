# --
# Kernel/Modules/CustomerTicketProcess.pm - to create process tickets
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketProcess;
## nofilter(TidyAll::Plugin::OTRS::Perl::DBObject)

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless $Self, $Type;

    # global config hash for id dissolution
    $Self->{NameToID} = {
        Title          => 'Title',
        State          => 'StateID',
        StateID        => 'StateID',
        Lock           => 'LockID',
        LockID         => 'LockID',
        Priority       => 'PriorityID',
        PriorityID     => 'PriorityID',
        Queue          => 'QueueID',
        QueueID        => 'QueueID',
        Customer       => 'CustomerID',
        CustomerID     => 'CustomerID',
        CustomerNo     => 'CustomerID',
        CustomerUserID => 'CustomerUserID',
        Type           => 'TypeID',
        TypeID         => 'TypeID',
        SLA            => 'SLAID',
        SLAID          => 'SLAID',
        Service        => 'ServiceID',
        ServiceID      => 'ServiceID',
        Article        => 'Article',
    };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    my $TicketID               = $ParamObject->GetParam( Param => 'TicketID' );
    my $ActivityDialogEntityID = $ParamObject->GetParam( Param => 'ActivityDialogEntityID' );
    my $ActivityDialogHashRef;

    # get needed objects
    my $LayoutObject         = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
    my $ActivityDialogObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog');

    # some fields should be skipped for the customer interface
    my $SkipFields = [ 'Owner', 'Responsible', 'Lock', 'PendingTime', 'CustomerID' ];

    if ($TicketID) {

        # include extra fields should be skipped
        for my $Item (qw(Service SLA Queue)) {
            push @{$SkipFields}, $Item;
        }

        # check if there is a configured required permission
        # for the ActivityDialog (if there is one)
        my $ActivityDialogPermission = 'rw';
        if ($ActivityDialogEntityID) {
            $ActivityDialogHashRef = $ActivityDialogObject->ActivityDialogGet(
                ActivityDialogEntityID => $ActivityDialogEntityID,
                Interface              => 'CustomerInterface',
            );

            if ( !IsHashRefWithData($ActivityDialogHashRef) ) {
                return $LayoutObject->CustomerErrorScreen(
                    Message => "Couldn't get ActivityDialogEntityID '$ActivityDialogEntityID'!",
                    Comment => 'Please contact the admin.',
                );
            }

            if ( $ActivityDialogHashRef->{Permission} ) {
                $ActivityDialogPermission = $ActivityDialogHashRef->{Permission};
            }
        }

        # check permissions
        my $Access = $TicketObject->TicketCustomerPermission(
            Type     => $ActivityDialogPermission,
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID}
        );

        # error screen, don't show ticket
        if ( !$Access ) {
            return $LayoutObject->CustomerNoPermission(
                Message    => "You need $ActivityDialogPermission permissions!",
                WithHeader => 'yes',
            );
        }

        # get ACL restrictions
        my %PossibleActions = ( 1 => $Self->{Action} );

        my $ACL = $TicketObject->TicketAcl(
            Data           => \%PossibleActions,
            Action         => $Self->{Action},
            TicketID       => $Self->{TicketID},
            ReturnType     => 'Action',
            ReturnSubType  => '-',
            CustomerUserID => $Self->{UserID},
        );
        my %AclAction = $TicketObject->TicketAclActionData();

        # check if ACL restrictions exist
        if ( $ACL || IsHashRefWithData( \%AclAction ) ) {

            my %AclActionLookup = reverse %AclAction;

            # show error screen if ACL prohibits this action
            if ( !$AclActionLookup{ $Self->{Action} } ) {
                return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' );
            }
        }

        if ( IsHashRefWithData($ActivityDialogHashRef) ) {

            my $PossibleActivityDialogs = { 1 => $ActivityDialogEntityID };

            # get ACL restrictions
            my $ACL = $TicketObject->TicketAcl(
                Data                   => $PossibleActivityDialogs,
                ActivityDialogEntityID => $ActivityDialogEntityID,
                TicketID               => $TicketID,
                ReturnType             => 'ActivityDialog',
                ReturnSubType          => '-',
                CustomerUserID         => $Self->{UserID},
            );

            if ($ACL) {
                %{$PossibleActivityDialogs} = $TicketObject->TicketAclData();
            }

            # check if ACL resctictions exist
            if ( !IsHashRefWithData($PossibleActivityDialogs) )
            {
                return $LayoutObject->CustomerNoPermission( WithHeader => 'yes' );
            }
        }
    }

    # list only Active processes by default
    my @ProcessStates = ('Active');

    # set IsMainWindow and IsAjaxRequest for proper error responses, screen display and process list
    $Self->{IsMainWindow}  = $ParamObject->GetParam( Param => 'IsMainWindow' )  || '';
    $Self->{IsAjaxRequest} = $ParamObject->GetParam( Param => 'IsAjaxRequest' ) || '';

    # fetch also FadeAway processes to continue working with existing tickets, but not to start new
    #    ones
    if ( !$Self->{IsMainWindow} && $Self->{Subaction} ) {
        push @ProcessStates, 'FadeAway'
    }

    # get process object
    my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process');

    # get the list of processes that customer can start
    my $ProcessList = $ProcessObject->ProcessList(
        ProcessState => \@ProcessStates,
        Interface    => ['CustomerInterface'],
    );

    # also get the list of processes initiated by agents, as an activity dialog might be configured
    # for the customer interface
    my $FollowupProcessList = $ProcessObject->ProcessList(
        ProcessState => \@ProcessStates,
        Interface    => [ 'AgentInterface', 'CustomerInterface' ],
    );

    my $ProcessEntityID = $ParamObject->GetParam( Param => 'ProcessEntityID' );

    if ( !IsHashRefWithData($ProcessList) && !IsHashRefWithData($FollowupProcessList) ) {
        return $LayoutObject->CustomerErrorScreen(
            Message => 'No Process configured!',
            Comment => 'Please contact the admin.',
        );
    }

    # prepare process list for ACLs, use only entities instead of names, convert from
    #   P1 => Name to P1 => P1. As ACLs should work only against entities
    my %ProcessListACL = map { $_ => $_ } sort keys %{$ProcessList};

    # validate the ProcessList with stored ACLs
    my $ACL = $TicketObject->TicketAcl(
        ReturnType     => 'Process',
        ReturnSubType  => '-',
        Data           => \%ProcessListACL,
        CustomerUserID => $Self->{UserID},
    );

    if ( IsHashRefWithData($ProcessList) && $ACL ) {

        # get ACL results
        my %ACLData = $TicketObject->TicketAclData();

        # recover process names
        my %ReducedProcessList = map { $_ => $ProcessList->{$_} } sort keys %ACLData;

        # replace original process list with the reduced one
        $ProcessList = \%ReducedProcessList;
    }

    # if we have no subaction display the process list to start a new one
    if ( !$Self->{Subaction} ) {

        # to display the process list is mandatory to have processes that customer can start
        if ( !IsHashRefWithData($ProcessList) ) {
            return $LayoutObject->CustomerErrorScreen(
                Message => 'No Process configured!',
                Comment => 'Please contact the admin.',
            );
        }

        return $Self->_DisplayProcessList(
            %Param,
            ProcessList     => $ProcessList,
            ProcessEntityID => $ProcessEntityID
        );
    }

    # check if the selected process from the list is valid, prevent tamper with process selection
    #    list (not existing, invalid an fade away processes must not be able to start a new process
    #    ticket)
    elsif (
        $Self->{Subaction} eq 'DisplayActivityDialogAJAX'
        && !$ProcessList->{$ProcessEntityID}
        && $Self->{IsMainWindow}
        )
    {

        # translate the error message (as it will be injected in the HTML)
        my $ErrorMessage = $LayoutObject->{LanguageObject}->Translate("The selected process is invalid!");

        # return a predefined HTML sctructure as the AJAX call is expecting and HTML response
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => '<div class="ServerError" data-message="' . $ErrorMessage . '"></div>',
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # if invalid process is detected on a ActivityDilog popup screen show an error message
    elsif (
        $Self->{Subaction} eq 'DisplayActivityDialog'
        && !$FollowupProcessList->{$ProcessEntityID}
        && !$Self->{IsMainWindow}
        )
    {
        $LayoutObject->CustomerFatalError(
            Message => "Process $ProcessEntityID is invalid!",
            Comment => 'Please contact the admin.',
        );
    }

    # Get the necessary parameters
    # collects a mixture of present values bottom to top:
    # SysConfig DefaultValues, ActivityDialog DefaultValues, TicketValues, SubmittedValues
    # including ActivityDialogEntityID and ProcessEntityID
    # is used for:
    # - Parameter checking before storing
    # - will be used for ACL checking later on
    my $GetParam = $Self->_GetParam(
        ProcessEntityID => $ProcessEntityID,
    );

    # get form id
    $Self->{FormID} = $ParamObject->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate();
    }

    if ( $Self->{Subaction} eq 'StoreActivityDialog' && $ProcessEntityID ) {
        $LayoutObject->ChallengeTokenCheck( Type => 'Customer' );

        return $Self->_StoreActivityDialog(
            %Param,
            ProcessName     => $ProcessList->{$ProcessEntityID},
            ProcessEntityID => $ProcessEntityID,
            GetParam        => $GetParam,
        );
    }
    if ( $Self->{Subaction} eq 'DisplayActivityDialog' && $ProcessEntityID ) {

        return $Self->_OutputActivityDialog(
            %Param,
            ProcessEntityID => $ProcessEntityID,
            GetParam        => $GetParam,
        );
    }
    if ( $Self->{Subaction} eq 'DisplayActivityDialogAJAX' && $ProcessEntityID ) {

        my $ActivityDialogHTML = $Self->_OutputActivityDialog(
            %Param,
            ProcessEntityID => $ProcessEntityID,
            GetParam        => $GetParam,
        );
        return $LayoutObject->Attachment(
            ContentType => 'text/html; charset=' . $LayoutObject->{Charset},
            Content     => $ActivityDialogHTML,
            Type        => 'inline',
            NoCache     => 1,
        );

    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        return $Self->_RenderAjax(
            %Param,
            ProcessEntityID => $ProcessEntityID,
            GetParam        => $GetParam,
        );
    }
    return $LayoutObject->CustomerErrorScreen(
        Message => 'Subacion is invalid!',
        Comment => 'Please contact the admin.',
    );
}

sub _RenderAjax {

    # FatalError is safe because a JSON strcuture is expecting, then it will result into a
    # communications error

    my ( $Self, %Param ) = @_;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    for my $Needed (qw(ProcessEntityID)) {
        if ( !$Param{$Needed} ) {
            $LayoutObject->CustomerFatalError( Message => "Got no $Needed in _RenderAjax!" );
        }
    }
    my $ActivityDialogEntityID = $Param{GetParam}{ActivityDialogEntityID};
    if ( !$ActivityDialogEntityID ) {
        $LayoutObject->CustomerFatalError(
            Message => "Got no ActivityDialogEntityID in _RenderAjax!"
        );
    }
    my $ActivityDialog = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog')->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityDialogEntityID,
        Interface              => 'CustomerInterface',
    );

    if ( !IsHashRefWithData($ActivityDialog) ) {
        $LayoutObject->CustomerFatalError(
            Message => "No ActivityDialog configured for $ActivityDialogEntityID in _RenderAjax!"
        );
    }

    # get list type
    my $TreeView = 0;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    my %FieldsProcessed;
    my @JSONCollector;
    my $Services;

    # All submitted DynamicFields
    # get dynamic field values form http request
    my %DynamicFieldValues;

    # get backend object
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => 'Ticket',
    );

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $DynamicField = \@CustomerDynamicFields;

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value form the web request
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} } = $BackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $ParamObject,
            LayoutObject       => $LayoutObject,
        );
    }

    # convert dynamic field values into a structure for ACLs
    my %DynamicFieldCheckParam;
    DYNAMICFIELD:
    for my $DynamicField ( sort keys %DynamicFieldValues ) {
        next DYNAMICFIELD if !$DynamicField;
        next DYNAMICFIELD if !$DynamicFieldValues{$DynamicField};

        $DynamicFieldCheckParam{ 'DynamicField_' . $DynamicField } = $DynamicFieldValues{$DynamicField};
    }
    $Param{GetParam}->{DynamicField} = \%DynamicFieldCheckParam;

    # some fields should be skipped for the customer interface
    my $SkipFields = [ 'Owner', 'Responsible', 'Lock', 'PendingTime', 'CustomerID' ];

    # Get the activity dialog's Submit Param's or Config Params
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        # some fields should be skipped for the customer interface
        next DIALOGFIELD if ( grep { $_ eq $CurrentField } @{$SkipFields} );

        # Skip if we're working on a field that was already done with or without ID
        if (
            $Self->{NameToID}{$CurrentField}
            && $FieldsProcessed{ $Self->{NameToID}{$CurrentField} }
            )
        {
            next DIALOGFIELD;
        }

        if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldName = $1;

            my $DynamicFieldConfig = ( grep { $_->{Name} eq $DynamicFieldName } @{$DynamicField} )[0];

            next DIALOGFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $IsACLReducible = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next DIALOGFIELD if !$IsACLReducible;

            my $PossibleValues = $BackendObject->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # get ticket object
            my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

            # set possible values filter from ACLs
            my $ACL = $TicketObject->TicketAcl(
                %{ $Param{GetParam} },
                ReturnType     => 'Ticket',
                ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data           => \%AclData,
                CustomerUserID => $Self->{UserID},
            );

            if ($ACL) {
                my %Filter = $TicketObject->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValues} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }

            my $DataValues = $BackendObject->BuildSelectionDataGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                PossibleValues     => $PossibleValues,
                Value              => $Param{GetParam}{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            ) || $PossibleValues;

            # add dynamic field to the JSONCollector
            push(
                @JSONCollector,
                {
                    Name        => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data        => $DataValues,
                    SelectedID  => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                    Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                    Max         => 100,
                }
            );
        }
        elsif ( $Self->{NameToID}{$CurrentField} eq 'QueueID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            my $Data = $Self->_GetQueues(
                %{ $Param{GetParam} },
            );

            # add Queue to the JSONCollector
            push(
                @JSONCollector,
                {
                    Name         => $Self->{NameToID}{$CurrentField},
                    Data         => $Data,
                    SelectedID   => $Param{GetParam}{ $Self->{NameToID}{$CurrentField} },
                    PossibleNone => 1,
                    Translation  => 0,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }

        elsif ( $Self->{NameToID}{$CurrentField} eq 'StateID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            my $Data = $Self->_GetStates(
                %{ $Param{GetParam} },
            );

            # add State to the JSONCollector
            push(
                @JSONCollector,
                {
                    Name        => 'StateID',
                    Data        => $Data,
                    SelectedID  => $Param{GetParam}{ $Self->{NameToID}{$CurrentField} },
                    Translation => 1,
                    Max         => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }
        elsif ( $Self->{NameToID}{$CurrentField} eq 'PriorityID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            my $Data = $Self->_GetPriorities(
                %{ $Param{GetParam} },
            );

            # add Priority to the JSONCollector
            push(
                @JSONCollector,
                {
                    Name        => $Self->{NameToID}{$CurrentField},
                    Data        => $Data,
                    SelectedID  => $Param{GetParam}{ $Self->{NameToID}{$CurrentField} },
                    Translation => 1,
                    Max         => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }
        elsif ( $Self->{NameToID}{$CurrentField} eq 'ServiceID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            my $Data = $Self->_GetServices(
                %{ $Param{GetParam} },
            );
            $Services = $Data;

            # add Service to the JSONCollector (Use ServiceID from web request)
            push(
                @JSONCollector,
                {
                    Name         => $Self->{NameToID}{$CurrentField},
                    Data         => $Data,
                    SelectedID   => $ParamObject->GetParam( Param => 'ServiceID' ) || '',
                    PossibleNone => 1,
                    Translation  => 0,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }
        elsif ( $Self->{NameToID}{$CurrentField} eq 'SLAID' ) {
            next DIALOGFIELD if $FieldsProcessed{ $Self->{NameToID}{$CurrentField} };

            # if SLA is render before service (by it order in the fields) it needs to create
            # the service list
            if ( !IsHashRefWithData($Services) ) {
                $Services = $Self->_GetServices(
                    %{ $Param{GetParam} },
                );
            }

            my $Data = $Self->_GetSLAs(
                %{ $Param{GetParam} },
                Services  => $Services,
                ServiceID => $ParamObject->GetParam( Param => 'ServiceID' ) || '',
            );

            # add SLA to the JSONCollector (Use SelectedID from web request)
            push(
                @JSONCollector,
                {
                    Name         => $Self->{NameToID}{$CurrentField},
                    Data         => $Data,
                    SelectedID   => $ParamObject->GetParam( Param => 'SLAID' ) || '',
                    PossibleNone => 1,
                    Translation  => 0,
                    Max          => 100,
                },
            );
            $FieldsProcessed{ $Self->{NameToID}{$CurrentField} } = 1;
        }
    }

    my $JSON = $LayoutObject->BuildSelectionJSON( [@JSONCollector] );

    return $LayoutObject->Attachment(
        ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
        Content     => $JSON,
        Type        => 'inline',
        NoCache     => 1,
    );
}

=item _GetParam()

returns the current data state of the submitted information

This contains the following data for the different callers:

    Initial call with selected Process:
        ProcessEntityID
        ActivityDialogEntityID
        DefaultValues for the configured Fields in that ActivityDialog
        DefaultValues for the 4 required Fields Queue State Lock Priority

    First Store call submitting an Activity Dialog:
        ProcessEntityID
        ActivityDialogEntityID
        SubmittedValues for the current ActivityDialog
        ActivityDialog DefaultValues for invisible fields of that ActivityDialog
        DefaultValues for the 4 required Fields Queue State Lock Priority
            if not configured in the ActivityDialog

    ActivityDialog fillout request on existing Ticket:
        ProcessEntityID
        ActivityDialogEntityID
        TicketValues

    ActivityDialog store request or AjaxUpdate request on existing Tickets:
        ProcessEntityID
        ActivityDialogEntityID
        TicketValues for all not-Submitted Values
        Submitted Values

    my $GetParam = _GetParam(
        ProcessEntityID => $ProcessEntityID,
    );

=cut

sub _GetParam {
    my ( $Self, %Param ) = @_;

    #my $IsAJAXUpdate = $Param{AJAX} || '';

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');

    for my $Needed (qw(ProcessEntityID)) {
        if ( !$Param{$Needed} ) {
            $LayoutObject->CustomerFatalError( Message => "Got no $Needed in _GetParam!" );
        }
    }
    my %GetParam;
    my %Ticket;
    my $ProcessEntityID        = $Param{ProcessEntityID};
    my $TicketID               = $ParamObject->GetParam( Param => 'TicketID' );
    my $ActivityDialogEntityID = $ParamObject->GetParam(
        Param => 'ActivityDialogEntityID',
    );
    my $ActivityEntityID;
    my %ValuesGotten;
    my $Value;

    # If we got no ActivityDialogEntityID and no TicketID
    # we have to get the Processes' Startpoint
    if ( !$ActivityDialogEntityID && !$TicketID ) {
        my $ActivityActivityDialog
            = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process')->ProcessStartpointGet(
            ProcessEntityID => $ProcessEntityID,
            );
        if (
            !$ActivityActivityDialog->{ActivityDialog}
            || !$ActivityActivityDialog->{Activity}
            )
        {
            my $Message = "Got no Start ActivityEntityID or Start ActivityDialogEntityID for"
                . " Process: $ProcessEntityID in _GetParam!";

            # does not show header and footer again
            if ( $Self->{IsMainWindow} ) {
                return $LayoutObject->CustomerError(
                    Message => $Message,
                );
            }

            $LayoutObject->CustomerFatalError(
                Message => $Message,
            );
        }
        $ActivityDialogEntityID = $ActivityActivityDialog->{ActivityDialog};
        $ActivityEntityID       = $ActivityActivityDialog->{Activity};
    }

    my $ActivityDialog = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog')->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityDialogEntityID,
        Interface              => 'CustomerInterface',
    );

    if ( !IsHashRefWithData($ActivityDialog) ) {
        return $LayoutObject->CustomerErrorScreen(
            Message => "Couldn't get ActivityDialogEntityID '$ActivityDialogEntityID'!",
            Comment => 'Please contact the admin.',
        );
    }

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # if there is a ticket then is not an AJAX request
    if ($TicketID) {
        %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $TicketID,
            UserID        => $ConfigObject->Get('CustomerPanelUserID'),
            DynamicFields => 1,
        );

        %GetParam = %Ticket;
        if ( !IsHashRefWithData( \%GetParam ) ) {
            $LayoutObject->CustomerFatalError(
                Message => "Couldn't get Ticket for TicketID: $TicketID in _GetParam!",
            );
        }

        $ActivityEntityID = $Ticket{
            'DynamicField_'
                . $ConfigObject->Get("Process::DynamicFieldProcessManagementActivityID")
        };
        if ( !$ActivityEntityID ) {
            $LayoutObject->CustomerFatalError(
                Message =>
                    "Couldn't determine ActivityEntityID. DynamicField or Config isn't set properly!",
            );
        }

    }
    $GetParam{ActivityDialogEntityID} = $ActivityDialogEntityID;
    $GetParam{ActivityEntityID}       = $ActivityEntityID;
    $GetParam{ProcessEntityID}        = $ProcessEntityID;

    # some fields should be skipped for the customer interface
    my $SkipFields = [ 'Owner', 'Responsible', 'Lock', 'PendingTime', 'CustomerID' ];

    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => 'Ticket',
    );

    # get backend object
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $DynamicField = \@CustomerDynamicFields;

    # Get the activitydialogs's Submit Param's or Config Params
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        # some fields should be skipped for the customer interface
        next DIALOGFIELD if ( grep { $_ eq $CurrentField } @{$SkipFields} );

        # Skip if we're working on a field that was already done with or without ID
        if ( $Self->{NameToID}{$CurrentField} && $ValuesGotten{ $Self->{NameToID}{$CurrentField} } )
        {
            next DIALOGFIELD;
        }

        if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldName = $1;

            # Get the Config of the current DynamicField (the first element of the grep result array)
            my $DynamicFieldConfig = ( grep { $_->{Name} eq $DynamicFieldName } @{$DynamicField} )[0];

            if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                my $Message = "DynamicFieldConfig missing for field: $DynamicFieldName!";

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Message,
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Message,
                );
            }

            # Get DynamicField Values
            $Value = $BackendObject->EditFieldValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ParamObject        => $ParamObject,
                LayoutObject       => $LayoutObject,
            );

            # If we got a submitted param, take it and next out
            if (
                defined $Value
                && (
                    $Value eq ''
                    || IsStringWithData($Value)
                    || IsArrayRefWithData($Value)
                    || IsHashRefWithData($Value)
                )
                )
            {
                $GetParam{$CurrentField} = $Value;
                next DIALOGFIELD;
            }

            # If we didn't have a Param Value try the ticket Value
            # next out if it was successful
            if (
                defined $Ticket{$CurrentField}
                && (
                    $Ticket{$CurrentField} eq ''
                    || IsStringWithData( $Ticket{$CurrentField} )
                    || IsArrayRefWithData( $Ticket{$CurrentField} )
                    || IsHashRefWithData( $Ticket{$CurrentField} )
                )
                )
            {
                $GetParam{$CurrentField} = $Ticket{$CurrentField};
                next DIALOGFIELD;
            }

            # If we had neighter submitted nor ticket param get the ActivityDialog's default Value
            # next out if it was successful
            $Value = $ActivityDialog->{Fields}{$CurrentField}{DefaultValue};
            if ($Value) {
                $GetParam{$CurrentField} = $Value;
                next DIALOGFIELD;
            }

            # If we had no submitted, ticket or ActivityDialog default value
            # use the DynamicField's default value and next out
            $Value = $DynamicFieldConfig->{Config}{DefaultValue};
            if ($Value) {
                $GetParam{$CurrentField} = $Value;
                next DIALOGFIELD;
            }

            # if all that failed then the field should not have a defined value otherwise
            # if a value (even empty) is sent, fields like Date or DateTime will mark the field as
            # used with the field display value, this could lead to unwanted field sets,
            # see bug#9159
            next DIALOGFIELD;
        }

        # get article fields
        if ( $CurrentField eq 'Article' ) {

            $GetParam{Subject} = $ParamObject->GetParam( Param => 'Subject' );
            $GetParam{Body}    = $ParamObject->GetParam( Param => 'Body' );
            @{ $GetParam{InformUserID} } = $ParamObject->GetArray(
                Param => 'InformUserID',
            );

            $ValuesGotten{Article} = 1 if ( $GetParam{Subject} && $GetParam{Body} );
        }

        if ( $CurrentField eq 'CustomerID' ) {
            $GetParam{Customer} = $ParamObject->GetParam(
                Param => 'SelectedCustomerUser',
            ) || '';
            $GetParam{CustomerUserID} = $ParamObject->GetParam(
                Param => 'SelectedCustomerUser',
            ) || '';
        }

        # Non DynamicFields
        # 1. try to get the required param
        my $Value = $ParamObject->GetParam( Param => $Self->{NameToID}{$CurrentField} );

        if ($Value) {

            # if we have an ID field make sure the value without ID won't be in the
            # %GetParam Hash any more
            if ( $Self->{NameToID}{$CurrentField} =~ m{(.*)ID$}xms ) {
                $GetParam{$1} = undef;
            }
            $GetParam{ $Self->{NameToID}{$CurrentField} }     = $Value;
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
            next DIALOGFIELD;
        }

        # If we got ticket params, the GetParam Hash was already filled before the loop
        # and we can next out
        if ( $GetParam{ $Self->{NameToID}{$CurrentField} } ) {
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
            next DIALOGFIELD;
        }

        # if no Submitted nore Ticket Param get ActivityDialog Config's Param
        if ( $CurrentField ne 'CustomerID' ) {
            $Value = $ActivityDialog->{Fields}{$CurrentField}{DefaultValue};
        }
        if ($Value) {
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
            $GetParam{$CurrentField} = $Value;
            next DIALOGFIELD;
        }
    }
    REQUIREDFIELDLOOP:
    for my $CurrentField (qw(Queue State Lock Priority)) {
        $Value = undef;
        if ( !$ValuesGotten{ $Self->{NameToID}{$CurrentField} } ) {
            $Value = $ConfigObject->Get("Process::Default$CurrentField");
            if ( !$Value ) {

                my $Message = "Process::Default$CurrentField Config Value missing!";

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Message,
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Message,
                );
            }
            $GetParam{$CurrentField} = $Value;
            $ValuesGotten{ $Self->{NameToID}{$CurrentField} } = 1;
        }
    }

    # get also the IDs for the Required files (if they are not present)
    if ( $GetParam{Queue} && !$GetParam{QueueID} ) {
        $GetParam{QueueID} = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $GetParam{Queue} );
    }
    if ( $GetParam{State} && !$GetParam{StateID} ) {
        $GetParam{StateID} = $Kernel::OM->Get('Kernel::System::State')->StateLookup( State => $GetParam{State} );
    }
    if ( $GetParam{Lock} && !$GetParam{LockID} ) {
        $GetParam{LockID} = $Kernel::OM->Get('Kernel::System::Lock')->LockLookup( Lock => $GetParam{Lock} );
    }
    if ( $GetParam{Priority} && !$GetParam{PriorityID} ) {
        $GetParam{PriorityID} = $Kernel::OM->Get('Kernel::System::Priority')->PriorityLookup(
            Priority => $GetParam{Priority},
        );
    }

    # and finally we'll have the special parameters:
    $GetParam{ResponsibleAll} = $ParamObject->GetParam( Param => 'ResponsibleAll' );
    $GetParam{OwnerAll}       = $ParamObject->GetParam( Param => 'OwnerAll' );

    return \%GetParam;
}

sub _OutputActivityDialog {
    my ( $Self, %Param ) = @_;
    my $TicketID               = $Param{GetParam}{TicketID};
    my $ActivityDialogEntityID = $Param{GetParam}{ActivityDialogEntityID};

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # Check needed parameters:
    # ProcessEntityID only
    # TicketID ActivityDialogEntityID
    if ( !$Param{ProcessEntityID} || ( !$TicketID && !$ActivityDialogEntityID ) ) {
        my $Message = 'Got no ProcessEntityID or TicketID and ActivityDialogEntityID!';

        # does not show header and footer again
        if ( $Self->{IsMainWindow} ) {
            return $LayoutObject->CustomerError(
                Message => $Message,
            );
        }

        $LayoutObject->CustomerFatalError(
            Message => $Message,
        );
    }

    my $ActivityActivityDialog;
    my %Ticket;
    my %Error        = ();
    my %ErrorMessage = ();

    # If we had Errors, we got an Errorhash
    %Error        = %{ $Param{Error} }        if ( IsHashRefWithData( $Param{Error} ) );
    %ErrorMessage = %{ $Param{ErrorMessage} } if ( IsHashRefWithData( $Param{ErrorMessage} ) );

    # get process object
    my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process');
    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');

    if ( !$TicketID ) {
        $ActivityActivityDialog = $ProcessObject->ProcessStartpointGet(
            ProcessEntityID => $Param{ProcessEntityID},
        );

        if ( !IsHashRefWithData($ActivityActivityDialog) ) {
            my $Message = "Can't get StartActivityDialog and StartActivityDialog for the"
                . " ProcessEntityID '$Param{ProcessEntityID}'!";

            # does not show header and footer again
            if ( $Self->{IsMainWindow} ) {
                return $LayoutObject->CustomerError(
                    Message => $Message,
                );
            }

            $LayoutObject->CustomerFatalError(
                Message => $Message,
            );
        }
    }
    else {

        # no AJAX update in this part
        %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $TicketID,
            UserID        => $ConfigObject->Get('CustomerPanelUserID'),
            DynamicFields => 1,
        );

        if ( !IsHashRefWithData( \%Ticket ) ) {
            $LayoutObject->CustomerFatalError(
                Message => "Can't get Ticket '$Param{TicketID}'!",
            );
        }

        my $DynamicFieldProcessID = 'DynamicField_'
            . $ConfigObject->Get('Process::DynamicFieldProcessManagementProcessID');
        my $DynamicFieldActivityID = 'DynamicField_'
            . $ConfigObject->Get('Process::DynamicFieldProcessManagementActivityID');

        if ( !$Ticket{$DynamicFieldProcessID} || !$Ticket{$DynamicFieldActivityID} ) {
            $LayoutObject->CustomerFatalError(
                Message =>
                    "Can't get ProcessEntityID or ActivityEntityID for Ticket '$Param{TicketID}'!",
            );
        }

        $ActivityActivityDialog = {
            Activity       => $Ticket{$DynamicFieldActivityID},
            ActivityDialog => $ActivityDialogEntityID,
        };
    }

    my $Activity = $Kernel::OM->Get('Kernel::System::ProcessManagement::Activity')->ActivityGet(
        Interface        => 'CustomerInterface',
        ActivityEntityID => $ActivityActivityDialog->{Activity}
    );
    if ( !$Activity ) {
        my $Message = "Can't get Activity configuration for ActivityEntityID"
            . " $ActivityActivityDialog->{Activity}!";

        # does not show header and footer again
        if ( $Self->{IsMainWindow} ) {
            return $LayoutObject->CustomerError(
                Message => $Message,
            );
        }

        $LayoutObject->CustomerFatalError(
            Message => $Message,
        );
    }

    my $ActivityDialog = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog')->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityActivityDialog->{ActivityDialog},
        Interface              => 'CustomerInterface',
    );
    if ( !IsHashRefWithData($ActivityDialog) ) {
        my $Message = "Can't get ActivityDialog configuration for ActivityDialogEntityID"
            . " '$ActivityActivityDialog->{ActivityDialog}'!";

        # does not show header and footer again
        if ( $Self->{IsMainWindow} ) {
            return $LayoutObject->CustomerError(
                Message => $Message,
            );
        }

        $LayoutObject->CustomerFatalError(
            Message => $Message,
        );
    }

    # grep out Overwrites if defined on the Activity
    my @OverwriteActivityDialogNumber = grep {
        ref $Activity->{ActivityDialog}{$_} eq 'HASH'
            && $Activity->{ActivityDialog}{$_}{ActivityDialogEntityID}
            && $Activity->{ActivityDialog}{$_}{ActivityDialogEntityID} eq
            $ActivityActivityDialog->{ActivityDialog}
            && IsHashRefWithData( $Activity->{ActivityDialog}{$_}{Overwrite} )
    } keys %{ $Activity->{ActivityDialog} };

    # let the Overwrites Overwrite the ActivityDialog's Hashvalues
    if ( $OverwriteActivityDialogNumber[0] ) {
        %{$ActivityDialog} = (
            %{$ActivityDialog},
            %{ $Activity->{ActivityDialog}{ $OverwriteActivityDialogNumber[0] }{Overwrite} }
        );
    }

    # Add PageHeader, Navbar, Formheader (Process/ActivityDialogHeader)
    my $Output;
    my $MainBoxClass;

    if ( !$Self->{IsMainWindow} ) {
        $Output = $LayoutObject->CustomerHeader(
            Type  => 'Small',
            Value => $Ticket{Number},
        );

        # display given notify messages if this is not an ajax request
        if ( IsArrayRefWithData( $Param{Notify} ) ) {

            for my $NotifyString ( @{ $Param{Notify} } ) {
                $Output .= $LayoutObject->Notify(
                    Data => $NotifyString,
                );
            }
        }

        $LayoutObject->Block(
            Name => 'Header',
            Data => {
                Name =>
                    $LayoutObject->{LanguageObject}->Translate( $ActivityDialog->{Name} )
                    || '',
                }
        );
    }
    elsif ( $Self->{IsMainWindow} && IsHashRefWithData( \%Error ) ) {

        # add rich text editor
        if ( $LayoutObject->{BrowserRichText} ) {

            # use height/width defined for this screen
            $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
            $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

            $LayoutObject->Block(
                Name => 'RichText',
                Data => \%Param,
            );
        }

        # display complete header and nav bar in ajax dialogs when there is a server error
        $Output = $LayoutObject->CustomerHeader();
        $Output .= $LayoutObject->CustomerNavigationBar();

        # display original header texts (the process list maybe is not necessary)
        $Output .= $LayoutObject->Output(
            TemplateFile => 'CustomerTicketProcess',
            Data         => {},
        );

        # set the MainBox class to add correct borders to the screen
        $MainBoxClass = 'MainBox';
    }

    # display process iformation
    if ( $Self->{IsMainWindow} ) {

        # get process data
        my $Process = $ProcessObject->ProcessGet(
            ProcessEntityID => $Param{ProcessEntityID},
        );

        # output main process information
        $LayoutObject->Block(
            Name => 'ProcessInfoSidebar',
            Data => {
                Process        => $Process->{Name}        || '',
                Activity       => $Activity->{Name}       || '',
                ActivityDialog => $ActivityDialog->{Name} || '',
            },
        );

        # output activity dilalog short description (if any)
        if (
            defined $ActivityDialog->{DescriptionShort}
            && $ActivityDialog->{DescriptionShort} ne ''
            )
        {
            $LayoutObject->Block(
                Name => 'ProcessInfoSidebarActivityDialogDesc',
                Data => {
                    ActivityDialogDescription => $ActivityDialog->{DescriptionShort} || '',
                },
            );
        }
    }

    # show descriptions
    if ( $ActivityDialog->{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => 'DescriptionShort',
            Data => {
                DescriptionShort
                    => $LayoutObject->{LanguageObject}->Translate(
                    $ActivityDialog->{DescriptionShort},
                    ),
            },
        );
    }
    if ( $ActivityDialog->{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'DescriptionLong',
            Data => {
                DescriptionLong
                    => $LayoutObject->{LanguageObject}->Translate(
                    $ActivityDialog->{DescriptionLong},
                    ),
            },
        );
    }

    # show close & cancel link if neccessary
    if ( !$Self->{IsMainWindow} ) {
        if ( $Param{RenderLocked} ) {
            $LayoutObject->Block(
                Name => 'PropertiesLock',
                Data => {
                    %Param,
                    TicketID => $TicketID,
                },
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'CancelLink',
            );
        }
    }

    $Output .= $LayoutObject->Output(
        TemplateFile => 'ProcessManagement/CustomerActivityDialogHeader',
        Data         => {
            FormName               => 'ActivityDialogDialog' . $ActivityActivityDialog->{ActivityDialog},
            FormID                 => $Self->{FormID},
            Subaction              => 'StoreActivityDialog',
            TicketID               => $Ticket{TicketID} || '',
            ActivityDialogEntityID => $ActivityActivityDialog->{ActivityDialog},
            ProcessEntityID        => $Param{ProcessEntityID}
                || $Ticket{
                'DynamicField_'
                    . $ConfigObject->Get(
                    'Process::DynamicFieldProcessManagementProcessID'
                    )
                },
            IsMainWindow => $Self->{IsMainWindow},
            MainBoxClass => $MainBoxClass || '',
        },
    );

    my %RenderedFields = ();

    # get the list of fields where the AJAX loader icon should appear on AJAX updates triggered
    # by ActivityDialog fields
    my $AJAXUpdatableFields = $Self->_GetAJAXUpdatableFields(
        ActivityDialogFields => $ActivityDialog->{Fields},
    );

    # some fields should be skipped for the customer interface
    my $SkipFields = [ 'Owner', 'Responsible', 'Lock', 'PendingTime', 'CustomerID' ];

    # Loop through ActivityDialogFields and render their output
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        # some fields should be skipped for the customer interface
        next DIALOGFIELD if ( grep { $_ eq $CurrentField } @{$SkipFields} );

        if ( !IsHashRefWithData( $ActivityDialog->{Fields}{$CurrentField} ) ) {
            my $Message = "Can't get data for Field '$CurrentField' of ActivityDialog"
                . " '$ActivityActivityDialog->{ActivityDialog}'!";

            # does not show header and footer again
            if ( $Self->{IsMainWindow} ) {
                return $LayoutObject->CustomerError(
                    Message => $Message,
                );
            }

            $LayoutObject->CustomerFatalError(
                Message => $Message,
            );
        }

        my %FieldData = %{ $ActivityDialog->{Fields}{$CurrentField} };

        # We render just visible ActivityDialogFields
        next DIALOGFIELD if !$FieldData{Display};

        # render DynamicFields
        if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldName = $1;
            my $Response         = $Self->_RenderDynamicField(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $DynamicFieldName,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                ErrorMessage        => \%ErrorMessage || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                AJAXUpdatableFields => $AJAXUpdatableFields,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{$CurrentField} = 1;

        }

        # render State
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'StateID' )
        {

            # We don't render Fields twice,
            # if there was already a Config without ID, skip this field
            # next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderState(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                AJAXUpdatableFields => $AJAXUpdatableFields,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }

        # render Queue
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'QueueID' )
        {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderQueue(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                AJAXUpdatableFields => $AJAXUpdatableFields,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }

        # render Priority
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'PriorityID' )
        {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderPriority(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                AJAXUpdatableFields => $AJAXUpdatableFields,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }

        # render Service
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'ServiceID' )
        {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderService(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                AJAXUpdatableFields => $AJAXUpdatableFields,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{$CurrentField} = 1;
        }

        # render SLA
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'SLAID' )
        {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderSLA(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                AJAXUpdatableFields => $AJAXUpdatableFields,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }

        # render Title
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'Title' ) {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderTitle(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{$CurrentField} = 1;
        }

        # render Article
        elsif (
            $Self->{NameToID}->{$CurrentField} eq 'Article'
            )
        {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderArticle(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                InformAgents        => $ActivityDialog->{Fields}->{Article}->{Config}->{InformAgents},
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{$CurrentField} = 1;
        }

        # render Type
        elsif ( $Self->{NameToID}->{$CurrentField} eq 'TypeID' )
        {

            # We don't render Fields twice,
            # if there was already a Config without ID, skip this field
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderType(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                DescriptionLong     => $ActivityDialog->{Fields}{$CurrentField}{DescriptionLong},
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                AJAXUpdatableFields => $AJAXUpdatableFields,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ( $Self->{IsMainWindow} ) {
                    return $LayoutObject->CustomerError(
                        Message => $Response->{Message},
                    );
                }

                $LayoutObject->CustomerFatalError(
                    Message => $Response->{Message},
                );
            }

            $Output .= $Response->{HTML};

            $RenderedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
        }
    }

    my $FooterCSSClass = 'Footer';

    if ( $Self->{IsAjaxRequest} ) {

        # Due to the initial loading of
        # the first ActivityDialog after Process selection
        # we have to bind the AjaxUpdate Function on
        # the selects, so we get the complete JSOnDocumentComplete code
        # and deliver it in the FooterJS block.
        # This Javascript Part is executed in
        # CustomerTicketProcess.tt
        $LayoutObject->Block(
            Name => 'FooterJS',
            Data => {},
        );

        $FooterCSSClass = 'Centered';
    }

    # set submit button data
    my $ButtonText  = 'Submit';
    my $ButtonTitle = 'Save';
    my $ButtonID    = 'Submit' . $ActivityActivityDialog->{ActivityDialog};
    if ( $ActivityDialog->{SubmitButtonText} ) {
        $ButtonText  = $ActivityDialog->{SubmitButtonText};
        $ButtonTitle = $ActivityDialog->{SubmitButtonText};
    }

    $LayoutObject->Block(
        Name => 'Footer',
        Data => {
            FooterCSSClass => $FooterCSSClass,
            ButtonText     => $ButtonText,
            ButtonTitle    => $ButtonTitle,
            ButtonID       => $ButtonID
        },
    );

    if ( $ActivityDialog->{SubmitAdviceText} ) {
        $LayoutObject->Block(
            Name => 'SubmitAdviceText',
            Data => {
                AdviceText => $ActivityDialog->{SubmitAdviceText},
            },
        );
    }

    # reload parent window
    if ( $Param{ParentReload} ) {
        $LayoutObject->Block(
            Name => 'ParentReload',
        );
    }

    # Add the FormFooter
    $Output .= $LayoutObject->Output(
        TemplateFile => 'ProcessManagement/CustomerActivityDialogFooter',
        Data         => {},
    );

    # display regular footer only in non-ajax case
    if ( !$Self->{IsAjaxRequest} ) {
        $Output .= $LayoutObject->CustomerFooter( Type => $Self->{IsMainWindow} ? '' : 'Small' );
    }

    return $Output;
}

sub _RenderDynamicField {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID FieldName)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderDynamicField!",
            };
        }
    }

    # get backend object
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => 'Ticket',
    );

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $DynamicField = \@CustomerDynamicFields;

    my $DynamicFieldConfig = ( grep { $_->{Name} eq $Param{FieldName} } @{$DynamicField} )[0];

    my $PossibleValuesFilter;

    my $IsACLReducible = $BackendObject->HasBehavior(
        DynamicFieldConfig => $DynamicFieldConfig,
        Behavior           => 'IsACLReducible',
    );

    if ($IsACLReducible) {

        # get PossibleValues
        my $PossibleValues = $BackendObject->PossibleValuesGet(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        # All Ticket DynamicFields
        # used for ACL checking
        my %DynamicFieldCheckParam = map { $_ => $Param{GetParam}{$_} }
            grep {m{^DynamicField_}xms} ( keys %{ $Param{GetParam} } );

        # check if field has PossibleValues property in its configuration
        if ( IsHashRefWithData($PossibleValues) ) {

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
            my $ACL          = $TicketObject->TicketAcl(
                %{ $Param{GetParam} },
                DynamicField   => \%DynamicFieldCheckParam,
                Action         => $Self->{Action},
                ReturnType     => 'Ticket',
                ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data           => \%AclData,
                CustomerUserID => $Self->{UserID},
            );
            if ($ACL) {
                my %Filter = $TicketObject->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }
        }
    }

    my $ServerError;
    my $ErrorMessage;
    if ( IsHashRefWithData( $Param{Error} ) ) {
        if (
            defined $Param{Error}->{ $Param{FieldName} }
            && $Param{Error}->{ $Param{FieldName} } ne ''
            )
        {
            $ServerError = 1;
            if (
                defined $Param{ErrorMessage}->{ $Param{FieldName} }
                && $Param{ErrorMessage}->{ $Param{FieldName} } ne ''
                )
            {
                $ErrorMessage = $Param{ErrorMessage}->{ $Param{FieldName} };
            }
        }
    }

    # get layout objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $DynamicFieldHTML = $BackendObject->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,
        PossibleValuesFilter => $PossibleValuesFilter,
        Value                => $Param{GetParam}{ 'DynamicField_' . $Param{FieldName} },
        LayoutObject         => $LayoutObject,
        ParamObject          => $Kernel::OM->Get('Kernel::System::Web::Request'),
        AJAXUpdate           => 1,
        Mandatory            => $Param{ActivityDialogField}->{Display} == 2,
        UpdatableFields      => $Param{AJAXUpdatableFields},
        ServerError          => $ServerError,
        ErrorMessage         => $ErrorMessage,
    );

    my %Data = (
        Name    => $DynamicFieldHTML->{Name},
        Label   => $DynamicFieldHTML->{Label},
        Content => $DynamicFieldHTML->{Field},
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:DynamicField',
        Data => \%Data,
    );
    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock}
                || 'rw:DynamicField:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }
    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:DynamicField:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/DynamicField' ),
    };
}

sub _RenderTitle {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderTitle!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderTitle!",
        };
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Title"),
        FieldID          => 'Title',
        FormID           => $Param{FormID},
        Value            => $Param{GetParam}{Title},
        Name             => 'Title',
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    # output server errors
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'Title'} ) {
        $Data{ServerError} = 'ServerError';
    }

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Title',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Title:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Title:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Title' ),
    };

}

sub _RenderArticle {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID Ticket)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderArticle!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderArticle!",
        };
    }

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Name             => 'Article',
        MandatoryClass   => '',
        ValidateRequired => '',
        Subject          => $Param{GetParam}{Subject},
        Body             => $Param{GetParam}{Body},
        LabelSubject     => $Param{ActivityDialogField}->{Config}->{LabelSubject}
            || $LayoutObject->{LanguageObject}->Translate("Subject"),
        LabelBody => $Param{ActivityDialogField}->{Config}->{LabelBody}
            || $LayoutObject->{LanguageObject}->Translate("Text"),
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    # output server errors
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'ArticleSubject'} ) {
        $Data{SubjectServerError} = 'ServerError';
    }
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'ArticleBody'} ) {
        $Data{BodyServerError} = 'ServerError';
    }

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Article',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpanSubject',
            Data => {},
        );
        $LayoutObject->Block(
            Name => 'LabelSpanBody',
            Data => {},
        );
    }

    # add rich text editor
    if ( $LayoutObject->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

        $LayoutObject->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => 'rw:Article:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Article:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    if ( $Param{InformAgents} ) {

        my %ShownUsers;
        my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        my $GID = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID( QueueID => $Param{Ticket}->{QueueID} );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->GroupMemberList(
            GroupID => $GID,
            Type    => 'note',
            Result  => 'HASH',
            Cached  => 1,
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
        }
        $Param{OptionStrg} = $LayoutObject->BuildSelection(
            Data       => \%ShownUsers,
            SelectedID => '',
            Name       => 'InformUserID',
            Multiple   => 1,
            Size       => 3,
        );
        $LayoutObject->Block(
            Name => 'rw:Article:InformAgent',
            Data => \%Param,
        );
    }

    # get all attachments meta data
    my @Attachments = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # show attachments
    ATTACHMENT:
    for my $Attachment (@Attachments) {
        if (
            $Attachment->{ContentID}
            && $LayoutObject->{BrowserRichText}
            && ( $Attachment->{ContentType} =~ /image/i )
            && ( $Attachment->{Disposition} eq 'inline' )
            )
        {
            next ATTACHMENT;
        }
        $LayoutObject->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Article' ),
    };
}

sub _RenderCustomer {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderResponsible!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderCustomer!",
        };
    }

    my $AutoCompleteConfig = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::CustomerSearchAutoComplete');

    my %CustomerUserData = ();

    my $SubmittedCustomerUserID = $Param{GetParam}{CustomerUserID};

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        LabelCustomerUser => $LayoutObject->{LanguageObject}->Translate("Customer user"),
        LabelCustomerID   => $LayoutObject->{LanguageObject}->Translate("CustomerID"),
        FormID            => $Param{FormID},
        MandatoryClass    => '',
        ValidateRequired  => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    # output server errors
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{CustomerUserID} ) {
        $Data{CustomerUserIDServerError} = 'ServerError';
    }
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{CustomerID} ) {
        $Data{CustomerIDServerError} = 'ServerError';
    }

    # set some customer search autocomplete properties
    $LayoutObject->Block(
        Name => 'CustomerSearchAutoComplete',
        Data => {
            minQueryLength      => $AutoCompleteConfig->{MinQueryLength}      || 2,
            queryDelay          => $AutoCompleteConfig->{QueryDelay}          || 100,
            maxResultsDisplayed => $AutoCompleteConfig->{MaxResultsDisplayed} || 20,
            ActiveAutoComplete  => $AutoCompleteConfig->{Active},
        },
    );

    if (
        ( IsHashRefWithData( $Param{Ticket} ) && $Param{Ticket}->{CustomerUserID} )
        || $SubmittedCustomerUserID
        )
    {
        %CustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $SubmittedCustomerUserID
                || $Param{Ticket}{CustomerUserID},
        );
    }

    # show customer field as "FirstName Lastname" <MailAddress>
    if ( IsHashRefWithData( \%CustomerUserData ) ) {
        $Data{CustomerUserID} = "\"$CustomerUserData{UserFirstname} " .
            "$CustomerUserData{UserLastname}\" <$CustomerUserData{UserEmail}>";
        $Data{CustomerID}           = $CustomerUserData{UserCustomerID} || '';
        $Data{SelectedCustomerUser} = $CustomerUserData{UserID}         || '';
    }

    # set fields that will get an AJAX loader icon when this field changes
    my $JSON = $LayoutObject->JSONEncode(
        Data     => $Param{AJAXUpdatableFields},
        NoQuotes => 0,
    );
    $Data{FieldsToUpdate} = $JSON;

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Customer',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpanCustomerUser',
            Data => {},
        );
        $LayoutObject->Block(
            Name => 'LabelSpanCustomerID',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Customer:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Customer:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Customer' ),
    };
}

sub _RenderSLA {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderSLA!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderSLA!",
        };
    }
    my $Services = $Self->_GetServices(
        %{ $Param{GetParam} },
    );

    my $SLAs = $Self->_GetSLAs(
        %{ $Param{GetParam} },
        Services => $Services,
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("SLA"),
        FieldID          => 'SLAID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get SLA object
    my $SLAObject = $Kernel::OM->Get('Kernel::System::SLA');

    my $SLAIDParam = $Param{GetParam}{SLAID};
    if ($SLAIDParam) {
        $SelectedValue = $SLAObject->SLALookup( SLAID => $SLAIDParam );
    }

    if ( $Param{FieldName} eq 'SLA' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $SLAObject->SLALookup(
                    SLA => $Param{ActivityDialogField}->{DefaultValue},
                );
            }

            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $SLAObject->SLALookup(
                    SLA => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{SLA};
    }

    # set server errors
    my $ServerError;
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'SLAID'} ) {
        $ServerError = 'ServerError';
    }

    # build SLA string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $SLAs,
        Name          => 'SLAID',
        SelectedValue => $SelectedValue,
        PossibleNone  => 1,
        Sort          => 'AlphanumericValue',
        Translation   => 0,
        Class         => $ServerError,
        Max           => 200,
    );

    # set fields that will get an AJAX loader icon when this field changes
    $Data{FieldsToUpdate} = $Self->_GetFieldsToUpdateStrg(
        TriggerField        => 'SLAID',
        AJAXUpdatableFields => $Param{AJAXUpdatableFields},
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:SLA',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:SLA:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:SLA:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/SLA' ),
    };
}

sub _RenderService {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderService!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderService!"
        };
    }

    my $Services = $Self->_GetServices(
        %{ $Param{GetParam} },
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Service"),
        FieldID          => 'ServiceID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get service object
    my $ServiceObject = $Kernel::OM->Get('Kernel::System::Service');

    my $ServiceIDParam = $Param{GetParam}{ServiceID};
    if ($ServiceIDParam) {
        $SelectedValue = $ServiceObject->ServiceLookup(
            ServiceID => $ServiceIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Service' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $ServiceObject->ServiceLookup(
                    Name => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $ServiceObject->ServiceLookup(
                    Service => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Service};
    }

    # set server errors
    my $ServerError;
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'ServiceID'} ) {
        $ServerError = 'ServerError';
    }

    # get list type
    my $TreeView = 0;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # build Service string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Services,
        Name          => 'ServiceID',
        Class         => $ServerError,
        SelectedValue => $SelectedValue,
        PossibleNone  => 1,
        TreeView      => $TreeView,
        Sort          => 'TreeView',
        Translation   => 0,
        Max           => 200,
    );

    # set fields that will get an AJAX loader icon when this field changes
    $Data{FieldsToUpdate} = $Self->_GetFieldsToUpdateStrg(
        TriggerField        => 'ServiceID',
        AJAXUpdatableFields => $Param{AJAXUpdatableFields},
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Service',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Service:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Service:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Service' ),
    };

}

sub _RenderPriority {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderPriority!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderPriority!",
        };
    }

    my $Priorities = $Self->_GetPriorities(
        %{ $Param{GetParam} },
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Priority"),
        FieldID          => 'PriorityID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get priority object
    my $PriorityObject = $Kernel::OM->Get('Kernel::System::Priority');

    my $PriorityIDParam = $Param{GetParam}{PriorityID};
    if ($PriorityIDParam) {
        $SelectedValue = $PriorityObject->PriorityLookup(
            PriorityID => $PriorityIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Priority' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            $SelectedValue = $PriorityObject->PriorityLookup(
                Priority => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            $SelectedValue = $PriorityObject->PriorityLookup(
                PriorityID => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Priority};
    }

    # set server errors
    my $ServerError;
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'PriorityID'} ) {
        $ServerError = 'ServerError';
    }

    # build next Priorities string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Priorities,
        Name          => 'PriorityID',
        Translation   => 1,
        SelectedValue => $SelectedValue,
        Class         => $ServerError,
    );

    # set fields that will get an AJAX loader icon when this field changes
    $Data{FieldsToUpdate} = $Self->_GetFieldsToUpdateStrg(
        TriggerField        => 'PriorityID',
        AJAXUpdatableFields => $Param{AJAXUpdatableFields},
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Priority',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Priority:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Priority:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Priority' ),
    };
}

sub _RenderQueue {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderQueue!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderQueue!",
        };
    }

    my $Queues = $Self->_GetQueues(
        %{ $Param{GetParam} },
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("To queue"),
        FieldID          => 'QueueID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }
    my $SelectedValue;

    # get queue object
    my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

    # if we got QueueID as Param from the GUI
    my $QueueIDParam = $Param{GetParam}{QueueID};
    if ($QueueIDParam) {
        $SelectedValue = $QueueObject->QueueLookup(
            QueueID => $QueueIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Queue' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            $SelectedValue = $QueueObject->QueueLookup(
                Queue => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            $SelectedValue = $QueueObject->QueueLookup(
                QueueID => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Queue};
    }

    # set server errors
    my $ServerError;
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'QueueID'} ) {
        $ServerError = 'ServerError';
    }

    # get list type
    my $TreeView = 0;
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # build next queues string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Queues,
        Name          => 'QueueID',
        Translation   => 1,
        SelectedValue => $SelectedValue,
        Class         => $ServerError,
        TreeView      => $TreeView,
        Sort          => 'TreeView',
        PossibleNone  => 1,
    );

    $Data{FieldsToUpdate} = $Self->_GetFieldsToUpdateStrg(
        TriggerField        => 'QueueID',
        AJAXUpdatableFields => $Param{AJAXUpdatableFields},
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Queue',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Queue:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Queue:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Queue' ),
    };
}

sub _RenderState {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderState!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderState!",
        };
    }

    my $States = $Self->_GetStates( %{ $Param{Ticket} } );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Next ticket state"),
        FieldID          => 'StateID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }
    my $SelectedValue;

    # get state object
    my $StateObject = $Kernel::OM->Get('Kernel::System::State');

    my $StateIDParam = $Param{GetParam}{StateID};
    if ($StateIDParam) {
        $SelectedValue = $StateObject->StateLookup( StateID => $StateIDParam );
    }

    if ( $Param{FieldName} eq 'State' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            $SelectedValue = $StateObject->StateLookup(
                State => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            $SelectedValue = $StateObject->StateLookup(
                StateID => $Param{ActivityDialogField}->{DefaultValue} || '',
            );
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{State};
    }

    # set server errors
    my $ServerError;
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'StateID'} ) {
        $ServerError = 'ServerError';
    }

    # build next states string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $States,
        Name          => 'StateID',
        Translation   => 1,
        SelectedValue => $SelectedValue,
        Class         => $ServerError,
    );

    # set fields that will get an AJAX loader icon when this field changes
    $Data{FieldsToUpdate} = $Self->_GetFieldsToUpdateStrg(
        TriggerField        => 'StateID',
        AJAXUpdatableFields => $Param{AJAXUpdatableFields},
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:State',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:State:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:State:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/State' ),
    };
}

sub _RenderType {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(FormID)) {
        if ( !$Param{$Needed} ) {
            return {
                Success => 0,
                Message => "Got no $Needed in _RenderType!",
            };
        }
    }
    if ( !IsHashRefWithData( $Param{ActivityDialogField} ) ) {
        return {
            Success => 0,
            Message => "Got no ActivityDialogField in _RenderType!"
        };
    }

    my $Types = $Self->_GetTypes(
        %{ $Param{GetParam} },
    );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data = (
        Label            => $LayoutObject->{LanguageObject}->Translate("Type"),
        FieldID          => 'TypeID',
        FormID           => $Param{FormID},
        MandatoryClass   => '',
        ValidateRequired => '',
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{MandatoryClass}   = 'Mandatory';
    }

    my $SelectedValue;

    # get type object
    my $TypeObject = $Kernel::OM->Get('Kernel::System::Type');

    my $TypeIDParam = $Param{GetParam}{TypeID};
    if ($TypeIDParam) {
        $SelectedValue = $TypeObject->TypeLookup(
            TypeID => $TypeIDParam,
        );
    }

    if ( $Param{FieldName} eq 'Type' ) {

        if ( !$SelectedValue ) {

            # Fetch DefaultValue from Config
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $TypeObject->TypeLookup(
                    Type => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
            if ($SelectedValue) {
                $SelectedValue = $Param{ActivityDialogField}->{DefaultValue};
            }
        }
    }
    else {
        if ( !$SelectedValue ) {
            if (
                defined $Param{ActivityDialogField}->{DefaultValue}
                && $Param{ActivityDialogField}->{DefaultValue} ne ''
                )
            {
                $SelectedValue = $TypeObject->TypeLookup(
                    Type => $Param{ActivityDialogField}->{DefaultValue},
                );
            }
        }
    }

    # Get TicketValue
    if ( IsHashRefWithData( $Param{Ticket} ) && !$SelectedValue ) {
        $SelectedValue = $Param{Ticket}->{Type};
    }

    # set server errors
    my $ServerError;
    if ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'TypeID'} ) {
        $ServerError = 'ServerError';
    }

    # build Service string
    $Data{Content} = $LayoutObject->BuildSelection(
        Data          => $Types,
        Name          => 'TypeID',
        Class         => $ServerError,
        SelectedValue => $SelectedValue,
        PossibleNone  => 1,
        Sort          => 'AlphanumericValue',
        Translation   => 0,
        Max           => 200,
    );

    # set fields that will get an AJAX loader icon when this field changes
    $Data{FieldsToUpdate} = $Self->_GetFieldsToUpdateStrg(
        TriggerField        => 'TypeID',
        AJAXUpdatableFields => $Param{AJAXUpdatableFields},
    );

    $LayoutObject->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Type',
        Data => \%Data,
    );

    # set mandatory label marker
    if ( $Data{MandatoryClass} && $Data{MandatoryClass} ne '' ) {
        $LayoutObject->Block(
            Name => 'LabelSpan',
            Data => {},
        );
    }

    if ( $Param{DescriptionShort} ) {
        $LayoutObject->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Type:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    if ( $Param{DescriptionLong} ) {
        $LayoutObject->Block(
            Name => 'rw:Type:DescriptionLong',
            Data => {
                DescriptionLong => $Param{DescriptionLong},
            },
        );
    }

    return {
        Success => 1,
        HTML    => $LayoutObject->Output( TemplateFile => 'ProcessManagement/Type' ),
    };
}

sub _StoreActivityDialog {
    my ( $Self, %Param ) = @_;

    my $TicketID = $Param{GetParam}{TicketID};
    my $ProcessStartpoint;
    my %Ticket;
    my $ProcessEntityID;
    my $ActivityEntityID;
    my %Error;
    my %ErrorMessage;

    my %TicketParam;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my $ActivityDialogEntityID = $Param{GetParam}{ActivityDialogEntityID};
    if ( !$ActivityDialogEntityID ) {
        $LayoutObject->CustomerFatalError(
            Message => "ActivityDialogEntityID missing!",
        );
    }

    my $ActivityDialog = $Kernel::OM->Get('Kernel::System::ProcessManagement::ActivityDialog')->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityDialogEntityID,
        Interface              => 'CustomerInterface',
    );

    if ( !IsHashRefWithData($ActivityDialog) ) {
        $LayoutObject->CustomerFatalError(
            Message => "Couldn't get Config for ActivityDialogEntityID '$ActivityDialogEntityID'!",
        );
    }

    # If is an action about attachments
    my $IsUpload = 0;

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # attachment delete
    my @AttachmentIDs = map {
        my ($ID) = $_ =~ m{ \A AttachmentDelete (\d+) \z }xms;
        $ID ? $ID : ();
    } $ParamObject->GetParamNames();

    # get upload chache object
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    COUNT:
    for my $Count ( reverse sort @AttachmentIDs ) {
        my $Delete = $ParamObject->GetParam( Param => "AttachmentDelete$Count" );
        next COUNT if !$Delete;
        %Error = ();
        $Error{AttachmentDelete} = 1;
        $UploadCacheObject->FormIDRemoveFile(
            FormID => $Self->{FormID},
            FileID => $Count,
        );
        $IsUpload = 1;
    }

    # attachment upload
    if ( $ParamObject->GetParam( Param => 'AttachmentUpload' ) ) {
        $IsUpload                = 1;
        %Error                   = ();
        $Error{AttachmentUpload} = 1;
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );
        $UploadCacheObject->FormIDAddFile(
            FormID      => $Self->{FormID},
            Disposition => 'attachment',
            %UploadStuff,
        );
    }

    # get backend object
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # some fields should be skipped for the customer interface
    my $SkipFields = [ 'Owner', 'Responsible', 'Lock', 'PendingTime', 'CustomerID' ];

    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => 'Ticket',
    );

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $DynamicField = \@CustomerDynamicFields;

    if ( !$IsUpload ) {

        # check each Field of an Activity Dialog and fill the error hash if something goes horribly wrong
        my %CheckedFields;
        DIALOGFIELD:
        for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

            # some fields should be skipped for the customer interface
            next DIALOGFIELD if ( grep { $_ eq $CurrentField } @{$SkipFields} );

            if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
                my $DynamicFieldName = $1;

                # Get the Config of the current DynamicField (the first element of the grep result array)
                my $DynamicFieldConfig = ( grep { $_->{Name} eq $DynamicFieldName } @{$DynamicField} )[0];

                if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                    $LayoutObject->CustomerFatalError(
                        Message => "DynamicFieldConfig missing for field: $DynamicFieldName!",
                    );
                }

                # Will be extended lateron for ACL Checking:
                my $PossibleValuesFilter;

                # Check DynamicField Values
                my $ValidationResult = $BackendObject->EditFieldValueValidate(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    ParamObject          => $ParamObject,
                    Mandatory            => $ActivityDialog->{Fields}{$CurrentField}{Display} == 2,
                );

                if ( !IsHashRefWithData($ValidationResult) ) {
                    $LayoutObject->CustomerFatalError(
                        Message =>
                            "Could not perform validation on field $DynamicFieldConfig->{Label}!",
                    );
                }

                if ( $ValidationResult->{ServerError} ) {
                    $Error{ $DynamicFieldConfig->{Name} } = 1;
                    $ErrorMessage{ $DynamicFieldConfig->{Name} } = $ValidationResult->{ErrorMessage} || '';
                }

                # if we had an invisible field, use config's default value
                if ( $ActivityDialog->{Fields}{$CurrentField}{Display} == 0 ) {
                    $TicketParam{$CurrentField} = $ActivityDialog->{Fields}{$CurrentField}{DefaultValue}
                        || '';
                }

                # else take the DynamicField Value
                else {
                    $TicketParam{$CurrentField} =
                        $BackendObject->EditFieldValueGet(
                        DynamicFieldConfig => $DynamicFieldConfig,
                        ParamObject        => $ParamObject,
                        LayoutObject       => $LayoutObject,
                        );
                }

                # In case of DynamicFields there is no NameToID translation
                # so just take the DynamicField name
                $CheckedFields{$CurrentField} = 1;
            }
            elsif (
                $Self->{NameToID}->{$CurrentField} eq 'CustomerID'
                || $Self->{NameToID}->{$CurrentField} eq 'CustomerUserID'
                )
            {

                next DIALOGFIELD if $CheckedFields{ $Self->{NameToID}{'CustomerID'} };

                my $CustomerID = $Param{GetParam}{CustomerID} || $Self->{UserCustomerID};
                if ( !$CustomerID ) {
                    $Error{'CustomerID'} = 1;
                }
                $TicketParam{CustomerID} = $CustomerID;

                # Unfortunately TicketCreate needs 'CustomerUser' as param instead of 'CustomerUserID'
                my $CustomerUserID = $ParamObject->GetParam( Param => 'SelectedCustomerUser' )
                    || $Self->{UserID};
                if ( !$CustomerUserID ) {
                    $CustomerUserID = $ParamObject->GetParam( Param => 'SelectedUserID' );
                }
                if ( !$CustomerUserID ) {
                    $Error{'CustomerUserID'} = 1;
                }
                else {
                    $TicketParam{CustomerUser} = $CustomerUserID;
                }
                $CheckedFields{ $Self->{NameToID}{'CustomerID'} }     = 1;
                $CheckedFields{ $Self->{NameToID}{'CustomerUserID'} } = 1;

            }
            else {

                # skip if we've already checked ID or Name
                next DIALOGFIELD if $CheckedFields{ $Self->{NameToID}->{$CurrentField} };

                my $Result = $Self->_CheckField(
                    Field => $Self->{NameToID}->{$CurrentField},
                    %{ $ActivityDialog->{Fields}{$CurrentField} },
                );

                if ( !$Result && $ActivityDialog->{Fields}{$CurrentField}->{Display} == 2 ) {

                    # special case for Article (Subject & Body)
                    if ( $CurrentField eq 'Article' ) {
                        for my $ArticlePart (qw(Subject Body)) {
                            if ( !$Param{GetParam}->{$ArticlePart} ) {

                                # set error for each part (if any)
                                $Error{ 'Article' . $ArticlePart } = 1;
                            }
                        }
                    }

                    # all other fields
                    else {
                        $Error{ $Self->{NameToID}->{$CurrentField} } = 1;
                    }
                }
                elsif ($Result) {
                    $TicketParam{ $Self->{NameToID}->{$CurrentField} } = $Result;
                }
                $CheckedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
            }
        }
    }

    # get needed objects
    my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::Process');
    my $ConfigObject  = $Kernel::OM->Get('Kernel::Config');
    my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');

    my $NewTicketID;
    if ( !$TicketID ) {

        $ProcessEntityID = $Param{GetParam}{ProcessEntityID};
        if ( !$ProcessEntityID )
        {
            return $LayoutObject->CustomerFatalError(
                Message => "Missing ProcessEntityID, check your ActivityDialogHeader.tt!",
            );
        }

        $ProcessStartpoint = $ProcessObject->ProcessStartpointGet(
            ProcessEntityID => $Param{ProcessEntityID},
        );

        if (
            !$ProcessStartpoint
            || !IsHashRefWithData($ProcessStartpoint)
            || !$ProcessStartpoint->{Activity} || !$ProcessStartpoint->{ActivityDialog}
            )
        {
            $LayoutObject->CustomerFatalError(
                Message => "No StartActivityDialog or StartActivityDialog for Process"
                    . " '$Param{ProcessEntityID}' configured!",
            );
        }

        $ActivityEntityID = $ProcessStartpoint->{Activity};

        NEEDEDLOOP:
        for my $Needed (qw(Queue State Lock Priority)) {

            if ( !$TicketParam{ $Self->{NameToID}->{$Needed} } ) {

                # if a required field has no value call _CheckField as filed is hidden
                # (No Display param = Display => 0) and no DefaultValue, to use global default as
                # fallback. One reason for this to happen is that ActivityDialog DefaultValue tried
                # to set before, was not valid.
                my $Result = $Self->_CheckField(
                    Field => $Self->{NameToID}->{$Needed},
                );

                if ( !$Result ) {
                    $Error{ $Self->{NameToID}->{$Needed} } = ' ServerError';
                }
                elsif ($Result) {
                    $TicketParam{ $Self->{NameToID}->{$Needed} } = $Result;
                }
            }
        }

        # If we had no Errors, we can create the Ticket and Set ActivityEntityID as well as
        # ProcessEntityID
        if ( !IsHashRefWithData( \%Error ) ) {

            $TicketParam{UserID} = $Self->{UserID};

            $TicketParam{CustomerID}   = $Self->{UserCustomerID};
            $TicketParam{CustomerUser} = $Self->{UserLogin};
            $TicketParam{OwnerID}      = $ConfigObject->Get('CustomerPanelUserID');
            $TicketParam{UserID}       = $ConfigObject->Get('CustomerPanelUserID');

            if ( !$TicketParam{OwnerID} ) {

                $TicketParam{OwnerID} = $Param{GetParam}{OwnerID} || 1;
            }

            # if StartActivityDialog does not provide a ticket title set a default value
            if ( !$TicketParam{Title} ) {

                # get the current server Timestamp
                my $CurrentTimeStamp = $Kernel::OM->Get('Kernel::System::Time')->CurrentTimestamp();
                $TicketParam{Title} = "$Param{ProcessName} - $CurrentTimeStamp";

                # use article subject from the web request if any
                if ( IsStringWithData( $Param{GetParam}->{Subject} ) ) {
                    $TicketParam{Title} = $Param{GetParam}->{Subject};
                }
            }

            # create a new ticket
            $TicketID = $TicketObject->TicketCreate(%TicketParam);

            if ( !$TicketID ) {
                $LayoutObject->CustomerFatalError(
                    Message => "Couldn't create ticket for Process with ProcessEntityID"
                        . " '$Param{ProcessEntityID}'!",
                );
            }

            my $Success = $ProcessObject->ProcessTicketProcessSet(
                ProcessEntityID => $Param{ProcessEntityID},
                TicketID        => $TicketID,
                UserID          => $ConfigObject->Get('CustomerPanelUserID'),
            );
            if ( !$Success ) {
                $LayoutObject->CustomerFatalError(
                    Message => "Couldn't set ProcessEntityID '$Param{ProcessEntityID}' on"
                        . " TicketID '$TicketID'!",
                );
            }

            $Success = undef;

            $Success = $ProcessObject->ProcessTicketActivitySet(
                ProcessEntityID  => $Param{ProcessEntityID},
                ActivityEntityID => $ProcessStartpoint->{Activity},
                TicketID         => $TicketID,
                UserID           => $ConfigObject->Get('CustomerPanelUserID'),
            );

            if ( !$Success ) {
                $LayoutObject->CustomerFatalError(
                    Message => "Couldn't set ActivityEntityID '$Param{ProcessEntityID}' on"
                        . " TicketID '$TicketID'!",
                    Comment => 'Please contact the admin.',
                );
            }

            %Ticket = $TicketObject->TicketGet(
                TicketID      => $TicketID,
                UserID        => $ConfigObject->Get('CustomerPanelUserID'),
                DynamicFields => 1,
            );

            if ( !IsHashRefWithData( \%Ticket ) ) {
                $LayoutObject->CustomerFatalError(
                    Message => "Could not Store ActivityDialog, invalid TicketID: $TicketID!",
                    Comment => 'Please contact the admin.',
                );
            }
            for my $DynamicFieldConfig (

                # 2. remove "DynamicField_" from string
                map {
                    my $Field = $_;
                    $Field =~ s{^DynamicField_(.*)}{$1}xms;

                    # 3. grep from the DynamicFieldConfigs the resulting DynamicFields without
                    # "DynamicField_"
                    grep { $_->{Name} eq $Field } @{$DynamicField}
                }

                # 1. grep all DynamicFields
                grep {m{^DynamicField_(.*)}xms} @{ $ActivityDialog->{FieldOrder} }
                )
            {

                # and now it's easy, just store the dynamic Field Values ;)
                $BackendObject->ValueSet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $TicketID,
                    Value              => $TicketParam{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                    UserID             => $ConfigObject->Get('CustomerPanelUserID'),
                );
            }

            # remember new created TicketID
            $NewTicketID = $TicketID;
        }
    }

    # If we had a TicketID, get the Ticket
    else {

        # Get Ticket to check TicketID was valid
        %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            UserID        => $ConfigObject->Get('CustomerPanelUserID'),
            DynamicFields => 1,
        );

        if ( !IsHashRefWithData( \%Ticket ) ) {
            $LayoutObject->CustomerFatalError(
                Message => "Could not Store ActivityDialog, invalid TicketID: $TicketID!",
            );
        }

        $ActivityEntityID = $Ticket{
            'DynamicField_'
                . $ConfigObject->Get('Process::DynamicFieldProcessManagementActivityID')
        };
        if ( !$ActivityEntityID )
        {
            return $LayoutObject->CustomerErrorScreen(
                Message => "Missing ActivityEntityID in Ticket $Ticket{TicketID}!",
                Comment => 'Please contact the admin.',
            );
        }

        $ProcessEntityID = $Ticket{
            'DynamicField_'
                . $ConfigObject->Get('Process::DynamicFieldProcessManagementProcessID')
        };

        if ( !$ProcessEntityID )
        {
            $LayoutObject->CustomerFatalError(
                Message => "Missing ProcessEntityID in Ticket $Ticket{TicketID}!",
            );
        }
    }

    # if we got errors go back to displaying the ActivityDialog
    if ( IsHashRefWithData( \%Error ) ) {
        return $Self->_OutputActivityDialog(
            ProcessEntityID        => $ProcessEntityID,
            TicketID               => $TicketID || undef,
            ActivityDialogEntityID => $ActivityDialogEntityID,
            Error                  => \%Error,
            ErrorMessage           => \%ErrorMessage,
            GetParam               => $Param{GetParam},
        );
    }

    # Check if we deal with a Ticket Update
    my $UpdateTicketID = $Param{GetParam}{TicketID};

    # We save only once, no matter if one or more configs are set for the same param
    my %StoredFields;

    # Save loop for storing Ticket Values that were not required on the initial TicketCreate
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        # some fields should be skipped for the customer interface
        next DIALOGFIELD if ( grep { $_ eq $CurrentField } @{$SkipFields} );

        if ( !IsHashRefWithData( $ActivityDialog->{Fields}{$CurrentField} ) ) {
            $LayoutObject->CustomerFatalError(
                Message => "Can't get data for Field '$CurrentField' of ActivityDialog"
                    . " '$ActivityDialogEntityID'!",
            );
        }

        if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldName = $1;
            my $DynamicFieldConfig = ( grep { $_->{Name} eq $DynamicFieldName } @{$DynamicField} )[0];

            my $Success = $BackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $TicketParam{$CurrentField},
                UserID             => $ConfigObject->Get('CustomerPanelUserID'),
            );
            if ( !$Success ) {
                $LayoutObject->CustomerFatalError(
                    Message => "Could not set DynamicField value for $CurrentField of Ticket"
                        . " with ID '$TicketID' in ActivityDialog '$ActivityDialogEntityID'!",
                );
            }
        }
        elsif ( $CurrentField eq 'Article' && ( $UpdateTicketID || $NewTicketID ) ) {

            my $TicketID = $UpdateTicketID || $NewTicketID;

            if ( $Param{GetParam}{Subject} && $Param{GetParam}{Body} ) {

                # add note
                my $ArticleID = '';
                my $MimeType  = 'text/plain';
                if ( $LayoutObject->{BrowserRichText} ) {
                    $MimeType = 'text/html';

                    # verify html document
                    $Param{GetParam}{Body} = $LayoutObject->RichTextDocumentComplete(
                        String => $Param{GetParam}{Body},
                    );
                }

                my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
                $ArticleID = $TicketObject->ArticleCreate(
                    TicketID                  => $TicketID,
                    SenderType                => 'customer',
                    From                      => $From,
                    MimeType                  => $MimeType,
                    Charset                   => $LayoutObject->{UserCharset},
                    UserID                    => $ConfigObject->Get('CustomerPanelUserID'),
                    HistoryType               => 'AddNote',
                    HistoryComment            => '%%Note',
                    Body                      => $Param{GetParam}{Body},
                    Subject                   => $Param{GetParam}{Subject},
                    ArticleType               => $ActivityDialog->{Fields}->{Article}->{Config}->{ArticleType},
                    ForceNotificationToUserID => $Param{GetParam}{InformUserID},
                );
                if ( !$ArticleID ) {
                    return $LayoutObject->CustomerErrorScreen();
                }

                # get pre loaded attachment
                my @Attachments = $UploadCacheObject->FormIDGetAllFilesData(
                    FormID => $Self->{FormID},
                );

                # get submit attachment
                my %UploadStuff = $ParamObject->GetUploadAll(
                    Param => 'FileUpload',
                );
                if (%UploadStuff) {
                    push @Attachments, \%UploadStuff;
                }

                # write attachments
                ATTACHMENT:
                for my $Attachment (@Attachments) {

                    # skip, deleted not used inline images
                    my $ContentID = $Attachment->{ContentID};
                    if (
                        $ContentID
                        && ( $Attachment->{ContentType} =~ /image/i )
                        && ( $Attachment->{Disposition} eq 'inline' )
                        )
                    {
                        my $ContentIDHTMLQuote = $LayoutObject->Ascii2Html(
                            Text => $ContentID,
                        );

                        # workaround for link encode of rich text editor, see bug#5053
                        my $ContentIDLinkEncode = $LayoutObject->LinkEncode($ContentID);
                        $Param{GetParam}{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                        # ignore attachment if not linked in body
                        if ( $Param{GetParam}{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i )
                        {
                            next ATTACHMENT;
                        }
                    }

                    # write existing file to backend
                    $TicketObject->ArticleWriteAttachment(
                        %{$Attachment},
                        ArticleID => $ArticleID,
                        UserID    => $ConfigObject->Get('CustomerPanelUserID'),
                    );
                }

                # remove pre submited attachments
                $UploadCacheObject->FormIDRemove( FormID => $Self->{FormID} );
            }
        }

        # If we have to Update a ticket, update the transmitted values
        elsif ($UpdateTicketID) {

            my $Success;
            if ( $Self->{NameToID}{$CurrentField} eq 'Title' ) {

                # if there is no title, nothig is needed to be done
                if (
                    !defined $TicketParam{'Title'}
                    || ( defined $TicketParam{'Title'} && $TicketParam{'Title'} eq '' )
                    )
                {
                    $Success = 1;
                }

                # otherwise set the ticket title
                else {
                    $Success = $TicketObject->TicketTitleUpdate(
                        Title    => $TicketParam{'Title'},
                        TicketID => $TicketID,
                        UserID   => $ConfigObject->Get('CustomerPanelUserID'),
                    );
                }
            }
            elsif (
                (
                    $Self->{NameToID}{$CurrentField} eq 'CustomerID'
                    || $Self->{NameToID}{$CurrentField} eq 'CustomerUserID'
                )
                )
            {
                next DIALOGFIELD if $StoredFields{ $Self->{NameToID}{$CurrentField} };

                if ( $ActivityDialog->{Fields}{$CurrentField}{Display} == 1 ) {
                    $LayoutObject->CustomerFatalError(
                        Message => "Wrong ActivityDialog Field config: $CurrentField can't be"
                            . ' Display => 1 / Show field (Please change its configuration to be'
                            . ' Display => 0 / Do not show field or '
                            . ' Display => 2 / Show field as mandatory )!',
                    );
                }

                # skip TicketCustomerSet() if there is no change in the customer
                if (
                    $Ticket{CustomerID} eq $TicketParam{CustomerID}
                    && $Ticket{CustomerUserID} eq $TicketParam{CustomerUser}
                    )
                {

                    # In this case we don't want to call any additional stores
                    # on Customer, CustomerNo, CustomerID or CustomerUserID
                    # so make sure both fields are set to "Stored" ;)
                    $StoredFields{ $Self->{NameToID}{'CustomerID'} }     = 1;
                    $StoredFields{ $Self->{NameToID}{'CustomerUserID'} } = 1;
                    next DIALOGFIELD;
                }

                $Success = $TicketObject->TicketCustomerSet(
                    No => $TicketParam{CustomerID},

                    # here too: unfortunately TicketCreate takes Param 'CustomerUser'
                    # instead of CustomerUserID, so our TicketParam hash
                    # has the CustomerUser Key instead of 'CustomerUserID'
                    User     => $TicketParam{CustomerUser},
                    TicketID => $TicketID,
                    UserID   => $ConfigObject->Get('CustomerPanelUserID'),
                );

                # In this case we don't want to call any additional stores
                # on Customer, CustomerNo, CustomerID or CustomerUserID
                # so make sure both fields are set to "Stored" ;)
                $StoredFields{ $Self->{NameToID}{'CustomerID'} }     = 1;
                $StoredFields{ $Self->{NameToID}{'CustomerUserID'} } = 1;
            }
            else {
                next DIALOGFIELD if $StoredFields{ $Self->{NameToID}{$CurrentField} };

                my $TicketFieldSetSub = $CurrentField;
                $TicketFieldSetSub =~ s{ID$}{}xms;
                $TicketFieldSetSub = 'Ticket' . $TicketFieldSetSub . 'Set';

                if ( $TicketObject->can($TicketFieldSetSub) )
                {
                    my $UpdateFieldName;

                    $UpdateFieldName = $Self->{NameToID}{$CurrentField};

                    # to store if the field needs to be updated
                    my $FieldUpdate;

                    # only Service and SLA fields accepts empty values if the hash key is not
                    # defined set it to empty so the Ticket*Set function call will get the empty
                    # value
                    if (
                        ( $UpdateFieldName eq 'ServiceID' || $UpdateFieldName eq 'SLAID' )
                        && !defined $TicketParam{ $Self->{NameToID}{$CurrentField} }
                        )
                    {
                        $TicketParam{ $Self->{NameToID}{$CurrentField} } = '';
                        $FieldUpdate = 1;
                    }

                    # update Service an SLA fields if they have a defined value (even empty)
                    elsif ( $UpdateFieldName eq 'ServiceID' || $UpdateFieldName eq 'SLAID' )
                    {
                        $FieldUpdate = 1;
                    }

                    # update any other field that its value is defiend and not emoty
                    elsif (
                        $UpdateFieldName ne 'ServiceID'
                        && $UpdateFieldName ne 'SLAID'
                        && defined $TicketParam{ $Self->{NameToID}{$CurrentField} }
                        && $TicketParam{ $Self->{NameToID}{$CurrentField} } ne ''
                        )
                    {
                        $FieldUpdate = 1;
                    }

                    $Success = 1;

                    # check if field needs to be updated
                    if ($FieldUpdate) {
                        $Success = $TicketObject->$TicketFieldSetSub(
                            $UpdateFieldName => $TicketParam{ $Self->{NameToID}{$CurrentField} },
                            TicketID         => $TicketID,
                            UserID           => $ConfigObject->Get('CustomerPanelUserID'),
                        );
                    }
                }
            }
            if ( !$Success ) {
                $LayoutObject->CustomerFatalError(
                    Message => "Could not set $CurrentField for Ticket with ID '$TicketID'"
                        . " in ActivityDialog '$ActivityDialogEntityID'!",
                );
            }
        }
    }

    # Transitions will be handled by ticket event module (TicketProcessTransitions.pm).

    # if we were updating a ticket, close the popup and return to zoom
    # else (new ticket) just go to zoom to show the new ticket
    if ($UpdateTicketID) {

        # load new URL in parent window and close popup
        return $LayoutObject->PopupClose(
            URL => "Action=CustomerTicketZoom;TicketID=$UpdateTicketID",
        );
    }

    return $LayoutObject->Redirect(
        OP => "Action=CustomerTicketZoom;TicketID=$TicketID",
    );
}

sub _DisplayProcessList {
    my ( $Self, %Param ) = @_;

    # If we have a ProcessEntityID
    $Param{Errors}->{ProcessEntityIDInvalid} = ' ServerError'
        if ( $Param{ProcessEntityID} && !$Param{ProcessList}->{ $Param{ProcessEntityID} } );

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    $Param{ProcessList} = $LayoutObject->BuildSelection(
        Class => 'Validate_Required' . ( $Param{Errors}->{ProcessEntityIDInvalid} || ' ' ),
        Data  => $Param{ProcessList},
        Name  => 'ProcessEntityID',
        SelectedID   => $Param{ProcessEntityID},
        PossibleNone => 1,
        Sort         => 'AlphanumericValue',
        Translation  => 0,
        AutoComplete => 'off',
    );

    # add rich text editor
    if ( $LayoutObject->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

        $LayoutObject->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    $LayoutObject->Block(
        Name => 'ProcessList',
        Data => {
            %Param,
            FormID => $Self->{FormID},
        },
    );
    my $Output = $LayoutObject->CustomerHeader();
    $Output .= $LayoutObject->CustomerNavigationBar();

    $Output .= $LayoutObject->Output(
        TemplateFile => 'CustomerTicketProcess',
        Data         => {
            %Param,
        },
    );

    # workaround when activity dialog is loaded by AJAX as first activity dialog, if there is
    # a date field like Pending Time or Dynamic Fields Date/Time or Date, there is no way to set
    # this options in the footer again
    $LayoutObject->{HasDatepicker} = 1;

    $Output .= $LayoutObject->CustomerFooter();

    return $Output;
}

=item _CheckField()

checks all the possible ticket fields and returns the ID (if possible) value of the field, if valid
and checks are successfull

if Display param is set to 0 or not given, it uses ActivityDialog field default value for all fields
or global default value as fallback only for certain fields

if Display param is set to 1 or 2 it uses the value from the web request

    my $PriorityID = $CustomerTicketProcessObject->_CheckField(
        Field        => 'PriorityID',
        Display      => 1,                   # optional, 0 or 1 or 2
        DefaultValue => '3 normal',          # ActivityDialog field default value (it uses global
                                             #    default value as fall back for mandatory fields
                                             #    (Queue, Sate, Lock and Priority)
    );

Returns:
    $PriorityID = 1;                         # if PriorityID is set to 1 in the web request

    my $PriorityID = $CustomerTicketProcessObject->_CheckField(
        Field        => 'PriorityID',
        Display      => 0,
        DefaultValue => '3 normal',
    );

Returns:
    $PriorityID = 3;                        # since ActivityDialog default value is '3 normal' and
                                            #     field is hidden

=cut

sub _CheckField {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Field)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # remove the ID and check if the given field is required for creating a ticket
    my $FieldWithoutID = $Param{Field};
    $FieldWithoutID =~ s{ID$}{}xms;
    my $TicketRequiredField = scalar grep { $_ eq $FieldWithoutID } qw(Queue State Lock Priority);

    my $Value;

    # get needed objects
    my $ParamObject  = $Kernel::OM->Get('Kernel::System::Web::Request');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # if no Display (or Display == 0) is commited
    if ( !$Param{Display} ) {

        # Check if a DefaultValue is given
        if ( $Param{DefaultValue} ) {

            # check if the given field param is valid
            $Value = $Self->_LookupValue(
                Field => $FieldWithoutID,
                Value => $Param{DefaultValue},
            );
        }

        # if we got a required ticket field, check if we got a valid DefaultValue in the SysConfig
        if ( !$Value && $TicketRequiredField ) {
            $Value = $Kernel::OM->Get('Kernel::Config')->Get("Process::Default$FieldWithoutID");

            if ( !$Value ) {
                $LayoutObject->CustomerFatalError(
                    Message => "Default Config for Process::Default$FieldWithoutID missing!",
                );
            }
            else {

                # check if the given field param is valid
                $Value = $Self->_LookupValue(
                    Field => $FieldWithoutID,
                    Value => $Value,
                );
                if ( !$Value ) {
                    $LayoutObject->CustomerFatalError(
                        Message => "Default Config for Process::Default$FieldWithoutID invalid!",
                    );
                }
            }
        }
    }
    elsif ( $Param{Display} == 1 ) {

        # Display == 1 is logicaliy not possible for a ticket required field
        if ($TicketRequiredField) {
            $LayoutObject->CustomerFatalError(
                Message => "Wrong ActivityDialog Field config: $Param{Field} can't be"
                    . ' Display => 1 / Show field (Please change its configuration to be'
                    . ' Display => 0 / Do not show field or '
                    . ' Display => 2 / Show field as mandatory )!',
            );
        }

        # check if the given field param is valid
        if ( $Param{Field} eq 'Article' ) {

            # in case of article fields we need to fake a value
            $Value = 1;
        }
        else {

            $Value = $Self->_LookupValue(
                Field => $Param{Field},
                Value => $ParamObject->GetParam( Param => $Param{Field} ) || '',
            );
        }
    }
    elsif ( $Param{Display} == 2 ) {

        # check if the given field param is valid
        if ( $Param{Field} eq 'Article' ) {

            my ( $Body, $Subject ) = (
                $ParamObject->GetParam( Param => 'Body' ),
                $ParamObject->GetParam( Param => 'Subject' )
            );

            $Value = 0;
            if ( $Body && $Subject ) {
                $Value = 1;
            }
        }
        else {
            $Value = $Self->_LookupValue(
                Field => $Param{Field},
                Value => $ParamObject->GetParam( Param => $Param{Field} ) || '',
            );
        }
    }

    return $Value;
}

=item _LookupValue()

returns the ID (if possible) of nearly all ticket fields and/or checks if its valid.
Can handle IDs or Strings.
Currently working with: State, Queue, Lock, Priority (possible more).

    my $PriorityID = $CustomerTicketProcessObject->_LookupValue(
        PriorityID => 1,
    );
    $PriorityID = 1;

    my $StateID = $CustomerTicketProcessObject->_LookupValue(
        State => 'open',
    );
    $StateID = 3;

    my $PriorityID = $CustomerTicketProcessObject->_LookupValue(
        Priority => 'unknownpriority1234',
    );
    $PriorityID = undef;

=cut

sub _LookupValue {
    my ( $Self, %Param ) = @_;

    # get log object
    my $LogObject = $Kernel::OM->Get('Kernel::System::Log');

    # check needed stuff
    for my $Needed (qw(Field Value)) {
        if ( !defined $Param{$Needed} ) {
            $LogObject->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    if ( !$Param{Field} ) {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Field should not be empty!"
        );
        return;
    }

    # if there is no value, there is nothing to do
    return if !$Param{Value};

    # remove the ID for function name purpose
    my $FieldWithoutID = $Param{Field};
    $FieldWithoutID =~ s{ID$}{}xms;

    my $LookupFieldName;
    my $ObjectName;
    my $FunctionName;

    # service and SLA lookup needs Name as parameter (While ServiceID an SLAID uses standard)
    if ( scalar grep { $Param{Field} eq $_ } qw( Service SLA ) ) {
        $LookupFieldName = 'Name';
        $ObjectName      = $FieldWithoutID . 'Object';
        $FunctionName    = $FieldWithoutID . 'Lookup';
    }

    # other fields can use standard parameter names as Priority or PriorityID
    else {
        $LookupFieldName = $Param{Field};
        $ObjectName      = $FieldWithoutID . 'Object';
        $FunctionName    = $FieldWithoutID . 'Lookup';
    }

    my $Value;
    my $Object->{$ObjectName} = $Kernel::OM->Get( 'Kernel::System::' . $FieldWithoutID );

    # check if the backend module has the needed *Lookup sub
    if (
        $Object->{$ObjectName}
        && $Object->{$ObjectName}->can($FunctionName)
        )
    {

        # call the *Lookup sub and get the value
        $Value = $Object->{$ObjectName}->$FunctionName(
            $LookupFieldName => $Param{Value},
        );
    }

    # if we didn't have an object and the value has no ref a string e.g. Title and so on
    # return true
    elsif ( $Param{Field} eq $FieldWithoutID && !ref $Param{Value} ) {
        return $Param{Value};
    }
    else {
        $LogObject->Log(
            Priority => 'error',
            Message  => "Error while checking with " . $FieldWithoutID . "Object!"
        );
        return;
    }

    return if ( !$Value );

    # return the given ID value if the *Lookup result was a string
    if ( $Param{Field} ne $FieldWithoutID ) {
        return $Param{Value};
    }

    # return the *Lookup string return value
    return $Value;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;

    # if no CustomerUserID is present, consider the logged in customer
    if ( !$Param{CustomerUserID} ) {
        $Param{CustomerUserID} = $Self->{UserID};
    }

    # get sla
    my %SLA;
    if ( $Param{ServiceID} && $Param{Services} && %{ $Param{Services} } ) {
        if ( $Param{Services}->{ $Param{ServiceID} } ) {
            %SLA = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSLAList(
                %Param,
                Action => $Self->{Action},
            );
        }
    }
    return \%SLA;
}

sub _GetServices {
    my ( $Self, %Param ) = @_;

    # get service
    my %Service;

    # check needed
    return \%Service if !$Param{QueueID} && !$Param{TicketID};

    # get options for default services for unknown customers
    my $DefaultServiceUnknownCustomer
        = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service::Default::UnknownCustomer');

    # if no CustomerUserID is present, consider the logged in customer
    if ( !$Param{CustomerUserID} ) {
        $Param{CustomerUserID} = $Self->{UserID};
    }

    # check if still no CustomerUserID is selected
    # if $DefaultServiceUnknownCustomer = 0 leave CustomerUserID empty, it will not get any services
    # if $DefaultServiceUnknownCustomer = 1 set CustomerUserID to get default services
    if ( !$Param{CustomerUserID} && $DefaultServiceUnknownCustomer ) {
        $Param{CustomerUserID} = '<DEFAULT>';
    }

    # get service list
    if ( $Param{CustomerUserID} ) {
        %Service = $Kernel::OM->Get('Kernel::System::Ticket')->TicketServiceList(
            %Param,
            Action => $Self->{Action},
        );
    }
    return \%Service;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    my %Priorities;

    # Initially we have just the default Queue Parameter
    # so make sure to get the ID in that case
    my $QueueID;
    if ( !$Param{QueueID} && $Param{Queue} ) {
        $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $Param{Queue} );
    }
    if ( $Param{QueueID} || $QueueID || $Param{TicketID} ) {
        %Priorities = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPriorityList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );

    }
    return \%Priorities;
}

sub _GetQueues {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # check own selection
    my %NewQueues;
    if ( $ConfigObject->Get('Ticket::Frontend::NewQueueOwnSelection') ) {
        %NewQueues = %{ $ConfigObject->Get('Ticket::Frontend::NewQueueOwnSelection') };
    }
    else {

        # SelectionType Queue or SystemAddress?
        my %Queues;
        if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue' ) {
            %Queues = $Kernel::OM->Get('Kernel::System::Ticket')->MoveList(
                %Param,
                Type    => 'create',
                Action  => $Self->{Action},
                QueueID => $Self->{QueueID},
                UserID  => $ConfigObject->Get('CustomerPanelUserID'),
            );
        }
        else {
            %Queues = $Kernel::OM->Get('Kernel::System::DB')->GetTableData(
                Table => 'system_address',
                What  => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
        }

        # get create permission queues
        my %UserGroups = $Kernel::OM->Get('Kernel::System::CustomerGroup')->GroupMemberList(
            UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            Type   => 'create',
            Result => 'HASH',
        );

        # build selection string
        QUEUEID:
        for my $QueueID ( sort keys %Queues ) {
            my %QueueData = $Kernel::OM->Get('Kernel::System::Queue')->QueueGet( ID => $QueueID );

            # permission check, can we create new tickets in queue
            next QUEUEID if !$UserGroups{ $QueueData{GroupID} };

            my $String = $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionString')
                || '<Realname> <<Email>> - Queue: <Queue>';
            $String =~ s/<Queue>/$QueueData{Name}/g;
            $String =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ( $ConfigObject->Get('Ticket::Frontend::NewQueueSelectionType') ne 'Queue' )
            {
                my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet(
                    ID => $Queues{$QueueID},
                );
                $String =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $String =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewQueues{$QueueID} = $String;
        }
    }

    return \%NewQueues;
}

sub _GetStates {
    my ( $Self, %Param ) = @_;

    my %States = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateList(
        %Param,

        # Set default values for new process ticket
        QueueID  => $Param{QueueID}  || 1,
        TicketID => $Param{TicketID} || '',

        # remove type, since if Ticket::Type is active in sysconfig, the Type parameter will
        # be sent and the TicketStateList will send the parameter as State Type
        Type => undef,

        Action         => $Self->{Action},
        CustomerUserID => $Self->{UserID},
    );

    return \%States;
}

sub _GetTypes {
    my ( $Self, %Param ) = @_;

    # get type
    my %Type;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Type = $Kernel::OM->Get('Kernel::System::Ticket')->TicketTypeList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );
    }
    return \%Type;
}

sub _GetAJAXUpdatableFields {
    my ( $Self, %Param ) = @_;

    my %DefaultUpdatableFields = (
        PriorityID    => 1,
        QueueID       => 1,
        ResponsibleID => 1,
        ServiceID     => 1,
        SLAID         => 1,
        StateID       => 1,
        OwnerID       => 1,
        LockID        => 1,
    );

    # get backend object
    my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => 'Ticket',
    );

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $BackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $DynamicField = \@CustomerDynamicFields;

    # create a DynamicFieldLookupTable
    my %DynamicFieldLookup = map { 'DynamicField_' . $_->{Name} => $_ } @{$DynamicField};

    my @UpdatableFields;
    FIELD:
    for my $Field ( sort keys %{ $Param{ActivityDialogFields} } ) {

        my $FieldData = $Param{ActivityDialogFields}->{$Field};

        # skip hidden fields
        next FIELD if !$FieldData->{Display};

        # for Dynamic Fields check if is AJAXUpdatable
        if ( $Field =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldConfig = $DynamicFieldLookup{$Field};

            # skip any field with wrong config
            next FIELD if !IsHashRefWithData($DynamicFieldConfig);

            # skip field if is not IsACLReducible (updatable)

            my $IsACLReducible = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next FIELD if !$IsACLReducible;

            push @UpdatableFields, $Field;
        }

        # for all others use %DefaultUpdatableFields table
        else {

            # standarize the field name (e.g. use StateID for State field)
            my $FieldName = $Self->{NameToID}->{$Field};

            # skip if field name could not be converted (this means that field is unknown)
            next FIELD if !$FieldName;

            # skip if the field is not updatable via ajax
            next FIELD if !$DefaultUpdatableFields{$FieldName};

            push @UpdatableFields, $FieldName;
        }
    }

    return \@UpdatableFields;
}

sub _GetFieldsToUpdateStrg {
    my ( $Self, %Param ) = @_;

    my $FieldsToUpdate = '';
    if ( IsArrayRefWithData( $Param{AJAXUpdatableFields} ) ) {
        my $FirstItem = 1;
        FIELD:
        for my $Field ( @{ $Param{AJAXUpdatableFields} } ) {
            next FIELD if $Field eq $Param{TriggerField};
            if ($FirstItem) {
                $FirstItem = 0;
            }
            else {
                $FieldsToUpdate .= ', ';
            }
            $FieldsToUpdate .= "'" . $Field . "'";
        }
    }
    return $FieldsToUpdate;
}

1;
