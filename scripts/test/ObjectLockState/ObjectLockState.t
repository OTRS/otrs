# --
# ObjectLockState.t - ObjectLockState tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ObjectLockState.t,v 1.1 2011-02-25 15:28:52 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::ObjectLockState;

my $ObjectLockStateObject = Kernel::System::ObjectLockState->new( %{$Self} );

my $RandomNumber     = int rand(10000000);
my $CustomObjectType = "TestObject$RandomNumber";

my $Success = $ObjectLockStateObject->ObjectLockStateSet(
    ObjectType       => $CustomObjectType,
    ObjectID         => $RandomNumber,
    LockState        => 'locked',
    LockStateCounter => 0,
);

$Self->True(
    $Success,
    'ObjectLockStateSet() for new entry',
);

my $ObjectLockState = $ObjectLockStateObject->ObjectLockStateGet(
    ObjectType => $CustomObjectType,
    ObjectID   => $RandomNumber,
);

my %Check = (
    ObjectType       => $CustomObjectType,
    ObjectID         => $RandomNumber,
    LockState        => 'locked',
    LockStateCounter => 0,
);

for my $Key ( sort keys %Check ) {
    $Self->Is(
        $ObjectLockState->{$Key},
        $Check{$Key},
        "ObjectLockStateGet() $Key for new entry",
    );
}

$Success = $ObjectLockStateObject->ObjectLockStateSet(
    ObjectType       => $CustomObjectType,
    ObjectID         => $RandomNumber,
    LockState        => 'locked2',
    LockStateCounter => 3,
);

$Self->True(
    $Success,
    'ObjectLockStateSet() for existing entry',
);

$ObjectLockState = $ObjectLockStateObject->ObjectLockStateGet(
    ObjectType => $CustomObjectType,
    ObjectID   => $RandomNumber,
);

%Check = (
    ObjectType       => $CustomObjectType,
    ObjectID         => $RandomNumber,
    LockState        => 'locked2',
    LockStateCounter => 3,
);

for my $Key ( sort keys %Check ) {
    $Self->Is(
        $ObjectLockState->{$Key},
        $Check{$Key},
        "ObjectLockStateGet() $Key for existing entry",
    );
}

my $ObjectLockStates = $ObjectLockStateObject->ObjectLockStateList(
    ObjectType => $CustomObjectType,
    ObjectID   => $RandomNumber,
);

$Self->Is(
    scalar @{$ObjectLockStates},
    1,
    "ObjectLockStateList() for ObjectType",
);

for my $Key ( sort keys %Check ) {
    $Self->Is(
        $ObjectLockStates->[0]->{$Key},
        $Check{$Key},
        "ObjectLockStateList() $Key for existing entry",
    );
}

$Success = $ObjectLockStateObject->ObjectLockStateDelete(
    ObjectType => $CustomObjectType,
    ObjectID   => $RandomNumber,
);

$Self->True(
    $Success,
    'ObjectLockStateDelete() for existing entry',
);

$ObjectLockState = $ObjectLockStateObject->ObjectLockStateGet(
    ObjectType => $CustomObjectType,
    ObjectID   => $RandomNumber,
);

$Self->False(
    scalar %{$ObjectLockState},
    "ObjectLockStateGet() for deleted entry",
);

$Success = $ObjectLockStateObject->ObjectLockStateDelete(
    ObjectType => $CustomObjectType,
    ObjectID   => $RandomNumber,
);

$Self->False(
    defined $Success,
    'ObjectLockStateDelete() for deleted entry',
);

1;
