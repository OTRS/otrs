#!/usr/bin/perl -w
# --
# bin/GenericAgent.pl - a generic agent -=> e. g. close ale emails in a specific queue
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: GenericAgent.pl,v 1.52 2008-12-28 23:15:34 martin Exp $
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

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use vars qw($VERSION %Jobs @ISA);
$VERSION = qw($Revision: 1.52 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::PID;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::Ticket;
use Kernel::System::Queue;
use Kernel::System::GenericAgent;

# get options
my %Opts = ();
getopt( 'fcdlb', \%Opts );
if ( $Opts{h} ) {
    print "GenericAgent.pl <Revision $VERSION> - OTRS generic agent\n";
    print "Copyright (c) 2001-2008 OTRS AG, http://otrs.org/\n";
    print "usage: GenericAgent.pl [-c 'Kernel::Config::GenericAgentJobModule'] [-d 1] ";
    print "[-l <limit>] [-f force]\n";
    print "usage: GenericAgent.pl [-c db] [-d 1] [-l <limit>] ";
    print "[-b <BACKGROUND_INTERVAL_IN_MIN> (note: only 10,20,30,40,50,60,... minutes make ";
    print "sense)] [-f force]\n";
    print "Use -d for debug mode.\n";
    exit 1;
}

# set debug
if ( !$Opts{d} ) {
    $Opts{d} = 0;
}

# set limit
if ( !$Opts{l} ) {
    $Opts{l} = 4000;
}

# check -b option
if ( $Opts{c} eq 'db' && $Opts{b} && $Opts{b} !~ /^\d+$/ ) {
    print STDERR "ERROR: Need -b <BACKGROUND_INTERVAL_IN_MIN>, e. g. -b 10 to execute generic agent";
    print STDERR " every 10 minutes (note, only 10,20,30,40,50,60,... minutes make sense).\n";
    exit 1;
}

# set generic agent uid
my $UserIDOfGenericAgent = 1;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-GenericAgent',
    %CommonObject,
);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{PIDObject}    = Kernel::System::PID->new(%CommonObject);
$CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new( %CommonObject, Debug => $Opts{d}, );
$CommonObject{QueueObject}  = Kernel::System::Queue->new(%CommonObject);
$CommonObject{GenericAgentObject} = Kernel::System::GenericAgent->new(
    %CommonObject,
    Debug        => $Opts{d},
    NoticeSTDOUT => 1,
);

# get generic agent config (job file)
if ( !$Opts{c} ) {
    $Opts{c} = 'Kernel::Config::GenericAgent';
}

# db jobs
if ( $Opts{c} eq 'db' ) {
    %Jobs = ();
}

# load/import config jobs
else {
    if ( !$CommonObject{MainObject}->Require( $Opts{c} ) ) {
        print STDERR "ERROR: Can't load agent job file '$Opts{c}': $!\n";
        exit 1;
    }
    eval "import $Opts{c}";
}

# create pid lock
if ( !$Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => 'GenericAgent' ) ) {
    print "NOTICE: GenericAgent.pl is already running!\n";
    exit 1;
}
elsif ( $Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => 'GenericAgent' ) ) {
    print "NOTICE: GenericAgent.pl is already running but is starting again!\n";
}

# while to run several times if -b is used
while (1) {

    # set new PID
    $CommonObject{PIDObject}->PIDCreate(
        Name  => 'GenericAgent',
        Force => 1,
    );

    # process all db jobs
    if ( $Opts{c} eq 'db' ) {
        ExecuteDBJobs();
    }
    # process all config file jobs
    else {
        ExecuteConfigJobs();
    }

    # return if no interval is set
    last if !$Opts{b};

    # sleep till next interval
    print "NOTICE: Waiting for next interval ($Opts{b} min)...\n";
    sleep 60 * $Opts{b};
}

# delete pid lock
$CommonObject{PIDObject}->PIDDelete( Name => 'GenericAgent' );
exit(0);

sub ExecuteConfigJobs {
    for my $Job ( sort keys %Jobs ) {

        # log event
        $CommonObject{GenericAgentObject}->JobRun(
            Job    => $Job,
            Limit  => $Opts{l},
            Config => $Jobs{$Job},
            UserID => $UserIDOfGenericAgent,
        );
    }
}

sub ExecuteDBJobs {

    # process all jobs
    my %DBJobs = $CommonObject{GenericAgentObject}->JobList();
    for my $DBJob ( sort keys %DBJobs ) {

        # get job
        my %DBJobRaw = $CommonObject{GenericAgentObject}->JobGet( Name => $DBJob );

        # check requred params (need min. one param)
        my $Schedule;
        for my $Key (qw( ScheduleDays ScheduleMinutes ScheduleHours )) {
            if ( $DBJobRaw{$Key} ) {
                $Schedule = 1;
            }
        }
        next if !$Schedule;

        # next if jobs is invalid
        next if !$DBJobRaw{Valid};

        # get time params to check last and current run
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay ) = $CommonObject{TimeObject}->SystemTime2Date(
            SystemTime => $CommonObject{TimeObject}->SystemTime(),
        );
        if ( $Min =~ /(.)./ ) {
            $Min = ($1) . '0';
        }

        # check ScheduleDays
        if ( $DBJobRaw{ScheduleDays} ) {
            my $Match = 0;
            for ( @{ $DBJobRaw{ScheduleDays} } ) {
                if ( $_ eq $WDay ) {
                    $Match = 1;
                }
            }
            next if !$Match;
        }

        # check ScheduleMinutes
        if ( $DBJobRaw{ScheduleMinutes} ) {
            my $Match = 0;
            for ( @{ $DBJobRaw{ScheduleMinutes} } ) {
                if ( $_ == $Min ) {
                    $Match = 1;
                }
            }
            next if !$Match;
        }

        # check ScheduleHours
        if ( $DBJobRaw{ScheduleHours} ) {
            my $Match = 0;
            for ( @{ $DBJobRaw{ScheduleHours} } ) {
                if ( $_ == $Hour ) {
                    $Match = 1;
                }
            }
            next if !$Match;
        }

        # check if job already was running
        my $CurrentTime = $CommonObject{TimeObject}->SystemTime();
        if (
            $DBJobRaw{ScheduleLastRunUnixTime}
            && $CurrentTime < $DBJobRaw{ScheduleLastRunUnixTime} + ( 10 * 60 )
            )
        {
            print "Job '$DBJob' already finished!\n";
            next;
        }

        # log event
        $CommonObject{GenericAgentObject}->JobRun(
            Job    => $DBJob,
            Limit  => $Opts{l},
            UserID => $UserIDOfGenericAgent,
        );
    }
}
