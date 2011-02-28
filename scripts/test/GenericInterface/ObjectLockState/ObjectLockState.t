# --
# ObjectLockState.t - ObjectLockState tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ObjectLockState.t,v 1.1 2011-02-28 11:32:25 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::GenericInterface::Webservice;
use Kernel::System::GenericInterface::ObjectLockState;

my $WebserviceObject      = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
my $ObjectLockStateObject = Kernel::System::GenericInterface::ObjectLockState->new( %{$Self} );

my $RandomNumber     = int rand(10000000);
my $CustomObjectType = "TestObject$RandomNumber";

# add config
my $WebserviceID = $WebserviceObject->WebserviceAdd(
    Config => {
        Debugger => {
            DebugThreshold => 'debug',
        },
    },
    Name    => "Test$RandomNumber",
    ValidID => 1,
    UserID  => 1,
);

$Self->True(
    $WebserviceID,
    "WebserviceAdd()",
);

my $Success = $ObjectLockStateObject->ObjectLockStateSet(
    WebserviceID     => $WebserviceID,
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
    WebserviceID => $WebserviceID,
    ObjectType   => $CustomObjectType,
    ObjectID     => $RandomNumber,
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
    WebserviceID     => $WebserviceID,
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
    WebserviceID => $WebserviceID,
    ObjectType   => $CustomObjectType,
    ObjectID     => $RandomNumber,
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
    WebserviceID => $WebserviceID,
    ObjectType   => $CustomObjectType,
    ObjectID     => $RandomNumber,
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
    WebserviceID => $WebserviceID,
    ObjectType   => $CustomObjectType,
    ObjectID     => $RandomNumber,
);

$Self->True(
    $Success,
    'ObjectLockStateDelete() for existing entry',
);

$ObjectLockState = $ObjectLockStateObject->ObjectLockStateGet(
    WebserviceID => $WebserviceID,
    ObjectType   => $CustomObjectType,
    ObjectID     => $RandomNumber,
);

$Self->False(
    scalar %{$ObjectLockState},
    "ObjectLockStateGet() for deleted entry",
);

$Success = $ObjectLockStateObject->ObjectLockStateDelete(
    WebserviceID => $WebserviceID,
    ObjectType   => $CustomObjectType,
    ObjectID     => $RandomNumber,
);

$Self->False(
    defined $Success,
    'ObjectLockStateDelete() for deleted entry',
);

# delete config
$Success = $WebserviceObject->WebserviceDelete(
    ID     => $WebserviceID,
    UserID => 1,
);

$Self->True(
    $Success,
    "WebserviceDelete()",
);

1;
