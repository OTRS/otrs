# --
# Kernel/Modules/AgentOwner.pm - to set the ticket owner
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentOwner.pm,v 1.16 2003-05-13 22:53:09 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentOwner;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
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

    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
   
    # get params    
    $Self->{NewUserID} = $Self->{ParamObject}->GetParam(Param => 'NewUserID') || '';
    $Self->{Comment} = $Self->{ParamObject}->GetParam(Param => 'Comment') || '';

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;

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

    if ($Self->{Subaction} eq 'Update') {
        # --
		# lock ticket && set user id && send notify to new agent
        # --
        if ($Self->{TicketObject}->SetLock(
          TicketID => $Self->{TicketID},
          Lock => 'lock',
          UserID => $Self->{UserID},
        ) &&
          $Self->{TicketObject}->SetOwner(
			TicketID => $Self->{TicketID},
			UserID => $Self->{UserID},
            NewUserID => $Self->{NewUserID},
            Comment => $Self->{Comment},
		)) {
            # --
            # add note
            # --
            if ($Self->{Comment}) {
              my $ArticleID = $Self->{TicketObject}->CreateArticle(
                TicketID => $Self->{TicketID},
                ArticleType => 'note-internal',
                SenderType => 'agent',
                From => $Self->{UserLogin},
                Subject => 'Owner Update',
                Body => $Self->{Comment},
                ContentType => "text/plain; charset=$Self->{'UserCharset'}",
                UserID => $Self->{UserID},
                HistoryType => 'AddNote',
                HistoryComment => 'Note added.',
                NoAgentNotify => 1, # because of owner updated notify
              );
            }
          # --
          # redirect
          # --
          return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
        }
        else {
          $Output = $Self->{LayoutObject}->Header(Title => "Error");
          $Output .= $Self->{LayoutObject}->Error();
          $Output .= $Self->{LayoutObject}->Footer();
          return $Output;
        }
    }
    else {
        # --
        # print form
        # --
        my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $Self->{TicketID});
        my $OwnerID = $Self->{TicketObject}->CheckOwner(TicketID => $Self->{TicketID});
        $Output .= $Self->{LayoutObject}->Header(Title => 'Set Owner');
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        # --
        # get user of own groups
        # --
        my %ShownUsers = ();
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
        # print change form
        # --
	    $Output .= $Self->{LayoutObject}->AgentOwner(
            OptionStrg => \%ShownUsers,
 			TicketID => $Self->{TicketID},
            OwnerID => $OwnerID,
            BackScreen => $Self->{BackScreen},
            NextScreen => $Self->{NextScreen},
            TicketNumber => $Tn,
            QueueID => $Self->{QueueID},
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --

1;
