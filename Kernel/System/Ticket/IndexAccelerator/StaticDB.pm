# --
# Kernel/System/Ticket/IndexAccelerator/StaticDB.pm - static db queue ticket index module
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: StaticDB.pm,v 1.31 2005-10-31 10:09:19 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::IndexAccelerator::StaticDB;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.31 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub TicketAcceleratorUpdate {
    my $Self = shift;
    my %Param = @_;
    my @ViewableLocks = @{$Self->{ViewableLocks}};
    my @ViewableStates = @{$Self->{ViewableStates}};
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # check if ticket is shown or not
    my $IndexUpdateNeeded = 0;
    my $IndexSelcected = 0;
    my %TicketData = $Self->TicketGet(%Param);
    my %IndexTicketData = $Self->GetIndexTicket(%Param);
    if (!%IndexTicketData) {
        $IndexUpdateNeeded = 1;
    }
    else {
        # check if we need to update
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
    # check if this ticket ist still viewable
    my $ViewableStatsHit = 0;
    foreach (@ViewableStates) {
        if ($_ =~ /^$TicketData{State}$/i) {
            $ViewableStatsHit = 1;
        }
    }
    my $ViewableLocksHit = 0;
    foreach (@ViewableLocks) {
        if ($_ =~ /^$TicketData{Lock}$/i) {
            $ViewableLocksHit = 1;
        }
    }
    if ($ViewableStatsHit && $ViewableLocksHit) {
        $IndexSelcected = 1;
    }
    # write index back
    if ($IndexUpdateNeeded) {
      if ($IndexSelcected) {
        if ($IndexTicketData{TicketID}) {
            # db quote
            foreach (qw(TicketID QueueID GroupID)) {
                $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
            }
            foreach (qw(Queue State Lock)) {
                $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
            }
            my $SQL = "UPDATE ticket_index SET ".
                " queue_id = $TicketData{QueueID}, ".
                " queue = '$TicketData{Queue}', group_id = $TicketData{GroupID}, ".
                " s_lock = '$TicketData{Lock}', s_state = '$TicketData{State}' ".
                " WHERE  ".
                " ticket_id = $Param{TicketID}";
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
    # write lock index
    if (!$ViewableLocksHit) {
        # check if there is already an lock index entry
        if (!$Self->GetIndexTicketLock(%Param)) {
            # add lock index entry
            $Self->TicketLockAcceleratorAdd(%TicketData);
        }
    }
    else {
        # delete lock index entry if tickst is unlocked
        $Self->TicketLockAcceleratorDelete(%Param);
    }
    return 1;
}
# --
sub TicketAcceleratorDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    my $SQL = "DELETE FROM ticket_index WHERE ticket_id = $Param{TicketID} ";
    $Self->{DBObject}->Do(SQL => $SQL);
    return;
}
# --
sub TicketAcceleratorAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # get ticket data
    my %TicketData = $Self->TicketGet(%Param);
    # write/append index
    foreach (keys %TicketData) {
        $TicketData{$_} = $Self->{DBObject}->Quote($TicketData{$_});
    }
    # db quote
    foreach (qw(TicketID QueueID GroupID CreateTimeUnix)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    foreach (qw(Queue State Lock)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
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
sub TicketLockAcceleratorDelete {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # db query
    my $SQL = "DELETE FROM ticket_lock_index WHERE ticket_id = $Param{TicketID} ";
    $Self->{DBObject}->Do(SQL => $SQL);
    return;
}
# --
sub TicketLockAcceleratorAdd {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get ticket data
    my %TicketData = $Self->TicketGet(%Param);
    # write/append index
    foreach (keys %TicketData) {
        $TicketData{$_} = $Self->{DBObject}->Quote($TicketData{$_});
    }
    my $SQL = "INSERT INTO ticket_lock_index ".
        " (ticket_id)".
        " VALUES ".
        " ($Param{TicketID})";
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
    # check needed stuff
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
    # prepar "All tickets: ??" in Queue
    if (@QueueIDs) {
        my $SQL = "SELECT count(*) as count " .
          " FROM " .
          " ticket st " .
          " WHERE " .
          " st.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) " .
          " and " .
          " st.queue_id in (";
        foreach (0..$#QueueIDs) {
            if ($_ > 0) {
                $SQL .= ",";
            }
            $SQL .= $Self->{DBObject}->Quote($QueueIDs[$_]);
        }
        $SQL .= " )";

        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Queues{AllTickets} = $Row[0];
        }
    }
    # get user groups
    my $Type = 'rw';
    if ($Self->{ConfigObject}->Get('Ticket::QueueViewAllPossibleTickets')) {
        $Type = 'ro';
    }
    my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
        UserID => $Param{UserID},
        Type => $Type,
        Result => 'ID',
        Cached => 1,
    );
    # get index
    $Queues{MaxAge} = 0;
    # check if user is in min. one group! if not, return here
    if (!@GroupIDs) {
        my %Hashes;
        $Hashes{QueueID} = 0;
        $Hashes{Queue} = 'CustomQueue';
        $Hashes{MaxAge} = 0;
        $Hashes{Count} = 0;
        push (@{$Queues{Queues}}, \%Hashes);
        return %Queues;
    }
    # CustomQueue add on
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
        $Hashes{Queue} = 'CustomQueue';
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
        $Hashes{MaxAge} = $Self->{TimeObject}->SystemTime() - $RowTmp[2];
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
    # get all viewable tickets
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
    " st.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) " .
    " AND " .
    " st.ticket_lock_id in ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) " .
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
    # write index
    $Self->{DBObject}->Do(SQL => "DELETE FROM ticket_index");
    foreach (@RowBuffer) {
        my %Data = %{$_};
        foreach (keys %Data) {
            $Data{$_} = $Self->{DBObject}->Quote($Data{$_});
        }
        my $SQL = "INSERT INTO ticket_index ".
          " (ticket_id, queue_id, queue, group_id, s_lock, s_state, create_time_unix)".
          " VALUES ".
          " ($Data{TicketID}, $Data{QueueID}, '$Data{Queue}', $Data{GroupID}, ".
          " '$Data{Lock}', '$Data{State}', $Data{CreateTimeUnix})";
        $Self->{DBObject}->Do(SQL => $SQL)
    }
    # write lock index
    $Self->{DBObject}->Prepare(
       SQL => "SELECT ti.id, ti.user_id ".
         " FROM ".
         " ticket ti ".
         " WHERE ".
         " ti.ticket_lock_id not in ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) ",
    );
    my @LockRowBuffer = ();
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@LockRowBuffer, $Row[0]);
    }
    $Self->{DBObject}->Do(SQL => "DELETE FROM ticket_lock_index");
    foreach (@LockRowBuffer) {
        # add lock index entry
        $Self->TicketLockAcceleratorAdd(TicketID => $_);
    }
    return 1;
}
# --
sub GetIndexTicket {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!exists($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql query
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
sub GetIndexTicketLock {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(TicketID)) {
      if (!exists($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # sql query
    my $SQL = "SELECT ticket_id ".
      " FROM ticket_lock_index ".
      " WHERE ticket_id = $Param{TicketID}";
    my $Hit = 0;
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Hit = 1;
    }
    return $Hit;
}
# --
sub GetLockedCount {
    my $Self = shift;
    my %Param = @_;
    # check needed stuff
    foreach (qw(UserID)) {
      if (!exists($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # db query
    $Self->{DBObject}->Prepare(
       SQL => "SELECT ar.id as ca, st.name, ti.id, ar.create_by, ti.create_time_unix, ".
              " ti.until_time, ts.name, tst.name ".
              " FROM ".
              " ticket ti, article ar, article_sender_type st, ".
              " ticket_state ts, ticket_lock_index tli, ticket_state_type tst ".
              " WHERE ".
              " tli.ticket_id = ti.id".
              " AND ".
              " tli.ticket_id = ar.ticket_id".
              " AND ".
              " st.id = ar.article_sender_type_id ".
              " AND ".
              " ts.id = ti.ticket_state_id ".
              " AND ".
              " ts.type_id = tst.id " .
              " AND ".
              " ti.user_id = $Param{UserID} ".
              " ORDER BY ar.create_time DESC",
    );
    my %TicketIDs = ();
    my %Data = ();
    $Data{'Reminder'} = 0;
    $Data{'Pending'} = 0;
    $Data{'All'} = 0;
    $Data{'New'} = 0;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if (!$Param{"ID$Row[2]"}) {
          $Data{'All'}++;
          # put all tickets to ToDo where last sender type is customer or ! UserID
          if ($Row[3] ne $Param{UserID} || $Row[1] eq 'customer') {
              $Data{'New'}++;
          }

          if ($Row[5] && $Row[7] =~ /^pending/i) {
              $Data{'Pending'}++;
              if ($Row[7] !~ /^pending auto/i && $Row[5] <= $Self->{TimeObject}->SystemTime()) {
                  $Data{'Reminder'}++;
              }
          }
        }
        $Param{"ID$Row[2]"} = 1;
        $Data{"MaxAge"} = $Row[4];
        $TicketIDs{$Row[2]} = 1;
    }
    # show just unseen tickets as new
    if ($Self->{ConfigObject}->Get('Ticket::NewMessageMode') eq 'ArticleSeen') {
        # reset new message count
        $Data{'New'} = 0;
        foreach my $TicketID (keys %TicketIDs) {
            my @Index = $Self->ArticleIndex(TicketID => $TicketID);
            my %Article = $Self->ArticleGet(ArticleID => $Index[$#Index]);
            my %Flag = $Self->ArticleFlagGet(
                ArticleID => $Article{ArticleID},
                UserID => $Param{UserID},
            );
            if (!$Flag{seen}) {
                $Data{'New'}++;
            }
        }
    }
    return %Data;
}
# --
sub GetOverTimeTickets {
    my $Self = shift;
    my %Param = @_;
    # get data (viewable tickets...)
    my @TicketIDsOverTime = ();
    my %TicketIDs = ();
    my $SQL = "SELECT st.id, st.escalation_start_time, q.escalation_time, st.ticket_priority_id, q.name ".
        " FROM ".
        " queue q, ticket st ".
        " WHERE ".
        " q.escalation_time != 0 ".
        " AND " .
        " st.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) " .
        " AND " .
        " q.id = st.queue_id ".
        " AND ";

    if ($Param{UserID}) {
        my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
            UserID => $Param{UserID},
            Type => 'rw',
            Result => 'ID',
            Cached => 1,
        );
        $SQL .= " q.group_id IN ( ${\(join ', ', @GroupIDs)} ) AND ";
        # check if user is in min. one group! if not, return here
        if (!@GroupIDs) {
            return;
        }
    }
    $SQL .= " st.ticket_lock_id in ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) ";
    $SQL .= " ORDER BY st.ticket_priority_id DESC, st.escalation_start_time ASC";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 40);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if ($Row[2] && $Row[1]) {
            my $CountedTime = $Self->{TimeObject}->WorkingTime(
                StartTime => $Row[1],
                StopTime => $Self->{TimeObject}->SystemTime(),
                Queue => $Row[4],
            );
            my $DiffTime = ($Row[2]*60) - $CountedTime;
            if ($DiffTime < 0) {
                push (@TicketIDsOverTime, $Row[0]);
            }
        }
    }
    # return overtime tickets
    return @TicketIDsOverTime;
}
# --

1;
