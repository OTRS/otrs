#!/usr/bin/perl -w
# --
# UnlockTickets.pl - to unlock tickets
# Copyright (C) 2002 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: UnlockTickets.pl,v 1.5 2002-08-13 15:20:35 martin Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

# use ../ as lib location
use FindBin qw($Bin);
use lib "$Bin/../";

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.5 $';
$VERSION =~ s/^.*:\s(\d+\.\d+)\s.*$/$1/;

use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Ticket;
use Kernel::System::Article;
use Kernel::System::User;
use Kernel::System::EmailSend;

# --
# common objects
# --
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OpenTRS-UnlockTickets',
    %CommonObject,
);
$CommonObject{DBObject} = Kernel::System::DB->new(
    %CommonObject,
);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(
    %CommonObject,
);
$CommonObject{ArticleObject} = Kernel::System::Article->new(
    %CommonObject,
);
$CommonObject{UserObject} = Kernel::System::User->new(
    %CommonObject,
);  

my @ViewableLocks = @{$CommonObject{ConfigObject}->Get('ViewableLocks')};
my @ViewableStats = @{$CommonObject{ConfigObject}->Get('ViewableStats')};

# --
# check args
# --
my $Command = shift || '--help';
print "UnlockTickets.pl <Revision $VERSION> - unlock tickets\n";
print "Copyright (c) 2002 Martin Edenhofer <martin\@otrs.org>\n";
# --
# unlock all tickets
# --
if ($Command eq '--all') {
    print " Unlock all tickets:\n";
    my @Tickets = ();
    my $SQL = "SELECT st.tn, slt.name, st.ticket_answered, st.id, st.user_id FROM " .
    " ticket as st, queue as sq, ticket_state tsd, ticket_lock_type slt " .
    " WHERE " .
    " st.ticket_state_id = tsd.id " .
    " AND " .
    " st.queue_id = sq.id " .
    " AND " .
    " st.ticket_lock_id = slt.id " .
    " AND " .
    " st.ticket_answered != 1 ".
    " AND " .
    " tsd.name IN ( ${\(join ', ', @ViewableStats)} ) " .
    " AND " .
    " slt.name NOT IN ( ${\(join ', ', @ViewableLocks)} ) ";
    $CommonObject{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $CommonObject{DBObject}->FetchrowArray()) {
#        print " Ticket: $RowTmp[0] State: $RowTmp[1] Answered: $RowTmp[2]\n";
        push (@Tickets, \@RowTmp);
    }
    foreach (@Tickets) {
        my @Row = @{$_};
        print " Unlocking ticket id $Row[0] ...";
        if ($CommonObject{TicketObject}->SetLock(
            TicketID => $Row[3],
            Lock => 'unlock',
            UserID => 1,
        ) ) { 
            # write notification email
            &SendUnlockMail(TN => $Row[0], TicketID => $Row[3], UserID => $Row[4]);
            print " done.\n";
        }
        else {
            print " failed.\n";
        }
    }
    exit (0);
}
# --
# unlock old tickets
# --
elsif ($Command eq '--timeout') {
    print " Unlock old tickets:\n";
    my @Tickets = ();
    my $SQL = "SELECT st.tn, slt.name, st.ticket_answered, st.id, st.timeout, ".
    " sq.unlock_timeout, user_id ".
    " FROM " .
    " ticket as st, queue as sq, ticket_state tsd, ticket_lock_type slt " .
    " WHERE " .
    " st.ticket_state_id = tsd.id " .
    " AND " .
    " st.queue_id = sq.id " .
    " AND " .
    " st.ticket_lock_id = slt.id " .
    " AND " .
    " st.ticket_answered != 1 ".
    " AND " .
    " sq.unlock_timeout != 0 " .
    " AND " .
    " tsd.name IN ( ${\(join ', ', @ViewableStats)} ) " .
    " AND " .
    " slt.name NOT IN ( ${\(join ', ', @ViewableLocks)} ) ";
    $CommonObject{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $CommonObject{DBObject}->FetchrowArray()) {
#        print " Ticket: $RowTmp[0] State: $RowTmp[1] Answered: $RowTmp[2]\n";
        if (($RowTmp[4] + ($RowTmp[5]*60)) <= time()) {
            push (@Tickets, \@RowTmp);
        }
    }
    foreach (@Tickets) {
        my @Row = @{$_};
        print " Unlocking ticket id $Row[0] ...";
        if ($CommonObject{TicketObject}->SetLock(
            TicketID => $Row[3],
            Lock => 'unlock',
            UserID => 1,
        ) ) { 
            # write notification email
            &SendUnlockMail(TN => $Row[0], TicketID => $Row[3], UserID => $Row[6]);
            print " done.\n";
        }
        else {
            print " failed.\n";
        }
    }
    exit (0);
}
# --
# show usage 
# --
else {
    print "usage: $0 [options] \n";
    print "  Options are as follows:\n";
    print "  --help        display this option help\n";
    print "  --timeout     unlock old tickets\n";
    print "  --all         unlock all ticksts (force)\n";
    exit (1);
}
# --
sub SendUnlockMail {
    my %Param = @_;
    foreach (qw(UserID TicketID TN)) {
        if (!$Param{$_}) {
            $CommonObject{LogObject}->Log(Priority => 'error', Message => "Got no $_!");
            return;
        }
    }
    my %UserData = $CommonObject{UserObject}->GetUserData(%Param);
    if ($UserData{UserEmail} && $UserData{UserSendLockTimeoutNotification}) {
        my %Article = $CommonObject{TicketObject}->GetLastCustomerArticle(%Param);
        # --
        # prepare subject 
        # --
        $Param{Subject} = $CommonObject{ConfigObject}->Get('NotificationSubjectLockTimeout')
          || 'No body found in Config.pm!';
        $Article{Subject} =~ s/\n//g;
        if ($Param{Subject} =~ /<OTRS_CUSTOMER_SUBJECT\[(.+?)\]>/) {
            my $SubjectChar = $1;
            $Article{Subject} =~ s/^(.{$SubjectChar}).*$/$1 [...]/;
            $Param{Subject} =~ s/<OTRS_CUSTOMER_SUBJECT\[.+?\]>/$Article{Subject}/g;
        }
        $Param{Subject} = "[". $CommonObject{ConfigObject}->Get('TicketHook') .": $Param{TN}] $Param{Subject}";
        # --
        # prepare body 
        # --
        $Param{Body} = $CommonObject{ConfigObject}->Get('NotificationBodyLockTimeout')
          || 'No body found in Config.pm!';
        $Param{Body} =~ s/<OTRS_USER_FIRSTNAME>/$UserData{UserFirstname}/g;
        $Param{Body} =~ s/<OTRS_TICKET_ID>/$Param{TicketID}/g;
        $Param{Body} =~ s/<OTRS_TICKET_NUMBER>/$Param{TN}/g;
        # --
        # send notification
        # --
        my $EmailObject = Kernel::System::EmailSend->new(%CommonObject);
        $EmailObject->Send(
            %CommonObject,
            To => $UserData{UserEmail},
            ArticleType => 'email-notification-int',
            SenderType => 'system',
            HistoryType => 'SendAgentNotification',
            HistoryComment => "Sent lock timeout notification to '$UserData{UserEmail}'.",
            From => $CommonObject{ConfigObject}->Get('NotificationSenderName').
              ' <'.$CommonObject{ConfigObject}->Get('NotificationSenderEmail').'>',
            Email => $CommonObject{ConfigObject}->Get('NotificationSenderEmail'),
            UserID => $CommonObject{ConfigObject}->Get('PostmasterUserID'),
            Loop => 1,
            %Param,
        );
        return;
    }
    else {
        # --
        # log notice
        # --
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message => "Send 'no' unlock notification for ticket '$Param{TN}'!",
        );
    }
}
# --

