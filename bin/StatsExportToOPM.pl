#!/usr/bin/perl -w
# --
# StatsExportToOPM.pl - export all stats of a system and create a package for the package manager
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: StatsExportToOPM.pl,v 1.6 2007-09-29 11:41:28 mh Exp $
# --
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
# --

# Remark: You have to install this programm in $OTRS_HOME/bin of the OTRS 2.0
# installation

# ---------------------------------------------------------- #
# get needed objects and settings
# ---------------------------------------------------------- #

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . "/Kernel/cpan-lib";

use strict;
use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Time;
use Kernel::System::Stats;
use Kernel::System::Group;
use Kernel::System::User;
use Kernel::System::Package;

# get file version
use vars qw($VERSION $Debug);
$VERSION = qw($Revision: 1.6 $) [1];

# common objects
my %CommonObject = ();
$CommonObject{UserID}       = 1;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-StatsStatsExportToOPM.pl',
    %CommonObject,
);
$CommonObject{MainObject}    = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject}    = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject}      = Kernel::System::DB->new(%CommonObject);
$CommonObject{UserObject}    = Kernel::System::User->new(%CommonObject);
$CommonObject{GroupObject}   = Kernel::System::Group->new(%CommonObject);
$CommonObject{StatsObject}   = Kernel::System::Stats->new(%CommonObject);
$CommonObject{PackageObject} = Kernel::System::Package->new(%CommonObject);

# ---------------------------------------------------------- #
# get options and params
# ---------------------------------------------------------- #

my %Opts           = ();
my $PackageName    = 'StatsExportToOPM';
my $PackageVersion = '1.0.0';
my $DeleteStats    = 0;

getopt( 'dhvn', \%Opts );

# check needed params
if ( $Opts{'h'} ) {
    print
        "StatsExportToOPM.pl <Revision $VERSION> - export all stats of a system and create a package for the package manager\n";
    print "Copyright (c) 2001-2006 OTRS GmbH, http//otrs.org/\n";
    print "usage: StatsExportToOPM.pl [-n <PACKAGE_NAME>] [-v <PACKAGE_VERSION>]\n";
    print
        "       [-d 'yes' for delete existing stats if the opm will be installed] [-h for help]\n";
    exit 1;
}
if ( $Opts{'n'} ) {
    $PackageName = $Opts{'n'};
}
if ( $Opts{'v'} ) {
    $PackageVersion = $Opts{'v'};
}
if ( $Opts{'d'} && $Opts{'d'} eq 'yes' ) {
    $DeleteStats = 1;
}

# ---------------------------------------------------------- #
# check if needed directories are available
# ---------------------------------------------------------- #

my $Directory = $CommonObject{ConfigObject}->Get('Home') . "/var/";
if ( !opendir( DIR, $Directory ) ) {
    print "Can not open Directory: $Directory/";
    exit(1);
}
my $StatsFlag = 0;
my $OPMFlag   = 0;
while ( defined( my $Filename = readdir DIR ) ) {
    if ( -d "$Directory$Filename" ) {
        if ( $Filename eq 'Stats' ) {
            $StatsFlag = 1;
        }
        elsif ( $Filename eq 'OPM' ) {
            $OPMFlag = 1;
        }
    }
}
closedir(DIR);

if ( !$StatsFlag ) {
    system( "mkdir " . $Directory . "Stats" );
    print "Created Stats directory!\n";
}

if ( !$OPMFlag ) {
    system( "mkdir " . $Directory . "OPM" );
    print "Created OPM directory!\n";
}

# ---------------------------------------------------------- #
# get all configured stats and export them
# ---------------------------------------------------------- #

# get all stats of the system

my $StatsListRef  = $CommonObject{StatsObject}->GetStatsList();
my %FileListcheck = ();
my @Filelist      = ();
for my $StatID ( @{$StatsListRef} ) {

    # use Stats export function
    my $File = $CommonObject{StatsObject}->Export(
        StatID           => $StatID,
        ExportStatNumber => $DeleteStats,

        # $DeleteStats, because if one delete the statistics he want to
        # insert the new stats in the same row. For example because of the used
        # Cronjobs
    );

    # double check
    if ( $FileListcheck{ $File->{Filename} } ) {
        print "\nThe same stats title is used more than one time (Filename: $File->{Filename})!\n";
        $File->{Filename} =~ s/.xml$/I.xml/;
        print "\nTherefore the filename is renamed to '$File->{Filename}'\n";
    }

    $FileListcheck{ $File->{Filename} } = $StatID;

    # write data in filesystem
    my $FullFilename = $CommonObject{ConfigObject}->Get('Home') . "/var/Stats/" . $File->{Filename};
    push( @Filelist, $File->{Filename} );
    if ( !open( OUT, "> $FullFilename" ) ) {
        print "\nCan't create $FullFilename!\n";
    }
    else {
        print OUT $File->{Content};
        close(OUT);
        print "\n$FullFilename successful created!\n";
    }
}

# ---------------------------------------------------------- #
# build the package
# ---------------------------------------------------------- #

my %OPMS = ();
my ( $s, $m, $h, $D, $M, $Y )
    = $CommonObject{TimeObject}
    ->SystemTime2Date( SystemTime => $CommonObject{TimeObject}->SystemTime(), );

$OPMS{Version}{Content}   = $PackageVersion;
$OPMS{Name}{Content}      = $PackageName;
$OPMS{Framework}{Content} = '2.2.x';
$OPMS{Vendor}{Content}    = 'OTRS GmbH';
$OPMS{URL}{Content}       = 'http://otrs.org/';
$OPMS{License}{Content}   = 'GNU GENERAL PUBLIC LICENSE Version 2, June 1991';
$OPMS{ChangeLog}{Content} = "$Y-$M-$D Created per StatsExportToOPM.pl";
$OPMS{Description}[0]{Content}
    = 'Ein Modul um ein Paket mit allen Statistiken eines Systems zu generieren.';
$OPMS{Description}[0]{Lang}    = 'de';
$OPMS{Description}[1]{Content} = 'A module to make a package with all stats of an system.';
$OPMS{Description}[1]{Lang}    = 'en';

# build file list
my $FileListString = '';
for (@Filelist) {
    my %Hash = ();
    $Hash{Location}   = "var/Stats/" . $_;
    $Hash{Permission} = '644';
    push( @{ $OPMS{Filelist} }, \%Hash );
    $FileListString .= " $_";
}

# prepare code install settings

$OPMS{CodeInstall}{Content} = '
require Kernel::System::Stats;
require Kernel::System::Group;
require Kernel::System::User;

$Self-&gt;{UserID} = 1;
$Self-&gt;{GroupObject} = Kernel::System::Group-&gt;new(%{$Self});
$Self-&gt;{UserObject}  = Kernel::System::User-&gt;new(%{$Self});
$Self-&gt;{StatsObject} = Kernel::System::Stats-&gt;new(%{$Self});

# delete the exitsting stats db
my $Delete = ' . $DeleteStats . ';

if ($Delete) {
    my $StatsListRef = $Self-&gt;{StatsObject}-&gt;GetStatsList();
   for my $StatID (@{$StatsListRef}) {
        $Self-&gt;{StatsObject}-&gt;StatsDelete(StatID => $StatID);
    }

for my $FileString (qw(' . $FileListString . ')) {
    my $File = $Self-&gt;{ConfigObject}-&gt;Get(\'Home\')."/var/Stats/$FileString";
    my $Content = \'\';
    if (open(IN, "&lt; $File")) {
        # set bin mode
        #binmode IN;
        while (&lt;IN&gt;) {
            $Content .= $_;
        }
        close (IN);
    }
    else {
        die "Can\'t open: $File: $!";
    }
    my $StatID = $Self-&gt;{StatsObject}-&gt;Import(Content  => $Content);
}

';

# save the package
my $File = $CommonObject{ConfigObject}->Get('Home')
    . "/var/OPM/$PackageName-$OPMS{Version}{Content}.opm";
if ( open( OUT, "> $File" ) ) {
    print "Writing $File\n";
    print OUT $CommonObject{PackageObject}->PackageBuild(%OPMS);
    close(OUT);
    exit 1;
}
else {
    print STDERR "ERROR: Can't write $File\n";
    exit;
}

1;
