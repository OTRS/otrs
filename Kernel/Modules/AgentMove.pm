# --
# AgentMove.pm - move tickets to queues 
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentMove.pm,v 1.1 2001-12-23 13:27:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentMove;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);

    # make all Params to local 
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach ('ParamObject', 'DBObject', 'TicketObject', 'LayoutObject', 'LogObject') { 
        die "Got no $_" if (!$Self->{$_});
    }

    # get DestQueueID 
    $Self->{DestQueueID} = $Self->{ParamObject}->GetParam(Param => 'DestQueueID');

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
	
    if (!$Self->{DestQueueID}) {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
                Message => 'No DestQueueID!!',
                Comment => 'Please contact your admin');
        $Self->{LogObject}->Log(
                Priority => 'error',
                MSG => 'Panic! No DestQueueID found!!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    elsif (!$Self->{TicketID}) {
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
                Message => 'No TicketID!!',
                Comment => 'Please contact your admin');
        $Self->{LogObject}->Log(
                Priority => 'error',
                MSG => 'Panic! No TicketID found!!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    else {
        # db update
        my $SQL = "UPDATE ticket SET queue_id = $Self->{DestQueueID} where id = $Self->{TicketID}";
        if ($Self->{DBObject}->Do(SQL => $SQL) ) {
           # queue lookup
           my $Queue = $Self->{QueueObject}->QueueLookup(QueueID => $Self->{DestQueueID}) || $Self->{DestQueueID};
           # history insert
           $Self->{TicketObject}->AddHistoryRow(
		        TicketID => $Self->{TicketID},
                HistoryType => 'Move',
		        Name => "Ticket moved to Queue '$Queue'.",
		        CreateUserID => $Self->{UserID},
		   );
           # redirect 
           $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=AgentQueueView&QueueID=$Self->{QueueID}");
	}
	else {
        # error?!
	    $Output .= $Self->{LayoutObject}->Error(
                MSG => 'DB Error!!',
                REASON => 'Please contact your admin');
        $Self->{LogObject}->Log(
                Priority => 'error',
                MSG => "Panic! DB Error! Can't update queue for ticket id $Self->{TicketID} !!",
        );

	}
    }
    return $Output;
}
# --

1;

