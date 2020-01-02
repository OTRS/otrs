# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Cache;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Cache - Key/value based data cache for OTRS

=head1 DESCRIPTION

This is a simple data cache. It can store key/value data both
in memory and in a configured cache backend for persistent caching.

This can be controlled via the config settings C<Cache::InMemory> and
C<Cache::InBackend>. The backend can also be selected with the config setting
C<Cache::Module> and defaults to file system based storage for permanent caching.

=head1 CACHING STRATEGY

Caching works based on C<CacheType>s and C<CacheKey>s.

=head2 CACHE TYPES

For file based caching,
a C<CacheType> groups all contained entries in a top level directory like
C<var/tmp/CacheFileStorable/MyCacheType>. This means also that all entries of a specific
C<CacheType> can be deleted with one function call, L</CleanUp()>.

Typically, every backend module like L<Kernel::System::Valid> has its own CacheType that is stored in C<$Self>
for consistent use. There could be exceptions when modules have much cached data that needs to be cleaned up
together. In this case additional C<CacheType>s could be used, but this should be avoided.

=head2 CACHE KEYS

A C<CacheKey> is used to identify a single cached entry within a C<CacheType>. The specified cache key will be
internally hashed to a file name that is used to fetch/store that particular cache entry,
like C<var/tmp/CacheFileStorable/Valid/2/1/217727036cc9b1804f7c0f4f7777ef86>.

It is important that all variables that lead to the output of different results of a function
must be part of the C<CacheKey> if the entire function result is to be stored in a separate cache entry.
For example, L<Kernel::System::State/StateGet()> allows fetching of C<State>s by C<Name> or by C<ID>.
So there are different cache keys for both cases:

    my $CacheKey;
    if ( $Param{Name} ) {
        $CacheKey = 'StateGet::Name::' . $Param{Name};
    }
    else {
        $CacheKey = 'StateGet::ID::' . $Param{ID};
    }

Please avoid the creation of too many different cache keys, as this can be a burden for storage
and performance of the system. Sometimes it can be helpful to implement a function like the one presented above
in another way: C<StateGet()> could call the cached C<StateList()> internally and fetch the requested entry from
its result. This depends on the amount of data, of course.

=head2 CACHING A BACKEND MODULE

=over 4

=item Define a C<CacheType> and a C<CacheTTL>.

Every module should have its own C<CacheType> which typically resembles the module name.
The C<CacheTTL> defines how long a cache is valid. This depends on the data, but a value of 30 days is
considered a good default choice.

=item Add caching to methods fetching data.

All functions that list and fetch entities can potentially get caches.

=item Implement cache cleanup.

All functions that add, modify or delete entries need to make sure that the cache stays consistent.
All of these operations typically need to cleanup list method caches, while only modify and delete
affect individual cache entries that need to be deleted.

Whenever possible, avoid calling L</CleanUp()> for an entire cache type, but instead delete individual
cache entries with L</Delete()> to keep as much cached data as possible.

It is recommendable to implement a C<_CacheCleanup()> method in the module that centralizes cache cleanup.

=item Extend module tests.

Please also extend the module tests to work on non-cached and cached values
(e. g. calling a method more than one time) to ensure consistency of both cached and non-cached data,
and proper cleanup on deleting entities.

=back

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

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

=head2 Configure()

change cache configuration settings at runtime. You can use this to disable the cache in
environments where it is not desired, such as in long running scripts.

please, to turn CacheInMemory off in persistent environments.

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

=head2 Set()

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

The C<TTL> controls when the cache will expire. Please note that the in-memory cache is not persistent
and thus has no C<TTL>/expiry mechanism.

Please note that if you store complex data, you have to make sure that the data is not modified
in other parts of the code as the in-memory cache only refers to it. Otherwise also the cache would
contain the modifications. If you cannot avoid this, you can disable the in-memory cache for this
value:

    $CacheObject->Set(
        Type  => 'ObjectName',
        Key   => 'SomeKey',
        Value => { ... complex data ... },

        TTL            => 60 * 60 * 24 * 1,  # optional, default 20 days
        CacheInMemory  => 0,                 # optional, defaults to 1
        CacheInBackend => 1,                 # optional, defaults to 1
    );

=cut

sub Set {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(Type Key Value)) {
        if ( !defined $Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # set default TTL to 20 days
    $Param{TTL} //= 60 * 60 * 24 * 20;

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

    # Set in-memory cache.
    if ( $Self->{CacheInMemory} && ( $Param{CacheInMemory} // 1 ) ) {
        $Self->{Cache}->{ $Param{Type} }->{ $Param{Key} } = $Param{Value};
    }

    # If in-memory caching is not active, make sure the in-memory
    #   cache is not in an inconsistent state.
    else {
        delete $Self->{Cache}->{ $Param{Type} }->{ $Param{Key} };
    }

    # Set persistent cache.
    if ( $Self->{CacheInBackend} && ( $Param{CacheInBackend} // 1 ) ) {
        return $Self->{CacheObject}->Set(%Param);
    }

    # If persistent caching is not active, make sure the persistent
    #   cache is not in an inconsistent state.
    else {
        return $Self->{CacheObject}->Delete(%Param);
    }

    return 1;
}

=head2 Get()

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
    if ( $Self->{CacheInMemory} && ( $Param{CacheInMemory} // 1 ) ) {
        if ( exists $Self->{Cache}->{ $Param{Type} }->{ $Param{Key} } ) {
            return $Self->{Cache}->{ $Param{Type} }->{ $Param{Key} };
        }
    }

    return if ( !$Self->{CacheInBackend} || !( $Param{CacheInBackend} // 1 ) );

    # check persistent cache
    my $Value = $Self->{CacheObject}->Get(%Param);

    # set in-memory cache
    if ( defined $Value ) {
        if ( $Self->{CacheInMemory} && ( $Param{CacheInMemory} // 1 ) ) {
            $Self->{Cache}->{ $Param{Type} }->{ $Param{Key} } = $Value;
        }
    }

    return $Value;
}

=head2 Delete()

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

=head2 CleanUp()

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
        for my $Type ( sort keys %{ $Self->{Cache} || {} } ) {
            next TYPE if exists $KeepTypeLookup{$Type};
            delete $Self->{Cache}->{$Type};
        }
    }
    else {
        delete $Self->{Cache};
    }

    # cleanup persistent cache
    return $Self->{CacheObject}->CleanUp(%Param);
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
