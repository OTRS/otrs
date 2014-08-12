#!/usr/bin/perl
# --
# bin/otrs.ExecuteDatabaseXML.pl - Execute XML on the database
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

use Kernel::System::ObjectManager;

# create common objects
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::System::Log' => {
        LogPrefix => 'OTRS-otrs.ExecuteDatabaseXML.pl',
    },
);

print "otrs.ExecuteDatabaseXML.pl - Execute XML DDL in the OTRS database\n";
print "Copyright (C) 2001-2014 OTRS AG, http://otrs.com/\n\n";

if ( !$ARGV[0] ) {
    print "USAGE: $0 <filename.xml>\n";
    exit 1;
}

if ( !-e $ARGV[0] ) {
    print "WARNING: file $ARGV[0] is not found.\n";
    exit 1;
}

# read file
my $XML = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
    Location => $ARGV[0],
);

# convert to array
my @XMLArray = $Kernel::OM->Get('Kernel::System::XML')->XMLParse( String => $XML );

my @SQL = $Kernel::OM->Get('Kernel::System::DB')->SQLProcessor(
    Database => \@XMLArray,
);

my @SQLPost = $Kernel::OM->Get('Kernel::System::DB')->SQLProcessorPost();

_ExecuteSQL( SQL => \@SQL );
_ExecuteSQL( SQL => \@SQLPost );
print "Done.\n";
exit 0;

sub _ExecuteSQL {
    my (%Param) = @_;

    for my $SQL ( @{ $Param{SQL} } ) {
        print "$SQL\n";
        my $Success = $Kernel::OM->Get('Kernel::System::DB')->Do( SQL => $SQL );
        if ( !$Success ) {
            print STDERR "WARNING: Database action failed. Exiting.\n\n";
            exit 1;
        }
    }
    return 1;
}
