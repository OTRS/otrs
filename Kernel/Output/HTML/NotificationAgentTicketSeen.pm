# --
# Kernel/Output/HTML/NotificationAgentTicketSeen.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: NotificationAgentTicketSeen.pm,v 1.8 2008-05-08 09:36:57 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketSeen;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.8 $) [1];

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
