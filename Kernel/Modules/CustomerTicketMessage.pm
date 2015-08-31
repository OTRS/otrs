# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketMessage;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get params
    my %GetParam;
    my $ParamObject = $Kernel::OM->Get('Kernel::System::Web::Request');
    for my $Key (qw( Subject Body PriorityID TypeID ServiceID SLAID Expand Dest FromChatID)) {
        $GetParam{$Key} = $ParamObject->GetParam( Param => $Key );
    }

    # ACL compatibility translation
    my %ACLCompatGetParam;
    $ACLCompatGetParam{OwnerID} = $GetParam{NewUserID};

    # get Dynamic fields from ParamObject
    my %DynamicFieldValues;

    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => $Config->{DynamicField} || {},
    );

    my $LayoutObject  = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
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

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value form the web request
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} } =
            $BackendObject->EditFieldValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ParamObject        => $ParamObject,
            LayoutObject       => $LayoutObject,
            );
    }

    # convert dynamic field values into a structure for ACLs
    my %DynamicFieldACLParameters;
    DYNAMICFIELD:
    for my $DynamicField ( sort keys %DynamicFieldValues ) {
        next DYNAMICFIELD if !$DynamicField;
        next DYNAMICFIELD if !$DynamicFieldValues{$DynamicField};

        $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicField } = $DynamicFieldValues{$DynamicField};
    }
    $GetParam{DynamicField} = \%DynamicFieldACLParameters;

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $QueueObject  = $Kernel::OM->Get('Kernel::System::Queue');
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    if ( $GetParam{FromChatID} ) {
        if ( !$ConfigObject->Get('ChatEngine::Active') ) {
            return $LayoutObject->FatalError(
                Message => "Chat is not active.",
            );
        }

        # Check chat participant
        my %ChatParticipant = $Kernel::OM->Get('Kernel::System::Chat')->ChatParticipantCheck(
            ChatID      => $GetParam{FromChatID},
            ChatterType => 'Customer',
            ChatterID   => $Self->{UserID},
        );

        if ( !%ChatParticipant ) {
            return $LayoutObject->FatalError(
                Message => "No permission.",
            );
        }
    }

    # get form id
    my $FormID = $ParamObject->GetParam( Param => 'FormID' );

    # create form id
    if ( !$FormID ) {
        $FormID = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate();
    }

    if ( !$Self->{Subaction} ) {

        #Get default Queue ID if none is set
        my $QueueDefaultID;
        if ( !$GetParam{Dest} && !$Param{ToSelected} ) {
            my $QueueDefault = $Config->{'QueueDefault'} || '';
            if ($QueueDefault) {
                $QueueDefaultID = $QueueObject->QueueLookup( Queue => $QueueDefault );
                if ($QueueDefaultID) {
                    $Param{ToSelected} = $QueueDefaultID . '||' . $QueueDefault;
                }
            }

            # warn if there is no (valid) default queue and the customer can't select one
            elsif ( !$Config->{'Queue'} ) {
                $LayoutObject->CustomerFatalError(
                    Message => 'Check SysConfig setting for ' . $Self->{Action} . '::QueueDefault.',
                    Comment => 'Please contact your administrator',
                );
                return;
            }
        }
        elsif ( $GetParam{Dest} ) {
            my ( $QueueIDParam, $QueueParam ) = split( /\|\|/, $GetParam{Dest} );
            my $QueueIDLookup = $QueueObject->QueueLookup( Queue => $QueueParam );
            if ( $QueueIDLookup && $QueueIDLookup eq $QueueIDParam ) {
                $Param{ToSelected} = $GetParam{Dest};
            }
        }

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

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

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $TicketObject->TicketAcl(
                        %GetParam,
                        Action         => $Self->{Action},
                        TicketID       => $Self->{TicketID},
                        ReturnType     => 'Ticket',
                        ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data           => \%AclData,
                        CustomerUserID => $Self->{UserID},
                    );
                    if ($ACL) {
                        my %Filter = $TicketObject->TicketAclData();

                        # convert Filer key => key back to key => value using map
                        %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                    }
                }
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $BackendObject->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                Mandatory =>
                    $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                LayoutObject    => $LayoutObject,
                ParamObject     => $ParamObject,
                AJAXUpdate      => 1,
                UpdatableFields => $Self->_GetFieldsToUpdate(),
                );
        }

        # print form ...
        my $Output .= $LayoutObject->CustomerHeader();
        $Output    .= $LayoutObject->CustomerNavigationBar();
        $Output    .= $Self->_MaskNew(
            %GetParam,
            QueueID          => $QueueDefaultID,
            ToSelected       => $Param{ToSelected},
            DynamicFieldHTML => \%DynamicFieldHTML,
            FromChatID       => $GetParam{FromChatID} || '',
        );
        $Output .= $LayoutObject->CustomerFooter();
        return $Output;
    }
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {

        # challenge token check for write action
        $LayoutObject->ChallengeTokenCheck( Type => 'Customer' );

        my $NextScreen = $Config->{NextScreenAfterNewTicket};
        my %Error;

        # get destination queue
        my $Dest = $ParamObject->GetParam( Param => 'Dest' ) || '';
        my ( $NewQueueID, $To ) = split( /\|\|/, $Dest );
        if ( !$To ) {
            $NewQueueID = $ParamObject->GetParam( Param => 'NewQueueID' ) || '';
            $To = 'System';
        }

        # fallback, if no destination is given
        if ( !$NewQueueID ) {
            my $Queue = $ParamObject->GetParam( Param => 'Queue' )
                || $Config->{'QueueDefault'}
                || '';
            if ($Queue) {
                my $QueueID = $QueueObject->QueueLookup( Queue => $Queue );
                $NewQueueID = $QueueID;
                $To         = $Queue;
            }
        }

        # use default if ticket type is not available in screen but activated on system
        if ( $ConfigObject->Get('Ticket::Type') && !$Config->{'TicketType'} ) {
            my %TypeList = reverse $TicketObject->TicketTypeList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
            $GetParam{TypeID} = $TypeList{ $Config->{'TicketTypeDefault'} };
            if ( !$GetParam{TypeID} ) {
                $LayoutObject->CustomerFatalError(
                    Message => 'Check SysConfig setting for '
                        . $Self->{Action}
                        . '::TicketTypeDefault.',
                    Comment => 'Please contact your administrator',
                );
                return;
            }
        }

        # If is an action about attachments
        my $IsUpload = 0;

        # attachment delete
        my @AttachmentIDs = map {
            my ($ID) = $_ =~ m{ \A AttachmentDelete (\d+) \z }xms;
            $ID ? $ID : ();
        } $ParamObject->GetParamNames();

        my $UploadCacheObject = $Kernel::OM->Get('Kernel::System::Web::UploadCache');

        COUNT:
        for my $Count ( reverse sort @AttachmentIDs ) {
            my $Delete = $ParamObject->GetParam( Param => "AttachmentDelete$Count" );
            next COUNT if !$Delete;
            $Error{AttachmentDelete} = 1;
            $UploadCacheObject->FormIDRemoveFile(
                FormID => $FormID,
                FileID => $Count,
            );
            $IsUpload = 1;
        }

        # attachment upload
        if ( $ParamObject->GetParam( Param => 'AttachmentUpload' ) ) {
            $IsUpload = 1;
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $ParamObject->GetUploadAll(
                Param => 'file_upload',
            );
            $UploadCacheObject->FormIDAddFile(
                FormID      => $FormID,
                Disposition => 'attachment',
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $UploadCacheObject->FormIDGetAllFilesMeta(
            FormID => $FormID,
        );

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

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

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $TicketObject->TicketAcl(
                        %GetParam,
                        Action         => $Self->{Action},
                        TicketID       => $Self->{TicketID},
                        ReturnType     => 'Ticket',
                        ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                        Data           => \%AclData,
                        CustomerUserID => $Self->{UserID},
                    );
                    if ($ACL) {
                        my %Filter = $TicketObject->TicketAclData();

                        # convert Filer key => key back to key => value using map
                        %{$PossibleValuesFilter} = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                    }
                }
            }

            my $ValidationResult;

            # do not validate on attachment upload or GetParam Expand
            if ( !$IsUpload && !$GetParam{Expand} ) {

                $ValidationResult = $BackendObject->EditFieldValueValidate(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    ParamObject          => $ParamObject,
                    Mandatory =>
                        $Config->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                );

                if ( !IsHashRefWithData($ValidationResult) ) {
                    my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
                    $Output .= $LayoutObject->CustomerError(
                        Message =>
                            "Could not perform validation on field $DynamicFieldConfig->{Label}!",
                        Comment => 'Please contact your administrator',
                    );
                    $Output .= $LayoutObject->CustomerFooter();
                    return $Output;
                }

                # propagate validation error to the Error variable to be detected by the frontend
                if ( $ValidationResult->{ServerError} ) {
                    $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
                }
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $BackendObject->EditFieldRender(
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

        # rewrap body if no rich text is used
        if ( $GetParam{Body} && !$LayoutObject->{BrowserRichText} ) {
            $GetParam{Body} = $LayoutObject->WrapPlainText(
                MaxCharacters => $ConfigObject->Get('Ticket::Frontend::TextAreaNote'),
                PlainText     => $GetParam{Body},
            );
        }

        # if there is FromChatID, get related messages and prepend them to body
        if ( $GetParam{FromChatID} ) {
            my @ChatMessages = $Kernel::OM->Get('Kernel::System::Chat')->ChatMessageList(
                ChatID => $GetParam{FromChatID},
            );
        }

        # check queue
        if ( !$NewQueueID && !$IsUpload && !$GetParam{Expand} ) {
            $Error{QueueInvalid} = 'ServerError';
        }

        # prevent tamper with (Queue/Dest), see bug#9408
        if ( $NewQueueID && !$IsUpload ) {

            # get the original list of queues to display
            my $Tos = $Self->_GetTos(
                %GetParam,
                %ACLCompatGetParam,
                QueueID => $NewQueueID,
            );

            # check if current selected QueueID exists in the list of queues,\
            # otherwise rise an error
            if ( !$Tos->{$NewQueueID} ) {
                $Error{QueueInvalid} = 'ServerError';
            }

            # set the correct queue name in $To if it was altered
            if ( $To ne $Tos->{$NewQueueID} ) {
                $To = $Tos->{$NewQueueID}
            }
        }

        # check subject
        if ( !$GetParam{Subject} && !$IsUpload ) {
            $Error{SubjectInvalid} = 'ServerError';
        }

        # check body
        if ( !$GetParam{Body} && !$IsUpload ) {
            $Error{BodyInvalid} = 'ServerError';
        }
        if ( $GetParam{Expand} ) {
            %Error = ();
            $Error{Expand} = 1;
        }

        # check mandatory service
        if (
            $ConfigObject->Get('Ticket::Service')
            && $Config->{Service}
            && $Config->{ServiceMandatory}
            && !$GetParam{ServiceID}
            )
        {
            $Error{'ServiceIDInvalid'} = ' ServerError';
        }

        # check mandatory sla
        if (
            $ConfigObject->Get('Ticket::Service')
            && $Config->{SLA}
            && $Config->{SLAMandatory}
            && !$GetParam{SLAID}
            )
        {
            $Error{'SLAIDInvalid'} = ' ServerError';
        }

        # check type
        if (
            $ConfigObject->Get('Ticket::Type')
            && !$GetParam{TypeID}
            && !$IsUpload
            && !$GetParam{Expand}
            )
        {
            $Error{TypeIDInvalid} = 'ServerError';
        }

        if (%Error) {

            # html output
            my $Output .= $LayoutObject->CustomerHeader();
            $Output    .= $LayoutObject->CustomerNavigationBar();
            $Output    .= $Self->_MaskNew(
                Attachments => \@Attachments,
                %GetParam,
                ToSelected       => $Dest,
                QueueID          => $NewQueueID,
                DynamicFieldHTML => \%DynamicFieldHTML,
                Errors           => \%Error,
            );
            $Output .= $LayoutObject->CustomerFooter();
            return $Output;
        }

        # if customer is not allowed to set priority, set it to default
        if ( !$Config->{Priority} ) {
            $GetParam{PriorityID} = '';
            $GetParam{Priority}   = $Config->{PriorityDefault};
        }

        # create new ticket, do db insert
        my $TicketID = $TicketObject->TicketCreate(
            QueueID      => $NewQueueID,
            TypeID       => $GetParam{TypeID},
            ServiceID    => $GetParam{ServiceID},
            SLAID        => $GetParam{SLAID},
            Title        => $GetParam{Subject},
            PriorityID   => $GetParam{PriorityID},
            Priority     => $GetParam{Priority},
            Lock         => 'unlock',
            State        => $Config->{StateDefault},
            CustomerID   => $Self->{UserCustomerID},
            CustomerUser => $Self->{UserLogin},
            OwnerID      => $ConfigObject->Get('CustomerPanelUserID'),
            UserID       => $ConfigObject->Get('CustomerPanelUserID'),
        );

        # set ticket dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';

            # set the value
            my $Success = $BackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $ConfigObject->Get('CustomerPanelUserID'),
            );
        }

        my $MimeType = 'text/plain';
        if ( $LayoutObject->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # verify html document
            $GetParam{Body} = $LayoutObject->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        my $PlainBody = $GetParam{Body};

        if ( $LayoutObject->{BrowserRichText} ) {
            $PlainBody = $LayoutObject->RichText2Ascii( String => $GetParam{Body} );
        }

        # create article
        my $FullName = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerName(
            UserLogin => $Self->{UserLogin},
        );
        my $From      = "\"$FullName\" <$Self->{UserEmail}>";
        my $ArticleID = $TicketObject->ArticleCreate(
            TicketID         => $TicketID,
            ArticleType      => $Config->{ArticleType},
            SenderType       => $Config->{SenderType},
            From             => $From,
            To               => $To,
            Subject          => $GetParam{Subject},
            Body             => $GetParam{Body},
            MimeType         => $MimeType,
            Charset          => $LayoutObject->{UserCharset},
            UserID           => $ConfigObject->Get('CustomerPanelUserID'),
            HistoryType      => $Config->{HistoryType},
            HistoryComment   => $Config->{HistoryComment} || '%%',
            AutoResponseType => ( $ConfigObject->Get('AutoResponseForWebTickets') )
            ? 'auto reply'
            : '',
            OrigHeader => {
                From    => $From,
                To      => $Self->{UserLogin},
                Subject => $GetParam{Subject},
                Body    => $PlainBody,
            },
            Queue => $QueueObject->QueueLookup( QueueID => $NewQueueID ),
        );

        if ( !$ArticleID ) {
            my $Output = $LayoutObject->CustomerHeader( Title => 'Error' );
            $Output .= $LayoutObject->CustomerError();
            $Output .= $LayoutObject->CustomerFooter();
            return $Output;
        }

        # set article dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Article';

            # set the value
            my $Success = $BackendObject->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ArticleID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $ConfigObject->Get('CustomerPanelUserID'),
            );
        }

        # Permissions check were done earlier
        if ( $GetParam{FromChatID} ) {
            my $ChatObject = $Kernel::OM->Get('Kernel::System::Chat');
            my %Chat       = $ChatObject->ChatGet(
                ChatID => $GetParam{FromChatID},
            );
            my @ChatMessageList = $ChatObject->ChatMessageList(
                ChatID => $GetParam{FromChatID},
            );
            my $ChatArticleID;

            if (@ChatMessageList) {
                my $JSONBody = $Kernel::OM->Get('Kernel::System::JSON')->Encode(
                    Data => \@ChatMessageList,
                );

                my $ChatArticleType = 'chat-external';

                $ChatArticleID = $TicketObject->ArticleCreate(

                    #NoAgentNotify => $NoAgentNotify,
                    TicketID    => $TicketID,
                    ArticleType => $ChatArticleType,
                    SenderType  => $Config->{SenderType},

                    From => $From,

                    # To               => $To,
                    Subject        => $Kernel::OM->Get('Kernel::Language')->Translate('Chat'),
                    Body           => $JSONBody,
                    MimeType       => 'application/json',
                    Charset        => $LayoutObject->{UserCharset},
                    UserID         => $ConfigObject->Get('CustomerPanelUserID'),
                    HistoryType    => $Config->{HistoryType},
                    HistoryComment => $Config->{HistoryComment} || '%%',
                    Queue          => $QueueObject->QueueLookup( QueueID => $NewQueueID ),
                );
            }
            if ($ChatArticleID) {
                $ChatObject->ChatDelete(
                    ChatID => $GetParam{FromChatID},
                );
            }
        }

        # get pre loaded attachment
        my @AttachmentData = $UploadCacheObject->FormIDGetAllFilesData(
            FormID => $FormID,
        );

        # get submitted attachment
        my %UploadStuff = $ParamObject->GetUploadAll(
            Param => 'file_upload',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        # write attachments
        ATTACHMENT:
        for my $Attachment (@AttachmentData) {

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
                $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                # ignore attachment if not linked in body
                next ATTACHMENT if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
            }

            # write existing file to backend
            $TicketObject->ArticleWriteAttachment(
                %{$Attachment},
                ArticleID => $ArticleID,
                UserID    => $ConfigObject->Get('CustomerPanelUserID'),
            );
        }

        # remove pre submitted attachments
        $UploadCacheObject->FormIDRemove( FormID => $FormID );

        # redirect
        return $LayoutObject->Redirect(
            OP => "Action=$NextScreen;TicketID=$TicketID",
        );
    }

    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        my $Dest         = $ParamObject->GetParam( Param => 'Dest' ) || '';
        my $CustomerUser = $Self->{UserID};
        my $QueueID      = '';
        if ( $Dest =~ /^(\d{1,100})\|\|.+?$/ ) {
            $QueueID = $1;
        }

        # get list type
        my $TreeView = 0;
        if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }

        my $Tos = $Self->_GetTos(
            %GetParam,
            %ACLCompatGetParam,
            QueueID => $QueueID,
        );

        my $NewTos;

        if ($Tos) {
            TOs:
            for my $KeyTo ( sort keys %{$Tos} ) {
                next TOs if ( $Tos->{$KeyTo} eq '-' );
                $NewTos->{"$KeyTo||$Tos->{$KeyTo}"} = $Tos->{$KeyTo};
            }
        }
        my $Priorities = $Self->_GetPriorities(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $Services = $Self->_GetServices(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );
        my $SLAs = $Self->_GetSLAs(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
            Services       => $Services,
        );
        my $Types = $Self->_GetTypes(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID        => $QueueID      || 1,
        );

        # update Dynamic Fields Possible Values via AJAX
        my @DynamicFieldAJAX;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $IsACLReducible = $BackendObject->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next DYNAMICFIELD if !$IsACLReducible;

            my $PossibleValues = $BackendObject->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $TicketObject->TicketAcl(
                %GetParam,
                %ACLCompatGetParam,
                Action         => $Self->{Action},
                QueueID        => $QueueID || 0,
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

        my $JSON = $LayoutObject->BuildSelectionJSON(
            [
                {
                    Name         => 'Dest',
                    Data         => $NewTos,
                    SelectedID   => $Dest,
                    Translation  => 0,
                    PossibleNone => 1,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
                {
                    Name        => 'PriorityID',
                    Data        => $Priorities,
                    SelectedID  => $GetParam{PriorityID},
                    Translation => 1,
                    Max         => 100,
                },
                {
                    Name         => 'ServiceID',
                    Data         => $Services,
                    SelectedID   => $GetParam{ServiceID},
                    PossibleNone => 1,
                    Translation  => 0,
                    TreeView     => $TreeView,
                    Max          => 100,
                },
                {
                    Name         => 'SLAID',
                    Data         => $SLAs,
                    SelectedID   => $GetParam{SLAID},
                    PossibleNone => 1,
                    Translation  => 0,
                    Max          => 100,
                },
                {
                    Name         => 'TypeID',
                    Data         => $Types,
                    SelectedID   => $GetParam{TypeID},
                    PossibleNone => 1,
                    Translation  => 0,
                    Max          => 100,
                },
                @DynamicFieldAJAX,
            ],
        );
        return $LayoutObject->Attachment(
            ContentType => 'application/json; charset=' . $LayoutObject->{Charset},
            Content     => $JSON,
            Type        => 'inline',
            NoCache     => 1,
        );
    }
    else {
        return $LayoutObject->ErrorScreen(
            Message => 'No Subaction!!',
            Comment => 'Please contact your administrator',
        );
    }

}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    # get priority
    my %Priorities;
    if ( $Param{QueueID} || $Param{TicketID} ) {
        %Priorities = $Kernel::OM->Get('Kernel::System::Ticket')->TicketPriorityList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );
    }
    return \%Priorities;
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

sub _GetServices {
    my ( $Self, %Param ) = @_;

    # get service
    my %Service;

    # check needed
    return \%Service if !$Param{QueueID} && !$Param{TicketID};

    # get options for default services for unknown customers
    my $DefaultServiceUnknownCustomer
        = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Service::Default::UnknownCustomer');

    # get service list
    if ( $Param{CustomerUserID} || $DefaultServiceUnknownCustomer ) {
        %Service = $Kernel::OM->Get('Kernel::System::Ticket')->TicketServiceList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );
    }
    return \%Service;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;

    # get sla
    my %SLA;
    if ( $Param{ServiceID} && $Param{Services} && %{ $Param{Services} } ) {
        if ( $Param{Services}->{ $Param{ServiceID} } ) {
            %SLA = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSLAList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
        }
    }
    return \%SLA;
}

sub _GetTos {
    my ( $Self, %Param ) = @_;

    # check own selection
    my %NewTos = ( '', '-' );
    my $Module = $Kernel::OM->Get('Kernel::Config')->Get('CustomerPanel::NewTicketQueueSelectionModule')
        || 'Kernel::Output::HTML::CustomerNewTicket::QueueSelectionGeneric';
    if ( $Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
        my $Object = $Module->new(
            %{$Self},
            SystemAddress => $Kernel::OM->Get('Kernel::System::SystemAddress'),
            Debug         => $Self->{Debug},
        );

        # log loaded module
        if ( $Self->{Debug} && $Self->{Debug} > 1 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message  => "Module: $Module loaded!",
            );
        }
        %NewTos = (
            $Object->Run(
                Env       => $Self,
                ACLParams => \%Param
            ),
            ( '', => '-' )
        );
    }
    else {
        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalDie(
            Message => "Could not load $Module!",
        );
    }

    return \%NewTos;
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    # get form id
    my $FormID = $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'FormID' );

    # create form id
    if ( !$FormID ) {
        $FormID = $Kernel::OM->Get('Kernel::System::Web::UploadCache')->FormIDCreate();
    }

    $Param{FormID} = $FormID;
    $Param{Errors}->{QueueInvalid} = $Param{Errors}->{QueueInvalid} || '';

    my $DynamicFieldNames = $Self->_GetFieldsToUpdate(
        OnlyDynamicFields => 1,
    );

    # create a string with the quoted dynamic field names separated by commas
    if ( IsArrayRefWithData($DynamicFieldNames) ) {
        for my $Field ( @{$DynamicFieldNames} ) {
            $Param{DynamicFieldNamesStrg} .= ", '" . $Field . "'";
        }
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get list type
    my $TreeView = 0;
    if ( $ConfigObject->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');
    my $Config       = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    if ( $Config->{Queue} ) {

        # check own selection
        my %NewTos = ( '', '-' );
        my $Module = $ConfigObject->Get('CustomerPanel::NewTicketQueueSelectionModule')
            || 'Kernel::Output::HTML::CustomerNewTicket::QueueSelectionGeneric';
        if ( $Kernel::OM->Get('Kernel::System::Main')->Require($Module) ) {
            my $Object = $Module->new(
                %{$Self},
                SystemAddress => $Kernel::OM->Get('Kernel::System::SystemAddress'),
                Debug         => $Self->{Debug},
            );

            # log loaded module
            if ( $Self->{Debug} && $Self->{Debug} > 1 ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'debug',
                    Message  => "Module: $Module loaded!",
                );
            }
            %NewTos = (
                $Object->Run(
                    Env       => $Self,
                    ACLParams => \%Param
                ),
                ( '', => '-' )
            );
        }
        else {
            return $LayoutObject->FatalError();
        }

        # build to string
        if (%NewTos) {
            for ( sort keys %NewTos ) {
                $NewTos{"$_||$NewTos{$_}"} = $NewTos{$_};
                delete $NewTos{$_};
            }
        }
        $Param{ToStrg} = $LayoutObject->AgentQueueListOption(
            Data       => \%NewTos,
            Multiple   => 0,
            Size       => 0,
            Name       => 'Dest',
            Class      => "Validate_Required Modernize " . $Param{Errors}->{QueueInvalid},
            SelectedID => $Param{ToSelected} || $Param{QueueID},
            TreeView   => $TreeView,
        );
        $LayoutObject->Block(
            Name => 'Queue',
            Data => {
                %Param,
                QueueInvalid => $Param{Errors}->{QueueInvalid},
            },
        );

    }

    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get priority
    if ( $Config->{Priority} ) {
        my %Priorities = $TicketObject->TicketPriorityList(
            %Param,
            CustomerUserID => $Self->{UserID},
            Action         => $Self->{Action},
        );

        # build priority string
        my %PrioritySelected;
        if ( $Param{PriorityID} ) {
            $PrioritySelected{SelectedID} = $Param{PriorityID};
        }
        else {
            $PrioritySelected{SelectedValue} = $Config->{PriorityDefault} || '3 normal';
        }
        $Param{PriorityStrg} = $LayoutObject->BuildSelection(
            Data  => \%Priorities,
            Name  => 'PriorityID',
            Class => 'Modernize',
            %PrioritySelected,
        );
        $LayoutObject->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }

    # types
    if ( $ConfigObject->Get('Ticket::Type') && $Config->{'TicketType'} ) {
        my %Type = $TicketObject->TicketTypeList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );

        if ( $Config->{'TicketTypeDefault'} && !$Param{TypeID} ) {
            my %ReverseType = reverse %Type;
            $Param{TypeID} = $ReverseType{ $Config->{'TicketTypeDefault'} };
        }

        $Param{TypeStrg} = $LayoutObject->BuildSelection(
            Data         => \%Type,
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Class        => "Validate_Required Modernize " . ( $Param{Errors}->{TypeIDInvalid} || '' ),
        );
        $LayoutObject->Block(
            Name => 'TicketType',
            Data => {
                %Param,
                TypeIDInvalid => $Param{Errors}->{TypeIDInvalid},
                }
        );
    }

    # services
    if ( $ConfigObject->Get('Ticket::Service') && $Config->{Service} ) {
        my %Services;
        if ( $Param{QueueID} || $Param{TicketID} ) {
            %Services = $TicketObject->TicketServiceList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
        }

        if ( $Config->{ServiceMandatory} ) {
            $Param{ServiceStrg} = $LayoutObject->BuildSelection(
                Data         => \%Services,
                Name         => 'ServiceID',
                SelectedID   => $Param{ServiceID},
                Class        => "Validate_Required Modernize " . ( $Param{Errors}->{ServiceIDInvalid} || '' ),
                PossibleNone => 1,
                TreeView     => $TreeView,
                Sort         => 'TreeView',
                Translation  => 0,
                Max          => 200,
            );
            $LayoutObject->Block(
                Name => 'TicketServiceMandatory',
                Data => \%Param,
            );
        }
        else {
            $Param{ServiceStrg} = $LayoutObject->BuildSelection(
                Data         => \%Services,
                Name         => 'ServiceID',
                SelectedID   => $Param{ServiceID},
                Class        => 'Modernize',
                PossibleNone => 1,
                TreeView     => $TreeView,
                Sort         => 'TreeView',
                Translation  => 0,
                Max          => 200,
            );
            $LayoutObject->Block(
                Name => 'TicketService',
                Data => \%Param,
            );
        }

        # reset previous ServiceID to reset SLA-List if no service is selected
        if ( !$Services{ $Param{ServiceID} || '' } ) {
            $Param{ServiceID} = '';
        }
        my %SLA;
        if ( $Config->{SLA} ) {
            if ( $Param{ServiceID} ) {
                %SLA = $TicketObject->TicketSLAList(
                    %Param,
                    Action         => $Self->{Action},
                    CustomerUserID => $Self->{UserID},
                );
            }

            if ( $Config->{SLAMandatory} ) {
                $Param{SLAStrg} = $LayoutObject->BuildSelection(
                    Data         => \%SLA,
                    Name         => 'SLAID',
                    SelectedID   => $Param{SLAID},
                    Class        => "Validate_Required Modernize " . ( $Param{Errors}->{SLAIDInvalid} || '' ),
                    PossibleNone => 1,
                    Sort         => 'AlphanumericValue',
                    Translation  => 0,
                    Max          => 200,
                );
                $LayoutObject->Block(
                    Name => 'TicketSLAMandatory',
                    Data => \%Param,
                );
            }
            else {
                $Param{SLAStrg} = $LayoutObject->BuildSelection(
                    Data         => \%SLA,
                    Name         => 'SLAID',
                    SelectedID   => $Param{SLAID},
                    Class        => 'Modernize',
                    PossibleNone => 1,
                    Sort         => 'AlphanumericValue',
                    Translation  => 0,
                    Max          => 200,
                );
                $LayoutObject->Block(
                    Name => 'TicketSLA',
                    Data => \%Param,
                );
            }
        }
    }

    # prepare errors
    if ( $Param{Errors} ) {
        for ( sort keys %{ $Param{Errors} } ) {
            $Param{$_} = $Param{Errors}->{$_};
        }
    }

    # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => $Config->{DynamicField} || {},
    );

    # reduce the dynamic fields to only the ones that are desinged for customer interface
    my @CustomerDynamicFields;
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsCustomerInterfaceCapable = $Kernel::OM->Get('Kernel::System::DynamicField::Backend')->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsCustomerInterfaceCapable',
        );
        next DYNAMICFIELD if !$IsCustomerInterfaceCapable;

        push @CustomerDynamicFields, $DynamicFieldConfig;
    }
    $DynamicField = \@CustomerDynamicFields;

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
        $LayoutObject->Block(
            Name => 'Attachment',
            Data => $Attachment,
        );
    }

    # add rich text editor
    if ( $LayoutObject->{BrowserRichText} ) {

        # use height/width defined for this screen
        $Param{RichTextHeight} = $Config->{RichTextHeight} || 0;
        $Param{RichTextWidth}  = $Config->{RichTextWidth}  || 0;

        $LayoutObject->Block(
            Name => 'RichText',
            Data => \%Param,
        );
    }

    # Permissions have been checked before in Run()
    if ( $Param{FromChatID} ) {
        my @ChatMessages = $Kernel::OM->Get('Kernel::System::Chat')->ChatMessageList(
            ChatID => $Param{FromChatID},
        );
        $LayoutObject->Block(
            Name => 'ChatArticlePreview',
            Data => {
                ChatMessages => \@ChatMessages,
            },
        );
    }

    # get output back
    return $LayoutObject->Output(
        TemplateFile => 'CustomerTicketMessage',
        Data         => \%Param,
    );
}

sub _GetFieldsToUpdate {
    my ( $Self, %Param ) = @_;

    my @UpdatableFields;

    # set the fields that can be updatable via AJAXUpdate
    if ( !$Param{OnlyDynamicFields} ) {
        @UpdatableFields = qw( Dest ServiceID SLAID PriorityID );
    }

    my $Config = $Kernel::OM->Get('Kernel::Config')->Get("Ticket::Frontend::$Self->{Action}");

    # get the dynamic fields for this screen
    my $DynamicField = $Kernel::OM->Get('Kernel::System::DynamicField')->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
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

1;
