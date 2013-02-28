# --
# Daemon.t - Scheduler tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Storable qw();

use Kernel::Scheduler;
use Kernel::System::PID;
use Kernel::System::UnitTest::Helper;
use Kernel::System::SysConfig;

# Create Helper instance which will restore system configuration in destructor
my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %{$Self},
    UnitTestObject             => $Self,
    RestoreSystemConfiguration => 1,
);

my $SysConfigObject = Kernel::System::SysConfig->new( %{$Self} );
my $PIDObject       = Kernel::System::PID->new( %{$Self} );

my $Home = $Self->{ConfigObject}->Get('Home');

my $Scheduler = $Home . '/bin/otrs.Scheduler.pl';
if ( $^O =~ /^mswin/i ) {
    $Scheduler = "\"$^X\" " . $Home . '/bin/otrs.Scheduler4win.pl';
    $Scheduler =~ s{/}{\\}g
}

my $CheckAction = sub {
    my %Param = @_;

    my $Name = $Param{Name};

    my $StateBefore = `$Scheduler -a status`;

    $Self->True(
        scalar( $StateBefore =~ m/^\Q$Param{StateBefore}\E/smxi ),
        "$Name state before action (should be '$Param{StateBefore}' and is '$StateBefore' ... ignoring case)",
    );

    my ($PIDBefore) = $StateBefore =~ m/(\d+)/;
    $PIDBefore ||= 0;

    my %PIDInfoBefore = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

    $Self->Is(
        $PIDBefore,
        $PIDInfoBefore{PID} || 0,
        "$Name PID matches DB value before action (current state $StateBefore)",
    );

    # check if force action is needed
    my $Force = '';
    if ( defined $Param{Force} && $Param{Force} && $Param{Force} == 1 ) {
        $Force = '-f 1';
    }

    my $ResultMessage = `$Scheduler -a $Param{Action} $Force 2>&1`;

    # special sleep for windows
    if ( $^O =~ /^mswin/i ) {
        if (
            $Param{Action} eq 'start'
            || $Param{Action} eq 'stop'
            || $Param{Action} eq 'reload'
            )
        {
            print "Sleeping 5s (Special for Windows OS)\n";
            sleep 5;
        }
    }

    if ( $Param{ExpectActionSuccess} ) {
        $Self->Is(
            $?,
            0,
            "$Name action executed successfully",
        );

        # give some visibility if the test fail when it should not
        if ($?) {
            $Self->True(
                0,
                "$Name action DETECTED $ResultMessage",
            );
        }
    }
    else {
        $Self->True(
            $?,
            "$Name action executed unsuccessfully",
        );
    }

    # slow systems needs some time to process actions and gets new PIDs
    if ( $Param{SleepAfterAction} ) {
        if ( $Param{PIDChangeExpected} ) {
            print "Waiting at most $Param{SleepAfterAction} s until scheduler gets a new PID\n";
            ACTIVESLEEP:
            for my $Seconds ( 1 .. $Param{SleepAfterAction} ) {
                my %IntPIDInfo = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );
                my $IntStateAfter = `$Scheduler -a status`;
                if (
                    ( $IntPIDInfo{PID} || 0 ) ne ( $PIDInfoBefore{PID} || 0 )
                    && $IntStateAfter =~ m/^\Q$Param{StateAfter}\E/smxi
                    )
                {
                    last ACTIVESLEEP;
                }
                print "Sleeping for $Seconds seconds...\n";
                sleep 1;
                if ( $Seconds == $Param{SleepAfterAction} ) {
                    $Self->True(
                        0,
                        "$Name timeout wating for $Seconds seconds state is $IntStateAfter!",
                    );
                }
            }
        }
        else {
            print "Waiting at most $Param{SleepAfterAction} s until scheduler perform action\n";
            ACTIVESLEEP:
            for my $Seconds ( 1 .. $Param{SleepAfterAction} ) {
                my $IntStateAfter = `$Scheduler -a status`;
                if ( $IntStateAfter =~ m/^\Q$Param{StateAfter}\E/smxi ) {
                    last ACTIVESLEEP;
                }
                print "Sleeping for $Seconds seconds...\n";
                sleep 1;
                if ( $Seconds == $Param{SleepAfterAction} ) {
                    $Self->True(
                        0,
                        "$Name timeout wating for $Seconds seconds state is $IntStateAfter!",
                    );
                }
            }
        }
    }

    my $StateAfter = `$Scheduler -a status`;

    $Self->True(
        scalar( $StateAfter =~ m/^\Q$Param{StateAfter}\E/smxi ),
        "$Name state after action (Should be '$Param{StateAfter}' and is '$StateAfter' ... ignoring case)",
    );

    my ($PIDAfter) = $StateAfter =~ m/(\d+)/;
    $PIDAfter ||= 0;

    $Self->Is(
        $PIDBefore != $PIDAfter   ? 1 : 0,
        $Param{PIDChangeExpected} ? 1 : 0,
        "$Name PID changed (current state $StateAfter)",
    );

    my %PIDInfoAfter = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

    $Self->Is(
        $PIDAfter,
        $PIDInfoAfter{PID} || 0,
        "$Name PID matches DB value after action (current state $StateAfter)",
    );
};

my $SleepTime;
my $PreviousSchedulerStatus = `$Scheduler -a status`;

# stop scheduler if it was not already running before this test
if ( $PreviousSchedulerStatus =~ /^running/i ) {
    $CheckAction->(
        Name                => 'Cleanup-stop',
        Action              => 'stop',
        Force               => 1,
        StateBefore         => 'running',
        ExpectActionSuccess => 1,
        StateAfter          => 'not running',
        PIDChangeExpected   => 1,
    );
}

# special case where scheduler is not running but PID is registered
if ( $PreviousSchedulerStatus =~ m{registered}i ) {

    # force stop direcly before CheckAction
    my $ResultMessage = `$Scheduler -a stop -f 1 2>&1`;
    $Self->True(
        1,
        "Force stoping due to bad status...",
    );

    $Self->Is(
        $?,
        0,
        "Forced stop Scheduler executed successfully",
    );

    # give some visibility if the test fail when it should not
    if ($?) {
        $Self->True(
            0,
            "Forced stopscheduler DETECTED $ResultMessage",
        );
    }

    $SleepTime = 20;
    print "Waiting at most $SleepTime s until scheduler stops\n";
    ACTIVESLEEP:
    for my $Seconds ( 1 .. $SleepTime ) {
        my $SchedulerStatus = `$Scheduler -a status`;
        if ( $SchedulerStatus !~ m{\A running }msxi ) {
            last ACTIVESLEEP;
        }
        print "Sleeping for $Seconds seconds...\n";
        sleep 1;
    }

    $CheckAction->(
        Name                => 'Cleanup-stop',
        Action              => 'stop',
        StateBefore         => 'not running',
        ExpectActionSuccess => 0,
        StateAfter          => 'not running',
        PIDChangeExpected   => 0,
    );
}

$CheckAction->(
    Name                => 'Initial start',
    Action              => 'start',
    ExpectActionSuccess => 1,
    SleepAfterAction    => 20,
    StateBefore         => 'not running',
    StateAfter          => 'running',
    PIDChangeExpected   => 1,
);

$CheckAction->(
    Name                => 'Second start',
    Action              => 'start',
    ExpectActionSuccess => 0,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 0,
);

$CheckAction->(
    Name                => 'Reload',
    Action              => 'reload',
    SleepAfterAction    => 20,
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 1,
);

$CheckAction->(
    Name                => 'Stop',
    Action              => 'stop',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'not running',
    SleepAfterAction    => 20,
    PIDChangeExpected   => 1,
);

$CheckAction->(
    Name                => 'Second stop',
    Action              => 'stop',
    ExpectActionSuccess => 0,
    StateBefore         => 'not running',
    StateAfter          => 'not running',
    SleepAfterAction    => 20,
    PIDChangeExpected   => 0,
);

$CheckAction->(
    Name                => 'Reload without scheduler running',
    Action              => 'reload',
    ExpectActionSuccess => 0,
    StateBefore         => 'not running',
    StateAfter          => 'not running',
    PIDChangeExpected   => 0,
);

#
# Check self-reloading of Scheduler
#

# this will be reset by the HelperObject automatically
my $RestartAfterSeconds = 10;
if ( $^O =~ /^mswin/i ) {
    $RestartAfterSeconds = 40;
}

my $ConfigUpdated = $SysConfigObject->ConfigItemUpdate(
    Valid => 1,
    Key   => 'Scheduler::RestartAfterSeconds',
    Value => $RestartAfterSeconds,
);

$Self->True(
    $ConfigUpdated,
    'SysConfig setting was changed.'
);

$CheckAction->(
    Name                => 'Start for self-restart tests',
    Action              => 'start',
    ExpectActionSuccess => 1,
    StateBefore         => 'not running',
    StateAfter          => 'running',
    SleepAfterAction    => 20,
    PIDChangeExpected   => 1,
);

my %PIDInfo1 = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

# this sleep is needed just to test that scheduler is still runing and not self-restart on a short
# wait
print "Sleeping 2s\n";
sleep 2;

my %PIDInfo2 = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

$CheckAction->(
    Name                => 'Status check 2',
    Action              => 'status',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 0,
);

$Self->Is(
    $PIDInfo2{PID},
    $PIDInfo1{PID},
    'Not restarted yet, same PID',
);

# wait enough for scheduler to self-restart
$SleepTime = 40;
print "Waiting at most $SleepTime s until scheduler gets a new PID\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my %IntPIDInfo = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );
    if (
        $IntPIDInfo{PID}
        && $IntPIDInfo{PID} ne $PIDInfo2{PID}
        )
    {
        last ACTIVESLEEP;
    }
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
}

$CheckAction->(
    Name                => 'Status check 3',
    Action              => 'status',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 0,
);

my %PIDInfo3 = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

$Self->IsNot(
    $PIDInfo3{PID},
    $PIDInfo2{PID},
    'Scheduler should have restarted, different PID',
);

$CheckAction->(
    Name                => 'Stop self-restarting',
    Action              => 'stop',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'not running',
    SleepAfterAction    => 20,
    PIDChangeExpected   => 1,
);

# set new configuration so shceduler will not be auto-restarted anymore during the test
$ConfigUpdated = $SysConfigObject->ConfigItemUpdate(
    Valid => 1,
    Key   => 'Scheduler::RestartAfterSeconds',
    Value => 86_400,
);

$CheckAction->(
    Name                => 'Start auto-stop tests',
    Action              => 'start',
    SleepAfterAction    => 20,
    ExpectActionSuccess => 1,
    StateBefore         => 'not running',
    StateAfter          => 'running',
    PIDChangeExpected   => 1,
);

# check for Framework.xml file
use File::Copy;
my $FrameworkConfigFile = $Home . '/Kernel/Config/Files/Framework.xml';
move( "$FrameworkConfigFile", "$FrameworkConfigFile.save" );

# Wait for slow systems
$SleepTime = 20;
print "Waiting at most $SleepTime s until scheduler stops\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my $SchedulerStatus = `$Scheduler -a status`;
    if ( $SchedulerStatus !~ m{\A running }msxi ) {
        last ACTIVESLEEP;
    }
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
}

$CheckAction->(
    Name                => 'Config file is missing, scheduler must die',
    Action              => 'status',
    ExpectActionSuccess => 0,
    StateBefore         => 'not running',
    StateAfter          => 'not running',
    PIDChangeExpected   => 0,
);

# recover Framework.xml file
move( "$FrameworkConfigFile.save", "$FrameworkConfigFile" );

$CheckAction->(
    Name                => 'Config file is recovered, start Scheduler again',
    Action              => 'start',
    ExpectActionSuccess => 1,
    SleepAfterAction    => 20,
    StateBefore         => 'not running',
    StateAfter          => 'running',
    PIDChangeExpected   => 1,
);

# Check for auto-restart on Config file timestamp change.
my %PIDInfo6 = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

# change Config file timestamp to change the checksum
utime time, time, "$Home/Kernel/Config.pm";

# wait for slow systems
$SleepTime = 40;
print "Waiting at most $SleepTime s until scheduler gets a new PID\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my %IntPIDInfo = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );
    if (
        $IntPIDInfo{PID}
        && $IntPIDInfo{PID} ne $PIDInfo6{PID}
        )
    {
        last ACTIVESLEEP;
    }
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
}

# check after Config file timestamp changed
$CheckAction->(
    Name                => 'Check status after config checksum change',
    Action              => 'status',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 0,
);

my %PIDInfo7 = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

$Self->IsNot(
    $PIDInfo6{PID},
    $PIDInfo7{PID},
    'Scheduler should have restarted, different PID',
);

# Delete PID on database, scheduler must die
$PIDObject->PIDDelete( Name => 'otrs.Scheduler' );

# Wait for slow systems
$SleepTime = 20;
print "Waiting at most $SleepTime s until scheduler stops\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my $SchedulerStatus = `$Scheduler -a status`;
    if ( $SchedulerStatus !~ m{\A running }msxi ) {
        last ACTIVESLEEP;
    }
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
}

# check after delete PID on database
$CheckAction->(
    Name                => 'Check status after delete PID',
    Action              => 'status',
    ExpectActionSuccess => 0,
    StateBefore         => 'not running',
    StateAfter          => 'not running',
    PIDChangeExpected   => 0,
);

# start daemon again
$CheckAction->(
    Name                => 'Start after delete PID',
    Action              => 'start',
    ExpectActionSuccess => 1,
    StateBefore         => 'not running',
    StateAfter          => 'running',
    SleepAfterAction    => 20,
    PIDChangeExpected   => 1,
);

$CheckAction->(
    Name                => 'Final stop',
    Action              => 'stop',
    Force               => 1,
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'not running',
    PIDChangeExpected   => 1,
);

# Wait for slow systems
$SleepTime = 20;
print "Waiting at most $SleepTime s until scheduler stops\n";
ACTIVESLEEP:
for my $Seconds ( 1 .. $SleepTime ) {
    my $SchedulerStatus = `$Scheduler -a status`;
    if ( $SchedulerStatus !~ m{\A running }msxi ) {
        last ACTIVESLEEP;
    }
    print "Sleeping for $Seconds seconds...\n";
    sleep 1;
}

# get the process ID
my %PID = $PIDObject->PIDGet(
    Name => 'otrs.Scheduler',
);

# verify that PID is removed
$Self->False(
    $PID{PID},
    "Scheduler PID was correctly removed from DB",
);

# Destroy helper so that system configuration will be restored before
#   starting the Scheduler again.
undef $HelperObject;

print "Sleeping 1s\n";
sleep 1;

# start scheduler if it was already running before this test
if ( $PreviousSchedulerStatus =~ /^running/i ) {
    $CheckAction->(
        Name                => 'Cleanup - restart Scheduler as it was running before this test',
        Action              => 'start',
        ExpectActionSuccess => 1,
        StateBefore         => 'not running',
        StateAfter          => 'running',
        SleepAfterAction    => 20,
        PIDChangeExpected   => 1,
    );
}

1;
