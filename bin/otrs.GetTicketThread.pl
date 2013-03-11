#!/usr/bin/perl
# --
# bin/otrs.GetTicketThread.pl - to print the whole ticket thread to STDOUT
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
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Ticket;

# get options
my %Opts;
getopt( 'htl', \%Opts );
if ( $Opts{h} || !$Opts{t} ) {
    print
        "otrs.GetTicketThread.pl <Revision $VERSION> - Prints out a ticket with all its articles.\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print "usage: otrs.GetTicketThread.pl -t <TicketID> [-l article limit]\n";
    exit 1;
}

# common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.GetTicketThread.pl',
    %CommonObject,
);
$CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
$CommonObject{TicketObject} = Kernel::System::Ticket->new(%CommonObject);

# get ticket data
my %Ticket = $CommonObject{TicketObject}->TicketGet(
    TicketID      => $Opts{t},
    DynamicFields => 0,
);

exit 1 if !%Ticket;

print STDOUT "=====================================================================\n";

KEY:
for my $Key (qw(TicketNumber TicketID Created Queue State Priority Lock CustomerID CustomerUserID))
{

    next KEY if !$Key;
    next KEY if !$Ticket{$Key};

    print STDOUT "$Key: $Ticket{$Key}\n";
}

print STDOUT "---------------------------------------------------------------------\n";

# get article index
my @Index = $CommonObject{TicketObject}->ArticleIndex(
    TicketID => $Opts{t},
);

my $Counter = 1;
ARTICLEID:
for my $ArticleID (@Index) {

    last ARTICLEID if $Opts{l} && $Opts{l} < $Counter;
    next ARTICLEID if !$ArticleID;

    # get article data
    my %Article = $CommonObject{TicketObject}->ArticleGet(
        ArticleID     => $ArticleID,
        DynamicFields => 0,
    );

    next ARTICLEID if !%Article;

    KEY:
    for my $Key (qw(ArticleID From To Cc Subject ReplyTo InReplyTo Created SenderType)) {

        next KEY if !$Key;
        next KEY if !$Article{$Key};

        print STDOUT "$Key: $Article{$Key}\n";
    }

    $Article{Body} ||= '';

    print STDOUT "Body:\n";
    print STDOUT "$Article{Body}\n";
    print STDOUT "---------------------------------------------------------------------\n";
}
continue {
    $Counter++;
}

1;
