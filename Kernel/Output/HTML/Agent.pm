# --
# HTML/Agent.pm - provides generic agent HTML output
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Agent.pm,v 1.55 2002-10-20 23:22:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::Agent;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.55 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub NavigationBar {
    my $Self = shift;
    my %Param = @_;

    my $LockData = $Param{LockData};
    my %LockDataTmp = %$LockData;
    $Param{LockCount} = $LockDataTmp{Count} || 0;
    $Param{LockToDo} = $LockDataTmp{ToDo} || 0;

    # create & return output
    return $Self->Output(TemplateFile => 'AgentNavigationBar', Data => \%Param);
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
        $QueueStrg .= "<a href=\"$Self->{Baselink}Action=AgentQueueView&QueueID=$Queue{QueueID}\">";
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
    my %StdResponses = %{$Param{StdResponses}};

    # do some html quoting
    foreach (qw(From To Cc Subject)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 150) || '';
    }
    # create short html customer id
    $Param{CustomerIDHTML} = $Param{CustomerID} || '';
    foreach (qw(Priority State Queue Owner Lock CustomerIDHTML)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 15) || '';
    }
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ');
    # prepare escalation time
    if ($Param{Answered}) {
      $Param{TicketOverTime} = '$Text{"none - answered"}';
    } 
    elsif ($Param{TicketOverTime}) { 
      $Param{TicketOverTimeSuffix} = '';

      # colloring  
      $Param{TicketOverTimeFont} = '';
      $Param{TicketOverTimeFontEnd} = '';
      if ($Param{TicketOverTime} >= -60*20) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor2}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }
      elsif ($Param{TicketOverTime} >= -60*40) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor1}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }

      # create string
      if (!($Param{TicketOverTime} =~ s/-(.*?)/$1/g)) {
         $Param{TicketOverTimeSuffix} = '-';
      } 
      $Param{TicketOverTime} = $Self->CustomerAge(
          Age => $Param{TicketOverTime}, 
          Space => '<br>',
      );
      $Param{TicketOverTime} = $Param{TicketOverTimeFont}.$Param{TicketOverTimeSuffix}.
        $Param{TicketOverTime}.$Param{TicketOverTimeFontEnd}; 
    }
    else {
      $Param{TicketOverTime} = '$Text{"none"}';
    }

    # --
    # check if just a only html email
    # --
    if (my $MimeTypeText = $Self->CheckMimeType(%Param)) {
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
    if ($Self->{ConfigObject}->Get('StdResponsesMethod') eq 'Form') {
        $Param{StdResponsesStrg} .= '<form action="'.$Self->{CGIHandle}.'" method="post">';
        $Param{StdResponsesStrg} .= '<input type="hidden" name="Action" value="AgentCompose">';
        $Param{StdResponsesStrg} .= '<input type="hidden" name="TicketID" value="'.$Param{TicketID}.'">';
        $Param{StdResponsesStrg} .= $Self->OptionStrgHashRef(
          Name => 'ResponseID',
          Data => \%StdResponses,
        );
        $Param{StdResponsesStrg} .= '<input type="submit" value="$Text{"Compose"}">';
    }
    else {
       foreach (sort { $StdResponses{$a} cmp $StdResponses{$b} } keys %StdResponses) {
         $Param{StdResponsesStrg} .= "\n<li><A HREF=\"$Self->{Baselink}Action=AgentCompose&".
           "ResponseID=$_&TicketID=$Param{TicketID}\">$StdResponses{$_}</A></li>\n";
       }
    }

    # --
    # create & return output
    # --
    return $Self->Output(TemplateFile => 'TicketView', Data => \%Param);
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
    foreach (qw(Priority State Owner Queue CustomerIDHTML)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 15) || '';
    }
    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ');
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
      if ($Param{TicketOverTime} >= -60*20) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor2}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }
      elsif ($Param{TicketOverTime} >= -60*40) {
          $Param{TicketOverTimeFont} = "<font color='$Self->{HighlightColor1}'>";
          $Param{TicketOverTimeFontEnd} = '</font>';
      }

      if (!($Param{TicketOverTime} =~ s/-(.*?)/$1/g)) {
         $Param{TicketOverTimeSuffix} = '-';
      }
      $Param{TicketOverTime} = $Self->CustomerAge(
          Age => $Param{TicketOverTime}, 
          Space => '<br>',
      );
      $Param{TicketOverTime} = $Param{TicketOverTimeFont}.$Param{TicketOverTimeSuffix}.
        $Param{TicketOverTime}.$Param{TicketOverTimeFontEnd}; 
    }
    else {
      $Param{TicketOverTime} = 'none';
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
    my %StdResponses = %{$Param{StdResponses}};
    if ($Self->{ConfigObject}->Get('StdResponsesMethod') eq 'Form') {
        $Param{StdResponsesStrg} .= '<form action="'.$Self->{CGIHandle}.'" method="post">';
        $Param{StdResponsesStrg} .= '<input type="hidden" name="Action" value="AgentCompose">';
        $Param{StdResponsesStrg} .= '<input type="hidden" name="ArticleID" value="'.$ArticleID.'">';
        $Param{StdResponsesStrg} .= $Self->OptionStrgHashRef(
          Name => 'ResponseID',
          Data => \%StdResponses,
        );
        $Param{StdResponsesStrg} .= '<input type="submit" value="$Text{"Compose"}">';
    }
    else {
        foreach (sort { $StdResponses{$a} cmp $StdResponses{$b} } keys %StdResponses) {
          $Param{StdResponsesStrg} .= "\n<li><A HREF=\"$BaseLink"."Action=AgentCompose&".
           "ResponseID=$_&ArticleID=$ArticleID\">$StdResponses{$_}</A></li>\n";
        }
    }
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
        $ThreadStrg .= "<A HREF=\"$BaseLink"."Action=AgentZoom&ArticleID=$Article{ArticleID}\">" .
        "$Article{SenderType} ($Article{ArticleType})</A> ";
        if ($Article{ArticleType} =~ /^email/) {
            $ThreadStrg .= " (<A HREF=\"$BaseLink"."Action=AgentPlain&ArticleID=$Article{ArticleID}\">" .
            $Self->{LanguageObject}->Get('plain') . "</A>)";
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

    my $ArticleArray = 0;
    foreach my $ArticleTmp (@ArticleBox) {
        my %ArticleTmp1 = %$ArticleTmp;
        if ($ArticleID eq $ArticleTmp1{ArticleID}) {
            %Article = %ArticleTmp1;
        }
    }
    # --
    # get attacment string
    # --
    my $ATMsTmp = $Article{Atms};
    my @ATMs = ();
    @ATMs = @$ATMsTmp if ($ATMsTmp);
    my $ATMStrg = '';
    foreach (@ATMs) {
        my $FileName = $Self->LinkEncode($_) || '???';
        $Param{"Article::ATM"} .= '<a href="$Env{"Baselink"}Action=AgentAttachment&'.
          'ArticleID='.$Article{ArticleID}.'&File='.$FileName.'" target="attachment">'.$_.'</a><br> ';
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
    foreach ('ReplyTo', 'To', 'Cc', 'Subject') {
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

    # build ArticleTypeID string
    $Param{'NoteStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NoteTypes},
        Name => 'NoteID',
#        Selected => $Self->{ConfigObject}->Get('DefaultPhoneNoteType'),
    );

    # answered strg
    $Param{'AnsweredYesNoOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'Answered',
        Selected => 'Yes',
    );

    # build next states string
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NextStateID',
        Selected => $Self->{ConfigObject}->Get('PhoneDefaultNextState'),
    );

    # get output back
    return $Self->Output(TemplateFile => 'AgentPhone', Data => \%Param);
}
# --
sub AgentPhoneNew {
    my $Self = shift;
    my %Param = @_;

    # build next states string
    $Param{'NextStatesStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NextStateID',
        Selected => $Self->{ConfigObject}->Get('PhoneDefaultNewNextState'),
    );

    $Param{'ToStrg'} = $Self->OptionStrgHashRef(
        Data => $Param{To},
        Name => 'NewQueueID',
#        Selected => $Self->{ConfigObject}->Get('PhoneDefaultNextState'),
    );


    # get output back
    return $Self->Output(TemplateFile => 'AgentPhoneNew', Data => \%Param);
}
# --
sub AgentPriority {
    my $Self = shift;
    my %Param = @_;

    # build ArticleTypeID string
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

    # create & return output
    return $Self->Output(TemplateFile => 'AgentCustomer', Data => \%Param);
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
    if (my $MimeTypeText = $Self->CheckMimeType(%Param, Text => $Param{Body})) {
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
            ContentCharset => $Param{ContentCharset},
            TicketID => $Param{TicketID},
            ArticleID => $Param{ArticleID} )) {
            $Param{TextNote} = $CharsetText;
        }
    }

    # do some html quoting
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
        Name => 'ComposeStateID'
    );

    # --
    # answered strg
    # --
    $Param{'AnsweredYesNoOption'} = $Self->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'Answered',
        Selected => 'Yes',
    );

    # --
    # prepare 
    # --
    # create FromHTML (to show)
    $Param{FromHTML} = $Self->Ascii2Html(Text => $Param{From}, Max => 70);
    # do html quoting
    foreach ('ReplyTo', 'From', 'To', 'Cc', 'Subject') {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}) || '';
    }
    # email quoted print decode
    $Param{Body} = $Self->Ascii2Html(Text => $Param{Body});

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
    foreach ('ReplyTo', 'From', 'To', 'Cc', 'Subject', 'SystemFrom') {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}) || '';
    }
    # email quoted print decode
    $Param{Body} = $Self->Ascii2Html(Text => $Param{Body});

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
          elsif ($PrefKey eq 'UserLanguage') {
              $PrefItem{'Option'} = $Self->OptionStrgHashRef(
                  Data => {
                    $Self->{DBObject}->GetTableData(
                      What => 'language, language',
                      Valid => 1,
                      Clamp => 0,
                      Table => 'language',
                    )
                  },
                  Name => 'GenericTopic',
                  Selected => $Self->{UserLanguage},
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
          if ($Type eq 'Password' && $Self->{ConfigObject}->Get('AuthModule') =~ /ldap/i) {
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

    if ($Param{ViewType} eq 'New' && $Param{LastSenderID} eq $Param{UserID}) {
        return '';
    }

    if ($Param{LastSenderID} ne $Param{UserID}) {
        $Param{Message} = 'New message!';
    }

    $Param{Age} = $Self->CustomerAge(Age => $Param{Age}, Space => ' ');

    # do some strips && quoting
    foreach (qw(To Cc From Subject)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 70);
    }
    foreach (qw(State Priority Queue CustomerID)) {
        $Param{$_} = $Self->Ascii2Html(Text => $Param{$_}, Max => 20);
    }

    # create & return output
    return $Self->Output(TemplateFile => 'AgentMailboxTicket', Data => \%Param);
}
# --
sub AgentHistory {
    my $Self = shift;
    my %Param = @_;

    my $BackScreen = $Param{BackScreen} || '';
    my $LinesTmp = $Param{Data};
    my @Lines = @$LinesTmp;
    my $Output = '';

    foreach my $Data (@Lines) {
      # html qouting
      foreach ('Name', 'HistoryType', 'CreateBy', 'CreateTime') {
        $$Data{$_} = $Self->Ascii2Html(Text => $$Data{$_});
      }
      # get html string
      $Param{History} .= $Self->Output(TemplateFile => 'AgentHistoryRow', Data => $Data);
    }

    # create & return output
    return $Self->Output(TemplateFile => 'AgentHistoryForm', Data => \%Param);
}
# --
sub TicketLocked {
    my $Self = shift;
    my %Param = @_;
    return $Self->Output(TemplateFile => 'AgentTicketLocked', Data => \%Param);
}
# --
sub Attachment {
    my $Self = shift;
    my %Param = @_;
    # --
    # return attachment 
    # --
    my $Output = "Content-Disposition: attachment; filename=$Param{File}\n";
    $Output .= "Content-Type: $Param{Type}\n";
    $Output .= "$Param{Data}";
    return $Output;
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
    return $Self->Output(TemplateFile => 'AgentStatusViewTable', Data => \%Param);
}
# --

1;
 
