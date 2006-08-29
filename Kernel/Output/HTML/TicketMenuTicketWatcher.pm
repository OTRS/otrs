# --
# Kernel/Output/HTML/TicketMenuTicketWatcher.pm
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: TicketMenuTicketWatcher.pm,v 1.2 2006-08-29 17:15:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::TicketMenuTicketWatcher;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject UserID TicketObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Ticket}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need Ticket!");
        return;
    }
    # check if feature is aktive
    if (!$Self->{ConfigObject}->Get('Ticket::Watcher')) {
        return $Param{Counter};
    }

    if (!defined($Param{ACL}->{$Param{Config}->{Action}}) || $Param{ACL}->{$Param{Config}->{Action}}) {
        my @Groups = ();
        if ($Self->{ConfigObject}->Get('Ticket::WatcherGroup')) {
            @Groups = @{$Self->{ConfigObject}->Get('Ticket::WatcherGroup')};
        }
        # check access
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
        if ($Access) {
            $Self->{LayoutObject}->Block(
                Name => 'Menu',
                Data => {},
            );
            if ($Param{Counter}) {
                $Self->{LayoutObject}->Block(
                    Name => 'MenuItemSplit',
                    Data => {},
                );
            }
            my %Watch = $Self->{TicketObject}->TicketWatchGet(
                TicketID => $Param{TicketID},
                UserID => $Self->{UserID},
            );
            if ($Watch{CreateBy}) {
                $Self->{LayoutObject}->Block(
                    Name => 'MenuItem',
                    Data => {
                        %{$Param{Config}},
                        %{$Param{Ticket}},
                        %Param,
                        Name => 'Unsubscribe',
                        Description => 'Unsubscribe it to watch it not longer!',
                        Link => 'Action=AgentTicketWatcher&Subaction=Unsubscribe&TicketID=$QData{"TicketID"}',
                    },
                );
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'MenuItem',
                    Data => {
                        %{$Param{Config}},
                        %Param,
                        Name => 'Subscribe',
                        Description => 'Subscribe it to watch it!',
                        Link => 'Action=AgentTicketWatcher&Subaction=Subscribe&TicketID=$QData{"TicketID"}',
                    },
                );
            }
        }
        $Param{Counter}++;
    }
    return $Param{Counter};
}

1;
