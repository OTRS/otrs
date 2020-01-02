# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::SystemAddress;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Cache',
    'Kernel::System::DB',
    'Kernel::System::Log',
    'Kernel::System::Valid',
);

=head1 NAME

Kernel::System::SystemAddress - all system address functions

=head1 DESCRIPTION

Global module to add/edit/update system addresses.

=head1 PUBLIC INTERFACE

=head2 new()

create an object

    my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{CacheType} = 'SystemAddress';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=head2 SystemAddressAdd()

add system address with attributes

    my $ID = $SystemAddressObject->SystemAddressAdd(
        Name     => 'info@example.com',
        Realname => 'Hotline',
        ValidID  => 1,
        QueueID  => 123,
        Comment  => 'some comment',
        UserID   => 123,
    );

=cut

sub SystemAddressAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Name ValidID Realname QueueID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # check if a system address with this name already exists
    if ( $Self->NameExistsCheck( Name => $Param{Name} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "A system address with the name '$Param{Name}' already exists.",
        );
        return;
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # insert new system address
    return if !$DBObject->Do(
        SQL => 'INSERT INTO system_address (value0, value1, valid_id, comments, queue_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Realname}, \$Param{ValidID}, \$Param{Comment},
            \$Param{QueueID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get system address id
    $DBObject->Prepare(
        SQL   => 'SELECT id FROM system_address WHERE value0 = ? AND value1 = ?',
        Bind  => [ \$Param{Name}, \$Param{Realname}, ],
        Limit => 1,
    );

    # fetch the result
    my $ID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $ID = $Row[0];
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return $ID;
}

=head2 SystemAddressGet()

get system address with attributes

    my %SystemAddress = $SystemAddressObject->SystemAddressGet(
        ID => 1,
    );

returns:

    %SystemAddress = (
        ID         => 1,
        Name       => 'info@example.com'
        Realname   => 'Hotline',
        QueueID    => 123,
        Comment    => 'some comment',
        ValidID    => 1,
        CreateTime => '2010-11-29 11:04:04',
        ChangeTime => '2010-12-07 12:33:56',
    )

=cut

sub SystemAddressGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need ID!",
        );
        return;
    }

    my $CacheKey = 'SystemAddressGet::' . $Param{ID};

    my $Cached = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    return %{$Cached} if ref $Cached eq 'HASH';

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get system address
    return if !$DBObject->Prepare(
        SQL => 'SELECT value0, value1, comments, valid_id, queue_id, change_time, create_time '
            . ' FROM system_address WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    # fetch the result
    my %Data;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        %Data = (
            ID         => $Param{ID},
            Name       => $Data[0],
            Realname   => $Data[1],
            Comment    => $Data[2],
            ValidID    => $Data[3],
            QueueID    => $Data[4],
            ChangeTime => $Data[5],
            CreateTime => $Data[6],
        );
    }

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%Data,
    );

    return %Data;
}

=head2 SystemAddressUpdate()

update system address with attributes

    $SystemAddressObject->SystemAddressUpdate(
        ID       => 1,
        Name     => 'info@example.com',
        Realname => 'Hotline',
        ValidID  => 1,
        QueueID  => 123,
        Comment  => 'some comment',
        UserID   => 123,
    );

=cut

sub SystemAddressUpdate {
    my ( $Self, %Param ) = @_;

    # Check needed stuff.
    for my $Needed (qw(ID Name ValidID Realname QueueID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # Check if a system address with this name already exists.
    if (
        $Self->NameExistsCheck(
            ID   => $Param{ID},
            Name => $Param{Name}
        )
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "A system address with the name '$Param{Name}' already exists.",
        );
        return;
    }

    # Check if a system address is used in some queue's or auto response's.
    if ( $Self->SystemAddressIsUsed( SystemAddressID => $Param{ID} ) && $Param{ValidID} > 1 )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message =>
                "This system address '$Param{Name}' cannot be set to invalid, because it is used in one or more queue(s) or auto response(s).",
        );
        return;
    }

    # Update system address.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => 'UPDATE system_address SET value0 = ?, value1 = ?, comments = ?, valid_id = ?, '
            . ' change_time = current_timestamp, change_by = ?, queue_id = ? WHERE id = ?',
        Bind => [
            \$Param{Name}, \$Param{Realname}, \$Param{Comment}, \$Param{ValidID},
            \$Param{UserID}, \$Param{QueueID}, \$Param{ID},
        ],
    );

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return 1;
}

=head2 SystemAddressList()

get a list of system addresses

    my %List = $SystemAddressObject->SystemAddressList(
        Valid => 0,  # optional, defaults to 1
    );

returns:

    %List = (
        '1' => 'sales@example.com',
        '2' => 'purchasing@example.com',
        '3' => 'service@example.com',
    );

=cut

sub SystemAddressList {
    my ( $Self, %Param ) = @_;

    my $Valid = 1;
    if ( !$Param{Valid} && defined $Param{Valid} ) {
        $Valid = 0;
    }

    my $CacheKey = 'SystemAddressList::' . $Valid;

    my $Cached = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    return %{$Cached} if ref $Cached eq 'HASH';

    my $ValidSQL = '';
    if ($Valid) {
        my $ValidIDs = join ',', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();
        $ValidSQL = " WHERE valid_id IN ($ValidIDs)";
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get system address
    return if !$DBObject->Prepare(
        SQL => "
            SELECT id, value0
            FROM system_address
            $ValidSQL",
    );

    my %List;

    while ( my @Data = $DBObject->FetchrowArray() ) {
        $List{ $Data[0] } = $Data[1];
    }

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \%List,
    );

    return %List;
}

=head2 SystemAddressIsLocalAddress()

Checks if the given address is a local (system) address. Returns true
for local addresses.

    if ( $SystemAddressObject->SystemAddressIsLocalAddress( Address => 'info@example.com' ) ) {
        # is local
    }
    else {
        # is not local
    }

=cut

sub SystemAddressIsLocalAddress {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Address)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    return $Self->SystemAddressQueueID(%Param);
}

=head2 SystemAddressQueueID()

find dispatching queue id of email address

    my $QueueID = $SystemAddressObject->SystemAddressQueueID( Address => 'info@example.com' );

=cut

sub SystemAddressQueueID {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Needed (qw(Address)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );
            return;
        }
    }

    # remove spaces
    $Param{Address} =~ s/\s+//g;

    my $CacheKey = 'SystemAddressQueueID::' . $Param{Address};
    my $Cached   = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    return ${$Cached} if ref $Cached eq 'SCALAR';

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    if ( $DBObject->GetDatabaseFunction('CaseSensitive') ) {

        return if !$DBObject->Prepare(
            SQL => "SELECT queue_id FROM system_address WHERE "
                . "valid_id IN ( ${\(join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet())} ) "
                . "AND LOWER(value0) = LOWER(?)",
            Bind  => [ \$Param{Address} ],
            Limit => 1,
        );
    }
    else {
        return if !$DBObject->Prepare(
            SQL => "SELECT queue_id FROM system_address WHERE "
                . "valid_id IN ( ${\(join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet())} ) "
                . "AND value0 = ?",
            Bind  => [ \$Param{Address} ],
            Limit => 1,
        );
    }

    # fetch the result
    my $QueueID;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $QueueID = $Row[0];
    }

    $Kernel::OM->Get('Kernel::System::Cache')->Set(
        Type  => $Self->{CacheType},
        TTL   => $Self->{CacheTTL},
        Key   => $CacheKey,
        Value => \$QueueID,
    );

    return $QueueID;
}

=head2 SystemAddressQueueList()

get a list of the queues and their system addresses IDs

    my %List = $SystemAddressObject->SystemAddressQueueList(
        Valid => 0,  # optional, defaults to 1
    );

returns:

    %List = (
        '5' => 3,
        '7' => 1,
        '9' => 2,
    );

=cut

sub SystemAddressQueueList {
    my ( $Self, %Param ) = @_;

    # set default value
    my $Valid = $Param{Valid} // 1;

    # create the valid list
    my $ValidIDs = join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();

    # build SQL
    my $SQL = 'SELECT queue_id, id FROM system_address';

    # add WHERE statement in case Valid param is set to '1', for valid system address
    if ($Valid) {
        $SQL .= ' WHERE valid_id IN (' . $ValidIDs . ')';
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # get data from database
    return if !$DBObject->Prepare(
        SQL => $SQL,
    );

    # fetch the result
    my %SystemAddressQueueList;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $SystemAddressQueueList{ $Row[0] } = $Row[1];
    }

    return %SystemAddressQueueList;

}

=head2 NameExistsCheck()

return 1 if another system address with this name already exists

    $Exist = $SystemAddressObject->NameExistsCheck(
        Name => 'Some Address',
        ID => 1, # optional
    );

=cut

sub NameExistsCheck {
    my ( $Self, %Param ) = @_;

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
    return if !$DBObject->Prepare(
        SQL  => 'SELECT id FROM system_address WHERE value0 = ?',
        Bind => [ \$Param{Name} ],
    );

    # fetch the result
    my $Flag;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        if ( !$Param{ID} || $Param{ID} ne $Row[0] ) {
            $Flag = 1;
        }
    }

    if ($Flag) {
        return 1;
    }

    return 0;
}

=head2 SystemAddressIsUsed()

Return 1 if system address is used in one of the queue's or auto response's.

    $SytemAddressIsUsed = $SystemAddressObject->SystemAddressIsUsed(
        SystemAddressID => 1,
    );

=cut

sub SystemAddressIsUsed {
    my ( $Self, %Param ) = @_;

    # Check needed param.
    if ( !$Param{SystemAddressID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need SystemAddressID!"
        );
        return;
    }

    # Get database object.
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => 'SELECT DISTINCT sa.id FROM system_address sa
            LEFT JOIN queue q ON q.system_address_id = sa.id
            LEFT JOIN auto_response ar ON ar.system_address_id = sa.id
            WHERE q.system_address_id = ? OR ar.system_address_id = ?',
        Bind  => [ \$Param{SystemAddressID}, \$Param{SystemAddressID} ],
        Limit => 1,
    );

    # Fetch the result.
    my $SystemAddressIsUsed;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $SystemAddressIsUsed = $Row[0] ? 1 : 0;
    }

    return $SystemAddressIsUsed;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
