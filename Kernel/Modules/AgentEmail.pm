# --
# Kernel/Modules/AgentEmail.pm - to compose inital email to customer 
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentEmail.pm,v 1.5 2004-02-26 21:43:10 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentEmail;

use strict;
use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::CheckItem;
use Kernel::System::State;
use Mail::Address;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
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
        $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Compose Email');
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
            my %TicketFreeText = $Self->{LayoutObject}->AgentFreeText(
                $Self->{UserObject}->GetUserData(
                    UserID => $Self->{UserID}, 
                    Cached => 1,
                ),
            );
            # html output
            $Output .= $Self->_MaskEmailNew(
              QueueID => $Self->{QueueID},
              NextStates => $Self->_GetNextStates(),
              Priorities => $Self->_GetPriorities(), 
              Users => $Self->_GetUsers(),
              From => $Self->_GetTos(),
              To => '',
              Subject => '', 
              Body => $Self->{ConfigObject}->Get('EmailDefaultNoteText'), 
              CustomerID => '', 
              CustomerUser =>  '',
              CustomerData => '',
              %TicketFreeText,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
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
                Key => 'EmailDefaultNewLock', 
                Value => $Lock,
            ); 
        }
        if ($NewUserID) {
            $Self->{ConfigObject}->Set(
                Key => 'EmailDefaultNewLock', 
                Value => 'lock',
            ); 
        }
        my $Dest = $Self->{ParamObject}->GetParam(Param => 'Dest') || '';
        my ($NewQueueID, $From) = split(/\|\|/, $Dest); 
        my $AllUsers = $Self->{ParamObject}->GetParam(Param => 'AllUsers') || '';
        if (!$NewQueueID) {
            $AllUsers = 1;
        }
        my $To = $Self->{ParamObject}->GetParam(Param => 'To') || '';
        my $Cc = $Self->{ParamObject}->GetParam(Param => 'Cc') || '';
        my $Bcc = $Self->{ParamObject}->GetParam(Param => 'Bcc') || '';
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
                Search => $To.'*',
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
                $To = $Param{CustomerUserListLast};
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
                $To = '';
                $CustomerID = '';
                $Param{"ToOptions"} = \%CustomerUserList;
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
                $To = $CustomerUserList{$_};
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
        if ($Self->{ConfigObject}->Get('ShowCustomerInfoCompose')) {
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
        foreach my $Email (Mail::Address->parse($To)) {
            if (!$Self->{CheckItemObject}->CheckEmail(Address => $Email->address())) {
                $Error{"To invalid"} .= $Self->{CheckItemObject}->CheckError();
            }
        }
        if (!$To && $ExpandCustomerName != 1 && $ExpandCustomerName == 0) {
            $Error{"To invalid"} = 'invalid';
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
            $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Compose Email');
            my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
            $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
            # --
            # html output
            # --
            $Output .= $Self->_MaskEmailNew(
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
              From => $Self->_GetTos(),
              FromSelected => $Dest,
              To => $To,
              ToOptions => $Param{"ToOptions"},
              Cc => $Cc,
              Bcc => $Bcc,
              Subject => $Subject,
              Body => $Text,
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
        # get sender queue from
        my %Queue = $Self->{QueueObject}->GetSystemAddress(QueueID => $NewQueueID);
        # get attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'file_upload',
            Source => 'string',
        );
        # prepare subject
        my $TicketHook = $Self->{ConfigObject}->Get('TicketHook') || '';
        my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
        $Subject = "[$TicketHook: $Tn] $Subject";
        # prepare body
        my $Signature = $Self->{QueueObject}->GetSignature(QueueID => $NewQueueID);
        $Signature =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
        $Signature =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;
        $Signature =~ s/<OTRS_USER_ID>/$Self->{UserID}/g;
        $Signature =~ s/<OTRS_USER_LOGIN>/$Self->{UserLogin}/g;
        $Text .= "\n".$Signature;
        # send email
        my $ArticleID = $Self->{TicketObject}->SendArticle(
            Attach => [\%UploadStuff],
            ArticleType => 'email-external',
            SenderType => 'agent',
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('EmailDefaultNewArticleType'),
            SenderType => $Self->{ConfigObject}->Get('EmailDefaultNewSenderType'),
            From => "$Queue{RealName} <$Queue{Email}>",
            To => $To,
            Cc => $Cc,
            Bcc => $Bcc,
            Subject => $Subject,
            Body => $Text,
            Charset => $Self->{LayoutObject}->{UserCharset},
            UserID => $Self->{UserID},
            HistoryType => $Self->{ConfigObject}->Get('EmailDefaultNewHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('EmailDefaultNewHistoryComment'),
        );
        if ($ArticleID) {
          # set lock (get lock type)
          $Self->{TicketObject}->SetLock(
              TicketID => $TicketID,
              Lock => $Self->{ConfigObject}->Get('EmailDefaultNewLock'),
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
          my $NextScreen = $Self->{UserCreateNextMask} || $Self->{ConfigObject}->Get('PreferencesGroups')->{CreateNextMask}->{DataSelected} || 'AgentEmail';
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
        Type => 'EmailDefaultNext',
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
sub _MaskEmailNew {
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
        Selected => $Param{NextState} || $Self->{ConfigObject}->Get('EmailDefaultNewNextState'),
    );
    # build from string
    if ($Param{ToOptions} && %{$Param{ToOptions}}) {
      $Param{'CustomerUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{ToOptions},
        Name => 'CustomerUser',
        Max => 70,
      ).'<br>$Env{"Box0"}<a href="" onclick="document.compose.ExpandCustomerName.value=\'2\'; document.compose.submit(); return false;" onmouseout="window.status=\'\';" onmouseover="window.status=\'$Text{"Take this User"}\'; return true;">$Text{"Take this User"}</a>$Env{"Box1"}';
    }
    # build so string
    my %NewTo = ();
    if ($Param{From}) {
        foreach (keys %{$Param{From}}) {
             $NewTo{"$_||$Param{From}->{$_}"} = $Param{From}->{$_};
        }
    }
    if ($Self->{ConfigObject}->Get('PhoneViewSelectionType') eq 'Queue') {
        $Param{'FromStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
            Data => \%NewTo,
            Multiple => 0,
            Size => 0,
            Name => 'Dest',
            SelectedID => $Param{FromSelected},
            OnChangeSubmit => 0,
            OnChange => "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
        );
    }
    else {
        $Param{'FromStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%NewTo,
            Name => 'Dest',
            SelectedID => $Param{FromSelected},
            OnChange => "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
        );
    }
    # customer info string 
    $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
        Data => $Param{CustomerData},
        Max => $Self->{ConfigObject}->Get('ShowCustomerInfoComposeMaxSize'),
    );
    # do html quoting
    foreach (qw(From To Cc Bcc)) {
        $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_}) || '';
    }
    # build priority string
    if (!$Param{PriorityID}) {
        $Param{Priority} = $Self->{ConfigObject}->Get('EmailDefaultPriority');
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
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentEmailNew', Data => \%Param);
}
# --
1;
