# --
# Kernel/Modules/AgentCompose.pm - to compose and send a message
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentCompose.pm,v 1.57 2004-01-27 09:26:06 martin Exp $
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
use Mail::Address;

use vars qw($VERSION);
$VERSION = '$Revision: 1.57 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
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

    # --
    # get params
    # --
    foreach (qw(From To Cc Bcc Subject Body InReplyTo ResponseID ComposeStateID 
      Answered ArticleID TimeUnits Year Month Day Hour Minute)) {
        my $Value = $Self->{ParamObject}->GetParam(Param => $_);
        $Self->{$_} = defined $Value ? $Value : '';
    }
    # -- 
    # get response format
    # --
    $Self->{ResponseFormat} = $Self->{ConfigObject}->Get('ResponseFormat') ||
      '$Data{"Salutation"}
$Data{"OrigFrom"} $Text{"wrote"}:
$Data{"Body"}

$Data{"StdResponse"}

$Data{"Signature"}
';
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
    # -- 
    # start with page ...
    # --
    $Output .= $Self->{LayoutObject}->Header(Area => 'Agent', Title => 'Compose');
    # -- 
    # check needed stuff
    # --
    if (!$Self->{TicketID}) {
        $Output .= $Self->{LayoutObject}->Error(
                Message => "Got no TicketID!",
                Comment => 'System Error!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # get ticket data
    # --
    my %Ticket = $Self->{TicketObject}->GetTicket(TicketID => $Self->{TicketID});
    if ($Self->{ConfigObject}->Get('AgentCanBeCustomer') && $Ticket{CustomerUserID} && $Ticket{CustomerUserID} eq $Self->{UserLogin}) {
        # --
        # redirect
        # --
        return $Self->{LayoutObject}->Redirect(
            OP => "Action=AgentCustomerFollowUp&TicketID=$Self->{TicketID}",
        );
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        Type => 'rw',
        TicketID => $Self->{TicketID},
        UserID => $Self->{UserID})) {
        # error screen, don't show ticket
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # --
    # get lock state && write (lock) permissions
    # --
    if (!$Self->{TicketObject}->IsTicketLocked(TicketID => $Self->{TicketID})) {
        # set owner
        $Self->{TicketObject}->SetOwner(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
            NewUserID => $Self->{UserID},
        );
        # set lock
        if ($Self->{TicketObject}->SetLock(
            TicketID => $Self->{TicketID},
            Lock => 'lock',
            UserID => $Self->{UserID}
        )) {
            # show lock state
            $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $Self->{TicketID});
        }
    }
    else {
        my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->CheckOwner(
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
    # -- 
    # get last customer article or selecte article ...
    # --
    my %Data = ();
    if ($Self->{ArticleID}) {
        %Data = $Self->{TicketObject}->GetArticle(
            ArticleID => $Self->{ArticleID},
        );
    }
    else {
        %Data = $Self->{TicketObject}->GetLastCustomerArticle(
            TicketID => $Self->{TicketID},
        );
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
    $Data{Body} =~ s/(.{$NewLine}.+?\s)/$1\n/g;
    $Data{Body} =~ s/\n/\n> /g;
    $Data{Body} = "\n> " . $Data{Body};

    my $TicketHook = $Self->{ConfigObject}->Get('TicketHook') || '';
    $Data{Subject} =~ s/^..: //;
    $Data{Subject} =~ s/\[$TicketHook: $Ticket{TicketNumber}\] //g;
    $Data{Subject} =~ s/^..: //;
    $Data{Subject} =~ s/^(.{30}).*$/$1 [...]/;
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
    $Data{StdResponse} = $Self->{QueueObject}->GetStdResponse(ID => $Self->{ResponseID});

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
    # --
    # prepare signature
    # --
    $Data{Signature} = $Self->{QueueObject}->GetSignature(%Ticket);
    foreach (qw(Signature Salutation)) {
        $Data{$_} =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
        $Data{$_} =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;
        $Data{$_} =~ s/<OTRS_USER_ID>/$Self->{UserID}/g;
        $Data{$_} =~ s/<OTRS_USER_LOGIN>/$Self->{UserLogin}/g;
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
    # --
    # get std attachments
    # --
    my %AllStdAttachments = $Self->{StdAttachmentObject}->StdAttachmentsByResponseID(
        ID => $Self->{ResponseID},
    );
    # --
    # build view ...
    # --
    $Output .= $Self->_Mask(
        TicketNumber => $Ticket{TicketNumber},
        TicketID => $Self->{TicketID},
        QueueID => $Ticket{QueueID},
        NextStates => $Self->_GetNextStates(),
        ResponseFormat => $Self->{ResponseFormat},
        Errors => \%Error,
        StdAttachments => \%AllStdAttachments,
        %Data,
    );
    $Output .= $Self->{LayoutObject}->Footer();
    
    return $Output;
}
# --
sub SendEmail {
    my $Self = shift;
    my %Param = @_;
    my $Output = '';
    my $QueueID = $Self->{QueueID};
    my %StateData = $Self->{TicketObject}->{StateObject}->StateGet(
        ID => $Self->{ComposeStateID},
    );
    my $NextState = $StateData{Name};
    # --
    # get attachment
    # -- 
    my %UploadStuff = $Self->{ParamObject}->GetUploadAll(
        Param => 'file_upload',
        Source => 'string',
    );
    # --
    # check some values
    # --
    my %Error = ();
    foreach (qw(From To Cc Bcc)) {
        if ($Self->{$_}) {
            foreach my $Email (Mail::Address->parse($Self->{$_})) {
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
    # --
    # check if there is an error
    # --
    if (%Error) {
        my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $Self->{TicketID});
        my $QueueID = $Self->{TicketObject}->GetQueueIDOfTicketID(TicketID => $Self->{TicketID});
        my $Output = $Self->{LayoutObject}->Header(Title => 'Compose');
        my %Data = ();
        foreach (qw(From To Cc Bcc Subject Body InReplyTo Answered ArticleID 
          TimeUnits Year Month Day Hour Minute)) {
            $Data{$_} = $Self->{$_};
        }
        $Data{StdResponse} = $Self->{Body};
        $Output .= $Self->_Mask(
            TicketNumber => $Tn,
            TicketID => $Self->{TicketID},
            QueueID => $QueueID,
            NextStates => $Self->_GetNextStates(),
            NextState => $NextState,
            ResponseFormat => $Self->{Body},
            AnsweredID => $Self->{Answered},
            %Data,
            Errors => \%Error,
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output; 
    }
    # replace <OTRS_TICKET_STATE> with next ticket state name
    if ($NextState) {
        $Self->{Body} =~ s/<OTRS_TICKET_STATE>/$NextState/g;
    }
    # send email
    if (my $ArticleID = $Self->{TicketObject}->SendArticle(
        Attach => [\%UploadStuff],
        ArticleType => 'email-external',
        SenderType => 'agent',
        TicketID => $Self->{TicketID},
        HistoryType => 'SendAnswer',
        HistoryComment => "Sent email to '$Self->{To}'.",
        From => $Self->{From},
        To => $Self->{To},
        Cc => $Self->{Cc},
        Bcc => $Self->{Bcc},
        Subject => $Self->{Subject},
        UserID => $Self->{UserID},
        Body => $Self->{Body},
        InReplyTo => $Self->{InReplyTo},
        Charset => $Self->{LayoutObject}->{UserCharset},
        StdAttachmentIDs => \@StdAttachmentIDs,
    )) {
        # time accounting
        if ($Self->{TimeUnits}) {
            $Self->{TicketObject}->AccountTime(
                TicketID => $Self->{TicketID},
                ArticleID => $ArticleID,
                TimeUnit => $Self->{TimeUnits},
                UserID => $Self->{UserID},
            );
        }
        # set state
        $Self->{TicketObject}->SetState(
            TicketID => $Self->{TicketID},
            ArticleID => $ArticleID,
            State => $NextState,
            UserID => $Self->{UserID},
        );
        # set answerd
        $Self->{TicketObject}->SetAnswered(
            TicketID => $Self->{TicketID},
            UserID => $Self->{UserID},
            Answered => $Self->{Answered},
        );
        # should I set an unlock?
        if ($StateData{TypeName} =~ /^close/i) {
            $Self->{TicketObject}->SetLock(
                TicketID => $Self->{TicketID},
                Lock => 'unlock',
                UserID => $Self->{UserID},
            );
        }
        # set pending time
        elsif ($StateData{TypeName} =~ /^pending/i) {
            $Self->{TicketObject}->SetPendingTime(
                UserID => $Self->{UserID},
                TicketID => $Self->{TicketID},
                Year => $Self->{Year},
                Month => $Self->{Month},
                Day => $Self->{Day},
                Hour => $Self->{Hour},
                Minute => $Self->{Minute},
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
    my %NextStates = $Self->{StateObject}->StateGetStatesByType(
        Type => 'DefaultNextCompose',
        Result => 'HASH',
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
    if ($Param{AnsweredID}) {
        $Param{'AnsweredYesNoOption'} = $Self->{LayoutObject}->OptionStrgHashRef(
            Data => $Self->{ConfigObject}->Get('YesNoOptions'),
            Name => 'Answered',
            SelectedID => $Param{AnsweredID},
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
    # create & return output
    return $Self->{LayoutObject}->Output(TemplateFile => 'AgentCompose', Data => \%Param);
}
# --
1;
