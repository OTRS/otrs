# --
# AgentPriority.pm - to set the ticket priority
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPriority.pm,v 1.1 2001-12-23 13:27:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPriority;

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
    foreach ('ParamObject', 'DBObject', 'TicketObject', 'LayoutObject', 'LogObject', 'QueueObject', 'ConfigObject') {
        die "Got no $_!" if (!$Self->{$_});
    }
   
    # get  PriorityID
    $Self->{PriorityID} = $Self->{ParamObject}->GetParam(Param => 'PriorityID') || '';

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
    my $PriorityID = $Self->{PriorityID};

    if ($Subaction eq 'Update') {
		# set id
        $Self->{TicketObject}->SetPriority(
			TicketID => $TicketID,
			PriorityID => $PriorityID,
			UserID => $UserID,
		);
        # add history entry
        $Self->{TicketObject}->AddHistoryRow(
            TicketID => $TicketID,
            HistoryType => 'PriorityUpdate',
            Name => "Priority update to $PriorityID.",
            CreateUserID => $UserID,
        );
        # print redirect
        $Output .= $Self->{LayoutObject}->Redirect(
			OP => "&Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID"
		);
    }
    else {
        # print form
        my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
        my $Priority = $Self->{TicketObject}->GetPriorityState(TicketID => $TicketID);
        $Output .= $Self->{LayoutObject}->Header();
        my %LockedData = $Self->{DBObject}->GetLockedCount(UserID => $UserID);
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        # get priority states
        my %States = $Self->{DBObject}->GetTableData(
			What => 'id, id, name',
			Table => 'ticket_priority',
		);
        # print change form
	    $Output .= $Self->{LayoutObject}->AgentPriority(
			Data => \%States,
            OptionStrg => \%States,
 			TicketID => $TicketID,
            Priority => $Priority,
            BackScreen => $Self->{BackScreen},
            NextScreen => $Self->{NextScreen},
            TicketNumber => $Tn,
            QueueID => $QueueID,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
