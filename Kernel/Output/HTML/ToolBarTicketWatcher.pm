# --
# Kernel/Output/HTML/ToolBarTicketWatcher.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarTicketWatcher;

use strict;
use warnings;

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

    # check if feature is active
    return if !$Self->{ConfigObject}->Get('Ticket::Watcher');

    # check needed stuff
    for (qw(Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

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

    my $CountReached = $Self->{TicketObject}->TicketSearch(
        Result                        => 'COUNT',
        StateType                     => ['pending reminder'],
        WatchUserIDs                  => [ $Self->{UserID} ],
        TicketPendingTimeOlderMinutes => 1,
        UserID                        => 1,
        Permission                    => 'ro',
    );

    my $Class        = $Param{Config}->{CssClass};
    my $ClassNew     = $Param{Config}->{CssClassNew};
    my $ClassReached = $Param{Config}->{CssClassReached};

    my $Icon         = $Param{Config}->{Icon};
    my $IconNew      = $Param{Config}->{IconNew};
    my $IconReached  = $Param{Config}->{IconReached};

    my $URL = $Self->{LayoutObject}->{Baselink};
    my %Return;
    my $Priority = $Param{Config}->{Priority};
    if ($CountNew) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => 'Watched Tickets New',
            Count       => $CountNew,
            Class       => $ClassNew,
            Icon        => $IconNew,
            Link        => $URL . 'Action=AgentTicketWatchView;Filter=New',
            AccessKey   => '',
        };
    }
    if ($CountReached) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => 'Watched Tickets Reminder Reached',
            Count       => $CountReached,
            Class       => $ClassReached,
            Icon        => $IconReached,
            Link        => $URL . 'Action=AgentTicketWatchView;Filter=ReminderReached',
            AccessKey   => '',
        };
    }
    if ($Count) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => 'Watched Tickets Total',
            Count       => $Count,
            Class       => $Class,
            Icon        => $Icon,
            Link        => $URL . 'Action=AgentTicketWatchView',
            AccessKey   => '',
        };
    }
    return %Return;
}

1;
