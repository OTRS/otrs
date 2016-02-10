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

# get needed objects
my $AutoResponseObject  = $Kernel::OM->Get('Kernel::System::AutoResponse');
my $SystemAddressObject = $Kernel::OM->Get('Kernel::System::SystemAddress');
my $QueueObject         = $Kernel::OM->Get('Kernel::System::Queue');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get random id
my $RandomID = $HelperObject->GetRandomID();

# set queue name
my $QueueName = 'Some::Queue' . $RandomID;

# create new queue
my $QueueID   = $QueueObject->QueueAdd(

    Name            => $QueueName,
    ValidID         => 1,
    GroupID         => 1,
    SystemAddressID => 1,
    SalutationID    => 1,
    SignatureID     => 1,
    Comment         => 'Some comment',
    UserID          => 1,
);

$Self->True(
    $QueueID,
    "QueueAdd() - $QueueName, $QueueID",
);

# add system address
my $SystemAddressNameRand = 'SystemAddress' . $HelperObject->GetRandomID();
my $SystemAddressID       = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressNameRand . '@example.com',
    Realname => $SystemAddressNameRand,
    ValidID  => 1,
    QueueID  => $QueueID,
    Comment  => 'Some Comment',
    UserID   => 1,
);
$Self->True(
    $SystemAddressID,
    'SystemAddressAdd()',
);

# add auto response
my $AutoResponseNameRand = 'AutoResponse' . $HelperObject->GetRandomID();

my $AutoResponseID = $AutoResponseObject->AutoResponseAdd(
    Name        => $AutoResponseNameRand,
    Subject     => 'Some Subject',
    Response    => 'Some Response',
    Comment     => 'Some Comment',
    AddressID   => $SystemAddressID,
    TypeID      => 1,
    ContentType => 'text/plain',
    ValidID     => 1,
    UserID      => 1,
);

$Self->True(
    $AutoResponseID,
    'AutoResponseAdd()',
);

my %AutoResponse = $AutoResponseObject->AutoResponseGet( ID => $AutoResponseID );

$Self->Is(
    $AutoResponse{Name} || '',
    $AutoResponseNameRand,
    'AutoResponseGet() - Name',
);
$Self->Is(
    $AutoResponse{Subject} || '',
    'Some Subject',
    'AutoResponseGet() - Subject',
);
$Self->Is(
    $AutoResponse{Response} || '',
    'Some Response',
    'AutoResponseGet() - Response',
);
$Self->Is(
    $AutoResponse{Comment} || '',
    'Some Comment',
    'AutoResponseGet() - Comment',
);
$Self->Is(
    $AutoResponse{ContentType} || '',
    'text/plain',
    'AutoResponseGet() - ContentType',
);
$Self->Is(
    $AutoResponse{AddressID} || '',
    $SystemAddressID,
    'AutoResponseGet() - AddressID',
);
$Self->Is(
    $AutoResponse{ValidID} || '',
    1,
    'AutoResponseGet() - ValidID',
);

my %AutoResponseList = $AutoResponseObject->AutoResponseList( Valid => 0 );
my $Hit = 0;
for ( sort keys %AutoResponseList ) {
    if ( $_ eq $AutoResponseID ) {
        $Hit = 1;
    }
}
$Self->True(
    $Hit eq 1,
    'AutoResponseList()',
);

# get a list of the queues that do not have auto response
my %AutoResponseWithoutQueue = $AutoResponseObject->AutoResponseWithoutQueue();

$Self->True(
    exists $AutoResponseWithoutQueue{$QueueID} && $AutoResponseWithoutQueue{$QueueID} eq $QueueName,
    'AutoResponseWithoutQueue() contains queue ' . $QueueName . ' with ID ' . $QueueID,
);

my $AutoResponseQueue = $AutoResponseObject->AutoResponseQueue(
    QueueID         => $QueueID,
    AutoResponseIDs => [$AutoResponseID],
    UserID          => 1,
);
$Self->True(
    $AutoResponseQueue,
    'AutoResponseQueue()',
);

# check again after assigning auto response to queue
%AutoResponseWithoutQueue = $AutoResponseObject->AutoResponseWithoutQueue();
$Self->False(
    exists $AutoResponseWithoutQueue{$QueueID} && $AutoResponseWithoutQueue{$QueueID} eq $QueueName,
    'AutoResponseWithoutQueue() does not contain queue ' . $QueueName . ' with ID ' . $QueueID,
);

my %Address = $AutoResponseObject->AutoResponseGetByTypeQueueID(
    QueueID => $QueueID,
    Type    => 'auto reply',
);
$Self->Is(
    $Address{Address} || '',
    $SystemAddressNameRand . '@example.com',
    'AutoResponseGetByTypeQueueID() - Address',
);
$Self->Is(
    $Address{Realname} || '',
    $SystemAddressNameRand,
    'AutoResponseGetByTypeQueueID() - Realname',
);

$AutoResponseQueue = $AutoResponseObject->AutoResponseQueue(
    QueueID         => $QueueID,
    AutoResponseIDs => [],
    UserID          => 1,
);

my $AutoResponseUpdate = $AutoResponseObject->AutoResponseUpdate(
    ID          => $AutoResponseID,
    Name        => $AutoResponseNameRand . '1',
    Subject     => 'Some Subject1',
    Response    => 'Some Response1',
    Comment     => 'Some Comment1',
    AddressID   => $SystemAddressID,
    TypeID      => 1,
    ContentType => 'text/html',
    ValidID     => 2,
    UserID      => 1,
);

$Self->True(
    $AutoResponseUpdate,
    'AutoResponseUpdate()',
);

%AutoResponse = $AutoResponseObject->AutoResponseGet( ID => $AutoResponseID );

$Self->Is(
    $AutoResponse{Name} || '',
    $AutoResponseNameRand . '1',
    'AutoResponseGet() - Name',
);
$Self->Is(
    $AutoResponse{Subject} || '',
    'Some Subject1',
    'AutoResponseGet() - Subject',
);
$Self->Is(
    $AutoResponse{Response} || '',
    'Some Response1',
    'AutoResponseGet() - Response',
);
$Self->Is(
    $AutoResponse{Comment} || '',
    'Some Comment1',
    'AutoResponseGet() - Comment',
);
$Self->Is(
    $AutoResponse{ContentType} || '',
    'text/html',
    'AutoResponseGet() - ContentType',
);
$Self->Is(
    $AutoResponse{AddressID} || '',
    $SystemAddressID,
    'AutoResponseGet() - AddressID',
);
$Self->Is(
    $AutoResponse{ValidID} || '',
    2,
    'AutoResponseGet() - ValidID',
);

# cleanup is done by RestoreDatabase

1;
