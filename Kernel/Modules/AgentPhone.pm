# --
# Kernel/Modules/AgentPhone.pm - to handle phone calls
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPhone.pm,v 1.27 2003-02-25 22:55:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPhone;

use strict;
use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::EmailParser;
use Kernel::System::CheckItem;

use vars qw($VERSION);
$VERSION = '$Revision: 1.27 $';
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
    $Self->{EmailParserObject} = Kernel::System::EmailParser->new(%Param);
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $TicketID = $Self->{TicketID};
    my $QueueID = $Self->{QueueID};
    my $Subaction = $Self->{Subaction};
    my $NextScreen = $Self->{NextScreen} || 'AgentZoom';
    my $UserLogin = $Self->{UserLogin};
    
    if ($Subaction eq '' || !$Subaction) {
        # --
        # header
        # --
        $Output .= $Self->{LayoutObject}->Header(Title => 'Phone call');
        # --
        # if there is no ticket id!
        # --
        if (!$TicketID) {
            my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
            $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
            # --
            # html output
            # --
            $Output .= $Self->{LayoutObject}->AgentPhoneNew(
              QueueID => $QueueID,
              NextScreen => $NextScreen,
              NextStates => $Self->_GetNextStates(),
              Priorities => $Self->_GetPriorities(),
              Body => '$Text{"$Config{"PhoneDefaultNewNoteText"}"}',
              Subject => '$Config{"PhoneDefaultNewSubject"}',
              To => $Self->_GetTos(),
           );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # --
        # get ticket info
        # --
        my %TicketData = $Self->{TicketObject}->GetTicket(TicketID => $TicketID);
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
        # --
        # get lock state && permissions
        # --
        if (!$Self->{TicketObject}->IsTicketLocked(TicketID => $TicketID)) {
          # --
          # set owner
          # --
          $Self->{TicketObject}->SetOwner(
            TicketID => $TicketID,
            UserID => $Self->{UserID},
            NewUserID => $Self->{UserID},
          );
          # --
          # set lock
          # --
          if ($Self->{TicketObject}->SetLock(
            TicketID => $TicketID,
            Lock => 'lock',
            UserID => $Self->{UserID},
          )) {
            # show lock state
            $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $TicketID);
          }
        }
        else {
          my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->CheckOwner(
              TicketID => $TicketID,
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
        # print form ...
        # --
        $Output .= $Self->{LayoutObject}->AgentPhone(
            TicketID => $TicketID,
            QueueID => $QueueID,
            NextScreen => $NextScreen,
            TicketNumber => $Tn,
            NextStates => $Self->_GetNextStates(),
            CustomerData => \%CustomerData,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Subaction eq 'Store') {
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Note!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Body');
        my $NextStateID = $Self->{ParamObject}->GetParam(Param => 'NextStateID') || '';
        my $NextState = $Self->{TicketObject}->StateIDLookup(StateID => $NextStateID);
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $Answered = $Self->{ParamObject}->GetParam(Param => 'Answered') || '';
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || 0;
        my %GetParam = ();
        foreach (qw(Year Month Day Hour Minute)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('PhoneDefaultArticleType'),
            SenderType => $Self->{ConfigObject}->Get('PhoneDefaultSenderType'),
            From => $UserLogin,
            To => $UserLogin,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => $Self->{ConfigObject}->Get('PhoneDefaultHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('PhoneDefaultHistoryComment'),
        )) {
          # --
          # time accounting
          # --
          if ($TimeUnits) {
            $Self->{TicketObject}->AccountTime(
              TicketID => $TicketID,
              ArticleID => $ArticleID,
              TimeUnit => $TimeUnits,
              UserID => $Self->{UserID},
            );
          }
          # --
          # set state
          # --
          $Self->{TicketObject}->SetState(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            State => $NextState,
            UserID => $Self->{UserID},
          );
          # --
          # set answerd
          # --
          $Self->{TicketObject}->SetAnswered(
            TicketID => $TicketID,
            UserID => $Self->{UserID},
            Answered => $Answered,
         );
         # --
         # should i set an unlock?
         # --
         if ($NextState =~ /^close/i) {
           $Self->{TicketObject}->SetLock(
             TicketID => $TicketID,
             Lock => 'unlock',
             UserID => $Self->{UserID},
           );
         }
         # --
         # set pending time
         # --
         elsif ($NextState =~ /^pending/i) {
             $Self->{TicketObject}->SetPendingTime(
                 UserID => $Self->{UserID},
                 TicketID => $TicketID,
                 %GetParam,
             );
         }
         # --
         # redirect to zoom view
         # --        
         return $Self->{LayoutObject}->Redirect(
            OP => "Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID",
         );
      }
      else {
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error();
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
      }
    }
    elsif ($Subaction eq 'StoreNew') {
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || '';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Body') || '';
        my $NextStateID = $Self->{ParamObject}->GetParam(Param => 'NextStateID') || '';
        my $NextState = $Self->{TicketObject}->StateIDLookup(StateID => $NextStateID);
        my $PriorityID = $Self->{ParamObject}->GetParam(Param => 'PriorityID') || '';
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $Dest = $Self->{ParamObject}->GetParam(Param => 'Dest') || '';
        my ($NewQueueID, $To) = split(/\|\|/, $Dest); 
        my $From = $Self->{ParamObject}->GetParam(Param => 'From') || '';
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || '';
        my $CustomerUser = $Self->{ParamObject}->GetParam(Param => 'CustomerUser') || '';
        my $SelectedCustomerUser = $Self->{ParamObject}->GetParam(Param => 'SelectedCustomerUser') || '';
        my $ExpandCustomerName = $Self->{ParamObject}->GetParam(Param => 'ExpandCustomerName') || 0;
        my $CustomerID = $Self->{ParamObject}->GetParam(Param => 'CustomerID') || '';
        my %GetParam = ();
        foreach (qw(Year Month Day Hour Minute)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        my %Error = ();
        # --
        # Expand Customer Name
        # -- 
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
        # --
        # get from and customer id if customer user is given
        # --
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
            $Error{"ExpandCustomerName"} = 1;
        }
        # --
        # check some values
        # --
        my @Addresses = $Self->{EmailParserObject}->SplitAddressLine(Line => $From);
        foreach my $Address (@Addresses) {
            if (!$Self->{CheckItemObject}->CkeckEmail(Address => $Address)) {
                $Error{"From invalid"} .= $Self->{CheckItemObject}->CheckError();
            }
        }
        if (!$From) {
            $Error{"From invalid"} = 'invalid';
        }
        if (!$Subject) {
            $Error{"Subject invalid"} = 'invalid';
        }
        if (%Error) {
            # --
            # header
            # --
            $Output .= $Self->{LayoutObject}->Header(Title => 'Phone call');
            my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
            $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
            # --
            # html output
            # --
            $Output .= $Self->{LayoutObject}->AgentPhoneNew(
              QueueID => $QueueID,
              NextScreen => $NextScreen,
              NextStates => $Self->_GetNextStates(),
              NextState => $NextState,
              Priorities => $Self->_GetPriorities(),
              PriorityID => $PriorityID,
              CustomerID => $CustomerID,
              CustomerUser => $CustomerUser,
              TimeUnits => $TimeUnits,
              From => $From,
              FromOptions => $Param{"FromOptions"},
              Body => $Text,
              To => $Self->_GetTos(),
              ToSelected => $Dest,
              Subject => $Subject,
              Errors => \%Error,
              %GetParam,
           );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # --
        # create new ticket
        # --
        my $NewTn = $Self->{TicketObject}->CreateTicketNr();
        # --
        # do db insert
        # --
        my $TicketID = $Self->{TicketObject}->CreateTicketDB(
            TN => $NewTn,
            QueueID => $NewQueueID,
            Lock => 'unlock',
            # FIXME !!!
            GroupID => 1,
            StateID => $NextStateID,
            PriorityID => $PriorityID,
            UserID => $Self->{UserID},
            CreateUserID => $Self->{UserID},
        );

      if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('PhoneDefaultNewArticleType'),
            SenderType => $Self->{ConfigObject}->Get('PhoneDefaultNewSenderType'),
            From => $From,
            To => $To,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
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
          # --
          # set lock
          # --
          $Self->{TicketObject}->SetLock(
              TicketID => $TicketID,
              Lock => $Self->{ConfigObject}->Get('PhoneDefaultNewLock') || 'lock',
              UserID => $Self->{UserID},
          );
          # --
          # time accounting
          # --
          if ($TimeUnits) {
              $Self->{TicketObject}->AccountTime(
                  TicketID => $TicketID,
                  ArticleID => $ArticleID,
                  TimeUnit => $TimeUnits,
                  UserID => $Self->{UserID},
              );
          }
          # --
          # set custoemr id
          # --
          if ($CustomerID || $SelectedCustomerUser) {
              $Self->{TicketObject}->SetCustomerData(
                  TicketID => $TicketID,
                  No => $CustomerID, 
                  User => $SelectedCustomerUser,
                  UserID => $Self->{UserID},
              );
          }
          # --
          # should i set an unlock?
          # --
          if ($NextState =~ /^close/i) {
              $Self->{TicketObject}->SetLock(
                  TicketID => $TicketID,
                  Lock => 'unlock',
                  UserID => $Self->{UserID},
              );
          }
          # --
          # set pending time
          # --
          elsif ($NextState =~ /^pending/i) {
              $Self->{TicketObject}->SetPendingTime(
                  UserID => $Self->{UserID},
                  TicketID => $TicketID,
                  %GetParam,
              );
          }
          # --
          # redirect
          # --
          return $Self->{LayoutObject}->Redirect(
            OP => "Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID",
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
    # get next states
    my %NextStates;
    my $NextComposeTypePossibleTmp = $Self->{ConfigObject}->Get('PhoneDefaultNextStatePossible')
        || die 'No Config entry "PhoneDefaultNextStatePossible"!';
    my @NextComposeTypePossible = @$NextComposeTypePossibleTmp;
    foreach (@NextComposeTypePossible) {
        $NextStates{$Self->{TicketObject}->StateLookup(State => $_)} = $_;
    }
    return \%NextStates;
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
    # --
    # check own selection
    # --
    my %NewTos = ();
    if ($Self->{ConfigObject}->{PhoneViewOwnSelection}) {
        %NewTos = %{$Self->{ConfigObject}->{PhoneViewOwnSelection}};
    }
    else {
        # --
        # SelectionType Queue or SystemAddress?    
        # --
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
        # --
        # ASP? Just options where the user is in!
        # --
        if ($Self->{ConfigObject}->Get('PhoneViewASP')) {
            my %UserGroups = $Self->{UserObject}->GetGroups(UserID => $Self->{UserID});
            foreach (keys %Tos) {
                if ($UserGroups{$Self->{QueueObject}->GetQueueGroupID(QueueID => $_)}) {
                    $NewTos{$_} = $Tos{$_};
                }
            }
        }
        else {
            %NewTos = %Tos;
        }
        # --
        # build selection string
        # --
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
    return \%NewTos;
}
# --

1;
