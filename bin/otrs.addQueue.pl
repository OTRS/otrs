#!/usr/bin/perl -w
# --
# bin/otrs.addQueue.pl - Add Queue from CLI
# Copyright (C) 2001-2009 OTRS AG, http://otrs.org/
# --
# $Id: otrs.addQueue.pl,v 1.1 2009-11-03 15:18:50 mn Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use vars qw($VERSION);
$VERSION = qw($Revision: 1.1 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::Queue;
use Kernel::System::Group;
use Kernel::System::Main;

# get options
my %Opts = ();
getopts( 'hg:n:s:c:r:u:l:C:', \%Opts );
if ( $Opts{h} ) {
    print "otrs.addQueue.pl <Revision $VERSION> - add new queue\n";
    print "Copyright (C) 2002 Atif Ghaffar <aghaffar\@developer.ch>\n";
    print "Copyright (C) 2001-2009 OTRS AG, http://otrs.org/\n";
    print "usage: otrs.addQueue.pl -n <NAME> -g <GROUP> [-s <SYSTEMADDRESSID> -c <COMMENT> -r <FirstResponseTime> -u <UpdateTime> -l <SolutionTime> -C <CalendarID>]\n";
    exit 1;
}

if ( !$Opts{n} ) {
    print STDERR "ERROR: Need -n <NAME>\n";
    exit 1;
}
if ( !$Opts{g} ) {
    print STDERR "ERROR: Need -g <GROUP>\n";
    exit 1;
}

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject} = Kernel::System::Log->new( %CommonObject, LogPrefix => 'otrs.addQueue', );
$CommonObject{MainObject}  = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}    = Kernel::System::DB->new(%CommonObject);
$CommonObject{QueueObject} = Kernel::System::Queue->new(%CommonObject);
$CommonObject{GroupObject} = Kernel::System::Group->new(%CommonObject);

# check group
my $GroupID = $CommonObject{GroupObject}->GroupLookup( Group => $Opts{g} );
if ( !$GroupID ) {
    print STDERR "ERROR: Found no GroupID for $Opts{g}\n";
    exit 1;
}

# add queue
if (
    !$CommonObject{QueueObject}->QueueAdd(
        Name               => $Opts{n},
        GroupID            => $GroupID,
        SystemAddressID    => $Opts{s} || undef,
        Comment            => $Opts{c} || undef,
        FirstResponseTime  => $Opts{r} || undef,
        UpdateTime         => $Opts{u} || undef,
        SolutionTime       => $Opts{l} || undef,
        Calendar           => $Opts{C} || undef,
        ValidID            => 1,
        UserID             => 1,
    )
    )
{
    print STDERR "ERROR: Can't create queue!\n";
    exit 1;
}
else {
    print "Queue '$Opts{n}' created.\n";
    exit(0);
}
