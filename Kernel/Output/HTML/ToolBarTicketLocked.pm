# --
# Kernel/Output/HTML/ToolBarTicketLocked.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: ToolBarTicketLocked.pm,v 1.1 2010-03-28 10:57:54 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::ToolBarTicketLocked;

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

    # get user lock data
    my $Count = $Self->{TicketObject}->TicketSearch(
        Result     => 'COUNT',
        Locks      => ['lock'],
        OwnerIDs   => [ $Self->{UserID} ],
        UserID     => 1,
        Permission => 'ro',
    );
    my $CountNew = $Self->{TicketObject}->TicketSearch(
        Result     => 'COUNT',
        Locks      => ['lock'],
        OwnerIDs   => [ $Self->{UserID} ],
        TicketFlag => {
            Seen => 1,
        },
        TicketFlagUserID => $Self->{UserID},
        UserID           => 1,
        Permission       => 'ro',
    );
    $CountNew = $Count - $CountNew;

    my $Text = $Self->{LayoutObject}->{LanguageObject}->Get('Locked Tickets');
    my $URL  = $Self->{LayoutObject}->{Baselink};
    my $CountNotify;
    if ($CountNew) {
        $CountNotify = "*$CountNew/$Count";
        $URL .= 'Action=AgentTicketLockedView;Filter=New';
    }
    else {
        $CountNotify = $Count;
        $URL .= 'Action=AgentTicketLockedView';
    }
    my %Return;
    $Return{'0999999'} = {
        Block       => 'ToolBarItem',
        Count       => $CountNotify,
        Description => $Text,

        #        Name        => $Text,
        #        Image       => 'personal.png',
        Link      => $URL,
        AccessKey => 'k',
    };
    return %Return;
}

1;
