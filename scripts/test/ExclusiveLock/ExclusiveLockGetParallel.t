# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $CacheType = 'UnitTestExclusiveLock';

my $LockKey      = 'UnitTest';
my $LockKeyOther = 'UnitTestOther';

# Cleanup old locks.
return if !$DBObject->Do(
    SQL => '
        DELETE FROM exclusive_lock
        WHERE lock_key = ? OR lock_key = ?',
    Bind => [ \$LockKey, \$LockKeyOther ],
);

# Create a lock with long TTL manually, otherwise the handle will die with the child removing the lock
#   this lock has a different LockKey to proof that other locks are not affected with this one.
my $DateTimeObject = $Kernel::OM->Create(
    'Kernel::System::DateTime'
);
my $Success = $DateTimeObject->Add(
    Seconds => 2400,
);
my $ExpiryTimeString = $DateTimeObject->ToString();

my $LockUID = $Kernel::OM->Get("Kernel::System::ExclusiveLock")->_GetUID();
return if !$DBObject->Do(
    SQL => '
        INSERT INTO exclusive_lock
            (lock_key, lock_uid, create_time, expiry_time)
        VALUES
            ( ?, ?, current_timestamp, ? )',
    Bind => [ \$LockKeyOther, \$LockUID, \$ExpiryTimeString ],
);

my $ChildCount     = 10;
my $LockCount      = 5;
my $LockCountOther = 1;
my $LockCountTotal = $LockCount + $LockCountOther;

my $CheckLock = sub {
    my %Param = @_;

    return if !$DBObject->Prepare(
        SQL => '
            SELECT COUNT(id)
            FROM exclusive_lock
            WHERE lock_key = ?
                AND lock_uid =?',
        Bind => [ \$Param{LockKey}, \$Param{LockUID} ],
    );
    my $LocksCount;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $LocksCount = $Data[0];
    }
    return $LocksCount;
};

for my $ChildIndex ( 1 .. $ChildCount ) {

    # Disconnect database before fork.
    $DBObject->Disconnect();

    # Create a fork of the current process
    #   parent gets the PID of the child
    #   child gets PID = 0.
    my $PID = fork;
    if ( !$PID ) {

        # Destroy objects.
        $Kernel::OM->ObjectsDiscard();

        for my $LockIndex ( 1 .. $LockCountTotal ) {

            my $TestLockKey = $LockKey;
            my $TestTimeout = 10;

            # special case that should fail due to the already locked key at the beginning
            if ( $LockIndex > $LockCount ) {
                $TestLockKey = $LockKeyOther;
                $TestTimeout = .5;
            }

            my $LockHandle = $Kernel::OM->Get("Kernel::System::ExclusiveLock")->ExclusiveLockGet(
                LockKey => $TestLockKey,
                Timeout => $TestTimeout,
            );

            my $LockUID;
            if ($LockHandle) {
                $LockUID = $LockHandle->LockUIDGet();
            }

            my $NumberOfLocks = $CheckLock->(
                LockKey => $TestLockKey,
                LockUID => $LockUID,
            );

            $Kernel::OM->Get('Kernel::System::Cache')->Set(
                Type  => $CacheType,
                Key   => "ExclusiveLockGetParallel::${ChildIndex}::${LockIndex}",
                Value => {
                    LockUID   => $LockUID,
                    LockFound => $NumberOfLocks,
                },
                TTL => 60 * 10,
            );

            # Release the lock by destroying the handle.
            $LockHandle = undef;
        }

        # Always end child process.
        exit;
    }
}

my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

my %ChildData;

my $SleepCounter = 0;
my $Wait         = 1;
while ($Wait) {
    CHILDINDEX:
    for my $ChildIndex ( 1 .. $ChildCount ) {

        LOCKINDEX:
        for my $LockIndex ( 1 .. $LockCountTotal ) {

            next LOCKINDEX if $ChildData{"${ChildIndex}${LockIndex}"};

            my $Cache = $CacheObject->Get(
                Type => $CacheType,
                Key  => "ExclusiveLockGetParallel::${ChildIndex}::${LockIndex}",
            );

            next LOCKINDEX if !$Cache;
            next LOCKINDEX if ref $Cache ne 'HASH';

            $ChildData{"${ChildIndex}${LockIndex}"} = $Cache;
        }
    }
}
continue {
    my $GotDataCount = scalar keys %ChildData;
    if ( $GotDataCount == ( $ChildCount * $LockCountTotal ) ) {
        $Wait = 0;
    }

    sleep 1;

    $SleepCounter++;
    if ( $SleepCounter == 20 ) {
        $Self->True(
            0,
            "Wait for children failed!"
        );
        $Wait = 0;
    }
}

my %LockUIDs;

CHILDINDEX:
for my $ChildIndex ( 1 .. $ChildCount ) {

    LOCKINDEX:
    for my $LockIndex ( 1 .. $LockCountTotal ) {

        my %Data = %{ $ChildData{"${ChildIndex}${LockIndex}"} };

        if ( $LockIndex > $LockCount ) {
            $Self->Is(
                $Data{LockUID},
                undef,
                "Child $ChildIndex - $LockIndex LockUID (using LockKey $LockKeyOther)",
            );
            $Self->False(
                $Data{LockFound},
                "Child $ChildIndex - $LockIndex Doesn't found its own lock in the DB (using LockKey $LockKeyOther)",
            );

            next LOCKINDEX;
        }

        $Self->IsNot(
            $Data{LockUID},
            undef,
            "Child $ChildIndex - $LockIndex LockUID",
        );

        $Self->True(
            $Data{LockFound},
            "Child $ChildIndex - $LockIndex Found its own lock in the DB",
        );

        $Self->Is(
            $LockUIDs{ $Data{LockUID} } || 0,
            0,
            "Child $ChildIndex - $LockIndex LockUID $Data{LockUID} should not exits in the list",
        );

        $LockUIDs{ $Data{LockUID} } = 1;
    }

}
$CacheObject->CleanUp(
    Type => $CacheType,
);

# Remove manually created lock.
return if !$DBObject->Do(
    SQL => '
        DELETE FROM exclusive_lock
        WHERE lock_uid = ?',
    Bind => [ \$LockUID, ],
);

# Check that there are not locks leftover.
return if !$DBObject->Prepare(
    SQL => '
        SELECT COUNT(id)
        FROM exclusive_lock
        WHERE lock_key = ? OR lock_key = ?',
    Bind => [ \$LockKey, \$LockKeyOther ],
);
my $LocksCount;
while ( my @Data = $DBObject->FetchrowArray() ) {
    $LocksCount = $Data[0];
}
$Self->Is(
    $LocksCount,
    0,
    "The number of $LockKey locks after the tests should be 0",
);

1;
