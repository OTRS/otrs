# --
# Kernel/Modules/AgentClose.pm - to close a ticket
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentClose.pm,v 1.16 2002-10-25 11:46:00 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentClose;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.16 $';
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
    foreach (
      'ParamObject', 
      'DBObject', 
      'TicketObject', 
      'LayoutObject', 
      'LogObject', 
      'QueueObject', 
      'ConfigObject',
    ) {
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
    my $LockID = 2;
    my $UnLockID = 0;
    my $Subaction = $Self->{Subaction};
    my $UserID    = $Self->{UserID};
    my $UserLogin = $Self->{UserLogin};

    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
      # --
      # error page
      # --
      $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
      $Output .= $Self->{LayoutObject}->Error(
          Message => "Can't close Ticket, no TicketID is given!",
          Comment => 'Please contact the admin.',
      );
      $Output .= $Self->{LayoutObject}->Footer();
      return $Output;
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }

    
    my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
    
    if ($Subaction eq '' || !$Subaction) {
        # get next states
        my %NextStates = $Self->{DBObject}->GetTableData(
            Table => 'ticket_state',
            Valid => 0,
            What => 'id, name'
        );
        foreach (keys %NextStates) {
            if ($NextStates{$_} !~ /^close/i) {
                delete $NextStates{$_};
            }
        }
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
        # move queues
        my $SelectedMoveQueue = $Self->{TicketObject}->GetQueueIDOfTicketID(TicketID => $TicketID);
        my %MoveQueues = ();
        if ($Self->{ConfigObject}->Get('MoveInToAllQueues')) {
            %MoveQueues = $Self->{QueueObject}->GetAllQueues();
        }
        else {
            %MoveQueues = $Self->{QueueObject}->GetAllQueues(UserID => $Self->{UserID});
        }

        # -- 
        # html header
        # --
        $Output .= $Self->{LayoutObject}->Header(Title => 'Close');
        # --
        # get lock state
        # --
        if (!$Self->{TicketObject}->IsTicketLocked(TicketID => $TicketID)) {
            $Self->{TicketObject}->SetLock(
                TicketID => $TicketID,
                Lock => 'lock',
                UserID => $UserID
            );
            if ($Self->{TicketObject}->SetOwner(
                TicketID => $TicketID,
                UserID => $UserID,
                NewUserID => $UserID,
            )) {
                # show lock state
                $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $TicketID);
            }

        }
        # --
        # print form ...
        # --
        $Output .= $Self->{LayoutObject}->AgentClose(
            TicketID => $TicketID,
            TicketNumber => $Tn,
            QueueID => $QueueID,
            NextStatesStrg => \%NextStates,
            NoteTypesStrg => \%NoteTypes,
            MoveQueues => \%MoveQueues,
            SelectedMoveQueue => $SelectedMoveQueue,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Subaction eq 'Store') {
        # store action
        my $StateID = $Self->{ParamObject}->GetParam(Param => 'CloseStateID');
        my $NoteID = $Self->{ParamObject}->GetParam(Param => 'CloseNoteID');
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || '';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Text');
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || 0;
        my $DestQueueID = $Self->{ParamObject}->GetParam(Param => 'DestQueueID') || '';
        if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $TicketID,
            ArticleTypeID => $NoteID,
            SenderType => 'agent',
            From => $UserLogin,
            To => $UserLogin,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
            UserID => $UserID,
            HistoryType => 'AddNote',
            HistoryComment => 'Close Note added.',
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
            UserID => $UserID,
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            StateID => $StateID,
          );
          # --
          # set queue
          # --
          if ($DestQueueID) {
            $Self->{TicketObject}->MoveByTicketID(
              TicketID => => $TicketID,
              UserID => $UserID,
              QueueID => $DestQueueID,
            );
          }
          # --
          # set lock
          # --
          $Self->{TicketObject}->SetLock(
            UserID => $UserID,
            TicketID => $TicketID,
            Lock => 'unlock'
          );
          if ($Self->{QueueID}) {
             return $Self->{LayoutObject}->Redirect(OP => "QueueID=$Self->{QueueID}");
          }
          else {
             return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
          }
        }
        else {
          # error screen
          $Output .= $Self->{LayoutObject}->Header();
          $Output .= $Self->{LayoutObject}->Error(
            Comment => 'Please contact your admin'
          );
          $Output .= $Self->{LayoutObject}->Footer();
          return $Output;
        }
    }
    else {
        # error screen
        $Output .= $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'Wrong Subaction!!',
            Comment => 'Please contact your admin'
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

1;
