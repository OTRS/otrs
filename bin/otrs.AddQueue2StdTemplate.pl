#!/usr/bin/perl
# --
# bin/otrs.AddQueue2StdTemplate.pl - Assign Templates to Queues from CLI
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
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::Log;
use Kernel::System::Queue;
use Kernel::System::StandardTemplate;
use Kernel::System::Main;

# create common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.AddQueue2StdTemplate.pl',
    %CommonObject,
);
$CommonObject{MainObject}             = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}               = Kernel::System::DB->new(%CommonObject);
$CommonObject{QueueObject}            = Kernel::System::Queue->new(%CommonObject);
$CommonObject{StandardTemplateObject} = Kernel::System::StandardTemplate->new(%CommonObject);

# get options
my %Opts;
getopts( 'hq:t:', \%Opts );
if ( $Opts{h} ) {
    print
        "otrs.AddQueue2StdTemplate.pl - assign Queues to Standard templates\n";
    print
        "usage: otrs.AddQueue2StdTemplate.pl -t <TEMPLATE> -q <QUEUE>\n";
    exit 1;
}

if ( !$Opts{t} ) {
    print STDERR "ERROR: Need -t <TEMPLATE>\n";
    exit 1;
}
if ( !$Opts{q} ) {
    print STDERR "ERROR: Need -q <QUEUE>\n";
    exit 1;
}

# check queue
my $QueueID = $CommonObject{QueueObject}->QueueLookup( Queue => $Opts{q} );
if ( !$QueueID ) {
    print STDERR "ERROR: Queue not found for $Opts{q}\n";
    exit 1;
}

# check template
my $StandardTemplateID
    = $CommonObject{StandardTemplateObject}->StandardTemplateLookup( StandardTemplate => $Opts{t} );
if ( !$StandardTemplateID ) {
    print STDERR "ERROR: Found no Standard Template for $Opts{t}\n";
    exit 1;
}

# set queue standard template
if (
    !$CommonObject{QueueObject}->QueueStandardTemplateMemberAdd(
        StandardTemplateID => $StandardTemplateID,
        QueueID            => $QueueID,
        Active             => 1,
        UserID             => 1,
    )
    )
{
    print STDERR "ERROR: Can't set Standard template!\n";
    exit 1;
}
else {
    print "Added Queue '$Opts{q}' to Standard Template '$Opts{t}'.\n";
    exit 0;
}
