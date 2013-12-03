#!/usr/bin/perl
# --
# otrs.WebServer4win.pl - provides Web Server Daemon control for Microsoft Windows OS
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
use Plack::Runner;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;

# to store service name
my $Service = 'OTRSWebServer';

# to store the service status, needs to be an explicit hash ref
my $ServiceStatus = {};

# get options
my %Opts = ();
getopt( 'haf', \%Opts );

BEGIN {

    # check if is running on windows
    if ( $^O ne "MSWin32" ) {

        # nofilter(TidyAll::Plugin::OTRS::Perl::SyntaxCheck)
        print "This program only works on Microsoft Windows.\n";
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
        print "To be able to start or stop the Web Server, call the script with UAC enabled.\n";
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

    # stop the Web Server Service (same as "stop"" in service control manger)
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

    # stop the Web Server Service
    _Stop();
}

# check if a status request is sent
elsif ( $Opts{a} && $Opts{a} eq "status" ) {

    # query service status
    _Status();
}

# check if a reload request is sent
elsif ( $Opts{a} && $Opts{a} eq "reload" ) {

    # create common objects
    my %CommonObject = _CommonObjects();

    # log daemon reload request
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Web Server reload request",
    );

    # stop the Web Server Service (same as "stop" in service control manger)
    # can't use Win32::Daemon because is called from outside
    Win32::Service::StopService( '', $Service );

    # needs to wait until the service is stopped completely
    # this value could be changed if needed or check the status
    sleep 2;

    # start the Web Server Service (same as "play" in service control manager)
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

    # start the Web Server Service (same as "play" in service control manager)
    # cant use Win32::Daemon because is called from outside
    Win32::Service::StartService( '', $Service );
}

# check if a service start request is sent (This is usually called by SCM)
elsif ( $Opts{a} && $Opts{a} eq "servicestart" ) {

    # start the server process
    _Start();
}

# otherwise show help
else {

    # help option
    _Help();
}

# Internal
sub _Help {
    print "otrs.WebServer4win.pl - OTRS Web Server Daemon for Windows\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.WebServer4win.pl -a <ACTION> (start|stop|status|reload) [-f force]\n";
}

sub _Start {

    # create common objects

    my %CommonObject = _CommonObjects();

    # get default log path from configuration
    my $LogPath = $CommonObject{ConfigObject}->Get('Home') . '/var/log';

    # set proper directory separators on windows
    $LogPath =~ s{/}{\\}g;

    # backup old log files
    my $FileStdOut = $LogPath . '\WebServerOUT.log';
    my $FileStdErr = $LogPath . '\WebServerERR.log';
    use File::Copy;
    my $SystemTime = $CommonObject{TimeObject}->SystemTime();
    if ( -e $FileStdOut ) {
        move( "$FileStdOut", "$LogPath/WebServerOUT-$SystemTime.log" );
    }
    if ( -e $FileStdErr ) {
        move( "$FileStdErr", "$LogPath/WebServerERR-$SystemTime.log" );
    }

    # delete old log files
    my $DaysToKeep = 10;
    my $DaysToKeepSystemTime
        = $CommonObject{TimeObject}->SystemTime() - $DaysToKeep * 24 * 60 * 60;

    my @LogFiles = glob("$LogPath/*.log");

    LOGFILE:
    for my $LogFile (@LogFiles) {

        # skip if is not a backup file
        next LOGFILE if ( $LogFile !~ m{(?: .* /)* WebServer (?: OUT|ERR ) - (\d+) \.log}igmx );

        # skip if is not older than the maximum allowed
        next LOGFILE if ( $1 > $DaysToKeepSystemTime );

        # delete file
        if ( unlink($LogFile) == 0 ) {

            # log old backup file cannot be deleted
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message  => "Web Server could not delete old backup file $LogFile! $!",
            );

        }
        else {

            # log old backup file deleted
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Web Server deleted old backup file $LogFile!",
            );
        }
    }

    # a flag to only log running status once
    my $AlreadyStarted;

    # sleep time between loop intervals in seconds
    my $SleepTime = 1;

    my $RestartAfterSeconds = ( 60 * 60 * 24 );    # default 1 day

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
                Message  => "Web Server Service is starting...!",
            );

            # set running state
            Win32::Daemon::State(SERVICE_RUNNING);
        }

        # check if service is in pause pending state
        elsif ( SERVICE_PAUSE_PENDING == $State ) {

            # Log service pause
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Web Server Service is pausing...!",
            );

            # set paused state
            Win32::Daemon::State(SERVICE_PAUSED);
        }

        # check if service is in continue pending state
        elsif ( SERVICE_CONTINUE_PENDING == $State ) {

            # Log service resume
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Web Server Service resuming...!",
            );

            # set running state
            Win32::Daemon::State(SERVICE_RUNNING);
        }

        # check if service is in stop pending state
        elsif ( SERVICE_STOP_PENDING == $State ) {

            # Log service stop
            $CommonObject{LogObject}->Log(
                Priority => 'notice',
                Message  => "Web Server Service is stopping...!",
            );

            # set stop state
            Win32::Daemon::State(SERVICE_STOPPED);
        }

        # check if service is running
        elsif ( SERVICE_RUNNING == $State ) {

            if ( !$AlreadyStarted ) {
                $CommonObject{LogObject}->Log(
                    Priority => 'notice',
                    Message  => "Web Server Service start!",
                );
                $AlreadyStarted = 1;
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
                        . "Web Server is stopping...!\n",
                );
                return $ExitCode;
            }

            # run Webserver
            my $Runner = Plack::Runner->new();
            $Runner->parse_options(
                '--port' => 80,
                $CommonObject{ConfigObject}->Get('Home') . '/bin/cgi-bin/app.psgi'
            );
            $Runner->run();
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

    # stop the service (this can be called because is part of the main loop)
    Win32::Daemon::StopService();

    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Web Server Service stop!",
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

    # log daemon stop
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Web Server Service status request!",
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
        print "Running\n"
    }
    else {
        print
            "Not running.\n";
        exit 1;
    }

    exit 0;
}

sub _CommonObjects {
    my %CommonObject;
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-otrs.WebServer',
        %CommonObject,
    );
    $CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
    $CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
    $CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
    return %CommonObject;
}

sub _AutoRestart {
    my (%Param) = @_;

    # create common objects
    my %CommonObject = _CommonObjects();

    # Log daemon start-up
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message => $Param{Message} || 'Unknown reason to restart',
    );

    # Send service control a stop message otherwise the execution of a new server will not be
    # successful. (this can be called because it is part of the same loop)
    Win32::Daemon::StopService();

    # log service stopping
    $CommonObject{LogObject}->Log(
        Priority => 'notice',
        Message  => "Web Server Service is stopping due a restart.",
    );

    # get the web server information to restart
    my $Home      = $CommonObject{ConfigObject}->Get('Home');
    my $WebServer = $Home . '/bin/otrs.WebServer4win.pl';

    # convert WebServer path to windows format
    $WebServer =~ s{/}{\\}g;

    # create a new web server instance
    # this process could take a couple of seconds be aware of that!
    # needs a separate process
    my $Result = system("\"$^X\" \"$WebServer\" -a start");

    if ( !$Result ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not start-up new Web Server instance.",
        );

        return 1;
    }

    return 0;
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

    # this can be called because it is in the same loop
    return Win32::Daemon::StopService();
}
