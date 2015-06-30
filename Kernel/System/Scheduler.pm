# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

=head1 SYNOPSIS

Includes the functions to add a new task to the scheduler daemon.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create a scheduler object. Do not use it directly, instead use:

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $SchedulerObject = $Kernel::OM->Get('Kernel::System::Scheduler');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item TaskAdd()

add a task to scheduler

    my $Success = $SchedulerObject->TaskAdd(
        ExecutionTime => '2015-01-01 00:00:00',  # task will be executed emitiatly if no execution time is given
        Type          => 'GenericInterface',     # e. g. GenericInterface, Test
        Name          => 'any name',             # optional
        Attempts      => 5,                      # optional (default 1)
        Data          => {                       # data payload
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

=item FutureTaskList()

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

=item FutureTaskDelete()

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

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
