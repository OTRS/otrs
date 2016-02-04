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

# get SystemAddress object
my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# add SystemAddress
my $SystemAddressEmail    = 'example-SystemAddress' . $Helper->GetRandomID() . '@example.com';
my $SystemAddressRealname = "OTRS-Team";

my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => 2,
    ValidID  => 1,
    UserID   => 1,
);

$Self->True(
    $SystemAddressID,
    'SystemAddressAdd()',
);

my %SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

$Self->Is(
    $SystemAddress{Name},
    $SystemAddressEmail,
    'SystemAddressGet() - Name',
);
$Self->Is(
    $SystemAddress{Realname},
    $SystemAddressRealname,
    'SystemAddressGet() - Realname',
);
$Self->Is(
    $SystemAddress{Comment},
    'some comment',
    'SystemAddressGet() - Comment',
);
$Self->Is(
    $SystemAddress{QueueID},
    2,
    'SystemAddressGet() - QueueID',
);
$Self->Is(
    $SystemAddress{ValidID},
    1,
    'SystemAddressGet() - ValidID',
);

# caching
%SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

$Self->Is(
    $SystemAddress{Name},
    $SystemAddressEmail,
    'SystemAddressGet() - Name',
);
$Self->Is(
    $SystemAddress{Realname},
    $SystemAddressRealname,
    'SystemAddressGet() - Realname',
);
$Self->Is(
    $SystemAddress{Comment},
    'some comment',
    'SystemAddressGet() - Comment',
);
$Self->Is(
    $SystemAddress{QueueID},
    2,
    'SystemAddressGet() - QueueID',
);
$Self->Is(
    $SystemAddress{ValidID},
    1,
    'SystemAddressGet() - ValidID',
);

my %SystemAddressList = $SystemAddressObject->SystemAddressList( Valid => 0 );
$Self->True(
    exists $SystemAddressList{$SystemAddressID} && $SystemAddressList{$SystemAddressID} eq $SystemAddressEmail,
    "SystemAddressList() contains the SystemAddress $SystemAddressID",
);

# caching
%SystemAddressList = $SystemAddressObject->SystemAddressList( Valid => 1 );
$Self->True(
    exists $SystemAddressList{$SystemAddressID} && $SystemAddressList{$SystemAddressID} eq $SystemAddressEmail,
    "SystemAddressList() contains the SystemAddress $SystemAddressID",
);

my @Tests = (
    {
        Address => uc($SystemAddressEmail),
        QueueID => 2,
    },
    {
        Address => lc($SystemAddressEmail),
        QueueID => 2,
    },
    {
        Address => $SystemAddressEmail,
        QueueID => 2,
    },
    {
        Address => '2' . $SystemAddressEmail,
        QueueID => undef,
    },
    {
        Address => ', ' . $SystemAddressEmail,
        QueueID => undef,
    },
    {
        Address => ')' . $SystemAddressEmail,
        QueueID => undef,
    },
);
for my $Test (@Tests) {
    my $QueueID = $SystemAddressObject->SystemAddressQueueID( Address => $Test->{Address} );
    $Self->Is(
        $QueueID,
        $Test->{QueueID},
        "SystemAddressQueueID() - $Test->{Address}",
    );

    # cached
    $QueueID = $SystemAddressObject->SystemAddressQueueID( Address => $Test->{Address} );
    $Self->Is(
        $QueueID,
        $Test->{QueueID},
        "SystemAddressQueueID() - $Test->{Address}",
    );
}

my $SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
    ID       => $SystemAddressID,
    Name     => '2' . $SystemAddressEmail,
    Realname => '2' . $SystemAddressRealname,
    Comment  => 'some comment 1',
    QueueID  => 1,
    ValidID  => 2,
    UserID   => 1,
);
$Self->True(
    $SystemAddressUpdate,
    'SystemAddressUpdate()',
);

%SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

$Self->Is(
    $SystemAddress{Name},
    '2' . $SystemAddressEmail,
    'SystemAddressGet() - Name',
);
$Self->Is(
    $SystemAddress{Realname},
    '2' . $SystemAddressRealname,
    'SystemAddressGet() - Realname',
);
$Self->Is(
    $SystemAddress{Comment},
    'some comment 1',
    'SystemAddressGet() - Comment',
);
$Self->Is(
    $SystemAddress{QueueID},
    1,
    'SystemAddressGet() - QueueID',
);
$Self->Is(
    $SystemAddress{ValidID},
    2,
    'SystemAddressGet() - ValidID',
);

# add test valid system address
my $SystemAddressID1 = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail . 'first',
    Realname => $SystemAddressRealname . 'first',
    Comment  => 'some comment',
    QueueID  => 3,
    ValidID  => 1,
    UserID   => 1,
);

# test SystemAddressQueueList() method - get all addresses
my %SystemQueues = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressQueueList( Valid => 0 );

$Self->True(
    exists $SystemQueues{'1'} && $SystemQueues{'1'} == $SystemAddressID,
    "SystemAddressQueueList() contains the queue 1 of the SystemAddress $SystemAddressID",
);
$Self->True(
    exists $SystemQueues{'3'} && $SystemQueues{'3'} == $SystemAddressID1,
    "SystemAddressQueueList() contains the queue 3 of the SystemAddress $SystemAddressID1",
);

# test SystemAddressQueueList() method -  get only valid system addresses
%SystemQueues = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressQueueList( Valid => 1 );

$Self->False(
    exists $SystemQueues{'1'} && $SystemQueues{'1'} == $SystemAddressID,
    "SystemAddressQueueList() does not contains the queue 1 of the SystemAddress $SystemAddressID",
);
$Self->True(
    exists $SystemQueues{'3'} && $SystemQueues{'3'} == $SystemAddressID1,
    "SystemAddressQueueList() contains the invalid queue 2 of the SystemAddress $SystemAddressID1",
);

# cleanup is done by RestoreDatabase

1;
