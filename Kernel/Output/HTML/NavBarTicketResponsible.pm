# --
# Kernel/Output/HTML/NavBarTicketResponsible.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: NavBarTicketResponsible.pm,v 1.1 2010-02-21 18:32:14 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBarTicketResponsible;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

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

    my $Text = $Self->{LayoutObject}->{LanguageObject}->Get('Responsible') . " ($Count/$CountNew)";
    my %Return;
    $Return{'0999899'} = {
        Block       => 'ItemPersonal',
        Description => $Text,
        Name        => $Text,
        Image       => 'folder_yellow.png',
        Link        => 'Action=AgentTicketResponsibleView',
        AccessKey   => 'r',
    };
    return %Return;
}

1;
