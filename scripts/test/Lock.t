# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get lock object
my $LockObject = $Kernel::OM->Get('Kernel::System::Lock');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my @Names = sort $LockObject->LockViewableLock(
    Type => 'Name',
);

$Self->IsDeeply(
    \@Names,
    [ 'tmp_lock', 'unlock' ],
    'LockViewableLock()',
);

my @Tests = (
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
