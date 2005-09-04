# --
# Kernel/Modules/AgentTicketOwner.pm - to set the ticket owner
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketOwner.pm,v 1.4 2005-09-04 13:17:47 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketOwner;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.4 $';
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
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }

    # get params
    $Self->{NewUserID} = $Self->{ParamObject}->GetParam(Param => 'NewUserID') || '';
    $Self->{OldUserID} = $Self->{ParamObject}->GetParam(Param => 'OldUserID') || '';
    $Self->{UserSelection} = $Self->{ParamObject}->GetParam(Param => 'UserSelection') || '';

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => 'owner',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }


    # get params
    my %GetParam = ();
    foreach (qw(NewStateID Comment Year Month Day Hour Minute)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
    }

    if ($Self->{Subaction} eq 'Update') {
        # check new/old user selection
        if ($Self->{UserSelection} eq 'Old') {
            if (!$Self->{OldUserID}) {
                $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, you need to select a previous owner!",
                    Comment => 'Please go back and select one.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{NewUserID} = $Self->{OldUserID};
            }
        }
        else {
            if (!$Self->{NewUserID}) {
                $Output = $Self->{LayoutObject}->Header();
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, you need to select a new owner!",
                    Comment => 'Please go back and select one.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
        }
        # lock ticket && set user id && send notify to new agent
        if ($Self->{TicketObject}->LockSet(
          TicketID => $Self->{TicketID},
          Lock => 'lock',
          UserID => $Self->{UserID},
        ) &&
          $Self->{TicketObject}->OwnerSet(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
            NewUserID => $Self->{NewUserID},
            Comment => $GetParam{Comment},
		)) {
            # add note
            if ($GetParam{Comment}) {
              my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID => $Self->{TicketID},
                ArticleType => 'note-internal',
                SenderType => 'agent',
                From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
                Subject => $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('Ticket::Frontend::OwnerSubject') || '$Text{"Owner Update"}'),
                Body => $GetParam{Comment},
                ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
                UserID => $Self->{UserID},
                HistoryType => 'AddNote',
                HistoryComment => '%%Owner',
                NoAgentNotify => 1, # because of owner updated notify
              );
            }
            if ($Self->{ConfigObject}->Get('Ticket::Frontend::OwnerSetState') && $GetParam{NewStateID}) {
                $Self->{TicketObject}->StateSet(
                    TicketID => $Self->{TicketID},
                    StateID => $GetParam{NewStateID},
                    UserID => $Self->{UserID},
                );
                # unlock the ticket after close
                my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                    ID => $GetParam{NewStateID},
                );
                # set unlock on close
                if ($StateData{TypeName} =~ /^close/i) {
                    $Self->{TicketObject}->LockSet(
                        TicketID => $Self->{TicketID},
                        Lock => 'unlock',
                        UserID => $Self->{UserID},
                    );
                }
                # set pending time
                elsif ($StateData{TypeName} =~ /^pending/i) {
                    $Self->{TicketObject}->TicketPendingTimeSet(
                        UserID => $Self->{UserID},
                        TicketID => $Self->{TicketID},
                        %GetParam,
                    );
                }
            }
          # redirect
          return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
        }
        else {
          return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    else {
        # print form
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
        my $OwnerID = $Self->{TicketObject}->OwnerCheck(TicketID => $Self->{TicketID});
        $Output .= $Self->{LayoutObject}->Header(Value => $Ticket{TicketNumber});
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get user of own groups
        my %ShownUsers = ();
        my %AllGroupsMembers = $Self->{UserObject}->UserList(
            Type => 'Long',
            Valid => 1,
        );
        if ($Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone')) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
            my $GID = $Self->{QueueObject}->GetQueueGroupID(QueueID => $Ticket{QueueID});
            my %MemberList = $Self->{GroupObject}->GroupMemberList(
                GroupID => $GID,
                Type => 'rw',
                Result => 'HASH',
                Cached => 1,
            );
            foreach (keys %MemberList) {
                $ShownUsers{$_} = $AllGroupsMembers{$_};
            }
        }
        # get old owner
        my @OldUserInfo = $Self->{TicketObject}->OwnerList(TicketID => $Self->{TicketID});
        # print change form
        $Output .= $Self->MaskOwner(
            %Ticket,
            OptionStrg => \%ShownUsers,
            OldUser => \@OldUserInfo,
            TicketID => $Self->{TicketID},
            OwnerID => $OwnerID,
            QueueID => $Self->{QueueID},
        );
        $Output .= $Self->{LayoutObject}->Footer();
    }
    return $Output;
}
# --
sub MaskOwner {
    my $Self = shift;
    my %Param = @_;
    # build string
    $Param{'OptionStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{OptionStrg},
        Selected => $Param{OwnerID},
        Name => 'NewUserID',
        Size => 10,
        OnClick => "change_selected(0)",
    );
    my %UserHash = ();
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
#        Size => 10,
    );
    # get next states
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::OwnerSetState')) {
        my %NextStates = $Self->{TicketObject}->StateList(
            Type => 'DefaultNextOwner',
            Action => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
        );
        $NextStates{''} = '-';
        # build next states string
        $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%NextStates,
            Name => 'NewStateID',
            SelectedID => $Param{NewStateID},
        );
        $Param{DateString} = $Self->{LayoutObject}->BuildDateSelection(
            Format => 'DateInputFormatLong',
            DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
            %Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'NextState',
            Data => \%Param,
        );
    }
    # create & return output
    return $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentTicketOwner',
        Data => \%Param,
    );
}
# --
1;
