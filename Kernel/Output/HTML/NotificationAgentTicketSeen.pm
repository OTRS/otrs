# --
# Kernel/Output/HTML/NotificationAgentTicketSeen.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NotificationAgentTicketSeen.pm,v 1.5 2007-09-29 10:50:15 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketSeen;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5 $) [1];

sub new {
    my $Type  = shift;
    my %Param = @_;

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
    my $Self   = shift;
    my %Param  = @_;
    my $Output = '';
    if (   $Self->{LayoutObject}->{Action} ne 'AgentTicketZoom'
        || $Self->{ConfigObject}->Get('Ticket::NewMessageMode') ne 'ArticleSeen' )
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
    return $Output;
}

1;
