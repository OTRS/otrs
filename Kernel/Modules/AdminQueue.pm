# --
# Kernel/Modules/AdminQueue.pm - to add/update/delete queues
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminQueue.pm,v 1.11 2003-03-10 21:27:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminQueue;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    
    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);
    
    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject 
        LogObject PermissionObject)) {
        die "Got no $_" if (!$Self->{$_});
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{Subaction} = $Self->{Subaction} || '';
    $Param{NextScreen} = 'AdminQueue';
    # -- 
    # permission check
    # --
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }

    my @Params = (
        'QueueID',
        'ParentQueueID',
        'Name',
        'GroupID',
        'UnlockTimeout',
        'WorkflowID',
        'SystemAddressID',
        'SalutationID',
        'SignatureID',
        'FollowUpID',
        'FollowUpLock',
        'EscalationTime',
        'MoveNotify',
        'StateNotify',
        'LockNotify', 
        'OwnerNotify',
        'Comment', 
        'ValidID'
    );

    # --
    # get data
    # --
    if ($Param{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'QueueID') || '';
        my %QueueData = $Self->{QueueObject}->QueueGet(ID => $ID); 
        $Output .= $Self->{LayoutObject}->Header(Title => 'Queue change');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminQueueForm(%Param, %QueueData);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # update action
    # --
    elsif ($Param{Subaction} eq 'ChangeAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # --
        # get long queue name
        # --
        if ($GetParam{ParentQueueID}) {
            $GetParam{Name} = $Self->{QueueObject}->QueueLookup(
                QueueID => $GetParam{ParentQueueID},
            ) .'::'. $GetParam{Name};
        }
        if ($Self->{QueueObject}->QueueUpdate(%GetParam, UserID => $Self->{UserID})) {
            return $Self->{LayoutObject}->Redirect(OP => "Action=$Param{NextScreen}");
        }
        else {
            $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # --
    # add new queue
    # --
    elsif ($Param{Subaction} eq 'AddAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # --
        # get long queue name
        # --
        if ($GetParam{ParentQueueID}) {
            $GetParam{Name} = $Self->{QueueObject}->QueueLookup(
                QueueID => $GetParam{ParentQueueID},
            ) .'::'. $GetParam{Name};
        }
        # --
        # create new queue
        # --
        if (my $Id = $Self->{QueueObject}->QueueAdd(%GetParam, UserID => $Self->{UserID})) {
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AdminQueueResponses&Subaction=Queue&ID=$Id",
            );
        }
        else {
            $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error();
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # --
    # else ! print form
    # --
    else {
        $Output = $Self->{LayoutObject}->Header(Title => 'Queue add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminQueueForm();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
