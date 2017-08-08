# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Start a communication.
my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Test',
        Direction => 'Incoming',
        Start     => 1,
    },
);

# Create some logging for 'Connection' and 'Message'
for my $ObjectType (qw( Connection Message )) {
    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectType => $ObjectType,
    );

    $CommunicationLogObject->ObjectLog(
        ObjectType => $ObjectType,
        ObjectID   => $ObjectID,
        Key        => 'Time',
        Value      => time(),
    );

    $CommunicationLogObject->ObjectLogStop(
        ObjectType => $ObjectType,
        ObjectID   => $ObjectID,
        Status     => $ObjectType eq 'Connection' ? 'Successful' : 'Failed',
    );
}

# Stop the communication.
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

my $Result;

# Get the Objects list.
$Result = $CommunicationLogObject->ObjectList();
$Self->True(
    $Result && scalar @{$Result} == 2,
    'Communication objects list.'
);

# Filter by Status
$Result = $CommunicationLogObject->ObjectList( Status => 'Failed' );
$Self->True(
    $Result && scalar @{$Result} == 1,
    'Communication objects list by status "Failed".'
);

# Filter by ObjectType
$Result = $CommunicationLogObject->ObjectList( ObjectType => 'Message' );
$Self->True(
    $Result && scalar @{$Result} == 1,
    'Communication objects list by object-type "Message".'
);

# Filter by ObjectType and Status
$Result = $CommunicationLogObject->ObjectList(
    ObjectType => 'Message',
    Status     => 'Successful'
);
$Self->True(
    $Result && scalar @{$Result} == 0,
    'Communication objects list by object-type "Message" and Status "Successful".'
);

# Filter by StartTime
my $CurSysDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$CurSysDateTimeObject->Subtract(
    Days => 1,
);
$Result = $CommunicationLogObject->ObjectList( StartTime => $CurSysDateTimeObject->ToString() );
$Self->True(
    $Result && scalar @{$Result} == 0,
    sprintf( 'Communication objects list by start-time "%s".', $CurSysDateTimeObject->ToString(), ),
);

# restore to the previous state is done by RestoreDatabase

1;
