# --
# Kernel/Modules/CustomerTicketProcess.pm - to create process tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketProcess;

use strict;
use warnings;

use Kernel::System::ProcessManagement::Activity;
use Kernel::System::ProcessManagement::ActivityDialog;
use Kernel::System::ProcessManagement::TransitionAction;
use Kernel::System::ProcessManagement::Transition;
use Kernel::System::ProcessManagement::Process;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::Web::UploadCache;
use Kernel::System::CustomerUser;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless $Self, $Type;

    # check needed Objects
    for my $Needed (
        qw(
        ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject TimeObject MainObject
        EncodeObject
        )
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->CustomerFatalError( Message => "Got no $Needed!" );
        }
    }

    $Self->{UploadCacheObject}    = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{UserObject}           = Kernel::System::User->new(%Param);
    $Self->{ActivityObject}       = Kernel::System::ProcessManagement::Activity->new(%Param);
    $Self->{ActivityDialogObject} = Kernel::System::ProcessManagement::ActivityDialog->new(%Param);
    $Self->{TransitionActionObject}
        = Kernel::System::ProcessManagement::TransitionAction->new(%Param);
    $Self->{TransitionObject}   = Kernel::System::ProcessManagement::Transition->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);
    $Self->{ProcessObject}      = Kernel::System::ProcessManagement::Process->new(
        ActivityObject         => $Self->{ActivityObject},
        ActivityDialogObject   => $Self->{ActivityDialogObject},
        TransitionObject       => $Self->{TransitionObject},
        TransitionActionObject => $Self->{TransitionActionObject},
        %Param,
    );
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{DynamicField}       = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid      => 1,
        ObjectType => 'Ticket',
    );

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $Self->{DynamicField} = \@CustomerDynamicFields;

    # global config hash for id dissolution
    $Self->{NameToID} = {
        Article => 'Article',
    };

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $TicketID = $Self->{ParamObject}->GetParam( Param => 'TicketID' );
    my $ActivityDialogEntityID
        = $Self->{ParamObject}->GetParam( Param => 'ActivityDialogEntityID' );
    my $ActivityDialogHashRef;

    # get all processes even those that can not be started in the Customer Interface
    # currently there is no option to start a process from Customer Interface
    # this list is used later (if is restricted then valid customer activity dialogs it will not be
    # possible to access valid customer activity dialogs)
    my $ProcessList = $Self->{ProcessObject}->ProcessList(
        ProcessState => ['Active'],
        Interface    => 'all',
    );
    my $ProcessEntityID = $Self->{ParamObject}->GetParam( Param => 'ProcessEntityID' );

    if ( !IsHashRefWithData($ProcessList) ) {
        return $Self->{LayoutObject}->CustomerErrorScreen(
            Message => 'No Process configured!',
            Comment => 'Please contact the admin.',
        );
    }

    if ( !$TicketID ) {
        return $Self->{LayoutObject}->CustomerErrorScreen(
            Message => 'No TicketID given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check if there is a configured required permission
    # for the ActivityDialog (if there is one)
    my $ActivityDialogPermission = 'rw';
    if ($ActivityDialogEntityID) {
        $ActivityDialogHashRef
            = $Self->{ActivityDialogObject}->ActivityDialogGet(
            ActivityDialogEntityID => $ActivityDialogEntityID,
            Interface              => 'CustomerInterface',
            );

        if ( !IsHashRefWithData($ActivityDialogHashRef) ) {
            $Self->{LayoutObject}->CustomerFatalError(
                Message =>
                    "Couldn't get Config for ActivityDialogEntityID '$ActivityDialogEntityID'!",
            );
        }

        if ( $ActivityDialogHashRef->{Permission} ) {
            $ActivityDialogPermission = $ActivityDialogHashRef->{Permission};
        }
    }

    # check permissions
    my $Access = $Self->{TicketObject}->TicketCustomerPermission(
        Type     => $ActivityDialogPermission,
        TicketID => $Self->{TicketID},

        # here is safe to use $Self->{UserID}, since it will be compared vs ticket customer in
        # ticket permission modules
        UserID => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->CustomerNoPermission(
            Message    => "You need $ActivityDialogPermission permissions!",
            WithHeader => 'yes',
        );
    }

    # get ACL restrictions
    $Self->{TicketObject}->TicketAcl(
        Data           => '-',
        TicketID       => $TicketID,
        ReturnType     => 'Action',
        ReturnSubType  => '-',
        CustomerUserID => $Self->{UserID},
    );
    my %AclAction = $Self->{TicketObject}->TicketAclActionData();

    # check if ACL resctictions if exist
    if ( IsHashRefWithData( \%AclAction ) ) {

        # show error screen if ACL prohibits this action
        if ( defined $AclAction{ $Self->{Action} } && $AclAction{ $Self->{Action} } eq '0' ) {
            return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
        }
    }
    if ( IsHashRefWithData($ActivityDialogHashRef) ) {

        # get ACL restrictions
        $Self->{TicketObject}->TicketAcl(
            Data                   => '-',
            ActivityDialogEntityID => $ActivityDialogEntityID,
            TicketID               => $TicketID,
            ReturnType             => 'Ticket',
            ReturnSubType          => '-',
            CustomerUserID         => $Self->{UserID},
        );

        my @PossibleActivityDialogs
            = $Self->{TicketObject}->TicketAclActivityDialogData(
            ActivityDialogs => [ $ActivityDialogEntityID, ]
            );

        # check if ACL resctictions exist
        if (
            !$PossibleActivityDialogs[0]
            || $PossibleActivityDialogs[0] ne $ActivityDialogEntityID
            )
        {
            return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
        }
    }

    # If we have no Subaction or Subaction is 'Create' and submitted ProcessEntityID is invalid
    # Display the ProcessList
    if (
        !$Self->{Subaction}
        || ( $Self->{Subaction} eq 'DisplayActivityDialog' && !$ProcessList->{$ProcessEntityID} )
        )
    {
        return $Self->{LayoutObject}->CustomerErrorScreen(
            Message => 'Subacion is invalid!',
            Comment => 'Please contact the admin.',
        );
    }

    # set AJAX for proper error responses
    my $AJAX = $Self->{Subaction} eq 'DisplayActivityDialogAJAX' ? 1 : 0;

    # Get the necessary parameters
    # collects a mixture of present values bottom to top:
    # SysConfig DefaultValues, ActivityDialog DefaultValues, TicketValues, SubmittedValues
    # including ActivityDialogEntityID and ProcessEntityID
    # is used for:
    # - Parameter checking before storing
    # - will be used for ACL checking lateron
    my $GetParam = $Self->_GetParam(
        AJAX            => $AJAX,
        ProcessEntityID => $ProcessEntityID,
    );

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    if ( $Self->{Subaction} eq 'StoreActivityDialog' && $ProcessEntityID ) {
        $Self->{LayoutObject}->ChallengeTokenCheck();

        return $Self->_StoreActivityDialog(
            %Param,
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
            AJAX            => 1,
            ProcessEntityID => $ProcessEntityID,
            GetParam        => $GetParam,
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'text/html; charset=' . $Self->{LayoutObject}->{Charset},
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
    return $Self->{LayoutObject}->CustomerErrorScreen(
        Message => 'Subacion is invalid!',
        Comment => 'Please contact the admin.',
    );
}

sub _RenderAjax {

    # FatalError is safe because a JSON strcuture is expecting, then it will result into a
    # communications error

    my ( $Self, %Param ) = @_;
    for my $Needed (qw(ProcessEntityID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LayoutObject}->CustomerFatalError(
                Message => "Got no $Needed in _RenderAjax!"
            );
        }
    }
    my $ActivityDialogEntityID = $Param{GetParam}{ActivityDialogEntityID};
    if ( !$ActivityDialogEntityID ) {
        $Self->{LayoutObject}->CustomerFatalError(
            Message => "Got no ActivityDialogEntityID in _RenderAjax!"
        );
    }
    my $ActivityDialog
        = $Self->{ActivityDialogObject}->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityDialogEntityID,
        Interface              => 'CustomerInterface',
        );
    if ( !IsHashRefWithData($ActivityDialog) ) {
        $Self->{LayoutObject}->CustomerFatalError(
            Message => "No ActivityDialog configured for $ActivityDialogEntityID in _RenderAjax!"
        );
    }

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    my %FieldsProcessed;
    my @JSONCollector;

    # All submitted DynamicFields
    # used for ACL checking
    my %DynamicFieldCheckParam = map { $_ => $Param{GetParam}{$_} }
        grep {m{^DynamicField_}xms} ( keys %{ $Param{GetParam} } );

    # Get the activity dialog's Submit Param's or Config Params
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

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

            my $DynamicFieldConfig
                = ( grep { $_->{Name} eq $DynamicFieldName } @{ $Self->{DynamicField} } )[0];

            next DIALOGFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next DYNAMICFIELD if !$IsACLReducible;

            my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );
            my %DynamicFieldCheckParam = map { $_ => $Param{GetParam}{$_} }
                grep {m{^DynamicField_}xms} ( keys %{ $Param{GetParam} } );

            # convert possible values key => value to key => key for ACLs usign a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $Self->{TicketObject}->TicketAcl(
                %{ $Param{GetParam} },
                DynamicField   => \%DynamicFieldCheckParam,
                ReturnType     => 'Ticket',
                ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data           => \%AclData,
                CustomerUserID => $Self->{UserID},
            );

            if ($ACL) {
                my %Filter = $Self->{TicketObject}->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValues} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }

            my $DataValues = $Self->{BackendObject}->BuildSelectionDataGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                PossibleValues     => $PossibleValues,
                Value
                    => $Param{GetParam}{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
            ) || $PossibleValues;

            # add dynamic field to the JSONCollector
            push(
                @JSONCollector,
                {
                    Name       => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data       => $DataValues,
                    SelectedID => $Param{GetParam}{ 'DynamicField_' . $DynamicFieldConfig->{Name} },
                    Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                    Max         => 100,
                }
            );
        }

        my $JSON = $Self->{LayoutObject}->BuildSelectionJSON( [@JSONCollector] );

        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
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

    my $IsAJAXUpdate = $Param{AJAX} || '';

    for my $Needed (qw(ProcessEntityID)) {
        if ( !$Param{$Needed} ) {
            $Self->{LayoutObject}->CustomerFatalError( Message => "Got no $Needed in _GetParam!" );
        }
    }
    my %GetParam;
    my %Ticket;
    my $ProcessEntityID = $Param{ProcessEntityID};
    my $TicketID = $Self->{ParamObject}->GetParam( Param => 'TicketID' );
    my $ActivityDialogEntityID
        = $Self->{ParamObject}->GetParam( Param => 'ActivityDialogEntityID' );
    my $ActivityEntityID;
    my %ValuesGotten;
    my $Value;

    # If we got no ActivityDialogEntityID and no TicketID
    # we have to get the Processes' Startpoint
    if ( !$ActivityDialogEntityID && !$TicketID ) {
        my $ActivityActivityDialog
            = $Self->{ProcessObject}->ProcessStartpointGet( ProcessEntityID => $ProcessEntityID );
        if (
            !$ActivityActivityDialog->{ActivityDialog}
            || !$ActivityActivityDialog->{Activity}
            )
        {
            my $Message = "Got no Start ActivityEntityID or Start ActivityDialogEntityID for"
                . " Process: $ProcessEntityID in _GetParam!";

            # does not show header and footer again
            if ($IsAJAXUpdate) {
                return $Self->{LayoutObject}->CustomerError(
                    Message => $Message,
                );
            }
            else {
                $Self->{LayoutObject}->CustomerFatalError(
                    Message => $Message,
                );
            }
        }
        $ActivityDialogEntityID = $ActivityActivityDialog->{ActivityDialog};
        $ActivityEntityID       = $ActivityActivityDialog->{Activity};
    }

    my $ActivityDialog
        = $Self->{ActivityDialogObject}->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityDialogEntityID,
        Interface              => 'CustomerInterface',
        );

    if ( !IsHashRefWithData($ActivityDialog) ) {
        $Self->{LayoutObject}->CustomerFatalError(
            Message => "Couldn't get Config for ActivityDialogEntityID '$ActivityDialogEntityID'!",
        );
    }

    # if there is a ticket then is not an AJAX request
    if ($TicketID) {
        %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 1,
        );

        %GetParam = %Ticket;
        if ( !IsHashRefWithData( \%GetParam ) ) {
            $Self->{LayoutObject}->CustomerFatalError(
                Message => "Couldn't get Ticket for TicketID: $TicketID in _GetParam!",
            );
        }

        $ActivityEntityID = $Ticket{
            'DynamicField_'
                . $Self->{ConfigObject}->Get("Process::DynamicFieldProcessManagementActivityID")
        };
        if ( !$ActivityEntityID ) {
            $Self->{LayoutObject}->CustomerFatalError(
                Message =>
                    "Couldn't determine ActivityEntityID. DynamicField or Config isn't set properly!",
            );
        }

    }
    $GetParam{ActivityDialogEntityID} = $ActivityDialogEntityID;
    $GetParam{ActivityEntityID}       = $ActivityEntityID;
    $GetParam{ProcessEntityID}        = $ProcessEntityID;

    # Get the activitydialogs's Submit Param's or Config Params
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        # Skip if we're working on a field that was already done with or without ID
        if ( $Self->{NameToID}{$CurrentField} && $ValuesGotten{ $Self->{NameToID}{$CurrentField} } )
        {
            next DIALOGFIELD;
        }

        if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldName = $1;

           # Get the Config of the current DynamicField (the first element of the grep result array)
            my $DynamicFieldConfig
                = ( grep { $_->{Name} eq $DynamicFieldName } @{ $Self->{DynamicField} } )[0];

            if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                my $Message = "DynamicFieldConfig missing for field: $DynamicFieldName!";

                # does not show header and footer again
                if ($IsAJAXUpdate) {
                    return $Self->{LayoutObject}->CustomerError(
                        Message => $Message,
                    );
                }
                else {
                    $Self->{LayoutObject}->CustomerFatalError(
                        Message => $Message,
                    );
                }
            }

            # Get DynamicField Values
            $Value = $Self->{BackendObject}->EditFieldValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ParamObject        => $Self->{ParamObject},
                LayoutObject       => $Self->{LayoutObject},
            );

            # If we got a submitted param, take it and next out
            if ($Value) {
                $GetParam{$CurrentField} = $Value;
                next DIALOGFIELD;
            }

            # If we didn't have a Param Value try the ticket Value
            # next out if it was successful
            $Value = $Ticket{$CurrentField};
            if ($Value) {
                $GetParam{$CurrentField} = $Value;
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

            # if all that failed, use ''
            $GetParam{$CurrentField} = '';
            next DIALOGFIELD;
        }

        # get article fields
        if ( $CurrentField eq 'Article' ) {

            $GetParam{Subject} = $Self->{ParamObject}->GetParam( Param => 'Subject' );
            $GetParam{Body}    = $Self->{ParamObject}->GetParam( Param => 'Body' );

            $ValuesGotten{Article} = 1 if ( $GetParam{Subject} && $GetParam{Body} );
        }
    }
    return \%GetParam;
}

sub _OutputActivityDialog {
    my ( $Self, %Param ) = @_;
    my $TicketID               = $Param{GetParam}{TicketID};
    my $ActivityDialogEntityID = $Param{GetParam}{ActivityDialogEntityID};
    my $IsAJAXUpdate           = $Param{AJAX} || '';

    # Check needed parameters:
    # TicketID and ActivityDialogEntityID
    if ( !( $TicketID && $ActivityDialogEntityID ) ) {
        my $Message = 'Got no TicketID and ActivityDialogEntityID!';

        # does not show header and footer again
        if ($IsAJAXUpdate) {
            return $Self->{LayoutObject}->CustomerError(
                Message => $Message,
            );
        }
        else {
            $Self->{LayoutObject}->CustomerFatalError(
                Message => $Message,
            );
        }
    }

    my $ActivityActivityDialog;
    my %Ticket;
    my %Error = ();

    # If we had Errors, we got an Errorhash
    %Error = %{ $Param{Error} } if ( IsHashRefWithData( $Param{Error} ) );

    # no AJAX update in this part
    %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 1,
    );

    if ( !IsHashRefWithData( \%Ticket ) ) {
        $Self->{LayoutObject}->CustomerFatalError(
            Message => "Can't get Ticket '$Param{TicketID}'!",
        );
    }

    my $DynamicFieldProcessID = 'DynamicField_'
        . $Self->{ConfigObject}->Get('Process::DynamicFieldProcessManagementProcessID');
    my $DynamicFieldActivityID
        = 'DynamicField_'
        . $Self->{ConfigObject}->Get(
        'Process::DynamicFieldProcessManagementActivityID'
        );

    if ( !$Ticket{$DynamicFieldProcessID} || !$Ticket{$DynamicFieldActivityID} ) {
        $Self->{LayoutObject}->CustomerFatalError(
            Message =>
                "Can't get ProcessEntityID or ActivityEntityID for Ticket '$Param{TicketID}'!",
        );
    }

    $ActivityActivityDialog = {
        Activity       => $Ticket{$DynamicFieldActivityID},
        ActivityDialog => $ActivityDialogEntityID,
    };

    my $Activity = $Self->{ActivityObject}->ActivityGet(
        Interface        => 'CustomerInterface',
        ActivityEntityID => $ActivityActivityDialog->{Activity}
    );
    if ( !$Activity ) {
        my $Message = "Can't get Activity configuration for ActivityEntityID"
            . " $ActivityActivityDialog->{Activity}!";

        # does not show header and footer again
        if ($IsAJAXUpdate) {
            return $Self->{LayoutObject}->CustomerError(
                Message => $Message,
            );
        }
        else {
            $Self->{LayoutObject}->CustomerFatalError(
                Message => $Message,
            );
        }
    }

    my $ActivityDialog = $Self->{ActivityDialogObject}->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityActivityDialog->{ActivityDialog},
        Interface              => 'CustomerInterface',
    );
    if ( !$ActivityDialog ) {
        my $Message = "Can't get ActivityDialog configuration for ActivityDialogEntityID"
            . " '$ActivityActivityDialog->{ActivityDialog}'!";

        # does not show header and footer again
        if ($IsAJAXUpdate) {
            return $Self->{LayoutObject}->CustomerError(
                Message => $Message,
            );
        }
        else {
            $Self->{LayoutObject}->CustomerFatalError(
                Message => $Message,
            );
        }
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

    if ( !$IsAJAXUpdate ) {
        $Output = $Self->{LayoutObject}->CustomerHeader(
            Type  => 'Small',
            Value => $Ticket{Number},
        );

        # display given notify messages if this is not an ajax request
        if ( IsArrayRefWithData( $Param{Notify} ) ) {

            for my $NotifyString ( @{ $Param{Notify} } ) {
                $Output .= $Self->{LayoutObject}->Notify(
                    Data => $NotifyString,
                );
            }
        }

        $Self->{LayoutObject}->Block(
            Name => 'Header',
            Data => {
                Name => $Self->{LayoutObject}->{LanguageObject}->Get( $ActivityDialog->{Name} )
                    || '',
                }
        );
    }

    # show descriptions
    if ( $ActivityDialog->{DescriptionShort} ) {
        $Self->{LayoutObject}->Block(
            Name => 'DescriptionShort',
            Data => {
                DescriptionShort
                    => $Self->{LayoutObject}->{LanguageObject}->Get(
                    $ActivityDialog->{DescriptionShort},
                    ),
            },
        );
    }
    if ( $ActivityDialog->{DescriptionLong} ) {
        $Self->{LayoutObject}->Block(
            Name => 'DescriptionLong',
            Data => {
                DescriptionLong
                    => $Self->{LayoutObject}->{LanguageObject}->Get(
                    $ActivityDialog->{DescriptionLong},
                    ),
            },
        );
    }

    # show close & cancel link if neccessary
    if ( !$IsAJAXUpdate ) {
        if ( $Param{RenderLocked} ) {
            $Self->{LayoutObject}->Block(
                Name => 'PropertiesLock',
                Data => {
                    %Param,
                    TicketID => $TicketID,
                },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'CancelLink',
            );
        }

    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'ProcessManagement/CustomerActivityDialogHeader',
        Data         => {
            FormName  => 'ActivityDialogDialog' . $ActivityActivityDialog->{ActivityDialog},
            FormID    => $Self->{FormID},
            Subaction => 'StoreActivityDialog',
            TicketID  => $Ticket{TicketID},
            ActivityDialogEntityID => $ActivityActivityDialog->{ActivityDialog},
            ProcessEntityID        => $Param{ProcessEntityID}
                || $Ticket{
                'DynamicField_'
                    . $Self->{ConfigObject}->Get(
                    'Process::DynamicFieldProcessManagementProcessID'
                    )
                },
        },
    );

    my %RenderedFields = ();

    # get the list of fields where the AJAX loader icon should appear on AJAX updates triggered
    # by ActivityDialog fields
    my $AJAXUpdatableFields = $Self->_GetAJAXUpdatableFields(
        ActivityDialogFields => $ActivityDialog->{Fields},
    );

    # Loop through ActivityDialogFields and render their output
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {
        if ( !IsHashRefWithData( $ActivityDialog->{Fields}{$CurrentField} ) ) {
            my $Message = "Can't get data for Field '$CurrentField' of ActivityDialog"
                . " '$ActivityActivityDialog->{ActivityDialog}'!";

            # does not show header and footer again
            if ($IsAJAXUpdate) {
                return $Self->{LayoutObject}->CustomerError(
                    Message => $Message,
                );
            }
            else {
                $Self->{LayoutObject}->CustomerFatalError(
                    Message => $Message,
                );
            }
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
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
                AJAXUpdatableFields => $AJAXUpdatableFields,
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ($IsAJAXUpdate) {
                    return $Self->{LayoutObject}->CustomerError(
                        Message => $Response->{Message},
                    );
                }
                else {
                    $Self->{LayoutObject}->CustomerFatalError(
                        Message => $Response->{Message},
                    );
                }
            }

            $Output .= $Response->{HTML};

            $RenderedFields{$CurrentField} = 1;

        }

        # render Article
        elsif (
            $Self->{NameToID}->{$CurrentField}
            && $Self->{NameToID}->{$CurrentField} eq 'Article'
            )
        {
            next DIALOGFIELD if $RenderedFields{ $Self->{NameToID}->{$CurrentField} };

            my $Response = $Self->_RenderArticle(
                ActivityDialogField => $ActivityDialog->{Fields}{$CurrentField},
                FieldName           => $CurrentField,
                DescriptionShort    => $ActivityDialog->{Fields}{$CurrentField}{DescriptionShort},
                Ticket              => \%Ticket || {},
                Error               => \%Error || {},
                FormID              => $Self->{FormID},
                GetParam            => $Param{GetParam},
            );

            if ( !$Response->{Success} ) {

                # does not show header and footer again
                if ($IsAJAXUpdate) {
                    return $Self->{LayoutObject}->CustomerError(
                        Message => $Response->{Message},
                    );
                }
                else {
                    $Self->{LayoutObject}->CustomerFatalError(
                        Message => $Response->{Message},
                    );
                }
            }

            $Output .= $Response->{HTML};

            $RenderedFields{$CurrentField} = 1;
        }
    }

    my $FooterCSSClass = 'Footer';

    if ($IsAJAXUpdate) {

        # Due to the initial loading of
        # the first ActivityDialog after Process selection
        # we have to bind the AjaxUpdate Function on
        # the selects, so we get the complete JSOnDocumentComplete code
        # and deliver it in the FooterJS block.
        # This Javascript Part is executed in
        # CustomerTicketProcess.dtl
        $Self->{LayoutObject}->Block(
            Name => 'FooterJS',
            Data => { Bindings => $Self->{LayoutObject}->{EnvRef}->{JSOnDocumentComplete} },
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

    $Self->{LayoutObject}->Block(
        Name => 'Footer',
        Data => {
            FooterCSSClass => $FooterCSSClass,
            ButtonText     => $ButtonText,
            ButtonTitle    => $ButtonTitle,
            ButtonID       => $ButtonID

        },
    );

    if ( $ActivityDialog->{SubmitAdviceText} ) {
        $Self->{LayoutObject}->Block(
            Name => 'SubmitAdviceText',
            Data => {
                AdviceText => $ActivityDialog->{SubmitAdviceText},
            },
        );
    }

    # reload parent window
    if ( $Param{ParentReload} ) {
        $Self->{LayoutObject}->Block(
            Name => 'ParentReload',
        );
    }

    # Add the FormFooter
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'ProcessManagement/CustomerActivityDialogFooter',
        Data         => {},
    );

    if ( !$IsAJAXUpdate ) {

        # Add the OTRS Footer
        $Output .= $Self->{LayoutObject}->CustomerFooter( Type => 'Small' );
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
    my $DynamicFieldConfig
        = ( grep { $_->{Name} eq $Param{FieldName} } @{ $Self->{DynamicField} } )[0];

    my $PossibleValuesFilter;

    my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
        DynamicFieldConfig => $DynamicFieldConfig,
        Behavior           => 'IsACLReducible',
    );

    if ($IsACLReducible) {

        # get PossibleValues
        my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        # All Ticket DynamicFields
        # used for ACL checking
        my %DynamicFieldCheckParam = map { $_ => $Param{GetParam}{$_} }
            grep {m{^DynamicField_}xms} ( keys %{ $Param{GetParam} } );

        # check if field has PossibleValues property in its configuration
        if ( IsHashRefWithData($PossibleValues) ) {

            # convert possible values key => value to key => key for ACLs usign a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $Self->{TicketObject}->TicketAcl(
                %{ $Param{GetParam} },
                DynamicField   => \%DynamicFieldCheckParam,
                Action         => $Self->{Action},
                ReturnType     => 'Ticket',
                ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data           => \%AclData,
                CustomerUserID => $Self->{UserID},
            );
            if ($ACL) {
                my %Filter = $Self->{TicketObject}->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValuesFilter}
                    = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }
        }
    }

    my $DynamicFieldHTML = $Self->{BackendObject}->EditFieldRender(
        DynamicFieldConfig   => $DynamicFieldConfig,
        PossibleValuesFilter => $PossibleValuesFilter,
        Value                => $Param{GetParam}{ 'DynamicField_' . $Param{FieldName} },
        LayoutObject         => $Self->{LayoutObject},
        ParamObject          => $Self->{ParamObject},
        AJAXUpdate           => 1,
        Mandatory            => $Param{ActivityDialogField}->{Display} == 2,
        UpdatableFields      => $Param{AJAXUpdatableFields},
    );

    my %Data = (
        Name    => $DynamicFieldHTML->{Name},
        Label   => $DynamicFieldHTML->{Label},
        Content => $DynamicFieldHTML->{Field},
    );

    $Self->{LayoutObject}->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:DynamicField',
        Data => \%Data,
    );
    if ( $Param{DescriptionShort} ) {
        $Self->{LayoutObject}->Block(
            Name => $Param{ActivityDialogField}->{LayoutBlock}
                || 'rw:DynamicField:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    return {
        Success => 1,
        HTML => $Self->{LayoutObject}->Output( TemplateFile => 'ProcessManagement/DynamicField' ),
    };

    return '';

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

    my $ArticleInvalid
        = ( IsHashRefWithData( $Param{Error} ) && $Param{Error}->{'Article'} )
        ? $Param{Error}->{'Article'}
        : '';

    my %Data = (
        Name             => 'Article',
        ArticleInvalid   => $ArticleInvalid,
        ClassMandatory   => '',
        ValidateRequired => '',
        Marker           => '',
        Subject          => $Param{GetParam}{Subject},
        Body             => $Param{GetParam}{Body},
        LabelSubject     => $Param{ActivityDialogField}->{Config}->{LabelSubject}
            || $Self->{LayoutObject}->{LanguageObject}->Get("Subject"),
        LabelBody => $Param{ActivityDialogField}->{Config}->{LabelBody}
            || $Self->{LayoutObject}->{LanguageObject}->Get("Text"),
    );

    # If field is required put in the necessary variables for
    # ValidateRequired class input field, Mandatory class for the label
    # Marker for the label
    if ( $Param{ActivityDialogField}->{Display} && $Param{ActivityDialogField}->{Display} == 2 ) {
        $Data{ValidateRequired} = 'Validate_Required';
        $Data{ClassMandatory}   = ' class="Mandatory"';
        $Data{Marker}           = '<span class="Marker">*</span> ';
    }

    $Self->{LayoutObject}->Block(
        Name => $Param{ActivityDialogField}->{LayoutBlock} || 'rw:Article',
        Data => \%Data,
    );

    $Self->{LayoutObject}->Block(
        Name => 'BodySeparator',
        Data => \%Param,
    );

    # add rich text editor
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Self->{Config}->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Self->{Config}->{RichTextWidth}  || 0;

        $Self->{LayoutObject}->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    if ( length $ArticleInvalid ) {
        $Self->{LayoutObject}->Block(
            Name => 'ServerErrorMsg',
            Data => { Error => $ArticleInvalid },
        );
    }
    if ( $Param{DescriptionShort} ) {
        $Self->{LayoutObject}->Block(
            Name => 'rw:Article:DescriptionShort',
            Data => {
                DescriptionShort => $Param{DescriptionShort},
            },
        );
    }

    # get all attachments meta data
    my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );

    # show attachments
    ATTACHMENT:
    for my $Attachment (@Attachments) {

        next ATTACHMENT if $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText};

        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    return {
        Success => 1,
        HTML => $Self->{LayoutObject}->Output( TemplateFile => 'ProcessManagement/Article' ),
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

    my %TicketParam;

    my $ActivityDialogEntityID = $Param{GetParam}{ActivityDialogEntityID};
    if ( !$ActivityDialogEntityID ) {
        $Self->{LayoutObject}->CustomerFatalError(
            Message => "ActivityDialogEntityID missing!",
        );
    }

    my $ActivityDialog
        = $Self->{ActivityDialogObject}->ActivityDialogGet(
        ActivityDialogEntityID => $ActivityDialogEntityID,
        Interface              => 'CustomerInterface',
        );
    if ( !IsHashRefWithData($ActivityDialog) ) {
        $Self->{LayoutObject}->CustomerFatalError(
            Message => "Couldn't get Config for ActivityDialogEntityID $ActivityDialogEntityID!",
        );
    }

    # If is an action about attachments
    my $IsUpload = 0;

    # attachment delete
    my @AttachmentIDs = map {
        my ($ID) = $_ =~ m{ \A AttachmentDelete (\d+) \z }xms;
        $ID ? $ID : ();
    } $Self->{ParamObject}->GetParamNames();

    COUNT:
    for my $Count ( reverse sort @AttachmentIDs ) {
        my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Count" );
        next COUNT if !$Delete;
        %Error = ();
        $Error{AttachmentDelete} = 1;
        $Self->{UploadCacheObject}->FormIDRemoveFile(
            FormID => $Self->{FormID},
            FileID => $Count,
        );
        $IsUpload = 1;
    }

    # attachment upload
    if ( $Self->{ParamObject}->GetParam( Param => 'AttachmentUpload' ) ) {
        $IsUpload                = 1;
        %Error                   = ();
        $Error{AttachmentUpload} = 1;
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'FileUpload',
        );
        $Self->{UploadCacheObject}->FormIDAddFile(
            FormID => $Self->{FormID},
            %UploadStuff,
        );
    }

   # check each Field of an Activity Dialog and fill the error hash if something goes horribly wrong
    my %CheckedFields;
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {
        if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldName = $1;

           # Get the Config of the current DynamicField (the first element of the grep result array)
            my $DynamicFieldConfig
                = ( grep { $_->{Name} eq $DynamicFieldName } @{ $Self->{DynamicField} } )[0];

            if ( !IsHashRefWithData($DynamicFieldConfig) ) {
                $Self->{LayoutObject}->CustomerFatalError(
                    Message => "DynamicFieldConfig missing for field: $DynamicFieldName!",
                );
            }

            # Will be extended lateron for ACL Checking:
            my $PossibleValuesFilter;

            # Check DynamicField Values
            my $ValidationResult = $Self->{BackendObject}->EditFieldValueValidate(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                ParamObject          => $Self->{ParamObject},
                Mandatory            => $ActivityDialog->{Fields}{$CurrentField}{Display} == 2,
            );

            if ( !IsHashRefWithData($ValidationResult) ) {
                $Self->{LayoutObject}->CustomerFatalError(
                    Message =>
                        "Could not perform validation on field $DynamicFieldConfig->{Label}!",
                );
            }

            if ( $ValidationResult->{ServerError} ) {
                $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
            }

            # if we had an invisible field, use config's default value
            if ( $ActivityDialog->{Fields}{$CurrentField}{Display} == 0 ) {
                $TicketParam{$CurrentField} = $ActivityDialog->{Fields}{$CurrentField}{DefaultValue}
                    || '';
            }

            # else take the DynamicField Value
            else {
                $TicketParam{$CurrentField} =
                    $Self->{BackendObject}->EditFieldValueGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ParamObject        => $Self->{ParamObject},
                    LayoutObject       => $Self->{LayoutObject},
                    );
            }

            # In case of DynamicFields there is no NameToID translation
            # so just take the DynamicField name
            $CheckedFields{$CurrentField} = 1;
        }

        # Article
        else {

            # skip if we've already checked ID or Name
            next if !$Self->{NameToID}->{$CurrentField};
            next DIALOGFIELD if $CheckedFields{ $Self->{NameToID}->{$CurrentField} };

            if ( $ActivityDialog->{Fields}{$CurrentField}{Display} == 2 ) {

                # check if the given field param is valid
                my ( $Body, $Subject ) = (
                    $Self->{ParamObject}->GetParam( Param => 'Body' ),
                    $Self->{ParamObject}->GetParam( Param => 'Subject' )
                );

                if ( !( $Body && $Subject ) ) {
                    $Error{ $Self->{NameToID}->{$CurrentField} } = ' ServerError';
                }
                $CheckedFields{ $Self->{NameToID}->{$CurrentField} } = 1;
            }
        }
    }

    # Get Ticket to check TicketID was valid
    %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 1,
    );

    if ( !IsHashRefWithData( \%Ticket ) ) {
        $Self->{LayoutObject}->CustomerFatalError(
            Message => "Could not Store ActivityDialog, invalid TicketID: $TicketID!",
        );
    }

    $ActivityEntityID = $Ticket{
        'DynamicField_'
            . $Self->{ConfigObject}->Get('Process::DynamicFieldProcessManagementActivityID')
    };
    if ( !$ActivityEntityID )
    {
        return $Self->{LayoutObject}->CustomerErrorScreen(
            Message => "Missing ActivityEntityID in Ticket $Ticket{TicketID}!",
            Comment => 'Please contact the admin.',
        );
    }

    $ProcessEntityID = $Ticket{
        'DynamicField_'
            . $Self->{ConfigObject}->Get('Process::DynamicFieldProcessManagementProcessID')
    };

    if ( !$ProcessEntityID )
    {
        $Self->{LayoutObject}->CustomerFatalError(
            Message => "Missing ProcessEntityID in Ticket $Ticket{TicketID}!",
        );
    }

    # if we got errors go back to displaying the ActivityDialog
    if ( IsHashRefWithData( \%Error ) ) {
        return $Self->_OutputActivityDialog(
            ProcessEntityID        => $ProcessEntityID,
            TicketID               => $TicketID || undef,
            ActivityDialogEntityID => $ActivityDialogEntityID,
            Error                  => \%Error,
            GetParam               => $Param{GetParam},
        );
    }

    # We save only once, no matter if one or more configs are set for the same param
    my %StoredFields;

    # Save loop for storing Ticket Values that were not required on the initial TicketCreate
    DIALOGFIELD:
    for my $CurrentField ( @{ $ActivityDialog->{FieldOrder} } ) {

        if ( !IsHashRefWithData( $ActivityDialog->{Fields}{$CurrentField} ) ) {
            $Self->{LayoutObject}->CustomerFatalError(
                Message => "Can't get data for Field '$CurrentField' of ActivityDialog"
                    . " '$ActivityDialogEntityID'!",
            );
        }

        if ( $CurrentField =~ m{^DynamicField_(.*)}xms ) {
            my $DynamicFieldName = $1;
            my $DynamicFieldConfig
                = ( grep { $_->{Name} eq $DynamicFieldName } @{ $Self->{DynamicField} } )[0];

            my $Success = $Self->{BackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $TicketParam{$CurrentField},
                UserID             => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
            if ( !$Success ) {
                $Self->{LayoutObject}->CustomerFatalError(
                    Message => "Could not set DynamicField value for $CurrentField of Ticket"
                        . " with ID '$TicketID' in ActivityDialog '$ActivityDialogEntityID'!",
                );
            }
        }

        elsif ( $CurrentField eq 'Article' ) {

            if ( $Param{GetParam}{Subject} && $Param{GetParam}{Body} ) {

                # add note
                my $ArticleID = '';
                my $MimeType  = 'text/plain';
                if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                    $MimeType = 'text/html';

                    # verify html document
                    $Param{GetParam}{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                        String => $Param{GetParam}{Body},
                    );
                }

                my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
                $ArticleID = $Self->{TicketObject}->ArticleCreate(
                    TicketID       => $TicketID,
                    SenderType     => 'customer',
                    From           => $From,
                    MimeType       => $MimeType,
                    Charset        => $Self->{LayoutObject}->{UserCharset},
                    UserID         => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                    HistoryType    => 'AddNote',
                    HistoryComment => '%%Note',
                    Body           => $Param{GetParam}{Body},
                    Subject        => $Param{GetParam}{Subject},
                    ArticleType =>
                        $ActivityDialog->{Fields}->{Article}->{Config}->{ArticleType},
                );
                if ( !$ArticleID ) {
                    return $Self->{LayoutObject}->CustomerErrorScreen();
                }

                # get pre loaded attachment
                my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
                    FormID => $Self->{FormID},
                );

                # get submit attachment
                my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
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
                    if ($ContentID) {
                        my $ContentIDHTMLQuote = $Self->{LayoutObject}->Ascii2Html(
                            Text => $ContentID,
                        );

                        # workaround for link encode of rich text editor, see bug#5053
                        my $ContentIDLinkEncode = $Self->{LayoutObject}->LinkEncode($ContentID);
                        $Param{GetParam}{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                        # ignore attachment if not linked in body
                        next ATTACHMENT
                            if $Param{GetParam}{Body}
                            !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                    }

                    # write existing file to backend
                    $Self->{TicketObject}->ArticleWriteAttachment(
                        %{$Attachment},
                        ArticleID => $ArticleID,
                        UserID    => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                    );
                }

                # remove pre submited attachments
                $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );
            }
        }
    }

    # Transitions will be handled by ticket event module (TicketProcessTransitions.pm).

    # load new URL in parent window and close popup
    return $Self->{LayoutObject}->PopupClose(
        URL => "Action=CustomerTicketZoom;TicketID=$TicketID",
    );
}

sub _GetAJAXUpdatableFields {
    my ( $Self, %Param ) = @_;

    # create a DynamicFieldLookupTable
    my %DynamicFieldLookup = map { 'DynamicField_' . $_->{Name} => $_ } @{ $Self->{DynamicField} };

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

            my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next FIELD if !$IsACLReducible;


            push @UpdatableFields, $Field;
        }
    }

    return \@UpdatableFields;
}

1;
