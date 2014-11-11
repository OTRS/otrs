# --
# Kernel/Output/HTML/DashboardCalendar.pm
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardCalendar;

use strict;
use warnings;

our $ObjectManagerDisabled = 1;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for my $Needed (qw(Config Name UserID)) {
        die "Got no $Needed!" if ( !$Self->{$Needed} );
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
        CacheKey => 'Calendar'
            . $Self->{UserID} . '-'
            . $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{UserLanguage},
    );
}

sub Run {
    my ( $Self, %Param ) = @_;

    # find tickets with reached times in near future
    my $PendingReminderStateTypes = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::PendingReminderStateType');

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

    # get needed objects
    my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    my %Date;
    for my $Type ( sort keys %Map ) {

        my $UID;
        if ( $Self->{Config}->{OwnerOnly} ) {
            $UID = $Self->{UserID};
        }

        # search tickets
        my @TicketIDs = $TicketObject->TicketSearch(

            # add search attributes
            %{ $Map{$Type}->[1] },

            Result     => 'ARRAY',
            Permission => $Self->{Config}->{Permission} || 'ro',
            UserID     => $Self->{UserID},
            OwnerID    => $UID,
            Limit      => 25,
        );

        # get ticket attributes
        TICKETID:
        for my $TicketID (@TicketIDs) {

            my %Ticket = $TicketObject->TicketGet(
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
                if (
                    $Ticket{OwnerID} ne $Self->{UserID}
                    && $Ticket{ResponsibleID} ne $Self->{UserID}
                    )
                {
                    next TICKETID;
                }
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
                In           => $LayoutObject->CustomerAge(
                    Age   => $TimeTill,
                    Space => ' ',
                ),
            };
        }
    }

    # show content rows
    my $Count = 0;
    DATE:
    for my $Data ( sort keys %Date ) {
        $Count++;
        last DATE if $Count > $Self->{Config}->{Limit};
        $LayoutObject->Block(
            Name => 'ContentSmallCalendarOverviewRow',
            Data => $Date{$Data},
        );
    }

    # fill-up if no content exists
    if ( !$Count ) {
        $LayoutObject->Block(
            Name => 'ContentSmallCalendarOverviewNone',
            Data => {},
        );
    }

    # render content
    my $Content = $LayoutObject->Output(
        TemplateFile => 'AgentDashboardCalendarOverview',
        Data         => {
            %{ $Self->{Config} },
        },
    );

    # return content
    return $Content;
}

1;
