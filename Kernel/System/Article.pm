# --
# Kernel/System/Article.pm - global article module for OTRS kernel
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Article.pm,v 1.17 2002-09-01 20:24:05 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Article;

use strict;

use File::Path;
use File::Basename;
use MIME::Parser;
use MIME::Words qw(:all);
use Kernel::System::Ticket;

# --
# to get it writable for the otrs group (just in case)
# --
umask 002;

use vars qw($VERSION);
$VERSION = '$Revision: 1.17 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # 0=off; 
    $Self->{Debug} = 0;

    # check needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{TicketObject} = Kernel::System::Ticket->new(%Param);

    $Self->{ArticleDataDir} = $Self->{ConfigObject}->Get('ArticleDir') 
       || die "Got no ArticleDir!";

    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = localtime(time);
    $Self->{Year} = $Year+1900;
    $Self->{Month} = $Month+1;
    $Self->{Month}  = "0$Self->{Month}" if ($Self->{Month} <10);
    $Self->{Day} = $Day;
    $Self->{ContentPath} = $Self->{Year} . "/" . $Self->{Month} . "/" . $Self->{Day};
    return $Self;
}
# --
sub CreateArticle {
    my $Self = shift;
    my %Param = @_;
    my $ValidID 	= $Param{ValidID} || 1;
    my $ContentPath     = $Self->{ContentPath};
    my $IncomingTime    = time();
    # --
    # lockups if no ids!!!
    # --
    if (($Param{ArticleType}) && (!$Param{ArticleTypeID})) {
        $Param{ArticleTypeID} = $Self->ArticleTypeLookup(ArticleType => $Param{ArticleType}); 
    }
    if (($Param{SenderType}) && (!$Param{SenderTypeID})) {
        $Param{SenderTypeID} = $Self->SenderTypeLookup(SenderType => $Param{SenderType});
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
            # mime decode
            $Param{$_} = decode_mimewords($Param{$_});
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
    $ContentPath = $Self->{DBObject}->Quote($ContentPath) || '';
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
	" '$Param{MessageID}', '$Param{Body}', '$Param{ContentType}', '$ContentPath', ".
    " $ValidID,  $IncomingTime, " .
	" current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # get article id 
      if (my $ArticleID = $Self->GetIdOfArticle(
        TicketID => $Param{TicketID},
        MessageID => $Param{MessageID},
        From => $Param{From},
        Subject => $Param{Subject},
        IncomingTime => $IncomingTime
      )) {
        # add history row
        $Self->{TicketObject}->AddHistoryRow(
          ArticleID => $ArticleID,
          TicketID => $Param{TicketID},
          CreateUserID => $Param{UserID},
          HistoryType => $Param{HistoryType},
          Name => $Param{HistoryComment},
        );
        return $ArticleID;
      }
    }
    return;
}
# --
sub WriteArticle {
    my $Self = shift;
    my %Param = @_;
    my $ArticleID = $Param{ArticleID} || return;
    my $GetPlain = $Param{Email} || return;
    my @Plain = @$GetPlain;
    my $Path = $Self->{ArticleDataDir} . "/" . $Self->{Year} . "/" . $Self->{Month} . "/" . 
	$Self->{Day} . "/" . $ArticleID;
    # --
    # debug
    # --
    if ($Self->{Debug} > 0) {
            print STDERR '->WriteArticle: ' . $Path . "\n";
    }
    # --
    # mk dir
    # --
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
            $Self->WritePart(Part => $Part, Path => $Path);
        }
        return 1;
    }
    else {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write: $Path/plain.txt: $!");
        return;
    }
}
# --
sub WritePart {
    my $Self = shift;
    my %Param = @_;
    my $Part = $Param{Part};
    my $Path = $Param{Path};
    $Self->{PartCounter} = $Param{PartCounter} || 0;
    if ($Part->parts() > 0) {
        $Self->{PartCounter}++;
        my $PartCounter1 = 0;
        foreach ($Part->parts()) {
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
            $Self->WritePart(Part => $_, PartCounter => $Self->{PartCounter}, Path => $Path);
        }
    }
    else {
        my $Filename = $Part->head()->recommended_filename() || "file-$Self->{PartCounter}";
        # --
        # debug
        # --
        if ($Self->{Debug} > 0) {
          $Self->{LogObject}->Log(Message => '->GotArticle::Atm->Filename:' . $Filename);
        }
        # --
        # write attachment to fs
        # --
        if (open (DATA, "> $Path/$Filename")) {
          print DATA $Part->effective_type() . "\n";
          print DATA $Part->bodyhandle()->as_string();
          close (DATA);
        }
        else {
          $Self->{LogObject}->Log(Priority => 'error', Message => "Can't write: $Path/$Filename: $!");
          return;
        }
    }
    return 1;
}
# --
sub GetAtmIndex  {
    my $Self = shift;
    my %Param = @_;
    my $ArticleID = $Param{ArticleID} || '';
    # --
    # check needed stuff
    # --
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }

    my $ContentPath = $Param{ContentPath} || '';
    $ContentPath = $Self->GetContentPath(ArticleID => $ArticleID) if (!$ContentPath);
    my @Index;
    my @List = glob("$Self->{ArticleDataDir}/$ContentPath/$ArticleID/*");
    foreach (@List) {
        s!^.*/!!;
        push (@Index, $_) if ($_ ne 'plain.txt');
    }
    return @Index;
}
# --
sub GetPlain {
    my $Self = shift;
    my %Param = @_;
    my $ArticleID = $Param{ArticleID} || '';
    # --
    # check needed stuff
    # --
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }

    my $ContentPath = $Self->GetContentPath(ArticleID => $ArticleID);
    # --
    # open plain article
    # --
    if (!open (DATA, "< $Self->{ArticleDataDir}/$ContentPath/$ArticleID/plain.txt")) {
        # can't open article
        $Self->{LogObject}->Log(
          Priority => 'error', 
          Message => "Can't open $Self->{ArticleDataDir}/$ContentPath/$ArticleID/plain.txt: $!",
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
sub GetAttachment {
    my $Self = shift;
    my %Param = @_;
    my $ArticleID = $Param{ArticleID} || '';
    # --
    # check needed stuff
    # --
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }

    my $File = $Param{File};
    my $ContentPath = $Self->GetContentPath(ArticleID => $ArticleID);
    my %Data; 
    my $Counter = 0;
 
    open (DATA, "< $Self->{ArticleDataDir}/$ContentPath/$ArticleID/$File") or
       print STDERR "$!: $Self->{ArticleDataDir}/$ContentPath/$ArticleID/$File\n";
    while (<DATA>) {
        $Data{Type} = $_ if ($Counter == 0);
        $Data{Data} .= $_ if ($Counter > 0);
        $Data{File} = $File;
        $Counter++;
    }
    close (DATA);
    return %Data;
}
# --
sub GetContentPath {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }

    my $Path;
    my $SQL = "SELECT content_path FROM article WHERE id = $Param{ArticleID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Path = $Row[0];
    }
    return $Path;
}
# --
sub GetIdOfArticle {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $MessageID = $Param{MessageID};
    my $From = $Param{From};
    my $Subject = $Param{Subject};
    my $IncomingTime = $Param{IncomingTime};	
    my $Id;
    my $SQL = "SELECT id FROM article " .
	" WHERE " .
	" ticket_id = $TicketID " .
	" AND " .
	" a_message_id = '$MessageID' " .
	" AND " .
	" a_from = '$From' " .
	" AND " .
	" a_subject = '$Subject'" .
	" AND " .
	" incoming_time = '$IncomingTime'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Id = $RowTmp[0];
    }
    return $Id;
}
# --
sub SenderTypeLookup {
    my $Self = shift;
    my %Param = @_;
    my $SenderType = $Param{SenderType} || '';
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
    if (exists $Self->{"Kernel::System::Article::SenderTypeLookup::$SenderType"}) {
        return $Self->{"Kernel::System::Article::SenderTypeLookup::$SenderType"};
    }
    # --
    # get data
    # --
    my $SQL = "SELECT id FROM article_sender_type WHERE name = '$SenderType'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Kernel::System::Article::SenderTypeLookup::$SenderType"} = $Row[0];
    }
    # --
    # check if data exists
    # --
    if (!exists $Self->{"Kernel::System::Article::SenderTypeLookup::$SenderType"}) {
        print STDERR "Article->SenderTypeLookup(!\$SenderTypeID / $SenderType) \n";
        return;
    }

    return $Self->{"Kernel::System::Article::SenderTypeLookup::$SenderType"};
}
# --
sub ArticleTypeLookup {
    my $Self = shift;
    my %Param = @_;
    my $ArticleType = $Param{ArticleType} || '';
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
    if (exists $Self->{"Kernel::System::Article::ArticleTypeLookup::$ArticleType"}) {
        return $Self->{"Kernel::System::Article::ArticleTypeLookup::$ArticleType"};
    }
    # --
    # get data
    # --
    my $SQL = "SELECT id FROM article_type WHERE name = '$ArticleType'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Kernel::System::Article::ArticleTypeLookup::$ArticleType"} = $Row[0];
    }
    # --
    # check if data exists
    # --
    if (!exists $Self->{"Kernel::System::Article::ArticleTypeLookup::$ArticleType"}) {
        print STDERR "Article->ArticleTypeLookup(!\$ArticleTypeID / $ArticleType)\n";
        return;
    }

    return $Self->{"Kernel::System::Article::ArticleTypeLookup::$ArticleType"};
}
# --
sub SetFreeText {
    my $Self = shift;
    my %Param = @_;
    my $ArticleID = $Param{ArticleID};
    my $UserID = $Param{UserID};
    my $Value = $Param{Value};
    my $Key = $Param{Key};
    my $Counter = $Param{Counter};
    $Value = $Self->{DBObject}->Quote($Value);
    $Key = $Self->{DBObject}->Quote($Key);
    # db update
    my $SQL = "UPDATE article SET a_freekey$Counter = '$Key', " .
	" a_freetext$Counter = '$Value', " .
        " change_time = current_timestamp, change_by = $UserID " .
        " WHERE id = $ArticleID";
    $Self->{DBObject}->Do(SQL => $SQL);
    return 1;
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
    my $SQL = "SELECT sa.ticket_id, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, sa.a_reply_to, ".
        " sa. a_message_id, sa.a_body, " .
        " st.create_time_unix, sp.name, sd.name, sq.name, sq.id, sa.create_time, sa.a_content_type " .
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
        " ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
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
