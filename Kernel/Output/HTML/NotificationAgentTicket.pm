# --
# Kernel/Output/HTML/NotificationAgentTicket.pm
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NotificationAgentTicket.pm,v 1.3 2005-02-17 07:09:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicket;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
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
          Info => '<a href="$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=New">'.
            $Self->{LayoutObject}->{LanguageObject}->Get('You have %s new message(s)!", "'.$LockedData{New}).'</a>'
        );
    }
    if ($LockedData{Reminder}) {
        $Output .= $Self->{LayoutObject}->Notify(
          Info => '<a href="$Env{"Baselink"}Action=AgentTicketMailbox&Subaction=Reminder">'.
           $Self->{LayoutObject}->{LanguageObject}->Get('You have %s reminder ticket(s)!", "'.$LockedData{Reminder}).'</a>',
        );
    }
    return $Output;
}
# --

1;
