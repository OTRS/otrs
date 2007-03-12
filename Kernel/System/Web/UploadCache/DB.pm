# --
# Kernel/System/Web/UploadCache/DB.pm - a db upload cache
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: DB.pm,v 1.6.2.1 2007-03-12 23:55:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Web::UploadCache::DB;

use strict;
use MIME::Base64;

use vars qw($VERSION);

$VERSION = '$Revision: 1.6.2.1 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(ConfigObject LogObject DBObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub FormIDCreate {
    my $Self = shift;
    my %Param = @_;
    # cleanup temp form ids
    $Self->FormIDCleanUp();
    # return requested form id
    return time().'.'.rand(12341241);
}

sub FormIDRemove {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(FormID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM web_upload_cache WHERE form_id = '$Param{FormID}'",
    );
}

sub FormIDAddFile {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(FormID Filename Content ContentType)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # get file size
    {
        use bytes;
        $Param{Filesize} = length($Param{Content});
        no bytes;
    }
    # encode attachemnt if it's a postgresql backend!!!
    $Self->{EncodeObject}->EncodeOutput(\$Param{Content});
    if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
        $Param{Content} = encode_base64($Param{Content});
    }
    # db quote (just not Content, use db Bind values)
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}) if ($_ ne 'Content');
    }
    my $SQL = "INSERT INTO web_upload_cache ".
        " (form_id, filename, content_type, content_size, content, ".
        " create_time_unix) " .
        " VALUES ".
        " ('$Param{FormID}', '$Param{Filename}', '$Param{ContentType}', ".
        " '$Param{Filesize}', ?, ".time().")";
    # write attachment to db
    return $Self->{DBObject}->Do(SQL => $SQL, Bind => [\$Param{Content}]);
}

sub FormIDRemoveFile {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(FormID FileID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my @Index = @{$Self->FormIDGetAllFilesMeta(%Param)};
    my $ID = $Param{FileID}-1;
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM web_upload_cache WHERE form_id = '$Param{FormID}' AND filename = '$Index[$ID]->{Filename}'",
    );
}

sub FormIDGetAllFilesData {
    my $Self = shift;
    my %Param = @_;
    my $Counter = 0;
    my @Data = ();
    foreach (qw(FormID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $SQL = "SELECT filename, content_type, content_size, content FROM web_upload_cache ".
        " WHERE ".
        " form_id = '".$Self->{DBObject}->Quote($Param{FormID})."'".
        " ORDER BY create_time_unix";
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
        # encode attachemnt if it's a postgresql backend!!!
        if (!$Self->{DBObject}->GetDatabaseFunction('DirectBlob')) {
            $Row[3] = decode_base64($Row[3]);
            $Self->{EncodeObject}->Encode(\$Row[3]);
        }
        # add the info
        push (@Data, {
            Content => $Row[3],
            ContentType => $Row[1],
            Filename => $Row[0],
            Filesize => $Row[2],
            FileID => $Counter,
        });
    }
    return \@Data;
}

sub FormIDGetAllFilesMeta {
    my $Self = shift;
    my %Param = @_;
    my $Counter = 0;
    my @Data = ();
    foreach (qw(FormID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $SQL = "SELECT filename, content_type, content_size FROM web_upload_cache ".
        " WHERE ".
        " form_id = '".$Self->{DBObject}->Quote($Param{FormID})."'".
        " ORDER BY create_time_unix";
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
        # add the info
        push (@Data, {
            ContentType => $Row[1],
            Filename => $Row[0],
            Filesize => $Row[2],
            FileID => $Counter,
        });
    }
    return \@Data;
}

sub FormIDCleanUp {
    my $Self = shift;
    my %Param = @_;
    my $CurrentTile = time() - (60*60*24*1);
    return $Self->{DBObject}->Do(
        SQL => "DELETE FROM web_upload_cache WHERE create_time_unix < $CurrentTile",
    );
}

1;
