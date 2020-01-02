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

my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

my $Daemon = $Home . '/bin/otrs.Daemon.pl';

# get daemon status (stop if necessary)
my $PreviousDaemonStatus = `perl $Daemon status`;

if ( !$PreviousDaemonStatus ) {
    $Self->False(
        1,
        "Could not determine current daemon status!",
    );
    die "Could not determine current daemon status!";
}

if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    my $ResultMessage = system("perl $Daemon stop");
}
else {
    $Self->True(
        1,
        "Daemon was already stopped.",
    );
}

# Wait for slow systems
my $SleepTime = 120;
print "Waiting at most $SleepTime s until daemon stops\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my $DaemonStatus = `perl $Daemon status`;
    if ( $DaemonStatus =~ m{Daemon not running}i ) {
        last ACTIVESLEEP;
    }
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
}

my $CurrentDaemonStatus = `perl $Daemon status`;

$Self->True(
    int $CurrentDaemonStatus =~ m{Daemon not running}i,
    "Daemon is not running",
);

if ( $CurrentDaemonStatus !~ m{Daemon not running}i ) {
    die "Daemon could not be stopped.";
}

my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

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

# get worker object
my $WorkerObject = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker');

# make sure there is no other pending task to be executed
my $Success = $WorkerObject->Run();

# Wait for slow systems
$SleepTime = 120;
print "Waiting at most $SleepTime s until tasks are executed\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my @List = $SchedulerDBObject->TaskList();
    last ACTIVESLEEP if !scalar @List;
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
    $WorkerObject->Run();
}

# get needed objects
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
        $WorkerObject->Run();

        # Wait for slow systems
        $SleepTime = 120;
        print "Waiting at most $SleepTime s until tasks are executed\n";
        ACTIVESLEEP:
        for my $Seconds ( 1 .. $SleepTime ) {
            my @List = $SchedulerDBObject->TaskList();
            last ACTIVESLEEP if !scalar @List;
            print "Sleeping for $Seconds seconds...\n";
            sleep 1;
            $WorkerObject->Run();
        }
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
