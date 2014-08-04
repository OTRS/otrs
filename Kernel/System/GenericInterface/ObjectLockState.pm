# --
# Kernel/System/GenericInterface/ObjectLockState.pm - backend for lock state handling
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericInterface::ObjectLockState;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::DB',
    'Kernel::System::Log',
);
our $ObjectManagerAware = 1;

=head1 NAME

Kernel::System::GenericInterface::ObjectLockState - lock state backend

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a debug log object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $ObjectLockStateObject = $Kernel::OM->Get('Kernel::System::GenericInterface::ObjectLockState');

=cut

sub new {
    my ( $ObjectLockState, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $ObjectLockState );

    return $Self;
}

=item ObjectLockStateSet()

set lock state for an object.

    my $Success = $ObjectLockStateObject->ObjectLockStateSet(
        WebserviceID     => 123,
        ObjectType       => 'Ticket',       # type of the object
        ObjectID         => 123,            # ID of the object
        LockState        => 'sync_started', # the state to set
        LockStateCounter => 0,              # optional, defaults to 0
    );

=cut

sub ObjectLockStateSet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(WebserviceID ObjectType ObjectID LockState)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # create new
    if ( !%{ $Self->ObjectLockStateGet(%Param) || {} } ) {
        return if !$DBObject->Do(
            SQL => '
                INSERT INTO gi_object_lock_state
                    (webservice_id, object_type, object_id, lock_state, lock_state_counter, create_time, change_time)
                VALUES (?, ?, ?, ?, ?, current_timestamp, current_timestamp)',
            Bind => [
                \int( $Param{WebserviceID} ),
                \$Param{ObjectType},
                \int( $Param{ObjectID} ),
                \$Param{LockState},
                \int( $Param{LockStateCounter} || 0 ),
            ],
        );
    }
    else {    # update existing

        return if !$DBObject->Do(
            SQL => '
                UPDATE gi_object_lock_state
                SET lock_state = ?, lock_state_counter = ?, change_time = current_timestamp
                WHERE webservice_id = ?
                    AND object_type = ?
                    AND object_id = ?',
            Bind => [
                \$Param{LockState},
                \int( $Param{LockStateCounter} || 0 ),
                \int( $Param{WebserviceID} ),
                \$Param{ObjectType},
                \int( $Param{ObjectID} ),
            ],
            ,
        );
    }

    return 1;
}

=item ObjectLockStateGet()

gets the lock state of an object

    my $ObjectLockState = $ObjectLockStateObject->ObjectLockStateGet(
        WebserviceID     => 123,
        ObjectType       => 'Ticket',       # type of the object
        ObjectID         => 123,            # ID of the object
    );

If lock state was found, returns:

    $ObjectLockState = {
        WebserviceID     => 123,
        ObjectType       => 'Ticket',
        ObjectID         => 123,
        LockState        => 'sync_started',
        LockStateCounter => 0,
        CreateTime       => '2011-02-08 15:08:00',
        ChangeTime       => '2011-02-08 15:08:00',
    };

If no lock state was found, returns {}.

=cut

sub ObjectLockStateGet {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(WebserviceID ObjectType ObjectID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL => '
            SELECT webservice_id, object_type, object_id, lock_state, lock_state_counter, create_time, change_time
            FROM gi_object_lock_state
            WHERE webservice_id =?
                AND object_type = ?
                AND object_id = ?',
        Bind => [
            \int( $Param{WebserviceID} ),
            \$Param{ObjectType},
            \int( $Param{ObjectID} ),
        ],
    );

    my %Result;
    while ( my @Data = $DBObject->FetchrowArray() ) {

        %Result = (
            WebserviceID     => $Data[0],
            ObjectType       => $Data[1],
            ObjectID         => $Data[2],
            LockState        => $Data[3],
            LockStateCounter => $Data[4],
            CreateTime       => $Data[5],
            ChangeTime       => $Data[6],
        );
    }

    return \%Result;
}

=item ObjectLockStateDelete()

deletes lock state of an object.

    my $Success = $ObjectLockStateObject->ObjectLockStateDelete(
        WebserviceID     => 123,
        ObjectType       => 'Ticket',       # type of the object
        ObjectID         => 123,            # ID of the object
    );

=cut

sub ObjectLockStateDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(WebserviceID ObjectType ObjectID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    return if ( !%{ $Self->ObjectLockStateGet(%Param) || {} } );

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Do(
        SQL => '
            DELETE FROM gi_object_lock_state
            WHERE webservice_id = ?
                AND object_type = ?
                AND object_id = ?',
        Bind => [
            \int( $Param{WebserviceID} ),
            \$Param{ObjectType},
            \int( $Param{ObjectID} ),
        ],
    );

    return 1;
}

=item ObjectLockStatePurge()

deletes all entries of a given webservice.

    my $Success = $ObjectLockStateObject->ObjectLockStatePurge(
        WebserviceID     => 123,
    );

=cut

sub ObjectLockStatePurge {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(WebserviceID)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Do(
        SQL => '
            DELETE FROM gi_object_lock_state
            WHERE webservice_id = ?',
        Bind => [
            \int( $Param{WebserviceID} ),
        ],
    );

    return 1;
}

=item ObjectLockStateList()

gets a list of lock states of an object type.

    my $ObjectLockStates = $ObjectLockStateObject->ObjectLockStateList(
        WebserviceID     => 123,
        ObjectType       => 'Ticket',       # type of the object
        LockState        => 'sync_started', # optional, only entries with this lock state
    );

Returns:

    $ObjectLockStates = [
        {
            WebserviceID     => 123,
            ObjectType       => 'Ticket',
            ObjectID         => 123,
            LockState        => 'sync_started',
            LockStateCounter => 0,
            CreateTime       => '2011-02-08 15:08:00',
            ChangeTime       => '2011-02-08 15:08:00',
        },
        ...
    ];

=cut

sub ObjectLockStateList {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(ObjectType)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error', Message => "Need $Key!" );
            return;
        }
    }

    my $SQL = '
        SELECT webservice_id, object_type, object_id, lock_state, lock_state_counter, create_time, change_time
        FROM gi_object_lock_state
        WHERE webservice_id = ?
            AND object_type = ?';

    my @Bind = (
        \int( $Param{WebserviceID} ),
        \$Param{ObjectType},
    );

    if ( $Param{LockState} ) {
        $SQL .= ' AND lock_state = ?';

        push @Bind, \$Param{LockState};

    }

    $SQL .= ' ORDER BY object_id ASC';

    # get database object
    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    return if !$DBObject->Prepare(
        SQL  => $SQL,
        Bind => \@Bind,
    );

    my @Result;

    while ( my @Data = $DBObject->FetchrowArray() ) {

        push @Result, {
            WebserviceID     => $Data[0],
            ObjectType       => $Data[1],
            ObjectID         => $Data[2],
            LockState        => $Data[3],
            LockStateCounter => $Data[4],
            CreateTime       => $Data[5],
            ChangeTime       => $Data[6],
        };
    }

    return \@Result;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
