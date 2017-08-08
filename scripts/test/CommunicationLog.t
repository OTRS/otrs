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
            Start     => 0,
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
            Start     => 0,
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
            Start     => 0,
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
            Start     => 0,
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
            Start     => 1,
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
            Start     => 1,
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
            Start     => 1,
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
            Start     => 1,
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
            Start     => $Test->{Create}->{Start},
            }
    );

    $Self->Is(
        ref $CommunicationLogObject,
        'Kernel::System::CommunicationLog',
        "$Test->{Name} - Object create - New communication object.",
    );

    my $GeneratedCommunicationID = $CommunicationLogObject->CommunicationIDGet();

    if ( $Test->{Create}->{Start} ) {
        $Self->True(
            $GeneratedCommunicationID,
            "$Test->{Name} - Object create - Generated CommunicationID.",
        );
    }
    else {
        $Self->False(
            $GeneratedCommunicationID,
            "$Test->{Name} - Object create - Generated CommunicationID.",
        );
    }

    my %CommunicationData = $CommunicationLogObject->CommunicationGet(
        CommunicationID => $GeneratedCommunicationID,
    );

    my $Existing = IsHashRefWithData( \%CommunicationData );

    if ( $Test->{Create}->{Start} ) {
        $Self->True(
            $Existing,
            "$Test->{Name} - Object create - Communication existing before communication start (given CommunicationID).",
        );
    }
    else {
        $Self->False(
            $Existing,
            "$Test->{Name} - Object create - Communication existing before communication start (given CommunicationID).",
        );
    }

    %CommunicationData = $CommunicationLogObject->CommunicationGet();

    $Existing = IsHashRefWithData( \%CommunicationData );

    if ( $Test->{Create}->{Start} ) {
        $Self->True(
            $Existing,
            "$Test->{Name} - Object create - Communication existing before communication start (without CommunicationID).",
        );
    }
    else {
        $Self->False(
            $Existing,
            "$Test->{Name} - Object create - Communication existing before communication start (without CommunicationID).",
        );
    }

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

    #
    # Communication start
    #
    my $CommunicationID = $CommunicationLogObject->CommunicationStart();

    if ( $Test->{Create}->{Start} ) {

        $Self->False(
            $CommunicationID,
            "$Test->{Name} - Communication start - Start new communication.",
        );
    }
    else {
        $Self->True(
            $CommunicationID,
            "$Test->{Name} - Communication start - Start new communication.",
        );

        $GeneratedCommunicationID = $CommunicationID;
    }

    %CommunicationData = $CommunicationLogObject->CommunicationGet(
        CommunicationID => $GeneratedCommunicationID,
    );

    $Existing = IsHashRefWithData( \%CommunicationData );

    $Self->True(
        $Existing,
        "$Test->{Name} - Communication start - Started communication successfully created.",
    );

    $Self->Is(
        $CommunicationData{CommunicationID},
        $GeneratedCommunicationID,
        "$Test->{Name} - Communication start - Generated and stored CommunicationIDs equal.",
    );
    $Self->Is(
        $CommunicationData{Transport},
        $Test->{Create}->{Transport},
        "$Test->{Name} - Communication start - Created and stored transports equal.",
    );
    $Self->Is(
        $CommunicationData{Direction},
        $Test->{Create}->{Direction},
        "$Test->{Name} - Communication start - Created and stored directions equal.",
    );
    $Self->Is(
        $CommunicationData{Status},
        $Test->{Start}->{Status},
        "$Test->{Name} - Communication start - Created and stored status equal.",
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

    %CommunicationData = $CommunicationLogObject->CommunicationGet(
        CommunicationID => $RecreatedCommunicationID,
    );

    $Existing = IsHashRefWithData( \%CommunicationData );

    $Self->True(
        $Existing,
        "$Test->{Name} - Object recreate - Communication existing after recreate (given CommunicationID).",
    );

    %CommunicationData = $CommunicationLogObject->CommunicationGet();

    $Existing = IsHashRefWithData( \%CommunicationData );

    $Self->True(
        $Existing,
        "$Test->{Name} - Object recreate - Communication existing after recreate (without CommunicationID).",
    );

    $Transport = $CommunicationLogObject->TransportGet();

    $Self->True(
        $Transport,
        "$Test->{Name} - Object create - Receive transport.",
    );

    $Self->Is(
        $Transport,
        $Test->{Create}->{Transport},
        "$Test->{Name} - Object create - Created and received transports equal.",
    );

    $Direction = $CommunicationLogObject->DirectionGet();

    $Self->True(
        $Direction,
        "$Test->{Name} - Object create - Receive direction.",
    );

    $Self->Is(
        $Direction,
        $Test->{Create}->{Direction},
        "$Test->{Name} - Object create - Created and received directions equal.",
    );

    #
    # Communication list
    #
    my @CommunicationList = $CommunicationLogObject->CommunicationList(
        Transport => $Test->{Create}->{Transport},
        Direction => $Test->{Create}->{Direction},
        Status    => $Test->{Start}->{Status},
    );

    $Existing = IsArrayRefWithData( \@CommunicationList );

    $Self->True(
        $Existing,
        "$Test->{Name} - Communication list - Communication list result.",
    );

    $Self->Is(
        $CommunicationList[0]->{CommunicationID},
        $RecreatedCommunicationID,
        "$Test->{Name} - Communication list - CommunicationID.",
    );

    $Self->Is(
        $CommunicationList[0]->{Transport},
        $Test->{Create}->{Transport},
        "$Test->{Name} - Communication list - Transport.",
    );

    $Self->Is(
        $CommunicationList[0]->{Direction},
        $Test->{Create}->{Direction},
        "$Test->{Name} - Communication list - Direction.",
    );

    $Self->Is(
        $CommunicationList[0]->{Status},
        $Test->{Start}->{Status},
        "$Test->{Name} - Communication list - Status.",
    );

    $Self->True(
        $CommunicationList[0]->{StartTime},
        "$Test->{Name} - Communication list - StartTime.",
    );

    $Self->False(
        $CommunicationList[0]->{EndTime},
        "$Test->{Name} - Communication list - EndTime.",
    );

    $Self->False(
        $CommunicationList[0]->{Duration},
        "$Test->{Name} - Communication list - Duration.",
    );

    $Helper->FixedTimeAddSeconds(1);

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

    @CommunicationList = $CommunicationLogObject->CommunicationList(
        Transport => $Test->{Create}->{Transport},
        Direction => $Test->{Create}->{Direction},
        Status    => $Test->{Stop}->{Status},
    );

    $Existing = IsArrayRefWithData( \@CommunicationList );

    $Self->True(
        $Existing,
        "$Test->{Name} - Communication stop - Communication list result.",
    );

    $Self->Is(
        $CommunicationList[0]->{CommunicationID},
        $RecreatedCommunicationID,
        "$Test->{Name} - Communication stop - CommunicationID.",
    );

    $Self->Is(
        $CommunicationList[0]->{Transport},
        $Test->{ExpectedResult}->{Transport},
        "$Test->{Name} - Communication stop - Transport.",
    );

    $Self->Is(
        $CommunicationList[0]->{Direction},
        $Test->{ExpectedResult}->{Direction},
        "$Test->{Name} - Communication stop - Direction.",
    );

    $Self->Is(
        $CommunicationList[0]->{Status},
        $Test->{ExpectedResult}->{Status},
        "$Test->{Name} - Communication stop - Status.",
    );

    $Self->True(
        $CommunicationList[0]->{StartTime},
        "$Test->{Name} - Communication stop - StartTime.",
    );

    $Self->True(
        $CommunicationList[0]->{EndTime},
        "$Test->{Name} - Communication stop - EndTime.",
    );

    $Self->True(
        $CommunicationList[0]->{Duration},    # 1 second
        "$Test->{Name} - Communication stop - Duration.",
    );

    #
    # Communication delete
    #
    $Success = $CommunicationLogObject->CommunicationDelete(
        CommunicationID => $RecreatedCommunicationID,
    );

    $Self->True(
        $Success,
        "$Test->{Name} - Communication delete - Delete communication entry.",
    );

    %CommunicationData = $CommunicationLogObject->CommunicationGet(
        CommunicationID => $RecreatedCommunicationID,
    );

    $Existing = IsHashRefWithData( \%CommunicationData );

    $Self->False(
        $Existing,
        "$Test->{Name} - Communication delete - Communication existing after delete (given CommunicationID).",
    );

    %CommunicationData = $CommunicationLogObject->CommunicationGet();

    $Existing = IsHashRefWithData( \%CommunicationData );

    $Self->False(
        $Existing,
        "$Test->{Name} - Communication delete - Communication existing after delete (without CommunicationID).",
    );
}

1;
