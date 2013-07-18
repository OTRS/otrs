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
use Kernel::System::Time;
use Kernel::System::Valid;

use vars qw(@ISA);

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
    $Self->{ValidObject}         = Kernel::System::Valid->new(%Param);
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

Note that keys can be unicode but are lowercased before they're inserted in
the database. This is because the values are cached and cache is case sensitive; 
databases can be case-insensitive.

    my $Result = $SystemDataObject->SystemDataAdd(
        Key     => 'OTRS Version',
        Value   => 'Some Value',
        UserID  => 123,
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

    # lowercase key
    $Param{Key} = lc $Param{Key};

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
        Bind => [ \$Param{Key}, \$Param{Value}, \$Param{UserID}, \$Param{UserID}, ],
    );

    # delete cache
    $Self->{CacheInternalObject}->CleanUp();

    return 1;
}

=item SystemDataGet()

get system data for key

    my $SystemData = $SystemDataObject->SystemDataGet(
        Key  => 'OTRS Version',
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

    # lowercase key
    $Param{Key} = lc $Param{Key};

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

=item SystemDataUpdate()

update system data

Returns true if update was succesful or false if otherwise - for instance
if key did not exist.

Note that keys can be unicode but are lowercased before they're inserted in
the database. This is because the values are cached and cache is case sensitive; 
databases can be case-insensitive.

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

    # lowercase key
    $Param{Key} = lc $Param{Key};

    # return if key does not already exists - then we can't do an update
    my $Value = $Self->SystemDataGet( Key => $Param{Key} );
    if ( !defined $Value ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => "Can't update SystemData key '$Param{Key}', it does not exist!"
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
    $Self->{CacheInternalObject}->Delete(
        Key => 'SystemDataGet::' . $Param{Key},
    );

    return 1;
}

=item SystemDataDelete()

update system data

Returns true if de;ete was succesful or false if otherwise - for instance
if key did not exist.

    $SystemDataObject->SystemDataDelete(
        Key     => 'OTRS Version',
        UserID  => 123,
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

    # lowercase key
    $Param{Key} = lc $Param{Key};

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
        Bind => [ \$Param{Key}, ],
    );

    # delete cache entry
    $Self->{CacheInternalObject}->Delete(
        Key => 'SystemDataGet::' . $Param{Key},
    );

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
