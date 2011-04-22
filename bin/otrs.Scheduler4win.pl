#!/usr/bin/perl -w
# --
# otrs.Scheduler4win.pl - provides Scheduler daemon control on Microsoft Windows OS
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: otrs.Scheduler4win.pl,v 1.12 2011-04-22 19:45:59 cr Exp $
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
$VERSION = qw($Revision: 1.12 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::PID;
use Kernel::Scheduler;
use Win32::Daemon;
use Win32::Service;

# to store service name
my $Service = 'OTRSScheduler';

# to store the service status, needs to be an explcit hash ref
my $ServiceStatus = {};

# get options
my %Opts = ();
getopt( 'haf', \%Opts );

# check if is running on windows
if ( $^O ne "MSWin32" ) {
    die "This program only works in Microsoft Windows!, use otrs.Scheduler.pl instead";
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

    if ( $Opts{f} ) {

        # delete pid lock
        my $PIDDelSuccess = $CommonObject{PIDObject}->PIDDelete( Name => 'otrs.Scheduler' );
    }
    else {

        # get the process ID
        my %PID = $CommonObject{PIDObject}->PIDGet(
            Name => 'otrs.Scheduler',
        );

        # no proces ID means that is not running
        if ( !%PID ) {
            print "Can't stop OTRS Scheduler because is not running!\n";
            exit 1;
        }
    }

    # stop the scheduler service (same as "stop"" in service control manger)
    Win32::Service::StopService( '', $Service );
}
elsif ( $Opts{a} && $Opts{a} eq "servicestop" ) {

    # stop the schduler process
    _stop();
}
elsif ( $Opts{a} && $Opts{a} eq "status" ) {
    _status();
}
elsif ( $Opts{a} && $Opts{a} eq "start" ) {

    # create common objects
    my %CommonObject = _CommonObjects();

    # get current service status
    Win32::Service::GetStatus( '', $Service, $ServiceStatus );

    # could it bee that the service is stopping
    while ( $ServiceStatus->{CurrentState} eq 3 ) {
        Win32::Service::GetStatus( '', $Service, $ServiceStatus );
        sleep 1;
    }

    # check for force to start option
    # check if PID is already there
    if ( $CommonObject{PIDObject}->PIDGet( Name => 'otrs.Scheduler' ) ) {
        if ( !$Opts{f} ) {
            print
                "NOTICE: otrs.Scheduler4win.pl is already running (use '-force' if you want to start it\n";
            print "forced)!\n";

            # log daemon already running
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Scheduler service tries to start but there is a running service already!\n",
            );
            exit 1;
        }
        elsif ( $Opts{f} ) {
            print "NOTICE: otrs.Scheduler4win.pl is already running but is starting again!\n";

            # log daemon forced start
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler Daemon is forced to Start!",
            );
        }
    }

    # start the scheduler service (same as "play" in service control manager)
    Win32::Service::StartService( '', $Service );
}
elsif ( $Opts{a} && $Opts{a} eq "servicestart" ) {

    # start the scheduler process
    _start();
}

# Internal
sub _help {
    print "otrs.Scheduler4win.pl <Revision $VERSION> - OTRS Schaduler Deamon\n";
    print "Copyright (C) 2001-2011 OTRS AG, http://otrs.org/\n";
    print "usage: otrs.Scheduler4win.pl -a <ACTION> (start|stop|status) [-f force]\n";
}

sub _start {

    # create common objects
    my %CommonObject = _CommonObjects();

    # create new PID on the Database
    $CommonObject{PIDObject}->PIDCreate( Name => 'otrs.Scheduler' );

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # get detault log path from configuration
    my $LogPath = $CommonObject{ConfigObject}->Get('Scheduler::LogPath')
        || '<OTRS_CONFIG_Home>/var/log';

    # set proper directory separators on windows
    $LogPath =~ s{/}{\\}g;

    # backup old logfiles
    my $FileStdOut = $LogPath . '\SchedulerOUT.log';
    my $FileStdErr = $LogPath . '\SchedulerERR.log';
    use File::Copy;
    my $SystemTime = $CommonObject{TimeObject}->SystemTime();
    if ( -e $FileStdOut ) {
        move( "$FileStdOut", "$LogPath/SchedulerOUT-$SystemTime.log" );
    }
    if ( -e $FileStdErr ) {
        move( "$FileStdErr", "$LogPath/SchedulerERR-$SystemTime.log" );
    }

    # delete old log files
    my $DaysToKeep = $CommonObject{ConfigObject}->Get('Scheduler::Log::DaysToKeep') || 10;
    my $DaysToKeepSystemTime
        = $CommonObject{TimeObject}->SystemTime() - $DaysToKeep * 24 * 60 * 60;

    my @LogFiles = <$LogPath/*.log>;

    LOGFILE:
    for my $LogFile (@LogFiles) {

        # skip if is not a backup file
        next LOGFILE if ( $LogFile !~ m{(?: .* /)* Scheduler (?: OUT|ERR ) - (\d+) \.log}igmx );

        # skip if is not older than the maximum allowed
        next LOGFILE if ( $1 > $DaysToKeepSystemTime );

        #delete file
        if ( unlink($LogFile) == 0 ) {

            # log old backup file cannot be deleted
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Scheduler could not delete old backup file $LogFile! $!",
            );

        }
        else {

            # log old backup file deleted
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler deleted old backup file $LogFile!",
            );
        }
    }

    my $AlreadyStarted;

    # sleep time between loop intervals in seconds
    my $SleepTime = $CommonObject{ConfigObject}->Get('Scheduler::SleepTime') || 1;

    my $RestartAfterSeconds = $CommonObject{ConfigObject}->Get('Scheduler::RestartAfterSeconds')
        || ( 60 * 60 * 24 );    # default 1 day

    my $StartTime = $CommonObject{TimeObject}->SystemTime();

    # get config checksum
    my $InitConfigMD5 = $CommonObject{ConfigObject}->ConfigChecksum();

    # start the service
    Win32::Daemon::StartService();

    # to store the current sevice state
    my $State;
    $State = Win32::Daemon::State();

    # Redirect STDOUT and STDERR to log file
    open( STDOUT, ">$FileStdOut" );
    open( STDERR, ">$FileStdErr" );

    # main loop
    while ( SERVICE_STOPPED != $State ) {

        # check if service is in start pending state
        if ( SERVICE_START_PENDING == $State ) {

            # Log service startup
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler service is Starting...!",
            );

            # set running state
            Win32::Daemon::State(SERVICE_RUNNING);
        }

        # check if service is in pause pending state
        elsif ( SERVICE_PAUSE_PENDING == $State ) {

            # Log service pause
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler service is Pausing...!",
            );

            # set paused state
            Win32::Daemon::State(SERVICE_PAUSED);
        }

        # check if service is in continue pending state
        elsif ( SERVICE_CONTINUE_PENDING == $State ) {

            # Log service resume
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler service Resuming...!",
            );

            # set running state
            Win32::Daemon::State(SERVICE_RUNNING);
        }

        # check if service is in stop pending state
        elsif ( SERVICE_STOP_PENDING == $State ) {

            # Log service stop
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler service is Stoping...!",
            );

            # set stop state
            Win32::Daemon::State(SERVICE_STOPPED);
        }

        # check if service is running
        elsif ( SERVICE_RUNNING == $State ) {

            if ( !$AlreadyStarted ) {
                $CommonObject{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "Scheduler service Start! PID $PID{PID}",
                );
                $AlreadyStarted = 1;
            }

            # get the process ID
            my %PID = $CommonObject{PIDObject}->PIDGet(
                Name => 'otrs.Scheduler',
            );

            # check if process ID was deleted from DB
            if ( !%PID ) {
                my $ExitCode = _AutoStop(
                    Message => "Process could not be found in the process table!\n"
                        . "Scheduler is stopping...!\n",
                );
                return $ExitCode;
            }

            # check if Framework.xml file exists, otherwise quits because the otrs instalation
            # might not be ok. for example UnitTest machines during change scenario process
            my $Home                = $CommonObject{ConfigObject}->Get('Home');
            my $FrameworkConfigFile = $Home . '/Kernel/Config/Files/Framework.xml';

            # convert FrameworkConfigFile path to windows format
            $FrameworkConfigFile =~ s{/}{\\}g;

            if ( !-e $FrameworkConfigFile ) {
                my $ExitCode = _AutoStop(
                    Message => "$FrameworkConfigFile file is part of the OTRS file set and "
                        . "is not present! \n"
                        . "Scheduler is stopping...!\n",
                    DeletePID => 1,
                );
                return $ExitCode;
            }

            # get config checksum
            my $CurrConfigMD5 = $CommonObject{ConfigObject}->ConfigChecksum();

            # check if cheksum changed and restart
            if ( $InitConfigMD5 ne $CurrConfigMD5 ) {

                my $ExitCode = _AutoRestart(
                    Message => "Config.pm changed, unsafe to continue! \n"
                        . "Scheduler is restarting...!\n",
                );
                exit $ExitCode;
            }

            # Call Scheduler
            my $SchedulerObject = Kernel::Scheduler->new(%CommonObject);
            $SchedulerObject->Run();

            my $CurrentTime = $CommonObject{TimeObject}->SystemTime();

            # The Scheduler needs to be restarted from time to time because
            #   of memory leaks in some external perl modules.
            if ( ( $CurrentTime - $StartTime ) > $RestartAfterSeconds ) {
                my $ExitCode = _AutoRestart(
                    Message => "Scheduler daemon restarts itself (PID $PID{PID})."
                );
                exit $ExitCode;
            }

        }

        # sleep to avoid overloading the processor
        sleep $SleepTime;
        $State = Win32::Daemon::State();
    }

    # stop the service
    _stop();
}

sub _stop {

    # create common objects
    my %CommonObject = _CommonObjects();

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # stop the service
    Win32::Daemon::StopService();

    # delete pid lock
    my $PIDDelSuccess = $CommonObject{PIDObject}->PIDDelete( Name => 'otrs.Scheduler' );

    # log daemon stop
    if ( !$PIDDelSuccess ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Process could not be deleted from process table! PID $PID{PID}",
        );
        exit 1;
    }
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Scheduler service Stop! PID $PID{PID}",
    );
    exit 0;
}

sub _status {

    # Windows service status table
    # 5 => 'The service continue is pending.',
    # 6 => 'The service pause is pending.',
    # 7 => 'The service is paused.',
    # 4 => 'The service is running.',
    # 2 => 'The service is starting.',
    # 3 => 'The service is stopping.',
    # 1 => 'The service is not running.',

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

    Win32::Service::GetStatus( '', $Service, $ServiceStatus );

    # check if service is starting (state 2)
    while ( $ServiceStatus->{CurrentState} eq 2 ) {
        Win32::Service::GetStatus( '', $Service, $ServiceStatus );
        sleep 1;
    }

    # check if service is runing (state 4)
    if ( $ServiceStatus->{CurrentState} eq 4 ) {
        print "Running $PID{PID}\n"
    }
    else {
        print
            "Not Running, but PID still registered! Use '-a stop -force' to unregister the PID from the database.\n";
    }

    exit 0;
}

sub _CommonObjects {
    my %CommonObject;
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-otrs.Scheduler',
        %CommonObject,
    );
    $CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
    $CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
    $CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
    $CommonObject{PIDObject}  = Kernel::System::PID->new(%CommonObject);
    return %CommonObject;
}

sub _AutoRestart {
    my %Param = @_;

    # create common objects
    my %CommonObject = _CommonObjects();

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # Log deamon startup
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message => $Param{Message} || 'Unknown reason to restart',
    );

    # delete pid lock
    my $PIDDelSuccess = $CommonObject{PIDObject}->PIDDelete( Name => $PID{Name} );

    my $ExitCode;
    if ( !$PIDDelSuccess ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message =>
                "Could not remove Scheduler PID $PID{PID} from database to prepare Scheduler restart, exiting.",
        );
        $ExitCode = 1;
        return $ExitCode;
    }

    # Send service control an stop message otherwise the execusion of a new scheduler will not be
    # success.
    Win32::Daemon::StopService();

    # log service stopping
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Schduler service is Stopping due a restart!!!.",
    );

    # get the scheduler information to restart
    my $Home      = $CommonObject{ConfigObject}->Get('Home');
    my $Scheduler = $Home . '/bin/otrs.Scheduler4win.pl';

    # convert Sceduler path to windows format
    $Scheduler =~ s{/}{\\}g;

    # create a new scheduler intance
    # this process could take more than 30 secons be aware of that!
    my $Result = system("\"$^X\" \"$Scheduler\" -a start");

    if ( !$Result ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not startup new Scheduler instance.",
        );

        $ExitCode = 1;
        return $ExitCode;
    }

    $ExitCode = 0;
    return $ExitCode;
}

sub _AutoStop {
    my %Param = @_;

    # create common objects
    my %CommonObject = _CommonObjects();

    if ( $Param{Message} ) {

        # log error
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => $Param{Message},
        );
    }

    my $ExitCode;
    if ( $Param{DeletePID} ) {

        # get the process ID
        my %PID = $CommonObject{PIDObject}->PIDGet(
            Name => 'otrs.Scheduler',
        );

        # delete pid lock
        my $PIDDelSuccess = $CommonObject{PIDObject}->PIDDelete( Name => $PID{Name} );

        # log daemon stop
        if ( !$PIDDelSuccess ) {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Process could not be deleted from process table! PID $PID{PID}",
            );
            $ExitCode = 1;
            Win32::Daemon::StopService();
            return $ExitCode;
        }

        $ExitCode = 0;
        Win32::Daemon::StopService();
        return $ExitCode;
    }
    $ExitCode = 1;
    Win32::Daemon::StopService();
    return $ExitCode;

}
