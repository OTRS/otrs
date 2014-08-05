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
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::Cache - Key/value based data cache for OTRS

=head1 SYNOPSIS

This is a simple data cache. It can store key/value data both
in memory and in a configured cache backend for persistent caching.

This can be controlled via the config settings C<Cache::InMemory> and
C<Cache::InBackend>. The backend can also be selected with the config setting
C<Cache::Module> and defaults to file system based storage for permanent caching.

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

    # Store backend in $Self for fastest access.
    $Self->{CacheObject}    = $Kernel::OM->Get($CacheModule);
    $Self->{CacheInMemory}  = $Kernel::OM->Get('Kernel::Config')->Get('Cache::InMemory') // 1;
    $Self->{CacheInBackend} = $Kernel::OM->Get('Kernel::Config')->Get('Cache::InBackend') // 1;

    return $Self;
}

=item Configure()

change cache configuration settings at runtime. You can use this to disable the cache in
environments where it is not desired, such as in long running scripts.

    $CacheObject->Configure(
        CacheInMemory  => 1,    # optional
        CacheInBackend => 1,    # optional
    );

=cut

sub Configure {
    my ( $Self, %Param ) = @_;

    SETTING:
    for my $Setting (qw(CacheInMemory CacheInBackend)) {
        next SETTING if !exists $Param{$Setting};
        $Self->{$Setting} = $Param{$Setting} ? 1 : 0;
    }

    return;
}

=item Set()

store a value in the cache.

    $CacheObject->Set(
        Type  => 'ObjectName',      # only [a-zA-Z0-9_] chars usable
        Key   => 'SomeKey',
        Value => 'Some Value',
        TTL   => 60 * 60 * 24 * 20, # seconds, this means 20 days
    );

The Type here refers to the group of entries that should be cached and cleaned up together,
usually this will represent the OTRS object that is supposed to be cached, like 'Ticket'.

The Key identifies the entry (together with the type) for retrieval and deletion of this value.

The TTL controls when the cache will expire. Please note that the in-memory cache is not persistent
and thus has no TTL/expiry mechanism.

Please note that if you store complex data, you have to make sure that the data is not modified
in other parts of the code as the in-memory cache only refers to it. Otherwise also the cache would
contain the modifications. If you cannot avoid this, you can disable the in-memory cache for this
value:

    $CacheObject->Set(
        Type  => 'ObjectName',
        Key   => 'SomeKey',
        Value => { ... complex data ... },
        TTL   => 60 * 60 * 24 * 20,

        CacheInMemory => 0,     # optional, defaults to 1
        CacheInBackend => 1,    # optional, defaults to 1
    );

=cut

sub Set {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type Key Value TTL)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
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

    # set in-memory cache
    if ( $Self->{CacheInMemory} && ($Param{CacheInMemory} // 1) ) {
        $Self->{Cache}->{ $Param{Type} }->{ $Param{Key} } = $Param{Value};
    }

    # set persistent cache
    if ( $Self->{CacheInBackend} && ($Param{CacheInBackend} // 1) ) {
        return $Self->{CacheObject}->Set(%Param);
    }

    return 1;
}

=item Get()

fetch a value from the cache.

    my $Value = $CacheObject->Get(
        Type => 'ObjectName',       # only [a-zA-Z0-9_] chars usable
        Key  => 'SomeKey',
    );

Please note that if you store complex data, you have to make sure that the data is not modified
in other parts of the code as the in-memory cache only refers to it. Otherwise also the cache would
contain the modifications. If you cannot avoid this, you can disable the in-memory cache for this
value:

    my $Value = $CacheObject->Get(
        Type => 'ObjectName',
        Key  => 'SomeKey',

        CacheInMemory => 0,     # optional, defaults to 1
        CacheInBackend => 1,    # optional, defaults to 1
    );


=cut

sub Get {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type Key)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check in-memory cache
    if ( $Self->{CacheInMemory} && exists $Self->{Cache}->{ $Param{Type} }->{ $Param{Key} } ) {
        return $Self->{Cache}->{ $Param{Type} }->{ $Param{Key} };
    }

    return if ( !$Self->{CacheInBackend} || !($Param{CacheInBackend} // 1) );

    # check persistent cache
    my $Value = $Self->{CacheObject}->Get(%Param);

    # set in-memory cache
    if ( defined $Value ) {
        if ( $Self->{CacheInMemory} && ($Param{CacheInMemory} // 1) ) {
            $Self->{Cache}->{ $Param{Type} }->{ $Param{Key} } = $Value;
        }
    }

    return $Value;
}

=item Delete()

deletes a single value from the cache.

    $CacheObject->Delete(
        Type => 'ObjectName',       # only [a-zA-Z0-9_] chars usable
        Key  => 'SomeKey',
    );

Please note that despite the cache configuration, Delete and CleanUp will always
be executed both in memory and in the backend to avoid inconsistent cache states.

=cut

sub Delete {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type Key)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Delete and cleanup operations should also be done if the cache is disabled
    #   to avoid inconsistent states.

    # delete from in-memory cache
    delete $Self->{Cache}->{ $Param{Type} }->{ $Param{Key} };

    # delete from persistent cache
    return $Self->{CacheObject}->Delete(%Param);
}

=item CleanUp()

delete parts of the cache or the full cache data.

To delete the whole cache:

    $CacheObject->CleanUp();

To delete the data of only one cache type:

    $CacheObject->CleanUp(
        Type => 'ObjectName',   # only [a-zA-Z0-9_] chars usable
    );

To delete all data except of some types:

    $CacheObject->CleanUp(
        KeepTypes => ['Object1', 'Object2'],
    );

To delete only expired cache data:

    $CacheObject->CleanUp(
        Expired => 1,   # optional, defaults to 0
    );

Type/KeepTypes and Expired can be combined to only delete expired data of a single type
or of all types except the types to keep.

Please note that despite the cache configuration, Delete and CleanUp will always
be executed both in memory and in the backend to avoid inconsistent cache states.

=cut

sub CleanUp {
    my ( $Self, %Param ) = @_;

    # cleanup in-memory cache
    # We don't have TTL/expiry information here, so just always delete to be sure.
    if ( $Param{Type} ) {
        delete $Self->{Cache}->{ $Param{Type} };
    }
    elsif ( $Param{KeepTypes} ) {
        my %KeepTypeLookup;
        @KeepTypeLookup{ @{ $Param{KeepTypes} } } = undef;
        TYPE:
        for my $Type (sort keys %{$Self->{Cache} || {}}) {
            next TYPE if exists $KeepTypeLookup{$Type};
            delete $Self->{Cache}->{ $Type };
        }
    }
    else {
        delete $Self->{Cache};
    }

    # cleanup persistent cache
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
