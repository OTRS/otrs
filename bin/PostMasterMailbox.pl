#!/usr/bin/perl -w
# --
# bin/PostMasterMailbox.pl - the global eMail handle for email2db
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: PostMasterMailbox.pl,v 1.4 2009-01-12 12:57:37 mh Exp $
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

use vars qw($VERSION);
$VERSION = qw($Revision: 1.4 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::PID;
use Kernel::System::PostMaster;
use Kernel::System::MailAccount;

# get options
my %Opts = ();
getopt( 'upshdftb', \%Opts );
if ( $Opts{h} ) {
    print "PostMasterMailbox.pl <Revision $VERSION> - Fetch mail accounts for OTRS\n";
    print "Copyright (c) 2001-2009 OTRS AG, http://otrs.org/\n";
    print "usage: PostMasterMailbox.pl -t <TYPE> (POP3|POP3S|IMAP|IMAPS) -s <SERVER> -u <USER> ";
    print "-p <PASSWORD> [-d 1-2] [-b <BACKGROUND_INTERVAL_IN_MIN>] [-f force]\n";
    exit 1;
}

# set debug
if ( !$Opts{d} ) {
    $Opts{d} = 0;
}

# check -b option
if ( $Opts{b} && $Opts{b} !~ /^\d+$/ ) {
    print STDERR "ERROR: Need -b <BACKGROUND_INTERVAL_IN_MIN>, e. g. -b 5 for fetching emails ";
    print STDERR "every 5 minutes.\n";
    exit 1;
}

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-PMAccount',
    %CommonObject,
);
$CommonObject{MainObject}  = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}  = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}    = Kernel::System::DB->new(%CommonObject);
$CommonObject{PIDObject}   = Kernel::System::PID->new(%CommonObject);
$CommonObject{MailAccount} = Kernel::System::MailAccount->new(%CommonObject);

# create pid lock
if ( !$Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => 'PostMasterMailbox' ) ) {
    print "NOTICE: PostMasterMailbox.pl is already running (use '-f 1' if you want to start it ";
    print "forced)!\n";
    exit 1;
}
elsif ( $Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => 'PostMasterMailbox' ) ) {
    print "NOTICE: PostMasterMailbox.pl is already running but is starting again!\n";
}

# while to run several times if -b is used
while (1) {

    # set new PID
    $CommonObject{PIDObject}->PIDCreate(
        Name  => 'PostMasterMailbox',
        Force => 1,
    );

    # fetch mails
    Fetch();

    # return if no interval is set
    last if !$Opts{b};

    # sleep till next interval
    print "NOTICE: Waiting for next interval ($Opts{b} min)...\n";
    sleep 60 * $Opts{b};
}

# delete pid lock
$CommonObject{PIDObject}->PIDDelete( Name => 'PostMasterMailbox' );
exit(0);

sub Fetch {

    # debug info

    if ( $Opts{d} > 1 ) {
        $CommonObject{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Global OTRS email handle (PostMasterMailbox.pl) started...',
        );
    }

    if ( $Opts{s} || $Opts{u} || $Opts{p} || $Opts{t} ) {
        if ( !$Opts{t} ) {

            # delete pid lock
            $CommonObject{PIDObject}->PIDDelete( Name => 'PostMasterMailbox' );
            print STDERR "ERROR: Need -t <TYPE> (POP3|IMAP)\n";
            exit 1;
        }
        if ( !$Opts{s} ) {

            # delete pid lock
            $CommonObject{PIDObject}->PIDDelete( Name => 'PostMasterMailbox' );
            print STDERR "ERROR: Need -s <SERVER>\n";
            exit 1;
        }
        if ( !$Opts{u} ) {

            # delete pid lock
            $CommonObject{PIDObject}->PIDDelete( Name => 'PostMasterMailbox' );
            print STDERR "ERROR: Need -u <USER>\n";
            exit 1;
        }
        if ( !$Opts{p} ) {

            # delete pid lock
            $CommonObject{PIDObject}->PIDDelete( Name => 'PostMasterMailbox' );
            print STDERR "ERROR: Need -p <PASSWORD>\n";
            exit 1;
        }
        $CommonObject{MailAccount}->MailAccountFetch(
            Login         => $Opts{u},
            Password      => $Opts{p},
            Host          => $Opts{s},
            Type          => $Opts{t},
            Trusted       => 0,
            DispatchingBy => '',
            QueueID       => 0,
            Debug         => $Opts{d},
            CMD           => 1,
            UserID        => 1,
        );
    }
    else {
        my %List = $CommonObject{MailAccount}->MailAccountList( Valid => 1 );
        for my $Key ( keys %List ) {
            my %Data = $CommonObject{MailAccount}->MailAccountGet( ID => $Key );
            $CommonObject{MailAccount}->MailAccountFetch(
                %Data,
                Debug  => $Opts{d},
                CMD    => 1,
                UserID => 1,
            );
        }
    }

    # debug info
    if ( $Opts{d} > 1 ) {
        $CommonObject{LogObject}->Log(
            Priority => 'debug',
            Message  => 'Global OTRS email handle (PostMasterMailbox.pl) stoped.',
        );
    }
}
