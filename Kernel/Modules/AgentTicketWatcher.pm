# --
# Kernel/Modules/AgentTicketWatcher.pm - a ticketwatcher module
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: AgentTicketWatcher.pm,v 1.11 2009-02-16 11:20:53 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentTicketWatcher;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.11 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # ------------------------------------------------------------ #
    # check if feature is aktive
    # ------------------------------------------------------------ #
    if ( !$Self->{ConfigObject}->Get('Ticket::Watcher') ) {
        return $Self->{LayoutObject}->ErrorScreen( Message => 'Feature is not aktive', );
    }

    # ------------------------------------------------------------ #
    # check access
    # ------------------------------------------------------------ #
    my @Groups = ();
    if ( $Self->{ConfigObject}->Get('Ticket::WatcherGroup') ) {
        @Groups = @{ $Self->{ConfigObject}->Get('Ticket::WatcherGroup') };
    }
    my $Access = 0;
    if ( !@Groups ) {
        $Access = 1;
    }
    else {
        for my $Group (@Groups) {
            if ( $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                $Access = 1;
            }
        }
    }

    # ------------------------------------------------------------ #
    # subscribe a ticket
    # ------------------------------------------------------------ #
    if ( $Self->{Subaction} eq 'Subscribe' ) {

        # set subscribe
        my $Subscribe = $Self->{TicketObject}->TicketWatchSubscribe(
            TicketID    => $Self->{TicketID},
            WatchUserID => $Self->{UserID},
            UserID      => $Self->{UserID},
        );

        if ( !$Subscribe ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # redirect
        return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenView} );
    }

    # ------------------------------------------------------------ #
    # unsubscribe a ticket
    # ------------------------------------------------------------ #
    elsif ( $Self->{Subaction} eq 'Unsubscribe' ) {
        my $Unsubscribe = $Self->{TicketObject}->TicketWatchUnsubscribe(
            TicketID    => $Self->{TicketID},
            WatchUserID => $Self->{UserID},
            UserID      => $Self->{UserID},
        );

        if ( !$Unsubscribe ) {
            return $Self->{LayoutObject}->ErrorScreen();
        }

        # redirect
        return $Self->{LayoutObject}->Redirect( OP => $Self->{LastScreenView} );
    }
}

1;
