# --
# Kernel/System/Ticket/Lock.pm - the sub module of the global Ticket.pm handle
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: Lock.pm,v 1.4 2002-07-13 12:28:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::Lock;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub GetLockState {
    my $Self = shift;
    my %Param = @_;
    my $LockState = 'lock';
    my $Hit = 0;

    # --
    # check needed stuff
    # --
    if (!$Param{TicketID}) {
      $Self->{LogObject}->Log(Priority => 'error', Message => "Need TicketID!");
      return;
    }
    # --
    # db query
    # --
    my $SQL = "SELECT st.id " .
        " FROM " .
        " ticket st, ticket_lock_type slt " .
        " WHERE " .
        " st.id = $Param{TicketID} " .
        " AND " .
        " slt.name = '$LockState' " .
        " AND " .
        " st.ticket_lock_id = slt.id ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Hit = 1;
    }
    if ($Hit) {
        return 1;
    }
    else {
        return;
    }
}
# --
sub LockLookup {
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
    if (exists $Self->{"Ticket::Lock::Lookup::$Param{Type}"}) {
        return $Self->{"Ticket::Lock::Lookup::$Param{Type}"};
    }
    # --
    # db query
    # --
    my $SQL = "SELECT id " .
    " FROM " .
    " ticket_lock_type " .
    " WHERE " .
    " name = '$Param{Type}'";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store result
        $Self->{"Ticket::Lock::Lookup::$Param{Type}"} = $Row[0];
    }
    # --
    # check if data exists
    # --
    if (!exists $Self->{"Ticket::Lock::Lookup::$Param{Type}"}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "No TypeID for $Param{Type} found!");
        return;
    }
    else {
        return $Self->{"Ticket::Lock::Lookup::$Param{Type}"};
    }
}
# --
sub SetLock {
    my $Self = shift;
    my %Param = @_;
    # --
    # lookup!
    # --
    if ((!$Param{LockID}) && ($Param{Lock})) {
        $Param{LockID} = $Self->LockLookup(Type => $Param{Lock});
    }
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID UserID LockID Lock)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    if (!$Param{Lock} && !$Param{LockID}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need LcokID or Lock!");
        return;
    }
    # --
    # check if update is needed
    # --
    if (($Self->GetLockState(TicketID => $Param{TicketID}) && $Param{Lock} eq 'lock') ||
        (!$Self->GetLockState(TicketID => $Param{TicketID}) && $Param{Lock} eq 'unlock')) {
        # update not needed
        return 1;
    }
    # --
    # db update
    # --
    my $SQL = "UPDATE ticket SET ticket_lock_id = $Param{LockID}, " .
    " change_time = current_timestamp, change_by = $Param{UserID} " .
        " WHERE id = $Param{TicketID}";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
      # set lock time it event is 'lock'
      if ($Param{Lock} eq 'lock') {
        $SQL = "UPDATE ticket SET timeout = ". time() . 
          " WHERE id = $Param{TicketID} "; 
        $Self->{DBObject}->Do(SQL => $SQL);
      }
      # --
      # add history
      # --
      my $HistoryType = '';
      if ($Param{Lock} eq 'unlock') {
        $HistoryType = 'Unlock';
      }
      elsif ($Param{Lock} eq 'lock') {
        $HistoryType = 'Lock';
      }
      else {
        $HistoryType = 'Misc';
      }

      if ($HistoryType) {
        $Self->AddHistoryRow(
          TicketID => $Param{TicketID},
          CreateUserID => $Param{UserID},
          HistoryType => $HistoryType,
          Name => "Ticket $Param{Lock}.",
        );
      }
      return 1;
    }
    else {
      return;
    }
}
# --

1;

