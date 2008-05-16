# --
# Kernel/System/Ticket/IndexAccelerator/RuntimeDB.pm - realtime database
# queue ticket index module
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: RuntimeDB.pm,v 1.59 2008-05-16 09:49:46 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

package Kernel::System::Ticket::IndexAccelerator::RuntimeDB;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.59 $) [1];

sub TicketAcceleratorUpdate {
    my ( $Self, %Param ) = @_;

    return 1;
}

sub TicketAcceleratorDelete {
    my ( $Self, %Param ) = @_;

    return 1;
}

sub TicketAcceleratorAdd {
    my ( $Self, %Param ) = @_;

    return 1;
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

    # db quote
    for (qw(UserID)) {
        $Param{$_} = $Self->{DBObject}->Quote( $Param{$_}, 'Integer' );
    }

    # get user groups
    my $Type = 'rw';
    if (
        $Self->{ConfigObject}->Get('Ticket::Frontend::AgentTicketQueue')->{ViewAllPossibleTickets}
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
    my @QueueIDs = @{ $Param{ShownQueueIDs} };
    my %Queues   = ();
    $Queues{MaxAge}       = 0;
    $Queues{TicketsShown} = 0;
    $Queues{TicketsAvail} = 0;

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
        . " ticket st, queue sq, personal_queues suq "
        . " WHERE "
        . " st.ticket_state_id IN ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) AND "
        . " st.ticket_lock_id IN ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) AND "
        . " st.queue_id = sq.id AND "
        . " suq.queue_id = st.queue_id AND "
        . " sq.group_id IN ( ${\(join ', ', @GroupIDs)} ) AND "
        .

        # get all custom queues
        " suq.user_id = $Param{UserID} " .

        #/ get all custom queues /
        "";
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
    $SQL = "SELECT st.queue_id, sq.name, min(st.create_time_unix), count(*) "
        . " FROM "
        . " ticket st, queue sq "
        . " WHERE "
        . " st.ticket_state_id IN ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} ) AND "
        . " st.ticket_lock_id IN ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) AND "
        . " st.queue_id = sq.id AND "
        . " sq.group_id IN ( ${\(join ', ', @GroupIDs)} ) "
        . " GROUP BY st.queue_id,sq.name "
        . " ORDER BY sq.name";
    $Self->{DBObject}->Prepare( SQL => $SQL );

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {

        # store the data into a array
        my %Hashes;
        $Hashes{QueueID} = $Row[0];
        $Hashes{Queue}   = $Row[1];
        $Hashes{MaxAge}  = $Self->{TimeObject}->SystemTime() - $Row[2];
        $Hashes{Count}   = $Row[3];
        push( @{ $Queues{Queues} }, \%Hashes );

        # set some things
        if ( $Param{QueueID} eq $Row[0] ) {
            $Queues{TicketsShown} = $Row[3];
            $Queues{TicketsAvail} = $Row[3];
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

    return 1;
}

sub GetLockedCount {
    my ( $Self, %Param ) = @_;

    # check needed stuff
    if ( !exists( $Param{UserID} ) ) {
        $Self->{LogObject}->Log( Priority => 'error', Message => 'Need UserID!' );
        return;
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
            . " FROM "
            . " ticket ti, article ar, ticket_state ts, ticket_state_type tst "
            . " WHERE "
            . " ti.ticket_lock_id NOT IN ( ${\(join ', ', @{$Self->{ViewableLockIDs}})} ) "
            . " AND "
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
                $Data{New}++;
                $Data{NewTicketIDs}->{ $Article->[2] } = 1;
            }
        }
        $TicketIDs{ $Article->[2] } = 1;
    }

    # find all and reminder tickets
    %TicketIDs = ();
    my $SystemTime = $Self->{TimeObject}->SystemTime();
    for my $Article (@ArticleLocked) {
        my $SenderType = $Self->ArticleSenderTypeLookup( SenderTypeID => $Article->[1] );
        my $ArticleType = $Self->ArticleTypeLookup( ArticleTypeID => $Article->[7] );
        if ( !$TicketIDs{ $Article->[2] } ) {
            $Data{All}++;

            if ( $Article->[5] && $Article->[6] =~ /^pending/i ) {
                $Data{Pending}++;
                $Data{PendingTicketIDs}->{ $Article->[2] } = 1;
                if ( $Article->[6] !~ /^pending auto/i && $Article->[5] <= $SystemTime ) {
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
    my @TicketIDs = $Self->{TicketObject}->TicketSearch(
        Result               => 'ARRAY',
        Limit                => 100,
        TicketEscalatationIn => 'now',
        UserID               => $Param{UserID},
    );

    # return overtime tickets
    return @TicketIDs;
}

1;
