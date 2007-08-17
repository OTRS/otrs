# --
# Kernel/Modules/AgentTicketWatcher.pm - a ticketwatcher module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketWatcher.pm,v 1.5 2007-08-17 08:48:22 sb Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketWatcher;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # ------------------------------------------------------------ #
    # check if feature is aktive
    # ------------------------------------------------------------ #
    if (!$Self->{ConfigObject}->Get('Ticket::Watcher')) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Feature is not aktive',
        );
    }
    # ------------------------------------------------------------ #
    # check access
    # ------------------------------------------------------------ #
    my @Groups = ();
    if ($Self->{ConfigObject}->Get('Ticket::WatcherGroup')) {
        @Groups = @{$Self->{ConfigObject}->Get('Ticket::WatcherGroup')};
    }
    my $Access = 0;
    if (!@Groups) {
        $Access = 1;
    }
    else {
        foreach my $Group (@Groups) {
            if ($Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes') {
                $Access = 1;
            }
        }
    }
    # ------------------------------------------------------------ #
    # subscribe a ticket
    # ------------------------------------------------------------ #
    if ($Self->{Subaction} eq 'Subscribe') {
        # set subscribe
        if ($Self->{TicketObject}->TicketWatchSubscribe(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
        )) {
            # redirect
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # ------------------------------------------------------------ #
    # unsubscribe a ticket
    # ------------------------------------------------------------ #
    elsif ($Self->{Subaction} eq 'Unsubscribe') {
        if ($Self->{TicketObject}->TicketWatchUnsubscribe(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
        )) {
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
}

1;
