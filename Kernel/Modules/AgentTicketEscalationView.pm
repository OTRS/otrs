# --
# Kernel/Modules/AgentTicketEscalationView.pm - status for all open tickets
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketEscalationView.pm,v 1.11 2009-02-16 11:20:53 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketEscalationView;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject UserObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    # get params
    $Self->{SortBy} = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'EscalationTime';
    $Self->{OrderBy} = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Up';

    # viewable tickets a page
    $Self->{Limit} = $Self->{ParamObject}->GetParam( Param => 'Limit' ) || 2000;

    $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || 'Today';
    $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # store last queue screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
        Value     => $Self->{RequestedURL},
    );

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # starting with page ...
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh, );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Self->{LayoutObject}->Print( Output => \$Output );
    $Output = '';

    my ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime() + 60 * 60 * 24 * 7,
    );
    my $TimeStampNextWeek = "$Year-$Month-$Day 23:59:59";

    ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime() + 60 * 60 * 24,
    );
    my $TimeStampTomorrow = "$Year-$Month-$Day 23:59:59";

    ( $Sec, $Min, $Hour, $Day, $Month, $Year ) = $Self->{TimeObject}->SystemTime2Date(
        SystemTime => $Self->{TimeObject}->SystemTime(),
    );
    my $TimeStampToday = "$Year-$Month-$Day 23:59:59";

    my %Filters = (
        Today => {
            Name   => 'Today',
            Prio   => 1000,
            Search => {
                TicketEscalationTimeOlderDate => $TimeStampToday,
                OrderBy                       => $Self->{OrderBy},
                SortBy                        => $Self->{SortBy},
                UserID                        => $Self->{UserID},
                Permission                    => 'ro',
            },
        },
        Tomorrow => {
            Name   => 'Tomorrow',
            Prio   => 2000,
            Search => {
                TicketEscalationTimeOlderDate => $TimeStampTomorrow,
                OrderBy                       => $Self->{OrderBy},
                SortBy                        => $Self->{SortBy},
                UserID                        => $Self->{UserID},
                Permission                    => 'ro',
            },
        },
        NextWeek => {
            Name   => 'Next Week',
            Prio   => 3000,
            Search => {
                TicketEscalationTimeOlderDate => $TimeStampNextWeek,
                OrderBy                       => $Self->{OrderBy},
                SortBy                        => $Self->{SortBy},
                UserID                        => $Self->{UserID},
                Permission                    => 'ro',
            },
        },
    );

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
        %{ $Filters{ $Self->{Filter} }->{Search} },
        Result => 'ARRAY',
        Limit  => $Self->{Limit},
    );

    my %NavBarFilter;
    for my $Filter ( keys %Filters ) {
        my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{$Filter}->{Search} },
            Result => 'ARRAY',
            Limit  => $Self->{Limit},
        );
        $NavBarFilter{ $Filters{$Filter}->{Prio} } = {
            Count  => scalar @ViewableTickets,
            Filter => $Filter,
            %{ $Filters{$Filter} },
        };
    }

    # show ticket's
    my $LinkPage = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
        . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{OrderBy} )
        . '&';
    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&';
    my $LinkFilter = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
        . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{OrderBy} )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&';
    $Output .= $Self->{LayoutObject}->TicketListShow(
        TicketIDs => \@ViewableTickets,
        Total     => scalar @ViewableTickets,

        View => $Self->{View},

        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,

        TitleName  => 'Ticket Escalation View',
        TitleValue => $Self->{Filter},
        Bulk       => 1,

        Env      => $Self,
        LinkPage => $LinkPage,
        LinkSort => $LinkSort,

        Escalation => 1,
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
