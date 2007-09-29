# --
# Kernel/System/Web/UploadCache/FS.pm - a fs upload cache
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: FS.pm,v 1.9 2007-09-29 10:51:59 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Web::UploadCache::FS;

use strict;
use warnings;

use vars qw($VERSION);

$VERSION = '$Revision: 1.9 $ ';

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ConfigObject LogObject EncodeObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{TempDir} = $Self->{ConfigObject}->Get('TempDir') . "/upload_cache/";
    if ( !-d $Self->{TempDir} ) {
        mkdir $Self->{TempDir};
    }

    return $Self;
}

sub FormIDCreate {
    my $Self  = shift;
    my %Param = @_;

    # cleanup temp form ids
    $Self->FormIDCleanUp();

    # return requested form id
    return time() . '.' . rand(12341241);
}

sub FormIDRemove {
    my $Self  = shift;
    my %Param = @_;
    for (qw(FormID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my @List    = glob("$Self->{TempDir}/$Param{FormID}.*");
    my $Counter = 0;
    my @Data    = ();
    for my $File (@List) {
        $Self->{MainObject}->FileDelete( Location => $File, );
    }
    return 1;
}

sub FormIDAddFile {
    my $Self  = shift;
    my %Param = @_;
    for (qw(FormID Filename Content ContentType)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # files must readable for creater
    if (!$Self->{MainObject}->FileWrite(
            Directory  => $Self->{TempDir},
            Filename   => "$Param{FormID}.$Param{Filename}",
            Content    => \$Param{Content},
            Mode       => 'binmode',
            Permission => '644',
        )
        )
    {
        return;
    }
    if (!$Self->{MainObject}->FileWrite(
            Directory  => $Self->{TempDir},
            Filename   => "$Param{FormID}.$Param{Filename}.ContentType",
            Content    => \$Param{ContentType},
            Mode       => 'binmode',
            Permission => '644',
        )
        )
    {
        return;
    }
    return 1;
}

sub FormIDRemoveFile {
    my $Self  = shift;
    my %Param = @_;
    for (qw(FormID FileID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my @Index = @{ $Self->FormIDGetAllFilesMeta(%Param) };
    my $ID    = $Param{FileID} - 1;
    my %File  = %{ $Index[$ID] };
    $Self->{MainObject}->FileDelete(
        Directory => $Self->{TempDir},
        Filename  => "$Param{FormID}.$File{Filename}",
    );
    $Self->{MainObject}->FileDelete(
        Directory => $Self->{TempDir},
        Filename  => "$Param{FormID}.$File{Filename}.ContentType",
    );
    return 1;
}

sub FormIDGetAllFilesData {
    my $Self  = shift;
    my %Param = @_;
    for (qw(FormID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my @List    = glob("$Self->{TempDir}/$Param{FormID}.*");
    my $Counter = 0;
    my @Data    = ();
    for my $File (@List) {
        if ( $File !~ /\.ContentType$/ ) {
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
                $FileSize = $FileSize - 30 if ( $FileSize > 30 );
                if ( $FileSize > ( 1024 * 1024 ) ) {
                    $FileSize = sprintf "%.1f MBytes", ( $FileSize / ( 1024 * 1024 ) );
                }
                elsif ( $FileSize > 1024 ) {
                    $FileSize = sprintf "%.1f KBytes", ( ( $FileSize / 1024 ) );
                }
                else {
                    $FileSize = $FileSize . ' Bytes';
                }
            }
            my $Content = $Self->{MainObject}->FileRead(
                Location => $File,
                Mode     => 'binmode',    # optional - binmode|utf8
            );
            if ( !$Content ) {
                next;
            }
            my $ContentType = $Self->{MainObject}->FileRead(
                Location => "$File.ContentType",
                Mode     => 'binmode',             # optional - binmode|utf8
            );
            if ( !$ContentType ) {
                next;
            }

            # strip filename
            $File =~ s/^.*\/$Param{FormID}\.(.+?)$/$1/;
            push(
                @Data,
                {   Content     => ${$Content},
                    ContentType => ${$ContentType},
                    Filename    => $File,
                    Filesize    => $FileSize,
                    FileID      => $Counter,
                }
            );
        }
    }
    return \@Data;

}

sub FormIDGetAllFilesMeta {
    my $Self  = shift;
    my %Param = @_;
    for (qw(FormID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my @List    = glob("$Self->{TempDir}/$Param{FormID}.*");
    my $Counter = 0;
    my @Data    = ();
    for my $File (@List) {
        if ( $File !~ /\.ContentType$/ ) {
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
                $FileSize = $FileSize - 30 if ( $FileSize > 30 );
                if ( $FileSize > ( 1024 * 1024 ) ) {
                    $FileSize = sprintf "%.1f MBytes", ( $FileSize / ( 1024 * 1024 ) );
                }
                elsif ( $FileSize > 1024 ) {
                    $FileSize = sprintf "%.1f KBytes", ( ( $FileSize / 1024 ) );
                }
                else {
                    $FileSize = $FileSize . ' Bytes';
                }
            }

            # strip filename
            $File =~ s/^.*\/$Param{FormID}\.(.+?)$/$1/;
            push(
                @Data,
                {   Filename => $File,
                    Filesize => $FileSize,
                    FileID   => $Counter,
                }
            );
        }
    }
    return \@Data;
}

sub FormIDCleanUp {
    my $Self          = shift;
    my %Param         = @_;
    my $CurrentTile   = time() - ( 60 * 60 * 24 * 1 );
    my @List          = glob("$Self->{TempDir}/*");
    my %RemoveFormIDs = ();
    for my $File (@List) {

        # get FormID
        $File =~ s/^.*\/(.+?)\..+?$/$1/;
        if ( $CurrentTile > $File ) {
            if ( !$RemoveFormIDs{$File} ) {
                $RemoveFormIDs{$File} = 1;
            }
        }
    }
    for ( keys %RemoveFormIDs ) {
        $Self->FormIDRemove( FormID => $_ );
    }
    return 1;
}

1;
