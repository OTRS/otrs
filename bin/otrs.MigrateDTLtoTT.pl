#!/usr/bin/perl
# --
# otrs.MigrateDTLtoTT.pl - migrate DTL templates to TT
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
use Kernel::Output::Template::Provider;

# get options
my %Options;
getopt( 'hd', \%Options );
if ( exists $Options{h} || !$Options{d} ) {
    print <<EOF;
$0 - migrate DTL templates to TT
Copyright (C) 2001-2014 OTRS AG, http://otrs.com/

Usage: $0 -d /path/to/OTRS/or/module

EOF
    exit 1;
}

local $Kernel::OM = Kernel::System::ObjectManager->new(
    LogObject => {
        LogPrefix => 'OTRS-otrs.MigrateDTLtoTT.pl',
    },
);

sub Run {

    my %CommonObject = _CommonObjects();

    my $ProviderObject = Kernel::Output::Template::Provider->new();

    if ( !$Options{d} || !-d $Options{d} ) {

        my $Directory = $Options{d} || '';

        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Please provide a directory. '$Directory' is not a valid directory.",
        );
        exit 1;
    }

    my @FileList;

    # Regular DTLs
    if ( -d "$Options{d}/Kernel/Output/HTML/" ) {
        push @FileList, $CommonObject{MainObject}->DirectoryRead(
            Directory => "$Options{d}/Kernel/Output/HTML/",
            Filter    => "*.dtl",
            Recursive => 1,
        );
    }

    # Customized DTLs
    if ( -d "$Options{d}/Custom/Kernel/Output/HTML/" ) {
        push @FileList, $CommonObject{MainObject}->DirectoryRead(
            Directory => "$Options{d}/Custom/Kernel/Output/HTML/",
            Filter    => "*.dtl",
            Recursive => 1,
        );
    }

    # XML configuration files, may also contain DTL tags
    if ( -d "$Options{d}/Kernel/Config/Files/" ) {
        push @FileList, $CommonObject{MainObject}->DirectoryRead(
            Directory => "$Options{d}/Kernel/Config/Files/",
            Filter    => "*.xml",
            Recursive => 1,
        );
    }

    if ( !@FileList ) {
        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "No affected files found in $Options{d}.",
        );
        exit 1;
    }

    my $Success = 1;

    for my $File (@FileList) {
        my $ContentRef = $CommonObject{MainObject}->FileRead(
            Location => $File,
            Mode     => 'utf8',
        );

        my $TTFile = $File;
        $TTFile =~ s{[.]dtl$}{.tt}smx;

        print "$File -> $TTFile\n";

        # Correct file name in header (*.dtl -> *.tt)
        ${$ContentRef} =~ s{(\A# --\n# [a-zA-Z0-9/]+[.])dtl[ ]}{$1tt };

        my $TTContent;
        eval {
            $TTContent = $ProviderObject->MigrateDTLtoTT( Content => ${$ContentRef} );
        };
        if ($@) {
            print STDERR "There were errors processing this file:\n$@\n";
            $Success = 0;
        }

        if ( $TTContent ne ${$ContentRef} ) {
            $CommonObject{MainObject}->FileWrite(
                Location => $TTFile,
                Content  => \$TTContent,
                Mode     => 'utf8',
            );
        }

    }

    if ( !$Success ) {
        print STDERR "\nThere were errors converting the files, please see above!\n";
        exit 1;
    }

    print STDERR "\nAll files ok.\n";
    exit 0;
}

sub _CommonObjects {

    # create common objects
    my %CommonObject = $Kernel::OM->ObjectHash(
        Objects => [
            qw(ConfigObject EncodeObject LogObject MainObject TimeObject DBObject)
        ],
    );

    return %CommonObject;
}

Run();

exit 0;
