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

# define needed variable
my $UID;

# ------------------------------------------------------------ #
# XML test 7 - default value test (alter table)
# ------------------------------------------------------------ #
my $XML = '
<TableCreate Name="test_f">
    <Column Name="id" Required="true" Type="INTEGER"/>
    <Column Name="name_a" Required="false" Type="INTEGER" />
    <Column Name="name_b" Required="false" Default="0" Type="INTEGER" />
    <Column Name="name_c" Required="false" Default="10" Type="INTEGER" />
    <Column Name="name_d" Required="false" Size="20" Type="VARCHAR" />
    <Column Name="name_e" Required="false" Default="" Size="20" Type="VARCHAR" />
    <Column Name="name_f" Required="false" Default="Test1" Size="20" Type="VARCHAR" />
    <Index Name="test_f_name_a">
        <IndexColumn Name="name_a"/>
    </Index>
    <Unique Name="unique_id_name_a">
        <UniqueColumn Name="id"/>
        <UniqueColumn Name="name_a"/>
    </Unique>
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

# try to add the same index again
# this should not cause an error as the database driver
# should take care to not create it again if it already exists
$XML = '
<TableAlter Name="test_f">
    <IndexCreate Name="test_f_name_a">
        <IndexColumn Name="name_a"/>
    </IndexCreate>
</TableAlter>
';
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

# try to add another index with another name
# but using the same index column
# this should work fine
$XML = '
<TableAlter Name="test_f">
    <IndexCreate Name="test_f_name_a2">
        <IndexColumn Name="name_a"/>
    </IndexCreate>
</TableAlter>
';
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

# try to drop the last index
$XML = '
<TableAlter Name="test_f">
    <IndexDrop Name="test_f_name_a2"/>
</TableAlter>
';
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

# try to drop the last index again
# has already been deleted, but should be fine, as IndexDrop should handle this
$XML = '
<TableAlter Name="test_f">
    <IndexDrop Name="test_f_name_a2"/>
</TableAlter>
';
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

# try to add the same unique constraint again
# this should not cause an error as the database driver
# should take care to not create it again if it already exists
$XML = '
<TableAlter Name="test_f">
    <UniqueCreate Name="unique_id_name_a">
        <UniqueColumn Name="id"/>
        <UniqueColumn Name="name_a"/>
    </UniqueCreate>
</TableAlter>
';
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

# drop unique constraint
$XML = '
<TableAlter Name="test_f">
    <UniqueDrop Name="unique_id_name_a"/>
</TableAlter>
';
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

# drop the same unique constraint again (should be fine)
$XML = '
<TableAlter Name="test_f">
    <UniqueDrop Name="unique_id_name_a"/>
</TableAlter>
';
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

my $DefaultTest2Insert = [

    # general function test
    {
        Insert => {
            name_a => 100,
            name_b => 100,
            name_c => 100,
            name_d => q{'Test'},
            name_e => q{'Test'},
            name_f => q{'Test'},
        },
        Select => {
            name_a => 100,
            name_b => 100,
            name_c => 100,
            name_d => 'Test',
            name_e => 'Test',
            name_f => 'Test',
        },
    },

    # check integer columns
    {
        Insert => {
            name_d => q{''},
            name_e => q{''},
            name_f => q{''},
        },
        Select => {
            name_a => '',
            name_b => 0,
            name_c => 10,
            name_d => '',
            name_e => '',
            name_f => '',
        },
    },

    # check text columns
    {
        Insert => {
            name_a => 0,
            name_b => 0,
            name_c => 0,
        },
        Select => {
            name_a => 0,
            name_b => 0,
            name_c => 0,
            name_d => '',
            name_e => '',
            name_f => 'Test1',
        },
    },
];

my $Counter1 = 1;
for my $Test ( @{$DefaultTest2Insert} ) {

    # create unique id
    my $ID = $UID++;

    my @InsertColumnsSorted = sort { $a cmp $b } keys %{ $Test->{Insert} };
    my @InsertValuesSorted  = map  { $Test->{Insert}->{$_} } @InsertColumnsSorted;
    my $InsertColumns = join q{, }, @InsertColumnsSorted;
    my $InsertValues  = join q{, }, @InsertValuesSorted;

    my $SQLInsert = "INSERT INTO test_f (id, $InsertColumns) VALUES ($ID, $InsertValues)";

    $Self->True(
        $DBObject->Do( SQL => $SQLInsert ) || 0,
        "#7.$Counter1 Do() INSERT",
    );

    for my $Column ( sort { $a cmp $b } keys %{ $Test->{Select} } ) {

        my $SelectedValue;
        my $ReferenceValue = $Test->{Select}->{$Column};

        $DBObject->Prepare(
            SQL   => "SELECT $Column FROM test_f WHERE id = $ID",
            Limit => 1,
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {

            $SelectedValue  = defined $Row[0]         ? $Row[0]         : '';
            $ReferenceValue = defined $ReferenceValue ? $ReferenceValue : '';

            $Self->Is(
                $SelectedValue,
                $ReferenceValue,
                "#7.$Counter1 SELECT check selected value of column '$Column':",
            );
        }
    }

    $Counter1++;

}

$XML = '
<TableAlter Name="test_f">
    <ColumnChange NameOld="name_a" NameNew="name_a" Required="false" Default="20" Type="INTEGER" />
    <ColumnChange NameOld="name_b" NameNew="name_b" Required="false" Default="0" Type="INTEGER" />
    <ColumnChange NameOld="name_c" NameNew="name_c" Required="false" Default="0" Type="INTEGER" />
    <ColumnChange NameOld="name_d" NameNew="name_d" Required="false" Default="Test1" Size="20" Type="VARCHAR" />
    <ColumnChange NameOld="name_e" NameNew="name_e" Required="false" Default="" Size="20" Type="VARCHAR" />
    <ColumnChange NameOld="name_f" NameNew="name_f" Required="false" Default="" Size="20" Type="VARCHAR" />
    <ColumnAdd Name="name2_a" Required="false" Default="1" Type="INTEGER" />
    <ColumnAdd Name="name2_b" Required="false" Default="0" Type="INTEGER" />
    <ColumnAdd Name="name2_c" Required="true" Default="2" Type="INTEGER" />
    <ColumnAdd Name="name2_d" Required="true" Default="0" Type="INTEGER" />
    <ColumnAdd Name="name2_e" Required="false" Default="Test1" Size="20" Type="VARCHAR" />
    <ColumnAdd Name="name2_f" Required="false" Default="" Size="20" Type="VARCHAR" />
    <ColumnAdd Name="name2_g" Required="true" Default="Test2" Size="20" Type="VARCHAR" />
    <ColumnAdd Name="name2_h" Required="true" Default="" Size="20" Type="VARCHAR" />
    <ColumnAdd Name="name3_a" Required="false" Type="INTEGER" />
    <ColumnAdd Name="name3_b" Required="false" Type="INTEGER" />
    <ColumnAdd Name="name3_c" Required="false" Size="20" Type="VARCHAR" />
    <ColumnAdd Name="name3_d" Required="false" Size="20" Type="VARCHAR" />
</TableAlter>
';
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

my $DefaultTest2Alter1 = [

    # general function test
    {
        Insert => {
            name_a  => 10,
            name_b  => 10,
            name_c  => 10,
            name_d  => q{'Test'},
            name_e  => q{'Test'},
            name_f  => q{'Test'},
            name2_a => 10,
            name2_b => 10,
            name2_c => 10,
            name2_d => 10,
            name2_e => q{'Test'},
            name2_f => q{'Test'},
            name2_g => q{'Test'},
            name2_h => q{'Test'},
        },
        Select => {
            name_a  => 10,
            name_b  => 10,
            name_c  => 10,
            name_d  => 'Test',
            name_e  => 'Test',
            name_f  => 'Test',
            name2_a => 10,
            name2_b => 10,
            name2_c => 10,
            name2_d => 10,
            name2_e => 'Test',
            name2_f => 'Test',
            name2_g => 'Test',
            name2_h => 'Test',
        },
    },

    # check integer columns
    {
        Insert => {
            name_d  => q{''},
            name_e  => q{''},
            name_f  => q{''},
            name2_e => q{''},
            name2_f => q{''},
            name2_g => q{'Test'},
            name2_h => q{'Test'},
        },
        Select => {
            name_a  => 20,
            name_b  => 0,
            name_c  => 0,
            name_d  => '',
            name_e  => '',
            name_f  => '',
            name2_a => 1,
            name2_b => 0,
            name2_c => 2,
            name2_d => 0,
            name2_e => '',
            name2_f => '',
            name2_g => 'Test',
            name2_h => 'Test',
        },
    },

    # check text columns
    {
        Insert => {
            name_a  => 0,
            name_b  => 0,
            name_c  => 0,
            name2_a => 0,
            name2_b => 0,
            name2_c => 0,
            name2_d => 0,
        },
        Select => {
            name_a  => 0,
            name_b  => 0,
            name_c  => 0,
            name_d  => 'Test1',
            name_e  => '',
            name_f  => '',
            name2_a => 0,
            name2_b => 0,
            name2_c => 0,
            name2_d => 0,
            name2_e => 'Test1',
            name2_f => '',
            name2_g => 'Test2',
            name2_h => '',
        },
    },
];

my $Counter2 = 1;
for my $Test ( @{$DefaultTest2Alter1} ) {

    # create unique id
    my $ID = $UID++;

    my @InsertColumnsSorted = sort { $a cmp $b } keys %{ $Test->{Insert} };
    my @InsertValuesSorted  = map  { $Test->{Insert}->{$_} } @InsertColumnsSorted;
    my $InsertColumns = join q{, }, @InsertColumnsSorted;
    my $InsertValues  = join q{, }, @InsertValuesSorted;

    my $SQLInsert = "INSERT INTO test_f (id, $InsertColumns) VALUES ($ID, $InsertValues)";

    $Self->True(
        $DBObject->Do( SQL => $SQLInsert ) || 0,
        "#7.$Counter2 Do() INSERT",
    );

    for my $Column ( sort { $a cmp $b } keys %{ $Test->{Select} } ) {

        my $SelectedValue;
        my $ReferenceValue = $Test->{Select}->{$Column};

        $DBObject->Prepare(
            SQL   => "SELECT $Column FROM test_f WHERE id = $ID",
            Limit => 1,
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {

            $SelectedValue  = defined $Row[0]         ? $Row[0]         : '';
            $ReferenceValue = defined $ReferenceValue ? $ReferenceValue : '';

            $Self->Is(
                $SelectedValue,
                $ReferenceValue,
                "#7.$Counter2 SELECT check selected value of column '$Column':",
            );
        }
    }

    $Counter2++;

}

$XML = '
<TableAlter Name="test_f">
    <ColumnChange NameOld="name_a" NameNew="name_a" Required="true" Type="INTEGER" />
    <ColumnChange NameOld="name_b" NameNew="name_b" Required="true" Default="0" Type="INTEGER" />
    <ColumnChange NameOld="name_c" NameNew="name_c" Required="true" Default="0" Type="INTEGER" />
    <ColumnChange NameOld="name_d" NameNew="name_d" Required="true" Default="Test1" Size="20" Type="VARCHAR" />
    <ColumnChange NameOld="name_e" NameNew="name_e" Required="true" Size="20" Type="VARCHAR" />
    <ColumnChange NameOld="name_f" NameNew="name_f" Required="true" Default="" Size="20" Type="VARCHAR" />
    <ColumnDrop Name="name2_a" />
    <ColumnDrop Name="name2_b" />
    <ColumnDrop Name="name2_c" />
    <ColumnDrop Name="name2_d" />
    <ColumnDrop Name="name2_e" />
    <ColumnDrop Name="name2_f" />
    <ColumnDrop Name="name2_g" />
    <ColumnDrop Name="name2_h" />
    <ColumnChange NameOld="name3_a" NameNew="name3_a" Required="true" Default="0" Type="INTEGER" />
    <ColumnChange NameOld="name3_b" NameNew="name3_b" Required="true" Default="1" Type="INTEGER" />
    <ColumnChange NameOld="name3_c" NameNew="name3_c" Required="true" Default="" Size="20" Type="VARCHAR" />
    <ColumnChange NameOld="name3_d" NameNew="name3_d" Required="true" Default="Test1" Size="20" Type="VARCHAR" />
</TableAlter>
';
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

my $DefaultTest2Alter2 = [

    # general function test
    {
        Insert => {
            name_a  => 10,
            name_b  => 10,
            name_c  => 10,
            name_d  => q{'Test'},
            name_e  => q{'Test'},
            name_f  => q{'Test'},
            name3_a => 10,
            name3_b => 10,
            name3_c => q{'Test'},
            name3_d => q{'Test'},
        },
        Select => {
            name_a  => 10,
            name_b  => 10,
            name_c  => 10,
            name_d  => 'Test',
            name_e  => 'Test',
            name_f  => 'Test',
            name3_a => 10,
            name3_b => 10,
            name3_c => 'Test',
            name3_d => 'Test',
        },
    },

    # check integer columns
    {
        Insert => {
            name_a  => 100,
            name_d  => q{'Test'},
            name_e  => q{'Test'},
            name_f  => q{'Test'},
            name3_c => q{'Test'},
            name3_d => q{'Test'},
        },
        Select => {
            name_a  => 100,
            name_b  => 0,
            name_c  => 0,
            name_d  => 'Test',
            name_e  => 'Test',
            name_f  => 'Test',
            name3_a => 0,
            name3_b => 1,
            name3_c => 'Test',
            name3_d => 'Test',
        },
    },

    # check text columns
    {
        Insert => {
            name_a  => 0,
            name_b  => 0,
            name_c  => 0,
            name_e  => q{'Test'},
            name3_a => 0,
            name3_b => 0,
        },
        Select => {
            name_a  => 0,
            name_b  => 0,
            name_c  => 0,
            name_d  => 'Test1',
            name_e  => 'Test',
            name_f  => '',
            name3_a => 0,
            name3_b => 0,
            name3_c => '',
            name3_d => 'Test1',
        },
    },
];

my $Counter3 = 1;
for my $Test ( @{$DefaultTest2Alter2} ) {

    # create unique id
    my $ID = $UID++;

    my @InsertColumnsSorted = sort { $a cmp $b } keys %{ $Test->{Insert} };
    my @InsertValuesSorted  = map  { $Test->{Insert}->{$_} } @InsertColumnsSorted;
    my $InsertColumns = join q{, }, @InsertColumnsSorted;
    my $InsertValues  = join q{, }, @InsertValuesSorted;

    my $SQLInsert = "INSERT INTO test_f (id, $InsertColumns) VALUES ($ID, $InsertValues)";

    $Self->True(
        $DBObject->Do( SQL => $SQLInsert ) || 0,
        "#7.$Counter3 Do() INSERT",
    );

    for my $Column ( sort { $a cmp $b } keys %{ $Test->{Select} } ) {

        my $SelectedValue;
        my $ReferenceValue = $Test->{Select}->{$Column};

        $DBObject->Prepare(
            SQL   => "SELECT $Column FROM test_f WHERE id = $ID",
            Limit => 1,
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {

            $SelectedValue  = defined $Row[0]         ? $Row[0]         : '';
            $ReferenceValue = defined $ReferenceValue ? $ReferenceValue : '';

            $Self->Is(
                $SelectedValue,
                $ReferenceValue,
                "#7.$Counter3 SELECT check selected value of column '$Column':",
            );
        }
    }

    $Counter3++;

}

$XML      = '<TableDrop Name="test_f"/>';
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

# auto-increment tests
# only execute this tests on PostgreSQL
return 1 if $DBObject->GetDatabaseFunction('Type') ne 'postgresql';

$XML = '
<TableCreate Name="test_f">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="INTEGER"/>
    <Column Name="name_a" Required="false" Type="INTEGER" />
</TableCreate>
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

my @Tests = (
    {
        Name   => 'Just Insert',
        Insert => {
            name_a => 1,
        },
    },

    {
        Name => 'Change id from Integer to BigInt',
        XML  => << 'END',
<TableAlter Name="test_f">
    <ColumnChange NameOld="id" NameNew="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT"/>
</TableAlter>
END
        Insert => {
            name_a => 1,
        },
    },
    {
        Name => 'Change id to id 2',
        XML  => << 'END',
<TableAlter Name="test_f">
    <ColumnChange NameOld="id" NameNew="id2" Required="true" PrimaryKey="true" AutoIncrement="true" Type="BIGINT"/>
</TableAlter>
END
        Insert => {
            name_a => 1,
        },
    },
    {
        Name => 'Add name_b as AutoIncrement',
        XML  => << 'END',
<TableAlter Name="test_f">
    <ColumnAdd Name="name_b" Required="true" AutoIncrement="true" Type="BIGINT"/>
</TableAlter>
END
        Insert => {
            name_a => 1,
        },
    },
    {
        Name => 'Add id as AutoIncrement',
        XML  => << 'END',
<TableAlter Name="test_f">
    <ColumnAdd Name="id" Required="true" AutoIncrement="true" Type="BIGINT"/>
</TableAlter>
END
        Insert => {
            name_a => 1,
        },
    },

);

for my $Test (@Tests) {

    if ( $Test->{XML} ) {
        my @XMLARRAY = $XMLObject->XMLParse(
            String => $Test->{XML},
        );
        my @SQL = $DBObject->SQLProcessor(
            Database => \@XMLARRAY,
        );
        $Self->True(
            $SQL[0],
            "$Test->{Name} SQLProcessor() ALTER TABLE",
        );

        for my $SQL (@SQL) {
            $Self->True(
                $DBObject->Do( SQL => $SQL ) || 0,
                "$Test->{Name} Do() ALTER TABLE ($SQL)",
            );
        }
    }
    if ( $Test->{Insert} ) {
        my @InsertColumnsSorted = sort { $a cmp $b } keys %{ $Test->{Insert} };
        my @InsertValuesSorted  = map  { $Test->{Insert}->{$_} } @InsertColumnsSorted;
        my $InsertColumns = join q{, }, @InsertColumnsSorted;
        my $InsertValues  = join q{, }, @InsertValuesSorted;

        my $SQLInsert = "INSERT INTO test_f ($InsertColumns) VALUES ($InsertValues)";

        $Self->True(
            $DBObject->Do( SQL => $SQLInsert ) || 0,
            "$Test->{Name} Do() INSERT",
        );
    }
}

$XML      = '<TableDrop Name="test_f"/>';
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

# cleanup cache is done by RestoreDatabase.

1;
