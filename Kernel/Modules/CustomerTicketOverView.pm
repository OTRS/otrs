# --
# Kernel/Modules/CustomerTicketOverView.pm - status for all open tickets
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: CustomerTicketOverView.pm,v 1.47 2008-05-08 09:36:37 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Modules::CustomerTicketOverView;

use strict;
use warnings;

use Kernel::System::State;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.47 $) [1];

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
    $Self->{ShowClosedTickets} = $Self->{ParamObject}->GetParam( Param => 'ShowClosedTickets' );
    $Self->{SortBy}            = $Self->{ParamObject}->GetParam( Param => 'SortBy' ) || 'Age';
    $Self->{Order}             = $Self->{ParamObject}->GetParam( Param => 'Order' ) || 'Down';
    $Self->{StartHit}          = $Self->{ParamObject}->GetParam( Param => 'StartHit' ) || 1;
    $Self->{Type}              = $Self->{ParamObject}->GetParam( Param => 'Type' ) || 'MyTickets';
    $Self->{PageShown} = $Self->{UserShowTickets}
        || $Self->{ConfigObject}->Get('CustomerPreferencesGroups')->{ShownTickets}->{DataSelected}
        || 1;

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # store last screen
    if (
        !$Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'LastScreenView',
            Value     => $Self->{RequestedURL},
        )
        )
    {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError();
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # check needed CustomerID
    if ( !$Self->{UserCustomerID} ) {
        my $Output = $Self->{LayoutObject}->CustomerHeader( Title => 'Error' );
        $Output .= $Self->{LayoutObject}->CustomerError( Message => 'Need CustomerID!!!' );
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }

    # check if just open tickets should be shown
    my $SQLExt     = '';
    my $ShowClosed = 0;
    if ( !defined( $Self->{ShowClosedTickets} ) ) {
        if ( defined( $Self->{UserShowClosedTickets} ) ) {
            $ShowClosed = $Self->{UserShowClosedTickets};
        }
        else {
            $ShowClosed = $Self->{ConfigObject}->Get('CustomerPreferencesGroups')->{ClosedTickets}
                ->{DataSelected};
        }
    }
    else {
        $ShowClosed = $Self->{ShowClosedTickets};
    }

    # get data (viewable tickets...)
    my $StateType = '';
    if ( !$ShowClosed ) {
        $StateType = 'Open';
    }

    my @ViewableTickets = ();
    if ( $Self->{Type} eq 'MyTickets' ) {
        @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            Result            => 'ARRAY',
            CustomerUserLogin => $Self->{UserID},
            StateType         => $StateType,
            OrderBy           => $Self->{Order},
            SortBy            => $Self->{SortBy},
            CustomerUserID    => $Self->{UserID},
            Permission        => 'ro',
        );
    }
    else {
        @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            Result => 'ARRAY',
            CustomerID =>
                [ $Self->{CustomerUserObject}->CustomerIDs( User => $Self->{UserLogin} ) ],
            StateType => $StateType,
            OrderBy   => $Self->{Order},
            SortBy    => $Self->{SortBy},

            CustomerUserID => $Self->{UserID},
            Permission     => 'ro',
        );
    }

    my $AllTickets = @ViewableTickets;

    # show ticket's
    my $Counter = 0;
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
    my %PageNav = $Self->{LayoutObject}->PageNavBar(
        Limit     => 10000,
        StartHit  => $Self->{StartHit},
        PageShown => $Self->{PageShown},
        AllHits   => $AllTickets,
        Action    => "Action=CustomerTicketOverView",
        Link =>
            "SortBy=$Self->{SortBy}&Order=$Self->{Order}&ShowClosedTickets=$ShowClosed&Type=$Self->{Type}&",
    );

    # create & return output
    my $Refresh = '';
    if ( $Self->{UserRefreshTime} ) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->CustomerHeader(
        Title   => $Self->{Type},
        Refresh => $Refresh,
    );

    # build NavigationBar
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'CustomerStatusView',
        Data         => {
            Type       => $Self->{Type},
            ShowClosed => $ShowClosed,
            %PageNav,
            %Param,
        },
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
