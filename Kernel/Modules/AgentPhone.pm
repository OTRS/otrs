# --
# Kernel/Modules/AgentPhone.pm - to handle phone calls
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPhone.pm,v 1.53 2004-01-20 00:02:27 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPhone;

use strict;
use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::CheckItem;
use Kernel::System::State;
use Mail::Address;

use vars qw($VERSION);
$VERSION = '$Revision: 1.53 $';
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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject 
       ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

    $Self->{SystemAddress} = Kernel::System::SystemAddress->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    
    if (!$Self->{Subaction} || $Self->{Subaction} eq 'Created') {
        # header
        $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Phone call');
        # if there is no ticket id!
        if (!$Self->{TicketID} || ($Self->{TicketID} && $Self->{Subaction} eq 'Created')) {
            # navigation bar
            my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
            $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
            # notify info
            if ($Self->{TicketID}) {
                my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $Self->{TicketID});
                $Output .= $Self->{LayoutObject}->Notify(Info => '<a href="$Env{"Baselink"}Action=AgentZoom&TicketID='.$Ticket{TicketID}.'">Ticket "%s" created!", "'.$Ticket{TicketNumber}).'</a>';
            }
            # --
            # get split article if given
            # --
            # get ArticleID
            my $ArticleID = $Self->{ParamObject}->GetParam(Param => 'ArticleID'); 
            my %Article = ();
            my %CustomerData = ();
            if ($ArticleID) {
                %Article = $Self->{TicketObject}->GetArticle(ArticleID => $ArticleID);
                my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
                $Article{Subject} =~ s/\[${TicketHook}:\s*\d+\](\s|)//;
                # check if original content isn't text/plain or text/html, don't use it
                if ($Article{'ContentType'}) {
                    if($Article{'ContentType'} =~ /text\/html/i) {
                        $Article{Body} =~ s/\<.+?\>//gs;
                    }
                    elsif ($Article{'ContentType'} !~ /text\/plain/i) {
                        $Article{Body} = "-> no quotable message <-";
                    }
                }
                # show customer info
                if ($Self->{ConfigObject}->Get('ShowCustomerInfoPhone')) {
                  if ($Article{CustomerUserID}) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                         User => $Article{CustomerUserID},
                    );
                  }
                  elsif ($Article{CustomerID}) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        CustomerID => $Article{CustomerID},
                    );
                  }
                }
            }
            my %TicketFreeText = $Self->{LayoutObject}->AgentFreeText();
            # html output
            $Output .= $Self->_MaskPhoneNew(
              QueueID => $Self->{QueueID},
              NextStates => $Self->_GetNextStates(),
              Priorities => $Self->_GetPriorities(), 
              Users => $Self->_GetUsers(),
              To => $Self->_GetTos(),
              From => $Article{From},
              Subject => $Article{Subject} || '$Config{"PhoneDefaultNewSubject"}',
              Body => $Article{Body} || '$Text{"$Config{"PhoneDefaultNewNoteText"}"}',
              CustomerID => $Article{CustomerID},
              CustomerUser => $Article{CustomerUserID},
              CustomerData => \%CustomerData,
              %TicketFreeText,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # get ticket info if ticket id is given
        my %TicketData = $Self->{TicketObject}->GetTicket(TicketID => $Self->{TicketID});
        # check it it's a agent-customer ticket
        if ($Self->{ConfigObject}->Get('AgentCanBeCustomer') && $TicketData{CustomerUserID} && $TicketData{CustomerUserID} eq $Self->{UserLogin}) {
            # redirect for agent follow up screen
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentCustomerFollowUp&TicketID=$Self->{TicketID}",
            );
        }
        # check permissions if it's a existing ticket
        if (!$Self->{TicketObject}->Permission(
            Type => 'phone',
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID})) {
            # error screen, don't show ticket
            return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
        }
        # get ticket info
        my $Tn = $TicketData{TicketNumber};
        my %CustomerData = ();
        if ($Self->{ConfigObject}->Get('ShowCustomerInfoPhone')) {
            if ($TicketData{CustomerUserID}) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $TicketData{CustomerUserID},
                );
            }
            elsif ($TicketData{CustomerID}) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    CustomerID => $TicketData{CustomerID},
                );
            }
        }
        # get lock state && permissions
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
            UserID => $Self->{UserID},
          )) {
            # show lock state
            $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $Self->{TicketID});
          }
        }
        else {
          my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->CheckOwner(
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
        # print form ...
        $Output .= $Self->_MaskPhone(
            TicketID => $Self->{TicketID},
            QueueID => $Self->{QueueID},
            TicketNumber => $Tn,
            NextStates => $Self->_GetNextStates(),
            CustomerData => \%CustomerData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # save new phone article to existing ticket
    elsif ($Self->{Subaction} eq 'Store') {
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Note!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Body');
        my $NextStateID = $Self->{ParamObject}->GetParam(Param => 'NextStateID') || '';
        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
            ID => $NextStateID, 
        );
        my $NextState = $StateData{Name};
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $Answered = $Self->{ParamObject}->GetParam(Param => 'Answered') || '';
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || 0;
        my %GetParam = ();
        foreach (qw(Year Month Day Hour Minute)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $Self->{TicketID},
            ArticleType => $Self->{ConfigObject}->Get('PhoneDefaultArticleType'),
            SenderType => $Self->{ConfigObject}->Get('PhoneDefaultSenderType'),
            From => $Self->{UserLogin},
            To => $Self->{UserLogin},
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => $Self->{ConfigObject}->Get('PhoneDefaultHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('PhoneDefaultHistoryComment'),
        )) {
          # time accounting
          if ($TimeUnits) {
            $Self->{TicketObject}->AccountTime(
              TicketID => $Self->{TicketID},
              ArticleID => $ArticleID,
              TimeUnit => $TimeUnits,
              UserID => $Self->{UserID},
            );
          }
          # set state
          $Self->{TicketObject}->SetState(
            TicketID => $Self->{TicketID},
            ArticleID => $ArticleID,
            State => $NextState,
            UserID => $Self->{UserID},
          );
          # set answerd
          $Self->{TicketObject}->SetAnswered(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
            Answered => $Answered,
         );
         # should i set an unlock? yes if the ticket is closed
         my %StateData = $Self->{StateObject}->StateGet(ID => $NextStateID);
         if ($StateData{TypeName} =~ /^close/i) {
             $Self->{TicketObject}->SetLock(
                 TicketID => $Self->{TicketID},
                 Lock => 'unlock',
                 UserID => $Self->{UserID},
             );
         }
         # set pending time if next state is a pending state
         elsif ($StateData{TypeName} =~ /^pending/i) {
             $Self->{TicketObject}->SetPendingTime(
                 UserID => $Self->{UserID},
                 TicketID => $Self->{TicketID},
                 %GetParam,
             );
         }
         # redirect to last screen (e. g. zoom view) and to queue view if 
         # the ticket is closed (move to the next task).
         if ($StateData{TypeName} =~ /^close/i) {
             return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenQueue});
         }
         else {
             return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
         }
      }
      else {
        # show error of creating article
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
      }
    }
    # create new ticket and article
    elsif ($Self->{Subaction} eq 'StoreNew') {
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || '';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Body') || '';
        my $NextStateID = $Self->{ParamObject}->GetParam(Param => 'NextStateID') || '';
        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
            ID => $NextStateID,
        );
        my $NextState = $StateData{Name};
        my $PriorityID = $Self->{ParamObject}->GetParam(Param => 'PriorityID') || '';
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $NewUserID = $Self->{ParamObject}->GetParam(Param => 'NewUserID') || '';
        my $Lock = $Self->{ParamObject}->GetParam(Param => 'Lock') || '';
        if ($Lock) {
            $Self->{ConfigObject}->Set(
                Key => 'PhoneDefaultNewLock', 
                Value => $Lock,
            ); 
        }
        if ($NewUserID) {
            $Self->{ConfigObject}->Set(
                Key => 'PhoneDefaultNewLock', 
                Value => 'lock',
            ); 
        }
        my $Dest = $Self->{ParamObject}->GetParam(Param => 'Dest') || '';
        my ($NewQueueID, $To) = split(/\|\|/, $Dest); 
        my $AllUsers = $Self->{ParamObject}->GetParam(Param => 'AllUsers') || '';
        if (!$NewQueueID) {
            $AllUsers = 1;
        }
        my $From = $Self->{ParamObject}->GetParam(Param => 'From') || '';
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || '';
        my $CustomerUser = $Self->{ParamObject}->GetParam(Param => 'CustomerUser') || '';
        my $SelectedCustomerUser = $Self->{ParamObject}->GetParam(Param => 'SelectedCustomerUser') || '';
        my $ExpandCustomerName = $Self->{ParamObject}->GetParam(Param => 'ExpandCustomerName') || 0;
        my $CustomerID = $Self->{ParamObject}->GetParam(Param => 'CustomerID') || '';
        my %TicketFree = ();
        foreach (1..8) {
            $TicketFree{"TicketFreeKey$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeKey$_");
            $TicketFree{"TicketFreeText$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeText$_");
        }
        my %TicketFreeText = $Self->{LayoutObject}->AgentFreeText(%TicketFree);
        my %GetParam = ();
        foreach (qw(Year Month Day Hour Minute)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        my %Error = ();
        # Expand Customer Name
        my %CustomerUserData = ();
        if ($ExpandCustomerName == 1) {
            # search customer 
            my %CustomerUserList = ();
            %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                Search => $From.'*',
            );
            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            foreach (keys %CustomerUserList) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast} = $CustomerUserList{$_};
                $Param{CustomerUserListLastUser} = $_;
            }
            if ($Param{CustomerUserListCount} == 1) {
                $From = $Param{CustomerUserListLast};
                $Error{"ExpandCustomerName"} = 1;
                my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $Param{CustomerUserListLastUser},
                );
                if ($CustomerUserData{UserCustomerID}) {
                    $CustomerID = $CustomerUserData{UserCustomerID};
                } 
                if ($CustomerUserData{UserLogin}) {
                    $CustomerUser = $CustomerUserData{UserLogin};
                } 
            }
            # if more the one customer user exists, show list
            # and clean CustomerUserID and CustomerID
            else {
                $From = '';
                $CustomerID = '';
                $Param{"FromOptions"} = \%CustomerUserList;
                $Error{"ExpandCustomerName"} = 1;
            }
        }
        # get from and customer id if customer user is given
        elsif ($ExpandCustomerName == 2) {
            %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CustomerUser,
            );
            my %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                UserLogin => $CustomerUser,
            );
            foreach (keys %CustomerUserList) {
                $From = $CustomerUserList{$_};
            }
            if ($CustomerUserData{UserCustomerID}) {
                $CustomerID = $CustomerUserData{UserCustomerID};
            } 
            if ($CustomerUserData{UserLogin}) {
                $CustomerUser = $CustomerUserData{UserLogin};
            } 
            $Error{"ExpandCustomerName"} = 1;
        }
        # if a new destination queue is selected
        elsif ($ExpandCustomerName == 3) {
            $Error{NoSubmit} = 1;
            $CustomerUser = $SelectedCustomerUser;
        }
        # --
        # show customer info
        # --
        my %CustomerData = ();
        if ($Self->{ConfigObject}->Get('ShowCustomerInfoPhone')) {
            if ($CustomerUser) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $CustomerUser,
                ); 
            }
            elsif ($CustomerID) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    CustomerID => $CustomerID,
                );
            }
        }
        # --
        # check some values
        # --
        foreach my $Email (Mail::Address->parse($From)) {
            if (!$Self->{CheckItemObject}->CheckEmail(Address => $Email->address())) {
                $Error{"From invalid"} .= $Self->{CheckItemObject}->CheckError();
            }
        }
        if (!$From && $ExpandCustomerName != 1 && $ExpandCustomerName == 0) {
            $Error{"From invalid"} = 'invalid';
        }
        if (!$Subject && $ExpandCustomerName == 0) {
            $Error{"Subject invalid"} = 'invalid';
        }
        if (!$NewQueueID && $ExpandCustomerName == 0) {
            $Error{"Destination invalid"} = 'invalid';
        }
        if (%Error) {
            # --
            # header
            # --
            $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Phone call');
            my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
            $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
            # --
            # html output
            # --
            $Output .= $Self->_MaskPhoneNew(
              QueueID => $Self->{QueueID},
              Users => $Self->_GetUsers(QueueID => $NewQueueID, AllUsers => $AllUsers),
              UserSelected => $NewUserID,
              NextStates => $Self->_GetNextStates(),
              NextState => $NextState,
              Priorities => $Self->_GetPriorities(),
              PriorityID => $PriorityID,
              CustomerID => $CustomerID,
              CustomerUser => $CustomerUser,
              CustomerData => \%CustomerData,
              TimeUnits => $TimeUnits,
              From => $From,
              FromOptions => $Param{"FromOptions"},
              Body => $Text,
              To => $Self->_GetTos(),
              ToSelected => $Dest,
              Subject => $Subject,
              Errors => \%Error,
              %GetParam,
              %TicketFreeText,
            );
            # show customer tickets
            my @TicketIDs = ();
            if ($CustomerID) {
                @TicketIDs = $Self->{TicketObject}->GetCustomerTickets(
                    UserID => $Self->{UserID}, 
                    CustomerID => $CustomerID, 
                );
            }
            foreach my $TicketID (@TicketIDs) {
                my %Article = $Self->{TicketObject}->GetLastCustomerArticle(TicketID => $TicketID);
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'TicketViewLite',
                    Data => {
                        %Article,
                        Age => $Self->{LayoutObject}->CustomerAge(Age => $Article{Age}, Space => ' '),
                    }
                );
            }
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->CreateTicketDB(
            QueueID => $NewQueueID,
            Lock => 'unlock',
            # FIXME !!!
            GroupID => 1,
            StateID => $NextStateID,
            PriorityID => $PriorityID,
            UserID => $Self->{UserID},
            CustomerNo => $CustomerID, 
            CustomerUser => $SelectedCustomerUser,
            CreateUserID => $Self->{UserID},
        );
        # set ticket free text
        foreach (1..8) {
            if (defined($TicketFree{"TicketFreeKey$_"})) {
                $Self->{TicketObject}->SetTicketFreeText(
                    TicketID => $TicketID,
                    Key => $TicketFree{"TicketFreeKey$_"}, 
                    Value => $TicketFree{"TicketFreeText$_"},
                    Counter => $_,
                    UserID => $Self->{UserID},
                );
            }
        }
        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ($NewUserID) {
            $NoAgentNotify = 1;
        }
        if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            NoAgentNotify => $NoAgentNotify,
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('PhoneDefaultNewArticleType'),
            SenderType => $Self->{ConfigObject}->Get('PhoneDefaultNewSenderType'),
            From => $From,
            To => $To,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => $Self->{ConfigObject}->Get('PhoneDefaultNewHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('PhoneDefaultNewHistoryComment'),
            AutoResponseType => 'auto reply',
            OrigHeader => {
              From => $From,
              To => $To,
              Subject => $Subject,
              Body => $Text,
            },
            Queue => $Self->{QueueObject}->QueueLookup(QueueID => $NewQueueID),
        )) {
          # set lock (get lock type)
          $Self->{TicketObject}->SetLock(
              TicketID => $TicketID,
              Lock => $Self->{ConfigObject}->Get('PhoneDefaultNewLock'),
              UserID => $Self->{UserID},
          );
          # set owner (if new user id is given)
          if ($NewUserID) {
              $Self->{TicketObject}->SetOwner(
                  TicketID => $TicketID, 
                  NewUserID => $NewUserID,
                  UserID => $Self->{UserID},
              );
          }
          # time accounting
          if ($TimeUnits) {
              $Self->{TicketObject}->AccountTime(
                  TicketID => $TicketID,
                  ArticleID => $ArticleID,
                  TimeUnit => $TimeUnits,
                  UserID => $Self->{UserID},
              );
          }
          # should i set an unlock?
          my %StateData = $Self->{StateObject}->StateGet(ID => $NextStateID);
          if ($StateData{TypeName} =~ /^close/i) {
              $Self->{TicketObject}->SetLock(
                  TicketID => $TicketID,
                  Lock => 'unlock',
                  UserID => $Self->{UserID},
              );
          }
          # set pending time
          elsif ($StateData{TypeName} =~ /^pending/i) {
              $Self->{TicketObject}->SetPendingTime(
                  UserID => $Self->{UserID},
                  TicketID => $TicketID,
                  %GetParam,
              );
          }
          # get redirect screen
          my $NextScreen = $Self->{UserPhoneNextMask} || $Self->{ConfigObject}->Get('PreferencesGroups')->{PhoneNextMask}->{DataSelected};
          # redirect
          return $Self->{LayoutObject}->Redirect(
            OP => "Action=$NextScreen&Subaction=Created&TicketID=$TicketID",
          );
      }
      else {
          $Output = $Self->{LayoutObject}->Header(Title => 'Error');
          $Output .= $Self->{LayoutObject}->Error();
          $Output .= $Self->{LayoutObject}->Footer();
          return $Output;
      }
    }
    else {
        $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub _GetNextStates {
    my $Self = shift;
    my %Param = @_;
    my %NextStates = $Self->{StateObject}->StateGetStatesByType(
        Type => 'PhoneDefaultNext',
        Result => 'HASH',
    );
    return \%NextStates;
}
# --
sub _GetUsers {
    my $Self = shift;
    my %Param = @_;
    # get users 
    my %ShownUsers = ();
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type => 'Long',
        Valid => 1,
    );
    # just show only users with selected custom queue
    if ($Param{QueueID} && !$Param{AllUsers}) {
        my @UserIDs = $Self->{QueueObject}->GetAllUserIDsByQueueID(%Param);
        foreach (keys %AllGroupsMembers) {
            my $Hit = 0;
            foreach my $UID (@UserIDs) {
                if ($UID eq $_) {
                    $Hit = 1;
                }
            }
            if (!$Hit) {
                delete $AllGroupsMembers{$_};
            }
        }
    }
    # check show users
    if ($Self->{ConfigObject}->Get('ChangeOwnerToEveryone')) {
        %ShownUsers = %AllGroupsMembers;
    }
    else {
        my %Groups = $Self->{GroupObject}->GroupMemberList(
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
    return \%ShownUsers;
}
# --
sub _GetPriorities {
    my $Self = shift;
    my %Param = @_;
    # -- 
    # get priority
    # --
    my %Priorities = $Self->{DBObject}->GetTableData(
        What => 'id, name',
        Table => 'ticket_priority',
    );
    return \%Priorities;
}
# --
sub _GetTos {
    my $Self = shift;
    my %Param = @_;
    # check own selection
    my %NewTos = ();
    if ($Self->{ConfigObject}->{PhoneViewOwnSelection}) {
        %NewTos = %{$Self->{ConfigObject}->{PhoneViewOwnSelection}};
    }
    else {
        # SelectionType Queue or SystemAddress?    
        my %Tos = ();
        if ($Self->{ConfigObject}->Get('PhoneViewSelectionType') eq 'Queue') {
            %Tos = $Self->{QueueObject}->GetAllQueues();
        }
        else {
            %Tos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
        }
        # get create permission queues
        my %UserGroups = $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID}, 
            Type => 'create', 
            Result => 'HASH',
        );
        foreach (keys %Tos) {
            if ($UserGroups{$Self->{QueueObject}->GetQueueGroupID(QueueID => $_)}) {
                $NewTos{$_} = $Tos{$_};
            }
        }
        # build selection string
        foreach (keys %NewTos) {
            my %QueueData = $Self->{QueueObject}->QueueGet(ID => $_);
            my $Srting = $Self->{ConfigObject}->Get('PhoneViewSelectionString') || '<Realname> <<Email>> - Queue: <Queue>';
            $Srting =~ s/<Queue>/$QueueData{Name}/g;
            $Srting =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ($Self->{ConfigObject}->Get('PhoneViewSelectionType') ne 'Queue') {
                my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet(ID => $NewTos{$_});
                $Srting =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $Srting =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$_} = $Srting;
        }
    }
    # adde empty selection
    $NewTos{''} = '-';
    return \%NewTos;
}
# --
sub _MaskPhone {
    my $Self = shift;
    my %Param = @_;
    # answered strg
    $Param{'AnsweredYesNoOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Self->{ConfigObject}->Get('YesNoOptions'),
        Name => 'Answered',
        Selected => 'Yes',
    );
    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NextStateID',
        Selected => $Self->{ConfigObject}->Get('PhoneDefaultNextState'),
    );
    # customer info string 
    $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
        Data => $Param{CustomerData},
        Max => $Self->{ConfigObject}->Get('ShowCustomerInfoPhoneMaxSize'),
    );
    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param, 
        Format => 'DateInputFormatLong',
        DiffTime => $Self->{ConfigObject}->Get('PendingDiffTime') || 0,
    );
    # prepare errors!
    if ($Param{Errors}) {
        foreach (keys %{$Param{Errors}}) {
            $Param{$_} = "* ".$Self->{LayoutObject}->Ascii2Html(Text => $Param{Errors}->{$_});
        }
    }
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentPhone', Data => \%Param);
}
# --
sub _MaskPhoneNew {
    my $Self = shift;
    my %Param = @_;
    # build string
    $Param{Users}->{''} = '-';
    $Param{'OptionStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{Users},
        SelectedID => $Param{UserSelected},
        Name => 'NewUserID',
    );
    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NextStateID',
        Selected => $Param{NextState} || $Self->{ConfigObject}->Get('PhoneDefaultNewNextState'),
    );
    # build from string
    if ($Param{FromOptions} && %{$Param{FromOptions}}) {
      $Param{'CustomerUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{FromOptions},
        Name => 'CustomerUser',
        Max => 70,
      ).'<br>$Env{"Box0"}<a href="" onclick="document.compose.ExpandCustomerName.value=\'2\'; document.compose.submit(); return false;" onmouseout="window.status=\'\';" onmouseover="window.status=\'$Text{"Take this User"}\'; return true;">$Text{"Take this User"}</a>$Env{"Box1"}';
    }
    # build so string
    my %NewTo = ();
    if ($Param{To}) {
        foreach (keys %{$Param{To}}) {
             $NewTo{"$_||$Param{To}->{$_}"} = $Param{To}->{$_};
        }
    }
    if ($Self->{ConfigObject}->Get('PhoneViewSelectionType') eq 'Queue') {
        $Param{'ToStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
            Data => \%NewTo,
            Multiple => 0,
            Size => 0,
            Name => 'Dest',
            SelectedID => $Param{ToSelected},
            OnChangeSubmit => 0,
            OnChange => "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
        );
    }
    else {
        $Param{'ToStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%NewTo,
            Name => 'Dest',
            SelectedID => $Param{ToSelected},
            OnChange => "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
        );
    }
    # customer info string 
    $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
        Data => $Param{CustomerData},
        Max => $Self->{ConfigObject}->Get('ShowCustomerInfoPhoneMaxSize'),
    );
    # do html quoting
    foreach (qw(From To Cc)) {
        $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_}) || '';
    }
    # build priority string
    if (!$Param{PriorityID}) {
        $Param{Priority} = $Self->{ConfigObject}->Get('PhoneDefaultPriority');
    }
    $Param{'PriorityStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{Priorities},
        Name => 'PriorityID',
        SelectedID => $Param{PriorityID},
        Selected => $Param{Priority},
    );
    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format => 'DateInputFormatLong',
        DiffTime => $Self->{ConfigObject}->Get('PendingDiffTime') || 0,
    );
    # prepare errors!
    if ($Param{Errors}) {
        foreach (keys %{$Param{Errors}}) {
            $Param{$_} = "* ".$Self->{LayoutObject}->Ascii2Html(Text => $Param{Errors}->{$_});
        }
    }
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentPhoneNew', Data => \%Param);
}
# --
1;
