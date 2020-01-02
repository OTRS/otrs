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

my $CreateCommunicationLogObject = sub {
    return $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => 'Test',
            Direction => 'Incoming',
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
        'Object logging not started because no ObjectLogType was passed.'
    );

    # Pass an invalid Status
    $CommunicationLogObject = $CreateCommunicationLogObject->();
    $ObjectID               = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
        Status        => 'Invalid',
    );
    $Self->False(
        $ObjectID,
        'Object logging not started because an invalid status was provided.',
    );

    # No Status, should create with a default status
    $CommunicationLogObject = $CreateCommunicationLogObject->();
    $ObjectID               = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
    );
    $Self->True(
        $ObjectID,
        'Object logging started with the default status.',
    );

    # Pass a valid status
    $CommunicationLogObject = $CreateCommunicationLogObject->();
    $ObjectID               = $CommunicationLogObject->ObjectLogStart(
        ObjectLogType => 'Connection',
        Status        => 'Processing',
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
        ObjectLogType => 'Connection',
    );

    # Stop without passing ObjectLogType should give error.
    $Result = $CommunicationLogObject->ObjectLogStop();
    $Self->False(
        $Result,
        'Object logging not stopped because no ObjectLogType was passed.',
    );

    # Stop passing no Status
    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
    );
    $Self->False(
        $Result,
        'Object logging not stopped because no status was passed.',
    );

    # Stop passing an invalid status
    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Invalid',
    );
    $Self->False(
        $Result,
        'Object logging not stopped because status was invalid.',
    );

    # Stop passing an valid status
    $Result = $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
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
        ObjectLogType => 'Connection',
    );

    my $Result;

    # Without Key and Value
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
    );
    $Self->False(
        $Result,
        'Object logging unsuccessful because key and value were missing.',
    );

    # Without value
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Key           => 'Key',
    );
    $Self->False(
        $Result,
        'Object logging unsuccessful because value was missing.',
    );

    # Without Key
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Value         => 'Value',
    );
    $Self->False(
        $Result,
        'Object logging unsuccessful because key was missing.',
    );

    # With key and value and default priority (Info)
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Key           => 'Key',
        Value         => 'Value',
    );
    $Self->True(
        $Result,
        'Object logging successful',
    );

    # With an invalid Priority
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Key           => 'Key',
        Value         => 'Value',
        Priority      => 'Something',
    );
    $Self->False(
        $Result,
        'Object logging unsuccessful invalid priority.',
    );

    # With an valid Priority
    $Result = $CommunicationLogObject->ObjectLog(
        ObjectLogType => 'Connection',
        Key           => 'Key',
        Value         => 'Value',
        Priority      => 'Debug',
    );
    $Self->True(
        $Result,
        'Object logging successful with "Debug" priority.',
    );

    $CommunicationLogObject->ObjectLogStop(
        ObjectLogType => 'Connection',
        Status        => 'Successful',
    );

    return;
};

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$TestObjectLogStart->();
$TestObjectLogStop->();
$TestObjectLog->();

# restore to the previous state is done by RestoreDatabase

1;
