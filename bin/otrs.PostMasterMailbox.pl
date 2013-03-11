#!/usr/bin/perl
# --
# bin/otrs.PostMasterMailbox.pl - the global eMail handle for email2db
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use vars qw($VERSION);

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Encode;
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
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
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
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.PostMasterMailbox.pl',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
$CommonObject{PIDObject}  = Kernel::System::PID->new(%CommonObject);

# create pid lock
if ( !$Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => 'PostMasterMailbox' ) ) {
    print "NOTICE: PostMasterMailbox.pl is already running (use '-f 1' if you want to start it ";
    print "forced)!\n";
    exit 1;
}
elsif ( $Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => 'PostMasterMailbox' ) ) {
    print "NOTICE: PostMasterMailbox.pl is already running but is starting again!\n";
}

# fetch mails -b is not used
if ( !$Opts{b} ) {
    Fetch(%CommonObject);
}

# while to run several times if -b is used
else {
    while (1) {

        # set new PID
        $CommonObject{PIDObject}->PIDCreate(
            Name  => 'PostMasterMailbox',
            Force => 1,
        );

        # fetch mails
        Fetch(%CommonObject);

        # sleep till next interval
        print "NOTICE: Waiting for next interval ($Opts{b} min)...\n";
        sleep 60 * $Opts{b};
    }
}

# delete pid lock
$CommonObject{PIDObject}->PIDDelete( Name => 'PostMasterMailbox' );
exit(0);

sub Fetch {
    my (%CommonObject) = @_;

    my $MailAccount = Kernel::System::MailAccount->new(%CommonObject);

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
        $MailAccount->MailAccountFetch(
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
        my %List = $MailAccount->MailAccountList( Valid => 1 );
        for my $Key ( sort keys %List ) {
            my %Data = $MailAccount->MailAccountGet( ID => $Key );
            $MailAccount->MailAccountFetch(
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
            Message  => 'Global OTRS email handle (PostMasterMailbox.pl) stopped.',
        );
    }
}
