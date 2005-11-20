# --
# Kernel/System/Ticket/IndexAccelerator/RuntimeDB.pm - realtime database
# queue ticket index module
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: RuntimeDB.pm,v 1.21.2.1 2005-11-20 21:38:44 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.21.2.1 $';
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
    # check needed stuff
    foreach (qw(UserID QueueID ShownQueueIDs)) {
      if (!exists($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    foreach (qw(UserID QueueID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
    }
    # get user groups
    my $Type = 'rw';
    if ($Self->{ConfigObject}->Get('QueueViewAllPossibleTickets')) {
        $Type = 'ro';
    }
    my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
        UserID => $Param{UserID},
        Type => $Type,
        Result => 'ID',
        Cached => 1,
    );
    my @QueueIDs = @{$Param{ShownQueueIDs}};
    my %Queues = ();
    $Queues{MaxAge} = 0;
    $Queues{TicketsShown} = 0;
    $Queues{TicketsAvail} = 0;
    # prepar "All tickets: ??" in Queue
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
        $Hashes{Queue} = 'CustomQueue';
        $Hashes{MaxAge} = 0;
        $Hashes{Count} = 0;
        push (@{$Queues{Queues}}, \%Hashes);
        return %Queues;
    }
    # CustomQueue add on
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
        $Hashes{MaxAge} = $Self->{TimeObject}->SystemTime() - $Row[2];
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
    # check needed stuff
    foreach (qw(UserID)) {
      if (!exists($Param{$_})) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # db query
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
          # put all tickets to ToDo where last sender type is customer or ! UserID
          if ($RowTmp[3] ne $Param{UserID} || $RowTmp[1] eq 'customer') {
              $Data{'New'}++;
          }
          if ($RowTmp[5] && $RowTmp[7] =~ /^pending/i) {
              $Data{'Pending'}++;
              if ($RowTmp[7] !~ /^pending auto/i && $RowTmp[5] <= $Self->{TimeObject}->SystemTime()) {
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
    # db quote
    foreach (keys %Param) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_});
    }
    # get data (viewable tickets...)
    my @TicketIDsOverTime = ();
    my %TicketIDs = ();
    my $SQL = "SELECT t.id, a.article_sender_type_id, a.incoming_time, q.escalation_time, a.id, t.ticket_priority_id ".
    " FROM ".
    " article a, queue q, ticket t ".
    " WHERE ".
    " t.ticket_answered != 1 ".
    " AND " .
    " q.escalation_time != 0 ".
    " AND " .
    " t.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) " .
    " AND " .
    " t.id = a.ticket_id ".
    " AND " .
    " q.id = t.queue_id ".
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
    $SQL .= " t.ticket_lock_id in ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) ";
    $SQL .= " ORDER BY t.id, t.ticket_priority_id DESC, a.incoming_time";
    my $CustomerSenderID = $Self->ArticleSenderTypeLookup(SenderType => 'customer');
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 1500);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        my $DiffTime = ($Row[2] + ($Row[3] * 60)) - $Self->{TimeObject}->SystemTime();
        my $Prio = $Row[5] - 100;
        if ($DiffTime < 0) {
            if (!$TicketIDs{$Row[0]}) {
                $TicketIDs{$Row[0]} = $Prio.'.'.$Row[2];
            }
            if ($TicketIDs{$Row[0]} && ($Row[1] eq $CustomerSenderID)) {
                $TicketIDs{$Row[0]} = $Prio.'.'.$Row[2];
            }
        }
        else {
            if ($Row[1] eq $CustomerSenderID) {
                delete $TicketIDs{$Row[0]} if ($TicketIDs{$Row[0]});
            }
        }
    }
    # get ticket ids (max shown)
    my $Max = 40;
    my $Count = 0;
    foreach (sort {$TicketIDs{$a} cmp $TicketIDs{$b}} keys %TicketIDs) {
        $Count++;
        push (@TicketIDsOverTime, $_) if ($Count <= $Max);
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
