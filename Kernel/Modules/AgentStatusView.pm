# --   
# Kernel/Modules/AgentStatusView.pm - status for all open tickets
# Copyright (C) 2002 Phil Davis <phil.davis at itaction.co.uk>
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code at otrs.org>
# --   
# $Id: AgentStatusView.pm,v 1.9 2003-03-06 22:11:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentStatusView;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.9 $';
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
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # state object
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    # --
    # all static variables
    # --
    my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
        Type => 'Viewable',
        Result => 'ID',
    );
    $Self->{ViewableStateIDs} = \@ViewableStateIDs;

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
    # get user groups 
    my @GroupIDs = $Self->{GroupObject}->GroupUserList(
        UserID => $Self->{UserID},
        Type => 'ro',
        Result => 'ID',
    );
    # --
    # get data (viewable tickets...)
    # --
    my @ViewableTickets = ();
    my $SQL = "SELECT st.id, st.queue_id FROM " .
       " ticket st, queue q ".
       " WHERE " .
       " q.group_id IN ( ${\(join ', ', @GroupIDs)} )".
       " AND ".
       " q.id = st.queue_id ".
       " AND ";
    if ($Self->{ViewType} =~ /closed/i) {
        $SQL .= " st.ticket_state_id not in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} )"; 
    }
    else {
        $SQL .= " st.ticket_state_id in ( ${\(join ', ', @{$Self->{ViewableStateIDs}})} )"; 
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
