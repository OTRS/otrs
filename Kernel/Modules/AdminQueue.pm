# --
# Kernel/Modules/AdminQueue.pm - to add/update/delete queues
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminQueue.pm,v 1.14 2003-12-07 23:56:15 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminQueue;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.14 $';
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
    foreach (qw(ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
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
    # get data
    if ($Param{Subaction} eq 'Change') {
        my $ID = $Self->{ParamObject}->GetParam(Param => 'QueueID') || '';
        my %QueueData = $Self->{QueueObject}->QueueGet(ID => $ID); 
        $Output .= $Self->{LayoutObject}->Header(Title => 'Queue change');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->_Mask(%Param, %QueueData);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # update action
    elsif ($Param{Subaction} eq 'ChangeAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # check queue name
        if ($GetParam{Name} =~ /::/) {
            $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Warning(
                Message => 'Don\'t use :: in queue name!',
                Comment => 'Click back and change it!',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # get long queue name
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
    # add new queue
    elsif ($Param{Subaction} eq 'AddAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # check queue name
        if ($GetParam{Name} =~ /::/) {
            $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->AdminNavigationBar();
            $Output .= $Self->{LayoutObject}->Warning(
                Message => 'Don\'t use :: in queue name!',
                Comment => 'Click back and change it!',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # get long queue name
        if ($GetParam{ParentQueueID}) {
            $GetParam{Name} = $Self->{QueueObject}->QueueLookup(
                QueueID => $GetParam{ParentQueueID},
            ) .'::'. $GetParam{Name};
        }
        # create new queue
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
    # else ! print form
    else {
        $Output = $Self->{LayoutObject}->Header(Title => 'Queue add');
        $Output .= $Self->{LayoutObject}->AdminNavigationBar();
        $Output .= $Self->_Mask();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;

    # build ValidID string
    $Param{'ValidOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'valid',
            Valid => 0,
          )
        },
        Name => 'ValidID',
        SelectedID => $Param{ValidID},
    );

    $Param{'GroupOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'groups',
            Valid => 1,
          )
        },
        Name => 'GroupID',
        SelectedID => $Param{GroupID},
    );
    my $ParentQueue = '';
    if ($Param{Name}) {
        my @Queue = split(/::/, $Param{Name});
        for (my $i = 0; $i < $#Queue; $i++) {
            if ($ParentQueue) {
                $ParentQueue .= '::';
            }
            $ParentQueue .= $Queue[$i];
        }
        $Param{Name} = $Queue[$#Queue];
    }
    $Param{'QueueOption'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'queue',
            Valid => 1,
          ),
          '' => '-',
        },
        Name => 'ParentQueueID',
        Selected => $ParentQueue,
        MaxLevel => 2,
        OnChangeSubmit => 0,
    );

    $Param{'QueueLongOption'} = $Self->{LayoutObject}->AgentQueueListOption(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Table => 'queue',
            Valid => 0,
          )
        },
        Name => 'QueueID',
        Size => 15,
        SelectedID => $Param{QueueID},
        OnChangeSubmit => 0,
    );

    $Param{'SignatureOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Valid => 1,
            Clamp => 1,
            Table => 'signature',
          )
        },
        Name => 'SignatureID',
        SelectedID => $Param{SignatureID},
    );

    $Param{'FollowUpLockYesNoOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'FollowUpLock',
        SelectedID => $Param{FollowUpLock},
    );

    $Param{'SystemAddressOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, value0, value1',
            Valid => 1,
            Clamp => 1,
            Table => 'system_address',
          )
        },
        Name => 'SystemAddressID',
        SelectedID => $Param{SystemAddressID},
    );

    $Param{'SalutationOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name, id',
            Valid => 1,
            Clamp => 1,
            Table => 'salutation',
          )
        },
        Name => 'SalutationID',
        SelectedID => $Param{SalutationID},
    );

    $Param{'FollowUpOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => {
          $Self->{DBObject}->GetTableData(
            What => 'id, name',
            Valid => 1,
            Table => 'follow_up_possible',
          )
        },
        Name => 'FollowUpID',
        SelectedID => $Param{FollowUpID} || $Self->{ConfigObject}->Get('AdminDefaultFollowUpID') || 1,
    );

    $Param{'MoveOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'MoveNotify',
        SelectedID => $Param{MoveNotify},
    );
    $Param{'StateOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'StateNotify',
        SelectedID => $Param{StateNotify},
    );
    $Param{'OwnerOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'OwnerNotify',
        SelectedID => $Param{OwnerNotify},
    );
    $Param{'LockOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'LockNotify',
        SelectedID => $Param{LockNotify},
    );
    $Param{'Subaction'} = "Add" if (!$Param{'Subaction'});

    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminQueueForm', Data => \%Param);
}
# --
1;
