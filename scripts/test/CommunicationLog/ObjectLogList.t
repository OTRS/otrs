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

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $HelperObject          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

my $Success = $CommunicationDBObject->CommunicationDelete();

$Self->True(
    $Success,
    'Communication log cleanup.',
);

# Start a communication.
my $CommunicationLogObject = $Kernel::OM->Create(
    'Kernel::System::CommunicationLog',
    ObjectParams => {
        Transport => 'Test',
        Direction => 'Incoming',
    },
);

# Remember the start result count to prevent wrong list count values.
my $StartResult      = $CommunicationDBObject->ObjectLogList();
my $StartResultCount = scalar @{$StartResult};

# Create some logging for 'Connection' and 'Message'
for my $ObjectLogType (qw( Connection Message )) {
    my $ObjectLogID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => $ObjectLogType,
    );

    $CommunicationLogObject->ObjectLog(
        ObjectLogType => $ObjectLogType,
        ObjectLogID   => $ObjectLogID,
        Key           => 'Time',
        Value         => time(),
    );

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => $ObjectLogType,
        ObjectLogID   => $ObjectLogID,
        Status        => $ObjectLogType eq 'Connection' ? 'Successful' : 'Failed',
    );
}

# Stop the communication.
$CommunicationLogObject->CommunicationStop(
    Status => 'Successful',
);

my $Result;

# Get the Objects list.
$Result = $CommunicationDBObject->ObjectLogList();
$Self->True(
    $Result && scalar @{$Result} == ( $StartResultCount + 2 ),
    'Communication objects list.'
);

# Filter by Status
$Result = $CommunicationDBObject->ObjectLogList( ObjectLogStatus => 'Failed' );

$Self->True(
    $Result && scalar @{$Result} == ( $StartResultCount + 1 ),
    'Communication objects list by status "Failed".'
);

# Filter by ObjectLogType
$Result = $CommunicationDBObject->ObjectLogList( ObjectLogType => 'Message' );
$Self->True(
    $Result && scalar @{$Result} == ( $StartResultCount + 1 ),
    'Communication objects list by object-type "Message".'
);

# Filter by ObjectLogType and Status
$Result = $CommunicationDBObject->ObjectLogList(
    ObjectLogType   => 'Message',
    ObjectLogStatus => 'Successful'
);
$Self->True(
    $Result && scalar @{$Result} == $StartResultCount,
    'Communication objects list by object-type "Message" and Status "Successful".'
);

# Filter by StartTime
my $CurSysDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$CurSysDateTimeObject->Subtract(
    Days => 1,
);
$Result = $CommunicationDBObject->ObjectLogList( ObjectLogStartTime => $CurSysDateTimeObject->ToString() );
$Self->True(
    $Result && scalar @{$Result} == $StartResultCount,
    sprintf( 'Communication objects list by start-time "%s".', $CurSysDateTimeObject->ToString(), ),
);

# restore to the previous state is done by RestoreDatabase

1;
