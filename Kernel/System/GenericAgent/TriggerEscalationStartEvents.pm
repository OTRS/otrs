# --
# Kernel/System/GenericAgent/TriggerEscalationStartEvents.pm - trigger escalation start events
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericAgent::TriggerEscalationStartEvents;

use strict;
use warnings;

use List::Util qw(first);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::Log',
    'Kernel::System::Queue',
    'Kernel::System::SLA',
    'Kernel::System::Ticket',
    'Kernel::System::Time',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless $Self, $Type;

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get ticket object
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # get ticket data
    # the escalation properties are computed within TicketGet().
    my %Ticket = $TicketObject->TicketGet(
        %Param,
        DynamicFields => 0,
    );

    # get used calendar
    my $Calendar = $TicketObject->TicketCalendarGet(
        %Ticket,
    );

    # get time object
    my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

    # do not trigger escalation start events outside busincess hours
    my $CountedTime = $TimeObject->WorkingTime(
        StartTime => $TimeObject->SystemTime() - ( 10 * 60 ),
        StopTime  => $TimeObject->SystemTime(),
        Calendar  => $Calendar,
    );
    if ( !$CountedTime ) {

        if ( $Self->{Debug} ) {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'debug',
                Message =>
                    "Send not escalation for Ticket $Ticket{TicketNumber}/$Ticket{TicketID} because currently no working hours!",
            );
        }

        return 1;
    }

    # needed for deciding whether events should be triggered
    my @HistoryLines = $TicketObject->HistoryGet(
        TicketID => $Ticket{TicketID},
        UserID   => 1,
    );

    # check if it's a escalation or escalation notification
    # check escalation times
    my %TicketAttr2Event = (
        FirstResponseTimeEscalation   => 'EscalationResponseTimeStart',
        UpdateTimeEscalation          => 'EscalationUpdateTimeStart',
        SolutionTimeEscalation        => 'EscalationSolutionTimeStart',
        FirstResponseTimeNotification => 'EscalationResponseTimeNotifyBefore',
        UpdateTimeNotification        => 'EscalationUpdateTimeNotifyBefore',
        SolutionTimeNotification      => 'EscalationSolutionTimeNotifyBefore',
    );
    my @Events;

    # triggering summary events is currently (2010-12-03) disabled
    #my ( $FoundEscalation, $FoundNotifyBefore ) = ( 0, 0 );
    ATTR:
    for my $Attr ( grep { defined $Ticket{$_} } sort keys %TicketAttr2Event ) {

        # the decay time is configured in minutes
        my $DecayTimeInSeconds = $Kernel::OM->Get('Kernel::Config')->Get('OTRSEscalationEvents::DecayTime') || 0;

        $DecayTimeInSeconds *= 60;

        # get the last time this event was triggered
        # search in reverse order, as @HistoryLines sorted ascendingly by CreateTime
        if ($DecayTimeInSeconds) {
            my $PrevEventLine = first { $_->{HistoryType} eq $TicketAttr2Event{$Attr} }
            reverse @HistoryLines;
            if ( $PrevEventLine && $PrevEventLine->{CreateTime} ) {
                my $PrevEventTime = $TimeObject->TimeStamp2SystemTime(
                    String => $PrevEventLine->{CreateTime},
                );
                my $TimeSincePrevEvent = $TimeObject->SystemTime() - $PrevEventTime;

                next ATTR if $TimeSincePrevEvent <= $DecayTimeInSeconds;
            }
        }

        # emit the event
        push @Events, $TicketAttr2Event{$Attr};
    }

    for my $Event (@Events) {

        # trigger the event
        $TicketObject->EventHandler(
            Event  => $Event,
            UserID => 1,
            Data   => {
                TicketID => $Param{TicketID},
            },
            UserID => 1,
        );

        # log the triggered event in the history
        $TicketObject->HistoryAdd(
            TicketID     => $Param{TicketID},
            HistoryType  => $Event,
            Name         => "%%$Event%%triggered",
            CreateUserID => 1,
        );
    }

    return 1;
}

1;
