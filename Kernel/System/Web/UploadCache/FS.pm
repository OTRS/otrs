# --
# Kernel/System/Web/UploadCache/FS.pm - a fs upload cache
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Web::UploadCache::FS;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{TempDir} = $Kernel::OM->Get('Kernel::Config')->Get('TempDir') . '/upload_cache/';

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
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need FormID!'
        );
        return;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List = $MainObject->DirectoryRead(
        Directory => $Self->{TempDir},
        Filter    => "$Param{FormID}.*",
    );

    my @Data;
    for my $File (@List) {
        $MainObject->FileDelete(
            Location => $File,
        );
    }

    return 1;
}

sub FormIDAddFile {
    my ( $Self, %Param ) = @_;

    for (qw(FormID Filename Content ContentType)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # create content id
    my $ContentID = $Param{ContentID};
    my $Disposition = $Param{Disposition} || '';
    if ( !$ContentID && lc $Disposition eq 'inline' ) {

        my $Random = rand 999999;
        my $FQDN   = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

        $ContentID = "$Disposition$Random.$Param{FormID}\@$FQDN";
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # files must readable for creator
    return if !$MainObject->FileWrite(
        Directory  => $Self->{TempDir},
        Filename   => "$Param{FormID}.$Param{Filename}",
        Content    => \$Param{Content},
        Mode       => 'binmode',
        Permission => '640',
    );
    return if !$MainObject->FileWrite(
        Directory  => $Self->{TempDir},
        Filename   => "$Param{FormID}.$Param{Filename}.ContentType",
        Content    => \$Param{ContentType},
        Mode       => 'binmode',
        Permission => '640',
    );
    return if !$MainObject->FileWrite(
        Directory  => $Self->{TempDir},
        Filename   => "$Param{FormID}.$Param{Filename}.ContentID",
        Content    => \$ContentID,
        Mode       => 'binmode',
        Permission => '640',
    );
    return if !$MainObject->FileWrite(
        Directory  => $Self->{TempDir},
        Filename   => "$Param{FormID}.$Param{Filename}.Disposition",
        Content    => \$Disposition,
        Mode       => 'binmode',
        Permission => '644',
    );
    return 1;
}

sub FormIDRemoveFile {
    my ( $Self, %Param ) = @_;

    for (qw(FormID FileID)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my @Index = @{ $Self->FormIDGetAllFilesMeta(%Param) };
    my $ID    = $Param{FileID} - 1;
    my %File  = %{ $Index[$ID] };

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    $MainObject->FileDelete(
        Directory => $Self->{TempDir},
        Filename  => "$Param{FormID}.$File{Filename}",
    );
    $MainObject->FileDelete(
        Directory => $Self->{TempDir},
        Filename  => "$Param{FormID}.$File{Filename}.ContentType",
    );
    $MainObject->FileDelete(
        Directory => $Self->{TempDir},
        Filename  => "$Param{FormID}.$File{Filename}.ContentID",
    );
    $MainObject->FileDelete(
        Directory => $Self->{TempDir},
        Filename  => "$Param{FormID}.$File{Filename}.Disposition",
    );

    return 1;
}

sub FormIDGetAllFilesData {
    my ( $Self, %Param ) = @_;

    if ( !$Param{FormID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need FormID!'
        );
        return;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List = $MainObject->DirectoryRead(
        Directory => $Self->{TempDir},
        Filter    => "$Param{FormID}.*",
    );

    my $Counter = 0;
    my @Data;

    FILE:
    for my $File (@List) {

        # ignore meta files
        next FILE if $File =~ /\.ContentType$/;
        next FILE if $File =~ /\.ContentID$/;
        next FILE if $File =~ /\.Disposition$/;

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
        my $Content = $MainObject->FileRead(
            Location => $File,
            Mode     => 'binmode',                                             # optional - binmode|utf8
        );
        next FILE if !$Content;

        my $ContentType = $MainObject->FileRead(
            Location => "$File.ContentType",
            Mode     => 'binmode',                                             # optional - binmode|utf8
        );
        next FILE if !$ContentType;

        my $ContentID = $MainObject->FileRead(
            Location => "$File.ContentID",
            Mode     => 'binmode',                                             # optional - binmode|utf8
        );
        next FILE if !$ContentID;

        # verify if content id is empty, set to undef
        if ( !${$ContentID} ) {
            ${$ContentID} = undef;
        }

        my $Disposition = $MainObject->FileRead(
            Location => "$File.Disposition",
            Mode     => 'binmode',                                             # optional - binmode|utf8
        );

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
                Disposition => ${$Disposition},
            },
        );
    }
    return \@Data;

}

sub FormIDGetAllFilesMeta {
    my ( $Self, %Param ) = @_;

    if ( !$Param{FormID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need FormID!'
        );
        return;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List = $MainObject->DirectoryRead(
        Directory => $Self->{TempDir},
        Filter    => "$Param{FormID}.*",
    );

    my $Counter = 0;
    my @Data;

    FILE:
    for my $File (@List) {

        # ignore meta files
        next FILE if $File =~ /\.ContentType$/;
        next FILE if $File =~ /\.ContentID$/;
        next FILE if $File =~ /\.Disposition$/;

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

        my $ContentType = $MainObject->FileRead(
            Location => "$File.ContentType",
            Mode     => 'binmode',                                             # optional - binmode|utf8
        );
        next FILE if !$ContentType;

        my $ContentID = $MainObject->FileRead(
            Location => "$File.ContentID",
            Mode     => 'binmode',                                             # optional - binmode|utf8
        );
        next FILE if !$ContentID;

        # verify if content id is empty, set to undef
        if ( !${$ContentID} ) {
            ${$ContentID} = undef;
        }

        my $Disposition = $MainObject->FileRead(
            Location => "$File.Disposition",
            Mode     => 'binmode',                                             # optional - binmode|utf8
        );

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
                Disposition => ${$Disposition},
            },
        );
    }
    return \@Data;
}

sub FormIDCleanUp {
    my ( $Self, %Param ) = @_;

    my $CurrentTile = time() - 86400;                                            # 60 * 60 * 24 * 1
    my @List        = $Kernel::OM->Get('Kernel::System::Main')->DirectoryRead(
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
