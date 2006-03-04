# --
# Kernel/System/PostMaster/FollowUp.pm - the sub part of PostMaster.pm
# Copyright (C) 2001-2006 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FollowUp.pm,v 1.42 2006-03-04 11:13:37 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::FollowUp;

use strict;
use Kernel::System::User;

use vars qw($VERSION);
$VERSION = '$Revision: 1.42 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# --
sub new {
    my $Type = shift;
    my %Param = @_;

    # allocate new hash for object
    my $Self = {};
    bless ($Self, $Type);

    foreach (keys %Param) {
        $Self->{$_} = $Param{$_};
    }

    $Self->{Debug} = $Param{Debug} || 0;

    # check needed Objects
    foreach (qw(DBObject ConfigObject TicketObject LogObject ParseObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    $Self->{UserObject} = Kernel::System::User->new(%Param);

    return $Self;
}
# --
sub Run {
    my $Self = shift;
    my %Param = @_;
    # --
    # check needed stuff
    # --
    foreach (qw(TicketID InmailUserID GetParam Tn AutoResponseType)) {
      if (!$Param{$_}) {
        $Self->{LogObject}->Log(Priority => 'error', Message => "Need $_!");
        return;
      }
    }
    my %GetParam = %{$Param{GetParam}};
    # get ticket data
    my %Ticket = $Self->{TicketObject}->TicketGet(TicketID => $Param{TicketID});

    my $Comment = $Param{Comment} || '';
    my $Lock = $Param{Lock} || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';

    # Check if owner of ticket is still valid
    my %UserInfo = $Self->{UserObject}->GetUserData(
        UserID => $Ticket{UserID},
    );
    # check data
    if ($UserInfo{ValidID} eq 1) {
        # set lock (if ticket should be locked on follow up)
        if ($Lock && $Ticket{StateType} =~ /^close/i) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Param{TicketID},
                Lock => 'lock',
                UserID => => $Param{InmailUserID},
            );
            if ($Self->{Debug} > 0) {
                print "Lock: lock\n";
                $Self->{LogObject}->Log(
                    Priority => 'notice',
                    Message => "Ticket [$Param{Tn}] still locked",
                );
            }
        }
    }
    else {
        # Unlock ticket, because current user is set to invalid
        $Self->{TicketObject}->LockSet(
            TicketID => $Param{TicketID},
            Lock => 'unlock',
            UserID => => $Param{InmailUserID},
        );
        $Self->{LogObject}->Log(
            Priority => 'notice',
            Message => "Ticket [$Param{Tn}] unlocked, current owner is invalid!",
        );
    }
    # set state
    my $State = $Self->{ConfigObject}->Get('PostmasterFollowUpState') || 'open';
    if ($GetParam{'X-OTRS-FollowUp-State'}) {
        $State = $GetParam{'X-OTRS-FollowUp-State'};
    }

    if ($Ticket{StateType} !~ /^new/ || $GetParam{'X-OTRS-FollowUp-State'}) {
	    $Self->{TicketObject}->StateSet(
    	    State => $GetParam{'X-OTRS-FollowUp-State'} || $State,
        	TicketID => $Param{TicketID},
	        UserID => $Param{InmailUserID},
    	);
        if ($Self->{Debug} > 0) {
            print "State: $State\n";
        }
    }
    # set priority
    if ($GetParam{'X-OTRS-FollowUp-Priority'}) {
        $Self->{TicketObject}->PrioritySet(
            TicketID => $Param{TicketID},
            Priority => $GetParam{'X-OTRS-FollowUp-Priority'},
            UserID => $Param{InmailUserID},
        );
        if ($Self->{Debug} > 0) {
            print "PriorityUpdate: $GetParam{'X-OTRS-FollowUp-Priority'}\n";
        }
    }
    # set queue
    if ($GetParam{'X-OTRS-FollowUp-Queue'}) {
        $Self->{TicketObject}->MoveTicket(
            Queue => $GetParam{'X-OTRS-FollowUp-Queue'},
            TicketID => $Param{TicketID},
            UserID => $Param{InmailUserID},
        );
        if ($Self->{Debug} > 0) {
            print "QueueUpdate: $GetParam{'X-OTRS-FollowUp-Queue'}\n";
        }
    }
    # set free ticket text
    my @Values = ('X-OTRS-FollowUp-TicketKey', 'X-OTRS-FollowUp-TicketValue');
    my $CounterTmp = 0;
    while ($CounterTmp <= 8) {
        $CounterTmp++;
        if ($GetParam{"$Values[0]$CounterTmp"}) {
            $Self->{TicketObject}->TicketFreeTextSet(
                TicketID => $Param{TicketID},
                Key => $GetParam{"$Values[0]$CounterTmp"},
                Value => $GetParam{"$Values[1]$CounterTmp"},
                Counter => $CounterTmp,
                UserID => $Param{InmailUserID},
            );
            if ($Self->{Debug} > 0) {
                print "TicketKey$CounterTmp: ".$GetParam{"$Values[0]$CounterTmp"}."\n";
                print "TicketValue$CounterTmp: ".$GetParam{"$Values[1]$CounterTmp"}."\n";
            }
        }
    }
    # do db insert
    my $ArticleID = $Self->{TicketObject}->ArticleCreate(
        TicketID => $Param{TicketID},
        ArticleType => $GetParam{'X-OTRS-FollowUp-ArticleType'},
        SenderType => $GetParam{'X-OTRS-FollowUp-SenderType'},
        From => $GetParam{From},
        ReplyTo => $GetParam{ReplyTo},
        To => $GetParam{To},
        Cc => $GetParam{Cc},
        Subject => $GetParam{Subject},
        MessageID => $GetParam{'Message-ID'},
        ContentType => $GetParam{'Content-Type'},
        Body => $GetParam{Body},
        UserID => $Param{InmailUserID},
        HistoryType => 'FollowUp',
        HistoryComment => "\%\%$Param{Tn}\%\%$Comment",

        AutoResponseType => $AutoResponseType,
        OrigHeader => \%GetParam,
    );
    if (!$ArticleID) {
        return;
    }
    # debug
    if ($Self->{Debug} > 0) {
        print "Follow up Ticket\n";
        print "TicketNumber: $Param{Tn}\n";
        print "From: $GetParam{From}\n" if ($GetParam{From});
        print "ReplyTo: $GetParam{ReplyTo}\n" if ($GetParam{ReplyTo});
        print "To: $GetParam{To}\n" if ($GetParam{To});
        print "Cc: $GetParam{Cc}\n" if ($GetParam{Cc});
        print "Subject: $GetParam{Subject}\n";
        print "MessageID: $GetParam{'Message-ID'}\n";
        print "ArticleType: $GetParam{'X-OTRS-FollowUp-ArticleType'}\n";
        print "SenderType: $GetParam{'X-OTRS-FollowUp-SenderType'}\n";
    }
    # write plain email to the storage
    $Self->{TicketObject}->ArticleWritePlain(
        ArticleID => $ArticleID,
        Email => $Self->{ParseObject}->GetPlainEmail(),
        UserID => $Param{InmailUserID},
    );
    # write attachments to the storage
    foreach my $Attachment ($Self->{ParseObject}->GetAttachments()) {
        $Self->{TicketObject}->ArticleWriteAttachment(
            Content => $Attachment->{Content},
            Filename => $Attachment->{Filename},
            ContentType => $Attachment->{ContentType},
            ArticleID => $ArticleID,
            UserID => $Param{InmailUserID},
        );
    }
    # set free article text
    @Values = ('X-OTRS-FollowUp-ArticleKey', 'X-OTRS-ArticleValue');
    $CounterTmp = 0;
    while ($CounterTmp <= 3) {
        $CounterTmp++;
        if ($GetParam{"$Values[0]$CounterTmp"}) {
            $Self->{TicketObject}->ArticleFreeTextSet(
                ArticleID => $ArticleID,
                Key => $GetParam{"$Values[0]$CounterTmp"},
                Value => $GetParam{"$Values[1]$CounterTmp"},
                Counter => $CounterTmp,
                UserID => $Param{InmailUserID},
            );
            if ($Self->{Debug} > 0) {
                print "ArticleKey$CounterTmp: ".$GetParam{"$Values[0]$CounterTmp"}."\n";
                print "ArticleValue$CounterTmp: ".$GetParam{"$Values[1]$CounterTmp"}."\n";
            }

        }
    }

    # write log
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message => "FollowUp Article to Ticket [$Param{Tn}] created ".
          "(TicketID=$Param{TicketID}, ArticleID=$ArticleID). $Comment,"
    );

    return 1;
}
# --
1;
