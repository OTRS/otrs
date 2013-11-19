#!/usr/bin/perl -w
# --
# DBUpdate-to-3.0.pl - update script to migrate OTRS 2.4.x to 3.0.x
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: DBUpdate-to-3.0.pl,v 1.5.2.1 2011-12-05 11:09:17 ub Exp $
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use vars qw($VERSION);
$VERSION = qw($Revision: 1.5.2.1 $) [1];

use Getopt::Std qw();
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::State;
use Kernel::System::SysConfig;
use Kernel::System::Package;
use Kernel::System::XML;

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

    print "Step 1 of 5: Refresh configuration cache... ";
    RebuildConfig($CommonObject);
    print "done.\n\n";

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    print "Step 2 of 5: Migrating theme configuration... ";
    MigrateThemes($CommonObject);
    print "done.\n\n";

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    print "Step 3 of 5: Cleaning up the permission table... ";
    PermissionTableCleanup($CommonObject);
    print "done.\n\n";

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    print "Step 4 of 5: Cleanup pending time of tickets without pending state-type... ";
    RemovePendingTime($CommonObject);
    print "done.\n\n";

    print "Step 5 of 5: Creating VirtualFS tables (if necessary)... ";
    if ( CreateVirtualFSTables($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "Error!\n\n";
    }

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
    $CommonObject{EncodeObject}  = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{MainObject}    = Kernel::System::Main->new(%CommonObject);
    $CommonObject{TimeObject}    = Kernel::System::Time->new(%CommonObject);
    $CommonObject{DBObject}      = Kernel::System::DB->new(%CommonObject);
    $CommonObject{PackageObject} = Kernel::System::Package->new(%CommonObject);
    $CommonObject{XMLObject}     = Kernel::System::XML->new(%CommonObject);
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

=item CreateVirtualFSTables($CommonObject)

Checks if the VirtualFS tables exist, and if they don't they will be created.

    CreateVirtualFSTables($CommonObject);

=cut

sub CreateVirtualFSTables {
    my $CommonObject = shift;

    # get list of all installed packages
    my @RepositoryList = $CommonObject->{PackageObject}->RepositoryList();

    # check if the VirtualFS tables already exist,
    # by checking if ITSMCore 1.3.91 or higher is installed
    my $VirtualFSTablesExist;

    PACKAGE:
    for my $Package (@RepositoryList) {

        # package is not the ITSMCore package
        next PACKAGE if $Package->{Name}->{Content} ne 'ITSMCore';

        # check if the ITSMCore version version is at least 1.3.91 or higher
        # that means that the VirtualFS tables exist already
        $VirtualFSTablesExist = _CheckVersion(
            $CommonObject,
            Version1 => '1.3.91',
            Version2 => $Package->{Version}->{Content},
            Type     => 'Min',
        );
    }

    # VirtualFS tables exist, so we do not have to create them here
    return 1 if $VirtualFSTablesExist;

    # define the XML data for the VirtualFS tables
    my @XMLStrings = (
        '
            <TableCreate Name="virtual_fs">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT"/>
                <Column Name="filename" Required="true" Size="350" Type="VARCHAR"/>
                <Column Name="backend" Required="true" Size="60" Type="VARCHAR"/>
                <Column Name="backend_key" Required="true" Size="160" Type="VARCHAR"/>
                <Column Name="create_time" Required="true" Type="DATE"/>
                <Index Name="virtual_fs_filename">
                    <IndexColumn Name="filename" Size="350"/>
                </Index>
                <Index Name="virtual_fs_backend">
                    <IndexColumn Name="backend" Size="60"/>
                </Index>
            </TableCreate>
        ', '
            <TableCreate Name="virtual_fs_preferences">
                <Column Name="virtual_fs_id" Required="true" Type="BIGINT"/>
                <Column Name="preferences_key" Required="true" Size="150" Type="VARCHAR"/>
                <Column Name="preferences_value" Required="false" Size="350" Type="VARCHAR"/>
                <Index Name="virtual_fs_preferences_virtual_fs_id">
                    <IndexColumn Name="virtual_fs_id"/>
                </Index>
                <Index Name="virtual_fs_preferences_key_value">
                    <IndexColumn Name="preferences_key"/>
                    <IndexColumn Name="preferences_value" Size="150"/>
                </Index>
                <ForeignKey ForeignTable="virtual_fs">
                    <Reference Local="virtual_fs_id" Foreign="id"/>
                </ForeignKey>
            </TableCreate>
        ', '
            <TableCreate Name="virtual_fs_db">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT"/>
                <Column Name="filename" Required="true" Size="350" Type="VARCHAR"/>
                <Column Name="content" Required="true" Type="LONGBLOB"/>
                <Column Name="create_time" Required="true" Type="DATE"/>
                <Index Name="virtual_fs_db_filename">
                    <IndexColumn Name="filename" Size="350"/>
                </Index>
            </TableCreate>
        ',
    );

    my @SQL;
    my @SQLPost;

    # create database specific SQL and PostSQL commands
    for my $XMLString (@XMLStrings) {

        # parse the XML string
        my @XMLARRAY = $CommonObject->{XMLObject}->XMLParse( String => $XMLString );

        # create database specific SQL
        push @SQL, $CommonObject->{DBObject}->SQLProcessor(
            Database => \@XMLARRAY,
        );

        # create database specific PostSQL
        push @SQLPost, $CommonObject->{DBObject}->SQLProcessorPost();
    }

    # create tables (continue on error)
    my $Error;
    for my $SQL (@SQL) {
        my $Success = $CommonObject->{DBObject}->Do( SQL => $SQL );
        if ( !$Success ) {
            $CommonObject->{LogObject}->Log(
                Priority => 'error',
                Message  => "Error during table creation!",
            );
            $Error = 1;
        }
    }

    # create foreign keys (continue on error)
    for my $SQL (@SQLPost) {
        my $Success = $CommonObject->{DBObject}->Do( SQL => $SQL );
        if ( !$Success ) {
            $CommonObject->{LogObject}->Log(
                Priority => 'error',
                Message  => "Error during foreign key creation!",
            );
            $Error = 1;
        }
    }

    # error
    return if $Error;

    # success
    return 1;
}

=item _CheckVersion()

checks if Version2 is at least Version1

    my $Result = _CheckVersion(
        $CommonObject,
        Version1 => '1.3.1',
        Version2 => '1.2.4',
        Type     => 'Min',
    );

=cut

sub _CheckVersion {
    my ( $CommonObject, %Param ) = @_;

    # check needed stuff
    for (qw(Version1 Version2 Type)) {
        if ( !defined $Param{$_} ) {
            $CommonObject->{LogObject}->Log(
                Priority => 'error',
                Message  => "$_ not defined!",
            );
            return;
        }
    }
    for my $Type (qw(Version1 Version2)) {
        my @Parts = split( /\./, $Param{$Type} );
        $Param{$Type} = 0;
        for ( 0 .. 4 ) {
            if ( defined $Parts[$_] ) {
                $Param{$Type} .= sprintf( "%04d", $Parts[$_] );
            }
            else {
                $Param{$Type} .= '0000';
            }
        }
        $Param{$Type} = int( $Param{$Type} );
    }
    if ( $Param{Type} eq 'Min' ) {
        return 1 if ( $Param{Version2} >= $Param{Version1} );
        return;
    }
    elsif ( $Param{Type} eq 'Max' ) {
        return 1 if ( $Param{Version2} < $Param{Version1} );
        return;
    }

    $CommonObject->{LogObject}->Log(
        Priority => 'error',
        Message  => 'Invalid Type!',
    );
    return;
}

1;
