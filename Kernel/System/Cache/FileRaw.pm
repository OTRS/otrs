# --
# Kernel/System/Cache/FileRaw.pm - all cache functions
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: FileRaw.pm,v 1.6 2011-12-20 10:20:09 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Cache::FileRaw;

use strict;
use warnings;
umask 002;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.6 $) [1];

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
    $Self->{CacheDirectory} = $TempDir . '/CacheFileRaw';

    # set mode
    $Self->{Mode} = 'utf8';

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

    my $Now  = time();
    my $TTL  = $Now + $Param{TTL};
    my $Dump = "\$TTL=$TTL; #$Now:$Param{TTL}\n";

    # clean up key
    $Param{KeyNice} = $Param{Key};
    $Param{KeyNice} =~ s/(\n\r)/_/g;
    $Dump .= "#$Param{KeyNice}\n";
    $Dump .= $Self->{MainObject}->Dump( $Param{Value} ) . "\n1;";

    # check for 7 bit chars in type
    if ( grep { $_ < 32 or $_ > 126 } unpack( "C*", $Param{Type} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can use only 7 bit chars as cache type ($Param{Type})!",
        );
        return;
    }
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
        Mode       => $Self->{Mode},
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
        Mode            => $Self->{Mode},
        DisableWarnings => 1,
    );

    # check if cache exists
    return if !$Content;

    my $TTL;
    my $VAR1;
    eval ${$Content};

    # check ttl
    my $Now = time();
    if ( $TTL < $Now ) {
        $Self->Delete(%Param);
        return;
    }
    return $VAR1;
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
            Directory => "$Self->{CacheDirectory}",
            Filter    => "$Param{Type}",
        );
    }

    # get all cache types
    else {
        @TypeList = $Self->{MainObject}->DirectoryRead(
            Directory => "$Self->{CacheDirectory}",
            Filter    => '*',
        );
    }
    for my $Type (@TypeList) {

        # get all .cache files
        my @CacheList = $Self->{MainObject}->DirectoryRead(
            Directory => $Type,
            Filter    => '*',
        );
        CacheFile:
        for my $CacheFile (@CacheList) {

            # only remove files
            next CacheFile if ( !-f $CacheFile );

            # only expired
            if ( $Param{Expired} ) {
                my $Content = $Self->{MainObject}->FileRead(
                    Location        => $CacheFile,
                    Mode            => $Self->{Mode},
                    DisableWarnings => 1,
                );

                # check if cache exists
                if ($Content) {
                    my $TTL;
                    my $VAR1;
                    eval ${$Content};

                    # check ttl
                    my $Now = time();
                    if ( $TTL > $Now ) {
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

        # delete cache directory (if whole cache got deleted)
        if ( !$Param{Expired} ) {
            rmdir $Type;
        }
    }

    return 1;
}

1;
