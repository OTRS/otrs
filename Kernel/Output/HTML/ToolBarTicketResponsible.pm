# --
# Kernel/Output/HTML/ToolBarTicketResponsible.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: ToolBarTicketResponsible.pm,v 1.2 2010-05-04 01:24:06 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarTicketResponsible;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

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

    my $Text = $Self->{LayoutObject}->{LanguageObject}->Get('Responsible');
    my $URL  = $Self->{LayoutObject}->{Baselink};
    my $CountNotify;
    if ($CountNew) {
        $CountNotify = "*$CountNew/$Count";
        $URL .= 'Action=AgentTicketResponsibleView;Filter=New';
    }
    else {
        $CountNotify = $Count;
        $URL .= 'Action=AgentTicketResponsibleView';
    }
    my %Return;
    $Return{'0999899'} = {
        Block       => 'ToolBarItem',
        Description => $Text,
        Count       => $CountNotify,
        Class       => 'Global',

        #        Name        => $Text,
        #        Image       => 'folder_yellow.png',
        Link      => $URL,
        AccessKey => 'r',
    };
    return %Return;
}

1;
