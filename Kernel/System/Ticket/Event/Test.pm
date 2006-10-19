# --
# Kernel/System/Ticket/Event/Test.pm - test event module
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: Test.pm,v 1.4 2006-10-19 20:58:25 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Event::Test;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    # get needed objects
    foreach (qw(ConfigObject TicketObject LogObject UserObject CustomerUserObject SendmailObject)) {
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
    if ($Param{Event} eq 'TicketCreate') {
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Param{TicketID});
        if ($Ticket{State} eq 'Test') {
            # do some stuff
            $Self->{TicketObject}->HistoryAdd(
                TicketID => $Param{TicketID},
                CreateUserID => $Param{UserID},
                HistoryType => 'Misc',
                Name => "Some Info about Changes!",
            );
        }
    }
    elsif ($Param{Event} eq 'MoveTicket') {
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Param{TicketID});
        if ($Ticket{Queue} eq 'Test') {
            # do some stuff
            $Self->{TicketObject}->HistoryAdd(
                TicketID => $Param{TicketID},
                CreateUserID => $Param{UserID},
                HistoryType => 'Misc',
                Name => "Some Info about Changes!",
            );
        }
    }
}

1;
