#!/usr/bin/perl
# --
# otrs.MarkTicketAsSeen.pl - set all ticket to seen
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

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::User;
use Kernel::System::Ticket;

# get options
my %Opts = ();
getopts( 'ha', \%Opts );
if ( $Opts{h} ) {
    print "otrs.MarkTicketAsSeen.pl - mark tickets as seen by the agent\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n\n";
    print "usage: otrs.MarkTicketAsSeen.pl [-a]\n\n";
    print "If you pass '-a' it will update ALL tickets, otherwise only non-closed\n";
    print "tickets will be updated.\n";
    exit 1;
}

# create common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.MarkTicketAsSeen.pl',
    %CommonObject,
);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{UserObject}   = Kernel::System::User->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

# disable ticket events
$CommonObject{ConfigObject}->{'Ticket::EventModulePost'} = undef;

my %Search;
if ( !$Opts{a} ) {
    print "Only processing tickets that are not closed:\n";
    $Search{StateType} = 'Open';
}
else {
    print "Processing all tickets:\n";
}

# get all users
my %Users = $CommonObject{UserObject}->UserList(
    Type  => 'Short',
    Valid => 1,
);

# get all tickets
my @TicketIDs = $CommonObject{TicketObject}->TicketSearch(

    # result (required)
    Result  => 'ARRAY',
    OrderBy => 'Down',

    # result limit
    Limit      => 1_000_000_000,
    UserID     => 1,
    Permission => 'ro',

    # restriction
    %Search,
);

my $TicketCount = scalar @TicketIDs;
my $Count       = 0;
for my $TicketID (@TicketIDs) {
    $Count++;
    my $TicketObject = Kernel::System::Ticket->new(%CommonObject);

    # check permission
    my %UserAccess;
    for my $UserID ( sort keys %Users ) {
        my $Access = $TicketObject->TicketPermission(
            Type     => 'ro',
            TicketID => $TicketID,
            LogNo    => 1,
            UserID   => $UserID,
        );
        $UserAccess{$UserID} = $Access;
    }

    # update article flag
    my @ArticleIndex = $TicketObject->ArticleIndex(
        TicketID => $TicketID,
        UserID   => 1,
    );
    my @Data;
    for my $ArticleID (@ArticleIndex) {
        for my $UserID ( sort keys %Users ) {

            # check permission
            next if !$UserAccess{$UserID};

            push @Data, {
                ArticleID => $ArticleID,
                UserID    => $UserID,
            };
        }
    }

    # mark article as seen
    for my $Row (@Data) {
        $TicketObject->ArticleFlagSet(
            ArticleID => $Row->{ArticleID},
            Key       => 'Seen',
            Value     => 1,
            UserID    => $Row->{UserID},
        );
    }

    # update ticket flag
    for my $UserID ( sort keys %Users ) {

        # check permission
        next if !$UserAccess{$UserID};

        # set ticket flag
        $TicketObject->TicketFlagSet(
            TicketID => $TicketID,
            Key      => 'Seen',
            Value    => 1,
            UserID   => $UserID,
        );
    }

    print "NOTICE: $Count of $TicketCount tickets.\n";
}
print "NOTICE: done.\n";

exit 0;
