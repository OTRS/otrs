# --
# Kernel/Modules/AgentPhone.pm - to handle phone calls
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPhone.pm,v 1.15 2002-10-30 00:39:07 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPhone;

use strict;
use Kernel::System::SystemAddress;

use vars qw($VERSION);
$VERSION = '$Revision: 1.15 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

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
    my $BackScreen = $Self->{BackScreen};
    my $UserID = $Self->{UserID};
    my $UserLogin = $Self->{UserLogin};
    
    if ($Subaction eq '' || !$Subaction) {
        # --
        # header
        # --
        $Output .= $Self->{LayoutObject}->Header(Title => 'Phone call');

        # get possible notes
        my %NoteTypes = $Self->{DBObject}->GetTableData(
            Table => 'article_type',
            Valid => 1,
            What => 'id, name'
        );
        foreach (keys %NoteTypes) {
            if ($NoteTypes{$_} !~ /^note/i) {
                delete $NoteTypes{$_};
            }
        }
        # get next states
        my %NextStates;
        my $NextComposeTypePossibleTmp =
           $Self->{ConfigObject}->Get('PhoneDefaultNextStatePossible')
             || die 'No Config entry "PhoneDefaultNextStatePossible"!';
        my @NextComposeTypePossible = @$NextComposeTypePossibleTmp;
        foreach (@NextComposeTypePossible) {
            $NextStates{$Self->{TicketObject}->StateLookup(State => $_)} = $_;
        }

        # --
        # if there is no ticket id!
        # --
        if (!$TicketID) {
            my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $UserID);
            $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
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
                    my %UserGroups = $Self->{UserObject}->GetGroups(UserID => $UserID);
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
            # --
            # html output
            # --
            $Output .= $Self->{LayoutObject}->AgentPhoneNew(
              QueueID => $QueueID,
              BackScreen => $BackScreen,
              NextScreen => $NextScreen,
              NoteTypes => \%NoteTypes,
              NextStates => \%NextStates,
              To => \%NewTos,
           );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
        # get lock state && permissions
        if (!$Self->{TicketObject}->IsTicketLocked(TicketID => $TicketID)) {
          # --
          # set owner
          # --
          $Self->{TicketObject}->SetOwner(
            TicketID => $TicketID,
            UserID => $UserID,
            NewUserID => $UserID,
          );
          # --
          # set lock
          # --
          if ($Self->{TicketObject}->SetLock(
            TicketID => $TicketID,
            Lock => 'lock',
            UserID => $UserID
          )) {
            # show lock state
            $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $TicketID);
          }
        }
        else {
          my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->CheckOwner(
            TicketID => $TicketID,
          );

          if ($OwnerID != $UserID) {
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
            BackScreen => $BackScreen,
            NextScreen => $NextScreen,
            TicketNumber => $Tn,
            NoteTypes => \%NoteTypes,
            NextStates => \%NextStates,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Subaction eq 'Store') {
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Note!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Note');
        my $NextStateID = $Self->{ParamObject}->GetParam(Param => 'NextStateID') || '';
        my $NextState = $Self->{TicketObject}->StateIDLookup(StateID => $NextStateID);
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $Answered = $Self->{ParamObject}->GetParam(Param => 'Answered') || '';
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || 0;
        if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('PhoneDefaultArticleType'),
            SenderType => $Self->{ConfigObject}->Get('PhoneDefaultSenderType'),
            From => $UserLogin,
            To => $UserLogin,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
            UserID => $UserID, 
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
              UserID => $UserID,
            );
          }
          # --
          # set state
          # --
          $Self->{TicketObject}->SetState(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            State => $NextState,
            UserID => $UserID,
          );
          # --
          # set answerd
          # --
          $Self->{TicketObject}->SetAnswered(
            TicketID => $TicketID,
            UserID => $UserID,
            Answered => $Answered,
         );
         # --
         # should i set an unlock?
         # --
         if ($NextState =~ /^close/i) {
           $Self->{TicketObject}->SetLock(
             TicketID => $TicketID,
             Lock => 'unlock',
             UserID => $UserID,
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
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Note!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Note');
        my $NextStateID = $Self->{ParamObject}->GetParam(Param => 'NextStateID') || '';
        my $NextState = $Self->{TicketObject}->StateIDLookup(StateID => $NextStateID);
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $Dest = $Self->{ParamObject}->GetParam(Param => 'Dest') || '';
        my ($NewQueueID, $To) = split(/\|\|/, $Dest); 
        my $From = $Self->{ParamObject}->GetParam(Param => 'From') || '??';
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || 0;
        my $CustomerID = $Self->{ParamObject}->GetParam(Param => 'CustomerID') || '';
        # create new ticket
        my $NewTn = $Self->{TicketObject}->CreateTicketNr();

        # do db insert
        my $TicketID = $Self->{TicketObject}->CreateTicketDB(
            TN => $NewTn,
            QueueID => $NewQueueID,
            Lock => 'unlock',
            # FIXME !!!
            GroupID => 1,
            StateID => $NextStateID,
            Priority => 'normal',
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
            UserID => $UserID,
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
          # time accounting
          # --
          if ($TimeUnits) {
            $Self->{TicketObject}->AccountTime(
              TicketID => $TicketID,
              ArticleID => $ArticleID,
              TimeUnit => $TimeUnits,
              UserID => $UserID,
            );
          }
          # --
          # set custoemr id
          # --
          if ($CustomerID) {
            $Self->{TicketObject}->SetCustomerNo(
              TicketID => $TicketID,
              No => $CustomerID, 
              UserID => $UserID,
            );
          }
          # --
          # should i set an unlock?
          # --
          if ($NextState =~ /^close/i) {
            $Self->{TicketObject}->SetLock(
              TicketID => $TicketID,
              Lock => 'unlock',
              UserID => $UserID,
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

1;
