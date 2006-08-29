# --
# Kernel/Modules/AgentTicketCompose.pm - to compose and send a message
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: AgentTicketCompose.pm,v 1.18 2006-08-29 17:17:24 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentTicketCompose;

use strict;
use Kernel::System::CheckItem;
use Kernel::System::StdAttachment;
use Kernel::System::State;
use Kernel::System::CustomerUser;
use Kernel::System::Web::UploadCache;
use Mail::Address;

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

    $Self->{Debug} = $Param{Debug} || 0;

    # get common opjects
    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check all needed objects
    foreach (qw(TicketObject ParamObject DBObject QueueObject LayoutObject ConfigObject LogObject)) {
        if (!$Self->{$_}) {
            $Self->{LayoutObject}->FatalError(Message => "Got no $_!");
        }
    }
    # some new objects
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new(%Param);
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{UploadCachObject} = Kernel::System::Web::UploadCache->new(%Param);
    # get response format
    $Self->{ResponseFormat} = $Self->{ConfigObject}->Get('Ticket::Frontend::ResponseFormat') ||
      '$Data{"Salutation"}
$Data{"OrigFrom"} $Text{"wrote"}:
$Data{"Body"}

$Data{"StdResponse"}

$Data{"Signature"}
';
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
        From To Cc Bcc Subject Body InReplyTo ResponseID StateID
        ArticleID TimeUnits Year Month Day Hour Minute AttachmentUpload
        AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
        AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
        AttachmentDelete9 AttachmentDelete10 AttachmentDelete11 AttachmentDelete12
        AttachmentDelete13 AttachmentDelete14 AttachmentDelete15 AttachmentDelete16
        FormID)) {
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

    # send email
    if ($Self->{Subaction} eq 'SendEmail') {
        my %Error = ();
        my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
            ID => $GetParam{StateID},
        );
        # check pending date
        if ($StateData{TypeName} && $StateData{TypeName} =~ /^pending/i) {
            if (!$Self->{TimeObject}->Date2SystemTime(%GetParam, Second => 0)) {
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
        # check some values
        foreach (qw(From To Cc Bcc)) {
            if ($GetParam{$_}) {
                foreach my $Email (Mail::Address->parse($GetParam{$_})) {
                    if (!$Self->{CheckItemObject}->CheckEmail(Address => $Email->address())) {
                         $Error{"$_ invalid"} .= $Self->{CheckItemObject}->CheckError();
                    }
                }
            }
        }
        # prepare subject
        my $Tn = $Self->{TicketObject}->TicketNumberLookup(TicketID => $Self->{TicketID});
        $GetParam{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Tn,
            Subject => $GetParam{Subject} || '',
        );
        # rewrap body if exists
        if ($GetParam{Body}) {
            my $NewLine = $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaEmail') || 75;
            $GetParam{Body} =~ s/(^>.+|.{4,$NewLine})(?:\s|\z)/$1\n/gm;
        }
        my %ArticleParam = ();
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
        # --
        # check if there is an error
        # --
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
            # ticket free time
            my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
                %Param,
                Ticket => \%GetParam,
            );
            # article free text
            my %ArticleFreeText = ();
            foreach (1..16) {
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
            $GetParam{StdResponse} = $GetParam{Body};
            $Output .= $Self->_Mask(
                TicketID => $Self->{TicketID},
                NextStates => $Self->_GetNextStates(),
                ResponseFormat => $Self->{LayoutObject}->Ascii2Html(Text => $GetParam{Body}),
                Errors => \%Error,
                Attachments => \@Attachments,
                %Ticket,
                %TicketFreeTextHTML,
                %TicketFreeTimeHTML,
                %ArticleFreeTextHTML,
                %GetParam,
            );
            $Output .= $Self->{LayoutObject}->Footer();
            return $Output;
        }
        # replace <OTRS_TICKET_STATE> with next ticket state name
        if ($StateData{Name}) {
            $GetParam{Body} =~ s/<OTRS_TICKET_STATE>/$StateData{Name}/g;
        }
        # get pre loaded attachments
        my @AttachmentData = $Self->{UploadCachObject}->FormIDGetAllFilesData(
            FormID => $Self->{FormID},
        );
        # get submit attachment
        my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
            Param => 'file_upload',
            Source => 'String',
        );
        if (%UploadStuff) {
            push (@AttachmentData, \%UploadStuff);
        }
        # send email
        if (my $ArticleID = $Self->{TicketObject}->ArticleSend(
            ArticleType => 'email-external',
            SenderType => 'agent',
            TicketID => $Self->{TicketID},
            HistoryType => 'SendAnswer',
            HistoryComment => "\%\%$GetParam{To}, $GetParam{Cc}, $GetParam{Bcc}",
            From => $GetParam{From},
            To => $GetParam{To},
            Cc => $GetParam{Cc},
            Bcc => $GetParam{Bcc},
            Subject => $GetParam{Subject},
            UserID => $Self->{UserID},
            Body => $GetParam{Body},
            InReplyTo => $GetParam{InReplyTo},
            Charset => $Self->{LayoutObject}->{UserCharset},
            Type => 'text/plain',
            Attachment => \@AttachmentData,
            %ArticleParam,
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
            # set ticket free text
            foreach (1..16) {
                if (defined($GetParam{"TicketFreeKey$_"})) {
                    $Self->{TicketObject}->TicketFreeTextSet(
                        Key => $GetParam{"TicketFreeKey$_"},
                        Value => $GetParam{"TicketFreeText$_"},
                        Counter => $_,
                        TicketID => $Self->{TicketID},
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
                StateID => $GetParam{StateID},
                UserID => $Self->{UserID},
            );
            # should I set an unlock?
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
                    Year => $GetParam{Year},
                    Month => $GetParam{Month},
                    Day => $GetParam{Day},
                    Hour => $GetParam{Hour},
                    Minute => $GetParam{Minute},
                );
            }
            # remove pre submited attachments
            $Self->{UploadCachObject}->FormIDRemove(FormID => $GetParam{FormID});
            # redirect
            if ($StateData{TypeName} =~ /^close/i) {
                return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenOverview});
            }
            else {
                return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenView});
            }
        }
        else {
            # error page
            return $Self->{LayoutObject}->ErrorScreen();
        }
    }
    else {
        my %Error = ();
        my $Output = $Self->{LayoutObject}->Header(Value => $Ticket{TicketNumber});
        # add std. attachments to email
        if ($GetParam{ResponseID}) {
            my %AllStdAttachments = $Self->{StdAttachmentObject}->StdAttachmentsByResponseID(
                ID => $GetParam{ResponseID},
            );
            foreach (sort keys %AllStdAttachments) {
                my %Data = $Self->{StdAttachmentObject}->StdAttachmentGet(ID => $_);
                $Self->{UploadCachObject}->FormIDAddFile(
                    FormID => $Self->{FormID},
                    %Data,
                );
            }
        }
        # get all attachments meta data
        my @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
            FormID => $Self->{FormID},
        );
        # get last customer article or selecte article ...
        my %Data = ();
        if ($GetParam{ArticleID}) {
            %Data = $Self->{TicketObject}->ArticleGet(
                ArticleID => $GetParam{ArticleID},
            );
        }
        else {
            %Data = $Self->{TicketObject}->ArticleLastCustomerArticle(
                TicketID => $Self->{TicketID},
            );
        }
        # check article type and replace To with From (in case)
        if ($Data{SenderType} !~ /customer/) {
            my $To = $Data{To};
            my $From = $Data{From};
            $Data{From} = $To;
            $Data{To} = $Data{From};
            $Data{ReplyTo} = '';
        }
        # --
        # get customer data
        # --
        my %Customer = ();
        if ($Ticket{CustomerUserID}) {
            %Customer = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $Ticket{CustomerUserID},
            );
        }
        # --
        # check if original content isn't text/plain or text/html, don't use it
        # --
        if ($Data{'ContentType'}) {
            if($Data{'ContentType'} =~ /text\/html/i) {
                $Data{Body} =~ s/\<.+?\>//gs;
            }
            elsif ($Data{'ContentType'} !~ /text\/plain/i) {
                $Data{Body} = "-> no quotable message <-";
            }
        }
        # --
        # prepare body, subject, ReplyTo ...
        # --
        # rewrap body if exists
        if ($Data{Body}) {
            my $NewLine = $Self->{ConfigObject}->Get('Ticket::Frontend::TextAreaEmail') || 75;
            $Data{Body} =~ s/(^>.+|.{4,$NewLine})(?:\s|\z)/$1\n/gm;
            $Data{Body} =~ s/\t/ /g;
            my $Quote = $Self->{ConfigObject}->Get('Ticket::Frontend::Quote');
            if ($Quote) {
                $Data{Body} =~ s/\n/\n$Quote /g;
                $Data{Body} = "\n$Quote " . $Data{Body};
            }
            else {
                $Data{Body} = "\n".$Data{Body};
                if ($Data{Created}) {
                    $Data{Body} = "Date: $Data{Created}\n".$Data{Body};
                }
                foreach (qw(Subject ReplyTo Reply-To Cc To From)) {
                    if ($Data{$_}) {
                        $Data{Body} = "$_: $Data{$_}\n".$Data{Body};
                    }
                }
                $Data{Body} = "\n---- Message from $Data{From} ---\n\n".$Data{Body};
                $Data{Body} .= "\n---- End Message ---\n";
            }
        }
        $Data{Subject} = $Self->{TicketObject}->TicketSubjectBuild(
            TicketNumber => $Ticket{TicketNumber},
            Subject => $Data{Subject} || '',
        );
        # check ReplyTo
        if ($Data{ReplyTo}) {
            $Data{To} = $Data{ReplyTo};
        }
        else {
            $Data{To} = $Data{From};
            # try to remove some wrong text to from line (by way of ...)
            # added by some strange mail programs on bounce
            $Data{To} =~ s/(.+?\<.+?\@.+?\>)\s+\(by\s+way\s+of\s+.+?\)/$1/ig;
        }
        # get to email (just "some@example.com")
        foreach my $Email (Mail::Address->parse($Data{To})) {
            $Data{ToEmail} = $Email->address();
        }
        # use database email
        if ($Customer{UserEmail} && $Data{ToEmail} !~ /^\Q$Customer{UserEmail}\E$/i) {
            if ($Self->{ConfigObject}->Get('Ticket::Frontend::ComposeReplaceSenderAddress')) {
                $Output .= $Self->{LayoutObject}->Notify(
                    Info => 'To: (%s) replaced with database email!", "$Quote{"'.$Data{To}.'"}',
                );
                $Data{To} = $Customer{UserEmail};
            }
            else {
                $Output .= $Self->{LayoutObject}->Notify(
                    Info => 'Cc: (%s) added database email!", "$Quote{"'.$Customer{UserEmail}.'"}',
                );
                if ($Data{Cc}) {
                    $Data{Cc} .= ', '.$Customer{UserEmail};
                }
                else {
                    $Data{Cc} = $Customer{UserEmail};
                }
            }
        }
        $Data{OrigFrom} = $Data{From};
        my %Address = $Self->{QueueObject}->GetSystemAddress(%Ticket);
        $Data{From} = "$Address{RealName} <$Address{Email}>";
        $Data{Email} = $Address{Email};
        $Data{RealName} = $Address{RealName};
        $Data{StdResponse} = $Self->{QueueObject}->GetStdResponse(ID => $GetParam{ResponseID});

        # --
        # prepare salutation & signature
        $Data{Salutation} = $Self->{QueueObject}->GetSalutation(%Ticket);
        $Data{Signature} = $Self->{QueueObject}->GetSignature(%Ticket);
        foreach (qw(Signature Salutation StdResponse)) {
            # get and prepare realname
            if ($Data{$_} =~ /<OTRS_CUSTOMER_REALNAME>/) {
                my $From = '';
                if ($Ticket{CustomerUserID}) {
                    $From = $Self->{CustomerUserObject}->CustomerName(UserLogin => $Ticket{CustomerUserID});
                }
                if (!$From) {
                    $From = $Data{OrigFrom} || '';
                    $From =~ s/<.*>|\(.*\)|\"|;|,//g;
                    $From =~ s/( $)|(  $)//g;
                }
                $Data{$_} =~ s/<OTRS_CUSTOMER_REALNAME>/$From/g;
            }
            # replace user staff
            my %User = $Self->{UserObject}->GetUserData(
                UserID => $Self->{UserID},
                Cached => 1,
            );
            foreach my $UserKey (keys %User) {
                if ($User{$UserKey}) {
                    $Data{$_} =~ s/<OTRS_Agent_$UserKey>/$User{$UserKey}/gi;
                }
            }
            # cleanup all not needed <OTRS_TICKET_ tags
            $Data{$_} =~ s/<OTRS_Agent_.+?>/-/gi;
            # replace other needed stuff
            $Data{$_} =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
            $Data{$_} =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;
            # replace ticket data
            foreach my $TicketKey (keys %Ticket) {
                if ($Ticket{$TicketKey}) {
                    $Data{$_} =~ s/<OTRS_TICKET_$TicketKey>/$Ticket{$TicketKey}/gi;
                }
            }
            # cleanup all not needed <OTRS_TICKET_ tags
            $Data{$_} =~ s/<OTRS_TICKET_.+?>/-/gi;
            # replace customer data
            foreach my $CustomerKey (keys %Customer) {
                if ($Customer{$CustomerKey}) {
                    $Data{$_} =~ s/<OTRS_CUSTOMER_$CustomerKey>/$Customer{$CustomerKey}/gi;
                }
            }
            # cleanup all not needed <OTRS_CUSTOMER_ tags
            $Data{$_} =~ s/<OTRS_CUSTOMER_.+?>/-/gi;
            # replace config options
            $Data{$_} =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
        }
        # --
        # check some values
        # --
        foreach (qw(From To Cc Bcc)) {
            if ($Data{$_}) {
                foreach my $Email (Mail::Address->parse($Data{$_})) {
                    if (!$Self->{CheckItemObject}->CheckEmail(Address => $Email->address())) {
                         $Error{"$_ invalid"} .= $Self->{CheckItemObject}->CheckError();
                    }
                }
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
        # ticket free time
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
        my %TicketFreeTimeHTML = $Self->{LayoutObject}->AgentFreeDate(
            Ticket => \%TicketFreeTime,
        );
        # article free text
        my %ArticleFreeText = ();
        foreach (1..16) {
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
                    foreach ($Object->Option(%Data, %GetParam, Config => $Jobs{$Job})) {
                        $GetParam{$_} = $Self->{ParamObject}->GetParam(Param => $_);
                    }
                    # run module
                    $Object->Run(%Data, %GetParam, Config => $Jobs{$Job});
                    # get errors
                    %Error = (%Error, $Object->Error(%GetParam, Config => $Jobs{$Job}));
                }
                else {
                    return $Self->{LayoutObject}->FatalError();
                }
            }
        }
        # build view ...
        $Output .= $Self->_Mask(
            TicketID => $Self->{TicketID},
            NextStates => $Self->_GetNextStates(),
            ResponseFormat => $Self->{ResponseFormat},
            Attachments => \@Attachments,
            Errors => \%Error,
            %Ticket,
            %Data,
#            %GetParam,
            %TicketFreeTextHTML,
            %TicketFreeTimeHTML,
            %ArticleFreeTextHTML,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
}

sub _GetNextStates {
    my $Self = shift;
    my %Param = @_;
    # get next states
    my %NextStates = $Self->{TicketObject}->StateList(
        Action => $Self->{Action},
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID},
    );
    return \%NextStates;
}

sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # build next states string
    if (!$Self->{Config}->{StateDefault}) {
        $Param{NextStates}->{''} = '-';
    }
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'StateID',
        Selected => $Param{NextState} || $Self->{Config}->{StateDefault},
    );
    # prepare errors!
    if ($Param{Errors}) {
        foreach (keys %{$Param{Errors}}) {
            $Param{$_} = "* ".$Self->{LayoutObject}->Ascii2Html(Text => $Param{Errors}->{$_});
        }
    }
    # pending data string
    $Param{PendingDateString} = $Self->{LayoutObject}->BuildDateSelection(
        %Param,
        Format => 'DateInputFormatLong',
        DiffTime => $Self->{ConfigObject}->Get('Ticket::Frontend::PendingDiffTime') || 0,
    );
    # js for time accounting
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')) {
        $Self->{LayoutObject}->Block(
            Name => 'TimeUnitsJs',
            Data => \%Param,
        );
    }
    $Self->{LayoutObject}->Block(
        Name => 'Content',
        Data => {
            FormID => $Self->{FormID},
            %Param,
        },
    );
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
    # show time accounting box
    if ($Self->{ConfigObject}->Get('Ticket::Frontend::AccountTime')) {
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
    # show address book
    if ($Self->{LayoutObject}->{BrowserJavaScriptSupport}) {
        $Self->{LayoutObject}->Block(
            Name => 'AddressBook',
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
    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentTicketCompose', Data => \%Param);
}

1;
