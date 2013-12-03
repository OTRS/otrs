# --
# TableCreate.t - database tests
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
# XML test 1 (XML:TableCreate, SQL:Insert, SQL:Select, SQL:Delete,  XML:TableDrop)
# ------------------------------------------------------------ #
my $XML = '
<TableCreate Name="test_a">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
    <Index Name="index_test_name_a">
        <IndexColumn Name="name_a"/>
    </Index>
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

$Self->True(
    $DBObject->Do(
        SQL => 'INSERT INTO test_a (name_a, name_b) VALUES (\'Some\', \'Lalala\')',
        )
        || 0,
    'Do() INSERT',
);

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_a WHERE name_a = \'Some\'',
        Limit => 1,
    ),
    'Prepare() SELECT - Prepare',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    'FetchrowArray () SELECT',
);

# rename table
$XML      = '<TableAlter NameOld="test_a" NameNew="test_aa"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    'SQLProcessor() ALTER TABLE',
);
for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() ALTER TABLE ($SQL)",
    );
}

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_aa WHERE name_a = \'Some\'',
        Limit => 1,
    ),
    'Prepare() SELECT - Prepare',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    'FetchrowArray () SELECT',
);

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT DISTINCT * FROM test_aa WHERE name_a = \'Some\'',
        Limit => 1,
    ),
    'Prepare() SELECT DISTINCT - Limit - Prepare',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    'FetchrowArray () SELECT DISTINCT - Limit',
);

$Self->True(
    $DBObject->Do(
        SQL => 'DELETE FROM valid WHERE name = \'Some\'',
        )
        || 0,
    'Do() DELETE',
);

$XML      = '<TableDrop Name="test_aa"/>';
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
