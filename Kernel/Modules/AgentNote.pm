# --
# Kernel/Modules/AgentNote.pm - to add notes to a ticket
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentNote.pm,v 1.38 2004-09-16 22:04:00 martin Exp $
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
$VERSION = '$Revision: 1.38 $';
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
    my @NewUserID = $Self->{ParamObject}->GetArray(Param => 'NewUserID');
    $Self->{NewUserID} = \@NewUserID;
    my @OldUserID = $Self->{ParamObject}->GetArray(Param => 'OldUserID');
    $Self->{OldUserID} = \@OldUserID;
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
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Need TicketID is given!",
            Comment => 'Please contact the admin.',
        );
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

    if ($Self->{Subaction} eq 'Store') {
        # store action
        my %Error = ();
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
        # check errors
        if (%Error) {
            my $Output = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Add Note');
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->_Mask(
                TicketID => $Self->{TicketID},
                QueueID => $Self->{QueueID},
                TicketNumber => $Tn,
                Attachments => \@Attachments,
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # add note
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID => $Self->{TicketID},
            SenderType => 'agent',
            From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => 'AddNote',
            HistoryComment => '%%Note',
            ForceNotificationToUserID => [@{$Self->{NewUserID}}, @{$Self->{OldUserID}}, ],
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
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    else {
        # fillup vars
        if (!defined($GetParam{Body}) && $Self->{ConfigObject}->Get('DefaultNoteText')) {
            $GetParam{Body} = $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('DefaultNoteText'));
        }
        if (!defined($GetParam{Subject}) && $Self->{ConfigObject}->Get('DefaultNoteSubject')) {
            $GetParam{Subject} = $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('DefaultNoteSubject'));
        }
        # print form ...
        my $Output = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Add Note');
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(
            TicketID => $Self->{TicketID},
            QueueID => $Self->{QueueID},
            TicketNumber => $Tn,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
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
    $Param{'NoteStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%NoteTypes,
        Name => 'ArticleTypeID',
        %ArticleType,
    );
    # get next states
    my %NextStates = $Self->{TicketObject}->StateList(
        Type => 'DefaultNextNote',
        Action => $Self->{Action},
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID},
    );
    $NextStates{''} = '-';
    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%NextStates,
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
    # agent list
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    my %ShownUsers = ();
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type => 'Long',
        Valid => 1,
    );
    my $GID = $Self->{QueueObject}->GetQueueGroupID(QueueID => $Ticket{QueueID});
    my %MemberList = $Self->{GroupObject}->GroupMemberList(
        GroupID => $GID,
        Type => 'rw',
        Result => 'HASH',
        Cached => 1,
    );
    foreach (keys %MemberList) {
        $ShownUsers{$_} = $AllGroupsMembers{$_};
    }
    $Param{'OptionStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%ShownUsers,
        SelectedIDRefArray => $Self->{NewUserID},
        Name => 'NewUserID',
        Multiple => 1,
        Size => 6,
    );
    # get old owner
    my @OldUserInfo = $Self->{TicketObject}->OwnerList(TicketID => $Self->{TicketID});
    my %UserHash = ();
    my $Counter = 0;
    foreach my $User (reverse @OldUserInfo) {
        if ($Counter) {
            if (!$UserHash{$User->{UserID}}) {
                $UserHash{$User->{UserID}} = "$Counter: $User->{UserLastname} ".
                  "$User->{UserFirstname} ($User->{UserLogin})";
            }
        }
        $Counter++;
    }

    $Param{'OldUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => \%UserHash,
        SelectedIDRefArray => $Self->{OldUserID},
        Name => 'OldUserID',
        Multiple => 1,
        Size => 4,
    );

    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentNote', Data => \%Param);
}
# --
1;
