# --
# Kernel/Modules/AgentTicketLockedView.pm - to view all locked tickets
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketLockedView.pm,v 1.2 2008-12-08 17:47:06 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::AgentTicketLockedView;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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

    $Self->{Filter}   = $Self->{ParamObject}->GetParam( Param => 'Filter' ) || 'All';
    $Self->{View}     = $Self->{ParamObject}->GetParam( Param => 'View' ) || '';

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

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

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
    my $SortByS         = $SortBy;
    if ( $SortByS eq 'CreateTime' ) {
        $SortByS = 'Age';
    }

    my %Filters = (
        All => {
            Name   => 'All',
            Prio   => 1000,
            Search => {
                Result     => 'ARRAY',
                Limit      => 1000,
                Locks      => ['lock'],
                OwnerIDs   => [ $Self->{UserID} ],
                OrderBy    => $OrderBy,
                SortBy     => $SortByS,
                UserID     => 1,
                Permission => 'ro',
            },
        },
        New => {
            Name   => 'New message',
            Prio   => 1001,
            Search => {
                Result     => 'ARRAY',
                Limit      => 1000,
                Locks      => ['lock'],
                OwnerIDs   => [ $Self->{UserID} ],
                OrderBy    => $OrderBy,
                SortBy     => $SortByS,
                UserID     => 1,
                Permission => 'ro',
            },
        },
        Reminder => {
            Name   => 'Reminder',
            Prio   => 1002,
            Search => {
                Result         => 'ARRAY',
                Limit          => 1000,
                StateType      => ['pending reminder', 'pending auto'],
                OwnerIDs       => [ $Self->{UserID} ],
                OrderBy        => $OrderBy,
                SortBy         => $SortByS,
                UserID         => 1,
                Permission     => 'ro',
            },
        },
        ReminderReached => {
            Name   => 'Reminder messages',
            Prio   => 1003,
            Search => {
                Result         => 'ARRAY',
                Limit          => 1000,
                StateType      => ['pending reminder', 'pending auto'],
                OwnerIDs       => [ $Self->{UserID} ],
                OrderBy        => $OrderBy,
                SortBy         => $SortByS,
                UserID         => 1,
                Permission     => 'ro',
            },
        },
    );

    # check if filter is valid
    if ( !$Filters{ $Self->{Filter} } ) {
        $Self->{LayoutObject}->FatalError( Message => "Invalid Filter: $Self->{Filter}!" );
    }

    my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
        %{ $Filters{ $Self->{Filter} }->{Search} },
        Result     => 'ARRAY',
        Limit      => 1000,
    );

    # prepare new message tickets
    if ( $Self->{Filter} eq 'New') {
        my @ViewableTicketsTmp;
        my %LockedData = $Self->{TicketObject}->GetLockedCount( UserID => $Self->{UserID} );
        for my $TicketID (@ViewableTickets) {
            # check what tickets are new
            my $Message = '';
            if ( $LockedData{NewTicketIDs}->{$TicketID} ) {
                $Message = 'New message!';
                push( @ViewableTicketsTmp, $TicketID );
            }
        }
        @ViewableTickets = @ViewableTicketsTmp;
    }
    elsif ( $Self->{Filter} eq 'ReminderReached') {
        my @ViewableTicketsTmp;
        for my $TicketID (@ViewableTickets) {
            my @Index = $Self->{TicketObject}->ArticleIndex( TicketID => $TicketID );
            if (@Index) {
                my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Index[-1] );
                if ( $Article{UntilTime} < 1 ) {
                    push( @ViewableTicketsTmp, $TicketID );
                }
            }
        }
        @ViewableTickets = @ViewableTicketsTmp;
    }

    my %NavBarFilter;
    for my $Filter ( keys %Filters ) {
        my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{ $Filter }->{Search} },
            Result     => 'ARRAY',
            Limit      => 1000,
        );

        if ( $Filter eq 'New') {
            my @ViewableTicketsTmp;
            my %LockedData = $Self->{TicketObject}->GetLockedCount( UserID => $Self->{UserID} );
            # check what tickets are new
            for my $TicketID (@ViewableTickets) {
                my $Message = '';
                if ( $LockedData{NewTicketIDs}->{$TicketID} ) {
                    $Message = 'New message!';
                    push( @ViewableTicketsTmp, $TicketID );
                }
            }
            @ViewableTickets = @ViewableTicketsTmp;
        }
        elsif ( $Filter eq 'ReminderReached') {
            my @ViewableTicketsTmp;
            for my $TicketID (@ViewableTickets) {
                my @Index = $Self->{TicketObject}->ArticleIndex( TicketID => $TicketID );
                if (@Index) {
                    my %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Index[-1] );
                    if ( $Article{UntilTime} < 1 ) {
                        push( @ViewableTicketsTmp, $TicketID );
                    }
                }
            }
            @ViewableTickets = @ViewableTicketsTmp;
        }

        $NavBarFilter{ $Filters{ $Filter }->{Prio} } = {
            Count  => scalar @ViewableTickets,
            Filter => $Filter,
            %{ $Filters{ $Filter } },
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
    my $LinkFilter = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $SortBy )
        . '&OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $OrderBy )
        . '&View=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{View} )
        . '&';
    $Output .= $Self->{LayoutObject}->TicketListShow(
        TicketIDs => \@ViewableTickets,
        Total      => scalar @ViewableTickets,

        View       => $Self->{View},

        Filter     => $Self->{Filter},
        Filters    => \%NavBarFilter,
        FilterLink => $LinkFilter,

        TitleName  => 'My Locked Tickets',
        TitleValue => $Self->{Filter},
        Bulk       => 1,

        Env        => $Self,
        LinkPage   => $LinkPage,
        LinkSort   => $LinkSort,

    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
