# --
# Kernel/Modules/AgentMove.pm - move tickets to queues 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentMove.pm,v 1.15.2.1 2003-05-13 15:37:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentMove;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.15.2.1 $';
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

    # get DestQueueID 
    $Self->{DestQueueID} = $Self->{ParamObject}->GetParam(Param => 'DestQueueID');
    $Self->{QueueViewQueueID} = $Self->{ParamObject}->GetParam(Param => 'QueueViewQueueID');
    $Self->{UnlockTicket} = $Self->{ParamObject}->GetParam(Param => 'UnlockTicket');

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
    foreach (qw(TicketID)) {
      if (!$Self->{$_}) {
        # --
        # error page
        # --
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
          Message => "Need $_!",
          Comment => 'Please contact the admin.',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
      }
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'rw',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # --	
    # move queue
    # --
    if (!$Self->{DestQueueID}) {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Move Ticket');
#        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
#        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        # --
        # get lock state && write (lock) permissions
        # --
        if (!$Self->{TicketObject}->IsTicketLocked(TicketID => $Self->{TicketID})) {
            # set owner
            $Self->{TicketObject}->SetOwner(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $Self->{UserID},
            );
            # set lock
            if ($Self->{TicketObject}->SetLock(
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
            $Self->{TicketUnlock} = 0;
            my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->CheckOwner(
                TicketID => $Self->{TicketID},
            );
            if ($OwnerID != $Self->{UserID}) {
                $Output .= $Self->{LayoutObject}->Error(
                    Message => "Sorry, the current owner is $OwnerLogin",
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }
        # --
        # fetch all queues
        # --
        my %MoveQueues = ();
        if ($Self->{ConfigObject}->Get('MoveInToAllQueues')) {
            %MoveQueues = $Self->{QueueObject}->GetAllQueues();
        }
        else {
            %MoveQueues = $Self->{QueueObject}->GetAllQueues(
                UserID => $Self->{UserID},
                Type => 'rw',
            );
        }
        # --
        # get user of own groups
        # --
        my %ShownUsers = ();
        $ShownUsers{''} = '-';
        my %AllGroupsMembers = $Self->{UserObject}->UserList(
            Type => 'Long',
            Valid => 1,
        );
        if ($Self->{ConfigObject}->Get('ChangeOwnerToEveryone')) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my %Groups = $Self->{GroupObject}->GroupUserList(
                UserID => $Self->{UserID},
                Type => 'rw',
                Result => 'HASH',
            );
            foreach (keys %Groups) {
                my %MemberList = $Self->{GroupObject}->GroupMemberList(
                    GroupID => $_,
                    Type => 'rw',
                    Result => 'HASH',
                );
                foreach (keys %MemberList) {
                    $ShownUsers{$_} = $AllGroupsMembers{$_};
                }
            }
        }
        # --
        # build header
        # --
        my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $Self->{TicketID});
        # --
        # get next states
        # --
        my %NextStates = $Self->{StateObject}->StateGetStatesByType(
            Type => 'DefaultNextMove',
            Result => 'HASH',
        );
        $NextStates{''} = '-';
        $Output .= $Self->{LayoutObject}->AgentMove(
            MoveQueues => \%MoveQueues,
            OwnerList => \%ShownUsers,
            TicketID => $Self->{TicketID},
            NextStates => \%NextStates,
            TicketUnlock => $Self->{TicketUnlock},
            %Ticket,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Self->{TicketObject}->MoveByTicketID(
          QueueID => $Self->{DestQueueID},
          UserID => $Self->{UserID},
          TicketID => $Self->{TicketID},
      ) ) {
        # --
        # set state
        # --
        my $NewStateID = $Self->{ParamObject}->GetParam(Param => 'NewStateID') || '';
        if ($Self->{ConfigObject}->{MoveSetState} && $NewStateID) {
            $Self->{TicketObject}->SetState(
                TicketID => $Self->{TicketID},
                StateID => $NewStateID,
                UserID => $Self->{UserID},
            );
        } 
        # --
        # new owner!
        # --
        my $NewUserID= $Self->{ParamObject}->GetParam(Param => 'NewUserID') || '';
        my $Comment = $Self->{ParamObject}->GetParam(Param => 'Comment') || '';
        if ($NewUserID) {
            # lock
            $Self->{TicketObject}->SetLock(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => $Self->{UserID},
            );
            # set owner
            $Self->{TicketObject}->SetOwner(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $NewUserID,
                Comment => $Comment,
            );
        }
        else {
            # unlock
            if ($Self->{UnlockTicket}) {
                $Self->{TicketObject}->SetLock(
                    TicketID => $Self->{TicketID},
                    Lock => 'unlock',
                    UserID => $Self->{UserID},
                );
            }
        }
        if ($Comment) {
            # add note
            my $ArticleID = $Self->{TicketObject}->CreateArticle(
                TicketID => $Self->{TicketID},
                ArticleType => 'note-internal',
                SenderType => 'agent',
                From => $Self->{UserLogin},
                To => $Self->{UserLogin},
                Subject => 'Move Note',
                Body => $Comment,
                ContentType => "text/plain; charset=$Self->{'UserCharset'}",
                UserID => $Self->{UserID},
                HistoryType => 'AddNote',
                HistoryComment => 'Note added.',
            );
        }
        # --
        # redirect 
        # --
        if ($Self->{QueueViewQueueID}) {
             return $Self->{LayoutObject}->Redirect(OP => "QueueID=$Self->{QueueViewQueueID}");
        }
        else {
             return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
        }
    }
    else {
        # error?!
        $Output = $Self->{LayoutObject}->Header(Title => "Error");
	    $Output .= $Self->{LayoutObject}->Error(
          Message => "Can't move TicketID '$Self->{TicketID}'!",
          Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --

1;
