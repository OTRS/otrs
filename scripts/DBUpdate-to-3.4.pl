#!/usr/bin/perl
# --
# DBUpdate-to-3.4.pl - update script to migrate OTRS 3.3.x to 3.4.x
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';

use Getopt::Std qw();
use Kernel::Config;
use Kernel::System::ObjectManager;
use Kernel::System::SysConfig;
use Kernel::System::Cache;
use Kernel::System::Package;
use Kernel::System::VariableCheck qw(:all);

local $Kernel::OM = Kernel::System::ObjectManager->new(
    LogObject => {
        LogPrefix => 'OTRS-DBUpdate-to-3.4.pl',
    },
);

{

    # get options
    my %Opts;
    Getopt::Std::getopt( 'h', \%Opts );

    if ( exists $Opts{h} ) {
        print <<"EOF";

DBUpdate-to-3.4.pl - Upgrade scripts for OTRS 3.3.x to 3.4.x migration.
Copyright (C) 2001-2013 OTRS AG, http://otrs.com/

Usage: $0 [-h]
    Options are as follows:
        -h      display this help

EOF
        exit 1;
    }

    # UID check if not on Windows
    if ( $^O ne 'MSWin32' && $> == 0 ) {    # $EFFECTIVE_USER_ID
        die "
Cannot run this program as root.
Please run it as the 'otrs' user or with the help of su:
    su -c \"$0\" -s /bin/bash otrs
";
    }

    # enable autoflushing of STDOUT
    $| = 1;                                 ## no critic

    print "\nMigration started...\n\n";

    # create common objects
    my $CommonObject = _CommonObjectsBase();

    # define the number of steps
    my $Steps = 6;
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

    # migrate FontAwesome
    print "Step $Step of $Steps: Migrate FontAwesome icons... ";
    if ( _MigrateFontAwesome($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "error.\n\n";
        die;
    }
    $Step++;

    # uninstall Merged Feature Add-Ons
    print "Step $Step of $Steps: Uninstall Merged Feature Add-Ons... ";
    if ( _UninstallMergedFeatureAddOns($CommonObject) ) {
        print "done.\n\n";
    }
    else {
        print "error.\n\n";
        die;
    }
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
    my %CommonObject = $Kernel::OM->ObjectHash(
        Objects =>
            [
            qw(ConfigObject EncodeObject LogObject MainObject TimeObject DBObject SysConfigObject)
            ],
    );
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
        die "Error: Can't write default config files!";
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
        die "Error: $Home/RELEASE does not exist!";
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
        die "Error: Can't read $CommonObject->{Home}/RELEASE: $!";
    }

    if ( $ProductName ne 'OTRS' ) {
        die "Error: No OTRS system found"
    }
    if ( $Version !~ /^3\.4(.*)$/ ) {

        die "Error: You are trying to run this script on the wrong framework version $Version!"
    }

    return 1;
}

=item _MigrateFontAwesome()

Migrate settings that has changed it name.

    _MigrateFontAwesome($CommonObject);

=cut

sub _MigrateFontAwesome {
    my $CommonObject = shift;

    my $SysConfigObject = Kernel::System::SysConfig->new( %{$CommonObject} );

    # update toolbar items settings
    # otherwise the new fontawesome icons won't be displayed

    # collect icon data for toolbar items
    my %ModuleAttributes = (
        '1-Ticket::AgentTicketQueue' => {
            'Icon' => 'fa fa-folder',
        },
        '2-Ticket::AgentTicketStatus' => {
            'Icon' => 'fa fa-list-ol',
        },
        '3-Ticket::AgentTicketEscalation' => {
            'Icon' => 'fa fa-exclamation',
        },
        '4-Ticket::AgentTicketPhone' => {
            'Icon' => 'fa fa-phone',
        },
        '5-Ticket::AgentTicketEmail' => {
            'Icon' => 'fa fa-envelope',
        },
        '6-Ticket::AgentTicketProcess' => {
            'Icon' => 'fa fa-th-large',
        },
        '6-Ticket::TicketResponsible' => {
            'Icon'        => 'fa fa-user',
            'IconNew'     => 'fa fa-user',
            'IconReached' => 'fa fa-user',
        },
        '7-Ticket::TicketWatcher' => {
            'Icon'        => 'fa fa-eye',
            'IconNew'     => 'fa fa-eye',
            'IconReached' => 'fa fa-eye',
        },
        '8-Ticket::TicketLocked' => {
            'Icon'        => 'fa fa-lock',
            'IconNew'     => 'fa fa-lock',
            'IconReached' => 'fa fa-lock',
        },
    );

    my $Setting = $CommonObject->{ConfigObject}->Get('Frontend::ToolBarModule');

    TOOLBARMODULE:
    for my $ToolbarModule ( sort keys %ModuleAttributes ) {

        next TOOLBARMODULE if !IsHashRefWithData( $Setting->{$ToolbarModule} );

        # set icon and class infos
        for my $Attribute ( sort keys %{ $ModuleAttributes{$ToolbarModule} } ) {
            $Setting->{$ToolbarModule}->{$Attribute}
                = $ModuleAttributes{$ToolbarModule}->{$Attribute};
        }

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###' . $ToolbarModule,
            Value => $Setting->{$ToolbarModule},
        );
    }

    return 1;
}

=item _UninstallMergedFeatureAddOns()

safe uninstall packages from the database.

    UninstallMergedFeatureAddOns($CommonObject);

=cut

sub _UninstallMergedFeatureAddOns {
    my $CommonObject = shift;

    my $PackageObject = Kernel::System::Package->new( %{$CommonObject} );

    # qw( ) contains a list of the feature add-ons to uninstall
    for my $PackageName (
        qw(
        OTRSGenericInterfaceREST
        )
        )
    {
        my $Success = $PackageObject->_PackageUninstallMerged(
            Name => $PackageName,
        );
        if ( !$Success ) {
            print STDERR "There was an error uninstalling package $PackageName\n";
            return;
        }
    }
    return 1;
}

1;
