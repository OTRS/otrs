# --
# NewTicket.pm - sub module of Postmaster.pm
# Copyright (C) 2001 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NewTicket.pm,v 1.1 2001-12-21 17:54:40 martin Exp $
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
$VERSION = '$Revision: 1.1 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
    
    my $Self = {}; # allocate new hash for object
    bless ($Self, $Type);
    
    $Self->{Debug} = 1;
    
    # get db object
    $Self->{DBObject} = $Param{DBObject} || die 'Got no DBObject!';

    # get config object
    $Self->{ConfigObject} = $Param{ConfigObject} || die 'Got no ConfigObject!';
    
    # get article and ticket object
    $Self->{ArticleObject} = $Param{ArticleObject} || die 'Got no ArticleObject!'; 

    $Self->{TicketObject} = $Param{TicketObject} || die 'Got no TicketObject!';
    
    # get log object
    $Self->{LogObject} = $Param{LogObject} || die 'Got no LogObject!';

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
        # FIXME !!!
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
        ArticleType => 'email',
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
    $LogObject->Log(MSG => "New Ticket [$NewTn] created (TicketID=$TicketID, " .
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
        # do article db insert
        my $ArticleID = $ArticleObject->CreateArticleDB(
            TicketID => $TicketID,
            ArticleType => 'email',
            SenderType => 'system',
            From => "$Data{Realname} <$Data{Address}>",
            To => $GetParam{From},
            Subject => "[Ticket#$NewTn] $Data{Subject}",
            MessageID => time() .".". rand(999999),
            Body => $Data{Text},
            CreateUserID => $InmailUserID,
        );
        my $Email = Kernel::System::Email->new();
        $Email->SendMail(
            DBObject => $DBObject,
            From => "$Data{Realname} <$Data{Address}>",
            Email => $Data{Address},
            To => $GetParam{From},
            RealName => $Data{Realname},
            Subject => "[Ticket#$NewTn] $Data{Subject}",
            UserID => $InmailUserID,
            TicketID => $TicketID,
            TicketObject => $TicketObject,
            ArticleID => $ArticleID,
            Body => $Data{Text},
            InReplyTo => $GetParam{'Message-ID'},
            Loop => 1,
			HistoryType => 'SendAutoReply',
        );
        # do log
        $LogObject->Log(MSG => "Sent auto reply for Ticket [$NewTn] (TicketID=$TicketID, " .
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
