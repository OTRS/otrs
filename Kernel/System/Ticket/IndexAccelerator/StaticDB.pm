# --
# Kernel/System/Ticket/IndexAccelerator/StaticDB.pm - static db queue ticket index module
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: StaticDB.pm,v 1.4 2003-01-02 18:18:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::IndexAccelerator::StaticDB;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

sub TicketAcceleratorUpdate {
    my $Self = shift;
    my %Param = @_;
    my @ViewableLocks = @{$Self->{ConfigObject}{ViewableLocks}};
    my @ViewableStats = @{$Self->{ConfigObject}{ViewableStats}};
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # check if ticket is shown or not
    # --
    my $IndexUpdateNeeded = 0;
    my $IndexSelcected = 0;
    my %TicketData = $Self->GetTicket(%Param);
    my %IndexTicketData = $Self->GetIndexTicket(%Param);
    if (!%IndexTicketData) {
        $IndexUpdateNeeded = 1;
    }
    else {
        # --
        # chekc if we need to update
        # --
        if ($TicketData{Lock} ne $IndexTicketData{Lock}) {
          $IndexUpdateNeeded = 1;
        }
        elsif ($TicketData{State} ne $IndexTicketData{State}) {
          $IndexUpdateNeeded = 1;
        }
        elsif ($TicketData{QueueID} ne $IndexTicketData{QueueID}) {
          $IndexUpdateNeeded = 1;
        }
    }
    # --
    # check if this ticket ist still viewable
    # --
    my $ViewableStatsHit = 0;
    foreach (@ViewableStats) {
        if ($_ =~ /^'$TicketData{State}'$/i) {
            $ViewableStatsHit = 1;
        }
    }
    my $ViewableLocksHit = 0;
    foreach (@ViewableLocks) {
        if ($_ =~ /^'$TicketData{Lock}'$/i) {
            $ViewableLocksHit = 1;
        }
    }
    if ($ViewableStatsHit && $ViewableLocksHit) {
        $IndexSelcected = 1;
    }
    # --
    # write index back
    # --
    if ($IndexUpdateNeeded) {
      if ($IndexSelcected) {
        if ($IndexTicketData{TicketID}) {
          my $SQL = "UPDATE ticket_index SET ".
            " queue_id = $TicketData{QueueID}, ".
            " queue = '$TicketData{Queue}', group_id = $TicketData{GroupID}, ".
            " s_lock = '$TicketData{Lock}', s_state = '$TicketData{State}' ".
            " WHERE  ".
            " ticket_id = $Param{TicketID} ";
          $Self->{DBObject}->Do(SQL => $SQL);
        }
        else {
          $Self->TicketAcceleratorAdd(%TicketData);
        }
      }
      else {
        $Self->TicketAcceleratorDelete(%Param);
      }
    }
    return 1;
}
# --
sub TicketAcceleratorDelete {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my $SQL = "DELETE FROM ticket_index WHERE ticket_id = $Param{TicketID} ";
    $Self->{DBObject}->Do(SQL => $SQL);
    return;
}
# --
sub TicketAcceleratorAdd {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # get ticket data
    # --
    my %TicketData = $Self->GetTicket(%Param);
    # --
    # write/append index 
    # --
    my $SQL = "INSERT INTO ticket_index ".
        " (ticket_id, queue_id, queue, group_id, s_lock, s_state, create_time_unix)".
        " VALUES ".
        " ($Param{TicketID}, $TicketData{QueueID}, '$TicketData{Queue}', ".
        " $TicketData{GroupID}, '$TicketData{Lock}', '$TicketData{State}', ".
        " $TicketData{CreateTimeUnix})";
    if ($Self->{DBObject}->Do(SQL => $SQL)) {
        return 1;
    } 
    else {
        return;
    }
}
# --
sub TicketAcceleratorIndex {
    my $Self = shift;
    my %Param = @_;
    my @ViewableLocks = @{$Self->{ConfigObject}{ViewableLocks}};
    my @ViewableStats = @{$Self->{ConfigObject}{ViewableStats}};
    # --
    # check needed stuff
    # --
    foreach (qw(UserID QueueID ShownQueueIDs)) {
      if (!exists($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %Queues = ();
    $Queues{MaxAge} = 0;
    $Queues{TicketsShown} = 0;
    $Queues{TicketsAvail} = 0;
    my @QueueIDs = @{$Param{ShownQueueIDs}};
    # --
    # prepar "All tickets: ??" in Queue
    # --
    if (@QueueIDs) {
        my $SQL = "SELECT count(*) as count " .
          " FROM " .
          " ticket st, ticket_state tsd " .
          " WHERE " .
          " tsd.id = st.ticket_state_id ".
          " AND " .
          " tsd.name in ( ${\(join ', ', @ViewableStats)} ) " .
          " and " .
          " st.queue_id in ( ${\(join ', ', @QueueIDs)} ) " .
          " ";

        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Queues{AllTickets} = $Row[0];
        }
    }
    # -- 
    # get user groups
    # --
    my %Groups = $Self->{UserObject}->GetGroups(%Param);
    my @GroupIDs = ();
    foreach (keys %Groups) {
        push (@GroupIDs, $_);
    }
    # --
    # get index 
    # --
    $Queues{MaxAge} = 0;
    # --
    # CustomQueue add on
    # --
    my $SQL = "SELECT count(*) FROM ".
    " ticket_index as ti, personal_queues as suq ".
    " WHERE ".
    " suq.queue_id = ti.queue_id ".
    " AND ".
    " ti.group_id in ( ${\(join ', ', @GroupIDs)} ) ".
    " AND ".
    " suq.user_id = $Param{UserID}";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Hashes;
        $Hashes{QueueID} = 0;
        $Hashes{Queue} = $Self->{ConfigObject}->Get('CustomQueue') || '???';
        $Hashes{MaxAge} = 0;
        $Hashes{Count} = $Row[0];
        push (@{$Queues{Queues}}, \%Hashes);
        # set some things
        if ($Param{QueueID} == 0) {
            $Queues{TicketsShown} = $Row[0];
            $Queues{TicketsAvail} = $Row[0];
        }
    }

    # prepar the tickets in Queue bar (all data only with my/your Permission)
    $SQL = "SELECT queue_id, queue, min(create_time_unix), count(*) as count ".
    " FROM " .
    " ticket_index ".
    " WHERE " .
    " group_id in ( ${\(join ', ', @GroupIDs)} ) ".
    " GROUP BY queue_id, queue " .
    " ORDER BY queue";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        # store the data into a array
        my %Hashes;
        $Hashes{QueueID} = $RowTmp[0];
        $Hashes{Queue} = $RowTmp[1];
        $Hashes{MaxAge} = time() - $RowTmp[2];
        $Hashes{Count} = $RowTmp[3];
        push (@{$Queues{Queues}}, \%Hashes);
        # set some things
        if ($Param{QueueID} == $RowTmp[0]) {
            $Queues{TicketsShown} = $RowTmp[3];
            $Queues{TicketsAvail} = $RowTmp[3];
        }
        # get the oldes queue id
        if ($Hashes{MaxAge} > $Queues{MaxAge}) {
            $Queues{MaxAge} = $Hashes{MaxAge};
            $Queues{QueueIDOfMaxAge} = $Hashes{QueueID};
        }
    }

    return %Queues;
}
# --
sub TicketAcceleratorRebuild {
    my $Self = shift;
    my %Param = @_;
    my @ViewableLocks = @{$Self->{ConfigObject}{ViewableLocks}};
    my @ViewableStats = @{$Self->{ConfigObject}{ViewableStats}};
    # --
    # get all viewable tickets
    # --
    my $SQL = "SELECT st.id, st.queue_id, sq.name, sq.group_id, slt.name, ".
    " tsd.name, st.create_time_unix ".
    " FROM " .
    " ticket as st, queue as sq, ticket_state tsd, " .
    " ticket_lock_type slt " .
    " WHERE " .
    " st.ticket_state_id = tsd.id " .
    " AND " .
    " st.queue_id = sq.id " .
    " AND " .
    " st.ticket_lock_id = slt.id " .
    " AND " .
    " tsd.name in ( ${\(join ', ', @ViewableStats)} ) " .
    " AND " .
    " slt.name in ( ${\(join ', ', @ViewableLocks)} ) " .
    " ";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    my @RowBuffer = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my %Data = ();
        $Data{TicketID} = $Row[0];
        $Data{QueueID} = $Row[1];
        $Data{Queue} = $Row[2];
        $Data{GroupID} = $Row[3];
        $Data{Lock} = $Row[4];
        $Data{State} = $Row[5];
        $Data{CreateTimeUnix} = $Row[6];
        push (@RowBuffer, \%Data);
    }
    # --
    # write index 
    # --
    $Self->{DBObject}->Do(SQL => "DELETE FROM ticket_index");
    foreach (@RowBuffer) {
        my %Data = %{$_};
        my $SQL = "INSERT INTO ticket_index ".
          " (ticket_id, queue_id, queue, group_id, s_lock, s_state, create_time_unix)".
          " VALUES ".
          " ($Data{TicketID}, $Data{QueueID}, '$Data{Queue}', $Data{GroupID}, ".
          " '$Data{Lock}', '$Data{State}', $Data{CreateTimeUnix})";
        $Self->{DBObject}->Do(SQL => $SQL)
    }
    return 1;
}
# --
sub GetIndexTicket {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID)) {
      if (!exists($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # --
    # sql query
    # --
    my $SQL = "SELECT ticket_id, queue_id, queue, group_id, s_lock, s_state, create_time_unix ".
      " FROM ticket_index ".
      " WHERE ticket_id = $Param{TicketID}";
    my %Data = ();
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Data{TicketID} = $Row[0];
        $Data{QueueID} = $Row[1];
        $Data{Queue} = $Row[2];
        $Data{GroupID} = $Row[3];
        $Data{Lock} = $Row[4];
        $Data{State} = $Row[5];
        $Data{CreateTimeUnix} = $Row[6];
    }
    return %Data;
}
# --

1;
