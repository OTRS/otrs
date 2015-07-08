# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker;

use strict;
use warnings;
use utf8;

use File::Path qw();
use Time::HiRes qw(sleep);

use base qw(Kernel::System::Daemon::BaseDaemon);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Storable',
    'Kernel::System::Time',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker - worker daemon for the scheduler

=head1 SYNOPSIS

Scheduler worker daemon

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create scheduler task worker object.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless $Self, $Type;

    # get objects in constructor to save performance
    $Self->{ConfigObject}      = $Kernel::OM->Get('Kernel::Config');
    $Self->{CacheObject}       = $Kernel::OM->Get('Kernel::System::Cache');
    $Self->{TimeObject}        = $Kernel::OM->Get('Kernel::System::Time');
    $Self->{MainObject}        = $Kernel::OM->Get('Kernel::System::Main');
    $Self->{DBObject}          = $Kernel::OM->Get('Kernel::System::DB');
    $Self->{StorableObject}    = $Kernel::OM->Get('Kernel::System::Storable');
    $Self->{SchedulerDBObject} = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

    # disable in memory cache to be clusterable
    $Self->{CacheObject}->Configure(
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );

    # get the NodeID from the SysConfig settings, this is used on High Availability systems.
    $Self->{NodeID} = $Self->{ConfigObject}->Get('NodeID') || 1;

    # check NodeID, if does not match is impossible to continue
    if ( $Self->{NodeID} !~ m{ \A \d+ \z }xms && $Self->{NodeID} > 0 && $Self->{NodeID} < 1000 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "NodeID '$Self->{NodeID}' is invalid!",
        );
        return;
    }

    # get pid directory
    $Self->{PIDDir}  = $Self->{ConfigObject}->Get('Home') . '/var/run/Daemon/Scheduler/';
    $Self->{PIDFile} = $Self->{PIDDir} . "Worker-NodeID-$Self->{NodeID}.pid";

    # check pid hash and pid file
    return if !$Self->_WorkerPIDsCheck();

    # get the maximum number of workers (forks to execute the tasks)
    $Self->{MaximumWorkers} = $Self->{ConfigObject}->Get('Daemon::SchedulerTaskWorker::MaximumWorkers') || 5;

    # Do not change the following values!
    # Modulo in PreRun() can be damaged after a change.
    $Self->{SleepPost} = 0.25;       # sleep 60 seconds after each loop
    $Self->{Discard}   = 60 * 60;    # discard every hour

    $Self->{DiscardCount} = $Self->{Discard} / $Self->{SleepPost};

    $Self->{Debug}      = $Param{Debug};
    $Self->{DaemonName} = 'Daemon: SchedulerTaskWorker';

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    # check each 10 seconds
    return 1 if $Self->{DiscardCount} % ( 10 / $Self->{SleepPost} );

    # set running daemon cache
    $Self->{CacheObject}->Set(
        Type           => 'DaemonRunning',
        Key            => $Self->{NodeID},
        Value          => 1,
        TTL            => 30,
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );

    # check if database is on-line
    return 1 if $Self->{DBObject}->Ping();

    sleep 10;

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{CurrentWorkersCount} = scalar keys %{ $Self->{CurrentWorkers} };

    # get all unlocked tasks
    my @TaskList = $Self->{SchedulerDBObject}->TaskListUnlocked();

    TASK:
    for my $TaskID (@TaskList) {

        last TASK if $Self->{CurrentWorkersCount} >= $Self->{MaximumWorkers};

        # disconnect database before fork
        $Self->{DBObject}->Disconnect();

        # create a fork of the current process
        # parent gets the PID of the child
        # child gets PID = 0
        my $PID = fork;

        # at the child, execute task
        if ( !$PID ) {

            # define the ZZZ files
            my @ZZZFiles = (
                'ZZZAAuto.pm',
                'ZZZAuto.pm',
            );

            # reload the ZZZ files
            for my $ZZZFile (@ZZZFiles) {

                PREFIX:
                for my $Prefix (@INC) {
                    my $File = $Prefix . '/Kernel/Config/Files/' . $ZZZFile;
                    next PREFIX if !-f $File;
                    do $File;
                    last PREFIX;
                }
            }

            # destroy objects
            $Kernel::OM->ObjectsDiscard(
                ForcePackageReload => 1,
            );

            # disable in memory cache because many processes runs at the same time
            $Kernel::OM->Get('Kernel::System::Cache')->Configure(
                CacheInMemory  => 0,
                CacheInBackend => 1,
            );

            # get scheduler database object
            my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

            # try to lock the task
            my $LockSucess = $SchedulerDBObject->TaskLock(
                TaskID => $TaskID,
                NodeID => $Self->{NodeID},
                PID    => $$,
            );

            exit 1 if !$LockSucess;

            # get task
            my %Task = $SchedulerDBObject->TaskGet(
                TaskID => $TaskID,
            );

            # error handling
            if ( !%Task || !$Task{Type} || !$Task{Data} || ref $Task{Data} ne 'HASH' ) {

                # delete the task
                $SchedulerDBObject->TaskDelete(
                    TaskID => $TaskID,
                );

                my $TaskName = $Task{Name} || '';
                my $TaskType = $Task{Type} || '';

                # log the error
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Task $TaskType $TaskName ($TaskID) was deleted due missing task data!",
                );

                exit 1;
            }

            my $TaskHandlerModule = 'Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::' . $Task{Type};

            # create task handler object
            my $TaskHandlerObject;
            eval {

                $Kernel::OM->ObjectParamAdd(
                    $TaskHandlerModule => {
                        Debug => $Self->{Debug},
                    },
                );

                $TaskHandlerObject = $Kernel::OM->Get($TaskHandlerModule);
            };

            # error handling
            if ( !$TaskHandlerObject ) {

                # delete the task
                $SchedulerDBObject->TaskDelete(
                    TaskID => $TaskID,
                );

                my $TaskName = $Task{Name} || '';
                my $TaskType = $Task{Type} || '';

                # log the error
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Task $TaskType $TaskName ($TaskID) was deleted due missing handler object!",
                );

                exit 1;
            }

            # call run method on task handler object
            $TaskHandlerObject->Run(
                TaskID   => $TaskID,
                TaskName => $Task{Name} || '',
                Data     => $Task{Data},
            );

            # delete the task
            $SchedulerDBObject->TaskDelete(
                TaskID => $TaskID,
            );

            exit 0;
        }

        # check if fork was not possible
        if ( $PID < 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not create a child process (worker) for task id $TaskID!",
            );
            next TASK;
        }

        # populate current workers hash to the parent knows witch task is executing each worker
        $Self->{CurrentWorkers}->{$PID} = {
            PID       => $PID,
            TaskID    => $TaskID,
            StartTime => $Self->{TimeObject}->SystemTime(),
        };

        $Self->{CurrentWorkersCount}++;
    }

    return 1;
}

sub PostRun {
    my ( $Self, %Param ) = @_;

    sleep $Self->{SleepPost};

    # check pid hash and pid file after sleep time to give the workers time to finish
    return if !$Self->_WorkerPIDsCheck();

    $Self->{DiscardCount}--;

    if ( $Self->{Debug} ) {
        print "  $Self->{DaemonName} Discard Count: $Self->{DiscardCount}\n";
    }

    # update task locks and remove expired each 60 seconds
    if ( !int $Self->{DiscardCount} % ( 60 / $Self->{SleepPost} ) ) {

        # extract current working task IDs
        my @LockedTaskIDs = map { $Self->{CurrentWorkers}->{$_}->{TaskID} } sort keys %{ $Self->{CurrentWorkers} };

        # update locks (only for this node)
        if (@LockedTaskIDs) {
            $Self->{SchedulerDBObject}->TaskLockUpdate(
                TaskIDs => \@LockedTaskIDs,
            );
        }

        # unlock expired tasks (for all nodes)
        $Self->{SchedulerDBObject}->TaskUnlockExpired();
    }

    # remove obsolete tasks before destroy
    if ( $Self->{DiscardCount} == 0 ) {
        $Self->{SchedulerDBObject}->TaskCleanup();
    }

    return if $Self->{DiscardCount} <= 0;
    return 1;
}

sub Summary {
    my ( $Self, %Param ) = @_;

    return $Self->{SchedulerDBObject}->TaskSummary();
}

sub _WorkerPIDsCheck {
    my ( $Self, %Param ) = @_;

    # check pid directory
    if ( !-e $Self->{PIDDir} ) {

        File::Path::mkpath( $Self->{PIDDir}, 0, 0770 );    ## no critic

        if ( !-e $Self->{PIDDir} ) {

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't create directory '$Self->{PIDDir}': $!",
            );

            return;
        }
    }

    # load current workers initially
    if ( !defined $Self->{CurrentWorkers} ) {

        # read pid file
        if ( -e $Self->{PIDFile} ) {

            # read file content
            my $PIDFileContent = $Self->{MainObject}->FileRead(
                Location        => $Self->{PIDFile},
                Mode            => 'binmode',
                Type            => 'Local',
                Result          => 'SCALAR',
                DisableWarnings => 1,
            );

            # deserialize the content
            if ($PIDFileContent) {

                my $WorkerPIDs = $Self->{StorableObject}->Deserialize(
                    Data => ${$PIDFileContent},
                ) || {};

                $Self->{CurrentWorkers} = $WorkerPIDs;
            }
        }

        $Self->{CurrentWorkers} ||= {};
    }

    # check worker PIDs
    WORKERPID:
    for my $WorkerPID ( sort keys %{ $Self->{CurrentWorkers} } ) {

        # check if PID is still alive
        next WORKERPID if kill 0, $WorkerPID;

        # delete worker
        delete $Self->{CurrentWorkers}->{$WorkerPID};
    }

    $Self->{WrittenPids} //= 'REWRITE REQUIRED';

    my $PidsString = join '-', sort keys %{ $Self->{CurrentWorkers} };
    $PidsString ||= '';

    # return if nothing has changed
    return 1 if $PidsString eq $Self->{WrittenPids};

    # update pid file
    if ( %{ $Self->{CurrentWorkers} } ) {

        # serialize the current worker hash
        my $CurrentWorkersString = $Self->{StorableObject}->Serialize(
            Data => $Self->{CurrentWorkers},
        );

        # write new pid file
        my $Success = $Self->{MainObject}->FileWrite(
            Location   => $Self->{PIDFile},
            Content    => \$CurrentWorkersString,
            Mode       => 'binmode',
            Type       => 'Local',
            Permission => '600',
        );

        return if !$Success;
    }
    elsif ( -e $Self->{PIDFile} ) {

        # remove empty file
        return if !unlink $Self->{PIDFile};
    }

    # save last written PIDs
    $Self->{WrittenPids} = $PidsString;

    return 1;
}

sub DESTROY {
    my $Self = shift;

    return 1;
}

1;
