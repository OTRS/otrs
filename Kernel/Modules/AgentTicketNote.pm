# --
# Kernel/Modules/AgentTicketNote.pm - to add notes to a ticket
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketNote.pm,v 1.7 2005-11-12 13:23:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketNote;

use strict;
use Kernel::System::State;
use Kernel::System::Web::UploadCache;

use vars qw($VERSION);
$VERSION = '$Revision: 1.7 $';
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
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject ConfigObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam(Param => 'FormID');
    my @InformUserID = $Self->{ParamObject}->GetArray(Param => 'InformUserID');
    $Self->{InformUserID} = \@InformUserID;
    my @InvolvedUserID = $Self->{ParamObject}->GetArray(Param => 'InvolvedUserID');
    $Self->{InvolvedUserID} = \@InvolvedUserID;
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
        Year Month Day Hour Minute
        AttachmentUpload
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 )) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
    }
    # rewrap body if exists
    if ($GetParam{Body}) {
        $GetParam{Body} =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
    }

    if ($Self->{Subaction} eq 'Store') {
        # store action
        my %Error = ();
        # check pending time
        if ($GetParam{NewStateID}) {
            my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $GetParam{NewStateID},
            );
            # check state type
            if ($StateData{TypeName} =~ /^pending/i) {
                # check needed stuff
                foreach (qw(Year Month Day Hour Minute)) {
                    if (!defined($GetParam{$_})) {
                        $Error{"Date invalid"} = '* invalid';
                    }
                }
                # check date
                if (!$Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0)) {
                    $Error{"Date invalid"} = '* invalid';
                }
                if ($Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0) < $Self->{TimeObject}->SystemTime()) {
                    $Error{"Date invalid"} = '* invalid';
                }
            }
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
        # check errors
        if (%Error) {
            my $Output = $Self->{LayoutObject}->Header(Value => $Tn);
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->_Mask(
                TicketID => $Self->{TicketID},
                QueueID => $Self->{QueueID},
                TicketNumber => $Tn,
                Attachments => \@Attachments,
                %GetParam,
                %Error,
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
            ForceNotificationToUserID => [@{$Self->{InformUserID}}, @{$Self->{InvolvedUserID}}, ],
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
            if ($Self->{ConfigObject}->Get('Ticket::Frontend::NoteSetState') && $GetParam{NewStateID}) {
                $Self->{TicketObject}->StateSet(
                    TicketID => $Self->{TicketID},
                    StateID => $GetParam{NewStateID},
                    UserID => $Self->{UserID},
                );
                # unlock the ticket after close
                my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                    ID => $GetParam{NewStateID},
                );
                # set unlock on close
                if ($StateData{TypeName} =~ /^close/i) {
                    $Self->{TicketObject}->LockSet(
                        TicketID => $Self->{TicketID},
                        Lock => 'unlock',
                        UserID => $Self->{UserID},
                    );
                }
                # set pending time
                elsif ($StateData{TypeName} =~ /^pending/i) {
                    $Self->{TicketObject}->TicketPendingTimeSet(
                        UserID => $Self->{UserID},
                        TicketID => $Self->{TicketID},
                        %GetParam,
                    );
                }
            }
            # remove pre submited attachments
            $Self->{UploadCachObject}->FormIDRemove(FormID => $Self->{FormID});
            # redirect
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    else {
        # fillup vars
        if (!defined($GetParam{Body}) && $Self->{ConfigObject}->Get('Ticket::Frontend::NoteText')) {
            $GetParam{Body} = $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('Ticket::Frontend::NoteText'));
        }
        if (!defined($GetParam{Subject}) && $Self->{ConfigObject}->Get('Ticket::Frontend::NoteSubject')) {
            $GetParam{Subject} = $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('Ticket::Frontend::NoteSubject'));
        }
        # print form ...
        my $Output = $Self->{LayoutObject}->Header(Value => $Tn);
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
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    $Param{FormID} = $Self->{FormID};
    # build ArticleTypeID string
    my %ArticleType = ();
    if (!$Param{ArticleTypeID}) {
        $ArticleType{Selected} = $Self->{ConfigObject}->Get('Ticket::Frontend::NoteType');
    }
    else {
        $ArticleType{SelectedID} = $Param{ArticleTypeID};
    }
    # get possible notes
    my %DefaultNoteTypes = %{$Self->{ConfigObject}->Get('Ticket::Frontend::NoteTypes')};
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
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::NoteSetState')) {
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
        $Self->{LayoutObject}->Block(
            Name => 'NextState',
            Data => \%Param,
        );
        $Param{DateString} = $Self->{LayoutObject}->BuildDateSelection(
            Format => 'DateInputFormatLong',
            DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
            %Param,
        );
    }
    # show spell check
    if ($Self->{ConfigObject}->Get('SpellChecker') && $Self->{LayoutObject}->{BrowserJavaScriptSupport}) {
        $Self->{LayoutObject}->Block(
            Name => 'SpellCheck',
            Data => {},
        );
    }
    # show attachments
    foreach my $DataRef (@{$Param{Attachments}}) {
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $DataRef,
        );
    }
    # agent list
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::NoteInformAgent')) {
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
            SelectedIDRefArray => $Self->{InformUserID},
            Name => 'InformUserID',
            Multiple => 1,
            Size => 3,
        );
        $Self->{LayoutObject}->Block(
            Name => 'InformAgent',
            Data => \%Param,
        );
    }
    # get involved
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::NoteInformInvolvedAgent')) {
        my @UserIDs = $Self->{TicketObject}->InvolvedAgents(TicketID => $Self->{TicketID});
        my %UserHash = ();
        my $Counter = 0;
        foreach my $User (reverse @UserIDs) {
            $Counter++;
            if (!$UserHash{$User->{UserID}}) {
                $UserHash{$User->{UserID}} = "$Counter: $User->{UserLastname} ".
                  "$User->{UserFirstname} ($User->{UserLogin})";
            }
        }
        $Param{'InvolvedAgentStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%UserHash,
            SelectedIDRefArray => $Self->{InvolvedUserID},
            Name => 'InvolvedUserID',
            Multiple => 1,
            Size => 3,
        );
        $Self->{LayoutObject}->Block(
            Name => 'InvolvedAgent',
            Data => \%Param,
        );
    }
    # show time accounting box
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')) {
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnitsJs',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnits',
            Data => \%Param,
        );
    }
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketNote', Data => \%Param);
}
# --
1;
