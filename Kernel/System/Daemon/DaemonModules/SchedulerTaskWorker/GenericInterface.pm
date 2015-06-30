# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericInterface;

use strict;
use warnings;

use base qw(Kernel::System::Daemon::DaemonModules::BaseTaskWorker);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::GenericInterface::Requester',
    'Kernel::System::Daemon::SchedulerDB',
    'Kernel::System::GenericInterface::Webservice',
    'Kernel::System::Log',
    'Kernel::System::Time',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericInterface - Scheduler daemon task handler module for GenericInterface

=head1 SYNOPSIS

This task handler executes scheduler tasks delegated by asynchronous invoker configuration

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

    use Kernel::System::ObjectManager;
    local $Kernel::OM = Kernel::System::ObjectManager->new();
    my $TaskHandlerObject = $Kernel::OM-Get('Kernel::System::Daemon::DaemonModules::SchedulerTaskWorker::GenericInterface');

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Run()

performs the selected Task, causing an Invoker call via GenericInterface.

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

    # to store task data locally
    my %TaskData = %{ $Param{Data} };

    # check needed parameters inside task data
    for my $Needed (qw(WebserviceID Invoker Data)) {
        if ( !$TaskData{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Got no $Needed!",
            );

            return;
        }
    }

    # run requester
    my $Result = $Kernel::OM->Get('Kernel::GenericInterface::Requester')->Run(
        WebserviceID => $TaskData{WebserviceID},
        Invoker      => $TaskData{Invoker},
        Asynchronous => 1,
        Data         => $TaskData{Data},
    );

    if ( !$Result->{Success} ) {

        # get the web service name
        my $Webservice = $Kernel::OM->Get('Kernel::System::GenericInterface::Webservice')->WebserviceGet(
            ID => $Param{Data}->{WebserviceID},
        );

        my $WebServiceName = $Webservice->{Name} // 'N/A';

        my $ErrorMessage
            = $Result->{ErrorMessage} || "$Param{Data}->{Invoker} execution failed without an error message";

        $Self->_HandleError(
            TaskName     => "$Param{Data}->{Invoker} WebService: $WebServiceName",
            TaskType     => 'GenericInterface',
            LogMessage   => "There was an error executing $Param{Data}->{Invoker}($WebServiceName): $ErrorMessage",
            ErrorMessage => "$ErrorMessage",
        );

        # check if task needs to be re-schedule in the future
        if ( $Result->{Data}->{ReSchedule} ) {

            # get time object
            my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

            # use the execution time from the return data (if nay)
            my $ExecutionTime = $Result->{Data}->{ExecutionTime} || 0;

            # check if execution time is valid
            if ($ExecutionTime) {
                my $SystemTime = $TimeObject->TimeStamp2SystemTime(
                    String => $ExecutionTime,
                );

                if ( !$SystemTime ) {
                    $Kernel::OM->Get('Kernel::System::Log')->Log(
                        Priority => 'error',
                        Message =>
                            "Invoker returned future execution time: $ExecutionTime is invalid! falling back to default",
                    );

                    $ExecutionTime = 0;
                }
            }

            # use another if condition as inside the first one, the Execution time could be reset to 0
            if ( !$ExecutionTime ) {

                # get default time difference from config
                my $FutureTaskTimeDiff = abs( $Kernel::OM->Get('Kernel::Config')
                        ->Get('Daemon::SchedulerGenericInterfaceTaskManager::FutureTaskTimeDiff') || 300 );

                # calculate execution time in future
                $ExecutionTime = $TimeObject->SystemTime2TimeStamp(
                    SystemTime => $TimeObject->SystemTime() + $FutureTaskTimeDiff,
                );
            }

            # create a new task (replica) that will be executed in the future
            my $TaskID = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB')->FutureTaskAdd(
                ExecutionTime => $ExecutionTime,
                Type          => 'GenericInterface',
                Name          => $Param{TaskName},
                Attempts      => 10,
                Data          => $Param{Data}
            );

            if ( !$TaskID ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Could not re-Schedule a task in future for task $Param{TaskName}",
                );
            }
        }

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
