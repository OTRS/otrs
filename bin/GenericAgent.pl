#!/usr/bin/perl -w
# --
# bin/GenericAgent.pl - a generic agent -=> e. g. close ale emails in a specific queue
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: GenericAgent.pl,v 1.47 2008-04-19 23:10:26 martin Exp $
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
$VERSION = qw($Revision: 1.47 $) [1];

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
getopt( 'fhcdl', \%Opts );
if ( $Opts{'h'} ) {
    print "GenericAgent.pl <Revision $VERSION> - OTRS generic agent\n";
    print "Copyright (c) 2001-2008 OTRS AG, http://otrs.org/\n";
    print
        "usage: GenericAgent.pl [-c 'Kernel::Config::GenericAgentJobModule'] [-d 1] [-l <limit>] [-f force]\n";
    print "usage: GenericAgent.pl [-c db || -c 'Kernel::Config::GenericAgentJobModule'] "
        . "[-d 1] [-l <limit>] [-f force]\n";
    print "Use -d for debug mode.\n";
    exit 1;
}

# set debug
if ( !$Opts{'d'} ) {
    $Opts{'d'} = 0;
}

# set limit
if ( !$Opts{'l'} ) {
    $Opts{'l'} = 4000;
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
$CommonObject{TicketObject} = Kernel::System::Ticket->new( %CommonObject, Debug => $Opts{'d'}, );
$CommonObject{QueueObject}  = Kernel::System::Queue->new(%CommonObject);
$CommonObject{GenericAgentObject} = Kernel::System::GenericAgent->new(
    %CommonObject,
    Debug        => $Opts{'d'},
    NoticeSTDOUT => 1,
);

# get generic agent config (job file)
if ( !$Opts{'c'} ) {
    $Opts{'c'} = 'Kernel::Config::GenericAgent';
}
if ( $Opts{'c'} eq 'db' ) {
    %Jobs = ();
}
else {
    if ( !$CommonObject{MainObject}->Require( $Opts{'c'} ) ) {
        print STDERR "Can't load agent job file '$Opts{'c'}': $!\n";
        exit 1;
    }
    else {

        # import %Jobs
        eval "import $Opts{'c'}";
    }
}

# process all jobs
if ( $Opts{'c'} eq 'db' ) {

    # create pid lock
    if ( !$Opts{'f'} && !$CommonObject{PIDObject}->PIDCreate( Name => 'GenericAgent' ) ) {
        print "Notice: GenericAgent.pl is already running!\n";
        exit 1;
    }
    elsif ( $Opts{'f'} && !$CommonObject{PIDObject}->PIDCreate( Name => 'GenericAgent' ) ) {
        print "Notice: GenericAgent.pl is already running but is starting again!\n";
    }

    # process all jobs
    my %DBJobs = $CommonObject{GenericAgentObject}->JobList();
    for my $DBJob ( sort keys %DBJobs ) {
        my %DBJobRaw = $CommonObject{GenericAgentObject}->JobGet( Name => $DBJob );
        my $Run      = 0;
        my $False    = 0;

        # check last run
        my ( $Sec, $Min, $Hour, $Day, $Month, $Year, $WDay ) = $CommonObject{TimeObject} ->SystemTime2Date(
            SystemTime => $CommonObject{TimeObject}->SystemTime(),
        );

        if ( $Min =~ /(.)./ ) {
            $Min = ($1) . "0";
        }
        if ( $DBJobRaw{ScheduleDays} ) {
            my $Match = 0;
            for ( @{ $DBJobRaw{ScheduleDays} } ) {
                if ( $_ eq $WDay ) {
                    $Match = 1;
                    $Run   = 1;
                }
            }
            if ( !$Match ) {
                $False = 1;
            }
        }
        if ( !defined( $DBJobRaw{ScheduleMinutes} ) ) {
            @{ $DBJobRaw{ScheduleMinutes} } = qw(00 10 20 30 40 50);
        }
        my $Match = 0;
        for ( @{ $DBJobRaw{ScheduleMinutes} } ) {
            if ( $_ == $Min ) {
                $Match = 1;
                $Run   = 1;
            }
        }
        if ( !$Match ) {
            $False = 1;
        }
        if ( !defined( $DBJobRaw{ScheduleHours} ) ) {
            @{ $DBJobRaw{ScheduleHours} }
                = qw(00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23);
        }
        $Match = 0;
        for ( @{ $DBJobRaw{ScheduleHours} } ) {
            if ( $_ == $Hour ) {
                $Match = 1;
                $Run   = 1;
            }
        }
        if ( !$Match ) {
            $False = 1;
        }

        # check if job is invalid
        if ( !$DBJobRaw{Valid} ) {
            $False = 1;
        }

        # check if job already was running
        my $CurrentTime = $CommonObject{TimeObject}->SystemTime();
        if (   $DBJobRaw{ScheduleLastRunUnixTime}
            && $CurrentTime < $DBJobRaw{ScheduleLastRunUnixTime} + ( 10 * 60 ) )
        {
            print "Job '$DBJob' already finished!\n";
            $False = 1;
        }
        if ( !$False ) {

            # log event
            $CommonObject{GenericAgentObject}->JobRun(
                Job    => $DBJob,
                Limit  => $Opts{'l'},
                UserID => $UserIDOfGenericAgent,
            );
        }
    }

    # delete pid lock
    $CommonObject{PIDObject}->PIDDelete( Name => 'GenericAgent' );
}

# process all config file jobs
else {
    for my $Job ( sort keys %Jobs ) {

        # log event
        $CommonObject{GenericAgentObject}->JobRun(
            Job    => $Job,
            Limit  => $Opts{'l'},
            Config => $Jobs{$Job},
            UserID => $UserIDOfGenericAgent,
        );
    }
}

exit;
