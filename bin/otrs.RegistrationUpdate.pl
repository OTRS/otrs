#!/usr/bin/perl
# --
# bin/otrs.RegistrationUpdate.pl - rebuild config
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
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

use Kernel::System::ObjectManager;
use Kernel::System::Registration;

print "otrs.RegistrationUpdate.pl - send system registration update\n";
print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";

# ---
# create object manager
# ---
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.RegistrationUpdate.pl',
    },
);

my %RegistrationData = $Kernel::OM->Get('Kernel::System::Registration')->RegistrationDataGet();

if ( $RegistrationData{State} ne 'registered' ) {
    print STDERR "Error: this is not a registered system. Please register your system first.\n";
    exit 1;
}

my %Result = $Kernel::OM->Get('Kernel::System::Registration')->RegistrationUpdateSend();

if ( !$Result{Success} ) {
    print STDERR "Error: $Result{Reason}\n";
    exit 1;
}

print "Registration update was successfully sent.\n";
exit;
