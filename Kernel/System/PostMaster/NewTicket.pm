# --
# NewTicket.pm - sub module of Postmaster.pm
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NewTicket.pm,v 1.5 2002-05-14 01:37:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::NewTicket;

use strict;
use Kernel::System::PostMaster::AutoResponse;
use Kernel::System::PostMaster::DestQueue;
use Kernel::System::EmailSend;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
    $Self->{Debug} = 1;
    
    # get all objects
    foreach (
      'DBObject', 
      'ConfigObject', 
      'ArticleObject', 
      'TicketObject', 
      'LogObject', 
      'LoopProtectionObject',
    ) {
        $Self->{$_} = $Param{$_} || die 'Got no $_';
    }

    my $ParseObject = $Param{ParseObject} || die 'Got no ParseObject!';   
 
    # get dest queue object
    $Self->{DestQueueObject} = Kernel::System::PostMaster::DestQueue->new(
	    DBObject => $Self->{DBObject},
	    ParseObject => $ParseObject,
        ConfigObject => $Self->{ConfigObject}, 
	);

    
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
        if ($GetParam{"$Values[0]$CounterTmp"} && $GetParam{"$Values[1]$CounterTmp"}) {
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
    my $ArticleID = $ArticleObject->CreateArticleDB(
        TicketID => $TicketID,
        ArticleType => 'email-external',
        SenderType => 'customer',
        From => $GetParam{From},
        ReplyTo => $GetParam{ReplyTo},
        To => $GetParam{To},
        Cc => $GetParam{Cc},
        Subject => $GetParam{Subject},
        MessageID => $GetParam{'Message-ID'},
        Body => $GetParam{Body},
        CreateUserID => $InmailUserID,
    );
    
    # set free article text
    @Values = ('X-OTRS-ArticleKey', 'X-OTRS-ArticleValue');
    $CounterTmp = 0;
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
    
    # write it to the fs
    $ArticleObject->WriteArticle(ArticleID => $ArticleID, Email => $Email);
    
    # add history entry
    $TicketObject->AddHistoryRow(
        TicketID => $TicketID,
        HistoryType => 'NewTicket',
        ArticleID => $ArticleID,
        Name => "New Ticket [$NewTn] created. $Comment",
        CreateUserID => $InmailUserID,
    );
    
    # do log
    $LogObject->Log(
        Message => "New Ticket [$NewTn] created (TicketID=$TicketID, " .
        "ArticleID=$ArticleID). $Comment"
    );
    
    # send auto response
    my $AutoResponse = Kernel::System::PostMaster::AutoResponse->new(
        DBObject => $DBObject,
    );
    my %Data = $AutoResponse->GetResponseData(
        OueueID => $QueueID,
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
        $OldSubject =~ s/\n//g;
        if ($Subject =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
            my $SubjectChar = $1;
            $OldSubject =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
            $Subject =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$OldSubject/g;
        }
        $Subject = "[". $Self->{ConfigObject}->Get('TicketHook') .": $NewTn] $Subject";

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
        my $EmailObject = Kernel::System::EmailSend->new(
            ConfigObject => $Self->{ConfigObject},
            DBObject => $Self->{DBObject},
            LogObject => $Self->{LogObject},
        );
        my $ArticleID = $EmailObject->Send(
            DBObject => $DBObject,
            ArticleObject => $ArticleObject,
            ArticleType => 'email-external',
            ArticleSenderType => 'system',
            TicketID => $TicketID,
            TicketObject => $TicketObject,
            HistoryType => 'SendAutoReply',

            From => "$Data{Realname} <$Data{Address}>",
            Email => $Data{Address},
            To => $GetParam{From},
            RealName => $Data{Realname},
            Subject => $Subject,
            UserID => $InmailUserID,
            Body => $Body,
            InReplyTo => $GetParam{'Message-ID'},
            Loop => 1,
         );


        # do log
        $LogObject->Log(
            Message => "Sent auto reply for Ticket [$NewTn] (TicketID=$TicketID, " .
            "ArticleID=$ArticleID) to '$GetParam{From}' " 
        );
    }
    else {
        # do log
        $LogObject->Log(MSG => "Sent no auto reply for Ticket [$NewTn] ($GetParam{From}) "
        );
    }

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
