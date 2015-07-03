# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::AsynchronousExecutor;

use strict;
use warnings;

use base qw(Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::AsynchronousExecutor - Scheduler daemon task handler module for generic asynchronous tasks

=head1 SYNOPSIS

This task handler executes scheduler generic asynchronous tasks.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TaskHandlerObject = $Kernel::OM-Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::AsynchronousExecutor');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug}      = $Param{Debug};
    $Self->{WorkerName} = 'Worker: AsynchronousExecutor';

    return $Self;
}

=item Run()

performs the selected asynchronous task.

    my $Success = $TaskHandlerObject->Run(
        TaskID   => 123,
        TaskName => 'some name',                # optional
        Data     => {
            Object   => 'Some::Object::Name',
            Function => 'SomeFunctionName',
            Params   => $Params ,               # HashRef with the needed parameters
        },
    );

Returns:

    $Success => 1,  # or fail in case of an error

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed
    for my $Needed (qw(TaskID Data)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed!",
            );

            return;
        }
    }

    # check data
    if ( ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no valid Data!',
        );

        return;
    }

    for my $Needed (qw(Object Function)) {
        if ( !$Param{Data}->{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need Data->$Needed!",
            );

            return;
        }

    }

    if ( $Param{Data}->{Params} && ref $Param{Data}->{Params} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Data->Params is invalid!",
        );

        return;
    }

    # get module object
    my $LocalObject;

    eval {
        $LocalObject = $Kernel::OM->Get( $Param{Data}->{Object} );
    };

    if ( !$LocalObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not create a new object $Param{Data}->{Object}!",
        );

        return;
    }

    # check if the module provide the required function()
    if ( !$LocalObject->can( $Param{Data}->{Function} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Param{Data}->{Object} does not provide $Param{Data}->{Function}()!",
        );

        return;
    }

    my $Function = $Param{Data}->{Function};

    my $ErrorMessage;

    if ( $Self->{Debug} ) {
        print "    $Self->{WorkerName} executes task: $Param{TaskName}\n";
    }

    # run given function on the object with the specified parameters in Data->{Params}
    eval {

        # localize the standard error, everything will be restored after the eval block
        local *STDERR;

        # redirect the standard error to a variable
        open STDERR, ">>", \$ErrorMessage;

        $LocalObject->$Function(
            %{ $Param{Data}->{Params} },
        );
    };

    # check if there are errors
    if ($ErrorMessage) {

        $Self->_HandleError(
            TaskName     => $Param{TaskName},
            TaskType     => 'AsynchronousExecutor',
            LogMessage   => "There was an error executing $Function() in $Param{Data}->{Object}: $ErrorMessage",
            ErrorMessage => $ErrorMessage,
        );

        return;
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
