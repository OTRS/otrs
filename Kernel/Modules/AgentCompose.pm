# --
# Kernel/Modules/AgentCompose.pm - to compose and send a message
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: AgentCompose.pm,v 1.35 2003-02-08 15:16:29 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::Modules::AgentCompose;

use strict;
use Kernel::System::EmailParser;
use Kernel::System::CheckItem;
use Kernel::System::StdAttachment;

use vars qw($VERSION);
$VERSION = '$Revision: 1.35 $';
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

    $Self->{EmailParserObject} = Kernel::System::EmailParser->new(%Param);
    $Self->{CheckItemObject} = Kernel::System::CheckItem->new(%Param);
    $Self->{StdAttachmentObject} = Kernel::System::StdAttachment->new(%Param);

    # --
    # get params
    # --
    foreach (qw(From To Cc Bcc Subject Body Email InReplyTo ResponseID ComposeStateID 
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
    my $TicketID = $Self->{TicketID};
    # -- 
    # start with page ...
    # --
    $Output .= $Self->{LayoutObject}->Header(Title => 'Compose');
    # -- 
    # check needed stuff
    # --
    if (!$TicketID) {
        $Output .= $Self->{LayoutObject}->Error(
                Message => "Got no TicketID!",
                Comment => 'System Error!',
        );
        $Output .= $Self->{LayoutObject}->Footer();
        return $Output;
    }
    # --
    # check permissions
    # --
    if (!$Self->{TicketObject}->Permission(
        TicketID => $Self->{TicketID},
        ArticleID => $Self->{ArticleID},
        UserID => $Self->{UserID})) {
        # --
        # error screen, don't show ticket
        # --
        return $Self->{LayoutObject}->NoPermission(WithHeader => 'yes');
    }
    # --
    # get ticket number and queue id 
    # --
    my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
    my $QueueID = $Self->{TicketObject}->GetQueueIDOfTicketID(TicketID => $TicketID);
    my $QueueObject = Kernel::System::Queue->new(
        QueueID => $QueueID,
        DBObject => $Self->{DBObject},
        ConfigObject => $Self->{ConfigObject},
        LogObject => $Self->{LogObject},
    );
    # --
    # get lock state && write (lock) permissions
    # --
    if (!$Self->{TicketObject}->IsTicketLocked(TicketID => $TicketID)) {
        # set owner
        $Self->{TicketObject}->SetOwner(
            TicketID => $TicketID,
            UserID => $Self->{UserID},
            NewUserID => $Self->{UserID},
        );
        # set lock
        if ($Self->{TicketObject}->SetLock(
            TicketID => $TicketID,
            Lock => 'lock',
            UserID => $Self->{UserID}
        )) {
            # show lock state
            $Output .= $Self->{LayoutObject}->TicketLocked(TicketID => $TicketID);
        }
    }
    else {
        my ($OwnerID, $OwnerLogin) = $Self->{TicketObject}->CheckOwner(
            TicketID => $TicketID,
        );
        if ($OwnerID != $Self->{UserID}) {
            $Output .= $Self->{LayoutObject}->Error(
                Message => "Sorry, the current owner is $OwnerLogin",
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
            TicketID => $TicketID,
        );
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
    $Data{Subject} =~ s/\[$TicketHook: $Tn\] //g;
    $Data{Subject} =~ s/^..: //;
    $Data{Subject} =~ s/^(.{30}).*$/$1 [...]/;
    $Data{Subject} = "[$TicketHook: $Tn] Re: " . $Data{Subject};

    if ($Data{ReplyTo}) {
        $Data{To} = $Data{ReplyTo};
    }
    else {
        $Data{To} = $Data{From};
        # try to remove some wrong text to from line (by way of ...) 
        # added by some strange mail programs on bounce 
        $Data{To} =~ s/(.+?\<.+?\@.+?\>)\s+\(by\s+way\s+of\s+.+?\)/$1/ig;
    }
    $Data{OrigFrom} = $Data{From};
    my %Address = $QueueObject->GetSystemAddress();
    $Data{From} = "$Address{RealName} <$Address{Email}>";
    $Data{Email} = $Address{Email};
    $Data{RealName} = $Address{RealName};
    $Data{StdResponse} = $QueueObject->GetStdResponse(ID => $Self->{ResponseID});

    # --
    # prepare salutation
    # --
    $Data{Salutation} = $QueueObject->GetSalutation();
    # prepare customer realname
    if ($Data{Salutation} =~ /<OTRS_CUSTOMER_REALNAME>/) {
        # get realname 
        my $From = $Data{OrigFrom} || '';
        $From =~ s/<.*>|\(.*\)|\"|;|,//g;
        $From =~ s/( $)|(  $)//g;
        $Data{Salutation} =~ s/<OTRS_CUSTOMER_REALNAME>/$From/g;
    }
    # --
    # prepare signature
    # --
    $Data{Signature} = $QueueObject->GetSignature();
    $Data{Signature} =~ s/<OTRS_FIRST_NAME>/$Self->{UserFirstname}/g;
    $Data{Signature} =~ s/<OTRS_LAST_NAME>/$Self->{UserLastname}/g;
    # --
    # check some values
    # --
    my %Error = ();
    foreach (qw(From To Cc Bcc)) {
        if ($Data{$_}) {
            my @Addresses = $Self->{EmailParserObject}->SplitAddressLine(Line => $Data{$_});
            foreach my $Address (@Addresses) {
                if (!$Self->{CheckItemObject}->CkeckEmail(Address => $Address)) {
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
    $Output .= $Self->{LayoutObject}->AgentCompose(
        TicketNumber => $Tn,
        TicketID => $TicketID,
        QueueID => $QueueID,
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
    my $TicketID = $Self->{TicketID};
    my $NextState = $Self->{TicketObject}->StateIDLookup(StateID => $Self->{ComposeStateID});
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
            my @Addresses = $Self->{EmailParserObject}->SplitAddressLine(Line => $Self->{$_});
            foreach my $Address (@Addresses) {
                if (!$Self->{CheckItemObject}->CkeckEmail(Address => $Address)) {
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
        my $Tn = $Self->{TicketObject}->GetTNOfId(ID => $TicketID);
        my $QueueID = $Self->{TicketObject}->GetQueueIDOfTicketID(TicketID => $TicketID);
        my $Output = $Self->{LayoutObject}->Header(Title => 'Compose');
        my %Data = ();
        foreach (qw(From To Cc Bcc Subject Body Email InReplyTo Answered ArticleID 
          TimeUnits Year Month Day Hour Minute)) {
            $Data{$_} = $Self->{$_};
        }
        $Data{StdResponse} = $Self->{Body};
        $Output .= $Self->{LayoutObject}->AgentCompose(
            TicketNumber => $Tn,
            TicketID => $TicketID,
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
    # --
    # send email
    # --
    if (my $ArticleID = $Self->{TicketObject}->SendArticle(
        %UploadStuff,
        ArticleType => 'email-external',
        SenderType => 'agent',
        TicketID => $TicketID,
        HistoryType => 'SendAnswer',
        HistoryComment => "Sent email to '$Self->{To}'.",
        From => $Self->{From},
        Email => $Self->{Email},
        To => $Self->{To},
        Cc => $Self->{Cc},
        Subject => $Self->{Subject},
        UserID => $Self->{UserID},
        Body => $Self->{Body},
        InReplyTo => $Self->{InReplyTo},
        Charset => $Self->{UserCharset},
        StdAttachmentIDs => \@StdAttachmentIDs,
    )) {
        # --
        # time accounting
        # --
        if ($Self->{TimeUnits}) {
            $Self->{TicketObject}->AccountTime(
                TicketID => $TicketID,
                ArticleID => $ArticleID,
                TimeUnit => $Self->{TimeUnits},
                UserID => $Self->{UserID},
            );
        }
        # --
        # set state
        # --
        $Self->{TicketObject}->SetState(
            TicketID => $TicketID,
            ArticleID => $ArticleID,
            State => $NextState,
            UserID => $Self->{UserID},
        );
        # --
        # set answerd
        # --
        $Self->{TicketObject}->SetAnswered(
            TicketID => $TicketID,
            UserID => $Self->{UserID},
            Answered => $Self->{Answered},
        );
        # --
        # should i set an unlock?
        # --
        if ($NextState =~ /^close/i) {
            $Self->{TicketObject}->SetLock(
                TicketID => $TicketID,
                Lock => 'unlock',
                UserID => $Self->{UserID},
            );
        }
        # --
        # set pending time
        # --
        elsif ($NextState =~ /^pending/i) {
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
        # --
        # redirect
        # --
        return $Self->{LayoutObject}->Redirect(OP => $Self->{LastScreen});
    }
    else {
      # --
      # error page
      # --
      $Output .= $Self->{LayoutObject}->Header(Title => 'Compose');
      $Output .= $Self->{LayoutObject}->Error(
          Message => "Can't send email!",
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
    # --
    # get next states
    # --
    my %NextStates;
    my $NextComposeTypePossible =
       $Self->{ConfigObject}->Get('DefaultNextComposeTypePossible')
           || die 'No Config entry "DefaultNextComposeTypePossible"!';
    foreach (@{$NextComposeTypePossible}) {
        $NextStates{$Self->{TicketObject}->StateLookup(State => $_)} = $_;
    }
    return \%NextStates;
}
# --

1;
