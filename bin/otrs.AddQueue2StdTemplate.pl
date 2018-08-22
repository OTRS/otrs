#!/usr/bin/perl
# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std;
use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.AddQueue2StdTemplate.pl',
    },
);

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
my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup( Queue => $Opts{q} );
if ( !$QueueID ) {
    print STDERR "ERROR: Queue not found for $Opts{q}\n";
    exit 1;
}

# check template
my $StandardTemplateID = $Kernel::OM->Get('Kernel::System::StandardTemplate')->StandardTemplateLookup(
    StandardTemplate => $Opts{t}
);

if ( !$StandardTemplateID ) {
    print STDERR "ERROR: Found no Standard Template for $Opts{t}\n";
    exit 1;
}

# set queue standard template
if (
    !$Kernel::OM->Get('Kernel::System::Queue')->QueueStandardTemplateMemberAdd(
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
