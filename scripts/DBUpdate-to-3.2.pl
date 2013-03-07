#!/usr/bin/perl
# --
# DBUpdate-to-3.2.pl - update script to migrate OTRS 3.1.x to 3.2.x
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use vars qw($VERSION);
$VERSION = qw($Revision: 1.13 $) [1];

use Getopt::Std qw();
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Encode;
use Kernel::System::DB;
use Kernel::System::Main;
use Kernel::System::SysConfig;
use Kernel::System::Cache;
use Kernel::System::VariableCheck qw(:all);

{

    # get options
    my %Opts;
    Getopt::Std::getopt( 'h', \%Opts );

    if ( exists $Opts{h} ) {
        print <<"EOF";

DBUpdate-to-3.2.pl <Revision $VERSION> - Upgrade scripts for OTRS 3.1.x to 3.2.x migration.
Copyright (C) 2001-2011 OTRS AG, http://otrs.org/

EOF
        exit 1;
    }

    # UID check if not on Windows
    if ( $^O ne 'MSWin32' && $> == 0) { # $EFFECTIVE_USER_ID
        die "Cannot run this program as root. Please run it as the 'otrs' user.\n";
    }

    print "\nMigration started...\n\n";

    # create common objects
    my $CommonObject = _CommonObjectsBase();

    # define the number of steps
    my $Steps = 9;
    my $Step  = 1;

    print "Step $Step of $Steps: Refresh configuration cache... ";
    RebuildConfig($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    # check framework version
    print "Step $Step of $Steps: Check framework version... ";
    _CheckFrameworkVersion($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    print "Step $Step of $Steps: Cleanup UserPreferences... ";
    _CleanupUserPreferences($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    print "Step $Step of $Steps: Updating toolbar configuration... ";
    _MigrateToolbarConfig($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    print "Step $Step of $Steps: Updating AgentTicketZoom window configuration... ";
    _MigrateAgentTicketZoomWindowConfiguration($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    print "Step $Step of $Steps: Dropping obsolete columns from article_search... ";
    _DropArticleSearchColumns($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    print "Step $Step of $Steps: Migration cache backend configuration... ";
    _MigrateCacheConfiguration($CommonObject) || die;
    print "done.\n\n";
    $Step++;

    # Clean up the cache completely at the end.
    print "Step $Step of $Steps: Clean up the cache... ";
    my $CacheObject = Kernel::System::Cache->new( %{$CommonObject} ) || die;
    $CacheObject->CleanUp();
    print "done.\n\n";
    $Step++;

    print "Step $Step of $Steps: Refresh configuration cache another time... ";
    RebuildConfig($CommonObject) || die;
    print "done.\n\n";

    print "Migration completed!\n";

    exit 0;
}

sub _CommonObjectsBase {
    my %CommonObject;
    $CommonObject{ConfigObject} = Kernel::Config->new();
    $CommonObject{LogObject}    = Kernel::System::Log->new(
        LogPrefix => 'OTRS-DBUpdate-to-3.2',
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

    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );

    # Rebuild ZZZAAuto.pm with current values
    if ( !$SysConfigObject->WriteDefault() ) {
        die "ERROR: Can't write default config files!";
    }

    # Force a reload of ZZZAuto.pm and ZZZAAuto.pm to get the new values
    for my $Module ( sort keys %INC ) {
        if ( $Module =~ m/ZZZAA?uto\.pm$/ ) {
            delete $INC{$Module};
        }
    }

    # reload config object
    print
        "\nIf you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";
    $CommonObject = _CommonObjectsBase();

    return 1;
}

=item _CheckFrameworkVersion()

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
    if ( open( my $Product, '<', "$Home/RELEASE" ) ) {    ## no critic
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
    if ( $Version !~ /^3\.2(.*)$/ ) {
        die "Not framework version required"
    }

    return 1;
}

=item _CleanupUserPreferences()

cleanup obsolete user settings from DB.

=cut

sub _CleanupUserPreferences {
    my $CommonObject = shift;

    # Remove useless UserLastLoginTimestamp because UserLastLogin contains the same data.
    # With OTRS 3.2 we convert the data from UserLastLogin to UserLastLoginTimestamp automatically.

    my $CustomerPreferencesTable
        = $CommonObject->{ConfigObject}->Get('CustomerPreferences')->{Params}->{Table}
        || 'customer_preferences';

    my $CustomerPreferencesTableKey
        = $CommonObject->{ConfigObject}->Get('CustomerPreferences')->{Params}->{TableKey}
        || 'preferences_key';

    $CommonObject->{DBObject}->Do(
        SQL =>
            "DELETE FROM $CustomerPreferencesTable WHERE $CustomerPreferencesTableKey = 'UserLastLoginTimestamp'",
    );

    # Also remove UserLastPw because it contains unsalted md5 hashes.

    my $PreferencesTable = $CommonObject->{ConfigObject}->Get('PreferencesTable')
        || 'user_preferences';

    my $PreferencesTableKey = $CommonObject->{ConfigObject}->Get('PreferencesTableKey')
        || 'preferences_key';

    $CommonObject->{DBObject}->Do(
        SQL => "DELETE FROM $PreferencesTable WHERE $PreferencesTableKey = 'UserLastPw'",
    );

    return 1;
}

=item _MigrateToolbarConfig()

changes the module name of an existing toolbar module (TicketSearchFulltext).

=cut

sub _MigrateToolbarConfig {
    my $CommonObject = shift;

    my $ToolbarConfig = $CommonObject->{ConfigObject}->Get('Frontend::ToolBarModule');

    # Check if the the TicketSearchFulltext toolbar module is activated
    return 1 if !IsHashRefWithData($ToolbarConfig);
    return 1 if !IsHashRefWithData( $ToolbarConfig->{'10-Ticket::TicketSearchFulltext'} );

    # update to use the new generic module name
    $ToolbarConfig->{'10-Ticket::TicketSearchFulltext'}->{Module}
        = 'Kernel::Output::HTML::ToolBarGeneric';

    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );

    my $Success = $SysConfigObject->ConfigItemUpdate(
        Valid => 1,
        Key   => 'Frontend::ToolBarModule###10-Ticket::TicketSearchFulltext',
        Value => $ToolbarConfig->{'10-Ticket::TicketSearchFulltext'},
    );

    return $Success;
}

=item _MigrateAgentTicketZoomWindowConfiguration($CommonObject)

migrates the configuration of the dynamic fields in AgentTicketZoom to be
compatible with ProcessManagement new feature.

original field configration is set to the fields in the Sidebar

    _MigrateAgentTicketZoomWindowConfiguration($CommonObject);

=cut

sub _MigrateAgentTicketZoomWindowConfiguration {
    my $CommonObject = shift;

    # create a new SysConfigObject
    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );

    # Get the values to be set
    my $ExistingSetting = $CommonObject->{ConfigObject}->Get("Ticket::Frontend::AgentTicketZoom")
        || {};
    my %ValuesToSet = %{ $ExistingSetting->{DynamicField} || {} };

    # update configuration
    my $Success = $SysConfigObject->ConfigItemUpdate(
        Valid => 1,
        Key   => 'Ticket::Frontend::AgentTicketZoom###SidebarDynamicField',
        Value => \%ValuesToSet,
    );

    # print errors if any
    if ( !$Success ) {
        print "Could not migrate the config values on AgentTicketZoom window!\n";
        return 0;
    }

    return 1;
}

=item _DropArticleSearchColumns($CommonObject)

this will check if the table article_search has some obsolete columns that were forgotten
to drop for the migration to OTRS 3.1 but also absent from the 3.1 schema definition. So
on some systems (migrated from 3.0 or older) these will be present, on some not.

Therefore we first check if the columns are present, and then in a second step we will
drop them on the fly.

    _DropArticleSearchColumns($CommonObject);

=cut

sub _DropArticleSearchColumns {
    my $CommonObject = shift;

    my $ColumnExists;

    print
        "Check if columns exist.\n";

    {
        my $STDERR;

        # Catch STDERR log messages to not confuse the user. The Prepare() will fail
        #   if the columns are not present.
        local *STDERR;
        open STDERR, '>:utf8', \$STDERR;    ## no critic

        $ColumnExists = $CommonObject->{DBObject}->Prepare(
            SQL   => "SELECT a_freekey1 FROM article_search WHERE 1=0",
            Limit => 1,
        );
    }

    if ( !$ColumnExists ) {
        print "Columns are not present, no need to drop them.\n";
        return 1;
    }

    print "Columns found, drop them.\n";

    # fetch data to avoid warnings
    while ( my @Row = $CommonObject->{DBObject}->FetchrowArray() ) {

        # noop
    }

    my $XMLString = '
    <TableAlter Name="article_search">
        <ColumnDrop Name="a_freetext1"/>
        <ColumnDrop Name="a_freetext2"/>
        <ColumnDrop Name="a_freetext3"/>
        <ColumnDrop Name="a_freekey1"/>
        <ColumnDrop Name="a_freekey2"/>
        <ColumnDrop Name="a_freekey3"/>
    </TableAlter>';

    my @SQL;
    my @SQLPost;

    my $XMLObject = Kernel::System::XML->new( %{$CommonObject} );

    # create database specific SQL and PostSQL commands
    my @XMLARRAY = $XMLObject->XMLParse( String => $XMLString );

    # create database specific SQL
    push @SQL, $CommonObject->{DBObject}->SQLProcessor(
        Database => \@XMLARRAY,
    );

    # create database specific PostSQL
    push @SQLPost, $CommonObject->{DBObject}->SQLProcessorPost();

    # execute SQL
    for my $SQL ( @SQL, @SQLPost ) {
        print $SQL . "\n";
        my $Success = $CommonObject->{DBObject}->Do( SQL => $SQL );
        if ( !$Success ) {
            $CommonObject->{LogObject}->Log(
                Priority => 'error',
                Message  => "Error during execution of '$SQL'!",
            );
            return;
        }
    }
    return 1;
}

=item _MigrateCacheConfiguration($CommonObject)

disable legacy cache setting. CacheFileRaw was removed.

    _MigrateCacheConfiguration($CommonObject);

=cut

sub _MigrateCacheConfiguration {
    my $CommonObject = shift;

    # create a new SysConfigObject
    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );

    my $CacheModule = $CommonObject->{ConfigObject}->Get("Cache::Module");

    if ( $CacheModule eq 'Kernel::System::Cache::FileRaw' ) {

        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Cache::Module',
            Value => 'Kernel::System::Cache::FileStorable',
        );

        if ( !$Success ) {
            print "Could not migrate the config value Cache::Module!\n";
            return 0;
        }
    }

    return 1;
}

1;
