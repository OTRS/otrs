# --
# Kernel/Modules/CustomerTicketZoom.pm - to get a closer view
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: CustomerTicketZoom.pm,v 1.7 2006-10-05 13:04:46 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerTicketZoom;

use strict;
use Kernel::System::Web::UploadCache;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject
        ConfigObject UserObject SessionObject
    )) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    # needed objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);

    # get article id
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID');

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam(Param => 'FormID');
    # create form id
    if (!$Self->{FormID}) {
        $Self->{FormID} = $Self->{UploadCachObject}->FormIDCreate();
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my %GetParam = ();
    # check needed stuff
    if (!$Self->{TicketID}) {
        my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError(Message => 'Need TicketID!');
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    # check permissions
    if (!$Self->{TicketObject}->CustomerPermission(
        Type => 'ro',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->CustomerNoPermission(WithHeader => 'yes');
    }
    # store last screen
    if ($Self->{Subaction} ne 'ShowHTMLeMail') {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenView',
            Value => $Self->{RequestedURL},
        );
    }
    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    # check follow up
    if ($Self->{Subaction} eq 'Store') {
        my $NextScreen = $Self->{NextScreen} || $Self->{Config}->{NextScreenAfterFollowUp};
        my %Error = ();
        # get params
        foreach (qw(
            Subject Body StateID PriorityID
            AttachmentUpload
            AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
            AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
            AttachmentDelete9 AttachmentDelete10
        )) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        # rewrap body if exists
        if ($GetParam{Body}) {
            $GetParam{Body} =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
        }
        # get follow up option (possible or not)
        my $FollowUpPossible = $Self->{QueueObject}->GetFollowUpOption(
            QueueID => $Ticket{QueueID},
        );
        # get lock option (should be the ticket locked - if closed - after the follow up)
        my $Lock = $Self->{QueueObject}->GetFollowUpLockOption(
            QueueID => $Ticket{QueueID},
        );
        # get ticket state details
        my %State = $Self->{StateObject}->StateGet(
            ID => $Ticket{StateID},
            Cache => 1,
        );
        if ($FollowUpPossible =~ /(new ticket|reject)/i && $State{TypeName} =~ /^close/i) {
            my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
            $Output .= $Self->{LayoutObject}->CustomerWarning(
                Message => 'Can\'t reopen ticket, not possible in this queue!',
                Comment => 'Create a new ticket!',
            );
            $Output .= $Self->{LayoutObject}->CustomerFooter();
            return $Output;
        }
        # rewrap body if exists
        if ($GetParam{Body}) {
            $GetParam{Body} =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
        }
        # attachment delete
        foreach (1..10) {
            if ($GetParam{"AttachmentDelete$_"}) {
                $Error{AttachmentDelete} = 1;
                $Self->{UploadCachObject}->FormIDRemoveFile(
                    FormID => $Self->{FormID},
                    FileID => $_,
                );
            }
        }
        # attachment upload
        if ($GetParam{AttachmentUpload}) {
            $Error{AttachmentUpload} = 1;
            my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                Param => "file_upload",
                Source => 'string',
            );
            $Self->{UploadCachObject}->FormIDAddFile(
                FormID => $Self->{FormID},
                %UploadStuff,
            );
        }
        if (!%Error) {
            # set lock if ticket was cloased
            if ($Lock && $State{TypeName} =~ /^close/i && $Ticket{OwnerID} ne '1') {
                $Self->{TicketObject}->LockSet(
                    TicketID => $Self->{TicketID},
                    Lock => 'lock',
                    UserID => => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                );
            }
            my $From = "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>";
            if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID => $Self->{TicketID},
                ArticleType => $Self->{Config}->{ArticleType},
                SenderType => $Self->{Config}->{SenderType},
                From => $From,
                Subject => $GetParam{Subject},
                Body => $GetParam{Body},
                ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
                UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                OrigHeader => {
                    From => $From,
                    To => 'System',
                    Subject => $GetParam{Subject},
                    Body => $GetParam{Body},
                },
                HistoryType => $Self->{Config}->{HistoryType},
                HistoryComment => $Self->{Config}->{HistoryComment} || '%%',
                AutoResponseType => 'auto follow up',
            )) {
                # set state
                my %NextStateData = $Self->{StateObject}->StateGet(
                    ID => $GetParam{StateID},
                );
                my $NextState = $NextStateData{Name} ||
                    $Self->{Config}->{StateDefault} || 'open';
                $Self->{TicketObject}->StateSet(
                    TicketID => $Self->{TicketID},
                    ArticleID => $ArticleID,
                    State => $NextState,
                    UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                );
                # set priority
                if ($Self->{Config}->{Priority} && $GetParam{PriorityID}) {
                    $Self->{TicketObject}->PrioritySet(
                        TicketID => $Self->{TicketID},
                        PriorityID => $GetParam{PriorityID},
                        UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                    );
                }
                # get pre loaded attachment
                my @AttachmentData = $Self->{UploadCachObject}->FormIDGetAllFilesData(
                    FormID => $Self->{FormID},
                );
                foreach my $Ref (@AttachmentData) {
                    $Self->{TicketObject}->ArticleWriteAttachment(
                        %{$Ref},
                        ArticleID => $ArticleID,
                        UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                    );
                }
                # get submit attachment
                my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
                    Param => 'file_upload',
                    Source => 'String',
                );
                if (%UploadStuff) {
                    $Self->{TicketObject}->ArticleWriteAttachment(
                        %UploadStuff,
                        ArticleID => $ArticleID,
                        UserID => $Self->{ConfigObject}->Get('CustomerPanelUserID'),
                    );
                }
                # remove pre submited attachments
                $Self->{UploadCachObject}->FormIDRemove(FormID => $Self->{FormID});
                # redirect to zoom view
                return $Self->{LayoutObject}->Redirect(
                    OP => "Action=$NextScreen&TicketID=$Self->{TicketID}",
                );
            }
            else {
                my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
                $Output .= $Self->{LayoutObject}->CustomerError();
                $Output .= $Self->{LayoutObject}->CustomerFooter();
                return $Output;
            }
        }
    }

    $Ticket{TmpCounter} = 0;
    $Ticket{TicketTimeUnits} = $Self->{TicketObject}->TicketAccountedTimeGet(
        TicketID => $Ticket{TicketID},
    );
    # get all atricle of this ticket
    my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(TicketID => $Self->{TicketID});
    # get article attachments
    foreach my $Article (@ArticleBox) {
        my %AtmIndex = $Self->{TicketObject}->ArticleAttachmentIndex(
            ContentPath => $Article->{ContentPath},
            ArticleID => $Article->{ArticleID},
        );
        $Article->{Atms} = \%AtmIndex;
    }
    # --
    # genterate output
    # --
    my $Output = $Self->{LayoutObject}->CustomerHeader(Value => $Ticket{TicketNumber});
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
    # --
    # show ticket
    # --
    if ($Self->{Subaction} eq 'ShowHTMLeMail') {
        # if it is a html email, drop normal header
        $Ticket{ShowHTMLeMail} = 1;
        $Output = '';
    }
    $Output .= $Self->_Mask(
        TicketID => $Self->{TicketID},
        ArticleBox => \@ArticleBox,
        ArticleID => $Self->{ArticleID},
        %Ticket,
        %GetParam,
    );
    # --
    # return if HTML email
    # --
    if ($Self->{Subaction} eq 'ShowHTMLeMail') {
        # if it is a html email, return here
        $Ticket{ShowHTMLeMail} = 1;
        return $Output;
    }
    # add footer
    $Output .= $Self->{LayoutObject}->CustomerFooter();

    # return output
    return $Output;
}

sub _Mask {
    my $Self = shift;
    my %Param = @_;
    $Param{FormID} = $Self->{FormID};
    # do some html quoting
    $Param{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Param{Age}, Space => ' ');
    # build article stuff
    my $SelectedArticleID = $Param{ArticleID} || '';
    my $BaseLink = $Self->{LayoutObject}->{Baselink} . "TicketID=$Self->{TicketID}&";
    my @ArticleBox = @{$Param{ArticleBox}};
    # get last customer article
    my $CounterArray = 0;
    my $LastCustomerArticleID;
    my $LastCustomerArticle = $#ArticleBox;
    my $ArticleID = '';
    foreach my $ArticleTmp (@ArticleBox) {
        my %Article = %$ArticleTmp;
        # if it is a customer article
        if ($Article{SenderType} eq 'customer') {
            $LastCustomerArticleID = $Article{'ArticleID'};
            $LastCustomerArticle = $CounterArray;
        }
        $CounterArray++;
        if ($SelectedArticleID eq $Article{ArticleID}) {
            $ArticleID = $Article{ArticleID};
        }
    }
    # try to use the latest customer article
    if (!$ArticleID && $LastCustomerArticleID) {
        $ArticleID = $LastCustomerArticleID;
    }
    # try to use the latest non internal agent article
    if (!$ArticleID) {
        foreach my $ArticleTmp (@ArticleBox) {
            if ($ArticleTmp->{StateType} eq 'merged' || $ArticleTmp->{ArticleType} !~ /int/) {
                $ArticleID = $ArticleTmp->{ArticleID};
            }
        }
    }
    # build thread string
    my $ThreadStrg = '';
    my $Counter = '';
    my $Space = '';
    my $LastSenderType = '';
    $Param{ArticleStrg} = '';
    foreach my $ArticleTmp (@ArticleBox) {
        my %Article = %$ArticleTmp;
        if ($Article{ArticleType} !~ /int/) {
            if ($LastSenderType ne $Article{SenderType}) {
                $Counter .= "&nbsp;&nbsp;&nbsp;&nbsp;";
                $Space = "$Counter |-->";
            }
            $LastSenderType = $Article{SenderType};
            $ThreadStrg .= "$Space";
            # if this is the shown article -=> add <b>
            if ($ArticleID eq $Article{ArticleID} ||
                (!$ArticleID && $LastCustomerArticleID eq $Article{ArticleID})
            ) {
                $ThreadStrg .= ">><b><i><u>";
            }
            # the full part thread string
            $ThreadStrg .= "<A HREF=\"$BaseLink"."Action=CustomerTicketZoom&ArticleID=$Article{ArticleID}\" ";
            $ThreadStrg .= 'onmouseover="window.status=\'$Text{"Zoom"}\'; return true;" onmouseout="window.status=\'\';">';
            $ThreadStrg .= "\$Text{\"$Article{SenderType}\"} (\$Text{\"$Article{ArticleType}\"})</A> ";
            $ThreadStrg .= ' $TimeLong{"'.$Article{Created}.'"}';
            $ThreadStrg .= "<BR>";
            # if this is the shown article -=> add </b>
            if ($ArticleID eq $Article{ArticleID} ||
                (!$ArticleID && $LastCustomerArticleID eq $Article{ArticleID})
            ) {
                $ThreadStrg .= "</u></i></b>";
            }
        }
    }
    $ThreadStrg .= '';
    $Param{ArticleStrg} .= $ThreadStrg;

    my $ArticleOB = $ArticleBox[$LastCustomerArticle];
    my %Article = %$ArticleOB;

    my $ArticleArray = 0;
    foreach my $ArticleTmp (@ArticleBox) {
        my %ArticleTmp1 = %$ArticleTmp;
        if ($ArticleID eq $ArticleTmp1{ArticleID}) {
            %Article = %ArticleTmp1;
        }
    }
    # check show article type
    if ($Article{StateType} ne 'merged' && $Article{ArticleType} =~ /int/) {
        return $Self->{LayoutObject}->CustomerError(Message => 'No permission!');
    }
    # get attacment string
    my %AtmIndex = ();
    if ($Article{Atms}) {
        %AtmIndex = %{$Article{Atms}};
    }
    # add block for attachments
    if (%AtmIndex) {
        $Self->{LayoutObject}->Block(
            Name => 'ArticleAttachment',
            Data => {
                Key => 'Attachment',
            },
        );
        foreach my $FileID (sort keys %AtmIndex) {
            my %File = %{$AtmIndex{$FileID}};
            $Self->{LayoutObject}->Block(
                Name => 'ArticleAttachmentRow',
                Data => {
                    %File,
                },
            );
            # download type
            my $Type = $Self->{ConfigObject}->Get('AttachmentDownloadType') || 'attachment';
            # if attachment will be forced to download, don't open a new download window!
            my $Target = '';
            if ($Type =~ /inline/i) {
                $Target = 'target="attachment" ';
            }
            $Self->{LayoutObject}->Block(
                Name => 'ArticleAttachmentRowLink',
                Data => {
                    %File,
                    Action => 'Download',
                    Link => "\$Env{\"Baselink\"}Action=CustomerTicketAttachment&ArticleID=$Article{ArticleID}&FileID=$FileID",
                    Image => 'disk-s.png',
                    Target => $Target,
                },
            );
        }
    }
    # just body if html email
    if ($Param{"ShowHTMLeMail"}) {
        # generate output
        return $Self->{LayoutObject}->Attachment(
            Filename => $Self->{ConfigObject}->Get('Ticket::Hook')."-$Article{TicketNumber}-$Article{TicketID}-$Article{ArticleID}",
            Type => 'inline',
            ContentType => "$Article{MimeType}; charset=$Article{ContentCharset}",
            Content => $Article{Body},
        );
    }
    # check if just a only html email
    if (my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(%Param, %Article)) {
        $Param{"Article::TextNote"} = $MimeTypeText;
        $Param{"Article::Text"} = '';
    }
    else {
        # html quoting
        $Param{"Article::Text"} = $Self->{LayoutObject}->Ascii2Html(
            NewLine => $Self->{ConfigObject}->Get('DefaultViewNewLine') || 85,
            Text => $Article{Body},
            VMax => $Self->{ConfigObject}->Get('DefaultViewLines') || 5000,
            HTMLResultMode => 1,
            LinkFeature => 1,
        );
        # do charset check
        if (my $CharsetText = $Self->{LayoutObject}->CheckCharset(
            ContentCharset => $Article{ContentCharset},
            TicketID => $Param{TicketID},
            ArticleID => $Article{ArticleID} )) {
            $Param{"Article::TextNote"} = $CharsetText;
        }
    }
    # get article id
    $Param{"Article::ArticleID"} = $Article{ArticleID};
    # do some strips && quoting
    foreach (qw(From To Cc Subject)) {
        if ($Article{$_}) {
            $Self->{LayoutObject}->Block(
                Name => 'Row',
                Data => {
                    Key => $_,
                    Value => $Article{$_},
                },
            );
        }
    }

    # check follow up permissions
    my $FollowUpPossible = $Self->{QueueObject}->GetFollowUpOption(
        QueueID => $Article{QueueID},
    );
    my %State = $Self->{StateObject}->StateGet(
        ID => $Article{StateID},
        Cache => 1,
    );
    if ($Self->{TicketObject}->CustomerPermission(
        Type => 'update',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID}) && $FollowUpPossible !~ /(new ticket|reject)/i && $State{TypeName} !~ /^close/i) {
        $Self->{LayoutObject}->Block(
            Name => 'FollowUp',
            Data => {
                %Param,
            },
        );
        # build next states string
        if ($Self->{Config}->{State}) {
            my %NextStates = $Self->{TicketObject}->StateList(
                TicketID => $Self->{TicketID},
                Action => $Self->{Action},
                CustomerUserID => $Self->{UserID},
            );
            my %StateSelected = ();
            if ($Param{StateID}) {
                $StateSelected{SelectedID} = $Param{StateID};
                }
            else {
                $StateSelected{Selected} = $Self->{Config}->{StateDefault},
            }
            $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data => \%NextStates,
                Name => 'StateID',
                %StateSelected,
            );
            $Self->{LayoutObject}->Block(
                Name => 'State',
                Data => {
                    %Param,
                },
            );
        }
        # get priority
        if ($Self->{Config}->{Priority}) {
            my %Priorities = $Self->{TicketObject}->PriorityList(
                CustomerUserID => $Self->{UserID},
                Action => $Self->{Action},
            );
            my %PrioritySelected = ();
            if ($Param{PriorityID}) {
                $PrioritySelected{SelectedID} = $Param{PriorityID};
            }
            else {
                $PrioritySelected{Selected} = $Self->{Config}->{PriorityDefault} || '3 normal',
            }
            $Param{'PriorityStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
                Data => \%Priorities,
                Name => 'PriorityID',
                %PrioritySelected,
            );
            $Self->{LayoutObject}->Block(
                Name => 'Priority',
                Data => {
                    %Param,
                },
            );
        }
        # show attachments
        # get all attachments meta data
        my @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );
        foreach my $DataRef (@Attachments) {
            $Self->{LayoutObject}->Block(
                Name => 'Attachment',
                Data => $DataRef,
            );
        }
    }
    # select the output template
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketZoom',
        Data => {
            %Article,
            %Param,
        },
    );
}

1;
