# --
# Kernel/Output/HTML/NavBarLockedTickets.pm
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NavBarLockedTickets.pm,v 1.5 2005-07-23 09:32:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NavBarLockedTickets;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
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
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my %Return = ();
    # get user lock data
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});

    my $Text = $Self->{LayoutObject}->{LanguageObject}->Get('Locked Tickets')." ($LockedData{All})";
    $Return{'0999999'} = {
        Block => 'ItemPersonal',
        Description => $Text,
        Name => $Text,
        Image => 'personal.png',
        Link => 'Action=AgentTicketMailbox',
        AccessKey => 'k',
    };
    $Text = $Self->{LayoutObject}->{LanguageObject}->Get('New message')." ($LockedData{New})";
    $Return{'0999989'} = {
        Block => 'ItemPersonal',
        Description => $Text,
        Name => $Text,
        Image => 'new-message.png',
        Link => 'Action=AgentTicketMailbox&Subaction=New',
        AccessKey => 'm',
    };
    return %Return;
}
# --

1;
