# --
# Kernel/System/Ticket/Priority.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Priority.pm,v 1.12 2004-02-13 00:50:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --
package Kernel::System::Ticket::Priority;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub PriorityLookup {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{Type} && !$Param{ID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need Type or ID!");
      return;
    }
    # check if we ask the same request?
    if ($Param{Type}) {
        if (exists $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"}) {
            return $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"};
        }
    }
    else {
        if (exists $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"}) {
            return $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"};
        }
    }
    # db query
    my $SQL = '';
    if ($Param{Type}) {
        $SQL = "SELECT id FROM ticket_priority WHERE name = '".$Self->{DBObject}->Quote($Param{Type})."'";
    }
    else {
        $SQL = "SELECT name FROM ticket_priority WHERE id = ".$Self->{DBObject}->Quote($Param{ID})."";
    }
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        if ($Param{Type}) {
            $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"} = $Row[0];
        }
        else {
            $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"} = $Row[0];
        }
    }
    # check if data exists
    if ($Param{Type}) {
        if (!exists $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"}) {
            $Self->{LogObject}->Log(
                Priority => 'error', 
                Message => "No TypeID for $Param{Type} found!",
            );
            return;
        }
        else {
            return $Self->{"Ticket::Priority::PriorityLookup::$Param{Type}"};
        }
    }
    else {
        if (!exists $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"}) {
            $Self->{LogObject}->Log(
                Priority => 'error', 
                Message => "No ID for $Param{ID} found!",
            );
            return;
        }
        else {
            return $Self->{"Ticket::Priority::PriorityIDLookup::$Param{ID}"};
        }
    }
}
# --
sub PrioritySet {
    my $Self = shift;
    my %Param = @_;
    # lookup!
    if (!$Param{PriorityID} && $Param{Priority}) {
        $Param{PriorityID} = $Self->PriorityLookup(Type => $Param{Priority});
    }
    if ($Param{PriorityID} && !$Param{Priority}) {
        $Param{Priority} = $Self->PriorityLookup(ID => $Param{PriorityID});
    }
    # check needed stuff
    foreach (qw(TicketID UserID PriorityID Priority)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %TicketData = $Self->GetTicket(%Param);
    # check if update is needed
    if ($TicketData{Priority} eq $Param{Priority}) {
       # update not needed
       return 1;
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db update
    my $SQL = "UPDATE ticket SET ticket_priority_id = $Param{PriorityID}, " .
        " change_time = current_timestamp, change_by = $Param{UserID} " .
        " WHERE id = $Param{TicketID} ";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # add history
      $Self->AddHistoryRow(
          TicketID => $Param{TicketID},
          CreateUserID => $Param{UserID},
          HistoryType => 'PriorityUpdate',
          Name => "Priority update from '$TicketData{Priority}' ($TicketData{PriorityID})".
              " to '$Param{Priority}' ($Param{PriorityID}).",
      );
      return 1;
    }
    else {
        return;
    }
}
# --
sub PriorityList {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    if (!$Param{UserID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "UserID!");
        return;
    }
    # sql 
    my $SQL = "SELECT id, name ".
        " FROM ".
        " ticket_priority ";
    my %Data = ();
    if ($Self->{DBObject}->Prepare(SQL => $SQL)) {
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Data{$Row[0]} = $Row[1];
        }
        return %Data;
    }
    else {
        return;
    }
}
# --

1;
