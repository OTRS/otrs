# --
# DB.t - database tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: DB.t,v 1.10 2007-03-09 14:48:56 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::XML;

$Self->{XMLObject} = Kernel::System::XML->new(%{$Self});

# tests
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

# XML test 1
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

foreach my $SQL (@SQL) {
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

foreach my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#1 Do() DROP TABLE ($SQL)",
    );
}

# XML test 2
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

foreach my $SQL (@SQL) {
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

foreach my $SQL (@SQL) {
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

foreach my $SQL (@SQL) {
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
foreach (1..6) {
    $String .= $String.$_."abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz";
    my $Length = length($String);
    my $Size = $Length;
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
            <Data Key="name_a" Type="Quote">Some'.$_.'</Data>
            <Data Key="name_b" Type="Quote">Lalala '.$String.'</Data>
        </Insert>
    ';
    @XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
    @SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
    $Self->True(
        $SQL[0],
        "#2 SQLProcessorPost() INSERT 2 - $_",
    );

    foreach my $SQL (@SQL) {
        $Self->True(
            $Self->{DBObject}->Do(SQL => $SQL) || 0,
            "#2 Do() XML INSERT 2 - $_ (length:$Length/$Size)",
        );
    }
}
# sql
$String = '';
foreach (1..6) {
    $String .= $String.$_."abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz";
    my $Length = length($String);
    my $Size = $Length;
    if ($Size > (1024*1024)) {
         $Size = sprintf "%.1f MBytes", ($Size/(1024*1024));
    }
    elsif ($Size > 1024) {
         $Size = sprintf "%.1f KBytes", (($Size/1024));
    }
    else {
         $Size = $Size.' Bytes';
    }
    $Self->True(
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO test_a (name_a, name_b) VALUES ('Some".$_."', '$String')",
        ) || 0,
        "#2 Do() SQL INSERT 2 - $_ (length:$Length/$Size)",
    );
}
# sql bind
$String = '';
foreach (1..18) {
    $String .= $String." $_ abcdefghijklmno1234567890";
    my $Length = length($String);
    my $Size = $Length;
    if ($Size > (1024*1024)) {
         $Size = sprintf "%.1f MBytes", ($Size/(1024*1024));
    }
    elsif ($Size > 1024) {
         $Size = sprintf "%.1f KBytes", (($Size/1024));
    }
    else {
         $Size = $Size.' Bytes';
    }
    $Self->True(
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO test_a (name_a, name_b) VALUES ('Some".$_."', ?)",
            Bind => [\$String],
        ) || 0,
        "#2 Do() SQL INSERT (bind) 2 - $_ (length:$Length/$Size)",

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

foreach my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#2 Do() DROP TABLE ($SQL)",
    );
}

# XML test 3
$XML = '
<TableCreate Name="test_b">
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
    '#3 SQLProcessorPost() CREATE TABLE',
);

foreach my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#3 Do() CREATE TABLE ($SQL)",
    );
}

# xml
foreach (1..40) {
    $XML = '
        <Insert Table="test_b">
            <Data Key="name_a" Type="Quote">Some</Data>
            <Data Key="name_b" Type="Quote">'.$_.'</Data>
        </Insert>
    ';
    @XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
    @SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
    $Self->True(
        $SQL[0],
        "#3 SQLProcessorPost() INSERT - $_",
    );

    foreach my $SQL (@SQL) {
        $Self->True(
            $Self->{DBObject}->Do(SQL => $SQL) || 0,
            "#3 Do() XML INSERT - $_ ",
        );
    }
}

$Self->True(
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM test_b WHERE name_a like \'Some%\' ORDER BY id',
        Start => 15,
        Limit => 12,
    ) || 0,
    '#2 Prepare() SELECT - Prepare - Start 15 - Limit 12 - like',
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

$XML = '<TableDrop Name="test_b"/>';
@XMLARRAY = $Self->{XMLObject}->XMLParse(String => $XML);
@SQL = $Self->{DBObject}->SQLProcessor(Database => \@XMLARRAY);
$Self->True(
    $SQL[0],
    '#3 SQLProcessorPost() DROP TABLE',
);

foreach my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do(SQL => $SQL) || 0,
        "#3 Do() DROP TABLE ($SQL)",
    );
}

1;
