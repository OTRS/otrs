# --
# Kernel/Modules/AgentMove.pm - move tickets to queues
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentMove.pm,v 1.36 2004-09-15 12:31:08 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentMove;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.36 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    # get params
    $Self->{DestQueueID} = $Self->{ParamObject}->GetParam(Param => 'DestQueueID');
    $Self->{TicketUnlock} = $Self->{ParamObject}->GetParam(Param => 'TicketUnlock');
    $Self->{ExpandQueueUsers} = $Self->{ParamObject}->GetParam(Param => 'ExpandQueueUsers') || 0;
    $Self->{AllUsers} = $Self->{ParamObject}->GetParam(Param => 'AllUsers') || 0;
    $Self->{Comment} = $Self->{ParamObject}->GetParam(Param => 'Comment') || '';
    $Self->{NewStateID} = $Self->{ParamObject}->GetParam(Param => 'NewStateID') || '';

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;

    # check needed stuff
    foreach (qw(TicketID)) {
      if (!$Self->{$_}) {
        # error page
        return $Self->{LayoutObject}->ErrorScreen(
          Message => "Need $_!",
        );
      }
    }
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => 'move',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # check if ticket is locked
    if ($Self->{TicketObject}->LockIsTicketLocked(TicketID => $Self->{TicketID})) {
        my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
            TicketID => $Self->{TicketID},
        );
        if ($OwnerID != $Self->{UserID}) {
            my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Warning(
                Message => "Can't move, the current owner is $OwnerLogin!",
                Comment => 'Please change the owner first.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
    }
    # move queue
    if (!$Self->{DestQueueID} || $Self->{ExpandQueueUsers}) {
        $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Move Ticket');
#        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
#        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        # get lock state && write (lock) permissions
        if (!$Self->{TicketObject}->LockIsTicketLocked(TicketID => $Self->{TicketID})) {
            # set owner
            $Self->{TicketObject}->OwnerSet(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );
            # set lock
            if ($Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => $Self->{UserID}
            )) {
                # show lock state
                $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $Self->{TicketID});
                $Self->{TicketUnlock} = 1;
            }
        }
        else {
#            $Self->{TicketUnlock} = 0;
            my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
            );
            if ($OwnerID != $Self->{UserID}) {
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, the current owner is $OwnerLogin!",
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }
        # fetch all queues
        my %MoveQueues = $Self->{TicketObject}->MoveList(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
            Action => $Self->{Action},
            Type => 'move_into',
        );
        # build header
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
        # get next states
        my %NextStates = $Self->{TicketObject}->StateList(
            Type => 'DefaultNextMove',
            Action => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
        );
        $NextStates{''} = '-';
        # get old owners
        my @OldUserInfo = $Self->{TicketObject}->OwnerList(TicketID => $Self->{TicketID});
        # get lod queues
        my @OldQueue = $Self->{TicketObject}->MoveQueueList(TicketID => $Self->{TicketID});
        # print change form
        $Output .= $Self->AgentMove(
            OldQueue => \@OldQueue,
            OldUser => \@OldUserInfo,
            MoveQueues => \%MoveQueues,
            OwnerList => $Self->_GetUsers(),
            TicketID => $Self->{TicketID},
            NextStates => \%NextStates,
            TicketUnlock => $Self->{TicketUnlock},
            Comment => $Self->{Comment},
            %Ticket,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Self->{TicketObject}->MoveTicket(
          QueueID => $Self->{DestQueueID},
          UserID => $Self->{UserID},
          TicketID => $Self->{TicketID},
      ) ) {
        # set state
        if ($Self->{ConfigObject}->{MoveSetState} && $Self->{NewStateID}) {
            $Self->{TicketObject}->StateSet(
                TicketID => $Self->{TicketID},
                StateID => $Self->{NewStateID},
                UserID => $Self->{UserID},
            );
        }
        # new owner!
        my $UserSelection = $Self->{ParamObject}->GetParam(Param => 'UserSelection') || '';
        my $NewUserID = $Self->{ParamObject}->GetParam(Param => 'NewUserID') || '';
        my $OldUserID = $Self->{ParamObject}->GetParam(Param => 'OldUserID') || '';
        # check new/old user selection
        if ($UserSelection eq 'Old') {
            if ($OldUserID) {
                $NewUserID = $OldUserID;
            }
        }
        # check if new user is given
        if ($NewUserID) {
            # lock
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => $Self->{UserID},
            );
            # set owner
            $Self->{TicketObject}->OwnerSet(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $NewUserID,
                Comment => $Self->{Comment},
            );
        }
        else {
            # unlock
            if ($Self->{TicketUnlock}) {
                $Self->{TicketObject}->LockSet(
                    TicketID => $Self->{TicketID},
                    Lock => 'unlock',
                    UserID => $Self->{UserID},
                );
            }
        }
        if ($Self->{Comment}) {
            # add note
            my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID => $Self->{TicketID},
                ArticleType => 'note-internal',
                SenderType => 'agent',
                From => $Self->{UserLogin},
                Subject => 'Move Note',
                Body => $Self->{Comment},
                ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
                UserID => $Self->{UserID},
                HistoryType => 'AddNote',
                HistoryComment => '%%Move',
            );
        }
        # redirect
        return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
    }
    else {
        # error?!
        $Output = $Self->{LayoutObject}->Header(Title => 'Warning');
	$Output .= $Self->{LayoutObject}->Warning(
            Message => "",
            Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub AgentMove {
    my $Self = shift;
    my %Param = @_;
    my %Data = %{$Param{MoveQueues}};
    my %MoveQueues = %Data;
    my %UsedData = ();
    my %UserHash = ();
    my @OldQueue = @{$Param{OldQueue}};
    my $LatestQueueID = '';
    if ($#OldQueue >= 1) {
        $LatestQueueID = $OldQueue[$#OldQueue-1] || '';
    }
    if ($Param{OldUser}) {
        my $Counter = 0;
        foreach my $User (reverse @{$Param{OldUser}}) {
          if ($Counter) {
            if (!$UserHash{$User->{UserID}}) {
                $UserHash{$User->{UserID}} = "$Counter: $User->{UserLastname} ".
                  "$User->{UserFirstname} ($User->{UserLogin})";
            }
          }
          $Counter++;
        }
    }
    if (!%UserHash) {
        $UserHash{''} = '-';
    }
    # build string
    $Param{'OldUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%UserHash,
        SelectedID => $Param{OldUser}->[0]->{UserID}.'1',
        Name => 'OldUserID',
        OnClick => "change_selected(2)",
    );
    # add suffix for correct sorting
    foreach (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
        $Data{$_} .= '::';
    }
    # build a href stuff
    foreach my $ID (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
        $Data{$ID} =~ s/^(.*)::/$1/;
        my @Queue = split(/::/, $Data{$ID});
        $UsedData{$Data{$ID}} = 1;
        my $UpQueue = $Data{$ID};
        $UpQueue =~ s/^(.*)::.+?$/$1/g;
        $Queue[$#Queue] = $Self->{LayoutObject}->Ascii2Html(Text => $Queue[$#Queue], Max => 50-$#Queue);
        my $Space = '|';
        if ($#Queue == 0) {
            $Space .= '--';
        }
        for (my $i = 0; $i < $#Queue; $i++) {
#            $Space .= '&nbsp;&nbsp;&nbsp;&nbsp;';
            if ($#Queue == 1) {
                $Space .= '&nbsp;&nbsp;&nbsp;&nbsp;|--';
            }
            elsif ($#Queue == 2 && $i == $#Queue-1) {
                my $Hit = 0;
                foreach (keys %Data) {
                    my @Queue = split(/::/, $Data{$_});
                    my $QueueName = '';
                    for (my $i = 0; $i < $#Queue-1; $i++) {
                        if (!$QueueName) {
                            $QueueName .= $Queue[$i].'::';
                        }
#                        else {
#                            $QueueName .= '::'.$Queue[$i];
#                        }
                    }
#                    my $SecondLevel = $Queue[0].'::'.$Queue[1];
#print STDERR "$Data{$ID} ($QueueName) $#Queue--\n";
                    if ($#Queue == 1 && $QueueName && $Data{$ID} =~ /^$QueueName/) {
#print STDERR "sub queue of $Data{$ID} ($QueueName) exists\n";
                        $Hit = 1;
                    }
                }
                if ($Hit) {
                    $Space .= '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|--';
                }
                else {
                    $Space .= '&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;|--';
                }
            }
        }
        if ($UsedData{$UpQueue}) {
#         $Param{MoveQueuesStrg} .= "$Space<a href=\"$Self->{Baselink}Action=AgentMove&TicketID=$Param{TicketID}&DestQueueID=$ID\">".
#                $Queue[$#Queue].'</a><br>';
         $Param{MoveQueuesStrg} .= "$Space<a href=\"\" onclick=\"document.compose.DestQueueID.value='$ID'; document.compose.submit(); return false;\">".
                 $Queue[$#Queue].'</a>';
            if ($LatestQueueID eq $ID) {
                $Param{MoveQueuesStrg} .= '  <font color="red">--&gt; $Text{"Latest Queue!"} &lt;--</font>';
            }
            $Param{MoveQueuesStrg} .= '<br>';
        }
        delete $Data{$ID};
    }
    # --
    # build next states string
    # --
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NewStateID',
        SelectedID => $Self->{NewStateID},
    );
    # --
    # build owner string
    # --
    $Param{'OwnerStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
#        Data => $Param{OwnerList},
        Data => $Self->_GetUsers(QueueID => $Self->{DestQueueID}, AllUsers => $Self->{AllUsers}),
#        Selected => $Param{OwnerID},
        Name => 'NewUserID',
#       Size => 5,
        OnClick => "change_selected(0)",
    );
    if ($LatestQueueID && $MoveQueues{$LatestQueueID}) {
        $Param{LatestQueue} = '$Text{"Latest Queue!"} "'.$MoveQueues{$LatestQueueID}.'"';
    }
    $Param{MoveQueuesStrg} = $Self->{LayoutObject}->AgentQueueListOption(
            Data => { %MoveQueues, '' => '-' },
            Multiple => 0,
            Size => 0,
            Name => 'DestQueueID',
            SelectedID => $Self->{DestQueueID},
            OnChangeSubmit => 0,
            OnChange => "document.compose.ExpandQueueUsers.value='3'; document.compose.submit(); return false;",
        );

    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentMove', Data => \%Param);
}
# --
sub _GetUsers {
    my $Self = shift;
    my %Param = @_;
    # get users
    my %ShownUsers = $Self->{UserObject}->UserList(
        Type => 'Long',
        Valid => 1,
    );
    # just show only users with selected custom queue
    if ($Param{QueueID} && !$Param{AllUsers}) {
        my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(%Param);
        foreach (keys %ShownUsers) {
            my $Hit = 0;
            foreach my $UID (@UserIDs) {
                if ($UID eq $_) {
                    $Hit = 1;
                }
            }
            if (!$Hit) {
                delete $ShownUsers{$_};
            }
        }
    }
    $ShownUsers{''} = '-';
    return \%ShownUsers;
}
# --
1;
