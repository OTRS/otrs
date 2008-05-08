# --
# Kernel/Output/HTML/TicketMenuTicketWatcher.pm
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: TicketMenuTicketWatcher.pm,v 1.7 2008-05-08 09:36:57 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::TicketMenuTicketWatcher;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !$Param{Ticket} ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need Ticket!' );
        return;
    }

    # check if feature is aktive
    if ( !$Self->{ConfigObject}->Get('Ticket::Watcher') ) {
        return $Param{Counter};
    }

    if (
        !defined( $Param{ACL}->{ $Param{Config}->{Action} } )
        || $Param{ACL}->{ $Param{Config}->{Action} }
        )
    {
        my @Groups = ();
        if ( $Self->{ConfigObject}->Get('Ticket::WatcherGroup') ) {
            @Groups = @{ $Self->{ConfigObject}->Get('Ticket::WatcherGroup') };
        }

        # check access
        my $Access = 0;
        if ( !@Groups ) {
            $Access = 1;
        }
        else {
            for my $Group (@Groups) {
                if (
                    $Self->{LayoutObject}->{"UserIsGroup[$Group]"}
                    && $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes'
                    )
                {
                    $Access = 1;
                }
            }
        }
        if ($Access) {
            $Self->{LayoutObject}->Block(
                Name => 'Menu',
            );
            if ( $Param{Counter} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'MenuItemSplit',
                );
            }
            my %Watch = $Self->{TicketObject}->TicketWatchGet(
                TicketID => $Param{TicketID},
                UserID   => $Self->{UserID},
            );
            if ( $Watch{CreateBy} ) {
                $Self->{LayoutObject}->Block(
                    Name => 'MenuItem',
                    Data => {
                        %{ $Param{Config} },
                        %{ $Param{Ticket} },
                        %Param,
                        Name        => 'Unsubscribe',
                        Description => 'Unsubscribe it to watch it not longer!',
                        Link =>
                            'Action=AgentTicketWatcher&Subaction=Unsubscribe&TicketID=$QData{"TicketID"}',
                    },
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'MenuItem',
                    Data => {
                        %{ $Param{Config} },
                        %Param,
                        Name        => 'Subscribe',
                        Description => 'Subscribe it to watch it!',
                        Link =>
                            'Action=AgentTicketWatcher&Subaction=Subscribe&TicketID=$QData{"TicketID"}',
                    },
                );
            }
        }
        $Param{Counter}++;
    }
    return $Param{Counter};
}

1;
