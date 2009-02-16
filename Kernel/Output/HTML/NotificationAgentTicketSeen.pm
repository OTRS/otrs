# --
# Kernel/Output/HTML/NotificationAgentTicketSeen.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: NotificationAgentTicketSeen.pm,v 1.9 2009-02-16 11:16:22 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketSeen;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if (
        $Self->{LayoutObject}->{Action} ne 'AgentTicketZoom'
        || $Self->{ConfigObject}->Get('Ticket::NewMessageMode') ne 'ArticleSeen'
        )
    {
        return '';
    }
    my $TicketID = $Self->{ParamObject}->GetParam( Param => 'TicketID' ) || return;
    my @ArticleIDs = $Self->{TicketObject}->ArticleIndex( TicketID => $TicketID, );
    for (@ArticleIDs) {
        $Self->{TicketObject}->ArticleFlagSet(
            ArticleID => $_,
            Flag      => 'seen',
            UserID    => $Self->{UserID},
        );
    }
    return '';
}

1;
