# --
# HTML/Agent.pm - provides generic agent HTML output
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Agent.pm,v 1.105 2003-04-15 20:53:33 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Agent;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.105 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub NavigationBar {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # --
    # check DisplayCharset
    # --
    foreach ($Self->{LanguageObject}->GetPossibleCharsets()) {
        if ($Self->{UserCharset} =~ /^$_$/i) { 
            $Param{CorrectDisplayCharset} = 1;
        }
    }
    if (!$Param{CorrectDisplayCharset} && $Self->{LanguageObject}->GetRecommendedCharset()) {
        $Output .= $Self->Notify(
          Info => $Self->{LanguageObject}->Get('The recommended charset for your language is %s!", "'.$Self->{LanguageObject}->GetRecommendedCharset()),
        );
    }
    # --
    # check lock count
    # --
    foreach (keys %{$Param{LockData}}) {
        $Param{$_} = $Param{LockData}->{$_} || 0; 
    }
    if ($Param{New}) {
        $Output .= $Self->Notify(
          Info => '<a href="$Env{"Baselink"}Action=AgentMailbox&Subaction=New">'.
            $Self->{LanguageObject}->Get('You have %s new message(s)!", "'.$Param{New}).'</a>'
        );
    }
    if ($Param{Reminder}) {
        $Output .= $Self->Notify(
          Info => '<a href="$Env{"Baselink"}Action=AgentMailbox&Subaction=Reminder">'.
           $Self->{LanguageObject}->Get('You have %s reminder ticket(s)!", "'.
           $Param{Reminder}).'</a>',
        );
    }
    if ($Self->{UserID} == 1) {
        $Output .= $Self->Notify(
          Info => '<a href="$Env{"Baselink"}Action=AdminUser">'.
          $Self->{LanguageObject}->Get("Don't work with UserID 1 (System account)! Create new users!").'</a>',
        );
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentNavigationBar', Data => \%Param).$Output;
}
# --
sub QueueView {
    my $Self = shift;
    my %Param = @_;
    my $QueueID = $Param{QueueID} || 0;
    my @QueuesNew = @{$Param{Queues}};
    my $QueueIDOfMaxAge = $Param{QueueIDOfMaxAge} || -1;
    my %AllQueues = %{$Param{AllQueues}};
    my %Counter = (); 
    my %UsedQueue = (); 
    my @ListedQueues = ();
    my $Level = 0;
    $Param{SelectedQueue} = $AllQueues{$QueueID} || $Self->{ConfigObject}->Get('CustomQueue');
    my @MetaQueue = split(/::/, $Param{SelectedQueue});
    $Level = $#MetaQueue+2; 
    # --
    # prepare shown queues (short names)
    # - get queue total count -
    # --
    foreach my $QueueRef (@QueuesNew) {
        push (@ListedQueues, $QueueRef);
        my %Queue = %$QueueRef;
        my @Queue = split(/::/, $Queue{Queue});
        # --
        # remember counted/used queues
        # --
        $UsedQueue{$Queue{Queue}} = 1;
        # --
        # move to short queue names
        # --
        my $QueueName = '';
        foreach (0..$#Queue) {
            if (!$QueueName) {
                $QueueName .= $Queue[$_];
            }
            else {
                $QueueName .= '::'.$Queue[$_];
            }
            if (!$Counter{$QueueName}) {
                $Counter{$QueueName} = 0;
            }
            $Counter{$QueueName} = $Counter{$QueueName}+$Queue{Count};
            if ($Counter{$QueueName} && !$Queue{$QueueName} && !$UsedQueue{$QueueName}) {
                my %Hash = ();
                $Hash{Queue} = $QueueName; 
                $Hash{Count} = $Counter{$QueueName};
                foreach (keys %AllQueues) {
                    if ($AllQueues{$_} eq $QueueName) { 
                        $Hash{QueueID} = $_;
                    }
                }
                $Hash{MaxAge} = 0;
                push (@ListedQueues, \%Hash);
                $UsedQueue{$QueueName} = 1;
            }
        }
    }
    # build queue string
    foreach my $QueueRef (@ListedQueues) {
        my $QueueStrg = '';
        my %Queue = %$QueueRef;
        my @QueueName = split(/::/, $Queue{Queue});
        my $ShortQueueName = $QueueName[$#QueueName];
        $Queue{MaxAge} = $Queue{MaxAge} / 60;
        $Queue{QueueID} = 0 if (!$Queue{QueueID});
        # should i highlight this queue
        if ($Param{SelectedQueue} =~ /^$QueueName[0]/ && $Level-1 >= $#QueueName) {
            if ($#QueueName == 0 && $#MetaQueue >= 0 && $Queue{Queue} =~ /^$MetaQueue[0]$/) {
                $QueueStrg .= '<b>';
            }
            if ($#QueueName == 1 && $#MetaQueue >= 1 && $Queue{Queue} =~ /^$MetaQueue[0]::$MetaQueue[1]$/) {
               $QueueStrg .= '<b>';
            }
            if ($#QueueName == 2 && $#MetaQueue >= 2 && $Queue{Queue} =~ /^$MetaQueue[0]::$MetaQueue[1]::$MetaQueue[2]$/) {
               $QueueStrg .= '<b>';
            }
        }
        # --
        # remember to selected queue info
        # --
        if ($QueueID eq $Queue{QueueID}) {
           $Param{SelectedQueue} = $Queue{Queue};
           $Param{AllSubTickets} = $Counter{$Queue{Queue}};
           # --
           # build Page Navigator for AgentQueueView
           # --
           $Param{PageShown} = $Self->{ConfigObject}->Get('ViewableTickets');
           if ($Param{TicketsAvail} == 1 || $Param{TicketsAvail} == 0) {
               $Param{Result} = $Param{TicketsAvail};
           }
           elsif ($Param{TicketsAvail} >= ($Param{Start}+$Param{PageShown})) {
               $Param{Result} = $Param{Start}."-".($Param{Start}+$Param{PageShown}-1);
           }
           else {
               $Param{Result} = "$Param{Start}-$Param{TicketsAvail}";
           }
           my $Pages = int(($Param{TicketsAvail} / $Param{PageShown}) + 0.99999);
           my $Page = int(($Param{Start} / $Param{PageShown}) + 0.99999);
           for (my $i = 1; $i <= $Pages; $i++) {
               $Param{PageNavBar} .= " <a href=\"$Self->{Baselink}Action=\$Env{\"Action\"}".
                '&QueueID=$Data{"QueueID"}&Start='. (($i-1)*$Param{PageShown}+1) .= '">';
               if ($Page == $i) {
                   $Param{PageNavBar} .= '<b>'.($i).'</b>';
               }
               else {
                   $Param{PageNavBar} .= ($i);
               }
               $Param{PageNavBar} .= '</a> ';
           }
        }
        $QueueStrg .= "<a href=\"$Self->{Baselink}Action=AgentQueueView&QueueID=$Queue{QueueID}\"";
        $QueueStrg .= ' onmouseover="window.status=\'$Text{"Queue"}: '.$Queue{Queue}.'\'; return true;" onmouseout="window.status=\'\';">';
        # should i highlight this queue
        if ($Queue{MaxAge} >= $Self->{HighlightAge2}) {
            $QueueStrg .= "<font color='$Self->{HighlightColor2}'>";
        }
        elsif ($Queue{MaxAge} >= $Self->{HighlightAge1}) {
            $QueueStrg .= "<font color='$Self->{HighlightColor1}'>";
        }
        # the oldest queue
        if ($Queue{QueueID} == $QueueIDOfMaxAge) {
            $QueueStrg .= "<blink>";
        }
        # QueueStrg
        $QueueStrg .= "$ShortQueueName ($Counter{$Queue{Queue}})";
        # the oldest queue
        if ($Queue{QueueID} == $QueueIDOfMaxAge) {
            $QueueStrg .= "</blink>";
        }
        # should i highlight this queue
        if ($Queue{MaxAge} >= $Self->{HighlightAge1}
              || $Queue{MaxAge} >= $Self->{HighlightAge2}) {
            $QueueStrg .= "</font>";
        }
        $QueueStrg .= "</a>";
        # should i highlight this queue
        if ($Param{SelectedQueue} =~ /^$QueueName[0]/ && $Level >= $#QueueName) {
            if ($#QueueName == 0 && $#MetaQueue >= 0 && $Queue{Queue} =~ /^$MetaQueue[0]$/) {
                $QueueStrg .= '</b>';
            }
            if ($#QueueName == 1 && $#MetaQueue >= 1 && $Queue{Queue} =~ /^$MetaQueue[0]::$MetaQueue[1]$/) {
               $QueueStrg .= '</b>';
            }
            if ($#QueueName == 2 && $#MetaQueue >= 2 && $Queue{Queue} =~ /^$MetaQueue[0]::$MetaQueue[1]::$MetaQueue[2]$/) {
               $QueueStrg .= '</b>';
            }
        }

        if ($#QueueName == 0) {
            if ($Param{QueueStrg}) {
                $QueueStrg = ' - '.$QueueStrg;
            }
            $Param{QueueStrg} .= $QueueStrg;
        }
        elsif ($#QueueName == 1 && $Level >= 2 && $Queue{Queue} =~ /^$MetaQueue[0]::/) {
            if ($Param{QueueStrg1}) {
                $QueueStrg = ' - '.$QueueStrg;
            }
            $Param{QueueStrg1} .= $QueueStrg;
        }
        elsif ($#QueueName == 2 && $Level >= 3 && $Queue{Queue} =~ /^$MetaQueue[0]::$MetaQueue[1]::/) {
            if ($Param{QueueStrg2}) {
                $QueueStrg = ' - '.$QueueStrg;
            }
            $Param{QueueStrg2} .= $QueueStrg;
        }
    }
    if ($Param{QueueStrg1}) {
        $Param{QueueStrg} .= '<br>'.$Param{QueueStrg1};
    }
    if ($Param{QueueStrg2}) {
        $Param{QueueStrg} .= '<br>'.$Param{QueueStrg2};
    }
    # create & return output
    return $Self->Output(TemplateFile => 'QueueView', Data => \%Param);
}
# --
sub TicketView {
    my $Self = shift;
    my %Param = @_;
    # --
    # do some html quoting
    # --
    foreach (qw(From To Cc Subject)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 80) || '';
    }
    # --
    # create short html customer id
    # --
    $Param{CustomerIDHTML} = $Param{CustomerID} || '';
    foreach (qw(State Priority Lock)) {
        $Param{$_} = $Self->{LanguageObject}->Get($Param{$_});
    }
    foreach (qw(Priority State Queue Owner Lock CustomerIDHTML)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 15) || '';
    }
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ');
    # --
    # prepare escalation time
    # --
    if ($Param{Answered}) {
      $Param{TicketOverTime} = '$Text{"none - answered"}';
    } 
    elsif ($Param{TicketOverTime}) { 
      $Param{TicketOverTimeSuffix} = '';
      # colloring  
      $Param{TicketOverTimeFont} = '';
      $Param{TicketOverTimeFontEnd} = '';
      if ($Param{TicketOverTime} <= -60*20) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor2}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }
      elsif ($Param{TicketOverTime} <= -60*40) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor1}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }
      # create string
      $Param{TicketOverTime} = $Self->CustomerAge(
          Age => $Param{TicketOverTime}, 
          Space => '<br>',
      );
      $Param{TicketOverTime} = $Param{TicketOverTimeFont}.
        $Param{TicketOverTime}.$Param{TicketOverTimeFontEnd}; 
    }
    else {
      $Param{TicketOverTime} = '$Text{"none"}';
    }
    # --
    # customer info string 
    # --
    $Param{CustomerTable} = $Self->AgentCustomerViewTable(
        Data => $Param{CustomerData},
        Max => 15,
    );
    # --
    # check if just a only html email
    # --
    if (my $MimeTypeText = $Self->CheckMimeType(%Param, Action => 'AgentZoom')) {
        $Param{TextNote} = $MimeTypeText;
        $Param{Text} = '';
    }
    else {
        # --
        # do some text quoting
        # --
        $Param{Text} = $Self->Ascii2Html(
            NewLine => $Self->{ConfigObject}->Get('ViewableTicketNewLine') || 85,
            Text => $Param{Text}, 
            VMax => $Self->{ConfigObject}->Get('ViewableTicketLines') || 25,
        );
        # --
        # do link quoting
        # ---
        $Param{Text} = $Self->LinkQuote(Text => $Param{Text});
        # --
        # do charset check
        # --
        if (my $CharsetText = $Self->CheckCharset(
            Action => 'AgentZoom',
            ContentCharset => $Param{ContentCharset},
            TicketID => $Param{TicketID},
            ArticleID => $Param{ArticleID} )) {
            $Param{TextNote} = $CharsetText;
        } 
    }
    # --
    # get MoveQueuesStrg
    # --
    if ($Self->{ConfigObject}->Get('MoveType') =~ /^form$/i) {
        $Param{MoveQueuesStrg} = $Self->AgentQueueListOption(
            Name => 'DestQueueID',
            Data => $Param{MoveQueues},
            SelectedID => $Param{QueueID},
        );
    }
    # --
    # get StdResponsesStrg
    # --
    $Param{StdResponsesStrg} = $Self->TicketStdResponseString(
        StdResponsesRef => $Param{StdResponses},
        TicketID => $Param{TicketID},
        ArticleID => $Param{ArticleID},
    );
    if ($Self->{ConfigObject}->Get('AgentCanBeCustomer') && $Param{CustomerUserID} =~ /^$Self->{UserLogin}$/i) {
        $Param{TicketAnswer} = $Self->Output(
            TemplateFile => 'AgentZoomAgentIsCustomer', 
            Data => \%Param,
        );
    }
    else {
        $Param{TicketAnswer} = $Self->Output(
            TemplateFile => 'AgentZoomAnswer', 
            Data => \%Param,
        );
    }
    # --
    # create & return output
    # --
    if (!$Param{ViewType}) {
        return $Self->Output(TemplateFile => 'TicketView', Data => \%Param);
    }
    elsif ($Param{ViewType} eq 'TicketViewLite') {
        return $Self->Output(TemplateFile => 'TicketViewLite', Data => \%Param);
    }
    else {
        return $Self->Output(TemplateFile => 'TicketView', Data => \%Param);
    }
}
# --
sub AgentZoom {
    my $Self = shift;
    my %Param = @_;
    # --
    # create short html customer id
    # --
    $Param{CustomerIDHTML} = $Param{CustomerID} || '';
    if ($Param{Lock} =~ /unlock/) {
        $Param{Locked} = 2;
    }
    else {
        $Param{Locked} = 1;
    }
    # --
    # do some html quoting
    # --
    foreach (qw(State Priority Lock)) {
        $Param{$_} = $Self->{LanguageObject}->Get($Param{$_});
    }
    foreach (qw(Priority State Owner Queue CustomerIDHTML Lock)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 15) || '';
    }
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ');
    if ($Param{UntilTime}) {
        if ($Param{UntilTime} < -1) {
            $Param{PendingUntil} = "<font color='$Self->{HighlightColor2}'>";
        }
        $Param{PendingUntil} .= $Self->CustomerAge(Age => $Param{UntilTime}, Space => '<br>');
        if ($Param{UntilTime} < -1) {
            $Param{PendingUntil} .= "</font>";
        }
    }
    # --
    # prepare escalation time (if needed)
    # --
    if ($Param{Answered}) {
        $Param{TicketOverTime} = '$Text{"none - answered"}';
    }
    elsif ($Param{TicketOverTime}) { 
      $Param{TicketOverTimeSuffix} = '';
      # --
      # colloring  
      # --
      $Param{TicketOverTimeFont} = '';
      $Param{TicketOverTimeFontEnd} = '';
      if ($Param{TicketOverTime} <= -60*20) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor2}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }
      elsif ($Param{TicketOverTime} <= -60*40) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor1}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }

      $Param{TicketOverTime} = $Self->CustomerAge(
          Age => $Param{TicketOverTime}, 
          Space => '<br>',
      );
      $Param{TicketOverTime} = $Param{TicketOverTimeFont}.
        $Param{TicketOverTime}.$Param{TicketOverTimeFontEnd}; 
    }
    else {
        $Param{TicketOverTime} = '-';
    }
    # --
    # get MoveQueuesStrg
    # --
    if ($Self->{ConfigObject}->Get('MoveType') =~ /^form$/i) {
        $Param{MoveQueuesStrg} = $Self->AgentQueueListOption(
            Name => 'DestQueueID',
            Data => $Param{MoveQueues},
            SelectedID => $Param{QueueID},
        );
    }
    # --
    # customer info string 
    # --
    $Param{CustomerTable} = $Self->AgentCustomerViewTable(
        Data => $Param{CustomerData},
        Max => 15,
    );
    # --
    # build article stuff
    # --
    my $SelectedArticleID = $Param{ArticleID} || '';
    my $BaseLink = $Self->{Baselink} . "TicketID=$Self->{TicketID}&QueueID=$Self->{QueueID}&";
    my @ArticleBox = @{$Param{ArticleBox}};
    # --
    # get last customer article
    # --
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
    if (!$ArticleID) {
        $ArticleID = $LastCustomerArticleID;
    }
    # --
    # build thread string
    # --
    my $ThreadStrg = '';
    my $Counter = '';
    my $Space = '';
    my $LastSenderType = '';
    $Param{ArticleStrg} = '<table border="0" width="100%" cellspacing="0" cellpadding="0">';
    foreach my $ArticleTmp (@ArticleBox) {
      my %Article = %$ArticleTmp;
      if ($Article{ArticleType} !~ /^email-notification/i) {
        $ThreadStrg .= '<tr class="'.$Article{SenderType}.'-'.$Article{ArticleType}.'"><td class="small">';
        if ($LastSenderType ne $Article{SenderType}) {
            $Counter .= "&nbsp;&nbsp;&nbsp;&nbsp;";
            $Space = "$Counter |-->";
        }
        $LastSenderType = $Article{SenderType};
        $ThreadStrg .= "$Space";
        # --
        # if this is the shown article -=> add <b>
        # --
        if ($ArticleID eq $Article{ArticleID} ||
                 (!$ArticleID && $LastCustomerArticleID eq $Article{ArticleID})) {
            $ThreadStrg .= '>><B>';
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
        $ThreadStrg .= " $Article{CreateTime}";
#        $ThreadStrg .= "</table><BR>";
        # --
        # if this is the shown article -=> add </b>
        # --
        if ($ArticleID eq $Article{ArticleID} ||
                 (!$ArticleID && $LastCustomerArticleID eq $Article{ArticleID})) {
            $ThreadStrg .= '</B>';
        }
        $ThreadStrg .= '</td></tr>';
      }
    }
    $ThreadStrg .= '</table>';
    $Param{ArticleStrg} .= $ThreadStrg;

    my $ArticleOB = $ArticleBox[$LastCustomerArticle];
    my %Article = %$ArticleOB;
    my $Output = $Self->Output(TemplateFile => 'AgentZoomHead', Data => \%Param);
    $Param{TicketStatus} .= $Self->Output(TemplateFile => 'AgentZoomStatus', Data => \%Param);
    # --
    # get shown article(s)
    # --
    my @NewArticleBox = ();
    if (!$Self->{ConfigObject}->Get('TicketZoomExpand') || $Param{"ShowHTMLeMail"}) {
        foreach my $ArticleTmp (@ArticleBox) {
            if ($ArticleID eq $ArticleTmp->{ArticleID}) {
                push(@NewArticleBox, $ArticleTmp); 
            }
        }
    }
    else {
      # resort article order
      if ($Self->{ConfigObject}->Get('TicketZoomExpandSort') eq 'reverse') {
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
    my $BodyOutput = '';
    foreach my $ArticleTmp (@NewArticleBox) {
        %Article = %$ArticleTmp;
        # --
        # just body if html email
        # --
        if ($Param{"ShowHTMLeMail"}) {
            # generate output
            my $Output = "Content-Disposition: inline; filename=";
            $Output .= $Self->{ConfigObject}->Get('TicketHook')."-$Param{TicketNumber}-";
            $Output .= "$Param{TicketID}-$Article{ArticleID}\n";
            $Output .= "Content-Type: $Article{MimeType}; charset=$Article{ContentCharset}\n";
            $Output .= "\n";
            $Output .= $Article{"Body"};
            return $Output;
        }
        # --
        # delete ArticleStrg and TicketStatus if it's not the first shown article
        # --
        if ($BodyOutput) {
            $Param{ArticleStrg} = '';
            $Param{TicketStatus} = '';
        }
        # --
        # get StdResponsesStrg
        # --
        $Param{StdResponsesStrg} = $Self->TicketStdResponseString(
            StdResponsesRef => $Param{StdResponses},
            TicketID => $Param{TicketID},
            ArticleID => $Article{ArticleID},
        );
        # --
        # get attacment string
        # --
        my %AtmIndex = ();
        if ($Article{Atms}) {
            %AtmIndex = %{$Article{Atms}};
        }
        $Param{"Article::ATM"} = '';
        foreach (keys %AtmIndex) {
            $AtmIndex{$_} = $Self->Ascii2Html(Text => $AtmIndex{$_});
            $Param{"Article::ATM"} .= '<a href="$Env{"Baselink"}Action=AgentAttachment&'.
              "ArticleID=$Article{ArticleID}&FileID=$_\" target=\"attachment\" ".
              "onmouseover=\"window.status='\$Text{\"Download\"}: $AtmIndex{$_}';".
              ' return true;" onmouseout="window.status=\'\';">'.
              $AtmIndex{$_}.'</a><br> ';
        }
        # --
        # do some strips && quoting
        # --
        foreach (qw(To Cc From Subject FreeKey1 FreeKey2 FreeKey3 FreeValue1 FreeValue2 
            FreeValue3 ArticleType SenderType ArticleID)) {
            $Param{"Article::$_"} = $Self->Ascii2Html(Text => $Article{$_}, Max => 300);
        }
        # --
        # check if just a only html email
        # --
        if (my $MimeTypeText = $Self->CheckMimeType(%Param, %Article)) {
            $Param{"Article::TextNote"} = $MimeTypeText;
            $Param{"Article::Text"} = '';
        }
        else {
            # --
            # html quoting
            # --
            $Param{"Article::Text"} = $Self->Ascii2Html(
                NewLine => $Self->{ConfigObject}->Get('ViewableTicketNewLine') || 85,
                Text => $Article{Body},
                VMax => $Self->{ConfigObject}->Get('ViewableTicketLinesZoom') || 5000,
            );
            # --
            # link quoting
            # --
            $Param{"Article::Text"} = $Self->LinkQuote(Text => $Param{"Article::Text"});
            # --
            # do charset check
            # --
            if (my $CharsetText = $Self->CheckCharset(
                ContentCharset => $Article{ContentCharset},
                TicketID => $Param{TicketID},
                ArticleID => $Article{ArticleID} )) {
                $Param{"Article::TextNote"} = $CharsetText;
            }
        }
        # --
        # select the output template
        # --
        if ($Article{ArticleType} =~ /^note/i || 
             ($Article{ArticleType} =~ /^phone/i && $Article{SenderType} eq 'agent') ||
             $Article{SenderType} eq 'system' || $Article{SenderType} eq 'agent') {
            # without compose links!
            if ($Self->{ConfigObject}->Get('AgentCanBeCustomer') && $Param{CustomerUserID} =~ /^$Self->{UserLogin}$/i) {
              $Param{TicketAnswer} = $Self->Output(
                TemplateFile => 'AgentZoomAgentIsCustomer', 
                Data => \%Param,
              );
            }
            $Param{TicketArticle} = $Self->Output(
                TemplateFile => 'AgentZoomArticle', 
                Data => \%Param,
            );
            $BodyOutput .= $Self->Output(TemplateFile => 'AgentZoomBody', Data => \%Param);
        }
        else {
            # without all!
            if ($Self->{ConfigObject}->Get('AgentCanBeCustomer') && $Param{CustomerUserID} =~ /^$Self->{UserLogin}$/i) {
              $Param{TicketAnswer} = $Self->Output(
                TemplateFile => 'AgentZoomAgentIsCustomer', 
                Data => \%Param,
              );
            }
            else {
              $Param{TicketAnswer} = $Self->Output(
                TemplateFile => 'AgentZoomAnswer', 
                Data => \%Param,
              );
              $Param{TicketArticle} = $Self->Output(
                TemplateFile => 'AgentZoomArticle', 
                Data => \%Param,
              );
            }

#            $Param{TicketAnswer} .= $Self->Output(TemplateFile => 'AgentZoomAnswer', Data => \%Param);
            $BodyOutput .= $Self->Output(TemplateFile => 'AgentZoomBody', Data => \%Param);
        }
        $Param{TicketAnswer} = '';
        $Param{TicketArticle} = '';
    }
    $Output .= $BodyOutput;
    $Output .= $Self->Output(TemplateFile => 'AgentZoomFooter', Data => \%Param);
    # return output
    return $Output;
}
# --
sub AgentTicketPrintHeader {
    my $Self = shift;
    my %Param = @_;
    # --
    # do some html quoting
    # --
    foreach (qw(State Priority Lock)) {
        $Param{$_} = $Self->{LanguageObject}->Get($Param{$_});
    }
    foreach (qw(Priority State Owner Queue CustomerID Lock)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 25) || '';
    }
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ');
    if ($Param{UntilTime}) {
        $Param{PendingUntil} = $Self->CustomerAge(Age => $Param{UntilTime}, Space => ' ');
    }
    else {
        $Param{PendingUntil} = '-';
    }
    # --
    # prepare escalation time (if needed)
    # --
    if ($Param{Answered}) {
        $Param{TicketOverTime} = '$Text{"none - answered"}';
    }
    elsif ($Param{TicketOverTime}) { 
      $Param{TicketOverTime} = $Self->CustomerAge(
          Age => $Param{TicketOverTime}, 
          Space => ' ',
      );
    }
    else {
        $Param{TicketOverTime} = '-';
    }
    return $Self->Output(TemplateFile => 'AgentTicketPrintHeader', Data => \%Param);
}
# --
sub AgentTicketPrint {
    my $Self = shift;
    my %Param = @_;
    # --
    # build article stuff
    # --
    my $SelectedArticleID = $Param{ArticleID} || '';
    my @ArticleBox = @{$Param{ArticleBox}};
    # --
    # get last customer article
    # --
    my $Output = '';
    foreach my $ArticleTmp (@ArticleBox) {
        my %Article = %{$ArticleTmp};
        # --
        # get attacment string
        # --
        my %AtmIndex = ();
        if ($Article{Atms}) {
            %AtmIndex = %{$Article{Atms}};
        }
        $Param{"Article::ATM"} = '';
        foreach (keys %AtmIndex) {
          $AtmIndex{$_} = $Self->Ascii2Html(Text => $AtmIndex{$_});
          $Param{"Article::ATM"} .= '<a href="$Env{"Baselink"}Action=AgentAttachment&'.
            "ArticleID=$Article{ArticleID}&FileID=$_\" target=\"attachment\" ".
            "onmouseover=\"window.status='\$Text{\"Download\"}: $AtmIndex{$_}';".
             ' return true;" onmouseout="window.status=\'\';">'.
             $AtmIndex{$_}.'</a><br> ';
        }
        # --
        # do some strips && quoting
        # --
        foreach (qw(To Cc From Subject FreeKey1 FreeKey2 FreeKey3 FreeValue1 FreeValue2 
          FreeValue3 CreateTime SenderType ArticleType)) {
          $Param{"Article::$_"} = $Self->Ascii2Html(Text => $Article{$_}, Max => 300);
        }
        # --
        # check if just a only html email
        # --
        if (my $MimeTypeText = $Self->CheckMimeType(%Param, %Article, Action => 'AgentZoom')) {
            $Param{"Article::TextNote"} = $MimeTypeText;
            $Param{"Article::Text"} = '';
        }
        else {
            # --
            # html quoting
            # --
            $Param{"Article::Text"} = $Self->Ascii2Html(
                NewLine => $Self->{ConfigObject}->Get('ViewableTicketNewLine') || 85,
                Text => $Article{Body},
                VMax => $Self->{ConfigObject}->Get('ViewableTicketLinesZoom') || 5000,
            );
            # --
            # do charset check
            # --
            if (my $CharsetText = $Self->CheckCharset(
                Action => 'AgentZoom',
                ContentCharset => $Article{ContentCharset},
                TicketID => $Param{TicketID},
                ArticleID => $Article{ArticleID} )) {
                $Param{"Article::TextNote"} = $CharsetText;
            }
        }

        # get article id
        $Param{"Article::ArticleID"} = $Article{ArticleID};

        # select the output template
        if ($Article{ArticleType} ne 'email-notification-int') {
            $Output .= $Self->Output(TemplateFile => 'AgentTicketPrint', Data => \%Param);
        }
    }
    # return output
    return $Output;
}
# --
sub TicketStdResponseString {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # -- 
    foreach (qw(StdResponsesRef TicketID ArticleID)) {
        if (!$Param{$_}) {
            return "Need $_ in TicketStdResponseString()";
        } 
    }
    # --
    # get StdResponsesStrg
    # --
    if ($Self->{ConfigObject}->Get('StdResponsesMethod') eq 'Form') {
        # build html string
        $Param{StdResponsesStrg} .= '<form action="'.$Self->{CGIHandle}.'" method="post">'.
          '<input type="hidden" name="Action" value="AgentCompose">'.
          '<input type="hidden" name="ArticleID" value="'.$Param{ArticleID}.'">'.
          '<input type="hidden" name="TicketID" value="'.$Param{TicketID}.'">'.
          $Self->OptionStrgHashRef(
            Name => 'ResponseID',
            Data => $Param{StdResponsesRef},
          ).
          '<input class="button" type="submit" value="$Text{"Compose"}"></form>';
    }
    else {
        my %StdResponses = %{$Param{StdResponsesRef}};
        foreach (sort { $StdResponses{$a} cmp $StdResponses{$b} } keys %StdResponses) {
          # build html string
          $Param{StdResponsesStrg} .= "\n<li><a href=\"$Self->{Baselink}"."Action=AgentCompose&".
           "ResponseID=$_&TicketID=$Param{TicketID}&ArticleID=$Param{ArticleID}\" ".
           'onmouseover="window.status=\'$Text{"Compose"}\'; return true;" '.
           'onmouseout="window.status=\'\';">'.
           # html quote
           $Self->Ascii2Html(Text => $StdResponses{$_})."</A></li>\n";
        }
    }
    return $Param{StdResponsesStrg};
}
# --
sub TicketEscalation {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{Message} = 'Please go away!' if (!$Param{Message});

    # create output
    $Output .= $Self->Output(TemplateFile => 'TicketEscalation', Data => \%Param);

    # return output
    return $Output;
}
# --
sub ArticlePlain {
    my $Self = shift;
    my %Param = @_;

    # Ascii2Html
    $Param{Text} = $Self->Ascii2Html(Text => $Param{Text});

    # do some highlightings
    $Param{Text} =~ s/^((From|To|Cc|Subject|Reply-To|Organization|X-Company):.*)/<font color=\"red\">$1<\/font>/gm;
    $Param{Text} =~ s/^(Date:.*)/<FONT COLOR=777777>$1<\/font>/m;
    $Param{Text} =~ s/^((X-Mailer|User-Agent|X-OS):.*(Mozilla|Win?|Outlook|Microsoft|Internet Mail Service).*)/<blink>$1<\/blink>/gmi;
    $Param{Text} =~ s/(^|^<blink>)((X-Mailer|User-Agent|X-OS|X-Operating-System):.*)/<font color=\"blue\">$1$2<\/font>/gmi;
    $Param{Text} =~ s/^((Resent-.*):.*)/<font color=\"green\">$1<\/font>/gmi;
    $Param{Text} =~ s/^(From .*)/<font color=\"gray\">$1<\/font>/gm;
    $Param{Text} =~ s/^(X-OTRS.*)/<font color=\"#99BBDD\">$1<\/font>/gmi;

    # create & return output
    return $Self->Output(TemplateFile => 'AgentPlain', Data => \%Param);
}
# --
sub AgentNote {
    my $Self = shift;
    my %Param = @_;
    # --
    # build ArticleTypeID string
    # --
    $Param{'NoteStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NoteTypes},
        Name => 'NoteID',
    );
    # --
    # build next states string
    # -- 
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NewStateID',
    );
    # get output back
    return $Self->Output(TemplateFile => 'AgentNote', Data => \%Param);
}
# --
sub AgentBounce {
    my $Self = shift;
    my %Param = @_;
    # --
    # build next states string
    # --
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'BounceStateID',
        Selected => $Self->{ConfigObject}->Get('DefaultNextBounceType'),
    );
    # --
    # prepare 
    # --
    foreach (qw(ReplyTo To Cc Subject)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}) || '';
    }
    # create FromHTML (to show)
    $Param{FromHTML} = $Self->Ascii2Html(Text => $Param{From}, Max => 70);

    # get output back
    return $Self->Output(TemplateFile => 'AgentBounce', Data => \%Param);
}
# --
sub AgentPhone {
    my $Self = shift;
    my %Param = @_;
    # --
    # answered strg
    # --
    $Param{'AnsweredYesNoOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'Answered',
        Selected => 'Yes',
    );
    # --
    # build next states string
    # --
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NextStateID',
        Selected => $Self->{ConfigObject}->Get('PhoneDefaultNextState'),
    );
    # --
    # customer info string 
    # --
    $Param{CustomerTable} = $Self->AgentCustomerViewTable(
        Data => $Param{CustomerData},
        Max => 15,
    );
    # --
    # pending data string
    # --
    $Param{PendingDateString} = $Self->BuildDateSelection(%Param);
    # --
    # prepare errors!
    # --
    if ($Param{Errors}) {
        foreach (keys %{$Param{Errors}}) {
            $Param{$_} = "* ".$Self->Ascii2Html(Text => $Param{Errors}->{$_});
        }
    }
    # get output back
    return $Self->Output(TemplateFile => 'AgentPhone', Data => \%Param);
}
# --
sub AgentPhoneNew {
    my $Self = shift;
    my %Param = @_;
    # build string
    $Param{Users}->{''} = '-';
    $Param{'OptionStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{Users},
        SelectedID => $Param{UserSelected},
        Name => 'NewUserID',
    ); 
    # --
    # build next states string
    # --
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NextStateID',
        Selected => $Param{NextState} || $Self->{ConfigObject}->Get('PhoneDefaultNewNextState'),
    );
    # --
    # build from string
    # --
    if ($Param{FromOptions} && %{$Param{FromOptions}}) {
      $Param{'CustomerUserStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{FromOptions}, 
        Name => 'CustomerUser',
        Max => 70,
      ).'<br>$Env{"Box0"}<a href="" onclick="document.compose.ExpandCustomerName.value=\'2\'; document.compose.submit(); return false;" onmouseout="window.status=\'\';" onmouseover="window.status=\'$Text{"Take this User"}\'; return true;">$Text{"Take this User"}</a>$Env{"Box1"}';
    }
    # --
    # build so string
    # --
    my %NewTo = ();
    if ($Param{To}) {
        foreach (keys %{$Param{To}}) {
             $NewTo{"$_||$Param{To}->{$_}"} = $Param{To}->{$_};
        }
    }
    if ($Self->{ConfigObject}->Get('PhoneViewSelectionType') eq 'Queue') {
        $Param{'ToStrg'} = $Self->AgentQueueListOption(
            Data => \%NewTo,
            Multiple => 0,
            Size => 0,
            Name => 'Dest',
            SelectedID => 0,
            OnChangeSubmit => 0,
        );
    }
    else {
        $Param{'ToStrg'} = $Self->OptionStrgHashRef(
            Data => \%NewTo, 
            Name => 'Dest',
            SelectedID => $Param{ToSelected},
        );
    }
    # --
    # customer info string 
    # --
    $Param{CustomerTable} = $Self->AgentCustomerViewTable(
        Data => $Param{CustomerData},
        Max => 15,
    );
    # --
    # do html quoting
    # --
    foreach (qw(From To Cc)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}) || '';
    }
    # --
    # build priority string
    # --
    $Param{'PriorityStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{Priorities},
        Name => 'PriorityID',
        Selected => $Param{PriorityID} || $Self->{ConfigObject}->Get('PhoneDefaultPriority'),
    );
    # --
    # pending data string
    # --
    $Param{PendingDateString} = $Self->BuildDateSelection(%Param);
    # --
    # prepare errors!
    # --
    if ($Param{Errors}) {
        foreach (keys %{$Param{Errors}}) {
            $Param{$_} = "* ".$Self->Ascii2Html(Text => $Param{Errors}->{$_});
        }
    }
    # get output back
    return $Self->Output(TemplateFile => 'AgentPhoneNew', Data => \%Param);
}
# --
sub AgentFreeText {
    my $Self = shift;
    my %Param = @_;
    # create & return output
    return $Self->Output(TemplateFile => 'AgentFreeText', Data => \%Param);
}
# --
sub AgentPriority {
    my $Self = shift;
    my %Param = @_;
    # --
    # build ArticleTypeID string
    # --
    $Param{'OptionStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{OptionStrg},
        Name => 'PriorityID', 
        SelectedID => $Param{PriorityID},
    );
    # create & return output
    return $Self->Output(TemplateFile => 'AgentPriority', Data => \%Param);
}
# --
sub AgentCustomer {
    my $Self = shift;
    my %Param = @_;
    # --
    # do html quoting
    # --
    foreach (qw(CustomerUser CustomerID)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}) || '';
    }
    # --
    # build from string
    # --
    if ($Param{CustomerUserOptions} && %{$Param{CustomerUserOptions}}) {
      $Param{'CustomerUserStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{CustomerUserOptions},
        Name => 'CustomerUserOption',
        Max => 70,
      ).'$Env{"Box0"}<a href="" onclick="document.compose.ExpandCustomerName.value=\'2\'; document.compose.submit(); return false;" onmouseout="window.status=\'\';" onmouseover="window.status=\'$Text{"Take this User"}\'; return true;">$Text{"Take this User"}</a>$Env{"Box1"}';
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomer', Data => \%Param);
}
# --
sub AgentCustomerView {
    my $Self = shift;
    my %Param = @_;
    $Param{Table} = $Self->AgentCustomerViewTable(%Param);
    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomerView', Data => \%Param);
}
# --
sub AgentCustomerViewTable {
    my $Self = shift;
    my %Param = @_;
    if (ref($Param{Data}) eq 'HASH' && %{$Param{Data}}) {
        # build html table
        $Param{Table} = '<table>';
        foreach my $Field (@{$Self->{ConfigObject}->Get('CustomerUser')->{Map}}) {
            if ($Field->[3]) {
                $Param{Table} .= "<tr><td><b>\$Text{\"$Field->[1]\"}:</b></td><td>";
                if ($Field->[6]) {
                    $Param{Table} .= "<a href=\"$Field->[6]\">";
                }
                $Param{Table} .= $Self->Ascii2Html(Text => $Param{Data}->{$Field->[0]}, Max => $Param{Max});
                if ($Field->[6]) {
                    $Param{Table} .= "</a>";
                }
                $Param{Table} .= "</td></tr>";
            }
        }
        $Param{Table} .= '</table>';
    }
    else {
        $Param{Table} = '$Text{"none"}';
    }
    # create & return output
    return $Param{Table}; 
}
# --
sub AgentCustomerHistory {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomerHistory', Data => \%Param);
}
# --
sub AgentCustomerHistoryTable {
    my $Self = shift;
    my %Param = @_;
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ') || 0;
    # do html quoteing
    foreach (qw(State Queue Owner Lock)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 16);
    }
    foreach (qw(From Subject)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 20);
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomerHistoryTable', Data => \%Param);
}
# --
sub AgentOwner {
    my $Self = shift;
    my %Param = @_;

    # build string
    $Param{'OptionStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{OptionStrg},
        Selected => $Param{OwnerID},
        Name => 'NewUserID', 
        Size => 10,
    );

    # create & return output
    return $Self->Output(TemplateFile => 'AgentOwner', Data => \%Param);
}
# --
sub AgentPending {
    my $Self = shift;
    my %Param = @_;

    # build string
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStatesStrg},
        Name => 'CloseStateID'
    );
    # build string
    $Param{'NoteTypesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NoteTypesStrg},
        Name => 'CloseNoteID'
    );
    # get MoveQueuesStrg
    $Param{MoveQueuesStrg} = $Self->OptionStrgHashRef(
        Name => 'DestQueueID',
        SelectedID => $Param{SelectedMoveQueue},
        Data => $Param{MoveQueues},
        OnChangeSubmit => 0,
    );

    $Param{DateString} = $Self->BuildDateSelection(
        StartYear => 243 
    );

    # create & return output
    return $Self->Output(TemplateFile => 'AgentPending', Data => \%Param);
}
# --
sub AgentClose {
    my $Self = shift;
    my %Param = @_;

    # build string
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStatesStrg},
        Name => 'CloseStateID'
    );
    # build string
    $Param{'NoteTypesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NoteTypesStrg},
        Name => 'CloseNoteID'
    );
    # get MoveQueuesStrg
    $Param{MoveQueuesStrg} = $Self->OptionStrgHashRef(
        Name => 'DestQueueID',
        SelectedID => $Param{SelectedMoveQueue},
        Data => $Param{MoveQueues},
        OnChangeSubmit => 0,
    );

    # create & return output
    return $Self->Output(TemplateFile => 'AgentClose', Data => \%Param);
}
# --
sub AgentUtilForm {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # create & return output
    foreach (qw(From Subject Body)){
        $Param{$_.'CheckBox'} = 'checked';
    }
    $Param{'StatesStrg'} = $Self->OptionStrgHashRef(
        Data => { $Self->{DBObject}->GetTableData(
                      What => 'name, name',
                      Table => 'ticket_state',
                      Valid => 1,
                    ) }, 
        Name => 'State',
        Multiple => 1,
        Size => 5,
    );
    $Param{'QueuesStrg'} = $Self->AgentQueueListOption(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'queue',
            Valid => 1,
          )
        },
        Multiple => 1,
        Size => 5,
        Name => 'QueueID',
        OnChangeSubmit => 0,
    );
    $Param{'PriotitiesStrg'} = $Self->OptionStrgHashRef(
        Data => { $Self->{DBObject}->GetTableData(
                      What => 'id, name',
                      Table => 'ticket_priority',
                    ) }, 
        Name => 'PriorityID',
        Multiple => 1,
        Size => 5,
    );
    $Param{'UserStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{Users}, 
        Name => 'UserID',
        Multiple => 1,
        Size => 5,
    );
    $Output .= $Self->Output(TemplateFile => 'AgentUtilTicketStatus', Data => \%Param);
    $Output .= $Self->Output(TemplateFile => 'AgentUtilSearch', Data => \%Param);
    $Output .= $Self->Output(TemplateFile => 'AgentUtilSearchByCustomerID', Data => \%Param);
    return $Output;
}
# --
sub AgentUtilSearchAgain {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # create & return output
    if ($Self->{Subaction} eq 'CustomerID') {
      $Output .= $Self->Output(TemplateFile => 'AgentUtilSearchByCustomerID', Data => \%Param);
    }
    else {
      my @WhatFields = @{$Param{WhatFields}};
      foreach (@WhatFields) {
          $Param{$_.'CheckBox'} = 'checked';
      }
      $Param{'StatesStrg'} = $Self->OptionStrgHashRef(
        Data => { $Self->{DBObject}->GetTableData(
                      What => 'name, name',
                      Table => 'ticket_state',
                      Valid => 1,
                    ) }, 
        Name => 'State',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{SelectedStates},
      );
      $Param{'QueuesStrg'} = $Self->AgentQueueListOption(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'queue',
            Valid => 1,
          )
        },
        Size => 5,
        Multiple => 1,
        Name => 'QueueID',
        SelectedIDRefArray => $Param{SelectedQueueIDs},
        OnChangeSubmit => 0,
      );
      $Param{'PriotitiesStrg'} = $Self->OptionStrgHashRef(
        Data => { $Self->{DBObject}->GetTableData(
                      What => 'id, name',
                      Table => 'ticket_priority',
                    ) }, 
        Name => 'PriorityID',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{SelectedPriorityIDs},
      );
      $Param{'UserStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{Users}, 
        Name => 'UserID',
        Multiple => 1,
        Size => 5,
        SelectedIDRefArray => $Param{SelectedUserIDs},
      );

      $Output .= $Self->Output(TemplateFile => 'AgentUtilSearch', Data => \%Param);
    }
    return $Output;
}
# --
sub AgentUtilSearchResult {
    my $Self = shift;
    my %Param = @_;
    my $Highlight = $Param{Highlight} || 0;
    my $HighlightStart = '<font color="orange"><b><i>';
    my $HighlightEnd = '</i></b></font>';

    $Self->{UtilSearchResultCounter}++;

    # --
    # check if just a only html email
    # --
    if (my $MimeTypeText = $Self->CheckMimeType(
        %Param, 
        Text => $Param{Body}, 
        Action => 'AgentZoom',
    )) {
        $Param{TextNote} = $MimeTypeText;
        $Param{Body} = '';
    }
    else {
        # --
        # do some strips
        # --
        $Param{Body} =~ s/^\s*\n//mg;
        # --
        # do some text quoting
        # --
        $Param{Body} = $Self->Ascii2Html(
            NewLine => $Self->{ConfigObject}->Get('ViewableTicketNewLine') || 85,
            Text => $Param{Body},
            VMax => $Self->{ConfigObject}->Get('ViewableTicketLinesBySearch') || 15,
        );
        # --
        # do charset check
        # --
        if (my $CharsetText = $Self->CheckCharset(
            Action => 'AgentZoom',
            ContentCharset => $Param{ContentCharset},
            TicketID => $Param{TicketID},
            ArticleID => $Param{ArticleID} )) {
            $Param{TextNote} = $CharsetText;
        }
    }

    # do some html quoting
    foreach (qw(State Priority Lock)) {
        $Param{$_} = $Self->{LanguageObject}->Get($Param{$_});
    }
    foreach (qw(Priority State Queue Owner Lock CustomerID)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 15) || '';
    }
    foreach (qw(From To Cc Subject)) {
#        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 150) || '';
    }
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ');

    # do some html highlighting
    if ($Highlight) {
        my @SParts = split('%', $Param{What});
        foreach (qw(Body From To Subject)) {
            if ($_) {
                $Param{$_} =~ s/(${\(join('|', @SParts))})/$HighlightStart$1$HighlightEnd/gi;
            }
        } 
    }

    # create & return output
    return $Self->Output(TemplateFile => 'AgentUtilSearchResult', Data => \%Param);
}
# --
sub AgentUtilSearchCouter {
    my $Self = shift;
    my %Param = @_;
    my $Limit = $Param{Limit} || 0;
    $Param{AllHits} = 0 if (!$Param{AllHits});
    my $Pages = int(($Param{AllHits} / $Param{SearchPageShown}) + 0.99999);
    my $Page = int(($Param{StartHit} / $Param{SearchPageShown}) + 0.99999);
    # build Results (1-5 or 16-30)
    if ($Param{AllHits} >= ($Param{StartHit}+$Param{SearchPageShown})) {
        $Param{Results} = $Param{StartHit}."-".($Param{StartHit}+$Param{SearchPageShown}-1);
    }
    else {
        $Param{Results} = "$Param{StartHit}-$Param{AllHits}";
    }
    # check total hits
    if ($Limit == $Param{AllHits}) {
       $Param{TotalHits} = "<font color=red>$Param{AllHits}</font>";
    }
    else {
       $Param{TotalHits} = $Param{AllHits};
    }
    # build page nav bar
    for (my $i = 1; $i <= $Pages; $i++) {
        $Param{SearchNavBar} .= " <a href=\"$Self->{Baselink}Action=AgentUtilities&Subaction=".
         "$Self->{Subaction}&StartHit=". ((($i-1)*$Param{SearchPageShown})+1);
         foreach (@{$Param{WhatFields}}) {
             $Param{SearchNavBar} .= "&What=$_";
         }
         foreach (@{$Param{SelectedStates}}) {
             $Param{SearchNavBar} .= "&State=$_";
         }
         foreach (@{$Param{SelectedQueueIDs}}) {
             $Param{SearchNavBar} .= "&QueueID=$_";
         }
         foreach (@{$Param{SelectedPriorityIDs}}) {
             $Param{SearchNavBar} .= "&PriorityID=$_";
         }
         foreach (@{$Param{SelectedUserIDs}}) {
             $Param{SearchNavBar} .= "&UserID=$_";
         }
         if ($Param{TicketNumber}) {
             $Param{SearchNavBar} .= '&TicketNumber='.$Self->LinkEncode($Param{TicketNumber});
         }
         if ($Param{Want}) {
             $Param{SearchNavBar} .= '&Want='.$Self->LinkEncode($Param{Want});
         }
         $Param{SearchNavBar} .= '">';
         if ($Page == $i) {
             $Param{SearchNavBar} .= '<b>'.($i).'</b>';
         }
         else {
             $Param{SearchNavBar} .= ($i);
         }
         $Param{SearchNavBar} .= '</a> ';
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentUtilSearchNavBar', Data => \%Param);
}
# --
sub AgentCompose {
    my $Self = shift;
    my %Param = @_;
    # --
    # build next states string
    # --
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'ComposeStateID',
        Selected => $Param{NextState}
    );
    # --
    # build select string
    # --
    if ($Param{StdAttachments} && %{$Param{StdAttachments}}) {
      my %Data = %{$Param{StdAttachments}};
      $Param{'StdAttachmentsStrg'} = "<select name=\"StdAttachmentID\" size=2 multiple>\n";
      foreach (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
        if ((defined($_)) && ($Data{$_})) {
            $Param{'StdAttachmentsStrg'} .= '    <option selected value="'.$Self->Ascii2Html(Text => $_).'">'.
                  $Self->Ascii2Html(Text => $Self->{LanguageObject}->Get($Data{$_})) ."</option>\n";
        }
      }
      $Param{'StdAttachmentsStrg'} .= "</select>\n";
    }
    # --
    # answered strg
    # --
    if ($Param{AnsweredID}) {
        $Param{'AnsweredYesNoOption'} = $Self->OptionStrgHashRef(
            Data => $Self->{ConfigObject}->Get('YesNoOptions'),
            Name => 'Answered',
            SelectedID => $Param{AnsweredID},
        );
    }
    else {
        $Param{'AnsweredYesNoOption'} = $Self->OptionStrgHashRef(
            Data => $Self->{ConfigObject}->Get('YesNoOptions'),
            Name => 'Answered',
            Selected => 'Yes',
        );
    }
    # --
    # prepare 
    # --
    # create FromHTML (to show)
    $Param{FromHTML} = $Self->Ascii2Html(Text => $Param{From}, Max => 70);
    # do html quoting
    foreach (qw(ReplyTo From To Cc Subject Body)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}) || '';
    }
    # --
    # prepare errors!
    # --
    if ($Param{Errors}) {
        foreach (keys %{$Param{Errors}}) {
            $Param{$_} = "* ".$Self->Ascii2Html(Text => $Param{Errors}->{$_});
        }
    }
    # --
    # pending data string
    # --
    $Param{PendingDateString} = $Self->BuildDateSelection(%Param);
    # --
    # create & return output
    # --
    return $Self->Output(TemplateFile => 'AgentCompose', Data => \%Param);
}
# --
sub AgentForward {
    my $Self = shift;
    my %Param = @_;
    # --
    # build next states string
    # --
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'ComposeStateID'
    );

    $Param{'ArticleTypesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{ArticleTypes},
        Name => 'ArticleTypeID'
    );
    # --
    # prepare 
    # --
    # create html from
    $Param{SystemFromHTML} = $Self->Ascii2Html(Text => $Param{SystemFrom}, Max => 70);
    # do html quoting
    foreach (qw(ReplyTo From To Cc Subject SystemFrom Body)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}) || '';
    }
    # --
    # create & return output
    # --
    return $Self->Output(TemplateFile => 'AgentForward', Data => \%Param);
}
# --
sub AgentPreferencesForm {
    my $Self = shift;
    my %Param = @_;

    foreach my $Pref (sort keys %{$Self->{ConfigObject}->Get('PreferencesView')}) { 
      foreach my $Group (@{$Self->{ConfigObject}->Get('PreferencesView')->{$Pref}}) {
        if ($Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Activ}) {
          my $PrefKey = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{PrefKey} || '';
          my $Data = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Data};
          my $DataSelected = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{DataSelected} || '';
          my $Type = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Type} || '';
          my %PrefItem = %{$Self->{ConfigObject}->{PreferencesGroups}->{$Group}};
          if ($Data) {
            if (ref($Data) eq 'HASH') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                Data => $Data, 
                Name => 'GenericTopic',
                SelectedID => $Self->{$PrefKey} || $DataSelected, 
              );
            }
            else {
                $PrefItem{'Option'} = '<input type="text" name="GenericTopic" value="'.
                     $Self->Ascii2Html(Text => $Self->{$PrefKey}) .'">';
            }
          } 
          elsif ($Type eq 'CustomQueue') {
            # prepar custom selection
            $PrefItem{'Option'} = $Self->AgentQueueListOption(
                Data => $Param{QueueData},
                Size => 12,
                Name => 'QueueID',
                SelectedIDRefArray => $Param{CustomQueueIDs},
                Multiple => 1,
                OnChangeSubmit => 0,
            );
          }
          elsif ($PrefKey eq 'UserLanguage') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => $Self->{ConfigObject}->Get('DefaultUsedLanguages'),
                  Name => "GenericTopic",
                  SelectedID => $Self->{UserLanguage} || $Self->{ConfigObject}->Get('DefaultLanguage'),
              );
          }
          elsif ($PrefKey eq 'UserCharset') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => {
                    $Self->{DBObject}->GetTableData(
                      What => 'charset, charset',
                      Table => 'charset',
                      Valid => 1,
                    )
                  },
                  Name => 'GenericTopic',
                  Selected => $Self->{UserCharset} || $Self->{ConfigObject}->Get('DefaultCharset'),
              );
          }
          elsif ($PrefKey eq 'UserTheme') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => {
                    $Self->{DBObject}->GetTableData(
                      What => 'theme, theme',
                      Table => 'theme',
                      Valid => 1,
                    )
                  },
                  Name => 'GenericTopic',
                  Selected => $Self->{UserTheme} || $Self->{ConfigObject}->Get('DefaultTheme'),
              );
          }
          if ($Type eq 'Password' && ($Self->{ConfigObject}->Get('AuthModule') =~ /ldap/i ||
               $Self->{ConfigObject}->Get('DemoSystem'))) {
              # do nothing if the auth module is ldap
          }
          else {
              $Param{$Pref} .= $Self->Output(
                TemplateFile => 'AgentPreferences'.$Type, 
                Data => \%PrefItem, 
              );
          }
        }
      }
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentPreferencesForm', Data => \%Param);
}
# --
sub AgentMailboxTicket {
    my $Self = shift;
    my %Param = @_;
    # --
    # 
    # --
    $Param{Message} = $Self->{LanguageObject}->Get($Param{Message}).' ';
    # --
    # check if the pending ticket is Over Time
    # --
    if ($Param{UntilTime} < 0 && $Param{State} !~ /^pending auto/i) {
        $Param{Message} .= $Self->{LanguageObject}->Get('Timeover').' '.
          $Self->CustomerAge(Age => $Param{UntilTime}, Space => ' ').'!';
    }
    # --
    # create PendingUntil string if UntilTime is < -1
    # --
    if ($Param{UntilTime}) {
        if ($Param{UntilTime} < -1) {
            $Param{PendingUntil} = "<font color='$Self->{HighlightColor2}'>";
        }
        $Param{PendingUntil} .= $Self->CustomerAge(Age => $Param{UntilTime}, Space => '<br>');
        if ($Param{UntilTime} < -1) {
            $Param{PendingUntil} .= "</font>";
        }
    }
    # --
    # do some strips && quoting
    # --
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ');
    foreach (qw(To Cc From Subject)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 70);
    }
    foreach (qw(State Priority Lock)) {
        $Param{$_} = $Self->{LanguageObject}->Get($Param{$_});
    }
    # --
    # create short html customer id
    # --
    $Param{CustomerIDHTML} = $Param{CustomerID} || '';
    foreach (qw(State Priority Queue)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 18);
    }
    foreach (qw(CustomerIDHTML)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 10);
    }
    # --
    # create & return output
    # --
    return $Self->Output(TemplateFile => 'AgentMailboxTicket', Data => \%Param);
}
# --
sub AgentMailboxNavBar {
    my $Self = shift;
    my %Param = @_;
    # --
    # check lock count
    # --
    foreach (keys %{$Param{LockData}}) {
        $Param{$_} = $Param{LockData}->{$_} || 0;
    }
    # --
    # create & return output
    # --
    return $Self->Output(TemplateFile => 'AgentMailboxNavBar', Data => \%Param);
}
# --
sub AgentHistory {
    my $Self = shift;
    my %Param = @_;
    my @Lines = @{$Param{Data}};

    foreach my $Data (@Lines) {
      # --
      # html qouting
      # --
      foreach ('Name', 'HistoryType', 'CreateBy', 'CreateTime') {
        $$Data{$_} = $Self->Ascii2Html(Text => $$Data{$_}, Max => 100);
      }
      # --
      # get html string
      # --
      $Param{History} .= $Self->Output(TemplateFile => 'AgentHistoryRow', Data => $Data);
    }
    # --
    # create & return output
    # --
    return $Self->Output(TemplateFile => 'AgentHistoryForm', Data => \%Param);
}
# --
sub TicketLocked {
    my $Self = shift;
    my %Param = @_;
    return $Self->Output(TemplateFile => 'AgentTicketLocked', Data => \%Param);
}
# --
sub AgentMove {
    my $Self = shift;
    my %Param = @_;
    my %Data = %{$Param{MoveQueues}};
    my %UsedData = ();
    foreach my $ID (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
        my @Queue = split(/::/, $Data{$ID});
        $UsedData{$Data{$ID}} = 1;
        my $UpQueue = $Data{$ID}; 
        $UpQueue =~ s/^(.*)::.+?$/$1/g;
        $Queue[$#Queue] = $Self->Ascii2Html(Text => $Queue[$#Queue], Max => 50-$#Queue);
        my $Space = '|';
        if ($#Queue == 0) {
            $Space .= '--';
        }
        for (my $i = 0; $i < $#Queue; $i++) {
#            $Space .= '&nbsp;&nbsp;&nbsp;&nbsp;';
            if ($#Queue == 1) {
                $Space .= '&nbsp;&nbsp;&nbsp;&nbsp;|--';
            }
            elsif ($#Queue == 2 && $i == $#Queue-1) {
                my $Hit = 0;
                foreach (keys %Data) {
                    my @Queue = split(/::/, $Data{$_});
                    my $QueueName = '';
                    for (my $i = 0; $i < $#Queue-1; $i++) {
                        if (!$QueueName) {
                            $QueueName .= $Queue[$i].'::';
                        }
#                        else {
#                            $QueueName .= '::'.$Queue[$i];
#                        }
                    }
#                    my $SecondLevel = $Queue[0].'::'.$Queue[1];
#print STDERR "$Data{$ID} ($QueueName) $#Queue--\n";
                    if ($#Queue == 1 && $QueueName && $Data{$ID} =~ /^$QueueName/) { 
#print STDERR "sub queue of $Data{$ID} ($QueueName) exists\n";
                        $Hit = 1;
                    }
                }
                if ($Hit) {
                    $Space .= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|--';
                }
                else {
                    $Space .= '&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;|--';
                }
            }
        }
        if ($UsedData{$UpQueue}) {

#         $Param{MoveQueuesStrg} .= "$Space<a href=\"$Self->{Baselink}Action=AgentMove&TicketID=$Param{TicketID}&DestQueueID=$ID\">".
#                $Queue[$#Queue].'</a><br>';
         $Param{MoveQueuesStrg} .= "$Space<a href=\"\" onclick=\"document.compose.DestQueueID.value='$ID'; document.compose.submit(); return false;\">".
                 $Queue[$#Queue].'</a><br>';
        }
        delete $Data{$ID};
    }
    # --
    # build next states string
    # -- 
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NewStateID',
#        Selected => $Param{State},
    );
    # --
    # build owner string
    # --
    $Param{'OwnerStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{OwnerList},
#        Selected => $Param{OwnerID},
        Name => 'NewUserID',
#       Size => 5,
    );
    return $Self->Output(TemplateFile => 'AgentMove', Data => \%Param);
}
# --
sub AgentStatusView {
    my $Self = shift;
    my %Param = @_;
    if ($Param{AllHits} == 1 || $Param{AllHits} == 0) {
               $Param{Result} = $Param{AllHits};
    }
    elsif ($Param{AllHits} >= ($Param{StartHit}+$Param{PageShown})) {
        $Param{Result} = $Param{StartHit}."-".($Param{StartHit}+$Param{PageShown}-1);
    }
    else {
        $Param{Result} = "$Param{StartHit}-$Param{AllHits}";
    }
    my $Pages = int(($Param{AllHits} / $Param{PageShown}) + 0.99999);
    my $Page = int(($Param{StartHit} / $Param{PageShown}) + 0.99999);
    for (my $i = 1; $i <= $Pages; $i++) {
        $Param{PageNavBar} .= " <a href=\"$Self->{Baselink}Action=\$Env{\"Action\"}".
         "&StartHit=". (($i-1)*$Param{PageShown}+1) .= '&SortBy=$Data{"SortBy"}&Order=$Data{"Order"}">';
        if ($Page == $i) {
            $Param{PageNavBar} .= '<b>'.($i).'</b>';
        }
        else {
            $Param{PageNavBar} .= ($i);
        }
#         if ((int($Param{StartHit}+$Self->{UtilSearchResultCounter})/$Param{PageShown}) == ($i)) {
         $Param{PageNavBar} .= '</a> ';
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentStatusView', Data => \%Param);
}
# --  
sub AgentStatusViewTable {
    my $Self = shift;
    my %Param = @_;
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ') || 0;
    foreach (qw(State Lock)) {
        $Param{$_} = $Self->{LanguageObject}->Get($Param{$_});
    }
    # do html quoteing
    foreach (qw(State Queue Owner Lock CustomerID)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 10) || '';
    }
    foreach (qw(From To Cc Subject)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 30) || '';
    }
    # create & return output
    if (!$Param{Answered}) {
        return $Self->Output(TemplateFile => 'AgentStatusViewTableNotAnswerd', Data => \%Param);
    }
    else {
        return $Self->Output(TemplateFile => 'AgentStatusViewTable', Data => \%Param);
    }
}
# --
sub AgentSpelling {
    my $Self = shift;
    my %Param = @_;
    # --
    # do html quoteing
    # --
    foreach (qw(Body)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_});
    }
    # --
    # spellcheck
    # --
    if ($Param{SpellCheck}) {
      $Param{SpellCheckString} = '<table border="0" width="580" cellspacing="0" cellpadding="1">'.
        '<tr><th width="50">$Text{"Line"}</th><th width="100">$Text{"Word"}</th>'.
        '<th width="330"colspan="2">$Text{"replace with"}</th>'.
        '<th width="50">$Text{"Change"}</th><th width="50">$Text{"Ignore"}</th></tr>';
      $Param{SpellCounter} = 0;
      foreach (sort {$a <=> $b} keys %{$Param{SpellCheck}}) {
        my $WrongWord = $Param{SpellCheck}->{$_}->{Word};
        if ($WrongWord) {
          $Param{SpellCounter} ++;
          if ($Param{SpellCounter} <= 300) {
            $Param{SpellCheckString} .= "<tr><td align='center'>$Param{SpellCheck}->{$_}->{Line}</td><td><font color='red'>$WrongWord</font></td><td>";
            my %ReplaceWords = ();
            if ($Param{SpellCheck}->{$_}->{Replace}) {
              foreach my $ReplaceWord (@{$Param{SpellCheck}->{$_}->{Replace}}) {
                $ReplaceWords{$WrongWord."::".$ReplaceWord} = $ReplaceWord;
              }
            }
            else {
                $ReplaceWords{$WrongWord.'::0'} = 'No suggestions';
            }
            $Param{SpellCheckString}  .= $Self->OptionStrgHashRef(
               Data => \%ReplaceWords, 
               Name => "SpellCheckReplace",
               OnChange => "change_selected($Param{SpellCounter})"
            ).
              '</td><td> or '.
              '<input type="text" name="SpellCheckOrReplace::'.$WrongWord.'" value="" size="16" onchange="change_selected('.$Param{SpellCounter}.')">'.
              '</td><td align="center">'.
              '<input type="radio" name="SpellCheck::'.$WrongWord.'" value="Replace">'.
              '</td><td align="center">'.
              '<input type="radio" name="SpellCheck::'.$WrongWord.'" value="Ignore" checked="checked">'.
              '</td></tr>'."\n";
          }
        }
      } 
      $Param{SpellCheckString} .= '</table>';
      if ($Param{SpellCounter} == 0) {
        $Param{SpellCheckString} = '';
      }
    }
    # --
    # dict language selection
    # --
    $Param{SpellLanguageString}  .= $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('PreferencesGroups')->{SpellDict}->{Data},
        Name => "SpellLanguage",
        SelectedID => $Param{SpellLanguage},
    );
    # --
    # create & return output
    # --
    return $Self->Output(TemplateFile => 'AgentSpelling', Data => \%Param);
}
# --  
sub AgentQueueListOption {
    my $Self = shift;
    my %Param = @_;
    my $Size = defined($Param{Size}) ? "size='$Param{Size}'" : ''; 
    my $MaxLevel = defined($Param{MaxLevel}) ? $Param{MaxLevel} : 10;
    my $SelectedID = defined($Param{SelectedID}) ? $Param{SelectedID} : '';
    my $Selected = defined($Param{Selected}) ? $Param{Selected} : '';
    my $SelectedIDRefArray = $Param{SelectedIDRefArray} || '';
    my $Multiple = $Param{Multiple} ? 'multiple' : '';
    my $OnChangeSubmit = defined($Param{OnChangeSubmit}) ? $Param{OnChangeSubmit} : 
     $Self->{ConfigObject}->Get('OnChangeSubmit');
    if ($OnChangeSubmit) {
        $OnChangeSubmit = " onchange=\"submit()\"";
    }
    $Param{MoveQueuesStrg} = '<select name="'.$Param{Name}."\" $Size $Multiple $OnChangeSubmit>";
    my %UsedData = ();
    my %Data = %{$Param{Data}};
    foreach (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
      my @Queue = split(/::/, $Param{Data}->{$_});
      $UsedData{$Param{Data}->{$_}} = 1;
      my $UpQueue = $Param{Data}->{$_};
      $UpQueue =~ s/^(.*)::.+?$/$1/g;
      if (! $Queue[$MaxLevel]) {
        $Queue[$#Queue] = $Self->Ascii2Html(Text => $Queue[$#Queue], Max => 50-$#Queue);
        my $Space = '';
        for (my $i = 0; $i < $#Queue; $i++) {
            $Space .= '&nbsp;&nbsp;';
        }
        # check if SelectedIDRefArray exists
        if ($SelectedIDRefArray) {
            foreach my $ID (@{$SelectedIDRefArray}) {
                if ($ID eq $_) {
                    $Param{SelectedIDRefArrayOK}->{$_} = 1;
                }
            }
        }
        # build select string
        if ($UsedData{$UpQueue}) {
          if ($SelectedID eq $_ || $Selected eq $Param{Data}->{$_} || $Param{SelectedIDRefArrayOK}->{$_}) {
            $Param{MoveQueuesStrg} .= '<option selected value="'.$_.'">'.
                $Space.$Queue[$#Queue].'</option>';
          }
          else {
            $Param{MoveQueuesStrg} .= '<option value="'.$_.'">'.
                $Space.$Queue[$#Queue].'</option>';
          }
        }
      }
    }
    $Param{MoveQueuesStrg} .= '</select>';

    return $Param{MoveQueuesStrg};
}
# --
sub AgentCustomerMessage {
    my $Self = shift;
    my %Param = @_;
    # get output back
    my $Output .= $Self->Notify(
        Info => 
          $Self->{LanguageObject}->Get('You are the customer user of this message - customer modus!'), 
    );
    return $Output.$Self->Output(TemplateFile => 'AgentCustomerMessage', Data => \%Param);
}   
# --

1;
