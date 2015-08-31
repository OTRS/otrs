#!/usr/bin/perl -X
# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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
use utf8;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use File::Path qw();
use Time::HiRes qw(sleep);
use Fcntl qw(:flock);

use Kernel::System::ObjectManager;

print STDOUT "otrs.Daemon.pl - the otrs daemon\n";
print STDOUT "Copyright (C) 2001-2015 OTRS AG, http://otrs.com/\n\n";

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.Daemon.pl',
    },
);

# Don't allow to run these scripts as root.
if ( $> == 0 ) {    # $EFFECTIVE_USER_ID
    print STDERR
        "Error: You cannot run otrs.Damon.pl as root. Please run it as the 'otrs' user or with the help of su:\n";
    print STDERR "  su -c \"bin/otrs.Daemon.pl ...\" -s /bin/bash otrs\n";
    exit 1;
}

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get the NodeID from the SysConfig settings, this is used on High Availability systems.
my $NodeID = $ConfigObject->Get('NodeID') || 1;

# check NodeID, if does not match its impossible to continue
if ( $NodeID !~ m{ \A \d+ \z }xms && $NodeID > 0 && $NodeID < 1000 ) {
    print STDERR "NodeID '$NodeID' is invalid. Change the NodeID to a number between 1 and 999.";
    exit 1;
}

# get pid directory
my $PIDDir  = $ConfigObject->Get('Home') . '/var/run/';
my $PIDFile = $PIDDir . "Daemon-NodeID-$NodeID.pid";
my $PIDFH;

# get default log directory
my $LogDir = $ConfigObject->Get('Daemon::Log::LogPath') || $ConfigObject->Get('Home') . '/var/log/Daemon';

if ( !-d $LogDir ) {
    File::Path::mkpath( $LogDir, 0, 0770 );    ## no critic

    if ( !-d $LogDir ) {
        print STDERR "Failed to create path: $LogDir";
        exit 1;
    }
}

if ( !@ARGV ) {
    PrintUsage();
    exit 0;
}

# check for debug mode
my %DebugDaemons;
my $Debug;
if ( $ARGV[1] && lc $ARGV[1] eq '--debug' ) {
    $Debug = 1;

    # if no more arguments, then use debug mode for all daemons
    if ( !$ARGV[2] ) {
        $DebugDaemons{All} = 1;
    }

    # otherwise set debug mode specific for named daemons
    else {

        ARGINDEX:
        for my $ArgIndex ( 2 .. 99 ) {

            # stop checking if there are no more arguments
            last ARGINDEX if !$ARGV[$ArgIndex];

            # remember debug mode for each daemon
            $DebugDaemons{ $ARGV[$ArgIndex] } = 1;
        }
    }
}
elsif ( $ARGV[1] ) {
    print STDERR "Invalid option: $ARGV[1]\n\n";
    PrintUsage();
    exit 0;
}

# check for action
if ( lc $ARGV[0] eq 'start' ) {
    exit 1 if !Start();
    exit 0;
}
elsif ( lc $ARGV[0] eq 'stop' ) {

    exit 1 if !Stop();
    exit 0;
}
elsif ( lc $ARGV[0] eq 'status' ) {

    exit 1 if !Status();
    exit 0;
}
else {
    PrintUsage();
    exit 0;
}

sub PrintUsage {
    my $UsageText = "Usage:\n";
    $UsageText .= " otrs.Daemon.pl <ACTION> [--debug]\n";
    $UsageText .= "\nActions:\n";
    $UsageText .= sprintf " %-30s - %s", 'start', 'Starts the daemon process' . "\n";
    $UsageText .= sprintf " %-30s - %s", 'stop', 'Stops the daemon process' . "\n";
    $UsageText .= sprintf " %-30s - %s", 'status', 'Shows daemon process current state' . "\n";
    $UsageText .= sprintf " %-30s - %s", 'help', 'Shows this help screen' . "\n";
    $UsageText .= "\nNote:\n";
    $UsageText
        .= " In debug mode if a daemon module is specified the debug mode will be activated only for that daemon.\n";
    $UsageText .= " Debug information is stored in the daemon log files localed under: $LogDir\n";
    $UsageText .= "\n otrs.Daemon.pl start --debug SchedulerTaskWorker SchedulerCronTaskManager\n";

    print STDOUT "$UsageText\n";

    return 1;
}

sub Start {

    # create a fork of the current process
    # parent gets the PID of the child
    # child gets PID = 0
    my $DaemonPID = fork;

    # check if fork was not possible
    die "Can not create daemon process: $!" if !defined $DaemonPID || $DaemonPID < 0;

    # close parent gracefully
    exit 0 if $DaemonPID;

    # lock PID
    my $LockSuccess = _PIDLock();

    if ( !$LockSuccess ) {
        print "Daemon already running!\n";
        exit 0;
    }

    # get daemon modules from SysConfig
    my $DaemonModuleConfig = $Kernel::OM->Get('Kernel::Config')->Get('DaemonModules') || {};

    # create daemon module hash
    my %DaemonModules;
    MODULE:
    for my $Module ( sort keys %{$DaemonModuleConfig} ) {

        next MODULE if !$Module;
        next MODULE if !$DaemonModuleConfig->{$Module};
        next MODULE if ref $DaemonModuleConfig->{$Module} ne 'HASH';
        next MODULE if !$DaemonModuleConfig->{$Module}->{Module};

        $DaemonModules{ $DaemonModuleConfig->{$Module}->{Module} } = {
            PID  => 0,
            Name => $Module,
        };
    }

    my $DaemonChecker = 1;
    local $SIG{INT}  = sub { $DaemonChecker = 0; };
    local $SIG{TERM} = sub { $DaemonChecker = 0; };
    local $SIG{CHLD} = "IGNORE";

    print STDOUT "Daemon started\n";
    if ($Debug) {
        print STDOUT "\nDebug information is stored in the daemon log files localed under: $LogDir\n\n";
    }

    while ($DaemonChecker) {

        MODULE:
        for my $Module ( sort keys %DaemonModules ) {

            next MODULE if !$Module;

            # check if daemon is still alive
            if ( $DaemonModules{$Module}->{PID} && !kill 0, $DaemonModules{$Module}->{PID} ) {
                $DaemonModules{$Module}->{PID} = 0;
            }

            next MODULE if $DaemonModules{$Module}->{PID};

            # fork daemon process
            my $ChildPID = fork;

            if ( !$ChildPID ) {

                my $ChildRun = 1;
                local $SIG{INT}  = sub { $ChildRun = 0; };
                local $SIG{TERM} = sub { $ChildRun = 0; };
                local $SIG{CHLD} = "IGNORE";

                # define the ZZZ files
                my @ZZZFiles = (
                    'ZZZAAuto.pm',
                    'ZZZAuto.pm',
                );

                # reload the ZZZ files (mod_perl workaround)
                for my $ZZZFile (@ZZZFiles) {

                    PREFIX:
                    for my $Prefix (@INC) {
                        my $File = $Prefix . '/Kernel/Config/Files/' . $ZZZFile;
                        next PREFIX if !-f $File;
                        do $File;
                        last PREFIX;
                    }
                }

                local $Kernel::OM = Kernel::System::ObjectManager->new(
                    'Kernel::System::Log' => {
                        LogPrefix => "OTRS-otrs.Daemon.pl - Daemon $Module",
                    },
                );

                # disable in memory cache because many processes runs at the same time
                $Kernel::OM->Get('Kernel::System::Cache')->Configure(
                    CacheInMemory  => 0,
                    CacheInBackend => 1,
                );

                # set daemon log files
                _LogFilesSet(
                    Module => $DaemonModules{$Module}->{Name}
                );

                my $DaemonObject;
                LOOP:
                while ($ChildRun) {

                    # create daemon object if not exists
                    eval {

                        if (
                            !$DaemonObject
                            && ( $DebugDaemons{All} || $DebugDaemons{ $DaemonModules{$Module}->{Name} } )
                            )
                        {
                            $Kernel::OM->ObjectParamAdd(
                                $Module => {
                                    Debug => 1,
                                },
                            );
                        }

                        $DaemonObject ||= $Kernel::OM->Get($Module);
                    };

                    # wait 10 seconds if creation of object is not possible
                    if ( !$DaemonObject ) {
                        sleep 10;
                        last LOOP;
                    }

                    METHOD:
                    for my $Method ( 'PreRun', 'Run', 'PostRun' ) {
                        last LOOP if !eval { $DaemonObject->$Method() };
                    }
                }

                exit 0;
            }
            else {

                if ($Debug) {
                    print STDOUT "Registered Daemon $Module with PID $ChildPID\n";
                }

                $DaemonModules{$Module}->{PID} = $ChildPID;
            }
        }

        # sleep 0.1 seconds to protect the system of a 100% CPU usage if one daemon
        # module is damaged and produces hard errors
        sleep 0.1;
    }

    # send all daemon processes a stop signal
    MODULE:
    for my $Module ( sort keys %DaemonModules ) {

        next MODULE if !$Module;
        next MODULE if !$DaemonModules{$Module}->{PID};

        if ($Debug) {
            print STDOUT "Send stop signal to $Module with PID $DaemonModules{$Module}->{PID}\n";
        }

        kill 2, $DaemonModules{$Module}->{PID};
    }

    # wait for active daemon processes to stop
    WAITTIME:
    for my $WaitTime ( 1 .. 30 ) {

        my $ProcessesStillRunning;
        MODULE:
        for my $Module ( sort keys %DaemonModules ) {

            next MODULE if !$Module;
            next MODULE if !$DaemonModules{$Module}->{PID};

            # check if PID is still alive
            if ( !kill 0, $DaemonModules{$Module}->{PID} ) {

                # remove daemon pid from list
                $DaemonModules{$Module}->{PID} = 0;
            }
            else {

                $ProcessesStillRunning = 1;

                if ($Debug) {
                    print STDOUT "Waiting to stop $Module with PID $DaemonModules{$Module}->{PID}\n";
                }
            }
        }

        last WAITTIME if !$ProcessesStillRunning;

        sleep 1;
    }

    # hard kill of all children witch are not stopped after 30 seconds
    MODULE:
    for my $Module ( sort keys %DaemonModules ) {

        next MODULE if !$Module;
        next MODULE if !$DaemonModules{$Module}->{PID};

        print STDOUT "Killing $Module with PID $DaemonModules{$Module}->{PID}\n";

        kill 9, $DaemonModules{$Module};
    }

    return 0;
}

sub Stop {
    my %Param = @_;

    my $RunningDaemonPID = _PIDUnlock();

    # send INT signal to running daemon
    if ($RunningDaemonPID) {
        kill 2, $RunningDaemonPID;
    }

    print STDOUT "Daemon stopped\n";

    return 1;
}

sub Status {
    my %Param = @_;

    if ( -e $PIDFile ) {

        # read existing PID file
        open my $FH, '<', $PIDFile;    ## no critic

        # try to lock the file exclusively
        if ( !flock( $FH, LOCK_EX | LOCK_NB ) ) {

            # if no exclusive lock, daemon might be running, send signal to the PID
            my $RegisteredPID = do { local $/; <$FH> };
            close $FH;

            if ($RegisteredPID) {

                # check if process is running
                my $RunningPID = kill 0, $RegisteredPID;

                if ($RunningPID) {
                    print STDOUT "Daemon running\n";
                    return 1;
                }
            }
        }
        else {

            # if exclusive lock is granted, then it is not running
            close $FH;
        }
    }

    _PIDUnlock();

    print STDOUT "Daemon not running\n";
    return;
}

sub _PIDLock {

    # check pid directory
    if ( !-e $PIDDir ) {

        File::Path::mkpath( $PIDDir, 0, 0770 );    ## no critic

        if ( !-e $PIDDir ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't create directory '$PIDDir': $!",
            );

            exit 1;
        }
    }

    if ( -e $PIDFile ) {

        # read existing PID file
        open my $FH, '<', $PIDFile;    ## no critic

        # try to get a exclusive of the pid file, if fails daemon is already running
        if ( !flock( $FH, LOCK_EX | LOCK_NB ) ) {
            close $FH;
            return;
        }

        my $RegisteredPID = do { local $/; <$FH> };
        close $FH;

        if ($RegisteredPID) {

            return 1 if $RegisteredPID eq $$;

            # check if another process is running
            my $AnotherRunningPID = kill 0, $RegisteredPID;

            return if $AnotherRunningPID;
        }
    }

    # create new PID file (set exclusive lock while writing the PIDFile)
    open my $FH, '>', $PIDFile || die "Can not create PID file: $PIDFile\n";    ## no critic
    return if !flock( $FH, LOCK_EX | LOCK_NB );
    print $FH $$;
    close $FH;

    # keep PIDFile shared locked forever
    open $PIDFH, '<', $PIDFile || die "Can not create PID file: $PIDFile\n";    ## no critic
    return if !flock( $PIDFH, LOCK_SH | LOCK_NB );

    return 1;
}

sub _PIDUnlock {

    return if !-e $PIDFile;

    # read existing PID file
    open my $FH, '<', $PIDFile;                                                 ## no critic

    # wait if PID is exclusively locked (and do a shared lock for reading)
    flock $FH, LOCK_SH;
    my $RegisteredPID = do { local $/; <$FH> };
    close $FH;

    unlink $PIDFile;

    return $RegisteredPID;
}

sub _LogFilesSet {
    my %Param = @_;

    # define log file names
    my $FileStdOut = "$LogDir/$Param{Module}OUT";
    my $FileStdErr = "$LogDir/$Param{Module}ERR";

    my $SystemTime = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();

    # backup old log files
    use File::Copy qw(move);
    if ( -e "$FileStdOut.log" ) {
        move( "$FileStdOut.log", "$FileStdOut-$SystemTime.log" );
    }
    if ( -e "$FileStdErr.log" ) {
        move( "$FileStdErr.log", "$FileStdErr-$SystemTime.log" );
    }

    # redirect STDOUT and STDERR
    open STDOUT, '>>', "$FileStdOut.log";
    open STDERR, '>>', "$FileStdErr.log";

    # remove not needed log files
    my $DaysToKeep = $Kernel::OM->Get('Kernel::Config')->Get('Daemon::Log::DaysToKeep') || 10;
    my $DaysToKeepTime = $SystemTime - $DaysToKeep * 24 * 60 * 60;

    my @LogFiles = glob "$LogDir/*.log";

    LOGFILE:
    for my $LogFile (@LogFiles) {

        # skip if is not a backup file
        next LOGFILE if ( $LogFile !~ m{(?: .* /)* $Param{Module} (?: OUT|ERR ) - (\d+) \.log}igmx );

        # do not delete files during keep period if they have content
        next LOGFILE if ( ( $1 > $DaysToKeepTime ) && -s $LogFile );

        # delete file
        if ( unlink $LogFile == 0 ) {

            # log old backup file cannot be deleted
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Daemon: $Param{Module} could not delete old log file $LogFile! $!",
            );
        }
    }

    return 1;
}

exit 0;
