# --
# Kernel/Modules/AgentClose.pm - to close a ticket
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentClose.pm,v 1.21 2003-03-06 22:11:58 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentClose;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.21 $';
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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject
      QueueObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
    # needed objects
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my $QueueID = $Self->{QueueID};

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
        Type => 'rw',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    
    my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $Self->{TicketID});
    
    if ($Self->{Subaction} eq '' || !$Self->{Subaction}) {
        # get next states
        my %NextStates = $Self->{StateObject}->StateGetStatesByType(
            Type => 'DefaultCloseNext',
            Result => 'HASH',
        );
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
        my $SelectedMoveQueue = $Self->{TicketObject}->GetQueueIDOfTicketID(
            TicketID => $Self->{TicketID},
        );
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
        if (!$Self->{TicketObject}->IsTicketLocked(TicketID => $Self->{TicketID})) {
            $Self->{TicketObject}->SetLock(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => $Self->{UserID}
            );
            if ($Self->{TicketObject}->SetOwner(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $Self->{UserID},
            )) {
                # show lock state
                $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $Self->{TicketID});
            }
        }
        # --
        # print form ...
        # --
        $Output .= $Self->{LayoutObject}->AgentClose(
            TicketID => $Self->{TicketID},
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
    elsif ($Self->{Subaction} eq 'Store') {
        # store action
        my $StateID = $Self->{ParamObject}->GetParam(Param => 'CloseStateID');
        my $NoteID = $Self->{ParamObject}->GetParam(Param => 'CloseNoteID');
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || '';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Text') || 
            $Self->{ParamObject}->GetParam(Param => 'Body');
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || 0;
        my $DestQueueID = $Self->{ParamObject}->GetParam(Param => 'DestQueueID') || '';
        if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $Self->{TicketID},
            ArticleTypeID => $NoteID,
            SenderType => 'agent',
            From => $Self->{UserLogin},
            To => $Self->{UserLogin},
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => 'AddNote',
            HistoryComment => 'Close Note added.',
        )) {
          # --
          # time accounting
          # --
          if ($TimeUnits) {
            $Self->{TicketObject}->AccountTime(
              TicketID => $Self->{TicketID},
              ArticleID => $ArticleID,
              TimeUnit => $TimeUnits,
              UserID => $Self->{UserID},
            );
          }
          # --
          # set state
          # --
          $Self->{TicketObject}->SetState(
            UserID => $Self->{UserID},
            TicketID => $Self->{TicketID},
            ArticleID => $ArticleID,
            StateID => $StateID,
          );
          # --
          # set queue
          # --
          if ($DestQueueID) {
            $Self->{TicketObject}->MoveByTicketID(
              TicketID => => $Self->{TicketID},
              UserID => $Self->{UserID},
              QueueID => $DestQueueID,
            );
          }
          # --
          # set lock
          # --
          $Self->{TicketObject}->SetLock(
            UserID => $Self->{UserID},
            TicketID => $Self->{TicketID},
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
# --
1;
