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

use Kernel::System::ObjectManager;

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.RebuildConfig.pl',
    },
);

# rebuild
print "otrs.RebuildConfig.pl - OTRS rebuild default config\n";
print "Copyright (C) 2001-2018 OTRS AG, https://otrs.com/\n";
if ( $Kernel::OM->Get('Kernel::System::SysConfig')->WriteDefault() ) {
    print "Done.\n";
    exit;
}
else {
    $Kernel::OM->Get('Kernel::System::Log')->Log( Priority => 'error' );
    exit 1;
}
