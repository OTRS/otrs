#!/usr/bin/perl
# --
# otrs.Scheduler4win.pl - provides Scheduler Daemon control for Microsoft Windows OS
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

## nofilter(TidyAll::Plugin::OTRS::Perl::Require)

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::PID;
use Kernel::Scheduler;

# to store service name
my $Service = 'OTRSScheduler';

# to store the service status, needs to be an explicit hash ref
my $ServiceStatus = {};

# get options
my %Opts = ();
getopt( 'haf', \%Opts );

BEGIN {

    # check if is running on windows
    if ( $^O ne "MSWin32" ) {
        print "This program only works on Microsoft Windows, use otrs.Scheduler.pl instead.\n";
        exit 1;
    }
}

# load windows specific modules
use Win32::Daemon;
use Win32::Service;

# starting and stopping can only be done with UAC enabled
if ( $Opts{a} && ( $Opts{a} eq "start" || $Opts{a} eq "stop" ) ) {
    require Win32;    ## no critic

    if ( !Win32::IsAdminUser() ) {
        print "To be able to start or stop the Scheduler, call the script with UAC enabled.\n";
        print "(right-click CMD, select \'Run as administrator\').\n";
        exit 2;
    }
}

# help option
if ( $Opts{h} ) {
    _Help();
    exit 0;
}

# check if a stop request is sent
if ( $Opts{a} && $Opts{a} eq "stop" ) {

    # create common objects
    my %CommonObject = _CommonObjects();

    if ( $Opts{f} ) {

        # delete process ID lock
        my $PIDDelSuccess = $CommonObject{PIDObject}->PIDDelete( Name => 'otrs.Scheduler' );
    }
    else {

        # get the process ID
        my %PID = $CommonObject{PIDObject}->PIDGet(
            Name => 'otrs.Scheduler',
        );

        # no process ID means that is not running
        if ( !%PID ) {
            print "OTRS scheduler was already in stopped state.\n";
            exit 1;
        }
    }

    # stop the scheduler service (same as "stop"" in service control manger)
    # cant use Win32::Daemon because is called from outside
    my $Result = Win32::Service::StopService( '', $Service );

    # sleep to let service stop successfully
    sleep 2;

    if ($Result) {
        exit 0;
    }
    exit 1;
}

# check if a stop service request is sent (this should be called by SCM)
elsif ( $Opts{a} && $Opts{a} eq "servicestop" ) {

    # stop the scheduler service
    _Stop();
}

# check if a status request is sent
elsif ( $Opts{a} && $Opts{a} eq "status" ) {

    # query scheduler status
    _Status();
}

# check if a reload request is sent
elsif ( $Opts{a} && $Opts{a} eq "reload" ) {

    # create common objects
    my %CommonObject = _CommonObjects();

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # no process ID means that is not running
    if ( !%PID ) {
        print "Can't get OTRS Scheduler status, it is not running!\n";
        exit 1;
    }

    # log daemon reload request
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Scheduler Service reload request: PID $PID{PID}",
    );

    # stop the scheduler service (same as "stop" in service control manger)
    # can't use Win32::Daemon because is called from outside
    Win32::Service::StopService( '', $Service );

    # needs to wait until the service is stopped completely
    # this value could be changed if needed or check the status
    sleep 2;

    # delete process ID lock
    my $PIDDelSuccess = $CommonObject{PIDObject}->PIDDelete( Name => $PID{Name} );

    # start the scheduler service (same as "play" in service control manager)
    # can't use Win32::Daemon because it is called from outside
    Win32::Service::StartService( '', $Service );

    exit 0;
}

# check if a start request is sent
elsif ( $Opts{a} && $Opts{a} eq "start" ) {

    # create common objects
    my %CommonObject = _CommonObjects();

    # get current service status
    # can't use Win32::Daemon because it is called from outside
    Win32::Service::GetStatus( '', $Service, $ServiceStatus );

    # check if the service is stopping
    while ( $ServiceStatus->{CurrentState} && $ServiceStatus->{CurrentState} eq 3 ) {
        Win32::Service::GetStatus( '', $Service, $ServiceStatus );
        sleep 1;
    }

    # check if PID is already there
    my %PID = $CommonObject{PIDObject}->PIDGet( Name => 'otrs.Scheduler' );

    if (%PID) {

        # get the PID update time
        my $PIDUpdateTime =
            $CommonObject{ConfigObject}->Get('Scheduler::PIDUpdateTime') || 60.0;

        # get current time
        my $Time = time();

        # calculate time difference
        my $DeltaTime = $Time - $PID{Changed};

        # remove PID if changed time is greater than
        if ( $DeltaTime > $PIDUpdateTime ) {

            # _AutoStop returns an exit code for the OS, we need the opposit value
            my $PIDDeleteSuccess = !_AutoStop(
                Message => 'NOTICE: otrs.Scheduler4win.pl is registered in the DB, but the '
                    . 'registry has not been updated in ' . $DeltaTime . ' seconds!. '
                    . 'The registration will be deleted so the Scheduler can start again without '
                    . 'forcing',
                DeletePID => 1,
            );

            if ($PIDDeleteSuccess) {
                %PID = ();
            }
        }
    }

    # check for force to start option
    if (%PID) {

        if ( !$Opts{f} ) {
            print
                "NOTICE: otrs.Scheduler4win.pl is already running (use '-force' if you want to start it\n";
            print "forced)!\n";

            # log daemon already running
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message =>
                    "Scheduler Service tried to start but found an already running service!\n",
            );
            exit 1;
        }
        elsif ( $Opts{f} ) {
            print
                "NOTICE: otrs.Scheduler4win.pl was already running but is starting again (force was used)!\n";

            # log daemon forced start
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler Service is forced to start!",
            );
        }
    }

    # start the scheduler service (same as "play" in service control manager)
    # cant use Win32::Daemon because is called from outside
    Win32::Service::StartService( '', $Service );
}

# check if a service start request is sent (This is usually called by SCM)
elsif ( $Opts{a} && $Opts{a} eq "servicestart" ) {

    # start the scheduler process
    _Start();
}

# otherwise show help
else {

    # help option
    _Help();
}

# Internal
sub _Help {
    print "otrs.Scheduler4win.pl - OTRS Scheduler Daemon\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.Scheduler4win.pl -a <ACTION> (start|stop|status|reload) [-f force]\n";
}

sub _Start {

    # create common objects

    my %CommonObject = _CommonObjects();

    # create new PID on the Database
    $CommonObject{PIDObject}->PIDCreate( Name => 'otrs.Scheduler' );

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # get default log path from configuration
    my $LogPath = $CommonObject{ConfigObject}->Get('Scheduler::LogPath')
        || '<OTRS_CONFIG_Home>/var/log';

    # set proper directory separators on windows
    $LogPath =~ s{/}{\\}g;

    # backup old log files
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

    my @LogFiles = glob("$LogPath/*.log");

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

    # a flag to only log running status once
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

    # to store the current service state
    my $State;
    $State = Win32::Daemon::State();

    # Redirect STDOUT and STDERR to log file
    open( STDOUT, ">", $FileStdOut );    ## no critic
    open( STDERR, ">", $FileStdErr );    ## no critic

    # main service loop
    while ( SERVICE_STOPPED != $State ) {

        # check if service is in start pending state
        if ( SERVICE_START_PENDING == $State ) {

            # Log service start-up
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler Service is starting...!",
            );

            # set running state
            Win32::Daemon::State(SERVICE_RUNNING);
        }

        # check if service is in pause pending state
        elsif ( SERVICE_PAUSE_PENDING == $State ) {

            # Log service pause
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler Service is pausing...!",
            );

            # set paused state
            Win32::Daemon::State(SERVICE_PAUSED);
        }

        # check if service is in continue pending state
        elsif ( SERVICE_CONTINUE_PENDING == $State ) {

            # Log service resume
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler Service resuming...!",
            );

            # set running state
            Win32::Daemon::State(SERVICE_RUNNING);
        }

        # check if service is in stop pending state
        elsif ( SERVICE_STOP_PENDING == $State ) {

            # Log service stop
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Scheduler Service is stopping...!",
            );

            # set stop state
            Win32::Daemon::State(SERVICE_STOPPED);
        }

        # check if service is running
        elsif ( SERVICE_RUNNING == $State ) {

            if ( !$AlreadyStarted ) {
                $CommonObject{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "Scheduler Service start! PID $PID{PID}",
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

            # check if Framework.xml file exists, otherwise quits because the otrs installation
            # might not be OK. for example UnitTest machines during change scenario process
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

            # check if checksum changed and restart
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
                    Message => "Scheduler Service restarts itself (PID $PID{PID})."
                );
                exit $ExitCode;
            }

        }

        # sleep to avoid overloading the processor
        sleep $SleepTime;
        $State = Win32::Daemon::State();
    }

    # stop the service
    _Stop();
}

sub _Stop {

    # create common objects

    my %CommonObject = _CommonObjects();

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # stop the service (this can be called because is part of the main loop)
    Win32::Daemon::StopService();

    # delete process ID lock
    my $PIDDelSuccess = $CommonObject{PIDObject}->PIDDelete( Name => 'otrs.Scheduler' );

    sleep 2;

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
        Message  => "Scheduler Service stop! PID $PID{PID}",
    );
    exit 0;
}

sub _Status {

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

    # no process ID means that is not running
    if ( !%PID ) {
        print "Not running!\n";
        exit 1;
    }

    # log daemon stop
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Scheduler Service status request! PID $PID{PID}",
    );

    # this call is from outside, can't use Win32::Daemon
    Win32::Service::GetStatus( '', $Service, $ServiceStatus );

    # check if service is starting (state 2)
    while ( $ServiceStatus->{CurrentState} eq 2 ) {
        Win32::Service::GetStatus( '', $Service, $ServiceStatus );
        sleep 1;
    }

    # check if service is running (state 4)
    if ( $ServiceStatus->{CurrentState} eq 4 ) {
        print "Running $PID{PID}\n"
    }
    else {
        print
            "Not running, but PID still registered! Use '-a stop -force' to unregister the PID from the database.\n";
        exit 1;
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
    my (%Param) = @_;

    # create common objects
    my %CommonObject = _CommonObjects();

    # get the process ID
    my %PID = $CommonObject{PIDObject}->PIDGet(
        Name => 'otrs.Scheduler',
    );

    # Log daemon start-up
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message => $Param{Message} || 'Unknown reason to restart',
    );

    # delete process ID lock
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

    # Send service control a stop message otherwise the execution of a new scheduler will not be
    # successful. (this can be called because it is part of the same loop)
    Win32::Daemon::StopService();

    # log service stopping
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Scheduler service is stopping due a restart.",
    );

    # get the scheduler information to restart
    my $Home      = $CommonObject{ConfigObject}->Get('Home');
    my $Scheduler = $Home . '/bin/otrs.Scheduler4win.pl';

    # convert Scheduler path to windows format
    $Scheduler =~ s{/}{\\}g;

    # create a new scheduler instance
    # this process could take more than 30 seconds be aware of that!
    # needs a separate process
    my $Result = system("\"$^X\" \"$Scheduler\" -a start");

    if ( !$Result ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not start-up new Scheduler instance.",
        );

        $ExitCode = 1;
        return $ExitCode;
    }

    $ExitCode = 0;
    return $ExitCode;
}

sub _AutoStop {
    my (%Param) = @_;

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

        # delete process ID lock
        my $PIDDelSuccess = $CommonObject{PIDObject}->PIDDelete( Name => $PID{Name} );

        # log daemon stop
        if ( !$PIDDelSuccess ) {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Process could not be deleted from process table! PID $PID{PID}",
            );
            $ExitCode = 1;

            # this can be called because it is in the same loop
            Win32::Daemon::StopService();
            return $ExitCode;
        }

        $ExitCode = 0;

        # this can be called because it is in the same loop
        Win32::Daemon::StopService();
        return $ExitCode;
    }
    $ExitCode = 1;

    # this can be called because it is in the same loop
    Win32::Daemon::StopService();
    return $ExitCode;
}
