# --
# Kernel/Modules/AgentCustomer.pm - to set the ticket customer and show the customer history
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentCustomer.pm,v 1.1 2002-07-17 22:36:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentCustomer;

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
    my $NextScreen = $Self->{NextScreen} || '';
    my $BackScreen = $Self->{BackScreen};
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
		# set id
        if ($Self->{TicketObject}->SetCustomerNo(
			TicketID => $TicketID,
			No => $Self->{CustomerID},
			UserID => $UserID,
		)) {
          # print redirect
          $Output .= $Self->{LayoutObject}->Redirect(
			OP => "&Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID"
	      );
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
        $Output .= $Self->{LayoutObject}->Header(Title => 'Set Customer');
        my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
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
            BackScreen => $Self->{BackScreen},
            NextScreen => $Self->{NextScreen},
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
          my $SQL = "SELECT sa.ticket_id, sa.a_from, sa.a_to, sa.a_cc, sa.a_subject, " .
            " sa.a_body, st.create_time_unix, sa.a_freekey1, sa.a_freetext1, sa.a_freekey2, " .
            " sa.a_freetext2, sa.a_freekey3, sa.a_freetext3, st.freekey1, st.freekey2, " .
            " st.freetext1, st.freetext2, st.customer_id, sq.name as queue, sa.id as article_id, " .
            " st.id, st.tn, sp.name, sd.name as state, st.queue_id, st.create_time, ".
            " sa.incoming_time, sq.escalation_time, st.ticket_answered, sa.a_content_type " .
            " FROM " .
            " article sa, ticket st, ticket_priority sp, ticket_state sd, article_sender_type sdt, queue sq " .
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
            " sdt.name in ( ${\(join ', ', @{$Self->{ViewableSenderTypes}})} ) " .
            " ORDER BY sa.create_time DESC ";
          $Self->{DBObject}->Prepare(SQL => $SQL, Limit => 1);
          while (my $Data = $Self->{DBObject}->FetchrowHashref() ) {
            my $Age = time() - $$Data{create_time_unix};
            $OutputTables .= $Self->{LayoutObject}->AgentCustomerHistoryTable(
              TicketNumber => $$Data{tn},
              From => $$Data{a_from},
              To => $$Data{a_to},
              Subject => $$Data{a_subject},
              State => $$Data{state},
              Text => $$Data{a_body},
              Lock => $$Data{lock_type},
              Queue => $$Data{queue},
              TicketID => $$Data{id},
              Owner => $$Data{login},
              Age => $Age,
            );
          }
        }
	    $Output .= $Self->{LayoutObject}->AgentCustomerHistory(
            CustomerID => $TicketCustomerID,
 			TicketID => $TicketID,
            BackScreen => $Self->{BackScreen},
            NextScreen => $Self->{NextScreen},
            HistoryTable => $OutputTables,
            QueueID => $QueueID,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
