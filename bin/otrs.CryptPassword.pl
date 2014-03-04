#!/usr/bin/perl
# --
# bin/otrs.CryptPassword.pl - to crypt database password for Kernel/Config.pm
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

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    LogObject => {
        LogPrefix => 'OTRS-otrs.CryptPassword.pl',
    },
);
my %CommonObject = $Kernel::OM->ObjectHash(
    Objects => [qw(ConfigObject EncodeObject LogObject MainObject DBObject)],
);

# check args
my $Password = shift;
print
    "bin/otrs.CryptPassword.pl - to crypt database password for Kernel/Config.pm\n";
print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n";

if ( !$Password ) {
    print STDERR "Usage: bin/otrs.CryptPassword.pl NEWPW\n";
}
else {
    chomp $Password;
    my $H = $CommonObject{DBObject}->_Encrypt($Password);
    print "Crypted password: {$H}\n";
}
