# --
# Kernel/Output/HTML/NavBarTicketWatcher.pm
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NavBarTicketWatcher.pm,v 1.3 2006-07-03 12:24:40 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NavBarTicketWatcher;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    my %Return = ();
    my @Groups = ();
    # check if feature is aktive
    if (!$Self->{ConfigObject}->Get('Ticket::Watcher')) {
        return %Return;
    }
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
        my $Count = $Self->{TicketObject}->TicketSearch(
            Result => 'ARRAY',
            Limit => 1000,
            WatchUserIDs => [$Self->{UserID}],
            UserID => 1,
            Permission => 'ro',
        );
        my $Text = $Self->{LayoutObject}->{LanguageObject}->Get('Watched Tickets')." ($Count)";
        $Return{'0999978'} = {
            Block => 'ItemPersonal',
            Description => $Text,
            Name => $Text,
            Image => 'watcher.png',
            Link => 'Action=AgentTicketMailbox&Subaction=Watched',
            AccessKey => '',
        };
    }
    return %Return;
}

1;

