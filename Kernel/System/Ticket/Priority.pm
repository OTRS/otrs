# --
# Kernel/System/Ticket/Priority.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Priority.pm,v 1.7 2003-01-03 00:34:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::Ticket::Priority;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub PriorityLookup {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{Type}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need Type!");
      return;
    }
    # --
    # check if we ask the same request?
    # --
    if (exists $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"}) {
        return $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"};
    }
    # --
    # db query
    # --
    my $SQL = "SELECT id FROM ticket_priority WHERE name = '$Param{Type}'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"} = $Row[0];
    }
    # --
    # check if data exists
    # --
    if (!exists $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No TypeID for $Param{Type} found!");
        return;
    }
    else {
        return $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"};
    }
}
# --
sub PriorityIDLookup {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    if (!$Param{ID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need ID!");
      return;
    }
    # --
    # check if we ask the same request?
    # --
    if (exists $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"}) {
        return $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"};
    }
    # --
    # db query
    # --
    my $SQL = "SELECT name FROM ticket_priority WHERE id = $Param{ID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"} = $Row[0];
    }
    # --
    # check if data exists
    # --
    if (!exists $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No Name for $Param{ID} found!");
        return;
    }
    else {
        return $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"};
    }
}
# --
sub SetPriority {
    my $Self = shift;
    my %Param = @_;
    # --
    # lookup!
    # --
    if (!$Param{PriorityID} && $Param{Priority}) {
        $Param{PriorityID} = $Self->PriorityLookup(Type => $Param{Priority});
    }
    if ($Param{PriorityID} && !$Param{Priority}) {
        $Param{Priority} = $Self->PriorityIDLookup(ID => $Param{PriorityID});
    }
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID PriorityID Priority)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %TicketData = $Self->GetTicket(%Param);
    # --
    # check if update is needed
    # --
    if ($TicketData{Priority} eq $Param{Priority}) {
       # update not needed
       return 1;
    }
    # --
    # db update
    # --
    my $SQL = "UPDATE ticket SET ticket_priority_id = $Param{PriorityID}, " .
        " change_time = current_timestamp, change_by = $Param{UserID} " .
        " WHERE id = $Param{TicketID} ";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # --
      # add history
      # --
      $Self->AddHistoryRow(
          TicketID => $Param{TicketID},
          CreateUserID => $Param{UserID},
          HistoryType => 'PriorityUpdate',
          Name => "Priority update to $Param{Priority} ($Param{PriorityID}) .",
      );
      return 1;
    }
    else {
        return;
    }
}
# --

1;

