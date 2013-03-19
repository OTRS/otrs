# --
# Kernel/System/GenericAgent/TriggerEscalationStartEvents.pm - trigger escalation start events
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericAgent::TriggerEscalationStartEvents;

use strict;
use warnings;

use List::Util qw(first);

use Kernel::System::SLA;
use Kernel::System::Queue;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless $Self, $Type;

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TicketObject TimeObject EncodeObject MainObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    $Self->{SLAObject}   = Kernel::System::SLA->new( %{$Self} );
    $Self->{QueueObject} = Kernel::System::Queue->new( %{$Self} );

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get ticket data
    # the escalation properties are computed within TicketGet().
    my %Ticket = $Self->{TicketObject}->TicketGet(
        %Param,
        DynamicFields => 0,
    );

    my $Calendar;

    # check if ticket has an assigned SLA with a defined calendar
    if ( $Ticket{SLAID} ) {
        my %SLAData = $Self->{SLAObject}->SLAGet(
            SLAID  => $Ticket{SLAID},
            UserID => 1,
        );

        # set $Calendar if SLA has a defined calendar
        $Calendar = $SLAData{Calendar} ? $SLAData{Calendar} : '';
    }

    # check if there was no $Calendar defined via SLA
    if ( !$Calendar ) {

        # check if ticket queue has a defined calendar
        if ( $Ticket{QueueID} ) {
            my %QueueData = $Self->{QueueObject}->QueueGet(
                ID => $Ticket{QueueID},
            );

            # set $Calendar if SLA has a defined calendar
            $Calendar = $QueueData{Calendar} ? $QueueData{Calendar} : '';
        }
    }

    # do not trigger escalation start events outside busincess hours
    my $CountedTime = $Self->{TimeObject}->WorkingTime(
        StartTime => $Self->{TimeObject}->SystemTime() - ( 10 * 60 ),
        StopTime => $Self->{TimeObject}->SystemTime(),
        Calendar => $Calendar || '',
    );
    if ( !$CountedTime ) {
        if ( $Self->{Debug} ) {
            $Self->{LogObject}->Log(
                Priority => 'debug',
                Message =>
                    "Send not escalation for Ticket $Ticket{TicketNumber}/$Ticket{TicketID} because currently no working hours!",
            );
        }
        return 1;
    }

    # needed for deciding whether events should be triggered
    my @HistoryLines = $Self->{TicketObject}->HistoryGet(
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
        my $DecayTimeInSeconds
            = $Self->{ConfigObject}->Get('OTRSEscalationEvents::DecayTime') || 0;
        $DecayTimeInSeconds *= 60;

        # get the last time this event was triggered
        # search in reverse order, as @HistoryLines sorted ascendingly by CreateTime
        if ($DecayTimeInSeconds) {
            my $PrevEventLine
                = first { $_->{HistoryType} eq $TicketAttr2Event{$Attr} }
            reverse @HistoryLines;
            if ( $PrevEventLine && $PrevEventLine->{CreateTime} ) {
                my $PrevEventTime = $Self->{TimeObject}->TimeStamp2SystemTime(
                    String => $PrevEventLine->{CreateTime},
                );
                my $TimeSincePrevEvent = $Self->{TimeObject}->SystemTime() - $PrevEventTime;

                next ATTR if $TimeSincePrevEvent <= $DecayTimeInSeconds;
            }
        }

        # emit the event
        push @Events, $TicketAttr2Event{$Attr};
    }

    for my $Event (@Events) {

        # trigger the event
        $Self->{TicketObject}->EventHandler(
            Event  => $Event,
            UserID => 1,
            Data   => {
                TicketID => $Param{TicketID},
            },
            UserID => 1,
        );

        # log the triggered event in the history
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{TicketID},
            HistoryType  => $Event,
            Name         => "%%$Event%%triggered",
            CreateUserID => 1,
        );
    }

    return 1;
}

1;
