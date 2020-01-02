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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper              = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');

my $QueueRand1 = $Helper->GetRandomID();
my $QueueRand2 = $Helper->GetRandomID();

my $QueueID1 = $QueueObject->QueueAdd(
    Name                => $QueueRand1,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => 'Some Comment',
);

my $QueueID2 = $QueueObject->QueueAdd(
    Name                => $QueueRand2,
    ValidID             => 1,
    GroupID             => 1,
    FirstResponseTime   => 30,
    FirstResponseNotify => 70,
    UpdateTime          => 240,
    UpdateNotify        => 80,
    SolutionTime        => 2440,
    SolutionNotify      => 90,
    SystemAddressID     => 1,
    SalutationID        => 1,
    SignatureID         => 1,
    UserID              => 1,
    Comment             => 'Some Comment',
);

# add SystemAddress
my $SystemAddressEmail    = $Helper->GetRandomID() . '@example.com';
my $SystemAddressRealname = "OTRS-Team";

my %SystemAddressData = (
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => $QueueID1,
    ValidID  => 1,
);

my $SystemAddressID = $SystemAddressObject->SystemAddressAdd(
    %SystemAddressData,
    UserID => 1,
);

$Self->True(
    $SystemAddressID,
    'SystemAddressAdd()',
);

my $SystemAddressIDWrong = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname,
    Comment  => 'some comment',
    QueueID  => 2,
    ValidID  => 1,
    UserID   => 1,
);

$Self->False(
    $SystemAddressIDWrong,
    'SystemAddressAdd() - Try to add new system address with existing system address name',
);

# add SystemAddress
my $SystemAddressEmail2    = $Helper->GetRandomID() . '@example.com';
my $SystemAddressRealname2 = "OTRS-Team2";
my $SystemAddressID2       = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail2,
    Realname => $SystemAddressRealname2,
    Comment  => 'some comment',
    QueueID  => 2,
    ValidID  => 1,
    UserID   => 1,
);

$Self->True(
    $SystemAddressID2,
    'SystemAddressAdd()',
);

# try to update SystemAddress with existing name
my $SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
    ID       => $SystemAddressID2,
    Name     => $SystemAddressEmail,
    Realname => $SystemAddressRealname2,
    Comment  => 'some comment',
    QueueID  => 1,
    ValidID  => 2,
    UserID   => 1,
);
$Self->False(
    $SystemAddressUpdate,
    'SystemAddressUpdate() - Try to update new system address with existing system address name',
);

my %SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

for my $Key ( sort keys %SystemAddressData ) {
    $Self->Is(
        $SystemAddress{$Key},
        $SystemAddressData{$Key},
        'SystemAddressGet() - $Key',
    );
}

# caching
%SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

for my $Key ( sort keys %SystemAddressData ) {
    $Self->Is(
        $SystemAddress{$Key},
        $SystemAddressData{$Key},
        'SystemAddressGet() - $Key',
    );
}

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
        QueueID => $QueueID1,
    },
    {
        Address => lc($SystemAddressEmail),
        QueueID => $QueueID1,
    },
    {
        Address => $SystemAddressEmail,
        QueueID => $QueueID1,
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

my %SystemAddressDataUpdate = (
    Name     => '2' . $SystemAddressEmail,
    Realname => '2' . $SystemAddressRealname,
    Comment  => 'some comment 1',
    QueueID  => $QueueID2,
    ValidID  => 2,
);

$SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
    %SystemAddressDataUpdate,
    ID     => $SystemAddressID,
    UserID => 1,
);
$Self->True(
    $SystemAddressUpdate,
    'SystemAddressUpdate()',
);

%SystemAddress = $SystemAddressObject->SystemAddressGet( ID => $SystemAddressID );

for my $Key ( sort keys %SystemAddressDataUpdate ) {
    $Self->Is(
        $SystemAddress{$Key},
        $SystemAddressDataUpdate{$Key},
        'SystemAddressGet() - $Key',
    );
}

# add test valid system address
my $SystemAddressID1 = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressEmail . 'first',
    Realname => $SystemAddressRealname . 'first',
    Comment  => 'some comment',
    QueueID  => $QueueID1,
    ValidID  => 1,
    UserID   => 1,
);

# test SystemAddressQueueList() method - get all addresses
my %SystemQueues = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressQueueList( Valid => 0 );

$Self->True(
    exists $SystemQueues{$QueueID2} && $SystemQueues{$QueueID2} == $SystemAddressID,
    "SystemAddressQueueList() contains the QueueID2",
);
$Self->True(
    exists $SystemQueues{$QueueID1} && $SystemQueues{$QueueID1} == $SystemAddressID1,
    "SystemAddressQueueList() contains the QueueID1",
);

# test SystemAddressQueueList() method -  get only valid system addresses
%SystemQueues = $Kernel::OM->Get('Kernel::System::SystemAddress')->SystemAddressQueueList( Valid => 1 );

$Self->False(
    exists $SystemQueues{$QueueID2},
    "SystemAddressQueueList() does not contain the invalid QueueID2",
);
$Self->True(
    exists $SystemQueues{$QueueID1} && $SystemQueues{$QueueID1} == $SystemAddressID1,
    "SystemAddressQueueList() contains the valid QueueID1",
);

# Test SystemAddressIsUsed() function.
my $SystemAddressIsUsed = $SystemAddressObject->SystemAddressIsUsed(
    SystemAddressID => 1,
);
$Self->True(
    $SystemAddressIsUsed,
    "SystemAddressIsUsed() - Correctly detected system address in use"
);

$SystemAddressIsUsed = $SystemAddressObject->SystemAddressIsUsed(
    SystemAddressID => $SystemAddressID2,
);
$Self->False(
    $SystemAddressIsUsed,
    "SystemAddressIsUsed() - Correctly detected system address not in use"
);

my $AutoResponse = $Kernel::OM->Get('Kernel::System::AutoResponse')->AutoResponseAdd(
    Name        => 'Some::AutoResponse',
    ValidID     => 1,
    Subject     => 'Some Subject..',
    Response    => 'Auto Response Test....',
    ContentType => 'text/plain',
    AddressID   => $SystemAddressID2,
    TypeID      => 1,
    UserID      => 1,
);

$Self->True(
    $AutoResponse,
    "AutoResponseAdd() - $AutoResponse"
);

$SystemAddressIsUsed = $SystemAddressObject->SystemAddressIsUsed(
    SystemAddressID => $SystemAddressID2,
);
$Self->True(
    $SystemAddressIsUsed,
    "SystemAddressIsUsed() - Correctly detected system address in use after adding auto response"
);

$SystemAddressUpdate = $SystemAddressObject->SystemAddressUpdate(
    Name     => '3' . $SystemAddressEmail,
    Realname => '3' . $SystemAddressRealname,
    Comment  => 'some comment 1',
    QueueID  => $QueueID2,
    ValidID  => 2,
    ID       => $SystemAddressID2,
    UserID   => 1,
);
$Self->False(
    $SystemAddressUpdate,
    "SystemAddressUpdate() -
        This system address $SystemAddressID2 cannot be set to invalid,
        because it is used in one or more queue(s) or auto response(s)",
);

# Cleanup is done by RestoreDatabase.

1;
