# --
# Kernel/Scheduler/TaskHandler.pm - Scheduler task handler interface
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Scheduler::TaskHandler;

use strict;
use warnings;

use Kernel::System::VariableCheck qw(IsStringWithData);

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Main',
);

=head1 NAME

Kernel::Scheduler::TaskHandler - Scheduler Task Handler interface

=head1 SYNOPSIS

The TaskHandler actually executes the tasks that were queued in the Scheduler.
For each different type of task, there is a separate backend that understands
how to execute this particular task.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

create an object.


    use Kernel::Scheduler::TaskHandler;
    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();

    my $OperationObject = Kernel::Scheduler::TaskHandler->new(
        TaskHandlerType => 'GenericInterface'    # Type of the TaskHandler backend to use
    );

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    # check operation
    if ( !IsStringWithData( $Param{TaskHandlerType} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no Task Type with content!',
        );
        return;
    }

    # load backend module
    my $GenericModule = 'Kernel::Scheduler::TaskHandler::' . $Param{TaskHandlerType};
    if ( !$Kernel::OM->Get('Kernel::System::Main')->Require($GenericModule) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can't load $Param{Type} task handler backend module!",
        );
        return;
    }
    $Self->{BackendObject} = $GenericModule->new();

    return ( ref $Self->{BackendObject} eq $GenericModule ) ? $Self : undef;
}

=item Run()

performs the selected Task. This will be delegated to the TaskHandler
backend for the specific TaskHandlerType selected in the constructor.

    my $Result = $TaskHandlerObject->Run(
        Data     => {                          # task data, depends on TaskType
            ...
        },
    );

Returns:

    $Result = {
        Success    => 1,                       # 0 or 1
        ReSchedule => 0,                       # 0 or 1, determines if task needs to be re-scheduled
        DueTime    => '2011-01-19 23:59:59',   # (for re-scheduling only) DueTime for new task
        Data       => {                        # (for re-scheduling only) Data for new task
            ...
        },
    };

Note that task handler backends must implement this method with the same signature.

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check data - we need a hash ref
    if ( $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no valid Data!',
        );
        return;
    }

    return $Self->{BackendObject}->Run(%Param);
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
