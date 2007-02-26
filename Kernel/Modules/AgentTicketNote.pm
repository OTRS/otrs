# --
# Kernel/Modules/AgentTicketNote.pm - to add notes to a ticket
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketNote.pm,v 1.19.2.1 2007-02-26 11:12:28 martin Exp $
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
$VERSION = '$Revision: 1.19.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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

    $Self->{Config} = $Self->{ConfigObject}->Get("Ticket::Frontend::$Self->{Action}");

    return $Self;
}

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
    }
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(
            Message => "You need $Self->{Config}->{Permission} permissions!",
            WithHeader => 'yes',
        );
    }
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    $Self->{LayoutObject}->Block(
        Name => 'Properties',
        Data => {
            FormID => $Self->{FormID},
            %Ticket,
            %Param,
        },
    );

    # get lock state
    if ($Self->{Config}->{RequiredLock}) {
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
                $Self->{LayoutObject}->Block(
                    Name => 'PropertiesLock',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
        }
        else {
            my $AccessOk = $Self->{TicketObject}->OwnerCheck(
                TicketID => $Self->{TicketID},
                OwnerID => $Self->{UserID},
            );
            if (!$AccessOk) {
                my $Output = $Self->{LayoutObject}->Header(Value => $Ticket{Number});
                $Output .= $Self->{LayoutObject}->Warning(
                    Message => "Sorry, you need to be the owner to do this action!",
                    Comment => 'Please change the owner first.',
                );
                $Output .= $Self->{LayoutObject}->Footer();
                return $Output;
            }
            else {
                $Self->{LayoutObject}->Block(
                    Name => 'TicketBack',
                    Data => {
                        %Param,
                        TicketID => $Self->{TicketID},
                    },
                );
            }
        }
    }
    else {
        $Self->{LayoutObject}->Block(
            Name => 'TicketBack',
            Data => {
                %Param,
                %Ticket,
            },
        );
    }

    # get params
    my %GetParam = ();
    foreach (qw(
        NewStateID NewPriorityID TimeUnits ArticleTypeID Title Body Subject
        Year Month Day Hour Minute NewOwnerID NewOwnerType OldOwnerID NewResponsibleID
        AttachmentUpload
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 AttachmentDelete11 AttachmentDelete12
        AttachmentDelete13 AttachmentDelete14 AttachmentDelete15 AttachmentDelete16
    )) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
    }
    # get ticket free text params
    foreach (1..16) {
        $GetParam{"TicketFreeKey$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeKey$_");
        $GetParam{"TicketFreeText$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeText$_");
    }
    # get ticket free text params
    foreach (1..2) {
        foreach my $Type (qw(Year Month Day Hour Minute)) {
            $GetParam{"TicketFreeTime".$_.$Type} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeTime".$_.$Type);
        }
    }
    # get article free text params
    foreach (1..3) {
        $GetParam{"ArticleFreeKey$_"} =  $Self->{ParamObject}->GetParam(Param => "ArticleFreeKey$_");
        $GetParam{"ArticleFreeText$_"} =  $Self->{ParamObject}->GetParam(Param => "ArticleFreeText$_");
    }
    # rewrap body if exists
    if ($GetParam{Body}) {
#        my $Size = $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote') || 70;
#        $GetParam{Body} =~ s/(^>.+|.{4,$Size})(?:\s|\z)/$1\n/gm;
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
        if ($Self->{Config}->{Note}) {
            # check subject
            if (!$GetParam{Subject}) {
                $Error{"Subject invalid"} = '* invalid';
            }
            # check body
            if (!$GetParam{Body}) {
                $Error{"Body invalid"} = '* invalid';
            }
        }
        # attachment delete
        foreach (1..16) {
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
            # ticket free text
            my %TicketFreeText = ();
            foreach (1..16) {
                $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type => "TicketFreeKey$_",
                    Action => $Self->{Action},
                    UserID => $Self->{UserID},
                );
                $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type => "TicketFreeText$_",
                    Action => $Self->{Action},
                    UserID => $Self->{UserID},
                );
            }
            my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
                Config => \%TicketFreeText,
                Ticket => \%GetParam,
            );
            # ticket free time
            my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
                %Param,
                Ticket => \%GetParam,
            );
            # article free text
            my %ArticleFreeText = ();
            foreach (1..3) {
                $ArticleFreeText{"ArticleFreeKey$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type => "ArticleFreeKey$_",
                    Action => $Self->{Action},
                    UserID => $Self->{UserID},
                );
                $ArticleFreeText{"ArticleFreeText$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                    TicketID => $Self->{TicketID},
                    Type => "ArticleFreeText$_",
                    Action => $Self->{Action},
                    UserID => $Self->{UserID},
                );
            }
            my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
                Config => \%ArticleFreeText,
                Article => \%GetParam,
            );
            my $Output = $Self->{LayoutObject}->Header(Value => $Ticket{TicketNumber});
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->_Mask(
                Attachments => \@Attachments,
                %Ticket,
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
                %GetParam,
                %Error,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        if ($Self->{Config}->{Title}) {
            if (defined($GetParam{Title})) {
                $Self->{TicketObject}->TicketTitleUpdate(
                    Title => $GetParam{Title},
                    TicketID => $Self->{TicketID},
                    UserID => $Self->{UserID},
                );
            }
        }
        if ($Self->{Config}->{Owner}) {
            if ($GetParam{NewOwnerType} eq 'Old' && $GetParam{OldOwnerID}) {
                $Self->{TicketObject}->LockSet(
                    TicketID => $Self->{TicketID},
                    Lock => 'lock',
                    UserID => $Self->{UserID},
                );
                $Self->{TicketObject}->OwnerSet(
                    TicketID => $Self->{TicketID},
                    UserID => $Self->{UserID},
                    NewUserID => $GetParam{OldOwnerID},
                    Comment => $GetParam{Body},
                );
                $GetParam{NoAgentNotify} = 1;
            }
            elsif ($GetParam{NewOwnerID}) {
                $Self->{TicketObject}->LockSet(
                    TicketID => $Self->{TicketID},
                    Lock => 'lock',
                    UserID => $Self->{UserID},
                );
                $Self->{TicketObject}->OwnerSet(
                    TicketID => $Self->{TicketID},
                    UserID => $Self->{UserID},
                    NewUserID => $GetParam{NewOwnerID},
                    Comment => $GetParam{Body},
                );
                $GetParam{NoAgentNotify} = 1;
            }
        }
        if ($Self->{Config}->{Responsible}) {
            if ($GetParam{NewResponsibleID}) {
                $Self->{TicketObject}->ResponsibleSet(
                    TicketID => $Self->{TicketID},
                    UserID => $Self->{UserID},
                    NewUserID => $GetParam{NewResponsibleID},
                    Comment => $GetParam{Body},
                );
                $GetParam{NoAgentNotify} = 1;
            }
        }
        # add note
        my $ArticleID = '';
        if ($Self->{Config}->{Note}) {
            $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID => $Self->{TicketID},
                SenderType => 'agent',
                From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
                ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
                UserID => $Self->{UserID},
                HistoryType => $Self->{Config}->{HistoryType},
                HistoryComment => $Self->{Config}->{HistoryComment},
                ForceNotificationToUserID => [@{$Self->{InformUserID}}, @{$Self->{InvolvedUserID}}, ],
                %GetParam,
                NoAgentNotify => 0,
            );
            if (!$ArticleID) {
                return $Self->{LayoutObject}->ErrorScreen();
            }
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
            # remove pre submited attachments
            $Self->{UploadCachObject}->FormIDRemove(FormID => $Self->{FormID});
        }
        # set ticket free text
        foreach (1..16) {
            if (defined($GetParam{"TicketFreeKey$_"})) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $Self->{TicketID},
                    Key => $GetParam{"TicketFreeKey$_"},
                    Value => $GetParam{"TicketFreeText$_"},
                    Counter => $_,
                    UserID => $Self->{UserID},
                );
            }
        }
        # set ticket free time
        foreach (1..2) {
            if (defined($GetParam{"TicketFreeTime".$_."Year"}) &&
                defined($GetParam{"TicketFreeTime".$_."Month"}) &&
                defined($GetParam{"TicketFreeTime".$_."Day"}) &&
                defined($GetParam{"TicketFreeTime".$_."Hour"}) &&
                defined($GetParam{"TicketFreeTime".$_."Minute"})) {
                my %Time = $Self->{LayoutObject}->TransfromDateSelection(
                    %GetParam,
                    Prefix => "TicketFreeTime".$_,
                );
                $Self->{TicketObject}->TicketFreeTimeSet(
                    %Time,
                    Prefix => "TicketFreeTime",
                    TicketID => $Self->{TicketID},
                    Counter => $_,
                    UserID => $Self->{UserID},
                );
            }
        }
        # set article free text
        foreach (1..3) {
            if (defined($GetParam{"ArticleFreeKey$_"})) {
                $Self->{TicketObject}->ArticleFreeTextSet(
                    TicketID => $Self->{TicketID},
                    ArticleID => $ArticleID,
                    Key => $GetParam{"ArticleFreeKey$_"},
                    Value => $GetParam{"ArticleFreeText$_"},
                    Counter => $_,
                    UserID => $Self->{UserID},
                );
            }
        }
        # set priority
        if ($Self->{Config}->{Priority} && $GetParam{NewPriorityID}) {
            $Self->{TicketObject}->PrioritySet(
                TicketID => $Self->{TicketID},
                PriorityID => $GetParam{NewPriorityID},
                UserID => $Self->{UserID},
            );
        }
        # set state
        if ($Self->{Config}->{State} && $GetParam{NewStateID}) {
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
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenOverview});
        }
        # redirect
        return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
    }
    else {
        # fillup vars
        if (!defined($GetParam{Body}) && $Self->{Config}->{Body}) {
            $GetParam{Body} = $Self->{LayoutObject}->Output(Template => $Self->{Config}->{Body});
        }
        if (!defined($GetParam{Subject}) && $Self->{Config}->{Subject}) {
            $GetParam{Subject} = $Self->{LayoutObject}->Output(Template => $Self->{Config}->{Subject});
        }
        # get free text config options
        my %TicketFreeText = ();
        foreach (1..16) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type => "TicketFreeKey$_",
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type => "TicketFreeText$_",
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Ticket => \%Ticket,
            Config => \%TicketFreeText,
        );
        # get free text params
        my %TicketFreeTime = ();
        foreach (1..2) {
            if ($Ticket{"TicketFreeTime".$_}) {
                ($TicketFreeTime{"TicketFreeTime".$_.'Secunde'}, $TicketFreeTime{"TicketFreeTime".$_.'Minute'}, $TicketFreeTime{"TicketFreeTime".$_.'Hour'}, $TicketFreeTime{"TicketFreeTime".$_.'Day'}, $TicketFreeTime{"TicketFreeTime".$_.'Month'},  $TicketFreeTime{"TicketFreeTime".$_.'Year'}) = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $Self->{TimeObject}->TimeStamp2SystemTime(
                        String => $Ticket{"TicketFreeTime".$_},
                    ),
                );
            }
        }
        # free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
            Ticket => \%TicketFreeTime,
        );
        # get article free text config options
        my %ArticleFreeText = ();
        foreach (1..3) {
            $ArticleFreeText{"ArticleFreeKey$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type => "ArticleFreeKey$_",
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
            $ArticleFreeText{"ArticleFreeText$_"} = $Self->{TicketObject}->ArticleFreeTextGet(
                TicketID => $Self->{TicketID},
                Type => "ArticleFreeText$_",
                Action => $Self->{Action},
                UserID => $Self->{UserID},
            );
        }
        my %ArticleFreeTextHTML = $Self->{LayoutObject}->TicketArticleFreeText(
            Config => \%ArticleFreeText,
            Article => \%GetParam,
        );
        # print form ...
        my $Output = $Self->{LayoutObject}->Header(Value => $Ticket{TicketNumber});
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_Mask(
            %GetParam,
            %Ticket,
            %TicketFreeTextHTML,
            %TicketFreeTimeHTML,
            %ArticleFreeTextHTML,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _Mask {
    my $Self = shift;
    my %Param = @_;
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});

    if ($Self->{Config}->{Title}) {
        $Self->{LayoutObject}->Block(
            Name => 'Title',
            Data => \%Param,
        );
    }
    if ($Self->{Config}->{Owner}) {
        # get user of own groups
        my %ShownUsers = ();
        my %AllGroupsMembers = $Self->{UserObject}->UserList(
            Type => 'Long',
            Valid => 1,
        );
        if ($Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone')) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
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
        }
        # get old owner
        my @OldUserInfo = $Self->{TicketObject}->OwnerList(TicketID => $Self->{TicketID});
        $Param{'OwnerStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%ShownUsers,
            SelectedID => $Param{NewOwnerID},
            Name => 'NewOwnerID',
            Size => 10,
            OnClick => "change_selected(0)",
        );
        my %UserHash = ();
        if (@OldUserInfo) {
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
        }
        if (!%UserHash) {
            $UserHash{''} = '-';
        }
        # build string
        $Param{'OldOwnerStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%UserHash,
            SelectedID => $Param{OldOwnerID} || $OldUserInfo[0]->{UserID}.'1',
            Name => 'OldOwnerID',
            OnClick => "change_selected(2)",
        );
        if ($Param{NewOwnerType} && $Param{NewOwnerType} eq 'Old') {
            $Param{'NewOwnerType::Old'} = 'checked="checked"';
        }
        else {
            $Param{'NewOwnerType::New'} = 'checked="checked"';
        }
        $Self->{LayoutObject}->Block(
            Name => 'OwnerJs',
            Data => \%Param,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Owner',
            Data => \%Param,
        );
    }
    if ($Self->{Config}->{Responsible}) {
        # get user of own groups
        my %ShownUsers = ();
        my %AllGroupsMembers = $Self->{UserObject}->UserList(
            Type => 'Long',
            Valid => 1,
        );
        if ($Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone')) {
            %ShownUsers = %AllGroupsMembers;
        }
        else {
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
        }
        # get responsible
        $Param{'ResponsibleStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%ShownUsers,
            SelectedID => $Param{NewResponsibleID} || $Ticket{ResponsibleID},
            Name => 'NewResponsibleID',
            Size => 10,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Responsible',
            Data => \%Param,
        );
    }
    if ($Self->{Config}->{State}) {
        my %State = ();
        my %StateList = $Self->{TicketObject}->StateList(
            Action => $Self->{Action},
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
        );
        if (!$Self->{Config}->{StateDefault}) {
            $StateList{''} = '-';
#            $State{SelectedID} = $Param{StateID};
        }
        if (!$Param{NewStateID}) {
            if ($Self->{Config}->{StateDefault}) {
                $State{Selected} = $Self->{Config}->{StateDefault};
            }
        }
        else {
            $State{SelectedID} = $Param{NewStateID};
        }
        # build next states string
        $Param{'StateStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%StateList,
            Name => 'NewStateID',
            %State,
        );
        $Self->{LayoutObject}->Block(
            Name => 'State',
            Data => \%Param,
        );
        foreach (sort keys %StateList) {
            if ($_) {
                my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                    ID => $_,
                );
                if ($StateData{TypeName} =~ /pending/i) {
                    $Param{DateString} = $Self->{LayoutObject}->BuildDateSelection(
                        Format => 'DateInputFormatLong',
                        DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
                        %Param,
                    );
                    $Self->{LayoutObject}->Block(
                        Name => 'StatePending',
                        Data => \%Param,
                    );
                    last;
                }
            }
        }
    }
    # get next states
    if ($Self->{Config}->{Priority}) {
        my %Priority = ();
        my %PriorityList = $Self->{TicketObject}->PriorityList(
            UserID => $Self->{UserID},
            TicketID => $Self->{TicketID},
        );
        if (!$Self->{Config}->{PriorityDefault}) {
            $PriorityList{''} = '-';
#            $Priority{SelectedID} = $Param{PriorityID};
        }
        if (!$Param{NewPriorityID}) {
            if ($Self->{Config}->{PriorityDefault}) {
                $Priority{Selected} = $Self->{Config}->{PriorityDefault};
            }
        }
        else {
            $Priority{SelectedID} = $Param{NewPriorityID};
        }
        $Param{'PriorityStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%PriorityList,
            Name => 'NewPriorityID',
            %Priority,
        );
        $Self->{LayoutObject}->Block(
            Name => 'Priority',
            Data => \%Param,
        );
    }
    if ($Self->{Config}->{Note}) {
        $Self->{LayoutObject}->Block(
            Name => 'NoteJs',
            Data => { %Param },
        );
        $Self->{LayoutObject}->Block(
            Name => 'Note',
            Data => { %Param },
        );
        # agent list
        if ($Self->{Config}->{InformAgent}) {
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
        if ($Self->{Config}->{InvolvedAgent}) {
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
        # build ArticleTypeID string
        my %ArticleType = ();
        if (!$Param{ArticleTypeID}) {
            $ArticleType{Selected} = $Self->{Config}->{ArticleTypeDefault};
        }
        else {
            $ArticleType{SelectedID} = $Param{ArticleTypeID};
        }
        # get possible notes
        my %DefaultNoteTypes = %{$Self->{Config}->{ArticleTypes}};
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
        $Param{'ArticleTypeStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%NoteTypes,
            Name => 'ArticleTypeID',
            %ArticleType,
        );
        $Self->{LayoutObject}->Block(
            Name => 'ArticleType',
            Data => \%Param,
        );
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
    }
    # ticket free text
    my $Count = 0;
    foreach (1..16) {
        $Count++;
        if ($Self->{Config}->{'TicketFreeText'}->{$Count}) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeText',
                Data => {
                    TicketFreeKeyField => $Param{'TicketFreeKeyField'.$Count},
                    TicketFreeTextField => $Param{'TicketFreeTextField'.$Count},
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeText'.$Count,
                Data => {
                    %Param,
                    Count => $Count,
                },
            );
        }
    }
    $Count = 0;
    foreach (1..2) {
        $Count++;
        if ($Self->{Config}->{'TicketFreeTime'}->{$Count}) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTime',
                Data => {
                    TicketFreeTimeKey => $Self->{ConfigObject}->Get('TicketFreeTimeKey'.$Count),
                    TicketFreeTime => $Param{'TicketFreeTime'.$Count},
                    Count => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTime'.$Count,
                Data => {
                    %Param,
                    Count => $Count,
                },
            );
        }
    }
    # article free text
    $Count = 0;
    foreach (1..3) {
        $Count++;
        if ($Self->{Config}->{'ArticleFreeText'}->{$Count}) {
            $Self->{LayoutObject}->Block(
                Name => 'ArticleFreeText',
                Data => {
                    ArticleFreeKeyField => $Param{'ArticleFreeKeyField'.$Count},
                    ArticleFreeTextField => $Param{'ArticleFreeTextField'.$Count},
                    Count => $Count,
                },
            );
            $Self->{LayoutObject}->Block(
                Name => 'ArticleFreeText'.$Count,
                Data => {
                    %Param,
                    Count => $Count,
                },
            );
        }
    }
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketNote', Data => \%Param);
}

1;
