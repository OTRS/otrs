# --
# Kernel/System/Web/UploadCache/FS.pm - a fs upload cache
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: FS.pm,v 1.7 2007-03-12 23:58:52 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Web::UploadCache::FS;

use strict;

use vars qw($VERSION);

$VERSION = '$Revision: 1.7 $ ';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(ConfigObject LogObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{TempDir} = $Self->{ConfigObject}->Get('TempDir')."/upload_cache/";
    if (! -d $Self->{TempDir}) {
        mkdir $Self->{TempDir};
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
    my @List = glob("$Self->{TempDir}/$Param{FormID}.*");
    my $Counter = 0;
    my @Data = ();
    foreach my $File (@List) {
        unlink "$File" || die "$!";
    }
    return 1;
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
    # files must readable for creater
    umask(066);
    open (OUT, "> $Self->{TempDir}/$Param{FormID}.$Param{Filename}") || die "$!";
    binmode(OUT);
    print OUT $Param{Content};
    close (OUT);
    open (OUT, "> $Self->{TempDir}/$Param{FormID}.$Param{Filename}.ContentType") || die "$!";
    print OUT $Param{ContentType};
    close (OUT);
    return 1;
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
    my %File = %{$Index[$ID]};
    unlink "$Self->{TempDir}/$Param{FormID}.$File{Filename}" || die "$!: /tmp/up/$File{Filename}";
    unlink "$Self->{TempDir}/$Param{FormID}.$File{Filename}.ContentType" || die "$!: /tmp/up/$File{Filename}.ContentType";
    return 1;
}

sub FormIDGetAllFilesData {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(FormID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my @List = glob("$Self->{TempDir}/$Param{FormID}.*");
    my $Counter = 0;
    my @Data = ();
    foreach my $File (@List) {
        if ($File !~ /\.ContentType$/) {
            $Counter++;
            my $FileSize = -s $File;
            # convert the file name in utf-8 if utf-8 is used
            $File = $Self->{EncodeObject}->Decode(
                Text => $File,
                From => 'utf-8',
            );
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
            my $Content = '';
            open (IN, "< $File") || die "$!";
            binmode(IN);
            while (<IN>) {
                $Content .= $_;
            }
            close (IN);
            my $ContentType = '';
            open (IN, "< $File.ContentType") || die "$!";
            binmode(IN);
            while (<IN>) {
                $ContentType .= $_;
            }
            close (IN);
            # strip filename
            $File =~ s/^.*\/$Param{FormID}\.(.+?)$/$1/;
            push (@Data, {
                Content => $Content,
                ContentType => $ContentType,
                Filename => $File,
                Filesize => $FileSize,
                FileID => $Counter,
            });
        }
    }
    return \@Data;

}

sub FormIDGetAllFilesMeta {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(FormID)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my @List = glob("$Self->{TempDir}/$Param{FormID}.*");
    my $Counter = 0;
    my @Data = ();
    foreach my $File (@List) {
        if ($File !~ /\.ContentType$/) {
            $Counter++;
            my $FileSize = -s $File;
            # convert the file name in utf-8 if utf-8 is used
            $File = $Self->{EncodeObject}->Decode(
                Text => $File,
                From => 'utf-8',
            );
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
            $File =~ s/^.*\/$Param{FormID}\.(.+?)$/$1/;
            push (@Data, {
                Filename => $File,
                Filesize => $FileSize,
                FileID => $Counter,
            });
        }
    }
    return \@Data;
}

sub FormIDCleanUp {
    my $Self = shift;
    my %Param = @_;
    my $CurrentTile = time() - (60*60*24*1);
    my @List = glob("$Self->{TempDir}/*");
    my %RemoveFormIDs = ();
    foreach my $File (@List) {
        # get FormID
        $File =~ s/^.*\/(.+?)\..+?$/$1/;
        if ($CurrentTile > $File) {
            if (!$RemoveFormIDs{$File}) {
                $RemoveFormIDs{$File} = 1;
            }
        }
    }
    foreach (keys %RemoveFormIDs) {
        $Self->FormIDRemove(FormID => $_);
    }
    return 1;
}

1;
