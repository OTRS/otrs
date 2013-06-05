# --
# Kernel/Modules/AgentTicketResponsibleView.pm - to view all locked tickets
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketResponsibleView;

use strict;
use warnings;

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

    $Self->{Filter} = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || 'All';
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

    # starting with page ...
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->Header( Refresh => $Refresh, );
    $Output .= $Self->{LayoutObject}->NavigationBar();
    $Self->{LayoutObject}->Print( Output => \$Output );
    $Output = '';

    # get locked  viewable tickets...
    my $SortByS = $SortBy;
    if ( $SortByS eq 'CreateTime' ) {
        $SortByS = 'Age';
    }

    my %Filters = (
        All => {
            Name   => 'All',
            Prio   => 1000,
            Search => {
                StateType      => 'Open',
                ResponsibleIDs => [ $Self->{UserID} ],
                OrderBy        => $OrderBy,
                SortBy         => $SortByS,
                UserID         => 1,
                Permission     => 'ro',
            },
        },
        New => {
            Name   => 'New Article',
            Prio   => 1001,
            Search => {
                StateType      => 'Open',
                ResponsibleIDs => [ $Self->{UserID} ],
                TicketFlag     => {
                    Seen => 1,
                },
                TicketFlagUserID => $Self->{UserID},
                OrderBy          => $OrderBy,
                SortBy           => $SortByS,
                UserID           => 1,
                Permission       => 'ro',
            },
        },
        Reminder => {
            Name   => 'Pending',
            Prio   => 1002,
            Search => {
                StateType => [ 'pending reminder', 'pending auto' ],
                ResponsibleIDs => [ $Self->{UserID} ],
                OrderBy        => $OrderBy,
                SortBy         => $SortByS,
                UserID         => 1,
                Permission     => 'ro',
            },
        },
        ReminderReached => {
            Name   => 'Reminder Reached',
            Prio   => 1003,
            Search => {
                StateType                     => ['pending reminder'],
                TicketPendingTimeOlderMinutes => 1,
                ResponsibleIDs                => [ $Self->{UserID} ],
                OrderBy                       => $OrderBy,
                SortBy                        => $SortByS,
                UserID                        => 1,
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
        Limit  => 1_000,
    );

    # prepare shown tickets for new article tickets
    if ( $Self->{Filter} eq 'New' ) {
        my @ViewableTicketsAll = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{'All'}->{Search} },
            Result => 'ARRAY',
            Limit  => 1_000,
        );
        my %ViewableTicketsNotNew;
        for my $TicketID (@ViewableTickets) {
            $ViewableTicketsNotNew{$TicketID} = 1;
        }

        my @ViewableTicketsTmp;
        for my $TicketIDAll (@ViewableTicketsAll) {
            next if $ViewableTicketsNotNew{$TicketIDAll};
            push @ViewableTicketsTmp, $TicketIDAll;
        }
        @ViewableTickets = @ViewableTicketsTmp;
    }

    my %NavBarFilter;
    for my $Filter ( sort keys %Filters ) {
        my $Count = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{$Filter}->{Search} },
            Result => 'COUNT',
        );

        # prepare count for new article tickets
        if ( $Filter eq 'New' ) {
            my $CountAll = $Self->{TicketObject}->TicketSearch(
                %{ $Filters{All}->{Search} },
                Result => 'COUNT',
            );
            $Count = $CountAll - $Count;
        }

        $NavBarFilter{ $Filters{$Filter}->{Prio} } = {
            Count  => $Count,
            Filter => $Filter,
            %{ $Filters{$Filter} },
        };
    }

    # show tickets
    my $LinkPage = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';';
    my $LinkSort = 'Filter='
        . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';';
    my $LinkFilter = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . ';View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . ';';
    $Output .= $Self->{LayoutObject}->TicketListShow(
        TicketIDs => \@ViewableTickets,
        Total     => scalar @ViewableTickets,

        View => $Self->{View},

        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,

        TitleName  => 'My Responsible Tickets',
        TitleValue => $Filters{ $Self->{Filter} }->{Name},
        Bulk       => 1,

        Env      => $Self,
        LinkPage => $LinkPage,
        LinkSort => $LinkSort,

        OrderBy => $OrderBy,
        SortBy  => $SortBy,
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
