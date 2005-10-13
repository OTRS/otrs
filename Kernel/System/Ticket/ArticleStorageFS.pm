# --
# Kernel/System/Ticket/ArticleStorageFS.pm - article storage module for OTRS kernel
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: ArticleStorageFS.pm,v 1.24 2005-10-13 17:24:13 cs Exp $
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
use MIME::Base64;

# --
# to get it writable for the otrs group (just in case)
# --
umask 002;

use vars qw($VERSION);
$VERSION = '$Revision: 1.24 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub ArticleStorageInit {
    my $Self = shift;
    my %Param = @_;
    # ArticleDataDir
    $Self->{ArticleDataDir} = $Self->{ConfigObject}->Get('ArticleDir')
       || die "Got no ArticleDir!";
    # create ArticleContentPath
    my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    $Self->{ArticleContentPath} = $Year.'/'.$Month.'/'.$Day;

    # check fs write permissions!
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
sub ArticleDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # delete attachments and plain emails
    my @Articles = $Self->ArticleIndex(TicketID => $Param{TicketID});
    foreach (@Articles) {
        # delete attachments
        $Self->ArticleDeleteAttachment(
            ArticleID => $_,
            UserID => $Param{UserID},
        );
        # delete plain message
        $Self->ArticleDeletePlain(
            ArticleID => $_,
            UserID => $Param{UserID},
        );
	# delete storage directory
        $Self->ArticleDeleteDir(
            ArticleID => $_,
            UserID => $Param{UserID},
        );
    }
    # delete articles
    if ($Self->{DBObject}->Do(SQL => "DELETE FROM article WHERE ticket_id = $Param{TicketID}")) {
        # delete history
        if ($Self->HistoryDelete(TicketID => $Param{TicketID}, UserID => $Param{UserID})) {
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
sub ArticleDeleteDir {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ArticleID UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # delete directory from fs
    my $ContentPath = $Self->ArticleGetContentPath(ArticleID => $Param{ArticleID});
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}";
    $Self->{LogObject}->Log(Priority => 'error', Message => "Need $Path");
    if (-d $Path) {
        rmdir $Path or die "Can't remove $Path";
    }
    return 1;
}
# --
sub ArticleDeletePlain {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ArticleID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # delete attachments
    $Self->{DBObject}->Do(SQL => "DELETE FROM article_plain WHERE article_id = $Param{ArticleID}");
    # delete from fs
    my $ContentPath = $Self->ArticleGetContentPath(ArticleID => $Param{ArticleID});
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt";
    if (-f $Path) {
        unlink $Path;
    }
    return 1;
}
# --
sub ArticleDeleteAttachment {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ArticleID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # delete attachments
    $Self->{DBObject}->Do(SQL => "DELETE FROM article_attachment WHERE article_id = $Param{ArticleID}");
    # delete from fs
    my $ContentPath = $Self->ArticleGetContentPath(ArticleID => $Param{ArticleID});
    my $Path = "$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}";
    my @List = glob($Path."/*");
    foreach my $File (@List) {
        $File =~ s!^.*/!!;
        if ($File !~ /^plain.txt$/) {
            unlink "$Path/$File" or die "Cannot unlink $Path/$File ($!)";
        }
    }
    return 1;
}
# --
sub ArticleWritePlain {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ArticleID Email UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta($Param{ArticleID});
    $Param{ArticleID} =~ s/\0//g;
    # define path
    my $Path = $Self->{ArticleDataDir}.'/'.$Self->{ArticleContentPath}.'/'.$Param{ArticleID};
    # debug
    if ($Self->{Debug} > 1) {
        $Self->{LogObject}->Log(Message => "->WriteArticle: $Path");
    }
    # write article to fs 1:1
    File::Path::mkpath([$Path], 0, 0775);
    # write article to fs
    if (open (DATA, "> $Path/plain.txt")) {
        binmode(DATA);
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
sub ArticleWriteAttachment {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Content Filename ContentType ArticleID UserID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta($Param{ArticleID});
    $Param{ArticleID} =~ s/\0//g;
    my $ContentPath = $Self->ArticleGetContentPath(ArticleID => $Param{ArticleID});
    # define path
    $Param{Path} = $Self->{ArticleDataDir}.'/'.$ContentPath.'/'.$Param{ArticleID};
    # check used name (we want just uniq names)
    my $NewFileName = decode_mimewords($Param{Filename});
    my %UsedFile = ();
    my @Index = $Self->ArticleAttachmentIndex(
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
    # write attachment to backend
    if (! -d $Param{Path}) {
        if (! File::Path::mkpath([$Param{Path}], 0, 0775)) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Can't create $Param{Path}: $!");
            return;
        }
    }
    # write attachment to fs
    if (open (DATA, "> $Param{Path}/$Param{Filename}")) {
        binmode(DATA);
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
sub ArticlePlain {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }
    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta($Param{ArticleID});
    $Param{ArticleID} =~ s/\0//g;
    # get content path
    my $ContentPath = $Self->ArticleGetContentPath(ArticleID => $Param{ArticleID});
    # open plain article
    my $Data = '';
    if (!open (DATA, "< $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/plain.txt")) {
        # can't open article
        # try database
        my $SQL = "SELECT body FROM article_plain ".
        " WHERE ".
        " article_id = ".$Self->{DBObject}->Quote($Param{ArticleID})."";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Data = $Row[0];
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
        # read whole article
        binmode(DATA);
        while (<DATA>) {
            $Data .= $_;
        }
        close (DATA);
        return $Data;
    }
}
# --
sub ArticleAttachmentIndex {
    my $Self = shift;
    my %Param = @_;
    # check ArticleContentPath
    if (!$Self->{ArticleContentPath}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleContentPath!");
        return;
    }
    # check needed stuff
    if (!$Param{ArticleID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ArticleID!");
      return;
    }
    my $ContentPath = $Self->ArticleGetContentPath(ArticleID => $Param{ArticleID});
    my %Index = ();
    my $Counter = 0;
    # try fs
    my @List = glob("$Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/*");
    foreach (@List) {
        $Counter++;
        my $FileSize = -s $_;
        # human readable file size
        if ($FileSize) {
            # remove meta data in files
            $FileSize = $FileSize - 30 if ($FileSize > 30);
            if ($FileSize > (1024*1024)) {
                $FileSize = sprintf "%.1f MBytes", ($FileSize/(1024*1024));
            }
            elsif ($FileSize > 1024) {
                $FileSize = sprintf "%.1f KBytes", (($FileSize/1024));
            }
            else {
                $FileSize = $FileSize.' Bytes';
            }
        }
        # strip filename
        s!^.*/!!;
        if ($_ ne 'plain.txt') {
            # add the info the the hash
            $Index{$Counter} = {
                Filename => $_,
                Filesize => $FileSize,
            };
        }

    }
    # try database (if there is no index in fs)
    if (!%Index) {
        my $SQL = "SELECT filename, content_type, content_size FROM article_attachment ".
        " WHERE ".
        " article_id = ".$Self->{DBObject}->Quote($Param{ArticleID})."".
        " ORDER BY id";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
           $Counter++;
            # human readable file size
            if ($Row[2]) {
                if ($Row[2] > (1024*1024)) {
                    $Row[2] = sprintf "%.1f MBytes", ($Row[2]/(1024*1024));
                }
                elsif ($Row[2] > 1024) {
                    $Row[2] = sprintf "%.1f KBytes", (($Row[2]/1024));
                }
                else {
                    $Row[2] = $Row[2].' Bytes';
                }
            }
            # add the info the the hash
            $Index{$Counter} = {
                Filename => $Row[0],
                ContentType => $Row[1],
                Filesize => $Row[2] || '',
            };
        }
    }
    return %Index;
}
# --
sub ArticleAttachment {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ArticleID FileID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # prepare/filter ArticleID
    $Param{ArticleID} = quotemeta($Param{ArticleID});
    $Param{ArticleID} =~ s/\0//g;
    # get attachment index
    my %Index = $Self->ArticleAttachmentIndex(ArticleID => $Param{ArticleID});
    # get content path
    my $ContentPath = $Self->ArticleGetContentPath(ArticleID => $Param{ArticleID});
    my %Data = %{$Index{$Param{FileID}}};;
    my $Counter = 0;
    if (open (DATA, "< $Self->{ArticleDataDir}/$ContentPath/$Param{ArticleID}/$Data{Filename}")) {
        binmode(DATA);
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
        # try database
        my $SQL = "SELECT content_type, content FROM article_attachment ".
        " WHERE ".
        " article_id = ".$Self->{DBObject}->Quote($Param{ArticleID})."";
        $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Param{FileID});
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Data{ContentType} = $Row[0];
            # decode attachemnt if it's e. g. a postgresql backend!!!
            if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
                $Data{Content} = decode_base64($Row[1]);
            }
            else {
                $Data{Content} = $Row[1];
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
