#!/usr/bin/perl
# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

use strict;
use warnings;

use File::Basename;
use FindBin qw($RealBin);
use lib dirname($RealBin);
use lib dirname($RealBin) . '/Kernel/cpan-lib';
use lib dirname($RealBin) . '/Custom';

use Getopt::Std;

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Time;
use Kernel::System::Log;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::SupportBundleGenerator;

print "otrs.SuppportBundle.pl - creates a bundle of support information\n";
print "Copyright (C) 2001-2018 OTRS AG, https://otrs.com/\n";

# common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.SuppportBundle.pl',
    %CommonObject,
);
$CommonObject{TimeObject}                   = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject}                   = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}                     = Kernel::System::DB->new(%CommonObject);
$CommonObject{SupportBundleGeneratorObject} = Kernel::System::SupportBundleGenerator->new(%CommonObject);

# get options
my %Opts = ();
getopt( 'ho', \%Opts );

# help option
if ( $Opts{h} ) {
    print "Usage: otrs.SuppportBundle.pl -o <Path> (Optional)\n\n";
    print "Examples:\n";
    print "otrs.SuppportBundle.pl\n";
    print "otrs.SuppportBundle.pl -o /opt/otrs\n\n";
    exit 1;
}

my $Response = $CommonObject{SupportBundleGeneratorObject}->Generate();

if ( $Response->{Success} ) {

    my $FileData = $Response->{Data};

    my $OutputDir = $CommonObject{ConfigObject}->Get('Home');
    if ( $Opts{o} ) {
        $OutputDir = $Opts{o};
        $OutputDir =~ s{\/\z}{};
    }

    my $FileLocation = $CommonObject{MainObject}->FileWrite(
        Location   => $OutputDir . '/' . $FileData->{Filename},
        Content    => $FileData->{Filecontent},
        Mode       => 'binmode',
        Permission => '644',
    );

    if ($FileLocation) {
        print "\nSupport Bundle saved to: $FileLocation\n";
    }
    else {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Support Bundle could not be written!",
        );
    }

    exit;
}

exit 1;
