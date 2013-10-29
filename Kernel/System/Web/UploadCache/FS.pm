# --
# Kernel/System/Web/UploadCache/FS.pm - a fs upload cache
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::UploadCache::FS;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ConfigObject LogObject EncodeObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{TempDir} = $Self->{ConfigObject}->Get('TempDir') . '/upload_cache/';
    if ( !-d $Self->{TempDir} ) {
        mkdir $Self->{TempDir};
    }

    return $Self;
}

sub FormIDCreate {
    my ( $Self, %Param ) = @_;

    # cleanup temp form ids
    $Self->FormIDCleanUp();

    # return requested form id
    return time() . '.' . rand(12341241);
}

sub FormIDRemove {
    my ( $Self, %Param ) = @_;

    if ( !$Param{FormID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need FormID!' );
        return;
    }

    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{TempDir},
        Filter    => "$Param{FormID}.*",
    );
    my @Data;
    for my $File (@List) {
        $Self->{MainObject}->FileDelete( Location => $File, );
    }
    return 1;
}

sub FormIDAddFile {
    my ( $Self, %Param ) = @_;

    for (qw(FormID Filename Content ContentType)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # create content id
    my $ContentID = $Param{ContentID};
    my $Disposition = $Param{Disposition} || '';
    if ( !$ContentID && lc $Disposition eq 'inline' ) {
        my $Random = rand 999999;
        my $FQDN   = $Self->{ConfigObject}->Get('FQDN');
        $ContentID = "$Disposition$Random.$Param{FormID}\@$FQDN";
    }

    # files must readable for creator
    return if !$Self->{MainObject}->FileWrite(
        Directory  => $Self->{TempDir},
        Filename   => "$Param{FormID}.$Param{Filename}",
        Content    => \$Param{Content},
        Mode       => 'binmode',
        Permission => '640',
    );
    return if !$Self->{MainObject}->FileWrite(
        Directory  => $Self->{TempDir},
        Filename   => "$Param{FormID}.$Param{Filename}.ContentType",
        Content    => \$Param{ContentType},
        Mode       => 'binmode',
        Permission => '640',
    );
    return if !$Self->{MainObject}->FileWrite(
        Directory  => $Self->{TempDir},
        Filename   => "$Param{FormID}.$Param{Filename}.ContentID",
        Content    => \$ContentID,
        Mode       => 'binmode',
        Permission => '640',
    );
    return 1;
}

sub FormIDRemoveFile {
    my ( $Self, %Param ) = @_;

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
    $Self->{MainObject}->FileDelete(
        Directory => $Self->{TempDir},
        Filename  => "$Param{FormID}.$File{Filename}.ContentID",
    );
    return 1;
}

sub FormIDGetAllFilesData {
    my ( $Self, %Param ) = @_;

    if ( !$Param{FormID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need FormID!' );
        return;
    }

    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{TempDir},
        Filter    => "$Param{FormID}.*",
    );

    my $Counter = 0;
    my @Data;
    for my $File (@List) {

        # ignore meta files
        next if $File =~ /\.ContentType$/;
        next if $File =~ /\.ContentID$/;

        $Counter++;
        my $FileSize = -s $File;

        # human readable file size
        if ($FileSize) {

            # remove meta data in files
            if ( $FileSize > 30 ) {
                $FileSize = $FileSize - 30
            }
            if ( $FileSize > 1048576 ) {    # 1024 * 1024
                $FileSize = sprintf "%.1f MBytes", ( $FileSize / 1048576 );    # 1024 * 1024
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
        next if !$Content;

        my $ContentType = $Self->{MainObject}->FileRead(
            Location => "$File.ContentType",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next if !$ContentType;

        my $ContentID = $Self->{MainObject}->FileRead(
            Location => "$File.ContentID",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next if !$ContentID;

        # verify if content id is empty, set to undef
        if ( !${$ContentID} ) {
            ${$ContentID} = undef;
        }

        # strip filename
        $File =~ s/^.*\/$Param{FormID}\.(.+?)$/$1/;
        push(
            @Data,
            {
                Content     => ${$Content},
                ContentID   => ${$ContentID},
                ContentType => ${$ContentType},
                Filename    => $File,
                Filesize    => $FileSize,
                FileID      => $Counter,
            },
        );
    }
    return \@Data;

}

sub FormIDGetAllFilesMeta {
    my ( $Self, %Param ) = @_;

    if ( !$Param{FormID} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need FormID!' );
        return;
    }

    my @List = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{TempDir},
        Filter    => "$Param{FormID}.*",
    );

    my $Counter = 0;
    my @Data;
    for my $File (@List) {

        # ignore meta files
        next if $File =~ /\.ContentType$/;
        next if $File =~ /\.ContentID$/;

        $Counter++;
        my $FileSize = -s $File;

        # human readable file size
        if ($FileSize) {

            # remove meta data in files
            if ( $FileSize > 30 ) {
                $FileSize = $FileSize - 30
            }
            if ( $FileSize > 1048576 ) {    # 1024 * 1024
                $FileSize = sprintf "%.1f MBytes", ( $FileSize / 1048576 );    # 1024 * 1024
            }
            elsif ( $FileSize > 1024 ) {
                $FileSize = sprintf "%.1f KBytes", ( ( $FileSize / 1024 ) );
            }
            else {
                $FileSize = $FileSize . ' Bytes';
            }
        }

        my $ContentType = $Self->{MainObject}->FileRead(
            Location => "$File.ContentType",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next if !$ContentType;

        my $ContentID = $Self->{MainObject}->FileRead(
            Location => "$File.ContentID",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next if !$ContentID;

        # verify if content id is empty, set to undef
        if ( !${$ContentID} ) {
            ${$ContentID} = undef;
        }

        # strip filename
        $File =~ s/^.*\/$Param{FormID}\.(.+?)$/$1/;
        push(
            @Data,
            {
                ContentID   => ${$ContentID},
                ContentType => ${$ContentType},
                Filename    => $File,
                Filesize    => $FileSize,
                FileID      => $Counter,
            },
        );
    }
    return \@Data;
}

sub FormIDCleanUp {
    my ( $Self, %Param ) = @_;

    my $CurrentTile = time() - 86400;                       # 60 * 60 * 24 * 1
    my @List        = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{TempDir},
        Filter    => '*'
    );
    my %RemoveFormIDs;
    for my $File (@List) {

        # get FormID
        $File =~ s/^.*\/(.+?)\..+?$/$1/;
        if ( $CurrentTile > $File ) {
            if ( !$RemoveFormIDs{$File} ) {
                $RemoveFormIDs{$File} = 1;
            }
        }
    }
    for ( sort keys %RemoveFormIDs ) {
        $Self->FormIDRemove( FormID => $_ );
    }
    return 1;
}

1;
