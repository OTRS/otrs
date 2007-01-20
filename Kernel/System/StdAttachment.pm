# --
# Kernel/System/StdAttachment.pm - lib for std attachemnt
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: StdAttachment.pm,v 1.15 2007-01-20 23:11:34 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::StdAttachment;

use strict;
use MIME::Base64;
use Kernel::System::Encode;

use vars qw($VERSION);
$VERSION = '$Revision: 1.15 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get common objects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(DBObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    $Self->{EncodeObject} = Kernel::System::Encode->new(%Param);

    return $Self;
}

sub StdAttachmentAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Name ValidID Content ContentType Filename UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # encode attachemnt if it's a postgresql backend!!!
    if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
        $Self->{EncodeObject}->EncodeOutput(\$Param{Content});
        $Param{Content} = encode_base64($Param{Content});
    }
    # db quote
    foreach (qw(Name ContentType Filename Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "INSERT INTO standard_attachment ".
        " (name, content_type, content, filename, valid_id, comments, ".
        " create_time, create_by, change_time, change_by)".
        " VALUES ".
        " ('$Param{Name}', '$Param{ContentType}', ?, '$Param{Filename}', ".
        " $Param{ValidID}, '$Param{Comment}', ".
        " current_timestamp, $Param{UserID}, current_timestamp,  $Param{UserID})";
    if ($Self->{DBObject}->Do(SQL => $SQL, Bind => [\$Param{Content}])) {
        my $Id = 0;
        $Self->{DBObject}->Prepare(
            SQL => "SELECT id FROM standard_attachment WHERE ".
                "name = '$Param{Name}' AND content_type = '$Param{ContentType}'",
        );
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Id = $Row[0];
        }
        return $Id;
    }
    else {
        return;
    }
}

sub StdAttachmentGet {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
        return;
    }
    # db quote
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "SELECT name, content_type, content, filename, valid_id, comments ".
        " FROM ".
        " standard_attachment ".
        " WHERE ".
        " id = $Param{ID}";
    if (!$Self->{DBObject}->Prepare(SQL => $SQL)) {
        return;
    }
    if (my @Data = $Self->{DBObject}->FetchrowArray()) {
        # decode attachemnt if it's a postgresql backend!!!
        if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
            $Data[2] = decode_base64($Data[2]);
        }
        my %Data = (
            ID => $Param{ID},
            Name => $Data[0],
            ContentType => $Data[1],
            Content => $Data[2],
            Filename => $Data[3],
            ValidID => $Data[4],
            Comment => $Data[5],
        );
        return %Data;
    }
    else {
        return;
    }
}

sub StdAttachmentUpdate {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID Name ValidID Content ContentType Filename UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # encode attachemnt if it's a postgresql backend!!!
    if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
        $Self->{EncodeObject}->EncodeOutput(\$Param{Content});
        $Param{Content} = encode_base64($Param{Content});
    }
    # db quote
    foreach (qw(Name ContentType Filename Comment)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(ID ValidID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql
    my $SQL = "UPDATE standard_attachment SET " .
        " name = '$Param{Name}', " .
        " content = ?, " .
        " content_type = '$Param{ContentType}', " .
        " comments = '$Param{Comment}', " .
        " filename = '$Param{Filename}', " .
        " valid_id = $Param{ValidID}, " .
        " change_time = current_timestamp, " .
        " change_by = $Param{UserID} " .
        " WHERE " .
        " id = $Param{ID}";
    if ($Self->{DBObject}->Do(SQL => $SQL, Bind => [\$Param{Content}])) {
        return 1;
    }
    else {
        return;
    }
}

sub StdAttachmentDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # sql
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    if ($Self->{DBObject}->Do(SQL => "DELETE FROM standard_attachment WHERE ID = $Param{ID}")) {
        return 1;
    }
    else {
        return;
    }
}

sub StdAttachmentLookup {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{StdAttachment} && !$Param{StdAttachmentID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Got no StdAttachment or StdAttachment!");
        return;
    }
    # check if we ask the same request?
    if ($Param{StdAttachmentID} && $Self->{"StdAttachmentLookup$Param{StdAttachmentID}"}) {
        return $Self->{"StdAttachmentLookup$Param{StdAttachmentID}"};
    }
    if ($Param{StdAttachment} && $Self->{"StdResponseLookup$Param{StdAttachment}"}) {
        return $Self->{"StdAttachmentLookup$Param{StdAttachment}"};
    }
    # get data
    my $SQL = '';
    my $Suffix = '';
    if ($Param{StdAttachment}) {
        $Suffix = 'StdAttachmentID';
        $SQL = "SELECT id FROM standard_attachment WHERE name = '".$Self->{DBObject}->Quote($Param{StdAttachment})."'";
    }
    else {
        $Suffix = 'StdAttachment';
        $SQL = "SELECT name FROM standard_attachment WHERE id = ".$Self->{DBObject}->Quote($Param{StdAttachmentID}, 'Integer')."";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"StdAttachment$Suffix"} = $Row[0];
    }
    # check if data exists
    if (!exists $Self->{"StdAttachment$Suffix"}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Found no \$$Suffix!");
        return;
    }

    return $Self->{"StdAttachment$Suffix"};
}

sub StdAttachmentsByResponseID {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{ID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Got no ID!");
        return;
    }
    # db quote
    foreach (qw(ID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # return data
    my %Relation = $Self->{DBObject}->GetTableData(
        Table => 'standard_response_attachment',
        What => 'standard_attachment_id, standard_response_id',
        Where => "standard_response_id = $Param{ID}",
    );
    my %AllStdAttachments = $Self->GetAllStdAttachments(Valid => 1);
    my %Data = ();
    foreach (keys %Relation) {
        $Data{$_} = $AllStdAttachments{$_};
    }
    return %Data;
}

sub GetAllStdAttachments {
    my $Self = shift;
    my %Param = @_;
    if (!defined $Param{Valid}) {
        $Param{Valid} = 1;
    }
    # return data
    return $Self->{DBObject}->GetTableData(
        Table => 'standard_attachment',
        What => 'id, name, filename',
        Clamp => 1,
        Valid => $Param{Valid},
    );
}

sub SetStdAttachmentsOfResponseID {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(ID AttachmentIDsRef UserID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # db quote
    foreach (qw(ID UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # add attachments to response
    $Self->{DBObject}->Do(
        SQL => "DELETE FROM standard_response_attachment WHERE standard_response_id = $Param{ID}",
    );
    foreach (@{$Param{AttachmentIDsRef}}) {
        my $SQL = "INSERT INTO standard_response_attachment (standard_attachment_id, ".
            "standard_response_id, create_time, create_by, change_time, change_by)" .
            " VALUES " .
            " ( $_, $Param{ID}, current_timestamp, $Param{UserID}, current_timestamp, $Param{UserID})";
        $Self->{DBObject}->Do(SQL => $SQL);
    }
    return 1;
}

1;