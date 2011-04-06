# --
# Daemon.t - Scheduler tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Daemon.t,v 1.7 2011-04-06 12:40:58 cr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Storable ();

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

my $Home = $Self->{ConfigObject}->Get('Home');

my $PIDObject = Kernel::System::PID->new( %{$Self} );

my $Scheduler = $Home . '/bin/otrs.Scheduler.pl';
if ( $^O =~ /^win/i ) {
    $Scheduler = $Home . '/bin/otrs.Scheduler4win.pl';
}

my $CheckAction = sub {
    my %Param = @_;

    my $Name = $Param{Name};

    my $StateBefore = `$Scheduler -a status`;

    $Self->True(
        scalar( $StateBefore =~ m/^\Q$Param{StateBefore}\E/smxi ),
        "$Name state before action ($Param{StateBefore})",
    );

    my ($PIDBefore) = $StateBefore =~ m/(\d+)/;
    $PIDBefore ||= 0;

    my %PIDInfoBefore = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

    $Self->Is(
        $PIDBefore,
        $PIDInfoBefore{PID} || 0,
        "$Name PID matches DB value before action (current state $StateBefore)",
    );

    my $Result = system("$Scheduler -a $Param{Action}");

    if ( $Param{ExpectActionSuccess} ) {
        $Self->Is(
            $Result,
            0,
            "$Name action executed successfully",
        );
    }
    else {
        $Self->True(
            $Result,
            "$Name action executed unsuccessfully",
        );
    }

    my $StateAfter = `$Scheduler -a status`;

    $Self->True(
        scalar( $StateAfter =~ m/^\Q$Param{StateAfter}\E/smxi ),
        "$Name state after action ($Param{StateAfter})",
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

my $PreviousSchedulerStatus = `$Scheduler -a status`;

# stop scheduler if it was not already running before this test
if ( $PreviousSchedulerStatus =~ /^running/i ) {
    $CheckAction->(
        Name                => 'Cleanup-stop',
        Action              => 'stop',
        StateBefore         => 'running',
        ExpectActionSuccess => 1,
        StateAfter          => 'not running',
        PIDChangeExpected   => 1,
    );
}

$CheckAction->(
    Name                => 'Initial start',
    Action              => 'start',
    ExpectActionSuccess => 1,
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
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 0,
);

$CheckAction->(
    Name                => 'Stop',
    Action              => 'stop',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'not running',
    PIDChangeExpected   => 1,
);

$CheckAction->(
    Name                => 'Second stop',
    Action              => 'stop',
    ExpectActionSuccess => 0,
    StateBefore         => 'not running',
    StateAfter          => 'not running',
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
my $ConfigUpdated = $SysConfigObject->ConfigItemUpdate(
    Valid => 1,
    Key   => 'Scheduler::RestartAfterSeconds',
    Value => 5,
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
    PIDChangeExpected   => 1,
);

my %PIDInfo1 = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

sleep 1;

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

sleep 6;

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

sleep 1;

my %PIDInfo4 = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

$CheckAction->(
    Name                => 'Status check 4',
    Action              => 'status',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 0,
);

$Self->Is(
    $PIDInfo3{PID},
    $PIDInfo4{PID},
    'After 1 restart, still same PID',
);

sleep 6;

$CheckAction->(
    Name                => 'Status check 5',
    Action              => 'status',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 0,
);

my %PIDInfo5 = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

$Self->IsNot(
    $PIDInfo5{PID},
    $PIDInfo4{PID},
    'Scheduler should have restarted, different PID',
);

# check for Framework.xml file
use File::Copy;
my $FrameworkConfigFile = $Home . '/Kernel/Config/Files/Framework.xml';
move( "$FrameworkConfigFile", "$FrameworkConfigFile.save" );

sleep 6;

$CheckAction->(
    Name                => 'a Config file is missing',
    Action              => 'status',
    ExpectActionSuccess => 0,
    StateBefore         => 'not running',
    StateAfter          => 'not running',
    PIDChangeExpected   => 0,
);

# recover Framework.xml file
move( "$FrameworkConfigFile.save", "$FrameworkConfigFile" );

$CheckAction->(
    Name                => 'a Config file is recovered',
    Action              => 'start',
    ExpectActionSuccess => 1,
    StateBefore         => 'not running',
    StateAfter          => 'running',
    PIDChangeExpected   => 1,
);

# check for Config file timestamp
$CheckAction->(
    Name                => 'Check status before change Timestap',
    Action              => 'status',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 0,
);

# change Config file timestamp
my $ConfigFile = $Home . '/Kernel/Config.pm';
my $TimeStamp  = time;
utime $TimeStamp, $TimeStamp, $ConfigFile;

sleep 6;

# check after Config file timestamp changed
$CheckAction->(
    Name                => 'Check status after change Timestap',
    Action              => 'status',
    ExpectActionSuccess => 0,
    StateBefore         => 'not running',
    StateAfter          => 'not running',
    PIDChangeExpected   => 0,
);

# start deamon again
$CheckAction->(
    Name                => 'start after change Timestap',
    Action              => 'start',
    ExpectActionSuccess => 1,
    StateBefore         => 'not running',
    StateAfter          => 'running',
    PIDChangeExpected   => 1,
);

# check after daemon started
$CheckAction->(
    Name                => 'Check status after change Timestap',
    Action              => 'status',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 0,
);

# delete PID on database
$PIDObject->PIDDelete( Name => 'otrs.Scheduler' );

sleep 6;

# check after delete PID on database
$CheckAction->(
    Name                => 'Check status after delete PID',
    Action              => 'status',
    ExpectActionSuccess => 0,
    StateBefore         => 'not running',
    StateAfter          => 'not running',
    PIDChangeExpected   => 0,
);

# start deamon again
$CheckAction->(
    Name                => 'start after delete PID',
    Action              => 'start',
    ExpectActionSuccess => 1,
    StateBefore         => 'not running',
    StateAfter          => 'running',
    PIDChangeExpected   => 1,
);

# check after daemon started
$CheckAction->(
    Name                => 'Check status after change Timestap',
    Action              => 'status',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'running',
    PIDChangeExpected   => 0,
);

sleep 2;

$CheckAction->(
    Name                => 'Final stop',
    Action              => 'stop',
    ExpectActionSuccess => 1,
    StateBefore         => 'running',
    StateAfter          => 'not running',
    PIDChangeExpected   => 1,
);

# Destroy helper so that system configuration will be restored before
#   starting the Scheduler again.
undef $HelperObject;

# start scheduler if it was already running before this test
if ( $PreviousSchedulerStatus =~ /^running/i ) {
    $CheckAction->(
        Name                => 'Cleanup - restart Scheduler as it was running before this test',
        Action              => 'start',
        ExpectActionSuccess => 1,
        StateBefore         => 'not running',
        StateAfter          => 'running',
        PIDChangeExpected   => 1,
    );
}

1;
