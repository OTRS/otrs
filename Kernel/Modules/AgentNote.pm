# --
# Kernel/Modules/AgentNote.pm - to add notes to a ticket
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentNote.pm,v 1.36 2004-08-02 06:50:43 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentNote;

use strict;
use Kernel::System::State;
use Kernel::System::WebUploadCache;

use vars qw($VERSION);
$VERSION = '$Revision: 1.36 $';
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
    $Self->{UploadCachObject} = Kernel::System::WebUploadCache->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam(Param => 'FormID');
    # create form id
    if (!$Self->{FormID}) {
        $Self->{FormID} = $Self->{UploadCachObject}->FormIDCreate();
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    # check needed stuff
    if (!$Self->{TicketID}) {
        # error page
        my $Output = $Self->{LayoutObject}->Header(Title => 'Error');
        $Output .= $Self->{LayoutObject}->Error(
            Message => "Can't add note, no TicketID is given!",
            Comment => 'Please contact the admin.',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => 'note',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }

    my %Error = ();
    my $Tn = $Self->{TicketObject}->TicketNumberLookup(TicketID => $Self->{TicketID});
    # get params
    my %GetParam = ();
    foreach (qw(
        NewStateID TimeUnits ArticleTypeID Body Subject
        AttachmentUpload
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 )) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
    }
    # attachment delete
    foreach (1..10) {
        if ($GetParam{"AttachmentDelete$_"}) {
            $Error{AttachmentDelete} = 1;
            $Self->{UploadCachObject}->FormIDRemoveFile(
                FormID => $Self->{FormID},
                FileID => $_,
            );
        }
    }
    # attachment upload
    if ($GetParam{AttachmentUpload}) {
        $Error{AttachmentUpload} = 1;
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => "file_upload",
            Source => 'string',
        );
        $Self->{UploadCachObject}->FormIDAddFile(
            FormID => $Self->{FormID},
            %UploadStuff,
        );
    }
    # get all attachments meta data
    my @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
        FormID => $Self->{FormID},
    );
    if ($Self->{Subaction} ne 'Store' || %Error) {
        if ($Self->{Subaction} ne 'Store' && !%Error) {
            if ($Self->{ConfigObject}->Get('DefaultNoteSubject')) {
                $GetParam{Subject} = $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('DefaultNoteSubject'));
            }
            if ($Self->{ConfigObject}->Get('DefaultNoteText')) {
                $GetParam{Body} = $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('DefaultNoteText'));
            }
        }
        # print form ...
        $Output = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Add Note');
        my %LockedData = $Self->{TicketObject}->GetLockedCount(UserID => $Self->{UserID});
        $Output .= $Self->{LayoutObject}->NavigationBar(LockData => \%LockedData);
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
        # get next states
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
            NoteTypes => \%NoteTypes,
            NextStates => \%NextStates,
            Attachments => \@Attachments,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;

    }
    else {
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID => $Self->{TicketID},
            SenderType => 'agent',
            From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => 'AddNote',
            HistoryComment => '%%Note',
            %GetParam,
        )) {
          # time accounting
          if ($GetParam{TimeUnits}) {
            $Self->{TicketObject}->TicketAccountTime(
              TicketID => $Self->{TicketID},
              ArticleID => $ArticleID,
              TimeUnit => $GetParam{TimeUnits},
              UserID => $Self->{UserID},
            );
          }
          # get pre loaded attachment
          my @AttachmentData = $Self->{UploadCachObject}->FormIDGetAllFilesData(
              FormID => $Self->{FormID},
          );
          foreach my $Ref (@AttachmentData) {
              $Self->{TicketObject}->ArticleWriteAttachment(
                  %{$Ref},
                  ArticleID => $ArticleID,
                  UserID => $Self->{UserID},
              );
          }
          # get submit attachment
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
          # set state
          if ($Self->{ConfigObject}->Get('NoteSetState') && $GetParam{NewStateID}) {
              $Self->{TicketObject}->StateSet(
                  TicketID => $Self->{TicketID},
                  StateID => $GetParam{NewStateID},
                  UserID => $Self->{UserID},
              );
          }
          # remove pre submited attachments
          $Self->{UploadCachObject}->FormIDRemove(FormID => $Self->{FormID});
          # redirect
          return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
        }
        else {
          $Output = $Self->{LayoutObject}->Header(Title => 'Error');
          $Output .= $Self->{LayoutObject}->Error();
          $Output .= $Self->{LayoutObject}->Footer();
          return $Output;
        }
    }
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    $Param{FormID} = $Self->{FormID};
    # build ArticleTypeID string
    my %ArticleType = ();
    if (!$Param{ArticleTypeID}) {
        $ArticleType{Selected} = $Self->{ConfigObject}->Get('DefaultNoteType');
    }
    else {
        $ArticleType{SelectedID} = $Param{ArticleTypeID};
    }
    $Param{'NoteStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NoteTypes},
        Name => 'ArticleTypeID',
        %ArticleType,
    );
    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NewStateID',
        SelectedID => $Param{NewStateID},
    );
    # show attachments
    foreach my $DataRef (@{$Param{Attachments}}) {
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $DataRef,
        );
    }
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentNote', Data => \%Param);
}
# --
1;
