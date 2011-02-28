# --
# ObjectLockStatePerformance.t - ObjectLockState performance tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: ObjectLockStatePerformance.t,v 1.1 2011-02-28 14:46:41 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Time::HiRes ();

use Kernel::System::GenericInterface::Webservice;
use Kernel::System::GenericInterface::ObjectLockState;

=head1 ObjectLockState performance tests

This test script will create 10000 records in the object lock table,
and then perform SELECT and UDPATE queries on it to make sure that
they take not more than 0.5s each.

=cut

my $WebserviceObject      = Kernel::System::GenericInterface::Webservice->new( %{$Self} );
my $ObjectLockStateObject = Kernel::System::GenericInterface::ObjectLockState->new( %{$Self} );

my $RandomNumber     = int rand(10000000);
my $CustomObjectType = "TestObject$RandomNumber";
my $Success;
my $TestDataCount = 10_000;

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

for my $Count ( 1 .. $TestDataCount ) {

    # set initial
    $Success = $ObjectLockStateObject->ObjectLockStateSet(
        WebserviceID     => $WebserviceID,
        ObjectType       => $CustomObjectType,
        ObjectID         => $Count,
        LockState        => 'locked',
        LockStateCounter => 0,
    );

    $Self->True(
        $Success,
        "ObjectLockStateSet() for entry $Count",
    );
}

for my $Count ( 1 .. 100 ) {
    my $TimeStart = [ Time::HiRes::gettimeofday() ];

    # try to access a random object's lock state
    my $LookFor = int( rand($TestDataCount) + 1 );

    # set initial
    my $ObjectLockState = $ObjectLockStateObject->ObjectLockStateGet(
        WebserviceID => $WebserviceID,
        ObjectType   => $CustomObjectType,
        ObjectID     => $LookFor,
    );

    my $TimeElapsed = Time::HiRes::tv_interval($TimeStart);

    $Self->True(
        $TimeElapsed < 0.5,
        "ObjectLockStateGet() in $TestDataCount entries took less than 0.5s (${TimeElapsed}s)",
    );

    $Self->Is(
        $ObjectLockState->{LockState},
        'locked',
        "ObjectLockStateGet() in $TestDataCount entries result",
    );

    $TimeStart = [ Time::HiRes::gettimeofday() ];

    # update
    $Success = $ObjectLockStateObject->ObjectLockStateSet(
        WebserviceID     => $WebserviceID,
        ObjectType       => $CustomObjectType,
        ObjectID         => $LookFor,
        LockState        => 'locked2',
        LockStateCounter => 0,
    );

    $TimeElapsed = Time::HiRes::tv_interval($TimeStart);

    $Self->True(
        $TimeElapsed < 0.5,
        "ObjectLockStateSet in $TestDataCount entries took less than 0.5s (${TimeElapsed}s)",
    );

    $ObjectLockState = $ObjectLockStateObject->ObjectLockStateGet(
        WebserviceID => $WebserviceID,
        ObjectType   => $CustomObjectType,
        ObjectID     => $LookFor,
    );

    $Self->Is(
        $ObjectLockState->{LockState},
        'locked2',
        "ObjectLockStateSet() in $TestDataCount entries result",
    );

    # restore old value update
    $Success = $ObjectLockStateObject->ObjectLockStateSet(
        WebserviceID     => $WebserviceID,
        ObjectType       => $CustomObjectType,
        ObjectID         => $LookFor,
        LockState        => 'locked',
        LockStateCounter => 0,
    );
}

# purge
$Success = $ObjectLockStateObject->ObjectLockStatePurge(
    WebserviceID => $WebserviceID,
);

$Self->True(
    $Success,
    'ObjectLockStatePurge() for existing entry',
);

# check
my $ObjectLockState = $ObjectLockStateObject->ObjectLockStateGet(
    WebserviceID => $WebserviceID,
    ObjectType   => $CustomObjectType,
    ObjectID     => $RandomNumber,
);

$Self->False(
    scalar %{$ObjectLockState},
    "ObjectLockStateGet() for deleted entry",
);

# check list
my $ObjectLockStates = $ObjectLockStateObject->ObjectLockStateList(
    WebserviceID => $WebserviceID,
    ObjectType   => $CustomObjectType,
    ObjectID     => $RandomNumber,
);

$Self->Is(
    scalar @{$ObjectLockStates},
    0,
    "ObjectLockStateList() for ObjectType",
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
