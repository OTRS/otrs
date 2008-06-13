# --
# Kernel/System/Ticket/IndexAccelerator/StaticDB.pm - static db queue ticket index module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: StaticDB.pm,v 1.63 2008-06-13 08:13:13 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Ticket::IndexAccelerator::StaticDB;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.63 $) [1];

sub TicketAcceleratorUpdate {
    my ( $Self, %Param ) = @_;

    my @ViewableLocks  = @{ $Self->{ViewableLocks} };
    my @ViewableStates = @{ $Self->{ViewableStates} };

    # check needed stuff
    for (qw(TicketID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check if ticket is shown or not
    my $IndexUpdateNeeded = 0;
    my $IndexSelcected    = 0;
    my %TicketData        = $Self->TicketGet(%Param);
    my %IndexTicketData   = $Self->GetIndexTicket(%Param);
    if ( !%IndexTicketData ) {
        $IndexUpdateNeeded = 1;
    }
    else {

        # check if we need to update
        if ( $TicketData{Lock} ne $IndexTicketData{Lock} ) {
            $IndexUpdateNeeded = 1;
        }
        elsif ( $TicketData{State} ne $IndexTicketData{State} ) {
            $IndexUpdateNeeded = 1;
        }
        elsif ( $TicketData{QueueID} ne $IndexTicketData{QueueID} ) {
            $IndexUpdateNeeded = 1;
        }
    }

    # check if this ticket ist still viewable
    my $ViewableStatsHit = 0;
    for (@ViewableStates) {
        if ( $_ =~ /^$TicketData{State}$/i ) {
            $ViewableStatsHit = 1;
        }
    }
    my $ViewableLocksHit = 0;
    for (@ViewableLocks) {
        if ( $_ =~ /^$TicketData{Lock}$/i ) {
            $ViewableLocksHit = 1;
        }
    }
    if ( $ViewableStatsHit && $ViewableLocksHit ) {
        $IndexSelcected = 1;
    }

    # write index back
    if ($IndexUpdateNeeded) {
        if ($IndexSelcected) {
            if ( $IndexTicketData{TicketID} ) {
                $Self->{DBObject}->Do(
                    SQL => 'UPDATE ticket_index SET'
                        . ' queue_id = ?, queue = ?, group_id = ?, s_lock = ?, s_state = ?'
                        . ' WHERE ticket_id = ?',
                    Bind => [
                        \$TicketData{QueueID}, \$TicketData{Queue}, \$TicketData{GroupID},
                        \$TicketData{Lock},    \$TicketData{State}, \$Param{TicketID},
                    ],
                );
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
    if ( !$ViewableLocksHit ) {

        # check if there is already an lock index entry
        if ( !$Self->GetIndexTicketLock(%Param) ) {

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

sub TicketAcceleratorDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    return $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ticket_index WHERE ticket_id = ?',
        Bind => [ \$Param{TicketID} ],
    );
}

sub TicketAcceleratorAdd {
    my ( $Self, %Param ) = @_;

    my @ViewableLocks  = @{ $Self->{ViewableLocks} };
    my @ViewableStates = @{ $Self->{ViewableStates} };

    # check needed stuff
    for (qw(TicketID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get ticket data
    my %TicketData = $Self->TicketGet(%Param);

    # check if this ticket ist still viewable
    my $ViewableStatsHit = 0;
    for (@ViewableStates) {
        if ( $_ =~ /^$TicketData{State}$/i ) {
            $ViewableStatsHit = 1;
        }
    }
    my $ViewableLocksHit = 0;
    for (@ViewableLocks) {
        if ( $_ =~ /^$TicketData{Lock}$/i ) {
            $ViewableLocksHit = 1;
        }
    }

    # do nothing if stats or lock is not viewable
    if ( !$ViewableStatsHit || !$ViewableLocksHit ) {
        return 1;
    }

    return $Self->{DBObject}->Do(
        SQL => 'INSERT INTO ticket_index'
            . ' (ticket_id, queue_id, queue, group_id, s_lock, s_state, create_time_unix)'
            . ' VALUES (?, ?, ?, ?, ?, ?, ?)',
        Bind => [
            \$Param{TicketID},     \$TicketData{QueueID}, \$TicketData{Queue},
            \$TicketData{GroupID}, \$TicketData{Lock},    \$TicketData{State},
            \$TicketData{CreateTimeUnix},
        ],
    );
}

sub TicketLockAcceleratorDelete {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db query
    return $Self->{DBObject}->Do(
        SQL  => 'DELETE FROM ticket_lock_index WHERE ticket_id = ?',
        Bind => [ \$Param{TicketID} ],
    );
}

sub TicketLockAcceleratorAdd {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID)) {
        if ( !$Param{$_} ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # get ticket data
    my %TicketData = $Self->TicketGet(%Param);
    return $Self->{DBObject}->Do(
        SQL  => 'INSERT INTO ticket_lock_index (ticket_id) VALUES (?)',
        Bind => [ \$Param{TicketID} ],
    );
}

sub TicketAcceleratorIndex {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID QueueID ShownQueueIDs)) {
        if ( !exists( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }
    my %Queues = ();
    $Queues{MaxAge}       = 0;
    $Queues{TicketsShown} = 0;
    $Queues{TicketsAvail} = 0;
    my @QueueIDs = @{ $Param{ShownQueueIDs} };

    # prepar "All tickets: ??" in Queue
    if (@QueueIDs) {
        my $SQL = "SELECT count(*) "
            . " FROM "
            . " ticket st "
            . " WHERE "
            . " st.ticket_state_id IN ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) AND "
            . " st.queue_id IN (";
        for ( 0 .. $#QueueIDs ) {
            if ( $_ > 0 ) {
                $SQL .= ",";
            }
            $SQL .= $Self->{DBObject}->Quote( $QueueIDs[$_] );
        }
        $SQL .= " )";

        $Self->{DBObject}->Prepare( SQL => $SQL );
        while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
            $Queues{AllTickets} = $Row[0];
        }
    }

    # get user groups
    my $Type             = 'rw';
    my $AgentTicketQueue = $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketQueue');
    if (
        $AgentTicketQueue
        && ref $AgentTicketQueue eq 'HASH'
        && $AgentTicketQueue->{ViewAllPossibleTickets}
        )
    {
        $Type = 'ro';
    }
    my @GroupIDs = $Self->{GroupObject}->GroupMemberList(
        UserID => $Param{UserID},
        Type   => $Type,
        Result => 'ID',
        Cached => 1,
    );

    # get index
    $Queues{MaxAge} = 0;

    # check if user is in min. one group! if not, return here
    if ( !@GroupIDs ) {
        my %Hashes;
        $Hashes{QueueID} = 0;
        $Hashes{Queue}   = 'CustomQueue';
        $Hashes{MaxAge}  = 0;
        $Hashes{Count}   = 0;
        push( @{ $Queues{Queues} }, \%Hashes );
        return %Queues;
    }

    # CustomQueue add on
    my $SQL = "SELECT count(*) FROM "
        . " ticket_index ti, personal_queues suq "
        . " WHERE "
        . " suq.queue_id = ti.queue_id AND "
        . " ti.group_id IN ( ${\(join ', ', @GroupIDs)} ) AND "
        . " suq.user_id = $Param{UserID}";
    $Self->{DBObject}->Prepare( SQL => $SQL );
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Hashes;
        $Hashes{QueueID} = 0;
        $Hashes{Queue}   = 'CustomQueue';
        $Hashes{MaxAge}  = 0;
        $Hashes{Count}   = $Row[0];
        push( @{ $Queues{Queues} }, \%Hashes );

        # set some things
        if ( $Param{QueueID} == 0 ) {
            $Queues{TicketsShown} = $Row[0];
            $Queues{TicketsAvail} = $Row[0];
        }
    }

    # prepar the tickets in Queue bar (all data only with my/your Permission)
    $SQL = "SELECT queue_id, queue, min(create_time_unix), count(*) "
        . " FROM "
        . " ticket_index "
        . " WHERE "
        . " group_id IN ( ${\(join ', ', @GroupIDs)} ) "
        . " GROUP BY queue_id, queue "
        . " ORDER BY queue";
    $Self->{DBObject}->Prepare( SQL => $SQL );

    while ( my @RowTmp = $Self->{DBObject}->FetchrowArray() ) {

        # store the data into a array
        my %Hashes;
        $Hashes{QueueID} = $RowTmp[0];
        $Hashes{Queue}   = $RowTmp[1];
        $Hashes{MaxAge}  = $Self->{TimeObject}->SystemTime() - $RowTmp[2];
        $Hashes{Count}   = $RowTmp[3];
        push( @{ $Queues{Queues} }, \%Hashes );

        # set some things
        if ( $Param{QueueID} == $RowTmp[0] ) {
            $Queues{TicketsShown} = $RowTmp[3];
            $Queues{TicketsAvail} = $RowTmp[3];
        }

        # get the oldes queue id
        if ( $Hashes{MaxAge} > $Queues{MaxAge} ) {
            $Queues{MaxAge}          = $Hashes{MaxAge};
            $Queues{QueueIDOfMaxAge} = $Hashes{QueueID};
        }
    }

    return %Queues;
}

sub TicketAcceleratorRebuild {
    my ( $Self, %Param ) = @_;

    # get all viewable tickets
    my $SQL = "SELECT st.id, st.queue_id, sq.name, sq.group_id, slt.name, "
        . " tsd.name, st.create_time_unix "
        . " FROM "
        . " ticket st, queue sq, ticket_state tsd, "
        . " ticket_lock_type slt "
        . " WHERE "
        . " st.ticket_state_id = tsd.id AND "
        . " st.queue_id = sq.id AND "
        . " st.ticket_lock_id = slt.id AND "
        . " st.ticket_state_id IN ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) AND "
        . " st.ticket_lock_id IN ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} )";

    $Self->{DBObject}->Prepare( SQL => $SQL );
    my @RowBuffer = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        my %Data = ();
        $Data{TicketID}       = $Row[0];
        $Data{QueueID}        = $Row[1];
        $Data{Queue}          = $Row[2];
        $Data{GroupID}        = $Row[3];
        $Data{Lock}           = $Row[4];
        $Data{State}          = $Row[5];
        $Data{CreateTimeUnix} = $Row[6];
        push( @RowBuffer, \%Data );
    }

    # write index
    $Self->{DBObject}->Do( SQL => 'DELETE FROM ticket_index' );
    for (@RowBuffer) {
        my %Data = %{$_};
        for ( keys %Data ) {
            $Data{$_} = $Self->{DBObject}->Quote( $Data{$_} );
        }
        $Self->{DBObject}->Do(
            SQL => 'INSERT INTO ticket_index'
                . ' (ticket_id, queue_id, queue, group_id, s_lock, s_state, create_time_unix)'
                . ' VALUES (?, ?, ?, ?, ?, ?, ?)',
            Bind => [
                \$Data{TicketID}, \$Data{QueueID}, \$Data{Queue}, \$Data{GroupID},
                \$Data{Lock}, \$Data{State}, \$Data{CreateTimeUnix},
            ],
        );
    }

    # write lock index
    $Self->{DBObject}->Prepare(
        SQL => "SELECT ti.id, ti.user_id FROM ticket ti WHERE "
            . " ti.ticket_lock_id not IN ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) ",
    );
    my @LockRowBuffer = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push( @LockRowBuffer, $Row[0] );
    }

    # add lock index entry
    $Self->{DBObject}->Do( SQL => 'DELETE FROM ticket_lock_index' );
    for (@LockRowBuffer) {
        $Self->TicketLockAcceleratorAdd( TicketID => $_ );
    }
    return 1;
}

sub GetIndexTicket {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID)) {
        if ( !exists( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # db quote
    for (qw(TicketID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # sql query
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT ticket_id, queue_id, queue, group_id, s_lock, s_state, create_time_unix'
            . ' FROM ticket_index WHERE ticket_id = ?',
        Bind => [ \$Param{TicketID} ]
    );
    my %Data = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Data{TicketID}       = $Row[0];
        $Data{QueueID}        = $Row[1];
        $Data{Queue}          = $Row[2];
        $Data{GroupID}        = $Row[3];
        $Data{Lock}           = $Row[4];
        $Data{State}          = $Row[5];
        $Data{CreateTimeUnix} = $Row[6];
    }
    return %Data;
}

sub GetIndexTicketLock {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(TicketID)) {
        if ( !exists( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # sql query
    $Self->{DBObject}->Prepare(
        SQL  => 'SELECT ticket_id FROM ticket_lock_index WHERE ticket_id = ?',
        Bind => [ \$Param{TicketID} ],
    );
    my $Hit = 0;
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Hit = 1;
    }
    return $Hit;
}

sub GetLockedCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    for (qw(UserID)) {
        if ( !exists( $Param{$_} ) ) {
            $Self->{LogObject}->Log( Priority => 'error', Message => "Need $_!" );
            return;
        }
    }

    # check cache
    if ( $Self->{ 'Cache::GetLockCount' . $Param{UserID} } ) {
        return %{ $Self->{ 'Cache::GetLockCount' . $Param{UserID} } };
    }

    # db query
    $Self->{DBObject}->Prepare(
        SQL => "SELECT ar.id, ar.article_sender_type_id, ti.id, "
            . " ar.create_by, ti.create_time_unix, ti.until_time, "
            . " tst.name, ar.article_type_id "
            . " FROM ticket ti, article ar, ticket_state ts, ticket_state_type tst "
            . " WHERE "
            . " ti.ticket_lock_id NOT IN ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) AND "
            . " ti.user_id = ? AND "
            . " ar.ticket_id = ti.id AND "
            . " ts.id = ti.ticket_state_id AND "
            . " ts.type_id = tst.id "
            . " ORDER BY ar.create_time DESC",
        Bind => [ \$Param{UserID} ],
    );
    my @ArticleLocked = ();
    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        push( @ArticleLocked, \@Row );
    }
    my %TicketIDs = ();
    my %Data      = (
        Reminder => 0,
        Pending  => 0,
        All      => 0,
        New      => 0,
    );

    # find only new messages
    # put all tickets to ToDo where last sender type is customer / system or ! UserID
    # and article type is not a email-notification
    for my $Article (@ArticleLocked) {
        my $SenderType = $Self->ArticleSenderTypeLookup( SenderTypeID => $Article->[1] );
        my $ArticleType = $Self->ArticleTypeLookup( ArticleTypeID => $Article->[7] );
        if ( !$TicketIDs{ $Article->[2] } ) {
            if ( $SenderType eq 'system' && $ArticleType =~ /^email-extern/i ) {
                next;
            }
            if (
                (
                    $Article->[3] ne $Param{UserID}
                    || $SenderType eq 'customer'
                )
                && $ArticleType !~ /^email-notification/i
                )
            {
                $Data{'New'}++;
                $Data{'NewTicketIDs'}->{ $Article->[2] } = 1;
            }

        }
        $TicketIDs{ $Article->[2] } = 1;
    }

    # find all and reminder tickets
    %TicketIDs = ();
    for my $Article (@ArticleLocked) {
        my $SenderType = $Self->ArticleSenderTypeLookup( SenderTypeID => $Article->[1] );
        my $ArticleType = $Self->ArticleTypeLookup( ArticleTypeID => $Article->[7] );
        if ( !$TicketIDs{ $Article->[2] } ) {
            $Data{All}++;

            if ( $Article->[5] && $Article->[6] =~ /^pending/i ) {
                $Data{Pending}++;
                $Data{PendingTicketIDs}->{ $Article->[2] } = 1;
                if (
                    $Article->[6] !~ /^pending auto/i
                    && $Article->[5] <= $Self->{TimeObject}->SystemTime()
                    )
                {
                    $Data{ReminderTicketIDs}->{ $Article->[2] } = 1;
                    $Data{Reminder}++;
                }
            }
        }
        $Data{MaxAge} = $Article->[4];
        $TicketIDs{ $Article->[2] } = 1;
    }

    # show just unseen tickets as new
    if ( $Self->{ConfigObject}->Get('Ticket::NewMessageMode') eq 'ArticleSeen' ) {

        # reset new message count
        $Data{New}          = 0;
        $Data{NewTicketIDs} = undef;
        for my $TicketID ( keys %TicketIDs ) {
            my @Index = $Self->ArticleIndex( TicketID => $TicketID );
            my %Flag = $Self->ArticleFlagGet(
                ArticleID => $Index[-1],
                UserID    => $Param{UserID},
            );
            if ( !$Flag{seen} ) {
                $Data{NewTicketIDs}->{$TicketID} = 1;
                $Data{New}++;
            }
        }
    }

    # cache result
    $Self->{ 'Cache::GetLockCount' . $Param{UserID} } = \%Data;

    return %Data;
}

sub GetOverTimeTickets {
    my ( $Self, %Param ) = @_;

    # get all overtime tickets
    my @TicketIDs = $Self->TicketSearch(
        Result                           => 'ARRAY',
        Limit                            => 100,
        TicketEscalationTimeOlderMinutes => -60,
        UserID                           => $Param{UserID} || 1,
    );

    # return overtime tickets
    return @TicketIDs;
}

1;
