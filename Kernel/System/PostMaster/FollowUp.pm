# --
# Kernel/System/PostMaster/FollowUp.pm - the sub part of PostMaster.pm 
# Copyright (C) 2001-2003 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: FollowUp.pm,v 1.26 2003-04-14 19:48:48 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see 
# the enclosed file COPYING for license information (GPL). If you 
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

package Kernel::System::PostMaster::FollowUp;

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.26 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

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
    foreach (qw(DBObject ConfigObject TicketObject LogObject)) {
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
    my $State = $Param{State} || '';
	my $Comment = $Param{Comment} || '';
    my $Lock = $Param{Lock} || '';
    my $AutoResponseType = $Param{AutoResponseType} || '';

    my $OldState = $Self->{TicketObject}->GetState(TicketID => $TicketID) || '';

    # do db insert
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
        HistoryType => 'FollowUp',
        HistoryComment => "FollowUp for [$Tn]. $Comment",

        AutoResponseType => $AutoResponseType,
        OrigHeader => \%GetParam,
    ); 
    # --
    # debug
    # --
    if ($Self->{Debug} > 0) {
        print "Follow up Ticket\n";
        print "TicketNumber: $Tn\n";
        print "From: $GetParam{From}\n";
        print "ReplyTo: $GetParam{ReplyTo}\n" if ($GetParam{ReplyTo});
        print "To: $GetParam{To}\n";
        print "Cc: $GetParam{Cc}\n" if ($GetParam{Cc});
        print "Subject: $GetParam{Subject}\n";
        print "MessageID: $GetParam{'Message-ID'}\n";
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
    # --
    # set free article text
    # --
    my @Values = ('X-OTRS-ArticleKey', 'X-OTRS-ArticleValue');
    my $CounterTmp = 0;
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
    # set state 
    # --
    if ($State && ($OldState ne $State)) {
	    $Self->{TicketObject}->SetState(
    	    State => $State,
        	TicketID => $TicketID,
	        UserID => $InmailUserID,
    	);
        if ($Self->{Debug} > 0) {
            print "State: $State\n";
        }
    }
    # --
    # set lock
    # --
    if ($Lock && !$Self->{TicketObject}->IsTicketLocked(TicketID => $TicketID) && $OldState =~ /^close/i) {
       $Self->{TicketObject}->SetLock( 
           TicketID => $TicketID,
           Lock => 'lock',
           UserID => => $InmailUserID,
       );
        if ($Self->{Debug} > 0) {
            print "Lock: lock\n";
        }
    }
    # --
    # set unanswered
    # --
    $Self->{TicketObject}->SetAnswered(
        TicketID => $TicketID,
        UserID => $InmailUserID,
        Answered => 0,
    );

    # write log
    $Self->{LogObject}->Log(
        Priority => 'notice',
        Message => "FollowUp Article to Ticket [$Tn] created (TicketID=$TicketID, " .
			"ArticleID=$ArticleID). $Comment"
    );

    return 1;
}
# --

1;
