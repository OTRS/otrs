#!/usr/bin/perl
# --
# otrs.GenerateDashboardStats.pl - calculate stats caches for dashboard stats widgets
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

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std;
use Kernel::System::ObjectManager;

# get options
my %Opts;
getopt( 'hn', \%Opts );
if ( $Opts{h} ) {
    print <<EOF;
$0 - generate caches for dashboard stats widgets
Copyright (C) 2001-2013 OTRS AG, http://otrs.com/

Usage: $0 [-n number] [-f force] [-d debug]
EOF
    exit 1;
}

sub Run {
    local $Kernel::OM = Kernel::System::ObjectManager->new(
        LogObject => {
            LogPrefix => 'OTRS-otrs.GenerateDashboardStats.pl',
        },
        StatsObject => {
            UserID => 1,
        },
    );

    my %CommonObject = $Kernel::OM->ObjectHash(
        Objects => [qw(ConfigObject EncodeObject LogObject MainObject TimeObject DBObject PIDObject UserObject GroupObject StatsObject JSONObject)],
    );

    # create pid lock
    if ( !$Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => 'GenerateDashboardStats' ) ) {
        print
            "NOTICE: otrs.GenerateDashboardStats.pl is already running (use '-f 1' if you want to start it forced)!\n";
        exit 1;
    }
    elsif ( $Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => 'GenerateDashboardStats' ) ) {
        print "NOTICE: otrs.GenerateDashboardStats.pl is already running but is starting again!\n";
    }

    # set new PID
    $CommonObject{PIDObject}->PIDCreate(
        Name  => 'GenerateDashboardStats',
        Force => 1,
        TTL   => 60 * 60 * 24 * 3,
    );

    # get the list of stats that can be used in agent dashboards
    my $Stats = $CommonObject{StatsObject}->StatsListGet();

    STATID:
    for my $StatID ( sort keys %{ $Stats || {} } ) {

        my %Stat = %{ $Stats->{$StatID} || {} };

        next STATID if $Opts{n} && $Opts{n} ne $Stat{StatNumber};
        next STATID if !$Stat{ShowAsDashboardWidget};

        print "Stat $Stat{StatNumber}: $Stat{Title}\n";

        # now find out all users which have this statistic enabled in their dashboard
        my $DashboardActiveSetting = 'UserDashboard' . ( 1000 + $StatID ) . "-Stats";
        my %UsersWithActivatedWidget = $CommonObject{UserObject}->SearchPreferences(
            Key   => $DashboardActiveSetting,
            Value => 1,
        );

        my $UserWidgetConfigSetting
            = 'UserDashboardStatsStatsConfiguration' . ( 1000 + $StatID ) . "-Stats";

        # Calculate the cache for each user, if needed. If several users have the same settings
        #   for a stat, the cache will not be recalculated.
        USERID:
        for my $UserID ( sort keys %UsersWithActivatedWidget ) {

            # ignore invalid users
            my %UserData = $CommonObject{UserObject}->GetUserData(
                UserID        => $UserID,
                Valid         => 1,
                NoOutOfOffice => 1,
            );

            next USERID if !%UserData;

            print "    User: $UserData{UserLogin} ($UserID)\n";

            my $UserGetParam = {};
            if ( $UserData{$UserWidgetConfigSetting} ) {
                $UserGetParam = $CommonObject{JSONObject}->Decode(
                    Data => $UserData{$UserWidgetConfigSetting},
                );
            }

            # use an own object for the user to handle permissions correctly
            my $UserStatsObject = Kernel::System::Stats->new(
                %CommonObject,
                UserID => $UserID,
            );

            if ( $Opts{d} ) {
                print STDERR "DEBUG: user statistic configuration data:\n";
                print STDERR $CommonObject{MainObject}->Dump($UserGetParam);
            }

            # now run the stat to fill the cache with the current parameters
            my $Result = $UserStatsObject->StatsResultCacheCompute(
                StatID       => $StatID,
                UserGetParam => $UserGetParam,
            );

            if ( !$Result ) {
                print "        Stat calculation was not successful.\n";
            }
        }
    }

    # delete pid lock
    $CommonObject{PIDObject}->PIDDelete( Name => 'GenerateDashboardStats' );

    print "NOTICE: done.\n";
}

Run();

exit 0;
