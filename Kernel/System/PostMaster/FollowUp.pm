# --
# PostMaster.pm - the global PostMaster module for OpenTRS
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FollowUp.pm,v 1.13 2002-07-13 03:28:04 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::FollowUp;

use strict;
use Kernel::System::PostMaster::AutoResponse;
use Kernel::System::User;

use vars qw($VERSION);
$VERSION = '$Revision: 1.13 $';
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
        if ($GetParam{"$Values[0]$CounterTmp"} && $GetParam{"$Values[1]$CounterTmp"}) {
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
        MSG => "FollowUp Article to Ticket [$Tn] created (TicketID=$TicketID, " .
			"ArticleID=$ArticleID). $Comment"
    );

    # --
    # send auto response?
    # --
    my $AutoResponse = Kernel::System::PostMaster::AutoResponse->new(
        DBObject => $DBObject,
    );
    my %Data = $AutoResponse->GetResponseData(
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
            return;
        }
        # write log
        if (!$Self->{LoopProtectionObject}->SendEmail(To => $GetParam{From})) {
            return;
        }

        # --
        # prepare subject (insert old subject)
        # --
        my $Subject = $Data{Subject} || 'No Std. Subject found!';
        my $OldSubject = $GetParam{Subject} || 'Your email!';
        my $TicketHook = $Self->{ConfigObject}->Get('TicketHook');
        $OldSubject =~ s/\n//g;
        if ($Subject =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
            my $SubjectChar = $1;
            $OldSubject =~ s/\[$TicketHook: $Tn\] //g;
            $OldSubject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
            $Subject =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$OldSubject/g;
        }
        $Subject = "[$TicketHook: $Tn] $Subject";

        # --
        # prepare body (insert old email)
        # --
        my $Body = $Data{Text} || 'No Std. Body found!'; 
        my $OldBody = $GetParam{Body} || 'Your Message!';
        if ($Body =~ /<OTRS_CUSTOMER_EMAIL\[(.+?)\]>/g) {
            my $Line = $1;
            my @Body = split(/\n/, $OldBody);
            my $NewOldBody = '';
            foreach (my $i = 0; $i < $Line; $i++) {
              $NewOldBody .= "> $Body[$i]\n";
            }
            $Body =~ s/<OTRS_CUSTOMER_EMAIL\[.+?\]>/$NewOldBody/g;
        }

        # --
        # send email
        # --
        $EmailObject->Send(
            DBObject => $DBObject,
            ArticleObject => $ArticleObject,
            ArticleType => 'email-external',
            ArticleSenderType => 'system',
            TicketID => $TicketID,
            TicketObject => $TicketObject,
            HistoryType => 'SendAutoFollowUp',

            From => "$Data{Realname} <$Data{Address}>",
            Email => $Data{Address},
            To => $GetParam{From},
            RealName => $Data{Realname},
            Charset => $Data{Charset},
            Subject => $Subject, 
            UserID => $InmailUserID,
            Body => $Body,
            InReplyTo => $GetParam{'Message-ID'},
            Loop => 1,
        );

        # do log
        $LogObject->Log(MSG => "Sent auto follow up for Ticket [$Tn] (TicketID=$TicketID, " .
            "ArticleID=$ArticleID) to '$GetParam{From}' "
        );

    }
    else {
        # do log
        $LogObject->Log(MSG => "Sent no auto follow up for Ticket [$Tn] " .
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
            MSG => "OwnerID of ticket $Tn is $OwnerID.",
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
            MSG => "UserSendFollowUpNotification is '$Preferences{UserSendFollowUpNotification}'.",
         );
       }
       # check UserSendFollowUpNotification
       if ($Preferences{UserSendFollowUpNotification}) {
         # --
         # prepare subject (insert old subject)
         # --
         my $Subject = $Self->{ConfigObject}->Get('NotificationSubjectFollowUp') 
              || 'No subject found in Config.pm!';
         my $TicketHook = $Self->{ConfigObject}->Get('TicketHook') || '';
         my $OldSubject = $GetParam{Subject} || 'Your email!';
         $OldSubject =~ s/(\[$TicketHook: $Tn\]|\n)//g;
         if ($Subject =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
            my $SubjectChar = $1;
            $OldSubject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
            $Subject =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$OldSubject/g;
         }
         $Subject = "[". $Self->{ConfigObject}->Get('TicketHook') .": $Tn] $Subject";

         # --
         # prepare body (insert old email)
         # --
         my $Body = $Self->{ConfigObject}->Get('NotificationBodyFollowUp') 
          || 'No body found in Config.pm!';
         $Body =~ s/<OTRS_TICKET_ID>/$TicketID/g;
         $Body =~ s/<OTRS_USER_FIRSTNAME>/$Preferences{UserFirstname}/g; 
         my $OldBody = $GetParam{Body} || 'Your Message!';
         if ($Body =~ /<OTRS_CUSTOMER_EMAIL\[(.+?)\]>/g) {
            my $Line = $1;
            my @Body = split(/\n/, $OldBody);
            my $NewOldBody = '';
            foreach (my $i = 0; $i < $Line; $i++) {
              $NewOldBody .= "> $Body[$i]\n";
            }
            $Body =~ s/<OTRS_CUSTOMER_EMAIL\[.+?\]>/$NewOldBody/g;
         }

         # --
         # send notification
         # --
         $EmailObject->Send(
            DBObject => $DBObject,
            ArticleObject => $ArticleObject,
            ArticleType => 'email-internal',
            ArticleSenderType => 'system',
            TicketID => $TicketID,
            TicketObject => $TicketObject,
            HistoryType => 'SendAgentNotification',

            From => $Self->{ConfigObject}->Get('NotificationSenderName').
              ' <'.$Self->{ConfigObject}->Get('NotificationSenderEmail').'>', 
            Email => $Self->{ConfigObject}->Get('NotificationSenderEmail'),
            To => $Preferences{UserLogin},
            Subject => $Subject, 
            UserID => $Self->{ConfigObject}->Get('PostmasterUserID'),
            Body => $Body, 
            Loop => 1,
         );
       }
    }

    # --
    # debug
    # --
    if ($Self->{Debug} > 0) {
       $LogObject->Log(
            MSG => "Debug($Self->{Debug}): AutoResponseType=$AutoResponseType, " .
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
