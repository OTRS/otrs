#!/usr/bin/perl
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
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
        LogPrefix => 'OTRS-otrs.CryptPassword.pl',
    },
);

# check args
my $Password = shift;
print
    "bin/otrs.CryptPassword.pl - to crypt database password for Kernel/Config.pm\n";
print "Copyright (C) 2001-2020 OTRS AG, https://otrs.com/\n";

if ( !$Password ) {
    print STDERR "Usage: bin/otrs.CryptPassword.pl NEWPW\n";
}
else {
    chomp $Password;
    my $H = $Kernel::OM->Get('Kernel::System::DB')->_Encrypt($Password);
    print "Crypted password: {$H}\n";
}
