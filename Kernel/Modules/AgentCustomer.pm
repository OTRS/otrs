# --
# Kernel/Modules/AgentCustomer.pm - to set the ticket customer and show the customer history
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentCustomer.pm,v 1.8 2002-10-25 11:46:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentCustomer;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.8 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (
      'ParamObject', 
      'DBObject', 
      'TicketObject', 
      'LayoutObject', 
      'LogObject', 
      'QueueObject', 
      'ConfigObject',
      'UserObject',
    ) {
        die "Got no $_!" if (!$Self->{$_});
    }
   
    # get  CustomerID
    $Self->{CustomerID} = $Self->{ParamObject}->GetParam(Param => 'CustomerID') || '';
    $Self->{Search} = $Self->{ParamObject}->GetParam(Param => 'Search') || 0;

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $TicketID = $Self->{TicketID};
    my $QueueID = $Self->{QueueID};
    my $Subaction = $Self->{Subaction};
    my $UserID    = $Self->{UserID};

    # --
    # check permissions
    # --
    if ($Self->{TicketID}) {
      if (!$Self->{TicketObject}->Permission(
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
      }
    }

    if ($Subaction eq 'Update') {
        # --
		# set customer id
        # --
        if ($Self->{TicketObject}->SetCustomerNo(
			TicketID => $TicketID,
			No => $Self->{CustomerID},
			UserID => $UserID,
		)) {
          # --
          # redirect
          # --
          if ($Self->{QueueID}) {
             return $Self->{LayoutObject}->Redirect(OP => "QueueID=$Self->{QueueID}");
          }
          else {
             return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
          }
        }
        else {
          # error?!
          $Output = $Self->{LayoutObject}->Header(Title => "Error");
          $Output .= $Self->{LayoutObject}->Error();
          $Output .= $Self->{LayoutObject}->Footer();
          return $Output;
        }
    }
    else {
        # print header 
        $Output .= $Self->{LayoutObject}->Header(Title => 'Customer');
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $UserID);
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        my $TicketCustomerID = $Self->{CustomerID};

        # --
        # print change form if ticket id is given
        # --
        if ($Self->{TicketID}) {
          my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
          $TicketCustomerID = $Self->{TicketObject}->GetCustomerNo(TicketID => $TicketID);
          # print change form
          $Output .= $Self->{LayoutObject}->AgentCustomer(
            CustomerID => $TicketCustomerID,
 			TicketID => $TicketID,
            TicketNumber => $Tn,
            QueueID => $QueueID,
          );
        }

        # get ticket ids with customer id
        my @TicketIDs = ();
        my $SQL = "SELECT st.id, st.tn ".
          " FROM ".
          " ticket st, $Self->{ConfigObject}->{DatabaseUserTable} su, group_user sug, ".
          " groups g, queue q ".
          " WHERE ".
          " su.$Self->{ConfigObject}->{DatabaseUserTableUserID} = sug.user_id ".
          " AND ".
          " g.id = sug.group_id".
          " AND ".
          " st.queue_id = q.id ".
          " AND ".
          " q.group_id = g.id ".
          " AND ".
          " sug.user_id = $UserID ".
          " AND ".
          " st.customer_id = '$TicketCustomerID' ".
          " ORDER BY st.create_time_unix ASC ";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        while (my @Row = $Self->{DBObject}->FetchrowArray() ) {
            push(@TicketIDs, $Row[0]); 
        }

        my $OutputTables = '';
        $Self->{ViewableSenderTypes} = $Self->{ConfigObject}->Get('ViewableSenderTypes')
           || die 'No Config entry "ViewableSenderTypes"!';

        foreach my $TicketID (@TicketIDs) {
            my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $TicketID);
            my %Article = $Self->{TicketObject}->GetLastCustomerArticle(TicketID => $TicketID);
            $OutputTables .= $Self->{LayoutObject}->AgentCustomerHistoryTable(
              %Ticket,
              %Article,
            );
        }
        if (!$OutputTables && $Self->{Search}) {
          $Output .= $Self->{LayoutObject}->AgentUtilSearchAgain(
              %Param,
              CustomerID => $Self->{CustomerID},
              Message => 'No entry found!',
          );
        }
        elsif ($Self->{Search}) {
          $Output .= $Self->{LayoutObject}->AgentUtilSearchAgain(
              %Param,
              CustomerID => $Self->{CustomerID},
          );
        }
        if ($OutputTables) {
          $Output .= $Self->{LayoutObject}->AgentCustomerHistory(
            CustomerID => $TicketCustomerID,
 			TicketID => $TicketID,
            HistoryTable => $OutputTables,
            QueueID => $QueueID,
          );
        }
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
