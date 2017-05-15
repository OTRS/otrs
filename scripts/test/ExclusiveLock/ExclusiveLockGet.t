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

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    RestoreDatabase => 1,
);

my $LockKey = 'UnitTest';

my @Tests = (
    {
        Name    => 'Missing LockKey',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Wrong TTL',
        Config => {
            LockKey => $LockKey,
            TTL     => 'a',
        },
        Success => 0,
    },
    {
        Name   => 'Wrong Timeout',
        Config => {
            LockKey => $LockKey,
            TTL     => 20,
            Timeout => 'a',
        },
        Success => 0,
    },
    {
        Name   => 'LockKey Only',
        Config => {
            LockKey => $LockKey,
        },
        Success => 1,
    },
    {
        Name   => 'Full',
        Config => {
            LockKey => $LockKey,
        },
        Success => 1,
    },

);

my $ExclusiveLockObject = $Kernel::OM->Get("Kernel::System::ExclusiveLock");

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my $CheckLock = sub {
    my %Param = @_;

    return if !$DBObject->Prepare(
        SQL => '
            SELECT COUNT(id)
            FROM exclusive_lock
            WHERE lock_key = ?
                AND lock_uid =?',
        Bind => [ \$LockKey, \$Param{LockUID} ],
    );
    my $LocksCount;
    while ( my @Data = $DBObject->FetchrowArray() ) {
        $LocksCount = $Data[0];
    }
    return $LocksCount;
};

TEST:
for my $Test (@Tests) {
    my $LockHandle = $ExclusiveLockObject->ExclusiveLockGet( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $LockHandle,
            "$Test->{Name} ExclusiveLockGet() - with false",
        );
        next TEST;
    }

    $Self->Is(
        ref $LockHandle,
        'Kernel::System::ExclusiveLock::Handle',
        "$Test->{Name} ExclusiveLockGet() - LockHandle",
    );

    my $LockUID = $LockHandle->LockUIDGet();

    $Self->IsNot(
        $LockUID,
        undef,
        "$Test->{Name} LockUIDGet()",
    );

    my $NumberOfLocks = $CheckLock->( LockUID => $LockUID );
    $Self->Is(
        $NumberOfLocks,
        1,
        "$Test->{Name} Lock should still in the DB before handle destroy",
    );

    $LockHandle = undef;

    $NumberOfLocks = $CheckLock->( LockUID => $LockUID );
    $Self->Is(
        $NumberOfLocks,
        0,
        "$Test->{Name} Lock should not exists in the DB after handle destroy",
    );
}

# simple TTL and Timeout tests
@Tests = (
    {
        Name   => 'Timeout',
        Config => {
            LockKey => 'UnitTest',
            TTL     => 5,
            Timeout => 2,
        },
        OrigLockHandle => 'Kernel::System::ExclusiveLock::Handle',
        NewLockHandle  => '',
    },
    {
        Name   => 'TTL Over',
        Config => {
            LockKey => 'UnitTest',
            TTL     => 2,
            Timeout => 5,
        },
        OrigLockHandle => 'Kernel::System::ExclusiveLock::Handle',
        NewLockHandle  => 'Kernel::System::ExclusiveLock::Handle',
    },
);

for my $Test (@Tests) {
    my $OrigLockHandle = $ExclusiveLockObject->ExclusiveLockGet( %{ $Test->{Config} } );
    $Self->Is(
        ref $OrigLockHandle,
        $Test->{OrigLockHandle},
        "$Test->{Name} - Original Lock",
    );
    my $NewLockHandle = $ExclusiveLockObject->ExclusiveLockGet( %{ $Test->{Config} } );
    $Self->Is(
        ref $NewLockHandle,
        $Test->{NewLockHandle},
        "$Test->{Name} - New Lock",
    );
}

return if !$DBObject->Prepare(
    SQL => '
        SELECT COUNT(id)
        FROM exclusive_lock
        WHERE lock_key = ?',
    Bind => [ \$LockKey ],
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

# Cleanup is done by RestoreDatabase.

1;
