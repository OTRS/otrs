# --
# AdminQueue.pm - to add/update/delete queues
# Copyright (C) 2001,2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminQueue.pm,v 1.4 2002-06-18 18:07:53 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminQueue;

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
    
    # get common opjects
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
    
    # permission check
    if (!$Self->{PermissionObject}->Section(UserID => $Self->{UserID}, Section => 'Admin')) {
        $Output .= $Self->{LayoutObject}->NoPermission();
        return $Output;
    }
    
    # get user data 2 form
    if ($Param{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'QueueID') || '';
        $Output .= $Self->{LayoutObject}->Header(Title => 'Queue change');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        # get user data
        my $SQL = "SELECT name, group_id, unlock_timeout, " .
        " system_address_id, salutation_id, signature_id, comment, valid_id, " .
        " escalation_time, follow_up_id, follow_up_lock " .
        " FROM " .
        " queue " .
        " WHERE " .
        " id = $ID";
        $Self->{DBObject}->Prepare(SQL => $SQL);
        my @Data = $Self->{DBObject}->FetchrowArray();
        $Output .= $Self->{LayoutObject}->AdminQueueForm(
            QueueID => $ID,
            Name => $Data[0],
            GroupID => $Data[1],
            UnlockTimeout => $Data[2],
            EscalationTime => $Data[8],
            FollowUpID => $Data[9],
            FollowUpLock => $Data[10],
            SystemAddressID => $Data[3],
            SalutationID => $Data[4],
            SignatureID => $Data[5],
            Comment => $Data[6],
            ValidID => $Data[7],
            %Param,
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    # update action
    elsif ($Param{Subaction} eq 'ChangeAction') {
        my %GetParam;
        my @Params = (
            'QueueID',
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
            'Comment',
            'ValidID'
        );
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
            $GetParam{$_} = $Self->{DBObject}->Quote($GetParam{$_}) || '';
            $GetParam{$_} = '' if (!exists $GetParam{$_});
        }
        # check !!!
        $GetParam{UnlockTimeout} = 0 if (!$GetParam{UnlockTimeout});
        $GetParam{EscalationTime} = 0 if (!$GetParam{EscalationTime});
        $GetParam{FollowUpLock} = 0 if (!$GetParam{FollowUpLock});
        my $SQL = "UPDATE queue SET name = '$GetParam{Name}', " .
        " comment = '$GetParam{Comment}', " .
        " group_id = $GetParam{GroupID}, " .
        " unlock_timeout = $GetParam{UnlockTimeout}, " .
        " escalation_time = $GetParam{EscalationTime}, " .
        " follow_up_id = $GetParam{FollowUpID}, " .
        " follow_up_lock = $GetParam{FollowUpLock}, " .
#        " workflow_id = $GetParam{WorkflowID}, " .
        " system_address_id = $GetParam{SystemAddressID}, " .
        " salutation_id = $GetParam{SalutationID}, " .
        " signature_id = $GetParam{SignatureID}, " .
        " valid_id = $GetParam{ValidID}, " .
        " change_time = current_timestamp, " .
        " change_by = $Self->{UserID} " .
        " WHERE id = $GetParam{QueueID}";
        if ($Self->{DBObject}->Do(SQL => $SQL)) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'DB Error!!',
                Comment => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # --
    # add new queue
    # --
    elsif ($Param{Subaction} eq 'AddAction') {
        my %GetParam;
        my @Params = (
            'Name',
            'GroupID',
            'UnlockTimeout',
            'SystemAddressID',
            'SalutationID',
            'SignatureID',
            'FollowUpID',
            'FollowUpLock',
            'EscalationTime',
            'Comment',
            'ValidID',
        );
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }

        # --
        # create new queue
        # --
        if ($Self->{QueueObject}->QueueAdd(%GetParam, UserID => $Self->{UserID})) {
            $Output .= $Self->{LayoutObject}->Redirect(OP => "&Action=$Param{NextScreen}");
        }
        else {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Error(
                Message => 'Can\'t create Queue!!',
                Comment => 'Please contact your admin',
            );
            $Output .= $Self->{LayoutObject}->Footer();
        }
    }
    # --
    # else ! print form
    # --
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Queue add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->{LayoutObject}->AdminQueueForm();
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
