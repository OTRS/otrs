# --
# AgentLock.pm - to set or unset a lock for tickets
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentLock.pm,v 1.3 2002-07-12 23:01:20 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentLock;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.3 $';
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

    # check all needed objects
    foreach (
      'ParamObject', 
      'DBObject', 
      'QueueObject', 
      'LayoutObject', 
      'ConfigObject', 
      'LogObject',
    ) {
        die "Got no $_!" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $TicketID = $Self->{TicketID};
    my $QueueID = $Self->{QueueID};
    my $Lock = 'lock';
    my $UnLock = 'unlock';
    my $Subaction = $Self->{Subaction};
    my $NextScreen = $Self->{NextScreen} || '';
    my $UserID = $Self->{UserID};
    my $UserLogin = $Self->{UserLogin};
    
    if (!$TicketID) {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'No TicketID!!',
            Comment => 'Please contact your admin');
        $Self->{LogObject}->Log(
            Priority => 'error',
            MSG => 'No TicketID found!!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # do some selects ....
    else {
        if ($Subaction eq 'Unlock') {
            $Lock = $UnLock;
        }
        # set lock
        $Self->{TicketObject}->SetLock(
            TicketID => $TicketID,
            Lock => $Lock,
            UserID => $UserID,
        );
        if ($Subaction ne 'Unlock') {
	        # set user id
    	    $Self->{TicketObject}->SetOwner(
        	    TicketID => $TicketID,
	            UserID => $UserID,
	            NewUserID => $UserID,
        	);
        }
        # mk redirect
        $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=$NextScreen&QueueID=$QueueID",
        );
    }
    return $Output;
}
# --

1;
