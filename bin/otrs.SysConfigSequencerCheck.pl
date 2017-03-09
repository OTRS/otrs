#!/usr/bin/perl
# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU AFFERO General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

## nofilter(TidyAll::Plugin::OTRS::Perl::BinScripts)
use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.PostMaster.pl',
    },
);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my @Values = (
    'Ticket::EventModulePost',
    'Package::EventModulePost',
    'PostMaster::PreFilterModule',
    'Frontend::Module',
    'Frontend::NotifyModule',
    'CloudService::Admin::Module',
    'Loader::Module::AdminCloudServiceSupportDataCollector',
    'DaemonModules',
    'Daemon::SchedulerCronTaskManager::Task',
    'PreApplicationModule',

);

for my $ConfigKeys ( sort @Values ) {
    my $Data = $ConfigObject->Get($ConfigKeys);

    print "\n==============================\n";
    print "== $ConfigKeys == \n";
    print "==============================\n";

    print "\nTransaction 0 \n\n";

    my $Count = 1;
    KEY:
    for my $Key ( sort keys %{$Data} ) {

        next KEY if $Data->{$Key}->{Transaction};

        print "$Count - $Key\n";

        $Count++;
    }

    print "\nTransaction 1 \n\n";

    $Count = 1;
    KEY:
    for my $Key ( sort keys %{$Data} ) {

        next KEY if !$Data->{$Key}->{Transaction};

        print "$Count - $Key\n";

        $Count++;
    }
    print "\n---------------\n";
}

exit 0;
