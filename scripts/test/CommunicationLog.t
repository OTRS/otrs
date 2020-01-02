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

use Kernel::System::VariableCheck qw(:all);

# get needed objects
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

    #
    # CommunicationLog object create
    #
    # Create an object, representing a new communication:
    my $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            Transport => $Test->{Create}->{Transport},
            Direction => $Test->{Create}->{Direction},
        }
    );

    $Self->Is(
        ref $CommunicationLogObject,
        'Kernel::System::CommunicationLog',
        "$Test->{Name} - Object create - New communication object.",
    );

    my $GeneratedCommunicationID = $CommunicationLogObject->CommunicationIDGet();

    $Self->True(
        $GeneratedCommunicationID,
        "$Test->{Name} - Object create - Generated CommunicationID.",
    );

    my $Transport = $CommunicationLogObject->TransportGet();

    $Self->True(
        $Transport,
        "$Test->{Name} - Object create - Receive transport.",
    );

    $Self->Is(
        $Transport,
        $Test->{Create}->{Transport},
        "$Test->{Name} - Object create - Created and received transports equal.",
    );

    my $Direction = $CommunicationLogObject->DirectionGet();

    $Self->True(
        $Direction,
        "$Test->{Name} - Object create - Receive direction.",
    );

    $Self->Is(
        $Direction,
        $Test->{Create}->{Direction},
        "$Test->{Name} - Object create - Created and received directions equal.",
    );

    my $Status = $CommunicationLogObject->StatusGet();
    $Self->Is(
        $Status,
        $Test->{Start}->{Status},
        "$Test->{Name} - Object create - Created and received status equal.",
    );

    #
    # CommunicationLog recreate object
    #
    $CommunicationLogObject = undef;
    $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            CommunicationID => $GeneratedCommunicationID,
        },
    );

    $Self->Is(
        ref $CommunicationLogObject,
        'Kernel::System::CommunicationLog',
        "$Test->{Name} - Object recreate - Recreate communication object.",
    );

    my $RecreatedCommunicationID = $CommunicationLogObject->CommunicationIDGet();

    $Self->True(
        $RecreatedCommunicationID,
        "$Test->{Name} - Object recreate - Recreated CommunicationID.",
    );

    $Self->Is(
        $RecreatedCommunicationID,
        $GeneratedCommunicationID,
        "$Test->{Name} - Object recreate - Generated and recreated CommunicationIDs equal.",
    );

    $Transport = $CommunicationLogObject->TransportGet();

    $Self->True(
        $Transport,
        "$Test->{Name} - Object recreate - Receive transport.",
    );

    $Self->Is(
        $Transport,
        $Test->{Create}->{Transport},
        "$Test->{Name} - Object recreate - Created and received transports equal.",
    );

    $Direction = $CommunicationLogObject->DirectionGet();

    $Self->True(
        $Direction,
        "$Test->{Name} - Object recreate - Receive direction.",
    );

    $Self->Is(
        $Direction,
        $Test->{Create}->{Direction},
        "$Test->{Name} - Object recreate - Created and received directions equal.",
    );

    $Status = $CommunicationLogObject->StatusGet();

    $Self->Is(
        $Status,
        $Test->{Start}->{Status},
        "$Test->{Name} - Object recreate - Receive status.",
    );

    #
    # Communication stop
    #
    my $Success = $CommunicationLogObject->CommunicationStop(
        Status => $Test->{Stop}->{Status},
    );

    if ( $Test->{Stop}->{Result} ) {
        $Self->True(
            $Success,
            "$Test->{Name} - Communication stop - stop result should be true.",
        );
    }
    else {
        $Self->False(
            $Success,
            "$Test->{Name} - Communication stop - stop result should be false.",
        );
    }

    $Status = $CommunicationLogObject->StatusGet();

    $Self->Is(
        $Status,
        $Test->{ExpectedResult}->{Status},
        "$Test->{Name} - Communication stop - Status.",
    );

    #
    # CommunicationLog recreate closed object
    #
    $CommunicationLogObject = undef;
    $CommunicationLogObject = $Kernel::OM->Create(
        'Kernel::System::CommunicationLog',
        ObjectParams => {
            CommunicationID => $GeneratedCommunicationID,
        },
    );

    $Self->False(
        $CommunicationLogObject,
        "$Test->{Name} - Object already closed couldn't be recreated.",
    );
}

1;
