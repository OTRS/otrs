# --
# Kernel/Modules/AgentLock.pm - to set or unset a lock for tickets
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentLock.pm,v 1.6 2002-08-01 02:37:36 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentLock;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.6 $';
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
    my $QueueID = $Self->{QueueID};

    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
      # --
      # error page
      # --
      $Output = $Self->{LayoutObject}->Header(Title => 'Error');
      $Output .= $Self->{LayoutObject}->Error(
          Message => "Can't lock Ticket, no TicketID is given!",
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

    # --
    # start with actions
    # --
    if ($Self->{Subaction} eq 'Unlock') {
        # --
        # set unlock
        # --
        if ($Self->{TicketObject}->SetLock(
          TicketID => $Self->{TicketID},
          Lock => 'unlock',
          UserID => $Self->{UserID},
        )) {
          # --
          # redirekt
          # --
          if ($Self->{QueueID}) {
             return $Self->{LayoutObject}->Redirect(OP => "&QueueID=$Self->{QueueID}");
          }
          else {
             return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
          }
        }
        else {
          $Output = $Self->{LayoutObject}->Header(Title => 'Error');
          $Output .= $Self->{LayoutObject}->Error();
          $Output .= $Self->{LayoutObject}->Footer();
          return $Output;
        } 
    }
    else {
        # --
        # set lock
        # --
        if ($Self->{TicketObject}->SetLock(
          TicketID => $Self->{TicketID},
          Lock => 'lock',
          UserID => $Self->{UserID},
        ) &&
        # --
	    # set user id
        # --
    	$Self->{TicketObject}->SetOwner(
            TicketID => $Self->{TicketID},
	        UserID => $Self->{UserID},
	        NewUserID => $Self->{UserID},
        )) {
          # --
          # redirekt
          # --
          if ($Self->{QueueID}) {
             return $Self->{LayoutObject}->Redirect(OP => "&QueueID=$Self->{QueueID}");
          }
          else {
             return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
          }
        }
        else {
          $Output = $Self->{LayoutObject}->Header(Title => 'Error');
          $Output .= $Self->{LayoutObject}->Error();
          $Output .= $Self->{LayoutObject}->Footer();
          return $Output;
        } 
    }
}
# --

1;
