# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::ExclusiveLock;

use strict;
use warnings;

use Time::HiRes();

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::ExclusiveLock::Handle',
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::System::ExclusiveLock - Functions to perform application-level cooperative locking.

=head1 SYNOPSIS

Attempt to get an exclusive lock handle for a certain identifier, in this case 'TicketNumberCounter':

    my $LockHandle = $Kernel::OM->Get('Kernel::System::ExclusiveLock')->ExclusiveLockGet(
        LockKey => 'TicketNumberCounter',
    );

Get the exclusive lock UID:

    my $LockUID = $LockHandle->LockUIDGet();

=head1 PUBLIC INTERFACE

=head2 new()

Don't use the constructor directly, use the ObjectManager instead:

    my $ExclusiveLockObject = $Kernel::OM->Get('Kernel::System::ExclusiveLock');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 ExclusiveLockGet()

Attempt to get an exclusive lock handle for a certain identifier, in this case 'TicketNumberCounter':

    my $LockHandle = $ExclusiveLockObject->ExclusiveLockGet(
        LockKey => 'TicketNumberCounter', # what to lock
        Timeout => 10,                    # how long to wait for lock retrieval, default 10 seconds
        TTL     => 20,                    # how long this lock is valid, default 20 seconds
    );

Returns an instance of L<Kernel::System::ExclusiveLock::Handle> in case of success, undef otherwise.

If the lock was retrieved successfully, then no other process can have a lock on the same identifier as long as the lock is valid.

This lock handle will automatically release its lock on the database if the object is destroyed, and can therefore be used as a scope guard.

=cut

sub ExclusiveLockGet {
    my ( $Self, %Param ) = @_;

    if ( !$Param{LockKey} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Need LockKey!",
        );

        return;
    }

    for my $Check (qw(TTL Timeout)) {
        if ( $Param{$Check} && !IsNumber( $Param{$Check} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "$Check is invalid!",
            );

            return;
        }
    }

    my $TTL     = abs( $Param{TTL}     || 20 );
    my $Timeout = abs( $Param{Timeout} || 10 );

    # Remove expired locks before adding a new lock candidate.
    my $Success = $Self->ExclusiveLockDeleteExpired();

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );

    $Success = $DateTimeObject->Add(
        Seconds => $TTL,
    );
    my $ExpiryTimeString = $DateTimeObject->ToString();

    my $LockUID = $Self->_GetUID();

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Create a lock candidate.
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO exclusive_lock
                (lock_key, lock_uid, create_time, expiry_time)
            VALUES
                ( ?, ?, current_timestamp, ? )',
        Bind => [ \$Param{LockKey}, \$LockUID, \$ExpiryTimeString ],
    );

    # Get the LockID using the LockUID.
    return if !$DBObject->Prepare(
        SQL => '
            SELECT id
            FROM exclusive_lock
            WHERE lock_uid = ?',
        Bind => [ \$LockUID ],
    );

    my $LockID;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $LockID = $Data[0];
    }

    if ( !$LockID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not get LockID for $Param{LockKey}",
        );
        return;
    }

    # Create a LockHandle as a scope guard to make sure that the lock is always released
    #   in case of an error, no matter how the current scope is exited .
    my $LockHandle = $Kernel::OM->Create(
        'Kernel::System::ExclusiveLock::Handle',
        ObjectParams => {
            LockKey => $Param{LockKey},
            LockUID => $LockUID,
        },
    );

    my $LockObtained;
    my $SleepCounter  = 0;
    my $SleepDuration = 0.01;

    # Wait until all other previous locks for this object has been removed
    ACTIVESLEEP:
    while ( !$LockObtained ) {

        # Get the number of all previous locks for the current key.
        last ACTIVESLEEP if !$DBObject->Prepare(
            SQL => '
                SELECT COUNT(id)
                FROM exclusive_lock
                WHERE lock_key = ?
                    AND id < ?',
            Bind  => [ \$Param{LockKey}, \$LockID ],
            Limit => 1,
        );
        my $CountOfOlderLocks;
        while ( my @Data = $DBObject->FetchrowArray() ) {
            $CountOfOlderLocks = $Data[0];
        }

        # If there are no other locks, stop. Lock candidate will be new lock.
        if ( !$CountOfOlderLocks ) {
            $LockObtained++;
            last ACTIVESLEEP;
        }

        # Are we over the timeout yet?
        if ( $SleepCounter * $SleepDuration >= $Timeout ) {
            last ACTIVESLEEP;
        }

        $SleepCounter++;
        Time::HiRes::sleep($SleepDuration);

        # Perform some tasks on each second.
        next ACTIVESLEEP if int $SleepCounter % ( 1 / $SleepDuration );

        # Update expire time of the lock candidate to prevent own expire time while getting the lock.
        my $DateTimeObject = $Kernel::OM->Create(
            'Kernel::System::DateTime'
        );
        my $Success = $DateTimeObject->Add(
            Seconds => $TTL,
        );
        my $ExpiryTimeString = $DateTimeObject->ToString();
        last ACTIVESLEEP if !$DBObject->Do(
            SQL => '
                UPDATE exclusive_lock
                SET expiry_time = ?
                WHERE id = ?',
            Bind => [ \$ExpiryTimeString, \$LockID, ],
        );

        # Remove expired locks.
        $Success = $Self->ExclusiveLockDeleteExpired();
    }

    # Return false if there are still other previous locks.
    if ( !$LockObtained ) {

        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not get exclusive lock for $Param{LockKey}",
        );

        # LockHandle will automatically release the lock.
        return;
    }

    return $LockHandle;
}

=head2 ExclusiveLockDeleteExpired()

Removes expired exclusive locks in the database.

    my $Success = $ExclusiveLockObject->ExclusiveLockDeleteExpired();

=cut

sub ExclusiveLockDeleteExpired {
    my ( $Self, %Param ) = @_;

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime'
    );

    my $DateTimeString = $DateTimeObject->ToString();

    # Remove all expired locks.
    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL  => 'DELETE FROM exclusive_lock WHERE expiry_time <= ?',
        Bind => [ \$DateTimeString ],
    );

    return 1;
}

=head2 ExclusiveLockRelease()

Removes an exclusive lock entry.

    my $Success = $ExclusiveLockObject->ExclusiveLockRelease(
        LockKey => 'TicketNumberCounter',   # what to unlock
        LockUID => $LockUID,
    );

=cut

sub ExclusiveLockRelease {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(LockKey LockUID)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    return if !$Kernel::OM->Get('Kernel::System::DB')->Do(
        SQL => '
            DELETE FROM exclusive_lock
            WHERE lock_key = ?
                AND lock_uid = ?',
        Bind => [ \$Param{LockKey}, \$Param{LockUID} ],
    );

    return 1;

}

=head1 PRIVATE INTERFACE

=head2 _GetUID()

Generates a unique identifier.

    my $UID = $TicketNumberObject->_GetUID();

Returns:

    my $UID = 14906327941360ed8455f125d0450277;

=cut

sub _GetUID {
    my ( $Self, %Param ) = @_;

    my $NodeID = $Kernel::OM->Get('Kernel::Config')->Get('NodeID') || 1;
    my ( $Seconds, $Microseconds ) = Time::HiRes::gettimeofday();
    my $ProcessID = $$;

    my $CounterUID = $ProcessID . $Seconds . $Microseconds . $NodeID;

    my $RandomString = $Kernel::OM->Get('Kernel::System::Main')->GenerateRandomString(
        Length     => 32 - length $CounterUID,
        Dictionary => [ 0 .. 9, 'a' .. 'f' ],    # hexadecimal
    );

    $CounterUID .= $RandomString;

    return $CounterUID;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
