#!/usr/bin/perl -w
# --
# DBUpdate-to-3.2.pl - update script to migrate OTRS 3.1.x to 3.2.x
# Copyright (C) 2001-2012 OTRS AG, http://otrs.org/
# --
# $Id: DBUpdate-to-3.2.pl,v 1.4 2012-09-14 12:09:54 mg Exp $
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
$VERSION = qw($Revision: 1.4 $) [1];

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

    print "\nMigration started...\n\n";

    # create common objects
    my $CommonObject = _CommonObjectsBase();

    # define the number of steps
    my $Steps = 6;

    print "Step 1 of $Steps: Refresh configuration cache... ";
    RebuildConfig($CommonObject);
    print "done.\n\n";

    # create common objects with new default config
    $CommonObject = _CommonObjectsBase();

    # check framework version
    print "Step 2 of $Steps: Check framework version... ";
    _CheckFrameworkVersion($CommonObject);
    print "done.\n\n";

    print "Step 3 of $Steps: Cleanup UserPreferences... ";
    _CleanupUserPreferences($CommonObject);
    print "done.\n\n";

    print "Step 4 of $Steps: Updating toolbar configuration... ";
    _MigrateToolbarConfig($CommonObject);
    print "done.\n\n";

    # Clean up the cache completely at the end.
    print "Step 5 of $Steps: Clean up the cache... ";
    my $CacheObject = Kernel::System::Cache->new( %{$CommonObject} );
    $CacheObject->CleanUp();
    print "done.\n\n";

    print "Step 6 of $Steps: Refresh configuration cache another time... ";
    RebuildConfig($CommonObject);
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
    for my $Module ( keys %INC ) {
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
    if ( $Version !~ /^3\.2(.*)$/ ) {
        die "Not framework version required"
    }

    return 1;
}

=item _CleanupUserPreferences()

remove useless UserLastLoginTimestamp because UserLastLogin contains the same data.
With OTRS 3.2 we convert the data from UserLastLogin to UserLastLoginTimestamp automatically.

=cut

sub _CleanupUserPreferences {
    my $CommonObject = shift;

    $CommonObject->{DBObject}->Do(
        SQL => "DELETE FROM customer_preferences WHERE preferences_key = 'UserLastLoginTimestamp'",
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

1;
