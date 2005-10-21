# --
# Kernel/System/PostMaster/FollowUp.pm - the sub part of PostMaster.pm
# Copyright (C) 2001-2005 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FollowUp.pm,v 1.39 2005-10-21 15:46:21 cs Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::FollowUp;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.39 $';
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
    my $UserTable = $Self->{ConfigObject}->Get('DatabaseUserTable') || 'system_user';
    my $Owner = $Self->{ConfigObject}->Get('DatabaseUserTableUserID') || '';
    my $ValidID = 1;
    my $SQL = "SELECT id,valid_id FROM ".$UserTable." WHERE id = ".$Ticket{UserID}.";";
    $Self->{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
        $Owner = $Row[0];
        $ValidID = $Row[1];
    }
    # check data
    if (($Owner == $Ticket{UserID}) && $ValidID == 1) {
        # set lock (if ticket should be locked on follow up)
        if ($Lock && $Ticket{StateType} =~ /^close/i) {
            $Self->{TicketObject}->LockSet(
                TicketID => $Param{TicketID},
                Lock => 'lock',
                UserID => => $Param{InmailUserID},
            );
            if ($Self->{Debug} > 0) {
                print "Lock: lock\n";
            }
            $Self->{LogObject}->Log(
                Priority => 'notice',
                Message => "Ticket [$Param{Tn}] still locked",
            );
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
            Message => "Ticket [$Param{Tn}] unlocked, current owner ist invalid!",
        );
    }
    # set state
    my $State = $Self->{ConfigObject}->Get('PostmasterFollowUpState') || 'open';
    if ($GetParam{'X-OTRS-State'}) {
        $State = $GetParam{'X-OTRS-State'};
    }

    if ($Ticket{StateType} !~ /^new/ || $GetParam{'X-OTRS-State'}) {
	    $Self->{TicketObject}->StateSet(
    	    State => $State,
        	TicketID => $Param{TicketID},
	        UserID => $Param{InmailUserID},
    	);
        if ($Self->{Debug} > 0) {
            print "State: $State\n";
        }
    }
    # set priority
    if ($GetParam{'X-OTRS-Priority'}) {
        $Self->{TicketObject}->PrioritySet(
            TicketID => $Param{TicketID},
            Priority => $GetParam{'X-OTRS-Priority'},
            UserID => $Param{InmailUserID},
        );
        if ($Self->{Debug} > 0) {
            print "PriorityUpdate: $GetParam{'X-OTRS-Priority'}\n";
        }
    }
    # set queue
    if ($GetParam{'X-OTRS-Queue'}) {
        $Self->{TicketObject}->MoveTicket(
            Queue => $GetParam{'X-OTRS-Queue'},
            TicketID => $Param{TicketID},
            UserID => $Param{InmailUserID},
        );
        if ($Self->{Debug} > 0) {
            print "QueueUpdate: $GetParam{'X-OTRS-Queue'}\n";
        }
    }
    # set free ticket text
    my @Values = ('X-OTRS-TicketKey', 'X-OTRS-TicketValue');
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
        ArticleType => $GetParam{'X-OTRS-ArticleType'},
        SenderType => $GetParam{'X-OTRS-SenderType'},
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
    # debug
    if ($Self->{Debug} > 0) {
        print "Follow up Ticket\n";
        print "TicketNumber: $Param{Tn}\n";
        print "From: $GetParam{From}\n";
        print "ReplyTo: $GetParam{ReplyTo}\n" if ($GetParam{ReplyTo});
        print "To: $GetParam{To}\n";
        print "Cc: $GetParam{Cc}\n" if ($GetParam{Cc});
        print "Subject: $GetParam{Subject}\n";
        print "MessageID: $GetParam{'Message-ID'}\n";
        print "SenderType: $GetParam{'X-OTRS-SenderType'}\n";
        print "ArticleType: $GetParam{'X-OTRS-ArticleType'}\n";
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
    @Values = ('X-OTRS-ArticleKey', 'X-OTRS-ArticleValue');
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
