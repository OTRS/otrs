# --
# AutoResponse.t - AutoResponse tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));

use Kernel::System::AutoResponse;
use Kernel::System::SystemAddress;

# create local objects
my $AutoResponseObject  = Kernel::System::AutoResponse->new( %{$Self} );
my $SystemAddressObject = Kernel::System::SystemAddress->new( %{$Self} );

# add system address
my $SystemAddressNameRand0 = 'unittest' . int rand 1000000;
my $SystemAddressID        = $SystemAddressObject->SystemAddressAdd(
    Name     => $SystemAddressNameRand0 . '@example.com',
    Realname => $SystemAddressNameRand0,
    ValidID  => 1,
    QueueID  => 1,
    Comment  => 'Some Comment',
    UserID   => 1,
);
$Self->True(
    $SystemAddressID,
    'SystemAddressAdd()',
);

# add auto response
my $AutoResponseNameRand0 = 'unittest' . int rand 1000000;

my $AutoResponseID = $AutoResponseObject->AutoResponseAdd(
    Name        => $AutoResponseNameRand0,
    Subject     => 'Some Subject',
    Response    => 'Some Response',
    Comment     => 'Some Comment',
    AddressID   => $SystemAddressID,
    TypeID      => 1,
    Charset     => 'iso-8859-1',
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
    $AutoResponseNameRand0,
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

# check return charset based on system wide utf8 or not
if ( $Self->{EncodeObject}->EncodeInternalUsed() ) {
    $Self->Is(
        $AutoResponse{Charset} || '',
        'utf-8',
        'AutoResponseGet() - Charset',
    );
}
else {
    $Self->Is(
        $AutoResponse{Charset} || '',
        'iso-8859-1',
        'AutoResponseGet() - Charset',
    );
}
$Self->Is(
    $AutoResponse{ContentType} || '',
    'text/plain',
    'AutoResponseGet() - Charset',
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

my $AutoResponseUpdate = $AutoResponseObject->AutoResponseUpdate(
    ID          => $AutoResponseID,
    Name        => $AutoResponseNameRand0 . '1',
    Subject     => 'Some Subject1',
    Response    => 'Some Response1',
    Comment     => 'Some Comment1',
    AddressID   => $SystemAddressID,
    TypeID      => 1,
    Charset     => 'utf8',
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
    $AutoResponseNameRand0 . '1',
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

# check return charset based on system wide utf8 or not
if ( $Self->{EncodeObject}->EncodeInternalUsed() ) {
    $Self->Is(
        $AutoResponse{Charset} || '',
        'utf-8',
        'AutoResponseGet() - Charset',
    );
}
else {
    $Self->Is(
        $AutoResponse{Charset} || '',
        'utf8',
        'AutoResponseGet() - Charset',
    );
}
$Self->Is(
    $AutoResponse{ContentType} || '',
    'text/html',
    'AutoResponseGet() - Charset',
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

my $AutoResponseQueue = $AutoResponseObject->AutoResponseQueue(
    QueueID         => 1,
    AutoResponseIDs => [$AutoResponseID],
    UserID          => 1,
);
$Self->True(
    $AutoResponseQueue,
    'AutoResponseQueue()',
);

my %Address = $AutoResponseObject->AutoResponseGetByTypeQueueID(
    QueueID => 1,
    Type    => 'auto reply',
);
$Self->Is(
    $Address{Address} || '',
    $SystemAddressNameRand0 . '@example.com',
    'AutoResponseGetByTypeQueueID() - Address',
);
$Self->Is(
    $Address{Realname} || '',
    $SystemAddressNameRand0,
    'AutoResponseGetByTypeQueueID() - Realname',
);

$AutoResponseQueue = $AutoResponseObject->AutoResponseQueue(
    QueueID         => 1,
    AutoResponseIDs => [],
    UserID          => 1,
);

1;
