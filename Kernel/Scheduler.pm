# --
# Kernel/Scheduler.pm - The otrs Scheduler Daemon
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Scheduler;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsHashRefWithData IsStringWithData);
use Kernel::System::Scheduler::TaskManager;
use Kernel::Scheduler::TaskHandler;
use Kernel::System::Registration;
use Kernel::System::PID;

=head1 NAME

Kernel::Scheduler - Scheduler lib

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

create an object.

    use Kernel::Config;
    use Kernel::System::Encode;
    use Kernel::System::Log;
    use Kernel::System::Time;
    use Kernel::System::Main;
    use Kernel::System::DB;
    use Kernel::Scheduler;

    my $ConfigObject = Kernel::Config->new();
    my $EncodeObject = Kernel::System::Encode->new(
        ConfigObject => $ConfigObject,
    );
    my $LogObject = Kernel::System::Log->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
    );
    my $TimeObject = Kernel::System::Time->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
    );
    my $MainObject = Kernel::System::Main->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
    );
    my $DBObject = Kernel::System::DB->new(
        ConfigObject => $ConfigObject,
        EncodeObject => $EncodeObject,
        LogObject    => $LogObject,
        MainObject   => $MainObject,
    );
    my $SchedulerObject = Kernel::Scheduler->new(
        ConfigObject => $ConfigObject,
        LogObject    => $LogObject,
        TimeObject   => $TimeObject,
        DBObject     => $DBObject,
        MainObject   => $MainObject,
        EncodeObject => $EncodeObject,
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # check needed objects
    for my $Object (qw(MainObject ConfigObject LogObject DBObject EncodeObject TimeObject)) {
        $Self->{$Object} = $Param{$Object} || die "Got no $Object!";
    }

    # create additional objects
    $Self->{TaskManagerObject} = Kernel::System::Scheduler::TaskManager->new( %{$Self} );

    $Self->{PIDObject} = Kernel::System::PID->new( %{$Self} );
    $Self->{PIDUpdateTime} = $Self->{ConfigObject}->Get('Scheduler::PIDUpdateTime') || 60;

    $Self->{RegistrationObject} = Kernel::System::Registration->new( %{$Self} );

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

    # Perform sanity checks
    $Self->_SanityChecks();

    # get all tasks
    my @TaskList = $Self->{TaskManagerObject}->TaskList();

    # if there are no task to execute return successfully
    return 1 if !@TaskList;

    # get the task details
    TASKITEM:
    for my $TaskItem (@TaskList) {

        if ( !IsHashRefWithData($TaskItem) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Got invalid task list entry!',
            );

            next TASKITEM;
        }

        # delete task if no type is set
        if ( !$TaskItem->{Type} ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Task $TaskItem->{ID} will be deleted bacause type is not set!",
            );
            $Self->{TaskManagerObject}->TaskDelete( ID => $TaskItem->{ID} );

            next TASKITEM;
        }

        # do not execute if task is scheduled for future
        my $SystemTime  = $Self->{TimeObject}->SystemTime();
        my $TaskDueTime = $Self->{TimeObject}->TimeStamp2SystemTime(
            String => $TaskItem->{DueTime},
        );
        next TASKITEM if ( $TaskDueTime gt $SystemTime );

        # get task data
        my %TaskData = $Self->{TaskManagerObject}->TaskGet( ID => $TaskItem->{ID} );
        if ( !%TaskData ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Got invalid task data!',
            );
            $Self->{TaskManagerObject}->TaskDelete( ID => $TaskItem->{ID} );

            # skip if cant get task data
            next TASKITEM;
        }

        if ( !IsHashRefWithData( $TaskData{Data} ) ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => 'Got invalid data inside task data!',
            );
            $Self->{TaskManagerObject}->TaskDelete( ID => $TaskItem->{ID} );

            # skip if can't get task data -> data
            next TASKITEM;
        }

        # create task handler object
        my $TaskHandlerObject = eval {
            Kernel::Scheduler::TaskHandler->new(
                %{$Self},
                TaskHandlerType => $TaskItem->{Type},
            );
        };

        # check if Task Handler object was created
        if ( !$TaskHandlerObject ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Can't create $TaskItem->{Type} task handler object! $@",
            );

            $Self->{TaskManagerObject}->TaskDelete( ID => $TaskItem->{ID} );

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
            my $Success = $Self->{TaskManagerObject}->TaskUpdate(
                ID      => $TaskItem->{ID},
                DueTime => $TaskResult->{DueTime},
                Data    => $TaskResult->{Data},
                Type    => $TaskItem->{Type},
            );

            # check if task was rescheduled successfully
            if ( !$Success ) {
                $Self->{LogObject}->Log(
                    Priority => 'error',
                    Message  => "Could not reschedule task.",
                );

                # delete the task
                $Self->{TaskManagerObject}->TaskDelete( ID => $TaskItem->{ID} );

                next TASKITEM;
            }

            $Self->{LogObject}->Log(
                Priority => 'info',
                Message  => "Task is rescheduled (TaskID: $TaskItem->{ID}).",
            );
        }

        else {

            # delete the task
            $Self->{TaskManagerObject}->TaskDelete( ID => $TaskItem->{ID} );
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
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got no Task Type with content!',
        );

        # return failure if no task type is sent
        return;
    }

    # check if task data is undefined
    if ( !defined $Param{Data} ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Got undefined Task data!',
        );

        # return error if task data is undefined
        return;
    }

    # register task
    my $TaskID = $Self->{TaskManagerObject}->TaskAdd(
        %Param,
    );

    # check if task was registered
    if ( !$TaskID ) {
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message  => 'Task could not be registered',
        );

        # return failure if task registration fails
        return;
    }

    # otherwise return the task ID
    return $TaskID;
}

=item _SanityChecks()

performs checks for the currently registered tasks.

=cut

sub _SanityChecks {
    my ( $Self, %Param ) = @_;

    $Self->_SanityCheckSystemRegistration();

    return 1;
}

sub _SanityCheckSystemRegistration {
    my ( $Self, %Param ) = @_;

    my %RegistrationData = $Self->{RegistrationObject}->RegistrationDataGet();

    # get all tasks
    my @TaskList                   = $Self->{TaskManagerObject}->TaskList();
    my @RegistrationUpdateTaskList = grep { $_->{Type} eq 'RegistrationUpdate' } @TaskList;

    # Registered system, must have RegistrationUpdate task.
    if ( $RegistrationData{State} && $RegistrationData{State} eq 'registered' ) {

        # Is there exactly 1 task?
        if ( scalar @RegistrationUpdateTaskList == 1 ) {
            return 1;
        }
        elsif ( scalar @RegistrationUpdateTaskList == 0 ) {

            # Ok, RegistrationUpdate task is missing. Create it.
            $Self->{TaskManagerObject}->TaskAdd(
                Type => 'RegistrationUpdate',
                Data => {
                    ReSchedule => 1,
                },
            );
        }
        else {
            # Ok, there is more than one task. Remove the others.
            shift @RegistrationUpdateTaskList;
            for my $RegistrationUpdateTask (@RegistrationUpdateTaskList) {
                $Self->{TaskManagerObject}->TaskDelete(
                    ID => $RegistrationUpdateTask->{ID},
                );
            }
        }
    }

    # Not registered system, may not have RegistrationUpdate task.
    else {
        # Delete any remaining tasks.
        for my $RegistrationUpdateTask (@RegistrationUpdateTaskList) {
            $Self->{TaskManagerObject}->TaskDelete(
                ID => $RegistrationUpdateTask->{ID},
            );
        }
    }
    return 1;
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
        my %PIDGetUpdate = $Self->{PIDObject}->PIDGet(
            Name => 'otrs.Scheduler'
        );
        $Self->{PIDTimeToUpdate} = $PIDGetUpdate{Changed} + $Self->{PIDUpdateTime};
    }

    # get current system time
    my $CurrentTime = time();

    # check if it's necessary to update change time for pid
    if ( $CurrentTime >= $Self->{PIDTimeToUpdate} ) {
        my $UpdateSuccess = $Self->{PIDObject}->PIDUpdate(
            Name => 'otrs.Scheduler'
        );
        if ( !$UpdateSuccess ) {
            $Self->{LogObject}->Log(
                Priority => 'error',
                Message  => "Could not update PID",
            );
            return;
        }
        my %PIDGetUpdate = $Self->{PIDObject}->PIDGet(
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
