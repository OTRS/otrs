# --
# Article.pm - global article module for OpenTRS kernel
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Article.pm,v 1.5 2002-04-13 15:50:03 martin Exp $
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
$VERSION = '$Revision: 1.5 $';
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
    foreach ('DBObject', 'ConfigObject') {
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
sub CreateArticleDB {
    my $Self = shift;
    my %Param = @_;
    my $TicketID 	= $Param{TicketID};
    my $ArticleTypeID   = $Param{ArticleTypeID}; 
    my $ArticleType	= $Param{ArticleType};
    my $SenderTypeID 	= $Param{SenderTypeID};
    my $SenderType	= $Param{SenderType};
    my $From 		= $Param{From} || '';
    my $ReplyTo		= $Param{ReplyTo} || '';
    my $To 		= $Param{To} || '';
    my $Cc 		= $Param{Cc} || '';
    my $Subject 	= $Param{Subject} || '';
    my $MessageID 	= $Param{MessageID} || '';
    my $Body 		= $Param{Body} || 'no body found!';
    my $ValidID 	= $Param{ValidID} || 1;
    my $CreateUserID	= $Param{CreateUserID};
    my $ContentPath     = $Self->{ContentPath};
    my $IncomingTime    = time();

    # lockups if no ids!!!
    if (($ArticleType) && (!$ArticleTypeID)) {
        $ArticleTypeID = $Self->ArticleTypeLookup(ArticleType => $ArticleType); 
    }
    if (($SenderType) && (!$SenderTypeID)) {
        $SenderTypeID = $Self->SenderTypeLookup(SenderType => $SenderType);
    }

    # DB Quoting
    $From = $Self->{DBObject}->Quote($From);
    $To = $Self->{DBObject}->Quote($To);
    $Cc = $Self->{DBObject}->Quote($Cc);
    $ReplyTo = $Self->{DBObject}->Quote($ReplyTo);
    $Subject = $Self->{DBObject}->Quote($Subject);
    $Body = $Self->{DBObject}->Quote($Body);
    $MessageID = $Self->{DBObject}->Quote($MessageID);
    $ContentPath = $Self->{DBObject}->Quote($ContentPath);

    # do db insert
    my $SQL = "INSERT INTO article (ticket_id, article_type_id, article_sender_type_id, a_from, a_reply_to, a_to, " .
	" a_cc, a_subject, a_message_id, a_body, content_path, valid_id, incoming_time, " .
	" create_time, create_by, change_time, change_by) " .
	"VALUES ($TicketID, $ArticleTypeID, $SenderTypeID, '$From', '$ReplyTo', '$To', '$Cc', '$Subject', ". 
	" '$MessageID', '$Body', '$ContentPath', $ValidID,  $IncomingTime, " .
	" current_timestamp, $CreateUserID, current_timestamp, $CreateUserID)";
    $Self->{DBObject}->Do(SQL => $SQL);

    # get article id 
    my $ArticleID = $Self->GetIdOfArticle(
        TicketID => $TicketID,
        MessageID => $MessageID,
        From => $From,
        Subject => $Subject,
        IncomingTime => $IncomingTime
    );

    return $ArticleID;
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
    if ($Self->{Debug} > 0) {
            print STDERR '->WriteArticle: ' . $Path . "\n";
    }

    File::Path::mkpath([$Path], 0, 0775);# if (! -d $ArticleDir);  

    open (DATA, "> $Path/plain.txt") or print "$! \n";
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
            if ($Self->{Debug} > 0) {
                print STDERR "Sub part($Self->{PartCounter}/$PartCounter1)!\n";
            }
            $Self->WritePart(Part => $_, PartCounter => $Self->{PartCounter}, Path => $Path);
        }
    }
    else {
        my $Filename = $Part->head()->recommended_filename() || "file-$Self->{PartCounter}";
        if ($Self->{Debug} > 0) {
            print STDERR '->GotArticle::Atm->Filename:' . $Filename . "\n";
        }
        open (DATA, "> $Path/$Filename") or print STDERR "$!: $Path/$Filename \n";
        print DATA $Part->effective_type() . "\n";
        print DATA $Part->bodyhandle()->as_string();
        close (DATA);
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
    my $Data = '';
    open (DATA, "< $Self->{ArticleDataDir}/$ContentPath/$ArticleID/plain.txt") || 
       print STDERR "$!: $Self->{ArticleDataDir}/$ContentPath/$ArticleID/plain.txt\n";
    while (<DATA>) {
        $Data .= $_;
    }
    close (DATA);
    return $Data;
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
    " at.a_subject, at.a_message_id, at.a_body, ticket_id " .
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
    }
    return %Data;
}
# --

1;
