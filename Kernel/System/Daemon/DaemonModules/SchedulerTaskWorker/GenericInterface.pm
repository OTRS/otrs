# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericInterface;

use strict;
use warnings;

use parent qw(Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

use Kernel::System::VariableCheck qw(:all);

use Storable;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::GenericInterface::Requester',
    'Kernel::System::DateTime',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Log',
    'Kernel::System::Scheduler',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericInterface - Scheduler daemon task handler module for GenericInterface

=head1 DESCRIPTION

This task handler executes scheduler tasks delegated by asynchronous invoker configuration

=head1 PUBLIC INTERFACE

=head2 new()

    my $TaskHandlerObject = $Kernel::OM-Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericInterface');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    $Self->{Debug}      = $Param{Debug};
    $Self->{WorkerName} = 'Worker: GenericInterface';

    return $Self;
}

=head2 Run()

Performs the selected Task, causing an Invoker call via GenericInterface.

    my $Result = $TaskHandlerObject->Run(
        TaskID   => 123,
        TaskName => 'some name',                    # optional
        Data     => {
            WebserviceID => $WebserviceID,
            Invoker      => 'configured_invoker',
            Data         => {                       # data payload for the Invoker
                ...
            },
        },
    );

Returns:

    $Result =  1;       # or fail in case of an error

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # Check task params.
    my $CheckResult = $Self->_CheckTaskParams(
        NeededDataAttributes => [ 'WebserviceID', 'Invoker', 'Data' ],
        %Param,
    );
    return if !$CheckResult;

    if ( $Self->{Debug} ) {
        print "    $Self->{WorkerName} executes task: $Param{TaskName}\n";
    }

    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID      => $Param{Data}->{WebserviceID},
        Invoker           => $Param{Data}->{Invoker},
        Asynchronous      => 1,
        Data              => Storable::dclone( $Param{Data}->{Data} ),
        PastExecutionData => $Param{Data}->{PastExecutionData},
    );
    return 1 if $Result->{Success};

    my $Webservice = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
        ID => $Param{Data}->{WebserviceID},
    );

    my $WebServiceName = $Webservice->{Name} // 'N/A';

    # No further retries for request.
    if (
        !IsHashRefWithData( $Result->{Data} )
        || !$Result->{Data}->{ReSchedule}
        )
    {
        my $ErrorMessage
            = $Result->{ErrorMessage} || "$Param{Data}->{Invoker} execution failed without an error message";

        $Self->_HandleError(
            TaskName     => "$Param{Data}->{Invoker} WebService: $WebServiceName",
            TaskType     => 'GenericInterface',
            LogMessage   => "There was an error executing $Param{Data}->{Invoker} ($WebServiceName): $ErrorMessage",
            ErrorMessage => "$ErrorMessage",
        );

        return;
    }

    # Schedule request for another try.

    # Use the execution time from the return data (if any).
    my $ExecutionTime = $Result->{Data}->{ExecutionTime};
    my $ExecutionDateTime;

    # Check if execution time is valid.
    if ( IsStringWithData($ExecutionTime) ) {

        $ExecutionDateTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => $ExecutionTime,
            },
        );
        if ( !$ExecutionDateTime ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message =>
                    "WebService $WebServiceName, Invoker $Param{Data}->{Invoker} returned invalid execution time $ExecutionTime. Falling back to default!",
            );
        }
    }

    # Set default execution time.
    if ( !$ExecutionTime || !$ExecutionDateTime ) {

        # Get default time difference from config.
        my $FutureTaskTimeDiff = int(
            $Kernel::OM->Get('Kernel::Config')->Get('Daemon::SchedulerGenericInterfaceTaskManager::FutureTaskTimeDiff')
            )
            || 300;

        $ExecutionDateTime = $Kernel::OM->Create('Kernel::System::DateTime');
        $ExecutionDateTime->Add( Seconds => $FutureTaskTimeDiff );
    }

    if ( $Self->{Debug} ) {
        print "    $Self->{WorkerName} re-schedule task: $Param{TaskName} for: $ExecutionDateTime->ToString()\n";
    }

    # Create a new task (replica) that will be executed in the future.
    my $Success = $Kernel::OM->Get('Kernel::System::Scheduler')->TaskAdd(
        ExecutionTime => $ExecutionDateTime->ToString(),
        Type          => 'GenericInterface',
        Name          => $Param{TaskName},
        Attempts      => 10,
        Data          => {
            %{ $Param{Data} },
            PastExecutionData => $Result->{Data}->{PastExecutionData},
        },
    );

    if ( !$Success ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Could not re-schedule a task in future for task $Param{TaskName}",
        );
    }

    return;
}

1;

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
