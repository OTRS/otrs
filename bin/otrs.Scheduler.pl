#!/usr/bin/perl -w
# --
# otrs.Scheduler.pl - provides Scheduler daemon control on unlix like OS
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: otrs.Scheduler.pl,v 1.3 2011-02-14 10:33:51 cr Exp $
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
$VERSION = qw($Revision: 1.3 $) [1];

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

# get options
my %Opts = ();
getopt( 'hfa', \%Opts );

# check if is running on windows
if ( $^O eq "MSWin32" ) {
    print "This program cannot run in Microsoft Windows!, use otrs.Scheduler4win.pl instead.";
    exit 1;
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
        Message  => "Scheduler Daemon Stop $PID{PID}!",
    );

    exit 1;
}

# check if start request is sent
elsif ( $Opts{a} && $Opts{a} eq "start" ) {

    # check for force to start option
    # check if PID is already there
    if ( $CommonObject{PIDObject}->PIDGet( Name => 'otrs.Scheduler' ) ) {
        if ( !$Opts{f} ) {
            print
                "NOTICE: otrs.Scheduler.pl is already running (use '-f 1' if you want to start it ";
            print "forced)!\n";

            # log daemon already running
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message => "Scheduler Daemon tries to start but there is a running Daemon already!",
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

    # demonize itself
    Proc::Daemon::Init();

    # refresh database conection
    $CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);

    # create new PID on the Database
    $CommonObject{PIDObject}->PIDCreate( Name => 'otrs.Scheduler' );

    # Log deamon startup
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Scheduler Daemon Start!",
    );

    my $Interrupt;

    # when we get a INT signal, set the exit flag
    $SIG{INT} = sub { $Interrupt = 1 };

    # main loop
    while (1) {

        # check for stop signal
        exit if $Interrupt;

        # sleep to don't overload the processor
        sleep 5;

        # check for stop signal (again)
        exit if $Interrupt;

        # Call Scheduler
        $CommonObject{SchedulerObject}->Run();
    }
}

# invalid option, show help
else {
    _help();
}

# Internal
sub _help {
    print "otrs.Scheduler.pl <Revision $VERSION> - OTRS Schaduler Deamon\n";
    print "Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
    print "usage: otrs.Scheduler.pl -a <ACTION> (start|stop) [-f force] ";
}
