# --
# Kernel/Modules/CustomerTicketMessage.pm - to handle customer messages
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketMessage;

use strict;
use warnings;

use Kernel::System::CustomerUser;
use Kernel::System::Web::UploadCache;
use Kernel::System::SystemAddress;
use Kernel::System::Queue;
use Kernel::System::State;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # needed objects
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{SystemAddress}      = Kernel::System::SystemAddress->new(%Param);
    $Self->{QueueObject}        = Kernel::System::Queue->new(%Param);
    $Self->{UploadCacheObject}  = Kernel::System::Web::UploadCache->new(%Param);
    $Self->{DynamicFieldObject} = Kernel::System::DynamicField->new(%Param);
    $Self->{BackendObject}      = Kernel::System::DynamicField::Backend->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

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

    # get params
    my %GetParam;
    for my $Key (qw( Subject Body PriorityID TypeID ServiceID SLAID Expand Dest)) {
        $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
    }

    # ACL compatibility translation
    my %ACLCompatGetParam;
    $ACLCompatGetParam{OwnerID} = $GetParam{NewUserID};

    # get Dynamic fields from ParamObject
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

    if ( !$Self->{Subaction} ) {

        #Get default Queue ID if none is set
        my $QueueDefaultID;
        if ( !$GetParam{Dest} && !$Param{ToSelected} ) {
            my $QueueDefault = $Self->{Config}->{'QueueDefault'} || '';
            if ($QueueDefault) {
                $QueueDefaultID = $Self->{QueueObject}->QueueLookup( Queue => $QueueDefault );
                if ($QueueDefaultID) {
                    $Param{ToSelected} = $QueueDefaultID . '||' . $QueueDefault;
                }
            }

            # warn if there is no (valid) default queue and the customer can't select one
            elsif ( !$Self->{Config}->{'Queue'} ) {
                $Self->{LayoutObject}->CustomerFatalError(
                    Message => 'Check SysConfig setting for ' . $Self->{Action} . '::QueueDefault.',
                    Comment => 'Please contact your administrator',
                );
                return;
            }
        }

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            # get PossibleValues
            my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # check if field has PossibleValues property in its configuration
            if ( IsHashRefWithData( $PossibleValues ) ) {

                # convert possible values key => value to key => key for ACLs usign a Hash slice
                my %AclData = %{ $PossibleValues };
                @AclData{ keys %AclData } = keys %AclData;

                # set possible values filter from ACLs
                my $ACL = $Self->{TicketObject}->TicketAcl(
                    %GetParam,
                    Action         => $Self->{Action},
                    TicketID       => $Self->{TicketID},
                    ReturnType     => 'Ticket',
                    ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data           => \%AclData,
                    CustomerUserID => $Self->{UserID},
                );
                if ($ACL) {
                    my %Filter = $Self->{TicketObject}->TicketAclData();

                    # convert Filer key => key back to key => value using map
                    %{$PossibleValuesFilter}
                        = map { $_ => $PossibleValues->{$_} }
                        keys %Filter;
                }
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $Self->{BackendObject}->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                Mandatory =>
                    $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                LayoutObject    => $Self->{LayoutObject},
                ParamObject     => $Self->{ParamObject},
                AJAXUpdate      => 1,
                UpdatableFields => $Self->_GetFieldsToUpdate(),
                );
        }

        # print form ...
        my $Output .= $Self->{LayoutObject}->CustomerHeader();
        $Output    .= $Self->{LayoutObject}->CustomerNavigationBar();
        $Output    .= $Self->_MaskNew(
            %GetParam,
            QueueID          => $QueueDefaultID,
            ToSelected       => $Param{ToSelected},
            DynamicFieldHTML => \%DynamicFieldHTML,
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    elsif ( $Self->{Subaction} eq 'StoreNew' ) {
        my $NextScreen = $Self->{Config}->{NextScreenAfterNewTicket};
        my %Error;

        # get destination queue
        my $Dest = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my ( $NewQueueID, $To ) = split( /\|\|/, $Dest );
        if ( !$To ) {
            $NewQueueID = $Self->{ParamObject}->GetParam( Param => 'NewQueueID' ) || '';
            $To = 'System';
        }

        # fallback, if no destination is given
        if ( !$NewQueueID ) {
            my $Queue
                = $Self->{ParamObject}->GetParam( Param => 'Queue' )
                || $Self->{Config}->{'QueueDefault'}
                || '';
            if ($Queue) {
                my $QueueID = $Self->{QueueObject}->QueueLookup( Queue => $Queue );
                $NewQueueID = $QueueID;
                $To         = $Queue;
            }
        }

        # use default if ticket type is not available in screen but activated on system
        if ( $Self->{ConfigObject}->Get('Ticket::Type') && !$Self->{Config}->{'TicketType'} ) {
            my %TypeList = reverse $Self->{TicketObject}->TicketTypeList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
            $GetParam{TypeID} = $TypeList{ $Self->{Config}->{'TicketTypeDefault'} };
            if ( !$GetParam{TypeID} ) {
                $Self->{LayoutObject}->CustomerFatalError(
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
            $IsUpload = 1;
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param => 'file_upload',
            );
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $PossibleValuesFilter;

            # get PossibleValues
            my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # check if field has PossibleValues property in its configuration
            if ( IsHashRefWithData( $PossibleValues ) ) {

                # convert possible values key => value to key => key for ACLs usign a Hash slice
                my %AclData = %{ $PossibleValues };
                @AclData{ keys %AclData } = keys %AclData;

                # set possible values filter from ACLs
                my $ACL = $Self->{TicketObject}->TicketAcl(
                    %GetParam,
                    Action         => $Self->{Action},
                    TicketID       => $Self->{TicketID},
                    ReturnType     => 'Ticket',
                    ReturnSubType  => 'DynamicField_' . $DynamicFieldConfig->{Name},
                    Data           => \%AclData,
                    CustomerUserID => $Self->{UserID},
                );
                if ($ACL) {
                    my %Filter = $Self->{TicketObject}->TicketAclData();

                    # convert Filer key => key back to key => value using map
                    %{$PossibleValuesFilter}
                        = map { $_ => $PossibleValues->{$_} }
                        keys %Filter;
                }
            }

            my $ValidationResult;

            # do not validate on attachment upload or GetParam Expand
            if ( !$IsUpload && !$GetParam{Expand} ) {

                $ValidationResult = $Self->{BackendObject}->EditFieldValueValidate(
                    DynamicFieldConfig   => $DynamicFieldConfig,
                    PossibleValuesFilter => $PossibleValuesFilter,
                    ParamObject          => $Self->{ParamObject},
                    Mandatory =>
                        $Self->{Config}->{DynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                );

                if ( !IsHashRefWithData($ValidationResult) ) {
                    my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
                    $Output .= $Self->{LayoutObject}->CustomerError(
                        Message =>
                            "Could not perform validation on field $DynamicFieldConfig->{Label}!",
                        Comment => 'Please contact your administrator',
                    );
                    $Output .= $Self->{LayoutObject}->CustomerFooter();
                    return $Output;
                }

                # propagate validation error to the Error variable to be detected by the frontend
                if ( $ValidationResult->{ServerError} ) {
                    $Error{ $DynamicFieldConfig->{Name} } = ' ServerError';
                }
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $Self->{BackendObject}->EditFieldRender(
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

        # rewrap body if rich text is used
        if ( $Self->{LayoutObject}->{BrowserRichText} && $GetParam{Body} ) {
            $GetParam{Body}
                =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
        }

        # check queue
        if ( !$NewQueueID && !$IsUpload && !$GetParam{Expand} ) {
            $Error{QueueInvalid} = 'ServerError';
        }

        # prevent tamper with (Queue/Dest), see bug#9408
        if ($NewQueueID && !$IsUpload) {

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
            if ( $To ne $Tos->{$NewQueueID} ){
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

        # check type
        if (
            $Self->{ConfigObject}->Get('Ticket::Type')
            && !$GetParam{TypeID}
            && !$IsUpload
            && !$GetParam{Expand}
            )
        {
            $Error{TypeIDInvalid} = 'ServerError';
        }

        if (%Error) {

            # html output
            my $Output .= $Self->{LayoutObject}->CustomerHeader();
            $Output    .= $Self->{LayoutObject}->CustomerNavigationBar();
            $Output    .= $Self->_MaskNew(
                Attachments => \@Attachments,
                %GetParam,
                ToSelected       => $Dest,
                QueueID          => $NewQueueID,
                DynamicFieldHTML => \%DynamicFieldHTML,
                Errors           => \%Error,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # if customer is not allowed to set priority, set it to default
        if ( !$Self->{Config}->{Priority} ) {
            $GetParam{PriorityID} = '';
            $GetParam{Priority}   = $Self->{Config}->{PriorityDefault};
        }

        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            QueueID      => $NewQueueID,
            TypeID       => $GetParam{TypeID},
            ServiceID    => $GetParam{ServiceID},
            SLAID        => $GetParam{SLAID},
            Title        => $GetParam{Subject},
            PriorityID   => $GetParam{PriorityID},
            Priority     => $GetParam{Priority},
            Lock         => 'unlock',
            State        => $Self->{Config}->{StateDefault},
            CustomerID   => $Self->{UserCustomerID},
            CustomerUser => $Self->{UserLogin},
            OwnerID      => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            UserID       => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
        );

        # set ticket dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';

            # set the value
            my $Success = $Self->{BackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        my $MimeType = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # verify html document
            $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        # create article
        my $FullName = $Self->{CustomerUserObject}->CustomerName(
            UserLogin => $Self->{UserLogin},
        );
        my $From      = "\"$FullName\" <$Self->{UserEmail}>";
        my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID         => $TicketID,
            ArticleType      => $Self->{Config}->{ArticleType},
            SenderType       => $Self->{Config}->{SenderType},
            From             => $From,
            To               => $To,
            Subject          => $GetParam{Subject},
            Body             => $GetParam{Body},
            MimeType         => $MimeType,
            Charset          => $Self->{LayoutObject}->{UserCharset},
            UserID           => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            HistoryType      => $Self->{Config}->{HistoryType},
            HistoryComment   => $Self->{Config}->{HistoryComment} || '%%',
            AutoResponseType => 'auto reply',
            OrigHeader       => {
                From    => $From,
                To      => $Self->{UserLogin},
                Subject => $GetParam{Subject},
                Body    => $Self->{LayoutObject}->RichText2Ascii( String => $GetParam{Body} ),
            },
            Queue => $Self->{QueueObject}->QueueLookup( QueueID => $NewQueueID ),
        );
        if ( !$ArticleID ) {
            my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
            $Output .= $Self->{LayoutObject}->CustomerError();
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # set article dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Article';

            # set the value
            my $Success = $Self->{BackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $ArticleID,
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        # get pre loaded attachment
        my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );

        # get submitted attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'file_upload',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        # write attachments
        for my $Attachment (@AttachmentData) {

            # skip, deleted not used inline images
            my $ContentID = $Attachment->{ContentID};
            if ($ContentID) {
                my $ContentIDHTMLQuote = $Self->{LayoutObject}->Ascii2Html(
                    Text => $ContentID,
                );

                # workaround for link encode of rich text editor, see bug#5053
                my $ContentIDLinkEncode = $Self->{LayoutObject}->LinkEncode($ContentID);
                $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                # ignore attachment if not linked in body
                next if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
            }

            # write existing file to backend
            $Self->{TicketObject}->ArticleWriteAttachment(
                %{$Attachment},
                ArticleID => $ArticleID,
                UserID    => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        # remove pre submitted attachments
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$NextScreen;TicketID=$TicketID",
        );
    }

    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        my $Dest         = $Self->{ParamObject}->GetParam( Param => 'Dest' ) || '';
        my $CustomerUser = $Self->{UserID};
        my $QueueID      = '';
        if ( $Dest =~ /^(\d{1,100})\|\|.+?$/ ) {
            $QueueID = $1;
        }

        # get list type
        my $TreeView = 0;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }

        my $Tos = $Self->_GetTos(
            %GetParam,
            %ACLCompatGetParam,
            QueueID => $QueueID,
        );

        my $NewTos;

        if ($Tos) {
            for my $KeyTo ( sort keys %{$Tos} ) {
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

        # update Dynamic Fields Possible Values via AJAX
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

            my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # convert possible values key => value to key => key for ACLs usign a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $Self->{TicketObject}->TicketAcl(
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
                my %Filter = $Self->{TicketObject}->TicketAclData();

                # convert Filer key => key back to key => value using map
                %{$PossibleValues} = map { $_ => $PossibleValues->{$_} } keys %Filter;
            }

            my $DataValues = $Self->{BackendObject}->BuildSelectionDataGet(
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

        my $JSON = $Self->{LayoutObject}->BuildSelectionJSON(
            [
                {
                    Name         => 'Dest',
                    Data         => $NewTos,
                    SelectedID   => $Dest,
                    Translation  => 0,
                    PossibleNone => 0,
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
    else {
        return $Self->{LayoutObject}->ErrorScreen(
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
        %Priorities = $Self->{TicketObject}->TicketPriorityList(
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
        %Type = $Self->{TicketObject}->TicketTypeList(
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
        = $Self->{ConfigObject}->Get('Ticket::Service::Default::UnknownCustomer');

    # get service list
    if ( $Param{CustomerUserID} || $DefaultServiceUnknownCustomer ) {
        %Service = $Self->{TicketObject}->TicketServiceList(
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
            %SLA = $Self->{TicketObject}->TicketSLAList(
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
    my $Module = $Self->{ConfigObject}->Get('CustomerPanel::NewTicketQueueSelectionModule')
        || 'Kernel::Output::HTML::CustomerNewTicketQueueSelectionGeneric';
    if ( $Self->{MainObject}->Require($Module) ) {
        my $Object = $Module->new( %{$Self}, Debug => $Self->{Debug}, );

        # log loaded module
        if ( $Self->{Debug} > 1 ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message  => "Module: $Module loaded!",
            );
        }
        %NewTos = ( $Object->Run( Env => $Self, ACLParams => \%Param ), ( '', => '-' ) );
    }
    else {
        return $Self->{LayoutObject}->FatalDie(
            Message => "Could not load $Module!",
        );
    }

    return \%NewTos;
}

sub _MaskNew {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};
    $Param{Errors}->{QueueInvalid} = $Param{Errors}->{QueueInvalid} || '';

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }

    if ( $Self->{Config}->{Queue} ) {

        # check own selection
        my %NewTos = ( '', '-' );
        my $Module = $Self->{ConfigObject}->Get('CustomerPanel::NewTicketQueueSelectionModule')
            || 'Kernel::Output::HTML::CustomerNewTicketQueueSelectionGeneric';
        if ( $Self->{MainObject}->Require($Module) ) {
            my $Object = $Module->new( %{$Self}, Debug => $Self->{Debug}, );

            # log loaded module
            if ( $Self->{Debug} > 1 ) {
                $Self->{LogObject}->Log(
                    Priority => 'debug',
                    Message  => "Module: $Module loaded!",
                );
            }
            %NewTos = ( $Object->Run( Env => $Self, ACLParams => \%Param ), ( '', => '-' ) );
        }
        else {
            return $Self->{LayoutObject}->FatalError();
        }

        # build to string
        if (%NewTos) {
            for ( sort keys %NewTos ) {
                $NewTos{"$_||$NewTos{$_}"} = $NewTos{$_};
                delete $NewTos{$_};
            }
        }
        $Param{ToStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Data       => \%NewTos,
            Multiple   => 0,
            Size       => 0,
            Name       => 'Dest',
            Class      => "Validate_Required " . $Param{Errors}->{QueueInvalid},
            SelectedID => $Param{ToSelected} || $Param{QueueID},
            TreeView   => $TreeView,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Queue',
            Data => {
                %Param,
                QueueInvalid => $Param{Errors}->{QueueInvalid},
            },
        );

    }

    # get priority
    if ( $Self->{Config}->{Priority} ) {
        my %Priorities = $Self->{TicketObject}->TicketPriorityList(
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
            $PrioritySelected{SelectedValue} = $Self->{Config}->{PriorityDefault} || '3 normal';
        }
        $Param{PriorityStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%Priorities,
            Name => 'PriorityID',
            %PrioritySelected,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }

    # types
    if ( $Self->{ConfigObject}->Get('Ticket::Type') && $Self->{Config}->{'TicketType'} ) {
        my %Type = $Self->{TicketObject}->TicketTypeList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );

        if ( $Self->{Config}->{'TicketTypeDefault'} && !$Param{TypeID} ) {
            my %ReverseType = reverse %Type;
            $Param{TypeID} = $ReverseType{ $Self->{Config}->{'TicketTypeDefault'} };
        }

        $Param{TypeStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%Type,
            Name         => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
            Class        => "Validate_Required " . ( $Param{Errors}->{TypeIDInvalid} || '' ),
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {
                %Param,
                TypeIDInvalid => $Param{Errors}->{TypeIDInvalid},
                }
        );
    }

    # services
    if ( $Self->{ConfigObject}->Get('Ticket::Service') && $Self->{Config}->{Service} ) {
        my %Services;
        if ( $Param{QueueID} || $Param{TicketID} ) {
            %Services = $Self->{TicketObject}->TicketServiceList(
                %Param,
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
        }
        $Param{ServiceStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%Services,
            Name         => 'ServiceID',
            SelectedID   => $Param{ServiceID},
            PossibleNone => 1,
            TreeView     => $TreeView,
            Sort         => 'TreeView',
            Translation  => 0,
            Max          => 200,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketService',
            Data => \%Param,
        );

        # reset previous ServiceID to reset SLA-List if no service is selected
        if ( !$Services{ $Param{ServiceID} || '' } ) {
            $Param{ServiceID} = '';
        }
        my %SLA;
        if ( $Self->{Config}->{SLA} ) {
            if ( $Param{ServiceID} ) {
                %SLA = $Self->{TicketObject}->TicketSLAList(
                    %Param,
                    Action         => $Self->{Action},
                    CustomerUserID => $Self->{UserID},
                );
            }
            $Param{SLAStrg} = $Self->{LayoutObject}->BuildSelection(
                Data         => \%SLA,
                Name         => 'SLAID',
                SelectedID   => $Param{SLAID},
                PossibleNone => 1,
                Sort         => 'AlphanumericValue',
                Translation  => 0,
                Max          => 200,
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketSLA',
                Data => \%Param,
            );
        }
    }

    # prepare errors
    if ( $Param{Errors} ) {
        for ( sort keys %{ $Param{Errors} } ) {
            $Param{$_} = $Param{Errors}->{$_};
        }
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

    # show attachments
    for my $Attachment ( @{ $Param{Attachments} } ) {
        next if $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText};
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $Attachment,
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

    # get output back
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketMessage',
        Data         => \%Param,
    );
}

sub _GetFieldsToUpdate {
    my ( $Self, %Param ) = @_;

    my @UpdatableFields;

    # set the fields that can be updatable via AJAXUpdate
    if ( !$Param{OnlyDynamicFields} ) {
        @UpdatableFields
            = qw( Dest ServiceID SLAID PriorityID );
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
