# --
# Kernel/Modules/AgentNote.pm - to add notes to a ticket 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentNote.pm,v 1.18 2003-03-06 22:11:59 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentNote;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.18 $';
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
        # print form ...
        $Output = $Self->{LayoutObject}->Header(Title => 'Add Note');
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
        $Output .= $Self->{LayoutObject}->AgentNote(
            TicketID => $Self->{TicketID},
            QueueID => $Self->{QueueID},
            TicketNumber => $Tn,
            NoteSubject => $Self->{ConfigObject}->Get('DefaultNoteSubject'),
            NoteTypes => \%NoteTypes,
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
        if (my $ArticleID = $Self->{TicketObject}->CreateArticle(
            TicketID => $Self->{TicketID},
            ArticleTypeID => $ArticleTypeID,
            SenderType => 'agent',
            From => $Self->{UserLogin},
            To => $Self->{UserLogin},
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => 'AddNote',
            HistoryComment => 'Note added.',
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
          # get attachment
          # -- 
          my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
              Param => 'file_upload', 
              Source => 'String',
          );
          if (%UploadStuff) {
              $Self->{TicketObject}->WriteArticlePart(
                  Content => $UploadStuff{UploadFilename},
                  Filename => $UploadStuff{UploadRealFileName},
                  ContentType => $UploadStuff{UploadContentType},
                  ArticleID => $ArticleID, 
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

1;
