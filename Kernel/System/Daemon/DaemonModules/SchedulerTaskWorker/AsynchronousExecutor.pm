# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::AsynchronousExecutor;

use strict;
use warnings;

use parent qw(Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

our @ObjectDependencies = (
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::AsynchronousExecutor - Scheduler daemon task handler module for generic asynchronous tasks

=head1 DESCRIPTION

This task handler executes scheduler generic asynchronous tasks.

=head1 PUBLIC INTERFACE

=head2 new()

    my $TaskHandlerObject = $Kernel::OM->Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::AsynchronousExecutor');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug}      = $Param{Debug};
    $Self->{WorkerName} = 'Worker: AsynchronousExecutor';

    return $Self;
}

=head2 Run()

Performs the selected asynchronous task.

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

    # Check task params.
    my $CheckResult = $Self->_CheckTaskParams(
        %Param,
        NeededDataAttributes => [ 'Object', 'Function' ],
    );

    # Stop execution if an error in params is detected.
    return if !$CheckResult;

    $Param{Data}->{Params} //= {};

    # Stop execution if invalid params ref is detected.
    return if !ref $Param{Data}->{Params};

    my $LocalObject;
    eval {
        $LocalObject = $Kernel::OM->Get( $Param{Data}->{Object} );
    };
    if ( !$LocalObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not create a new object $Param{Data}->{Object}! - Task: $Param{TaskName}",
        );

        return;
    }

    # Check if the module provide the required function().
    if ( !$LocalObject->can( $Param{Data}->{Function} ) ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "$Param{Data}->{Object} does not provide $Param{Data}->{Function}()! - Task: $Param{TaskName}",
        );

        return;
    }

    my $Function = $Param{Data}->{Function};

    my $ErrorMessage;

    if ( $Self->{Debug} ) {
        print "    $Self->{WorkerName} executes task: $Param{TaskName}\n";
    }

    # Run given function on the object with the specified parameters in Data->{Params}
    eval {

        # Restore child signal to default, main daemon set it to 'IGNORE' to be able to create
        #   multiple process at the same time, but in workers this causes problems if function does
        #   system calls (on linux), since system calls returns -1. See bug#12126.
        local $SIG{CHLD} = 'DEFAULT';

        # Localize the standard error, everything will be restored after the eval block.
        local *STDERR;

        # Redirect the standard error to a variable.
        open STDERR, ">>", \$ErrorMessage;

        if ( ref $Param{Data}->{Params} eq 'ARRAY' ) {
            $LocalObject->$Function(
                @{ $Param{Data}->{Params} },
            );
        }
        else {
            $LocalObject->$Function(
                %{ $Param{Data}->{Params} // {} },
            );
        }

    };

    # Check if there are errors.
    # Do not log debug messages as Daemon errors. See bug#14722 (https://bugs.otrs.org/show_bug.cgi?id=14722).
    if ( $ErrorMessage && $ErrorMessage !~ /Debug: /g ) {

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

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
