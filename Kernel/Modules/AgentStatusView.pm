# --   
# Kernel/Modules/AgentStatusView.pm - status for all open tickets
# Copyright (C) 2002 Phil Davis <phil.davis at itaction.co.uk>
# Copyright (C) 2002 Martin Edenhofer <martin+code at otrs.org>
# --   
# $Id: AgentStatusView.pm,v 1.1 2002-10-15 09:36:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentStatusView;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
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
   # all static variables
   # --
   $Self->{ViewableStats} = $Self->{ConfigObject}->Get('ViewableStats')
          || die 'No Config entry "ViewableStats"!';

   $Self->{ViewableSenderTypes} = $Self->{ConfigObject}->Get('ViewableSenderTypes')
          || die 'No Config entry "ViewableSenderTypes"!';
   # --
   # get params 
   # --
   $Self->{SortBy} = $Self->{ParamObject}->GetParam(Param => 'SortBy') || 'Age';
   $Self->{Order} = $Self->{ParamObject}->GetParam(Param => 'Order') || 'Up';
   # viewable tickets a page
   $Self->{Limit} = $Self->{ParamObject}->GetParam(Param => 'Limit')
       || 400; 

   return $Self;
}
# --
sub Run {
   my $Self = shift;
   my %Param = @_;
   # --
   # store last screen
   # --
   if (!$Self->{SessionObject}->UpdateSessionID(
       SessionID => $Self->{SessionID},
       Key => 'LastScreen',
       Value => $Self->{RequestedURL},
   )) {
       my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
       $Output .= $Self->{LayoutObject}->Error();
       $Output .= $Self->{LayoutObject}->Footer();
       return $Output;
   }   
   # --
   # starting with page ...
   # --
   my $Refresh = '';
   if ($Self->{UserRefreshTime}) {
       $Refresh = 60 * $Self->{UserRefreshTime};
   }
   my $Output = $Self->{LayoutObject}->Header(
       Title => 'QueueView',
       Refresh => $Refresh,
   );
   # get user lock data
   my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
   # build NavigationBar
   $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
   # to get the output faster!
   print $Output; $Output = '';
   # --
   # get data (viewable tickets...)
   # --
   my @ViewableTickets = ();
   my @ViewableStats = @{$Self->{ViewableStats}};
   my $SQL = "SELECT st.id, st.queue_id FROM " .
       " ticket st, ticket_state tsd, group_user ug, queue q, " . 
         $Self->{ConfigObject}->Get('DatabaseUserTable'). " u ".
       " WHERE " .
       " tsd.id = st.ticket_state_id " .
       " AND " .
       " ug.user_id = $Self->{UserID} " .
       " AND ".
       " q.group_id = ug.group_id ".
       " AND ".
       " ug.user_id = u.". $Self->{ConfigObject}->Get('DatabaseUserTableUserID') .
       " AND ".
       " q.id = st.queue_id ".
       " AND ".
       " tsd.name in ( ${\(join ', ', @ViewableStats)} ) " .
       " ORDER BY ";

    if ($Self->{SortBy} eq 'Owner') {
        $SQL .= "u.".$Self->{ConfigObject}->Get('DatabaseUserTableUser');
    }
    elsif ($Self->{SortBy} eq 'CustomerID') {
        $SQL .= "st.customer_id";
    }
    elsif ($Self->{SortBy} eq 'State') {
        $SQL .= "tsd.name";
    }
    elsif ($Self->{SortBy} eq 'Ticket') {
        $SQL .= "st.tn";
    }
    elsif ($Self->{SortBy} eq 'Queue') {
        $SQL .= "q.name";
    }
    else {
        $SQL .= "st.create_time_unix";
    }

    if ($Self->{Order} eq 'Down') {
        $SQL .= " DESC";
    }
    else {
        $SQL .= " ASC";
    }

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
    my $OutputTable = "";
    foreach my $DataTmp (@ViewableTickets) {
        $OutputTable .= ShowTicketStatus(
           $Self,
           %{$DataTmp}, 
        );
    }
    $Output .= $Self->{LayoutObject}->AgentStatusView(
        StatusTable => $OutputTable, 
        Limit => $Self->{Limit},
        SortBy => $Self->{SortBy},
        Order => $Self->{Order},
    );
    # get page footer
    $Output .= $Self->{LayoutObject}->Footer();
    
    # return page
    return $Output;
}
# --
# ShowTicket
# --
sub ShowTicketStatus {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID} || return;
    my $Output = '';
    # --   
    # get last customer articles
    # --
    my @ShownViewableTicket = ();
    my $SQL = "SELECT sa.ticket_id, sa.a_subject, " .
       " st.create_time_unix, st.user_id, " .
       " st.customer_id, sq.name as queue, sa.id as article_id, " .
       " st.id, st.tn, sp.name, sd.name as state, st.queue_id, " .
       " st.create_time, ".
       " su.$Self->{ConfigObject}->{DatabaseUserTableUser} " .
       " FROM " .
       " article sa, ticket st, ticket_priority sp, ticket_state sd, " .
       " article_sender_type sdt, queue sq, " .
       " $Self->{ConfigObject}->{DatabaseUserTable} su " .
       " WHERE " .
       " sa.ticket_id = st.id " .
       " AND " .
       " sa.article_sender_type_id = sdt.id " .
       " AND " .
       " sq.id = st.queue_id" .
       " AND " .
       " sp.id = st.ticket_priority_id " .
       " AND " .
       " st.ticket_state_id = sd.id " .
       " AND " .
       " sa.ticket_id = $TicketID " .
       " AND " .
       " su.$Self->{ConfigObject}->{DatabaseUserTableUserID} = st.user_id " .
       " AND " .
       " sdt.name in ( ${\(join ', ', @{$Self->{ViewableSenderTypes}})}) " .
       " ORDER BY sa.create_time DESC ";
    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 1);
    while (my $Data = $Self->{DBObject}->FetchrowHashref() ) {
        my $Age = time() - $$Data{create_time_unix};
        # Condense down the subject
        my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
        my $Subject = $$Data{a_subject};
        $Subject =~ s/^RE:*//i; 
        $Subject =~ s/\[${TicketHook}:\s*\d+\]//;

        $Output .= $Self->{LayoutObject}->AgentStatusViewTable(
           TicketNumber => $$Data{tn}, 
           Priority => $$Data{name},
           State => $$Data{state},   
           TicketID => $$Data{id},
           ArticleID => $$Data{article_id},
           Owner => $$Data{login},
           Subject => $Subject,
           Age => $Age,
           Created => $$Data{create_time},
           Queue => $$Data{queue},
           CustomerID => $$Data{customer_id},
        );
        push (@ShownViewableTicket, $$Data{id});
    }
    # --
    # if there is no customer article avalible! Error!
    # --
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
    # --
    # return page
    # --
    return $Output;
}
# --

1;

