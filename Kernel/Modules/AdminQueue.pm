# --
# Kernel/Modules/AdminQueue.pm - to add/update/delete queues
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AdminQueue.pm,v 1.24 2006-06-20 13:27:51 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AdminQueue;

use strict;
use Kernel::System::Crypt;

use vars qw($VERSION);
$VERSION = '$Revision: 1.24 $';
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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    $Param{NextScreen} = 'AdminQueue';
    my $QueueID = $Self->{ParamObject}->GetParam(Param => 'QueueID') || '';

    my @Params = (
        'QueueID',
        'ParentQueueID',
        'Name',
        'GroupID',
        'UnlockTimeout',
        'WorkflowID',
        'SystemAddressID',
        'DefaultSignKey',
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
    # get possible sign keys
    my %KeyList = ();
    if ($QueueID) {
        my %QueueData = $Self->{QueueObject}->QueueGet(ID => $QueueID);
        my $CryptObjectPGP = Kernel::System::Crypt->new(%{$Self}, CryptType => 'PGP');
        if ($CryptObjectPGP) {
            my @PrivateKeys = $CryptObjectPGP->PrivateKeySearch(
                Search => $QueueData{Email},
            );
            foreach my $DataRef (@PrivateKeys) {
                $KeyList{"PGP::Inline::$DataRef->{Key}"} = "PGP-Inline: $DataRef->{Key} $DataRef->{Identifier}";
                $KeyList{"PGP::Detached::$DataRef->{Key}"} = "PGP-Detached: $DataRef->{Key} $DataRef->{Identifier}";
            }
        }
        my $CryptObjectSMIME = Kernel::System::Crypt->new(%{$Self}, CryptType => 'SMIME');
        if ($CryptObjectSMIME) {
            my @PrivateKeys = $CryptObjectSMIME->PrivateSearch(
                Search => $QueueData{Email},
            );
            foreach my $DataRef (@PrivateKeys) {
                $KeyList{"SMIME::Detached::$DataRef->{Hash}"} = "SMIME-Detached: $DataRef->{Hash} $DataRef->{Email}";
            }
        }
    }
    # get data
    if ($Self->{Subaction} eq 'Change') {
        my %QueueData = $Self->{QueueObject}->QueueGet(ID => $QueueID);
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(%Param, %QueueData, DefaultSignKeyList => \%KeyList);
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # update action
    elsif ($Self->{Subaction} eq 'ChangeAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # check queue name
        if ($GetParam{Name} =~ /::/) {
            $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
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
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # add new queue
    elsif ($Self->{Subaction} eq 'AddAction') {
        my %GetParam;
        foreach (@Params) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_) || '';
        }
        # check queue name
        if ($GetParam{Name} =~ /::/) {
            $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
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
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    # else ! print form
    else {
        $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
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
        MaxLevel => 4,
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

    my %DefaultSignKeyList = %{$Param{DefaultSignKeyList}} if ($Param{DefaultSignKeyList});
    $Param{'DefaultSignKeyOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => { '' => '-none-', %DefaultSignKeyList },
        Name => 'DefaultSignKey',
        Max => 50,
        SelectedID => $Param{DefaultSignKey},
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

    return $Self->{LayoutObject}->Output(TemplateFile => 'AdminQueueForm', Data => \%Param);
}
# --
1;
