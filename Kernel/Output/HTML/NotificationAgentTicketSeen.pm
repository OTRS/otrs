# --
# Kernel/Output/HTML/NotificationAgentTicketSeen.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: NotificationAgentTicketSeen.pm,v 1.4 2006-08-27 22:27:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicketSeen;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject ParamObject TicketObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    if ($Self->{LayoutObject}->{Action} ne 'AgentTicketZoom' || $Self->{ConfigObject}->Get('Ticket::NewMessageMode') ne 'ArticleSeen') {
        return '';
    }
    my $TicketID = $Self->{ParamObject}->GetParam(Param => 'TicketID') || return;
    my @ArticleIDs = $Self->{TicketObject}->ArticleIndex(
        TicketID => $TicketID,
    );
    foreach (@ArticleIDs) {
        $Self->{TicketObject}->ArticleFlagSet(
            ArticleID => $_,
            Flag => 'seen',
            UserID => $Self->{UserID},
        );
    }
    return $Output;
}

1;
