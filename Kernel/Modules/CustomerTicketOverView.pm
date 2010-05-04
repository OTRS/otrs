# --
# Kernel/Modules/CustomerTicketOverView.pm - status for all open tickets
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: CustomerTicketOverView.pm,v 1.56 2010-05-04 01:25:50 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketOverView;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.56 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check all needed objects
    for (qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }
    $Self->{StateObject}        = Kernel::System::State->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    # all static variables
    $Self->{ViewableSenderTypes} = $Self->{ConfigObject}->Get('Ticket::ViewableSenderTypes')
        || $Self->{LayoutObject}->FatalError(
        Message => 'No Config entry "Ticket::ViewableSenderTypes"!'
        );

    # get params
    $Self->{Filter}   = $Self->{ParamObject}->GetParam( Param => 'Filter' )   || 'Open';
    $Self->{SortBy}   = $Self->{ParamObject}->GetParam( Param => 'SortBy' )   || 'Age';
    $Self->{Order}    = $Self->{ParamObject}->GetParam( Param => 'Order' )    || 'Down';
    $Self->{StartHit} = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;
    $Self->{PageShown} = $Self->{UserShowTickets} || 1;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check subaction
    if ( !$Self->{Subaction} ) {
        return $Self->{LayoutObject}->Redirect(
            OP => 'CustomerTicketOverview;Subaction=MyTickets',
        );
    }

    # check needed CustomerID
    if ( !$Self->{UserCustomerID} ) {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError( Message => 'Need CustomerID!!!' );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # store last screen
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenView',
        Value     => $Self->{RequestedURL},
    );

    # filter definition
    my %Filters = (
        MyTickets => {
            All => {
                Name   => 'All',
                Prio   => 1000,
                Search => {
                    CustomerUserLogin => $Self->{UserID},
                    OrderBy           => $Self->{Order},
                    SortBy            => $Self->{SortBy},
                    CustomerUserID    => $Self->{UserID},
                    Permission        => 'ro',
                },
            },
            Open => {
                Name   => 'Open',
                Prio   => 1100,
                Search => {
                    CustomerUserLogin => $Self->{UserID},
                    StateType         => 'Open',
                    OrderBy           => $Self->{Order},
                    SortBy            => $Self->{SortBy},
                    CustomerUserID    => $Self->{UserID},
                    Permission        => 'ro',
                },
            },
            Closed => {
                Name   => 'Closed',
                Prio   => 1200,
                Search => {
                    CustomerUserLogin => $Self->{UserID},
                    StateType         => 'Closed',
                    OrderBy           => $Self->{Order},
                    SortBy            => $Self->{SortBy},
                    CustomerUserID    => $Self->{UserID},
                    Permission        => 'ro',
                },
            },
        },
        CompanyTickets => {
            All => {
                Name   => 'All',
                Prio   => 1000,
                Search => {
                    CustomerID =>
                        [ $Self->{CustomerUserObject}->CustomerIDs( User => $Self->{UserLogin} ) ],
                    OrderBy        => $Self->{Order},
                    SortBy         => $Self->{SortBy},
                    CustomerUserID => $Self->{UserID},
                    Permission     => 'ro',
                },
            },
            Open => {
                Name   => 'Open',
                Prio   => 1100,
                Search => {
                    CustomerID =>
                        [ $Self->{CustomerUserObject}->CustomerIDs( User => $Self->{UserLogin} ) ],
                    StateType      => 'Open',
                    OrderBy        => $Self->{Order},
                    SortBy         => $Self->{SortBy},
                    CustomerUserID => $Self->{UserID},
                    Permission     => 'ro',
                },
            },
            Closed => {
                Name   => 'Closed',
                Prio   => 1200,
                Search => {
                    CustomerID =>
                        [ $Self->{CustomerUserObject}->CustomerIDs( User => $Self->{UserLogin} ) ],
                    StateType      => 'Closed',
                    OrderBy        => $Self->{Order},
                    SortBy         => $Self->{SortBy},
                    CustomerUserID => $Self->{UserID},
                    Permission     => 'ro',
                },
            },
        },
    );

    # check if filter is valid
    if ( !$Filters{ $Self->{Subaction} }->{ $Self->{Filter} } ) {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}
            ->CustomerError( Message => "Invalid Filter: $Self->{Filter}!" );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    my %NavBarFilter;
    my $Counter    = 0;
    my $AllTickets = 0;
    for my $Filter ( keys %{ $Filters{ $Self->{Subaction} } } ) {
        $Counter++;
        my $Count = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{ $Self->{Subaction} }->{$Filter}->{Search} },
            Result => 'COUNT',
        );

        my $ClassLI = '';
        my $ClassA  = '';
        if ( $Filter eq $Self->{Filter} ) {
            $ClassA     = 'Selected';
            $AllTickets = $Count;
        }
        my $CounterTotal = keys %{ $Filters{ $Self->{Subaction} } };
        if ( $CounterTotal eq $Counter ) {
            $ClassLI = 'Last';
        }
        $NavBarFilter{ $Filters{ $Self->{Subaction} }->{$Filter}->{Prio} } = {
            %{ $Filters{ $Self->{Subaction} }->{$Filter} },
            Count   => $Count,
            Filter  => $Filter,
            ClassA  => $ClassA,
            ClassLI => $ClassLI,
        };
    }

    if ( !$AllTickets ) {
        $Self->{LayoutObject}->Block(
            Name => 'Empty',
            Data => \%Param,
        );
    }
    else {

        # create & return output
        my $Link = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
            . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Order} )
            . ';Filter=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
            . ';Subaction=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Subaction} )
            . ';';
        my %PageNav = $Self->{LayoutObject}->PageNavBar(
            Limit     => 10000,
            StartHit  => $Self->{StartHit},
            PageShown => $Self->{PageShown},
            AllHits   => $AllTickets,
            Action    => 'Action=CustomerTicketOverView',
            Link      => $Link,
            IDPrefix  => 'CustomerTicketOverView',
        );

        $Self->{LayoutObject}->Block(
            Name => 'Filled',
            Data => { %Param, %PageNav },
        );
    }
    for my $Key ( sort keys %NavBarFilter ) {
        $Self->{LayoutObject}->Block(
            Name => 'FilterHeader',
            Data => {
                %{ $NavBarFilter{$Key} },
            },
        );
        $Self->{LayoutObject}->Block(
            Name => 'FilterFooter',
            Data => {
                %{ $NavBarFilter{$Key} },
            },
        );
    }

    my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
        %{ $Filters{ $Self->{Subaction} }->{ $Self->{Filter} }->{Search} },
        Result => 'ARRAY',
        Limit  => 1_000,
    );

    # show ticket's
    $Counter = 0;
    for my $TicketID (@ViewableTickets) {
        $Counter++;
        if (
            $Counter >= $Self->{StartHit}
            && $Counter < ( $Self->{PageShown} + $Self->{StartHit} )
            )
        {
            $Self->ShowTicketStatus( TicketID => $TicketID );
        }
    }

    # create & return output
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->CustomerHeader(
        Title   => $Self->{Subaction},
        Refresh => $Refresh,
    );

    # build NavigationBar
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerTicketOverView',
        Data         => \%Param,
    );

    # get page footer
    $Output .= $Self->{LayoutObject}->CustomerFooter();

    # return page
    return $Output;
}

# ShowTicket
sub ShowTicketStatus {
    my ( $Self, %Param ) = @_;

    my $TicketID = $Param{TicketID} || return;

    # get last article
    my @Index = $Self->{TicketObject}->ArticleIndex( TicketID => $Param{TicketID} );
    my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle( TicketID => $TicketID );
    if ( !%Article ) {
        %Article = $Self->{TicketObject}->ArticleGet( ArticleID => $Index[0] );
    }

    # condense down the subject
    my $Subject = $Self->{TicketObject}->TicketSubjectClean(
        TicketNumber => $Article{TicketNumber},
        Subject => $Article{Subject} || '',
    );

    # return ticket
    $Article{Age} = $Self->{LayoutObject}->CustomerAge( Age => $Article{Age}, Space => ' ' ) || 0;

    # customer info (customer name)
    if ( $Article{CustomerUserID} ) {
        $Param{CustomerName}
            = $Self->{CustomerUserObject}->CustomerName( UserLogin => $Article{CustomerUserID}, );
        $Param{CustomerName} = '(' . $Param{CustomerName} . ')' if ( $Param{CustomerName} );
    }

    # add block
    $Self->{LayoutObject}->Block(
        Name => 'Record',
        Data => {
            %Article,
            Subject => $Subject,
            %Param,
        },
    );
}

1;
