# --
# Kernel/System/PostMaster/NewTicket.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NewTicket.pm,v 1.22 2002-09-23 20:34:17 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::NewTicket;

use strict;
use Kernel::System::AutoResponse;
use Kernel::System::SendAutoResponse;
use Kernel::System::SendNotification;
use Kernel::System::PostMaster::DestQueue;
use Kernel::System::EmailSend;
use Kernel::System::User;
use Kernel::System::Queue;

use vars qw($VERSION);
$VERSION = '$Revision: 1.22 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
    $Self->{Debug} = 0;
    
    # get all objects
    foreach (
      'DBObject', 
      'ConfigObject', 
      'ArticleObject', 
      'TicketObject', 
      'LogObject', 
      'LoopProtectionObject',
      'ParseObject',
    ) {
        $Self->{$_} = $Param{$_} || die 'Got no $_';
    }

    # get dest queue object
    $Self->{DestQueueObject} = Kernel::System::PostMaster::DestQueue->new(%Param);

    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);

    $Self->{SendAutoResponse} = Kernel::System::SendAutoResponse->new(%Param);
    $Self->{SendNotification} = Kernel::System::SendNotification->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $InmailUserID = $Param{InmailUserID};
    my $GetParamTmp = $Param{GetParam};
    my %GetParam = %$GetParamTmp;
    my $Email = $Param{Email};
    
    my $DBObject = $Self->{DBObject};
    my $ArticleObject = $Self->{ArticleObject};
    my $TicketObject = $Self->{TicketObject};
    my $LogObject = $Self->{LogObject};
    my $Comment = $Param{Comment} || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';
    
    # get queue id
    my $QueueID = $Self->{DestQueueObject}->GetQueueID(Params => \%GetParam);
    # get queue name    
    my $Queue = $Self->{QueueObject}->QueueLookup(QueueID => $QueueID);    
 
    # create new ticket
    my $NewTn = $TicketObject->CreateTicketNr();
    
    # do db insert
    my $TicketID = $TicketObject->CreateTicketDB(
        TN => $NewTn,
        QueueID => $QueueID,
        Lock => 'unlock',
        GroupID => 1,
        Priority => $GetParam{'X-OTRS-Priority'},
        State => $GetParam{'X-OTRS-State'},
        UserID => $InmailUserID,
        CreateUserID => $InmailUserID,
    );
    
    # set customer no
    if ($GetParam{'X-OTRS-CustomerNo'}) {
        $TicketObject->SetCustomerNo(
            TicketID => $TicketID,
            No => $GetParam{'X-OTRS-CustomerNo'},
            UserID => $InmailUserID,
        );
    }
    
    # set free ticket text
    my @Values = ('X-OTRS-TicketKey', 'X-OTRS-TicketValue');
    my $CounterTmp = 0;
    while ($CounterTmp <= 2) {
        $CounterTmp++;
        if ($GetParam{"$Values[0]$CounterTmp"}) {
            $TicketObject->SetFreeText(
                TicketID => $TicketID,
                Key => $GetParam{"$Values[0]$CounterTmp"},
                Value => $GetParam{"$Values[1]$CounterTmp"},
                Counter => $CounterTmp,
                UserID => $InmailUserID,
            );
        }
    }
    
    # do article db insert
    my $ArticleID = $ArticleObject->CreateArticle(
        TicketID => $TicketID,
        ArticleType => 'email-external',
        SenderType => 'customer',
        From => $GetParam{From},
        ReplyTo => $GetParam{ReplyTo},
        To => $GetParam{To},
        Cc => $GetParam{Cc},
        Subject => $GetParam{Subject},
        MessageID => $GetParam{'Message-ID'},
        ContentType => $GetParam{'Content-Type'},
        Body => $GetParam{Body},
        UserID => $InmailUserID,
        HistoryType => 'NewTicket',
        HistoryComment => "New Ticket [$NewTn] created (Queue=$Queue). $Comment",
    );

    # close ticket if article create failed!
    if (!$ArticleID) {
        $TicketObject->SetState(
            TicketID => $TicketID,
            UserID => $InmailUserID,
            State => 'removed',
        );
        $Self->{LogObject}->Log(
            Priority => 'error', 
            Message => "Can't process email with MessageID <$GetParam{'Message-ID'}>! ".
              "Please create a bug report with this email (var/spool/) on http://bugs.otrs.org/!",
        );
        return;
    }
    # set free article text
    @Values = ('X-OTRS-ArticleKey', 'X-OTRS-ArticleValue');
    $CounterTmp = 0;
    while ($CounterTmp <= 3) {
        $CounterTmp++;
        if ($GetParam{"$Values[0]$CounterTmp"}) {
            $ArticleObject->SetFreeText(
                ArticleID => $ArticleID,
                Key => $GetParam{"$Values[0]$CounterTmp"},
                Value => $GetParam{"$Values[1]$CounterTmp"},
                Counter => $CounterTmp,
                UserID => $InmailUserID,
            );
        }
    }
    
    # write it to the fs
    $ArticleObject->WriteArticle(ArticleID => $ArticleID, Email => $Email);
    
    # do log
    $LogObject->Log(
        Message => "New Ticket [$NewTn] created (TicketID=$TicketID, " .
        "ArticleID=$ArticleID). $Comment"
    );
    
    # --
    # send auto response
    # --
    my $AutoResponse = Kernel::System::AutoResponse->new(
        DBObject => $DBObject, 
        LogObject => $Self->{LogObject},
        ConfigObject => $Self->{ConfigObject},
    );
    my %Data = $AutoResponse->AutoResponseGetByTypeQueueID(
        QueueID => $QueueID,
        Type => $AutoResponseType,
    );

    # --
    # check reply to
    # --
    if ($GetParam{ReplyTo}) {
        $GetParam{From} = $GetParam{ReplyTo};
    }

    if ($Data{Text} && $Data{Realname} && $Data{Address} && !$GetParam{'X-OTRS-Loop'}) {
        # --
        # check / loop protection!
        # --
        if (!$Self->{LoopProtectionObject}->Check(To => $GetParam{From})) {
            # add history row
            $TicketObject->AddHistoryRow(
                TicketID => $TicketID,
                HistoryType => 'LoopProtection',
                Name => "Sent no auto response (LoopProtection)!",
                CreateUserID => $InmailUserID,
            );
            return;
        }
        # write log
        if ($Self->{LoopProtectionObject}->SendEmail(To => $GetParam{From})) {
            $Self->{SendAutoResponse}->Send(
                %Data,
                CustomerMessageParams => \%GetParam,
                TicketNumber => $NewTn,
                TicketID => $TicketID,
                UserID => $InmailUserID,        
                HistoryType => 'SendAutoReply',
            );
        }
    }
    else {
        # do log
        $LogObject->Log(Message => "Sent no auto reply for Ticket [$NewTn] ($GetParam{From}) "
        );
    }

    # --
    # send new ticket agent notification?
    # --
    my @UserIDs = ();
    my $SQL = "SELECT user_id FROM personal_queues " .
    " WHERE " .
    " queue_id = $QueueID ";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $Self->{DBObject}->FetchrowArray()) {
        push (@UserIDs, $RowTmp[0]);
    }
    # create user object
    my $UserObject = Kernel::System::User->new(
        DBObject => $Self->{DBObject},
        LogObject => $Self->{LogObject},
        ConfigObject => $Self->{ConfigObject},
    );
    my $To = '';
    foreach (@UserIDs) {
        my %UserData = $UserObject->GetUserData(UserID => $_);
        if ($UserData{UserEmail} && $UserData{UserSendNewTicketNotification}) {
            $To .= "$UserData{UserEmail}, ";
        }
    }
    if ($To) {
        # --
        # send notification
        # --
        $Self->{SendNotification}->Send(
            Type => 'NewTicket',
            To => $To, 
            CustomerMessageParams => \%GetParam,
            TicketNumber => $NewTn,
            TicketID => $TicketID,
            Queue => $Queue, 
            UserID => $InmailUserID,
        );

    }
    else {
       if ($Self->{Debug} > 0) {
           $LogObject->Log(
               Message => "Sent no new ticket notification!",
		   );  
        }
    }
    # --
    # debug
    # --
    if ($Self->{Debug} > 0) {
       $LogObject->Log(
            Message => "Debug($Self->{Debug}): AutoResponseType=$AutoResponseType, " .
			"ResponseFrom=$Data{Address}, QueueID=$QueueID, " .
            "Mailing-List=$GetParam{'Mailing-List'}, " .
            "Precedence=$GetParam{Precedence}, X-Loop=$GetParam{'X-Loop'}, " .
            "X-No-Loop=$GetParam{'X-No-Loop'}, X-OTRS-Loop=$GetParam{'X-OTRS-Loop'}."
		);  
    }
    return 1;
}
# --

1;
