# --
# Kernel/Output/HTML/NotificationAgentTicket.pm
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NotificationAgentTicket.pm,v 1.4 2005-07-23 10:47:25 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicket;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject LogObject DBObject LayoutObject TicketObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    # get user lock data
    my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});

    if ($LockedData{New}) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New',
            Data => '$Text{"You have %s new message(s)!", "'.$LockedData{New}.'"}',
        );
    }
    if ($LockedData{Reminder}) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Link => '$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=Reminder',
            Data => '$Text{"You have %s reminder ticket(s)!", "'.$LockedData{Reminder}.'"}',
        );
    }
    return $Output;
}
# --

1;
