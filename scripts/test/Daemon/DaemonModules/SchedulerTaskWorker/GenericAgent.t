# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# prevent mails send
$ConfigObject->Set(
    Key   => 'SendmailModule',
    Value => 'Kernel::System::Email::DoNotSendEmail',
);

# prepare environment

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase  => 1,
        UseTmpArticleDir => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get random ID
my $RandomID = $Helper->GetRandomID();

my $TicketID = $Kernel::OM->Get('Kernel::System::Ticket')->TicketCreate(
    Title        => 'GA' . $RandomID,
    QueueID      => 1,
    Lock         => 'unlock',
    Priority     => '3 normal',
    State        => 'new',
    CustomerID   => '123465',
    CustomerUser => 'customer@example.com',
    OwnerID      => 1,
    UserID       => 1,
);
$Self->IsNot(
    $TicketID,
    undef,
    "TicketCreate() - result should not be undef",
);

my $Home = $ConfigObject->Get('Home');

# get generic agent object
my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

# execution failure test
my $JobAdd = $GenericAgentObject->JobAdd(
    Name => 'GA' . $RandomID,
    Data => {
        Valid => 1,
    },
    UserID => 1,
);
$Self->True(
    $JobAdd,
    "JobAdd() for GA$RandomID with true",
);

my %Job = $GenericAgentObject->JobGet( Name => 'GA' . $RandomID );

# get task handler object
my $TaskHandlerObject = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericAgent');

my $Result = $TaskHandlerObject->Run(
    TaskID   => 123,
    TaskName => 'UnitTest',
    Data     => {
        %Job,
    },
);

$Result //= '0';

$Self->Is(
    $Result,
    0,
    "TaskHandler Run() - result",
);

# cleanup
my $Success = $GenericAgentObject->JobDelete(
    Name   => 'GA' . $RandomID,
    UserID => 1,
);
$Self->True(
    $Success,
    "JobDelete() for GA$RandomID with true",
);

# more tests
$JobAdd = $GenericAgentObject->JobAdd(
    Name => 'GA' . $RandomID,
    Data => {
        ScheduleMinutes => 1,
        Title           => 'GA' . $RandomID,
        NewDelete       => 0,
        NewModule       => 'scripts::test::sample::GenericAgent::TestGenericAgent',
        NewParamKey1    => 'Location',
        NewParamValue1  => $Home . '/var/tmp/task_' . $RandomID,
        Valid           => 1,
    },
    UserID => 1,
);
$Self->True(
    $JobAdd,
    "JobAdd() for GA$RandomID with true",
);

# freeze time
$Helper->FixedTimeSet();

my @Tests = (
    {
        Name   => 'Empty',
        Config => {},
        Result => 0,
    },
    {
        Name   => 'Missing TaskID',
        Config => {
            TaskName => 'UnitTest',
            Data     => {
                Name  => 'GenericAgentUnitTest',
                Valid => 1,
            },
        },
        Result => 0,
    },
    {
        Name   => 'Missing Data',
        Config => {
            TaskID   => 123,
            TaskName => 'UnitTest',
        },
        Result => 0,
    },
);

TESTCASE:
for my $Test (@Tests) {

    # result task
    my $Result = $TaskHandlerObject->Run( %{ $Test->{Config} } );

    $Self->Is(
        $Result || 0,
        $Test->{Result},
        "$Test->{Name} - execution result",
    );
}

# additional tests
@Tests = (
    {
        Name   => 'Missing name and valid',
        Config => {
            Name  => undef,
            Valid => undef,
        },
        AddSeconds => '',
        Success    => 0,
    },
    {
        Name   => 'Missing valid',
        Config => {
            Valid => undef,
        },
        AddSeconds => '',
        Success    => 0,
    },
    {
        Name   => 'Invalid Job',
        Config => {
            Valid => 0,
        },
        AddSeconds => '',
        Success    => 0,
    },
    {
        Name       => 'Correct Call',
        Config     => {},
        AddSeconds => '',
        Success    => 1,
    },
    {
        Name       => 'After 0 Seconds',
        Config     => {},
        AddSeconds => '',
        Success    => 0,
    },
    {
        Name       => 'After 10 Seconds',
        Config     => {},
        AddSeconds => '10',
        Success    => 0,
    },
    {
        Name       => 'After 30 Seconds',
        Config     => {},
        AddSeconds => '20',
        Success    => 0,
    },
    {
        Name       => 'After 59 Seconds',
        Config     => {},
        AddSeconds => '29',
        Success    => 0,
    },
    {
        Name       => 'After 60 Seconds',
        Config     => {},
        AddSeconds => '1',
        Success    => 1,
    },
);

TESTCASE:
for my $Test (@Tests) {

    my $File = $Home . '/var/tmp/task_' . $RandomID;
    if ( -e $File ) {
        unlink $File;
    }

    if ( $Test->{AddSeconds} ) {
        $Helper->FixedTimeAddSeconds( $Test->{AddSeconds} );
    }

    my %Job = $GenericAgentObject->JobGet( Name => 'GA' . $RandomID );

    my $Result = $TaskHandlerObject->Run(
        TaskID   => 123,
        TaskName => 'UnitTest',
        Data     => {
            %Job,
            %{ $Test->{Config} },
        },
    );

    $Result //= '0';

    $Self->Is(
        $Result,
        $Test->{Success},
        "$Test->{Name} Run() - result",
    );

    if ( $Test->{Success} ) {
        $Self->True(
            int -e $File,
            "File $File exists with true",
        );
    }

    # cleanup file system
    if ( -e $File ) {
        unlink $File;
    }
}

# cleanup is done by RestoreDatabase.

1;
