# --
# Kernel/Modules/AgentTicketLock.pm - to set or unset a lock for tickets
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketLock.pm,v 1.2 2006-08-29 17:17:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketLock;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.2 $';
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

    # check all needed objects
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

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
        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Can't lock Ticket, no TicketID is given!",
            Comment => 'Please contact the admin.',
        );
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'lock',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # --
    # start with actions
    # --
    if ($Self->{Subaction} eq 'Unlock') {
        # check if I'm the owner
        my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
        );
        if ($OwnerID != $Self->{UserID}) {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Sorry, the current owner is $OwnerLogin!",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # set unlock
        if ($Self->{TicketObject}->LockSet(
            TicketID => $Self->{TicketID},
            Lock => 'unlock',
            UserID => $Self->{UserID},
        )) {
            # redirekt
            if ($Self->{QueueID}) {
               return $Self->{LayoutObject}->Redirect(OP => "QueueID=$Self->{QueueID}");
            }
            else {
               return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
            }
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    else {
        # check if the agent is ablee to lock
        if ($Self->{TicketObject}->LockIsTicketLocked(TicketID => $Self->{TicketID})) {
            my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
            );
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Ticket (ID=$Self->{TicketID}) is locked for $OwnerLogin!",
                Comment => "Change the owner!",
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # set lock
        if ($Self->{TicketObject}->LockSet(
            TicketID => $Self->{TicketID},
            Lock => 'lock',
            UserID => $Self->{UserID},
        ) &&
	    # set user id
    	$Self->{TicketObject}->OwnerSet(
            TicketID => $Self->{TicketID},
	        UserID => $Self->{UserID},
	        NewUserID => $Self->{UserID},
        )) {
            # redirekt
            if ($Self->{QueueID}) {
               return $Self->{LayoutObject}->Redirect(OP => "&QueueID=$Self->{QueueID}");
            }
            else {
               return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
            }
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
}
# --

1;
