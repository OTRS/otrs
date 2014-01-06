# --
# Kernel/Modules/CustomerTicketZoom.pm - to get a closer view
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: CustomerTicketZoom.pm,v 1.88 2012-01-27 12:29:12 mb Exp $
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
use Kernel::System::VariableCheck qw(:all);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.88 $) [1];

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

    $Self->{AgentUserObject} = Kernel::System::User->new(%Param);

    # needed objects
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
        DynamicFields => 0,
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

    # check follow up
    if ( $Self->{Subaction} eq 'Store' ) {

        # challenge token check for write action
        $Self->{LayoutObject}->ChallengeTokenCheck( Type => 'Customer' );

        my $NextScreen = $Self->{NextScreen} || $Self->{Config}->{NextScreenAfterFollowUp};
        my %Error;

        # rewrap body if rich text is used
        if ( $GetParam{Body} && $Self->{LayoutObject}->{BrowserRichText} ) {
            $GetParam{Body}
                =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
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

        # rewrap body if rich text is used
        if ( $GetParam{Body} && $Self->{LayoutObject}->{BrowserRichText} ) {
            $GetParam{Body}
                =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
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
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }

        # unlock ticket if agent is on vacation
        my $LockAction;
        if ( $Ticket{OwnerID} ) {
            my %User = $Self->{AgentUserObject}->GetUserData(
                UserID => $Ticket{OwnerID},
            );
            if ( %User && $User{OutOfOffice} && $User{OutOfOfficeMessage} ) {
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

        if ( $Self->{Config}->{State} ) {

            # set state
            my %NextStateData = $Self->{StateObject}->StateGet( ID => $GetParam{StateID} );
            my $NextState = $NextStateData{Name}
                || $Self->{Config}->{StateDefault}
                || 'open';
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
        %GetParam,
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
    my $SelectedArticleID = $Self->{ParamObject}->GetParam( Param => 'ArticleID' );
    my $BaseLink          = $Self->{LayoutObject}->{Baselink} . "TicketID=$Self->{TicketID}&";
    my @ArticleBox        = @{ $Param{ArticleBox} };

    # prepare errors!
    if ( $Param{Errors} ) {
        for my $KeyError ( keys %{ $Param{Errors} } ) {
            $Param{$KeyError}
                = $Self->{LayoutObject}->Ascii2Html( Text => $Param{Errors}->{$KeyError} );
        }
    }

    my $ArticleID           = '';
    my $LastCustomerArticle = 0;
    if (@ArticleBox) {

        # get last customer article
        my $CounterArray = 0;
        my $LastCustomerArticleID;
        my $LastCustomerArticle = $#ArticleBox;

        my $ArticleID = '';
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
        $Self->{LayoutObject}->Block(
            Name => 'Owner',
            Data => \%Param,
        );
    }

    # ticket responsible
    if (
        $Self->{ConfigObject}->Get('Ticket::Responsible')
        &&
        $Self->{Config}->{AttributesView}->{Responsible}
        )
    {
        $Self->{LayoutObject}->Block(
            Name => 'Responsible',
            Data => \%Param,
        );
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

    my $LastSenderType = '';
    for my $ArticleTmp (@ArticleBox) {
        my %Article = %$ArticleTmp;

        # check if article should be expanded (visible)
        if ( $SelectedArticleID eq $Article{ArticleID} ) {
            $Article{Class} = 'Visible';
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
        if ( $SelectedArticleID eq $Article{ArticleID} ) {
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
            if ( $SelectedArticleID eq $Article{ArticleID} ) {
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
                            "\$Env{\"CGIHandle\"}/\$QData{\"Filename\"}?Action=CustomerTicketAttachment;ArticleID=$Article{ArticleID};FileID=$FileID",
                        Image  => 'disk-s.png',
                        Target => $Target,
                    },
                );
            }
        }
    }

    # if there are no viewable articles show NoArticles message
    my %Article;
    if ( !@ArticleBox ) {
        $Self->{LayoutObject}->Block(
            Name => 'NoArticles',
        );
    }
    else {
        my $ArticleOB = $ArticleBox[$LastCustomerArticle];
        %Article = %$ArticleOB;
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

    # check follow up permissions
    my $FollowUpPossible = $Self->{QueueObject}->GetFollowUpOption( QueueID => $Article{QueueID}, );
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
                $PrioritySelected{SelectedValue} = $Self->{Config}->{PriorityDefault} || '3 normal';
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

1;
