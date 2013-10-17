# --
# Kernel/Output/HTML/DashboardCalendar.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardCalendar;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (
        qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)
        )
    {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;

    return;
}

sub Config {
    my ( $Self, %Param ) = @_;

    return (
        %{ $Self->{Config} },
        CacheKey => 'Calendar' . $Self->{UserID} . '-' . $Self->{LayoutObject}->{UserLanguage},
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # find tickets with reached times in near future
    my $PendingReminderStateTypes = $Self->{ConfigObject}->Get('Ticket::PendingReminderStateType');

    my %Map = (
        Escalation => [

            # text for content table
            'Escalation',

            # search attributes
            {

                # where escalation time reached
                TicketEscalationTimeNewerMinutes => 15,

                # sort
                SortBy  => 'EscalationTime',
                OrderBy => 'Up',
            },
        ],
        Pending => [

            # text for content table
            'Reminder Reached',

            # search attributes
            {

                # only pending reminder tickets
                StateType => $PendingReminderStateTypes,

                # where pending time reached in
                TicketPendingTimeNewerMinutes => 15,

                # sort
                SortBy  => 'PendingTime',
                OrderBy => 'Up',
            },
        ],
    );
    my %Date;
    for my $Type ( sort keys %Map ) {

        my $UID;
        if ( $Self->{Config}->{OwnerOnly} ) {
            $UID = $Self->{UserID};
        }

        # search tickets
        my @TicketIDs = $Self->{TicketObject}->TicketSearch(

            # add search attributes
            %{ $Map{$Type}->[1] },

            Result     => 'ARRAY',
            Permission => $Self->{Config}->{Permission} || 'ro',
            UserID     => $Self->{UserID},
            OwnerID    => $UID,
            Limit      => 25,
        );

        # get ticket attributes
        for my $TicketID (@TicketIDs) {

            my %Ticket = $Self->{TicketObject}->TicketGet(
                TicketID      => $TicketID,
                UserID        => $Self->{UserID},
                DynamicFields => 0,
            );
            my $TimeStamp;
            my $TimeTill;
            if ( $Type eq 'Escalation' ) {
                $TimeTill  = $Ticket{EscalationTime};
                $TimeStamp = $Ticket{EscalationDestinationDate};
            }
            elsif ( $Type eq 'Pending' ) {

                # only show own pending tickets
                next
                    if $Ticket{OwnerID} ne $Self->{UserID}
                        && $Ticket{ResponsibleID} ne $Self->{UserID};
                my $DestDate = $Self->{TimeObject}->SystemTime() + $Ticket{UntilTime};
                $TimeTill  = $Ticket{UntilTime};
                $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
                    SystemTime => $DestDate,
                );
            }

            # remember attributes for content table
            $Date{ $TimeStamp . '::' . $TicketID } = {
                Type         => $Type,
                Text         => $Map{$Type}->[0],
                Object       => 'Ticket',
                ObjectID     => $Ticket{TicketID},
                ObjectNumber => $Ticket{TicketNumber},
                Title        => $Ticket{Title},
                Link         => "Action=AgentTicketZoom;TicketID=$Ticket{TicketID}",
                TimeStamp    => $TimeStamp,
                TimeTill     => $TimeTill,
                In           => $Self->{LayoutObject}->CustomerAge(
                    Age   => $TimeTill,
                    Space => ' ',
                ),
            };
        }
    }

    # show content rows
    my $Count = 0;
    for my $Data ( sort keys %Date ) {
        $Count++;
        last if $Count > $Self->{Config}->{Limit};
        $Self->{LayoutObject}->Block(
            Name => 'ContentSmallCalendarOverviewRow',
            Data => $Date{$Data},
        );
    }

    # fillup if no content exists
    if ( !$Count ) {
        $Self->{LayoutObject}->Block(
            Name => 'ContentSmallCalendarOverviewNone',
            Data => {},
        );
    }

    # render content
    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardCalendarOverview',
        Data         => {
            %{ $Self->{Config} },
        },
    );

    # return content
    return $Content;
}

1;
