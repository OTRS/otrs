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

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $Home   = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $Daemon = $Home . '/bin/otrs.Daemon.pl';

# Get current daemon status.
my $PreviousDaemonStatus = `$Daemon status`;

# Check if there is permissions for daemon commands.
if ( !defined $PreviousDaemonStatus ) {
    $Self->False(
        0,
        'Permission denied for deamon commands, skipping test',
    );
    return 1;
}

# Stop daemon if it was already running before this test.
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    `$^X $Daemon stop`;

    my $SleepTime = 2;

    # Wait to get daemon fully stopped before test continues.
    print "A running Daemon was detected and need to be stopped...\n";
    print 'Sleeping ' . $SleepTime . "s\n";
    sleep $SleepTime;
}

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

# Remove existing scheduled asynchronous tasks from DB, as they may interfere with tests run later.
my @AsyncTasks = $SchedulerDBObject->TaskList(
    Type => 'AsynchronousExecutor',
);
for my $AsyncTask (@AsyncTasks) {
    my $Success = $SchedulerDBObject->TaskDelete(
        TaskID => $AsyncTask->{TaskID},
    );
    $Self->True(
        $Success,
        "TaskDelete - Removed scheduled asynchronous task $AsyncTask->{TaskID}",
    );
}

my @Tests = (
    {
        Name     => 'Synchronous Call',
        Function => 'Execute',
    },
    {
        Name     => 'ASynchronous Call',
        Function => 'ExecuteAsyc',
    },
    {
        Name     => 'ASynchronous Call With Object Name',
        Function => 'ExecuteAsycWithObjectName',
    },
);

# Make sure there is no other pending task to be executed.
my $Success = $TaskWorkerObject->Run();

$RunTasks->();

my $AsynchronousExecutorObject
    = $Kernel::OM->Get('scripts::test::sample::AsynchronousExecutor::TestAsynchronousExecutor');

my $MainObject = $Kernel::OM->Get('Kernel::System::Main');

my @FileRemember;
for my $Test (@Tests) {

    my $File = $Home . '/var/tmp/task_' . $Helper->GetRandomNumber();
    if ( -e $File ) {
        unlink $File;
    }
    push @FileRemember, $File;

    my $Function = $Test->{Function};

    $AsynchronousExecutorObject->$Function(
        File    => $File,
        Success => 1,
    );

    if ( $Function eq 'ExecuteAsyc' || $Function eq 'ExecuteAsycWithObjectName' ) {
        $TaskWorkerObject->Run();

        $RunTasks->();
    }

    $Self->True(
        -e $File,
        "$Test->{Name} - $File exists with true",
    );

    my $ContentSCALARRef = $MainObject->FileRead(
        Location        => $File,
        Mode            => 'utf8',
        Type            => 'Local',
        Result          => 'SCALAR',
        DisableWarnings => 1,
    );

    $Self->Is(
        ${$ContentSCALARRef},
        '123',
        "$Test->{Name} - $File content match",
    );
}

# perform cleanup
for my $File (@FileRemember) {
    if ( -e $File ) {
        unlink $File;
    }
    $Self->True(
        !-e $File,
        "$File removed with true",
    );
}

# start daemon if it was already running before this test
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    system("perl $Daemon start");
}

1;
