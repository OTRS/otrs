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
    Key    => $SystemDataNameRand0,
    Value  => $SystemDataNameRand0,
    UserID => 1,
);

$Self->True(
    $Success,
    "SystemDataAdd() - added '$SystemDataNameRand0'",
);

# another time, it should fail
$Success = $SystemDataObject->SystemDataAdd(
    Key    => $SystemDataNameRand0,
    Value  => $SystemDataNameRand0,
    UserID => 1,
);

$Self->False(
    $Success,
    "SystemDataAdd() - can not add duplicate key '$SystemDataNameRand0'",
);

my $SystemData = $SystemDataObject->SystemDataGet( Key => $SystemDataNameRand0 );

$Self->True(
    $SystemData eq $SystemDataNameRand0,
    'SystemDataGet() - value',
);

my $SystemDataUpdate = $SystemDataObject->SystemDataUpdate(
    Key    => $SystemDataNameRand0,
    Value  => 'update' . $SystemDataNameRand0,
    UserID => 1,
);

$Self->True(
    $SystemDataUpdate,
    'SystemDataUpdate()',
);

$SystemData = $SystemDataObject->SystemDataGet( Key => $SystemDataNameRand0 );

$Self->Is(
    $SystemData,
    'update' . $SystemDataNameRand0,
    'SystemDataGet() - after update',
);

$SystemDataUpdate = $SystemDataObject->SystemDataUpdate(
    Key    => 'NonExisting' . $Self->{MainObject}->GenerateRandomString(),
    Value  => 'some value',
    UserID => 1,
);

$Self->False(
    $SystemDataUpdate,
    'SystemDataUpdate() should not work on nonexisting value',
);

my $SystemDataDelete = $SystemDataObject->SystemDataDelete(
    Key    => $SystemDataNameRand0,
    UserID => 1,
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

# test setting value to empty string
# add system data 1
my $SystemDataNameRand1 = 'systemdata' . int( rand(1000000) );

$Success = $SystemDataObject->SystemDataAdd(
    Key    => $SystemDataNameRand1,
    Value  => '',
    UserID => 1,
);

$Self->True(
    $Success,
    "SystemDataAdd() - added '$SystemDataNameRand1' value empty string",
);

$SystemData = $SystemDataObject->SystemDataGet( Key => $SystemDataNameRand1 );

$Self->Is(
    $SystemData,
    '',
    'SystemDataGet() - value - empty string',
);

$SystemDataUpdate = $SystemDataObject->SystemDataUpdate(
    Key    => $SystemDataNameRand1,
    Value  => 'update',
    UserID => 1,
);

$Self->True(
    $SystemDataUpdate,
    'SystemDataUpdate()',
);

$SystemData = $SystemDataObject->SystemDataGet( Key => $SystemDataNameRand1 );

$Self->Is(
    $SystemData,
    'update',
    'SystemDataGet() - after update',
);

$SystemDataUpdate = $SystemDataObject->SystemDataUpdate(
    Key    => $SystemDataNameRand1,
    Value  => '',
    UserID => 1,
);

$Self->True(
    $SystemDataUpdate,
    'SystemDataUpdate()',
);

$SystemData = $SystemDataObject->SystemDataGet( Key => $SystemDataNameRand1 );

$Self->Is(
    $SystemData,
    '',
    'SystemDataGet() - after update empty string',
);

$SystemDataDelete = $SystemDataObject->SystemDataDelete(
    Key    => $SystemDataNameRand1,
    UserID => 1,
);

$Self->True(
    $SystemDataDelete,
    'SystemDataDelete() - removed key',
);

my $SystemDataGroupRand = 'systemdata' . int( rand(1000000) );

my %Storage = (
    Foo  => 'bar',
    Bar  => 'baz',
    Beef => 'spam',
);

for my $Key ( sort keys %Storage ) {
    my $Result = $SystemDataObject->SystemDataAdd(
        Key    => $SystemDataGroupRand . '::' . $Key,
        Value  => $Storage{$Key},
        UserID => 1,
    );
    $Self->True(
        $Result,
        "SystemDataAdd: added key " . $SystemDataGroupRand . '::' . $Key,
    );
}

my %Group = $SystemDataObject->SystemDataGroupGet(
    Group  => $SystemDataGroupRand,
    UserID => 1,
);

for my $Key ( sort keys %Storage ) {
    $Self->Is(
        $Group{$Key},
        $Storage{$Key},
        "SystemDataGroupGet: test value for '$Key'.",
    );
}

$Storage{Bar} = 'drinks';
$SystemDataObject->SystemDataUpdate(
    Key    => $SystemDataGroupRand . '::Bar',
    Value  => $Storage{Bar},
    UserID => 1,
);

%Group = $SystemDataObject->SystemDataGroupGet(
    Group  => $SystemDataGroupRand,
    UserID => 1,
);

for my $Key ( sort keys %Storage ) {
    $Self->Is(
        $Group{$Key},
        $Storage{$Key},
        "SystemDataGroupGet: test value for '$Key'.",
    );
}

$SystemDataObject->SystemDataDelete(
    Key    => $SystemDataGroupRand . '::Beef',
    UserID => 1,
);

%Group = $SystemDataObject->SystemDataGroupGet(
    Group  => $SystemDataGroupRand,
    UserID => 1,
);

$Self->False(
    $Group{Beef},
    "Key 'Beef' deleted, GroupGet",
);

$Self->Is(
    $Group{Foo},
    'bar',
    "Key 'Foo' still there, GroupGet",
);

for my $Key ( sort keys %Group ) {
    my $Result = $SystemDataObject->SystemDataDelete(
        Key    => $SystemDataGroupRand . '::' . $Key,
        UserID => 1,
    );
    $Self->True(
        $Result,
        "SystemData: deleted key " . $SystemDataGroupRand . '::' . $Key,
    );
}

1;
