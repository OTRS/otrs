# --
# Kernel/Output/HTML/NavBarBurdaResponsibleTicket.pm
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NavBarBurdaResponsibleTicket.pm,v 1.1 2006-06-26 08:26:01 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NavBarBurdaResponsibleTicket;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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

    my @ViewableTickets = $Self->{TicketObject}->TicketSearch(
            Result => 'ARRAY',
            Limit => 1000,
            StateType => 'Open',
            RUserIDs => [$Self->{UserID}],
            UserID => $Self->{UserID},
            Permission => 'ro',
    );

    my $Text = $Self->{LayoutObject}->{LanguageObject}->Get('Verantwortlich')." (".@ViewableTickets.")";

    $Return{'0999899'} = {
        Block => 'ItemPersonal',
        Description => $Text,
        Name => $Text,
        Image => 'folder_yellow.png',
        Link => 'Action=AgentTicketMailbox&Subaction=Responsible',
        AccessKey => 'm',
    };
    return %Return;
}
# --

1;
