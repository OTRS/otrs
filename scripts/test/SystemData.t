# --
# SystemData.t - SystemData tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::SystemData;

my $SystemDataObject = Kernel::System::SystemData->new( %{$Self} );

# add system data
my $SystemDataNameRand0 = 'systemdata' . int( rand(1000000) );

my $Success = $SystemDataObject->SystemDataAdd(
    Key     => $SystemDataNameRand0,
    Value   => $SystemDataNameRand0,
    UserID  => 1,
);

$Self->True(
    $Success,
    "SystemDataAdd() - added '$SystemDataNameRand0'",
);

# another time, it should fail
$Success = $SystemDataObject->SystemDataAdd(
    Key     => $SystemDataNameRand0,
    Value   => $SystemDataNameRand0,
    UserID  => 1,
);

$Self->False(
    $Success,
    "SystemDataAdd() - can not add duplicate key '$SystemDataNameRand0'",
);

# another time, upper case key, should fail
my $UpperCaseKey = uc $SystemDataNameRand0;

# another time, it should fail
$Success = $SystemDataObject->SystemDataAdd(
    Key     => $UpperCaseKey,
    Value   => $SystemDataNameRand0,
    UserID  => 1,
);

$Self->False(
    $Success,
    "SystemDataAdd() - can not add same key as upper case '$UpperCaseKey'",
);

my $SystemData = $SystemDataObject->SystemDataGet( Key => $SystemDataNameRand0 );

$Self->True(
    $SystemData eq $SystemDataNameRand0,
    'SystemDataGet() - value',
);

my $SystemDataUpdate = $SystemDataObject->SystemDataUpdate(
    Key      => $SystemDataNameRand0,
    Value   => 'update' . $SystemDataNameRand0,
    UserID  => 1,
);

$Self->True(
    $SystemDataUpdate,
    'SystemDataUpdate()',
);

$SystemData = $SystemDataObject->SystemDataGet( Key => $SystemDataNameRand0 );

$Self->Is(
    $SystemData,
    'update'. $SystemDataNameRand0,
    'SystemDataGet() - after update',
);

$SystemDataUpdate = $SystemDataObject->SystemDataUpdate(
    Key      => $UpperCaseKey,
    Value   => 'uc' . $SystemDataNameRand0,
    UserID  => 1,
);

$Self->True(
    $SystemDataUpdate,
    'SystemDataUpdate() uppercase key',
);

$SystemData = $SystemDataObject->SystemDataGet( Key => $SystemDataNameRand0 );

$Self->Is(
    $SystemData,
    'uc'. $SystemDataNameRand0,
    'SystemDataGet() - after update',
);

$SystemDataUpdate = $SystemDataObject->SystemDataUpdate(
    Key     => 'NonExisting' . $UpperCaseKey,   
    Value   => 'some value',
    UserID  => 1,
);

$Self->False(
    $SystemDataUpdate,
    'SystemDataUpdate() should not work on nonexisting value',
);

my $SystemDataDelete = $SystemDataObject->SystemDataDelete(
    Key      => $SystemDataNameRand0,
    UserID  => 1,
);

$Self->True(
    $SystemDataDelete,
    'SystemDataDelete() - removed key',
);


$SystemData = $SystemDataObject->SystemDataGet( Key => $SystemDataNameRand0 );

$Self->False(
    $SystemData,
    'SystemDataGet() - data is gone after delete',
);

1;
