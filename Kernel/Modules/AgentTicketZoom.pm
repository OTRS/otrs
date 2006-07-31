# --
# Kernel/Modules/AgentTicketZoom.pm - to get a closer view
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketZoom.pm,v 1.22 2006-07-31 13:26:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketZoom;

use strict;
use Kernel::System::CustomerUser;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = '$Revision: 1.22 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }
    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject
      QueueObject ConfigObject UserObject SessionObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    # set debug
    $Self->{Debug} = 0;
    # get params
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID');
    $Self->{ZoomExpand} = $Self->{ParamObject}->GetParam(Param => 'ZoomExpand');
    $Self->{ZoomExpandSort} = $Self->{ParamObject}->GetParam(Param => 'ZoomExpandSort');
    if (!defined($Self->{ZoomExpand})) {
        $Self->{ZoomExpand} = $Self->{ConfigObject}->Get('Ticket::Frontend::ZoomExpand');
    }
    if (!defined($Self->{ZoomExpandSort})) {
        $Self->{ZoomExpandSort} = $Self->{ConfigObject}->Get('Ticket::Frontend::ZoomExpandSort');
    }
    $Self->{HighlightColor1} = $Self->{ConfigObject}->Get('HighlightColor1');
    $Self->{HighlightColor2} = $Self->{ConfigObject}->Get('HighlightColor2');
    # ticket id lookup
    if (!$Self->{TicketID} && $Self->{ParamObject}->GetParam(Param => 'TicketNumber')) {
        $Self->{TicketID} = $Self->{TicketObject}->TicketIDLookup(
            TicketNumber => $Self->{ParamObject}->GetParam(Param => 'TicketNumber'),
            UserID => $Self->{UserID},
        );
    }
    # customer user object
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    # link object
    $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param);

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "No TicketID is given!",
            Comment => 'Please contact the admin.',
        );
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'ro',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # --
    # store last screen
    # --
    if ($Self->{Subaction} ne 'ShowHTMLeMail') {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenView',
            Value => $Self->{RequestedURL},
        );
    }
    # get content
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(TicketID => $Self->{TicketID});
    # --
    # return if HTML email
    # --
    if ($Self->{Subaction} eq 'ShowHTMLeMail') {
        # check needed ArticleID
        if (!$Self->{ArticleID}) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'Need ArticleID!');
        }
        # get article data
        my %Article = ();
        foreach my $ArticleTmp (@ArticleBox) {
            if ($ArticleTmp->{ArticleID} eq $Self->{ArticleID}) {
                %Article = %{$ArticleTmp};
            }
        }
        # check if article data exists
        if (!%Article) {
            return $Self->{LayoutObject}->ErrorScreen(Message => 'Invalid ArticleID!');
        }
        # if it is a html email, return here
        return $Self->{LayoutObject}->Attachment(
            Filename => $Self->{ConfigObject}->Get('Ticket::Hook')."-$Article{TicketNumber}-$Article{TicketID}-$Article{ArticleID}",
            Type => 'inline',
            ContentType => "$Article{MimeType}; charset=$Article{ContentCharset}",
            Content => $Article{Body},
        );
    }
    # --
    # else show normal ticket zoom view
    # --
    # fetch all move queues
    my %MoveQueues = $Self->{TicketObject}->MoveList(
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID},
        Action => $Self->{Action},
        Type => 'move_into',
    );
    # fetch all std. responses
    my %StdResponses = $Self->{QueueObject}->GetStdResponses(QueueID => $Ticket{QueueID});
    # customer info
    my %CustomerData = ();
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoZoom')) {
        if ($Ticket{CustomerUserID}) {
            %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Ticket{CustomerUserID},
            );
        }
        elsif ($Ticket{CustomerID}) {
            %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                CustomerID => $Ticket{CustomerID},
            );
        }
    }
    # --
    # genterate output
    # --
    $Output .= $Self->{LayoutObject}->Header(Value => $Ticket{TicketNumber});
    $Output .= $Self->{LayoutObject}->NavigationBar();
    # --
    # show ticket
    # --
    $Output .= $Self->MaskAgentZoom(
        MoveQueues => \%MoveQueues,
        StdResponses => \%StdResponses,
        ArticleBox => \@ArticleBox,
        CustomerData => \%CustomerData,
        TicketTimeUnits => $Self->{TicketObject}->TicketAccountedTimeGet(%Ticket),
        %Ticket,
    );
    # add footer
    $Output .= $Self->{LayoutObject}->Footer();
    # return output
    return $Output;
}

sub MaskAgentZoom {
    my $Self = shift;
    my %Param = @_;
    # owner info
    my %UserInfo = $Self->{UserObject}->GetUserData(
        UserID => $Param{OwnerID},
        Cached => 1
    );
    # responsible info
    my %ResponsibleInfo = $Self->{UserObject}->GetUserData(
        UserID => $Param{ResponsibleID} || 1,
        Cached => 1
    );
    # get ack actions
    $Self->{TicketObject}->TicketAcl(
        Data => '-',
        Action => $Self->{Action},
        TicketID => $Self->{TicketID},
        ReturnType => 'Action',
        ReturnSubType => '-',
        UserID => $Self->{UserID},
    );

    my %AclAction = $Self->{TicketObject}->TicketAclActionData();
    # age design
    $Param{Age} = $Self->{LayoutObject}->CustomerAge(Age => $Param{Age}, Space => ' ');
    if ($Param{UntilTime}) {
        if ($Param{UntilTime} < -1) {
            $Param{PendingUntil} = "<font color='$Self->{HighlightColor2}'>";
        }
        $Param{PendingUntil} .= $Self->{LayoutObject}->CustomerAge(Age => $Param{UntilTime}, Space => '<br>');
        if ($Param{UntilTime} < -1) {
            $Param{PendingUntil} .= "</font>";
        }
    }
    $Self->{LayoutObject}->Block(
        Name => 'Header',
        Data => {%Param, %AclAction},
    );
    # ticket title
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::Title')) {
        $Self->{LayoutObject}->Block(
            Name => 'Title',
            Data => {%Param, %AclAction},
        );
    }
    # run ticket menu modules
    if (ref($Self->{ConfigObject}->Get('Ticket::Frontend::MenuModule')) eq 'HASH') {
        my %Menus = %{$Self->{ConfigObject}->Get('Ticket::Frontend::MenuModule')};
        my $Counter = 0;
        foreach my $Menu (sort keys %Menus) {
            # load module
            if ($Self->{MainObject}->Require($Menus{$Menu}->{Module})) {
                my $Object = $Menus{$Menu}->{Module}->new(
                    %{$Self},
                    TicketID => $Self->{TicketID},
                );
                # run module
                $Counter = $Object->Run(
                    %Param,
                    Ticket => \%Param,
                    Counter => $Counter,
                    ACL => \%AclAction,
                    Config => $Menus{$Menu},
                );
            }
            else {
                return $Self->{LayoutObject}->FatalError();
            }
        }
    }
    # --
    # build article stuff
    # --
    my $BaseLink = $Self->{LayoutObject}->{Baselink}."TicketID=$Self->{TicketID}&";
    my @ArticleBox = @{$Param{ArticleBox}};
    # get selected or last customer article
    my $CounterArray = 0;
    my $ArticleID;
    if ($Self->{ArticleID}) {
        $ArticleID = $Self->{ArticleID};
    }
    else {
        # set first article
        if (@ArticleBox) {
            $ArticleID = $ArticleBox[0]->{ArticleID};
        }
        # get last customer article
        foreach my $ArticleTmp (@ArticleBox) {
            if ($ArticleTmp->{SenderType} eq 'customer') {
                $ArticleID = $ArticleTmp->{ArticleID};
            }
        }
    }
    # --
    # build thread string
    # --
    my $Counter = '';
    my $Space = '';
    my $LastSenderType = '';
    my $TicketOverTime = 0;
    foreach my $ArticleTmp (@ArticleBox) {
      my %Article = %$ArticleTmp;
      $TicketOverTime = $Article{TicketOverTime};
    }
    # --
    # prepare escalation time (if needed)
    # --
    if ($TicketOverTime) {
      # colloring
      if ($TicketOverTime <= -60*20) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor2}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }
      elsif ($TicketOverTime <= -60*40) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor1}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }

      $Param{TicketOverTime} = $Self->{LayoutObject}->CustomerAge(
          Age => $TicketOverTime,
          Space => '<br>',
      );
      if ($Param{TicketOverTimeFont} && $Param{TicketOverTimeFontEnd}) {
        $Param{TicketOverTime} = $Param{TicketOverTimeFont}.
            $Param{TicketOverTime}.$Param{TicketOverTimeFontEnd};
      }
    }
    else {
        $Param{TicketOverTime} = '-';
    }
    # --
    # get shown article(s)
    # --
    my @NewArticleBox = ();
    if (!$Self->{ZoomExpand}) {
        foreach my $ArticleTmp (@ArticleBox) {
            if ($ArticleID eq $ArticleTmp->{ArticleID}) {
                push(@NewArticleBox, $ArticleTmp);
            }
        }
    }
    else {
        # resort article order
        if ($Self->{ZoomExpandSort} eq 'reverse') {
            @ArticleBox = reverse(@ArticleBox);
        }
        # show no email-notification* article
        foreach my $ArticleTmp (@ArticleBox) {
            my %Article = %$ArticleTmp;
            if ($Article{ArticleType} !~ /^email-notification/i) {
                push (@NewArticleBox, $ArticleTmp);
            }
        }
    }
    # --
    # build shown article(s)
    # --
    my $Count = 0;
    my $BodyOutput = '';
    foreach my $ArticleTmp (@NewArticleBox) {
        $Count++;
        my %Article = %$ArticleTmp;
        # check if just a only html email
        if (my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(%Param, %Article)) {
            $Article{"BodyNote"} = $MimeTypeText;
            $Article{"Body"} = '';
        }
        else {
            # html quoting
            $Article{"Body"} = $Self->{LayoutObject}->Ascii2Html(
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
                $Article{"BodyNote"} = $CharsetText;
            }
        }
        $Self->{LayoutObject}->Block(
             Name => 'Body',
             Data => {%Param, %Article, %AclAction},
        );
        # show article tree
        if ($Count == 1) {
            # show status info
            $Self->{LayoutObject}->Block(
                 Name => 'Status',
                 Data => {%Param, %AclAction},
            );
            # customer info string
            if ($Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoZoom')) {
                $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
                    Data => {
                        %Param,
                        %{$Param{CustomerData}},
                    },
                    Max => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoZoomMaxSize'),
                );
                $Self->{LayoutObject}->Block(
                    Name => 'CustomerTable',
                    Data => \%Param,
                );
            }
            $Self->{LayoutObject}->Block(
                 Name => 'Owner',
                 Data => {%Param, %UserInfo, %AclAction},
            );
            if ($Self->{ConfigObject}->Get('Ticket::Responsible')) {
                $Self->{LayoutObject}->Block(
                     Name => 'Responsible',
                     Data => {%Param, %ResponsibleInfo, %AclAction},
                );
            }
            # get linked objects
            my %Links = $Self->{LinkObject}->AllLinkedObjects(
                Object => 'Ticket',
                ObjectID => $Self->{TicketID},
                UserID => $Self->{UserID},
            );
            foreach my $LinkType (sort keys %Links) {
                my %ObjectType = %{$Links{$LinkType}};
                foreach my $Object (sort keys %ObjectType) {
                    my %Data = %{$ObjectType{$Object}};
                    foreach my $Item (sort keys %Data) {
                        $Self->{LayoutObject}->Block(
                            Name => "Link$LinkType",
                            Data => $Data{$Item},
                        );
                    }
                }
            }
            $Self->{LayoutObject}->Block(
                 Name => 'Tree',
                 Data => {%Param, %Article, %AclAction},
            );
            # build thread string
            my $CounterTree = 0;
            my $Counter = '';
            my $Space = '';
            my $LastSenderType = '';
            foreach my $ArticleTmp (@ArticleBox) {
                my %Article = %$ArticleTmp;
                my $Start = '';
                my $Stop = '';
                if ($Article{ArticleType} !~ /^email-notification/i) {
                    $CounterTree++;
                    my $TmpSubject = $Self->{TicketObject}->TicketSubjectClean(
                            TicketNumber => $Article{TicketNumber},
                            Subject => $Article{Subject} || '',
                    );
                    if ($LastSenderType ne $Article{SenderType}) {
                            $Counter .= "&nbsp;";
                            $Space = "$Counter&nbsp;|--&gt;";
                    }
                    $LastSenderType = $Article{SenderType};
                    # if this is the shown article -=> add <b>
                    if ($ArticleID eq $Article{ArticleID}) {
                        $Start = '&gt;&gt;<i><b><u>';
                    }
                    # if this is the shown article -=> add </b>
                    if ($ArticleID eq $Article{ArticleID}) {
                        $Stop = '</u></b></i>';
                    }
                    $Self->{LayoutObject}->Block(
                        Name => 'TreeItem',
                        Data => {
                            %Article,
                            Subject => $TmpSubject,
                            Space => $Space,
                            Start => $Start,
                            Stop => $Stop,
                            Count => $CounterTree,
                        },
                    );
                    if ($Article{ArticleType} =~ /^email/) {
                        $Self->{LayoutObject}->Block(
                            Name => 'TreeItemEmail',
                            Data => {
                                %Article,
                            },
                        );
                    }
                    # add attachment icon
                    if ($Article{Atms}->{1} && $Self->{ConfigObject}->Get('Ticket::ZoomAttachmentDisplay')) {
                        my $Title = '';
                        # download type
                        my $Type = $Self->{ConfigObject}->Get('AttachmentDownloadType') || 'attachment';
                        # if attachment will be forced to download, don't open a new download window!
                        my $Target = '';
                        if ($Type =~ /inline/i) {
                            $Target = 'target="attachment" ';
                        }
                        foreach my $Count (1..($Self->{ConfigObject}->Get('Ticket::ZoomAttachmentDisplayCount')+1)) {
                            if ($Article{Atms}->{$Count}) {
                                if ($Count > $Self->{ConfigObject}->Get('Ticket::ZoomAttachmentDisplayCount')) {
                                    $Self->{LayoutObject}->Block(
                                        Name => 'TreeItemAttachmentMore',
                                        Data => {
                                            %Article,
                                            %{$Article{Atms}->{$Count}},
                                            FileID => $Count,
                                            Target => $Target,
                                        },
                                    );
                                }
                                elsif ($Article{Atms}->{$Count}) {
                                    $Self->{LayoutObject}->Block(
                                        Name => 'TreeItemAttachment',
                                        Data => {
                                            %Article,
                                            %{$Article{Atms}->{$Count}},
                                            FileID => $Count,
                                            Target => $Target,
                                        },
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }
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
        # show accounted article time
        if ($Self->{ConfigObject}->Get('Ticket::ZoomTimeDisplay')) {
            my $ArticleTime = $Self->{TicketObject}->ArticleAccountedTimeGet(
                ArticleID => $Article{ArticleID},
            );
            $Self->{LayoutObject}->Block(
                Name => "Row",
                Data => {
                    Key => 'Time',
                    Value => $ArticleTime,
                },
            );
        }
        # show article free text
        foreach (1..5) {
            if ($Article{"ArticleFreeText$_"}) {
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleFreeText',
                    Data => {
                        Key => $Article{"ArticleFreeKey$_"},
                        Value => $Article{"ArticleFreeText$_"},
                    },
                );
            }
        }
        # run article modules
        if (ref($Self->{ConfigObject}->Get('Ticket::Frontend::ArticleViewModule')) eq 'HASH') {
            my %Jobs = %{$Self->{ConfigObject}->Get('Ticket::Frontend::ArticleViewModule')};
            foreach my $Job (sort keys %Jobs) {
                # load module
                if ($Self->{MainObject}->Require($Jobs{$Job}->{Module})) {
                    my $Object = $Jobs{$Job}->{Module}->new(
                        %{$Self},
                        TicketID => $Self->{TicketID},
                        ArticleID => $Article{ArticleID},
                    );
                    # run module
                    my @Data = $Object->Check(Article=> \%Article, %Param, Config => $Jobs{$Job});
                    foreach my $DataRef (@Data) {
                        $Self->{LayoutObject}->Block(
                             Name => 'ArticleOption',
                             Data => $DataRef,
                        );
                    }
                    # filter option
                    $Object->Filter(Article=> \%Article, %Param, Config => $Jobs{$Job});
                }
                else {
                    return $Self->{LayoutObject}->ErrorScreen();
                }
            }
        }
        # get StdResponsesStrg
        $Param{StdResponsesStrg} = $Self->{LayoutObject}->TicketStdResponseString(
            StdResponsesRef => $Param{StdResponses},
            TicketID => $Param{TicketID},
            ArticleID => $Article{ArticleID},
        );
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
        }
        foreach my $FileID (sort keys %AtmIndex) {
            my %File = %{$AtmIndex{$FileID}};
            $Self->{LayoutObject}->Block(
                Name => 'ArticleAttachmentRow',
                Data => {
                    %File,
                },
            );
             # run article attachment modules
             if (ref($Self->{ConfigObject}->Get('Ticket::Frontend::ArticleAttachmentModule')) eq 'HASH') {
                my %Jobs = %{$Self->{ConfigObject}->Get('Ticket::Frontend::ArticleAttachmentModule')};
                foreach my $Job (sort keys %Jobs) {
                    # load module
                    if ($Self->{MainObject}->Require($Jobs{$Job}->{Module})) {
                        my $Object = $Jobs{$Job}->{Module}->new(
                            %{$Self},
                            TicketID => $Self->{TicketID},
                            ArticleID => $Article{ArticleID},
                        );
                        # run module
                        my %Data = $Object->Run(
                            File => {
                                %File,
                                FileID => $FileID,
                            },
                            Article => \%Article,
                        );
                        if (%Data) {
                            $Self->{LayoutObject}->Block(
                                Name => $Data{Block} || 'ArticleAttachmentRowLink',
                                Data => { %Data },
                            );
                        }
                    }
                    else {
                        return $Self->{LayoutObject}->ErrorScreen();
                    }
                }
             }
        }

        # select the output template
        if ($Article{ArticleType} =~ /^note/i) {
            # without compose links!
            if ($Self->{ConfigObject}->Get('Ticket::AgentCanBeCustomer') && $Param{CustomerUserID} =~ /^$Self->{UserLogin}$/i) {
                $Self->{LayoutObject}->Block(
                    Name => 'AgentIsCustomer',
                    Data => {%Param, %Article, %AclAction},
                );
            }
            $Self->{LayoutObject}->Block(
                Name => 'AgentArticleCom',
                Data => {%Param, %Article, %AclAction},
            );
        }
        else {
            # without all!
            if ($Self->{ConfigObject}->Get('Ticket::AgentCanBeCustomer') && $Param{CustomerUserID} =~ /^$Self->{UserLogin}$/i) {
                $Self->{LayoutObject}->Block(
                    Name => 'AgentIsCustomer',
                    Data => {%Param, %Article, %AclAction},
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'AgentAnswer',
                    Data => {%Param, %Article, %AclAction},
                );
            }
            $Self->{LayoutObject}->Block(
                Name => 'AgentArticleCom',
                Data => {%Param, %Article, %AclAction},
            );
        }
    }
    # get MoveQueuesStrg
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::MoveType') =~ /^form$/i) {
        $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Name => 'DestQueueID',
            Data => $Param{MoveQueues},
            SelectedID => $Param{QueueID},
        );
    }
    $Self->{LayoutObject}->Block(
        Name => 'Move',
        Data => {%Param, %AclAction},
    );
    $Self->{LayoutObject}->Block(
        Name => 'Footer',
        Data => {%Param, %AclAction},
    );
    # return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketZoom',
        Data => {%Param, %AclAction},
    );
}
# --
1;
