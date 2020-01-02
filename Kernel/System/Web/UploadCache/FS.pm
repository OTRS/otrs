# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
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

    $Self->{TempDir} = $Kernel::OM->Get('Kernel::Config')->Get('TempDir') . '/upload_cache';

    if ( !-d $Self->{TempDir} ) {
        mkdir $Self->{TempDir};
    }

    return $Self;
}

sub FormIDCreate {
    my ( $Self, %Param ) = @_;

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

    return if !$Self->_FormIDValidate( $Param{FormID} );

    my $Directory = $Self->{TempDir} . '/' . $Param{FormID};

    if ( !-d $Directory ) {
        return 1;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => "*",
    );

    my @Data;
    for my $File (@List) {
        $MainObject->FileDelete(
            Location => $File,
        );
    }

    if ( !rmdir($Directory) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't remove: $Directory: $!!",
        );
    }

    return 1;
}

sub FormIDAddFile {
    my ( $Self, %Param ) = @_;

    for (qw(FormID Filename ContentType)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    return if !$Self->_FormIDValidate( $Param{FormID} );

    $Param{Content} = '' if !defined( $Param{Content} );

    # create content id
    my $ContentID   = $Param{ContentID};
    my $Disposition = $Param{Disposition} || '';
    if ( !$ContentID && lc $Disposition eq 'inline' ) {

        my $Random = rand 999999;
        my $FQDN   = $Kernel::OM->Get('Kernel::Config')->Get('FQDN');

        $ContentID = "$Disposition$Random.$Param{FormID}\@$FQDN";
    }

    # create cache subdirectory if not exist
    my $Directory = $Self->{TempDir} . '/' . $Param{FormID};
    if ( !-d $Directory ) {

        # Create directory. This could fail if another process creates the
        #   same directory, so don't use the return value.
        File::Path::mkpath( $Directory, 0, 0770 );    ## no critic

        if ( !-d $Directory ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't create directory '$Directory': $!",
            );
            return;
        }
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    # files must readable for creator
    return if !$MainObject->FileWrite(
        Directory  => $Directory,
        Filename   => "$Param{Filename}",
        Content    => \$Param{Content},
        Mode       => 'binmode',
        Permission => '640',
        NoReplace  => 1,
    );
    return if !$MainObject->FileWrite(
        Directory  => $Directory,
        Filename   => "$Param{Filename}.ContentType",
        Content    => \$Param{ContentType},
        Mode       => 'binmode',
        Permission => '640',
        NoReplace  => 1,
    );
    return if !$MainObject->FileWrite(
        Directory  => $Directory,
        Filename   => "$Param{Filename}.ContentID",
        Content    => \$ContentID,
        Mode       => 'binmode',
        Permission => '640',
        NoReplace  => 1,
    );
    return if !$MainObject->FileWrite(
        Directory  => $Directory,
        Filename   => "$Param{Filename}.Disposition",
        Content    => \$Disposition,
        Mode       => 'binmode',
        Permission => '644',
        NoReplace  => 1,
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

    return if !$Self->_FormIDValidate( $Param{FormID} );

    my @Index = @{ $Self->FormIDGetAllFilesMeta(%Param) };

    # finish if files have been already removed by other process
    return if !@Index;

    my $ID   = $Param{FileID} - 1;
    my %File = %{ $Index[$ID] };

    my $Directory = $Self->{TempDir} . '/' . $Param{FormID};

    if ( !-d $Directory ) {
        return 1;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    $MainObject->FileDelete(
        Directory => $Directory,
        Filename  => "$File{Filename}",
        NoReplace => 1,
    );
    $MainObject->FileDelete(
        Directory => $Directory,
        Filename  => "$File{Filename}.ContentType",
        NoReplace => 1,
    );
    $MainObject->FileDelete(
        Directory => $Directory,
        Filename  => "$File{Filename}.ContentID",
        NoReplace => 1,
    );
    $MainObject->FileDelete(
        Directory => $Directory,
        Filename  => "$File{Filename}.Disposition",
        NoReplace => 1,
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

    my @Data;

    return \@Data if !$Self->_FormIDValidate( $Param{FormID} );

    my $Directory = $Self->{TempDir} . '/' . $Param{FormID};

    if ( !-d $Directory ) {
        return \@Data;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => "*",
    );

    my $Counter = 0;

    FILE:
    for my $File (@List) {

        # ignore meta files
        next FILE if $File =~ /\.ContentType$/;
        next FILE if $File =~ /\.ContentID$/;
        next FILE if $File =~ /\.Disposition$/;

        $Counter++;
        my $FileSize = -s $File;

        # human readable file size
        if ( defined $FileSize ) {

            # remove meta data in files
            if ( $FileSize > 30 ) {
                $FileSize = $FileSize - 30;
            }
        }
        my $Content = $MainObject->FileRead(
            Location => $File,
            Mode     => 'binmode',    # optional - binmode|utf8
        );
        next FILE if !$Content;

        my $ContentType = $MainObject->FileRead(
            Location => "$File.ContentType",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$ContentType;

        my $ContentID = $MainObject->FileRead(
            Location => "$File.ContentID",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$ContentID;

        # verify if content id is empty, set to undef
        if ( !${$ContentID} ) {
            ${$ContentID} = undef;
        }

        my $Disposition = $MainObject->FileRead(
            Location => "$File.Disposition",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$Disposition;

        # strip filename
        $File =~ s/^.*\/(.+?)$/$1/;
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

    my @Data;

    return \@Data if !$Self->_FormIDValidate( $Param{FormID} );

    my $Directory = $Self->{TempDir} . '/' . $Param{FormID};

    if ( !-d $Directory ) {
        return \@Data;
    }

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my @List = $MainObject->DirectoryRead(
        Directory => $Directory,
        Filter    => "*",
    );

    my $Counter = 0;

    FILE:
    for my $File (@List) {

        # ignore meta files
        next FILE if $File =~ /\.ContentType$/;
        next FILE if $File =~ /\.ContentID$/;
        next FILE if $File =~ /\.Disposition$/;

        $Counter++;
        my $FileSize = -s $File;

        # human readable file size
        if ( defined $FileSize ) {

            # remove meta data in files
            if ( $FileSize > 30 ) {
                $FileSize = $FileSize - 30;
            }
        }

        my $ContentType = $MainObject->FileRead(
            Location => "$File.ContentType",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$ContentType;

        my $ContentID = $MainObject->FileRead(
            Location => "$File.ContentID",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$ContentID;

        # verify if content id is empty, set to undef
        if ( !${$ContentID} ) {
            ${$ContentID} = undef;
        }

        my $Disposition = $MainObject->FileRead(
            Location => "$File.Disposition",
            Mode     => 'binmode',             # optional - binmode|utf8
        );
        next FILE if !$Disposition;

        # strip filename
        $File =~ s/^.*\/(.+?)$/$1/;
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

    # get main object
    my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

    my $RetentionTime = int( time() - 86400 );        # remove subdirs older than 24h
    my @List          = $MainObject->DirectoryRead(
        Directory => $Self->{TempDir},
        Filter    => '*'
    );

    SUBDIR:
    for my $Subdir (@List) {
        my $SubdirTime = $Subdir;

        if ( $SubdirTime =~ /^.*\/\d+\..+$/ ) {
            $SubdirTime =~ s/^.*\/(\d+?)\..+$/$1/;
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "Won't delete upload cache directory $Subdir: timestamp in directory name not found! Please fix it manually.",
            );
            next SUBDIR;
        }

        if ( $RetentionTime > $SubdirTime ) {
            my @Sublist = $MainObject->DirectoryRead(
                Directory => $Subdir,
                Filter    => "*",
            );

            for my $File (@Sublist) {
                $MainObject->FileDelete(
                    Location => $File,
                );
            }

            if ( !rmdir($Subdir) ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Can't remove: $Subdir: $!!",
                );
                next SUBDIR;
            }
        }
    }

    return 1;
}

sub _FormIDValidate {
    my ( $Self, $FormID ) = @_;

    return if !$FormID;

    if ( $FormID !~ m{^ \d+ \. \d+ \. \d+ $}xms ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Invalid FormID!',
        );
        return;
    }

    return 1;
}

1;
