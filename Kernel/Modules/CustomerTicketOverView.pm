# --   
# Kernel/Modules/CustomerTicketOverView.pm - status for all open tickets
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code at otrs.org>
# --   
# $Id: CustomerTicketOverView.pm,v 1.17 2003-10-13 20:34:30 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::CustomerTicketOverView;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.17 $';
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
    foreach (qw(ParamObject DBObject LayoutObject ConfigObject LogObject UserObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # state object
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    # --
    # all static variables
    # --
    $Self->{ViewableSenderTypes} = $Self->{ConfigObject}->Get('ViewableSenderTypes')
          || die 'No Config entry "ViewableSenderTypes"!';
    # --
    # get params 
    # --
    $Self->{ShowClosedTickets} = $Self->{ParamObject}->GetParam(Param => 'ShowClosedTickets') || 0;
    $Self->{SortBy} = $Self->{ParamObject}->GetParam(Param => 'SortBy') || 'Age';
    $Self->{Order} = $Self->{ParamObject}->GetParam(Param => 'Order') || 'Up';
    $Self->{StartHit} = $Self->{ParamObject}->GetParam(Param => 'StartHit') || 0; 
    if ($Self->{StartHit} >= 1000) {
        $Self->{StartHit} = 1000;
    }
    $Self->{PageShown} = $Self->{ConfigObject}->Get('CustomerViewableTickets') || 25;
 
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
        my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError();
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    # --
    # check needed CustomerID
    # --
    if (!$Self->{UserCustomerID}) {
        my $Output = $Self->{LayoutObject}->CustomerHeader(Title => 'Error');
        $Output .= $Self->{LayoutObject}->CustomerError(Message => 'Need CustomerID!!!');
        $Output .= $Self->{LayoutObject}->CustomerFooter();
        return $Output;
    }
    # --
    # starting with page ...
    # --
    my $Refresh = '';
    if ($Self->{UserRefreshTime}) {
        $Refresh = 60 * $Self->{UserRefreshTime};
    }
    my $Output = $Self->{LayoutObject}->CustomerHeader(
        Title => 'My Tickets',
        Refresh => $Refresh,
    );
    # build NavigationBar
    $Output .= $Self->{LayoutObject}->CustomerNavigationBar();
    # to get the output faster!
    print $Output; $Output = '';
    # --
    # check if just open tickets should be shown
    # --
    my $SQLExt = '';
    my $ShowClosed = 0;
    if ((defined($Self->{UserShowClosedTickets}) && !$Self->{UserShowClosedTickets}) 
      || (!defined $Self->{UserShowClosedTickets} && !$Self->{ConfigObject}->Get('CustomerPreferencesGroups')->{ClosedTickets}->{DataSelected})) {
        $ShowClosed = 0;
    }
    if ($Self->{ShowClosedTickets}) {
        $ShowClosed = 1;
    }
    if (!$ShowClosed) {
        my @ViewableStateIDs = $Self->{StateObject}->StateGetStatesByType(
            Type => 'Viewable',
            Result => 'ID',
        );
        $SQLExt .= " AND ";
        $SQLExt .= " st.ticket_state_id in ( ${\(join ', ', @ViewableStateIDs)} ) ";
    }
    # --
    # get data (viewable tickets...)
    # --
    my $AllTickets = 0; 
    my $SQL = "SELECT count(*) FROM ".
       " ticket st ".
       " WHERE ".
       " st.customer_id = '".$Self->{DBObject}->Quote($Self->{UserCustomerID})."'".
       $SQLExt;
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $AllTickets = $Row[0];
    }
    my @ViewableTickets = ();
    $SQL = "SELECT st.id FROM " .
       " ticket st, ticket_state tsd, queue q, " . 
         $Self->{ConfigObject}->Get('DatabaseUserTable'). " u ".
       " WHERE " .
       " tsd.id = st.ticket_state_id " .
       " AND " .
       " st.user_id = u.". $Self->{ConfigObject}->Get('DatabaseUserTableUserID') .
       " AND ".
       " q.id = st.queue_id ".
       " AND ".
       " st.customer_id = '".$Self->{DBObject}->Quote($Self->{UserCustomerID})."'".
       $SQLExt.
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

    if ($Self->{SortBy} eq 'Age') {
        if ($Self->{Order} eq 'Down') {
            $SQL .= " ASC";
        }
        else {
            $SQL .= " DESC";
        }
    }
    else {
        if ($Self->{Order} eq 'Down') {
            $SQL .= " DESC";
        }
        else {
            $SQL .= " ASC";
        }
    }

    $Self->{DBObject}->Prepare(SQL => $SQL, Limit => $Self->{StartHit}+$Self->{PageShown});
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        push (@ViewableTickets, $RowTmp[0]);
    }
    # --
    # show ticket's
    # --
    my $OutputTable = "";
    my $Counter = 0;
    foreach my $TicketID (@ViewableTickets) {
      $Counter++;
      if ($Counter > $Self->{StartHit} && $Counter <= ($Self->{PageShown}+$Self->{StartHit})) {
        $OutputTable .= $Self->ShowTicketStatus(TicketID => $TicketID);
      }
    }
    $Output .= $Self->{LayoutObject}->CustomerStatusView(
        StatusTable => $OutputTable, 
        SortBy => $Self->{SortBy},
        Order => $Self->{Order},
        PageShown => $Self->{PageShown},
        AllHits => $AllTickets,
        StartHit => $Self->{StartHit},
        ShowClosed => $ShowClosed,
    );
    # get page footer
    $Output .= $Self->{LayoutObject}->CustomerFooter();
    
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
    my @ArticleIndex = $Self->{TicketObject}->GetArticleIndex(
        TicketID => $TicketID, 
        SenderType => 'customer',
    );
    # --
    # check article index
    # --
    if (!@ArticleIndex) {
        $Self->{LogObject}->Log(
           Priority => 'error',
           Message => "No customer article found!! (TicketID=$TicketID)",
           Comment => 'Please contact your admin',
        ); 
        return;
    }
    # --
    # get last article
    # --
    my %Article = $Self->{TicketObject}->GetArticle(ArticleID => $ArticleIndex[$#ArticleIndex]);
    # Condense down the subject
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
    my $Subject = $Article{Subject};
    $Subject =~ s/^RE://i;
    $Subject =~ s/\[${TicketHook}:\s*\d+\]//;
    if (%Article) {
        $Output .= $Self->{LayoutObject}->CustomerStatusViewTable(
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
    # return ticket
    # --
    return $Output;
}
# --

1;
