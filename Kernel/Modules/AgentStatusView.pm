# --   
# Kernel/Modules/AgentStatusView.pm - status for all open tickets
# Copyright (C) 2002 Phil Davis <phil.davis at itaction.co.uk>
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code at otrs.org>
# --   
# $Id: AgentStatusView.pm,v 1.7 2003-03-02 14:03:08 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentStatusView;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
   $Self->{Limit} = $Self->{ParamObject}->GetParam(Param => 'Limit') || 6000; 

   $Self->{StartHit} = $Self->{ParamObject}->GetParam(Param => 'StartHit') || 0;
   if ($Self->{StartHit} >= 1000) {
       $Self->{StartHit} = 1000;
   }
   $Self->{PageShown} = $Self->{ConfigObject}->Get('AgentStatusView::ViewableTicketsPage') || 50;
   $Self->{ViewType} = $Self->{ParamObject}->GetParam(Param => 'Type') || 'Open';
   if ($Self->{ViewType} =~ /^close/i) {
       $Self->{ViewType} = 'Closed';
   }
   else {
       $Self->{ViewType} = 'Open';
   }

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
       " AND ";
    if ($Self->{ViewType} =~ /closed/i) {
       $SQL .= " tsd.name not in ( ${\(join ', ', @ViewableStats)} ) ";
    }
    else {
       $SQL .= " tsd.name in ( ${\(join ', ', @ViewableStats)} ) ";
    }
    $SQL .= " ORDER BY ";

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
    my $AllHits = 0;
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        $AllHits++;
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
    my $Counter = 0;
    foreach my $DataTmp (@ViewableTickets) {
        $Counter++;
        if ($Counter > $Self->{StartHit} && $Counter <= ($Self->{PageShown}+$Self->{StartHit})) {
            $OutputTable .= ShowTicketStatus(
               $Self,
               %{$DataTmp}, 
            );
        }
    }
    $Output .= $Self->{LayoutObject}->AgentStatusView(
        StatusTable => $OutputTable, 
        Limit => $Self->{Limit},
        SortBy => $Self->{SortBy},
        Order => $Self->{Order},
        PageShown => $Self->{PageShown},
        AllHits => $AllHits,
        StartHit => $Self->{StartHit},
        Type => $Self->{ViewType},
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
    my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $TicketID);
    my @ArticleIndex = $Self->{TicketObject}->GetArticleIndex(
        TicketID => $TicketID, 
        SenderType => 'customer',
    );
    my %Article = $Self->{TicketObject}->GetArticle(ArticleID => $ArticleIndex[$#ArticleIndex]);
    # Condense down the subject
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    my $Subject = $Article{Subject};
    $Subject =~ s/^RE:*//i; 
    $Subject =~ s/\[${TicketHook}:\s*\d+\]//;

    if (%Article) {
        $Output .= $Self->{LayoutObject}->AgentStatusViewTable(
            %Ticket,
            %Article,
            Subject => $Subject,
        );
    }
    else {
        # --
        # if there is no customer article avalible! Error!
        # --
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
