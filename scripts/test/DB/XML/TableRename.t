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

# add another value to the renamed table
$SQL = "INSERT INTO test_b (name) VALUES ('Test3')";
$Self->True(
    $DBObject->Do(
        SQL => $SQL,
        )
        || 0,
    $SQL,
);

# Prepare a second ID container to be able to compare
# old and new ID
my $NewLastID;

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
    $NewLastID = $Row[0];
}

$Self->True(
    $NewLastID,
    "Check that the last entry could be added (ID: $NewLastID)",
);

$Self->True(
    ( $NewLastID > $LastID ? 1 : 0 ),
    "Last entry ID should be higher than previous one, it means sequence is still the same for the re-named table (ID: $LastID - NewID: $NewLastID )",
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
    "Check that the last entry on NEW TABLE could be added (ID: $LastID)",
);

$Self->IsNot(
    $LastID,
    $NewLastID + 1,
    "First entry for new table shouldn't be on the same sequence as renamed table. (New table ID: $LastID - Renamed table last ID: $NewLastID )",
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

$Self->Is(
    $LastID,
    $NewLastID + 1,
    "After inserting a new record on re-named table, sequence still on the same road. (Current last ID: $LastID - Previous last ID: $NewLastID )",
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

# Check if sequence for both tables exist with the correct name,
# that means we have not duplicated names on sequences

# helper function to check sequence
my $SequenceCheck = sub {
    my %Param = @_;

    my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

    # Get the database type.
    my $DBType = $DBObject->GetDatabaseFunction('Type');

    # Sequence check works just for some DBs.
    my @CheckAllowed = qw(oracle postgresql);

    if ( !grep {m/$DBType/} @CheckAllowed ) {
        return 1;
    }

    my $TableName = $Param{TableName} || '';
    my $SequenceExists;

    if ( $DBType eq 'oracle' ) {

        my $Sequence = $DBObject->{Backend}->_SequenceName(
            TableName => $TableName,
        );

        # verify if the sequence exists
        return if !$DBObject->Prepare(
            SQL => '
                SELECT COUNT(*)
                FROM user_sequences
                WHERE LOWER(sequence_name) = LOWER(?)',
            Bind  => [ \$Sequence ],
            Limit => 1,
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $SequenceExists = $Row[0];
        }
    }
    elsif ( $DBType eq 'postgresql' ) {

        my $Sequence = $DBObject->{Backend}->_SequenceName(
            TableName => $TableName,
        );

        # check if sequence exists
        return if !$DBObject->Prepare(
            SQL => "
                SELECT 1
                FROM pg_class c
                WHERE c.relkind = 'S'
                AND LOWER(c.relname) = LOWER('$Sequence')",
            Limit => 1,
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {
            $SequenceExists = $Row[0];
        }
    }

    return $SequenceExists;
};

for my $TablePostfix (qw(a b)) {

    my $TableName = 'test_' . $TablePostfix;

    my $SequenceCheckResult = $SequenceCheck->(
        TableName => $TableName,
    );

    $Self->True(
        $SequenceCheckResult,
        "Correct sequence name for table $TableName.",
    );
}

# drop all tables
my @TableDropStatements = (
    '<TableDrop Name="test_a"/>',
    '<TableDrop Name="test_b"/>',
);
for my $XML (@TableDropStatements) {

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
}

# cleanup cache is done by RestoreDatabase.

1;
