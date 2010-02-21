# --
# Kernel/Output/HTML/NavBarTicketLocked.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: NavBarTicketLocked.pm,v 1.3 2010-02-21 22:14:49 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::NavBarTicketLocked;

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
    my $URL;
    if ($CountNew) {
        $Text .= " (*$CountNew/$Count)";
        $URL = 'Action=AgentTicketLockedView;Filter=New';
    }
    else {
        $Text .= " ($Count)";
        $URL = 'Action=AgentTicketLockedView';
    }
    my %Return;
    $Return{'0999999'} = {
        Block       => 'ItemPersonal',
        Description => $Text,
        Name        => $Text,
        Image       => 'personal.png',
        Link        => $URL,
        AccessKey   => 'k',
    };
    return %Return;
}

1;
