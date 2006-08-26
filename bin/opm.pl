#!/usr/bin/perl -w
# --
# opm.pl - otrs package manager cmd version
# Copyright (C) 2001-2006 OTRS GmbH, http://otrs.org/
# --
# $Id: opm.pl,v 1.11 2006-08-26 17:22:05 martin Exp $
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

# use ../ as lib location
use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin)."/Kernel/cpan-lib";

use strict;
use Getopt::Std;
use Kernel::Config;
use Kernel::System::Log;
use Kernel::System::DB;
use Kernel::System::Time;
use Kernel::System::Package;

# get file version
use vars qw($VERSION $Debug);
$VERSION = '$Revision: 1.11 $';
$VERSION =~ s/^\$.*:\W(.*)\W.+?$/$1/;

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{LogObject} = Kernel::System::Log->new(
    LogPrefix => 'OTRS-opm',
    %CommonObject,
);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{DBObject} = Kernel::System::DB->new(%CommonObject);
$CommonObject{PackageObject} = Kernel::System::Package->new(%CommonObject);

# get options
my %Opts = ();
getopt('hapofd', \%Opts);
# set defaults
if (!$Opts{'o'}) {
    $Opts{'o'} = '/tmp/';
}
if (!$Opts{'f'}) {
    $Opts{'f'} = 0;
}
if (!$Opts{'a'}) {
    $Opts{'h'} = 1;
}
if ($Opts{'a'} && ($Opts{'a'} !~ /^list/ && !$Opts{'p'})) {
    $Opts{'h'} = 1;
}
if ($Opts{'a'} && $Opts{'a'} eq 'index') {
    $Opts{'h'} = 0;
}
# check needed params
if ($Opts{'h'}) {
    print "opm.pl <Revision $VERSION> - OTRS Package Manager\n";
    print "Copyright (c) 2001-2006 OTRS GmbH, http//otrs.org/\n";
    print "usage: opm.pl -a list|install|upgrade|uninstall|reinstall|list-repository|file|build|index \n";
    print "        [-p package.opm|package.sopm|package|package-version] [-o OUTPUTDIR] [-f FORCE]\n";
    print "   user (local):\n";
    print "       opm.pl -a list\n";
    print "       opm.pl -a install -p /path/to/Package-1.0.0.opm\n";
    print "       opm.pl -a upgrade -p /path/to/Package-1.0.1.opm\n";
    print "       opm.pl -a reinstall -p Package\n";
    print "       opm.pl -a uninstall -p Package\n";
    print "       opm.pl -a file -p Kernel/System/File.pm (find package of file)\n";
    print "   user (remote):\n";
    print "       opm.pl -a list-repository\n";
    print "       opm.pl -a install -p online:Package\n";
    print "       opm.pl -a install -p http://ftp.otrs.org/pub/otrs/packages/:Package-1.0.0.opm\n";
    print "       opm.pl -a upgrade -p online:Package\n";
    print "       opm.pl -a upgrade -p http://ftp.otrs.org/pub/otrs/packages/:Package-1.0.0.opm\n";
    print "   developer: \n";
    print "       opm.pl -a build -p /path/to/Package-1.0.0.sopm\n";
    print "       opm.pl -a index -d /path/to/repository/\n";
    exit 1;
}
my $FileString = '';
if ($Opts{'a'} !~ /^(list|file)/ && $Opts{'p'}) {
    if (-e $Opts{'p'}) {
        if (open(IN, "< $Opts{'p'}")) {
            while (<IN>) {
                $FileString .= $_;
            }
            close (IN);
        }
        else {
            die "Can't open: $Opts{'p'}: $!";
        }
    }
    elsif ($Opts{'p'} =~ /^(online|.*):(.+?)$/) {
        my $URL = $1;
        my $PackageName = $2;
        if ($URL eq 'online') {
            my %List = %{$CommonObject{ConfigObject}->Get('Package::RepositoryList')};
            %List = (%List, $CommonObject{PackageObject}->PackageOnlineRepositories());
            foreach (sort keys %List) {
                if ($List{$_} =~ /^\[-Master-\]/) {
                    $URL = $_;
                }
            }
        }
        if ($PackageName !~ /^.+?.opm$/) {
            my @Packages = $CommonObject{PackageObject}->PackageOnlineList(
                URL => $URL,
                Lang => $CommonObject{ConfigObject}->Get('DefaultLanguage'),
            );
            foreach my $Package (@Packages) {
                if ($Package->{Name} eq $PackageName) {
                    $PackageName = $Package->{File};
                    last;
                }
            }
        }
        $FileString = $CommonObject{PackageObject}->PackageOnlineGet(
            Source => $URL,
            File => $PackageName,
        );
        if (!$FileString) {
            die "ERROR: No such file '$Opts{'p'}' in $URL!";
        }
    }
    else {
        if ($Opts{'p'} =~ /^(.*)\-(\d{1,4}\.\d{1,4}\.\d{1,4})$/) {
            $FileString = $CommonObject{PackageObject}->RepositoryGet(
                Name => $1,
                Version => $2,
            );
        }
        else {
            foreach my $Package ($CommonObject{PackageObject}->RepositoryList()) {
                if ($Opts{'p'} eq $Package->{Name}->{Content}) {
                    $FileString = $CommonObject{PackageObject}->RepositoryGet(
                        Name => $Package->{Name}->{Content},
                        Version => $Package->{Version}->{Content},
                    );
                    last;
                }
            }
        }
        if (!$FileString) {
            die "ERROR: No such file '$Opts{'p'}' or invalid 'package-version'!";
        }
    }
}
# file
if ($Opts{'a'} eq 'file') {
    $Opts{'p'} =~ s/\/\//\//g;
    my $Hit = 0;
    foreach my $Package ($CommonObject{PackageObject}->RepositoryList()) {
        foreach my $File (@{$Package->{Filelist}}) {
            if ($Opts{'p'} =~ /^\Q$File->{Location}\E$/) {
                print "+-----------------------------------------------------------------+\n";
                print "| File:        $File->{Location}!\n";
                print "| Name:        $Package->{Name}->{Content}\n";
                print "| Version:     $Package->{Version}->{Content}\n";
                print "| Vendor:      $Package->{Vendor}->{Content}\n";
                print "| URL:         $Package->{URL}->{Content}\n";
                print "+-----------------------------------------------------------------+\n";
                $Hit = 1;
            }
        }
    }
    if ($Hit) {
        exit;
    }
    else {
        print STDERR "ERROR: no package for file $Opts{'p'} found!\n";
        exit 1;
    }
}
# build
if ($Opts{'a'} eq 'build') {
    my %Structur = $CommonObject{PackageObject}->PackageParse(
        String => $FileString,
    );
    if (!-e $Opts{'o'}) {
        print STDERR "ERROR: $Opts{'o'} doesn't exist!\n";
        exit 1;
    }
    my $File = "$Opts{'o'}/$Structur{Name}->{Content}-$Structur{Version}->{Content}.opm";
    if (open (OUT, "> $File")) {
        print "Writing $File\n";
        print OUT $CommonObject{PackageObject}->PackageBuild(%Structur);
        close (OUT);
        exit;
    }
    else {
        print STDERR "ERROR: Can't writre $File\n";
        exit 1;
    }
}
elsif ($Opts{'a'} eq 'uninstall') {
    # get package file from db
    # uninstall
    $CommonObject{PackageObject}->PackageUninstall(
        String => $FileString,
        Force => $Opts{'f'},
    );
    exit;
}
elsif ($Opts{'a'} eq 'install') {
    # install
    $CommonObject{PackageObject}->PackageInstall(
        String => $FileString,
        Force => $Opts{'f'},
    );
    exit;
}
elsif ($Opts{'a'} eq 'reinstall') {
    # install
    $CommonObject{PackageObject}->PackageReinstall(
        String => $FileString,
        Force => $Opts{'f'},
    );
    exit;
}
elsif ($Opts{'a'} eq 'upgrade') {
    # upgrade
    $CommonObject{PackageObject}->PackageUpgrade(
        String => $FileString,
        Force => $Opts{'f'},
    );
    exit;
}
elsif ($Opts{'a'} eq 'list') {
    foreach my $Package ($CommonObject{PackageObject}->RepositoryList()) {
        my $Description = '';
        foreach my $Tag (@{$Package->{Description}}) {
            # just use start tags
            if ($Tag->{TagType} ne 'Start') {
                next;
            }
            if ($Tag->{Tag} eq 'Description') {
                if (!$Description) {
                    $Description = $Tag->{Content};
                }
                if ($Tag->{Lang} eq 'en') {
                    $Description = $Tag->{Content};
                }
            }
        }
        print "+-----------------------------------------------------------------+\n";
        print "| Name:        $Package->{Name}->{Content}\n";
        print "| Version:     $Package->{Version}->{Content}\n";
        print "| Vendor:      $Package->{Vendor}->{Content}\n";
        print "| URL:         $Package->{URL}->{Content}\n";
        print "| Description: $Description\n";
    }
    print "+-----------------------------------------------------------------+\n";
    exit;
}
elsif ($Opts{'a'} eq 'list-repository') {
    my $Count = 0;
    my %List = %{$CommonObject{ConfigObject}->Get('Package::RepositoryList')};
    %List = (%List, $CommonObject{PackageObject}->PackageOnlineRepositories());
    foreach my $URL (sort keys %List) {
        $Count++;
        print "+-----------------------------------------------------------------+\n";
        print "| $Count) Name: $List{$URL}\n";
        print "|    URL:  $URL\n";
    }
    print "+-----------------------------------------------------------------+\n";
    print "| Select the repository [1]: ";
    my $Repository = <STDIN>;
    chomp ($Repository);
    if (!$Repository) {
        $Repository = 1;
    }
    $Count = 0;
    foreach my $URL (sort keys %List) {
        $Count++;
        if ($Count == $Repository) {
            print "+-----------------------------------------------------------------+\n";
            print "| Package Overview:\n";
            my @Packages = $CommonObject{PackageObject}->PackageOnlineList(
                URL => $URL,
                Lang => $CommonObject{ConfigObject}->Get('DefaultLanguage'),
            );
            my $Count = 0;
            foreach my $Package (@Packages) {
                $Count++;
                print "+-----------------------------------------------------------------+\n";
                print "| $Count) Name:        $Package->{Name}\n";
                print "|    Version:     $Package->{Version}\n";
                print "|    URL:         $Package->{URL}\n";
                print "|    Description: $Package->{Description}\n";
                print "|    Install:     -p $URL:$Package->{File}\n";
            }
            print "+-----------------------------------------------------------------+\n";
            print "| Install/upgrade package: ";
            my $PackageCount = <STDIN>;
            chomp ($PackageCount);
            $Count = 0;
            foreach my $Package (@Packages) {
                $Count++;
                if ($Count eq $PackageCount) {
                    my $FileString = $CommonObject{PackageObject}->PackageOnlineGet(
                        Source => $URL,
                        File => $Package->{File},
                    );
                    $CommonObject{PackageObject}->PackageInstall(
                        String => $FileString,
                        Force => $Opts{'f'},
                    );
                }
            }
        }
    }
    exit;
}
elsif ($Opts{'a'} eq 'p') {
    my @Data = $CommonObject{PackageObject}->PackageParse(
        String => $FileString,
    );
    foreach my $Tag (@Data) {
        print STDERR "Tag: $Tag->{Type} $Tag->{Tag} $Tag->{Content}\n";
    }
}
elsif ($Opts{'a'} eq 'parse') {
    my %Structur = $CommonObject{PackageObject}->PackageParse(
        String => $FileString,
    );
    foreach my $Key (sort keys %Structur) {
        if (ref($Structur{$Key}) eq 'ARRAY') {
            foreach my $Data (@{$Structur{$Key}}) {
                print "--------------------------------------\n";
                print "$Key:\n";
                foreach (%{$Data}) {
                    if (defined($_) && defined($Data->{$_})) {
                        print "  $_: $Data->{$_}\n";
                    }
                }
            }
        }
        else {
            print "--------------------------------------\n";
            print "$Key:\n";
            foreach my $Data (%{$Structur{$Key}}) {
                if (defined($Structur{$Key}->{$Data})) {
                    print "  $Data: $Structur{$Key}->{$Data}\n";
                }
            }
        }
    }
    exit;
}
elsif ($Opts{'a'} eq 'index') {
    if (! $Opts{'d'}) {
        die "ERROR: invalid package root location -d is needed!";
    }
    elsif (! -d $Opts{'d'}) {
        die "ERROR: invalid package root location '$Opts{'d'}'";
    }
    my @Dirs = ();
    print "<?xml version=\"1.0\" encoding=\"utf-8\" ?>\n";
    print "<otrs_package_list version=\"1.0\">\n";
    BuildPackageIndex($Opts{'d'});
    print "</otrs_package_list>\n";
}
else {
    print STDERR "ERROR: Invalid -a '$Opts{'a'}' action\n";
    exit (1);
}


sub BuildPackageIndex {
    my $In = shift;
    my @List = glob("$In/*");
    foreach my $File (@List) {
        $File =~ s/\/\//\//g;
        if (-d $File && $File !~ /CVS/) {
            BuildPackageIndex($File);
            $File =~ s/$Opts{'d'}//;
#            print "Directory: $File\n";
        }
        else {
            my $OrigFile = $File;
            $File =~ s/$Opts{'d'}//;
#               print "File: $File\n";
#               my $Dir =~ s/^(.*)\//$1/;
            if ($File !~ /Entries|Repository|Root|CVS/ && $File =~ /\.opm$/) {
#               print "F: $File\n";
                my $Content = '';
                open (IN, "< $OrigFile") || die "Can't open $OrigFile: $!";
                while (<IN>) {
                    $Content .= $_;
                }
                close (IN);
                my %Structur = $CommonObject{PackageObject}->PackageParse(String => $Content);
                my $XML = $CommonObject{PackageObject}->PackageBuild(%Structur, Type => 'Index');
                print "<Package>\n";
                print $XML;
                print "  <File>$File</File>\n";
                print "</Package>\n";
            }
        }
    }
}

