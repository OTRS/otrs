# --
# AgentOwner.pm - to set the ticket owner
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentOwner.pm,v 1.2 2002-05-04 20:29:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentOwner;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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
    $Self->{NewUserID} = $Self->{ParamObject}->GetParam(Param => 'NewUserID') || '';

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

    if ($Subaction eq 'Update') {
		# set id
        $Self->{TicketObject}->SetOwner(
			TicketID => $TicketID,
			UserLogin => $Self->{UserLogin},
			UserID => $Self->{UserID},
            NewUserID => $Self->{NewUserID},
		);
        # print redirect
        $Output .= $Self->{LayoutObject}->Redirect(
			OP => "&Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID"
		);
    }
    else {
        # print form
        my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
        my $OwnerID = $Self->{TicketObject}->CheckOwner(TicketID => $TicketID);
        $Output .= $Self->{LayoutObject}->Header(Title => 'Set Owner');
        my %LockedData = $Self->{UserObject}->GetLockedCount(UserID => $UserID);
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        # get priority states
        my %States = $Self->{DBObject}->GetTableData(
			What => "$Self->{ConfigObject}->{DatabaseUserTableUserID}, ".
                    " $Self->{ConfigObject}->{DatabaseUserTableUser}",
			Table => $Self->{ConfigObject}->{DatabaseUserTable},
		);
        # print change form
	    $Output .= $Self->{LayoutObject}->AgentOwner(
			Data => \%States,
            OptionStrg => \%States,
 			TicketID => $TicketID,
            OwnerID => $OwnerID,
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
