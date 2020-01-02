# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Modules::AgentTicketMove;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);
use Kernel::Language qw(Translatable);

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # Try to load draft if requested.
    if (
        $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}")->{FormDraft}
        && $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'LoadFormDraft' )
        && $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormDraftID' )
        )
    {
        $Self->{LoadedFormDraftID} = $Kernel::OM->Get('Kernel::System::Web::Request')->LoadFormDraft(
            FormDraftID => $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormDraftID' ),
            UserID      => $Self->{UserID},
        );
    }

    # get form id
    $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate();
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get needed objects
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # check needed stuff
    for my $Needed (qw(TicketID)) {
        if ( !$Self->{$Needed} ) {
            return $LayoutObject->ErrorScreen(
                Message => $LayoutObject->{LanguageObject}->Translate( 'Need %s!', $Needed ),
            );
        }
    }

    # check permissions
    my $Access = $TicketObject->TicketPermission(
        Type     => 'move',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $LayoutObject->NoPermission(
            Message    => Translatable("You need move permissions!"),
            WithHeader => 'yes',
        );
    }

    # get ACL restrictions
    my %PossibleActions = ( 1 => $Self->{Action} );

    my $ACL = $TicketObject->TicketAcl(
        Data          => \%PossibleActions,
        Action        => $Self->{Action},
        TicketID      => $Self->{TicketID},
        ReturnType    => 'Action',
        ReturnSubType => '-',
        UserID        => $Self->{UserID},
    );
    my %AclAction = $TicketObject->TicketAclActionData();

    # check if ACL restrictions exist
    if ( $ACL || IsHashRefWithData( \%AclAction ) ) {

        my %AclActionLookup = reverse %AclAction;

        # show error screen if ACL prohibits this action
        if ( !$AclActionLookup{ $Self->{Action} } ) {
            return $LayoutObject->NoPermission( WithHeader => 'yes' );
        }
    }

    # Check for failed draft loading request.
    if (
        $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'LoadFormDraft' )
        && !$Self->{LoadedFormDraftID}
        )
    {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Loading draft failed!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # check if ticket is locked
    if ( $TicketObject->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
        my $AccessOk = $TicketObject->OwnerCheck(
            TicketID => $Self->{TicketID},
            OwnerID  => $Self->{UserID},
        );
        if ( !$AccessOk ) {
            my $Output = $LayoutObject->Header(
                Type      => 'Small',
                BodyClass => 'Popup',
            );
            $Output .= $LayoutObject->Warning(
                Message => Translatable('Sorry, you need to be the ticket owner to perform this action.'),
                Comment => Translatable('Please change the owner first.'),
            );

            # show back link
            $LayoutObject->Block(
                Name => 'TicketBack',
                Data => { %Param, TicketID => $Self->{TicketID} },
            );

            $Output .= $LayoutObject->Footer(
                Type => 'Small',
            );
            return $Output;
        }
    }

    # ticket attributes
    my %Ticket = $TicketObject->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 1,
    );

    # get param object
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');

    # get params
    my %GetParam;
    for my $Parameter (
        qw(Subject Body
        NewUserID NewStateID NewPriorityID
        OwnerAll NoSubmit DestQueueID DestQueue
        StandardTemplateID CreateArticle FormDraftID Title
        )
        )
    {
        $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter ) || '';
    }
    for my $Parameter (qw(Year Month Day Hour Minute TimeUnits)) {
        $GetParam{$Parameter} = $ParamObject->GetParam( Param => $Parameter );
    }

    # ACL compatibility translations
    my %ACLCompatGetParam;
    $ACLCompatGetParam{NewOwnerID} = $GetParam{NewUserID};
    $ACLCompatGetParam{QueueID}    = $GetParam{DestQueueID};
    $ACLCompatGetParam{Queue}      = $GetParam{DestQueue};

    # get Dynamic fields form ParamObject
    my %DynamicFieldValues;

    # define the dynamic fields to show based on the object type
    my $ObjectType = ['Ticket'];

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get config for frontend module
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # only screens that add notes can modify Article dynamic fields
    if ( $Config->{Note} ) {
        $ObjectType = [ 'Ticket', 'Article' ];
    }

    # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => $ObjectType,
        FieldFilter => $Config->{DynamicField} || {},
    );

    # get dynamic field backend object
    my $DynamicFieldBackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value from the web request
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} } =
            $DynamicFieldBackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $ParamObject,
            LayoutObject       => $LayoutObject,
            );
    }

    # convert dynamic field values into a structure for ACLs
    my %DynamicFieldACLParameters;
    DYNAMICFIELD:
    for my $DynamicFieldItem ( sort keys %DynamicFieldValues ) {
        next DYNAMICFIELD if !$DynamicFieldItem;
        next DYNAMICFIELD if !defined $DynamicFieldValues{$DynamicFieldItem};

        $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicFieldItem } = $DynamicFieldValues{$DynamicFieldItem};
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
        %GetParam = $LayoutObject->TransformDateSelection(
            %GetParam,
        );
    }

    # rewrap body if no rich text is used
    if ( $GetParam{Body} && !$LayoutObject->{BrowserRichText} ) {
        $GetParam{Body} = $LayoutObject->WrapPlainText(
            MaxCharacters => $ConfigObject->Get('Ticket::Frontend::TextAreaNote'),
            PlainText     => $GetParam{Body},
        );
    }

    # error handling
    my %Error;

    # distinguish between action concerning attachments and the move action
    my $IsUpload = 0;

    # Get and validate draft action.
    my $FormDraftAction = $ParamObject->GetParam( Param => 'FormDraftAction' );
    if ( $FormDraftAction && !$Config->{FormDraft} ) {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('FormDraft functionality disabled!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    my %FormDraftResponse;

    # Check draft name.
    if (
        $FormDraftAction
        && ( $FormDraftAction eq 'Add' || $FormDraftAction eq 'Update' )
        )
    {
        my $Title = $ParamObject->GetParam( Param => 'FormDraftTitle' );

        # A draft name is required.
        if ( !$Title ) {

            %FormDraftResponse = (
                Success      => 0,
                ErrorMessage => $Kernel::OM->Get('Kernel::Language')->Translate("Draft name is required!"),
            );
        }

        # Chosen draft name must be unique.
        else {
            my $FormDraftList = $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftListGet(
                ObjectType => 'Ticket',
                ObjectID   => $Self->{TicketID},
                Action     => $Self->{Action},
                UserID     => $Self->{UserID},
            );
            DRAFT:
            for my $FormDraft ( @{$FormDraftList} ) {

                # No existing draft with same name.
                next DRAFT if $Title ne $FormDraft->{Title};

                # Same name for update on existing draft.
                if (
                    $GetParam{FormDraftID}
                    && $FormDraftAction eq 'Update'
                    && $GetParam{FormDraftID} eq $FormDraft->{FormDraftID}
                    )
                {
                    next DRAFT;
                }

                # Another draft with the chosen name already exists.
                %FormDraftResponse = (
                    Success      => 0,
                    ErrorMessage => $Kernel::OM->Get('Kernel::Language')
                        ->Translate( "FormDraft name %s is already in use!", $Title ),
                );
                $IsUpload = 1;
                last DRAFT;
            }
        }
    }

    # Perform draft action instead of saving form data in ticket/article.
    if ( $FormDraftAction && !%FormDraftResponse ) {

        # Reset FormDraftID to prevent updating existing draft.
        if ( $FormDraftAction eq 'Add' && $GetParam{FormDraftID} ) {
            $ParamObject->{Query}->param(
                -name  => 'FormDraftID',
                -value => '',
            );
        }

        my $FormDraftActionOk;
        if (
            $FormDraftAction eq 'Add'
            ||
            ( $FormDraftAction eq 'Update' && $GetParam{FormDraftID} )
            )
        {
            $FormDraftActionOk = $ParamObject->SaveFormDraft(
                UserID         => $Self->{UserID},
                ObjectType     => 'Ticket',
                ObjectID       => $Self->{TicketID},
                OverrideParams => {
                    NoSubmit     => 1,
                    TicketUnlock => undef,
                },
            );
        }
        elsif ( $FormDraftAction eq 'Delete' && $GetParam{FormDraftID} ) {
            $FormDraftActionOk = $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftDelete(
                FormDraftID => $GetParam{FormDraftID},
                UserID      => $Self->{UserID},
            );
        }

        if ($FormDraftActionOk) {
            $FormDraftResponse{Success} = 1;
        }
        else {
            %FormDraftResponse = (
                Success      => 0,
                ErrorMessage => 'Could not perform requested draft action!',
            );
        }
    }

    if (%FormDraftResponse) {

        # build JSON output
        my $JSON = $LayoutObject->JSONEncode(
            Data => \%FormDraftResponse,
        );

        # send JSON response
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # DestQueueID lookup
    if ( !$GetParam{DestQueueID} && $GetParam{DestQueue} ) {
        $GetParam{DestQueueID}
            = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $GetParam{DestQueue} );
    }
    if ( !$GetParam{DestQueueID} ) {
        $Error{DestQueue} = 1;
    }

    # Check if destination queue is restricted by ACL.
    my $DestQueues = $Self->_GetQueues(
        %GetParam,
        %ACLCompatGetParam,
        TicketID => $Self->{TicketID},
    );
    if ( $GetParam{DestQueueID} && !exists $DestQueues->{ $GetParam{DestQueueID} } ) {
        return $LayoutObject->NoPermission( WithHeader => 'yes' );
    }

    # do not submit
    if ( $GetParam{NoSubmit} ) {
        $Error{NoSubmit} = 1;
    }

    # get upload cache object
    my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

    # Check if TreeView list type is activated.
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # Ajax update
    if ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my $ElementChanged = $ParamObject->GetParam( Param => 'ElementChanged' ) || '';

        my $NewUsers = $Self->_GetUsers(
            %GetParam,
            %ACLCompatGetParam,
            QueueID  => $GetParam{DestQueueID},
            AllUsers => $GetParam{OwnerAll},
        );
        my $NextStates = $Self->_GetNextStates(
            %GetParam,
            %ACLCompatGetParam,
            TicketID => $Self->{TicketID},
            QueueID  => $GetParam{DestQueueID} || $Ticket{QueueID},
        );
        my $NextPriorities = $Self->_GetPriorities(
            %GetParam,
            %ACLCompatGetParam,
            TicketID => $Self->{TicketID},
            QueueID  => $GetParam{DestQueueID} || $Ticket{QueueID},
        );

        # update Dynamc Fields Possible Values via AJAX
        my @DynamicFieldAJAX;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next DYNAMICFIELD if !$IsACLReducible;

            my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $TicketObject->TicketAcl(
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
                my %Filter = $TicketObject->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValues} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }

            my $DataValues = $DynamicFieldBackendObject->BuildSelectionDataGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                PossibleValues     => $PossibleValues,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
            ) || $PossibleValues;

            # add dynamic field to the list of fields to update
            push(
                @DynamicFieldAJAX,
                {
                    Name        => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data        => $DataValues,
                    SelectedID  => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                    Translation => $DynamicFieldConfig->{Config}->{TranslatableValues} || 0,
                    Max         => 100,
                }
            );
        }

        my $StandardTemplates = $Self->_GetStandardTemplates(
            %GetParam,
            QueueID  => $GetParam{DestQueueID} || '',
            TicketID => $Self->{TicketID},
        );

        my @TemplateAJAX;

        # update ticket body and attachments if needed.
        if ( $ElementChanged eq 'StandardTemplateID' ) {
            my @TicketAttachments;
            my $TemplateText;

            # remove all attachments from the Upload cache
            my $RemoveSuccess = $UploadCacheObject->FormIDRemove(
                FormID => $Self->{FormID},
            );
            if ( !$RemoveSuccess ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Form attachments could not be deleted!",
                );
            }

            # get the template text and set new attachments if a template is selected
            if ( IsPositiveInteger( $GetParam{StandardTemplateID} ) ) {
                my $TemplateGenerator = $Kernel::OM->Get('Kernel::System::TemplateGenerator');

                # set template text, replace smart tags (limited as ticket is not created)
                $TemplateText = $TemplateGenerator->Template(
                    TemplateID => $GetParam{StandardTemplateID},
                    TicketID   => $Self->{TicketID},
                    UserID     => $Self->{UserID},
                );

                # create StdAttachmentObject
                my $StdAttachmentObject = $Kernel::OM->Get('Kernel::System::StdAttachment');

                # add std. attachments to ticket
                my %AllStdAttachments = $StdAttachmentObject->StdAttachmentStandardTemplateMemberList(
                    StandardTemplateID => $GetParam{StandardTemplateID},
                );
                for ( sort keys %AllStdAttachments ) {
                    my %AttachmentsData = $StdAttachmentObject->StdAttachmentGet( ID => $_ );
                    $UploadCacheObject->FormIDAddFile(
                        FormID      => $Self->{FormID},
                        Disposition => 'attachment',
                        %AttachmentsData,
                    );
                }

                # send a list of attachments in the upload cache back to the clientside JavaScript
                # which renders then the list of currently uploaded attachments
                @TicketAttachments = $UploadCacheObject->FormIDGetAllFilesMeta(
                    FormID => $Self->{FormID},
                );

                for my $Attachment (@TicketAttachments) {
                    $Attachment->{Filesize} = $LayoutObject->HumanReadableDataSize(
                        Size => $Attachment->{Filesize},
                    );
                }
            }

            @TemplateAJAX = (
                {
                    Name => 'UseTemplateNote',
                    Data => '0',
                },
                {
                    Name => 'RichText',
                    Data => $TemplateText || '',
                },
                {
                    Name     => 'TicketAttachments',
                    Data     => \@TicketAttachments,
                    KeepData => 1,
                },
            );
        }

        my $JSON = $LayoutObject->BuildSelectionJSON(
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
                {
                    Name         => 'StandardTemplateID',
                    Data         => $StandardTemplates,
                    SelectedID   => $GetParam{StandardTemplateID},
                    PossibleNone => 1,
                    Translation  => 1,
                    Max          => 100,
                },
                {
                    Name         => 'DestQueueID',
                    Data         => $DestQueues,
                    SelectedID   => $GetParam{DestQueueID},
                    PossibleNone => 1,
                    Translation  => 0,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
                @DynamicFieldAJAX,
                @TemplateAJAX,
            ],
        );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }

    # create HTML strings for all dynamic fields
    my %DynamicFieldHTML;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $PossibleValuesFilter;

        my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsACLReducible',
        );

        if ($IsACLReducible) {

            # get PossibleValues
            my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # check if field has PossibleValues property in its configuration
            if ( IsHashRefWithData($PossibleValues) ) {

                # convert possible values key => value to key => key for ACLs using a Hash slice
                my %AclData = %{$PossibleValues};
                @AclData{ keys %AclData } = keys %AclData;

                # set possible values filter from ACLs
                my $ACL = $TicketObject->TicketAcl(
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
                    my %Filter = $TicketObject->TicketAclData();

                    # convert Filer key => key back to key => value using map
                    %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                        keys %Filter;
                }
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
            $DynamicFieldBackendObject->EditFieldRender(
            DynamicFieldConfig   => $DynamicFieldConfig,
            PossibleValuesFilter => $PossibleValuesFilter,
            Value                => $Value,
            Mandatory =>
                $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
            LayoutObject    => $LayoutObject,
            ParamObject     => $ParamObject,
            AJAXUpdate      => 1,
            UpdatableFields => $Self->_GetFieldsToUpdate(),
            );
    }

    # get state object
    my $StateObject = $Kernel::OM->Get('Kernel::System::State');

    # move action
    if ( $Self->{Subaction} eq 'MoveTicket' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck();

        if ( $GetParam{DestQueueID} eq '' ) {
            $Error{'DestQueueIDInvalid'} = 'ServerError';
        }

        # check time units
        if (
            $ConfigObject->Get('Ticket::Frontend::AccountTime')
            && $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            && $GetParam{TimeUnits} eq ''
            && $Config->{Note}
            )
        {
            $Error{'TimeUnitsInvalid'} = ' ServerError';
        }

        # check pending time
        if ( $GetParam{NewStateID} ) {
            my %StateData = $StateObject->StateGet(
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

                # create a datetime object based on pending date
                my $PendingDateTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        %GetParam,
                        Second => 0,
                    },
                );

                # get current system epoch
                my $CurSystemDateTime = $Kernel::OM->Create('Kernel::System::DateTime');

                if (
                    !$PendingDateTimeObject
                    || $PendingDateTimeObject < $CurSystemDateTime
                    )
                {
                    $Error{'DateInvalid'} = 'ServerError';
                }
            }
        }

        if ( $Config->{Note} && $Config->{NoteMandatory} ) {

            # check subject
            if ( !$GetParam{Subject} ) {
                $Error{'SubjectInvalid'} = 'ServerError';
            }

            # check body
            if ( !$GetParam{Body} ) {
                $Error{'BodyInvalid'} = 'ServerError';
            }
        }

        # check mandatory state
        if ( $Config->{State} && $Config->{StateMandatory} ) {
            if ( !$GetParam{NewStateID} ) {
                $Error{'NewStateInvalid'} = 'ServerError';
            }
        }

        # clear DynamicFieldHTML
        %DynamicFieldHTML = ();

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            my $IsACLReducible = $DynamicFieldBackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );

            if ($IsACLReducible) {

                # get PossibleValues
                my $PossibleValues = $DynamicFieldBackendObject->PossibleValuesGet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                );

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $TicketObject->TicketAcl(
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
                        my %Filter = $TicketObject->TicketAclData();

                        # convert Filer key => key back to key => value using map
                        %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                    }
                }
            }

            my $ValidationResult = $DynamicFieldBackendObject->EditFieldValueValidate(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                ParamObject          => $ParamObject,
                Mandatory =>
                    $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
            );

            if ( !IsHashRefWithData($ValidationResult) ) {
                return $LayoutObject->ErrorScreen(
                    Message => $LayoutObject->{LanguageObject}->Translate(
                        'Could not perform validation on field %s!',
                        $DynamicFieldConfig->{Label},
                    ),
                    Comment => Translatable('Please contact the administrator.'),
                );
            }

            # propagate validation error to the Error variable to be detected by the frontend
            if ( $ValidationResult->{ServerError} ) {
                $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } = $DynamicFieldBackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                Mandatory =>
                    $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                ServerError  => $ValidationResult->{ServerError}  || '',
                ErrorMessage => $ValidationResult->{ErrorMessage} || '',
                LayoutObject => $LayoutObject,
                ParamObject  => $ParamObject,
                AJAXUpdate   => 1,
                UpdatableFields => $Self->_GetFieldsToUpdate(),
            );
        }
    }

    # get params
    my $TicketUnlock = $ParamObject->GetParam( Param => 'TicketUnlock' );

    # check errors
    if (%Error) {

        my $Output = $LayoutObject->Header(
            Type      => 'Small',
            BodyClass => 'Popup',
        );

        # check if lock is required
        if ( $Config->{RequiredLock} ) {

            # get lock state && write (lock) permissions
            if ( !$TicketObject->TicketLockGet( TicketID => $Self->{TicketID} ) ) {

                my $Lock = $TicketObject->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'lock',
                    UserID   => $Self->{UserID}
                );

                if ($Lock) {

                    # Set new owner if ticket owner is different then logged user.
                    if ( $Ticket{OwnerID} != $Self->{UserID} ) {

                        # Remember previous owner, which will be used to restore ticket owner on undo action.
                        $Param{PreviousOwner} = $Ticket{OwnerID};

                        $TicketObject->TicketOwnerSet(
                            TicketID  => $Self->{TicketID},
                            UserID    => $Self->{UserID},
                            NewUserID => $Self->{UserID},
                        );
                    }

                    # Show lock state.
                    $LayoutObject->Block(
                        Name => 'PropertiesLock',
                        Data => {
                            %Param,
                            TicketID => $Self->{TicketID}
                        },
                    );
                    $TicketUnlock = 1;
                }
            }
            else {
                my $AccessOk = $TicketObject->OwnerCheck(
                    TicketID => $Self->{TicketID},
                    OwnerID  => $Self->{UserID},
                );
                if ( !$AccessOk ) {

                    my $Output = $LayoutObject->Header(
                        Type      => 'Small',
                        BodyClass => 'Popup',
                    );
                    $Output .= $LayoutObject->Warning(
                        Message => Translatable('Sorry, you need to be the ticket owner to perform this action.'),
                        Comment => Translatable('Please change the owner first.'),
                    );

                    # show back link
                    $LayoutObject->Block(
                        Name => 'TicketBack',
                        Data => { %Param, TicketID => $Self->{TicketID} },
                    );

                    $Output .= $LayoutObject->Footer(
                        Type => 'Small',
                    );
                    return $Output;
                }

                # show back link
                $LayoutObject->Block(
                    Name => 'TicketBack',
                    Data => { %Param, TicketID => $Self->{TicketID} },
                );
            }
        }
        else {

            # show back link
            $LayoutObject->Block(
                Name => 'TicketBack',
                Data => { %Param, TicketID => $Self->{TicketID} },
            );
        }

        # fetch all queues
        my %MoveQueues = $TicketObject->MoveList(
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
            QueueID  => $GetParam{DestQueueID} || $Ticket{QueueID},
        );

        # get next priorities
        my $NextPriorities = $Self->_GetPriorities(
            %GetParam,
            %ACLCompatGetParam,
            TicketID => $Self->{TicketID},
            QueueID  => $GetParam{DestQueueID} || $Ticket{QueueID},
        );

        # get old owners
        my @OldUserInfo = $TicketObject->TicketOwnerList(
            %GetParam,
            %ACLCompatGetParam,
            TicketID => $Self->{TicketID}
        );

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
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
            TicketUnlock   => $TicketUnlock,
            TimeUnits      => $GetParam{TimeUnits},
            FormID         => $Self->{FormID},

            %Ticket,
            DynamicFieldHTML => \%DynamicFieldHTML,
            %GetParam,
            %Error,
        );
        $Output .= $LayoutObject->Footer(
            Type => 'Small',
        );
        return $Output;
    }

    # move ticket (send notification if no new owner is selected)
    my $BodyAsText = '';
    if ( $LayoutObject->{BrowserRichText} ) {
        $BodyAsText = $LayoutObject->RichText2Ascii(
            String => $GetParam{Body} || 0,
        );
    }
    else {
        $BodyAsText = $GetParam{Body} || 0;
    }
    my $Move = $TicketObject->TicketQueueSet(
        QueueID            => $GetParam{DestQueueID},
        UserID             => $Self->{UserID},
        TicketID           => $Self->{TicketID},
        SendNoNotification => $GetParam{NewUserID},
        Comment            => $BodyAsText,
    );
    if ( !$Move ) {
        return $LayoutObject->ErrorScreen();
    }

    # set priority
    if ( $Config->{Priority} && $GetParam{NewPriorityID} ) {
        $TicketObject->TicketPrioritySet(
            TicketID   => $Self->{TicketID},
            PriorityID => $GetParam{NewPriorityID},
            UserID     => $Self->{UserID},
        );
    }

    # set state
    if ( $Config->{State} && $GetParam{NewStateID} ) {
        $TicketObject->TicketStateSet(
            TicketID => $Self->{TicketID},
            StateID  => $GetParam{NewStateID},
            UserID   => $Self->{UserID},
        );

        # unlock the ticket after close
        my %StateData = $StateObject->StateGet(
            ID => $GetParam{NewStateID},
        );

        # set unlock on close
        if ( $StateData{TypeName} =~ /^close/i ) {
            $TicketObject->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }

        # set pending time on pending state
        elsif ( $StateData{TypeName} =~ /^pending/i ) {

            # set pending time
            $TicketObject->TicketPendingTimeSet(
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
        $TicketObject->TicketLockSet(
            TicketID => $Self->{TicketID},
            Lock     => 'lock',
            UserID   => $Self->{UserID},
        );

        # set owner
        $TicketObject->TicketOwnerSet(
            TicketID  => $Self->{TicketID},
            UserID    => $Self->{UserID},
            NewUserID => $GetParam{NewUserID},
            Comment   => $BodyAsText,
        );
    }

    # force unlock if no new owner is set and ticket was unlocked
    else {
        if ($TicketUnlock) {
            $TicketObject->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'unlock',
                UserID   => $Self->{UserID},
            );
        }
    }

    # add note (send no notification)
    my $ArticleID;

    my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

    if (
        $GetParam{CreateArticle}
        && $Config->{Note}
        && ( $GetParam{Body} || $GetParam{Subject} )
        )
    {

        # get pre-loaded attachments
        my @AttachmentData = $UploadCacheObject->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submitted attachment
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'FileUpload',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        my $MimeType = 'text/plain';
        if ( $LayoutObject->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # remove unused inline images
            my @NewAttachmentData;
            ATTACHMENT:
            for my $Attachment (@AttachmentData) {
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
                    next ATTACHMENT
                        if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # remember inline images and normal attachments
                push @NewAttachmentData, \%{$Attachment};
            }
            @AttachmentData = @NewAttachmentData;

            # verify HTML document
            $GetParam{Body} = $LayoutObject->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        my $InternalArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );
        $ArticleID = $InternalArticleBackendObject->ArticleCreate(
            TicketID             => $Self->{TicketID},
            IsVisibleForCustomer => 0,
            SenderType           => 'agent',
            From                 => "\"$Self->{UserFullname}\" <$Self->{UserEmail}>",
            Subject              => $GetParam{Subject},
            Body                 => $GetParam{Body},
            MimeType             => $MimeType,
            Charset              => $LayoutObject->{UserCharset},
            UserID               => $Self->{UserID},
            HistoryType          => 'AddNote',
            HistoryComment       => '%%Move',
            NoAgentNotify        => 1,
        );
        if ( !$ArticleID ) {
            return $LayoutObject->ErrorScreen();
        }

        # write attachments
        for my $Attachment (@AttachmentData) {
            $InternalArticleBackendObject->ArticleWriteAttachment(
                %{$Attachment},
                ArticleID => $ArticleID,
                UserID    => $Self->{UserID},
            );
        }

        # remove pre-submitted attachments
        $UploadCacheObject->FormIDRemove( FormID => $Self->{FormID} );
    }

    # only set the dynamic fields if the new window was displayed (link), otherwise if ticket was
    # moved from the dropdown menu (form) in AgentTicketZoom, the value if the dynamic fields will
    # be undefined and it will set to empty in the DB, see bug#8481
    if ( $ConfigObject->Get('Ticket::Frontend::MoveType') eq 'link' ) {

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # set the object ID (TicketID or ArticleID) depending on the field configration
            my $ObjectID = $DynamicFieldConfig->{ObjectType} eq 'Article' ? $ArticleID : $Self->{TicketID};

            # set dynamic field; when ObjectType=Article and no article will be created ignore
            # this dynamic field
            if ($ObjectID) {

                # set the value
                $DynamicFieldBackendObject->ValueSet(
                    DynamicFieldConfig => $DynamicFieldConfig,
                    ObjectID           => $ObjectID,
                    Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                    UserID             => $Self->{UserID},
                );
            }
        }
    }

    # time accounting
    if ( $GetParam{TimeUnits} ) {
        $TicketObject->TicketAccountTime(
            TicketID  => $Self->{TicketID},
            ArticleID => $ArticleID,
            TimeUnit  => $GetParam{TimeUnits},
            UserID    => $Self->{UserID},
        );
    }

    # If form was called based on a draft,
    #   delete draft since its content has now been used.
    if (
        $GetParam{FormDraftID}
        && !$Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftDelete(
            FormDraftID => $GetParam{FormDraftID},
            UserID      => $Self->{UserID},
        )
        )
    {
        return $LayoutObject->ErrorScreen(
            Message => Translatable('Could not delete draft!'),
            Comment => Translatable('Please contact the administrator.'),
        );
    }

    # check permission for redirect
    my $AccessNew = $TicketObject->TicketPermission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    my $NextScreen = $Config->{NextScreen} || '';

    # redirect to last overview if we do not have ro permissions anymore,
    # or if SysConfig option is set.
    if ( !$AccessNew || $NextScreen eq 'LastScreenOverview' ) {

        # Module directly called
        if ( $ConfigObject->Get('Ticket::Frontend::MoveType') eq 'form' ) {
            return $LayoutObject->Redirect( OP => $Self->{LastScreenOverview} );
        }

        # Module opened in popup
        elsif ( $ConfigObject->Get('Ticket::Frontend::MoveType') eq 'link' ) {
            return $LayoutObject->PopupClose(
                URL => ( $Self->{LastScreenOverview} || 'Action=AgentDashboard' ),
            );
        }
    }

    # Module directly called
    if ( $ConfigObject->Get('Ticket::Frontend::MoveType') eq 'form' ) {
        return $LayoutObject->Redirect(
            OP => "Action=AgentTicketZoom;TicketID=$Self->{TicketID}"
                . ( $ArticleID ? ";ArticleID=$ArticleID" : '' ),
        );
    }

    # Module opened in popup
    elsif ( $ConfigObject->Get('Ticket::Frontend::MoveType') eq 'link' ) {
        return $LayoutObject->PopupClose(
            URL => "Action=AgentTicketZoom;TicketID=$Self->{TicketID}"
                . ( $ArticleID ? ";ArticleID=$ArticleID" : '' ),
        );
    }
}

sub AgentMove {
    my ( $Self, %Param ) = @_;

    $Param{DestQueueIDInvalid} = $Param{DestQueueIDInvalid} || '';

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    # get config for frontend module
    my $Config = $ConfigObject->Get("Ticket::Frontend::$Self->{Action}");

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Data       = %{ $Param{MoveQueues} };
    my %MoveQueues = %Data;
    my %UsedData;

    my $DynamicFieldNames = $Self->_GetFieldsToUpdate(
        OnlyDynamicFields => 1
    );

    # send data to JS
    $LayoutObject->AddJSData(
        Key   => 'DynamicFieldNames',
        Value => $DynamicFieldNames
    );

    # build next states string
    $Param{NextStatesStrg} = $LayoutObject->BuildSelection(
        Data         => $Param{NextStates},
        Name         => 'NewStateID',
        SelectedID   => $Param{NewStateID},
        Translation  => 1,
        PossibleNone => 1,
        Class        => 'Modernize '
            . ( $Config->{StateMandatory} ? 'Validate_Required ' : '' )
            . ( $Param{NewStateInvalid} || '' ),
    );

    # build next priority string
    $Param{NextPrioritiesStrg} = $LayoutObject->BuildSelection(
        Data         => $Param{NextPriorities},
        Name         => 'NewPriorityID',
        SelectedID   => $Param{NewPriorityID},
        Translation  => 1,
        PossibleNone => 1,
        Class        => 'Modernize',
    );

    # build owner string
    $Param{OwnerStrg} = $LayoutObject->BuildSelection(
        Data => $Self->_GetUsers(
            QueueID  => $Param{DestQueueID},
            AllUsers => $Param{OwnerAll},
        ),
        Name         => 'NewUserID',
        SelectedID   => $Param{NewUserID},
        Translation  => 0,
        PossibleNone => 1,
        Class        => 'Modernize',
        Filters      => {
            OldOwners => {
                Name   => $LayoutObject->{LanguageObject}->Translate('Previous Owner'),
                Values => $Self->_GetOldOwners(
                    QueueID  => $Param{DestQueueID},
                    AllUsers => $Param{OwnerAll},
                ),
            },
        },
    );

    $LayoutObject->Block(
        Name => 'Owner',
        Data => \%Param,
    );

    # set state
    if ( $Config->{State} ) {
        $LayoutObject->Block(
            Name => 'State',
            Data => {
                StateMandatory => $Config->{StateMandatory} || 0,
                %Param
            },
        );
    }

    STATE_ID:
    for my $StateID ( sort keys %{ $Param{NextStates} } ) {
        next STATE_ID if !$StateID;
        my %StateData = $Kernel::OM->Get('Kernel::System::State')->StateGet( ID => $StateID );
        if ( $StateData{TypeName} =~ /pending/i ) {

            # get used calendar
            my $Calendar = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCalendarGet(
                QueueID => $Param{QueueID},
                SLAID   => $Param{SLAID},
            );

            $Param{DateString} = $LayoutObject->BuildDateSelection(
                Format           => 'DateInputFormatLong',
                YearPeriodPast   => 0,
                YearPeriodFuture => 5,
                DiffTime         => $ConfigObject->Get('Ticket::Frontend::PendingDiffTime')
                    || 0,
                %Param,
                Class                => $Param{DateInvalid} || ' ',
                Validate             => 1,
                ValidateDateInFuture => 1,
                Calendar             => $Calendar,
            );
            $LayoutObject->Block(
                Name => 'StatePending',
                Data => \%Param,
            );
            last STATE_ID;
        }
    }

    # set priority
    if ( $Config->{Priority} ) {
        $LayoutObject->Block(
            Name => 'Priority',
            Data => {%Param},
        );
    }

    # set move queues
    $Param{MoveQueuesStrg} = $LayoutObject->AgentQueueListOption(
        Data           => { %MoveQueues, '' => '-' },
        Multiple       => 0,
        Size           => 0,
        Class          => 'Modernize Validate_Required' . ' ' . $Param{DestQueueIDInvalid},
        Name           => 'DestQueueID',
        SelectedID     => $Param{DestQueueID},
        TreeView       => $TreeView,
        CurrentQueueID => $Param{QueueID},
        OnChangeSubmit => 0,
    );

    $LayoutObject->Block(
        Name => 'Queue',
        Data => {%Param},
    );

    # define the dynamic fields to show based on the object type
    my $ObjectType = ['Ticket'];

    # only screens that add notes can modify Article dynamic fields
    if ( $Config->{Note} ) {
        $ObjectType = [ 'Ticket', 'Article' ];
    }

    # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => $ObjectType,
        FieldFilter => $Config->{DynamicField} || {},
    );

    if ($DynamicField) {
        $LayoutObject->Block(
            Name => 'WidgetDynamicFields',
        );
    }

    # Dynamic fields
    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # skip fields that HTML could not be retrieved
        next DYNAMICFIELD if !IsHashRefWithData(
            $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} }
        );

        # get the html strings form $Param
        my $DynamicFieldHTML = $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} };

        $LayoutObject->Block(
            Name => 'DynamicField',
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );

        # example of dynamic fields order customization
        $LayoutObject->Block(
            Name => 'DynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Name  => $DynamicFieldConfig->{Name},
                Label => $DynamicFieldHTML->{Label},
                Field => $DynamicFieldHTML->{Field},
            },
        );

    }

    if ( $Config->{Note} ) {

        $Param{WidgetStatus} = 'Collapsed';

        if (
            $Config->{NoteMandatory}
            || $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            || $Param{IsUpload}
            || $Param{CreateArticle}
            )
        {
            $Param{WidgetStatus} = 'Expanded';
        }

        if (
            $Config->{NoteMandatory}
            || $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            )
        {
            $Param{SubjectRequired} = 'Validate_Required';
            $Param{BodyRequired}    = 'Validate_Required';
        }
        else {
            $Param{SubjectRequired} = 'Validate_DependingRequiredAND Validate_Depending_CreateArticle';
            $Param{BodyRequired}    = 'Validate_DependingRequiredAND Validate_Depending_CreateArticle';
        }

        $LayoutObject->Block(
            Name => 'WidgetArticle',
            Data => {%Param},
        );

        # fillup configured default vars
        if ( $Param{Body} eq '' && $Config->{Body} ) {
            $Param{Body} = $LayoutObject->Output(
                Template => $Config->{Body},
            );
        }

        if ( $Param{Subject} eq '' && $Config->{Subject} ) {
            $Param{Subject} = $LayoutObject->Output(
                Template => $Config->{Subject},
            );
        }

        $LayoutObject->Block(
            Name => 'Note',
            Data => {%Param},
        );

        # build text template string
        my %StandardTemplates = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateList(
            Valid => 1,
            Type  => 'Note',
        );

        my $QueueStandardTemplates = $Self->_GetStandardTemplates(
            %Param,
            TicketID => $Self->{TicketID} || '',
        );

        if ( IsHashRefWithData( \%StandardTemplates ) ) {
            $Param{StandardTemplateStrg} = $LayoutObject->BuildSelection(
                Data         => $QueueStandardTemplates || {},
                Name         => 'StandardTemplateID',
                SelectedID   => $Param{StandardTemplateID} || '',
                PossibleNone => 1,
                Sort         => 'AlphanumericValue',
                Translation  => 1,
                Max          => 200,
                Class        => 'Modernize',
            );
            $LayoutObject->Block(
                Name => 'StandardTemplate',
                Data => {%Param},
            );
        }

        # show time accounting box
        if ( $ConfigObject->Get('Ticket::Frontend::AccountTime') ) {
            if ( $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime') ) {
                $LayoutObject->Block(
                    Name => 'TimeUnitsLabelMandatory',
                    Data => \%Param,
                );
            }
            else {
                $LayoutObject->Block(
                    Name => 'TimeUnitsLabel',
                    Data => \%Param,
                );
            }
            $LayoutObject->Block(
                Name => 'TimeUnits',
                Data => {
                    %Param,
                    TimeUnitsRequired => (
                        $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
                        ? 'Validate_Required'
                        : ''
                    ),
                }
            );
        }

        # show attachments
        ATTACHMENT:
        for my $Attachment ( @{ $Param{Attachments} } ) {
            if (
                $Attachment->{ContentID}
                && $LayoutObject->{BrowserRichText}
                && ( $Attachment->{ContentType} =~ /image/i )
                && ( $Attachment->{Disposition} eq 'inline' )
                )
            {
                next ATTACHMENT;
            }

            push @{ $Param{AttachmentList} }, $Attachment;
        }

        # add rich text editor
        if ( $LayoutObject->{BrowserRichText} ) {

            # use height/width defined for this screen
            $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;
            $Param{RichTextWidth}  = $Config->{RichTextWidth}  || 0;

            # set up rich text editor
            $LayoutObject->SetRichTextParameters(
                Data => \%Param,
            );
        }

        if (
            $Config->{NoteMandatory}
            || $ConfigObject->Get('Ticket::Frontend::NeedAccountedTime')
            )
        {
            $LayoutObject->Block(
                Name => 'SubjectLabelMandatory',
            );
            $LayoutObject->Block(
                Name => 'RichTextLabelMandatory',
            );
        }
        else {
            $LayoutObject->Block(
                Name => 'SubjectLabel',
            );
            $LayoutObject->Block(
                Name => 'RichTextLabel',
            );
        }
    }

    my $LoadedFormDraft;
    if ( $Self->{LoadedFormDraftID} ) {
        $LoadedFormDraft = $Kernel::OM->Get('Kernel::System::FormDraft')->FormDraftGet(
            FormDraftID => $Self->{LoadedFormDraftID},
            GetContent  => 0,
            UserID      => $Self->{UserID},
        );

        my @Articles = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleList(
            TicketID => $Self->{TicketID},
            OnlyLast => 1,
        );

        if (@Articles) {
            my $LastArticle = $Articles[0];

            my $LastArticleSystemTime;
            if ( $LastArticle->{CreateTime} ) {
                my $LastArticleSystemTimeObject = $Kernel::OM->Create(
                    'Kernel::System::DateTime',
                    ObjectParams => {
                        String => $LastArticle->{CreateTime},
                    },
                );
                $LastArticleSystemTime = $LastArticleSystemTimeObject->ToEpoch();
            }

            my $FormDraftSystemTimeObject = $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => $LoadedFormDraft->{ChangeTime},
                },
            );
            my $FormDraftSystemTime = $FormDraftSystemTimeObject->ToEpoch();

            if ( !$LastArticleSystemTime || $FormDraftSystemTime <= $LastArticleSystemTime ) {
                $Param{FormDraftOutdated} = 1;
            }
        }
    }

    if ( IsHashRefWithData($LoadedFormDraft) ) {

        $LoadedFormDraft->{ChangeByName} = $Kernel::OM->Get('Kernel::System::User')->UserName(
            UserID => $LoadedFormDraft->{ChangeBy},
        );
    }

    return $LayoutObject->Output(
        TemplateFile => 'AgentTicketMove',
        Data         => {
            %Param,
            FormDraft      => $Config->{FormDraft},
            FormDraftID    => $Self->{LoadedFormDraftID},
            FormDraftTitle => $LoadedFormDraft ? $LoadedFormDraft->{Title} : '',
            FormDraftMeta  => $LoadedFormDraft,
        },
    );
}

sub _GetUsers {
    my ( $Self, %Param ) = @_;

    # get users
    my %ShownUsers;
    my %AllGroupsMembers = $Kernel::OM->Get('Kernel::System::User')->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # just show only users with selected custom queue
    if ( $Param{QueueID} && !$Param{AllUsers} ) {
        my @UserIDs = $TicketObject->GetSubscribedUserIDsByQueueID(%Param);
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
    if ( $Kernel::OM->Get('Kernel::Config')->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show all users who are rw in the queue group
    elsif ( $Param{QueueID} ) {
        my $GID        = $Kernel::OM->Get('Kernel::System::Queue')->GetQueueGroupID( QueueID => $Param{QueueID} );
        my %MemberList = $Kernel::OM->Get('Kernel::System::Group')->PermissionGroupGet(
            GroupID => $GID,
            Type    => 'owner',
        );
        for my $MemberUsers ( sort keys %MemberList ) {
            if ( $AllGroupsMembers{$MemberUsers} ) {
                $ShownUsers{$MemberUsers} = $AllGroupsMembers{$MemberUsers};
            }
        }
    }

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action        => $Self->{Action},
        ReturnType    => 'Ticket',
        ReturnSubType => 'NewOwner',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetOldOwners {
    my ( $Self, %Param ) = @_;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    my @OldUserInfo = $TicketObject->TicketOwnerList( TicketID => $Self->{TicketID} );
    my %UserHash;
    if (@OldUserInfo) {
        my $Counter = 1;
        USER:
        for my $User ( reverse @OldUserInfo ) {
            next USER if $UserHash{ $User->{UserID} };
            $UserHash{ $User->{UserID} } = "$Counter: $User->{UserFullname}";
            $Counter++;
        }
    }

    # workflow
    my $ACL = $TicketObject->TicketAcl(
        %Param,
        Action        => $Self->{Action},
        ReturnType    => 'Ticket',
        ReturnSubType => 'OldOwner',
        Data          => \%UserHash,
        UserID        => $Self->{UserID},
    );

    return { $TicketObject->TicketAclData() } if $ACL;

    return \%UserHash;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    # get priority
    my %Priorities;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPriorityList(
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
        %NextStates = $Kernel::OM->Get('Kernel::System::Ticket')->TicketStateList(
            %Param,
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
        @UpdatableFields = qw( DestQueueID NewUserID NewStateID NewPriorityID );
    }

    # define the dynamic fields to show based on the object type
    my $ObjectType = ['Ticket'];

    # get config for frontend module
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    # only screens that add notes can modify Article dynamic fields
    if ( $Config->{Note} ) {
        $ObjectType = [ 'Ticket', 'Article' ];
    }

    # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => $ObjectType,
        FieldFilter => $Config->{DynamicField} || {},
    );

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsACLReducible = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsACLReducible',
        );
        next DYNAMICFIELD if !$IsACLReducible;

        push @UpdatableFields, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    return \@UpdatableFields;
}

sub _GetStandardTemplates {
    my ( $Self, %Param ) = @_;

    # get create templates
    my %Templates;

    # check needed
    return \%Templates if !$Param{QueueID} && !$Param{TicketID};

    my $QueueID = $Param{QueueID} || '';
    if ( !$Param{QueueID} && $Param{TicketID} ) {

        # get QueueID from the ticket
        my %Ticket = $Kernel::OM->Get('Kernel::System::Ticket')->TicketGet(
            TicketID      => $Param{TicketID},
            DynamicFields => 0,
            UserID        => $Self->{UserID},
        );
        $QueueID = $Ticket{QueueID} || '';
    }

    # fetch all std. templates
    my %StandardTemplates = $Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberList(
        QueueID       => $QueueID,
        TemplateTypes => 1,
    );

    # return empty hash if there are no templates for this screen
    return \%Templates if !IsHashRefWithData( $StandardTemplates{Note} );

    # return just the templates for this screen
    return $StandardTemplates{Note};
}

sub _GetQueues {
    my ( $Self, %Param ) = @_;

    # Get Queues.
    my %Queues = $Kernel::OM->Get('Kernel::System::Ticket')->TicketMoveList(
        %Param,
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID},
        Action   => $Self->{Action},
        Type     => 'move_into',
    );
    return \%Queues;
}

1;
