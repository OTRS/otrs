# --
# Kernel/System/Ticket/IndexAccelerator/RuntimeDB.pm - realtime database
# queue ticket index module
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: RuntimeDB.pm,v 1.40 2007-05-21 14:14:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::Ticket::IndexAccelerator::RuntimeDB;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.40 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

sub TicketAcceleratorUpdate {
    my $Self = shift;
    my %Param = @_;
    return 1;
}

sub TicketAcceleratorDelete {
    my $Self = shift;
    my %Param = @_;
    return 1;
}

sub TicketAcceleratorAdd {
    my $Self = shift;
    my %Param = @_;
    return 1;
}

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
    foreach (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote($Param{$_}, 'Integer');
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
            " st.ticket_state_id IN ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) ".
            " AND ".
            " st.queue_id IN (";
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
        " st.ticket_state_id IN ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) ".
        " AND ".
        " st.ticket_lock_id IN ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) ".
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
        " st.ticket_state_id IN ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) " .
        " AND " .
        " st.ticket_lock_id IN ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) " .
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

sub TicketAcceleratorRebuild {
    my $Self = shift;
    my %Param = @_;
    return 1;
}

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
            " ti.until_time, ts.name, tst.name " .
            " FROM " .
            " ticket ti, article ar, article_sender_type st, " .
            " ticket_state ts, ticket_state_type tst " .
            " WHERE " .
            " ti.ticket_lock_id not IN ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) " .
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
    my %TicketIDs = ();
    my %Data = ();
    $Data{'Reminder'} = 0;
    $Data{'Pending'} = 0;
    $Data{'All'} = 0;
    $Data{'New'} = 0;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        if (!$Param{"ID$Row[2]"}) {
            $Data{'All'}++;
            # put all tickets to ToDo where last sender type is customer / system or ! UserID
            if ($Row[3] ne $Param{UserID} || $Row[1] eq 'customer' || $Row[1] eq 'system') {
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
            my %Flag = $Self->ArticleFlagGet(
                ArticleID => $Index[$#Index],
                UserID => $Param{UserID},
            );
            if (!$Flag{seen}) {
                $Data{'New'}++;
            }
        }
    }
    return %Data;
}

sub GetOverTimeTickets {
    my $Self = shift;
    my %Param = @_;
    # get data (viewable tickets...)
    my @TicketIDsOverTime = ();
    my %TicketIDs = ();
    # get all open rw ticket
    my @TicketIDs = $Self->TicketSearch(
        Result => 'ARRAY',
        StateType => 'Open',
        SortBy => 'Age',
        OrderBy => 'Up',
        UserID => $Param{UserID} || 1,
    );
    foreach my $TicketID (@TicketIDs) {
        # just use the oldest 30 ticktes
        if ($#TicketIDsOverTime > 30) {
            last;
        }
        my %Ticket = $Self->TicketGet(TicketID => $TicketID);
        # check response time
        if (defined($Ticket{'FirstResponseTime'})) {
            if (0 > $Ticket{'FirstResponseTimeWorkingTime'}) {
                push (@TicketIDsOverTime, $TicketID);
                next;
            }
        }
        # check update time
        if (defined($Ticket{'UpdateTime'})) {
            if (0 >= $Ticket{'UpdateTimeWorkingTime'}) {
                push (@TicketIDsOverTime, $TicketID);
                next;
            }
        }
        # check solution
        if (defined($Ticket{'SolutionTime'})) {
            if (0 >= $Ticket{'SolutionTimeWorkingTime'}) {
                push (@TicketIDsOverTime, $TicketID);
                next;
            }
        }
    }
    # return overtime tickets
    return @TicketIDsOverTime;
}

1;
