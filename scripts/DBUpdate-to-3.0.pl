#!/usr/bin/perl -w
# --
# DBUpdate-to-3.0.pl - update script to migrate OTRS 2.4.x to 3.0.x
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: DBUpdate-to-3.0.pl,v 1.4 2010-11-23 09:00:44 mg Exp $
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
$VERSION = qw($Revision: 1.4 $) [1];

use Getopt::Std qw();
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::State;
use Kernel::System::SysConfig;

{

    # get options
    my %Opts;
    Getopt::Std::getopt( 'h', \%Opts );

    if ( exists $Opts{h} ) {
        print <<"EOF";

DBUpdate-to-3.0.pl <Revision $VERSION> - Database migration script for upgrading OTRS 2.4 to 3.0
Copyright (C) 2001-2010 OTRS AG, http://otrs.org/

EOF
        exit 1;
    }

    print "\nMigration started...\n\n";

    # create common objects
    my $CommonObject = _CommonObjectsBase();

    # start migration process 1/2
    print "Step 1 of 4: Refresh configuration cache... ";
    RebuildConfig($CommonObject);
    print "done.\n\n";

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    # start migration process 2/2
    print "Step 2 of 4: Migrating theme configuration... ";
    MigrateThemes($CommonObject);
    print "done.\n\n";

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    print "Step 3 of 4: Cleaning up the permission table... ";
    PermissionTableCleanup($CommonObject);
    print "done.\n\n";

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    print "Step 4 of 4: Cleanup pending time of tickets without pending state-type... ";
    RemovePendingTime($CommonObject);
    print "done.\n\n";

    print "Migration completed!\n";

    exit 0;
}

sub _CommonObjectsBase {
    my %CommonObject;
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-DBUpdate-to-3.0',
        %CommonObject,
    );
    $CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
    $CommonObject{TimeObject}   = Kernel::System::Time->new(%CommonObject);
    $CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
    return \%CommonObject;
}

=item RebuildConfig($CommonObject)

refreshes the configuration to make sure that a ZZZAAuto.pm is present
after the upgrade.

    RebuildConfig($CommonObject);

=cut

sub RebuildConfig {
    my $CommonObject = shift;

    # write now default config options
    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );
    if ( !$SysConfigObject->WriteDefault() ) {
        die "ERROR: Can't write default config files!";
    }

    # reload config object
    $CommonObject->{ConfigObject} = Kernel::Config->new( %{$CommonObject} );

    return 1;
}

=item MigrateThemes($CommonObject)

migrate the theme configuration from the database to SysConfig. The themes table
will be dropped later in the *post.sql file.

    MigrateThemes($CommonObject);

=cut

sub MigrateThemes {
    my $CommonObject = shift;

    my %Themes = $CommonObject->{DBObject}->GetTableData(
        What  => 'theme, valid_id',
        Table => 'theme',
    );

    if ( !%Themes ) {
        die "ERROR: reading themes from database. Migration halted.\n";
    }

    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );
    my $Update          = $SysConfigObject->ConfigItemUpdate(
        Key   => 'Frontend::Themes',
        Value => \%Themes,
        Valid => 1,

    ) || die "ERROR: Can't write SysConfig. Migration halted. $!\n";

    return 1;
}

=item PermissionTableCleanup($CommonObject)

removes all not necessary values from permission table.

    PermissionTableCleanup($CommonObject);

=cut

sub PermissionTableCleanup {
    my $CommonObject = shift;

    my $Success = $CommonObject->{DBObject}->Do(
        SQL => 'DELETE FROM group_user WHERE permission_value = \'0\'',
    );

    if ( !$Success ) {
        die "Database command failed!";
    }

    $Success = $CommonObject->{DBObject}->Do(
        SQL => 'DELETE FROM group_customer_user WHERE permission_value = \'0\'',
    );

    if ( !$Success ) {
        die "Database command failed!";
    }

    return 1;
}

=item RemovePendingTime($CommonObject)

sets tending time to zero if the ticket does not have a pending-type state.

    RemovePendingTime($CommonObject);

=cut

sub RemovePendingTime {
    my $CommonObject = shift;

    # read pending state types from config
    my $PendingReminderStateType =
        $CommonObject->{ConfigObject}->Get('Ticket::PendingReminderStateType:')
        || 'pending reminder';
    my $PendingAutoStateType =
        $CommonObject->{ConfigObject}->Get('Ticket::PendingAutoStateType:') || 'pending auto';

    # read states
    my $StateObject = Kernel::System::State->new( %{$CommonObject} );

    my @PendingStateIDs = $StateObject->StateGetStatesByType(
        StateType => [ $PendingReminderStateType, $PendingAutoStateType ],
        Result => 'ID',
    );

    if ( !@PendingStateIDs ) {
        return 1;
    }

    # update ticket table via DB driver.
    my $Success = $CommonObject->{DBObject}->Do(
        SQL => "UPDATE ticket SET until_time = 0 WHERE until_time > 0"
            . " AND ticket_state_id NOT IN (${\(join ', ', sort @PendingStateIDs)})",
    );

    return 1;
}

1;
