# --
# Kernel/Modules/AgentPhone.pm - to handle phone calls
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPhone.pm,v 1.10 2002-10-03 17:29:23 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPhone;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10 $';
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
           $Self->{ConfigObject}->Get('DefaultPhoneNextStatePossible')
             || die 'No Config entry "DefaultPhoneNextStatePossible"!';
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
    
            my %Tos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What => 'queue_id, value1, value0',
                Valid => 1,
                Clamp => 1,
            );

            $Output .= $Self->{LayoutObject}->AgentPhoneNew(
              QueueID => $QueueID,
              BackScreen => $BackScreen,
              NextScreen => $NextScreen,
              NoteTypes => \%NoteTypes,
              NextStates => \%NextStates,
              To => \%Tos,
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
#            ArticleTypeID => $ArticleTypeID,
            ArticleType => $Self->{ConfigObject}->Get('DefaultPhoneArticleType'),
            SenderType => $Self->{ConfigObject}->Get('DefaultPhoneSenderType'),
            From => $UserLogin,
            To => $UserLogin,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
            UserID => $UserID, 
            HistoryType => $Self->{ConfigObject}->Get('DefaultPhoneHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('DefaultPhoneHistoryComment'),
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
            OP => "&Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID",
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
        my $NewQueueID = $Self->{ParamObject}->GetParam(Param => 'NewQueueID') || 4;
        my $From = $Self->{ParamObject}->GetParam(Param => 'From') || '??';
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || 0;
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
            ArticleType => $Self->{ConfigObject}->Get('DefaultPhoneNewArticleType'),
            SenderType => $Self->{ConfigObject}->Get('DefaultPhoneNewSenderType'),
            From => $From,
            To => $UserLogin,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
            UserID => $UserID,
            HistoryType => $Self->{ConfigObject}->Get('DefaultPhoneNewHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('DefaultPhoneNewHistoryComment'),
            AutoResponseType => 'auto reply',
            OrigHeader => {
              From => $From,
              To => $UserLogin,
              Subject => $Subject,
              Body => $Text,
           },
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
            OP => "&Action=$NextScreen&QueueID=$QueueID&TicketID=$TicketID",
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
