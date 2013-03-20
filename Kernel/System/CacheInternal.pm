# --
# Kernel/System/CacheInternal.pm - all cache functions
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::CacheInternal;

use strict;
use warnings;
use Kernel::System::Cache;

use vars qw(@ISA);

=head1 NAME

Kernel::System::CacheInternal - cache lib

=head1 SYNOPSIS

All cache functions for internal cache management.

Notice:
This module is storing the cache information in memory and also permanently (e. g. on a file system).
So you need to take care, that there is only one instance of the CacheInternalObject at a
time, because otherwise the in-memory cache will fail.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::CacheInternal;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $CacheInternalObject = Kernel::System::CacheInternal->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
        Type         => 'ObjectName', # only [a-zA-Z0-9_] chars usable
        TTL          => 60 * 60 * 24,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # 0=off; 1=set+get_cache; 2=+delete+get_request;
    $Self->{Debug} = $Param{Debug} || 0;

    # check needed objects
    for (qw(MainObject ConfigObject LogObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    for (qw(Type TTL)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{CacheObject} = Kernel::System::Cache->new(%Param);

    # Enforce cache type restriction to make sure it works properly on all file systems.
    if ( $Param{Type} !~ m{ \A [a-zA-Z0-9_]+ \z}smx ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Cache type '$Param{Type}' contains invalid characters, use [a-zA-Z0-9_] only!",
        );
        die "Cache type '$Param{Type}' contains invalid characters, use [a-zA-Z0-9_] only!";
    }

    $Self->{Type} = 'CacheInternal' . $Self->{Type};

    return $Self;
}

=item Set()

add a new item to cache

    $CacheInternalObject->Set(
        Key   => 'SomeKey',
        Value => 'Some Value',
    );

=cut

sub Set {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key Value)) {
        if ( !defined $Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # set runtime cache
    $Self->{Cache}->{ $Param{Key} } = $Param{Value};

    # set permanent cache
    $Self->{CacheObject}->Set(
        Type  => $Self->{Type},
        Key   => $Param{Key},
        Value => $Param{Value},
        TTL   => $Self->{TTL},
    );

    return 1;
}

=item Get()

return a cached item

    my $Value = $CacheInternalObject->Get(
        Key  => 'SomeKey',
    );

=cut

sub Get {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check runtime cache
    return $Self->{Cache}->{ $Param{Key} } if exists $Self->{Cache}->{ $Param{Key} };

    # check permanent cache
    my $Cache = $Self->{CacheObject}->Get(
        Type => $Self->{Type},
        Key  => $Param{Key},
    );
    return if !defined $Cache;

    # set runtime cache
    $Self->{Cache}->{ $Param{Key} } = $Cache;

    return $Cache;
}

=item Delete()

delete an item from cache

    $CacheInternalObject->Delete(
        Key  => 'SomeKey',
    );

=cut

sub Delete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # delete runtime cache
    delete $Self->{Cache}->{ $Param{Key} };

    # delete permanent cache
    $Self->{CacheObject}->Delete(
        Type => $Self->{Type},
        Key  => $Param{Key},
    );

    return 1;
}

=item CleanUp()

delete all cached items

    $CacheInternalObject->CleanUp();

If another cache type needs to be cleaned up, you can
use the parameter 'OtherType'.

    $CacheInternalObject->CleanUp(OtherType => 'SomeType');

This is useful for cleaning up dependent cache entries after
the modification of objects (for example, cleaning up the group
cache after modifying agents).

NOTE: This 'OtherType'-cleanup only affects permanent caches.
In-memory-caches in other CacheInternal objects cannot be cleaned
up presently, therefore a refactoring of the entire caching architecture
will be neccessary.

=cut

sub CleanUp {
    my ( $Self, %Param ) = @_;

    # delete all runtime cache
    $Self->{Cache} = undef;

    # delete permanent cache
    if ( $Param{OtherType} ) {
        return if !$Self->{CacheObject}->CleanUp(
            Type => 'CacheInternal' . $Param{OtherType}
        );
    }
    else {
        return if !$Self->{CacheObject}->CleanUp(
            Type => $Self->{Type}
        );
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
