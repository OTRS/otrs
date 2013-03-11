# --
# Kernel/System/Cache/FileStorable.pm - all cache functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Cache::FileStorable;

use strict;
use warnings;
umask 002;

use Storable qw();
use Digest::MD5 qw();
use File::Path qw();
use File::Find qw();

use vars qw(@ISA $VERSION);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Needed (qw(ConfigObject LogObject MainObject EncodeObject)) {
        $Self->{$Needed} = $Param{$Needed} || die "Got no $Needed!";
    }

    my $TempDir = $Self->{ConfigObject}->Get('TempDir');
    $Self->{CacheDirectory} = $TempDir . '/CacheFileStorable';

    # check if cache directory exists and in case create one
    for my $Directory ( $TempDir, $Self->{CacheDirectory} ) {
        if ( !-e $Directory ) {
            ## no critic
            if ( !mkdir( $Directory, 0775 ) ) {
                ## use critic
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Can't create directory '$Directory': $!",
                );
            }
        }
    }

    # Specify how many levels of subdirectories to use, can be 0, 1 or more.
    $Self->{'Cache::SubdirLevels'} = $Self->{ConfigObject}->Get('Cache::SubdirLevels');
    $Self->{'Cache::SubdirLevels'} = 2 if !defined $Self->{'Cache::SubdirLevels'};

    return $Self;
}

sub Set {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type Key Value TTL)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    my $Dump = Storable::nfreeze(
        {
            TTL   => time() + $Param{TTL},
            Value => $Param{Value},
        }
    );

    my ( $Filename, $CacheDirectory ) = $Self->_GetFilenameAndCacheDirectory(%Param);

    if ( !-e $CacheDirectory ) {
        ## no critic
        if ( !File::Path::mkpath( $CacheDirectory, 0, 0775 ) ) {
            ## use critic
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't create directory '$CacheDirectory': $!",
            );
            return;
        }
    }
    my $FileLocation = $Self->{MainObject}->FileWrite(
        Directory  => $CacheDirectory,
        Filename   => $Filename,
        Content    => \$Dump,
        Type       => 'Local',
        Mode       => 'binmode',
        Permission => '664',
    );

    return if !$FileLocation;

    return 1;
}

sub Get {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type Key)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    my ( $Filename, $CacheDirectory ) = $Self->_GetFilenameAndCacheDirectory(%Param);

    my $Content = $Self->{MainObject}->FileRead(
        Directory       => $CacheDirectory,
        Filename        => $Filename,
        Type            => 'Local',
        Mode            => 'binmode',
        DisableWarnings => 1,
    );

    # check if cache exists
    return if !$Content;

    # read data structure back from file dump, use block eval for safety reasons
    my $Storage = eval { Storable::thaw( ${$Content} ) };
    if ( ref $Storage ne 'HASH' || $Storage->{TTL} < time() ) {
        $Self->Delete(%Param);
        return;
    }
    return $Storage->{Value};
}

sub Delete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Type Key)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    my ( $Filename, $CacheDirectory ) = $Self->_GetFilenameAndCacheDirectory(%Param);

    return $Self->{MainObject}->FileDelete(
        Directory       => $CacheDirectory,
        Filename        => $Filename,
        Type            => 'Local',
        DisableWarnings => 1,
    );
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    my @TypeList = $Self->{MainObject}->DirectoryRead(
        Directory => $Self->{CacheDirectory},
        Filter => $Param{Type} || '*',
    );

    return if !@TypeList;

    my $FileCallback = sub {

        my $CacheFile = $File::Find::name;

        # Remove directory if it is empty
        if ( -d $CacheFile ) {
            rmdir $CacheFile;
            return;
        }

        # For expired filed, check the content and TTL
        if ( $Param{Expired} ) {
            my $Content = $Self->{MainObject}->FileRead(
                Location        => $CacheFile,
                Mode            => 'binmode',
                DisableWarnings => 1,
            );

            if ( ref $Content eq 'SCALAR' ) {
                my $Storage = eval { Storable::thaw( ${$Content} ); };
                return if ( ref $Storage eq 'HASH' && $Storage->{TTL} > time() );
            }
        }

        # delete all cache files
        if ( !unlink $CacheFile ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't remove file $CacheFile: $!",
            );
        }
    };

    # We use finddepth so that the most deeply nested files will be deleted first,
    #   and then the directories above are already empty and can just be removed.
    File::Find::finddepth( $FileCallback, @TypeList );

    return 1;
}

sub _GetFilenameAndCacheDirectory {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type Key)) {
        if ( !defined $Param{$Needed} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $Needed!" );
            return;
        }
    }

    my $Filename = $Param{Key};
    $Self->{EncodeObject}->EncodeOutput( \$Filename );
    $Filename = Digest::MD5::md5_hex($Filename);

    my $CacheDirectory = $Self->{CacheDirectory} . '/' . $Param{Type};

    for my $Level ( 1 .. $Self->{'Cache::SubdirLevels'} ) {
        $CacheDirectory .= '/' . substr( $Filename, $Level - 1, 1 )
    }

    return $Filename, $CacheDirectory;
}

1;
