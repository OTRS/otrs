# --
# Kernel/System/Ticket/Article.pm - global article module for OTRS kernel
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Article.pm,v 1.50 2004-02-17 13:28:38 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Article;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.50 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub CreateArticle {
    my $Self = shift;
    my %Param = @_;
    my $ValidID 	= $Param{ValidID} || 1;
    my $IncomingTime    = time();
    # create ArticleContentPath
    if (!$Self->{ArticleContentPath}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleContentPath!");
        return;
    }
    # lockups if no ids!!!
    if (($Param{ArticleType}) && (!$Param{ArticleTypeID})) {
        $Param{ArticleTypeID} = $Self->ArticleTypeLookup(ArticleType => $Param{ArticleType}); 
    }
    if (($Param{SenderType}) && (!$Param{SenderTypeID})) {
        $Param{SenderTypeID} = $Self->ArticleSenderTypeLookup(SenderType => $Param{SenderType});
    }
    # check needed stuff
    foreach (qw(TicketID UserID ArticleTypeID SenderTypeID HistoryType HistoryComment)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # add 'no body found!' if there is no body there!
    if (!$Param{Body}) {
        $Param{Body} = 'no body found!';
    }
    # if body isn't text, attach body as attachment (mostly done by OE) :-/
    elsif ($Param{ContentType} && $Param{ContentType} !~ /\btext\b/i) {
        $Param{AttachContentType} = $Param{ContentType};
        $Param{AttachBody} = $Param{Body};
        $Param{ContentType} = 'text/plain';
        $Param{Body} = 'no text/plain body => see attachment'; 
    }
    else {
        # fix some bad stuff from some browsers (Opera)!
        $Param{Body} =~ s/(\n\r|\r\r\n|\r\n)/\n/g;
    }
    # strip not wanted stuff
    foreach (qw(From To Cc Subject MessageID ReplyTo)) {
        $Param{$_} =~ s/\n|\r//g if ($Param{$_});
    }
    # DB quoting
    my %DBParam = ();
    foreach (qw(From To Cc ReplyTo Subject Body MessageID ContentType TicketID ArticleTypeID SenderTypeID )) {
        if ($Param{$_}) {
            # qb quoting
            $DBParam{$_} = $Self->{DBObject}->Quote($Param{$_});
        }
        else {
            $DBParam{$_} = '';
        }
    }
    # do db insert
    if (!$Self->{DBObject}->Do(SQL => "INSERT INTO article ".
      " (ticket_id, article_type_id, article_sender_type_id, a_from, a_reply_to, a_to, " .
      " a_cc, a_subject, a_message_id, a_body, a_content_type, content_path, ".
      " valid_id, incoming_time,  create_time, create_by, change_time, change_by) " .
      " VALUES ".
      " ($DBParam{TicketID}, $DBParam{ArticleTypeID}, $DBParam{SenderTypeID}, ".
      " '$DBParam{From}', '$DBParam{ReplyTo}', '$DBParam{To}', '$DBParam{Cc}', ".
      " '$DBParam{Subject}', ". 
      " '$DBParam{MessageID}', '$DBParam{Body}', '$DBParam{ContentType}', ".
      "'".$Self->{DBObject}->Quote($Self->{ArticleContentPath})."', $ValidID,  $IncomingTime, " .
      " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})")) {
        return;
    }
    # get article id 
    my $ArticleID = $Self->GetIdOfArticle(
        TicketID => $Param{TicketID},
        MessageID => $Param{MessageID},
        From => $Param{From},
        Subject => $Param{Subject},
        IncomingTime => $IncomingTime
    ); 
    # return if there is not article created
    if (!$ArticleID) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "Can't get ArticleID from INSERT!",
        );
        return;
    }
    # if body isn't text, attach body as attachment (mostly done by OE) :-/
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
    # add history row
    $Self->AddHistoryRow(
        ArticleID => $ArticleID,
        TicketID => $Param{TicketID},
        CreateUserID => $Param{UserID},
        HistoryType => $Param{HistoryType},
        Name => $Param{HistoryComment},
    );
    # send auto response
    my %Ticket = $Self->GetTicket(TicketID => $Param{TicketID});
    my %State = $Self->{StateObject}->StateGet(ID => $Ticket{StateID});
    # --
    # send if notification should be sent (not for closed tickets)!?
    # --
    if ($Param{AutoResponseType} && $Param{AutoResponseType} eq 'auto reply' && ($State{TypeName} eq 'closed' || $State{TypeName} eq 'removed')) {
        # add history row
        $Self->AddHistoryRow(
            TicketID => $Param{TicketID},
            HistoryType => 'Misc',
            Name => "Sent no auto response or agent notification because ticket is state-type '$State{TypeName}'!",
            CreateUserID => $Param{UserID},
        );
        # return ArticleID
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
        # return ArticleID
        return $ArticleID;
    }
    # --
    # send agent notification!?
    # --
    my $To = '';
    if ($Param{HistoryType} =~ /^(EmailCustomer|PhoneCallCustomer|WebRequestCustomer)$/i) {
        foreach ($Self->{QueueObject}->GetAllUserIDsByQueueID(QueueID => $Ticket{QueueID})) {
	    my %UserData = $Self->{UserObject}->GetUserData(
                UserID => $_, 
                Cached => 1, 
                Valid => 1,
            );
            if ($UserData{UserSendNewTicketNotification}) {
                # send notification
                $Self->SendNotification(
                    Type => $Param{HistoryType},
                    UserData => \%UserData,
                    CustomerMessageParams => \%Param,
                    TicketID => $Param{TicketID},
                    Queue => $Param{Queue},
                    UserID => $Param{UserID},
                );
            }
        }
    }
    elsif ($Param{HistoryType} =~ /^FollowUp$/i || $Param{HistoryType} =~ /^AddNote$/i) {
        # get owner
        my ($OwnerID, $Owner) = $Self->CheckOwner(TicketID => $Param{TicketID});
        if ($OwnerID ne $Self->{ConfigObject}->Get('PostmasterUserID') && $OwnerID ne $Param{UserID}) {
            my %Preferences = $Self->{UserObject}->GetUserData(UserID => $OwnerID);
            if ($Preferences{UserSendFollowUpNotification}) {
                # send notification
                $Self->SendNotification(
                    Type => $Param{HistoryType},
                    UserData => \%Preferences,
                    CustomerMessageParams => \%Param,
                    TicketID => $Param{TicketID},
                    Queue => $Param{Queue},
                    UserID => $Param{UserID},
                );
            }
        }
    }
    # return ArticleID
    return $ArticleID;
}
# --
sub GetArticleContentPath {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # check cache
    if ($Self->{"GetArticleContentPath::$Param{ArticleID}"}) {
        return $Self->{"GetArticleContentPath::$Param{ArticleID}"};
    }
    # sql query
    my $Path;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT content_path FROM article WHERE id = $Param{ArticleID}",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Path = $Row[0];
    }
    # fillup cache
    $Self->{"GetArticleContentPath::$Param{ArticleID}"} = $Path;
    return $Path;
}
# --
sub GetIdOfArticle {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID MessageID From Subject IncomingTime)) {
      if (!defined $Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # sql query
    my $SQL = "SELECT id FROM article " .
        " WHERE " .
        " ticket_id = $Param{TicketID} " .
        " AND ";
    if ($Param{MessageID}) {
        $SQL .= "a_message_id = '$Param{MessageID}' AND ";
    }
    if ($Param{MessageID}) {
        $SQL .= "a_from = '$Param{From}' AND ";
    }
    if ($Param{MessageID}) {
        $SQL .= "a_subject = '$Param{Subject}' AND ";
    }
    $SQL .= " incoming_time = '$Param{IncomingTime}'";
    # start query
    $Self->{DBObject}->Prepare(SQL => $SQL);
    my $Id;
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Id = $RowTmp[0];
    }
    return $Id;
}
# --
sub ArticleSenderTypeLookup {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{SenderType} && !$Param{SenderTypeID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need SenderType or SenderTypeID!");
      return;
    }
    # get key
    if ($Param{SenderType}) {
        $Param{Key} = 'SenderType';
    }
    else {
        $Param{Key} = 'SenderTypeID';
    }
    # check if we ask the same request?
    if ($Self->{"ArticleSenderTypeLookup::$Param{$Param{Key}}"}) {
        return $Self->{"ArticleSenderTypeLookup::$Param{$Param{Key}}"};
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # get data
    my $SQL = '';
    if ($Param{SenderType}) {
        $SQL = "SELECT id FROM article_sender_type WHERE name = '$Param{SenderType}'";
    }
    else {
        $SQL = "SELECT name FROM article_sender_type WHERE id = $Param{SenderTypeID}";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL); 
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"ArticleSenderTypeLookup::$Param{$Param{Key}}"} = $Row[0];
    }
    # check if data exists
    if (!exists $Self->{"ArticleSenderTypeLookup::$Param{$Param{Key}}"}) {
        $Self->{LogObject}->Log(
            Priority => 'error', Message => "Found no SenderType(ID) for $Param{$Param{Key}}!",
        );
        return;
    }
    # return
    return $Self->{"ArticleSenderTypeLookup::$Param{$Param{Key}}"};
}
# --
sub ArticleTypeLookup {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ArticleType} && !$Param{ArticleTypeID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleType or ArticleTypeID!");
        return;
    }
    # get key
    if ($Param{ArticleType}) {
        $Param{Key} = 'ArticleType';
    }
    else {
        $Param{Key} = 'ArticleTypeID';
    }
    # check if we ask the same request (cache)?
    if ($Self->{"ArticleTypeLookup::$Param{$Param{Key}}"}) {
        return $Self->{"ArticleTypeLookup::$Param{$Param{Key}}"};
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # get data
    my $SQL = '';
    if ($Param{ArticleType}) {
        $SQL = "SELECT id FROM article_type WHERE name = '$Param{ArticleType}'",
    }
    else {
        $SQL = "SELECT name FROM article_type WHERE id = $Param{ArticleTypeID}",
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);

    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"ArticleTypeLookup::$Param{$Param{Key}}"} = $Row[0];
    }
    # check if data exists
    if (!$Self->{"ArticleTypeLookup::$Param{$Param{Key}}"}) {
        $Self->{LogObject}->Log(
            Priority => 'error', Message => "Found no ArticleType(ID) for $Param{$Param{Key}}!",
        );
        return;
    }
    # return
    return $Self->{"ArticleTypeLookup::$Param{$Param{Key}}"};
}
# --
sub SetArticleFreeText {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ArticleID UserID Counter)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote for key an value
    $Param{Value} = $Self->{DBObject}->Quote($Param{Value}) || '';
    $Param{Key} = $Self->{DBObject}->Quote($Param{Key}) || '';
    # db update
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
    # check needed stuff
    if (!$Param{TicketID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
        return;
    }
    # get article index
    my @Index = $Self->GetArticleIndex(TicketID => $Param{TicketID}, SenderType => 'customer');
    # get article data   
    if (@Index) {
        return $Self->GetArticle(ArticleID => $Index[$#Index], TicketOverTime => 1);
    }
    else {
        my @Index = $Self->GetArticleIndex(TicketID => $Param{TicketID});
        if (@Index) {
            return $Self->GetArticle(ArticleID => $Index[$#Index], TicketOverTime => 1);
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
sub GetFirstArticle {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{TicketID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
        return;
    }
    # get article index
    my @Index = $Self->GetArticleIndex(TicketID => $Param{TicketID});
    # get article data   
    if (@Index) {
        return $Self->GetArticle(ArticleID => $Index[0]);
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error', 
            Message => "No article found for TicketID $Param{TicketID}!",
        );
        return; 
    }
}
# --
sub GetArticleIndex {
    my $Self = shift;
    my %Param = @_;
    my @Index = (); 
    # check needed stuff
    if (!$Param{TicketID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db query
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
    # return data
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
#    my @ArticleIndex = $Self->GetArticleIndex(TicketID => $Param{TicketID});
#    my @ArticleBox = ();
#    foreach (@ArticleIndex) {
#        my %Article = $Self->GetArticle(ArticleID => $_);
#        push (@ArticleBox, \%Article);
#    }
    my @ArticleBox = $Self->GetArticle(TicketID => $Param{TicketID});
    # article attachments
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
    # check needed stuff
    if (!$Param{ArticleID} && !$Param{TicketID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID or TicketID!");
        return;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # article type lookup
    my $ArticleTypeSQL = '';
    if ($Param{ArticleType} && (ref($Param{ArticleType}) eq 'ARRAY')) {
        foreach (@{$Param{ArticleType}}) {
            if ($Self->ArticleTypeLookup(ArticleType => $_)) {
                if ($ArticleTypeSQL) {
                    $ArticleTypeSQL .= ',';
                }
                $ArticleTypeSQL .= $Self->ArticleTypeLookup(ArticleType => $_);
            }
        }
        if ($ArticleTypeSQL) {
            $ArticleTypeSQL = " AND sa.article_type_id IN ($ArticleTypeSQL)";
        }
    }
    # sql query
    my @Content = ();
    my $SQL = "SELECT sa.ticket_id, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, ".
        " sa.a_reply_to, sa. a_message_id, sa.a_body, ".
        " st.create_time_unix, st.ticket_state_id, st.queue_id, sa.create_time, ".
        " sa.a_content_type, sa.create_by, st.tn, article_sender_type_id, st.customer_id, ".
        " st.until_time, st.ticket_priority_id, st.customer_user_id, st.user_id, ".
        " su.$Self->{ConfigObject}->{DatabaseUserTableUser}, sa.article_type_id, ".
        " sa.a_freekey1, sa.a_freetext1, sa.a_freekey2, sa.a_freetext2, ".
        " sa.a_freekey3, sa.a_freetext3, st.ticket_answered, ".
        " sa.incoming_time, sa.id, st.freekey1, st.freetext1, st.freekey2, st.freetext2,".
        " st.freekey3, st.freetext3, st.freekey4, st.freetext4,". 
        " st.freekey5, st.freetext5, st.freekey6, st.freetext6,". 
        " st.freekey7, st.freetext7, st.freekey8, st.freetext8". 
        " FROM ".
        " article sa, ticket st, ".
        " $Self->{ConfigObject}->{DatabaseUserTable} su ".
        " where ";
    if ($Param{ArticleID}) { 
        $SQL .= " sa.id = $Param{ArticleID}";
    }
    else {
        $SQL .= " sa.ticket_id = $Param{TicketID}";
    }
    $SQL .= " AND ".
        " sa.ticket_id = st.id ";
    # add article types
    if ($ArticleTypeSQL) {
        $SQL .= $ArticleTypeSQL;
    }
    $SQL .= " AND ".
        " st.user_id = su.$Self->{ConfigObject}->{DatabaseUserTableUserID} ".
        " ORDER BY sa.id ASC";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    my %Ticket = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Data;
        $Data{ArticleID} = $Row[31];
        $Data{TicketID} = $Row[0];
        $Data{From} = $Row[1];
        $Data{To} = $Row[2];
        $Data{Cc} = $Row[3];
        $Data{Subject} = $Row[4];
        $Data{ReplyTo} = $Row[5],
        $Data{InReplyTo} = $Row[6];
        $Data{Body} = $Row[7];
        $Data{Age} = time() - $Row[8];
        $Data{PriorityID} = $Row[18];
        $Ticket{PriorityID} = $Row[18];
        $Data{StateID} = $Row[9];
        $Ticket{StateID} = $Row[9];
        $Data{QueueID} = $Row[10];
        $Ticket{QueueID} = $Row[10];
        $Data{Date} = $Row[11];
        $Data{Created} = $Row[11];
        $Data{ContentType} = $Row[12];
        $Data{CreatedBy} = $Row[13];
        $Data{TicketNumber} = $Row[14];
        $Data{SenderTypeID} = $Row[15];
        if ($Row[12] && $Data{ContentType} =~ /charset=/i) {
            $Data{ContentCharset} = $Data{ContentType};
            $Data{ContentCharset} =~ s/.+?charset=("|'|)(\w+)/$2/gi;
            $Data{ContentCharset} =~ s/"|'//g ;
            $Data{ContentCharset} =~ s/(.+?);.*/$1/g;
        }
        else {
            $Data{ContentCharset} = '';
        }
        if ($Row[12] && $Data{ContentType} =~ /^(\w+\/\w+)/i) {
            $Data{MimeType} = $1;
            $Data{MimeType} =~ s/"|'//g ;
        } 
        else {
            $Data{MimeType} = '';
        }
        $Ticket{CustomerID} = $Row[16];
        $Ticket{CustomerUserID} = $Row[19];
        $Data{CustomerID} = $Row[16];
        $Data{CustomerUserID} = $Row[19];
        $Data{UserID} = $Row[20];
        $Ticket{UserID} = $Row[20];
        $Data{Owner} = $Row[21];
        $Data{ArticleTypeID} = $Row[22];
        $Data{FreeKey1} = $Row[23]; 
        $Data{FreeText1} = $Row[24];
        $Data{FreeKey2} = $Row[25];
        $Data{FreeText2} = $Row[26];
        $Data{FreeKey3} = $Row[27];
        $Data{FreeText3} = $Row[28];
        $Data{Answered} = $Row[29];
        $Data{TicketFreeKey1} = $Row[32];
        $Data{TicketFreeText1} = $Row[33];
        $Data{TicketFreeKey2} = $Row[34];
        $Data{TicketFreeText2} = $Row[35];
        $Data{TicketFreeKey3} = $Row[36];
        $Data{TicketFreeText3} = $Row[37];
        $Data{TicketFreeKey4} = $Row[38];
        $Data{TicketFreeText4} = $Row[39];
        $Data{TicketFreeKey5} = $Row[40];
        $Data{TicketFreeText5} = $Row[41];
        $Data{TicketFreeKey6} = $Row[42];
        $Data{TicketFreeText6} = $Row[43];
        $Data{TicketFreeKey7} = $Row[44];
        $Data{TicketFreeText7} = $Row[45];
        $Data{TicketFreeKey8} = $Row[46];
        $Data{TicketFreeText8} = $Row[47];
        $Data{IncomingTime} = $Row[30];
        $Data{RealTillTimeNotUsed} = $Row[17];
        # strip not wanted stuff
        foreach (qw(From To Cc Subject)) {
            $Data{$_} =~ s/\n|\r//g if ($Data{$_});
        }
        push (@Content, {%Data});
    }

    # get priority name
    $Ticket{Priority} = $Self->PriorityLookup(ID => $Ticket{PriorityID});
    # get queue name and other stuff
    my %Queue = $Self->{QueueObject}->QueueGet(ID => $Ticket{QueueID}, Cache => 1);
    # get state info
    my %StateData = $Self->{StateObject}->StateGet(ID => $Ticket{StateID}, Cache => 1);

    # article stuff
    my $LastCustomerCreateTime = 0;
    foreach my $Part (@Content) {
        # get sender type
        $Part->{SenderType} = $Self->ArticleSenderTypeLookup(
            SenderTypeID => $Part->{SenderTypeID},
        );
        # get article type
        $Part->{ArticleType} = $Self->ArticleTypeLookup(
            ArticleTypeID => $Part->{ArticleTypeID},
        );
        # get priority name
        $Part->{Priority} = $Ticket{Priority};
        $Part->{Queue} = $Queue{Name};
        if (!$Part->{RealTillTimeNotUsed} || $StateData{TypeName} !~ /^pending/i) {
            $Part->{UntilTime} = 0;
        }
        else {
            $Part->{UntilTime} = $Part->{RealTillTimeNotUsed} - time();
        }
        $Part->{StateType} = $StateData{TypeName};
        $Part->{State} = $StateData{Name};
        if ($Queue{EscalationTime} && ($Param{TicketID}||$Param{TicketOverTime}) && $Part->{SenderType} eq 'customer') {
            $LastCustomerCreateTime = (($Part->{IncomingTime} + ($Queue{EscalationTime}*60)) - time());
        }
    }
    foreach my $Part (@Content) {
        $Part->{TicketOverTime} = $LastCustomerCreateTime;
    }
    if ($Param{ArticleID}) {
        return %{$Content[0]};
    }
    else {
        return @Content;
    }
}
# --

1;
