# --
# Kernel/System/PostMaster/FollowUp.pm - the sub part of PostMaster.pm 
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FollowUp.pm,v 1.18 2002-09-23 20:34:18 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::FollowUp;

use strict;
use Kernel::System::AutoResponse;
use Kernel::System::SendNotification;
use Kernel::System::User;

use vars qw($VERSION);
$VERSION = '$Revision: 1.18 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {}; 
    bless ($Self, $Type);

    # 0=off 1=on
    $Self->{Debug} = 0;

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    # check needed Objects
    foreach (
      'DBObject', 
      'ConfigObject', 
      'ArticleObject', 
      'TicketObject', 
      'LogObject', 
      'LoopProtectionObject',
    ) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{SendAutoResponse} = Kernel::System::SendAutoResponse->new(%Param);
    $Self->{SendNotification} = Kernel::System::SendNotification->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $TicketID = $Param{TicketID};
    my $InmailUserID = $Param{InmailUserID}; 
    my $GetParamTmp = $Param{GetParam};
    my %GetParam = %$GetParamTmp;
    my $Tn = $Param{Tn};
    my $Email = $Param{Email};
    my $State = $Param{State} || '';
	my $Comment = $Param{Comment} || '';
    my $Lock = $Param{Lock} || '';
    my $QueueID = $Param{QueueID};
    my $AutoResponseType = $Param{AutoResponseType} || '';

    my $DBObject = $Self->{DBObject};
    my $ArticleObject = $Self->{ArticleObject};
    my $TicketObject = $Self->{TicketObject};
    my $LogObject = $Self->{LogObject};

    my $OldState = $TicketObject->GetState(TicketID => $TicketID) || '';

    # create ob
    my $EmailObject = Kernel::System::EmailSend->new(
        ConfigObject => $Self->{ConfigObject},
        LogObject => $Self->{LogObject} ,
        DBObject => $Self->{DBObject},
    );

    # do db insert
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
        HistoryType => 'FollowUp',
        HistoryComment => "FollowUp for [$Tn]. $Comment",
    ); 

    # write to fs
    $ArticleObject->WriteArticle(ArticleID => $ArticleID, Email => $Email);

    # set free article text
    my @Values = ('X-OTRS-ArticleKey', 'X-OTRS-ArticleValue');
    my $CounterTmp = 0;
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
    # --
    # set state 
    # --
    if ($State && ($OldState ne $State)) {
	    $TicketObject->SetState(
    	    State => $State,
        	TicketID => $TicketID,
	        UserID => $InmailUserID,
    	);
    }
    # --
    # set lock
    # --
    if ($Lock && !$TicketObject->GetLockState(TicketID => $TicketID) && $OldState =~ /^close/i) {
       $TicketObject->SetLock( 
           TicketID => $TicketID,
           Lock => 'lock',
           UserID => => $InmailUserID,
       );
    }
    # --
    # set unanswered
    # --
    $TicketObject->SetAnswered(
        TicketID => $TicketID,
        UserID => $InmailUserID,
        Answered => 0,
    );

    # write log
    $LogObject->Log(
        Message => "FollowUp Article to Ticket [$Tn] created (TicketID=$TicketID, " .
			"ArticleID=$ArticleID). $Comment"
    );

    # --
    # send auto response?
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
        }
        else { 
            # write log
            if ($Self->{LoopProtectionObject}->SendEmail(To => $GetParam{From})) {
                $Self->{SendAutoResponse}->Send(
                    %Data,
                    CustomerMessageParams => \%GetParam,
                    TicketNumber => $Tn,
                    TicketID => $TicketID,
                    UserID => $InmailUserID,
                    HistoryType => 'SendAutoFollowUp',
                );
            }
        }
    }
    else {
        # do log
        $LogObject->Log(Message => "Sent no auto follow up for Ticket [$Tn] " .
			"($GetParam{From})."
       );
    }

    # --
    # send agent notification!?
    # --
    # get owner
    my ($OwnerID, $Owner) = $TicketObject->CheckOwner(TicketID => $TicketID);
    # debug
    if ($Self->{Debug} > 0) {
       $LogObject->Log(
            Message => "OwnerID of ticket $Tn is $OwnerID.",
       );
    }
    if ($OwnerID ne $Self->{ConfigObject}->Get('PostmasterUserID')) {
        my $UserObject = Kernel::System::User->new(
           DBObject => $Self->{DBObject}, 
           ConfigObject => $Self->{ConfigObject}, 
           LogObject => $Self->{LogObject},
        ); 
        my %Preferences = $UserObject->GetUserData(UserID => $OwnerID);

        # debug
        if ($Self->{Debug} > 0) {
          $LogObject->Log(
            Message => "UserSendFollowUpNotification is '$Preferences{UserSendFollowUpNotification}'.",
          );
        }
        # check UserSendFollowUpNotification
        if ($Preferences{UserSendFollowUpNotification}) {
            # --
            # send notification
            # --
            $Self->{SendNotification}->Send(
                %Preferences,
                Type => 'FollowUp',
                To => $Preferences{UserEmail},
                CustomerMessageParams => \%GetParam,
                TicketNumber => $Tn,
                TicketID => $TicketID,
                UserID => $InmailUserID,
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
