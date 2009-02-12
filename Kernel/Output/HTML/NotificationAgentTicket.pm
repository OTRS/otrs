# --
# Kernel/Output/HTML/NotificationAgentTicket.pm
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: NotificationAgentTicket.pm,v 1.9 2009-02-12 16:38:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::Output::HTML::NotificationAgentTicket;

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
    for (qw(ConfigObject LogObject DBObject LayoutObject TicketObject UserID)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Output = '';

    # get user lock data
    my %LockedData = $Self->{TicketObject}->GetLockedCount( UserID => $Self->{UserID} );

    if ( $LockedData{New} ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Link     => '$Env{"Baselink"}Action=AgentTicketMailbox&Filter=New',
            Data     => '$Text{"You have %s new message(s)!", "' . $LockedData{New} . '"}',
        );
    }
    if ( $LockedData{Reminder} ) {
        $Output .= $Self->{LayoutObject}->Notify(
            Priority => 'Notice',
            Link     => '$Env{"Baselink"}Action=AgentTicketMailbox&Filter=Reminder',
            Data     => '$Text{"You have %s reminder ticket(s)!", "' . $LockedData{Reminder} . '"}',
        );
    }
    return $Output;
}

1;
