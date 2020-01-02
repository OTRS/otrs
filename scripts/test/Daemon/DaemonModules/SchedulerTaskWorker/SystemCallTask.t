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

use File::Copy;

use vars (qw($Self));

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $Daemon = $Home . '/bin/otrs.Daemon.pl';

# Get current daemon status.
my $PreviousDaemonStatus = `$Daemon status`;

# Stop daemon if it was already running before this test.
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    `$^X $Daemon stop`;

    my $SleepTime = 2;

    # Wait to get daemon fully stopped before test continues.
    print "A running Daemon was detected and need to be stopped...\n";
    print 'Sleeping ' . $SleepTime . "s\n";
    sleep $SleepTime;
}

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');
my $TaskWorkerObject  = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker');

my $RunTasks = sub {

    local $SIG{CHLD} = "IGNORE";

    my $ErrorMessage;

    # Localize the standard error, to prevent redefining warnings.
    #   WARNING: This also hides any task run errors.
    local *STDERR;

    # Redirect the standard error to a variable.
    open STDERR, ">>", \$ErrorMessage;

    # Wait until task is executed.
    ACTIVESLEEP:
    for my $Sec ( 1 .. 120 ) {

        # Run the worker.
        $TaskWorkerObject->Run();
        $TaskWorkerObject->_WorkerPIDsCheck();

        my @List = $SchedulerDBObject->TaskList();

        last ACTIVESLEEP if !scalar @List;

        sleep 1;

        print "Waiting $Sec secs for scheduler tasks to be executed\n";
    }
};

$Self->True(
    1,
    "Initial Task Cleanup...",
);
$RunTasks->();

my $RandomID = $Helper->GetRandomID();

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my $GATicketID = $TicketObject->TicketCreate(
    Title    => $RandomID,
    QueueID  => 1,
    Lock     => 'unlock',
    Priority => '3 normal',
    State    => 'new',
    OwnerID  => 1,
    UserID   => 1,
);
$Self->IsNot(
    $GATicketID,
    undef,
    "TicketCreate() - TicketID"
);

# Discard ticket object to process all transactional events
#   In Daemon environment objects are forked and discarded, any transactional event will be
#   repeated endlessly on each fork
$Kernel::OM->ObjectsDiscard(
    Objects => [ 'Kernel::System::Ticket', ]
);

# Execute tasks (ticket transactional events).
$Self->True(
    1,
    "Post TicketCreate() Task Cleanup...",
);
$RunTasks->();

$TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my $GenericAgentObject = $Kernel::OM->Get('Kernel::System::GenericAgent');

my $Success = $GenericAgentObject->JobAdd(
    Name => $RandomID,
    Data => {
        ScheduleDays  => [ 0, 1, 2, 3, 4, 5, 6, ],
        ScheduleHours => [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, ],
        ScheduleMinutes => [
            0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
            20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
            40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59,
        ],
        Title => $RandomID,    # to pass GA search validation in JobRun()
        NewModule => "scripts::test::sample::GenericAgent::TestSystemCallModule",
        Valid     => 1,
    },
    UserID => 1,
);
$Self->True(
    $Success,
    "GenericAgent JobAdd() - for $RandomID with true",
);

my $SourcePath = "$Home/scripts/test/sample/EmailParser/PostMaster-Test1.box";
my $TargetPath = "$Home/var/spool/Test.eml";

if ( -e $TargetPath ) {
    unlink $TargetPath;
}
$Self->False(
    -e $TargetPath ? 1 : 0,
    "Initial Test email does not exists - with false",
);

my @Tests = (
    {
        Name    => 'Cron',
        TaskAdd => {
            Type                     => 'Cron',
            Name                     => 'TestCronSpoolMailsReprocess',
            Attempts                 => 1,
            MaximumParallelInstances => 1,
            Data                     => {
                Module   => 'Kernel::System::Console::Command::Maint::PostMaster::SpoolMailsReprocess',
                Function => 'Execute',
                Params   => [],
            },
        },
    },
    {
        Name    => 'AsynchronousExecutor',
        TaskAdd => {
            Type                     => 'AsynchronousExecutor',
            Name                     => 'TestAsyncSpoolMailsReprocess',
            Attempts                 => 1,
            MaximumParallelInstances => 1,
            Data                     => {
                Object   => 'Kernel::System::Console::Command::Maint::PostMaster::SpoolMailsReprocess',
                Function => 'Execute',
                Params   => {},
            },
        },
    },
    {
        Name    => 'GenericAgent',
        TaskAdd => {
            Type                     => 'GenericAgent',
            Name                     => 'TestGASpoolMailsReprocess',
            Attempts                 => 1,
            MaximumParallelInstances => 1,
            Data                     => {
                Name  => $RandomID,
                Valid => 1,
            },
        },
    },
);

TESTCASE:
for my $Test (@Tests) {

    # prevent mails send
    $Helper->ConfigSettingChange(
        Key   => 'SendmailModule',
        Value => 'Kernel::System::Email::DoNotSendEmail',
        Valid => 1,
    );

    my $TaskID = $SchedulerDBObject->TaskAdd( %{ $Test->{TaskAdd} } );
    $Self->IsNot(
        $TaskID,
        undef,
        "$Test->{Name} TaskAdd()"
    );

    # Make sue there the mail in the spool directory.
    $Self->True(
        copy( $SourcePath, $TargetPath ) ? 1 : 0,
        "$Test->{Name} Copy test email with - true $!",
    );
    $Self->True(
        -e $TargetPath ? 1 : 0,
        "$Test->{Name} Test email is in the spool directory  - with true $!",
    );

    $RunTasks->();

    # Test if the file is still there (it should not). This means the task was executed correctly
    $Self->False(
        -e $TargetPath ? 1 : 0,
        "$Test->{Name} Test email still exists - with false",
    );
}

# Do cleanup.
if ( -e $TargetPath ) {
    unlink $TargetPath;
}
$Self->False(
    -e $TargetPath ? 1 : 0,
    "Final Test email still exists - with false",
);

my @TicketIDs = $TicketObject->TicketSearch(
    Result         => 'ARRAY',
    CustomerUserID => 'skywalker@otrs.org',
    UserID         => 1,
);

for my $TicketID ( @TicketIDs, $GATicketID ) {
    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "TicketDelete() for TicketID $TicketID"
    );
}

$Kernel::OM->ObjectsDiscard(
    Objects => [ 'Kernel::System::Ticket', ]
);

# Execute tasks (ticket transactional events).
$Self->True(
    1,
    "Post TicketDelete() Task Cleanup...",
);
$RunTasks->();

$Success = $GenericAgentObject->JobDelete(
    Name   => $RandomID,
    UserID => 1,
);
$Self->True(
    $Success,
    "GenericAgent JobDelete() - for $RandomID with true",
);

# Start daemon if it was already running before this test.
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    system("$^X $Daemon start");
}

1;
