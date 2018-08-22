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

use Getopt::Long;

use Kernel::System::ObjectManager;

# get options
Getopt::Long::Configure('no_ignore_case');
my %Opts;
GetOptions(
    'expired|e' => \$Opts{e},
    'all|a'     => \$Opts{a},
    'help|h'    => \$Opts{h},
    'type|t=s'  => \$Opts{t},
);

print "otrs.DeleteCache.pl - delete OTRS cache\n";
print "Copyright (C) 2001-2018 OTRS AG, https://otrs.com/\n\n";

if ( $Opts{h} ) {
    print "usage: otrs.DeleteCache.pl [--expired] [--type TYPE]\n";
    exit 1;
}

print "Deleting cache... ";

my %Options;
if ( $Opts{e} ) {
    $Options{Expired} = 1;
}
if ( $Opts{t} ) {
    $Options{Type} = $Opts{t};
}

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.DeleteCache.pl',
    },
);

# get cache object
my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

if ( !$CacheObject->CleanUp(%Options) ) {
    exit 1;
}

print "Done.\n";

exit;
