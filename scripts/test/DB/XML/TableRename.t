# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $DBObject  = $Kernel::OM->Get('Kernel::System::DB');
my $XMLObject = $Kernel::OM->Get('Kernel::System::XML');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# -------------------------------------------------------------------------- #
# Test renaming a table and then adding a new table with the same old name
# -------------------------------------------------------------------------- #
my $XML = '
<Table Name="test_a">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER" />
    <Column Name="name" Required="false" Size="20" Type="VARCHAR" />
    <Unique Name="test_a_name">
        <UniqueColumn Name="name"/>
    </Unique>
</Table>
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

# add 2 values to table
my $SQL = "INSERT INTO test_a (name) VALUES ('Test1')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

$SQL = "INSERT INTO test_a (name) VALUES ('Test2')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

# get the id from the second entry
$SQL = "SELECT id FROM test_a WHERE name = 'Test2'";
$Self->True(
    $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    ),
    "Prepare(): $SQL",
);

my $LastID;
while ( my @Row = $DBObject->FetchrowArray() ) {
    $LastID = $Row[0];
}

$Self->True(
    $LastID,
    "Check that the last entry could be added (ID: $LastID)",
);

# drop unique constraint before renaming
$XML = '
<TableAlter Name="test_a">
    <UniqueDrop Name="test_a_name"/>
</TableAlter>';

@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
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

# rename table
$XML      = '<TableAlter NameOld="test_a" NameNew="test_b"/>';
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

# add unique constraint after renaming
$XML = '
<TableAlter Name="test_b">
    <UniqueCreate Name="test_b_name">
        <UniqueColumn Name="name"/>
    </UniqueCreate>
</TableAlter>';

@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
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

# add another value to the renamed table
$SQL = "INSERT INTO test_b (name) VALUES ('Test3')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

# get the id from the third entry in the renamed table
$SQL = "SELECT id FROM test_b WHERE name = 'Test3'";
$Self->True(
    $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    ),
    "Prepare(): $SQL",
);

while ( my @Row = $DBObject->FetchrowArray() ) {
    $LastID = $Row[0];
}

$Self->True(
    $LastID,
    "Check that the last entry could be added (ID: $LastID)",
);

# create a new table with the same name than before the renaming
$XML = '
<Table Name="test_a">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER" />
    <Column Name="name" Required="false" Size="20" Type="VARCHAR" />
    <Unique Name="test_a_name">
        <UniqueColumn Name="name"/>
    </Unique>
</Table>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );

@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
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

# add one value to new table
$SQL = "INSERT INTO test_a (name) VALUES ('Test1')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

# get the id from the first entry in the new table
$SQL = "SELECT id FROM test_a WHERE name = 'Test1'";
$Self->True(
    $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    ),
    "Prepare(): $SQL",
);

while ( my @Row = $DBObject->FetchrowArray() ) {
    $LastID = $Row[0];
}

$Self->True(
    $LastID,
    "Check that the last entry could be added (ID: $LastID)",
);

# add another value to the renamed table
$SQL = "INSERT INTO test_b (name) VALUES ('Test4')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

# get the id from the fourth entry in the renamed table
$SQL = "SELECT id FROM test_b WHERE name = 'Test4'";
$Self->True(
    $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    ),
    "Prepare(): $SQL",
);

while ( my @Row = $DBObject->FetchrowArray() ) {
    $LastID = $Row[0];
}

$Self->True(
    $LastID,
    "Check that the last entry could be added (ID: $LastID)",
);

# add another value to new table
$SQL = "INSERT INTO test_a (name) VALUES ('Test2')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

# get the id from the second entry in the new table
$SQL = "SELECT id FROM test_a WHERE name = 'Test2'";
$Self->True(
    $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    ),
    "Prepare(): $SQL",
);

while ( my @Row = $DBObject->FetchrowArray() ) {
    $LastID = $Row[0];
}

$Self->True(
    $LastID,
    "Check that the last entry could be added (ID: $LastID)",
);

# drop all tables
my @TableDropStatements = (
    '<TableDrop Name="test_a"/>',
    '<TableDrop Name="test_b"/>',
);
for my $XML (@TableDropStatements) {

    @XMLARRAY = $XMLObject->XMLParse( String => $XML );
    @SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
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
}

# cleanup cache is done by RestoreDatabase.

1;
