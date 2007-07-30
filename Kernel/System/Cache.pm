# --
# Kernel/System/Cache.pm - all cache functions
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: Cache.pm,v 1.2 2007-07-30 09:55:17 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Cache;

use strict;
use warnings;

use vars qw(@ISA $VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

=head1 NAME

Kernel::System::Cache - valid lib

=head1 SYNOPSIS

All cache functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a object

    use Kernel::Config;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::Cache;

    my $ConfigObject = Kernel::Config->new();
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
    );
    my $CacheObject = Kernel::System::Cache->new(
        ConfigObject => $ConfigObject,
        LogObject => $LogObject,
        MainObject => $MainObject,
    );

=cut

sub new {
    my $Type = shift;
    my %Param = @_;
    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);
    # 0=off; 1=set; 2=+get+delete;
    $Self->{Debug} = $Param{Debug} || 0;
    # check needed objects
    foreach (qw(MainObject ConfigObject LogObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # cache backend
    my $CacheModule = $Self->{ConfigObject}->Get('Cache::Module')
        || 'Kernel::System::Cache::File';
    if (!$Self->{MainObject}->Require($CacheModule)) {
        die "Can't load cache backend module $CacheModule! $@";
    }

    $Self->{CacheObject} = $CacheModule->new(%Param);

    return $Self;
}

=item Set()

set a new cache

    $CacheObject->Set(
        Key => 'SomeKey',
        Value => 'Some Value',
        TTL => 24*60*60, # in sec. in this case 24h
    );

=cut

sub Set {
    my $Self = shift;
    my %Param = @_;
    foreach (qw(Key Value)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    # debug
    if ($Self->{Debug} > 0) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Set Key:$Param{Key} TTL:$Param{TTL}!",
        );
    }
    return $Self->{CacheObject}->Set(%Param);
}

=item Get()

return a cache

    my $Value = $CacheObject->Get(
        Key => 'SomeKey',
    );

=cut

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
    # debug
    if ($Self->{Debug} > 1) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Get Key:$Param{Key}!",
        );
    }
    return $Self->{CacheObject}->Get(%Param);
}

=item Delete()

delete a cache

    $CacheObject->Delete(
        Key => 'SomeKey',
    );

=cut

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
    # debug
    if ($Self->{Debug} > 1) {
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Delete Key:$Param{Key}!",
        );
    }
    return $Self->{CacheObject}->Delete(%Param);
}

1;

=back

=head1 TERMS AND CONDITIONS

This Software is part of the OTRS project (http://otrs.org/).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see http://www.gnu.org/licenses/gpl.txt.

=cut

=head1 VERSION

$Revision: 1.2 $ $Date: 2007-07-30 09:55:17 $

=cut
