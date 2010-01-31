#!/usr/bin/perl -w
# --
# DBUpdate-to-2.5.pl - update script to migrate OTRS 2.4.x to 2.5.x
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: DBUpdate-to-2.5.pl,v 1.2 2010-01-31 23:46:00 martin Exp $
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
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# or see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use vars qw($VERSION);
$VERSION = qw($Revision: 1.2 $) [1];

use Getopt::Std;
use Kernel::Config;
use Kernel::System::CheckItem;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::SysConfig;
use Kernel::System::User;

# get options
my %Opts;
getopt( 'h', \%Opts );
if ( $Opts{h} ) {
    print "DBUpdate-to-2.5.pl <Revision $VERSION> - Database migration script\n";
    print "Copyright (C) 2001-2010 OTRS AG, http://otrs.org/\n";
    exit 1;
}

print "Start migration of the system...\n\n";

# instantiate needed objects (1/2)
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-DBUpdate-to-2.5',
    %CommonObject,
);
$CommonObject{EncodeObject}    = Kernel::System::Encode->new(%CommonObject);
$CommonObject{MainObject}      = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}      = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}        = Kernel::System::DB->new(%CommonObject);
$CommonObject{SysConfigObject} = Kernel::System::SysConfig->new(%CommonObject);
$CommonObject{UserObject}      = Kernel::System::User->new(%CommonObject);

# start migration process
MigrateThemes();
PermissionTableCleanup();

print "\nMigration of the system completed!\n";

exit 0;

=item MigrateThemes()

migrate all themes from the database to SysConfig

    MigrateThemes();

=cut

sub MigrateThemes {

    print "NOTICE: Migrating themes...\n";

    (
        my %Themes
            =
            $CommonObject{DBObject}->GetTableData(
            What  => 'theme, valid_id',
            Table => 'theme',
            )
    ) || die "Error reading themes from database. Migration halted.\n";

    my $Update = $CommonObject{SysConfigObject}->ConfigItemUpdate(
        Key   => 'Frontend::Themes',
        Value => \%Themes,
        Valid => 1,

    ) || die "Can't write SysConfig. Migration halted. $!\n";

    return 1;
}

=item PermissionTableCleanup()

remove all not necessary values from permission table

    PermissionTableCleanup();

=cut

sub PermissionTableCleanup {

    print "NOTICE: Permission table cleanup ...";

    my $Success = $CommonObject{DBObject}->Do(
        SQL => 'DELETE FROM group_user WHERE permission_value = \'0\'',
    );

    if ( !$Success ) {
        print "failed!\n";
        return;
    }

    $Success = $CommonObject{DBObject}->Do(
        SQL => 'DELETE FROM group_customer_user WHERE permission_value = \'0\'',
    );

    if ( !$Success ) {
        print "failed!\n";
        return;
    }

    print "done!\n";

    return 1;
}

1;
