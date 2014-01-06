# --
# Kernel/Modules/CustomerTicketOverview.pm - status for all open tickets
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: CustomerTicketOverview.pm,v 1.4.2.3 2012-11-19 12:36:33 mb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerTicketOverview;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4.2.3 $) [1];

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

    $Self->{SmallViewColumnHeader}
        = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketOverview')->{ColumnHeader};

    # get params
    $Self->{Filter}  = $Self->{ParamObject}->GetParam( Param => 'Filter' )  || 'Open';
    $Self->{SortBy}  = $Self->{ParamObject}->GetParam( Param => 'SortBy' )  || 'Age';
    $Self->{OrderBy} = $Self->{ParamObject}->GetParam( Param => 'OrderBy' ) || 'Down';
    $Self->{StartHit} = int( $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1 );
    $Self->{PageShown} = $Self->{UserShowTickets} || 1;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check subaction
    if ( !$Self->{Subaction} ) {
        return $Self->{LayoutObject}->Redirect(
            OP => 'Action=CustomerTicketOverview;Subaction=MyTickets',
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
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key       => 'LastScreenOverview',
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
                    OrderBy           => $Self->{OrderBy},
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
                    OrderBy           => $Self->{OrderBy},
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
                    OrderBy           => $Self->{OrderBy},
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
                    OrderBy        => $Self->{OrderBy},
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
                    OrderBy        => $Self->{OrderBy},
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
                    OrderBy        => $Self->{OrderBy},
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
        $Output .= $Self->{LayoutObject}->CustomerError(
            Message => "Invalid Filter: $Self->{Filter}!",
        );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # check if archive search is allowed, otherwise search for all tickets
    my %SearchInArchive = ();
    if (
        $Self->{ConfigObject}->Get('Ticket::ArchiveSystem')
        && !$Self->{ConfigObject}->Get('Ticket::CustomerArchiveSystem')
        )
    {
        $SearchInArchive{ArchiveFlags} = [ 'y', 'n' ];
    }

    my %NavBarFilter;
    my $Counter         = 0;
    my $AllTickets      = 0;
    my $AllTicketsTotal = 0;
    for my $Filter ( keys %{ $Filters{ $Self->{Subaction} } } ) {
        $Counter++;
        my $Count = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{ $Self->{Subaction} }->{$Filter}->{Search} },
            %SearchInArchive,
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
        if ( $Filter eq 'All' ) {
            $AllTicketsTotal = $Count;
        }
        $NavBarFilter{ $Filters{ $Self->{Subaction} }->{$Filter}->{Prio} } = {
            %{ $Filters{ $Self->{Subaction} }->{$Filter} },
            Count   => $Count,
            Filter  => $Filter,
            ClassA  => $ClassA,
            ClassLI => $ClassLI,
        };
    }

    if ( !$AllTicketsTotal ) {
        $Self->{LayoutObject}->Block(
            Name => 'Empty',
        );

        my $CustomTexts
            = $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerTicketOverviewCustomEmptyText');

        if ( ref $CustomTexts eq 'HASH' ) {
            $Self->{LayoutObject}->Block(
                Name => 'EmptyCustom',
                Data => $CustomTexts,
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'EmptyDefault',
            );
        }
    }
    else {

        # create & return output
        my $Link = 'SortBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{SortBy} )
            . ';OrderBy=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{OrderBy} )
            . ';Filter=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Filter} )
            . ';Subaction=' . $Self->{LayoutObject}->Ascii2Html( Text => $Self->{Subaction} )
            . ';';
        my %PageNav = $Self->{LayoutObject}->PageNavBar(
            Limit     => 10000,
            StartHit  => $Self->{StartHit},
            PageShown => $Self->{PageShown},
            AllHits   => $AllTickets,
            Action    => 'Action=CustomerTicketOverview',
            Link      => $Link,
            IDPrefix  => 'CustomerTicketOverview',
        );

        my $OrderBy = 'Down';
        if ( $Self->{OrderBy} eq 'Down' ) {
            $OrderBy = 'Up';
        }
        my $Sort       = '';
        my $StateSort  = '';
        my $TicketSort = '';
        my $TitleSort  = '';
        my $AgeSort    = '';

        # this sets the opposit to the $OrderBy
        if ( $OrderBy eq 'Down' ) {
            $Sort = 'SortAscending';
        }
        if ( $OrderBy eq 'Up' ) {
            $Sort = 'SortDescending';
        }

        # perl is missing 'switch' :-| have to learn to work effectivly without it
        if ( $Self->{SortBy} eq 'State' ) {
            $StateSort = $Sort;
        }
        if ( $Self->{SortBy} eq 'Ticket' ) {
            $TicketSort = $Sort;
        }
        if ( $Self->{SortBy} eq 'Title' ) {
            $TitleSort = $Sort;
        }
        if ( $Self->{SortBy} eq 'Age' ) {
            $AgeSort = $Sort;
        }
        $Self->{LayoutObject}->Block(
            Name => 'Filled',
            Data => {
                %Param,
                %PageNav,
                OrderBy    => $OrderBy,
                StateSort  => $StateSort,
                TicketSort => $TicketSort,
                TitleSort  => $TitleSort,
                AgeSort    => $AgeSort,
                Filter     => $Self->{Filter},
            },
        );

        # show header filter
        for my $Key ( sort keys %NavBarFilter ) {
            $Self->{LayoutObject}->Block(
                Name => 'FilterHeader',
                Data => {
                    %{ $NavBarFilter{$Key} },
                },
            );
        }

        # show footer filter - show only if more the one page is available
        if ( $AllTickets > $Self->{PageShown} ) {
            $Self->{LayoutObject}->Block(
                Name => 'FilterFooter',
                Data => {
                    %Param,
                    %PageNav,
                },
            );
        }
        for my $Key ( sort keys %NavBarFilter ) {
            if ( $AllTickets > $Self->{PageShown} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'FilterFooterItem',
                    Data => {
                        %{ $NavBarFilter{$Key} },
                    },
                );
            }
        }

        my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            %{ $Filters{ $Self->{Subaction} }->{ $Self->{Filter} }->{Search} },
            %SearchInArchive,
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
        TemplateFile => 'CustomerTicketOverview',
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

    # contains last article (non-internal)
    my %Article;

    # get whole article index
    my @ArticleIDs = $Self->{TicketObject}->ArticleIndex( TicketID => $Param{TicketID} );

    # get article data
    if (@ArticleIDs) {
        my %LastNonInternalArticle;

        ARTICLEID:
        for my $ArticleID ( reverse @ArticleIDs ) {
            my %CurrentArticle = $Self->{TicketObject}->ArticleGet( ArticleID => $ArticleID );

            # check for non-internal article
            next ARTICLEID if $CurrentArticle{ArticleType} =~ m{internal}smx;

            # check for customer article
            if ( $CurrentArticle{SenderType} eq 'customer' ) {
                %Article = %CurrentArticle;
                last ARTICLEID;
            }

            # check for last non-internal article (sender type does not matter)
            if ( !%LastNonInternalArticle ) {
                %LastNonInternalArticle = %CurrentArticle;
            }
        }

        if ( !%Article && %LastNonInternalArticle ) {
            %Article = %LastNonInternalArticle;
        }
    }

    # get ticket info
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID      => $TicketID,
        DynamicFields => 0,
    );

    my $Subject
        = $Self->{SmallViewColumnHeader} eq 'LastCustomerSubject'
        ? $Article{Subject}
        : $Ticket{Title};

    # condense down the subject
    $Subject = $Self->{TicketObject}->TicketSubjectClean(
        TicketNumber => $Article{TicketNumber},
        Subject      => $Subject,
    );

    # return ticket
    $Article{CustomerAge}
        = $Self->{LayoutObject}->CustomerAge( Age => $Article{Age}, Space => ' ' ) || 0;

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
            %Ticket,
            Subject => $Subject,
            %Param,
        },
    );
}

1;
