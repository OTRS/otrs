# --
# Kernel/System/Ticket/Article.pm - global article module for OTRS kernel
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Article.pm,v 1.32 2003-07-07 22:13:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Article;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.32 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub CreateArticle {
    my $Self = shift;
    my %Param = @_;
    my $ValidID 	= $Param{ValidID} || 1;
    my $IncomingTime    = time();
    # --
    # create ArticleContentPath
    # --
    if (!$Self->{ArticleContentPath}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleContentPath!");
        return;
    }
    # --
    # lockups if no ids!!!
    # --
    if (($Param{ArticleType}) && (!$Param{ArticleTypeID})) {
        $Param{ArticleTypeID} = $Self->ArticleTypeLookup(ArticleType => $Param{ArticleType}); 
    }
    if (($Param{SenderType}) && (!$Param{SenderTypeID})) {
        $Param{SenderTypeID} = $Self->ArticleSenderTypeLookup(SenderType => $Param{SenderType});
    }
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID ArticleTypeID SenderTypeID HistoryType HistoryComment)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # add 'no body found!' if there is no body there!
    # --
    if (!$Param{Body}) {
        $Param{Body} = 'no body found!';
    }
    # --
    # if body isn't text, attach body as attachment (mostly done by OE) :-/
    # --
    elsif ($Param{ContentType} && $Param{ContentType} !~ /text\//i) {
        $Param{AttachContentType} = $Param{ContentType};
        $Param{AttachBody} = $Param{Body};
        $Param{ContentType} = 'text/plain';
        $Param{Body} = 'see attachment'; 
    }
    else {
        # fix some bad stuff from some browsers (Opera)!
        $Param{Body} =~ s/(\n\r|\r\r\n|\r\n)/\n/g;
    }
    # --
    # DB Quoting
    # --
    my %DBParam = ();
    foreach (qw(From To Cc ReplyTo Subject Body MessageID ContentType)) {
        if ($Param{$_}) {
            # qb quoting
            $DBParam{$_} = $Self->{DBObject}->Quote($Param{$_});
        }
        else {
            $DBParam{$_} = '';
        }
    }
    # --
    # do db insert
    # --
    my $SQL = "INSERT INTO article ".
    " (ticket_id, article_type_id, article_sender_type_id, a_from, a_reply_to, a_to, " .
	" a_cc, a_subject, a_message_id, a_body, a_content_type, content_path, ".
    " valid_id, incoming_time,  create_time, create_by, change_time, change_by) " .
	" VALUES ".
    " ($Param{TicketID}, $Param{ArticleTypeID}, $Param{SenderTypeID}, ".
    " '$DBParam{From}', '$DBParam{ReplyTo}', '$DBParam{To}', '$DBParam{Cc}', ".
    " '$DBParam{Subject}', ". 
	" '$DBParam{MessageID}', '$DBParam{Body}', '$DBParam{ContentType}', ".
    "'".$Self->{DBObject}->Quote($Self->{ArticleContentPath})."', $ValidID,  $IncomingTime, " .
	" current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if (!$Self->{DBObject}->Do(SQL => $SQL)) {
        return;
    }
    # --
    # get article id 
    # --
    my $ArticleID = $Self->GetIdOfArticle(
        TicketID => $Param{TicketID},
        MessageID => $DBParam{MessageID},
        From => $DBParam{From},
        Subject => $DBParam{Subject},
        IncomingTime => $IncomingTime
    ); 
    # --
    # if body isn't text, attach body as attachment (mostly done by OE) :-/
    # --
    if ($Param{AttachContentType} && $Param{AttachBody}) {
        my $FileName = 'unknown';
        if ($Param{AttachContentType} =~ /name="(.+?)"/i) {
            $FileName = $1;
        }
        $Self->WriteArticlePart(
            Content => $Param{AttachBody},
            Filename => $FileName,
            ContentType => $Param{AttachContentType},
            ArticleID => $ArticleID,
            UserID => $Param{UserID},
        );
    }
    # --
    # return if there is not article created
    # --
    if (!$ArticleID) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't get ArticleID from INSERT!",
        );
        return;
    }
    # --
    # add history row
    # --
    $Self->AddHistoryRow(
        ArticleID => $ArticleID,
        TicketID => $Param{TicketID},
        CreateUserID => $Param{UserID},
        HistoryType => $Param{HistoryType},
        Name => $Param{HistoryComment},
    );
    # --
    # send auto response
    # --
    my %Ticket = $Self->GetTicket(TicketID => $Param{TicketID});
    my %State = $Self->{StateObject}->StateGet(ID => $Ticket{StateID});
    # --
    # send if notification should be sent (not for closed tickets)!?
    # --
    if ($Param{AutoResponseType} && $Param{AutoResponseType} eq 'auto reply' && ($State{TypeName} eq 'closed' || $State{TypeName} eq 'removed')) {
        # --
        # add history row
        # --
        $Self->AddHistoryRow(
            TicketID => $Param{TicketID},
            HistoryType => 'Misc',
            Name => "Sent no auto response or agent notification because ticket is state-type '$State{TypeName}'!",
            CreateUserID => $Param{UserID},
        );
        # --
        # return ArticleID
        # --
        return $ArticleID;
    }
    if ($Param{AutoResponseType} && $Param{OrigHeader}) {
        # get auto default responses
        my %Data = $Self->{AutoResponse}->AutoResponseGetByTypeQueueID(
            QueueID => $Ticket{QueueID}, 
            Type => $Param{AutoResponseType},
        );
        my %OrigHeader = %{$Param{OrigHeader}};
        if ($Data{Text} && $Data{Realname} && $Data{Address} && !$OrigHeader{'X-OTRS-Loop'}) {
            # --
            # check / loop protection!
            # --
            if (!$Self->{LoopProtectionObject}->Check(To => $OrigHeader{From})) {
                # add history row
                $Self->AddHistoryRow(
                    TicketID => $Param{TicketID},
                    HistoryType => 'LoopProtection',
                    Name => "Sent no auto response (LoopProtection)!",
                    CreateUserID => $Param{UserID},
                );
                # do log
                $Self->{LogObject}->Log(
                    Message => "Sent no '$Param{AutoResponseType}' for Ticket [".
                      "$Ticket{TicketNumber}] ($OrigHeader{From}) "
                );
            }
            else {
                # write log
                if ($Param{UserID} ne $Self->{ConfigObject}->Get('PostmasterUserID') || 
                     $Self->{LoopProtectionObject}->SendEmail(To => $OrigHeader{From})) {
                    # get history type
                    my %SendInfo = ();
                    if ($Param{AutoResponseType} =~/^auto follow up$/i) {
                        $SendInfo{AutoResponseHistoryType} = 'SendAutoFollowUp';
                    }
                    elsif ($Param{AutoResponseType} =~/^auto reply$/i) {
                        $SendInfo{AutoResponseHistoryType} = 'SendAutoReply';
                    }
                    elsif ($Param{AutoResponseType} =~/^auto reply\/new ticket$/i) {
                        $SendInfo{AutoResponseHistoryType} = 'SendAutoReply';
                    }
                    elsif ($Param{AutoResponseType} =~/^auto reject$/i) {
                        $SendInfo{AutoResponseHistoryType} = 'SendAutoReject';
                    }
                    else {
                        $SendInfo{AutoResponseHistoryType} = 'Misc'; 
                    }
                    $Self->SendAutoResponse(
                        %Data,
                        CustomerMessageParams => \%OrigHeader,
                        TicketNumber => $Ticket{TicketNumber}, 
                        TicketID => $Param{TicketID},
                        UserID => $Param{UserID}, 
                        HistoryType => $SendInfo{AutoResponseHistoryType},
                    );
                }
            }
        }
        # -- 
        # log that no auto response was sent!
        # --
        elsif ($Data{Text} && $Data{Realname} && $Data{Address} && $OrigHeader{'X-OTRS-Loop'}) {
            # add history row
            $Self->AddHistoryRow(
                TicketID => $Param{TicketID},
                HistoryType => 'Misc',
                Name => "Sent no auto-response because the sender don't want ".
                  "a auto-response (e. g. loop or precedence header)",
                CreateUserID => $Param{UserID},
            );
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Sent no '$Param{AutoResponseType}' for Ticket [".
                  "$Ticket{TicketNumber}] ($OrigHeader{From}) because the ".
                  "sender don't want a auto-response (e. g. loop or precedence header)"
            );
        }
    }
    # --
    # send no agent notification!?
    # --
    if ($Param{NoAgentNotify}) {
        # --
        # return ArticleID
        # --
        return $ArticleID;
    }
    # --
    # send agent notification!?
    # --
    my $To = '';
    if ($Param{HistoryType} =~ /^NewTicket$/i ||  $Param{HistoryType} =~ /^PhoneCallCustomer$/i) {
		foreach ($Self->{QueueObject}->GetAllUserIDsByQueueID(QueueID => $Ticket{QueueID})) {
			my %UserData = $Self->{UserObject}->GetUserData(UserID => $_);
			if ($UserData{UserEmail} && $UserData{UserSendNewTicketNotification}) {
				$To .= "$UserData{UserEmail}, ";
			}
		}
    }
    elsif ($Param{HistoryType} =~ /^FollowUp$/i || $Param{HistoryType} =~ /^AddNote$/i) {
        # get owner
        my ($OwnerID, $Owner) = $Self->CheckOwner(TicketID => $Param{TicketID});
        if ($OwnerID ne $Self->{ConfigObject}->Get('PostmasterUserID') && $OwnerID ne $Param{UserID}) {
            my %Preferences = $Self->{UserObject}->GetUserData(UserID => $OwnerID);
            if ($Preferences{UserSendFollowUpNotification}) {
                $To = $Preferences{UserEmail};
            }
        }
    }
    # --
    # send notification
    # --
    $Self->SendNotification(
        Type => $Param{HistoryType},
        To => $To,
        CustomerMessageParams => \%Param,
        TicketNumber => $Ticket{TicketNumber},
        TicketID => $Param{TicketID},
        Queue => $Param{Queue},
        UserID => $Param{UserID},
    );
    # --
    # return ArticleID
    # --
    return $ArticleID;
}
# --
sub GetArticleContentPath {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }
    # --
    # check cache
    # --
    if ($Self->{"GetArticleContentPath::$Param{ArticleID}"}) {
        return $Self->{"GetArticleContentPath::$Param{ArticleID}"};
    }
    # --
    # sql query
    # --
    my $Path;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT content_path FROM article WHERE id = $Param{ArticleID}",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Path = $Row[0];
    }
    # --
    # fillup cache
    # --
    $Self->{"GetArticleContentPath::$Param{ArticleID}"} = $Path;
    return $Path;
}
# --
sub GetIdOfArticle {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID MessageID From Subject IncomingTime)) {
      if (!defined $Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # sql query
    # --
    my $Id;
    $Self->{DBObject}->Prepare(
      SQL => "SELECT id FROM article " .
        " WHERE " .
        " ticket_id = $Param{TicketID} " .
        " AND " .
        " a_message_id = '$Param{MessageID}' " .
        " AND " .
        " a_from = '$Param{From}' " .
        " AND " .
        " a_subject = '$Param{Subject}'" .
        " AND " .
        " incoming_time = '$Param{IncomingTime}'",
    );
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Id = $RowTmp[0];
    }
    return $Id;
}
# --
sub ArticleSenderTypeLookup {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{SenderType}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need SenderType!");
      return;
    }
    # --
    # check if we ask the same request?
    # --
    if (exists $Self->{"Kernel::System::Ticket::ArticleSenderTypeLookup::$Param{SenderType}"}) {
        return $Self->{"Kernel::System::Ticket::ArticleSenderTypeLookup::$Param{SenderType}"};
    }
    # --
    # get data
    # --
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM article_sender_type WHERE name = '$Param{SenderType}'",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Kernel::System::Ticket::ArticleSenderTypeLookup::$Param{SenderType}"} = $Row[0];
    }
    # --
    # check if data exists
    # --
    if (!exists $Self->{"Kernel::System::Ticket::ArticleSenderTypeLookup::$Param{SenderType}"}) {
        $Self->{LogObject}->Log(
            Priority => 'error', Message => "Found no SenderTypeID for $Param{SenderType}!",
        );
        return;
    }

    return $Self->{"Kernel::System::Ticket::ArticleSenderTypeLookup::$Param{SenderType}"};
}
# --
sub ArticleTypeLookup {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{ArticleType}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleType!");
      return;
    }
    # --
    # check if we ask the same request?
    # --
    if (exists $Self->{"Kernel::System::Ticket::ArticleTypeLookup::$Param{ArticleType}"}) {
        return $Self->{"Kernel::System::Ticket::ArticleTypeLookup::$Param{ArticleType}"};
    }
    # --
    # get data
    # --
    $Self->{DBObject}->Prepare(
        SQL => "SELECT id FROM article_type WHERE name = '$Param{ArticleType}'",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Kernel::System::Ticket::ArticleTypeLookup::$Param{ArticleType}"} = $Row[0];
    }
    # --
    # check if data exists
    # --
    if (!exists $Self->{"Kernel::System::Ticket::ArticleTypeLookup::$Param{ArticleType}"}) {
        $Self->{LogObject}->Log(
            Priority => 'error', Message => "Found no ArticleTypeID for $Param{ArticleType}!",
        );
        return;
    }

    return $Self->{"Kernel::System::Ticket::ArticleTypeLookup::$Param{ArticleType}"};
}
# --
sub SetArticleFreeText {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ArticleID UserID Counter)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # db quote for key an value
    # --
    $Param{Value} = $Self->{DBObject}->Quote($Param{Value}) || '';
    $Param{Key} = $Self->{DBObject}->Quote($Param{Key}) || '';
    # --
    # db update
    # --
    if ($Self->{DBObject}->Do(
        SQL => "UPDATE article SET a_freekey$Param{Counter} = '$Param{Key}', " .
          " a_freetext$Param{Counter} = '$Param{Value}', " .
          " change_time = current_timestamp, change_by = $Param{UserID} " .
          " WHERE id = $Param{ArticleID}",
    )) { 
        return 1;
    }
    else {
        return;
    }
}
# --
sub GetLastCustomerArticle {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{TicketID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
      return;
    }
    # --
    # get article index
    # --
    my @Index = $Self->GetArticleIndex(TicketID => $Param{TicketID}, SenderType => 'customer');
    # --
    # get article data   
    # --
    if (@Index) {
        return $Self->GetArticle(ArticleID => $Index[$#Index]);
    }
    else {
        my @Index = $Self->GetArticleIndex(TicketID => $Param{TicketID});
        if (@Index) {
            return $Self->GetArticle(ArticleID => $Index[$#Index]);
        }
        else {
            $Self->{LogObject}->Log(
                Priority => 'error', 
                Message => "No article found for TicketID $Param{TicketID}!",
            );
            return; 
        }
    }
}
# --
sub GetArticleIndex {
    my $Self = shift;
    my %Param = @_;
    my @Index = (); 
    # --
    # check needed stuff
    # --
    if (!$Param{TicketID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
      return;
    }
    # --
    # db query
    # --
    my $SQL = '';

    if ($Param{SenderType}) {
        $SQL .= "SELECT at.id".
          " FROM ".
          " article at, article_sender_type ast ".
          " WHERE ".
          " at.ticket_id = $Param{TicketID} ".
          " AND ".
          " at.article_sender_type_id = ast.id ".
          " AND ".
          " ast.name = '$Param{SenderType}' ";
    }
    else {
        $SQL = "SELECT at.id".
          " FROM ".
          " article at ".
          " WHERE ".
          " at.ticket_id = $Param{TicketID} ";
    }
    $SQL .= " ORDER BY at.id";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@Index, $Row[0]);
    }
    # --
    # return data
    # --
    return @Index; 
}
# --
sub GetArticleContentIndex {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{TicketID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
        return;
    }
    my @ArticleIndex = $Self->GetArticleIndex(TicketID => $Param{TicketID});
    my @ArticleBox = ();
    foreach (@ArticleIndex) {
        my %Article = $Self->GetArticle(ArticleID => $_);
        push (@ArticleBox, \%Article);
    }
    # --
    # article attachments
    # --
    foreach my $Article (@ArticleBox) {
        my %AtmIndex = $Self->GetArticleAtmIndex(
            ContentPath => $Article->{ContentPath},
            ArticleID => $Article->{ArticleID},
        );
        $Article->{Atms} = \%AtmIndex;
    }
    return @ArticleBox;
}
# --
sub GetArticle {
    my $Self = shift;
    my %Param = @_;
    my %Data;
    # check needed stuff
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }
    # sql query
    $Self->{DBObject}->Prepare(
      SQL => "SELECT sa.ticket_id, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, sa.a_reply_to, ".
        " sa. a_message_id, sa.a_body, ".
        " st.create_time_unix, sp.name, sd.name, sq.name, sq.id, sa.create_time, ".
        " sa.a_content_type, sa.create_by, st.tn, ast.name, st.customer_id, ".
        " st.until_time, sp.id, st.customer_user_id, st.user_id, ".
        " su.$Self->{ConfigObject}->{DatabaseUserTableUser}, at.name, ".
        " sa.a_freekey1, sa.a_freetext1, sa.a_freekey2, sa.a_freetext2, ".
        " sa.a_freekey3, sa.a_freetext3 ".
        " FROM ".
        " article sa, ticket st, ticket_priority sp, ticket_state sd, queue sq, ".
        " article_sender_type ast, $Self->{ConfigObject}->{DatabaseUserTable} su, ".
        " article_type at ".
        " where ". 
        " sa.id = $Param{ArticleID}".
        " AND ".
        " sa.ticket_id = st.id ".
        " ANd ".
        " sq.id = st.queue_id ".
        " AND ".
        " sa.article_sender_type_id = ast.id ".
        " AND ".
        " sp.id = st.ticket_priority_id ".
        " AND ".
        " st.ticket_state_id = sd.id ".
        " AND ".
        " at.id = sa.article_type_id ".
        " AND ".
        " st.user_id = su.$Self->{ConfigObject}->{DatabaseUserTableUserID} ",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{ArticleID} = $Param{ArticleID};
        $Data{TicketID} = $Row[0];
        $Data{From} = $Row[1];
        $Data{To} = $Row[2];
        $Data{Cc} = $Row[3];
        $Data{Subject} = $Row[4];
        $Data{ReplyTo} = $Row[5],
        $Data{InReplyTo} = $Row[6];
        $Data{Body} = $Row[7];
        $Data{Age} = time() - $Row[8];
        $Data{Priority} = $Row[9];
        $Data{PriorityID} = $Row[20];
        $Data{State} = $Row[10];
        $Data{Queue} = $Row[11];
        $Data{QueueID} = $Row[12];
        $Data{Date} = $Row[13];
        $Data{Created} = $Row[13];
        $Data{ContentType} = $Row[14];
        $Data{CreatedBy} = $Row[15];
        $Data{TicketNumber} = $Row[16];
        $Data{SenderType} = $Row[17];
        if ($Row[14] && $Data{ContentType} =~ /charset=(.*)(| |\n)/i) {
            $Data{ContentCharset} = $1;
        }
        if ($Row[14] && $Data{ContentType} =~ /^(.+?\/.+?)( |;)/i) {
            $Data{MimeType} = $1;
        } 
        $Data{CustomerID} = $Row[18];
        $Data{CustomerUserID} = $Row[21];
        $Data{UserID} = $Row[22];
        $Data{Owner} = $Row[23];
        $Data{ArticleType} = $Row[24];
        $Data{FreeKey1} = $Row[25]; 
        $Data{FreeText1} = $Row[26];
        $Data{FreeKey2} = $Row[27];
        $Data{FreeText2} = $Row[28];
        $Data{FreeKey3} = $Row[29];
        $Data{FreeText3} = $Row[30];
        $Data{RealTillTimeNotUsed} = $Row[19];
    }
    # --
    # get state info
    # --
    my %StateData = $Self->{StateObject}->StateGet(Name => $Data{State});
    $Data{StateType} = $StateData{TypeName};
    if (!$Data{RealTillTimeNotUsed} || $StateData{TypeName} !~ /^pending/i) {
        $Data{UntilTime} = 0;
    }
    else {
        $Data{UntilTime} = $Data{RealTillTimeNotUsed} - time();
    }
    return %Data;
}
# --

1;
