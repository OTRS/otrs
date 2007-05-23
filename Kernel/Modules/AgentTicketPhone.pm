# --
# Kernel/Modules/AgentTicketPhone.pm - to handle phone calls
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketPhone.pm,v 1.43 2007-05-23 17:43:00 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketPhone;

use strict;
use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::CheckItem;
use Kernel::System::Web::UploadCache;
use Kernel::System::State;
use Mail::Address;

use vars qw($VERSION);
$VERSION = '$Revision: 1.43 $';
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
    # get params
    my %GetParam = ();
    foreach (qw(AttachmentUpload ArticleID PriorityID NewUserID
        From Subject Body NextStateID TimeUnits
        Year Month Day Hour Minute
        NewResponsibleID ResponsibleAll OwnerAll TypeID ServiceID SLAID
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 AttachmentDelete11 AttachmentDelete12
        AttachmentDelete13 AttachmentDelete14 AttachmentDelete15 AttachmentDelete16
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
        $GetParam{'TicketFreeTime'.$_.'Optional'} = $Self->{ConfigObject}->Get('TicketFreeTimeOptional'.$_) || 0;
        if (!$Self->{ConfigObject}->Get('TicketFreeTimeOptional'.$_)) {
            $GetParam{'TicketFreeTime'.$_.'Used'} = 1;
        }
    }
    # get article free text params
    foreach (1..3) {
        $GetParam{"ArticleFreeKey$_"} = $Self->{ParamObject}->GetParam(Param => "ArticleFreeKey$_");
        $GetParam{"ArticleFreeText$_"} = $Self->{ParamObject}->GetParam(Param => "ArticleFreeText$_");
    }

    if (!$Self->{Subaction} || $Self->{Subaction} eq 'Created') {
        # header
        my $Output = $Self->{LayoutObject}->Header();
        $Output .= $Self->{LayoutObject}->NavigationBar();
        # if there is no ticket id!
        if ($Self->{TicketID} && $Self->{Subaction} eq 'Created') {
            # notify info
            my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
            $Output .= $Self->{LayoutObject}->Notify(
                Info => 'Ticket "%s" created!", "'.$Ticket{TicketNumber},
                Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='.$Ticket{TicketID},
            );
        }
        # store last queue screen
        if ($Self->{LastScreenOverview} !~ /Action=AgentTicketPhone/) {
            $Self->{SessionObject}->UpdateSessionID(
                SessionID => $Self->{SessionID},
                Key => 'LastScreenOverview',
                Value => $Self->{RequestedURL},
            );
        }

        # get split article if given
        # get ArticleID
        my %Article = ();
        my %CustomerData = ();
        if ($GetParam{ArticleID}) {
            %Article = $Self->{TicketObject}->ArticleGet(ArticleID => $GetParam{ArticleID});
            $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
                TicketNumber => $Article{TicketNumber},
                Subject => $Article{Subject} || '',
            );
            # check if original content isn't text/plain or text/html, don't use it
            if ($Article{'ContentType'}) {
                if ($Article{'ContentType'} =~ /text\/html/i) {
                    $Article{Body} =~ s/\<.+?\>//gs;
                }
                elsif ($Article{'ContentType'} !~ /text\/plain/i) {
                    $Article{Body} = "-> no quotable message <-";
                }
            }
            # show customer info
            if ($Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose')) {
                if ($Article{CustomerUserID}) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        User => $Article{CustomerUserID},
                    );
                }
                elsif ($Article{CustomerID}) {
                    %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                        CustomerID => $Article{CustomerID},
                    );
                }
            }
            if ($Article{CustomerUserID}) {
                my %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                    UserLogin => $Article{CustomerUserID},
                );
                foreach (sort keys %CustomerUserList) {
                    $Article{From} = $CustomerUserList{$_};
                }
            }
        }
        # get default selections
        my %TicketFreeDefault = ();
        foreach (1..16) {
            $TicketFreeDefault{'TicketFreeKey'.$_} = $GetParam{'TicketFreeKey'.$_} || $Self->{ConfigObject}->Get('TicketFreeKey'.$_.'::DefaultSelection');
            $TicketFreeDefault{'TicketFreeText'.$_} = $GetParam{'TicketFreeText'.$_} || $Self->{ConfigObject}->Get('TicketFreeText'.$_.'::DefaultSelection');
        }
        # get free text config options
        my %TicketFreeText = ();
        foreach (1..16) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Action => $Self->{Action},
                Type => "TicketFreeKey$_",
                UserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Action => $Self->{Action},
                Type => "TicketFreeText$_",
                UserID => $Self->{UserID},
            );
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => { %TicketFreeDefault,
                $Self->{UserObject}->GetUserData(
                    UserID => $Self->{UserID},
                    Cached => 1,
                ),
            },
        );
        # free time
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
            %Param,
            Ticket => \%GetParam,
        );
        # get article free text default selections
        my %ArticleFreeDefault = ();
        foreach (1..3) {
            $ArticleFreeDefault{'ArticleFreeKey'.$_} = $GetParam{'ArticleFreeKey'.$_} || $Self->{ConfigObject}->Get('ArticleFreeKey'.$_.'::DefaultSelection');
            $ArticleFreeDefault{'ArticleFreeText'.$_} = $GetParam{'ArticleFreeText'.$_} || $Self->{ConfigObject}->Get('ArticleFreeText'.$_.'::DefaultSelection');
        }
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
            Article => {
                %GetParam,
                %ArticleFreeDefault,
            },
        );
        # html output
        $Output .= $Self->_MaskPhoneNew(
            QueueID => $Self->{QueueID},
            NextStates => $Self->_GetNextStates(QueueID => $Self->{QueueID} || 1),
            Priorities => $Self->_GetPriorities(QueueID => $Self->{QueueID} || 1),
            Types => $Self->_GetTypes(QueueID => $Self->{QueueID} || 1),
            Services => $Self->_GetServices(QueueID => $Self->{QueueID} || 1),
            SLAs => $Self->_GetSLAs(QueueID => $Self->{QueueID} || 1, %GetParam),
            Users => $Self->_GetUsers(QueueID => $Self->{QueueID}),
            To => $Self->_GetTos(QueueID => $Self->{QueueID}),
            From => $Article{From},
            Subject => $Article{Subject} || $Self->{LayoutObject}->Output(Template => $Self->{Config}->{Subject}),
            Body => $Article{Body} || $Self->{LayoutObject}->Output(Template => $Self->{Config}->{Body}),
            CustomerID => $Article{CustomerID},
            CustomerUser => $Article{CustomerUserID},
            CustomerData => \%CustomerData,
            %TicketFreeTextHTML,
            %TicketFreeTimeHTML,
            %ArticleFreeTextHTML,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # create new ticket and article
    elsif ($Self->{Subaction} eq 'StoreNew') {
        my %Error = ();
        my %StateData = ();
        if ($GetParam{NextStateID}) {
            %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $GetParam{NextStateID},
            );
        }
        my $NextState = $StateData{Name} || '';
        my $Dest = $Self->{ParamObject}->GetParam(Param => 'Dest') || '';
        my ($NewQueueID, $To) = split(/\|\|/, $Dest);
        my $CustomerUser = $Self->{ParamObject}->GetParam(Param => 'CustomerUser') ||
            $Self->{ParamObject}->GetParam(Param => 'PreSelectedCustomerUser') ||
            $Self->{ParamObject}->GetParam(Param => 'SelectedCustomerUser') || '';
        my $SelectedCustomerUser = $Self->{ParamObject}->GetParam(Param => 'SelectedCustomerUser') || '';
        my $CustomerID = $Self->{ParamObject}->GetParam(Param => 'CustomerID') || '';
        my $ExpandCustomerName = $Self->{ParamObject}->GetParam(Param => 'ExpandCustomerName') || 0;
        if ($Self->{ParamObject}->GetParam(Param => 'OwnerAllRefresh')) {
            $GetParam{OwnerAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ($Self->{ParamObject}->GetParam(Param => 'ResponsibleAllRefresh')) {
            $GetParam{ResponsibleAll} = 1;
            $ExpandCustomerName = 3;
        }
        if ($Self->{ParamObject}->GetParam(Param => 'ClearFrom')) {
            $GetParam{From} = '';
            $ExpandCustomerName = 3;
        }
        foreach (1..2) {
            my $Item = $Self->{ParamObject}->GetParam(Param => "ExpandCustomerName$_") || 0;
            if ($_ == 1 && $Item) {
                $ExpandCustomerName = 1;
            }
            elsif ($_ == 2 && $Item) {
                $ExpandCustomerName = 2;
            }
        }
        # rewrap body if exists
        if ($GetParam{Body}) {
            $GetParam{Body} =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
        }
        # check pending date
        if ($StateData{TypeName} && $StateData{TypeName} =~ /^pending/i) {
            if (!$Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0)) {
                $Error{"Date invalid"} = 'invalid';
            }
            if ($Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0) < $Self->{TimeObject}->SystemTime()) {
                $Error{"Date invalid"} = 'invalid';
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

        # get free text config options
        my %TicketFreeText = ();
        foreach (1..16) {
            $TicketFreeText{"TicketFreeKey$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type => "TicketFreeKey$_",
                Action => $Self->{Action},
                QueueID => $NewQueueID || 0,
                UserID => $Self->{UserID},
            );
            $TicketFreeText{"TicketFreeText$_"} = $Self->{TicketObject}->TicketFreeTextGet(
                TicketID => $Self->{TicketID},
                Type => "TicketFreeText$_",
                Action => $Self->{Action},
                QueueID => $NewQueueID || 0,
                UserID => $Self->{UserID},
            );
            # check required FreeTextField (if configured)
            if ($Self->{Config}{'TicketFreeText'}{$_} == 2 && $GetParam{"TicketFreeText$_"} eq '' && $ExpandCustomerName == 0) {
                $Error{"TicketFreeTextField$_ invalid"} = 'invalid';
            }
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
        # expand customer name
        my %CustomerUserData = ();
        if ($ExpandCustomerName == 1) {
            # search customer
            my %CustomerUserList = ();
            %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                Search => $GetParam{From},
            );
            # check if just one customer user exists
            # if just one, fillup CustomerUserID and CustomerID
            $Param{CustomerUserListCount} = 0;
            foreach (keys %CustomerUserList) {
                $Param{CustomerUserListCount}++;
                $Param{CustomerUserListLast} = $CustomerUserList{$_};
                $Param{CustomerUserListLastUser} = $_;
            }
            if ($Param{CustomerUserListCount} == 1) {
                $GetParam{From} = $Param{CustomerUserListLast};
                $Error{"ExpandCustomerName"} = 1;
                my %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $Param{CustomerUserListLastUser},
                );
                if ($CustomerUserData{UserCustomerID}) {
                    $CustomerID = $CustomerUserData{UserCustomerID};
                }
                if ($CustomerUserData{UserLogin}) {
                    $CustomerUser = $CustomerUserData{UserLogin};
                }
            }
            # if more the one customer user exists, show list
            # and clean CustomerUserID and CustomerID
            else {
                # don't check email syntax on multi customer select
                $Self->{ConfigObject}->Set(Key => 'CheckEmailAddresses', Value => 0);
                $CustomerID = '';
                $Param{"FromOptions"} = \%CustomerUserList;
                # clear from if there is no customer found
                if (!%CustomerUserList) {
                    $GetParam{From} = '';
                }
                $Error{"ExpandCustomerName"} = 1;
            }
        }
        # get from and customer id if customer user is given
        elsif ($ExpandCustomerName == 2) {
            %CustomerUserData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $CustomerUser,
            );
            my %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                UserLogin => $CustomerUser,
            );
            foreach (keys %CustomerUserList) {
                $GetParam{From} = $CustomerUserList{$_};
            }
            if ($CustomerUserData{UserCustomerID}) {
                $CustomerID = $CustomerUserData{UserCustomerID};
            }
            if ($CustomerUserData{UserLogin}) {
                $CustomerUser = $CustomerUserData{UserLogin};
            }
            $Error{"ExpandCustomerName"} = 1;
        }
        # if a new destination queue is selected
        elsif ($ExpandCustomerName == 3) {
            $Error{NoSubmit} = 1;
            $CustomerUser = $SelectedCustomerUser;
        }
        # 'just' no submit
        elsif ($ExpandCustomerName == 4) {
            $Error{NoSubmit} = 1;
        }

        # show customer info
        my %CustomerData = ();
        if ($Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose')) {
            if ($CustomerUser || $SelectedCustomerUser) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $CustomerUser || $SelectedCustomerUser,
                );
            }
            elsif ($CustomerID) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    CustomerID => $CustomerID,
                );
            }
        }

        # check some values
        foreach my $Email (Mail::Address->parse($GetParam{From})) {
            if (!$Self->{CheckItemObject}->CheckEmail(Address => $Email->address())) {
                $Error{"From invalid"} .= $Self->{CheckItemObject}->CheckError();
            }
        }
        if (!$GetParam{From} && $ExpandCustomerName != 1 && $ExpandCustomerName == 0) {
            $Error{"From invalid"} = 'invalid';
        }
        if (!$GetParam{Subject} && $ExpandCustomerName == 0) {
            $Error{"Subject invalid"} = 'invalid';
        }
        if (!$NewQueueID && $ExpandCustomerName == 0) {
            $Error{"Destination invalid"} = 'invalid';
        }
        if ($Self->{ConfigObject}->Get('Ticket::Service') && $GetParam{SLAID} && !$GetParam{ServiceID}) {
            $Error{"Service invalid"} = 'invalid';
        }
        if (%Error) {
            # header
            my $Output = $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();

            # html output
            $Output .= $Self->_MaskPhoneNew(
                QueueID => $Self->{QueueID},
                Users => $Self->_GetUsers(QueueID => $NewQueueID, AllUsers => $GetParam{OwnerAll}),
                UserSelected => $GetParam{NewUserID},
                ResponsibleUsers => $Self->_GetUsers(QueueID => $NewQueueID, AllUsers => $GetParam{ResponsibleAll}),
                ResponsibleUserSelected => $GetParam{NewResponsibleID},
                NextStates => $Self->_GetNextStates(QueueID => $NewQueueID || 1),
                NextState => $NextState,
                Priorities => $Self->_GetPriorities(QueueID => $NewQueueID || 1),
                Types => $Self->_GetTypes(QueueID => $NewQueueID || 1),
                Services => $Self->_GetServices(QueueID => $NewQueueID || 1),
                SLAs => $Self->_GetSLAs(QueueID => $NewQueueID || 1, %GetParam),
                CustomerID => $Self->{LayoutObject}->Ascii2Html(Text => $CustomerID),
                CustomerUser => $CustomerUser,
                CustomerData => \%CustomerData,
                FromOptions => $Param{"FromOptions"},
                To => $Self->_GetTos(QueueID => $NewQueueID),
                ToSelected => $Dest,
                Errors => \%Error,
                Attachments => \@Attachments,
                %GetParam,
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
            );
            # show customer tickets
            my @TicketIDs = ();
            if ($CustomerUser && $Self->{Config}->{ShownCustomerTickets}) {
                # get secondary customer ids
                my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDs(User => $CustomerUser);
                # get own customer id
                my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $CustomerUser);
                if ($CustomerData{UserCustomerID}) {
                    push (@CustomerIDs, $CustomerData{UserCustomerID});
                }

                @TicketIDs = $Self->{TicketObject}->TicketSearch(
                    Result => 'ARRAY',
                    Limit => $Self->{Config}->{ShownCustomerTickets},
                    CustomerID => \@CustomerIDs,

                    UserID => $Self->{UserID},
                    Permission => 'ro',
                );
            }
            foreach my $TicketID (@TicketIDs) {
                my %Article = $Self->{TicketObject}->ArticleLastCustomerArticle(TicketID => $TicketID);
                # get acl actions
                $Self->{TicketObject}->TicketAcl(
                    Data => '-',
                    Action => $Self->{Action},
                    TicketID => $TicketID,
                    ReturnType => 'Action',
                    ReturnSubType => '-',
                    UserID => $Self->{UserID},
                );
                my %AclAction = $Self->{TicketObject}->TicketAclActionData();
                # run ticket menu modules
                if (ref($Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule')) eq 'HASH') {
                    my %Menus = %{$Self->{ConfigObject}->Get('Ticket::Frontend::PreMenuModule')};
                    my $Counter = 0;
                    foreach my $Menu (sort keys %Menus) {
                        # load module
                        if ($Self->{MainObject}->Require($Menus{$Menu}->{Module})) {
                            my $Object = $Menus{$Menu}->{Module}->new(
                                %{$Self},
                                TicketID => $TicketID,
                            );
                            # run module
                            $Counter = $Object->Run(
                                %Param,
                                TicketID => $TicketID,
                                Ticket => \%Article,
                                Counter => $Counter,
                                ACL => \%AclAction,
                                Config => $Menus{$Menu},
                            );
                        }
                        else {
                            return $Self->{LayoutObject}->FatalError();
                        }
                    }
                }
                foreach (qw(From To Cc Subject)) {
                    if ($Article{$_}) {
                        $Self->{LayoutObject}->Block(
                            Name => 'Row',
                            Data => {
                                Key => $_,
                                Value => $Article{$_},
                            },
                        );
                    }
                }
                foreach (1..3) {
                    if ($Article{"FreeText$_"}) {
                        $Self->{LayoutObject}->Block(
                            Name => 'ArticleFreeText',
                            Data => {
                                Key => $Article{"FreeKey$_"},
                                Value => $Article{"FreeText$_"},
                            },
                        );
                    }
                }
                $Output .= $Self->{LayoutObject}->Output(
                    TemplateFile => 'AgentTicketQueueTicketViewLite',
                    Data => {
                        %AclAction,
                        %Article,
                        Age => $Self->{LayoutObject}->CustomerAge(Age => $Article{Age}, Space => ' '),
                        TicketOverTime => $Self->{LayoutObject}->CustomerAge(Age => $Article{TicketOverTime}, Space => ' '),
                    }
                );
            }
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            Title => $GetParam{Subject},
            QueueID => $NewQueueID,
            Subject => $GetParam{Subject},
            Lock => 'unlock',
            TypeID => $GetParam{TypeID} || '',
            ServiceID => $GetParam{ServiceID} || '',
            SLAID => $GetParam{SLAID} || '',
            StateID => $GetParam{NextStateID},
            PriorityID => $GetParam{PriorityID},
            OwnerID => $Self->{UserID},
            CustomerNo => $CustomerID,
            CustomerUser => $SelectedCustomerUser,
            UserID => $Self->{UserID},
        );
        # set ticket free text
        foreach (1..16) {
            if (defined($GetParam{"TicketFreeKey$_"})) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
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
                    TicketID => $TicketID,
                    Counter => $_,
                    UserID => $Self->{UserID},
                );
            }
        }
        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ($GetParam{NewUserID}) {
            $NoAgentNotify = 1;
        }
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            NoAgentNotify => $NoAgentNotify,
            TicketID => $TicketID,
            ArticleType => $Self->{Config}->{ArticleType},
            SenderType => $Self->{Config}->{SenderType},
            From => $GetParam{From},
            To => $To,
            Subject => $GetParam{Subject},
            Body => $GetParam{Body},
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => $Self->{Config}->{HistoryType},
            HistoryComment => $Self->{Config}->{HistoryComment} || '%%',
            AutoResponseType => 'auto reply',
            OrigHeader => {
                From => $GetParam{From},
                To => $GetParam{To},
                Subject => $GetParam{Subject},
                Body => $GetParam{Body},
            },
            Queue => $Self->{QueueObject}->QueueLookup(QueueID => $NewQueueID),
        )) {
            # set article free text
            foreach (1..3) {
                if (defined($GetParam{"ArticleFreeKey$_"})) {
                    $Self->{TicketObject}->ArticleFreeTextSet(
                        TicketID => $TicketID,
                        ArticleID => $ArticleID,
                        Key => $GetParam{"ArticleFreeKey$_"},
                        Value => $GetParam{"ArticleFreeText$_"},
                        Counter => $_,
                        UserID => $Self->{UserID},
                    );
                }
            }
            # set owner (if new user id is given)
            if ($GetParam{NewUserID}) {
                $Self->{TicketObject}->OwnerSet(
                    TicketID => $TicketID,
                    NewUserID => $GetParam{NewUserID},
                    UserID => $Self->{UserID},
                );
                # set lock
                $Self->{TicketObject}->LockSet(
                    TicketID => $TicketID,
                    Lock => 'lock',
                    UserID => $Self->{UserID},
                );
            }
            # time accounting
            if ($GetParam{TimeUnits}) {
                $Self->{TicketObject}->TicketAccountTime(
                    TicketID => $TicketID,
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
            # should i set an unlock?
            my %StateData = $Self->{StateObject}->StateGet(ID => $GetParam{NextStateID});
            if ($StateData{TypeName} =~ /^close/i) {
                $Self->{TicketObject}->LockSet(
                    TicketID => $TicketID,
                    Lock => 'unlock',
                    UserID => $Self->{UserID},
                );
            }
            # set pending time
            elsif ($StateData{TypeName} =~ /^pending/i) {
                $Self->{TicketObject}->TicketPendingTimeSet(
                    UserID => $Self->{UserID},
                    TicketID => $TicketID,
                    %GetParam,
                );
            }
            # get redirect screen
            my $NextScreen = $Self->{UserCreateNextMask} ||
                $Self->{ConfigObject}->Get('PreferencesGroups')->{CreateNextMask}->{DataSelected} || 'AgentTicketPhone';
            # redirect
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=$NextScreen&Subaction=Created&TicketID=$TicketID",
            );
        }
        else {
            return $Self->{LayoutObject}->ErrorScreen();
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
    my %NextStates = ();
    if ($Param{QueueID} || $Param{TicketID}) {
        %NextStates = $Self->{TicketObject}->StateList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
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

sub _GetPriorities {
    my $Self = shift;
    my %Param = @_;
    my %Priorities = ();
    # get priority
    if ($Param{QueueID} || $Param{TicketID}) {
        %Priorities = $Self->{TicketObject}->PriorityList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Priorities;
}

sub _GetTypes {
    my $Self = shift;
    my %Param = @_;
    my %Type = ();
    # get priority
    if ($Param{QueueID} || $Param{TicketID}) {
        %Type = $Self->{TicketObject}->TicketTypeList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Type;
}

sub _GetServices {
    my $Self = shift;
    my %Param = @_;
    my %Service = ();
    # get priority
    if ($Param{QueueID} || $Param{TicketID}) {
        %Service = $Self->{TicketObject}->TicketServiceList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%Service;
}

sub _GetSLAs {
    my $Self = shift;
    my %Param = @_;
    my %SLA = ();
    # get priority
    if ($Param{ServiceID}) {
        %SLA = $Self->{TicketObject}->TicketSLAList(
            %Param,
            Action => $Self->{Action},
            UserID => $Self->{UserID},
        );
    }
    return \%SLA;
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

sub _MaskPhoneNew {
    my $Self = shift;
    my %Param = @_;
    $Param{FormID} = $Self->{FormID};
    # get list type
    my $TreeView = 0;
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::ListType') eq 'tree') {
        $TreeView = 1;
    }
    # build string
    $Param{Users}->{''} = '-';
    $Param{'OptionStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{Users},
        SelectedID => $Param{UserSelected},
        Name => 'NewUserID',
    );
    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'NextStateID',
        Selected => $Param{NextState} || $Self->{Config}->{StateDefault},
    );
    # build from string
    if ($Param{FromOptions} && %{$Param{FromOptions}}) {
        $Param{'CustomerUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => $Param{FromOptions},
            Name => 'CustomerUser',
            Max => 70,
        );
    }
    # build so string
    my %NewTo = ();
    if ($Param{To}) {
        foreach (keys %{$Param{To}}) {
            $NewTo{"$_||$Param{To}->{$_}"} = $Param{To}->{$_};
        }
    }
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue') {
        $Param{'ToStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
            Data => \%NewTo,
            Multiple => 0,
            Size => 0,
            Name => 'Dest',
            SelectedID => $Param{ToSelected},
            OnChangeSubmit => 0,
            OnChange => "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
        );
    }
    else {
        $Param{'ToStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%NewTo,
            Name => 'Dest',
            SelectedID => $Param{ToSelected},
            OnChange => "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
        );
    }
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
    # prepare errors!
    if ($Param{Errors}) {
        foreach (keys %{$Param{Errors}}) {
            $Param{$_} = "* ".$Self->{LayoutObject}->Ascii2Html(Text => $Param{Errors}->{$_});
        }
    }
    # build type string
    if ($Self->{ConfigObject}->Get('Ticket::Type')) {
        $Param{'TypeStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data => $Param{Types},
            Name => 'TypeID',
            SelectedID => $Param{TypeID},
            PossibleNone => 1,
            Sort => 'AlphanumericValue',
            Translation => 0,
            OnChange => "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketType',
            Data => {%Param},
        );
    }
    # build service string
    if ($Self->{ConfigObject}->Get('Ticket::Service')) {
        $Param{'ServiceStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data => $Param{Services},
            Name => 'ServiceID',
            SelectedID => $Param{ServiceID},
            PossibleNone => 1,
            TreeView => $TreeView,
            Sort => 'TreeView',
            Translation => 0,
            OnChange => "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketService',
            Data => {%Param},
        );
        $Param{'SLAStrg'} = $Self->{LayoutObject}->BuildSelection(
            Data => $Param{SLAs},
            Name => 'SLAID',
            SelectedID => $Param{SLAID},
            PossibleNone => 1,
            Sort => 'AlphanumericValue',
            Translation => 0,
            OnChange => "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
        );
        $Self->{LayoutObject}->Block(
            Name => 'TicketSLA',
            Data => {%Param},
        );
    }
    # build priority string
    if (!$Param{PriorityID}) {
        $Param{Priority} = $Self->{Config}->{Priority};
    }
    $Param{'PriorityStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{Priorities},
        Name => 'PriorityID',
        SelectedID => $Param{PriorityID},
        Selected => $Param{Priority},
    );
    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format => 'DateInputFormatLong',
        DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
    );
    # to update
    if (!$Self->{LayoutObject}->{BrowserJavaScriptSupport}) {
        $Self->{LayoutObject}->Block(
            Name => 'ToUpdateSubmit',
            Data => \%Param,
        );
    }
    # show owner selection
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::NewOwnerSelection')) {
        $Self->{LayoutObject}->Block(
            Name => 'OwnerSelection',
            Data => \%Param,
        );
        if ($Self->{LayoutObject}->{BrowserJavaScriptSupport}) {
            $Self->{LayoutObject}->Block(
                Name => 'OwnerSelectionAllJS',
                Data => { },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'OwnerSelectionAllSubmit',
                Data => { },
            );
        }
    }
    # show responsible selection
    if ($Self->{ConfigObject}->Get('Ticket::Responsible') &&
        $Self->{ConfigObject}->Get('Ticket::Frontend::NewResponsibleSelection')) {
        $Param{ResponsibleUsers}->{''} = '-';
        $Param{'ResponsibleOptionStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => $Param{ResponsibleUsers},
            SelectedID => $Param{ResponsibleUserSelected},
            Name => 'NewResponsibleID',
        );
        $Self->{LayoutObject}->Block(
            Name => 'ResponsibleSelection',
            Data => \%Param,
        );
        if ($Self->{LayoutObject}->{BrowserJavaScriptSupport}) {
            $Self->{LayoutObject}->Block(
                Name => 'ResponsibleSelectionAllJS',
                Data => { },
            );
        }
        else {
            $Self->{LayoutObject}->Block(
                Name => 'ResponsibleSelectionAllSubmit',
                Data => { },
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
                    Count => $Count,
                    %Param,
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
    # jscript check freetextfields by submit
    foreach my $Key (keys %{$Self->{Config}->{TicketFreeText}}) {
        if ($Self->{Config}->{TicketFreeText}->{$Key} == 2) {
            $Self->{LayoutObject}->Block(
                Name => 'TicketFreeTextCheckJs',
                Data => {
                    TicketFreeTextField => "TicketFreeText$Key",
                    TicketFreeKeyField => "TicketFreeKey$Key",
                },
            );
        }
    }
    # get output back
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketPhone', Data => \%Param);
}

1;
