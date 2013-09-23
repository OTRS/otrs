# --
# SQLFunctions.t - database tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars qw($Self);
use Encode;

use Kernel::System::XML;

my $XMLObject = Kernel::System::XML->new( %{$Self} );
my $DBObject  = Kernel::System::DB->new( %{$Self} );

# ------------------------------------------------------------ #
# XML test 10 - SQL functions: LOWER(), UPPER()
# ------------------------------------------------------------ #
# test different sizes up to 3999.
# 4000 is a magic value, beyond which locator objects might be used
# and all bets regarding UPPER and LOWER are off
my $XML = '
<TableCreate Name="test_j">
    <Column Name="name_a" Required="true" Size="6"    Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60"   Type="VARCHAR"/>
    <Column Name="name_c" Required="true" Size="600"  Type="VARCHAR"/>
    <Column Name="name_d" Required="true" Size="3998" Type="VARCHAR"/>
</TableCreate>
';
my @XMLARRAY = $XMLObject->XMLParse( String => $XML );
my @SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() CREATE TABLE ($SQL)",
    );
}

# as 'Ab' is two chars, multiply half the sizes from test_j
my @Values = map { 'Ab' x $_ } ( 3, 30, 300, 1999 );

# insert
my $Result = $DBObject->Do(
    SQL  => 'INSERT INTO test_j (name_a, name_b, name_c, name_d) VALUES ( ?, ?, ?, ? )',
    Bind => [ \(@Values) ],
);
$Self->True(
    $Result,
    "Do() INSERT",
);

my $SQL = 'SELECT LOWER(name_a), LOWER(name_b), LOWER(name_c), LOWER(name_d) FROM test_j';
$Result = $DBObject->Prepare(
    SQL   => $SQL,
    Limit => 1,
);
$Self->True(
    $Result,
    'Prepare() - LOWER() - SELECT',
);
while ( my @Row = $DBObject->FetchrowArray() ) {
    $Self->Is(
        scalar(@Row),
        scalar(@Values),
        "- LOWER() - Check number of fetched elements",
    );

    for my $Index ( 0 .. 3 ) {
        $Self->Is(
            $Row[$Index],
            lc( $Values[$Index] ),
            "#10.$Index - LOWER() - result",
        );
    }
}

$SQL    = 'SELECT UPPER(name_a), UPPER(name_b), UPPER(name_c), UPPER(name_d) FROM test_j';
$Result = $DBObject->Prepare(
    SQL   => $SQL,
    Limit => 1,
);
$Self->True(
    $Result,
    'Prepare() - UPPER() - SELECT',
);
while ( my @Row = $DBObject->FetchrowArray() ) {
    $Self->Is(
        scalar(@Row),
        scalar(@Values),
        "UPPER() - Check number of fetched elements",
    );

    for my $Index ( 0 .. 3 ) {
        $Self->Is(
            $Row[$Index],
            uc( $Values[$Index] ),
            "$Index - UPPER() - result",
        );
    }
}

$XML      = '<TableDrop Name="test_j"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() DROP TABLE ($SQL)",
    );
}


1;
