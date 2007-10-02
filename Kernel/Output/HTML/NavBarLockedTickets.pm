# --
# Kernel/Output/HTML/NavBarLockedTickets.pm
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: NavBarLockedTickets.pm,v 1.9 2007-10-02 10:42:08 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NavBarLockedTickets;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.9 $) [1];

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

    my %Return = ();

    # get responsible
    if ( $Self->{ConfigObject}->Get('Ticket::Responsible') ) {
        my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            Result         => 'ARRAY',
            Limit          => 1000,
            StateType      => 'Open',
            ResponsibleIDs => [ $Self->{UserID} ],
            UserID         => 1,
            Permission     => 'ro',
        );
        my $Text = $Self->{LayoutObject}->{LanguageObject}->Get('Responsible') . " ("
            . @ViewableTickets . ")";
        $Return{'0999899'} = {
            Block       => 'ItemPersonal',
            Description => $Text,
            Name        => $Text,
            Image       => 'folder_yellow.png',
            Link        => 'Action=AgentTicketMailbox&Subaction=Responsible',
            AccessKey   => 'r',
        };
    }

    # get user lock data
    my %LockedData = $Self->{TicketObject}->GetLockedCount( UserID => $Self->{UserID} );

    my $Text
        = $Self->{LayoutObject}->{LanguageObject}->Get('Locked Tickets') . " ($LockedData{All})";
    $Return{'0999999'} = {
        Block       => 'ItemPersonal',
        Description => $Text,
        Name        => $Text,
        Image       => 'personal.png',
        Link        => 'Action=AgentTicketMailbox',
        AccessKey   => 'k',
    };
    $Text = $Self->{LayoutObject}->{LanguageObject}->Get('New message') . " ($LockedData{New})";
    $Return{'0999989'} = {
        Block       => 'ItemPersonal',
        Description => $Text,
        Name        => $Text,
        Image       => 'new-message.png',
        Link        => 'Action=AgentTicketMailbox&Subaction=New',
        AccessKey   => 'm',
    };
    return %Return;
}

1;
