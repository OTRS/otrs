# --
# Kernel/System/Cache/File.pm - all cache functions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: File.pm,v 1.4 2007-09-29 10:58:50 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Cache::File;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ConfigObject LogObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{CacheDirectory} = $Self->{ConfigObject}->Get('TempDir');

    return $Self;
}

sub Set {
    my $Self  = shift;
    my %Param = @_;
    for (qw(Key Value TTL)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
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
    my $FileLocation = $Self->{MainObject}->FileWrite(
        Directory => $Self->{CacheDirectory},
        Filename  => $Param{Key},
        Content   => \$Dump,
        Mode      => 'utf8',
        Type      => 'MD5',
    );

    return 1;
}

sub Get {
    my $Self  = shift;
    my %Param = @_;

    # check needed stuff
    for (qw(Key)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my $Content = $Self->{MainObject}->FileRead(
        Directory       => $Self->{CacheDirectory},
        Filename        => $Param{Key},
        Type            => 'MD5',
        Mode            => 'utf8',
        DisableWarnings => 1,
    );

    # check if cache exists
    if ( !$Content ) {
        return;
    }
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
    my $Self  = shift;
    my %Param = @_;

    # check needed stuff
    for (qw(Key)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    return $Self->{MainObject}->FileDelete(
        Directory       => $Self->{CacheDirectory},
        Filename        => $Param{Key},
        Type            => 'MD5',
        DisableWarnings => 1,
    );
}

1;
