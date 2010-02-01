# --
# Kernel/System/Cache/FileStorable.pm - all cache functions
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: FileStorable.pm,v 1.1 2010-02-01 01:27:31 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Cache::FileStorable;

use strict;
use warnings;
umask 002;

use Storable qw(freeze thaw);

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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
    $Self->{CacheDirectory} = $TempDir . '/Cache/';

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check for 7 bit chars in type
    if ( grep { $_ < 32 or $_ > 126 } unpack( "C*", $Param{Type} ) ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can only 7 bit chars use as cache type ($Param{Type})!",
        );
        return;
    }

    my $Now = time();
    my $TTL = $Now + $Param{TTL};

    my $Data = {
        TTL   => $TTL,
        Value => $Param{Value},
    };
    my $Dump = freeze($Data);

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
        Filename   => $Param{Key} . '.storable',
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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $CacheDirectory = $Self->{CacheDirectory} . '/' . $Param{Type};
    my $Content        = $Self->{MainObject}->FileRead(
        Directory       => $CacheDirectory,
        Filename        => $Param{Key} . '.storable',
        Type            => 'MD5',
        Mode            => 'binary',
        DisableWarnings => 1,
    );

    # check if cache exists
    return if !$Content;

    my $Storage = thaw( ${$Content} );

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
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $CacheDirectory = $Self->{CacheDirectory} . '/' . $Param{Type};
    return $Self->{MainObject}->FileDelete(
        Directory       => $CacheDirectory,
        Filename        => $Param{Key} . '.storable',
        Type            => 'MD5',
        DisableWarnings => 1,
    );
}

sub CleanUp {
    my ( $Self, %Param ) = @_;

    my @TypeList;

    # get all only one type cache
    if ( $Param{Type} ) {
        @TypeList = glob( $Self->{CacheDirectory} . '/' . $Param{Type} );
    }

    # get all cache types
    else {
        @TypeList = glob( $Self->{CacheDirectory} . '/*' );
    }
    for my $Type (@TypeList) {

        # get all .cache files
        my @CacheList = glob( $Type . '/*' );
        for my $CacheFile (@CacheList) {

            # only remove files
            next if ( !-f $CacheFile );

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
