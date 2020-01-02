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
use Data::Dumper;
use vars (qw($Self));

use Kernel::System::VariableCheck qw(:all);

# get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TestObjectLogDelete = sub {
    my %Param = @_;

    my $CommunicationLogDBObj  = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );

    my $Result;

    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Key           => 'Key',
        Value         => 'Value',
    );

    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    $Result = $CommunicationLogDBObj->ObjectLogDelete(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
        ObjectLogStatus => 'Successful'
    );

    $Self->True( $Result, "Communication Log Delete by Status." );

    $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Key           => 'Key1',
        Value         => 'Value1',
    );

    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Key           => 'Key2',
        Value         => 'Value2',
    );

    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    $Result = $CommunicationLogDBObj->ObjectLogDelete(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
    );

    $Self->True( $Result, "Communication Log Delete by CommunicationID" );

    return;
};

my $TestObjectLogGet = sub {
    my %Param = @_;

    my $GetRandomPriority = sub {
        my $Idx        = int( rand(4) );                      ## no critic
        my @Priorities = qw( Error Warn Info Debug Trace );
        return $Priorities[$Idx];
    };

    my $CommunicationLogDBObj  = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );
    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    # Insert some logs
    my %Counters = (
        Total    => 0,
        Priority => {},
    );
    for my $Idx ( 0 .. 9 ) {
        my $Priority = $GetRandomPriority->();
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Key           => 'Key-' . $Idx,
            Value         => 'Value for Key-' . $Idx,
            Priority      => $Priority,
        );

        $Counters{Total} += 1;

        my $PriorityCounter = $Counters{Priority}->{$Priority} || 0;
        $Counters{Priority}->{$Priority} = $PriorityCounter + 1;
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    $CommunicationLogObject->CommunicationStop( Status => 'Successful' );

    my $Result;

    $Result = $CommunicationLogDBObj->ObjectLogGet(
        ObjectLogID => $ObjectID,
    );
    $Self->True(
        ( $Result && scalar %{$Result} ),
        "Get communication logging for ObjectLogID '$ObjectID'",
    );

    return;
};

my $TestObjectLogEntryList = sub {
    my %Param = @_;

    my $GetRandomPriority = sub {
        my $Idx        = int( rand(4) );                      ## no critic
        my @Priorities = qw( Error Warn Info Debug Trace );
        return $Priorities[$Idx];
    };

    my $CommunicationLogDBObj  = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
    );
    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );

    # Insert some logs
    my %Counters = (
        Total    => 0,
        Priority => {},
    );
    for my $Idx ( 0 .. 9 ) {
        my $Priority = $GetRandomPriority->();
        $CommunicationLogObject->ObjectLog(
            ObjectLogType => 'Connection',
            Key           => 'Key-' . $Idx,
            Value         => 'Value for Key-' . $Idx,
            Priority      => $Priority,
        );

        $Counters{Total} += 1;

        my $PriorityCounter = $Counters{Priority}->{$Priority} || 0;
        $Counters{Priority}->{$Priority} = $PriorityCounter + 1;
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    $CommunicationLogObject->CommunicationStop( Status => 'Successful' );

    my $Result;

    # Tes:t get all the data.
    $Result = $CommunicationLogDBObj->ObjectLogEntryList(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
    );
    $Self->True(
        $Result && scalar @{$Result} == $Counters{Total},
        'List communication logging.',
    );

    # Test: get all $Priority.
    {
        my $Priority = $GetRandomPriority->();
        $Result = $CommunicationLogDBObj->ObjectLogEntryList(
            CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
            LogPriority     => $Priority,
        );
        $Self->True(
            $Result && scalar @{$Result} == ( $Counters{Priority}->{$Priority} || 0 ),
            qq{List communication logging with priority '${ Priority }'},
        );
    }

    # Test: get all for message object type
    $Result = $CommunicationLogDBObj->ObjectLogEntryList(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
        ObjectLogType   => 'Message',
    );
    $Self->True(
        $Result && scalar @{$Result} == 0,
        'List communication logging for object type "Message"',
    );

    # Test: get all for Connection and Key
    $Result = $CommunicationLogDBObj->ObjectLogEntryList(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
        ObjectLogType   => 'Connection',
        LogKey          => 'Key-0',
    );
    $Self->True(
        $Result && scalar @{$Result} == 1,
        'List communication logging for object type "Connection" and key "Key-0"',
    );

    # Delete the communication.
    $Result = $CommunicationLogDBObj->CommunicationDelete(
        CommunicationID => $CommunicationLogObject->CommunicationIDGet(),
    );
    $Self->True(
        $Result,
        sprintf(
            "Communication '%s' deleted",
            $CommunicationLogObject->CommunicationIDGet(),
        ),
    );

    return;
};

my @Test = (
    {
        Name   => 'Test1',
        Create => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Successful',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Incoming',
            Status    => 'Successful',
        },
    },
    {
        Name   => 'Test2',
        Create => {
            Transport => 'Email',
            Direction => 'Outgoing',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Successful',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Outgoing',
            Status    => 'Successful',
        },
    },
    {
        Name   => 'Test3',
        Create => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Failed',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Incoming',
            Status    => 'Failed',
        },
    },
    {
        Name   => 'Test4',
        Create => {
            Transport => 'Email',
            Direction => 'Outgoing',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Failed',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Outgoing',
            Status    => 'Failed',
        },
    },
    {
        Name   => 'Test5',
        Create => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Successful',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Incoming',
            Status    => 'Successful',
        },
    },
    {
        Name   => 'Test6',
        Create => {
            Transport => 'Email',
            Direction => 'Outgoing',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Successful',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Outgoing',
            Status    => 'Successful',
        },
    },
    {
        Name   => 'Test7',
        Create => {
            Transport => 'Email',
            Direction => 'Incoming',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Failed',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Incoming',
            Status    => 'Failed',
        },
    },
    {
        Name   => 'Test8',
        Create => {
            Transport => 'Email',
            Direction => 'Outgoing',
        },
        Start => {
            Status => 'Processing',
        },
        Stop => {
            Status => 'Failed',
            Result => 1,
        },
        ExpectedResult => {
            Transport => 'Email',
            Direction => 'Outgoing',
            Status    => 'Failed',
        },
    },

);

for my $Test (@Test) {

    $Helper->FixedTimeSet();

    # Create an object, representing a new communication:
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => $Test->{Create}->{Transport},
            Direction => $Test->{Create}->{Direction},
        },
    );

    my $GeneratedCommunicationID = $CommunicationLogObject->CommunicationIDGet();

    my $CommunicationDBObject = $Kernel::OM->Get('Kernel::System::CommunicationLog::DB');

    my $CommunicationData = $CommunicationDBObject->CommunicationGet();
    my $Existing          = IsHashRefWithData($CommunicationData);
    $Self->False(
        $Existing,
        "$Test->{Name} - Object create - Communication Get (without CommunicationID).",
    );

    $CommunicationData = $CommunicationDBObject->CommunicationGet(
        CommunicationID => $GeneratedCommunicationID,
    );
    $Existing = IsHashRefWithData($CommunicationData);
    $Self->True(
        $Existing,
        "$Test->{Name} - Object create - Communication Get (given CommunicationID).",
    );

    $Self->Is(
        $CommunicationData->{CommunicationID},
        $GeneratedCommunicationID,
        "$Test->{Name} - Communication start - Generated and stored CommunicationIDs equal.",
    );
    $Self->Is(
        $CommunicationData->{Transport},
        $Test->{Create}->{Transport},
        "$Test->{Name} - Communication start - Created and stored transports equal.",
    );
    $Self->Is(
        $CommunicationData->{Direction},
        $Test->{Create}->{Direction},
        "$Test->{Name} - Communication start - Created and stored directions equal.",
    );
    $Self->Is(
        $CommunicationData->{Status},
        $Test->{Start}->{Status},
        "$Test->{Name} - Communication start - Created and stored status equal.",
    );

    #
    # Communication list
    #
    my $CommunicationList = $CommunicationDBObject->CommunicationList(
        Transport => $Test->{Create}->{Transport},
        Direction => $Test->{Create}->{Direction},
        Status    => $Test->{Start}->{Status},
    );

    $Existing = IsArrayRefWithData($CommunicationList);

    $Self->True(
        $Existing,
        "$Test->{Name} - Communication list - Communication list result.",
    );

    $Self->Is(
        $CommunicationList->[0]->{CommunicationID},
        $GeneratedCommunicationID,
        "$Test->{Name} - Communication list - CommunicationID.",
    );

    $Self->Is(
        $CommunicationList->[0]->{Transport},
        $Test->{Create}->{Transport},
        "$Test->{Name} - Communication list - Transport.",
    );

    $Self->Is(
        $CommunicationList->[0]->{Direction},
        $Test->{Create}->{Direction},
        "$Test->{Name} - Communication list - Direction.",
    );

    $Self->Is(
        $CommunicationList->[0]->{Status},
        $Test->{Start}->{Status},
        "$Test->{Name} - Communication list - Status.",
    );

    $Self->True(
        $CommunicationList->[0]->{StartTime},
        "$Test->{Name} - Communication list - StartTime.",
    );

    $Self->False(
        $CommunicationList->[0]->{EndTime},
        "$Test->{Name} - Communication list - EndTime.",
    );

    $Self->False(
        $CommunicationList->[0]->{Duration},
        "$Test->{Name} - Communication list - Duration.",
    );

    $Helper->FixedTimeAddSeconds(1);

    #
    # Communication Stop
    #

    my $Success = $CommunicationLogObject->CommunicationStop(
        Status => $Test->{Stop}->{Status},
    );

    $CommunicationList = $CommunicationDBObject->CommunicationList(
        Transport => $Test->{Create}->{Transport},
        Direction => $Test->{Create}->{Direction},
        Status    => $Test->{Stop}->{Status},
    );

    $Existing = IsArrayRefWithData($CommunicationList);

    $Self->True(
        $Existing,
        "$Test->{Name} - Communication stop - Communication list result.",
    );

    $Self->Is(
        $CommunicationList->[0]->{CommunicationID},
        $GeneratedCommunicationID,
        "$Test->{Name} - Communication stop - CommunicationID.",
    );

    $Self->Is(
        $CommunicationList->[0]->{Transport},
        $Test->{ExpectedResult}->{Transport},
        "$Test->{Name} - Communication stop - Transport.",
    );

    $Self->Is(
        $CommunicationList->[0]->{Direction},
        $Test->{ExpectedResult}->{Direction},
        "$Test->{Name} - Communication stop - Direction.",
    );

    $Self->Is(
        $CommunicationList->[0]->{Status},
        $Test->{ExpectedResult}->{Status},
        "$Test->{Name} - Communication stop - Status.",
    );

    $Self->True(
        $CommunicationList->[0]->{StartTime},
        "$Test->{Name} - Communication stop - StartTime.",
    );

    $Self->True(
        $CommunicationList->[0]->{EndTime},
        "$Test->{Name} - Communication stop - EndTime.",
    );

    $Self->True(
        $CommunicationList->[0]->{Duration},    # 1 second
        "$Test->{Name} - Communication stop - Duration.",
    );

    #
    # Communication delete
    #

    my $Result = $CommunicationDBObject->CommunicationDelete(
        CommunicationID => $GeneratedCommunicationID,
    );

    $Self->True(
        $Result,
        "$Test->{Name} - Communication delete. - Given CommunicationID.",
    );

    $CommunicationData = $CommunicationDBObject->CommunicationGet(
        CommunicationID => $GeneratedCommunicationID,
    );

    $Existing = IsHashRefWithData($CommunicationData);

    $Self->False(
        $Existing,
        "$Test->{Name} - Communication delete - Communication existing after delete (given CommunicationID).",
    );

}

$TestObjectLogDelete->();
$TestObjectLogGet->();
$TestObjectLogEntryList->();

1;
