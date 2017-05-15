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

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

# Cleanup old locks
return if !$DBObject->Do(
    SQL => '
        DELETE FROM exclusive_lock
        WHERE lock_key = ?',
    Bind => [ \$LockKey, ],
);

my @Tests = (
    {
        Name    => 'Empty',
        Config  => {},
        Success => 0,
    },
    {
        Name   => 'Missing LockKey',
        Config => {
            LockUID => 'Replace',
        },
        Success => 0,
    },
    {
        Name   => 'Missing LockUID',
        Config => {
            LockKey => $LockKey,
        },
        Success => 0,
    },
    {
        Name   => 'Full Params',
        Config => {
            LockKey => $LockKey,
            LockUID => 'Replace',
        },
        Success => 1,
    },
);

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

my $ExclusiveLockObject = $Kernel::OM->Get("Kernel::System::ExclusiveLock");

TEST:
for my $Test (@Tests) {

    my $LockHandle = $ExclusiveLockObject->ExclusiveLockGet(
        LockKey => $Test->{Config}->{LockKey} // $LockKey,
    );

    my $LockUID = $LockHandle->LockUIDGet();

    my $NumberOfLocks = $CheckLock->( LockUID => $LockUID );
    $Self->Is(
        $NumberOfLocks,
        1,
        "$Test->{Name} Lock should still in the DB before release",
    );

    # Replace LockUID with a valid one
    if ( $Test->{Config}->{LockUID} && $Test->{Config}->{LockUID} eq 'Replace' ) {
        $Test->{Config}->{LockUID} = $LockUID;
    }

    my $Success = $ExclusiveLockObject->ExclusiveLockRelease( %{ $Test->{Config} } );

    if ( !$Test->{Success} ) {
        $Self->False(
            $Success,
            "$Test->{Name} ExclusiveLockRelease() - with false"
        );

        undef $LockHandle;

        next TEST;
    }
    $Self->True(
        $Success,
        "$Test->{Name} ExclusiveLockRelease() - with true"
    );

    $NumberOfLocks = $CheckLock->( LockUID => $LockUID );
    $Self->Is(
        $NumberOfLocks,
        0,
        "$Test->{Name} Lock should not exists in the DB after release",
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
