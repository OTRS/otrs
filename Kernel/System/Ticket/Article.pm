# --
# Kernel/System/Ticket/Article.pm - global article module for OTRS kernel
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Article.pm,v 1.1 2002-10-03 17:27:39 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Article;

use strict;

use File::Path;
use File::Basename;
use MIME::Parser;

# --
# to get it writable for the otrs group (just in case)
# --
umask 002;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub CreateArticle {
    my $Self = shift;
    my %Param = @_;
    my $ValidID 	= $Param{ValidID} || 1;
    my $IncomingTime    = time();
    # --
    # check ArticleContentPath
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
    # DB Quoting
    # --
    foreach (qw(From To Cc ReplyTo Subject Body MessageID ContentType)) {
        if ($Param{$_}) {
            # qb quoting
            $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
        }
        else {
            $Param{$_} = '';
        }
    }
    if (!$Param{Body}) {
        # add 'no body found!' if there is no body there!
        $Param{Body} = 'no body found!';
    }
    else {
        # fix some bad stuff from browsers!
        $Param{Body} =~ s/(\n\r|\r\n)/\n/g;
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
    " '$Param{From}', '$Param{ReplyTo}', '$Param{To}', '$Param{Cc}', '$Param{Subject}', ". 
	" '$Param{MessageID}', '$Param{Body}', '$Param{ContentType}', ".
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
        MessageID => $Param{MessageID},
        From => $Param{From},
        Subject => $Param{Subject},
        IncomingTime => $IncomingTime
    ); 
    # --
    # return if there is not article created
    # --
    if (!$ArticleID) {
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
    my $TicketNumber = $Self->GetTNOfId(ID => $Param{TicketID});
    my $QueueID = $Self->GetQueueIDOfTicketID(TicketID => $Param{TicketID});
    if ($Param{AutoResponseType} && $Param{OrigHeader}) {
        # get auto default responses
        my %Data = $Self->{AutoResponse}->AutoResponseGetByTypeQueueID(
            QueueID => $QueueID, 
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
                      "$TicketNumber] ($OrigHeader{From}) "
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
                    $Self->{SendAutoResponse}->Send(
                        %Data,
                        CustomerMessageParams => \%OrigHeader,
                        TicketNumber => $TicketNumber, 
                        TicketID => $Param{TicketID},
                        UserID => $Param{UserID}, 
                        HistoryType => $SendInfo{AutoResponseHistoryType},
                    );
                }
            }
        }
    }
    # --
    # send agent notification!?
    # --
    my $To = '';
    if ($Param{HistoryType} =~ /^NewTicket$/i ||  $Param{HistoryType} =~ /^PhoneCallCustomer$/i) {
		foreach ($Self->{QueueObject}->GetAllUserIDsByQueueID(QueueID => $QueueID)) {
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
    $Self->{SendNotification}->Send(
        Type => $Param{HistoryType},
        To => $To,
        CustomerMessageParams => \%Param,
        TicketNumber => $TicketNumber,
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
sub WriteArticle {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ArticleID Email)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my @Plain = @{$Param{Email}};
    my $Path = $Self->{ArticleDataDir}.'/'.$Self->{ArticleContentPath}.'/'.$Param{ArticleID};
    # --
    # debug
    # --
    if ($Self->{Debug} > 0) {
        print STDERR '->WriteArticle: ' . $Path . "\n";
    }
    # --
    # mk dir
    # --
    # test for bert preiss!
#    File::Path::mkpath([$Path], 0, 0775);
    if (! File::Path::mkpath([$Path], 0, 0775)) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't create $Path: $!");
        return;
    }
    # --
    # write article to fs 1:1
    # --
    if (open (DATA, "> $Path/plain.txt")) { 
        print DATA @Plain;
        close (DATA);
        # store atms.
        my $Parser = new MIME::Parser;
        $Parser->output_to_core("ALL");
        my $Data;
        eval { $Data = $Parser->parse_open("$Path/plain.txt") };
        foreach my $Part ($Data->parts()) {
            $Self->WriteArticleParts(Part => $Part, Path => $Path);
        }
        return 1;
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write: $Path/plain.txt: $!");
        return;
    }
}
# --
sub WriteArticleParts {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Part Path)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }

    $Self->{PartCounter} = $Param{PartCounter} || 0;
    if ($Param{Part}->parts() > 0) {
        $Self->{PartCounter}++;
        my $PartCounter1 = 0;
        foreach ($Param{Part}->parts()) {
            $PartCounter1++;
            # --
            # debug
            # --
            if ($Self->{Debug} > 0) {
              $Self->{LogObject}->Log(Message => "Sub part($Self->{PartCounter}/$PartCounter1)!");
            }
            # --
            # there is a part in the current part
            # --
            $Self->WriteArticleParts(
                Part => $_, 
                PartCounter => $Self->{PartCounter}, 
                Path => $Param{Path},
            );
        }
    }
    else {
        my $Filename = $Param{Part}->head()->recommended_filename() || "file-$Self->{PartCounter}";
        # --
        # debug
        # --
        if ($Self->{Debug} > 0) {
          $Self->{LogObject}->Log(Message => '->GotArticle::Atm->Filename:' . $Filename);
        }
        # --
        # write attachment to fs
        # --
        if (open (DATA, "> $Param{Path}/$Filename")) {
          print DATA $Param{Part}->effective_type() . "\n";
          print DATA $Param{Part}->bodyhandle()->as_string();
          close (DATA);
        }
        else {
          $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write: $Param{Path}/$Filename: $!");
          return;
        }
    }
    return 1;
}
# --
sub GetArticleAtmIndex  {
    my $Self = shift;
    my %Param = @_;
    # --
    # check ArticleContentPath
    # --
    if (!$Self->{ArticleContentPath}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleContentPath!");
        return;
    }
    # --
    # check needed stuff
    # --
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }
    # --
    # get ContentPath if not given
    # --
    if (!$Param{ContentPath}) {
        $Param{ContentPath} = $Self->GetArticleContentPath(ArticleID => $Param{ArticleID});
    }
    my @Index;
    my @List = glob("$Self->{ArticleDataDir}/$Param{ContentPath}/$Param{ArticleID}/*");
    foreach (@List) {
        s!^.*/!!;
        push (@Index, $_) if ($_ ne 'plain.txt');
    }
    return @Index;
}
# --
sub GetArticlePlain {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }

    my $ContentPath = $Self->GetArticleContentPath(ArticleID => $Param{ArticleID});
    # --
    # open plain article
    # --
    if (!open (DATA, "< $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt")) {
        # can't open article
        $Self->{LogObject}->Log(
          Priority => 'error', 
          Message => "Can't open $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt: $!",
        );
        return;
    }
    else {
        my $Data = '';
        # --
        # read whole article
        # --
        while (<DATA>) {
            $Data .= $_;
        }
        close (DATA);
        return $Data;
    }
}
# --
sub GetArticleAttachment {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ArticleID File)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $ContentPath = $Self->GetArticleContentPath(ArticleID => $Param{ArticleID});
    my %Data; 
    my $Counter = 0;
    $Data{File} = $Param{File}; 
    if (open (DATA, "< $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/$Param{File}")) {
        while (<DATA>) {
            $Data{Type} = $_ if ($Counter == 0);
            $Data{Data} .= $_ if ($Counter > 0);
            $Counter++;
        }
        close (DATA);
        return %Data;
    }
    else {
        $Self->{LogObject}->Log(
          Priority => 'error', 
          Message => "$!: $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/$Param{File}!",
        );
        return;
    }
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
    # sql query
    # --
    my $Path;
    $Self->{DBObject}->Prepare(
        SQL => "SELECT content_path FROM article WHERE id = $Param{ArticleID}",
    );
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Path = $Row[0];
    }
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
    my $ArticleID = '';
    my $SenderType = 'customer';
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
    $Self->{DBObject}->Prepare(
      SQL => "SELECT at.id" .
        " FROM " .
        " article at, article_sender_type st" .
        " WHERE " .
        " at.article_sender_type_id = st.id " .
        " AND " .
        " st.name = '$SenderType' " .
        " AND " .
        " at.ticket_id = $Param{TicketID} " .
        " ORDER BY at.incoming_time",
    );
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $ArticleID = $RowTmp[0];
    }
    # --
    # get article data   
    # --
    return $Self->GetArticle(ArticleID => $ArticleID);
}
# --
sub GetArticle {
    my $Self = shift;
    my %Param = @_;
    my %Data;
    # --
    # check needed stuff
    # --
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }
    # --
    # sql query
    # --
    $Self->{DBObject}->Prepare(
      SQL => "SELECT sa.ticket_id, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, sa.a_reply_to, ".
        " sa. a_message_id, sa.a_body, " .
        " st.create_time_unix, sp.name, sd.name, sq.name, sq.id, sa.create_time, ".
        " sa.a_content_type, sa.create_by " .
        " FROM " .
        " article sa, ticket st, ticket_priority sp, ticket_state sd, queue sq" .
        " where " . 
        " sa.id = $Param{ArticleID}" .
        " and " .
        " sa.ticket_id = st.id " .
        " and " .
        " sq.id = st.queue_id " .
        " and " .
        " sp.id = st.ticket_priority_id " .
        " and " .
        " st.ticket_state_id = sd.id " .
        " ",
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
        $Data{State} = $Row[10];
        $Data{Queue} = $Row[11];
        $Data{QueueID} = $Row[12];
        $Data{Date} = $Row[13];
        $Data{Created} = $Row[13];
        $Data{ContentType} = $Row[14];
        $Data{CreatedBy} = $Row[15];
        if ($Row[14] && $Data{ContentType} =~ /charset=(.*)(| |\n)/i) {
            $Data{ContentCharset} = $1;
        }
        if ($Row[14] && $Data{ContentType} =~ /^(.+?\/.+?)( |;)/i) {
            $Data{MimeType} = $1;
        } 
    }
    return %Data;
}
# --

1;
