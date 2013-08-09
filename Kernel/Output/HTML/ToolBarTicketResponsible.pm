# --
# Kernel/Output/HTML/ToolBarTicketResponsible.pm
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarTicketResponsible;

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

    # check responsible feature
    return if !$Self->{ConfigObject}->Get('Ticket::Responsible');

    # check needed stuff
    for (qw(Config)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    my $Count = $Self->{TicketObject}->TicketSearch(
        Result         => 'COUNT',
        StateType      => 'Open',
        ResponsibleIDs => [ $Self->{UserID} ],
        UserID         => 1,
        Permission     => 'ro',
    );
    my $CountNew = $Self->{TicketObject}->TicketSearch(
        Result         => 'COUNT',
        StateType      => 'Open',
        ResponsibleIDs => [ $Self->{UserID} ],
        TicketFlag     => {
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
        ResponsibleIDs                => [ $Self->{UserID} ],
        TicketPendingTimeOlderMinutes => 1,
        UserID                        => 1,
        Permission                    => 'ro',
    );

    my $Class        = $Param{Config}->{CssClass};
    my $ClassNew     = $Param{Config}->{CssClassNew};
    my $ClassReached = $Param{Config}->{CssClassReached};

    my $Icon        = $Param{Config}->{Icon};
    my $IconNew     = $Param{Config}->{IconNew};
    my $IconReached = $Param{Config}->{IconReached};

    my $URL = $Self->{LayoutObject}->{Baselink};
    my %Return;
    my $Priority = $Param{Config}->{Priority};
    if ($CountNew) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => 'Responsible Tickets New',
            Count       => $CountNew,
            Class       => $ClassNew,
            Icon        => $IconNew,
            Link        => $URL . 'Action=AgentTicketResponsibleView;Filter=New',
            AccessKey   => 'r',
        };
    }
    if ($CountReached) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => 'Responsible Tickets Reminder Reached',
            Count       => $CountReached,
            Class       => $ClassReached,
            Icon        => $IconReached,
            Link        => $URL . 'Action=AgentTicketResponsibleView;Filter=ReminderReached',
            AccessKey   => 'r',
        };
    }
    if ($Count) {
        $Return{ $Priority++ } = {
            Block       => 'ToolBarItem',
            Description => 'Responsible Tickets Total',
            Count       => $Count,
            Class       => $Class,
            Icon        => $Icon,
            Link        => $URL . 'Action=AgentTicketResponsibleView',
            AccessKey   => 'r',
        };
    }
    return %Return;
}

1;
