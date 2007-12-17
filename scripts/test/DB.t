# --
# DB.t - database tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: DB.t,v 1.14.2.5 2007-12-17 16:08:44 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::XML;

$Self->{XMLObject} = Kernel::System::XML->new(%{$Self});

# ---
# quoting tests
# ---
$Self->Is(
    $Self->{DBObject}->Quote(0, 'Integer'),
    0,
    'Quote() Integer - 0',
);
$Self->Is(
    $Self->{DBObject}->Quote(1, 'Integer'),
    1,
    'Quote() Integer - 1',
);
$Self->Is(
    $Self->{DBObject}->Quote(123, 'Integer'),
    123,
    'Quote() Integer - 123',
);
$Self->Is(
    $Self->{DBObject}->Quote(61712, 'Integer'),
    61712,
    'Quote() Integer - 61712',
);
$Self->Is(
    $Self->{DBObject}->Quote(-61712, 'Integer'),
    -61712,
    'Quote() Integer - -61712',
);
$Self->Is(
    $Self->{DBObject}->Quote('+61712', 'Integer'),
    '+61712',
    'Quote() Integer - +61712',
);
$Self->Is(
    $Self->{DBObject}->Quote('02', 'Integer'),
    '02',
    'Quote() Integer - 02',
);
$Self->Is(
    $Self->{DBObject}->Quote('0000123', 'Integer'),
    '0000123',
    'Quote() Integer - 0000123',
);

$Self->Is(
    $Self->{DBObject}->Quote(123.23, 'Number'),
    123.23,
    'Quote() Number - 123.23',
);
$Self->Is(
    $Self->{DBObject}->Quote(0.23, 'Number'),
    0.23,
    'Quote() Number - 0.23',
);
$Self->Is(
    $Self->{DBObject}->Quote('+123.23', 'Number'),
    '+123.23',
    'Quote() Number - +123.23',
);
$Self->Is(
    $Self->{DBObject}->Quote('+0.23132', 'Number'),
    '+0.23132',
    'Quote() Number - +0.23132',
);
$Self->Is(
    $Self->{DBObject}->Quote('+12323', 'Number'),
    '+12323',
    'Quote() Number - +12323',
);
$Self->Is(
    $Self->{DBObject}->Quote(-123.23, 'Number'),
    -123.23,
    'Quote() Number - -123.23',
);
$Self->Is(
    $Self->{DBObject}->Quote(-123, 'Number'),
    -123,
    'Quote() Number - -123',
);
$Self->Is(
    $Self->{DBObject}->Quote(-0.23, 'Number'),
    -0.23,
    'Quote() Number - -0.23',
);

if ($Self->{ConfigObject}->Get('DatabaseDSN') =~ /pg/i) {
    $Self->Is(
        $Self->{DBObject}->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $Self->{DBObject}->Quote("Test'l;"),
        'Test\'\'l\\;',
        'Quote() String - Test\'l;',
    );
}
elsif ($Self->{ConfigObject}->Get('DatabaseDSN') =~ /oracle/i) {
    $Self->Is(
        $Self->{DBObject}->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $Self->{DBObject}->Quote("Test'l;"),
        'Test\'\'l;',
        'Quote() String - Test\'l;',
    );
}
elsif ($Self->{DBObject}->{'DB::Type'} =~ /mssql/i) {
    $Self->Is(
        $Self->{DBObject}->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $Self->{DBObject}->Quote("Test'l;"),
        'Test\'\'l;',
        'Quote() String - Test\'l;',
    );
}
elsif ($Self->{DBObject}->{'DB::Type'} =~ /maxdb/i) {
    $Self->Is(
        $Self->{DBObject}->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $Self->{DBObject}->Quote("Test'l;"),
        'Test\'\'l\\\;',
        'Quote() String - Test\'l;',
    );
}
else {
    $Self->Is(
        $Self->{DBObject}->Quote("Test'l"),
        'Test\\\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $Self->{DBObject}->Quote("Test'l;"),
        'Test\\\'l\\;',
        'Quote() String - Test\'l;',
    );
}

# ---
# XML test 1 (XML:TableCreate, SQL:Insert, SQL:Select, SQL:Delete,  XML:TableDrop)
# ---
my $XML = '
<TableCreate Name="test_a">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
    <Index Name="index_test_name_a">
        <IndexColumn Name="name_a"/>
    </Index>
</TableCreate>
';
my @XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
my @SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#1 SQLProcessorPost() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#1 Do() CREATE TABLE ($SQL)",
    );
}

$Self->True(
    $Self->{DBObject}->Do(
        SQL => 'INSERT INTO test_a (name_a, name_b) VALUES (\'Some\', \'Lalala\')',
    ) || 0,
    '#1 Do() INSERT',
);

$Self->True(
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM test_a WHERE name_a = \'Some\'',
        Limit => 1,
    ),
    '#1 Prepare() SELECT - Prepare',
);

$Self->True(
    ref($Self->{DBObject}->FetchrowArray()) eq '' &&
        ref($Self->{DBObject}->FetchrowArray()) eq '',
    '#1 FetchrowArray () SELECT',
);

$Self->True(
    $Self->{DBObject}->Do(
        SQL => 'DELETE FROM valid WHERE name = \'Some\'',
    ) || 0,
    '#1 Do() DELETE',
);

$XML = '<TableDrop Name="test_a"/>';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#1 SQLProcessorPost() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#1 Do() DROP TABLE ($SQL)",
    );
}

# ---
# XML test 2 (XML:TableCreate, XML:TableAlter, XML:Insert (size check),
# SQL:Insert (size check), SQL:Delete,  XML:TableDrop)
# ---
$XML = '
<TableCreate Name="test_a">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="SMALLINT"/>
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="500000" Type="VARCHAR"/>
    <Index Name="index_test_name_a">
        <IndexColumn Name="name_a"/>
    </Index>
</TableCreate>
';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#2 SQLProcessorPost() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#2 Do() CREATE TABLE ($SQL)",
    );
}

$XML = '
<TableAlter Name="test_a">
    <ColumnAdd Name="test2" Type="varchar" Size="20" Required="true"/>
    <ColumnChange NameOld="test2" NameNew="test3" Type="varchar" Size="30" Required="false"/>
    <ColumnChange NameOld="test3" NameNew="test3" Type="varchar" Size="30" Required="true"/>
    <ColumnDrop Name="test3"/>
</TableAlter>
';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#2 SQLProcessorPost() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#2 Do() CREATE TABLE ($SQL)",
    );
}

$XML = '
<Insert Table="test_a">
    <Data Key="name_a" Type="Quote">Some1</Data>
    <Data Key="name_b" Type="Quote">Lalala1</Data>
</Insert>
';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#2 SQLProcessorPost() INSERT 1',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#2 Do() XML INSERT 1 ($SQL)",
    );
}

$Self->True(
    $Self->{DBObject}->Do(
        SQL => 'INSERT INTO test_a (name_a, name_b) VALUES (\'Some2\', \'Lalala2\')',
    ) || 0,
    '#2 Do() SQL INSERT 1',
);
# xml
my $String = '';
for my $Count (1..6) {
    $String .= $String.$Count."abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxy ";
    my $Length = length($String);
    my $Size = $Length;
    my $Key = 'Some116'.$Count;
    if ($Size > (1024*1024)) {
         $Size = sprintf "%.1f MBytes", ($Size/(1024*1024));
    }
    elsif ($Size > 1024) {
         $Size = sprintf "%.1f KBytes", (($Size/1024));
    }
    else {
         $Size = $Size.' Bytes';
    }
    $XML = '
        <Insert Table="test_a">
            <Data Key="name_a" Type="Quote">'.$Key.'</Data>
            <Data Key="name_b" Type="Quote">'.$String.'</Data>
        </Insert>
    ';
    @XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
    @SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
    $Self->True(
        $SQL[0],
        "#2 SQLProcessorPost() INSERT 2 - $Count",
    );

    for my $SQL (@SQL) {
        # insert
        $Self->True(
            $Self->{DBObject}->Do(SQL => $SQL) || 0,
            "#2 Do() XML INSERT 2 - $Count (length:$Length/$Size)",
        );
        # select
        $Self->{DBObject}->Prepare(
            SQL => 'SELECT name_b FROM test_a WHERE name_a = \''.$Key.'\'',
        );
        my $LengthBack = 0;
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $LengthBack = length($Row[0]);
        }
        $Self->Is(
            $LengthBack,
            $Length,
            "#2 Do() SQL SELECT 2 - $Count",
        );
    }
}
# sql
$String = '';
for my $Count (1..6) {
    $String .= $String.$Count."abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz";
    my $Length = length($String);
    my $Size = $Length;
    my $Key = 'Some216'.$Count;
    if ($Size > (1024*1024)) {
         $Size = sprintf "%.1f MBytes", ($Size/(1024*1024));
    }
    elsif ($Size > 1024) {
         $Size = sprintf "%.1f KBytes", (($Size/1024));
    }
    else {
         $Size = $Size.' Bytes';
    }
    # insert
    $Self->True(
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO test_a (name_a, name_b) VALUES ('$Key', '$String')",
        ) || 0,
        "#2 Do() SQL INSERT 2 - $Count (length:$Length/$Size)",
    );
    # select
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT name_b FROM test_a WHERE name_a = \''.$Key.'\'',
    );
    my $LengthBack = 0;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $LengthBack = length($Row[0]);
    }
    $Self->Is(
        $LengthBack,
        $Length,
        "#2 Do() SQL SELECT 2 - $Count",
    );
}
# sql bind
$String = '';
for my $Count (1..19) {
    $String .= $String." $Count abcdefghijklmno1234567890";
    my $Length = length($String);
    my $Size = $Length;
    my $Key = 'Some119'.$Count;
    if ($Size > (1024*1024)) {
         $Size = sprintf "%.1f MBytes", ($Size/(1024*1024));
    }
    elsif ($Size > 1024) {
         $Size = sprintf "%.1f KBytes", (($Size/1024));
    }
    else {
         $Size = $Size.' Bytes';
    }
    # insert
    $Self->True(
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO test_a (name_a, name_b) VALUES ('$Key', ?)",
            Bind => [\$String],
        ) || 0,
        "#2 Do() SQL INSERT (bind) 2 - $Count (length:$Length/$Size)",
    );
    # select
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT name_b FROM test_a WHERE name_a = \''.$Key.'\'',
    );
    my $LengthBack = 0;
    while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $LengthBack = length($Row[0]);
    }
    $Self->Is(
        $LengthBack,
        $Length,
        "#2 Do() SQL SELECT 2 - $Count",
    );
}

$Self->True(
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM test_a WHERE name_a = \'Some1\'',
        Limit => 1,
    ) || 0,
    '#2 Prepare() SELECT - Prepare - Limit 1',
);

$Self->True(
    ref($Self->{DBObject}->FetchrowArray()) eq '' &&
        ref($Self->{DBObject}->FetchrowArray()) eq '',
    '#2 FetchrowArray () SELECT - Limit 1',
);

$Self->True(
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM test_a WHERE name_a like \'Some%\'',
        Limit => 1,
    ) || 0,
    '#2 Prepare() SELECT - Prepare - Limit 1 - like',
);

$Self->True(
    ref($Self->{DBObject}->FetchrowArray()) eq '' &&
        ref($Self->{DBObject}->FetchrowArray()) eq '',
    '#2 FetchrowArray () SELECT - Limit 1 - like',
);

$Self->True(
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM test_a WHERE name_a like \'Some%\'',
        Limit => 3,
    ) || 0,
    '#2 Prepare() SELECT - Prepare - Limit 2 - like',
);

$Self->True(
    ref($Self->{DBObject}->FetchrowArray()) eq '' &&
    ref($Self->{DBObject}->FetchrowArray()) eq '' &&
    ref($Self->{DBObject}->FetchrowArray()) eq '' &&
        ref($Self->{DBObject}->FetchrowArray()) eq '',
    '#2 FetchrowArray () SELECT - Limit 2 - like',
);
$Self->True(
    $Self->{DBObject}->Do(
        SQL => 'DELETE FROM test_a WHERE name_a like \'Some%\'',
    ) || 0,
    '#2 Do() DELETE',
);

$XML = '<TableDrop Name="test_a"/>';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#2 SQLProcessorPost() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#2 Do() DROP TABLE ($SQL)",
    );
}

# ---
# XML test 3 (XML:TableCreate, XML:Insert, SQL:Select (Start/Limit checks) XML:TableDrop)
# ---
$XML = '
<TableCreate Name="test_b">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="SMALLINT"/>
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="500" Type="VARCHAR"/>
    <Index Name="index_test_name_a">
        <IndexColumn Name="name_a"/>
    </Index>
</TableCreate>
';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#3 SQLProcessorPost() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#3 Do() CREATE TABLE ($SQL)",
    );
}

# xml
for my $Count (1..40) {
    my $Value = 'Some140'.$Count;
    my $Length = length($Value);
    $XML = '
        <Insert Table="test_b">
            <Data Key="name_a" Type="Quote">'.$Value.'</Data>
            <Data Key="name_b" Type="Quote">'.$Count.'</Data>
        </Insert>
    ';
    @XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
    @SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
    $Self->True(
        $SQL[0],
        "#3 SQLProcessorPost() INSERT - $Count",
    );

    for my $SQL (@SQL) {
        # insert
        $Self->True(
            $Self->{DBObject}->Do(SQL => $SQL) || 0,
            "#3 Do() XML INSERT - $Count ",
        );
        # select
        $Self->{DBObject}->Prepare(
            SQL => 'SELECT name_a FROM test_b WHERE name_b = \''.$Count.'\'',
        );
        my $LengthBack = 0;
        while (my @Row = $Self->{DBObject}->FetchrowArray()) {
            $LengthBack = length($Row[0]);
        }
        $Self->Is(
            $LengthBack,
            $Length,
            "#3 Do() SQL SELECT - $Count",
        );
    }
}

$Self->True(
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM test_b WHERE name_a like \'Some%\' ORDER BY id',
        Start => 15,
        Limit => 12,
    ) || 0,
    '#3 Prepare() SELECT - Prepare - Start 15 - Limit 12 - like',
);

my $Count = 0;
my $Start = '';
my $End = '';
while (my @Row = $Self->{DBObject}->FetchrowArray()) {
    if (!$Start) {
        $Start = $Row[2];
    }
    $End = $Row[2];
    $Count++;
}

$Self->Is(
    $Count,
    12,
    '#3 FetchrowArray () SELECT - Start 15 - Limit 12 - like - count',
);

$Self->Is(
    $Start,
    16,
    '#3 FetchrowArray () SELECT - Start 15 - Limit 12 - like - start',
);

$Self->Is(
    $End,
    27,
    '#3 FetchrowArray () SELECT - Start 15 - Limit 12 - like - end',
);

$Count = 0;
$Start = '';
$End = '';
$Self->True(
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM test_b WHERE name_a like \'Some%\' ORDER BY id',
        Start => 15,
        Limit => 40,
    ) || 0,
    '#3 Prepare() SELECT - Prepare - Start 15 - Limit 40 - like',
);
while (my @Row = $Self->{DBObject}->FetchrowArray()) {
    if (!$Start) {
        $Start = $Row[2];
    }
    $End = $Row[2];
    $Count++;
}

$Self->Is(
    $Count,
    25,
    '#3 FetchrowArray () SELECT - Start 15 - Limit 40 - like - count',
);

$Self->Is(
    $Start,
    16,
    '#3 FetchrowArray () SELECT - Start 15 - Limit 40 - like - start',
);

$Self->Is(
    $End,
    40,
    '#3 FetchrowArray () SELECT - Start 15 - Limit 40 - like - end',
);

$Count = 0;
$Start = 0;
$End = 0;
$Self->True(
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM test_b WHERE name_a like \'Some%\' ORDER BY id',
        Start => 200,
        Limit => 10,
    ) || 0,
    '#3 Prepare() SELECT - Prepare - Start 10 - Limit 200 - like',
);
while (my @Row = $Self->{DBObject}->FetchrowArray()) {
    if (!$Start) {
        $Start = $Row[2];
    }
    $End = $Row[2];
    $Count++;
}

$Self->Is(
    $Count,
    0,
    '#3 FetchrowArray () SELECT - Start 10 - Limit 200 - like - count',
);

$Self->Is(
    $Start,
    0,
    '#3 FetchrowArray () SELECT - Start 10 - Limit 200 - like - start',
);

$Self->Is(
    $End,
    0,
    '#3 FetchrowArray () SELECT - Start 10 - Limit 200 - like - end',
);

$XML = '<TableDrop Name="test_b"/>';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#3 SQLProcessorPost() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#3 Do() DROP TABLE ($SQL)",
    );
}

# ---
# XML test 4 - SELECT * ... LIKE ...
# ---
$XML = '
<TableCreate Name="test_c">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
</TableCreate>
';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#4 SQLProcessorPost() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#4 Do() CREATE TABLE ($SQL)",
    );
}

my $Inserts = [
    "INSERT INTO test_c (name_a, name_b) VALUES ( 'Block[1]Block[1]', 'Test1' )",
    "INSERT INTO test_c (name_a, name_b) VALUES ( 'Block[1]Block[2]', 'Test2' )",
    "INSERT INTO test_c (name_a, name_b) VALUES ( 'Block[2]Block[1]', 'Test3' )",
    "INSERT INTO test_c (name_a, name_b) VALUES ( 'Block[2]Block[2]', 'Test4' )",
    "INSERT INTO test_c (name_a, name_b) VALUES ( 'Block[11]Block[22]', 'Test5' )",
    "INSERT INTO test_c (name_a, name_b) VALUES ( 'Block[22]Block[11]', 'Test6' )",
    "INSERT INTO test_c (name_a, name_b) VALUES ( 'Block[12]Block[12]', 'Test7' )",
];

for my $Insert (@{$Inserts}) {
    $Self->True(
        $Self->{DBObject}->Do( SQL => $Insert ) || 0,
        '#4 Do() INSERT',
    );
}

my $LikeTests = [
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE 'Block[%]Block[%]'",
        Result => {
            Test1 => 1,
            Test2 => 1,
            Test3 => 1,
            Test4 => 1,
            Test5 => 1,
            Test6 => 1,
            Test7 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE 'Block[1]Block[%]'",
        Result => {
            Test1 => 1,
            Test2 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE 'Block[2]Block[%]'",
        Result => {
            Test3 => 1,
            Test4 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE 'Block[2]Block[1]'",
        Result => {
            Test3 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE 'Block[%]Block[1]'",
        Result => {
            Test1 => 1,
            Test3 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE 'Block[11]Block[%]'",
        Result => {
            Test5 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE 'Block[22]Block[%]'",
        Result => {
            Test6 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE 'Block[%]Block[%1]'",
        Result => {
            Test1 => 1,
            Test3 => 1,
            Test6 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE 'Block[12]Block[12]'",
        Result => {
            Test7 => 1,
        },
    },
];

for my $TestRef ( @{$LikeTests} ) {
    my $SQLSelect = $TestRef->{Select};
    my $Result = $TestRef->{Result};

    $Self->{DBObject}->Prepare( SQL => $SQLSelect );

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Self->True( $Result->{ $Row[0] }, "#4 SELECT ... LIKE ... - $Row[0]" );
        delete $Result->{ $Row[0] };
    }
    for my $Test (keys %{$Result}) {
        $Self->False( $Test, "#4 SELECT ... LIKE ... - $Test" );
        delete $Result->{$Test};
    }
}

$XML = '<TableDrop Name="test_c"/>';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#4 SQLProcessorPost() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#4 Do() DROP TABLE ($SQL)",
    );
}

# ---
# XML test 5 - INSERT special characters test
# ---
$XML = '
<TableCreate Name="test_d">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
</TableCreate>
';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#5 SQLProcessorPost() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#5 Do() CREATE TABLE ($SQL)",
    );
}

my $InsertTest = [
    {
        name_a => 'Test1',
        name_b => '-',
    },
    {
        name_a => 'Test2',
        name_b => ';',
    },
    {
        name_a => 'Test3',
        name_b => '\'',
    },
    {
        name_a => 'Test4',
        name_b => '\"',
    },
    {
        name_a => 'Test5',
        name_b => '\\',
    },
];

for my $Test (@{$InsertTest}) {
    my $name_a = $Self->{DBObject}->Quote("$Test->{name_a}");
    my $name_b = $Self->{DBObject}->Quote("$Test->{name_b}");

    my $SQLInsert = "INSERT INTO test_d (name_a, name_b) VALUES ( '$name_a', '$name_b' )";

    $Self->True(
        $Self->{DBObject}->Do( SQL => $SQLInsert ) || 0,
        '#5 Do() INSERT',
    );
}

for my $Test (@{$InsertTest}) {
    my $name_a = $Test->{name_a};
    my $name_b = $Test->{name_b};

    my $SQLSelect = "SELECT name_b FROM test_d WHERE name_a = '$name_a'";

    $Self->{DBObject}->Prepare( SQL => $SQLSelect, Limit => 1);

    while ( my @Row = $Self->{DBObject}->FetchrowArray() ) {
        $Self->True(
            $Row[0] eq $Test->{name_b},
            "#5 Check special character $Test->{name_b}",
        );
    }
}

$XML = '<TableDrop Name="test_d"/>';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#5 SQLProcessorPost() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#5 Do() DROP TABLE ($SQL)",
    );
}

1;
