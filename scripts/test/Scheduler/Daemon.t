# --
# Daemon.t - Scheduler tests
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: Daemon.t,v 1.1 2011-03-21 09:16:26 mg Exp $
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
        "$Name PID matches DB value before action",
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
        "$Name PID changed",
    );

    my %PIDInfoAfter = $PIDObject->PIDGet( Name => 'otrs.Scheduler' );

    $Self->Is(
        $PIDAfter,
        $PIDInfoAfter{PID} || 0,
        "$Name PID matches DB value after action",
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

# stop scheduler if it was not already running before this test
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
