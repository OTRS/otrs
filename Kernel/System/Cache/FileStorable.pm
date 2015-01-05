# --
# Kernel/System/Cache/FileStorable.pm - all cache functions
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: FileStorable.pm,v 1.9 2011-12-20 10:20:09 mg Exp $
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

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ConfigObject LogObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    my $TempDir = $Self->{ConfigObject}->Get('TempDir');
    $Self->{CacheDirectory} = $TempDir . '/CacheFileStorable';

    # check if cache directory exists and in case create one
    for my $Directory ( $TempDir, $Self->{CacheDirectory} ) {
        if ( !-e $Directory ) {
            if ( !mkdir( $Directory, 0775 ) ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Can't create directory '$Directory': $!",
                );
            }
        }
    }

    return $Self;
}

sub Set {
    my ( $Self, %Param ) = @_;

    for (qw(Type Key Value TTL)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    # check for 7 bit chars in type
    if ( grep { $_ < 32 or $_ > 126 } unpack( "C*", $Param{Type} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can use only 7 bit chars as cache type ($Param{Type})!",
        );
        return;
    }

    my $Now = time();
    my $TTL = $Now + $Param{TTL};

    my $Data = {
        TTL   => $TTL,
        Value => $Param{Value},
    };
    my $Dump = Storable::nfreeze($Data);

    my $CacheDirectory = $Self->{CacheDirectory} . '/' . $Param{Type};
    if ( !-e $CacheDirectory ) {
        if ( !mkdir( $CacheDirectory, 0775 ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't create directory '$CacheDirectory': $!",
            );
            return;
        }
    }
    my $FileLocation = $Self->{MainObject}->FileWrite(
        Directory  => $CacheDirectory,
        Filename   => $Param{Key},
        Content    => \$Dump,
        Type       => 'MD5',
        Mode       => 'binmode',
        Permission => '664',
    );

    return if !$FileLocation;

    return 1;
}

sub Get {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Key)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my $CacheDirectory = $Self->{CacheDirectory} . '/' . $Param{Type};
    my $Content        = $Self->{MainObject}->FileRead(
        Directory       => $CacheDirectory,
        Filename        => $Param{Key},
        Type            => 'MD5',
        Mode            => 'binmode',
        DisableWarnings => 1,
    );

    # check if cache exists
    return if !$Content;

    # read data structure back from file dump, use block eval for safety reasons
    my $Storage = eval { Storable::thaw( ${$Content} ) };
    return if !$Storage;

    # check ttl
    my $Now = time();
    if ( $Storage->{TTL} < $Now ) {
        $Self->Delete(%Param);
        return;
    }
    return $Storage->{Value};
}

sub Delete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Key)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Need $_!"
            );
            return;
        }
    }

    my $CacheDirectory = $Self->{CacheDirectory} . '/' . $Param{Type};
    return $Self->{MainObject}->FileDelete(
        Directory       => $CacheDirectory,
        Filename        => $Param{Key},
        Type            => 'MD5',
        DisableWarnings => 1,
    );
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    my @TypeList;

    # get all only one type cache
    if ( $Param{Type} ) {
        @TypeList = $Self->{MainObject}->DirectoryRead(
            Directory => $Self->{CacheDirectory},
            Filter    => $Param{Type},
        );
    }

    # get all cache types
    else {
        @TypeList = $Self->{MainObject}->DirectoryRead(
            Directory => $Self->{CacheDirectory},
            Filter    => '*',
        );
        @TypeList = $Self->{MainObject}->DirectoryRead(
            Directory => $Self->{CacheDirectory},
            Filter    => '*',
        );
    }
    for my $Type (@TypeList) {

        # get all cache files
        my @CacheList = $Self->{MainObject}->DirectoryRead(
            Directory => $Type,
            Filter    => '*',
        );
        CacheFile:
        for my $CacheFile (@CacheList) {

            # only remove files
            next if !-f $CacheFile;

            # only expired
            if ( $Param{Expired} ) {
                my $Content = $Self->{MainObject}->FileRead(
                    Location        => $CacheFile,
                    Mode            => 'binmode',
                    DisableWarnings => 1,
                );

                # check if cache exists
                if ($Content) {

                    my $Storage = Storable::thaw( ${$Content} );

                    # check ttl
                    my $Now = time();
                    if ( $Storage->{TTL} > $Now ) {
                        next CacheFile;
                    }
                }
            }

            # delete all cache files
            if ( !unlink $CacheFile ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Can't remove file $CacheFile: $!",
                );
            }
        }

        # delete cache directory
        rmdir $Type;
    }

    return 1;
}

1;
