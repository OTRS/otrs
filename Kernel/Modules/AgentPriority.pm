# --
# Kernel/Modules/AgentPriority.pm - to set the ticket priority
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPriority.pm,v 1.12 2003-03-10 21:27:12 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPriority;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject 
      QueueObject ConfigObject UserObject)) {
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

    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
        # --
        # error page
        # --
        my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
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
        Type => 'rw',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    else {
        my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->CheckOwner(
            TicketID => $Self->{TicketID},
        );
        if ($OwnerID != $Self->{UserID}) {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(
                Message => "Sorry, the current owner is $OwnerLogin",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }

    if ($Self->{Subaction} eq 'Update') {
        # --
		# set id
        # --
        $Self->{TicketObject}->SetPriority(
			TicketID => $Self->{TicketID},
			PriorityID => $Self->{PriorityID},
			UserID => $Self->{UserID},
		);
        # --
        # print redirect
        # --
        return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
    }
    else {
        # print form
        my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $Self->{TicketID});
        my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $Self->{TicketID});
        $Output .= $Self->{LayoutObject}->Header(Title => 'Set Priority');
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        # get priority states
        my %States = $Self->{DBObject}->GetTableData(
			What => 'id, name',
			Table => 'ticket_priority',
		);
        # print change form
	    $Output .= $Self->{LayoutObject}->AgentPriority(
			Data => \%States,
            OptionStrg => \%States,
 			TicketID => $Self->{TicketID},
            PriorityID => $Ticket{PriorityID},
            TicketNumber => $Tn,
            QueueID => $Self->{QueueID},
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
