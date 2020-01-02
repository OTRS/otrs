# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker;

use strict;
use warnings;
use utf8;

use File::Path qw();
use Time::HiRes qw(sleep);

use parent qw(Kernel::System::Daemon::BaseDaemon);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DB',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::DateTime',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::Main',
    'Kernel::System::Storable',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker - worker daemon for the scheduler

=head1 DESCRIPTION

Scheduler worker daemon

=head1 PUBLIC INTERFACE

=head2 new()

Create scheduler task worker object.

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # Allocate new hash for object.
    my $Self = {};
    bless $Self, $Type;

    # Get objects in constructor to save performance.
    $Self->{ConfigObject}      = $Kernel::OM->Get('Kernel::Config');
    $Self->{CacheObject}       = $Kernel::OM->Get('Kernel::System::Cache');
    $Self->{MainObject}        = $Kernel::OM->Get('Kernel::System::Main');
    $Self->{DBObject}          = $Kernel::OM->Get('Kernel::System::DB');
    $Self->{StorableObject}    = $Kernel::OM->Get('Kernel::System::Storable');
    $Self->{SchedulerDBObject} = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');
    $Self->{DateTimeObject}    = $Kernel::OM->Create('Kernel::System::DateTime');

    # Disable in memory cache to be clusterable.
    $Self->{CacheObject}->Configure(
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );

    # Get the NodeID from the SysConfig settings, this is used on High Availability systems.
    $Self->{NodeID} = $Self->{ConfigObject}->Get('NodeID') || 1;

    # Check NodeID, if does not match is impossible to continue.
    if ( $Self->{NodeID} !~ m{ \A \d+ \z }xms && $Self->{NodeID} > 0 && $Self->{NodeID} < 1000 ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "NodeID '$Self->{NodeID}' is invalid!",
        );
        return;
    }

    # Get pid directory.
    my $BaseDir = $Self->{ConfigObject}->Get('Daemon::PID::Path') || $Self->{ConfigObject}->Get('Home') . '/var/run/';
    $Self->{PIDDir}  = $BaseDir . 'Daemon/Scheduler/';
    $Self->{PIDFile} = $Self->{PIDDir} . "Worker-NodeID-$Self->{NodeID}.pid";

    # Check pid hash and pid file.
    return if !$Self->_WorkerPIDsCheck();

    # Get the maximum number of workers (forks to execute the tasks).
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

    # Check each 10 seconds.
    return 1 if $Self->{DiscardCount} % ( 10 / $Self->{SleepPost} );

    # Set running daemon cache.
    $Self->{CacheObject}->Set(
        Type           => 'DaemonRunning',
        Key            => $Self->{NodeID},
        Value          => 1,
        TTL            => 30,
        CacheInMemory  => 0,
        CacheInBackend => 1,
    );

    # Check if database is on-line.
    return 1 if $Self->{DBObject}->Ping();

    sleep 10;

    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->{CurrentWorkersCount} = scalar keys %{ $Self->{CurrentWorkers} };

    my @TaskList = $Self->{SchedulerDBObject}->TaskListUnlocked();

    TASK:
    for my $TaskID (@TaskList) {

        last TASK if $Self->{CurrentWorkersCount} >= $Self->{MaximumWorkers};

        # Disconnect database before fork.
        $Self->{DBObject}->Disconnect();

        # Create a fork of the current process
        #   parent gets the PID of the child
        #   child gets PID = 0
        my $PID = fork;

        # At the child, execute task.
        if ( !$PID ) {

            # Remove the ZZZAAuto.pm from %INC to force reloading it.
            delete $INC{'Kernel/Config/Files/ZZZAAuto.pm'};

            # Destroy objects.
            $Kernel::OM->ObjectsDiscard(
                ForcePackageReload => 1,
            );

            # Disable in memory cache because many processes runs at the same time.
            $Kernel::OM->Get('Kernel::System::Cache')->Configure(
                CacheInMemory  => 0,
                CacheInBackend => 1,
            );

            my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

            # Try to lock the task.
            my $LockSucess = $SchedulerDBObject->TaskLock(
                TaskID => $TaskID,
                NodeID => $Self->{NodeID},
                PID    => $$,
            );

            exit 1 if !$LockSucess;

            my %Task = $SchedulerDBObject->TaskGet(
                TaskID => $TaskID,
            );

            # Do error handling.
            if ( !%Task || !$Task{Type} || !$Task{Data} || ref $Task{Data} ne 'HASH' ) {

                $SchedulerDBObject->TaskDelete(
                    TaskID => $TaskID,
                );

                my $TaskName = $Task{Name} || '';
                my $TaskType = $Task{Type} || '';

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Task $TaskType $TaskName ($TaskID) was deleted due missing task data!",
                );

                exit 1;
            }

            my $TaskHandlerModule = 'Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::' . $Task{Type};

            my $TaskHandlerObject;
            eval {

                $Kernel::OM->ObjectParamAdd(
                    $TaskHandlerModule => {
                        Debug => $Self->{Debug},
                    },
                );

                $TaskHandlerObject = $Kernel::OM->Get($TaskHandlerModule);
            };

            # Do error handling.
            if ( !$TaskHandlerObject ) {

                $SchedulerDBObject->TaskDelete(
                    TaskID => $TaskID,
                );

                my $TaskName = $Task{Name} || '';
                my $TaskType = $Task{Type} || '';

                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Task $TaskType $TaskName ($TaskID) was deleted due missing handler object!",
                );

                exit 1;
            }

            $TaskHandlerObject->Run(
                TaskID   => $TaskID,
                TaskName => $Task{Name} || '',
                Data     => $Task{Data},
            );

            # Force transactional events to run by discarding all objects before deleting the task.
            $Kernel::OM->ObjectEventsHandle();

            $SchedulerDBObject->TaskDelete(
                TaskID => $TaskID,
            );

            exit 0;
        }

        # Check if fork was not possible.
        if ( $PID < 0 ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not create a child process (worker) for task id $TaskID!",
            );
            next TASK;
        }

        # Populate current workers hash to the parent knows witch task is executing each worker.
        $Self->{CurrentWorkers}->{$PID} = {
            PID       => $PID,
            TaskID    => $TaskID,
            StartTime => $Self->{DateTimeObject}->ToEpoch(),
        };

        $Self->{CurrentWorkersCount}++;
    }

    return 1;
}

sub PostRun {
    my ( $Self, %Param ) = @_;

    sleep $Self->{SleepPost};

    # Check pid hash and pid file after sleep time to give the workers time to finish.
    return if !$Self->_WorkerPIDsCheck();

    $Self->{DiscardCount}--;

    # Update task locks and remove expired each 60 seconds.
    if ( !int $Self->{DiscardCount} % ( 60 / $Self->{SleepPost} ) ) {

        # Extract current working task IDs.
        my @LockedTaskIDs = map { $Self->{CurrentWorkers}->{$_}->{TaskID} } sort keys %{ $Self->{CurrentWorkers} };

        # Update locks (only for this node).
        if (@LockedTaskIDs) {
            $Self->{SchedulerDBObject}->TaskLockUpdate(
                TaskIDs => \@LockedTaskIDs,
            );
        }

        # Unlock expired tasks (for all nodes).
        $Self->{SchedulerDBObject}->TaskUnlockExpired();
    }

    # Remove obsolete tasks before destroy.
    if ( $Self->{DiscardCount} == 0 ) {
        $Self->{SchedulerDBObject}->TaskCleanup();

        if ( $Self->{Debug} ) {
            print "  $Self->{DaemonName} will be stopped and set for restart!\n";
        }
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

    # Check pid directory.
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

    # Load current workers initially.
    if ( !defined $Self->{CurrentWorkers} ) {

        # read pid file
        if ( -e $Self->{PIDFile} ) {

            my $PIDFileContent = $Self->{MainObject}->FileRead(
                Location        => $Self->{PIDFile},
                Mode            => 'binmode',
                Type            => 'Local',
                Result          => 'SCALAR',
                DisableWarnings => 1,
            );

            # Deserialize the content of the PID file.
            if ($PIDFileContent) {

                my $WorkerPIDs = $Self->{StorableObject}->Deserialize(
                    Data => ${$PIDFileContent},
                ) || {};

                $Self->{CurrentWorkers} = $WorkerPIDs;
            }
        }

        $Self->{CurrentWorkers} ||= {};
    }

    # Check worker PIDs.
    WORKERPID:
    for my $WorkerPID ( sort keys %{ $Self->{CurrentWorkers} } ) {

        # Check if PID is still alive.
        next WORKERPID if kill 0, $WorkerPID;

        delete $Self->{CurrentWorkers}->{$WorkerPID};
    }

    $Self->{WrittenPids} //= 'REWRITE REQUIRED';

    my $PidsString = join '-', sort keys %{ $Self->{CurrentWorkers} };
    $PidsString ||= '';

    # Return if nothing has changed.
    return 1 if $PidsString eq $Self->{WrittenPids};

    # Update pid file.
    if ( %{ $Self->{CurrentWorkers} } ) {

        # Serialize the current worker hash.
        my $CurrentWorkersString = $Self->{StorableObject}->Serialize(
            Data => $Self->{CurrentWorkers},
        );

        # Write new pid file.
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

        # Remove empty file.
        return if !unlink $Self->{PIDFile};
    }

    # Save last written PIDs.
    $Self->{WrittenPids} = $PidsString;

    return 1;
}

sub DESTROY {
    my $Self = shift;

    return 1;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
