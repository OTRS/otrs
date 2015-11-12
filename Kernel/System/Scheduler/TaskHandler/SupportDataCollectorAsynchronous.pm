# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::Scheduler::TaskHandler::SupportDataCollectorAsynchronous;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::Log',
    'Kernel::System::Registration',
    'Kernel::System::SupportDataCollector',
    'Kernel::System::Time',
);

=head1 NAME

Kernel::System::Scheduler::TaskHandler::SupportDataCollectorAsynchronous - SupportDataCollectorAsynchronous backend of the TaskHandler for the Scheduler

=head1 SYNOPSIS

=head1 PUBLIC INTERFACE

=over 4

=cut

=item new()

usually, you want to create an instance of this
by using Kernel::System::Scheduler::TaskHandler->new();

=cut

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {};
    bless( $Self, $Type );

    return $Self;
}

=item Run()

performs the selected SupportDataCollectorAsynchronous task.

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

    my $Success = $Kernel::OM->Get('Kernel::System::SupportDataCollector')->CollectAsynchronous();

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # generate a timestamp for the current hour
    my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WeekDay ) = $TimeObject->SystemTime2Date(
        SystemTime => $TimeObject->SystemTime(),
    );

    my $SystemTime = $TimeObject->Date2SystemTime(
        Year   => $Year,
        Month  => $Month,
        Day    => $Day,
        Hour   => $Hour,
        Minute => 0,
        Second => 0,
    );

    # next run in one hour
    my $ReScheduleTime = $TimeObject->SystemTime2TimeStamp(
        SystemTime => ( $SystemTime + 3600 ),
    );

    # re-schedule with new time
    return {
        Success    => $Success,
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
