# --
# Kernel/Output/HTML/DashboardCalendar.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: DashboardCalendar.pm,v 1.4 2009-06-09 11:45:34 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardCalendar;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
    for (qw(Config Name ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)) {
        die "Got no $_!" if ( !$Self->{$_} );
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my %Map = (
        Escalation => [ 'TicketEscalation', 'Escalation', ],
        Pending    => [ 'TicketPending', 'Reminder Reached', ],
    );

    my %Date;

    for my $Type ( sort keys %Map ) {

        my @TicketIDs = $Self->{TicketObject}->TicketSearch(

            # ticket escalations over 60 minutes (optional)
#            $Map{ $Type }->[0] . 'TimeOlderMinutes' => -30,
            # ticket escalations in 120 minutes (optional)
            $Map{ $Type }->[0] . 'TimeNewerMinutes' => ( 60 * 18 ),

            Result     => 'ARRAY',
            Permission => $Self->{Config}->{Permission} || 'ro',
            UserID     => $Self->{UserID},
            Limit      => 20,
        );
        for my $TicketID (@TicketIDs) {

            my %Ticket = $Self->{TicketObject}->TicketGet(
                TicketID => $TicketID,
                UserID   => $Self->{UserID},
            );
            my $TimeStamp;
            my $TimeTill;
            if ( $Type eq 'Escalation' ) {
                my $DestDate = $Ticket{EscalationTime};
                $TimeTill = $Self->{TimeObject}->SystemTime() - $Ticket{EscalationTime};
                $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
                    SystemTime => $DestDate,
                );
            }
            elsif ( $Type eq 'Pending' ) {
                my $DestDate = $Self->{TimeObject}->SystemTime() + $Ticket{UntilTime};
                $TimeTill = $Ticket{UntilTime};
                $TimeStamp = $Self->{TimeObject}->SystemTime2TimeStamp(
                    SystemTime => $DestDate,
                );
            }

            $Date{$TimeStamp} = {
                Type         => $Type,
                Text         => $Map{ $Type }->[1],
                Object       => 'Ticket',
                ObjectID     => $Ticket{TicketID},
                ObjectNumber => $Ticket{TicketNumber},
                Title        => $Ticket{Title},
                Link         => "Action=AgentTicketZoom&TicketID=$Ticket{TicketID}",
                TimeStamp    => $TimeStamp,
                TimeTill     => $TimeTill,
                In           => $Self->{LayoutObject}->CustomerAge(
                    Age   => $TimeTill,
                    Space => ' ',
                ),
            };
        }
    }

    my $Count = 0;
    for my $Data ( sort keys %Date ) {
        $Count++;
        last if $Count > $Self->{Config}->{Limit};
        $Self->{LayoutObject}->Block(
            Name => 'ContentSmallCalendarOverviewRow',
            Data => $Date{$Data},
        );
    }

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardCalendarOverview',
        Data         => {
            %{ $Self->{Config} },
        },
    );

    if ( !%Date ) {
        $Content = '$Text{"none"}';
    }

    $Self->{LayoutObject}->Block(
        Name => 'ContentSmall',
        Data => {
            %{ $Self->{Config} },
            Name    => $Self->{Name},
            Content => $Content,
        },
    );

    return 1;
}

1;
