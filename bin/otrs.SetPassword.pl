#!/usr/bin/perl
# --
# bin/otrs.SetPassword.pl - Changes or Sets password for a user
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

use Getopt::Long;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::CustomerUser;
use Kernel::System::User;
use Kernel::System::Main;
use Kernel::System::Time;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    %CommonObject,
    LogPrefix => 'OTRS-otrs.SetPassword.pl',
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);

my %Options;
GetOptions(
    \%Options,
    'agent',
    'customer',
    'h',
);

my $Login = shift;
my $Pw    = shift;

if ( $Options{h} || !$Login ) {
    Usage();
}

my $Type = $Options{customer} ? 'customer' : 'user';
my %AccountList;

# define which object we need to operate on, default to UserObject
# search if login exists
if ( $Type eq 'customer' ) {
    $CommonObject{AccountObject} = Kernel::System::CustomerUser->new(%CommonObject);
    %AccountList = $CommonObject{AccountObject}->CustomerSearch(
        UserLogin => $Login,
    );
}
else {
    $CommonObject{AccountObject} = Kernel::System::User->new(%CommonObject);
    %AccountList = $CommonObject{AccountObject}->UserSearch(
        UserLogin => $Login,
    );
}

# exit if no login matches
if ( !scalar %AccountList ) {
    print "No $Type found with login '$Login'!\n";
    exit 1;
}

# if no password has been provided, generate one
if ( !$Pw ) {
    $Pw = $CommonObject{AccountObject}->GenerateRandomPassword( Size => 12 );
    print "Generated password '$Pw'\n";
}

my $Result = $CommonObject{AccountObject}->SetPassword(
    UserLogin => $Login,
    PW        => $Pw,
);

if ( !$Result ) {
    print "Failed to set password!\n";
    exit 1;
}

print "Set password for $Type '$Login'.\n";
print "Done.\n";
exit 0;

sub Usage {

    print "\n";
    print "$0 - set a new password\n";
    print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n";
    print "Usage: otrs.SetPassword [--customer | --agent] user [password]\n";
    print "\n";
    print "\tIf you do not specify --customer, --agent is assumed.\n";
    print "\tIf you do not specify a password, the script will generate one.\n\n";
    exit 1;
}
