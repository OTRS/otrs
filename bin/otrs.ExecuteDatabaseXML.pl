#!/usr/bin/perl
# --
# bin/otrs.ExecuteDatabaseXML.pl - Execute XML on the database
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

use Kernel::Config;
use Kernel::System::Encode;
use Kernel::System::Log;
use Kernel::System::Time;
use Kernel::System::Main;
use Kernel::System::DB;
use Kernel::System::XML;

# create common objects
my %CommonObject = ();
$CommonObject{ConfigObject} = Kernel::Config->new(%CommonObject);
$CommonObject{EncodeObject} = Kernel::System::Encode->new(%CommonObject);
$CommonObject{LogObject}
    = Kernel::System::Log->new( %CommonObject, LogPrefix => 'OTRS-otrs.ExecuteDatabaseXML.pl' );
$CommonObject{TimeObject} = Kernel::System::Time->new(%CommonObject);
$CommonObject{MainObject} = Kernel::System::Main->new(%CommonObject);
$CommonObject{DBObject}   = Kernel::System::DB->new(%CommonObject);
$CommonObject{XMLObject}  = Kernel::System::XML->new(%CommonObject);

print "otrs.ExecuteDatabaseXML.pl - Execute XML DDL in the OTRS database\n";
print "Copyright (C) 2001-2013 OTRS AG, http://otrs.com/\n\n";

if ( !$ARGV[0] ) {
    print "USAGE: $0 <filename.xml>\n";
    exit 1;
}

if ( !-e $ARGV[0] ) {
    print "WARNING: file $ARGV[0] is not found.\n";
    exit 1;
}

# read file
my $XML = $CommonObject{MainObject}->FileRead(
    Location => $ARGV[0],
);

# convert to array
my @XMLArray = $CommonObject{XMLObject}->XMLParse( String => $XML );

my @SQL = $CommonObject{DBObject}->SQLProcessor(
    Database => \@XMLArray,
);

my @SQLPost = $CommonObject{DBObject}->SQLProcessorPost();

_ExecuteSQL( SQL => \@SQL );
_ExecuteSQL( SQL => \@SQLPost );
print "Done.\n";
exit 0;

sub _ExecuteSQL {
    my (%Param) = @_;

    for my $SQL ( @{ $Param{SQL} } ) {
        print "$SQL\n";
        my $Success = $CommonObject{DBObject}->Do( SQL => $SQL );
        if ( !$Success ) {
            print STDERR "WARNING: Database action failed. Exiting.\n\n";
            exit 1;
        }
    }
    return 1;
}
