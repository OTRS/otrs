# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use File::Copy;

use vars (qw($Self));

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Home   = $ConfigObject->Get('Home');
my $Daemon = $Home . '/bin/otrs.Daemon.pl';

# Get current daemon status.
my $PreviousDaemonStatus = `$Daemon status`;

# Stop daemon if it was already running before this test.
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    `$Daemon stop`;

    my $SleepTime = 2;

    # Wait to get daemon fully stopped before test continues.
    print "A running Daemon was detected and need to be stopped...\n";
    print 'Sleeping ' . $SleepTime . "s\n";
    sleep $SleepTime;
}

my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $TaskWorkerObject  = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker');
my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

my $ActiveSleep = sub {

    # Wait until task is executed.
    ACTIVESLEEP:
    for my $Sec ( 1 .. 120 ) {

        # Run the worker.
        $TaskWorkerObject->Run();

        my @List = $SchedulerDBObject->TaskList();

        last ACTIVESLEEP if !scalar @List;

        sleep 1;

        print "Waiting $Sec secs for scheduler tasks to be executed\n";
    }
};

$ActiveSleep->();

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
);

TESTCASE:
for my $Test (@Tests) {

    local $SIG{CHLD} = "IGNORE";

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

    # Execute tasks.
    $ActiveSleep->();

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

my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

my @TicketIDs = $TicketObject->TicketSearch(
    Result  => 'ARRAY',
    From    => '%skywalker@otrs.org%',
    To      => '%darthvader@otrs.org%',
    Subject => '%test 1%',
    UserID  => 1,
);

for my $TicketID (@TicketIDs) {
    my $Success = $TicketObject->TicketDelete(
        TicketID => $TicketID,
        UserID   => 1,
    );
    $Self->True(
        $Success,
        "TicketDelete() for TicketID $TicketID"
    );
}

# Start daemon if it was already running before this test.
if ( $PreviousDaemonStatus =~ m{Daemon running}i ) {
    system("$Daemon start");
}

1;
