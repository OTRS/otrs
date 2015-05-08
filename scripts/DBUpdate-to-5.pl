#!/usr/bin/perl
# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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
use Kernel::System::VariableCheck qw(:all);

local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-DBUpdate-to-5.pl',
    },
);

{

    # get options
    my %Opts;
    Getopt::Std::getopt( 'h', \%Opts );

    if ( exists $Opts{h} ) {
        print <<"EOF";

DBUpdate-to-5.pl - Upgrade script for OTRS 4 to 5 migration.
Copyright (C) 2001-2015 OTRS AG, http://otrs.com/

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

    # define tasks and their mesages
    my @Tasks = (
        {
            Message => 'Refresh configuration cache',
            Command => \&RebuildConfig,
        },
        {
            Message => 'Check framework version',
            Command => \&_CheckFrameworkVersion,
        },
        {
            Message => 'Migrate toolbar configurations to the new module locations',
            Command => \&_MigrateConfigs,
        },
        {
            Message => 'Clean up the cache',
            Command => sub {
                $Kernel::OM->Get('Kernel::System::Cache')->CleanUp();
            },
        },
        {
            Message => 'Refresh configuration cache another time',
            Command => \&RebuildConfig,
        },
    );

    print "\nMigration started...\n\n";

    # get the number of total steps
    my $Steps = scalar @Tasks;
    my $Step  = 1;
    for my $Task (@Tasks) {

        # show task message
        print "Step $Step of $Steps: $Task->{Message}...";

        # run task command
        if ( &{ $Task->{Command} } ) {
            print "done.\n\n";
        }
        else {
            print "error.\n\n";
            die;
        }

        $Step++;
    }

    print "Migration completed!\n";

    exit 0;
}

=item RebuildConfig()

refreshes the configuration to make sure that a ZZZAAuto.pm is present
after the upgrade.

    RebuildConfig();

=cut

sub RebuildConfig {

    my $SysConfigObject = Kernel::System::SysConfig->new();

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
    print "\nIf you see warnings about 'Subroutine Load redefined', that's fine, no need to worry!\n";

    # create common objects with new default config
    $Kernel::OM->ObjectsDiscard();

    return 1;
}

=item _CheckFrameworkVersion()

Check if framework it's the correct one for Dynamic Fields migration.

    _CheckFrameworkVersion();

=cut

sub _CheckFrameworkVersion {
    my $Home = $Kernel::OM->Get('Kernel::Config')->Get('Home');

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
        die "Error: Can't read $Home/RELEASE: $!";
    }

    if ( $ProductName ne 'OTRS' ) {
        die "Error: No OTRS system found"
    }
    if ( $Version !~ /^5\.0(.*)$/ ) {

        die "Error: You are trying to run this script on the wrong framework version $Version!"
    }

    return 1;
}

=item _MigrateConfigs()

Change toolbar configurations to match the new module location.

    _MigrateConfigs();

=cut

sub _MigrateConfigs {

    # Toolbar Modules
    my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
    my $Setting         = $Kernel::OM->Get('Kernel::Config')->Get('Frontend::ToolBarModule');

    TOOLBARMODULE:
    for my $ToolbarModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$ToolbarModule}->{'Module'};
        if ($Module !~ m{Kernel::Output::HTML::ToolBar(\w+)}) {
            next TOOLBARMODULE;
        }

        $Module =~ s{Kernel::Output::HTML::ToolBar(\w+)}{Kernel::Output::HTML::ToolBar::$1}xmsg;
        $Setting->{$ToolbarModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###' . $ToolbarModule,
            Value => $Setting->{$ToolbarModule},
        );
    }

    # Ticket Menu Modules
    $Setting = $Kernel::OM->Get('Kernel::Config')->Get('Ticket::Frontend::MenuModule');

    MENUMODULE:
    for my $MenuModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$MenuModule}->{'Module'};
        if ($Module !~ m{Kernel::Output::HTML::TicketMenu(\w+)}) {
            next MENUMODULE;
        }

        $Module =~ s{Kernel::Output::HTML::TicketMenu(\w+)}{Kernel::Output::HTML::Ticket::Menu$1}xmsg;
        $Setting->{$MenuModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Frontend::MenuModule###' . $MenuModule,
            Value => $Setting->{$MenuModule},
        );
    }

    # Preferences groups
    $Setting = $Kernel::OM->Get('Kernel::Config')->Get('PreferencesGroups');

    PREFERENCEMODULE:
    for my $PreferenceModule ( sort keys %{$Setting} ) {

        # update module location
        my $Module = $Setting->{$PreferenceModule}->{'Module'};
        if ($Module !~ m{Kernel::Output::HTML::Preferences(\w+)}) {
            next PREFERENCEMODULE;
        }

        $Module =~ s{Kernel::Output::HTML::Preferences(\w+)}{Kernel::Output::HTML::Preferences::$1}xmsg;
        $Setting->{$PreferenceModule}->{'Module'} = $Module;

        # set new setting,
        my $Success = $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'PreferencesGroups###' . $PreferenceModule,
            Value => $Setting->{$PreferenceModule},
        );
    }

    # SLA, Service and Queue preferences
    for my $Type (qw(SLA Service Queue)) {

        $Setting = $Kernel::OM->Get('Kernel::Config')->Get($Type . 'Preferences');

        MODULE:
        for my $PreferenceModule ( sort keys %{$Setting} ) {

            # update module location
            my $Module = $Setting->{$PreferenceModule}->{'Module'};
            my $Regex  = 'Kernel::Output::HTML::' . $Type . 'Preferences(\w+)';
            if ($Module !~ m{$Regex}) {
                next MODULE;
            }

            $Module =~ s{$Regex}{Kernel::Output::HTML::${Type}Preferences::$1}xmsg;
            $Setting->{$PreferenceModule}->{'Module'} = $Module;

            # set new setting,
            my $Success = $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => $Type . 'Preferences###' . $PreferenceModule,
                Value => $Setting->{$PreferenceModule},
            );
        }
    }

    return 1;
}

1;
