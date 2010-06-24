# --
# Kernel/Output/HTML/ToolBarTicketResponsible.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: ToolBarTicketResponsible.pm,v 1.3 2010-06-24 12:15:26 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarTicketResponsible;

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

    # check responsible feature
    return if !$Self->{ConfigObject}->Get('Ticket::Responsible');

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

    my $Text        = $Self->{LayoutObject}->{LanguageObject}->Get('Responsibles Total');
    my $TextNew     = $Self->{LayoutObject}->{LanguageObject}->Get('Responsibles New');
    my $TextReached = $Self->{LayoutObject}->{LanguageObject}->Get('Responsibles Reminder Reached');
    my $URL         = $Self->{LayoutObject}->{Baselink};
    my %Return;
    $Return{'0999897'} = {
        Block       => 'ToolBarItem',
        Description => $TextNew,
        Count       => $CountNew,
        Class       => 'Global',

        #        Name        => $Text,
        #        Image       => 'folder_yellow.png',
        Link      => $URL . 'Action=AgentTicketResponsibleView;Filter=New',
        AccessKey => 'r',
    };
    $Return{'0999898'} = {
        Block       => 'ToolBarItem',
        Description => $TextReached,
        Count       => $CountReached,
        Class       => 'Global',

        #        Name        => $Text,
        #        Image       => 'folder_yellow.png',
        Link      => $URL . 'Action=AgentTicketResponsibleView;Filter=ReminderReached',
        AccessKey => 'r',
    };
    $Return{'0999899'} = {
        Block       => 'ToolBarItem',
        Description => $Text,
        Count       => $Count,
        Class       => 'Global',

        #        Name        => $Text,
        #        Image       => 'folder_yellow.png',
        Link      => $URL . 'Action=AgentTicketResponsibleView',
        AccessKey => 'r',
    };
    return %Return;
}

1;
