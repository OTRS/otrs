# --
# Kernel/System/Article.pm - global article module for OpenTRS kernel
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Article.pm,v 1.11 2002-07-15 10:38:59 martin Exp $
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

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
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
    foreach (qw(DBObject ConfigObject TicketObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

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
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) || '';
    }
    if (!$Param{Body}) {
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
    File::Path::mkpath([$Path], 0, 0775);# if (! -d $ArticleDir);  
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
    my $ArticleID = $Param{ArticleID} || return;
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
    my $ArticleID = $Param{ArticleID} || return;
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
    my $ArticleID = $Param{ArticleID} || return;
    my $File = $Param{File};
    my $ContentPath = $Self->GetContentPath(ArticleID => $ArticleID);
    my %Data; my $Counter = 0;
    
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
    my $ArticleID = $Param{ArticleID} || return;
    my $Path;
    my $SQL = "SELECT content_path FROM article WHERE id = $ArticleID";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Path = $RowTmp[0];
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
    my $SenderType = $Param{SenderType};

    # check if we ask the same request?
    if (exists $Self->{"Kernel::System::Article::SenderTypeLookup::$SenderType"}) {
        return $Self->{"Kernel::System::Article::SenderTypeLookup::$SenderType"};
    }
    # get data
    my $SQL = "SELECT id FROM article_sender_type WHERE name = '$SenderType'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Kernel::System::Article::SenderTypeLookup::$SenderType"} = $RowTmp[0];
    }
    # check if data exists
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
    my $ArticleType = $Param{ArticleType} || die 'Got no ArticleType!';

    # check if we ask the same request?
    if (exists $Self->{"Kernel::System::Article::ArticleTypeLookup::$ArticleType"}) {
        return $Self->{"Kernel::System::Article::ArticleTypeLookup::$ArticleType"};
    }
    # get data
    my $SQL = "SELECT id FROM article_type WHERE name = '$ArticleType'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Kernel::System::Article::ArticleTypeLookup::$ArticleType"} = $RowTmp[0];
    }
    # check if data exists
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
    my $ArticleID = $Param{ArticleID};
    my %Data;
    my $SenderType = 'customer';
    my $SQL = "SELECT at.a_from, at.a_reply_to, at.a_to, at.a_cc, " .
    " at.a_subject, at.a_message_id, at.a_body, at.ticket_id, at.create_time " .
    " a_content_type " .
    " FROM " .
    " article at, article_sender_type st" .
    " WHERE " .
    " at.id = $ArticleID " .
    " AND " .
    " at.article_sender_type_id = st.id ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $Data{From} = $RowTmp[0];
        $Data{ReplyTo} = $RowTmp[1],
        $Data{To} = $RowTmp[2];
        $Data{Cc} = $RowTmp[3];
        $Data{Subject} = $RowTmp[4];
        $Data{InReplyTo} = $RowTmp[5];
        $Data{Body} = $RowTmp[6];
        $Data{TicketID} = $RowTmp[7];
        $Data{Date} = $RowTmp[8];
        $Data{ContentType} = $RowTmp[9];
        if ($RowTmp[9] && $Data{ContentType} =~ /charset=(.*)(| |\n)/i) {
            $Data{ContentCharset} = $1;
        }
        if ($RowTmp[9] && $Data{ContentType} =~ /^(.+?\/.+?)( |;)/i) {
            $Data{MimeType} = $1;
        } 
    }
    return %Data;
}
# --

1;
