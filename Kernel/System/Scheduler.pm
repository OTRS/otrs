# --
# Kernel/System/Scheduler.pm - The otrs Scheduler Daemon
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Scheduler;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData IsStringWithData);
use Kernel::System::Scheduler::TaskManager;
use Kernel::System::Scheduler::TaskHandler;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Cache',
    'Kernel::System::Log',
    'Kernel::System::PID',
    'Kernel::System::Scheduler::TaskManager',
    'Kernel::System::Time',
);

=head1 NAME

Kernel::System::Scheduler - Scheduler lib

=head1 SYNOPSIS

This object can be used in two ways:

=head2 Registering new scheduler tasks

By creating an instance of this object and calling L<TaskRegister()> on it, a task
can be scheduled for asynchronous execution (either as soon as possible, or with a
specified future execution time).

=head2 Running pending tasks

From the scheduler daemon, the L<Run()> method will be called to find and process
all existing tasks.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a time object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Scheduler');


=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    $Self->{PIDUpdateTime}
        = $Kernel::OM->Get('Kernel::Config')->Get('Scheduler::PIDUpdateTime') || 60;

    $Kernel::OM->Get('Kernel::System::Cache')->Configure(
        CacheInMemory => 0,
    );

    return $Self;
}

=item Run()

find and dispatch pending tasks. This method is used from the scheduler
daemon to regularly find and execute all pending tasks.

    my $Success = $SchedulerObject->Run();

    $Success = 1                   # 0 or 1;

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # try to update PID changed time
    $Self->_PIDChangedTimeUpdate();

    # get all tasks
    my @TaskList = $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager')->TaskList();

    # if there are no task to execute return successfully
    return 1 if !@TaskList;

    # get the task details
    TASKITEM:
    for my $TaskItem (@TaskList) {

        if ( !IsHashRefWithData($TaskItem) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Got invalid task list entry!',
            );

            next TASKITEM;
        }

        # delete task if no type is set
        if ( !$TaskItem->{Type} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Task $TaskItem->{ID} will be deleted bacause type is not set!",
            );
            $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager')
                ->TaskDelete( ID => $TaskItem->{ID} );

            next TASKITEM;
        }

        # do not execute if task is scheduled for future
        my $SystemTime  = $Kernel::OM->Get('Kernel::System::Time')->SystemTime();
        my $TaskDueTime = $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime(
            String => $TaskItem->{DueTime},
        );
        next TASKITEM if ( $TaskDueTime gt $SystemTime );

        # get task data
        my %TaskData
            = $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager')
            ->TaskGet( ID => $TaskItem->{ID} );
        if ( !%TaskData ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Got invalid task data!',
            );
            $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager')
                ->TaskDelete( ID => $TaskItem->{ID} );

            # skip if cant get task data
            next TASKITEM;
        }

        if ( !IsHashRefWithData( $TaskData{Data} ) ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => 'Got invalid data inside task data!',
            );
            $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager')
                ->TaskDelete( ID => $TaskItem->{ID} );

            # skip if can't get task data -> data
            next TASKITEM;
        }

        # create task handler object
        my $TaskHandlerObject = eval {
            Kernel::System::Scheduler::TaskHandler->new(
                TaskHandlerType => $TaskItem->{Type},
            );
        };

        # check if Task Handler object was created
        if ( !$TaskHandlerObject ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Can't create $TaskItem->{Type} task handler object! $@",
            );

            $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager')
                ->TaskDelete( ID => $TaskItem->{ID} );

            # skip if can't create task handler
            next TASKITEM;
        }

        # call run method on task handler object
        my $TaskResult = $TaskHandlerObject->Run(
            TaskID => $TaskItem->{ID},
            Data   => $TaskData{Data},
        );

        # try to update PID changed time
        $Self->_PIDChangedTimeUpdate();

        # check if need to reschedule
        if ( $TaskResult->{ReSchedule} ) {

            # reschedule: update the current task
            my $Success = $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager')->TaskUpdate(
                ID      => $TaskItem->{ID},
                DueTime => $TaskResult->{DueTime},
                Data    => $TaskResult->{Data},
                Type    => $TaskItem->{Type},
            );

            # check if task was rescheduled successfully
            if ( !$Success ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not reschedule task.",
                );

                # delete the task
                $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager')
                    ->TaskDelete( ID => $TaskItem->{ID} );

                next TASKITEM;
            }

            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'info',
                Message  => "Task is rescheduled (TaskID: $TaskItem->{ID}).",
            );
        }

        else {

            # delete the task
            $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager')
                ->TaskDelete( ID => $TaskItem->{ID} );
        }
    }

    return 1;
}

=item TaskRegister()

schedules a task for asynchronous execution (either as soon as possible, or with a
specified future execution time). Each task has a task type, and for each task type
a corresponding task handler backend must be present. The task data that is required
depends on the task type. Please consult the task handler backend specification to find
out which data is exactly needed.

    my $TaskID = $SchedulerObject->TaskRegister(
        Type     => 'GenericInterface',
        Data     => {                               # task data, depends task handler backend
            ...
        },
        DueTime  => '2006-01-19 23:59:59',          # optional (default current time)
    );

=cut

sub TaskRegister {
    my ( $Self, %Param ) = @_;

    # check task type
    if ( !IsStringWithData( $Param{Type} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no Task Type with content!',
        );

        # return failure if no task type is sent
        return;
    }

    # check if task data is undefined
    if ( !defined $Param{Data} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got undefined Task data!',
        );

        # return error if task data is undefined
        return;
    }

    # register task
    my $TaskID = $Kernel::OM->Get('Kernel::System::Scheduler::TaskManager')->TaskAdd(
        %Param,
    );

    # check if task was registered
    if ( !$TaskID ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Task could not be registered',
        );

        # return failure if task registration fails
        return;
    }

    # otherwise return the task ID
    return $TaskID;
}

=item _PIDChangedTimeUpdate()

Check if is the case to update the changed time for the PID,
in order to use it as a keep alive signal.

    my $Success = $SchedulerObject->_PIDChangedTimeUpdate();

=cut

sub _PIDChangedTimeUpdate {
    my ( $Self, %Param ) = @_;

    # PID time to update should be defined, except the first time
    if ( !defined $Self->{PIDTimeToUpdate} ) {
        my %PIDGetUpdate = $Kernel::OM->Get('Kernel::System::PID')->PIDGet(
            Name => 'otrs.Scheduler'
        );
        $Self->{PIDTimeToUpdate} = $PIDGetUpdate{Changed} + $Self->{PIDUpdateTime};
    }

    # get current system time
    my $CurrentTime = time();

    # check if it's necessary to update change time for pid
    if ( $CurrentTime >= $Self->{PIDTimeToUpdate} ) {
        my $UpdateSuccess = $Kernel::OM->Get('Kernel::System::PID')->PIDUpdate(
            Name => 'otrs.Scheduler'
        );
        if ( !$UpdateSuccess ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Could not update PID",
            );
            return;
        }
        my %PIDGetUpdate = $Kernel::OM->Get('Kernel::System::PID')->PIDGet(
            Name => 'otrs.Scheduler'
        );
        $Self->{PIDTimeToUpdate} = $PIDGetUpdate{Changed} + $Self->{PIDUpdateTime};
    }

    return 1;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
