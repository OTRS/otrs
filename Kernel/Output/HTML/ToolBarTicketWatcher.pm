# --
# Kernel/Output/HTML/ToolBarTicketWatcher.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: ToolBarTicketWatcher.pm,v 1.3 2010-05-04 01:24:06 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarTicketWatcher;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.3 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject DBObject TicketObject LayoutObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # check if feature is aktive
    return if !$Self->{ConfigObject}->Get('Ticket::Watcher');

    # check access
    my @Groups;
    if ( $Self->{ConfigObject}->Get('Ticket::WatcherGroup') ) {
        @Groups = @{ $Self->{ConfigObject}->Get('Ticket::WatcherGroup') };
    }
    if (@Groups) {
        my $Access = 0;
        for my $Group (@Groups) {
            next if !$Self->{LayoutObject}->{"UserIsGroup[$Group]"};
            if ( $Self->{LayoutObject}->{"UserIsGroup[$Group]"} eq 'Yes' ) {
                $Access = 1;
                last;
            }
        }

        # return on no access
        return if !$Access;
    }

    # find watched tickets
    my $Count = $Self->{TicketObject}->TicketSearch(
        Result       => 'COUNT',
        WatchUserIDs => [ $Self->{UserID} ],
        UserID       => 1,
        Permission   => 'ro',
    );
    my $CountNew = $Self->{TicketObject}->TicketSearch(
        Result       => 'COUNT',
        WatchUserIDs => [ $Self->{UserID} ],
        TicketFlag   => {
            Seen => 1,
        },
        TicketFlagUserID => $Self->{UserID},
        UserID           => 1,
        Permission       => 'ro',
    );
    $CountNew = $Count - $CountNew;
    my $Text = $Self->{LayoutObject}->{LanguageObject}->Get('Watched Tickets');
    my $URL  = $Self->{LayoutObject}->{Baselink};
    my $CountNotify;
    if ($CountNew) {
        $CountNotify = "*$CountNew/$Count";
        $URL .= 'Action=AgentTicketWatchView;Filter=New';
    }
    else {
        $CountNotify = $Count;
        $URL .= 'Action=AgentTicketWatchView';
    }
    my %Return;
    $Return{'0999978'} = {
        Block       => 'ToolBarItem',
        Description => $Text,
        Count       => $CountNotify,
        Class       => 'Alerts',

        #        Name        => $Text,
        #        Image       => 'watcher.png',
        Link      => $URL,
        AccessKey => '',
    };
    return %Return;
}

1;
