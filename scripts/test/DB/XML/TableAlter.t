# --
# TableAlter.t - database tests
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

my $Counter3 = 1;
for my $Test ( @{$DefaultTest2Insert} ) {

    # create unique id
    my $ID = int rand 30_000;

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
}
continue {
    $Counter3++;
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

my $Counter4 = 1;
for my $Test ( @{$DefaultTest2Alter1} ) {

    # create unique id
    my $ID = int rand 30_000;

    my @InsertColumnsSorted = sort { $a cmp $b } keys %{ $Test->{Insert} };
    my @InsertValuesSorted  = map  { $Test->{Insert}->{$_} } @InsertColumnsSorted;
    my $InsertColumns = join q{, }, @InsertColumnsSorted;
    my $InsertValues  = join q{, }, @InsertValuesSorted;

    my $SQLInsert = "INSERT INTO test_f (id, $InsertColumns) VALUES ($ID, $InsertValues)";

    $Self->True(
        $DBObject->Do( SQL => $SQLInsert ) || 0,
        "#7.$Counter4 Do() INSERT",
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
                "#7.$Counter4 SELECT check selected value of column '$Column':",
            );
        }
    }
}
continue {
    $Counter4++;
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

my $Counter5 = 1;
for my $Test ( @{$DefaultTest2Alter2} ) {

    # create unique id
    my $ID = int rand 30_000;

    my @InsertColumnsSorted = sort { $a cmp $b } keys %{ $Test->{Insert} };
    my @InsertValuesSorted  = map  { $Test->{Insert}->{$_} } @InsertColumnsSorted;
    my $InsertColumns = join q{, }, @InsertColumnsSorted;
    my $InsertValues  = join q{, }, @InsertValuesSorted;

    my $SQLInsert = "INSERT INTO test_f (id, $InsertColumns) VALUES ($ID, $InsertValues)";

    $Self->True(
        $DBObject->Do( SQL => $SQLInsert ) || 0,
        "#7.$Counter5 Do() INSERT",
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
                "#7.$Counter5 SELECT check selected value of column '$Column':",
            );
        }
    }
}
continue {
    $Counter5++;
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

1;
