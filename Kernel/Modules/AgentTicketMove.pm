# --
# Kernel/Modules/AgentTicketMove.pm - move tickets to queues
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketMove;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::Web::UploadCache;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (
        qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)
        )
    {
        if ( !$Self->{$Needed} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $Needed!" );
        }
    }
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{UploadCacheObject}  = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    # get params
    $Self->{TicketUnlock} = $Self->{ParamObject}->GetParam( Param => 'TicketUnlock' );

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    # get config for frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => $Self->{Config}->{DynamicField} || {},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(TicketID)) {
        if ( !$Self->{$Needed} ) {
            return $Self->{LayoutObject}->ErrorScreen( Message => "Need $Needed!", );
        }
    }

    # check permissions
    my $Access = $Self->{TicketObject}->TicketPermission(
        Type     => 'move',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need move permissions!",
            WithHeader => 'yes',
        );
    }

    # get ACL restrictions
    $Self->{TicketObject}->TicketAcl(
        Data          => '-',
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $Self->{TicketObject}->TicketAclActionData();

    # check if ACL resctictions if exist
    if ( IsHashRefWithData( \%AclAction ) ) {

        # show error screen if ACL prohibits this action
        if ( defined $AclAction{ $Self->{Action} } && $AclAction{ $Self->{Action} } eq '0' ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
    }

    # check if ticket is locked
    if ( $Self->{TicketObject}->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
        my $AccessOk = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
            OwnerID  => $Self->{UserID},
        );
        if ( !$AccessOk ) {
            my $Output = $Self->{LayoutObject}->Header(
                Type => 'Small',
            );
            $Output .= $Self->{LayoutObject}->Warning(
                Message => $Self->{LayoutObject}->{LanguageObject}
                    ->Get('Sorry, you need to be the ticket owner to perform this action.'),
                Comment =>
                    $Self->{LayoutObject}->{LanguageObject}->Get('Please change the owner first.'),
            );

            # show back link
            $Self->{LayoutObject}->Block(
                Name => 'TicketBack',
                Data => { %Param, TicketID => $Self->{TicketID} },
            );

            $Output .= $Self->{LayoutObject}->Footer(
                Type => 'Small',
            );
            return $Output;
        }
    }

    # ticket attributes
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 1,
    );

    # get params
    my %GetParam;
    for my $Parameter (
        qw(Subject Body TimeUnits
        NewUserID OldUserID NewStateID NewPriorityID
        UserSelection OwnerAll NoSubmit DestQueueID DestQueue
        )
        )
    {
        $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter ) || '';
    }
    for my $Parameter (qw(Year Month Day Hour Minute)) {
        $GetParam{$Parameter} = $Self->{ParamObject}->GetParam( Param => $Parameter );
    }

    # ACL compatibility translations
    my %ACLCompatGetParam;
    $ACLCompatGetParam{NewOwnerType} = $GetParam{UserSelection};
    $ACLCompatGetParam{NewOwnerID}   = $GetParam{NewUserID};
    $ACLCompatGetParam{OldOwnerID}   = $GetParam{OldUserID};
    $ACLCompatGetParam{QueueID}      = $GetParam{DestQueueID};
    $ACLCompatGetParam{Queue}        = $GetParam{DestQueue};

    # get Dynamic fields form ParamObject
    my %DynamicFieldValues;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value form the web request
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} } =
            $Self->{BackendObject}->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $Self->{ParamObject},
            LayoutObject       => $Self->{LayoutObject},
            );
    }

    # convert dynamic field values into a structure for ACLs
    my %DynamicFieldACLParameters;
    DYNAMICFIELD:
    for my $DynamicField ( sort keys %DynamicFieldValues ) {
        next DYNAMICFIELD if !$DynamicField;
        next DYNAMICFIELD if !$DynamicFieldValues{$DynamicField};

        $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicField }
            = $DynamicFieldValues{$DynamicField};
    }
    $GetParam{DynamicField} = \%DynamicFieldACLParameters;

    # transform pending time, time stamp based on user time zone
    if (
        defined $GetParam{Year}
        && defined $GetParam{Month}
        && defined $GetParam{Day}
        && defined $GetParam{Hour}
        && defined $GetParam{Minute}
        )
    {
        %GetParam = $Self->{LayoutObject}->TransformDateSelection(
            %GetParam,
        );
    }

    # rewrap body if no rich text is used
    if ( $GetParam{Body} && !$Self->{LayoutObject}->{BrowserRichText} ) {
        $GetParam{Body} = $Self->{LayoutObject}->WrapPlainText(
            MaxCharacters => $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote'),
            PlainText     => $GetParam{Body},
        );
    }

    # error handling
    my %Error;

    # distinguish between action concerning attachments and the move action
    my $IsUpload = 0;

    # DestQueueID lookup
    if ( !$GetParam{DestQueueID} && $GetParam{DestQueue} ) {
        $GetParam{DestQueueID} = $Self->{QueueObject}->QueueLookup( Queue => $GetParam{DestQueue} );
    }
    if ( !$GetParam{DestQueueID} ) {
        $Error{DestQueue} = 1;
    }

    # do not submit
    if ( $GetParam{NoSubmit} ) {
        $Error{NoSubmit} = 1;
    }

    # check new/old user selection
    if ( $GetParam{UserSelection} && $GetParam{UserSelection} eq 'Old' ) {
        $GetParam{'UserSelection::Old'} = 'checked="checked"';
        if ( $GetParam{OldUserID} ) {
            $GetParam{NewUserID} = $GetParam{OldUserID};
        }
    }
    else {
        $GetParam{'UserSelection::New'} = 'checked="checked"';
    }

    # ajax update
    if ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        my $NewUsers = $Self->_GetUsers(
            %GetParam,
            %ACLCompatGetParam,
            QueueID  => $GetParam{DestQueueID},
            AllUsers => $GetParam{OwnerAll},
        );
        my $OldOwners = $Self->_GetOldOwners(
            %GetParam,
            %ACLCompatGetParam,
            QueueID  => $GetParam{DestQueueID},
            AllUsers => $GetParam{OwnerAll},
        );
        my $NextStates = $Self->_GetNextStates(
            %GetParam,
            %ACLCompatGetParam,
            TicketID => $Self->{TicketID},
            QueueID => $GetParam{DestQueueID} || 1,
        );
        my $NextPriorities = $Self->_GetPriorities(
            %GetParam,
            %ACLCompatGetParam,
            TicketID => $Self->{TicketID},
            QueueID => $GetParam{DestQueueID} || 1,
        );

        # update Dynamc Fields Possible Values via AJAX
        my @DynamicFieldAJAX;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD
                if !$Self->{BackendObject}->IsAJAXUpdateable(
                DynamicFieldConfig => $DynamicFieldConfig,
                );
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';

            my $PossibleValues = $Self->{BackendObject}->AJAXPossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # convert possible values key => value to key => key for ACLs usign a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $Self->{TicketObject}->TicketAcl(
                %GetParam,
                %ACLCompatGetParam,
                Action        => $Self->{Action},
                TicketID      => $Self->{TicketID},
                QueueID       => $GetParam{DestQueueID} || 0,
                ReturnType    => 'Ticket',
                ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data          => \%AclData,
                UserID        => $Self->{UserID},
            );
            if ($ACL) {
                my %Filter = $Self->{TicketObject}->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValues} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }

            # add dynamic field to the list of fields to update
            push(
                @DynamicFieldAJAX,
                {
                    Name        => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data        => $PossibleValues,
                    SelectedID  => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                    Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                    Max         => 100,
                }
            );
        }

        my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
            [
                {
                    Name         => 'NewUserID',
                    Data         => $NewUsers,
                    SelectedID   => $GetParam{NewUserID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'OldUserID',
                    Data         => $OldOwners,
                    SelectedID   => $GetParam{OldUserID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewStateID',
                    Data         => $NextStates,
                    SelectedID   => $GetParam{NewStateID},
                    Translation  => 1,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewPriorityID',
                    Data         => $NextPriorities,
                    SelectedID   => $GetParam{NewPriorityID},
                    Translation  => 1,
                    PossibleNone => 1,
                    Max          => 100,
                },
                @DynamicFieldAJAX,
            ],
        );
        return $Self->{LayoutObject}->Attachment(
            ContentType => 'application/json; charset=' . $Self->{LayoutObject}->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # attachment delete
    for my $Count ( 1 .. 32 ) {
        my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Count" );
        next if !$Delete;
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
            Param  => 'FileUpload',
            Source => 'string',
        );
        $Self->{UploadCacheObject}->FormIDAddFile(
            FormID => $Self->{FormID},
            %UploadStuff,
        );
    }

    # create html strings for all dynamic fields
    my %DynamicFieldHTML;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $PossibleValuesFilter;

        # check if field has PossibleValues property in its configuration
        if ( IsHashRefWithData( $DynamicFieldConfig->{Config}->{PossibleValues} ) ) {

            # convert possible values key => value to key => key for ACLs usign a Hash slice
            my %AclData = %{ $DynamicFieldConfig->{Config}->{PossibleValues} };
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $Self->{TicketObject}->TicketAcl(
                %GetParam,
                %ACLCompatGetParam,
                Action        => $Self->{Action},
                TicketID      => $Self->{TicketID},
                ReturnType    => 'Ticket',
                ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                Data          => \%AclData,
                UserID        => $Self->{UserID},
            );
            if ($ACL) {
                my %Filter = $Self->{TicketObject}->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValuesFilter}
                    = map { $_ => $DynamicFieldConfig->{Config}->{PossibleValues}->{$_} }
                    keys %Filter;
            }
        }

        # to store dynamic field value from database (or undefined)
        my $Value;

        # only get values for Ticket fields (all screens based on AgentTickeActionCommon
        # generates a new article, then article fields will be always empty at the beginign)
        if ( $DynamicFieldConfig->{ObjectType} eq 'Ticket' ) {

            # get value stored on the database from Ticket
            $Value = $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} };
        }

        # get field html
        $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
            $Self->{BackendObject}->EditFieldRender(
            DynamicFieldConfig   => $DynamicFieldConfig,
            PossibleValuesFilter => $PossibleValuesFilter,
            Value                => $Value,
            Mandatory =>
                $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
            LayoutObject    => $Self->{LayoutObject},
            ParamObject     => $Self->{ParamObject},
            AJAXUpdate      => 1,
            UpdatableFields => $Self->_GetFieldsToUpdate(),
            );
    }

    # check for errors
    if ( ( $Self->{Subaction} eq 'MoveTicket' ) && ( !$IsUpload ) ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        if ( $GetParam{DestQueueID} eq '' ) {
            $Error{'DestQueueIDInvalid'} = 'ServerError';
        }

        # Body and Subject must both be filled in or both be empty
        if ( $GetParam{Subject} eq '' && $GetParam{Body} ne '' ) {
            $Error{'SubjectInvalid'} = 'ServerError';
        }

        if ( $GetParam{Subject} ne '' && $GetParam{Body} eq '' ) {
            $Error{'BodyInvalid'} = 'ServerError';
        }

        # check time units
        if (
            $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')
            && $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
            && $GetParam{TimeUnits} eq ''
            )
        {
            $Error{'TimeUnitsInvalid'} = ' ServerError';
        }

        # check pending time
        if ( $GetParam{NewStateID} ) {
            my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $GetParam{NewStateID},
            );

            # check state type
            if ( $StateData{TypeName} =~ /^pending/i ) {

                # check needed stuff
                for my $TimeParameter (qw(Year Month Day Hour Minute)) {
                    if ( !defined $GetParam{$TimeParameter} ) {
                        $Error{'DateInvalid'} = 'ServerError';
                    }
                }

                # check date
                if ( !$Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 ) ) {
                    $Error{'DateInvalid'} = 'ServerError';
                }
                if (
                    $Self->{TimeObject}->Date2SystemTime( %GetParam, Second => 0 )
                    < $Self->{TimeObject}->SystemTime()
                    )
                {
                    $Error{'DateInvalid'} = 'ServerError';
                }
            }
        }

        # clear DynamicFieldHTML
        %DynamicFieldHTML = ();

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            # check if field has PossibleValues property in its configuration
            if ( IsHashRefWithData( $DynamicFieldConfig->{Config}->{PossibleValues} ) ) {

                # convert possible values key => value to key => key for ACLs usign a Hash slice
                my %AclData = %{ $DynamicFieldConfig->{Config}->{PossibleValues} };
                @AclData{ keys %AclData } = keys %AclData;

                # set possible values filter from ACLs
                my $ACL = $Self->{TicketObject}->TicketAcl(
                    %GetParam,
                    %ACLCompatGetParam,
                    Action        => $Self->{Action},
                    TicketID      => $Self->{TicketID},
                    ReturnType    => 'Ticket',
                    ReturnSubType => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data          => \%AclData,
                    UserID        => $Self->{UserID},
                );
                if ($ACL) {
                    my %Filter = $Self->{TicketObject}->TicketAclData();

                    # convert Filer key => key back to key => value using map
                    %{$PossibleValuesFilter}
                        = map { $_ => $DynamicFieldConfig->{Config}->{PossibleValues}->{$_} }
                        keys %Filter;
                }
            }

            my $ValidationResult;

            # do not validate on attachment upload
            if ( !$IsUpload ) {

                $ValidationResult = $Self->{BackendObject}->EditFieldValueValidate(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    ParamObject          => $Self->{ParamObject},
                    Mandatory =>
                        $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                );

                if ( !IsHashRefWithData($ValidationResult) ) {
                    return $Self->{LayoutObject}->ErrorScreen(
                        Message =>
                            "Could not perform validation on field $DynamicFieldConfig->{Label}!",
                        Comment => 'Please contact the admin.',
                    );
                }

                # propagate validation error to the Error variable to be detected by the frontend
                if ( $ValidationResult->{ServerError} ) {
                    $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
                }
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} }
                = $Self->{BackendObject}->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                Mandatory =>
                    $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                ServerError  => $ValidationResult->{ServerError}  || '',
                ErrorMessage => $ValidationResult->{ErrorMessage} || '',
                LayoutObject => $Self->{LayoutObject},
                ParamObject  => $Self->{ParamObject},
                AJAXUpdate   => 1,
                UpdatableFields => $Self->_GetFieldsToUpdate(),
                );
        }
    }

    # check errors
    if (%Error) {

        my $Output = $Self->{LayoutObject}->Header(
            Type => 'Small',
        );

        # get lock state && write (lock) permissions
        if ( !$Self->{TicketObject}->TicketLockGet( TicketID => $Self->{TicketID} ) ) {

            # set owner
            $Self->{TicketObject}->TicketOwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );

            # set lock
            my $Success = $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );

            # show lock state
            if ($Success) {
                $Self->{LayoutObject}->Block(
                    Name => 'PropertiesLock',
                    Data => { %Param, TicketID => $Self->{TicketID} },
                );
                $Self->{TicketUnlock} = 1;
            }
        }
        else {
            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, you need to be the ticket owner to perform this action.",
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer(
                    Type => 'Small',
                );
                return $Output;
            }

            # show back link
            $Self->{LayoutObject}->Block(
                Name => 'TicketBack',
                Data => { %Param, TicketID => $Self->{TicketID} },
            );
        }

        # fetch all queues
        my %MoveQueues = $Self->{TicketObject}->MoveList(
            %GetParam,
            %ACLCompatGetParam,
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
            Action   => $Self->{Action},
            Type     => 'move_into',
        );

        # get next states
        my $NextStates = $Self->_GetNextStates(
            %GetParam,
            %ACLCompatGetParam,
            TicketID => $Self->{TicketID},
            QueueID => $GetParam{DestQueueID} || 1,
        );

        # get next priorities
        my $NextPriorities = $Self->_GetPriorities(
            %GetParam,
            %ACLCompatGetParam,
            TicketID => $Self->{TicketID},
            QueueID => $GetParam{DestQueueID} || 1,
        );

        # get old owners
        my @OldUserInfo = $Self->{TicketObject}->TicketOwnerList(
            %GetParam,
            %ACLCompatGetParam,
            TicketID => $Self->{TicketID}
        );

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # print change form
        $Output .= $Self->AgentMove(
            OldUser        => \@OldUserInfo,
            Attachments    => \@Attachments,
            MoveQueues     => \%MoveQueues,
            TicketID       => $Self->{TicketID},
            NextStates     => $NextStates,
            NextPriorities => $NextPriorities,
            TicketUnlock   => $Self->{TicketUnlock},
            TimeUnits      => $GetParam{TimeUnits},
            FormID         => $Self->{FormID},
            %Ticket,
            DynamicFieldHTML => \%DynamicFieldHTML,
            %GetParam,
            %Error,
        );
        $Output .= $Self->{LayoutObject}->Footer(
            Type => 'Small',
        );
        return $Output;
    }

    # move ticket (send notification if no new owner is selected)
    my $BodyAsText = '';
    if ( $Self->{LayoutObject}->{BrowserRichText} ) {
        $BodyAsText = $Self->{LayoutObject}->RichText2Ascii(
            String => $GetParam{Body} || 0,
        );
    }
    else {
        $BodyAsText = $GetParam{Body} || 0;
    }
    my $Move = $Self->{TicketObject}->TicketQueueSet(
        QueueID            => $GetParam{DestQueueID},
        UserID             => $Self->{UserID},
        TicketID           => $Self->{TicketID},
        SendNoNotification => $GetParam{NewUserID},
        Comment            => $BodyAsText,
    );
    if ( !$Move ) {
        return $Self->{LayoutObject}->ErrorScreen();
    }

    # set priority
    if ( $Self->{Config}->{Priority} && $GetParam{NewPriorityID} ) {
        $Self->{TicketObject}->TicketPrioritySet(
            TicketID   => $Self->{TicketID},
            PriorityID => $GetParam{NewPriorityID},
            UserID     => $Self->{UserID},
        );
    }

    # set state
    if ( $Self->{Config}->{State} && $GetParam{NewStateID} ) {
        $Self->{TicketObject}->TicketStateSet(
            TicketID => $Self->{TicketID},
            StateID  => $GetParam{NewStateID},
            UserID   => $Self->{UserID},
        );

        # unlock the ticket after close
        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
            ID => $GetParam{NewStateID},
        );

        # set unlock on close
        if ( $StateData{TypeName} =~ /^close/i ) {
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }

        # set pending time on pendig state
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            $Self->{TicketObject}->TicketPendingTimeSet(
                UserID   => $Self->{UserID},
                TicketID => $Self->{TicketID},
                Year     => $GetParam{Year},
                Month    => $GetParam{Month},
                Day      => $GetParam{Day},
                Hour     => $GetParam{Hour},
                Minute   => $GetParam{Minute},
            );
        }
    }

    # check if new user is given and send notification
    if ( $GetParam{NewUserID} ) {

        # lock
        $Self->{TicketObject}->TicketLockSet(
            TicketID => $Self->{TicketID},
            Lock     => 'lock',
            UserID   => $Self->{UserID},
        );

        # set owner
        $Self->{TicketObject}->TicketOwnerSet(
            TicketID  => $Self->{TicketID},
            UserID    => $Self->{UserID},
            NewUserID => $GetParam{NewUserID},
            Comment   => $BodyAsText,
        );
    }

    # force unlock if no new owner is set and ticket was unlocked
    else {
        if ( $Self->{TicketUnlock} ) {
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }
    }

    # add note (send no notification)
    my $ArticleID;

    if ( $GetParam{Body} ) {

        # get pre-loaded attachments
        my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submitted attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'FileUpload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        my $MimeType = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # remove unused inline images
            my @NewAttachmentData;
            for my $Attachment (@AttachmentData) {
                my $ContentID = $Attachment->{ContentID};
                if ($ContentID) {
                    my $ContentIDHTMLQuote = $Self->{LayoutObject}->Ascii2Html(
                        Text => $ContentID,
                    );
                    next if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # remember inline images and normal attachments
                push @NewAttachmentData, \%{$Attachment};
            }
            @AttachmentData = @NewAttachmentData;

            # verify html document
            $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID       => $Self->{TicketID},
            ArticleType    => 'note-internal',
            SenderType     => 'agent',
            From           => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
            Subject        => $GetParam{Subject},
            Body           => $GetParam{Body},
            MimeType       => $MimeType,
            Charset        => $Self->{LayoutObject}->{UserCharset},
            UserID         => $Self->{UserID},
            HistoryType    => 'AddNote',
            HistoryComment => '%%Move',
            NoAgentNotify  => 1,
        );
        if ( !$ArticleID ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # write attachments
        for my $Attachment (@AttachmentData) {
            $Self->{TicketObject}->ArticleWriteAttachment(
                %{$Attachment},
                ArticleID => $ArticleID,
                UserID    => $Self->{UserID},
            );
        }

        # remove pre-submitted attachments
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );
    }

    # only set the dynamic fields if the new window was displayed (link), otherwise if ticket was
    # moved from the dropdown menu (form) in AgentTicketZoom, the value if the dynamic fields will
    # be undefined and it will set to empty in the DB, see bug#8481
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') eq 'link' ) {

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # set the object ID (TicketID or ArticleID) depending on the field configration
            my $ObjectID
                = $DynamicFieldConfig->{ObjectType} eq 'Article' ? $ArticleID : $Self->{TicketID};

            # set the value
            my $Success = $Self->{BackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ObjectID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{UserID},
            );
        }
    }

    # time accounting
    if ( $GetParam{TimeUnits} ) {
        $Self->{TicketObject}->TicketAccountTime(
            TicketID  => $Self->{TicketID},
            ArticleID => $ArticleID,
            TimeUnit  => $GetParam{TimeUnits},
            UserID    => $Self->{UserID},
        );
    }

    # check permission for redirect
    my $AccessNew = $Self->{TicketObject}->TicketPermission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    my $NextScreen = $Self->{Config}->{NextScreen} || 'LastScreenView';

    # redirect to last overview if we do not have ro permissions anymore,
    # or if SysConfig option is set.
    if ( !$AccessNew || $NextScreen eq 'LastScreenOverview' ) {

        # Module directly called
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') eq 'form' ) {
            return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenOverview} );
        }

        # Module opened in popup
        elsif ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') eq 'link' ) {
            return $Self->{LayoutObject}->PopupClose(
                URL => ( $Self->{LastScreenOverview} || 'Action=AgentDashboard' ),
            );
        }
    }

    # Module directly called
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') eq 'form' ) {
        return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenView} );
    }

    # Module opened in popup
    elsif ( $Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') eq 'link' ) {
        return $Self->{LayoutObject}->PopupClose(
            URL => ( $Self->{LastScreenView} || 'Action=AgentDashboard' ),
        );
    }
}

sub AgentMove {
    my ( $Self, %Param ) = @_;

    $Param{DestQueueIDInvalid} = $Param{DestQueueIDInvalid} || '';

    my %Data       = %{ $Param{MoveQueues} };
    my %MoveQueues = %Data;
    my %UsedData;
    my %UserHash;
    if ( $Param{OldUser} ) {
        my $Counter = 1;
        for my $User ( reverse @{ $Param{OldUser} } ) {
            next if $UserHash{ $User->{UserID} };
            $UserHash{ $User->{UserID} } = "$Counter: $User->{UserLastname} "
                . "$User->{UserFirstname} ($User->{UserLogin})";
            $Counter++;
        }
    }
    my $OldUserSelectedID = $Param{OldUserID};
    if ( !$OldUserSelectedID && $Param{OldUser}->[0]->{UserID} ) {
        $OldUserSelectedID = $Param{OldUser}->[0]->{UserID} . '1';
    }

    my $DynamicFieldNames = $Self->_GetFieldsToUpdate(
        OnlyDynamicFields => 1
    );

    # create a string with the quoted dynamic field names separated by commas
    if ( IsArrayRefWithData($DynamicFieldNames) ) {
        for my $Field ( @{$DynamicFieldNames} ) {
            $Param{DynamicFieldNamesStrg} .= ", '" . $Field . "'";
        }
    }

    # build string
    $Param{OldUserStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => \%UserHash,
        SelectedID   => $OldUserSelectedID,
        Name         => 'OldUserID',
        Translation  => 0,
        PossibleNone => 1,
    );

    # build next states string
    $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => $Param{NextStates},
        Name         => 'NewStateID',
        SelectedID   => $Param{NewStateID},
        Translation  => 1,
        PossibleNone => 1,
    );

    # build next priority string
    $Param{NextPrioritiesStrg} = $Self->{LayoutObject}->BuildSelection(
        Data         => $Param{NextPriorities},
        Name         => 'NewPriorityID',
        SelectedID   => $Param{NewPriorityID},
        Translation  => 1,
        PossibleNone => 1,
    );

    # build owner string
    $Param{OwnerStrg} = $Self->{LayoutObject}->BuildSelection(
        Data => $Self->_GetUsers(
            QueueID  => $Param{DestQueueID},
            AllUsers => $Param{OwnerAll},
        ),
        Name         => 'NewUserID',
        SelectedID   => $Param{NewUserID},
        Translation  => 0,
        PossibleNone => 1,
    );

    # set state
    if ( $Self->{Config}->{State} ) {
        $Self->{LayoutObject}->Block(
            Name => 'State',
            Data => {%Param},
        );
    }

    for my $StateID ( sort keys %{ $Param{NextStates} } ) {
        next if !$StateID;
        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet( ID => $StateID );
        if ( $StateData{TypeName} =~ /pending/i ) {
            $Param{DateString} = $Self->{LayoutObject}->BuildDateSelection(
                Format           => 'DateInputFormatLong',
                YearPeriodPast   => 0,
                YearPeriodFuture => 5,
                DiffTime         => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime')
                    || 0,
                %Param,
                Class => $Param{DateInvalid} || ' ',
                Validate             => 1,
                ValidateDateInFuture => 1,
            );
            $Self->{LayoutObject}->Block(
                Name => 'StatePending',
                Data => \%Param,
            );
            last;
        }
    }

    # set priority
    if ( $Self->{Config}->{Priority} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => {%Param},
        );
    }

    # set move queues
    $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => { %MoveQueues, '' => '-' },
        Multiple       => 0,
        Size           => 0,
        Class          => 'Validate_Required' . ' ' . $Param{DestQueueIDInvalid},
        Name           => 'DestQueueID',
        SelectedID     => $Param{DestQueueID},
        CurrentQueueID => $Param{QueueID},
        OnChangeSubmit => 0,
    );

    # show time accounting box
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime') ) {
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime') ) {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabelMandatory',
                Data => \%Param,
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'TimeUnitsLabel',
                Data => \%Param,
            );
        }
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => {
                %Param,
                TimeUnitsRequired => (
                    $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
                    ? 'Validate_Required'
                    : ''
                ),
                }
        );
    }

    # show spell check
    if ( $Self->{LayoutObject}->{BrowserSpellChecker} ) {
        $Self->{LayoutObject}->Block(
            Name => 'TicketOptions',
            Data => {},
        );
        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }

    # show attachments
    for my $Attachment ( @{ $Param{Attachments} } ) {
        next if $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText};
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    # Dynamic fields
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip fields that HTML could not be retrieved
        next DYNAMICFIELD if !IsHashRefWithData(
            $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} }
        );

        # get the html strings form $Param
        my $DynamicFieldHTML = $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} };

        $Self->{LayoutObject}->Block(
            Name => 'DynamicField',
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );

        # example of dynamic fields order customization
        $Self->{LayoutObject}->Block(
            Name => 'DynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );

    }

    # fillup configured default vars
    if ( $Param{Body} eq '' && $Self->{Config}->{Body} ) {
        $Param{Body} = $Self->{LayoutObject}->Output(
            Template => $Self->{Config}->{Body},
        );
    }

    if ( $Param{Subject} eq '' && $Self->{Config}->{Subject} ) {
        $Param{Subject} = $Self->{LayoutObject}->Output(
            Template => $Self->{Config}->{Subject},
        );
    }

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

    return $Self->{LayoutObject}->Output( TemplateFile => 'AgentTicketMove', Data => \%Param );
}

sub _GetUsers {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(%Param);
        for my $UserGroupMember ( sort keys %AllGroupsMembers ) {
            my $Hit = 0;
            for my $UID (@UserIDs) {
                if ( $UID eq $UserGroupMember ) {
                    $Hit = 1;
                }
            }
            if ( !$Hit ) {
                delete $AllGroupsMembers{$UserGroupMember};
            }
        }
    }

    # check show users
    if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Self->{GroupObject}->GroupMemberList(
            GroupID => $GID,
            Type    => 'owner',
            Result  => 'HASH',
        );
        for my $MemberUsers ( sort keys %MemberList ) {
            if ( $AllGroupsMembers{$MemberUsers} ) {
                $ShownUsers{$MemberUsers} = $AllGroupsMembers{$MemberUsers};
            }
        }
    }

    # workflow
    my $ACL = $Self->{TicketObject}->TicketAcl(
        %Param,
        ReturnType    => 'Ticket',
        ReturnSubType => 'NewOwner',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $Self->{TicketObject}->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetOldOwners {
    my ( $Self, %Param ) = @_;
    my @OldUserInfo = $Self->{TicketObject}->TicketOwnerList( TicketID => $Self->{TicketID} );
    my %UserHash;
    if (@OldUserInfo) {
        my $Counter = 1;
        for my $User ( reverse @OldUserInfo ) {
            next if $UserHash{ $User->{UserID} };
            $UserHash{ $User->{UserID} } = "$Counter: $User->{UserLastname} "
                . "$User->{UserFirstname} ($User->{UserLogin})";
            $Counter++;
        }
    }
    if ( !%UserHash ) {
        $UserHash{''} = '-';
    }

    # workflow
    my $ACL = $Self->{TicketObject}->TicketAcl(
        %Param,
        ReturnType    => 'Ticket',
        ReturnSubType => 'OldOwner',
        Data          => \%UserHash,
        UserID        => $Self->{UserID},
    );

    return { $Self->{TicketObject}->TicketAclData() } if $ACL;

    return \%UserHash;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    # get priority
    my %Priorities;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Self->{TicketObject}->TicketPriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %NextStates = $Self->{TicketObject}->TicketStateList(
            %Param,
            Type   => 'DefaultNextMove',
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%NextStates;
}

sub _GetFieldsToUpdate {
    my ( $Self, %Param ) = @_;

    my @UpdatableFields;

    # set the fields that can be updatable via AJAXUpdate
    if ( !$Param{OnlyDynamicFields} ) {
        @UpdatableFields
            = qw( DestQueueID NewUserID OldUserID NewStateID NewPriorityID );
    }

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $Updateable = $Self->{BackendObject}->IsAJAXUpdateable(
            DynamicFieldConfig => $DynamicFieldConfig,
        );

        next DYNAMICFIELD if !$Updateable;

        push @UpdatableFields, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    return \@UpdatableFields;
}

1;
