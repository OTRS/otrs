# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

#
# Tests for LockViewableLock().
#
my @Tests = (
    {
        Name   => 'Viewable locks - Default by Name',
        Config => [
            "'unlock'",
            "'tmp_lock'",
        ],
        Type   => 'Name',
        Result => [
            'tmp_lock',
            'unlock',
        ],
    },
    {
        Name   => 'Viewable locks - Default by ID',
        Config => [
            "'unlock'",
            "'tmp_lock'",
        ],
        Type   => 'ID',
        Result => [
            '1',
            '3',
        ],
    },
    {
        Name   => 'Viewable locks - Custom by Name',    # bug#12311
        Config => [
            "'unlock'",
            "'lock'",
            "'tmp_lock'",
        ],
        Type   => 'Name',
        Result => [
            'lock',
            'tmp_lock',
            'unlock',
        ],
    },
    {
        Name   => 'Viewable locks - Custom by ID',    # bug#12311
        Config => [
            "'unlock'",
            "'tmp_lock'",
            "'lock'",
        ],
        Type   => 'ID',
        Result => [
            '1',
            '2',
            '3',
        ],
    },
);

for my $Test (@Tests) {

    # Set config option to test value.
    my $Success = $ConfigObject->Set(
        Key   => 'Ticket::ViewableLocks',
        Value => $Test->{Config},
    );
    $Self->True(
        $Success,
        "$Test->{Name} - Config option set",
    );

    # Create lock object.
    my $LockObject = $Kernel::OM->Get('Kernel::System::Lock');

    # Get viewable locks.
    my @ViewableLocks = sort $LockObject->LockViewableLock(
        Type => $Test->{Type},
    );
    $Self->IsDeeply(
        \@ViewableLocks,
        $Test->{Result},
        "$Test->{Name} - Result",
    );

    # Discard lock object.
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::Lock',
        ],
    );
}

my $LockObject = $Kernel::OM->Get('Kernel::System::Lock');

#
# Tests for LockLookup().
#
@Tests = (
    {
        Name   => 'Lookup - lock',
        Input  => 'lock',
        Result => 1,
    },
    {
        Name   => 'Lookup - tmp_lock',
        Input  => 'tmp_lock',
        Result => 1,
    },
    {
        Name   => 'Lookup - unlock',
        Input  => 'unlock',
        Result => 1,
    },
    {
        Name   => 'Lookup - unlock_not_extsits',
        Input  => 'unlock_not_exists',
        Result => 0,
    },
);

for my $Test (@Tests) {

    my $LockID = $LockObject->LockLookup( Lock => $Test->{Input} );

    if ( $Test->{Result} ) {

        $Self->True( $LockID, $Test->{Name} );

        my $Lock = $LockObject->LockLookup( LockID => $LockID );

        $Self->Is(
            $Test->{Input},
            $Lock,
            $Test->{Name},
        );
    }
    else {
        $Self->False( $LockID, $Test->{Name} );
    }
}

# cleanup is done by RestoreDatabase

1;
