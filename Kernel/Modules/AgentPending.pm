# --
# Kernel/Modules/AgentPending.pm - to set ticket in pending state
# Copyright (C) 2002-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentPending.pm,v 1.5 2003-02-17 21:35:47 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentPending;

use strict;

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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject
      QueueObject ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }

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
        my %NextStates = $Self->{DBObject}->GetTableData(
            Table => 'ticket_state',
            Valid => 0,
            What => 'id, name'
        );
        foreach (keys %NextStates) {
            if ($NextStates{$_} !~ /^pending/i) {
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
        my $SelectedMoveQueue = $Self->{TicketObject}->GetQueueIDOfTicketID(
            TicketID => $Self->{TicketID},
        );
        # -- 
        # html header
        # --
        $Output .= $Self->{LayoutObject}->Header(Title => 'Pending');
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
        $Output .= $Self->{LayoutObject}->AgentPending(
            TicketID => $Self->{TicketID},
            TicketNumber => $Tn,
            QueueID => $QueueID,
            NextStatesStrg => \%NextStates,
            NoteTypesStrg => \%NoteTypes,
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
        my %GetParam = ();
        foreach (qw(Year Month Day Hour Minute)) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        # --
        # check needed stuff
        # --
        foreach (qw(Year Month Day Hour Minute)) {
          if (!$GetParam{$_}) {
            $Output .= $Self->{LayoutObject}->Header(Title => 'Error');
            $Output .= $Self->{LayoutObject}->Error(
              Message => "Need $_!",
              Comment => 'Please contact the admin.',
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
          }
        }
        # --
        # add note
        # --
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
            HistoryComment => 'Pending Note added.',
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
          # set pending time
          # --
          $Self->{TicketObject}->SetPendingTime(
            UserID => $Self->{UserID},
            TicketID => $Self->{TicketID},
            %GetParam,
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
