# --
# Kernel/Modules/AgentClose.pm - to close a ticket
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentClose.pm,v 1.40 2004-09-28 15:05:05 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentClose;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.40 $';
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
    # check needed stuff
    if (!$Self->{TicketID}) {
        # error page
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need TicketID!",
            Comment => 'Please contact the admin.',
        );
    }
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => 'close',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }

    my $Tn = $Self->{TicketObject}->TicketNumberLookup(TicketID => $Self->{TicketID});

    if ($Self->{Subaction} eq '' || !$Self->{Subaction}) {
        # get next states
        my %NextStates = $Self->{TicketObject}->StateList(
            Type => 'DefaultCloseNext',
            Action => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
        );
        # get possible notes
        my %DefaultNoteTypes = %{$Self->{ConfigObject}->Get('DefaultNoteTypes')};
        my %NoteTypes = $Self->{DBObject}->GetTableData(
            Table => 'article_type',
            Valid => 1,
            What => 'id, name'
        );
        foreach (keys %NoteTypes) {
            if (!$DefaultNoteTypes{$NoteTypes{$_}}) {
                delete $NoteTypes{$_};
            }
        }
        # move queues
        my $SelectedMoveQueue = $Self->{TicketObject}->TicketQueueID(
            TicketID => $Self->{TicketID},
        );
        my %MoveQueues = $Self->{TicketObject}->MoveList(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
            Action => $Self->{Action},
            Type => 'move',
        );
        # html header
        $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Close');
#        $Output .= $Self->{LayoutObject}->NavigationBar();
        # get lock state
        if (!$Self->{TicketObject}->LockIsTicketLocked(TicketID => $Self->{TicketID})) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => $Self->{UserID}
            );
            if ($Self->{TicketObject}->OwnerSet(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $Self->{UserID},
            )) {
                # show lock state
                $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $Self->{TicketID});
            }
        }
        else {
            my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->OwnerCheck(
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
        $Output .= $Self->_Mask(
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
        # rewrap body if exists
        if ($Text) {
            $Text =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('TextAreaNoteWindow')})(?:\s|\z)/$1\n/gm;
        }

        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || 0;
        my $DestQueueID = $Self->{ParamObject}->GetParam(Param => 'DestQueueID') || '';
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID => $Self->{TicketID},
            ArticleTypeID => $NoteID,
            SenderType => 'agent',
            From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => 'AddNote',
            HistoryComment => '%%Close',
        )) {
          # time accounting
          if ($TimeUnits) {
            $Self->{TicketObject}->TicketAccountTime(
              TicketID => $Self->{TicketID},
              ArticleID => $ArticleID,
              TimeUnit => $TimeUnits,
              UserID => $Self->{UserID},
            );
          }
          # set state
          $Self->{TicketObject}->StateSet(
            UserID => $Self->{UserID},
            TicketID => $Self->{TicketID},
            ArticleID => $ArticleID,
            StateID => $StateID,
          );
          # set queue
          if ($DestQueueID) {
            $Self->{TicketObject}->MoveTicket(
              TicketID => => $Self->{TicketID},
              UserID => $Self->{UserID},
              QueueID => $DestQueueID,
            );
          }
          # set lock
          $Self->{TicketObject}->LockSet(
            UserID => $Self->{UserID},
            TicketID => $Self->{TicketID},
            Lock => 'unlock'
          );
          # redirect
          my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
              ID => $StateID,
          );
          if ($StateData{TypeName} =~ /^close/i) {
              return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenOverview});
          }
          else {
              return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
          }
        }
        else {
            # error screen
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    else {
        # error screen
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'Wrong Subaction!!',
            Comment => 'Please contact your admin'
        );
    }
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;

    # build string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStatesStrg},
        Name => 'CloseStateID'
    );
    # build string
    $Param{'NoteTypesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NoteTypesStrg},
        Name => 'CloseNoteID'
    );
    # get MoveQueuesStrg
    $Param{MoveQueuesStrg} = $Self->{LayoutObject}->OptionStrgHashRef(
        Name => 'DestQueueID',
        SelectedID => $Param{SelectedMoveQueue},
        Data => $Param{MoveQueues},
        OnChangeSubmit => 0,
    );

    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentClose', Data => \%Param);
}
# --
1;
