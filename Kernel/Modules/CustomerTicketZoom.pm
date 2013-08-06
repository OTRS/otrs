# --
# Kernel/Modules/CustomerTicketZoom.pm - to get a closer view
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketZoom;

use strict;
use warnings;

use Kernel::System::Web::UploadCache;
use Kernel::System::State;
use Kernel::System::User;
use Kernel::System::DynamicField;
use Kernel::System::DynamicField::Backend;
use Kernel::System::ProcessManagement::Activity;
use Kernel::System::ProcessManagement::ActivityDialog;
use Kernel::System::ProcessManagement::Process;
use Kernel::System::ProcessManagement::Transition;
use Kernel::System::ProcessManagement::TransitionAction;
use Kernel::System::VariableCheck qw(:all);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (
        qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject
        ConfigObject UserObject SessionObject
        )
        )
    {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    # get params
    $Self->{ZoomExpand} = $Self->{ParamObject}->GetParam( Param => 'ZoomExpand' );
    if ( !defined $Self->{ZoomExpand} ) {
        $Self->{ZoomExpand} = $Self->{ConfigObject}->Get('Ticket::Frontend::ZoomExpand') || '';
    }

    # needed objects
    $Self->{AgentUserObject}    = Kernel::System::User->new(%Param);
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
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

    # get dynamic field config for frontend module
    $Self->{DynamicFieldFilter} = $Self->{Config}->{DynamicField};

    $Self->{FollowUpDynamicFieldFilter} = $Self->{Config}->{FollowUpDynamicField};

    # get the dynamic fields for ticket object
    $Self->{FollowUpDynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => [ 'Ticket', 'Article' ],
        FieldFilter => $Self->{FollowUpDynamicFieldFilter} || {},
    );

    # create additional objects for process management
    $Self->{ActivityObject} = Kernel::System::ProcessManagement::Activity->new(%Param);
    $Self->{ActivityDialogObject}
        = Kernel::System::ProcessManagement::ActivityDialog->new(%Param);

    $Self->{TransitionObject} = Kernel::System::ProcessManagement::Transition->new(%Param);
    $Self->{TransitionActionObject}
        = Kernel::System::ProcessManagement::TransitionAction->new(%Param);

    $Self->{ProcessObject} = Kernel::System::ProcessManagement::Process->new(
        %Param,
        ActivityObject         => $Self->{ActivityObject},
        ActivityDialogObject   => $Self->{ActivityDialogObject},
        TransitionObject       => $Self->{TransitionObject},
        TransitionActionObject => $Self->{TransitionActionObject},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ticket id lookup
    if ( !$Self->{TicketID} && $Self->{ParamObject}->GetParam( Param => 'TicketNumber' ) ) {
        $Self->{TicketID} = $Self->{TicketObject}->TicketIDLookup(
            TicketNumber => $Self->{ParamObject}->GetParam( Param => 'TicketNumber' ),
            UserID       => $Self->{UserID},
        );
    }

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError( Message => 'Need TicketID!' );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # check permissions
    my $Access = $Self->{TicketObject}->TicketCustomerPermission(
        Type     => 'ro',
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->CustomerNoPermission( WithHeader => 'yes' );
    }

    # store last screen
    if ( $Self->{Subaction} ne 'ShowHTMLeMail' ) {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $Self->{RequestedURL},
        );
    }

    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 1,
    );

    # strip html and ascii attachments of content
    my $StripPlainBodyAsAttachment = 1;

    # check if rich text is enabled, if not only stip ascii attachments
    if ( !$Self->{LayoutObject}->{BrowserRichText} ) {
        $StripPlainBodyAsAttachment = 2;
    }

    # get all articles of this ticket
    my @CustomerArticleTypes = $Self->{TicketObject}->ArticleTypeList( Type => 'Customer' );
    my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(
        TicketID                   => $Self->{TicketID},
        ArticleType                => \@CustomerArticleTypes,
        StripPlainBodyAsAttachment => $StripPlainBodyAsAttachment,
        UserID                     => $Self->{UserID},
        DynamicFields              => 0,
    );

    # get params
    my %GetParam;
    for my $Key (qw( Subject Body StateID PriorityID)) {
        $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
    }

    # ACL compatibility translation
    my %ACLCompatGetParam;
    $ACLCompatGetParam{OwnerID} = $GetParam{NewUserID};

    # get Dynamic fields from ParamObject
    my %DynamicFieldValues;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{FollowUpDynamicField} } ) {
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

    if ( $Self->{Subaction} eq 'AJAXUpdate' ) {

        # get TicketID
        if ( !$GetParam{TicketID} ) {
            $GetParam{TicketID} =
                $Self->{TicketID} ||
                $Self->{ParamObject}->GetParam( Param => 'TicketID' );
        }

        my $CustomerUser = $Self->{UserID};

        my $Priorities = $Self->_GetPriorities(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
        );
        my $NextStates = $Self->_GetNextStates(
            %GetParam,
            %ACLCompatGetParam,
            CustomerUserID => $CustomerUser || '',
        );

        # update Dynamic Fields Possible Values via AJAX
        my @DynamicFieldAJAX;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{FollowUpDynamicField} } ) {
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
                Action         => $Self->{Action},
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
                    Name        => 'PriorityID',
                    Data        => $Priorities,
                    SelectedID  => $GetParam{PriorityID},
                    Translation => 1,
                    Max         => 100,
                },
                {
                    Name        => 'StateID',
                    Data        => $NextStates,
                    SelectedID  => $GetParam{StateID},
                    Translation => 1,
                    Max         => 100,
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

    #   end AJAX Update

    # check follow up
    elsif ( $Self->{Subaction} eq 'Store' ) {
        my $NextScreen = $Self->{NextScreen} || $Self->{Config}->{NextScreenAfterFollowUp};
        my %Error;

        # rewrap body if no rich text is used
        if ( $GetParam{Body} && !$Self->{LayoutObject}->{BrowserRichText} ) {
            $GetParam{Body} = $Self->{LayoutObject}->WrapPlainText(
                MaxCharacters => $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote'),
                PlainText     => $GetParam{Body},
            );
        }

        # get follow up option (possible or not)
        my $FollowUpPossible = $Self->{QueueObject}->GetFollowUpOption(
            QueueID => $Ticket{QueueID},
        );

        # get lock option (should be the ticket locked - if closed - after the follow up)
        my $Lock = $Self->{QueueObject}->GetFollowUpLockOption( QueueID => $Ticket{QueueID}, );

        # get ticket state details
        my %State = $Self->{StateObject}->StateGet(
            ID => $Ticket{StateID},
        );
        if ( $FollowUpPossible =~ /(new ticket|reject)/i && $State{TypeName} =~ /^close/i ) {
            my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
            $Output .= $Self->{LayoutObject}->CustomerWarning(
                Message => 'Can\'t reopen ticket, not possible in this queue!',
                Comment => 'Create a new ticket!',
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # rewrap body if no rich text is used
        if ( $GetParam{Body} && !$Self->{LayoutObject}->{BrowserRichText} ) {
            $GetParam{Body} = $Self->{LayoutObject}->WrapPlainText(
                MaxCharacters => $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote'),
                PlainText     => $GetParam{Body},
            );
        }

        # for attachment actions
        my $IsUpload = 0;

        # attachment delete
        for my $Count ( 1 .. 32 ) {
            my $Delete = $Self->{ParamObject}->GetParam( Param => "AttachmentDelete$Count" );
            next if !$Delete;
            $GetParam{FollowUpVisible} = 'Visible';
            $Error{AttachmentDelete}   = 1;
            $Self->{UploadCacheObject}->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $Count,
            );
            $IsUpload = 1;
        }

        # attachment upload
        if ( $Self->{ParamObject}->GetParam( Param => 'AttachmentUpload' ) ) {
            $GetParam{FollowUpVisible} = 'Visible';
            $Error{AttachmentUpload}   = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param  => "file_upload",
                Source => 'string',
            );
            $Self->{UploadCacheObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
            $IsUpload = 1;
        }

        if ( !$IsUpload ) {
            if ( !$GetParam{Body} || $GetParam{Body} eq '<br />' ) {
                $Error{RichTextInvalid}    = 'ServerError';
                $GetParam{FollowUpVisible} = 'Visible';
            }
        }

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{FollowUpDynamicField} } ) {
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
                        $Self->{Config}->{FollowUpDynamicField}->{ $DynamicFieldConfig->{Name} }
                        == 2,
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

                    # make FollowUp visible to correcly show the error
                    $GetParam{FollowUpVisible} = 'Visible';
                }
            }

            # get field html
            $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
                $Self->{BackendObject}->EditFieldRender(
                DynamicFieldConfig   => $DynamicFieldConfig,
                PossibleValuesFilter => $PossibleValuesFilter,
                Mandatory =>
                    $Self->{Config}->{FollowUpDynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
                ServerError  => $ValidationResult->{ServerError}  || '',
                ErrorMessage => $ValidationResult->{ErrorMessage} || '',
                LayoutObject => $Self->{LayoutObject},
                ParamObject  => $Self->{ParamObject},
                AJAXUpdate   => 1,
                UpdatableFields => $Self->_GetFieldsToUpdate(),
                );
        }

        # show edit again
        if (%Error) {

            # generate output
            my $Output = $Self->{LayoutObject}->CustomerHeader( Value => $Ticket{TicketNumber} );
            $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
            $Output .= $Self->_Mask(
                TicketID   => $Self->{TicketID},
                ArticleBox => \@ArticleBox,
                Errors     => \%Error,
                %Ticket,
                TicketState   => $Ticket{State},
                TicketStateID => $Ticket{StateID},
                %GetParam,
                DynamicFieldHTML => \%DynamicFieldHTML,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # unlock ticket if agent is on vacation or invalid
        my $LockAction;
        if ( $Ticket{OwnerID} ) {
            my %User = $Self->{AgentUserObject}->GetUserData(
                UserID => $Ticket{OwnerID},
            );
            if ( %User && ( $User{OutOfOfficeMessage} || $User{ValidID} ne '1' ) ) {
                $LockAction = 'unlock';
            }
        }

        # set lock if ticket was closed
        if (
            !$LockAction
            && $Lock
            && $State{TypeName} =~ /^close/i && $Ticket{OwnerID} ne '1'
            )
        {

            $LockAction = 'lock';
        }

        if ($LockAction) {
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => $LockAction,
                UserID   => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";

        my $MimeType = 'text/plain';
        if ( $Self->{LayoutObject}->{BrowserRichText} ) {
            $MimeType = 'text/html';

            # verify html document
            $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                String => $GetParam{Body},
            );
        }

        my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID    => $Self->{TicketID},
            ArticleType => $Self->{Config}->{ArticleType},
            SenderType  => $Self->{Config}->{SenderType},
            From        => $From,
            Subject     => $GetParam{Subject},
            Body        => $GetParam{Body},
            MimeType    => $MimeType,
            Charset     => $Self->{LayoutObject}->{UserCharset},
            UserID      => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            OrigHeader  => {
                From    => $From,
                To      => 'System',
                Subject => $GetParam{Subject},
                Body    => $Self->{LayoutObject}->RichText2Ascii( String => $GetParam{Body} ),
            },
            HistoryType      => $Self->{Config}->{HistoryType},
            HistoryComment   => $Self->{Config}->{HistoryComment} || '%%',
            AutoResponseType => 'auto follow up',
        );
        if ( !$ArticleID ) {
            my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
            $Output .= $Self->{LayoutObject}->CustomerError();
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # set state
        my $NextState = $Self->{Config}->{StateDefault} || 'open';
        if ( $GetParam{StateID} && $Self->{Config}->{State} ) {
            my %NextStateData = $Self->{StateObject}->StateGet( ID => $GetParam{StateID} );
            $NextState = $NextStateData{Name};
        }

        # change state if
        # customer set another state
        # or the ticket is not new
        if ( $Ticket{StateType} !~ /^new/ || $GetParam{StateID} ) {
            $Self->{TicketObject}->StateSet(
                TicketID  => $Self->{TicketID},
                ArticleID => $ArticleID,
                State     => $NextState,
                UserID    => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        # set priority
        if ( $Self->{Config}->{Priority} && $GetParam{PriorityID} ) {
            $Self->{TicketObject}->TicketPrioritySet(
                TicketID   => $Self->{TicketID},
                PriorityID => $GetParam{PriorityID},
                UserID     => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        # get pre loaded attachment
        my @AttachmentData = $Self->{UploadCacheObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID}
        );

        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param  => 'file_upload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push @AttachmentData, \%UploadStuff;
        }

        # write attachments
        for my $Attachment (@AttachmentData) {

            # skip deleted inline images
            next if $Attachment->{ContentID}
                && $Attachment->{ContentID} =~ /^inline/
                && $GetParam{Body} !~ /$Attachment->{ContentID}/;
            $Self->{TicketObject}->ArticleWriteAttachment(
                %{$Attachment},
                ArticleID => $ArticleID,
                UserID    => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        # set ticket dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{FollowUpDynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';

            # set the value
            my $Success = $Self->{BackendObject}->ValueSet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $Self->{TicketID},
                Value              => $DynamicFieldValues{ $DynamicFieldConfig->{Name} },
                UserID             => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
            );
        }

        # set article dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{FollowUpDynamicField} } ) {
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

        # remove pre submited attachments
        $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );

        # redirect to zoom view
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=$NextScreen;TicketID=$Self->{TicketID}",
        );
    }

    $Ticket{TmpCounter}      = 0;
    $Ticket{TicketTimeUnits} = $Self->{TicketObject}->TicketAccountedTimeGet(
        TicketID => $Ticket{TicketID},
    );

    # set priority from ticket as fallback
    $GetParam{PriorityID} ||= $Ticket{PriorityID};

    # create html strings for all dynamic fields
    my %DynamicFieldHTML;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{FollowUpDynamicField} } ) {
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
                    = map { $_ => $DynamicFieldConfig->{Config}->{PossibleValues}->{$_} }
                    keys %Filter;
            }
        }

        # get field html
        $DynamicFieldHTML{ $DynamicFieldConfig->{Name} } =
            $Self->{BackendObject}->EditFieldRender(
            DynamicFieldConfig   => $DynamicFieldConfig,
            PossibleValuesFilter => $PossibleValuesFilter,
            Mandatory =>
                $Self->{Config}->{FollowUpDynamicField}->{ $DynamicFieldConfig->{Name} } == 2,
            LayoutObject    => $Self->{LayoutObject},
            ParamObject     => $Self->{ParamObject},
            AJAXUpdate      => 1,
            UpdatableFields => $Self->_GetFieldsToUpdate(),
            Value           => $Ticket{ 'DynamicField_' . $DynamicFieldConfig->{Name} },

            );
    }

    # generate output
    my $Output = $Self->{LayoutObject}->CustomerHeader( Value => $Ticket{TicketNumber} );
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();

    # show ticket
    if ( $Self->{Subaction} eq 'ShowHTMLeMail' ) {

        # if it is a html email, drop normal header
        $Ticket{ShowHTMLeMail} = 1;
        $Output = '';
    }
    $Output .= $Self->_Mask(
        TicketID   => $Self->{TicketID},
        ArticleBox => \@ArticleBox,
        %Ticket,
        TicketState   => $Ticket{State},
        TicketStateID => $Ticket{StateID},
        %GetParam,
        DynamicFieldHTML => \%DynamicFieldHTML,
    );

    # return if HTML email
    if ( $Self->{Subaction} eq 'ShowHTMLeMail' ) {
        return $Output;
    }

    # add footer
    $Output .= $Self->{LayoutObject}->CustomerFooter();

    # return output
    return $Output;
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates;
    if ( $Param{TicketID} ) {
        %NextStates = $Self->{TicketObject}->TicketStateList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );
    }
    return \%NextStates;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    # get priority
    my %Priorities;
    if ( $Param{TicketID} ) {
        %Priorities = $Self->{TicketObject}->TicketPriorityList(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    $Param{FormID} = $Self->{FormID};

    # show back link
    if ( $Self->{LastScreenOverview} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Back',
            Data => \%Param,
        );
    }

    # build article stuff
    my $SelectedArticleID = $Self->{ParamObject}->GetParam( Param => 'ArticleID' ) || '';
    my $BaseLink          = $Self->{LayoutObject}->{Baselink} . "TicketID=$Self->{TicketID}&";
    my @ArticleBox        = @{ $Param{ArticleBox} };

    # prepare errors!
    if ( $Param{Errors} ) {
        for my $KeyError ( sort keys %{ $Param{Errors} } ) {
            $Param{$KeyError}
                = $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$KeyError} );
        }
    }

    my $ArticleID           = '';
    my $LastCustomerArticle = '';
    if (@ArticleBox) {

        # get last customer article
        my $CounterArray = 0;
        my $LastCustomerArticleID;
        $LastCustomerArticle = $#ArticleBox;

        for my $ArticleTmp (@ArticleBox) {
            my %Article = %{$ArticleTmp};

            # if it is a customer article
            if ( $Article{SenderType} eq 'customer' ) {
                $LastCustomerArticleID = $Article{ArticleID};
                $LastCustomerArticle   = $CounterArray;
            }
            $CounterArray++;
            if ( ($SelectedArticleID) && ( $SelectedArticleID eq $Article{ArticleID} ) ) {
                $ArticleID = $Article{ArticleID};
            }
        }

        # try to use the latest non internal agent article
        if ( !$ArticleID ) {
            $ArticleID         = $ArticleBox[-1]->{ArticleID};
            $SelectedArticleID = $ArticleID;
        }

        # try to use the latest customer article
        if ( !$ArticleID && $LastCustomerArticleID ) {
            $ArticleID         = $LastCustomerArticleID;
            $SelectedArticleID = $ArticleID;
        }
    }

    # ticket priority flag
    if ( $Self->{Config}->{AttributesView}->{Priority} ) {
        $Self->{LayoutObject}->Block(
            Name => 'PriorityFlag',
            Data => \%Param,
        );
    }

    # ticket type
    if ( $Self->{ConfigObject}->Get('Ticket::Type') && $Self->{Config}->{AttributesView}->{Type} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Type',
            Data => \%Param,
        );
    }

    # ticket service
    if (
        $Param{Service}
        &&
        $Self->{ConfigObject}->Get('Ticket::Service')
        && $Self->{Config}->{AttributesView}->{Service}
        )
    {
        $Self->{LayoutObject}->Block(
            Name => 'Service',
            Data => \%Param,
        );
        if (
            $Param{SLA}
            && $Self->{ConfigObject}->Get('Ticket::Service')
            && $Self->{Config}->{AttributesView}->{SLA}
            )
        {
            $Self->{LayoutObject}->Block(
                Name => 'SLA',
                Data => \%Param,
            );
        }
    }

    # ticket state
    if ( $Self->{Config}->{AttributesView}->{State} ) {
        $Self->{LayoutObject}->Block(
            Name => 'State',
            Data => \%Param,
        );
    }

    # ticket priority
    if ( $Self->{Config}->{AttributesView}->{Priority} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }

    # ticket queue
    if ( $Self->{Config}->{AttributesView}->{Queue} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Queue',
            Data => \%Param,
        );
    }

    # ticket owner
    if ( $Self->{Config}->{AttributesView}->{Owner} ) {
        my $OwnerName = $Self->{AgentUserObject}->UserName(
            UserID => $Param{OwnerID},
        );
        $Self->{LayoutObject}->Block(
            Name => 'Owner',
            Data => { OwnerName => $OwnerName },
        );
    }

    # ticket responsible
    if (
        $Self->{ConfigObject}->Get('Ticket::Responsible')
        &&
        $Self->{Config}->{AttributesView}->{Responsible}
        )
    {
        my $ResponsibleName = $Self->{AgentUserObject}->UserName(
            UserID => $Param{ResponsibleID},
        );
        $Self->{LayoutObject}->Block(
            Name => 'Responsible',
            Data => { ResponsibleName => $ResponsibleName },
        );
    }

    # check if ticket is normal or process ticket
    my $IsProcessTicket = $Self->{TicketObject}->TicketCheckForProcessType(
        'TicketID' => $Self->{TicketID}
    );

    #    my $ProcessData;
    #    my $ActivityData;
    # show process widget  and activity dialogs on process tickets
    if ($IsProcessTicket) {

        # get the DF where the ProcessEntityID is stored
        my $ProcessEntityIDField = 'DynamicField_'
            . $Self->{ConfigObject}->Get("Process::DynamicFieldProcessManagementProcessID");

        # get the DF where the AtivityEntityID is stored
        my $ActivityEntityIDField = 'DynamicField_'
            . $Self->{ConfigObject}->Get("Process::DynamicFieldProcessManagementActivityID");

        my $ProcessData = $Self->{ProcessObject}->ProcessGet(
            ProcessEntityID => $Param{$ProcessEntityIDField},
        );

        my $ActivityData = $Self->{ActivityObject}->ActivityGet(
            Interface        => 'CustomerInterface',
            ActivityEntityID => $Param{$ActivityEntityIDField},
        );

        # output process information in the sidebar
        $Self->{LayoutObject}->Block(
            Name => 'ProcessData',
            Data => {
                Process  => $ProcessData->{Name}  || '',
                Activity => $ActivityData->{Name} || '',
            },
        );

        # output the process widget the the main screen
        $Self->{LayoutObject}->Block(
            Name => 'ProcessWidget',
            Data => {
                WidgetTitle => $Param{WidgetTitle},
            },
        );

        # get next activity dialogs
        my $NextActivityDialogs;
        if ( $Param{$ActivityEntityIDField} ) {
            $NextActivityDialogs = $ActivityData;
        }

        if ( IsHashRefWithData($NextActivityDialogs) ) {

            # we don't need the whole Activity config,
            # just the Activity Dialogs of the current Activity
            if ( IsHashRefWithData( $NextActivityDialogs->{ActivityDialog} ) ) {
                %{$NextActivityDialogs} = %{ $NextActivityDialogs->{ActivityDialog} };
            }
            else {
                $NextActivityDialogs = {};
            }

            # ACL Check is done in the initial "Run" statement
            # so here we can just pick the possibly reduced Activity Dialogs
            # map and sort reformat the $NextActivityDialogs hash from it's initial form e.g.:
            # 1 => 'AD1',
            # 2 => 'AD3',
            # 3 => 'AD2',
            # to a regular array in correct order:
            # ('AD1', 'AD3', 'AD2')

            my @TmpActivityDialogList
                = map { $NextActivityDialogs->{$_} } sort keys %{$NextActivityDialogs};

            # we have to check if the current user has the needed permissions to view the
            # different activity dialogs, so we loop over every activity dialog and check if there
            # is a permission configured. If there is a permission configured we check this
            # and display/hide the activity dialog link
            my %PermissionRights;
            my @PermissionActivityDialogList;
            ACTIVITYDIALOGPERMISSION:
            for my $CurrentActivityDialogEntityID (@TmpActivityDialogList) {

                my $CurrentActivityDialog = $Self->{ActivityDialogObject}->ActivityDialogGet(
                    ActivityDialogEntityID => $CurrentActivityDialogEntityID,
                    Interface              => 'CustomerInterface',
                );

                # create an interface lookuplist
                my %InterfaceLookup = map { $_ => 1 } @{ $CurrentActivityDialog->{Interface} };

                next ACTIVITYDIALOGPERMISSION if !$InterfaceLookup{CustomerInterface};

                if ( $CurrentActivityDialog->{Permission} ) {

                    # performanceboost/cache
                    if ( !defined $PermissionRights{ $CurrentActivityDialog->{Permission} } ) {
                        $PermissionRights{ $CurrentActivityDialog->{Permission} }
                            = $Self->{TicketObject}->TicketCustomerPermission(
                            Type     => $CurrentActivityDialog->{Permission},
                            TicketID => $Param{TicketID},
                            UserID   => $Self->{UserID},
                            );
                    }

                    next ACTIVITYDIALOGPERMISSION
                        if !$PermissionRights{ $CurrentActivityDialog->{Permission} };
                }

                push @PermissionActivityDialogList, $CurrentActivityDialogEntityID;
            }

            my @PossibleActivityDialogs;
            if (@PermissionActivityDialogList) {
                @PossibleActivityDialogs
                    = $Self->{TicketObject}->TicketAclActivityDialogData(
                    ActivityDialogs => \@PermissionActivityDialogList
                    );
            }

            # reformat the @PossibleActivityDialogs that is of the structure:
            # @PossibleActivityDialogs = ('AD1', 'AD3', 'AD4', 'AD2');
            # to get the same structure as in the %NextActivityDialogs
            # e.g.:
            # 1 => 'AD1',
            # 2 => 'AD3',
            %{$NextActivityDialogs}
                = map { $_ => $PossibleActivityDialogs[ $_ - 1 ] }
                1 .. scalar @PossibleActivityDialogs;

            $Self->{LayoutObject}->Block(
                Name => 'NextActivities',
            );

            for my $NextActivityDialogKey ( sort keys %{$NextActivityDialogs} ) {
                my $ActivityDialogData = $Self->{ActivityDialogObject}->ActivityDialogGet(
                    ActivityDialogEntityID => $NextActivityDialogs->{$NextActivityDialogKey},
                    Interface              => 'CustomerInterface',
                );
                $Self->{LayoutObject}->Block(
                    Name => 'ActivityDialog',
                    Data => {
                        ActivityDialogEntityID => $NextActivityDialogs->{$NextActivityDialogKey},
                        Name                   => $ActivityDialogData->{Name},
                        ProcessEntityID        => $Param{$ProcessEntityIDField},
                        TicketID               => $Param{TicketID},
                    },
                );
            }

            if ( !IsHashRefWithData($NextActivityDialogs) ) {
                $Self->{LayoutObject}->Block(
                    Name => 'NoActivityDialog',
                    Data => {},
                );
            }
        }
    }

    # get the dynamic fields for ticket object
    my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => ['Ticket'],
        FieldFilter => $Self->{DynamicFieldFilter} || {},
    );

    # cycle trough the activated Dynamic Fields for ticket object
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{$DynamicField} ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $Value = $Self->{BackendObject}->ValueGet(
            DynamicFieldConfig => $DynamicFieldConfig,
            ObjectID           => $Param{TicketID},
        );

        next DYNAMICFIELD if !$Value;
        next DYNAMICFIELD if $Value eq "";

        # get print string for this dynamic field
        my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
            DynamicFieldConfig => $DynamicFieldConfig,
            Value              => $Value,
            ValueMaxChars      => 25,
            LayoutObject       => $Self->{LayoutObject},
        );

        my $Label = $DynamicFieldConfig->{Label};

        $Self->{LayoutObject}->Block(
            Name => 'TicketDynamicField',
            Data => {
                Label => $Label,
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );

        # example of dynamic fields order customization
        $Self->{LayoutObject}->Block(
            Name => 'TicketDynamicField_' . $DynamicFieldConfig->{Name},
            Data => {
                Label => $Label,
                Value => $ValueStrg->{Value},
                Title => $ValueStrg->{Title},
            },
        );
    }

    # print option
    if ( $Self->{ConfigObject}->Get('CustomerFrontend::Module')->{CustomerTicketPrint} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Print',
            Data => \%Param,
        );
    }

    # Expand option
    my $ExpandOption = ( $Self->{ZoomExpand}    ? 'One' : 'All' );
    my $ExpandPlural = ( $ExpandOption eq 'All' ? 's'   : '' );
    $Self->{LayoutObject}->Block(
        Name => 'Expand',
        Data => {
            ZoomExpand   => !$Self->{ZoomExpand},
            ExpandOption => $ExpandOption,
            ExpandText   => lc($ExpandOption),
            ExpandPlural => $ExpandPlural,
            %Param,
        },
    );

    my $ShownArticles;
    my $LastSenderType = '';
    for my $ArticleTmp (@ArticleBox) {
        my %Article = %$ArticleTmp;

        # check if article should be expanded (visible)
        if ( $SelectedArticleID eq $Article{ArticleID} || $Self->{ZoomExpand} ) {
            $Article{Class} = 'Visible';
            $ShownArticles++;
        }

        # do some html quoting
        $Article{Age} = $Self->{LayoutObject}->CustomerAge(
            Age   => $Article{AgeTimeUnix},
            Space => ' ',
        );

        $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
            TicketNumber => $Article{TicketNumber},
            Subject      => $Article{Subject} || '',
            Size         => 150,
        );

        $LastSenderType = $Article{SenderType};

        $Self->{LayoutObject}->Block(
            Name => 'Article',
            Data => \%Article,
        );

        # show the correct title: "expand article..." or the article's subject
        if ( $SelectedArticleID eq $Article{ArticleID} || $Self->{ZoomExpand} ) {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleExpanded',
                Data => \%Article,
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleContracted',
                Data => \%Article,
            );
        }

        # do some strips && quoting
        for my $Key (qw(From To Cc)) {
            next if !$Article{$Key};
            $Self->{LayoutObject}->Block(
                Name => 'ArticleRow',
                Data => {
                    Key      => $Key,
                    Value    => $Article{$Key},
                    Realname => $Article{ $Key . 'Realname' },
                },
            );
        }

        # get the dynamic fields for article object
        my $DynamicField = $Self->{DynamicFieldObject}->DynamicFieldListGet(
            Valid       => 1,
            ObjectType  => ['Article'],
            FieldFilter => $Self->{DynamicFieldFilter} || {},
        );

        # cycle trough the activated Dynamic Fields for ticket object
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{$DynamicField} ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            my $Value = $Self->{BackendObject}->ValueGet(
                DynamicFieldConfig => $DynamicFieldConfig,
                ObjectID           => $Article{ArticleID},
            );

            next DYNAMICFIELD if !$Value;
            next DYNAMICFIELD if $Value eq "";

            # get print string for this dynamic field
            my $ValueStrg = $Self->{BackendObject}->DisplayValueRender(
                DynamicFieldConfig => $DynamicFieldConfig,
                Value              => $Value,
                ValueMaxChars      => 160,
                LayoutObject       => $Self->{LayoutObject},
            );

            my $Label = $DynamicFieldConfig->{Label};

            $Self->{LayoutObject}->Block(
                Name => 'ArticleDynamicField',
                Data => {
                    Label => $Label,
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );

            # example of dynamic fields order customization
            $Self->{LayoutObject}->Block(
                Name => 'ArticleDynamicField_' . $DynamicFieldConfig->{Name},
                Data => {
                    Label => $Label,
                    Value => $ValueStrg->{Value},
                    Title => $ValueStrg->{Title},
                },
            );
        }

        # check if just a only html email
        if ( my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType( %Param, %Article ) ) {
            $Param{BodyNote} = $MimeTypeText;
            $Param{Body}     = '';
        }
        else {

            # html quoting
            $Article{Body} = $Self->{LayoutObject}->Ascii2Html(
                NewLine        => $Self->{ConfigObject}->Get('DefaultViewNewLine'),
                Text           => $Article{Body},
                VMax           => $Self->{ConfigObject}->Get('DefaultViewLines') || 5000,
                HTMLResultMode => 1,
                LinkFeature    => 1,
            );

            # do charset check
            if ( my $CharsetText = $Self->{LayoutObject}->CheckCharset( %Param, %Article ) ) {
                $Param{BodyNote} = $CharsetText;
            }
        }

        # in case show plain article body (if no html body as attachment exists of if rich
        # text is not enabled)
        my $RichText = $Self->{LayoutObject}->{BrowserRichText};
        if ( $RichText && $Article{AttachmentIDOfHTMLBody} ) {
            if ( $SelectedArticleID eq $Article{ArticleID} || $Self->{ZoomExpand} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'BodyHTMLLoad',
                    Data => {
                        %Param,
                        %Article,
                    },
                );
            }
            else {
                my $SessionInformation;

                # Append session information to URL if needed
                if ( !$Self->{LayoutObject}->{SessionIDCookie} ) {
                    $SessionInformation = $Self->{LayoutObject}->{SessionName} . '='
                        . $Self->{LayoutObject}->{SessionID};
                }

                $Self->{LayoutObject}->Block(
                    Name => 'BodyHTMLPlaceholder',
                    Data => {
                        %Param,
                        %Article,
                        SessionInformation => $SessionInformation,
                    },
                );
            }
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'BodyPlain',
                Data => {
                    %Param,
                    %Article,
                },
            );
        }

        # add attachment icon
        if ( $Article{Atms} && %{ $Article{Atms} } ) {

            # download type
            my $Type = $Self->{ConfigObject}->Get('AttachmentDownloadType') || 'attachment';

            # if attachment will be forced to download, don't open a new download window!
            my $Target = '';
            if ( $Type =~ /inline/i ) {
                $Target = 'target="attachment" ';
            }
            my %AtmIndex = %{ $Article{Atms} };
            $Self->{LayoutObject}->Block(
                Name => 'ArticleAttachment',
                Data => { Key => 'Attachment', },
            );
            for my $FileID ( sort keys %AtmIndex ) {
                my %File = %{ $AtmIndex{$FileID} };
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleAttachmentRow',
                    Data => \%File,
                );

                $Self->{LayoutObject}->Block(
                    Name => 'ArticleAttachmentRowLink',
                    Data => {
                        %File,
                        Action => 'Download',
                        Link =>
                            "\$Env{\"Baselink\"}Action=CustomerTicketAttachment;ArticleID=$Article{ArticleID};FileID=$FileID",
                        Image  => 'disk-s.png',
                        Target => $Target,
                    },
                );
            }
        }
    }

    # if there are no viewable articles show NoArticles message
    if ( !@ArticleBox ) {
        $Self->{LayoutObject}->Block(
            Name => 'NoArticles',
        );
    }

    my %Article;
    if (@ArticleBox) {

        my $ArticleOB = {};
        if ($LastCustomerArticle) {
            $ArticleOB = $ArticleBox[$LastCustomerArticle];
        }

        %Article = %$ArticleOB;

        # if no customer articles found use ticket values
        if ( !IsHashRefWithData( \%Article ) ) {
            %Article = %Param;
            if ( !$Article{StateID} ) {
                $Article{StateID} = $Param{TicketStateID}
            }
        }

        my $ArticleArray = 0;
        for my $ArticleTmp (@ArticleBox) {
            my %ArticleTmp1 = %$ArticleTmp;
            if ( $ArticleID eq $ArticleTmp1{ArticleID} ) {
                %Article = %ArticleTmp1;
            }
        }

        # just body if html email
        if ( $Param{ShowHTMLeMail} ) {

            # generate output
            return $Self->{LayoutObject}->Attachment(
                Filename => $Self->{ConfigObject}->Get('Ticket::Hook')
                    . "-$Article{TicketNumber}-$Article{TicketID}-$Article{ArticleID}",
                Type        => 'inline',
                ContentType => "$Article{MimeType}; charset=$Article{Charset}",
                Content     => $Article{Body},
            );
        }
    }

    # fallback to ticket info if there is no article
    if ( !IsHashRefWithData( \%Article ) ) {
        %Article = %Param;
        if ( !$Article{StateID} ) {
            $Article{StateID} = $Param{TicketStateID}
        }
    }

    # check follow up permissions
    my $FollowUpPossible
        = $Self->{QueueObject}->GetFollowUpOption( QueueID => $Article{QueueID}, );
    my %State = $Self->{StateObject}->StateGet(
        ID => $Article{StateID},
    );
    if (
        $Self->{TicketObject}->TicketCustomerPermission(
            Type     => 'update',
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID}
        )
        && (
            ( $FollowUpPossible !~ /(new ticket|reject)/i && $State{TypeName} =~ /^close/i )
            || $State{TypeName} !~ /^close/i
        )
        )
    {

        my $DynamicFieldNames = $Self->_GetFieldsToUpdate(
            OnlyDynamicFields => 1,
        );

        # create a string with the quoted dynamic field names separated by commas
        if ( IsArrayRefWithData($DynamicFieldNames) ) {
            for my $Field ( @{$DynamicFieldNames} ) {
                $Param{DynamicFieldNamesStrg} .= ", '" . $Field . "'";
            }
        }

        # check subject
        if ( !$Param{Subject} ) {
            $Param{Subject} = "Re: $Param{Title}";
        }
        $Self->{LayoutObject}->Block(
            Name => 'FollowUp',
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

        # build next states string
        if ( $Self->{Config}->{State} ) {
            my %NextStates = $Self->{TicketObject}->TicketStateList(
                TicketID       => $Self->{TicketID},
                Action         => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
            my %StateSelected;
            if ( $Param{StateID} ) {
                $StateSelected{SelectedID} = $Param{StateID};
            }
            else {
                $StateSelected{SelectedValue} = $Self->{Config}->{StateDefault};
            }
            $Param{NextStatesStrg} = $Self->{LayoutObject}->BuildSelection(
                Data => \%NextStates,
                Name => 'StateID',
                %StateSelected,
            );
            $Self->{LayoutObject}->Block(
                Name => 'FollowUpState',
                Data => \%Param,
            );
        }

        # get priority
        if ( $Self->{Config}->{Priority} ) {
            my %Priorities = $Self->{TicketObject}->TicketPriorityList(
                CustomerUserID => $Self->{UserID},
                Action         => $Self->{Action},
            );
            my %PrioritySelected;
            if ( $Param{PriorityID} ) {
                $PrioritySelected{SelectedID} = $Param{PriorityID};
            }
            else {
                $PrioritySelected{SelectedValue} = $Self->{Config}->{PriorityDefault}
                    || '3 normal';
            }
            $Param{PriorityStrg} = $Self->{LayoutObject}->BuildSelection(
                Data => \%Priorities,
                Name => 'PriorityID',
                %PrioritySelected,
            );
            $Self->{LayoutObject}->Block(
                Name => 'FollowUpPriority',
                Data => \%Param,
            );
        }

        # Dynamic fields
        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{FollowUpDynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

            # skip fields that HTML could not be retrieved
            next DYNAMICFIELD if !IsHashRefWithData(
                $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} }
            );

            # get the html strings form $Param
            my $DynamicFieldHTML = $Param{DynamicFieldHTML}->{ $DynamicFieldConfig->{Name} };

            $Self->{LayoutObject}->Block(
                Name => 'FollowUpDynamicField',
                Data => {
                    Name  => $DynamicFieldConfig->{Name},
                    Label => $DynamicFieldHTML->{Label},
                    Field => $DynamicFieldHTML->{Field},
                },
            );

            # example of dynamic fields order customization
            $Self->{LayoutObject}->Block(
                Name => 'FollowUpDynamicField_' . $DynamicFieldConfig->{Name},
                Data => {
                    Name  => $DynamicFieldConfig->{Name},
                    Label => $DynamicFieldHTML->{Label},
                    Field => $DynamicFieldHTML->{Field},
                },
            );
        }

        # show attachments
        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );
        for my $Attachment (@Attachments) {
            next if $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText};
            $Self->{LayoutObject}->Block(
                Name => 'FollowUpAttachment',
                Data => $Attachment,
            );
        }
    }

    # select the output template
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketZoom',
        Data         => {
            %Article,
            %Param,
        },
    );
}

sub _GetFieldsToUpdate {
    my ( $Self, %Param ) = @_;

    my @UpdatableFields;

    # set the fields that can be updatable via AJAXUpdate
    if ( !$Param{OnlyDynamicFields} ) {
        @UpdatableFields
            = qw( ServiceID SLAID PriorityID StateID );
    }

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{FollowUpDynamicField} } ) {
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
