# --
# Kernel/System/PostMaster/NewTicket.pm - sub part of PostMaster.pm
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: NewTicket.pm,v 1.38 2003-04-14 19:49:28 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::NewTicket;

use strict;
use Kernel::System::AutoResponse;
use Kernel::System::Queue;
use Kernel::System::CustomerUser;

use vars qw($VERSION);
$VERSION = '$Revision: 1.38 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;
   
    # allocate new hash for object 
    my $Self = {}; 
    bless ($Self, $Type);
    
    $Self->{Debug} = $Param{Debug} || 0;
    
    # get all objects
    foreach (qw(DBObject ConfigObject TicketObject LogObject ParseObject DestQueueObject)) {
        $Self->{$_} = $Param{$_} || die 'Got no $_';
    }

    $Self->{QueueObject} = Kernel::System::Queue->new(%Param);

    $Self->{CustomerUserObject} = Kernel::System::CustomerUser->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    my $InmailUserID = $Param{InmailUserID};
    my %GetParam = %{$Param{GetParam}};
     
    my $Comment = $Param{Comment} || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';
    # -- 
    # get queue id and name
    # --
    my $QueueID = $Param{QueueID} || $Self->{DestQueueObject}->GetQueueID(Params => \%GetParam);
    my $Queue = $Self->{QueueObject}->QueueLookup(QueueID => $QueueID);    
    # --
    # get state
    # --
    my $State = $Self->{ConfigObject}->Get('PostmasterDefaultState') || 'new';
    if ($GetParam{'X-OTRS-State'}) {
        $State = $GetParam{'X-OTRS-State'};
    }
    # --
    # get priority
    # --
    my $Priority = $Self->{ConfigObject}->Get('PostmasterDefaultPriority') || '3 normal';
    if ($GetParam{'X-OTRS-Priority'}) {
        $Priority = $GetParam{'X-OTRS-Priority'}; 
    }
    # -- 
    # create new ticket
    # --
    my $NewTn = $Self->{TicketObject}->CreateTicketNr();
    # -- 
    # do db insert
    # --
    my $TicketID = $Self->{TicketObject}->CreateTicketDB(
        TN => $NewTn,
        QueueID => $QueueID,
        Lock => 'unlock',
        GroupID => 1,
        Priority => $Priority,
        State => $State,
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
        print "Priority: $Priority\n";
        print "State: $State\n";
    }
    # -- 
    # do article db insert
    # --
    my $ArticleID = $Self->{TicketObject}->CreateArticle(
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
        HistoryComment => "New Ticket [$NewTn] created (Q=$Queue;P=$Priority;S=$State). $Comment",
        OrigHeader => \%GetParam,
        AutoResponseType => $AutoResponseType,
        Queue => $Queue,
    );
    # --    
    # get customer user and no if not given
    # --
    if (!$GetParam{'X-OTRS-CustomerUser'}) {
        my @EmailAddresses = $Self->{ParseObject}->SplitAddressLine(
            Line => $GetParam{From},
        );
        foreach (@EmailAddresses) {
            $GetParam{'X-OTRS-CustomerUser'} = $Self->{ParseObject}->GetEmailAddress(
                Email => $_,
            );
        }
    }
    # --    
    # get customer id (sender email) if there is no customer id given
    # --
    if (!$GetParam{'X-OTRS-CustomerNo'}) {
        # --
        # get customer user data
        # --
        my %CustomerData = ();
        if ($GetParam{'X-OTRS-CustomerUser'}) {
            %CustomerData = $Self->{CustomerUserObject}->CustomerUserDataGet(
                User => $GetParam{'X-OTRS-CustomerUser'}, 
            );
        }
        # --
        # take CustomerID from customer backend lookup or from from field
        # --
        if ($CustomerData{UserCustomerID}) {
            $GetParam{'X-OTRS-CustomerNo'} = $CustomerData{UserCustomerID};
        }
        else {
            my @EmailAddresses = $Self->{ParseObject}->SplitAddressLine(
                Line => $GetParam{From},
            );
            foreach (@EmailAddresses) {
                $GetParam{'X-OTRS-CustomerNo'} = $Self->{ParseObject}->GetEmailAddress(
                    Email => $_,
        	);
            }
        }
    }
    # --    
    # set customer no
    # --
    if ($GetParam{'X-OTRS-CustomerNo'} || $GetParam{'X-OTRS-CustomerUser'}) {
        $Self->{TicketObject}->SetCustomerData(
            TicketID => $TicketID,
            No => $GetParam{'X-OTRS-CustomerNo'},
            User => $GetParam{'X-OTRS-CustomerUser'},
            UserID => $InmailUserID,
        );
    # --
    # debug
    # --
    if ($Self->{Debug} > 0) {
            print "CustomerID: $GetParam{'X-OTRS-CustomerNo'}\n";
            print "CustomerUser: $GetParam{'X-OTRS-CustomerUser'}\n";
        }
    }
    # --
    # set free ticket text
    # --
    my @Values = ('X-OTRS-TicketKey', 'X-OTRS-TicketValue');
    my $CounterTmp = 0;
    while ($CounterTmp <= 2) {
        $CounterTmp++;
        if ($GetParam{"$Values[0]$CounterTmp"}) {
            $Self->{TicketObject}->SetTicketFreeText(
                TicketID => $TicketID,
                Key => $GetParam{"$Values[0]$CounterTmp"},
                Value => $GetParam{"$Values[1]$CounterTmp"},
                Counter => $CounterTmp,
                UserID => $InmailUserID,
            );
        }
    }
    # --
    # close ticket if article create failed!
    # --
    if (!$ArticleID) {
        $Self->{TicketObject}->SetState(
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
            $Self->{TicketObject}->SetArticleFreeText(
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
    # write plain email to the storage
    # --
    $Self->{TicketObject}->WriteArticlePlain(
        ArticleID => $ArticleID, 
        Email => $Self->{ParseObject}->GetPlainEmail(),
        UserID => $InmailUserID,
    );
    # --    
    # write attachments to the storage
    # --
    foreach my $Attachment ($Self->{ParseObject}->GetAttachments()) {
        $Self->{TicketObject}->WriteArticlePart(
            Content => $Attachment->{Content}, 
            Filename => $Attachment->{Filename},
            ContentType => $Attachment->{ContentType},
            ArticleID => $ArticleID,
            UserID => $InmailUserID,
        );
    }
    # do log
    $Self->{LogObject}->Log(
	Priority => 'notice',
        Message => "New Ticket [$NewTn] created (TicketID=$TicketID, " .
        "ArticleID=$ArticleID). $Comment"
    );
    
    return 1;
}
# --

1;
