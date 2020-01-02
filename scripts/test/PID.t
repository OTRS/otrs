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

# get PID object
my $PIDObject = $Kernel::OM->Get('Kernel::System::PID');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# set fixed time
$Helper->FixedTimeSet();

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
    Name => 'NonExistentProcess' . $Helper->GetRandomID(),
);

$Self->False(
    $UpdateSuccess,
    'PIDUpdate() with wrong name',
);

# wait 2 seconds to update the PID change time
$Helper->FixedTimeAddSeconds(2);

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

# test Force delete
# 1 create a new PID
my $PIDCreate3 = $PIDObject->PIDCreate( Name => 'Test' );
$Self->True(
    $PIDCreate3,
    'PIDCreate3() for Force delete',
);

# 2 manually modify the PID host
my $RandomID = $Helper->GetRandomID();
$UpdateSuccess = $Kernel::OM->Get('Kernel::System::DB')->Do(
    SQL => '
        UPDATE process_id
        SET process_host = ?
        WHERE process_name = ?',
    Bind => [ \$RandomID, \'Test' ],
);
$Self->True(
    $UpdateSuccess,
    'Updated Host for Force delete',
);
%UpdatedPIDGet = $PIDObject->PIDGet( Name => 'Test' );
$Self->Is(
    $UpdatedPIDGet{Host},
    $RandomID,
    'PIDGet() for Force delete (Host)',
);

# 3 delete without force should keep the process
my $CurrentPID = $UpdatedPIDGet{PID};
$PIDDelete = $PIDObject->PIDDelete( Name => 'Test' );
$Self->True(
    $PIDDelete,
    'PIDDelete() Force delete (without Force)',
);
%UpdatedPIDGet = $PIDObject->PIDGet( Name => 'Test' );
$Self->Is(
    $UpdatedPIDGet{PID},
    $CurrentPID,
    'PIDGet() for Force delete (PID should still alive)',
);

# 4 force delete should delete the process even from a different host
$PIDDelete = $PIDObject->PIDDelete(
    Name  => 'Test',
    Force => 1,
);
$Self->True(
    $PIDDelete,
    'PIDDelete() Force delete (with Force)',
);
%UpdatedPIDGet = $PIDObject->PIDGet( Name => 'Test' );
$Self->False(
    $UpdatedPIDGet{PID},
    'PIDGet() for forced delete (PID should be deleted now)',
);

# cleanup is done by RestoreDatabase

1;
