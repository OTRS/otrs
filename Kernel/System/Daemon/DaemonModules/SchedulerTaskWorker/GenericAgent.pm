# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericAgent;

use strict;
use warnings;

use parent qw(Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::DateTime',
    'Kernel::System::GenericAgent',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericAgent - Scheduler daemon task handler module for GenericAgent

=head1 DESCRIPTION

This task handler executes generic agent jobs

=head1 PUBLIC INTERFACE

=head2 new()

    my $TaskHandlerObject = $Kernel::OM-Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericAgent');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug}      = $Param{Debug};
    $Self->{WorkerName} = 'Worker: GenericAgent';

    return $Self;
}

=head2 Run()

Performs the selected task.

    my $Result = $TaskHandlerObject->Run(
        TaskID   => 123,
        TaskName => 'some name',    # optional
        Data     => {               # job data as got from Kernel::System::GenericAgent::JobGet()
            Name 'job name',
            Valid 1,
            # ...
        },
    );

Returns:

    $Result =  1;       # or fail in case of an error

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check task params
    my $CheckResult = $Self->_CheckTaskParams(
        %Param,
        NeededDataAttributes => [ 'Name', 'Valid' ],
    );

    # Stop execution if an error in params is detected.
    return if !$CheckResult;

    # Skip if job is not valid.
    return if !$Param{Data}->{Valid};

    my %Job = %{ $Param{Data} };

    my $StartSystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    # Check if last run was less than 1 minute ago.
    if (
        $Job{ScheduleLastRunUnixTime}
        && $StartSystemTime - $Job{ScheduleLastRunUnixTime} < 60
        )
    {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "GenericAgent Job: $Job{Name}, was already executed less than 1 minute ago!",
        );
        return;
    }

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $TicketLimit = $ConfigObject->Get('Daemon::SchedulerGenericAgentTaskManager::TicketLimit') || 0;
    my $SleepTime   = $ConfigObject->Get('Daemon::SchedulerGenericAgentTaskManager::SleepTime')   || 0;

    my $Success;
    my $ErrorMessage;

    if ( $Self->{Debug} ) {
        print "    $Self->{WorkerName} executes task: $Param{TaskName}\n";
    }

    do {

        # Restore child signal to default, main daemon set it to 'IGNORE' to be able to create
        #   multiple process at the same time, but in workers this causes problems if function does
        #   system calls (on linux), since system calls returns -1. See bug#12126.
        local $SIG{CHLD} = 'DEFAULT';

        # Localize the standard error, everything will be restored after the eval block.
        local *STDERR;

        # Redirect the standard error to a variable.
        open STDERR, ">>", \$ErrorMessage;

        $Success = $Kernel::OM->Get('Kernel::System::GenericAgent')->JobRun(
            Job       => $Job{Name},
            Limit     => $TicketLimit,
            SleepTime => $SleepTime,
            UserID    => 1,
        );
    };

    # Get current system time (as soon as the job finish to run).
    my $EndSystemTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

    if ( !$Success ) {

        $ErrorMessage ||= "$Job{Name} execution failed without an error message!";

        $Self->_HandleError(
            TaskName     => $Job{Name},
            TaskType     => 'GenericAgent',
            LogMessage   => "There was an error executing $Job{Name}: $ErrorMessage",
            ErrorMessage => "$ErrorMessage",
        );
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
