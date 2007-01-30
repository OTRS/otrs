# --
# Kernel/System/Ticket/Event/ForceUnlock.pm - unlock ticket
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: ForceUnlock.pm,v 1.5 2007-01-30 17:33:24 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Event::ForceUnlock;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject TimeObject EncodeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID Event Config)) {
        if (!$Param{$_}) {
            $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
            return;
        }
    }
    $Self->{TicketObject}->LockSet(
        TicketID => $Param{TicketID},
        Lock => 'unlock',
        SendNoNotification => 1,
        UserID => 1,
    );
    return 1;
}

1;
