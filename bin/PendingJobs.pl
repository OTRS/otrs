#!/usr/bin/perl -w
# --
# PendingJobs.pl - check pending tickets
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: PendingJobs.pl,v 1.25 2006-11-02 12:20:59 tr Exp $
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
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin)."/Kernel/cpan-lib";

use strict;

use vars qw($VERSION);
$VERSION = '$Revision: 1.25 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

use Date::Pcalc qw(Day_of_Week Day_of_Week_Abbreviation);
use Kernel::Config;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Ticket;
use Kernel::System::User;
use Kernel::System::State;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-PendingJobs',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);
$CommonObject{UserObject} = Kernel::System::User->new(%CommonObject);
$CommonObject{StateObject} = Kernel::System::State->new(%CommonObject);

# check args
my $Command = shift || '--help';
print "PendingJobs.pl <Revision $VERSION> - check pending tickets\n";
print "Copyright (c) 2001-2006 OTRS GmbH, http://otrs.org/\n";

# do ticket auto jobs
my @PendingAutoStateIDs = $CommonObject{StateObject}->StateGetStatesByType(
    Type => 'PendingAuto',
    Result => 'ID',
);
if (@PendingAutoStateIDs) {
    my @TicketIDs = ();
    my $SQL = "SELECT st.id FROM " .
      " ticket st " .
      " WHERE " .
      " st.ticket_state_id IN ( ${\(join ', ', @PendingAutoStateIDs)} ) ";
    $CommonObject{DBObject}->Prepare(SQL => $SQL);
    while (my @Row = $CommonObject{DBObject}->FetchrowArray()) {
        push (@TicketIDs, $Row[0]);
    }
    foreach (@TicketIDs) {
      my %Ticket = $CommonObject{TicketObject}->TicketGet(TicketID => $_);
      if ($Ticket{UntilTime} < 1) {
        my %States = %{$CommonObject{ConfigObject}->Get('Ticket::StateAfterPending')};
        if ($States{$Ticket{State}}) {
            print " Update ticket state for ticket $Ticket{TicketNumber} ($_) to '$States{$Ticket{State}}'...";
            if ($CommonObject{TicketObject}->StateSet(TicketID => $_, State => $States{$Ticket{State}}, UserID => 1,)) {
              if ($States{$Ticket{State}} =~ /^close/i) {
                $CommonObject{TicketObject}->LockSet(
                    TicketID => $_,
                    Lock => 'unlock',
                    UserID => 1,
                    Notification => 0,
                );
              }
                print " done.\n";
            }
            else {
                print " failed.\n";
            }
        }
        else {
            print STDERR "ERROR: No Ticket::StateAfterPending found for '$Ticket{State}' in Kernel/Config.pm!\n";
        }
      }
    }
}

# do ticket reminder notification jobs

# get pending states
my @PendingReminderStateIDs = $CommonObject{StateObject}->StateGetStatesByType(
    Type => 'PendingReminder',
    Result => 'ID',
);
# check if pendig time has reached and send notification
if (@PendingReminderStateIDs) {
    my @TicketIDs = ();
    my $SQL = "SELECT st.tn, st.id, st.user_id FROM " .
      " ticket st, ticket_state tsd " .
      " WHERE " .
      " st.ticket_state_id = tsd.id " .
      " AND " .
      " st.ticket_state_id IN ( ${\(join ', ', @PendingReminderStateIDs)} ) ";
    $CommonObject{DBObject}->Prepare(SQL => $SQL);
    while (my @RowTmp = $CommonObject{DBObject}->FetchrowArray()) {
        push (@TicketIDs, $RowTmp[1]);
    }
    foreach (@TicketIDs) {
        my %Ticket = $CommonObject{TicketObject}->TicketGet(TicketID => $_);
        # check if bussines hours is, then send escalation info
        my $CountedTime = $CommonObject{TimeObject}->WorkingTime(
            StartTime => $CommonObject{TimeObject}->SystemTime()-(30*60),
            StopTime => $CommonObject{TimeObject}->SystemTime(),
        );
        if (!$CountedTime) {
            if ($CommonObject{Debug}) {
                $CommonObject{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Send not pending for Ticket $Ticket{TicketNumber}/$Ticket{TicketID} because currently no working hours!",
                );
            }
            next;
        }
        if ($Ticket{UntilTime} < 1) {
            my @UserID = ();
            # send reminder to ticket onwer if ticket is locked
            if ($Ticket{Lock} eq 'lock') {
                @UserID = ($Ticket{OwnerID});
            }
            # send reminder to queue subscriber if ticket is unlocked
            else {
                @UserID = $CommonObject{TicketObject}->GetSubscribedUserIDsByQueueID(
                    QueueID => $Ticket{QueueID},
                );
            }
            # send reminder notification
            print " Send reminder notification (TicketID=$_)\n";
            foreach (@UserID) {
                # get user data
                my %Preferences = $CommonObject{UserObject}->GetUserData(UserID => $_);
                # check if today a reminder is already sent
                my ($Sec, $Min, $Hour, $Day, $Month, $Year) = $CommonObject{TimeObject}->SystemTime2Date(
                    SystemTime => $CommonObject{TimeObject}->SystemTime(),
                );
                my @Lines = $CommonObject{TicketObject}->HistoryGet(
                    TicketID => $Ticket{TicketID},
                    UserID => 1,
                );
                my $Sent = 0;
                foreach my $Line (@Lines) {
                    if ($Line->{Name} =~ /PendingReminder/ && $Line->{Name} =~ /\Q$Preferences{UserEmail}\E/i && $Line->{CreateTime} =~ /$Year-$Month-$Day/) {
                        $Sent = 1;
                    }
                }
                if ($Sent) {
                    next;
                }
                $CommonObject{TicketObject}->SendAgentNotification(
                    UserData => \%Preferences,
                    Type => 'PendingReminder',
                    To => $Preferences{UserEmail},
                    CustomerMessageParams => {},
                    TicketNumber => $CommonObject{TicketObject}->TicketNumberLookup(TicketID => $Ticket{TicketID}),
                    TicketID => $Ticket{TicketID},
                    UserID => 1,
                );
            }
        }
    }
}

exit (0);
