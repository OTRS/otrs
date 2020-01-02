# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $DBObject       = $Kernel::OM->Get('Kernel::System::DB');
my $StorableObject = $Kernel::OM->Get('Kernel::System::Storable');
my $XMLObject      = $Kernel::OM->Get('Kernel::System::XML');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# -------------------------------------------------------------------------------------------- #
# Test creating a table with a column that needs data type translation in the DB drivers
# -------------------------------------------------------------------------------------------- #
my $XML = '
<Table Name="test_a">
    <Column Name="time_unit" Required="true" Size="10,2" Type="DECIMAL"/>
</Table>
';
my @XMLARRAY = $XMLObject->XMLParse( String => $XML );

# make a copy of the XMLArray (deep clone it),
# it will be needed for a later comparison
my @XMLARRAYCopy = @{ $StorableObject->Clone( Data => \@XMLARRAY ) };

# check that the copy is the same as the original
$Self->IsDeeply(
    \@XMLARRAY,
    \@XMLARRAYCopy,
    '@XMLARRAY equals @XMLARRAYCopy',
);

# create the SQL from the XMLArray
# the function SQLProcessor MUST NOT modify the given array reference
# see also Bug#12764 - Database function SQLProcessor() modifies given parameter data
# https://bugs.otrs.org/show_bug.cgi?id=12764
my @SQLARRAY = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQLARRAY[0],
    'SQLProcessor() CREATE TABLE',
);

# check that the copy is STILL the same as the original
$Self->IsDeeply(
    \@XMLARRAY,
    \@XMLARRAYCopy,
    '@XMLARRAY equals @XMLARRAYCopy',
);

# cleanup cache is done by RestoreDatabase.

1;
