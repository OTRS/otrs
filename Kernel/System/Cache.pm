# --
# Kernel/System/Cache.pm - all cache functions
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Cache;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Main',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::Cache - cache lib

=head1 SYNOPSIS

All cache functions.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=set+get_cache; 2=+delete+get_request;
    $Self->{Debug} = $Param{Debug} || 0;

    # cache backend
    my $CacheModule = $Kernel::OM->Get('Kernel::Config')->Get('Cache::Module')
        || 'Kernel::System::Cache::FileStorable';

    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($CacheModule) ) {
        die "Can't load backend module $CacheModule! $@";
    }

    $Self->{CacheObject} = $CacheModule->new();

    return $Self;
}

=item Set()

set a new cache

    $CacheObject->Set(
        Type  => 'ObjectName', # only [a-zA-Z0-9_] chars usable
        Key   => 'SomeKey',
        Value => 'Some Value',
        TTL   => 24*60*60,     # in sec. in this case 24h
    );

=cut

sub Set {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Key Value TTL)) {
        if ( !defined $Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # Enforce cache type restriction to make sure it works properly on all file systems.
    if ( $Param{Type} !~ m{ \A [a-zA-Z0-9_]+ \z}smx ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "Cache Type '$Param{Type}' contains invalid characters, use [a-zA-Z0-9_] only!",
        );
        return;
    }

    # debug
    if ( $Self->{Debug} > 0 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Set Key:$Param{Key} TTL:$Param{TTL}!",
        );
    }
    return $Self->{CacheObject}->Set(%Param);
}

=item Get()

return a cache

    my $Value = $CacheObject->Get(
        Type => 'ObjectName', # only A-z chars usable
        Key  => 'SomeKey',
    );

=cut

sub Get {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Key)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # debug
    if ( $Self->{Debug} > 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Get Key:$Param{Key}!",
        );
    }
    my $Value = $Self->{CacheObject}->Get(%Param);
    if ( defined $Value ) {
        if ( $Self->{Debug} > 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'notice',
                Message  => "Get cached Key:$Param{Key}!",
            );
        }
    }
    return $Value;
}

=item Delete()

delete a cache

    $CacheObject->Delete(
        Type => 'ObjectName', # only A-z chars usable
        Key  => 'SomeKey',
    );

=cut

sub Delete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Type Key)) {
        if ( !$Param{$_} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $_!",
            );
            return;
        }
    }

    # debug
    if ( $Self->{Debug} > 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => "Delete Key:$Param{Key}!",
        );
    }
    return $Self->{CacheObject}->Delete(%Param);
}

=item CleanUp()

delete chache or parts of the cache

    To delete the whole cache

    $CacheObject->CleanUp();

    of if you want to cleanup only one object cache

    $CacheObject->CleanUp(
        Type => 'ObjectName', # only A-z chars are usable
    );

    of if you want to cleanup only one object cache with expired caches

    $CacheObject->CleanUp(
        Type    => 'ObjectName', # only A-z chars are usable
        Expired => 1, # 1|0, default 0
    );

=cut

sub CleanUp {
    my ( $Self, %Param ) = @_;

    # debug
    if ( $Self->{Debug} > 1 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'notice',
            Message  => 'CleanUp cache!',
        );
    }
    return $Self->{CacheObject}->CleanUp(%Param);
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
