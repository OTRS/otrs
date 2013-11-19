# --
# Lock.t - Lock tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: Lock.t,v 1.2 2010-10-25 08:43:23 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::Lock;

my $LockObject = Kernel::System::Lock->new( %{$Self} );

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

1;
