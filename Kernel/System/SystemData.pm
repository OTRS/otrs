# --
# Kernel/System/SystemData.pm - Provides simple key/value store for system data
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::SystemData;

use strict;
use warnings;

use Kernel::System::CacheInternal;
use Kernel::System::SysConfig;
use Kernel::System::Valid;

=head1 NAME

Kernel::System::SystemData - key/value store for system data

=head1 SYNOPSIS

Provides key/value store for system data

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::System::SystemData;

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
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $SystemDataObject = Kernel::System::SystemData->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for (qw(DBObject ConfigObject LogObject MainObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # create additional objects
    $Self->{ValidObject}         = Kernel::System::Valid->new( %{$Self} );
    $Self->{CacheInternalObject} = Kernel::System::CacheInternal->new(
        %Param,
        Type => 'SystemData',
        TTL  => 60 * 60 * 24 * 20,
    );

    return $Self;
}

=item SystemDataAdd()

add new systemdata value

Result is true if adding was OK, and false if it failed, for instance because
the key already existed.

If your keys contain '::' this will be used as a separator. This allows you to
later for instance fetch all keys that start with 'SystemRegistration::' in
one go, using SystemDataGetGroup().

    my $Result = $SystemDataObject->SystemDataAdd(
        Key    => 'SomeKey',
        Value  => 'Some Value',
        UserID => 123,
    );

    my $Result = $SystemDataObject->SystemDataAdd(
        Key    => 'SystemRegistration::Version',
        Value  => 'Some Value',
        UserID => 123,
    );

=cut

sub SystemDataAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !defined $Param{Value} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Value!" );
        return;
    }

    # return if key does not already exists - then we can't do an update
    my $Value = $Self->SystemDataGet( Key => $Param{Key} );
    if ( defined $Value ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't add SystemData key '$Param{Key}', it already exists!",
        );
        return;
    }

    # store data
    return if !$Self->{DBObject}->Do(
        SQL => '
            INSERT INTO system_data
                (data_key, data_value, create_time, create_by, change_time, change_by)
            VALUES (?, ?, current_timestamp, ?, current_timestamp, ?)
            ',
        Bind => [ \$Param{Key}, \$Param{Value}, \$Param{UserID}, \$Param{UserID} ],
    );

    # delete cache
    $Self->_SystemDataCacheKeyDelete(
        Key => $Param{Key},
    );

    return 1;
}

=item SystemDataGet()

get system data for key

    my $SystemData = $SystemDataObject->SystemDataGet(
        Key => 'OTRS Version',
    );

returns value as a simple scalar, or undef if the key does not exist.
keys set to NULL return an empty string.

=cut

sub SystemDataGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Key} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Key!" );
        return;
    }

    # check cache
    my $CacheKey = 'SystemDataGet::' . $Param{Key};
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return $Cache if $Cache;

    return if !$Self->{DBObject}->Prepare(
        SQL => '
            SELECT data_value
            FROM system_data
            WHERE data_key = ?
            ',
        Bind  => [ \$Param{Key} ],
        Limit => 1,
    );

    my $Value;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $Value = $Data[0] || '';
    }

    # set cache
    $Self->{CacheInternalObject}->Set(
        Key => $CacheKey,
        Value => $Value || '',
    );

    return $Value;
}

=item SystemDataGroupGet()

returns a hash of all keys starting with the Group.
For instance the code below would return values for
'SystemRegistration::UniqueID', 'SystemRegistration::UpdateID',
and so on.

    my %SystemData = $SystemDataObject->SystemDataGroupGet(
        Group => 'SystemRegistration',
    );

my %SystemData = (
    UniqueID => 'CDC782BE-E483-11E2-83DA-9FFD99890B3C',
    UpdateID => 'D8F55850-E483-11E2-BD60-9FFD99890B3C'
    ...
);

=cut

sub SystemDataGroupGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Group} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Group!" );
        return;
    }

    # check cache
    my $CacheKey = 'SystemDataGetGroup::' . $Param{Group};
    my $Cache = $Self->{CacheInternalObject}->Get( Key => $CacheKey );
    return %{$Cache} if $Cache;

    # get like escape string needed for some databases (e.g. oracle)
    my $LikeEscapeString = $Self->{DBObject}->GetDatabaseFunction('LikeEscapeString');

    # prepare group name search
    my $Group = $Param{Group};
    $Group =~ s/\*/%/g;
    $Group = $Self->{DBObject}->Quote( $Group, 'Like' );

    return if !$Self->{DBObject}->Prepare(
        SQL => "
            SELECT data_key, data_value
            FROM system_data
            WHERE data_key LIKE '${Group}::%' $LikeEscapeString
            ",
    );

    my %Result;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
        $Data[0] =~ s/^${Group}:://;

        $Result{ $Data[0] } = $Data[1];
    }

    # set cache
    $Self->{CacheInternalObject}->Set(
        Key   => $CacheKey,
        Value => \%Result,
    );

    return %Result;
}

=item SystemDataUpdate()

update system data

Returns true if update was succesful or false if otherwise - for instance
if key did not exist.

    my $Result = $SystemDataObject->SystemDataUpdate(
        Key     => 'OTRS Version',
        Value   => 'Some New Value',
        UserID  => 123,
    );

=cut

sub SystemDataUpdate {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    if ( !defined $Param{Value} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => "Need Value!" );
        return;
    }

    # return if key does not already exists - then we can't do an update
    my $Value = $Self->SystemDataGet( Key => $Param{Key} );
    if ( !defined $Value ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't update SystemData key '$Param{Key}', it does not exist!",
        );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            UPDATE system_data
            SET data_value = ?, change_time = current_timestamp, change_by = ?
            WHERE data_key = ?
            ',
        Bind => [
            \$Param{Value}, \$Param{UserID}, \$Param{Key},
        ],
    );

    # delete cache entry
    $Self->_SystemDataCacheKeyDelete(
        Key => $Param{Key},
    );

    return 1;
}

=item SystemDataDelete()

update system data

Returns true if delete was succesful or false if otherwise - for instance
if key did not exist.

    $SystemDataObject->SystemDataDelete(
        Key    => 'OTRS Version',
        UserID => 123,
    );

=cut

sub SystemDataDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(Key UserID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # return if key does not already exists - then we can't do a delete
    my $Value = $Self->SystemDataGet( Key => $Param{Key} );
    if ( !defined $Value ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't delete SystemData key '$Param{Key}', it does not exist!",
        );
        return;
    }

    # sql
    return if !$Self->{DBObject}->Do(
        SQL => '
            DELETE FROM system_data
            WHERE data_key = ?
            ',
        Bind => [ \$Param{Key} ],
    );

    # delete cache entry
    $Self->_SystemDataCacheKeyDelete(
        Key => $Param{Key},
    );

    return 1;
}

=begin Internal:

=cut

=item _SystemDataCacheKeyDelete()

This will delete the cache for the given key and for all groups, if needed.

For a key such as 'Foo::Bar::Baz', it will delete the cache for 'Foo::Bar::Baz'
as well as for the groups 'Foo::Bar' and 'Foo'.

    $Success = $SystemDataObject->_SystemDataCacheKeyDelete(
        Key => 'SystemRegistration::Version::DB'
    );

=cut

sub _SystemDataCacheKeyDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Key} ) {
        $Self->{LogObject}
            ->Log( Priority => 'error', Message => "_SystemDataCacheKeyDelete: need 'Key'!" );
        return;
    }

    # delete cache entry
    $Self->{CacheInternalObject}->Delete(
        Key => 'SystemDataGet::' . $Param{Key},
    );

    # delete cache for groups if needed
    my @Parts = split( '::', $Param{Key} );

    if ( scalar @Parts > 1 ) {

        # remove last value, delete cache
        PART:
        for my $Part (@Parts) {
            pop @Parts;
            my $CacheKey = join( '::', @Parts );
            $Self->{CacheInternalObject}->Delete(
                Key => 'SystemDataGetGroup::' . join( '::', @Parts ),
            );

            # stop if there is just one value left
            last PART if scalar @Parts == 1;
        }
    }

    return 1;
}

=end Internal:

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut

1;
