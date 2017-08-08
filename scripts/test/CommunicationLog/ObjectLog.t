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

my $CreateCommunicationLogObject = sub {
    return $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Test',
            Direction => 'Incoming',
            Start     => 1,
            @_,
        },
    );
};

my $TestObjectLogStart = sub {
    my %Param = @_;

    my $ObjectID;

    my $CommunicationLogObject;

    # No object type passed.
    $CommunicationLogObject = $CreateCommunicationLogObject->();
    $ObjectID               = $CommunicationLogObject->ObjectLogStart();
    $Self->False(
        $ObjectID,
        'Object logging not started because no ObjectType was passed.'
    );

    # Pass an invalid Status
    $CommunicationLogObject = $CreateCommunicationLogObject->();
    $ObjectID               = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection',
        Status     => 'Invalid',
    );
    $Self->False(
        $ObjectID,
        'Object logging not started because an invalid status was provided.',
    );

    # No Status, should create with a default status
    $CommunicationLogObject = $CreateCommunicationLogObject->();
    $ObjectID               = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection',
    );
    $Self->True(
        $ObjectID,
        'Object logging started with the default status.',
    );

    # Pass a valid status
    $CommunicationLogObject = $CreateCommunicationLogObject->();
    $ObjectID               = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection',
        Status     => 'Processing',
    );
    $Self->True(
        $ObjectID,
        'Object logging started with custom status.',
    );

    return;
};

my $TestObjectLogStop = sub {
    my %Param = @_;

    my $CommunicationLogObject = $CreateCommunicationLogObject->();

    my $Result;
    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection',
    );

    # Stop without passing ObjectType should give error.
    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectID => $ObjectID,
    );
    $Self->False(
        $Result,
        'Object logging not stopped because no ObjectType was passed.',
    );

    # Stop passing no Status
    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
    );
    $Self->False(
        $Result,
        'Object logging not stopped because no status was passed.',
    );

    # Stop passing an invalid status
    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Status     => 'Invalid',
    );
    $Self->False(
        $Result,
        'Object logging not stopped because status was invalid.',
    );

    # Stop passing an valid status
    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Status     => 'Successful',
    );
    $Self->True(
        $Result,
        'Object logging stopped.',
    );

    return;
};

my $TestObjectLog = sub {
    my %Param = @_;

    my $CommunicationLogObject = $CreateCommunicationLogObject->();
    my $ObjectID               = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection',
    );

    my $Result;

    # Without Key and Value
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
    );
    $Self->False(
        $Result,
        'Object logging unsuccessful because key and value were missing.',
    );

    # Without value
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Key        => 'Key',
    );
    $Self->False(
        $Result,
        'Object logging unsuccessful because value was missing.',
    );

    # Without Key
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Value      => 'Value',
    );
    $Self->False(
        $Result,
        'Object logging unsuccessful because key was missing.',
    );

    # With key and value and default priority (Info)
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Key        => 'Key',
        Value      => 'Value',
    );
    $Self->True(
        $Result,
        'Object logging successful',
    );

    # With an invalid Priority
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Key        => 'Key',
        Value      => 'Value',
        Priority   => 'Something',
    );
    $Self->False(
        $Result,
        'Object logging unsuccessful invalid priority.',
    );

    # With an valid Priority
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Key        => 'Key',
        Value      => 'Value',
        Priority   => 'Debug',
    );
    $Self->True(
        $Result,
        'Object logging successful with "Debug" priority.',
    );

    $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Status     => 'Successful',
    );

    return;
};

my $TestObjectDelete = sub {
    my %Param = @_;

    my $CommunicationLogObject = $CreateCommunicationLogObject->();

    my %Communication = $CommunicationLogObject->CommunicationGet();

    my $Result;

    my $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection',
    );

    $Result = $CommunicationLogObject->ObjectLog(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Key        => 'Key',
        Value      => 'Value',
    );

    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Status     => 'Successful',
    );

    $Result = $CommunicationLogObject->ObjectLogDelete(
        CommunicationID => $Communication{CommunicationID},
        Status          => 'Successful'
    );

    $Self->True( $Result, "Communication Log Delete by Status." );

    $ObjectID = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection',
    );

    $Result = $CommunicationLogObject->ObjectLog(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Key        => 'Key1',
        Value      => 'Value1',
    );

    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Status     => 'Successful',
    );

    $Result = $CommunicationLogObject->ObjectLogDelete(
        CommunicationID => $Communication{CommunicationID},
        Key             => 'Key1'
    );

    $Self->True( $Result, "Communication Log Delete by Key." );

    $Result = $CommunicationLogObject->ObjectLog(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Key        => 'Key2',
        Value      => 'Value2',
    );

    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Status     => 'Successful',
    );

    $Result = $CommunicationLogObject->ObjectLogDelete(
        CommunicationID => $Communication{CommunicationID},
    );

    $Self->True( $Result, "Communication Log Delete CommunicationID ($Communication{CommunicationID})" );

    return;
};

my $TestObjectLogGet = sub {
    my %Param = @_;

    my $GetRandomPriority = sub {
        my $Idx        = int( rand(4) );                      ## no critic
        my @Priorities = qw( Error Warn Info Debug Trace );
        return $Priorities[$Idx];
    };

    my $CommunicationLogObject = $CreateCommunicationLogObject->();
    my $ObjectID               = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection',
    );

    # Insert some logs
    my %Counters = (
        Total    => 0,
        Priority => {},
    );
    for my $Idx ( 0 .. 9 ) {
        my $Priority = $GetRandomPriority->();
        $CommunicationLogObject->ObjectLog(
            ObjectType => 'Connection',
            ObjectID   => $ObjectID,
            Key        => 'Key-' . $Idx,
            Value      => 'Value for Key-' . $Idx,
            Priority   => $Priority,
        );

        $Counters{Total} += 1;

        my $PriorityCounter = $Counters{Priority}->{$Priority} || 0;
        $Counters{Priority}->{$Priority} = $PriorityCounter + 1;
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Status     => 'Successful',
    );

    $CommunicationLogObject->CommunicationStop( Status => 'Successful' );

    my $Result;

    $Result = $CommunicationLogObject->ObjectGet(
        ID => $ObjectID,
    );
    $Self->True(
        $Result,
        "Get communication logging for ObjectID '$ObjectID'",
    );
};

my $TestObjectLogList = sub {
    my %Param = @_;

    my $GetRandomPriority = sub {
        my $Idx        = int( rand(4) );                      ## no critic
        my @Priorities = qw( Error Warn Info Debug Trace );
        return $Priorities[$Idx];
    };

    my $CommunicationLogObject = $CreateCommunicationLogObject->();
    my $ObjectID               = $CommunicationLogObject->ObjectLogStart(
        ObjectType => 'Connection',
    );

    # Insert some logs
    my %Counters = (
        Total    => 0,
        Priority => {},
    );
    for my $Idx ( 0 .. 9 ) {
        my $Priority = $GetRandomPriority->();
        $CommunicationLogObject->ObjectLog(
            ObjectType => 'Connection',
            ObjectID   => $ObjectID,
            Key        => 'Key-' . $Idx,
            Value      => 'Value for Key-' . $Idx,
            Priority   => $Priority,
        );

        $Counters{Total} += 1;

        my $PriorityCounter = $Counters{Priority}->{$Priority} || 0;
        $Counters{Priority}->{$Priority} = $PriorityCounter + 1;
    }

    $CommunicationLogObject->ObjectLogStop(
        ObjectType => 'Connection',
        ObjectID   => $ObjectID,
        Status     => 'Successful',
    );

    $CommunicationLogObject->CommunicationStop( Status => 'Successful' );

    my $Result;

    # Tes:t get all the data.
    $Result = $CommunicationLogObject->ObjectLogList();
    $Self->True(
        $Result && scalar @{$Result} == $Counters{Total},
        'List communication logging.',
    );

    # Test: get all $Priority.
    {
        my $Priority = $GetRandomPriority->();
        $Result = $CommunicationLogObject->ObjectLogList(
            LogPriority => $Priority,
        );
        $Self->True(
            $Result && scalar @{$Result} == ( $Counters{Priority}->{$Priority} || 0 ),
            qq{List communication logging with priority '${ Priority }'},
        );
    }

    # Test: get all for message object type
    $Result = $CommunicationLogObject->ObjectLogList(
        ObjectType => 'Message',
    );
    $Self->True(
        $Result && scalar @{$Result} == 0,
        'List communication logging for object type "Message"',
    );

    # Test: get all for Connection and Key
    $Result = $CommunicationLogObject->ObjectLogList(
        ObjectType => 'Connection',
        LogKey     => 'Key-0',
    );
    $Self->True(
        $Result && scalar @{$Result} == 1,
        'List communication logging for object type "Connection" and key "Key-0"',
    );

    return;
};

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$TestObjectLogStart->();
$TestObjectLogStop->();
$TestObjectLog->();
$TestObjectDelete->();
$TestObjectLogList->();
$TestObjectLogGet->();

# restore to the previous state is done by RestoreDatabase

1;
