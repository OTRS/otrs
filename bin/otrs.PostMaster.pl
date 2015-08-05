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

## nofilter(TidyAll::Plugin::OTRS::Perl::BinScripts)
use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

# to get it readable for the web server user and writable for otrs
# group (just in case)

umask 007;

use Getopt::Std;
use Kernel::System::ObjectManager;

# get options
my %Opts;
getopt( 'qtd', \%Opts );
if ( $Opts{h} ) {
    print "otrs.PostMaster.pl - OTRS cmd postmaster\n";
    print "Copyright (C) 2001-2015 OTRS AG, http://otrs.com/\n";
    print
        "usage: otrs.PostMaster.pl -q <QUEUE> -t <TRUSTED> (default is trusted, use '-t 0' to disable trusted mode)\n";
    print "\notrs.PostMaster.pl is deprecated, please use console command 'Maint::PostMaster::Read' instead.\n\n";
    exit 1;
}
if ( !$Opts{d} ) {
    $Opts{d} = 0;
}
if ( !defined( $Opts{t} ) ) {
    $Opts{t} = 1;
}
if ( !$Opts{q} ) {
    $Opts{q} = '';
}

# create object manager
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.PostMaster.pl',
    },
);

# log the use of a deprecated script
$Kernel::OM->Get('Kernel::System::Log')->Log(
    Priority => 'error',
    Message  => "otrs.PostMaster.pl is deprecated, please use console command 'Maint::PostMaster::Read' instead.",
);

# convert arguments to console command format
my @Params;

if ( $Opts{q} ) {
    push @Params, '--target-queue';
    push @Params, $Opts{q};
}
if ( !$Opts{t} ) {
    push @Params, '--untrusted';
}
if ( $Opts{d} ) {
    push @Params, '--debug';
}

# execute console command
my $ExitCode = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::PostMaster::Read')->Execute(@Params);

exit $ExitCode;
