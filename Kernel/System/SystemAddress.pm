# --
# Kernel/System/SystemAddress.pm - lib for system addresses
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

=head1 SYNOPSIS

Global module to add/edit/update system addresses.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{DBObject} = $Kernel::OM->Get('Kernel::System::DB');

    $Self->{CacheType} = 'SystemAddress';
    $Self->{CacheTTL}  = 60 * 60 * 24 * 20;

    return $Self;
}

=item SystemAddressAdd()

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
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # insert new system address
    return if !$Self->{DBObject}->Do(
        SQL => 'INSERT INTO system_address (value0, value1, valid_id, comments, queue_id, '
            . ' create_time, create_by, change_time, change_by)'
            . ' VALUES (?, ?, ?, ?, ?, current_timestamp, ?, current_timestamp, ?)',
        Bind => [
            \$Param{Name}, \$Param{Realname}, \$Param{ValidID}, \$Param{Comment},
            \$Param{QueueID}, \$Param{UserID}, \$Param{UserID},
        ],
    );

    # get system address id
    $Self->{DBObject}->Prepare(
        SQL   => 'SELECT id FROM system_address WHERE value0 = ? AND value1 = ?',
        Bind  => [ \$Param{Name}, \$Param{Realname}, ],
        Limit => 1,
    );

    # fetch the result
    my $ID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $ID = $Row[0];
    }

    $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
        Type => $Self->{CacheType},
    );

    return $ID;
}

=item SystemAddressGet()

get system address with attributes

    my %SystemAddress = $SystemAddressObject->SystemAddressGet(
        ID => 1,
    );

returns:

    %SystemAddress = (
        'ID'         => 1,
        'Name'       => 'info@example.com'
        'Realname'   => 'Hotline',
        'QueueID'    => 123,
        'Comment'    => 'some comment',
        'ValidID'    => 1,
        'CreateTime' => '2010-11-29 11:04:04',
        'ChangeTime' => '2010-12-07 12:33:56',
    )

=cut

sub SystemAddressGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{ID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need ID!"
        );
        return;
    }

    my $CacheKey = 'SystemAddressGet::' . $Param{ID};

    my $Cached = $Kernel::OM->Get('Kernel::System::Cache')->Get(
        Type => $Self->{CacheType},
        Key  => $CacheKey,
    );

    if ( ref $Cached eq 'HASH' ) {
        return %{$Cached};
    }

    # get system address
    return if !$Self->{DBObject}->Prepare(
        SQL => 'SELECT value0, value1, comments, valid_id, queue_id, change_time, create_time '
            . ' FROM system_address WHERE id = ?',
        Bind  => [ \$Param{ID} ],
        Limit => 1,
    );

    # fetch the result
    my %Data;
    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
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

=item SystemAddressUpdate()

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

    # check needed stuff
    for my $Needed (qw(ID Name ValidID Realname QueueID UserID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    # update system address
    return if !$Self->{DBObject}->Do(
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

=item SystemAddressList()

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

    if ( ref $Cached eq 'HASH' ) {
        return %{$Cached};
    }

    my $ValidSQL = '';
    if ($Valid) {
        my $ValidIDs = join ',', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet();
        $ValidSQL = " WHERE valid_id IN ($ValidIDs)";
    }

    # get system address
    return if !$Self->{DBObject}->Prepare(
        SQL => "
            SELECT id, value0
            FROM system_address
            $ValidSQL",
    );

    my %List;

    while ( my @Data = $Self->{DBObject}->FetchrowArray() ) {
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

=item SystemAddressIsLocalAddress()

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
                Message  => "Need $Needed!"
            );
            return;
        }
    }

    return $Self->SystemAddressQueueID(%Param);
}

=item SystemAddressQueueID()

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
                Message  => "Need $Needed!"
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

    if ( ref $Cached eq 'SCALAR' ) {
        return ${$Cached};
    }

    if ( $Self->{DBObject}->GetDatabaseFunction('CaseSensitive') ) {
        return if !$Self->{DBObject}->Prepare(
            SQL => "SELECT queue_id FROM system_address WHERE "
                . "valid_id IN ( ${\(join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet())} ) "
                . "AND LOWER(value0) = LOWER(?)",
            Bind  => [ \$Param{Address} ],
            Limit => 1,
        );
    }
    else {
        return if !$Self->{DBObject}->Prepare(
            SQL => "SELECT queue_id FROM system_address WHERE "
                . "valid_id IN ( ${\(join ', ', $Kernel::OM->Get('Kernel::System::Valid')->ValidIDsGet())} ) "
                . "AND value0 = ?",
            Bind  => [ \$Param{Address} ],
            Limit => 1,
        );
    }

    # fetch the result
    my $QueueID;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
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

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
