# --
# Kernel/Modules/AgentNote.pm - to add notes to a ticket 
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentNote.pm,v 1.33 2004-04-22 13:17:22 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentNote;

use strict;
use Kernel::System::State;

use vars qw($VERSION);
$VERSION = '$Revision: 1.33 $';
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
    $Self->{StateObject} = Kernel::System::State->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # --
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
        # --
        # error page
        # --
        my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "Can't add note, no TicketID is given!",
            Comment => 'Please contact the admin.',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'note',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }

    my $Tn = $Self->{TicketObject}->TicketNumberLookup(TicketID => $Self->{TicketID});
    
    if ($Self->{Subaction} eq '' || !$Self->{Subaction}) {
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
        # print form ...
        $Output = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Add Note');
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        # --
        # get next states
        # --
        my %NextStates = $Self->{TicketObject}->StateList(
            Type => 'DefaultNextNote',
            Action => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
        );
        $NextStates{''} = '-';
        $Output .= $Self->_Mask(
            TicketID => $Self->{TicketID},
            QueueID => $Self->{QueueID},
            TicketNumber => $Tn,
            NoteSubject => $Self->{ConfigObject}->Get('DefaultNoteSubject'),
            NoteTypes => \%NoteTypes,
            NextStates => \%NextStates,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    elsif ($Self->{Subaction} eq 'Store') {
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || 'Note!';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Note') || 
            $Self->{ParamObject}->GetParam(Param => 'Body');
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || 0; 
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID => $Self->{TicketID},
            ArticleTypeID => $ArticleTypeID,
            SenderType => 'agent',
            From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => 'AddNote',
            HistoryComment => '%%Note',
        )) {
          # --
          # time accounting
          # --
          if ($TimeUnits) {
            $Self->{TicketObject}->TicketAccountTime(
              TicketID => $Self->{TicketID},
              ArticleID => $ArticleID,
              TimeUnit => $TimeUnits,
              UserID => $Self->{UserID},
            );
          }
          # --
          # get attachment
          # -- 
          my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
              Param => 'file_upload', 
              Source => 'String',
          );
          if (%UploadStuff) {
              $Self->{TicketObject}->ArticleWriteAttachment(
                  %UploadStuff,
                  ArticleID => $ArticleID, 
                  UserID => $Self->{UserID}, 
              );
          }
          # --
          # set state
          # --
          my $NewStateID = $Self->{ParamObject}->GetParam(Param => 'NewStateID') || '';
          if ($Self->{ConfigObject}->Get('NoteSetState') && $NewStateID) {
              $Self->{TicketObject}->StateSet(
                  TicketID => $Self->{TicketID},
                  StateID => $NewStateID,
                  UserID => $Self->{UserID},
              );
          } 
          # --
          # redirect
          # --
          return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
        }
        else {
          $Output = $Self->{LayoutObject}->Header(Title => 'Error');
          $Output .= $Self->{LayoutObject}->Error();
          $Output .= $Self->{LayoutObject}->Footer();
          return $Output;
        }
    }
    else {
        $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => 'Wrong Subaction!!',
            Comment => 'Please contact your admin',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # build ArticleTypeID string
    $Param{'NoteStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NoteTypes},
        Name => 'NoteID',
    );
    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NewStateID',
    );
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentNote', Data => \%Param);
}
# --
1;
