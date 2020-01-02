# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::Cron;

use strict;
use warnings;

use IPC::Open3;
use Symbol;

use parent qw(Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::DateTime',
    'Kernel::System::Email',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::Cron - Scheduler daemon task handler module for cron like jobs

=head1 DESCRIPTION

This task handler executes scheduler tasks based in cron notation.

=head1 PUBLIC INTERFACE

=head2 new()

    my $TaskHandlerObject = $Kernel::OM-Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::Cron');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug}      = $Param{Debug};
    $Self->{WorkerName} = 'Worker: Cron';

    return $Self;
}

=head2 Run()

Performs the selected Cron task.

    my $Success = $TaskHandlerObject->Run(
        TaskID   => 123,
        TaskName => 'some name',                                        # optional
        Data     => {
            Module   => 'Kernel::System:::Console:Command::Help',
            Function => 'Execute',
            Params   => [                                               # parameters array reference
             '--force',
             '--option',
             'my option',
            ],
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
        NeededDataAttributes => [ 'Module', 'Function' ],
        DataParamsRef        => 'ARRAY',
    );

    # Stop execution if an error in params is detected.
    return if !$CheckResult;

    my $StartSystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    my $ModuleObject;
    eval {
        $ModuleObject = $Kernel::OM->Get( $Param{Data}->{Module} );
    };
    if ( !$ModuleObject ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Can not create a new Object for Module: '$Param{Data}->{Module}'! - Task: $Param{TaskName}",
        );

        return;
    }

    my $Function = $Param{Data}->{Function};

    # Check if the module provide the required function.
    return if !$ModuleObject->can($Function);

    my @Parameters = @{ $Param{Data}->{Params} || [] };

    # To capture the standard error.
    my $ErrorMessage;

    my $Result;

    if ( $Self->{Debug} ) {
        print "    $Self->{WorkerName} Executes task: $Param{TaskName}\n";
    }

    eval {

        # Restore child signal to default, main daemon set it to 'IGNORE' to be able to create
        #   multiple process at the same time, but in workers this causes problems if function does
        #   system calls (on linux), since system calls returns -1. See bug#12126.
        local $SIG{CHLD} = 'DEFAULT';

        # Localize the standard error, everything will be restored after the eval block.
        local *STDERR;

        # Redirect the standard error to a variable.
        open STDERR, ">>", \$ErrorMessage;

        # Disable ANSI terminal colors for console commands, then in case of an error the output
        #   will be clean.
        # Prevent used once warning, setting the variable as local and then assign the value
        #   in the next statement.
        local $Kernel::System::Console::BaseCommand::SuppressANSI;
        $Kernel::System::Console::BaseCommand::SuppressANSI = 1;

        # Run function on the module with the specified parameters in Data->{Params}
        $Result = $ModuleObject->$Function(
            @Parameters,
        );
    };

    # Get current system time (as soon as the method has been called).
    my $EndSystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    my $IsConsoleCommand;
    if (
        substr( $Param{Data}->{Module}, 0, length 'Kernel::System::Console' ) eq 'Kernel::System::Console'
        && $Function eq 'Execute'
        )
    {
        $IsConsoleCommand = 1;
    }

    my $ConsoleCommandFailure;

    # Console commands send 1 as result if fail.
    if ( $IsConsoleCommand && $Result ) {
        $ConsoleCommandFailure = 1;
    }

    my $Success = 1;

    # Check if there are errors.
    # Do not log debug messages as Daemon errors. See bug#14722 (https://bugs.otrs.org/show_bug.cgi?id=14722).
    if ( ( $ErrorMessage && $ErrorMessage !~ /Debug: /g ) || $ConsoleCommandFailure ) {

        $ErrorMessage //= "Console command '$Param{TaskName}' is failed.";

        $Self->_HandleError(
            TaskName     => $Param{TaskName},
            TaskType     => 'Cron',
            LogMessage   => "There was an error executing $Function() in $Param{Data}->{Module}: $ErrorMessage",
            ErrorMessage => $ErrorMessage,
        );

        $Success = 0;
    }

    # Update worker task.
    $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB')->RecurrentTaskWorkerInfoSet(
        LastWorkerTaskID      => $Param{TaskID},
        LastWorkerStatus      => $Success,
        LastWorkerRunningTime => $EndSystemTime - $StartSystemTime,
    );

    return $Success;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
