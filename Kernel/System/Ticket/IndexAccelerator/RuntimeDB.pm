# --
# Kernel/System/Ticket/IndexAccelerator/RuntimeDB.pm - realtime database 
# queue ticket index module
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: RuntimeDB.pm,v 1.14 2003-07-12 08:22:31 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::IndexAccelerator::RuntimeDB;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub TicketAcceleratorUpdate {
    my $Self = shift;
    my %Param = @_;
    return 1;
}
# --
sub TicketAcceleratorDelete {
    my $Self = shift;
    my %Param = @_;
    return 1;
}
# --
sub TicketAcceleratorAdd {
    my $Self = shift;
    my %Param = @_;
    return 1;
}
# --
sub TicketAcceleratorIndex {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(UserID QueueID ShownQueueIDs)) {
      if (!exists($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # get user groups 
    my $Type = 'rw';
    if ($Self->{ConfigObject}->Get('QueueViewAllPossibleTickets')) {
        $Type = 'ro';
    }
    my @GroupIDs = $Self->{GroupObject}->GroupUserList(
        UserID => $Param{UserID},
        Type => $Type,
        Result => 'ID',
    );
    my @QueueIDs = @{$Param{ShownQueueIDs}};
    my %Queues = ();
    $Queues{MaxAge} = 0;
    $Queues{TicketsShown} = 0;
    $Queues{TicketsAvail} = 0;
    # --
    # prepar "All tickets: ??" in Queue
    # --
    if (@QueueIDs) {
        my $SQL = "SELECT count(*) ".
          " FROM ".
          " ticket st ".
          " WHERE ".
          " st.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) ".
          " AND ".
          " st.queue_id in ( ${\(join ', ', @QueueIDs)} ) ".
          " ";
    
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $Queues{AllTickets} = $Row[0];
        }
    }
    # check if user is in min. one group! if not, return here
    if (!@GroupIDs) {
        my %Hashes;
        $Hashes{QueueID} = 0;
        $Hashes{Queue} = $Self->{ConfigObject}->Get('CustomQueue') || '???';
        $Hashes{MaxAge} = 0;
        $Hashes{Count} = 0;
        push (@{$Queues{Queues}}, \%Hashes);
        return %Queues;
    }
    # --
    # CustomQueue add on
    # --
    my $SQL = "SELECT count(*) FROM ".
    " ticket st, queue sq, personal_queues suq ".
    " WHERE ".
    " st.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) ".
    " AND ".
    " st.ticket_lock_id in ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) ".
    " AND ".
    " st.queue_id = sq.id ".
    " AND ".
    " suq.queue_id = st.queue_id ".
    " AND ".
    " sq.group_id IN ( ${\(join ', ', @GroupIDs)} ) ".
    " AND ".
    # get all custom queues
    " suq.user_id = $Param{UserID} ".
    #/ get all custom queues /
    "";
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
    $SQL = "SELECT st.queue_id, sq.name, min(st.create_time_unix), count(*) ".
    " FROM " .
    " ticket st, queue sq " .
    " WHERE " .
    " st.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) " .
    " AND " .
    " st.ticket_lock_id in ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) " .
    " AND " .
    " st.queue_id = sq.id " .
    " AND ".
    " sq.group_id IN ( ${\(join ', ', @GroupIDs)} ) ".
    " GROUP BY st.queue_id,sq.name " .
    " ORDER BY sq.name";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        # store the data into a array
        my %Hashes;
        $Hashes{QueueID} = $Row[0];
        $Hashes{Queue} = $Row[1];
        $Hashes{MaxAge} = time() - $Row[2];
        $Hashes{Count} = $Row[3];
        push (@{$Queues{Queues}}, \%Hashes);
        # set some things
        if ($Param{QueueID} eq $Row[0]) {
            $Queues{TicketsShown} = $Row[3];
            $Queues{TicketsAvail} = $Row[3];
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
    return 1;
}
# --
sub GetLockedCount {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(UserID)) {
      if (!exists($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    $Self->{DBObject}->Prepare(
       SQL => "SELECT ar.id as ca, st.name, ti.id, ar.create_by, ti.create_time_unix, ".
              " ti.until_time, ts.name, tst.name " .
              " FROM " .
              " ticket ti, article ar, article_sender_type st, " .
              " ticket_state ts, ticket_state_type tst " .
              " WHERE " .
              " ti.ticket_lock_id not in ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) " .
              " AND " .
              " ti.user_id = $Param{UserID} " .
              " AND " .
              " ar.ticket_id = ti.id " .
              " AND " .
              " st.id = ar.article_sender_type_id " .
              " AND " .
              " ts.id = ti.ticket_state_id " .
              " AND " .
              " ts.type_id = tst.id " .
              " ORDER BY ar.create_time DESC",
    ); 
    my %Data = ();
    $Data{'Reminder'} = 0;
    $Data{'Pending'} = 0;
    $Data{'All'} = 0;
    $Data{'New'} = 0;
    $Data{'Open'} = 0;
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        if (!$Param{"ID$RowTmp[2]"}) {
          $Data{'All'}++;
          # --
          # put all tickets to ToDo where last sender type is customer or ! UserID
          # --
          if ($RowTmp[3] ne $Param{UserID} || $RowTmp[1] eq 'customer') {
              $Data{'New'}++;
          }
          if ($RowTmp[5] && $RowTmp[7] =~ /^pending/i) {
              $Data{'Pending'}++;
              if ($RowTmp[7] !~ /^pending auto/i && $RowTmp[5] <= time()) {
                  $Data{'Reminder'}++;
              }
          }
        }
        $Param{"ID$RowTmp[2]"} = 1;
        $Data{"MaxAge"} = $RowTmp[4];
    }
    $Data{'Open'} = $Data{'All'} - $Data{'Pending'};
    return %Data;
}
# --
sub GetOverTimeTickets {
    my $Self = shift;
    my %Param = @_;
    # --
    # get data (viewable tickets...)
    # --
    my @TicketIDsOverTime = ();
    my $SQL = "SELECT distinct (a.ticket_id), t.ticket_priority_id, a.incoming_time ".
    " FROM ".
    " article a, queue q, ticket t ".
    " WHERE ".
    " t.ticket_answered != 1 ".
    " AND " .
    " q.escalation_time != 0 ".
    " AND " .
    " t.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) " .
    " AND " .
    " t.ticket_lock_id in ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) " .
    " AND " .
    " t.id = a.ticket_id ".
    " AND ".
    " q.id = t.queue_id ".
    " AND ";
    if ($Param{UserID}) {
        my @GroupIDs = $Self->{GroupObject}->GroupUserList(
            UserID => $Param{UserID},
            Type => 'rw',
            Result => 'ID',
        );
        $SQL .= " q.group_id IN ( ${\(join ', ', @GroupIDs)} ) AND ";
        # check if user is in min. one group! if not, return here
        if (!@GroupIDs) {
            return;
        }
    }
    $SQL .= " a.article_sender_type_id = ".
      $Self->ArticleSenderTypeLookup(SenderType => 'customer').
    " AND ".
    " ".time()." >= (a.incoming_time + (q.escalation_time * 60))".
    " ORDER BY t.ticket_priority_id DESC, a.incoming_time";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 20);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        push (@TicketIDsOverTime, $Row[0]);
    }
    # return overtime tickets
    if (@TicketIDsOverTime) {
        return @TicketIDsOverTime;
    }
    else {
        return;
    }
}
# --

1;
