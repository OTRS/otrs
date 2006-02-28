# --
# Kernel/Modules/AgentTicketPhone.pm - to handle phone calls
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentTicketPhone.pm,v 1.16 2006-02-28 05:59:35 martin Exp $
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
$VERSION = '$Revision: 1.16 $';
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


    if (!$Self->{Subaction} || $Self->{Subaction} eq 'Created') {
        # header
        $Output .= $Self->{LayoutObject}->Header();
        # if there is no ticket id!
        if (!$Self->{TicketID} || ($Self->{TicketID} && $Self->{Subaction} eq 'Created')) {
            $Output .= $Self->{LayoutObject}->NavigationBar();
            # notify info
            if ($Self->{TicketID}) {
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
            # --
            # get split article if given
            # --
            # get ArticleID
            my $ArticleID = $Self->{ParamObject}->GetParam(Param => 'ArticleID');
            my %Article = ();
            my %CustomerData = ();
            if ($ArticleID) {
                %Article = $Self->{TicketObject}->ArticleGet(ArticleID => $ArticleID);
                $Article{Subject} = $Self->{TicketObject}->TicketSubjectClean(
                    TicketNumber => $Article{TicketNumber},
                    Subject => $Article{Subject} || '',
                );
                # check if original content isn't text/plain or text/html, don't use it
                if ($Article{'ContentType'}) {
                    if($Article{'ContentType'} =~ /text\/html/i) {
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
                $TicketFreeDefault{'TicketFreeKey'.$_} = $Self->{ConfigObject}->Get('TicketFreeKey'.$_.'::DefaultSelection');
                $TicketFreeDefault{'TicketFreeText'.$_} = $Self->{ConfigObject}->Get('TicketFreeText'.$_.'::DefaultSelection');
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
            # html output
            $Output .= $Self->_MaskPhoneNew(
              QueueID => $Self->{QueueID},
              NextStates => $Self->_GetNextStates(QueueID => $Self->{QueueID} || 1),
              Priorities => $Self->_GetPriorities(QueueID => $Self->{QueueID} || 1),
              Users => $Self->_GetUsers(QueueID => $Self->{QueueID}),
              To => $Self->_GetTos(QueueID => $Self->{QueueID}),
              From => $Article{From},
              Subject => $Article{Subject} || '$Config{"Ticket::Frontend::PhoneNewSubject"}',
              Body => $Article{Body} || '$Text{"$Config{"Ticket::Frontend::PhoneNewNote"}"}',
              CustomerID => $Article{CustomerID},
              CustomerUser => $Article{CustomerUserID},
              CustomerData => \%CustomerData,
              %TicketFreeTextHTML,
              %FreeTime,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # get ticket info if ticket id is given
        my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
        # check it it's a agent-customer ticket
        if ($Self->{ConfigObject}->Get('Ticket::AgentCanBeCustomer') && $Ticket{CustomerUserID} && $Ticket{CustomerUserID} eq $Self->{UserLogin}) {
            # redirect for agent follow up screen
            return $Self->{LayoutObject}->Redirect(
                OP => "Action=AgentTicketCustomerFollowUp&TicketID=$Self->{TicketID}",
            );
        }
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
        # get lock state && permissions
        if (!$Self->{TicketObject}->LockIsTicketLocked(TicketID => $Self->{TicketID})) {
          # set owner
          $Self->{TicketObject}->OwnerSet(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
            NewUserID => $Self->{UserID},
          );
          # set lock
          if ($Self->{TicketObject}->LockSet(
            TicketID => $Self->{TicketID},
            Lock => 'lock',
            UserID => $Self->{UserID},
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
        my %FreeTime = $Self->{LayoutObject}->AgentFreeDate(
            Ticket => \%TicketFreeTime,
        );
        # print form ...
        $Output .= $Self->_MaskPhone(
            TicketID => $Self->{TicketID},
            QueueID => $Self->{QueueID},
            TicketNumber => $Tn,
            NextStates => $Self->_GetNextStates(TicketID => $Self->{TicketID}),
            CustomerData => \%CustomerData,
            Subject => $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneSubject')) || '',
            Body => $Self->{LayoutObject}->Output(Template => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneNote')) || '',
            %TicketFreeTextHTML,
            %FreeTime,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # save new phone article to existing ticket
    elsif ($Self->{Subaction} eq 'Store') {
        my %Error = ();
        # get params
        my %GetParam = ();
        foreach (qw(AttachmentUpload
            Body Subject TimeUnits NextStateID
            Year Month Day Hour Minute
            AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
            AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
            AttachmentDelete9 AttachmentDelete10 )) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        # get free text params
        my %TicketFree = ();
        foreach (1..16) {
            $TicketFree{"TicketFreeKey$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeKey$_");
            $TicketFree{"TicketFreeText$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeText$_");
        }
        # get free text params
        my %TicketFreeTime = ();
        foreach (1..2) {
            foreach my $Type (qw(Year Month Day Hour Minute)) {
                $TicketFreeTime{"TicketFreeTime".$_.$Type} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeTime".$_.$Type);
            }
        }
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
            # free time
            my %FreeTime = $Self->{LayoutObject}->AgentFreeDate(
                Ticket => \%TicketFreeTime,
            );
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
                Ticket => \%TicketFree,
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
            # print form ...
            $Output .= $Self->_MaskPhone(
                TicketID => $Self->{TicketID},
                QueueID => $Self->{QueueID},
                TicketNumber => $Tn,
                NextStates => $Self->_GetNextStates(TicketID => $Self->{TicketID}),
                CustomerData => \%CustomerData,
                Attachments => \@Attachments,
                %GetParam,
                %TicketFreeTextHTML,
                %FreeTime,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        else {
          if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            TicketID => $Self->{TicketID},
            ArticleType => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneArticleType'),
            SenderType => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneSenderType'),
            From => "$Self->{UserFirstname} $Self->{UserLastname} <$Self->{UserEmail}>",
            Subject => $GetParam{Subject},
            Body => $GetParam{Body},
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneHistoryComment') || '%%',
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
                if (defined($TicketFree{"TicketFreeKey$_"})) {
                    $Self->{TicketObject}->TicketFreeTextSet(
                        TicketID => $Self->{TicketID},
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
                        TicketID => $Self->{TicketID},
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
    # create new ticket and article
    elsif ($Self->{Subaction} eq 'StoreNew') {
        my %Error = ();
        my $Subject = $Self->{ParamObject}->GetParam(Param => 'Subject') || '';
        my $Text = $Self->{ParamObject}->GetParam(Param => 'Body') || '';
        my $NextStateID = $Self->{ParamObject}->GetParam(Param => 'NextStateID') || '';
        my %StateData = ();
        if ($NextStateID) {
            %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
                ID => $NextStateID,
            );
        }
        my $NextState = $StateData{Name} || '';
        my $PriorityID = $Self->{ParamObject}->GetParam(Param => 'PriorityID') || '';
        my $ArticleTypeID = $Self->{ParamObject}->GetParam(Param => 'NoteID');
        my $NewUserID = $Self->{ParamObject}->GetParam(Param => 'NewUserID') || '';
        my $Lock = $Self->{ParamObject}->GetParam(Param => 'Lock') || '';
        if ($Lock) {
            $Self->{ConfigObject}->Set(
                Key => 'PhoneDefaultNewLock',
                Value => $Lock,
            );
        }
        if ($NewUserID) {
            $Self->{ConfigObject}->Set(
                Key => 'PhoneDefaultNewLock',
                Value => 'lock',
            );
        }
        my $Dest = $Self->{ParamObject}->GetParam(Param => 'Dest') || '';
        my ($NewQueueID, $To) = split(/\|\|/, $Dest);
        my $AllUsers = $Self->{ParamObject}->GetParam(Param => 'AllUsers') || '';
        if (!$NewQueueID) {
            $AllUsers = 1;
        }
        my $From = $Self->{ParamObject}->GetParam(Param => 'From') || '';
        my $TimeUnits = $Self->{ParamObject}->GetParam(Param => 'TimeUnits') || '';
        my $CustomerUser = $Self->{ParamObject}->GetParam(Param => 'CustomerUser') ||  $Self->{ParamObject}->GetParam(Param => 'PreSelectedCustomerUser') || $Self->{ParamObject}->GetParam(Param => 'SelectedCustomerUser') || '';
        my $SelectedCustomerUser = $Self->{ParamObject}->GetParam(Param => 'SelectedCustomerUser') || '';
        my $CustomerID = $Self->{ParamObject}->GetParam(Param => 'CustomerID') || '';
        my $ExpandCustomerName = $Self->{ParamObject}->GetParam(Param => 'ExpandCustomerName') || 0;
        if ($Self->{ParamObject}->GetParam(Param => 'AllUsersRefresh')) {
            $AllUsers = 1;
            $ExpandCustomerName = 3;
        }
        if ($Self->{ParamObject}->GetParam(Param => 'ClearFrom')) {
            $From = '';
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
        # get free text params
        my %TicketFree = ();
        foreach (1..16) {
            $TicketFree{"TicketFreeKey$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeKey$_");
            $TicketFree{"TicketFreeText$_"} =  $Self->{ParamObject}->GetParam(Param => "TicketFreeText$_");
        }
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
        foreach (qw(AttachmentUpload
            Year Month Day Hour Minute
            AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
            AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
            AttachmentDelete9 AttachmentDelete10 )) {
            $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
        }
        # rewrap body if exists
        if ($GetParam{Body}) {
            $Text =~ s/(^>.+|.{4,$Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaNote')})(?:\s|\z)/$1\n/gm;
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
        }
        my %TicketFreeTextHTML = $Self->{LayoutObject}->AgentFreeText(
            Config => \%TicketFreeText,
            Ticket => \%TicketFree,
        );

        # Expand Customer Name
        my %CustomerUserData = ();
        if ($ExpandCustomerName == 1) {
            # search customer
            my %CustomerUserList = ();
            %CustomerUserList = $Self->{CustomerUserObject}->CustomerSearch(
                Search => $From,
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
                $From = $Param{CustomerUserListLast};
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
                    $From = '';
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
                $From = $CustomerUserList{$_};
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
        # --
        # show customer info
        # --
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
        # --
        # check some values
        # --
        foreach my $Email (Mail::Address->parse($From)) {
            if (!$Self->{CheckItemObject}->CheckEmail(Address => $Email->address())) {
                $Error{"From invalid"} .= $Self->{CheckItemObject}->CheckError();
            }
        }
        if (!$From && $ExpandCustomerName != 1 && $ExpandCustomerName == 0) {
            $Error{"From invalid"} = 'invalid';
        }
        if (!$Subject && $ExpandCustomerName == 0) {
            $Error{"Subject invalid"} = 'invalid';
        }
        if (!$NewQueueID && $ExpandCustomerName == 0) {
            $Error{"Destination invalid"} = 'invalid';
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
            $Output .= $Self->_MaskPhoneNew(
              QueueID => $Self->{QueueID},
              Users => $Self->_GetUsers(QueueID => $NewQueueID, AllUsers => $AllUsers),
              UserSelected => $NewUserID,
              NextStates => $Self->_GetNextStates(QueueID => $NewQueueID),
              NextState => $NextState,
              Priorities => $Self->_GetPriorities(QueueID => $NewQueueID),
              PriorityID => $PriorityID,
              CustomerID => $Self->{LayoutObject}->Ascii2Html(Text => $CustomerID),
              CustomerUser => $CustomerUser,
              CustomerData => \%CustomerData,
              TimeUnits => $Self->{LayoutObject}->Ascii2Html(Text => $TimeUnits),
              From => $From,
              FromOptions => $Param{"FromOptions"},
              Body => $Self->{LayoutObject}->Ascii2Html(Text => $Text),
              To => $Self->_GetTos(QueueID => $NewQueueID),
              ToSelected => $Dest,
              Subject => $Self->{LayoutObject}->Ascii2Html(Text => $Subject),
              Errors => \%Error,
              Attachments => \@Attachments,
              %GetParam,
              %TicketFreeTextHTML,
              %FreeTime,
            );
            # show customer tickets
            my @TicketIDs = ();
            if ($CustomerUser && $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneNewShownCustomerTickets')) {
                # get secondary customer ids
                my @CustomerIDs = $Self->{CustomerUserObject}->CustomerIDs(User => $CustomerUser);
                # get own customer id
                my %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(User => $CustomerUser);
                if ($CustomerData{UserCustomerID}) {
                    push (@CustomerIDs, $CustomerData{UserCustomerID});
                }

                @TicketIDs = $Self->{TicketObject}->TicketSearch(
                    Result => 'ARRAY',
                    Limit => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneNewShownCustomerTickets'),
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
                    }
                );
            }
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # create new ticket, do db insert
        my $TicketID = $Self->{TicketObject}->TicketCreate(
            Title => $Subject,
            QueueID => $NewQueueID,
            Subject => $Subject,
            Lock => 'unlock',
            StateID => $NextStateID,
            PriorityID => $PriorityID,
            OwnerID => $Self->{UserID},
            CustomerNo => $CustomerID,
            CustomerUser => $SelectedCustomerUser,
            UserID => $Self->{UserID},
        );
        # set ticket free text
        foreach (1..16) {
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
        # check if new owner is given (then send no agent notify)
        my $NoAgentNotify = 0;
        if ($NewUserID) {
            $NoAgentNotify = 1;
        }
        if (my $ArticleID = $Self->{TicketObject}->ArticleCreate(
            NoAgentNotify => $NoAgentNotify,
            TicketID => $TicketID,
            ArticleType => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneNewArticleType'),
            SenderType => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneNewSenderType'),
            From => $From,
            To => $To,
            Subject => $Subject,
            Body => $Text,
            ContentType => "text/plain; charset=$Self->{LayoutObject}->{'UserCharset'}",
            UserID => $Self->{UserID},
            HistoryType => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneNewHistoryType'),
            HistoryComment => $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneNewHistoryComment') || '%%',
            AutoResponseType => 'auto reply',
            OrigHeader => {
              From => $From,
              To => $To,
              Subject => $Subject,
              Body => $Text,
            },
            Queue => $Self->{QueueObject}->QueueLookup(QueueID => $NewQueueID),
        )) {
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
          if ($TimeUnits) {
            $Self->{TicketObject}->TicketAccountTime(
                  TicketID => $TicketID,
                  ArticleID => $ArticleID,
                  TimeUnit => $TimeUnits,
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
          my $NextScreen = $Self->{UserCreateNextMask} || $Self->{ConfigObject}->Get('PreferencesGroups')->{CreateNextMask}->{DataSelected} || 'AgentTicketPhone';
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
            Type => 'PhoneDefaultNext',
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
# --
sub _MaskPhone {
    my $Self = shift;
    my %Param = @_;
    $Param{FormID} = $Self->{FormID};
    # build next states string
    my %Selected = ();
    if ($Param{NextStateID}) {
        $Selected{SelectedID} = $Param{NextStateID};
    }
    else {
        $Selected{Selected} = $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneNextState');
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
        if ($Self->{ConfigObject}->Get('TicketFreeText'.$Count.'::Shown') && $Self->{ConfigObject}->Get('TicketFreeText'.$Count.'::Shown')->{Phone}) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeText',
                Data => {
                    TicketFreeKeyField => $Param{'TicketFreeKeyField'.$Count},
                    TicketFreeTextField => $Param{'TicketFreeTextField'.$Count},
                },
            );
        }
    }
    $Count = 0;
    foreach (1..2) {
        $Count++;
        if ($Self->{ConfigObject}->Get('TicketFreeTime'.$Count.'::Shown') && $Self->{ConfigObject}->Get('TicketFreeText'.$Count.'::Shown')->{Phone}) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeTime',
                Data => {
                    TicketFreeTimeKey => $Self->{ConfigObject}->Get('TicketFreeTimeKey'.$Count),
                    TicketFreeTime => $Param{'TicketFreeTime'.$Count},
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
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketPhone', Data => \%Param);
}
# --
sub _MaskPhoneNew {
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
        Selected => $Param{NextState} || $Self->{ConfigObject}->Get('Ticket::Frontend::PhoneNewNextState'),
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
    # do html quoting
    foreach (qw(From To Cc)) {
        $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_}) || '';
    }
    # build priority string
    if (!$Param{PriorityID}) {
        $Param{Priority} = $Self->{ConfigObject}->Get('Ticket::Frontend::PhonePriority');
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
    # ticket free text
    my $Count = 0;
    foreach (1..16) {
        $Count++;
        if ($Self->{ConfigObject}->Get('TicketFreeText'.$Count.'::Shown') && $Self->{ConfigObject}->Get('TicketFreeText'.$Count.'::Shown')->{PhoneNew}) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeText',
                Data => {
                    TicketFreeKeyField => $Param{'TicketFreeKeyField'.$Count},
                    TicketFreeTextField => $Param{'TicketFreeTextField'.$Count},
                },
            );
        }
    }
    $Count = 0;
    foreach (1..2) {
        $Count++;
        if ($Self->{ConfigObject}->Get('TicketFreeTime'.$Count.'::Shown') && $Self->{ConfigObject}->Get('TicketFreeText'.$Count.'::Shown')->{PhoneNew}) {
            $Self->{LayoutObject}->Block(
                Name => 'FreeTime',
                Data => {
                    TicketFreeTimeKey => $Self->{ConfigObject}->Get('TicketFreeTimeKey'.$Count),
                    TicketFreeTime => $Param{'TicketFreeTime'.$Count},
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
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketPhoneNew', Data => \%Param);
}
# --
1;
