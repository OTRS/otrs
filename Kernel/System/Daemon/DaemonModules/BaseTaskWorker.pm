# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Daemon::DaemonModules::BaseTaskWorker;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Email',
    'Kernel::System::Log',
);

=head1 NAME

Kernel::System::Daemon::DaemonModules::BaseTaskWorker - scheduler task worker base class

=head1 DESCRIPTION

Base class for scheduler daemon task worker modules.

=head1 PUBLIC INTERFACE

=begin Internal:

=head2 _HandleError()

Creates a system error message and sends an email with the error messages form a task execution.

    my $Success = $TaskWorkerObject->_HandleError(
        TaskName     => 'some name',
        TaskType      => 'some type',
        LogMessage   => 'some message',       # message to set in the OTRS error log
        ErrorMessage => 'some message',       # message to be sent as a body of the email, usually contains
                                              #     all messages from STDERR including tracebacks
    );

=cut

sub _HandleError {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $Param{LogMessage},
    );

    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    my $From = $ConfigObject->Get('NotificationSenderName') . ' <'
        . $ConfigObject->Get('NotificationSenderEmail') . '>';

    my $To = $ConfigObject->Get('Daemon::SchedulerTaskWorker::NotificationRecipientEmail') || '';

    if ( $From && $To ) {

        my $Sent = $Kernel::OM->Get('Kernel::System::Email')->Send(
            From     => $From,
            To       => $To,
            Subject  => "OTRS Scheduler Daemon $Param{TaskType}: $Param{TaskName}",
            Charset  => 'utf-8',
            MimeType => 'text/plain',
            Body     => $Param{ErrorMessage},
        );

        return 1 if $Sent->{Success};
        return;
    }

    return;
}

=head2 _CheckTaskParams()

Performs basic checks for common task parameters.

    my $Success = $TaskWorkerObject->_CheckTaskParams(
        TaskID               => 123,
        TaskName             => 'some name',                # optional
        Data                 => $TaskDataHasRef,
        NeededDataAttributes => ['Object', 'Function'],     # optional, list of attributes that task needs in Data hash
        DataParamsRef        => 'HASH',                     # optional, 'HASH' or 'ARRAY', kind of reference of Data->Params
    );

=cut

sub _CheckTaskParams {
    my ( $Self, %Param ) = @_;

    for my $Needed (qw(TaskID Data)) {
        if ( !$Param{$Needed} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Need $Needed! - Task: $Param{TaskName}",
            );

            return;
        }
    }

    # Check data.
    if ( ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => "Got no valid Data! - Task: $Param{TaskName}",
        );

        return;
    }

    # Check mandatory attributes in Data.
    if ( $Param{NeededDataAttributes} && ref $Param{NeededDataAttributes} eq 'ARRAY' ) {

        for my $Needed ( @{ $Param{NeededDataAttributes} } ) {
            if ( !$Param{Data}->{$Needed} ) {
                $Kernel::OM->Get('Kernel::System::Log')->Log(
                    Priority => 'error',
                    Message  => "Need Data->$Needed! - Task: $Param{TaskName}",
                );

                return;
            }
        }
    }

    # Check the structure of Data params.
    if ( $Param{DataParamsRef} ) {

        if ( $Param{Data}->{Params} && ref $Param{Data}->{Params} ne uc $Param{DataParamsRef} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Data->Params is invalid, reference is not $Param{DataParamsRef}! - Task: $Param{TaskName}",
            );

            return;
        }
    }

    return 1;
}
1;

=end Internal:

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<https://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (GPL). If you
did not receive this file, see L<https://www.gnu.org/licenses/gpl-3.0.txt>.

=cut
