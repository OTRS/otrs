#!/usr/bin/perl -w
# --
# StatsMigration2.0to2.1.pl - make stats of otrs 2.0 fit for otrs 2.1
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: StatsMigration2_0To2_1.pl,v 1.1.2.1 2006-12-06 16:21:04 tr Exp $
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
use lib dirname($RealBin) . "/../";
use lib dirname($RealBin) . "/../Kernel/cpan-lib";

use strict;
use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::Time;
use Kernel::System::XML;
use Kernel::System::Encode;
use MIME::Base64;
use Kernel::System::Package;

# get file version
use vars qw($VERSION $Debug);
$VERSION = '$Revision: 1.1.2.1 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-StatsMigration2.0to2.1opm',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{PackageObject} = Kernel::System::Package->new(%CommonObject);
$CommonObject{XMLObject} = Kernel::System::XML->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);

# ---------------------------------------------------------- #
# get options and params
# ---------------------------------------------------------- #

my %Opts = ();
my $PackageName    = 'StatsMigration2.0to2.1';
my $PackageVersion = '1.0.0';
my $DefaulGroup    = 'stats';

getopt('hgvn', \%Opts);

# check needed params
if ($Opts{'h'}) {
    print "StatsMigration2.0to2.1.pl <Revision $VERSION> - make stats of OTRS 2.0 fit for OTRS 2.1\n";
    print "Copyright (c) 2001-2006 OTRS GmbH, http//otrs.org/\n";
    print "usage: StatsMigration2.0to2.1.pl [-n <PACKAGE_NAME>] [-v <PACKAGE_VERSION>]\n";
    print "       [-g <DEFAULT_GROUP>] [-h for help]\n";
    exit 1;
}
if ($Opts{'n'}) {
    $PackageName = $Opts{'n'};
}
if ($Opts{'v'}) {
    $PackageVersion = $Opts{'v'};
}
if ($Opts{'g'}) {
    $DefaulGroup = $Opts{'g'};
}

# ---------------------------------------------------------- #
# check if needed directories are available
# ---------------------------------------------------------- #

my $Directory = $CommonObject{ConfigObject}->Get('Home')."/var/";
if (!opendir(DIR, $Directory)) {
    print "Can not open Directory: $Directory/";
    exit (1);
}
my $StatsFlag = 0;
my $OPMFlag = 0;
while (defined (my $Filename = readdir DIR)) {
    if (-d "$Directory$Filename") {
        if ($Filename eq 'Stats') {
            $StatsFlag = 1;
        }
        elsif ($Filename eq 'OPM') {
            $OPMFlag = 1;
        }
    }
}
closedir(DIR);

if (!$StatsFlag) {
    system ("mkdir " . $Directory . "Stats");
    print "Created Stats directory!\n";
}

if (!$OPMFlag) {
    system ("mkdir " . $Directory . "OPM");
    print "Created OPM directory!\n";
}

# ---------------------------------------------------------- #
# get all configured stats and export them
# ---------------------------------------------------------- #

# get the SysConfig configuration of the stats
my %Config = %{$CommonObject{ConfigObject}->Get('SystemStatsMap')};
my @Filelist = ();

# export each stats as xml file in var/Stats
foreach my $Stats (sort keys %Config) {
    my %File  = ();
    my @XMLHash = ();
    my $ObjectModule = $Config{$Stats}{Module};
    $ObjectModule =~ s/Stats::/Stats::Static::/;
    # convert the config settings
    $XMLHash[0]->{otrs_stats}[1]{Title}[1]{Content} = $Config{$Stats}{Name};
    $XMLHash[0]->{otrs_stats}[1]{Description}[1]{Content} = $Config{$Stats}{Desc};
    $XMLHash[0]->{otrs_stats}[1]{StatType}[1]{Content} = 'static';
    $XMLHash[0]->{otrs_stats}[1]{ObjectModule}[1]{Content} = $ObjectModule;
    $XMLHash[0]->{otrs_stats}[1]{Cache}[1]{Content} = $Config{$Stats}{UseResultCache} || 0;
    $XMLHash[0]->{otrs_stats}[1]{Permission}[1]{Content} = $DefaulGroup;
    $XMLHash[0]->{otrs_stats}[1]{SumCol}[1]{Content} = $Config{$Stats}{SumCol} || 0;
    $XMLHash[0]->{otrs_stats}[1]{SumRow}[1]{Content} = $Config{$Stats}{SumRow} || 0;
    $XMLHash[0]->{otrs_stats}[1]{Valid}[1]{Content} = 1;
    # build the format settings
    my $Counter = 0;
    foreach my $Format (@{$Config{$Stats}{Output}}) {
        $Counter++;
        if ($Format eq 'Graph') {
            $XMLHash[0]->{otrs_stats}[1]{Format}[$Counter]{Content} = 'GD::Graph::lines';
        }
        elsif ($Format eq 'GraphBars') {
            $XMLHash[0]->{otrs_stats}[1]{Format}[$Counter]{Content} = 'GD::Graph::bars';
        }
        else {
            $XMLHash[0]->{otrs_stats}[1]{Format}[$Counter]{Content} = $Format;
        }
    }

    # convert and prepair the static file
    $File{Filename} = StringAndTimestamp2Filename($Stats) . '.xml';

    # settings for static files
    my $FileLocation = $Config{$Stats}{Module};
    $FileLocation =~ s/::/\//g;
    $FileLocation .= '.pm';
    my $File = $CommonObject{ConfigObject}->Get('Home')."/$FileLocation";
    my $FileContent = '';
    if (open(IN, "< $File")) {
        # set bin mode
        binmode IN;
        while (<IN>) {
            $FileContent .= $_;
        }
        close (IN);
    }
    else {
        die "Can't open: $File: $!";
    }

    # change package settings
    $FileContent =~ s/package Kernel::System::Stats::/package Kernel::System::Stats::Static::/;
    if ($FileContent =~ /{LayoutObject}->/) {
        print "Be careful this file tryed to use the LayoutObject!\n";
        if ($FileContent !~ /use Kernel::Output::HTML::Layout;/) {
            print "Found no 'use Kernel::Output::HTML::Layout'\n";
            if ($FileContent =~ s/(\nuse vars)/\nuse Kernel::Output::HTML::Layout;\n$1/) {
                print "Successful insert of 'use Kernel::Output::HTML::Layout'\n";
            }
            else {
                print "Can't insert 'use Kernel::Output::HTML::Layout'. Please edit this file yourself!\n";
            }
        }
        if ($FileContent !~ /Kernel::Output::HTML::Layout->new/) {
            print "Found no 'Kernel::Output::HTML::Layout->new'\n";
            if ($FileContent =~ s/(\n *return \$Self;)/\n    \$Self->{LayoutObject} = Kernel::Output::HTML::Layout->new(\%Param, UserLanguage => 'de');\n$1/) {
                print "Successful insert of 'Kernel::Output::HTML::Layout->new'\n";
            }
            else {
                print "Can't insert 'Kernel::Output::HTML::Layout->new'. Please edit this file yourself!\n";
            }
        }
    }

    my $StaticFilename = $ObjectModule;
    $StaticFilename =~ s/Kernel::System::Stats::Static:://;
    $CommonObject{EncodeObject}->EncodeOutput(\$FileContent);
    $XMLHash[0]->{otrs_stats}[1]{File}[1]{File}       = $StaticFilename;
    $XMLHash[0]->{otrs_stats}[1]{File}[1]{Content}    = encode_base64($FileContent, '');
    $XMLHash[0]->{otrs_stats}[1]{File}[1]{Location}   = $FileLocation;
    $XMLHash[0]->{otrs_stats}[1]{File}[1]{Permission} = "644";
    $XMLHash[0]->{otrs_stats}[1]{File}[1]{Encode}     = "Base64";

    # convert hash to string
    $File{Content} = $CommonObject{XMLObject}->XMLHash2XML(@XMLHash);

    # write data in filesystem
    $File = $CommonObject{ConfigObject}->Get('Home')."/var/Stats/". $File{Filename};
    push (@Filelist, $File{Filename});
    if (!open(OUT, "> $File")) {
        print "\nCan't create $File!\n";
    }
    else {
        print OUT $File{Content};
        close (OUT);
        print "\n$File successful created!\n";
    }
}
# ---------------------------------------------------------- #
# build the package
# ---------------------------------------------------------- #

my %OPMS = ();
my ($s,$m,$h, $D,$M,$Y) = $CommonObject{TimeObject}->SystemTime2Date(
    SystemTime => $CommonObject{TimeObject}->SystemTime(),
);

$OPMS{Version}    {Content}    = $PackageVersion;
$OPMS{Name}       {Content}    = $PackageName;
$OPMS{Framework}  {Content}    = '2.1.x';
$OPMS{Vendor}     {Content}    = 'OTRS GmbH';
$OPMS{URL}        {Content}    = 'http://otrs.org/';
$OPMS{License}    {Content}    = 'GNU GENERAL PUBLIC LICENSE Version 2, June 1991';
$OPMS{ChangeLog}  {Content}    = "$Y-$M-$D Created per StatsMigration2.0to2.1.pl";
$OPMS{BuildDate}  {Content}    = '?';
$OPMS{BuildHost}  {Content}    = '?';
$OPMS{Description}[0]{Content} = 'Ein Modul um Statistiken von OTRS 2.0 auf 2.1 zu migrieren';
$OPMS{Description}[0]{Lang}    = 'de';
$OPMS{Description}[1]{Content} = 'A module to migrate stats from OTRS 2.0 to 2.1';
$OPMS{Description}[1]{Lang}    = 'en';

# build file list
my $FileListString = '';
foreach (@Filelist) {
    my %Hash = ();
    $Hash{Location} = "var/Stats/" . $_;
    $Hash{Permission} = '644';
    push (@{$OPMS{Filelist}}, \%Hash);
    $FileListString .= " $_";
}

# prepare code install settings

$OPMS{CodeInstall}{Content}    = '
require Kernel::System::Stats;
require Kernel::System::Group;
require Kernel::System::User;

$Self-&gt;{UserID} = 1;
$Self-&gt;{GroupObject} = Kernel::System::Group-&gt;new(%{$Self});
$Self-&gt;{UserObject}  = Kernel::System::User-&gt;new(%{$Self});
$Self-&gt;{StatsObject} = Kernel::System::Stats-&gt;new(%{$Self});

foreach my $FileString (qw(' . $FileListString . ')) {
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
my $File = $CommonObject{ConfigObject}->Get('Home')."/var/OPM/$PackageName-$OPMS{Version}{Content}.opm";
if (open (OUT, "> $File")) {
    print "Writing $File\n";
    print OUT $CommonObject{PackageObject}->PackageBuild(%OPMS);
    close (OUT);
    exit 1;
}
else {
    print STDERR "ERROR: Can't write $File\n";
    exit;
}

=item StringAndTimestamp2Filename()

builds a filename with a string and a timestamp.
(space will be replaced with _ and - e.g. Title-of-File_2006-12-31_11-59)

    my $Filename = $Self->{StatsObject}->StringAndTimestamp2Filename(String => 'Title');

=cut

sub StringAndTimestamp2Filename {
    my $String  = shift;

    if (!$String) {
        return $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "StringAndTimestamp2Filename: Need String!"
        );
    }

    my ($s,$m,$h, $D,$M,$Y) = $CommonObject{TimeObject}->SystemTime2Date(
        SystemTime => $CommonObject{TimeObject}->SystemTime(),
    );
    $M = sprintf("%02d", $M);
    $D = sprintf("%02d", $D);
    $h = sprintf("%02d", $h);
    $m = sprintf("%02d", $m);

    # replace invalid token like < > ? " : | \ or *
    $String =~ s/[ <>\?":\\\*\|]/-/g;
    $String =~ s/ä/ae/g;
    $String =~ s/ö/oe/g;
    $String =~ s/ü/ue/g;
    $String =~ s/Ä/Ae/g;
    $String =~ s/Ö/Oe/g;
    $String =~ s/Ü/Ue/g;
    $String =~ s/ß/ss/g;
    $String =~ s/-+/-/g;

    # Cut the String if to long
    if (length($String) > 100) {
        $String = substr($String,0,100);
    }

    my $Filename = $String . "_"."$Y-$M-$D"."_"."$h-$m";

    return $Filename;
}

1;