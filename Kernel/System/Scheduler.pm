# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Scheduler;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Scheduler - Scheduler lib

=head1 DESCRIPTION

Includes the functions to add a new task to the scheduler daemon.

=head1 PUBLIC INTERFACE

=head2 new()

create a scheduler object. Do not use it directly, instead use:

    my $SchedulerObject = $Kernel::OM->Get('Kernel::System::Scheduler');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=head2 TaskAdd()

add a task to scheduler

    my $Success = $SchedulerObject->TaskAdd(
        ExecutionTime            => '2015-01-01 00:00:00',  # task will be executed immediately if no execution
                                                            #   time is given
        Type                     => 'GenericInterface',     # e. g. GenericInterface, Test
        Name                     => 'any name',             # optional
        Attempts                 => 5,                      # optional (default 1)
        MaximumParallelInstances => 2,                      # optional, number of tasks with the same type
                                                            #   (and name if provided) that can exists at
                                                            #   the same time, value of 0 means unlimited
        Data => {                                           # data payload
            ...
        },
    );

=cut

sub TaskAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for my $Key (qw(Type Data)) {
        if ( !$Param{$Key} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Key!",
            );

            return;
        }
    }

    # get scheduler database object
    my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

    my $TaskID;
    if ( $Param{ExecutionTime} ) {
        $TaskID = $SchedulerDBObject->FutureTaskAdd(%Param);
    }
    else {
        $TaskID = $SchedulerDBObject->TaskAdd(%Param);
    }

    return 1 if $TaskID;
    return;
}

=head2 FutureTaskList()

get the list of scheduler future tasks

    my @List = $SchedulerObject->FutureTaskList(
        Type => 'some type',  # optional
    );

Returns:

    @List = (
        {
            TaskID        => 123,
            ExecutionTime => '2015-01-01 00:00:00',
            Name          => 'any name',
            Type          => 'GenericInterface',
        },
        {
            TaskID        => 456,
            ExecutionTime => '2015-01-01 00:00:00',
            Name          => 'any other name',
            Type          => 'GenericInterface',
        },
        # ...
    );

=cut

sub FutureTaskList {
    my ( $Self, %Param ) = @_;

    my @List = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB')->FutureTaskList(%Param);

    return @List;
}

=head2 TaskList()

get the list of scheduler tasks

    my @List = $SchedulerObject->TaskList(
        Type => 'some type',  # optional
    );

Returns:

    @List = (
        {
            TaskID => 123,
            Name   => 'any name',
            Type   => 'GenericInterface',
        },
        {
            TaskID => 456,
            Name   => 'any other name',
            Type   => 'GenericInterface',
        },
        # ...
    );

=cut

sub TaskList {
    my ( $Self, %Param ) = @_;

    return $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB')->TaskList(%Param);
}

=head2 FutureTaskDelete()

delete a task from scheduler future task list

    my $Success = $Schedulerbject->FutureTaskDelete(
        TaskID => 123,
    );

=cut

sub FutureTaskDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{TaskID} ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Need TaskID!',
        );
        return;
    }

    my $Success = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB')->FutureTaskDelete(%Param);

    return $Success;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
