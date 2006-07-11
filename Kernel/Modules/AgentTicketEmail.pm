# --
# Kernel/Modules/AgentTicketEmail.pm - to compose inital email to customer
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketEmail.pm,v 1.12.2.3 2006-07-11 13:04:35 cs Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketEmail;

use strict;
use Kernel::System::SystemAddress;
use Kernel::System::CustomerUser;
use Kernel::System::CheckItem;
use Kernel::System::Web::UploadCache;
use Kernel::System::State;
use Mail::Address;

use vars qw($VERSION);
$VERSION = '$Revision: 1.12.2.3 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    $Self->{Debug} = $Param{Debug} || 0;

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Opjects
    foreach (qw(ParamObject DBObject TicketObject LayoutObject LogObject QueueObject
       ConfigObject)) {
        die "Got no $_!" if (!$Self->{$_});
    }
    # anyway, we need to check the email syntax (removed it, because the admins should configure it)
#    $Self->{ConfigObject}->Set(Key => 'CheckEmailAddresses', Value => 1);
    # needed objects
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

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;

    # store last queue screen
    if ($Self->{LastScreenOverview} !~ /Action=AgentTicketEmail/) {
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key => 'LastScreenOverview',
            Value => $Self->{RequestedURL},
        );
    }
    if (!$Self->{Subaction} || $Self->{Subaction} eq 'Created') {
        # header
        $Output .= $Self->{LayoutObject}->Header();
        # if there is no ticket id!
        if (!$Self->{TicketID} || ($Self->{TicketID} && $Self->{Subaction} eq 'Created')) {
            # navigation bar
            $Output .= $Self->{LayoutObject}->NavigationBar();
            # notify info
            if ($Self->{TicketID}) {
                my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
                $Output .= $Self->{LayoutObject}->Notify(
                    Info => 'Ticket "%s" created!", "'.$Ticket{TicketNumber},
                    Link => '$Env{"Baselink"}Action=AgentTicketZoom&TicketID='.$Ticket{TicketID},
                );
            }
            # --
            # get split article if given
            # --
            # get default selections
            my %TicketFreeDefault = ();
            foreach (1..8) {
                $TicketFreeDefault{'TicketFreeKey'.$_} = $Self->{ConfigObject}->Get('TicketFreeKey'.$_.'::DefaultSelection');
                $TicketFreeDefault{'TicketFreeText'.$_} = $Self->{ConfigObject}->Get('TicketFreeText'.$_.'::DefaultSelection');
            }
            # get free text config options
            my %TicketFreeText = ();
            foreach (1..8) {
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
                Ticket => {
                    %TicketFreeDefault,
                    $Self->{UserObject}->GetUserData(
                        UserID => $Self->{UserID},
                        Cached => 1,
                    ),
                }
            );
            # get free text params
            my %TicketFreeTime = ();
            foreach (1..2) {
                foreach my $Type (qw(Year Month Day Hour Minute)) {
                    $TicketFreeTime{"TicketFreeTime".$_.$Type} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeTime".$_.$Type);
                }
            }
            # free time
            my %FreeTime = $Self->{LayoutObject}->AgentFreeDate(
                %Param,
                Ticket => \%TicketFreeTime,
            );
            # run compose modules
            if (ref($Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule')) eq 'HASH') {
                my %Jobs = %{$Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule')};
                foreach my $Job (sort keys %Jobs) {
                        # load module
                        if ($Self->{MainObject}->Require($Jobs{$Job}->{Module})) {
                            my $Object = $Jobs{$Job}->{Module}->new(
                                %{$Self},
                                Debug => $Self->{Debug},
                            );
                            # get params
                            my %GetParam;
                            foreach ($Object->Option(%GetParam, Config => $Jobs{$Job})) {
                                $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
                            }
                            # run module
                            $Object->Run(%GetParam, Config => $Jobs{$Job});
                            # get errors
#                            %Error = (%Error, $Object->Error(%GetParam, Config => $Jobs{$Job}));
                        }
                        else {
                            return $Self->{LayoutObject}->FatalError();
                        }
                }
            }
            # html output
            $Output .= $Self->_MaskEmailNew(
              QueueID => $Self->{QueueID},
              NextStates => $Self->_GetNextStates(QueueID => 1),
              Priorities => $Self->_GetPriorities(QueueID => 1),
              Users => $Self->_GetUsers(),
              FromList => $Self->_GetTos(),
              To => '',
              Subject => '',
              Body => $Self->{ConfigObject}->Get('Ticket::Frontend::EmailNewNote'),
              CustomerID => '',
              CustomerUser =>  '',
              CustomerData => {},
              %TicketFreeTextHTML,
              %FreeTime,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }

        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # create new ticket and article
    elsif ($Self->{Subaction} eq 'StoreNew') {
        my %Error = ();
        my $NextStateID = $Self->{ParamObject}->GetParam(Param => 'NextStateID') || '';
        my %StateData = ();
        if ($NextStateID) {
            %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $NextStateID,
            );
        }
        my $NextState = $StateData{Name};
        my $NewUserID = $Self->{ParamObject}->GetParam(Param => 'NewUserID') || '';
        my $Lock = $Self->{ParamObject}->GetParam(Param => 'Lock') || '';
        if ($Lock) {
            $Self->{ConfigObject}->Set(
                Key => 'EmailDefaultNewLock',
                Value => $Lock,
            );
        }
        if ($NewUserID) {
            $Self->{ConfigObject}->Set(
                Key => 'EmailDefaultNewLock',
                Value => 'lock',
            );
        }
        my $Dest = $Self->{ParamObject}->GetParam(Param => 'Dest') || '';
        my ($NewQueueID, $From) = split(/\|\|/, $Dest);
        my $AllUsers = $Self->{ParamObject}->GetParam(Param => 'AllUsers') || '';
        if (!$NewQueueID) {
            $AllUsers = 1;
        }
        # get sender queue from
        my %Queue = ();
        my $Signature = '';
        if ($NewQueueID) {
            %Queue = $Self->{QueueObject}->GetSystemAddress(QueueID => $NewQueueID);
            # prepare signature
            $Signature = $Self->{QueueObject}->GetSignature(QueueID => $NewQueueID);
            $Signature =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
            $Signature =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;
            $Signature =~ s/<OTRS_USER_ID>/$Self->{UserID}/g;
            $Signature =~ s/<OTRS_USER_LOGIN>/$Self->{UserLogin}/g;
        }
        my $CustomerUser = $Self->{ParamObject}->GetParam(Param => 'CustomerUser') || $Self->{ParamObject}->GetParam(Param => 'PreSelectedCustomerUser') || $Self->{ParamObject}->GetParam(Param => 'SelectedCustomerUser') || '';
        my $CustomerID = $Self->{ParamObject}->GetParam(Param => 'CustomerID') || '';
        my $SelectedCustomerUser = $Self->{ParamObject}->GetParam(Param => 'SelectedCustomerUser') || '';
        my $ExpandCustomerName = $Self->{ParamObject}->GetParam(Param => 'ExpandCustomerName') || 0;
        foreach (1..2) {
            my $Item = $Self->{ParamObject}->GetParam(Param => "ExpandCustomerName$_") || 0;
            if ($_ == 1 && $Item) {
                $ExpandCustomerName = 1;
            }
            elsif ($_ == 2 && $Item) {
                $ExpandCustomerName = 2;
            }
        }
        # get free text params
        my %TicketFree = ();
        foreach (1..8) {
            $TicketFree{"TicketFreeKey$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeKey$_");
            $TicketFree{"TicketFreeText$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeText$_");
        }
        # get free text config options
        my %TicketFreeText = ();
        foreach (1..8) {
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
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%TicketFree,
        );
        # get free text params
        my %TicketFreeTime = ();
        foreach (1..2) {
            foreach my $Type (qw(Year Month Day Hour Minute)) {
                $TicketFreeTime{"TicketFreeTime".$_.$Type} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeTime".$_.$Type);
            }
        }
        # free time
        my %FreeTime = $Self->{LayoutObject}->AgentFreeDate(
            Ticket => \%TicketFreeTime,
        );
        # get params
        my %GetParam = ();
        $GetParam{From} = $Queue{Email};
        $GetParam{QueueID} = $NewQueueID;
        $GetParam{ExpandCustomerName} = $ExpandCustomerName;
        foreach (qw(AttachmentUpload
            Year Month Day Hour Minute To Cc Bcc TimeUnits PriorityID Subject Body
            AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
            AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
            AttachmentDelete9 AttachmentDelete10 )) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        # rewrap body if exists
        if ($GetParam{Body}) {
            $GetParam{Body} =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaEmail')})(?:\s|\z)/$1\n/gm;
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
        # Expand Customer Name
        my %CustomerUserData = ();
        if ($ExpandCustomerName == 1) {
            # search customer
            my %CustomerUserList = ();
            %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                Search => $GetParam{To},
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
                $GetParam{To} = $Param{CustomerUserListLast};
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
                $Param{"ToOptions"} = \%CustomerUserList;
                # clear to if there is no customer found
                if (!%CustomerUserList) {
                    $GetParam{To} = '';
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
                $GetParam{To} = $CustomerUserList{$_};
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
        # show customer info
        my %CustomerData = ();
        if ($Self->{ConfigObject}->Get('Ticket::Frontend::CustomerInfoCompose')) {
            if ($CustomerUser) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    User => $CustomerUser,
                );
            }
            elsif ($CustomerID) {
                %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                    CustomerID => $CustomerID,
                );
            }
        }
        # check some values
        foreach (qw(To Cc Bcc)) {
            if ($GetParam{$_}) {
                foreach my $Email (Mail::Address->parse($GetParam{$_})) {
                    if (!$Self->{CheckItemObject}->CheckEmail(Address => $Email->address())) {
                        $Error{"$_ invalid"} .= $Self->{CheckItemObject}->CheckError();
                    }
                }
            }
        }
        if (!$GetParam{To} && $ExpandCustomerName != 1 && $ExpandCustomerName == 0) {
            $Error{"To invalid"} = 'invalid';
        }
        if (!$GetParam{Subject} && $ExpandCustomerName == 0) {
            $Error{"Subject invalid"} = 'invalid';
        }
        if (!$NewQueueID && $ExpandCustomerName == 0) {
            $Error{"Destination invalid"} = 'invalid';
        }
        # check if date is valid
        if ($StateData{TypeName} && $StateData{TypeName} =~ /^pending/i) {
            if (!$Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0)) {
                $Error{"Date invalid"} = 'invalid';
            }
            if ($Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0) < $Self->{TimeObject}->SystemTime()) {
                $Error{"Date invalid"} = 'invalid';
            }
        }
        # run compose modules
        my %ArticleParam = ();
        if (ref($Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule')) eq 'HASH') {
            my %Jobs = %{$Self->{ConfigObject}->Get('Ticket::Frontend::ArticleComposeModule')};
            foreach my $Job (sort keys %Jobs) {
                # load module
                if ($Self->{MainObject}->Require($Jobs{$Job}->{Module})) {
                    my $Object = $Jobs{$Job}->{Module}->new(
                        %{$Self},
                        Debug => $Self->{Debug},
                    );
                    # get params
                    foreach ($Object->Option(%GetParam, Config => $Jobs{$Job})) {
                        $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
                    }
                    # run module
                    $Object->Run(%GetParam, Config => $Jobs{$Job});
                    # ticket params
                    %ArticleParam = (%ArticleParam, $Object->ArticleOption(%GetParam, Config => $Jobs{$Job}));
                    # get errors
                    %Error = (%Error, $Object->Error(%GetParam, Config => $Jobs{$Job}));
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
        }

        if (%Error) {
            # --
            # header
            # --
            $Output .= $Self->{LayoutObject}->Header();
            $Output .= $Self->{LayoutObject}->NavigationBar();
            # --
            # html output
            # --
            $Output .= $Self->_MaskEmailNew(
              QueueID => $Self->{QueueID},
              Users => $Self->_GetUsers(QueueID => $NewQueueID, AllUsers => $AllUsers),
              UserSelected => $NewUserID,
              NextStates => $Self->_GetNextStates(QueueID => $NewQueueID),
              NextState => $NextState,
              Priorities => $Self->_GetPriorities(QueueID => $NewQueueID),
              CustomerID => $Self->{LayoutObject}->Ascii2Html(Text => $CustomerID),
              CustomerUser => $CustomerUser,
              CustomerData => \%CustomerData,
              TimeUnits => $Self->{LayoutObject}->Ascii2Html(Text => $GetParam{TimeUnits} || ''),
              FromList => $Self->_GetTos(),
              FromSelected => $Dest,
              ToOptions => $Param{"ToOptions"},
              Subject => $Self->{LayoutObject}->Ascii2Html(Text => $GetParam{Subject}),
              Body => $Self->{LayoutObject}->Ascii2Html(Text => $GetParam{Body}),
              Errors => \%Error,
              Attachments => \@Attachments,
              Signature => $Signature,
              %GetParam,
              %TicketFreeTextHTML,
              %FreeTime,
            );
            # show customer tickets
            my @TicketIDs = ();
            if ($CustomerUser && $Self->{ConfigObject}->Get('Ticket::Frontend::EmailNewShownCustomerTickets')) {
                # get secondary customer ids
                my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDs(User => $CustomerUser);
                # get own customer id
                my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $CustomerUser);
                if ($CustomerData{UserCustomerID}) {
                    push (@CustomerIDs, $CustomerData{UserCustomerID});
                }
                @TicketIDs = $Self->{TicketObject}->TicketSearch(
                    Result => 'ARRAY',
                    Limit => $Self->{ConfigObject}->Get('Ticket::Frontend::EmailNewShownCustomerTickets'),
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
                    TicketID => $Article{TicketID},
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
                                TicketID => $Self->{TicketID},
                            );
                            # run module
                            $Counter = $Object->Run(
                                %Param,
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
                foreach (qw(1 2 3 4 5)) {
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
            StateID => $NextStateID,
            PriorityID => $GetParam{PriorityID},
            UserID => $Self->{UserID},
            CustomerNo => $CustomerID,
            CustomerUser => $SelectedCustomerUser,
            CreateUserID => $Self->{UserID},
        );
        # set ticket free text
        foreach (1..8) {
            if (defined($TicketFree{"TicketFreeKey$_"})) {
                $Self->{TicketObject}->TicketFreeTextSet(
                    TicketID => $TicketID,
                    Key => $TicketFree{"TicketFreeKey$_"},
                    Value => $TicketFree{"TicketFreeText$_"},
                    Counter => $_,
                    UserID => $Self->{UserID},
                );
            }
        }
        # set ticket free time
        foreach (1..2) {
            if (defined($TicketFreeTime{"TicketFreeTime".$_."Year"}) &&
                defined($TicketFreeTime{"TicketFreeTime".$_."Month"}) &&
                defined($TicketFreeTime{"TicketFreeTime".$_."Day"}) &&
                defined($TicketFreeTime{"TicketFreeTime".$_."Hour"}) &&
                defined($TicketFreeTime{"TicketFreeTime".$_."Minute"})) {
                $Self->{TicketObject}->TicketFreeTimeSet(
                    %TicketFreeTime,
                    TicketID => $TicketID,
                    Counter => $_,
                    UserID => $Self->{UserID},
                );
            }
        }
        # get pre loaded attachment
        @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );
        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'file_upload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push (@Attachments, \%UploadStuff);
        }
        # prepare subject
        my $Tn = $Self->{TicketObject}->TicketNumberLookup(TicketID => $TicketID);
        $GetParam{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Tn,
            Subject => $GetParam{Subject} || '',
        );
        $GetParam{Body} .= "\n\n".$Signature;
        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ($NewUserID) {
            $NoAgentNotify = 1;
        }
        # send email
        my $ArticleID = $Self->{TicketObject}->ArticleSend(
            NoAgentNotify => $NoAgentNotify,
            Attachment => \@Attachments,
            ArticleType => 'email-external',
            SenderType => 'agent',
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('Ticket::Frontend::EmailNewArticleType'),
            SenderType => $Self->{ConfigObject}->Get('Ticket::Frontend::EmailNewSenderType'),
            From => "$Queue{RealName} <$Queue{Email}>",
            To => $GetParam{To},
            Cc => $GetParam{Cc},
            Bcc => $GetParam{Bcc},
            Subject => $GetParam{Subject},
            Body => $GetParam{Body},
            Charset => $Self->{LayoutObject}->{UserCharset},
            Type => 'text/plain',
            UserID => $Self->{UserID},
            HistoryType => $Self->{ConfigObject}->Get('Ticket::Frontend::EmailNewHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('Ticket::Frontend::EmailNewHistoryComment') || "\%\%$GetParam{To}, $GetParam{Cc}, $GetParam{Bcc}",
            %ArticleParam,
        );
        if ($ArticleID) {
          # remove pre submited attachments
          $Self->{UploadCachObject}->FormIDRemove(FormID => $Self->{FormID});
          # set owner (if new user id is given)
          if ($NewUserID) {
              $Self->{TicketObject}->OwnerSet(
                  TicketID => $TicketID,
                  NewUserID => $NewUserID,
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
              # set lock
              $Self->{TicketObject}->LockSet(
                  TicketID => $TicketID,
                  Lock => $Self->{ConfigObject}->Get('EmailDefaultNewLock'),
                  UserID => $Self->{UserID},
              );
          }
          # should i set an unlock?
          my %StateData = $Self->{StateObject}->StateGet(ID => $NextStateID);
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
          my $NextScreen = $Self->{UserCreateNextMask} || $Self->{ConfigObject}->Get('PreferencesGroups')->{CreateNextMask}->{DataSelected} || 'AgentTicketEmail';
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
# --
sub _GetNextStates {
    my $Self = shift;
    my %Param = @_;
    my %NextStates = ();
    if ($Param{QueueID} || $Param{TicketID}) {
        %NextStates = $Self->{TicketObject}->StateList(
            %Param,
            Action => $Self->{Action},
            Type => 'EmailDefaultNext',
            UserID => $Self->{UserID},
        );
    }
    return \%NextStates;
}
# --
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
    # check show users
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
# --
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
# --
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
# --
sub _MaskEmailNew {
    my $Self = shift;
    my %Param = @_;
    $Param{FormID} = $Self->{FormID};
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
        Selected => $Param{NextState} || $Self->{ConfigObject}->Get('Ticket::Frontend::EmailNewNextState'),
    );
    # build from string
    if ($Param{ToOptions} && %{$Param{ToOptions}}) {
        $Param{'CustomerUserStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => $Param{ToOptions},
            Name => 'CustomerUser',
            Max => 70,
        );
    }
    # build so string
    my %NewTo = ();
    if ($Param{FromList}) {
        foreach (keys %{$Param{FromList}}) {
             $NewTo{"$_||$Param{FromList}->{$_}"} = $Param{FromList}->{$_};
        }
    }
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::NewQueueSelectionType') eq 'Queue') {
        $Param{'FromStrg'} = $Self->{LayoutObject}->AgentQueueListOption(
            Data => \%NewTo,
            Multiple => 0,
            Size => 0,
            Name => 'Dest',
            SelectedID => $Param{FromSelected},
            OnChangeSubmit => 0,
            OnChange => "document.compose.ExpandCustomerName.value='3'; document.compose.submit(); return false;",
        );
    }
    else {
        $Param{'FromStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => \%NewTo,
            Name => 'Dest',
            SelectedID => $Param{FromSelected},
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
    # do html quoting
    foreach (qw(From To Cc Bcc)) {
        $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_}) || '';
    }
    # build priority string
    if (!$Param{PriorityID}) {
        $Param{Priority} = $Self->{ConfigObject}->Get('Ticket::Frontend::EmailPriority');
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
    # prepare errors!
    if ($Param{Errors}) {
        foreach (keys %{$Param{Errors}}) {
            $Param{$_} = "* ".$Self->{LayoutObject}->Ascii2Html(Text => $Param{Errors}->{$_});
        }
    }
    # show owner selection
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::NewOwnerSelection')) {
        $Self->{LayoutObject}->Block(
            Name => 'OwnerSelection',
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
    # show spell check
    if ($Self->{ConfigObject}->Get('SpellChecker')) {
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
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketEmail', Data => \%Param);
}
# --
1;
