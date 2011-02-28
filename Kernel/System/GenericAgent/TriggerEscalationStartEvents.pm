# --
# Kernel/System/GenericAgent/TriggerEscalationStartEvents.pm - trigger escalation start events
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: TriggerEscalationStartEvents.pm,v 1.1 2011-02-28 09:41:24 bes Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::System::GenericAgent::TriggerEscalationStartEvents;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

use List::Util qw(first);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless $Self, $Type;

    # check needed objects
    for (qw(DBObject ConfigObject LogObject TicketObject TimeObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    # 0=off; 1=on;
    $Self->{Debug} = $Param{Debug} || 0;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get ticket data
    # the escalation properties are computed within TicketGet().
    my %Ticket = $Self->{TicketObject}->TicketGet(%Param);

    # do not trigger escalation start events outside busincess hours
    my $CountedTime = $Self->{TimeObject}->WorkingTime(
        StartTime => $Self->{TimeObject}->SystemTime() - ( 10 * 60 ),
        StopTime => $Self->{TimeObject}->SystemTime(),
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

        # for deciding whether EscalationStart or EscalationNotifyBefore should be emitted
        #if ( $Attr =~ m{ TimeEscalation }xms ) {
        #    $FoundEscalation++;
        #}
        #elsif ( $Attr =~ m{ TimeNotification }xms ) {
        #    $FoundNotifyBefore++;
        #}
    }

    # add special summary events
    #if ($FoundEscalation) {
    #    unshift @Events, 'EscalationStart';
    #}
    #elsif ($FoundNotifyBefore) {
    #    unshift @Events, 'EscalationNotifyBefore';
    #}

    for my $Event (@Events) {

        # trigger the event
        $Self->{TicketObject}->EventHandler(
            Event  => $Event,
            UserID => 1,
            Data   => {
                TicketID => $Param{TicketID},
            },
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
