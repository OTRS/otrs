# --
# Kernel/Modules/AgentCompose.pm - to compose and send a message
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentCompose.pm,v 1.69 2004-07-29 06:14:48 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentCompose;

use strict;
use Kernel::System::CheckItem;
use Kernel::System::StdAttachment;
use Kernel::System::State;
use Kernel::System::CustomerUser;
use Kernel::System::WebUploadCache;
use Mail::Address;

use vars qw($VERSION);
$VERSION = '$Revision: 1.69 $';
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
    foreach (qw(TicketObject ParamObject DBObject QueueObject LayoutObject
      ConfigObject LogObject)) {
        die "Got no $_" if (!$Self->{$_});
    }
    # some new objects
    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new(%Param);
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);
    $Self->{StateObject} = Kernel::System::State->new(%Param);
    $Self->{UploadCachObject} = Kernel::System::WebUploadCache->new(%Param);
    # anyway, we need to check the email syntax (removed it, because the admins should configure it)
#    $Self->{ConfigObject}->Set(Key => 'CheckEmailAddresses', Value => 1);
    # get params
    foreach (qw(From To Cc Bcc Subject Body InReplyTo ResponseID ComposeStateID
      Answered ArticleID TimeUnits Year Month Day Hour Minute AttachmentUpload
      AttachmentDelete1 AttachmentDelete2 AttachmentDelete3 AttachmentDelete4
      AttachmentDelete5 AttachmentDelete6 AttachmentDelete7 AttachmentDelete8
      AttachmentDelete9 AttachmentDelete10 FormID)) {
        my $Value = $Self->{ParamObject}->GetParam(Param => $_);
#        $Self->{GetParam}->{$_} = defined $Value ? $Value : '';
       if (defined($Value)) {
           $Self->{GetParam}->{$_} = $Value;
       }
    }
    # get response format
    $Self->{ResponseFormat} = $Self->{ConfigObject}->Get('ResponseFormat') ||
      '$Data{"Salutation"}
$Data{"OrigFrom"} $Text{"wrote"}:
$Data{"Body"}

$Data{"StdResponse"}

$Data{"Signature"}
';
    # create form id
    if (!$Self->{GetParam}->{FormID}) {
        $Self->{GetParam}->{FormID} = $Self->{UploadCachObject}->FormIDCreate();
    }

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $Output;

    if ($Self->{Subaction} eq 'SendEmail') {
        $Output = $Self->SendEmail();
    }
    else {
        $Output = $Self->Form();
    }
    return $Output;
}
# --
sub Form {
    my $Self = shift;
    my %Param = @_;
    my $Output;
    my %Error = ();
    my %GetParam = %{$Self->{GetParam}};
    # start with page ...
    $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Compose');
    # check needed stuff
    if (!$Self->{TicketID}) {
        $Output .= $Self->{LayoutObject}->Error(
                Message => "Got no TicketID!",
                Comment => 'System Error!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Self->{TicketID});
    if ($Self->{ConfigObject}->Get('AgentCanBeCustomer') && $Ticket{CustomerUserID} && $Ticket{CustomerUserID} eq $Self->{UserLogin}) {
        # redirect
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentCustomerFollowUp&TicketID=$Self->{TicketID}",
        );
    }
    # check permissions
    if (!$Self->{TicketObject}->Permission(
        Type => 'rw',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # get lock state && write (lock) permissions
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
            UserID => $Self->{UserID}
        )) {
            # show lock state
            $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $Self->{TicketID});
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
    }
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
    my $NewLine = $Self->{ConfigObject}->Get('ComposeTicketNewLine') || 75;
    $Data{Body} =~ s/(^>.+|.{4,$NewLine})(?:\s|\z)/$1\n/gm;
    $Data{Body} =~ s/\n/\n> /g;
    $Data{Body} = "\n> " . $Data{Body};

    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook') || '';
    $Data{Subject} =~ s/^..: //;
    $Data{Subject} =~ s/\[$TicketHook: $Ticket{TicketNumber}\] //g;
    $Data{Subject} =~ s/^..: //;
    $Data{Subject} =~ s/^(.{45}).*$/$1 [...]/;
    $Data{Subject} = "[$TicketHook: $Ticket{TicketNumber}] Re: " . $Data{Subject};

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
        $Output .= $Self->{LayoutObject}->Notify(
            Info => 'To: (%s) replaced with database email!", "$Quote{"'.$Data{To}.'"}',
        );
        $Data{To} = $Customer{UserEmail};
    }
    $Data{OrigFrom} = $Data{From};
    my %Address = $Self->{QueueObject}->GetSystemAddress(%Ticket);
    $Data{From} = "$Address{RealName} <$Address{Email}>";
    $Data{Email} = $Address{Email};
    $Data{RealName} = $Address{RealName};
    $Data{StdResponse} = $Self->{QueueObject}->GetStdResponse(ID => $GetParam{ResponseID});

    # --
    # prepare salutation
    # --
    $Data{Salutation} = $Self->{QueueObject}->GetSalutation(%Ticket);
    # prepare customer realname
    if ($Data{Salutation} =~ /<OTRS_CUSTOMER_REALNAME>/) {
        # get realname
        my $From = '';
        if ($Ticket{CustomerUserID}) {
            $From = $Self->{CustomerUserObject}->CustomerName(UserLogin => $Ticket{CustomerUserID});
        }
        if (!$From) {
            $From = $Data{OrigFrom} || '';
            $From =~ s/<.*>|\(.*\)|\"|;|,//g;
            $From =~ s/( $)|(  $)//g;
        }
        $Data{Salutation} =~ s/<OTRS_CUSTOMER_REALNAME>/$From/g;
    }
    # prepare signature
    $Data{Signature} = $Self->{QueueObject}->GetSignature(%Ticket);
    foreach (qw(Signature Salutation)) {
        $Data{$_} =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
        $Data{$_} =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;
        $Data{$_} =~ s/<OTRS_USER_ID>/$Self->{UserID}/g;
        $Data{$_} =~ s/<OTRS_USER_LOGIN>/$Self->{UserLogin}/g;
    }
    # replace customer data
    foreach (keys %Customer) {
        if ($Customer{$_}) {
            $Data{Signature} =~ s/<OTRS_CUSTOMER_$_>/$Customer{$_}/gi;
            $Data{Salutation} =~ s/<OTRS_CUSTOMER_$_>/$Customer{$_}/gi;
            $Data{StdResponse} =~ s/<OTRS_CUSTOMER_$_>/$Customer{$_}/gi;
        }
    }
    # cleanup all not needed <OTRS_CUSTOMER_ tags
    $Data{Signature} =~ s/<OTRS_CUSTOMER_.+?>/-/gi;
    $Data{Salutation} =~ s/<OTRS_CUSTOMER_.+?>/-/gi;
    $Data{StdResponse} =~ s/<OTRS_CUSTOMER_.+?>/-/gi;
    # replace config options
    $Data{Signature} =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
    $Data{Salutation} =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
    $Data{StdResponse} =~ s{<OTRS_CONFIG_(.+?)>}{$Self->{ConfigObject}->Get($1)}egx;
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
    # get std attachments
    my %AllStdAttachments = $Self->{StdAttachmentObject}->StdAttachmentsByResponseID(
        ID => $GetParam{ResponseID},
    );
    # run compose modules
    if (ref($Self->{ConfigObject}->Get('Frontend::ArticleComposeModule')) eq 'HASH') {
        my %Jobs = %{$Self->{ConfigObject}->Get('Frontend::ArticleComposeModule')};
        foreach my $Job (sort keys %Jobs) {
                # log try of load module
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "Try to load module: $Jobs{$Job}->{Module}!",
                    );
                }
                if (eval "require $Jobs{$Job}->{Module}") {
                    my $Object = $Jobs{$Job}->{Module}->new(
                        ConfigObject => $Self->{ConfigObject},
                        LogObject => $Self->{LogObject},
                        DBObject => $Self->{DBObject},
                        LayoutObject => $Self->{LayoutObject},
                        TicketObject => $Self->{TicketObject},
                        ParamObject => $Self->{ParamObject},
                        UserID => $Self->{UserID},
                        Debug => $Self->{Debug},
                    );
                    # log loaded module
                    if ($Self->{Debug} > 1) {
                        $Self->{LogObject}->Log(
                            Priority => 'debug',
                            Message => "Module: $Jobs{$Job}->{Module} loaded!",
                        );
                    }
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
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Can't load module $Jobs{$Job}->{Module}!",
                    );
                }
        }
    }

    # build view ...
    $Output .= $Self->_Mask(
        TicketNumber => $Ticket{TicketNumber},
        TicketID => $Self->{TicketID},
        QueueID => $Ticket{QueueID},
        NextStates => $Self->_GetNextStates(),
        ResponseFormat => $Self->{ResponseFormat},
        Errors => \%Error,
        StdAttachments => \%AllStdAttachments,
        %Data,
        %GetParam,
    );
    $Output .= $Self->{LayoutObject}->Footer();

    return $Output;
}
# --
sub SendEmail {
    my $Self = shift;
    my %Param = @_;
    my %Error = ();
    my %GetParam = %{$Self->{GetParam}};
    my $Output = '';
    my $QueueID = $Self->{QueueID};
    my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
        ID => $GetParam{ComposeStateID},
    );
    my $NextState = $StateData{Name};

    # attachment delete
    foreach (1..10) {
        if ($GetParam{"AttachmentDelete$_"}) {
            $Error{AttachmentDelete} = 1;
            $Self->{UploadCachObject}->FormIDRemoveFile(
                FormID => $GetParam{FormID},
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
            FormID => $GetParam{FormID},
            %UploadStuff,
        );
    }
    # get all attachments meta data
    my @Attachments = $Self->{UploadCachObject}->FormIDGetAllFilesMeta(
        FormID => $GetParam{FormID},
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
    # --
    # get std attachment ids
    # --
    my @StdAttachmentIDs = $Self->{ParamObject}->GetArray(Param => 'StdAttachmentID');
    # prepare subject
    my $Tn = $Self->{TicketObject}->TicketNumberLookup(TicketID => $Self->{TicketID});
    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook') || '';
    $GetParam{Subject} =~ s/^..: //;
    $GetParam{Subject} =~ s/\[$TicketHook: $Tn\] //g;
    $GetParam{Subject} =~ s/^..: //;
    $GetParam{Subject} =~ s/^(.{45}).*$/$1 [...]/;
    $GetParam{Subject} = "[$TicketHook: $Tn] ".$GetParam{Subject};

    my %ArticleParam = ();
        # run compose modules
        if (ref($Self->{ConfigObject}->Get('Frontend::ArticleComposeModule')) eq 'HASH') {
            my %Jobs = %{$Self->{ConfigObject}->Get('Frontend::ArticleComposeModule')};
            foreach my $Job (sort keys %Jobs) {
                # log try of load module
                if ($Self->{Debug} > 1) {
                    $Self->{LogObject}->Log(
                        Priority => 'debug',
                        Message => "Try to load module: $Jobs{$Job}->{Module}!",
                    );
                }
                if (eval "require $Jobs{$Job}->{Module}") {
                    my $Object = $Jobs{$Job}->{Module}->new(
                        ConfigObject => $Self->{ConfigObject},
                        LogObject => $Self->{LogObject},
                        DBObject => $Self->{DBObject},
                        LayoutObject => $Self->{LayoutObject},
                        TicketObject => $Self->{TicketObject},
                        ParamObject => $Self->{ParamObject},
                        UserID => $Self->{UserID},
                        Debug => $Self->{Debug},
                    );
                    # log loaded module
                    if ($Self->{Debug} > 1) {
                        $Self->{LogObject}->Log(
                            Priority => 'debug',
                            Message => "Module: $Jobs{$Job}->{Module} loaded!",
                        );
                    }
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
                    $Self->{LogObject}->Log(
                        Priority => 'error',
                        Message => "Can't load module $Jobs{$Job}->{Module}!",
                    );
                }
            }
        }
    # --
    # check if there is an error
    # --
    if (%Error) {
        my $QueueID = $Self->{TicketObject}->TicketQueueID(TicketID => $Self->{TicketID});
        my $Output = $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Compose');
        $GetParam{StdResponse} = $GetParam{Body};
        $Output .= $Self->_Mask(
            TicketNumber => $Tn,
            TicketID => $Self->{TicketID},
            QueueID => $QueueID,
            NextStates => $Self->_GetNextStates(),
            NextState => $NextState,
            ResponseFormat => $Self->{LayoutObject}->Ascii2Html(Text => $GetParam{Body}),
            Errors => \%Error,
            Attachments => \@Attachments,
            %GetParam,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # replace <OTRS_TICKET_STATE> with next ticket state name
    if ($NextState) {
        $GetParam{Body} =~ s/<OTRS_TICKET_STATE>/$NextState/g;
    }
    # get pre loaded attachments
    my @AttachmentData = $Self->{UploadCachObject}->FormIDGetAllFilesData(
        FormID => $GetParam{FormID},
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
        Attach => \@AttachmentData,
        StdAttachmentIDs => \@StdAttachmentIDs,
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
        # set state
        $Self->{TicketObject}->StateSet(
            TicketID => $Self->{TicketID},
            ArticleID => $ArticleID,
            State => $NextState,
            UserID => $Self->{UserID},
        );
        # set answerd
        $Self->{TicketObject}->TicketSetAnswered(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
            Answered => $GetParam{Answered} || 0,
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
        # redirect
        if ($StateData{TypeName} =~ /^close/i) {
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreenQueue});
        }
        else {
            return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
        }
    }
    else {
      # error page
      $Output .= $Self->{LayoutObject}->Header(Title => 'Compose');
      $Output .= $Self->{LayoutObject}->Error(
          Comment => 'Please contact the admin.',
      );
      $Output .= $Self->{LayoutObject}->Footer();
      return $Output;
    }
}
# --
sub _GetNextStates {
    my $Self = shift;
    my %Param = @_;
    # get next states
    my %NextStates = $Self->{TicketObject}->StateList(
        Type => 'DefaultNextCompose',
        Action => $Self->{Action},
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID},
    );
    return \%NextStates;
}
# --
sub _Mask {
    my $Self = shift;
    my %Param = @_;
    # build next states string
    $Param{'NextStatesStrg'} = $Self->{LayoutObject}->OptionStrgHashRef(
        Data => $Param{NextStates},
        Name => 'ComposeStateID',
        Selected => $Param{NextState}
    );
    # build select string
    if ($Param{StdAttachments} && %{$Param{StdAttachments}}) {
      my %Data = %{$Param{StdAttachments}};
      $Param{'StdAttachmentsStrg'} = "<select name=\"StdAttachmentID\" size=2 multiple>\n";
      foreach (sort {$Data{$a} cmp $Data{$b}} keys %Data) {
        if ((defined($_)) && ($Data{$_})) {
            $Param{'StdAttachmentsStrg'} .= '    <option selected value="'.$Self->{LayoutObject}->Ascii2Html(Text => $_).'">'.
                  $Self->{LayoutObject}->Ascii2Html(Text => $Self->{LayoutObject}->{LanguageObject}->Get($Data{$_})) ."</option>\n";
        }
      }
      $Param{'StdAttachmentsStrg'} .= "</select>\n";
    }
    # answered strg
    if (defined($Param{Answered})) {
        $Param{'AnsweredYesNoOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => $Self->{ConfigObject}->Get('YesNoOptions'),
            Name => 'Answered',
            SelectedID => $Param{Answered},
        );
    }
    else {
        $Param{'AnsweredYesNoOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => $Self->{ConfigObject}->Get('YesNoOptions'),
            Name => 'Answered',
            Selected => 'Yes',
        );
    }
    # create FromHTML (to show)
    $Param{FromHTML} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{From}, Max => 70);
    # do html quoting
    foreach (qw(ReplyTo From To Cc Bcc Subject Body)) {
        $Param{$_} = $Self->{LayoutObject}->{LanguageObject}->CharsetConvert(
            Text => $Param{$_},
            From => $Param{ContentCharset},
        );
        $Param{$_} = $Self->{LayoutObject}->Ascii2Html(Text => $Param{$_}) || '';
    }
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
        DiffTime => $Self->{ConfigObject}->Get('PendingDiffTime') || 0,
    );
    # show attachments
    foreach my $DataRef (@{$Param{Attachments}}) {
        $Self->{LayoutObject}->Block(
            Name => 'Attachment',
            Data => $DataRef,
        );
    }
    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentCompose', Data => \%Param);
}
# --
1;
