# --
# PID.t - PID tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::PID;
use Kernel::System::UnitTest::Helper;

# creates a local helper object
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject => $Self,
);

# set fixed time
$HelperObject->FixedTimeSet();

my $PIDObject = Kernel::System::PID->new( %{$Self} );

my $PIDCreate = $PIDObject->PIDCreate( Name => 'Test' );
$Self->True(
    $PIDCreate,
    'PIDCreate()',
);

my $PIDCreate2 = $PIDObject->PIDCreate( Name => 'Test' );
$Self->False(
    $PIDCreate2,
    'PIDCreate2()',
);

my %PIDGet = $PIDObject->PIDGet( Name => 'Test' );
$Self->True(
    $PIDGet{PID},
    'PIDGet()',
);

my $PIDCreateForce = $PIDObject->PIDCreate(
    Name  => 'Test',
    Force => 1,
);
$Self->True(
    $PIDCreateForce,
    'PIDCreate() - Force',
);

my $UpdateSuccess = $PIDObject->PIDUpdate();

$Self->False(
    $UpdateSuccess,
    'PIDUpdate() with no name',
);

$UpdateSuccess = $PIDObject->PIDUpdate(
    Name => 'NonExistentProcess' . time(),
);

$Self->False(
    $UpdateSuccess,
    'PIDUpdate() with wrong name',
);

# wait 2 seconds to update the PID change time
$HelperObject->FixedTimeAddSeconds(2);

$UpdateSuccess = $PIDObject->PIDUpdate(
    Name => 'Test',
);

$Self->True(
    $UpdateSuccess,
    'PIDUpdate()',
);

my %UpdatedPIDGet = $PIDObject->PIDGet( Name => 'Test' );
$Self->True(
    $UpdatedPIDGet{PID},
    'PIDGet() updated',
);

$Self->IsNotDeeply(
    \%PIDGet,
    \%UpdatedPIDGet,
    'PIDGet() updated is different than the original one',
);

my $PIDDelete = $PIDObject->PIDDelete( Name => 'Test' );
$Self->True(
    $PIDDelete,
    'PIDDelete()',
);

1;
