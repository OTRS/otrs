# --
# AgentQueueView.pm - the queue view of all tickets
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentQueueView.pm,v 1.5 2002-04-13 11:16:03 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentQueueView;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (
      'ParamObject', 
      'DBObject', 
      'QueueObject', 
      'LayoutObject', 
      'ConfigObject', 
      'LogObject',
      'UserObject',
    ) {
        die "Got no $_" if (!$Self->{$_});
    }

    # --
    # get config data
    # --

    # default viewable tickets a page
    $Self->{ViewableTickets} = $Self->{ConfigObject}->Get('ViewableTickets');

    # default reload time
    $Self->{Refresh} = $Self->{ConfigObject}->Get('Refresh');
 
    # viewable tickets a page
    $Self->{Limit} = $Self->{ParamObject}->GetParam(Param => 'Limit')
        || $Self->{ViewableTickets};

    # sure is sure!
    $Self->{MaxLimit} = $Self->{ConfigObject}->Get('MaxLimit') || 300;
    if ($Self->{Limit} > $Self->{MaxLimit}) {
        $Self->{Limit} = $Self->{MaxLimit};
    }

    # --
    # all static variables
    # --
    $Self->{ViewableLocks} = $Self->{ConfigObject}->Get('ViewableLocks') 
           || die 'No Config entry "ViewableLocks"!';

    $Self->{ViewableStats} = $Self->{ConfigObject}->Get('ViewableStats') 
           || die 'No Config entry "ViewableStats"!';

    $Self->{ViewableSenderTypes} = $Self->{ConfigObject}->Get('ViewableSenderTypes') 
           || die 'No Config entry "ViewableSenderTypes"!';;

    $Self->{CustomQueue} = $Self->{ConfigObject}->Get('CustomQueue') || '???';

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $QueueID = $Self->{QueueID};
    my $UserID = $Self->{UserID};

    # fetch all std. responses ...
    my %StdResponses = $Self->{QueueObject}->GetStdResponses(QueueID => $QueueID);

    # fetch all queues ...
    my %MoveQueues = $Self->{QueueObject}->GetAllQueues();

    # starting with page ...
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'QueueView',
        Refresh => $Self->{Refresh},
    );
    my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
    # build NavigationBar 
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

    my @ViewableQueueIDs;
    if ($QueueID == 0) {
        @ViewableQueueIDs = $Self->{QueueObject}->GetAllCustomQueues(
            UserID => $UserID
        );
        %StdResponses = $Self->{QueueObject}->GetStdResponses(
            QueueID => "${\(join ', ', @ViewableQueueIDs)}"
        );
    }
    else {
        @ViewableQueueIDs = ($QueueID);
    }


    # build queue view ...
    $Output .= $Self->BuildQueueView(
        QueueIDs => \@ViewableQueueIDs,
        QueueID => $QueueID
    );

    # to get the output faster!
    print $Output; $Output = '';

    # --
    # get data (viewable tickets...)
    # --
    my $ViewableStatsTmp = $Self->{ViewableStats};
    my $ViewableLocksTmp = $Self->{ViewableLocks};
    my @ViewableTickets;
    my @ViewableLocks = @$ViewableLocksTmp;
    my @ViewableStats = @$ViewableStatsTmp;
    my $SQL = "SELECT st.id, st.tn FROM " .
    " ticket st, ticket_state tsd, ticket_lock_type slt " .
    " WHERE " .
    " tsd.name in ( ${\(join ', ', @ViewableStats)} ) " .
    " AND " .
    " st.queue_id in ( ${\(join ', ', @ViewableQueueIDs)} ) " .
    " AND ".
    " slt.name in ( ${\(join ', ', @ViewableLocks)} ) " .
    " AND " .
    " tsd.id = st.ticket_state_id " .
    " AND " .
    " slt.id = st.ticket_lock_id " .
    " ORDER BY st.ticket_priority_id DESC, st.create_time_unix ASC ";

    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Self->{Limit});
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        push (@ViewableTickets, $RowTmp[0]);
    }

    # --
    # get atrticles
    # --
    my @ShownViewableTickets;
    my $ViewableSenderTypesTmp = $Self->{ViewableSenderTypes};
    my @ViewableSenderTypes = @$ViewableSenderTypesTmp;
    foreach (@ViewableTickets) {
        my $SQL = "SELECT sa.ticket_id, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, " .
            " sa.a_body, st.create_time_unix, sa.a_freekey1, sa.a_freetext1, sa.a_freekey2, " .
            " sa.a_freetext2, sa.a_freekey3, sa.a_freetext3, st.freekey1, st.freekey2, " .
            " st.freetext1, st.freetext2, st.customer_id, sq.name as queue, " .
            " st.id, st.tn, sp.name, sd.name as state, st.queue_id, st.create_time " .
            " FROM " .
            " article sa, ticket st, ticket_priority sp, ticket_state sd, article_sender_type sdt, queue sq " .
            " WHERE " .
            " sa.ticket_id = $_ " .
            " AND " .
            " sa.ticket_id = st.id " .
            " AND " .
            " sa.article_sender_type_id = sdt.id " .
            " AND " .
            " sdt.name in ( ${\(join ', ', @ViewableSenderTypes)} ) " .
            " AND " .
            " sq.id = st.queue_id" .
            " AND " .
            " sp.id = st.ticket_priority_id " .
            " AND " .
            " st.ticket_state_id = sd.id " .
            " ORDER BY sa.create_time DESC ";
        $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 1);
        while (my $Data = $Self->{DBObject}->FetchrowHashref() ) {
            my $Age = time() - $$Data{create_time_unix};
            $Output .= $Self->{LayoutObject}->TicketView(
                TicketNumber => $$Data{tn},
                Priority => $$Data{name},
                State => $$Data{state},
                TicketID => $$Data{id},
                From => $$Data{a_from},
                To => $$Data{a_to},
                Cc => $$Data{a_cc},
                Subject => $$Data{a_subject},
                Text => $$Data{a_body},
                Age => $Age,
                Created => $$Data{create_time},
                StdResponses => \%StdResponses,
        #       QueueID => $$Data{queue_id},
                QueueID => $QueueID,
                Queue => $$Data{queue},
                MoveQueues => \%MoveQueues,
                CustomerID => $$Data{customer_id},
                FreeKey1 => $$Data{a_freekey1},
                FreeValue1 => $$Data{a_freetext1},
                FreeKey2 => $$Data{a_freekey2},
                FreeValue2 => $$Data{a_freetext2},
                FreeKey3 => $$Data{a_freekey3},
                FreeValue3 => $$Data{a_freetext3},
                TicketFreeKey1 => $$Data{freekey1},
                TicketFreeValue1 => $$Data{freetext1},
                TicketFreeKey2 => $$Data{freekey2},
                TicketFreeValue2 => $$Data{freetext2},
    
             );
             push (@ShownViewableTickets, $$Data{id});
#print STDERR "-- $$Data{id} --\n";
        }
    }
    # if there is no customer article avalible!
#    foreach my $TicketID (@ViewableTickets){
#print STDERR "-- $_ - $TicketID --22\n";
#        my $Hit = 0;
#        foreach (@ShownViewableTickets) {
#print STDERR "-- $_ - $TicketID --33\n";
#            if ($_ == $TicketID) {
#                $Hit = 1;
#            }
#        }
#        if ($Hit == 0) {
#        $Output .= $Self->{LayoutObject}->Error(
#                Message => "No customer article found!! (TicketID=$TicketID)",
#                Comment => 'Please contact your admin');
##        $Self->{LogObject}->ErrorLog(
##                MSG => "No customer article found!! (TicketID=$TicketID)",
##                REASON => 'Please contact your admin');
##
#        }
#    }
#

    # get page footer
    $Output .= $Self->{LayoutObject}->Footer();

    # return page
    return $Output;
}
# --
sub BuildQueueView {
    my $Self = shift;
    my %Param = @_;
    my $QueueID = $Param{QueueID};
    my $QueueIDs = $Param{QueueIDs};
    my @QueueISsTmp = @$QueueIDs;
    my $UserID = $Self->{UserID};
    my $Output = '';
    my @Queues;
    my $TicketsShown = 0;
    my $AllTickets = 0;
    my $TicketsAvail = 0;
    my $ViewableStatsTmp = $Self->{ViewableStats};
    my $ViewableLocksTmp = $Self->{ViewableLocks};
    my @ViewableLocks = @$ViewableLocksTmp;
    my @ViewableStats = @$ViewableStatsTmp;

    # prepar "All tickets: ??" in Queue
    my $SQL = "SELECT count(*) as count " .
    " FROM " .
    " ticket st, ticket_state tsd " .
    " WHERE " .
    " tsd.name in ( ${\(join ', ', @ViewableStats)} ) " .
    " and " .
    " st.queue_id in ( ${\(join ', ', @QueueISsTmp)} ) " .
    " AND " .
    " tsd.id = st.ticket_state_id ";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $AllTickets = $RowTmp[0];
    }

    # CustomQueue add on
    $SQL = "SELECT count(*) FROM " .
    " ticket as st, queue as sq, group_user as sug, personal_queues as suq, " .
    " ticket_state tsd, ticket_lock_type slt " .
    " WHERE " .
    " st.ticket_state_id = tsd.id " .
    " AND " .
    " st.queue_id = sq.id " .
    " AND " .
    " st.ticket_lock_id = slt.id " .
    " AND " .
    " st.group_id = sug.group_id" .
    " AND " .
    # get all custom queues
    " suq.user_id = $UserID " .
    " AND " .
    " suq.queue_id = sq.id " .
    " AND " .
    " sug.user_id = $UserID " .
    #/ get all custom queues /
    " AND " .
    " tsd.name in ( ${\(join ', ', @ViewableStats)} ) " .
    " AND " .
    " slt.name in ( ${\(join ', ', @ViewableLocks)} ) ";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        my %Hashes;
        $Hashes{QueueID} = 0;
        $Hashes{Queue} = $Self->{CustomQueue};
        $Hashes{MaxAge} = $RowTmp[2] || 0;
        $Hashes{Count} = $RowTmp[0];
        push (@Queues, \%Hashes);
        # set some things
        if ($QueueID == 0) {
            $TicketsShown = $RowTmp[0];
            $TicketsAvail = $RowTmp[0];
        }
    }

    # the "oldest" valiables
    my $QueueIDOfMaxAge = '';
    my $MaxAge = 0;

    # prepar the tickets in Queue bar (all data only with my/your Permission)
    $SQL = "SELECT st.queue_id, sq.name, min(st.create_time_unix), count(*) as count ".
    " FROM " .
    " ticket as st, queue as sq, group_user as sug, ticket_state tsd, " .
    " ticket_lock_type slt " .
    " WHERE " .
    " st.ticket_state_id = tsd.id " .
    " AND " .
    " st.queue_id = sq.id " .
    " AND " .
    " st.ticket_lock_id = slt.id " .
    " AND " .
    " sq.group_id = sug.group_id" .
    " AND " .
    " tsd.name in ( ${\(join ', ', @ViewableStats)} ) " .
    " AND " .
    " slt.name in ( ${\(join ', ', @ViewableLocks)} ) " .
    " AND " .
    " sug.user_id = $UserID " .
    " GROUP BY st.queue_id " .
    " ORDER BY sq.name";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        # store the data into a array
        my %Hashes;
        $Hashes{QueueID} = $RowTmp[0];
        $Hashes{Queue} = $RowTmp[1];
        $Hashes{MaxAge} = time() - $RowTmp[2];
        $Hashes{Count} = $RowTmp[3];
        push (@Queues, \%Hashes);
        # set some things
        if ($QueueID eq $RowTmp[0]) {
            $TicketsShown = $RowTmp[3];
            $TicketsAvail = $RowTmp[3];
        }
        # get the oldes queue id
        if ($Hashes{MaxAge} > $MaxAge) {
            $MaxAge = $Hashes{MaxAge};
            $QueueIDOfMaxAge = $Hashes{QueueID};
        }
    }

    # check shown tickets
    if ($Self->{Limit} < $TicketsShown) {
        $TicketsShown = $Self->{Limit};
    }

    # build output ...
    $Output .= $Self->{LayoutObject}->QueueView(
        Queues => \@Queues,
        TicketsAvail => $TicketsAvail,
        QueueID => $QueueID,
        TicketsShown => $TicketsShown,
        AllTickets => $AllTickets,
        QueueIDOfMaxAge => $QueueIDOfMaxAge,
    );

    return $Output;
}
# --

1;
