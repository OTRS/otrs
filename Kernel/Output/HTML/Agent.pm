# --
# HTML/Agent.pm - provides generic agent HTML output
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Agent.pm,v 1.76 2003-01-09 20:43:19 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Agent;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.76 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    my $QueueStrg = '';
    my $QueueID = $Param{QueueID} || 0;
    my @QueuesNew = @{$Param{Queues}};
    my $QueueIDOfMaxAge = $Param{QueueIDOfMaxAge} || -1;
 
    # build queue string
    foreach my $QueueRef (@QueuesNew) {
        my %Queue = %$QueueRef;
        $Queue{MaxAge} = $Queue{MaxAge} / 60;
        # should i highlight this queue
        if ($QueueID eq $Queue{QueueID}) {
           $QueueStrg .= '<b>';
           $Param{SelectedQueue} = $Queue{Queue};
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
        $QueueStrg .= "$Queue{Queue} ($Queue{Count})";
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
        if ($QueueID eq $Queue{QueueID}) {
           $QueueStrg .= '</b>';
        }
        $QueueStrg .= ' - ';
    }
    $Param{QueueStrg} = $QueueStrg;

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
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 150) || '';
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
    $Param{MoveQueuesStrg} = $Self->OptionStrgHashRef(
        Name => 'DestQueueID',
        SelectedID => $Param{QueueID},
        Data => $Param{MoveQueues},
        OnChangeSubmit => $Self->{ConfigObject}->Get('OnChangeSubmit'),
    );
    # --
    # get StdResponsesStrg
    # --
    $Param{StdResponsesStrg} = $Self->TicketStdResponseString(
        StdResponsesRef => $Param{StdResponses},
        TicketID => $Param{TicketID},
        ArticleID => $Param{ArticleID},
    );
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
sub TicketZoom {
    my $Self = shift;
    my %Param = @_;
    # --
    # create short html customer id
    # --
    $Param{CustomerIDHTML} = $Param{CustomerID} || '';
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
    $Param{MoveQueuesStrg} = $Self->OptionStrgHashRef(
        Name => 'DestQueueID',
        SelectedID => $Param{QueueID},
        Data => $Param{MoveQueues},
        OnChangeSubmit => $Self->{ConfigObject}->Get('OnChangeSubmit'),
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
    # get StdResponsesStrg
    # --
    $Param{StdResponsesStrg} = $Self->TicketStdResponseString(
        StdResponsesRef => $Param{StdResponses},
        TicketID => $Param{TicketID},
        ArticleID => $ArticleID,
    );
    # --
    # build thread string
    # --
    my $ThreadStrg = '';
    my $Counter = '';
    my $Space = '';
    my $LastSenderType = '';
    $Param{ArticleStrg} = '';
    foreach my $ArticleTmp (@ArticleBox) {
      my %Article = %$ArticleTmp;
      if ($Article{ArticleType} ne 'email-notification-int') {
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
            $ThreadStrg .= ">><B>";
        }
        # --
        # the full part thread string
        # --
        $ThreadStrg .= "<a href=\"$BaseLink"."Action=AgentZoom&ArticleID=$Article{ArticleID}\"" .
           'onmouseover="window.status=\''."$Article{SenderType} ($Article{ArticleType})".
           '\'; return true;" onmouseout="window.status=\'\';">'.
           "$Article{SenderType} ($Article{ArticleType})</a> ";
        if ($Article{ArticleType} =~ /^email/) {
            $ThreadStrg .= " (<a href=\"$BaseLink"."Action=AgentPlain&ArticleID=$Article{ArticleID}\"".
             'onmouseover="window.status=\''.$Self->{LanguageObject}->Get('plain').
             '\'; return true;" onmouseout="window.status=\'\';">'.
            $Self->{LanguageObject}->Get('plain') . "</a>)";
        }
        $ThreadStrg .= " $Article{CreateTime}";
        $ThreadStrg .= "<BR>";
        # --
        # if this is the shown article -=> add </b>
        # --
        if ($ArticleID eq $Article{ArticleID} ||
                 (!$ArticleID && $LastCustomerArticleID eq $Article{ArticleID})) {
            $ThreadStrg .= "</B>";
        }
      }
    }
    $ThreadStrg .= '';
    $Param{ArticleStrg} .= $ThreadStrg;

    my $ArticleOB = $ArticleBox[$LastCustomerArticle];
    my %Article = %$ArticleOB;

    foreach my $ArticleTmp (@ArticleBox) {
        my %ArticleTmp1 = %$ArticleTmp;
        if ($ArticleID eq $ArticleTmp1{ArticleID}) {
            %Article = %ArticleTmp1;
        }
    }
    # --
    # get attacment string
    # --
    my %AtmIndex = ();
    if ($Article{Atms}) {
        %AtmIndex = %{$Article{Atms}};
    }
    my $ATMStrg = '';
    foreach (keys %AtmIndex) {
        $AtmIndex{$_} = $Self->Ascii2Html(Text => $AtmIndex{$_});
        $Param{"Article::ATM"} .= '<a href="$Env{"Baselink"}Action=AgentAttachment&'.
          "ArticleID=$Article{ArticleID}&FileID=$_\" target=\"attachment\" ".
          "onmouseover=\"window.status='\$Text{\"Download\"}: $AtmIndex{$_}';".
           ' return true;" onmouseout="window.status=\'\';">'.
           $AtmIndex{$_}.'</a><br> ';
    }
    # --
    # just body if html email
    # --
    if ($Param{"ShowHTMLeMail"}) {
        # generate output
        my $Output = "Content-Disposition: attachment; filename=";
        $Output .= $Self->{ConfigObject}->Get('TicketHook')."-$Param{TicketNumber}-";
        $Output .= "$Param{TicketID}-$Article{ArticleID}\n";
        $Output .= "Content-Type: $Article{MimeType}; charset=$Article{ContentCharset}\n";
        $Output .= "\n";
        $Output .= $Article{"Text"};
        return $Output;
    }
    # --
    # do some strips && quoting
    # --
    foreach (qw(To Cc From Subject FreeKey1 FreeKey2 FreeKey3 FreeValue1 FreeValue2 FreeValue3)) {
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
            Text => $Article{Text},
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

    # get article id
    $Param{"Article::ArticleID"} = $Article{ArticleID};

    # select the output template
    my $Output = '';
    if ($Article{ArticleType} =~ /^note/i || 
         ($Article{ArticleType} =~ /^phone/i && $Article{SenderType} eq 'agent')) {
        # without compose links and with From ans Subject only!
        $Output = $Self->Output(TemplateFile => 'TicketZoomNote', Data => \%Param);
    }
    elsif ($Article{SenderType} eq 'system' || $Article{SenderType} eq 'agent') {
        # without compose links!
        $Output = $Self->Output(TemplateFile => 'TicketZoomSystem', Data => \%Param);
    }
    else {
        # without all!
        $Output = $Self->Output(TemplateFile => 'TicketZoom', Data => \%Param);
    }
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
        my $ATMStrg = '';
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
                Text => $Article{Text},
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
          '<input type="submit" value="$Text{"Compose"}"></form>';
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

    # build ArticleTypeID string
    $Param{'NoteStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NoteTypes},
        Name => 'NoteID',
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
    # --
    # build next states string
    # --
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NextStateID',
        Selected => $Param{NextState} || $Self->{ConfigObject}->Get('PhoneDefaultNewNextState'),
    );
    my %NewTo = ();
    if ($Param{To}) {
        foreach (keys %{$Param{To}}) {
             $NewTo{"$_||$Param{To}->{$_}"} = $Param{To}->{$_};
        }
    }
    $Param{'ToStrg'} = $Self->OptionStrgHashRef(
        Data => \%NewTo, 
        Name => 'Dest',
        SelectedID => $Param{ToSelected},
    );
    # --
    # build priority string
    # --
    if ($Param{PriorityID}) { 
      $Param{'PriorityStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{Priorities},
        Name => 'PriorityID',
        SelectedID => $Param{PriorityID},
      );
    } else {
      $Param{'PriorityStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{Priorities},
        Name => 'PriorityID',
        Selected => $Self->{ConfigObject}->Get('PhoneDefaultPriority') || '3 normal',
      );
    }
    # --
    # build customer string
    # --
    if ($Self->{ConfigObject}->Get('ShowCustomerSelection')) {
        $Param{CustomerList}->{''} = '-';
        $Param{'CustomerStrg'} = $Self->OptionStrgHashRef(
            Data => $Param{CustomerList},
            Name => 'CustomerIDSelection',
            SelectedID => $Param{CustomerIDSelection},
        );
    }
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
    # build customer string
    if ($Self->{ConfigObject}->Get('ShowCustomerSelection')) {
        $Param{CustomerList}->{''} = '-';
        $Param{'CustomerStrg'} = $Self->OptionStrgHashRef(
            Data => $Param{CustomerList},
            Name => 'CustomerIDSelection',
        );
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomer', Data => \%Param);
}
# --
sub AgentCustomerView {
    my $Self = shift;
    my %Param = @_;
    if (%{$Param{Data}}) {
        # build html table
        $Param{Table} = '<table>';
        foreach my $Field (@{$Self->{ConfigObject}->Get('CustomerUser')->{Map}}) {
            if ($Field->[3]) {
                $Param{Table} .= "<tr><td>\$Text{\"$Field->[1]\"}:</td><td>".$Param{Data}->{$Field->[0]}."</td></tr>";
            }
        }
        $Param{Table} .= '</table>';
    }
    else {
        $Param{Table} = '$Text{"None"}';
    }
    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomerView', Data => \%Param);
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
        SelectedIDRefArray => ['open', 'new'],
    );

    $Output .= $Self->Output(TemplateFile => 'AgentUtilSearchByTicketNumber', Data => \%Param);
    $Output .= $Self->Output(TemplateFile => 'AgentUtilSearchByText', Data => \%Param);
    $Output .= $Self->Output(TemplateFile => 'AgentUtilSearchByCustomerID', Data => \%Param);
    $Output .= $Self->Output(TemplateFile => 'AgentUtilTicketStatus', Data => \%Param);
    return $Output;
}
# --
sub AgentUtilSearchAgain {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # create & return output
    if ($Self->{Subaction} eq 'SearchByTn') {
      $Output .= $Self->Output(TemplateFile => 'AgentUtilSearchByTicketNumber', Data => \%Param);
    }
    elsif ($Self->{Subaction} eq 'CustomerID') {
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
      $Output .= $Self->Output(TemplateFile => 'AgentUtilSearchByText', Data => \%Param);
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
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 150) || '';
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
    $Param{Results} = ($Param{StartHit}+1)."-".($Param{StartHit}+$Self->{UtilSearchResultCounter});
    if ($Limit == $Param{AllHits}) {
       $Param{TotalHits} = "<font color=red>$Param{AllHits}</font>";
    }
    else {
       $Param{TotalHits} = $Param{AllHits};
    }

    my $Pages = $Param{AllHits} / $Param{SearchPageShown};
    for (my $i = 1; $i < ($Pages+1); $i++) {
        $Param{SearchNavBar} .= " <a href=\"$Self->{Baselink}Action=AgentUtilities&Subaction=".
         "$Self->{Subaction}&StartHit=". (($i-1)*$Param{SearchPageShown});
         if ($Param{WhatFields}) {
             foreach (@{$Param{WhatFields}}) {
                 $Param{SearchNavBar} .= "&What=$_";
             }
             foreach (@{$Param{SelectedStates}}) {
                 $Param{SearchNavBar} .= "&State=$_";
             }
         }
         $Param{SearchNavBar} .= '&Want='.$Self->LinkEncode($Param{Want});
         $Param{SearchNavBar} .= '">';
         if ((int($Param{StartHit}+$Self->{UtilSearchResultCounter})/$Param{SearchPageShown}) == ($i)) {
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
    my %Data = %{$Param{StdAttachments}};
    if (%Data) {
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
          my $Type = $Self->{ConfigObject}->{PreferencesGroups}->{$Group}->{Type} || '';
          my %PrefItem = %{$Self->{ConfigObject}->{PreferencesGroups}->{$Group}};
          if ($Data) {
            $PrefItem{'Option'} = $Self->OptionStrgHashRef(
              Data => $Data, 
              Name => 'GenericTopic',
              SelectedID => $Self->{$PrefKey}, 
            );
          } 
          elsif ($Type eq 'CustomQueue') {
            my @CustomQueueIDs = $Self->{QueueObject}->GetAllCustomQueues(UserID => $Self->{UserID});
            # prepar custom selection
            my @CustomQueueIDsTmp = @{$Param{CustomQueueIDs}};
            my %QueueDataTmp = %{$Param{QueueData}}; 
            $PrefItem{'Option'} = '';
            foreach my $ID (sort keys %QueueDataTmp) {
              my $Mach = 0;
              foreach (@CustomQueueIDsTmp) {
                if ($_ eq $ID) {
                  $PrefItem{'Option'} .= "<OPTION selected VALUE=\"$ID\">$QueueDataTmp{$ID}\n";
                  $Mach = 1;
                }
              }
              $PrefItem{'Option'} .= "<OPTION VALUE=\"$ID\">$QueueDataTmp{$ID}\n" if (!$Mach);
            }
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
    foreach (qw(State Priority Queue CustomerID)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 20);
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
        $$Data{$_} = $Self->Ascii2Html(Text => $$Data{$_});
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
sub AgentStatusView {
    my $Self = shift;
    my %Param = @_;

    # create & return output
    return $Self->Output(TemplateFile => 'AgentStatusView', Data => \%Param);
}
# --  
sub AgentStatusViewTable {
    my $Self = shift;
    my %Param = @_;
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ') || 0;
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
               CoChange => "change_selected($Param{SpellCounter})"
            ).
              '</td><td> or '.
              '<input type="text" name="SpellCheckOrReplace::'.$WrongWord.'" value="" size="16" onchange="change_selected('.$Param{SpellCounter}.')">'.
              '</td><td align="center">'.
              '<input type="radio" name="SpellCheck::'.$WrongWord.'" value="Replace">'.
              '</td><td align="center">'.
              '<input type="radio" name="SpellCheck::'.$WrongWord.'" value="Ignore" checked="checked">'.
              '</td></tr>';
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
    my %Languages = ( 'English' => 'English', 'German' => 'German' );
    $Param{SpellLanguageString}  .= $Self->OptionStrgHashRef(
        Data => \%Languages,
        Name => "SpellLanguage",
        Selected => $Param{SpellLanguage}, 
    );
    # --
    # create & return output
    # --
    return $Self->Output(TemplateFile => 'AgentSpelling', Data => \%Param);
}
# --  

1;
 
