# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

=head1 SYNOPSIS

Base class for scheduler daemon task worker modules.

=head1 PUBLIC INTERFACE

=over 4

=cut

=item _HandleError()

creates a system error message and sends an email with the error messages form a task execution

    my $Success = $TaskWorkerObject->_HandleError(
        TaskName     => 'some name',
        TaksTye      => 'some type',
        LogMessage   => 'some message',       # message to set in the OTRS error log
        ErrorMessage => 'some message',       # message to be sent ad a body of the email, usually contains
                                              #     all messages from STDERR including tracebacks
    );

=cut

sub _HandleError {
    my ( $Self, %Param ) = @_;

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'error',
        Message  => $Param{LogMessage},
    );

    # get config object
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

        return $Sent;
    }

    return;
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
