# --
# AgentMove.pm - move tickets to queues 
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentMove.pm,v 1.2 2002-07-12 16:02:57 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentMove;

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

    # make all Params to local 
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject)) { 
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
        $Output .= $Self->{LayoutObject}->Header(Title => "Error");
        $Output .= $Self->{LayoutObject}->Error(
                Message => 'No DestQueueID!!',
                Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    elsif (!$Self->{TicketID}) {
        $Output .= $Self->{LayoutObject}->Header(Title => "Error");
        $Output .= $Self->{LayoutObject}->Error(
                Message => 'No TicketID!!',
                Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    else {
        # update
        if ($Self->{TicketObject}->MoveTicketID(
          QueueID => $Self->{DestQueueID},
          UserID => $Self->{UserID},
          TicketID => $Self->{TicketID},
          ) ) {
           # redirect 
           $Output .= $Self->{LayoutObject}->Redirect(
            OP => "&Action=AgentQueueView&QueueID=$Self->{QueueID}",
           );
        }
        else {
          # error?!
          $Output = $Self->{LayoutObject}->Header(Title => "Error");
	      $Output .= $Self->{LayoutObject}->Error(
                Message => "Error! Can't update queue for ticket id $Self->{TicketID}!",
                Comment => 'Please contact your admin',
          );
          $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    return $Output;
}
# --

1;

