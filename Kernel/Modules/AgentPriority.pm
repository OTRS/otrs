# --
# Kernel/Modules/AgentPriority.pm - to set the ticket priority
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPriority.pm,v 1.4 2002-07-13 12:21:44 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPriority;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
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

    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
      # --
      # error page
      # --
      $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
      $Output .= $Self->{LayoutObject}->Error(
          Message => "Can't show history, no TicketID is given!",
          Comment => 'Please contact the admin.',
      );
      $Output .= $Self->{LayoutObject}->Footer();
      return $Output;
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }

    if ($Subaction eq 'Update') {
		# set id
        $Self->{TicketObject}->SetPriority(
			TicketID => $TicketID,
			PriorityID => $PriorityID,
			UserID => $UserID,
		);
        # print redirect
        $Output .= $Self->{LayoutObject}->Redirect(
			OP => "&Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID"
		);
    }
    else {
        # print form
        my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
        my $Priority = $Self->{TicketObject}->GetPriorityByTicketID(TicketID => $TicketID);
        $Output .= $Self->{LayoutObject}->Header(Title => 'Set Priority');
        my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
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
