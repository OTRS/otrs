# --
# Kernel/Modules/AgentTicketPhoneOutbound.pm - to handle phone calls
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketPhoneOutbound.pm,v 1.10 2007-01-31 08:27:02 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketPhoneOutbound;

use strict;
use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::CheckItem;
use Kernel::System::Web::UploadCache;
use Kernel::System::State;
use Mail::Address;

use vars qw($VERSION);
$VERSION = '$Revision: 1.10 $';
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

    $Self->{SystemAddress} = Kernel::System::SystemAddress->new(%Param);
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);

    # get form id
    $Self->{FormID} = $Self->{ParamObject}->GetParam(Param => 'FormID');
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
    # check needed stuff
    if (!$Self->{TicketID}) {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => "Got no TicketID!",
            Comment => 'System Error!',
        );
    }
    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => $Self->{Config}->{Permission},
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # get lock state && write (lock) permissions
    if ($Self->{Config}->{RequiredLock}) {
        if (!$Self->{TicketObject}->LockIsTicketLocked(TicketID => $Self->{TicketID})) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Self->{TicketID},
                Lock => 'lock',
                UserID => $Self->{UserID},
            );
            if ($Self->{TicketObject}->OwnerSet(
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID},
                NewUserID => $Self->{UserID},
            )) {
                # show lock state
                $Self->{LayoutObject}->Block(
                    Name => 'TicketLocked',
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
    foreach (qw(AttachmentUpload
        Body Subject TimeUnits NextStateID
        Year Month Day Hour Minute
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10
    )) {
        $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
    }
    # get ticket free text params
    foreach (1..16) {
        $GetParam{"TicketFreeKey$_"} = $Self->{ParamObject}->GetParam(Param => "TicketFreeKey$_");
        $GetParam{"TicketFreeText$_"} = $Self->{ParamObject}->GetParam(Param => "TicketFreeText$_");
    }
    # get ticket free time params
    foreach (1..6) {
        foreach my $Type (qw(Used Year Month Day Hour Minute)) {
            $GetParam{"TicketFreeTime".$_.$Type} = $Self->{ParamObject}->GetParam(Param => "TicketFreeTime".$_.$Type);
        }
        if (!$Self->{ConfigObject}->Get('TicketFreeTimeOptional'.$_)) {
            $GetParam{'TicketFreeTime'.$_.'Used'} = 1;
        }
    }
    # get article free text params
    foreach (1..3) {
        $GetParam{"ArticleFreeKey$_"} = $Self->{ParamObject}->GetParam(Param => "ArticleFreeKey$_");
        $GetParam{"ArticleFreeText$_"} = $Self->{ParamObject}->GetParam(Param => "ArticleFreeText$_");
    }

    if (!$Self->{Subaction}) {
        # check it it's a agent-customer ticket
        if ($Self->{ConfigObject}->Get('Ticket::AgentCanBeCustomer') &&
            $Ticket{CustomerUserID} &&
            $Ticket{CustomerUserID} eq $Self->{UserLogin}
        ) {
            # redirect for agent follow up screen
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentTicketCustomerFollowUp&TicketID=$Self->{TicketID}",
            );
        }
        # get ticket info
        my %CustomerData = ();
        if ($Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose')) {
            if ($Ticket{CustomerUserID}) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $Ticket{CustomerUserID},
                );
            }
            elsif ($Ticket{CustomerID}) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    CustomerID => $Ticket{CustomerID},
                );
            }
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
        # free time
        my %TicketFreeTime = ();
        foreach (1..6) {
            $TicketFreeTime{"TicketFreeTime".$_.'Optional'} = $Self->{ConfigObject}->Get('TicketFreeTimeOptional'.$_) || 0;
            $TicketFreeTime{"TicketFreeTime".$_.'Used'} = $GetParam{'TicketFreeTime'.$_.'Used'};

            if ($Ticket{"TicketFreeTime".$_}) {
                (
                    $TicketFreeTime{"TicketFreeTime".$_.'Secunde'},
                    $TicketFreeTime{"TicketFreeTime".$_.'Minute'},
                    $TicketFreeTime{"TicketFreeTime".$_.'Hour'},
                    $TicketFreeTime{"TicketFreeTime".$_.'Day'},
                    $TicketFreeTime{"TicketFreeTime".$_.'Month'},
                    $TicketFreeTime{"TicketFreeTime".$_.'Year'}
                ) = $Self->{TimeObject}->SystemTime2Date(
                    SystemTime => $Self->{TimeObject}->TimeStamp2SystemTime(
                        String => $Ticket{"TicketFreeTime".$_},
                    ),
                );
                $TicketFreeTime{"TicketFreeTime".$_.'Used'} = 1;
            }
        }
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
            Ticket => \%TicketFreeTime,
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
        # print form ...
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        $Output .= $Self->_MaskPhone(
            TicketID => $Self->{TicketID},
            QueueID => $Self->{QueueID},
            TicketNumber => $Ticket{TicketNumber},
            NextStates => $Self->_GetNextStates(),
            CustomerData => \%CustomerData,
            Subject => $Self->{LayoutObject}->Output(Template => $Self->{Config}->{Subject}),
            Body => $Self->{LayoutObject}->Output(Template => $Self->{Config}->{Body}),
            %TicketFreeTextHTML,
            %TicketFreeTimeHTML,
            %ArticleFreeTextHTML,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # save new phone article to existing ticket
    elsif ($Self->{Subaction} eq 'Store') {
        my %Error = ();
        # rewrap body if exists
        if ($GetParam{Body}) {
            $GetParam{Body} =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
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
        # check if date is valid
        my %StateData = $Self->{StateObject}->StateGet(ID => $GetParam{NextStateID});
        if ($StateData{TypeName} =~ /^pending/i) {
            if (!$Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0)) {
                $Error{"Date invalid"} = 'invalid';
            }
            if ($Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0) < $Self->{TimeObject}->SystemTime()) {
                $Error{"Date invalid"} = 'invalid';
            }
        }
        if (%Error) {
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
                Config => \%TicketFreeText,
                Ticket => \%GetParam,
            );
            # free time
            my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
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
            # get ticket info if ticket id is given
            my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
            # check permissions if it's a existing ticket
            if (!$Self->{TicketObject}->Permission(
                Type => 'phone',
                TicketID => $Self->{TicketID},
                UserID => $Self->{UserID})) {
                # error screen, don't show ticket
                return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
            }
            # get ticket info
            my $Tn = $Ticket{TicketNumber};
            my %CustomerData = ();
            if ($Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose')) {
                if ($Ticket{CustomerUserID}) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $Ticket{CustomerUserID},
                    );
                }
                elsif ($Ticket{CustomerID}) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        CustomerID => $Ticket{CustomerID},
                    );
                }
            }
            # header
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            $Output .= $Self->_MaskPhone(
                TicketID => $Self->{TicketID},
                TicketNumber => $Tn,
                NextStates => $Self->_GetNextStates(),
                CustomerData => \%CustomerData,
                Attachments => \@Attachments,
                %GetParam,
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
            if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
                TicketID => $Self->{TicketID},
                ArticleType => $Self->{Config}->{ArticleType},
                SenderType => $Self->{Config}->{SenderType},
                From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
                Subject => $GetParam{Subject},
                Body => $GetParam{Body},
                ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
                UserID => $Self->{UserID},
                HistoryType => $Self->{Config}->{HistoryType},
                HistoryComment => $Self->{Config}->{HistoryComment} || '%%',
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
                foreach (1..6) {
                    if (defined($GetParam{"TicketFreeTime".$_."Year"}) &&
                        defined($GetParam{"TicketFreeTime".$_."Month"}) &&
                        defined($GetParam{"TicketFreeTime".$_."Day"}) &&
                        defined($GetParam{"TicketFreeTime".$_."Hour"}) &&
                        defined($GetParam{"TicketFreeTime".$_."Minute"})
                    ) {
                        my %Time;
                        $Time{"TicketFreeTime".$_."Year"} = 0;
                        $Time{"TicketFreeTime".$_."Month"} = 0;
                        $Time{"TicketFreeTime".$_."Day"} = 0;
                        $Time{"TicketFreeTime".$_."Hour"} = 0;
                        $Time{"TicketFreeTime".$_."Minute"} = 0;
                        $Time{"TicketFreeTime".$_."Secunde"} = 0;

                        if ($GetParam{"TicketFreeTime".$_."Used"}) {
                            %Time = $Self->{LayoutObject}->TransfromDateSelection(
                                %GetParam,
                                Prefix => "TicketFreeTime".$_,
                            );
                        }
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
                # set state
                $Self->{TicketObject}->StateSet(
                    TicketID => $Self->{TicketID},
                    ArticleID => $ArticleID,
                    StateID => $GetParam{NextStateID},
                    UserID => $Self->{UserID},
                );
                # should i set an unlock? yes if the ticket is closed
                my %StateData = $Self->{StateObject}->StateGet(ID => $GetParam{NextStateID});
                if ($StateData{TypeName} =~ /^close/i) {
                    $Self->{TicketObject}->LockSet(
                        TicketID => $Self->{TicketID},
                        Lock => 'unlock',
                        UserID => $Self->{UserID},
                    );
                }
                # set pending time if next state is a pending state
                elsif ($StateData{TypeName} =~ /^pending/i) {
                    $Self->{TicketObject}->TicketPendingTimeSet(
                        UserID => $Self->{UserID},
                        TicketID => $Self->{TicketID},
                        %GetParam,
                    );
                }
                # redirect to last screen (e. g. zoom view) and to queue view if
                # the ticket is closed (move to the next task).
                if ($StateData{TypeName} =~ /^close/i) {
                    return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenOverview});
                }
                else {
                    return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
                }
            }
            else {
                # show error of creating article
                return $Self->{LayoutObject}->ErrorScreen();
            }
        }
    }
    else {
        return $Self->{LayoutObject}->ErrorScreen(
            Message => 'No Subaction!!',
            Comment => 'Please contact your admin',
        );
    }
}

sub _GetNextStates {
    my $Self = shift;
    my %Param = @_;
    my %NextStates = $Self->{TicketObject}->StateList(
        TicketID => $Self->{TicketID},
        Action => $Self->{Action},
        UserID => $Self->{UserID},
    );
    return \%NextStates;
}

sub _GetUsers {
    my $Self = shift;
    my %Param = @_;
    # get users
    my %ShownUsers = ();
    my %AllGroupsMembers = $Self->{UserObject}->UserList(
        Type => 'Long',
        Valid => 1,
    );
    # just show only users with selected custom queue
    if ($Param{QueueID} && !$Param{AllUsers}) {
        my @UserIDs = $Self->{TicketObject}->GetSubscribedUserIDsByQueueID(%Param);
        foreach (keys %AllGroupsMembers) {
            my $Hit = 0;
            foreach my $UID (@UserIDs) {
                if ($UID eq $_) {
                    $Hit = 1;
                }
            }
            if (!$Hit) {
                delete $AllGroupsMembers{$_};
            }
        }
    }
    # show all system users
    if ($Self->{ConfigObject}->Get('Ticket::ChangeOwnerToEveryone')) {
        %ShownUsers = %AllGroupsMembers;
    }
    # show all users who are rw in the queue group
    elsif ($Param{QueueID}) {
        my $GID = $Self->{QueueObject}->GetQueueGroupID(QueueID => $Param{QueueID});
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
    return \%ShownUsers;
}

sub _GetTos {
    my $Self = shift;
    my %Param = @_;
    # check own selection
    my %NewTos = ();
    if ($Self->{ConfigObject}->{'Ticket::Frontend::NewQueueOwnSelection'}) {
        %NewTos = %{$Self->{ConfigObject}->{'Ticket::Frontend::NewQueueOwnSelection'}};
    }
    else {
        # SelectionType Queue or SystemAddress?
        my %Tos = ();
        if ($Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue') {
            %Tos = $Self->{TicketObject}->MoveList(
                Type => 'create',
                Action => $Self->{Action},
                QueueID => $Self->{QueueID},
                UserID => $Self->{UserID},
            );
        }
        else {
            %Tos = $Self->{DBObject}->GetTableData(
                Table => 'system_address',
                What => 'queue_id, id',
                Valid => 1,
                Clamp => 1,
            );
        }
        # get create permission queues
        my %UserGroups = $Self->{GroupObject}->GroupMemberList(
            UserID => $Self->{UserID},
            Type => 'create',
            Result => 'HASH',
            Cached => 1,
        );
        foreach (keys %Tos) {
            if ($UserGroups{$Self->{QueueObject}->GetQueueGroupID(QueueID => $_)}) {
                $NewTos{$_} = $Tos{$_};
            }
        }
        # build selection string
        foreach (keys %NewTos) {
            my %QueueData = $Self->{QueueObject}->QueueGet(ID => $_);
            my $Srting = $Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionString') || '<Realname> <<Email>> - Queue: <Queue>';
            $Srting =~ s/<Queue>/$QueueData{Name}/g;
            $Srting =~ s/<QueueComment>/$QueueData{Comment}/g;
            if ($Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') ne 'Queue') {
                my %SystemAddressData = $Self->{SystemAddress}->SystemAddressGet(ID => $NewTos{$_});
                $Srting =~ s/<Realname>/$SystemAddressData{Realname}/g;
                $Srting =~ s/<Email>/$SystemAddressData{Name}/g;
            }
            $NewTos{$_} = $Srting;
        }
    }
    # adde empty selection
    $NewTos{''} = '-';
    return \%NewTos;
}

sub _MaskPhone {
    my $Self = shift;
    my %Param = @_;
    $Param{FormID} = $Self->{FormID};
    # build next states string
    my %Selected = ();
    if ($Param{NextStateID}) {
        $Selected{SelectedID} = $Param{NextStateID};
    }
    elsif ($Self->{Config}->{State}) {
        $Selected{Selected} = $Self->{Config}->{State};
    }
    else {
        $Param{NextStates}->{''} = '-';
    }
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NextStateID',
        %Selected,
    );
    # customer info string
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose')) {
        $Param{CustomerTable} = $Self->{LayoutObject}->AgentCustomerViewTable(
            Data => $Param{CustomerData},
            Max => $Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoComposeMaxSize'),
        );
        $Self->{LayoutObject}->Block(
            Name => 'CustomerTable',
            Data => \%Param,
        );
    }
    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format => 'DateInputFormatLong',
        DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
    );
    # do html quoting
    foreach (qw(From To Cc)) {
        $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_}) || '';
    }
    # prepare errors!
    if ($Param{Errors}) {
        foreach (keys %{$Param{Errors}}) {
            $Param{$_} = "* ".$Self->{LayoutObject}->Ascii2Html(Text => $Param{Errors}->{$_});
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
    foreach (1..6) {
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
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketPhoneOutbound', Data => \%Param);
}

1;
