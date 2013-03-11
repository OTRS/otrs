#!/usr/bin/perl
# --
# otrs.MySQLInnoDBSwitch.pl - converts mysql tables from MyISAM to InnoDB
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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

use vars qw($VERSION);

use Getopt::Std;
use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::DB;
use Kernel::System::PID;
use Kernel::System::Main;

# get options
my %Opts;
getopt( 'f', \%Opts );
if ( $Opts{h} ) {
    print <<EOF;
otrs.MySQLInnoDBSwitch.pl <Revision $VERSION> - convert all MyISAM tables to InnoDB
Copyright (C) 2001-2013 OTRS AG, http://otrs.org/

usage: otrs.MySQLInnoDBSwitch.pl [-f force]
EOF

    exit 1;
}

print <<EOF;
This will change the table type of your database tables to InnoDB.
Only run this if you know what you are doing, and if there is no load on the DB server.
This operation can take lots of time.
Please type "yes" to confirm.
EOF

if ( <STDIN> ne "yes\n" ) {
    print STDERR "Aborting.\n";
    exit 1;
}

# create common objects
my %CommonObject;
$CommonObject{ConfigObject} = Kernel::Config->new();
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}    = Kernel::System::Log->new(
    LogPrefix => 'OTRS-otrs.MySQLInnoDBSwitch.pl',
    %CommonObject,
);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);

# create needed objects
$CommonObject{DBObject}  = Kernel::System::DB->new(%CommonObject);
$CommonObject{PIDObject} = Kernel::System::PID->new(%CommonObject);

if ( $CommonObject{DBObject}->{'DB::Type'} ne 'mysql' ) {
    print STDERR "This script can only be run on mysql databases. Aborting.\n";
    exit 1;
}

# create pid lock
if ( !$Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => 'MySQLInnoDBSwitch' ) ) {
    print
        "NOTICE: otrs.MySQLInnoDBSwitch.pl is already running (use '-f 1' if you want to start it forced)!\n";
    exit 1;
}
elsif ( $Opts{f} && !$CommonObject{PIDObject}->PIDCreate( Name => 'MySQLInnoDBSwitch' ) ) {
    print "NOTICE: otrs.MySQLInnoDBSwitch.pl is already running but is starting again!\n";
}

# Get all tables that have MyISAM
$CommonObject{DBObject}->Prepare(
    SQL => "SHOW TABLE STATUS WHERE ENGINE = 'MyISAM'",
);

my @Tables;
while ( my @Row = $CommonObject{DBObject}->FetchrowArray() ) {
    push @Tables, $Row[0];
}

# Turn off foreign key checks, this might not be needed
if (@Tables) {
    my $Result = $CommonObject{DBObject}->Do(
        SQL => "SET foreign_key_checks = 0",
    );

    if ( !$Result ) {

        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => 'Could not disable foreign key checks.',
        );

        $CommonObject{PIDObject}->PIDDelete( Name => 'MySQLInnoDBSwitch' );
        exit 1;
    }
}

print scalar @Tables . " tables need to be converted.\n";

# Now convert the tables.
for my $Table (@Tables) {
    print "Changing table $Table to engine InnoDB\n";
    my $Result = $CommonObject{DBObject}->Do(
        SQL => "ALTER TABLE $Table ENGINE = InnoDB",
    );
    if ( !$Result ) {

        $CommonObject{LogObject}->Log(
            Priority => 'error',
            Message  => "Could not convert table $Table to engine InnoDB",
        );

        $CommonObject{PIDObject}->PIDDelete( Name => 'MySQLInnoDBSwitch' );
        exit 1;
    }
}

print "Done.\n";

# delete pid lock
$CommonObject{PIDObject}->PIDDelete( Name => 'MySQLInnoDBSwitch' );

exit 0;
