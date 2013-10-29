#!/usr/bin/perl
# --
# bin/otrs.ImportACLsFromConfig.pl - import existing ACLs from Config.pm to database
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
use utf8;

use File::Basename;
use FindBin qw($RealBin);

use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Kernel::Config;
use Kernel::System::DB;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::Time;
use Kernel::System::ACL::DB::ACL;

my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.ImportACLsFromConfig.pl',
    %CommonObject,
);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
$CommonObject{ACLObject}  = Kernel::System::ACL::DB::ACL->new(%CommonObject);

# check if there are already entries in the database
# in this case, the import can't be done.
exit 1 if !$CommonObject{DBObject}->Prepare(
    SQL => 'SELECT id FROM acl',
);

=cut
# fetch the result
my $RowCount = $CommonObject{DBObject}->FetchrowArray();
if ($RowCount) {
    $CommonObject{LogObject}->Log(
        Priority => 'error',
        Message =>
            'Existing database entries found! Import stopped. Database has to be clean in order to be able to import ACLs from config.',
    );
    exit 1;
}
=cut

# check if there are any ACLs to import
my $ACLs = $CommonObject{ConfigObject}->{TicketAcl};
if ( !$ACLs || ref $ACLs ne 'HASH' ) {

    $CommonObject{LogObject}->Log(
        Priority => 'error',
        Message  => 'No ACLs found which could be imported. Import stopped.',
    );
    exit 1;

}

# get current time to add to ACL comments
my $TimeStamp = $CommonObject{TimeObject}->CurrentTimestamp();

ACL:
for my $ACLName ( sort keys %{$ACLs} ) {

    # try adding the ACL
    my $ACLID = $CommonObject{ACLObject}->ACLAdd(
        Name           => $ACLName,
        Comment        => 'Imported at ' . $TimeStamp,
        StopAfterMatch => $ACLs->{$ACLName}->{StopAfterMatch},
        ConfigMatch    => {
            Properties         => $ACLs->{$ACLName}->{Properties}         || {},
            PropertiesDatabase => $ACLs->{$ACLName}->{PropertiesDatabase} || {},
        },
        ConfigChange => {
            Possible    => $ACLs->{$ACLName}->{Possible}    || {},
            PossibleNot => $ACLs->{$ACLName}->{PossibleNot} || {},
        },
        ValidID => 1,
        UserID  => 1,
    );

    # show error if can't create
    if ( !$ACLID ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "There was an error creating the ACL",
        );
        next ACL;
    }
}

print "###############################################################\n";
print " IMPORT COMPLETED!\n";
print "###############################################################\n";
print " Please check the log for any errors.\n\n\n";
print " Important: Please delete the ACLs from any config files now in\n";
print " order to avoid any collisions with entries from the database.\n";
print "###############################################################\n";

exit 0;
