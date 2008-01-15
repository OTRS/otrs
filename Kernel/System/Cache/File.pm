# --
# Kernel/System/Cache/File.pm - all cache functions
# Copyright (C) 2001-2008 OTRS GmbH, http://otrs.org/
# --
# $Id: File.pm,v 1.3.2.3 2008-01-15 16:06:16 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Cache::File;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.3.2.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # check needed objects
    foreach (qw(ConfigObject LogObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{CacheDirectory} = $Self->{ConfigObject}->Get('TempDir');

    return $Self;
}

sub Set {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(Key Value TTL)) {
        if (!defined($Param{$_})) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    my $Now = time();
    my $TTL = $Now + $Param{TTL};
    my $Dump = "\$TTL=$TTL; #$Now:$Param{TTL}\n";
    # clean up key
    $Param{KeyNice} = $Param{Key};
    $Param{KeyNice} =~ s/(\n\r)/_/g;
    $Dump .= "#$Param{KeyNice}\n";
    $Dump .= $Self->{MainObject}->Dump($Param{Value})."\n1;";

    my %FileData = (
        Directory  => $Self->{CacheDirectory},
        Filename   => $Param{Key},
        Content    => \$Dump,
        Type       => 'MD5',
        Permission => '664',
    );

    if ($Self->{ConfigObject}->Get('DefaultCharset') eq 'utf-8') {
        $FileData{Mode} = 'utf8';
    }

    my $FileLocation = $Self->{MainObject}->FileWrite(%FileData);

    return 1;
}

sub Get {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Key)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }

    my %FileData = (
        Directory       => $Self->{CacheDirectory},
        Filename        => $Param{Key},
        Type            => 'MD5',
        DisableWarnings => 1,
    );

    if ($Self->{ConfigObject}->Get('DefaultCharset') eq 'utf-8') {
        $FileData{Mode} = 'utf8';
    }

    my $Content = $Self->{MainObject}->FileRead(%FileData);

    # check if cache exists
    return if !$Content;

    my $TTL;
    my $VAR1;
    eval ${$Content};
    # check ttl
    my $Now = time();
    if ($TTL < $Now) {
        $Self->Delete(%Param);
        return;
    }
    return $VAR1;
}

sub Delete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(Key)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    return $Self->{MainObject}->FileDelete(
        Directory => $Self->{CacheDirectory},
        Filename => $Param{Key},
        Type => 'MD5',
        DisableWarnings => 1,
    );
}

1;
