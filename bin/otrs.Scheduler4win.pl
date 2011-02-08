#!/usr/bin/perl -w
# --
# otrs.Scheduler4win.pl - provides Scheduler daemon control on Microsoft Windows OS
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: otrs.Scheduler4win.pl,v 1.1 2011-02-08 16:44:25 cr Exp $
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
$VERSION = qw($Revision: 1.1 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::PID;
use Kernel::System::Scheduler;
use Win32::Daemon;

# get options
my %Opts = ();
getopt( 'ha', \%Opts );

# check if is running on windows
if ( $^O ne "MSWin32" ) {
    die "This program only works in Microsoft Windows!, use otrs.Scheduler.pl instead";
}

# help option
if ( $Opts{h} ) {
    _help();
    exit 1;
}

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'otrs.Scheduler',
    %CommonObject,
);
$CommonObject{MainObject}      = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}      = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}        = Kernel::System::DB->new(%CommonObject);
$CommonObject{PIDObject}       = Kernel::System::PID->new(%CommonObject);
$CommonObject{SchedulerObject} = Kernel::Scheduler->new(%CommonObject);

# check if a stop request is sent
if ( $Opts{a} && $Opts{a} eq "stop" ) {
    _stop();
}

# OS services control
else {

    # start the service
    _start();
}

# Internal
sub _help {
    print "otrs.Scheduler.pl <Revision $VERSION> - OTRS Schaduler Deamon\n";
    print "Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
    print "usage: otrs.Scheduler.pl -a <ACTION> (stop) ";
}

sub _start {

    # check for process running
    if ( !$CommonObject{PIDObject}->PIDCreate( Name => 'otrs.Scheduler' ) ) {
        print "NOTICE: otrs.Scheduler.pl is already running (use 'otrs.Sehduler4win.pl -a stop' ";
        print "to stop se service correctly)!\n";

        # log service already running
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Scheduler Service tries to start but there is a running Service already!",
        );

        exit 1;
    }

    # start the service
    Win32::Daemon::StartService();

    # to stroe the current sevice state
    my $State;
    $State = Win32::Daemon::State();

    # main loop
    while ( SERVICE_STOPPED != $State ) {

        # check if service is in start pending state
        if ( SERVICE_START_PENDING == $State ) {

            # Log service startup
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler Service Start!",
            );

            # set running state
            Win32::Daemon::State(SERVICE_RUNNING);
        }

        # check if service is in pause pending state
        elsif ( SERVICE_PAUSE_PENDING == $State ) {

            # Log service pause
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler Service Paused!",
            );

            # set paused state
            Win32::Daemon::State(SERVICE_PAUSED);
        }

        # check if service is in continue pending state
        elsif ( SERVICE_CONTINUE_PENDING == $State ) {

            # Log service resume
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler Service Resumeed!",
            );

            # set running state
            Win32::Daemon::State(SERVICE_RUNNING);
        }

        # check if service is in stop pending state
        elsif ( SERVICE_STOP_PENDING == $State ) {

            # Log service stop
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler Service Stop!",
            );

            # set stop state
            Win32::Daemon::State(SERVICE_STOPPED);
        }

        # check if service is running
        elsif ( SERVICE_RUNNING == $State ) {

            # Call Scheduler
            # Calls to $CommonObject{SchedulerObject} must be placed here!
        }

        # sleep to don't overload the processor
        sleep(5);

        $State = Win32::Daemon::State();
    }

    # stop the service
    _stop();
}

sub _stop {

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # no proces ID means that is not running
    if ( !%PID ) {
        print "Can't stop OTRS Scheduler because is not running!\n";
        exit 1;
    }

    # stop the service
    Win32::Daemon::StopService();

    print "try to start the OTRS Scheduler service again from the Services interface!\n";

    # delete pid lock
    $CommonObject{PIDObject}->PIDDelete( Name => 'otrs.Scheduler' );
    exit 1;
}
