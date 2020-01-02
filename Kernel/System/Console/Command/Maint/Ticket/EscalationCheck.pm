# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::System::Console::Command::Maint::Ticket::EscalationCheck;

use strict;
use warnings;

use List::Util qw(first);

use parent qw(Kernel::System::Console::BaseCommand);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::System::DateTime',
    'Kernel::System::Ticket',
);

sub Configure {
    my ( $Self, %Param ) = @_;

    $Self->Description('Trigger ticket escalation events and notification events for escalation.');

    return;
}

# =item Run()
#
# looks for the tickets which will escalate within the next five days
# then perform a search over the values on the TicketGet result
# for checking if any of the escalations values are present, then base
# on that the notification events for notifications and normal escalation
# events are trigger
#
# NotificationEvents:
#     - NotificationEscalation
#     - NotificationEscalationNotifyBefore
#
# Escalation events:
#     - EscalationResponseTimeStart
#     - EscalationUpdateTimeStart
#     - EscalationSolutionTimeStart
#     - EscalationResponseTimeNotifyBefore
#     - EscalationUpdateTimeNotifyBefore
#     - EscalationSolutionTimeNotifyBefore
#
#
# NotificationEvents are alway triggered, and Escalation events just
# base on the 'OTRSEscalationEvents::DecayTime'.
#
# =cut

sub Run {
    my ( $Self, %Param ) = @_;

    $Self->Print("<yellow>Processing ticket escalation events ...</yellow>\n");

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

    # the decay time is configured in minutes
    my $DecayTimeInSeconds = $Kernel::OM->Get('Kernel::Config')->Get('OTRSEscalationEvents::DecayTime') || 0;
    $DecayTimeInSeconds *= 60;

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

    # Find all tickets which will escalate within the next five days.
    my @Tickets = $TicketObject->TicketSearch(
        Result                           => 'ARRAY',
        Limit                            => 1000,
        TicketEscalationTimeOlderMinutes => -( 5 * 24 * 60 ),
        Permission                       => 'rw',
        UserID                           => 1,
    );

    TICKET:
    for my $TicketID (@Tickets) {

        # get ticket data
        my %Ticket = $TicketObject->TicketGet(
            TicketID      => $TicketID,
            DynamicFields => 0,
        );

        # get used calendar
        my $Calendar = $TicketObject->TicketCalendarGet(
            %Ticket,
        );

        # check if it is during business hours, then send escalation info
        my $BusinessStartDTObject = $Kernel::OM->Create('Kernel::System::DateTime');
        $BusinessStartDTObject->Subtract( Seconds => 10 * 60 );

        my $BusinessStopDTObject = $Kernel::OM->Create('Kernel::System::DateTime');

        my $CountedTime = $BusinessStartDTObject->Delta(
            DateTimeObject => $BusinessStopDTObject,
            ForWorkingTime => 1,
            Calendar       => $Calendar,
        );

        # don't trigger events if not counted time
        if ( !$CountedTime || !$CountedTime->{AbsoluteSeconds} ) {
            next TICKET;
        }

        # needed for deciding whether events should be triggered
        my @HistoryLines = $TicketObject->HistoryGet(
            TicketID => $TicketID,
            UserID   => 1,
        );

        # check if it's a escalation of escalation notification
        # check escalation times
        my $EscalationType = 0;
        my @Events;
        TYPE:
        for my $Type (
            qw(FirstResponseTimeEscalation UpdateTimeEscalation SolutionTimeEscalation
            FirstResponseTimeNotification UpdateTimeNotification SolutionTimeNotification)
            )
        {
            next TYPE if !$Ticket{$Type};

            my @ReversedHistoryLines = reverse @HistoryLines;

            # get the last time this event was triggered
            # search in reverse order, as @HistoryLines sorted ascendingly by CreateTime
            if ($DecayTimeInSeconds) {

                my $PrevEventLine = first { $_->{HistoryType} eq $TicketAttr2Event{$Type} }
                @ReversedHistoryLines;

                if ( $PrevEventLine && $PrevEventLine->{CreateTime} ) {
                    my $PrevEventTime = $Kernel::OM->Create(
                        'Kernel::System::DateTime',
                        ObjectParams => {
                            String => $PrevEventLine->{CreateTime},
                        },
                    )->ToEpoch();

                    my $CurSysTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

                    my $TimeSincePrevEvent = $CurSysTime - $PrevEventTime;

                    next TYPE if $TimeSincePrevEvent <= $DecayTimeInSeconds;
                }
            }

            # emit the event
            push @Events, $TicketAttr2Event{$Type};

            if ( !$EscalationType ) {
                if ( $Type =~ /TimeEscalation$/ ) {
                    push @Events, 'NotificationEscalation';
                    $EscalationType = 1;
                }
                elsif ( $Type =~ /TimeNotification$/ ) {
                    push @Events, 'NotificationEscalationNotifyBefore';
                    $EscalationType = 1;
                }
            }
        }

        EVENT:
        for my $Event (@Events) {

            # trigger the event
            $TicketObject->EventHandler(
                Event  => $Event,
                UserID => 1,
                Data   => {
                    TicketID              => $TicketID,
                    CustomerMessageParams => {
                        TicketNumber => $Ticket{TicketNumber},
                    },
                },
                UserID => 1,
            );

            $Self->Print(
                "Ticket <yellow>$TicketID</yellow>: event <yellow>$Event</yellow>, processed.\n"
            );

            if ( $Event eq 'NotificationEscalation' || $Event eq 'NotificationEscalationNotifyBefore' ) {
                next EVENT;
            }

            # log the triggered event in the history
            $TicketObject->HistoryAdd(
                TicketID     => $TicketID,
                HistoryType  => $Event,
                Name         => "%%$Event%%triggered",
                CreateUserID => 1,
            );
        }
    }

    $Self->Print("<green>Done.</green>\n");
    return $Self->ExitCodeOk();
}

1;
