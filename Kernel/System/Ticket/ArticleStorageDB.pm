# --
# Kernel/System/Ticket/ArticleStorageDB.pm - article storage module for OTRS kernel
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: ArticleStorageDB.pm,v 1.6 2003-04-08 21:36:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::ArticleStorageDB;

use strict;
use MIME::Base64;
use MIME::Parser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub InitArticleStorage {
    my $Self = shift;
    my %Param = @_;
    # --
    # ArticleDataDir
    # --
    $Self->{ArticleDataDir} = $Self->{ConfigObject}->Get('ArticleDir')
       || die "Got no ArticleDir!";
    # --
    # create ArticleContentPath
    # --
    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = localtime(time);
    $Self->{Year} = $Year+1900;
    $Self->{Month} = $Month+1;
    $Self->{Month}  = "0$Self->{Month}" if ($Self->{Month} <10);
    $Self->{Day} = $Day;
    $Self->{ArticleContentPath} = $Self->{Year}.'/'.$Self->{Month}.'/'. $Self->{Day};

    return 1;
}
# --
sub DeleteArticleOfTicket {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # delete attachments and plain emails
    # --
    my @Articles = $Self->GetArticleIndex(TicketID => $Param{TicketID});
    foreach (@Articles) {    
        # --
        # delete from db
        # --
        $Self->{DBObject}->Do(SQL => "DELETE FROM article_attachment WHERE article_id = $_");
        $Self->{DBObject}->Do(SQL => "DELETE FROM article_plain WHERE article_id = $_");
    } 
    # --
    # delete articles
    # --
    if ($Self->{DBObject}->Do(SQL => "DELETE FROM article WHERE ticket_id = $Param{TicketID}")) {
        # --
        # delete history´
        # --
        if ($Self->DeleteHistoryOfTicket(TicketID => $Param{TicketID})) {
            return 1;
        }
        else {
            return;
        }
    }
    else {
        return;
    }
}
# --
sub WriteArticle {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ArticleID Email UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if ($Self->WriteArticlePlain(%Param)) {
        # --
        # write article parts
        # --
        my $Parser = new MIME::Parser;
        $Parser->output_to_core("ALL");
        my $Data = $Parser->parse_data($Param{Email});
        foreach my $Part ($Data->parts()) {
            $Self->WriteArticleParts(
                Part => $Part, 
                ArticleID => $Param{ArticleID},
                UserID => $Param{UserID},
            );
        }
        return 1;
    }
    else {
        return;
    }
}
# --
sub WriteArticlePlain {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ArticleID Email UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # write plain article
    # --
    my $PlainString = '';
    foreach (@{$Param{Email}}) {
        $PlainString .= $_;
    }
    # --
    # write article to db 1:1
    # --
    my $SQL = "INSERT INTO article_plain ".
          " (article_id, body, create_time, create_by, change_time, change_by) " .
          " VALUES ".
          " ($Param{ArticleID}, '".$Self->{DBObject}->Quote($PlainString)."', ".
          " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub WriteArticlePart {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(Content Filename ContentType ArticleID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # check used name (we want just uniq names)
    # --
    my $NewFileName = $Param{Filename};
    my %UsedFile = ();
    my %Index = $Self->GetArticleAtmIndex(ArticleID => $Param{ArticleID});
    foreach (keys %Index) {
        $UsedFile{$Index{$_}} = 1;
    }
    for (my $i=1; $i<=12; $i++) {
        if (exists $UsedFile{$NewFileName}) {
            $NewFileName = "$Param{Filename}-$i";
        }
        else {
            $i = 20;
        }
    }
    $Param{Filename} = $NewFileName;
    # --
    # encode attachemnt if it's a postgresql backend!!!
    # --
    if ($Self->{ConfigObject}->Get('DatabaseDSN') =~ /^DBI:Pg/i) {
        $Param{Content} = encode_base64($Param{Content});
    }
    # --
    # write attachment to db
    # --
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    my $SQL = "INSERT INTO article_attachment ".
        " (article_id, filename, content_type, content, ".
        " create_time, create_by, change_time, change_by) " .
        " VALUES ".
        " ($Param{ArticleID}, '$Param{Filename}', '$Param{ContentType}', ".
        " '$Param{Content}', ".
        " current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    }
    else {
        return;
    }
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
    my $Data = '';
    if (!open (DATA, "< $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt")) {
        # can't open article
        # try database
        my $SQL = "SELECT body FROM article_plain ".
        " WHERE ".
        " article_id = $Param{ArticleID}";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
            $Data = $RowTmp[0];
        }
        if ($Data) {
            return $Data;
        }
        else {
            $Self->{LogObject}->Log(
              Priority => 'error', 
              Message => "Can't open $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt: $!",
            );
            return;
        }
    }
    else {
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
sub GetArticleAtmIndex {
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
    my %Index = ();
    my $Counter = 0;
    # try fs
    my @List = glob("$Self->{ArticleDataDir}/$Param{ContentPath}/$Param{ArticleID}/*");
    foreach (@List) {
        $Counter++;
        s!^.*/!!;
        $Index{$Counter} = $_ if ($_ ne 'plain.txt');
    }
    # try database
    if (!%Index) {
        my $SQL = "SELECT filename FROM article_attachment ".
        " WHERE ".
        " article_id = $Param{ArticleID}".
        " ORDER BY id";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
           $Counter++;
           $Index{$Counter} = $RowTmp[0];
        }
    }
    return %Index;
}
# --
sub GetArticleAttachment {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(ArticleID FileID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %Index = $Self->GetArticleAtmIndex(ArticleID => $Param{ArticleID});
    my $ContentPath = $Self->GetArticleContentPath(ArticleID => $Param{ArticleID});
    my %Data; 
    my $Counter = 0;
    $Data{Filename} = $Index{$Param{FileID}}; 
    if (open (DATA, "< $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/$Index{$Param{FileID}}")) {
        while (<DATA>) {
            $Data{ContentType} = $_ if ($Counter == 0);
            $Data{Content} .= $_ if ($Counter > 0);
            $Counter++;
        }
        close (DATA);
        return %Data;
    }
    else {
        # try database
        my $SQL = "SELECT content_type, content FROM article_attachment ".
        " WHERE ".
        " article_id = $Param{ArticleID}";
        $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Param{FileID});
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
            $Data{ContentType} = $RowTmp[0]."\n";
            # --
            # decode attachemnt if it's a postgresql backend!!!
            # --
            if ($Self->{ConfigObject}->Get('DatabaseDSN') =~ /^DBI:Pg/i) {
                $Data{Content} = decode_base64($RowTmp[1]);
            }
            else {
                $Data{Content} = $RowTmp[1];
            }
        }
        if ($Data{Content}) {
            return %Data;
        }
        else {
            $Self->{LogObject}->Log(
              Priority => 'error', 
              Message => "$!: $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/$Index{$Param{FileID}}!",
            );
            return;
        }
    }
}
# --

1;
