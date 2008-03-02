# --
# Kernel/System/LinkObject/Ticket.pm - to link ticket objects
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: Ticket.pm,v 1.14 2008-03-02 20:54:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::LinkObject::Ticket;

use strict;
use warnings;

use Kernel::System::Ticket;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.14 $) [1];

sub Init {
    my ( $Self, %Param ) = @_;

    $Self->{TicketObject} = Kernel::System::Ticket->new( %{$Self} );

    return 1;
}

sub FillDataMap {
    my ( $Self, %Param ) = @_;

    for (qw(ID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my %Ticket = $Self->{TicketObject}->TicketGet(
        TicketID => $Param{ID},
        UserID => $Self->{UserID},
    );
    return (
        Text         => 'T:' . $Ticket{TicketNumber},
        Number       => $Ticket{TicketNumber},
        Title        => $Ticket{Title},
        ID           => $Param{ID},
        Object       => 'Ticket',
        FrontendDest => "Action=AgentTicketZoom&TicketID=",
    );
}

sub BackendLinkObject {
    my ( $Self, %Param ) = @_;

    if ( $Param{LinkObject1} eq 'Ticket' && $Param{LinkObject2} eq 'Ticket' ) {

        # add ticket hostory
        my $SlaveTicketNumber = $Self->{TicketObject}->TicketNumberLookup(
            TicketID => $Param{LinkID2},
            UserID   => $Self->{UserID},
        );
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{LinkID1},
            CreateUserID => $Self->{UserID},
            HistoryType  => 'TicketLinkAdd',
            Name         => "\%\%$SlaveTicketNumber\%\%$Param{LinkID2}\%\%$Param{LinkID1}",
        );

        # ticket event
        $Self->{TicketObject}->TicketEventHandlerPost(
            Event    => 'TicketSlaveLinkAdd' . $Param{LinkType},
            UserID   => $Self->{UserID},
            TicketID => $Param{LinkID1},
        );

        # added slave ticket history
        my $MasterTicketNumber = $Self->{TicketObject}->TicketNumberLookup(
            TicketID => $Param{LinkID1},
            UserID   => $Self->{UserID},
        );
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{LinkID2},
            CreateUserID => $Self->{UserID},
            HistoryType  => 'TicketLinkAdd',
            Name         => "\%\%$MasterTicketNumber\%\%$Param{LinkID1}\%\%$Param{LinkID2}",
        );

        # ticket event
        $Self->{TicketObject}->TicketEventHandlerPost(
            Event    => 'TicketMasterLinkAdd' . $Param{LinkType},
            UserID   => $Self->{UserID},
            TicketID => $Param{LinkID2},
        );
    }
    return 1;
}

sub BackendUnlinkObject {
    my ( $Self, %Param ) = @_;

    if ( $Param{LinkObject1} eq 'Ticket' && $Param{LinkObject2} eq 'Ticket' ) {

        # add ticket hostory
        my $SlaveTicketNumber = $Self->{TicketObject}->TicketNumberLookup(
            TicketID => $Param{LinkID1},
            UserID   => $Self->{UserID},
        );
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{LinkID2},
            CreateUserID => $Self->{UserID},
            HistoryType  => 'TicketLinkDelete',
            Name         => "\%\%$SlaveTicketNumber\%\%$Param{LinkID2}\%\%$Param{LinkID1}",
        );

        # ticket event
        $Self->{TicketObject}->TicketEventHandlerPost(
            Event    => 'TicketSlaveLinkDelete' . $Param{LinkType},
            UserID   => $Self->{UserID},
            TicketID => $Param{LinkID2},
        );

        # added slave ticket history
        my $MasterTicketNumber = $Self->{TicketObject}->TicketNumberLookup(
            TicketID => $Param{LinkID2},
            UserID   => $Self->{UserID},
        );
        $Self->{TicketObject}->HistoryAdd(
            TicketID     => $Param{LinkID1},
            CreateUserID => $Self->{UserID},
            HistoryType  => 'TicketLinkDelete',
            Name         => "\%\%$MasterTicketNumber\%\%$Param{LinkID1}\%\%$Param{LinkID2}",
        );

        # ticket event
        $Self->{TicketObject}->TicketEventHandlerPost(
            Event    => 'TicketMasterLinkDelete' . $Param{LinkType},
            UserID   => $Self->{UserID},
            TicketID => $Param{LinkID1},
        );
    }
    return 1;
}

sub LinkSearchParams {
    my ( $Self, %Param ) = @_;

    return (
        { Name => 'TicketNumber',   Text => 'Ticket#'  },
        { Name => 'Title',          Text => 'Title'    },
        { Name => 'TicketFulltext', Text => 'Fulltext' },
    );
}

sub LinkSearch {
    my ( $Self, %Param ) = @_;

    my %Search         = ();
    my @ResultWithData = ();

    # set focus
    if ( $Param{Title} ) {
        $Param{Title} = '*' . $Param{Title} . '*';
    }
    if ( $Param{TicketFulltext} ) {
        $Param{TicketFulltext} = '*' . $Param{TicketFulltext} . '*';
        %Search = (
            From          => $Param{TicketFulltext},
            To            => $Param{TicketFulltext},
            Cc            => $Param{TicketFulltext},
            Subject       => $Param{TicketFulltext},
            Body          => $Param{TicketFulltext},
            ContentSearch => 'OR',
        );
    }
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        Result => 'ARRAY',
        %Param,
        %Search,
    );
    for (@TicketIDs) {
        my %Ticket = $Self->{TicketObject}->TicketGet(
            TicketID => $_,
            UserID   => $Self->{UserID},
        );
        push(
            @ResultWithData,
            {   %Ticket,
                ID     => $_,
                Number => $Ticket{TicketNumber},
            },
        );

    }
    return @ResultWithData;
}

sub LinkItemData {
    my ( $Self, %Param ) = @_;

    my $Body       = '';
    my %Ticket     = $Self->{TicketObject}->TicketGet( TicketID => $Param{ID} );
    my @ArticleBox = $Self->{TicketObject}->ArticleContentIndex( TicketID => $Param{ID} );
    for my $Article ( reverse @ArticleBox ) {
        $Body .= $Article->{Body};
    }
    return (
        %Ticket,
        ID         => $Param{ID},
        Title      => $Ticket{Title},
        Number     => $Ticket{TicketNumber},
        Body       => $Body,
        DetailLink => "Action=AgentTicketZoom&TicketID=$Param{ID}",
    );
}

1;
