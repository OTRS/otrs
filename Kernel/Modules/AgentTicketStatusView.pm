# --
# Kernel/Modules/AgentTicketStatusView.pm - status for all open tickets
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketStatusView.pm,v 1.22 2009-01-09 08:43:41 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketStatusView;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.22 $) [1];

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

    $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || 'Open';
    $Self->{View}   = $Self->{ParamObject}->GetParam( Param => 'View' )   || '';

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $SortBy = $Self->{ParamObject}->GetParam( Param => 'SortBy' )
        || $Self->{Config}->{'SortBy::Default'}
        || 'Age';
    my $OrderBy = $Self->{ParamObject}->GetParam( Param => 'OrderBy' )
        || $Self->{Config}->{'Order::Default'}
        || 'Up';

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

    # define filter
    my %Filters = (
        Open => {
            Name   => 'open',
            Prio   => 1000,
            Search => {
                StateType  => 'Open',
                OrderBy    => $OrderBy,
                SortBy     => $SortBy,
                UserID     => $Self->{UserID},
                Permission => 'ro',
            },
        },
        Closed => {
            Name   => 'closed',
            Prio   => 1001,
            Search => {
                StateType  => 'Closed',
                OrderBy    => $OrderBy,
                SortBy     => $SortBy,
                UserID     => $Self->{UserID},
                Permission => 'ro',
            },
        },
    );

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    # do shown tickets lookup
    my $Limit = 10_000;
    my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
        %{ $Filters{ $Self->{Filter} }->{Search} },
        Limit  => $Limit,
        Result => 'ARRAY',
    );
    my $ViewableTicketCount = $Self->{TicketObject}->TicketSearch(
        %{ $Filters{ $Self->{Filter} }->{Search} },
        Result => 'COUNT',
    );
    if ( $ViewableTicketCount > $Limit ) {
        $ViewableTicketCount = $Limit;
    }

    # do nav bar lookup
    my %NavBarFilter;
    for my $Filter ( keys %Filters ) {
        my $Count = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{$Filter}->{Search} },
            Result => 'COUNT',
        );
        if ( $Count > $Limit ) {
            $Count = $Limit;
        }

        $NavBarFilter{ $Filters{$Filter}->{Prio} } = {
            Count  => $Count,
            Filter => $Filter,
            %{ $Filters{$Filter} },
        };
    }

    # show ticket's
    my $LinkPage = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . '&';
    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&';
    my $FilterLink = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&';
    $Output .= $Self->{LayoutObject}->TicketListShow(
        TicketIDs  => \@ViewableTickets,
        Total      => $ViewableTicketCount,
        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,
        View       => $Self->{View},
        Bulk       => 1,
        Limit      => $Limit,
        TitleName  => 'Status View',
        TitleValue => $Self->{Filter},

        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $FilterLink,
    );

    # get page footer
    $Output .= $Self->{LayoutObject}->Footer();

    # return page
    return $Output;
}

1;
