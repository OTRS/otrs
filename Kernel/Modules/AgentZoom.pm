# --
# Kernel/Modules/AgentZoom.pm - to get a closer view
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentZoom.pm,v 1.72 2004-09-16 22:04:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentZoom;

use strict;
use Kernel::System::CustomerUser;
use Kernel::System::LinkObject;

use vars qw($VERSION);
$VERSION = '$Revision: 1.72 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
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
        die "Got no $_!" if (!$Self->{$_});
    }
    # set debug
    $Self->{Debug} = 0;
    # get params
    $Self->{ArticleID} = $Self->{ParamObject}->GetParam(Param => 'ArticleID');
    $Self->{ZoomExpand} = $Self->{ParamObject}->GetParam(Param => 'ZoomExpand');
    $Self->{ZoomExpandSort} = $Self->{ParamObject}->GetParam(Param => 'ZoomExpandSort');
    if (!defined($Self->{ZoomExpand})) {
        $Self->{ZoomExpand} = $Self->{ConfigObject}->Get('TicketZoomExpand');
    }
    if (!defined($Self->{ZoomExpandSort})) {
        $Self->{ZoomExpandSort} = $Self->{ConfigObject}->Get('TicketZoomExpandSort');
    }
    $Self->{HighlightColor1} = $Self->{ConfigObject}->Get('HighlightColor1');
    $Self->{HighlightColor2} = $Self->{ConfigObject}->Get('HighlightColor2');
    # customer user object
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    # link object
    $Self->{LinkObject} = Kernel::System::LinkObject->new(%Param);
    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "No TicketID is given!",
            Comment => 'Please contact the admin.',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
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
      if (!$Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key => 'LastScreen',
        Value => $Self->{RequestedURL},
      )) {
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
      }
    }
    # get content
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    my %LinkObjects = $Self->{LinkObject}->LinkObjects();
    foreach my $Object (keys %LinkObjects) {
        $Self->{LinkObject}->LoadBackend(Module => $Object);
        my %Linked = $Self->{LinkObject}->LinkedObjects(
            LinkType => 'Child',
            LinkObject1 => 'Ticket',
            LinkID1 => $Self->{TicketID},
            LinkObject2 => $Object,
            UserID => $Self->{UserID},
        );
        foreach (keys %Linked) {
            $Self->{LayoutObject}->Block(
                Name => 'LinkChild',
                Data => { %{$Linked{$_}} },
            );
        }
    }
    foreach my $Object (keys %LinkObjects) {
        $Self->{LinkObject}->LoadBackend(Module => $Object);
        my %Linked = $Self->{LinkObject}->LinkedObjects(
            LinkType => 'Parent',
            LinkObject2 => 'Ticket',
            LinkID2 => $Self->{TicketID},
            LinkObject1 => $Object,
            UserID => $Self->{UserID},
        );
        foreach (keys %Linked) {
            $Self->{LayoutObject}->Block(
                Name => 'LinkParent',
                Data => { %{$Linked{$_}} },
            );
        }
    }
    foreach my $Object (keys %LinkObjects) {
        $Self->{LinkObject}->LoadBackend(Module => $Object);
        my %Linked = $Self->{LinkObject}->LinkedObjects(
            LinkType => 'Normal',
            LinkObject1 => 'Ticket',
            LinkID1 => $Self->{TicketID},
            LinkObject2 => $Object,
            UserID => $Self->{UserID},
        );
        foreach (keys %Linked) {
            $Self->{LayoutObject}->Block(
                Name => 'LinkNormal',
                Data => { %{$Linked{$_}} },
            );
        }
    }
    my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex(TicketID => $Self->{TicketID});
    # --
    # return if HTML email
    # --
    if ($Self->{Subaction} eq 'ShowHTMLeMail') {
        # check needed ArticleID
        if (!$Self->{ArticleID}) {
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(Message => 'Need ArticleID!');
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
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
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(Message => 'Invalid ArticleID!');
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # if it is a html email, return here
        return $Self->{LayoutObject}->Attachment(
            Filename => $Self->{ConfigObject}->Get('TicketHook')."-$Article{TicketNumber}-$Article{TicketID}-$Article{ArticleID}",
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
    # user info
    my %UserInfo = $Self->{UserObject}->GetUserData(
        User => $Ticket{Owner},
        Cached => 1
    );
    # customer info
    my %CustomerData = ();
    if ($Self->{ConfigObject}->Get('ShowCustomerInfoZoom')) {
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
    $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => "Zoom Ticket");
    $Output .= $Self->{LayoutObject}->NavigationBar(Type => 'Agent');
    # --
    # show ticket
    # --
    $Output .= $Self->MaskAgentZoom(
        MoveQueues => \%MoveQueues,
        StdResponses => \%StdResponses,
        ArticleBox => \@ArticleBox,
        CustomerData => \%CustomerData,
        TicketTimeUnits => $Self->{TicketObject}->TicketAccountedTimeGet(%Ticket),
        %UserInfo,
        %Ticket,
    );
    # add footer
    $Output .= $Self->{LayoutObject}->Footer();
    # return output
    return $Output;
}
# --
sub MaskAgentZoom {
    my $Self = shift;
    my %Param = @_;
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
    $Param{SLAAge} = $Self->{LayoutObject}->CustomerAge(Age => $Param{SLAAge}, Space => ' ');
    if ($Param{UntilTime}) {
        if ($Param{UntilTime} < -1) {
            $Param{PendingUntil} = "<font color='$Self->{HighlightColor2}'>";
        }
        $Param{PendingUntil} .= $Self->{LayoutObject}->CustomerAge(Age => $Param{UntilTime}, Space => '<br>');
        if ($Param{UntilTime} < -1) {
            $Param{PendingUntil} .= "</font>";
        }
    }
    # --
    # get MoveQueuesStrg
    # --
    if ($Self->{ConfigObject}->Get('MoveType') =~ /^form$/i) {
        $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Name => 'DestQueueID',
            Data => $Param{MoveQueues},
            SelectedID => $Param{QueueID},
        );
    }
    # --
    # customer info string 
    # --
    $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
        Data => $Param{CustomerData},
        Max => $Self->{ConfigObject}->Get('ShowCustomerInfoZoomMaxSize'),
    );
    # --
    # build article stuff
    # --
    my $BaseLink = $Self->{LayoutObject}->{Baselink}."TicketID=$Self->{TicketID}&QueueID=$Self->{QueueID}&";
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
    my $ThreadStrg = '';
    my $Counter = '';
    my $Space = '';
    my $LastSenderType = '';
    my $TicketOverTime = 0;
    $Param{ArticleStrg} = '<table border="0" width="100%" cellspacing="0" cellpadding="0">';
    foreach my $ArticleTmp (@ArticleBox) {
      my %Article = %$ArticleTmp;
      $TicketOverTime = $Article{TicketOverTime}; 
      if ($Article{ArticleType} !~ /^email-notification/i) { 
        my $TmpSubject = $Article{Subject};
        my $TicketHook = $Self->{ConfigObject}->Get('TicketHook') || '';
        $TmpSubject =~ s/^..: //;
        $TmpSubject =~ s/\[$TicketHook: $Article{TicketNumber}\] //g;
        my $TitleShort = $Self->{LayoutObject}->Ascii2Html(Text => $Article{From}, Max => 16).': '.$Self->{LayoutObject}->Ascii2Html(Text => $TmpSubject, Max => 20).' - $TimeLong{"'.$Article{Created}.'"}';
        my $Title = $Self->{LayoutObject}->Ascii2Html(Text => $Article{From}, Max => 50).': '.$Self->{LayoutObject}->Ascii2Html(Text => $TmpSubject, Max => 200).' - $TimeLong{"'.$Article{Created}.'"}';
        $ThreadStrg .= '<tr class="'.$Article{SenderType}.'-'.$Article{ArticleType}.'"><td class="small">';
        $ThreadStrg .= '<div title="'.$Title.'">';
        if ($LastSenderType ne $Article{SenderType}) {
            $Counter .= "&nbsp;";
            $Space = "$Counter&nbsp;|--&gt;";
        }
        $LastSenderType = $Article{SenderType};
        $ThreadStrg .= "$Space";
        # --
        # if this is the shown article -=> add <b>
        # --
        if ($ArticleID eq $Article{ArticleID}) {
            $ThreadStrg .= '&gt;&gt;<i><b><u>';
        }
        # --
        # the full part thread string
        # --
        $ThreadStrg .= "<a href=\"$BaseLink"."Action=AgentZoom&ArticleID=$Article{ArticleID}#$Article{ArticleID}\"" .
           'onmouseover="window.status=\''."\$Text{\"$Article{SenderType}\"} (".
           "\$Text{\"$Article{ArticleType}\"})".'\'; return true;" onmouseout="window.status=\'\';">'.
           "\$Text{\"$Article{SenderType}\"} (\$Text{\"$Article{ArticleType}\"})</a> ";
        if ($Article{ArticleType} =~ /^email/) {
            $ThreadStrg .= " (<a href=\"$BaseLink"."Action=AgentPlain&ArticleID=$Article{ArticleID}\"".
             'onmouseover="window.status=\'$Text{"plain"}'.
             '\'; return true;" onmouseout="window.status=\'\';">$Text{"plain"}</a>)';
        }
        $ThreadStrg .= '&nbsp;'.$TitleShort;
        # --
        # if this is the shown article -=> add </b>
        # --
        if ($ArticleID eq $Article{ArticleID}) { 
            $ThreadStrg .= '</u></b></i>';
        }
        $ThreadStrg .= '</div></td></tr>';
      }
    }
    $ThreadStrg .= '</table>';
    $Param{ArticleStrg} .= $ThreadStrg;
    # --
    # prepare escalation time (if needed)
    # --
    if ($Param{Answered}) {
        $Param{TicketOverTime} = '$Text{"none - answered"}';
    }
    elsif ($TicketOverTime) {
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
    $Param{TicketStatus} .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentZoomStatus',
        Data => {%Param, %AclAction},
    );
    my $BodyOutput = '';
    foreach my $ArticleTmp (@NewArticleBox) {
        my %Article = %$ArticleTmp;
        # run article modules
        if (ref($Self->{ConfigObject}->Get('Frontend::ArticleModule')) eq 'HASH') {
            my %Jobs = %{$Self->{ConfigObject}->Get('Frontend::ArticleModule')};
            foreach my $Job (sort keys %Jobs) {
                # log try of load module
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "Try to load module: $Jobs{$Job}->{Module}!",
                    );
                }
                if (eval "require $Jobs{$Job}->{Module}") {
                    my $Object = $Jobs{$Job}->{Module}->new(
                        ConfigObject => $Self->{ConfigObject},
                        LogObject => $Self->{LogObject},
                        DBObject => $Self->{DBObject},
                        LayoutObject => $Self->{LayoutObject},
                        TicketObject => $Self->{TicketObject},
                        ArticleID => $Article{ArticleID},
                        UserID => $Self->{UserID},
                        Debug => $Self->{Debug},
                    );
                    # log loaded module
                    if ($Self->{Debug} > 1) {
                        $Self->{LogObject}->Log(
                            Priority => 'debug',
                            Message => "Module: $Jobs{$Job}->{Module} loaded!",
                        );
                    }
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
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Can't load module $Jobs{$Job}->{Module}!",
                    );
                }
            }
        }
        # delete ArticleStrg and TicketStatus if it's not the first shown article
        if ($BodyOutput) {
            $Param{ArticleStrg} = '';
            $Param{TicketStatus} = '';
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
        $Article{"ATM"} = '<table border="0" cellspacing="0" cellpadding="1">';
        foreach my $FileID (keys %AtmIndex) {
            my %File = %{$AtmIndex{$FileID}};
            # check viewer
            my $Viewer = '';
            if ($Self->{ConfigObject}->Get('MIME-Viewer')) {
                foreach (keys %{$Self->{ConfigObject}->Get('MIME-Viewer')}) {
                    if ($File{ContentType} =~ /^$_/i) {
                        $Viewer = $Self->{ConfigObject}->Get('MIME-Viewer')->{$_};
                    }
                }
            }
            # build link
            $File{Filename} = $Self->{LayoutObject}->Ascii2Html(Text => $File{Filename});
            # download type
            my $Type = $Self->{ConfigObject}->Get('Agent::DownloadType') || 'attachment';
            # if attachment will be forced to download, don't open a new download window!
            my $Target = '';
            if ($Type =~ /inline/i) {
                $Target = 'target="attachment" ';
            }
            my $Link = "\$Env{\"Baselink\"}Action=AgentAttachment&ArticleID=$Article{ArticleID}&FileID=$FileID";
            $Article{"ATM"} .= "<tr><td>$File{Filename}</td>";
            $Article{"ATM"} .= "<td><a href=\"$Link\" $Target".
              "onmouseover=\"window.status='\$Text{\"Download\"}: $File{Filename}';".
              ' return true;" onmouseout="window.status=\'\';">'.
              "<img src=\"\$Env{\"Images\"}disk-s.png\" border=\"0\" alt=\"\$Text{\"Download\"}\"></a></td><td> ";
             if ($Viewer) {
                 $Article{"ATM"} .= "<a href=\"$Link&Viewer=1\" target=\"attachment\" ".
              "onmouseover=\"window.status='\$Text{\"View\"}: $File{Filename}';".
              ' return true;" onmouseout="window.status=\'\';">'.
              "<img src=\"\$Env{\"Images\"}screen-s.png\" border=\"0\" alt=\"\$Text{\"Viewer\"}\"></a>";
             }
             $Article{"ATM"} .= "</td><td align='right'> $File{Filesize}</td></tr>";
        }
        $Article{"ATM"} .= '</table>';
        if (%AtmIndex) {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleAttachment',
                Data => {
                    Key => 'Attachment',
                    Value => $Article{"ATM"},
                },
            );
        }
        # do some strips && quoting
        foreach (qw(From To Cc Subject Body)) {
            $Article{$_} = $Self->{LayoutObject}->{LanguageObject}->CharsetConvert(
                Text => $Article{$_},
                From => $Article{ContentCharset},
            );
        }
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
        foreach (qw(1 2 3 4 5)) {
            if ($Article{"FreeText$_"}) {
                $Self->{LayoutObject}->Block(
                    Name => 'ArticleFreeText',
                    Data => {
                        Key => $Article{"FreeKey$_"},
                        Value => $Article{"FreeText$_"},
                    },
                );
            }
        }

        # check if just a only html email
        if (my $MimeTypeText = $Self->{LayoutObject}->CheckMimeType(%Param, %Article)) {
            $Article{"BodyNote"} = $MimeTypeText;
            $Article{"Body"} = '';
        }
        else {
            # html quoting
            $Article{"Body"} = $Self->{LayoutObject}->Ascii2Html(
                NewLine => $Self->{ConfigObject}->Get('ViewableTicketNewLine') || 85,
                Text => $Article{Body},
                VMax => $Self->{ConfigObject}->Get('ViewableTicketLinesZoom') || 5000,
                HTMLResultMode => 1,
            );
            # link quoting
            $Article{"Body"} = $Self->{LayoutObject}->LinkQuote(
                Text => $Article{"Body"},
            );
            # do charset check
            if (my $CharsetText = $Self->{LayoutObject}->CheckCharset(
                ContentCharset => $Article{ContentCharset},
                TicketID => $Param{TicketID},
                ArticleID => $Article{ArticleID} )) {
                $Article{"BodyNote"} = $CharsetText;
            }
        }
        # select the output template
        if ($Article{ArticleType} =~ /^note/i) {
            # without compose links!
            if ($Self->{ConfigObject}->Get('AgentCanBeCustomer') && $Param{CustomerUserID} =~ /^$Self->{UserLogin}$/i) {
                $Self->{LayoutObject}->Block(
                    Name => 'AgentIsCustomer',
                    Data => {%Param, %Article, %AclAction},
                );
            }
            $Self->{LayoutObject}->Block(
                Name => 'AgentArticleCom',
                Data => {%Param, %Article, %AclAction},
            );
            $BodyOutput .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentZoomBody',
                Data => {%Param, %Article, %AclAction},
            );
        }
        else {
            # without all!
            if ($Self->{ConfigObject}->Get('AgentCanBeCustomer') && $Param{CustomerUserID} =~ /^$Self->{UserLogin}$/i) {
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
            $BodyOutput .= $Self->{LayoutObject}->Output(
                TemplateFile => 'AgentZoomBody',
                Data => {%Param, %Article, %AclAction},
            );
        }
    }
    my $Output = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentZoomHead',
        Data => {%Param, %AclAction},
    );
    $Output .= $BodyOutput;
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentZoomFooter',
        Data => {%Param, %AclAction},
    );
    # return output
    return $Output;
}
# --
1;
