#!/usr/bin/perl
# --
# bin/otrs.SupportBundle.pl - creates a bundle of support information
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
use Kernel::System::SupportBundleGenerator;

sub Run {

    local $Kernel::OM = $Kernel::OM = Kernel::System::ObjectManager->new(
        ConfigObject => {
            LogPrefix => 'OTRS-otrs.SupportBundle.pl',
        },
    );

    # Refresh common objects after a certain number of loop iterations.
    #   This will call event handlers and clean up caches to avoid excessive mem usage.
    my $CommonObjectRefresh = 50;

    # get options
    my %Opts = ();
    getopt( 'ho', \%Opts );
    if ( $Opts{h} ) {
        print <<EOF;
otrs.SuppportBundle.pl - creates a bundle of support information
Copyright (C) 2001-2014 OTRS AG, http://otrs.org/

usage: otrs.SuppportBundle.pl -o <Path> (Optional)

    Examples:
    otrs.SuppportBundle.pl
    otrs.SuppportBundle.pl -o /opt/otrs
EOF
        exit 1;
    }

    my $Response = $Kernel::OM->Get('Kernel::System::SupportBundleGenerator')->Generate();

    if ( $Response->{Success} ) {

        my $FileData = $Response->{Data};

        my $OutputDir = $Kernel::OM->Get('Kernel::Config')->Get('Home');
        if ( $Opts{o} ) {
            $OutputDir = $Opts{o};
            $OutputDir =~ s{\/\z}{};
        }

        my $FileLocation = $Kernel::OM->Get('Kernel::System::Main')->FileWrite(
            Location   => $OutputDir . '/' . $FileData->{Filename},
            Content    => $FileData->{Filecontent},
            Mode       => 'binmode',
            Permission => '644',
        );

        if ($FileLocation) {
            print "\nSupport Bundle saved to: $FileLocation\n";
        }
        else {
            $Kernel::OM->Get('Kernel::System::Log')->Log(
                Priority => 'error',
                Message  => "Support Bundle could not be written!",
            );
        }

        exit 1;
    }
}

Run();

exit 0;
