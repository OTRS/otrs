#!/usr/bin/perl -w
# --
# opm.pl - otrs package manager cmd version
# Copyright (C) 2001-2004 Martin Edenhofer <martin+code@otrs.org>
# --
# $Id: opm.pl,v 1.1 2004-12-04 11:54:30 martin Exp $
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
$VERSION = '$Revision: 1.1 $';
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
getopt('hapof', \%Opts);
if ($Opts{'h'} || !$Opts{'a'} || !$Opts{'p'}) {
    print "opm.pl <Revision $VERSION> - OTRS Package Manager\n";
    print "Copyright (c) 2001-2004 Martin Edenhofer <martin\@otrs.org>\n";
    print "usage: opm.pl -a list|install|uninstall|build -p package.opm [-o OUTPUTDIR] [-f FORCE]\n";
    exit 1;
}
if (!$Opts{'o'}) {
    $Opts{'o'} = '/tmp/';
}
if (!$Opts{'f'}) {
    $Opts{'f'} = 0;
}
my $FileString = '';
if ($Opts{'p'}) {
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
    print $CommonObject{PackageObject}->PackageBuild(
        Name => 123,
        Version => 43,
        Vendor => 24,
        License => 43,
        Description => 43,
        Files => [
            {
                Permission => "644",
                Location => "RELEASE",
            },
        ],
    );
    exit;
}
elsif ($Opts{'a'} eq 'uninstall') {
    # parse
    my %Structur = $CommonObject{PackageObject}->PackageParse(String => $FileString);
    # uninstall
    if ($CommonObject{PackageObject}->PackageUninstall(String => $FileString)) {
        # remove from repository
        $CommonObject{PackageObject}->RepositoryRemove(
            Name => $Structur{Name}->{Content},
            Version => $Structur{Version}->{Content},
        );
    }
    exit;
}
elsif ($Opts{'a'} eq 'install') {
    # parse
    my %Structur = $CommonObject{PackageObject}->PackageParse(String => $FileString);
   # add to repository
    if (!$CommonObject{PackageObject}->RepositoryGet(Name => $Structur{Name}->{Content}, Version => $Structur{Version}->{Content})) {
        $CommonObject{PackageObject}->RepositoryAdd(String => $FileString);
    }
    # install
    $CommonObject{PackageObject}->PackageInstall(
        String => $FileString,
        Force => $Opts{'f'},
    );
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
else {
    print STDERR "ERROR: Invalid -a '$Opts{'a'}' action\n";
    exit (1);
}

