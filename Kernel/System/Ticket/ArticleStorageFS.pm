# --
# Kernel/System/Ticket/ArticleStorageFS.pm - article storage module for OTRS kernel
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: ArticleStorageFS.pm,v 1.8 2003-04-23 17:43:42 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::ArticleStorageFS;

use strict;
use File::Path;
use File::Basename;
use MIME::Words qw(:all);

# --
# to get it writable for the otrs group (just in case)
# --
umask 002;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
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

    # --
    # check fs write permissions!
    # --
    my $Path = "$Self->{ArticleDataDir}/$Self->{ArticleContentPath}/check_permissons.$$";
    if (-d $Path) {
        File::Path::rmtree([$Path]) || die "Can't remove $Path: $!\n";
    }
    if (mkdir("$Self->{ArticleDataDir}/check_permissons_$$", 022)) {
        if (!rmdir("$Self->{ArticleDataDir}/check_permissons_$$")) {
            die "Can't remove $Self->{ArticleDataDir}/check_permissons_$$: $!\n";
        }
        if (File::Path::mkpath([$Path], 0, 0775)) {
            File::Path::rmtree([$Path]) || die "Can't remove $Path: $!\n";
        }
    }
    else {
        my $Error = $!;
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Can't create $Self->{ArticleDataDir}/check_permissons_$$: $Error, ".
            "Try: \$OTRS_HOME/bin/SetPermissions.sh !",
        );
        die "Error: Can't create $Self->{ArticleDataDir}/check_permissons_$$: $Error \n\n ".
            "Try: \$OTRS_HOME/bin/SetPermissions.sh !!!\n";
    }
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
        # delete from fs
        # --
        my $ContentPath = $Self->GetArticleContentPath(ArticleID => $_);
        system("rm -rf $Self->{ArticleDataDir}/$ContentPath/$_/*");
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
    my $Path = $Self->{ArticleDataDir}.'/'.$Self->{ArticleContentPath}.'/'.$Param{ArticleID};
    # --
    # debug
    # --
    if ($Self->{Debug} > 1) {
        $Self->{LogObject}->Log(Message => "->WriteArticle: $Path");
    }
    # --
    # write article to fs 1:1
    # --
    File::Path::mkpath([$Path], 0, 0775);
    # --
    # write article to fs 
    # --
    if (open (DATA, "> $Path/plain.txt")) { 
        print DATA $Param{Email};
        close (DATA);
        return 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error', 
            Message => "Can't write: $Path/plain.txt: $!",
        );
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
    $Param{Path} = $Self->{ArticleDataDir}.'/'.$Self->{ArticleContentPath}.'/'.$Param{ArticleID};
    # --
    # check used name (we want just uniq names)
    # --
    my $NewFileName = decode_mimewords($Param{Filename});
    my %UsedFile = ();
    my @Index = $Self->GetArticleAtmIndex(
        ArticleID => $Param{ArticleID},
    );
    foreach (@Index) {
        $UsedFile{$_} = 1;
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
    # write attachment to backend           
    # --
    if (! -d $Param{Path}) {
        if (! File::Path::mkpath([$Param{Path}], 0, 0775)) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Can't create $Param{Path}: $!");
            return;
        }
    }
    # --
    # write attachment to fs
    # --
    if (open (DATA, "> $Param{Path}/$Param{Filename}")) {
        print DATA "$Param{ContentType}\n";
        print DATA $Param{Content};
        close (DATA);
        return 1;
    }
    else {
        $Self->{LogObject}->Log(
            Priority => 'error', 
            Message => "Can't write: $Param{Path}/$Param{Filename}: $!",
        );
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
        $Self->{LogObject}->Log(
            Priority => 'error', 
            Message => "Can't open $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt: $!",
        );
        return;
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
    my $ContentPath = $Self->GetArticleContentPath(ArticleID => $Param{ArticleID});
    my %Index = ();
    my $Counter = 0;
    # try fs
    my @List = glob("$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/*");
    foreach (@List) {
        $Counter++;
        s!^.*/!!;
        $Index{$Counter} = $_ if ($_ ne 'plain.txt');
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
        chomp ($Data{ContentType});
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
# --

1;
