#!/usr/bin/perl
# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see https://www.gnu.org/licenses/gpl-3.0.txt.
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
    print <<EOF;

Read incoming email from STDIN.

Usage:
 otrs.PostMaster.pl -q <QUEUE> -t <TRUSTED>

Options:
 [-d]                   - Set debug mode.
 [-q] <QUEUE>           - Preselect a target queue by name.
 [-t] <TRUSTED>         - Default is trusted, use '-t 0' to disable trusted mode. This will cause X-OTRS email headers to be ignored.
 [-h]                   - Display help for this command.

Help:
DEPRECATED. This console command is deprecated, please use 'Maint::PostMaster::Read' instead.

 otrs.Console.pl Maint::PostMaster::Read [--target-queue ...] [--untrusted]

EOF
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
