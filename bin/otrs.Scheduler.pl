#!/usr/bin/perl -w
# --
# otrs.Scheduler.pl - provides Scheduler daemon control on unlix like OS
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: otrs.Scheduler.pl,v 1.13 2011-03-11 09:10:41 mg Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see L<http://www.gnu.org/licenses/agpl.txt>.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::PID;
use Kernel::Scheduler;
use Proc::Daemon;

# sleep time between loop intervals in seconds
my $SleepTime = 1;

# get options
my %Opts = ();
getopt( 'hfa', \%Opts );

# check if is running on windows
if ( $^O eq "MSWin32" ) {
    print "This program cannot run in Microsoft Windows!, use otrs.Scheduler4win.pl instead.\n";
    exit 1;
}

# help option
if ( $Opts{h} ) {
    _help();
    exit 1;
}

# check if a stop request is sent
if ( $Opts{a} && $Opts{a} eq "stop" ) {

    # create common objects
    my %CommonObject = _CommonObjects();

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # no proces ID means that is not running
    if ( !%PID ) {
        print "Can't stop OTRS Scheduler because is not running!\n";
        exit 1;
    }

    # send interrupt signal to the proces ID to stop it
    kill( 2, $PID{PID} );

    # delete pid lock
    $CommonObject{PIDObject}->PIDDelete( Name => 'otrs.Scheduler' );

    # log daemon stop
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Scheduler Daemon Stop! PID $PID{PID}",
    );

    exit 0;
}

# check if a status request is sent
if ( $Opts{a} && $Opts{a} eq "status" ) {

    # create common objects
    my %CommonObject = _CommonObjects();

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # no proces ID means that is not running
    if ( !%PID ) {
        print "Not Running!\n";
        exit 1;
    }

    # log daemon stop
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Scheduler Daemon status request! PID $PID{PID}",
    );

    # create a new Daemon object
    my $Daemon = Proc::Daemon->new();

    # Get the process status
    if ( $Daemon->Status( $PID{PID} ) ) {
        print "Running $PID{PID}\n"
    }
    else {
        print "Not Running!\n";
    }

    exit 0;
}

# check if a reload request is sent
if ( $Opts{a} && $Opts{a} eq "reload" ) {

    # create common objects
    my %CommonObject = _CommonObjects();

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # no proces ID means that is not running
    if ( !%PID ) {
        print "Can't get OTRS Scheduler status because is not running!\n";
        exit 1;
    }

    # send interrupt signal to the proces ID to stop it
    kill( 1, $PID{PID} );

    # log daemon stop
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Scheduler Daemon reload request! PID $PID{PID}",
    );
    exit 0;
}

# check if start request is sent
elsif ( $Opts{a} && $Opts{a} eq "start" ) {

    {

        # create common objects
        my %CommonObject = _CommonObjects();

        # check for force to start option
        # check if PID is already there
        if ( $CommonObject{PIDObject}->PIDGet( Name => 'otrs.Scheduler' ) ) {
            if ( !$Opts{f} ) {
                print
                    "NOTICE: otrs.Scheduler.pl is already running (use '-f 1' if you want to start it\n";
                print "forced)!\n";

                # log daemon already running
                $CommonObject{LogObject}->Log(
                    Priority => 'error',
                    Message =>
                        "Scheduler Daemon tries to start but there is a running Daemon already!\n",
                );
                exit 1;
            }
            elsif ( $Opts{f} ) {
                print "NOTICE: otrs.Scheduler.pl is already running but is starting again!\n";

                # log daemon forced start
                $CommonObject{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "Scheduler Daemon is forced to Start!",
                );
            }
        }

        # get detault log path from configuration
        my $LogPath = $CommonObject{ConfigObject}->Get('Scheduler::LogPath') || '/tmp';

        # create a new daemon object
        my $Daemon = Proc::Daemon->new();

        # demonize itself
        $Daemon->Init(
            {
                child_STDOUT => $LogPath . '/SchedulerOUT.log',
                child_STDERR => $LogPath . '/SchedulerERR.log',
            }
        );
    }

    # create common objects
    my %CommonObject = _CommonObjects();

    # create new PID on the Database
    $CommonObject{PIDObject}->PIDCreate( Name => 'otrs.Scheduler' );

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # Log deamon startup
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Scheduler Daemon Start! PID $PID{PID}",
    );

    my $Interrupt;
    my $Hangup;

    # when we get a INT signal, set the exit flag
    $SIG{INT} = sub { $Interrupt = 1 };

    # when get a HUP signal, set HUP flag
    $SIG{HUP} = sub { $Hangup = 1 };

    # main loop
    while (1) {

        # create common objects
        my %CommonObject = _CommonObjects();

        # check for stop signal
        exit if $Interrupt;

        # check for hangup signal
        _Hangup() if $Hangup;
        $Hangup = 0;

        # sleep to avoid overloading the processor
        sleep $SleepTime;

        # check for stop signal (again)
        exit if $Interrupt;

        # check for hangup signal
        _Hangup() if $Hangup;
        $Hangup = 0;

        # Call Scheduler
        my $SchedulerObject = Kernel::Scheduler->new(%CommonObject);
        $SchedulerObject->Run();
    }

    exit 0;
}

# invalid option, show help
else {
    _help();
    exit 1;
}

exit 1;

# Internal
sub _help {
    print "otrs.Scheduler.pl <Revision $VERSION> - OTRS Schaduler Deamon\n";
    print "Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
    print "usage: otrs.Scheduler.pl -a <ACTION> (start|stop|status) [-f force]\n";
}

sub _Hangup {

    # TODO Implement
}

sub _CommonObjects {
    my %CommonObject;
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'otrs.Scheduler',
        %CommonObject,
    );
    $CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
    $CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
    $CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
    $CommonObject{PIDObject}  = Kernel::System::PID->new(%CommonObject);
    return %CommonObject;
}
