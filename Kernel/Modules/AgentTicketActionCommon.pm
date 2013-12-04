# --
# Kernel/Modules/AgentTicketActionCommon.pm - common file for several modules
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketActionCommon;

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

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam( Param => 'FormID' );

    # get inform user list
    my @InformUserID = $Self->{ParamObject}->GetArray( Param => 'InformUserID' );
    $Self->{InformUserID} = \@InformUserID;

    # get involved user list
    my @InvolvedUserID = $Self->{ParamObject}->GetArray( Param => 'InvolvedUserID' );
    $Self->{InvolvedUserID} = \@InvolvedUserID;

    # create form id
    if ( !$Self->{FormID} ) {
        $Self->{FormID} = $Self->{UploadCacheObject}->FormIDCreate();
    }

    # get config of frontend module
    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # define the dynamic fields to show based on the object type
    my $ObjectType = ['Ticket'];

    # only screens that add notes can modify Article dynamic fields
    if ( $Self->{Config}->{Note} ) {
        $ObjectType = [ 'Ticket', 'Article' ];
    }

    # get the dynamic fields for this screen
    $Self->{DynamicField} = $Self->{DynamicFieldObject}->DynamicFieldListGet(
        Valid       => 1,
        ObjectType  => $ObjectType,
        FieldFilter => $Self->{Config}->{DynamicField} || {},
    );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Self->{TicketID} ) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No TicketID is given!',
            Comment => 'Please contact the admin.',
        );
    }

    # check permissions
    my $Access = $Self->{TicketObject}->TicketPermission(
        Type     => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID   => $Self->{UserID}
    );

    # error screen, don't show ticket
    if ( !$Access ) {
        return $Self->{LayoutObject}->NoPermission(
            Message    => "You need $Self->{Config}->{Permission} permissions!",
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

    # check if ACL restrictions exist
    if ( IsHashRefWithData( \%AclAction ) ) {

        # show error screen if ACL prohibits this action
        if ( defined $AclAction{ $Self->{Action} } && $AclAction{ $Self->{Action} } eq '0' ) {
            return $Self->{LayoutObject}->NoPermission( WithHeader => 'yes' );
        }
    }

    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $Self->{TicketID},
        DynamicFields => 1,
    );
    $Self->{LayoutObject}->Block(
        Name => 'Properties',
        Data => {
            FormID => $Self->{FormID},
            %Ticket,
            %Param,
        },
    );

    # show right header
    $Self->{LayoutObject}->Block(
        Name => 'Header' . $Self->{Action},
    );

    # get lock state
    if ( $Self->{Config}->{RequiredLock} ) {
        if ( !$Self->{TicketObject}->TicketLockGet( TicketID => $Self->{TicketID} ) ) {
            $Self->{TicketObject}->TicketLockSet(
                TicketID => $Self->{TicketID},
                Lock     => 'lock',
                UserID   => $Self->{UserID}
            );
            my $Success = $Self->{TicketObject}->TicketOwnerSet(
                TicketID  => $Self->{TicketID},
                UserID    => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );

            # show lock state
            if ($Success) {
                $Self->{LayoutObject}->Block(
                    Name => 'PropertiesLock',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
        }
        else {
            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID  => $Self->{UserID},
            );
            if ( !$AccessOk ) {
                my $Output = $Self->{LayoutObject}->Header(
                    Type      => 'Small',
                    Value     => $Ticket{Number},
                    BodyClass => 'Popup',
                );
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => $Self->{LayoutObject}->{LanguageObject}
                        ->Get('Sorry, you need to be the ticket owner to perform this action.'),
                    Comment => $Self->{LayoutObject}->{LanguageObject}
                        ->Get('Please change the owner first.'),
                );
                $Output .= $Self->{LayoutObject}->Footer(
                    Type => 'Small',
                );
                return $Output;
            }

            # show back link
            $Self->{LayoutObject}->Block(
                Name => 'TicketBack',
                Data => {
                    %Param,
                    TicketID => $Self->{TicketID},
                },
            );
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'TicketBack',
            Data => {
                %Param,
                %Ticket,
            },
        );
    }

    # get params
    my %GetParam;
    for my $Key (
        qw(
        NewStateID NewPriorityID TimeUnits ArticleTypeID Title Body Subject NewQueueID
        Year Month Day Hour Minute NewOwnerID NewOwnerType OldOwnerID NewResponsibleID
        TypeID ServiceID SLAID Expand
        )
        )
    {
        $GetParam{$Key} = $Self->{ParamObject}->GetParam( Param => $Key );
    }

    # get dynamic field values form http request
    my %DynamicFieldValues;

    # cycle trough the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        # extract the dynamic field value form the web request
        $DynamicFieldValues{ $DynamicFieldConfig->{Name} }
            = $Self->{BackendObject}->EditFieldValueGet(
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

    if ( $Self->{Subaction} eq 'Store' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck();

        # store action
        my %Error;

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

        # get all attachments meta data
        my @Attachments = $Self->{UploadCacheObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );

        # check pending time
        if ( $GetParam{NewStateID} ) {
            my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $GetParam{NewStateID},
            );

            if ( !$IsUpload ) {

                # check state type
                if ( $StateData{TypeName} =~ /^pending/i ) {

                    # check needed stuff
                    for my $Needed (qw(Year Month Day Hour Minute)) {
                        if ( !defined $GetParam{$Needed} ) {
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
        }

        if ( !$IsUpload ) {
            if ( $Self->{Config}->{Note} && $Self->{Config}->{NoteMandatory} ) {

                # check subject
                if ( !$GetParam{Subject} ) {
                    $Error{'SubjectInvalid'} = 'ServerError';
                }

                # check body
                if ( !$GetParam{Body} ) {
                    $Error{'BodyInvalid'} = 'ServerError';
                }
            }

            # check owner
            if ( $Self->{Config}->{Owner} && $Self->{Config}->{OwnerMandatory} ) {
                if ( $GetParam{NewOwnerType} eq 'New' && !$GetParam{NewOwnerID} ) {
                    $Error{'NewOwnerInvalid'} = 'ServerError';
                }
                elsif ( $GetParam{NewOwnerType} eq 'Old' && !$GetParam{OldOwnerID} ) {
                    $Error{'OldOwnerInvalid'} = 'ServerError';
                }
            }

            # check title
            if ( $Self->{Config}->{Title} && !$GetParam{Title} ) {
                $Error{'TitleInvalid'} = 'ServerError';
            }

            # check type
            if (
                ( $Self->{ConfigObject}->Get('Ticket::Type') )
                &&
                ( $Self->{Config}->{TicketType} ) &&
                ( !$GetParam{TypeID} )
                )
            {
                $Error{'TypeIDInvalid'} = ' ServerError';
            }

            # check service
            if (
                $Self->{ConfigObject}->Get('Ticket::Service')
                && $Self->{Config}->{Service}
                && $GetParam{SLAID}
                && !$GetParam{ServiceID}
                )
            {
                $Error{'ServiceInvalid'} = ' ServerError';
            }

            # check mandatory service
            if (
                $Self->{ConfigObject}->Get('Ticket::Service')
                && $Self->{Config}->{Service}
                && $Self->{Config}->{ServiceMandatory}
                && !$GetParam{ServiceID}
                )
            {
                $Error{'ServiceInvalid'} = ' ServerError';
            }

            # check mandatory sla
            if (
                $Self->{ConfigObject}->Get('Ticket::Service')
                && $Self->{Config}->{Service}
                && $Self->{Config}->{SLAMandatory}
                && !$GetParam{SLAID}
                )
            {
                $Error{'SLAInvalid'} = ' ServerError';
            }

            # check time units, but only if the current screen has a note
            #   (accounted time can only be stored if and article is generated)
            if (
                $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
                && $Self->{Config}->{Note}
                && $GetParam{TimeUnits} eq ''
                )
            {
                $Error{'TimeUnitsInvalid'} = ' ServerError';
            }
        }

        # check expand
        if ( $GetParam{Expand} ) {
            %Error = ();
            $Error{Expand} = 1;
        }

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

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

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $Self->{TicketObject}->TicketAcl(
                        %GetParam,
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
                            = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                    }
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

        # check errors
        if (%Error) {

            my $Output = $Self->{LayoutObject}->Header(
                Type      => 'Small',
                Value     => $Ticket{TicketNumber},
                BodyClass => 'Popup',
            );
            $Output .= $Self->_Mask(
                Attachments       => \@Attachments,
                TimeUnitsRequired => (
                    $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
                    ? 'Validate_Required'
                    : ''
                ),
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

        # set new title
        if ( $Self->{Config}->{Title} ) {
            if ( defined $GetParam{Title} ) {
                $Self->{TicketObject}->TicketTitleUpdate(
                    Title    => $GetParam{Title},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set new type
        if ( $Self->{ConfigObject}->Get('Ticket::Type') && $Self->{Config}->{TicketType} ) {
            if ( $GetParam{TypeID} ) {
                $Self->{TicketObject}->TicketTypeSet(
                    TypeID   => $GetParam{TypeID},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set new service
        if ( $Self->{ConfigObject}->Get('Ticket::Service') && $Self->{Config}->{Service} ) {
            if ( defined $GetParam{ServiceID} ) {
                $Self->{TicketObject}->TicketServiceSet(
                    ServiceID      => $GetParam{ServiceID},
                    TicketID       => $Self->{TicketID},
                    CustomerUserID => $Ticket{CustomerUserID},
                    UserID         => $Self->{UserID},
                );
            }
            if ( defined $GetParam{SLAID} ) {
                $Self->{TicketObject}->TicketSLASet(
                    SLAID    => $GetParam{SLAID},
                    TicketID => $Self->{TicketID},
                    UserID   => $Self->{UserID},
                );
            }
        }

        # set new owner
        my @NotifyDone;
        if ( $Self->{Config}->{Owner} ) {
            my $BodyText = $Self->{LayoutObject}->RichText2Ascii(
                String => $GetParam{Body} || '',
            );
            if ( $GetParam{NewOwnerType} eq 'Old' && $GetParam{OldOwnerID} ) {
                $Self->{TicketObject}->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'lock',
                    UserID   => $Self->{UserID},
                );
                my $Success = $Self->{TicketObject}->TicketOwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $GetParam{OldOwnerID},
                    Comment   => $BodyText,
                );

                # remember to not notify owner twice
                if ( $Success && $Success eq 1 ) {
                    push @NotifyDone, $GetParam{OldOwnerID};
                }
            }
            elsif ( $GetParam{NewOwnerID} ) {
                $Self->{TicketObject}->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'lock',
                    UserID   => $Self->{UserID},
                );
                my $Success = $Self->{TicketObject}->TicketOwnerSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $GetParam{NewOwnerID},
                    Comment   => $BodyText,
                );

                # remember to not notify owner twice
                if ( $Success && $Success eq 1 ) {
                    push @NotifyDone, $GetParam{NewOwnerID};
                }
            }
        }

        # set new responsible
        if ( $Self->{ConfigObject}->Get('Ticket::Responsible') && $Self->{Config}->{Responsible} ) {
            if ( $GetParam{NewResponsibleID} ) {
                my $BodyText = $Self->{LayoutObject}->RichText2Ascii(
                    String => $GetParam{Body} || '',
                );
                my $Success = $Self->{TicketObject}->TicketResponsibleSet(
                    TicketID  => $Self->{TicketID},
                    UserID    => $Self->{UserID},
                    NewUserID => $GetParam{NewResponsibleID},
                    Comment   => $BodyText,
                );

                # remember to not notify responsible twice
                if ( $Success && $Success eq 1 ) {
                    push @NotifyDone, $GetParam{NewResponsibleID};
                }
            }
        }

        # move ticket to a new queue, but only if the queue was changed
        if (
            $Self->{Config}->{Queue}
            && $GetParam{NewQueueID}
            && $GetParam{NewQueueID} ne $Ticket{QueueID}
            )
        {

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
                QueueID            => $GetParam{NewQueueID},
                UserID             => $Self->{UserID},
                TicketID           => $Self->{TicketID},
                SendNoNotification => $GetParam{NewUserID},
                Comment            => $BodyAsText,
            );
            if ( !$Move ) {
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }

        # add note
        my $ArticleID = '';
        if ( $Self->{Config}->{Note} && ( $GetParam{Subject} || $GetParam{Body} ) ) {

            if ( !$GetParam{Subject} ) {
                if ( $Self->{Config}->{Subject} ) {
                    my $Subject = $Self->{LayoutObject}->Output(
                        Template => $Self->{Config}->{Subject},
                    );
                    $GetParam{Subject} = $Subject;
                }
                $GetParam{Subject} = $GetParam{Subject}
                    || $Self->{LayoutObject}->{LanguageObject}->Get('No subject');
            }

            # if there is no ArticleTypeID, use the default value
            if ( !defined $GetParam{ArticleTypeID} ) {
                $GetParam{ArticleType} = $Self->{Config}->{ArticleTypeDefault};
            }

            my $MimeType = 'text/plain';
            if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                $MimeType = 'text/html';

                # verify html document
                $GetParam{Body} = $Self->{LayoutObject}->RichTextDocumentComplete(
                    String => $GetParam{Body},
                );
            }

            my $From = "\"$Self->{UserFirstname} $Self->{UserLastname}\" <$Self->{UserEmail}>";
            my @NotifyUserIDs = ( @{ $Self->{InformUserID} }, @{ $Self->{InvolvedUserID} } );
            $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID                        => $Self->{TicketID},
                SenderType                      => 'agent',
                From                            => $From,
                MimeType                        => $MimeType,
                Charset                         => $Self->{LayoutObject}->{UserCharset},
                UserID                          => $Self->{UserID},
                HistoryType                     => $Self->{Config}->{HistoryType},
                HistoryComment                  => $Self->{Config}->{HistoryComment},
                ForceNotificationToUserID       => \@NotifyUserIDs,
                ExcludeMuteNotificationToUserID => \@NotifyDone,
                %GetParam,
            );
            if ( !$ArticleID ) {
                return $Self->{LayoutObject}->ErrorScreen();
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
                    $GetParam{Body} =~ s/(ContentID=)$ContentIDLinkEncode/$1$ContentID/g;

                    # ignore attachment if not linked in body
                    next ATTACHMENT
                        if $GetParam{Body} !~ /(\Q$ContentIDHTMLQuote\E|\Q$ContentID\E)/i;
                }

                # write existing file to backend
                $Self->{TicketObject}->ArticleWriteAttachment(
                    %{$Attachment},
                    ArticleID => $ArticleID,
                    UserID    => $Self->{UserID},
                );
            }

            # remove pre submitted attachments
            $Self->{UploadCacheObject}->FormIDRemove( FormID => $Self->{FormID} );
        }

        # set dynamic fields
        # cycle through the activated Dynamic Fields for this screen
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

            # set unlock on close state
            if ( $StateData{TypeName} =~ /^close/i ) {
                $Self->{TicketObject}->TicketLockSet(
                    TicketID => $Self->{TicketID},
                    Lock     => 'unlock',
                    UserID   => $Self->{UserID},
                );
            }

            # set pending time on pending state
            elsif ( $StateData{TypeName} =~ /^pending/i ) {

                # set pending time
                $Self->{TicketObject}->TicketPendingTimeSet(
                    UserID   => $Self->{UserID},
                    TicketID => $Self->{TicketID},
                    %GetParam,
                );
            }

            # redirect parent window to last screen overview on closed tickets
            if ( $StateData{TypeName} =~ /^close/i ) {
                return $Self->{LayoutObject}->PopupClose(
                    URL => ( $Self->{LastScreenOverview} || 'Action=AgentDashboard' ),
                );
            }
        }

        # load new URL in parent window and close popup
        return $Self->{LayoutObject}->PopupClose(
            URL => "Action=AgentTicketZoom;TicketID=$Self->{TicketID};ArticleID=$ArticleID",
        );
    }
    elsif ( $Self->{Subaction} eq 'AJAXUpdate' ) {
        my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );
        my $CustomerUser = $Ticket{CustomerUserID};

        my $ServiceID;

        # get service value from param if field is visible in the screen
        if ( $Self->{ConfigObject}->Get('Ticket::Service') && $Self->{Config}->{Service} ) {
            $ServiceID = $GetParam{ServiceID} || '';
        }

        # otherwise use ticket service value since it can't be changed
        elsif ( $Self->{ConfigObject}->Get('Ticket::Service') ) {
            $ServiceID = $Ticket{ServiceID} || '';
        }

        my $QueueID = $GetParam{NewQueueID} || $Ticket{QueueID};

        # convert dynamic field values into a structure for ACLs
        my %DynamicFieldACLParameters;
        DYNAMICFIELD:
        for my $DynamicField ( sort keys %DynamicFieldValues ) {
            next DYNAMICFIELD if !$DynamicField;
            next DYNAMICFIELD if !$DynamicFieldValues{$DynamicField};

            $DynamicFieldACLParameters{ 'DynamicField_' . $DynamicField }
                = $DynamicFieldValues{$DynamicField};
        }

        # get list type
        my $TreeView = 0;
        if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
            $TreeView = 1;
        }

        my $Owners = $Self->_GetOwners(
            %GetParam,
            QueueID  => $QueueID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $OldOwners = $Self->_GetOldOwners(
            %GetParam,
            QueueID  => $QueueID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $ResponsibleUsers = $Self->_GetResponsible(
            %GetParam,
            QueueID  => $QueueID,
            AllUsers => $GetParam{OwnerAll},
        );
        my $Priorities = $Self->_GetPriorities(
            %GetParam,
        );
        my $Services = $Self->_GetServices(
            %GetParam,
            CustomerUserID => $CustomerUser,
            QueueID        => $QueueID,
        );

        # reset previous ServiceID to reset SLA-List if no service is selected
        if ( !defined $ServiceID || !$Services->{$ServiceID} ) {
            $ServiceID = '';
        }
        my $SLAs = $Self->_GetSLAs(
            %GetParam,
            CustomerUserID => $CustomerUser,
            QueueID        => $QueueID,
            ServiceID      => $ServiceID,
        );
        my $NextStates = $Self->_GetNextStates(
            %GetParam,
            CustomerUserID => $CustomerUser || '',
            QueueID => $QueueID,
        );

        # update Dynamic Fields Possible Values via AJAX
        my @DynamicFieldAJAX;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);
            next DYNAMICFIELD if $DynamicFieldConfig->{ObjectType} ne 'Ticket';

            my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
                DynamicFieldConfig => $DynamicFieldConfig,
                Behavior           => 'IsACLReducible',
            );
            next DYNAMICFIELD if !$IsACLReducible;

            my $PossibleValues = $Self->{BackendObject}->PossibleValuesGet(
                DynamicFieldConfig => $DynamicFieldConfig,
            );

            # convert possible values key => value to key => key for ACLs using a Hash slice
            my %AclData = %{$PossibleValues};
            @AclData{ keys %AclData } = keys %AclData;

            # set possible values filter from ACLs
            my $ACL = $Self->{TicketObject}->TicketAcl(
                %GetParam,
                Action        => $Self->{Action},
                TicketID      => $Self->{TicketID},
                QueueID       => $QueueID,
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
                    Name         => 'NewOwnerID',
                    Data         => $Owners,
                    SelectedID   => $GetParam{NewOwnerID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'OldOwnerID',
                    Data         => $OldOwners,
                    SelectedID   => $GetParam{OldOwnerID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewResponsibleID',
                    Data         => $ResponsibleUsers,
                    SelectedID   => $GetParam{NewResponsibleID},
                    Translation  => 0,
                    PossibleNone => 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewStateID',
                    Data         => $NextStates,
                    SelectedID   => $GetParam{NewStateID},
                    Translation  => 1,
                    PossibleNone => $Self->{Config}->{StateDefault} ? 0 : 1,
                    Max          => 100,
                },
                {
                    Name         => 'NewPriorityID',
                    Data         => $Priorities,
                    SelectedID   => $GetParam{NewPriorityID},
                    PossibleNone => 0,
                    Translation  => 1,
                    Max          => 100,
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

        # fillup configured default vars
        if ( !defined $GetParam{Body} && $Self->{Config}->{Body} ) {
            $GetParam{Body} = $Self->{LayoutObject}->Output(
                Template => $Self->{Config}->{Body},
            );

            # make sure body is rich text
            if ( $Self->{LayoutObject}->{BrowserRichText} ) {
                $GetParam{Body} = $Self->{LayoutObject}->Ascii2RichText(
                    String => $GetParam{Body},
                );
            }
        }
        if ( !defined $GetParam{Subject} && $Self->{Config}->{Subject} ) {
            $GetParam{Subject} = $Self->{LayoutObject}->Output(
                Template => $Self->{Config}->{Subject},
            );
        }

        # create html strings for all dynamic fields
        my %DynamicFieldHTML;

        # cycle trough the activated Dynamic Fields for this screen
        DYNAMICFIELD:
        for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
            next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

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

                # check if field has PossibleValues property in its configuration
                if ( IsHashRefWithData($PossibleValues) ) {

                    # convert possible values key => value to key => key for ACLs using a Hash slice
                    my %AclData = %{$PossibleValues};
                    @AclData{ keys %AclData } = keys %AclData;

                    # set possible values filter from ACLs
                    my $ACL = $Self->{TicketObject}->TicketAcl(
                        %GetParam,
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
                            = map { $_ => $PossibleValues->{$_} }
                            keys %Filter;
                    }
                }
            }

            # to store dynamic field value from database (or undefined)
            my $Value;

            # only get values for Ticket fields (all screens based on AgentTickeActionCommon
            # generates a new article, then article fields will be always empty at the beginning)
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

        # print form ...
        my $Output = $Self->{LayoutObject}->Header(
            Type      => 'Small',
            Value     => $Ticket{TicketNumber},
            BodyClass => 'Popup',
        );
        $Output .= $Self->_Mask(
            TimeUnitsRequired => (
                $Self->{ConfigObject}->Get('Ticket::Frontend::NeedAccountedTime')
                ? 'Validate_Required'
                : ''
            ),
            %GetParam,
            %Ticket,
            DynamicFieldHTML => \%DynamicFieldHTML,
        );
        $Output .= $Self->{LayoutObject}->Footer(
            Type => 'Small',
        );
        return $Output;
    }
}

sub _Mask {
    my ( $Self, %Param ) = @_;

    # get list type
    my $TreeView = 0;
    if ( $Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree' ) {
        $TreeView = 1;
    }
    my %Ticket = $Self->{TicketObject}->TicketGet( TicketID => $Self->{TicketID} );

    if ( $Self->{Config}->{Title} ) {
        $Self->{LayoutObject}->Block(
            Name => 'Title',
            Data => \%Param,
        );
    }

    my $DynamicFieldNames = $Self->_GetFieldsToUpdate(
        OnlyDynamicFields => 1,
    );

    # create a string with the quoted dynamic field names separated by commas
    if ( IsArrayRefWithData($DynamicFieldNames) ) {
        for my $Field ( @{$DynamicFieldNames} ) {
            $Param{DynamicFieldNamesStrg} .= ", '" . $Field . "'";
        }
    }

    # types
    if ( $Self->{ConfigObject}->Get('Ticket::Type') && $Self->{Config}->{TicketType} ) {
        my %Type = $Self->{TicketObject}->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
        $Param{TypeStrg} = $Self->{LayoutObject}->BuildSelection(
            Class => 'Validate_Required' . ( $Param{Errors}->{TypeIDInvalid} || ' ' ),
            Data  => \%Type,
            Name  => 'TypeID',
            SelectedID   => $Param{TypeID},
            PossibleNone => 1,
            Sort         => 'AlphanumericValue',
            Translation  => 0,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Type',
            Data => {%Param},
        );
    }

    # services
    if ( $Self->{ConfigObject}->Get('Ticket::Service') && $Self->{Config}->{Service} ) {

        my $Services = $Self->_GetServices(
            %Param,
            Action         => $Self->{Action},
            CustomerUserID => $Ticket{CustomerUserID},
            UserID         => $Self->{UserID},
        );

        # reset previous ServiceID to reset SLA-List if no service is selected
        if ( !$Param{ServiceID} || !$Services->{ $Param{ServiceID} } ) {
            $Param{ServiceID} = '';
        }

        if ( $Self->{Config}->{ServiceMandatory} ) {

            $Param{ServiceStrg} = $Self->{LayoutObject}->BuildSelection(
                Data         => $Services,
                Name         => 'ServiceID',
                SelectedID   => $Param{ServiceID},
                Class        => 'Validate_Required ' . ( $Param{ServiceInvalid} || ' ' ),
                PossibleNone => 1,
                TreeView     => $TreeView,
                Sort         => 'TreeView',
                Translation  => 0,
                Max          => 200,
            );

            $Self->{LayoutObject}->Block(
                Name => 'ServiceMandatory',
                Data => {%Param},
            );
        }
        else {

            $Param{ServiceStrg} = $Self->{LayoutObject}->BuildSelection(
                Data         => $Services,
                Name         => 'ServiceID',
                SelectedID   => $Param{ServiceID},
                Class        => $Param{ServiceInvalid} || ' ',
                PossibleNone => 1,
                TreeView     => $TreeView,
                Sort         => 'TreeView',
                Translation  => 0,
                Max          => 200,
            );

            $Self->{LayoutObject}->Block(
                Name => 'Service',
                Data => {%Param},
            );
        }

        my %SLA = $Self->{TicketObject}->TicketSLAList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );

        if ( $Self->{Config}->{SLAMandatory} ) {

            $Param{SLAStrg} = $Self->{LayoutObject}->BuildSelection(
                Data         => \%SLA,
                Name         => 'SLAID',
                SelectedID   => $Param{SLAID},
                Class        => 'Validate_Required ' . ( $Param{SLAInvalid} || ' ' ),
                PossibleNone => 1,
                Sort         => 'AlphanumericValue',
                Translation  => 0,
                Max          => 200,
            );

            $Self->{LayoutObject}->Block(
                Name => 'SLAMandatory',
                Data => {%Param},
            );
        }
        else {

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
                Name => 'SLA',
                Data => {%Param},
            );
        }
    }

    if ( $Self->{Config}->{Queue} ) {

        # fetch all queues
        my %MoveQueues = $Self->{TicketObject}->TicketMoveList(
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
            Action   => $Self->{Action},
            Type     => 'move_into',
        );

        # set move queues
        $Param{QueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Data => { %MoveQueues, '' => '-' },
            Multiple       => 0,
            Size           => 0,
            Class          => 'NewQueueID',
            Name           => 'NewQueueID',
            SelectedID     => $Param{NewQueueID},
            TreeView       => $TreeView,
            CurrentQueueID => $Param{QueueID},
            OnChangeSubmit => 0,
        );

        $Self->{LayoutObject}->Block(
            Name => 'Queue',
            Data => {%Param},
        );
    }

    if ( $Self->{Config}->{Owner} ) {

        # get user of own groups
        my %ShownUsers;
        my %AllGroupsMembers = $Self->{UserObject}->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $Self->{GroupObject}->GroupMemberList(
                GroupID => $GID,
                Type    => 'owner',
                Result  => 'HASH',
                Cached  => 1,
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }

        # get old owner
        my @OldUserInfo = $Self->{TicketObject}->TicketOwnerList( TicketID => $Self->{TicketID} );
        $Param{OwnerStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%ShownUsers,
            SelectedID   => $Param{NewOwnerID},
            Name         => 'NewOwnerID',
            Class        => $Param{NewOwnerInvalid} || ' ',
            Size         => 1,
            PossibleNone => 1,
        );
        my @OldOwners;
        my %SeenOldOwner;
        if (@OldUserInfo) {
            my $Counter = 1;
            for my $User ( reverse @OldUserInfo ) {

                # skip if old owner is already in the list
                next if $SeenOldOwner{ $User->{UserID} };
                $SeenOldOwner{ $User->{UserID} } = 1;
                push @OldOwners, {
                    Key   => $User->{UserID},
                    Value => "$Counter: $User->{UserLastname} "
                        . "$User->{UserFirstname} ($User->{UserLogin})"
                };
                $Counter++;
            }
        }

        my $OldOwnerSelectedID = '';
        if ( $Param{OldOwnerID} ) {
            $OldOwnerSelectedID = $Param{OldOwnerID};
        }
        elsif ( $OldUserInfo[0]->{UserID} ) {
            $OldOwnerSelectedID = $OldUserInfo[0]->{UserID} . '1';
        }

        # build string
        $Param{OldOwnerStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \@OldOwners,
            SelectedID   => $OldOwnerSelectedID,
            Name         => 'OldOwnerID',
            Class        => $Param{OldOwnerInvalid} || ' ',
            PossibleNone => 1,
        );

        if ( $Param{NewOwnerType} && $Param{NewOwnerType} eq 'Old' ) {
            $Param{'NewOwnerType::Old'} = 'checked = "checked"';
        }
        else {
            $Param{'NewOwnerType::New'} = 'checked = "checked"';
        }

        $Self->{LayoutObject}->Block(
            Name => 'Owner',
            Data => \%Param,
        );
    }
    if ( $Self->{ConfigObject}->Get('Ticket::Responsible') && $Self->{Config}->{Responsible} ) {

        # get user of own groups
        my %ShownUsers;
        my %AllGroupsMembers = $Self->{UserObject}->UserList(
            Type  => 'Long',
            Valid => 1,
        );
        if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $Self->{GroupObject}->GroupMemberList(
                GroupID => $GID,
                Type    => 'responsible',
                Result  => 'HASH',
                Cached  => 1,
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
        }

        # get responsible
        $Param{ResponsibleStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%ShownUsers,
            SelectedID   => $Param{NewResponsibleID},
            Name         => 'NewResponsibleID',
            PossibleNone => 1,
            Size         => 1,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Responsible',
            Data => \%Param,
        );
    }
    if ( $Self->{Config}->{State} ) {
        my %State;
        my %StateList = $Self->{TicketObject}->TicketStateList(
            Action   => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID   => $Self->{UserID},
        );
        if ( !$Param{NewStateID} ) {
            if ( $Self->{Config}->{StateDefault} ) {
                $State{SelectedValue} = $Self->{Config}->{StateDefault};
            }
        }
        else {
            $State{SelectedID} = $Param{NewStateID};
        }

        # build next states string
        $Param{StateStrg} = $Self->{LayoutObject}->BuildSelection(
            Data         => \%StateList,
            Name         => 'NewStateID',
            PossibleNone => $Self->{Config}->{StateDefault} ? 0 : 1,
            %State,
        );
        $Self->{LayoutObject}->Block(
            Name => 'State',
            Data => \%Param,
        );

        STATEID:
        for my $StateID ( sort keys %StateList ) {

            next STATEID if !$StateID;

            # get state data
            my %StateData = $Self->{TicketObject}->{StateObject}->StateGet( ID => $StateID );

            next STATEID if $StateData{TypeName} !~ /pending/i;

            $Param{DateString} = $Self->{LayoutObject}->BuildDateSelection(
                %Param,
                Format           => 'DateInputFormatLong',
                YearPeriodPast   => 0,
                YearPeriodFuture => 5,
                DiffTime         => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime')
                    || 0,
                Class => $Param{DateInvalid} || ' ',
                Validate             => 1,
                ValidateDateInFuture => 1,
            );

            $Self->{LayoutObject}->Block(
                Name => 'StatePending',
                Data => \%Param,
            );

            last STATEID;
        }
    }

    # get priority
    if ( $Self->{Config}->{Priority} ) {
        my %Priority;
        my %PriorityList = $Self->{TicketObject}->TicketPriorityList(
            UserID   => $Self->{UserID},
            TicketID => $Self->{TicketID},
        );
        if ( !$Self->{Config}->{PriorityDefault} ) {
            $PriorityList{''} = '-';
        }
        if ( !$Param{NewPriorityID} ) {
            if ( $Self->{Config}->{PriorityDefault} ) {
                $Priority{SelectedValue} = $Self->{Config}->{PriorityDefault};
            }
        }
        else {
            $Priority{SelectedID} = $Param{NewPriorityID};
        }
        $Priority{SelectedID} ||= $Param{PriorityID};
        $Param{PriorityStrg} = $Self->{LayoutObject}->BuildSelection(
            Data => \%PriorityList,
            Name => 'NewPriorityID',
            %Priority,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }

    if ( $Self->{Config}->{Note} ) {

        if ( $Self->{Config}->{NoteMandatory} ) {
            $Param{SubjectRequired} = 'Validate_Required';
            $Param{BodyRequired}    = 'Validate_Required';
        }

        $Self->{LayoutObject}->Block(
            Name => 'Note',
            Data => {%Param},
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

        if ( $Self->{Config}->{NoteMandatory} ) {
            $Self->{LayoutObject}->Block(
                Name => 'SubjectLabelMandatory',
            );
            $Self->{LayoutObject}->Block(
                Name => 'RichTextLabelMandatory',
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'SubjectLabel',
            );
            $Self->{LayoutObject}->Block(
                Name => 'RichTextLabel',
            );
        }

        # agent list
        if ( $Self->{Config}->{InformAgent} ) {
            my %ShownUsers;
            my %AllGroupsMembers = $Self->{UserObject}->UserList(
                Type  => 'Long',
                Valid => 1,
            );
            my $GID = $Self->{QueueObject}->GetQueueGroupID( QueueID => $Ticket{QueueID} );
            my %MemberList = $Self->{GroupObject}->GroupMemberList(
                GroupID => $GID,
                Type    => 'note',
                Result  => 'HASH',
                Cached  => 1,
            );
            for my $UserID ( sort keys %MemberList ) {
                $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
            }
            my $InformAgentSize = $Self->{ConfigObject}->Get('Ticket::Frontend::InformAgentMaxSize')
                || 3;
            $Param{OptionStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => \%ShownUsers,
                SelectedID => $Self->{InformUserID},
                Name       => 'InformUserID',
                Multiple   => 1,
                Size       => $InformAgentSize,
            );
            $Self->{LayoutObject}->Block(
                Name => 'InformAgent',
                Data => \%Param,
            );
        }

        # get involved
        if ( $Self->{Config}->{InvolvedAgent} ) {

            my @UserIDs = $Self->{TicketObject}->TicketInvolvedAgentsList(
                TicketID => $Self->{TicketID},
            );

            my @InvolvedAgents;
            my %SeenInvolvedAgents;
            my $Counter = 1;

            USER:
            for my $User ( reverse @UserIDs ) {

                next USER if $SeenInvolvedAgents{ $User->{UserID} };

                my $Value = "$Counter: $User->{UserFullname}";
                if ( $User->{OutOfOfficeMessage} ) {
                    $Value .= " $User->{OutOfOfficeMessage}";
                }

                push @InvolvedAgents, {
                    Key   => $User->{UserID},
                    Value => $Value,
                };
                $Counter++;
            }

            my $InvolvedAgentSize
                = $Self->{ConfigObject}->Get('Ticket::Frontend::InvolvedAgentMaxSize') || 3;
            $Param{InvolvedAgentStrg} = $Self->{LayoutObject}->BuildSelection(
                Data       => \@InvolvedAgents,
                SelectedID => $Self->{InvolvedUserID},
                Name       => 'InvolvedUserID',
                Multiple   => 1,
                Size       => $InvolvedAgentSize,
            );
            $Self->{LayoutObject}->Block(
                Name => 'InvolvedAgent',
                Data => \%Param,
            );
        }

        # show spell check
        if ( $Self->{LayoutObject}->{BrowserSpellChecker} ) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketOptions',
            );
            $Self->{LayoutObject}->Block(
                Name => 'SpellCheck',
            );
        }

        # show attachments
        ATTACHMENT:
        for my $Attachment ( @{ $Param{Attachments} } ) {

            next ATTACHMENT if $Attachment->{ContentID} && $Self->{LayoutObject}->{BrowserRichText};

            $Self->{LayoutObject}->Block(
                Name => 'Attachment',
                Data => $Attachment,
            );
        }

        # build ArticleTypeID string
        my %ArticleType;
        if ( !$Param{ArticleTypeID} ) {
            $ArticleType{SelectedValue} = $Self->{Config}->{ArticleTypeDefault};
        }
        else {
            $ArticleType{SelectedID} = $Param{ArticleTypeID};
        }

        # get possible notes
        if ( $Self->{Config}->{ArticleTypes} ) {
            my %DefaultNoteTypes = %{ $Self->{Config}->{ArticleTypes} };
            my %NoteTypes = $Self->{TicketObject}->ArticleTypeList( Result => 'HASH' );
            for my $KeyNoteType ( sort keys %NoteTypes ) {
                if ( !$DefaultNoteTypes{ $NoteTypes{$KeyNoteType} } ) {
                    delete $NoteTypes{$KeyNoteType};
                }
            }

            $Param{ArticleTypeStrg} = $Self->{LayoutObject}->BuildSelection(
                Data => \%NoteTypes,
                Name => 'ArticleTypeID',
                %ArticleType,
            );
            $Self->{LayoutObject}->Block(
                Name => 'ArticleType',
                Data => \%Param,
            );
        }

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
                Data => \%Param,
            );
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

    # get output back
    return $Self->{LayoutObject}->Output( TemplateFile => $Self->{Action}, Data => \%Param );
}

sub _GetNextStates {
    my ( $Self, %Param ) = @_;

    my %NextStates = $Self->{TicketObject}->TicketStateList(
        TicketID => $Self->{TicketID},
        Action   => $Self->{Action},
        UserID   => $Self->{UserID},
        %Param,
    );

    return \%NextStates;
}

sub _GetResponsible {
    my ( $Self, %Param ) = @_;
    my %ShownUsers;
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # show all users
    if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show only users with responsible or rw pemissions in the queue
    elsif ( $Param{QueueID} && !$Param{AllUsers} ) {
        my $GID = $Self->{QueueObject}->GetQueueGroupID(
            QueueID => $Param{NewQueueID} || $Param{QueueID}
        );
        my %MemberList = $Self->{GroupObject}->GroupMemberList(
            GroupID => $GID,
            Type    => 'responsible',
            Result  => 'HASH',
            Cached  => 1,
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
        }
    }

    # workflow
    my $ACL = $Self->{TicketObject}->TicketAcl(
        %Param,
        ReturnType    => 'Ticket',
        ReturnSubType => 'Responsible',
        Data          => \%ShownUsers,
        UserID        => $Self->{UserID},
    );

    return { $Self->{TicketObject}->TicketAclData() } if $ACL;

    return \%ShownUsers;
}

sub _GetOwners {
    my ( $Self, %Param ) = @_;
    my %ShownUsers;
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type  => 'Long',
        Valid => 1,
    );

    # show all users
    if ( $Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone') ) {
        %ShownUsers = %AllGroupsMembers;
    }

    # show only users with owner or rw pemissions in the queue
    elsif ( $Param{QueueID} && !$Param{AllUsers} ) {
        my $GID = $Self->{QueueObject}->GetQueueGroupID(
            QueueID => $Param{NewQueueID} || $Param{QueueID}
        );
        my %MemberList = $Self->{GroupObject}->GroupMemberList(
            GroupID => $GID,
            Type    => 'owner',
            Result  => 'HASH',
            Cached  => 1,
        );
        for my $UserID ( sort keys %MemberList ) {
            $ShownUsers{$UserID} = $AllGroupsMembers{$UserID};
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
        USER:
        for my $User ( reverse @OldUserInfo ) {

            next USER if $UserHash{ $User->{UserID} };

            $UserHash{ $User->{UserID} }
                = "$Counter: $User->{UserLastname} $User->{UserFirstname} ($User->{UserLogin})";
        }
        continue {
            $Counter++;
        }
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

sub _GetServices {
    my ( $Self, %Param ) = @_;

    # get service
    my %Service;

    # get options for default services for unknown customers
    my $DefaultServiceUnknownCustomer
        = $Self->{ConfigObject}->Get('Ticket::Service::Default::UnknownCustomer');

    # check if no CustomerUserID is selected
    # if $DefaultServiceUnknownCustomer = 0 leave CustomerUserID empty, it will not get any services
    # if $DefaultServiceUnknownCustomer = 1 set CustomerUserID to get default services
    if ( !$Param{CustomerUserID} && $DefaultServiceUnknownCustomer ) {
        $Param{CustomerUserID} = '<DEFAULT>';
    }

    # get service list
    if ( $Param{CustomerUserID} ) {
        %Service = $Self->{TicketObject}->TicketServiceList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Service;
}

sub _GetSLAs {
    my ( $Self, %Param ) = @_;

    my %SLA;
    if ( $Param{ServiceID} ) {
        %SLA = $Self->{TicketObject}->TicketSLAList(
            %Param,
            Action => $Self->{Action},
        );
    }
    return \%SLA;
}

sub _GetPriorities {
    my ( $Self, %Param ) = @_;

    my %Priorities = $Self->{TicketObject}->TicketPriorityList(
        %Param,
        Action   => $Self->{Action},
        UserID   => $Self->{UserID},
        TicketID => $Self->{TicketID},
    );
    if ( !$Self->{Config}->{PriorityDefault} ) {
        $Priorities{''} = '-';
    }
    return \%Priorities;
}

sub _GetFieldsToUpdate {
    my ( $Self, %Param ) = @_;

    my @UpdatableFields;

    # set the fields that can be updateable via AJAXUpdate
    if ( !$Param{OnlyDynamicFields} ) {
        @UpdatableFields
            = qw(
            TypeID ServiceID SLAID NewOwnerID OldOwnerID NewResponsibleID NewStateID
            NewPriorityID
        );
    }

    # cycle through the activated Dynamic Fields for this screen
    DYNAMICFIELD:
    for my $DynamicFieldConfig ( @{ $Self->{DynamicField} } ) {
        next DYNAMICFIELD if !IsHashRefWithData($DynamicFieldConfig);

        my $IsACLReducible = $Self->{BackendObject}->HasBehavior(
            DynamicFieldConfig => $DynamicFieldConfig,
            Behavior           => 'IsACLReducible',
        );
        next DYNAMICFIELD if !$IsACLReducible;

        push @UpdatableFields, 'DynamicField_' . $DynamicFieldConfig->{Name};
    }

    return \@UpdatableFields;
}

1;
