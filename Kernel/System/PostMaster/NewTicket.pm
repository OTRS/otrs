# --
# Kernel/System/PostMaster/NewTicket.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NewTicket.pm,v 1.24 2002-10-15 09:24:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::NewTicket;

use strict;
use Kernel::System::AutoResponse;
use Kernel::System::PostMaster::DestQueue;
use Kernel::System::EmailSend;
use Kernel::System::Queue;

use vars qw($VERSION);
$VERSION = '$Revision: 1.24 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
    $Self->{Debug} = $Param{Debug} || 0;
    
    # get all objects
    foreach (
      'DBObject', 
      'ConfigObject', 
      'TicketObject', 
      'LogObject', 
      'ParseObject',
    ) {
        $Self->{$_} = $Param{$_} || die 'Got no $_';
    }

    # get dest queue object
    $Self->{DestQueueObject} = Kernel::System::PostMaster::DestQueue->new(%Param);

    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);

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
    # --
    # debug
    # --
    if ($Self->{Debug} > 0) {
        print "New Ticket created!\n";
        print "TicketNumber: $NewTn\n";
        print "TicketID: $TicketID\n";
    }
    # --    
    # set customer no
    # --
    if ($GetParam{'X-OTRS-CustomerNo'}) {
        $TicketObject->SetCustomerNo(
            TicketID => $TicketID,
            No => $GetParam{'X-OTRS-CustomerNo'},
            UserID => $InmailUserID,
        );
    }
    # --
    # set free ticket text
    # --
    my @Values = ('X-OTRS-TicketKey', 'X-OTRS-TicketValue');
    my $CounterTmp = 0;
    while ($CounterTmp <= 2) {
        $CounterTmp++;
        if ($GetParam{"$Values[0]$CounterTmp"}) {
            $TicketObject->SetTicketFreeText(
                TicketID => $TicketID,
                Key => $GetParam{"$Values[0]$CounterTmp"},
                Value => $GetParam{"$Values[1]$CounterTmp"},
                Counter => $CounterTmp,
                UserID => $InmailUserID,
            );
        }
    }
    
    # do article db insert
    my $ArticleID = $TicketObject->CreateArticle(
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
        OrigHeader => \%GetParam,
        AutoResponseType => $AutoResponseType,
        Queue => $Queue,
    );
    # --
    # close ticket if article create failed!
    # --
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
    # --
    # debug
    # --
    if ($Self->{Debug} > 0) {
        print "From: $GetParam{From}\n";
        print "ReplyTo: $GetParam{ReplyTo}\n" if ($GetParam{ReplyTo});
        print "To: $GetParam{To}\n";
        print "Cc: $GetParam{Cc}\n" if ($GetParam{Cc});
        print "Subject: $GetParam{Subject}\n";
        print "MessageID: $GetParam{'Message-ID'}\n";
        print "Queue: $Queue\n";
    }
    # --
    # set free article text
    # --
    @Values = ('X-OTRS-ArticleKey', 'X-OTRS-ArticleValue');
    $CounterTmp = 0;
    while ($CounterTmp <= 3) {
        $CounterTmp++;
        if ($GetParam{"$Values[0]$CounterTmp"}) {
            $TicketObject->SetArticleFreeText(
                ArticleID => $ArticleID,
                Key => $GetParam{"$Values[0]$CounterTmp"},
                Value => $GetParam{"$Values[1]$CounterTmp"},
                Counter => $CounterTmp,
                UserID => $InmailUserID,
            );
            if ($Self->{Debug} > 0) {
                print "ArticleKey$CounterTmp: ".$GetParam{"$Values[0]$CounterTmp"}."\n";
                print "ArticleValue$CounterTmp: ".$GetParam{"$Values[1]$CounterTmp"}."\n";
            }
        }
    }
    # --    
    # write it to the fs
    # --
    $TicketObject->WriteArticle(ArticleID => $ArticleID, Email => $Email);
    
    # do log
    $LogObject->Log(
        Message => "New Ticket [$NewTn] created (TicketID=$TicketID, " .
        "ArticleID=$ArticleID). $Comment"
    );
    
    return 1;
}
# --

1;
