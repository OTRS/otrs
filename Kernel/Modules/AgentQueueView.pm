# --
# AgentQueueView.pm - the queue view of all tickets
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentQueueView.pm,v 1.12 2002-06-13 22:07:41 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentQueueView;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12 $';
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

    # starting with page ...
    my $Refresh = '';
    if ($Self->{UserRefreshTime}) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->Header(
        Title => 'QueueView',
        Refresh => $Refresh,
    );

    # get user lock data
    my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $Self->{UserID});

    # build NavigationBar 
    $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);

    # --
    # check old tickets, show it and return if needed
    # --
    if (my @ViewableTickets = $Self->CheckOldTickets()) {
        # --
        # show ticket's
        # --
        $Output .= $Self->{LayoutObject}->TicketEscalation(
            Message => 'Please answer this ticket(s) to get back to the normal queue view!',
        );
        foreach my $DataTmp (@ViewableTickets) {
          my %Data = %$DataTmp;
          $Output .= $Self->ShowTicket(
            %Data,
            QueueID => $QueueID,
          );
        }
        # get page footer
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }

    # --
    # build queue view ...
    # --
    my @ViewableQueueIDs;
    if ($QueueID == 0) {
        @ViewableQueueIDs = $Self->{QueueObject}->GetAllCustomQueues(
            UserID => $Self->{UserID}
        ) || 0;
    }
    else {
        @ViewableQueueIDs = ($QueueID);
    }
    $Output .= $Self->BuildQueueView(
        QueueIDs => \@ViewableQueueIDs,
        QueueID => $QueueID
    );

    # to get the output faster!
    print $Output; $Output = '';

    # --
    # get data (viewable tickets...)
    # --
    my @ViewableTickets = ();
    my @ViewableLocks = @{$Self->{ViewableLocks}};
    my @ViewableStats = @{$Self->{ViewableStats}};
    my $SQL = "SELECT st.id, st.queue_id FROM " .
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
        my $Data = {
            TicketID => $RowTmp[0],
            TicketQueueID => $RowTmp[1],
        };
        push (@ViewableTickets, $Data);
    }

    # --
    # show ticket's
    # --
    foreach my $DataTmp (@ViewableTickets) {
      my %Data = %$DataTmp;
      print $Self->ShowTicket(
        %Data,
        QueueID => $QueueID,
      );
    }

    # get page footer
    $Output .= $Self->{LayoutObject}->Footer();

    # return page
    return $Output;
}
# --
# ShowTicket
# --
sub ShowTicket {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID} || return;
    my $QueueID = $Param{QueueID} || '';
    my $TicketQueueID = $Param{TicketQueueID} || '';
    my $Output = '';

    my %MoveQueues = ();
    if ($Self->{ConfigObject}->Get('MoveInToAllQueues')) {
        %MoveQueues = $Self->{QueueObject}->GetAllQueues();
    }
    else {
        %MoveQueues = $Self->{QueueObject}->GetAllQueues(UserID => $Self->{UserID});
    }

    # fetch all std. responses ...
    my %StdResponses = $Self->{QueueObject}->GetStdResponses(QueueID => $TicketQueueID);

    # --
    # get atrticles
    # --
    my @ShownViewableTicket = ();
    my @ViewableSenderTypes = @{$Self->{ViewableSenderTypes}};
    my $SQL = "SELECT sa.ticket_id, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, " .
        " sa.a_body, st.create_time_unix, sa.a_freekey1, sa.a_freetext1, sa.a_freekey2, " .
        " sa.a_freetext2, sa.a_freekey3, sa.a_freetext3, st.freekey1, st.freekey2, " .
        " st.freetext1, st.freetext2, st.customer_id, sq.name as queue, sa.id as article_id, " .
        " st.id, st.tn, sp.name, sd.name as state, st.queue_id, st.create_time, ".
        " sa.incoming_time, sq.escalation_time, st.ticket_answered " .
        " FROM " .
        " article sa, ticket st, ticket_priority sp, ticket_state sd, article_sender_type sdt, queue sq " .
        " WHERE " .
        " sa.ticket_id = $TicketID " .
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
        my $TicketOverTime = ''; 
        if ($$Data{escalation_time} && !$$Data{ticket_answered}) {
            $TicketOverTime = (time() - ($$Data{incoming_time} + ($$Data{escalation_time}*60))); 
        }
        $Output .= $Self->{LayoutObject}->TicketView(
            TicketNumber => $$Data{tn},
            Priority => $$Data{name},
            State => $$Data{state},
            TicketID => $$Data{id},
            ArticleID => $$Data{article_id},
            From => $$Data{a_from},
            To => $$Data{a_to},
            Cc => $$Data{a_cc},
            Subject => $$Data{a_subject},
            Text => $$Data{a_body},
            Age => $Age,
            TicketOverTime => $TicketOverTime,
            Answered => $$Data{ticket_answered},
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
        push (@ShownViewableTicket, $$Data{id});
    }
    # if there is no customer article avalible! Error!
    my $Hit = 0;
    foreach (@ShownViewableTicket) {
        if ($_ == $TicketID) {
            $Hit = 1;
        }
    }
    if ($Hit == 0) {
        $Output .= $Self->{LayoutObject}->Error(
            Message => "No customer article found!! (TicketID=$TicketID)",
            Comment => 'Please contact your admin',
        );
        $Self->{LogObject}->Log(
            Priority => 'error',
            Message => "No customer article found!! (TicketID=$TicketID)",
            Comment => 'Please contact your admin',
        );
    }
    # return page
    return $Output;
}
# --
sub BuildQueueView {
    my $Self = shift;
    my %Param = @_;
    my $QueueID = $Param{QueueID};
    my @QueueIDs = @{$Param{QueueIDs}};
    my $Output = '';
    my @Queues;
    my $TicketsShown = 0;
    my $AllTickets = 0;
    my $TicketsAvail = 0;
    my @ViewableLocks = @{$Self->{ViewableLocks}};
    my @ViewableStats = @{$Self->{ViewableStats}};

    # --
    # prepar "All tickets: ??" in Queue
    # --
    if (@QueueIDs) {
        my $SQL = "SELECT count(*) as count " .
          " FROM " .
          " ticket st, ticket_state tsd " .
          " WHERE " .
          " tsd.name in ( ${\(join ', ', @ViewableStats)} ) " .
          " and " .
          " st.queue_id in ( ${\(join ', ', @QueueIDs)} ) " .
          " AND " .
          " tsd.id = st.ticket_state_id ";

        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
            $AllTickets = $RowTmp[0];
        }
    }
 
    # --
    # CustomQueue add on
    # --
    my $SQL = "SELECT count(*) FROM " .
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
    " suq.user_id = $Self->{UserID} " .
    " AND " .
    " suq.queue_id = sq.id " .
    " AND " .
    " sug.user_id = $Self->{UserID} " .
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

    # --
    # the "oldest" valiables
    # --
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
    " sug.user_id = $Self->{UserID} " .
    " GROUP BY st.queue_id,sq.name " .
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

    # --
    # check shown tickets
    # --
    if ($Self->{Limit} < $TicketsShown) {
        $TicketsShown = $Self->{Limit};
    }

    # --
    # build output ...
    # --
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
sub CheckOldTickets {
    my $Self = shift;
    my %Param = @_;

    # --
    # get data (viewable tickets...)
    # --
    my @TicketIDsOverTime = ();
    my @ViewableLocks = @{$Self->{ViewableLocks}};
    my @ViewableStats = @{$Self->{ViewableStats}};

    my $SQL = "SELECT t.queue_id, a.ticket_id, a.id, ast.name, a.incoming_time, ". 
    " q.name, q.escalation_time ".
    " FROM ".
    " article a, article_sender_type ast, queue q, ticket t, ".
    " ticket_state tsd, ticket_lock_type slt, group_user as ug ".
    " WHERE ".
    " tsd.id = t.ticket_state_id " .
    " AND " .
    " slt.id = t.ticket_lock_id " .
    " AND " .
    " ast.id = a.article_sender_type_id ".
    " AND ".
    " t.id = a.ticket_id ".
    " AND ".
    " q.id = t.queue_id ".
    " AND ".
    " q.group_id = ug.group_id ".
    " AND ".
    " ug.user_id = $Self->{UserID} " .
    " AND ".
    " tsd.name in ( ${\(join ', ', @ViewableStats)} ) " .
    " AND " .
    " slt.name in ( ${\(join ', ', @ViewableLocks)} ) " .
    " AND " .
    " ast.name = 'customer' ".
    " AND " .
    " t.ticket_answered != 1 ".
#    " GROUP BY t.id ".
    " ORDER BY t.ticket_priority_id, a.incoming_time ASC";

    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
      if ($RowTmp[6]) {
         my $OverTime = (time() - ($RowTmp[4] + ($RowTmp[6]*60))); 
         my $Data = {
              TicketID => $RowTmp[1],
              TicketQueueID => $RowTmp[0],
              TicketOverTime => $OverTime,
              ArticleSenderType => $RowTmp[3],
              ArticleID => $RowTmp[2],
          };
          if ($OverTime >= 0) {
              push (@TicketIDsOverTime, $Data);
          }
      }
    }
    # --
    # return overtime tickets
    # --
    return @TicketIDsOverTime;
}
# --

1;
