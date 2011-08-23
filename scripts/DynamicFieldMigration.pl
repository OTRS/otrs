#!/usr/bin/perl -w
# --
# DynamicFieldMigration.pl - update script to migrate OTRS 2.4.x to 3.0.x
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DynamicFieldMigration.pl,v 1.5 2011/01/10 14:54:12 ub Exp $
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
$VERSION = qw($Revision: 1.5 $) [1];

use Getopt::Std qw();
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::State;
use Kernel::System::SysConfig;
use Kernel::System::XML;

{

    # get options
    my %Opts;
    Getopt::Std::getopt( 'h', \%Opts );

    if ( exists $Opts{h} ) {
        print <<"EOF";

DynamicFieldMigration.pl <Revision $VERSION> - Database migration script for Dynamic Fields
Copyright (C) 2001-2011 OTRS AG, http://otrs.org/

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

    # check framework version
    print "Step 2 of 5: Check framework version... ";
    _CheckFrameworkVersion($CommonObject);
    print "done.\n\n";

    print "Step 3 of 5: Creating DynamicField tables (if necessary)... ";
    if ( CreateDynamicFieldTables($CommonObject) ) {
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
        LogPrefix => 'OTRS-DynamicFieldMigration',
        %CommonObject,
    );
    $CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
    $CommonObject{MainObject}   = Kernel::System::Main->new(%CommonObject);
    $CommonObject{DBObject}     = Kernel::System::DB->new(%CommonObject);
    $CommonObject{XMLObject}    = Kernel::System::XML->new(%CommonObject);
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

=item _CheckFrameworVersion()

Check if framework it's the correct one for Dinamic Fields migration.

    _CheckFrameworkVersion();

=cut

sub _CheckFrameworkVersion {
    my $CommonObject = shift;

    my $Home = $CommonObject->{ConfigObject}->Get('Home');

    # load RELEASE file
    if ( -e !"$Home/RELEASE" ) {
        die "ERROR: $Home/RELEASE does not exist!";
    }
    my $ProductName;
    my $Version;
    if ( open( my $Product, '<', "$Home/RELEASE" ) ) {
        while (<$Product>) {

            # filtering of comment lines
            if ( $_ !~ /^#/ ) {
                if ( $_ =~ /^PRODUCT\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $ProductName = $1;
                }
                elsif ( $_ =~ /^VERSION\s{0,2}=\s{0,2}(.*)\s{0,2}$/i ) {
                    $Version = $1;
                }
            }
        }
        close($Product);
    }
    else {
        die "ERROR: Can't read $CommonObject->{Home}/RELEASE: $!";
    }

    if ( $ProductName ne 'OTRS' ) {
        die "Not framework version required"
    }
    if ( $Version !~ /^3\.1(.*)$/ ) {
        die "Not framework version required"
    }

    return 1;
}

=item CreateDynamicFieldTables($CommonObject)

Checks if the DynamicField tables exist, and if they don't they will be created.

    CreateDynamicFieldTables($CommonObject);

=cut

sub CreateDynamicFieldTables {
    my $CommonObject = shift;

    # check if just with a SELECT query it's enough to verify
    # if the table already exist

    my $SuccessMaster = $CommonObject->{DBObject}->Do(
        SQL => 'SELECT count(id) FROM dynamic_field',
    );

    if ( !$SuccessMaster ) {
        die "Database command failed!";
    }

    # define the XML data for the DynamicField tables
    my @XMLStrings = (
        '
            <TableCreate Name="dynamic_field">
                <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
                <Column Name="name" Required="true" Type="VARCHAR" Size="200"/>
                <Column Name="label" Required="true" Type="VARCHAR" Size="200"/>
                <Column Name="field_type" Required="true" Type="VARCHAR" Size="200"/>
                <Column Name="object_type" Required="true" Type="VARCHAR" Size="200"/>
                <Column Name="config" Type="LONGBLOB"/>
                <Column Name="valid_id" Required="true" Type="SMALLINT"/>
                <Column Name="create_time" Required="true" Type="DATE"/>
                <Column Name="create_by" Required="true" Type="INTEGER"/>
                <Column Name="change_time" Required="true" Type="DATE"/>
                <Column Name="change_by" Required="true" Type="INTEGER"/>
                <Unique>
                    <UniqueColumn Name="name"/>
                </Unique>
                <ForeignKey ForeignTable="valid">
                    <Reference Local="valid_id" Foreign="id"/>
                </ForeignKey>
                <ForeignKey ForeignTable="users">
                    <Reference Local="create_by" Foreign="id"/>
                    <Reference Local="change_by" Foreign="id"/>
                </ForeignKey>
            </TableCreate>
        ', '
            <TableCreate Name="dynamic_field_value">
                <Column Name="field_id" Required="true" Type="INTEGER"/>
                <Column Name="object_type" Type="VARCHAR" Size="200"/>
                <Column Name="object_id" Required="true" Type="BIGINT"/>
                <Column Name="value_text" Required="false" Type="VARCHAR" Size="1800000" />
                <Column Name="value_date" Required="false" Type="DATE" />
                <Column Name="value_int" Required="false" Type="BIGINT" />
                <Index Name="index_object">
                    <IndexColumn Name="object_type"/>
                    <IndexColumn Name="object_id"/>
                </Index>
                <Index Name="index_search_date">
                    <IndexColumn Name="field_id"/>
                    <IndexColumn Name="value_date"/>
                </Index>
                <Index Name="index_search_int">
                    <IndexColumn Name="field_id"/>
                    <IndexColumn Name="value_int"/>
                </Index>
                <Unique>
                    <UniqueColumn Name="field_id"/>
                    <UniqueColumn Name="object_type"/>
                    <UniqueColumn Name="object_id"/>
                </Unique>
                <ForeignKey ForeignTable="dynamic_field">
                    <Reference Local="field_id" Foreign="id"/>
                </ForeignKey>
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

    # create tables
    for my $SQL (@SQL) {
        my $Success = $CommonObject->{DBObject}->Do( SQL => $SQL );
        if ( !$Success ) {
            $CommonObject->{LogObject}->Log(
                Priority => 'error',
                Message  => "Error during table creation!",
            );
            return;
        }
    }

    # create foreign keys
    for my $SQL (@SQLPost) {
        my $Success = $CommonObject->{DBObject}->Do( SQL => $SQL );
        if ( !$Success ) {
            $CommonObject->{LogObject}->Log(
                Priority => 'error',
                Message  => "Error during foreign key creation!",
            );
            return;
        }
    }

    return 1;
}

1;
