#!/usr/bin/perl -w
# --
# bin/GenericAgent.pl - a generic agent -=> e. g. close ale emails in a specific queue
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: GenericAgent.pl,v 1.23 2004-04-05 17:14:11 martin Exp $
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


# --                                              -- #
# Config file is under Kernel/Config/GenericAgent.pm #
# --                                              -- #


# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin)."/Kernel/cpan-lib";

use strict;

use vars qw($VERSION $Debug $Limit);

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Ticket;
use Kernel::System::Queue;

# import %jobs 
#use Kernel::Config::GenericAgent qw(%Jobs);

BEGIN { 
    # get file version
    $VERSION = '$Revision: 1.23 $';
    $VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;
    # get options
    my %Opts = ();
    getopt('hcdl', \%Opts);
    if ($Opts{'h'}) {
        print "GenericAgent.pl <Revision $VERSION> - OTRS generic agent\n";
        print "Copyright (c) 2001-2004 Martin Edenhofer <martin\@otrs.org>\n";
        print "usage: GenericAgent.pl (-c 'Kernel::Config::GenericAgentJobModule') (-d 1) (-l <limit>)\n";
        exit 1;
    }
    # set debug 
    if (!$Opts{'d'}) {
        $Debug = 0; 
    }
    else {
        $Debug = $Opts{'d'};
    }  
    # set limit 
    if (!$Opts{'l'}) {
        $Limit = 3000; 
    }
    else {
        $Limit = $Opts{'l'};
    }  
    # get generic agent config (job file)
    if (!$Opts{'c'}) {
        $Opts{'c'} = 'Kernel::Config::GenericAgent';
    }
    # load jobs file
    if (!eval "require $Opts{'c'};") {
        print STDERR "Can't load agent job file '$Opts{'c'}': $!\n";
        exit 1;
    }
    # import %Jobs
    eval "import $Opts{'c'}";
}
# set generic agent uid
my $UserIDOfGenericAgent = 1;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-GenericAgent',
    %CommonObject,
);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(
    %CommonObject,
    Debug => $Debug, 
);
$CommonObject{QueueObject} = Kernel::System::Queue->new(%CommonObject);

# --
# process all jobs
# --
foreach my $Job (sort keys %Jobs) {
    print "$Job:\n";
    # --
    # get regular tickets 
    # --
    my %Tickets = ();
    if (! $Jobs{$Job}->{Escalation}) {
        my %PartJobs = %{$Jobs{$Job}};
        if (!$PartJobs{Queue}) {
            print " For all Queues: \n";
            %Tickets = $CommonObject{TicketObject}->TicketSearch(
                %{$Jobs{$Job}},
                Limit => $Limit,
            );
        }
        elsif (ref($PartJobs{Queue}) eq 'ARRAY') {
            foreach (@{$PartJobs{Queue}}) {
                print " For Queue: $_\n";
                %Tickets = ($CommonObject{TicketObject}->TicketSearch(
                    %{$Jobs{$Job}},
                    Queues => [$_],
                    Limit => $Limit,
                ), %Tickets);
            }
        }
        else {
            %Tickets = $CommonObject{TicketObject}->TicketSearch(
                %{$Jobs{$Job}},
                Queues => [$PartJobs{Queue}],
                Limit => $Limit,
            );
        }
    }
    # --
    # escalation tickets
    # --
    else {
        if (! $Jobs{$Job}->{Queue}) {
            my @Tickets = $CommonObject{TicketObject}->GetOverTimeTickets();
            foreach (@Tickets) {
                $Tickets{$_} = $CommonObject{TicketObject}->TicketNumberLookup(TicketID => $_); 
            }
        }
        else {
            my @Tickets = $CommonObject{TicketObject}->GetOverTimeTickets();
            foreach (@Tickets) {
                my %Ticket = $CommonObject{TicketObject}->TicketGet(TicketID => $_);
                if ($Ticket{Queue} eq $Jobs{$Job}->{Queue}) {
                    $Tickets{$_} = $Ticket{TicketNumber};
                }
            }
        }
    }
    # --
    # process each ticket 
    # --
    foreach (sort keys %Tickets) {
        Run($Job, $_, $Tickets{$_});
    }
}
# --
# process each ticket 
# --
sub Run {
    my $Job = shift;
    my $TicketID = shift;
    my $TicketNumber = shift;
    print "* $TicketNumber ($TicketID) \n";
    # --
    # move ticket
    # --
    if ($Jobs{$Job}->{New}->{Queue}) {
        print "  - Move Ticket to Queue '$Jobs{$Job}->{New}->{Queue}'\n";
        $CommonObject{TicketObject}->MoveTicket(
            QueueID => $CommonObject{QueueObject}->QueueLookup(Queue=>$Jobs{$Job}->{New}->{Queue}, Cache => 1),
            UserID => $UserIDOfGenericAgent,
            TicketID => $TicketID,
        );
    }
    # --
    # add note if wanted
    # --
    if ($Jobs{$Job}->{New}->{Note}->{Body}) {
        print "  - Add note\n";
        $CommonObject{TicketObject}->CreateArticle(
            TicketID => $TicketID,
            ArticleType => $Jobs{$Job}->{New}->{Note}->{ArticleType} || 'note-internal',
            SenderType => 'agent',
            From => $Jobs{$Job}->{New}->{Note}->{From} || 'GenericAgent',
            Subject => $Jobs{$Job}->{New}->{Note}->{Subject} || 'Note',
            Body => $Jobs{$Job}->{New}->{Note}->{Body}, 
            UserID => $UserIDOfGenericAgent,
            HistoryType => 'AddNote',
            HistoryComment => 'Note added.',
        );
    }
    # --   
    # set new state
    # --
    if ($Jobs{$Job}->{New}->{State}) {
        print "  - set state to '$Jobs{$Job}->{New}->{State}'\n";
        $CommonObject{TicketObject}->StateSet(
            TicketID => $TicketID,
            UserID => $UserIDOfGenericAgent,
            State => $Jobs{$Job}->{New}->{State}, 
        );
    }
    # --   
    # set customer id and customer user 
    # --
    if ($Jobs{$Job}->{New}->{CustomerID} || $Jobs{$Job}->{New}->{CustomerUserLogin}) {
        if ($Jobs{$Job}->{New}->{CustomerID}) {
            print "  - set customer id to '$Jobs{$Job}->{New}->{CustomerID}'\n";
        }
        if ($Jobs{$Job}->{New}->{CustomerUserLogin}) {
            print "  - set customer user id to '$Jobs{$Job}->{New}->{CustomerUserLogin}'\n";
        }
        $CommonObject{TicketObject}->SetCustomerData(
            TicketID => $TicketID,
            No => $Jobs{$Job}->{New}->{CustomerID} || '',
            User => $Jobs{$Job}->{New}->{CustomerUserLogin} || '',
            UserID => $UserIDOfGenericAgent,
        );
    }
    # --   
    # set new priority 
    # --
    if ($Jobs{$Job}->{New}->{Priority}) {
        print "  - set priority to '$Jobs{$Job}->{New}->{Priority}'\n";
        $CommonObject{TicketObject}->PrioritySet(
            TicketID => $TicketID,
            UserID => $UserIDOfGenericAgent,
            Priority => $Jobs{$Job}->{New}->{Priority}, 
        );
    }
    # --
    # set new owner
    # --
    if ($Jobs{$Job}->{New}->{Owner}) {
        print "  - set owner to '$Jobs{$Job}->{New}->{Owner}'\n";
        $CommonObject{TicketObject}->OwnerSet(
            TicketID => $TicketID,
            UserID => $UserIDOfGenericAgent,
            NewUser => $Jobs{$Job}->{New}->{Owner},
        );
    }
    # --
    # set new lock 
    # --
    if ($Jobs{$Job}->{New}->{Lock}) {
        print "  - set lock to '$Jobs{$Job}->{New}->{Lock}'\n";
        $CommonObject{TicketObject}->LockSet(
            TicketID => $TicketID,
            UserID => $UserIDOfGenericAgent,
            Lock => $Jobs{$Job}->{New}->{Lock},
        );
    }
    # --
    # set ticket free text options
    # --
    foreach (1..8) { 
        if ($Jobs{$Job}->{New}->{"TicketFreeKey$_"} || $Jobs{$Job}->{New}->{"TicketFreeText$_"}) {
            my $Key = $Jobs{$Job}->{New}->{"TicketFreeKey$_"} || '';
            my $Value = $Jobs{$Job}->{New}->{"TicketFreeText$_"} || '';
            print "  - set ticket free text to Key: '$Key' Text: '$Value'\n";
            $CommonObject{TicketObject}->TicketFreeTextSet(
                TicketID => $TicketID,
                UserID => $UserIDOfGenericAgent,
                Key => $Key,
                Value => $Value,
                Counter => $_,
            );
        }
    }
    # --
    # run module 
    # --
    if ($Jobs{$Job}->{New}->{Module}) {
        print "  - use module ($Jobs{$Job}->{New}->{Module})\n";
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message => "Use module ($Jobs{$Job}->{New}->{Module}) Ticket [$TicketNumber], TicketID [$TicketID].",
        );
        if ($Debug) {
            $CommonObject{LogObject}->Log(
                Priority => 'debug',
                Message => "Try to load module: $Jobs{$Job}->{New}->{Module}!",
            );
        }
        if (eval "require $Jobs{$Job}->{New}->{Module}") {
            my $Object = $Jobs{$Job}->{New}->{Module}->new(
                %CommonObject,
                Debug => $Debug,
            );
            if ($Debug) {
                $CommonObject{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Loaded module: $Jobs{$Job}->{New}->{Module}!",
                );
                $CommonObject{LogObject}->Log(
                    Priority => 'debug',
                    Message => "Run module: $Jobs{$Job}->{New}->{Module}!",
                );
            }
            $Object->Run(TicketID => $TicketID);
        }
        else {
            $CommonObject{LogObject}->Log(
                Priority => 'error',
                Message => "Can't load module: $Jobs{$Job}->{New}->{Module}!",
            );
        }
    }
    # --
    # cmd
    # --
    if ($Jobs{$Job}->{New}->{CMD}) {
        print "  - call cmd ($Jobs{$Job}->{New}->{CMD}) for ticket_id $_\n";
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message => "Execut '$Jobs{$Job}->{New}->{CMD} $TicketNumber $TicketID'.",
        );
        system("$Jobs{$Job}->{New}->{CMD} $TicketNumber $TicketID ");
    }
    # --
    # delete ticket
    # --
    if ($Jobs{$Job}->{New}->{Delete}) {
        print "  - delete ticket_id $TicketID\n";
        $CommonObject{LogObject}->Log(
            Priority => 'notice',
            Message => "Delete Ticket [$TicketNumber], TicketID [$TicketID].",
        );
        $CommonObject{TicketObject}->TicketDelete(
            UserID => $UserIDOfGenericAgent, 
            TicketID => $TicketID,
        );
    }
}
# --

