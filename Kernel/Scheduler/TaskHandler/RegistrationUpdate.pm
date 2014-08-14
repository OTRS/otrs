# --
# Kernel/Scheduler/TaskHandler/RegistrationUpdate.pm - Scheduler task handler RegistrationUpdate backend
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Scheduler::TaskHandler::RegistrationUpdate;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Registration',
    'Kernel::System::Time',
);

=head1 NAME

Kernel::Scheduler::TaskHandler::RegistrationUpdate - RegistrationUpdate backend of the TaskHandler for the Scheduler

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::Scheduler::TaskHandler->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Run()

performs the selected RegistrationUpdate task.

    my $Result = $TaskHandlerObject->Run(
        Data     => {
            Success           => 1,                # 0 or 1, controls return value
            ReSchedule        => $ReSchedule,      # 0 or 1, constrols re-scheduling
            ReScheduleDueTime => $TimeStamp,
            ReScheduleData    => $Data,
        },
    );

Returns:

    $Result = {
        Success    => 1,                     # 0 or 1
        ReSchedule => $ReSchedule,
        DueTime    => $TimeStamp,
        Data       => $Data
    };

=cut

sub Run {
    my ( $Self, %Param ) = @_;

    # check data - we need a hash ref
    if ( $Param{Data} && ref $Param{Data} ne 'HASH' ) {
        $Kernel::OM->Get('Kernel::System::Log')->Log(
            Priority => 'error',
            Message  => 'Got no valid Data!',
        );

        return {
            Success => 0,
        };
    }

    $Kernel::OM->Get('Kernel::System::Log')->Log(
        Priority => 'info',
        Message  => "Registration - RegistrationUpdate running.",
    );
    my %Result = $Kernel::OM->Get('Kernel::System::Registration')->RegistrationUpdateSend();

    # if we sent a successful Update, reschedule in whatever the OTRS
    # portal tells us. Otherwise, retry in two hours
    my $ReSchedule = $Result{ReScheduleIn} // ( 3600 * 2 );

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    my $SystemTime = $TimeObject->SystemTime();

    my $ReScheduleTime = $TimeObject->SystemTime2TimeStamp(
        SystemTime => ( $SystemTime + $ReSchedule ),
    );

    # re-schedule with new time
    return {
        Success    => $Result{Success},
        ReSchedule => $Param{Data}->{ReSchedule},
        DueTime    => $ReScheduleTime,
        Data       => { ReSchedule => $Param{Data}->{ReSchedule} },
    };
}

1;

=back

=head1 TERMS AND CONDITIONS

This software is part of the OTRS project (L<http://otrs.org/>).

This software comes with ABSOLUTELY NO WARRANTY. For details, see
the enclosed file COPYING for license information (AGPL). If you
did not receive this file, see L<http://www.gnu.org/licenses/agpl.txt>.

=cut
