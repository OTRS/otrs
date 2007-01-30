# --
# DB.t - database tests
# Copyright (C) 2001-2007 OTRS GmbH, http://otrs.org/
# --
# $Id: DB.t,v 1.7 2007-01-30 17:33:25 tr Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use Kernel::System::XML;

$Self->{XMLObject} = Kernel::System::XML->new(%{$Self});

# tests
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
        $Self->{DBObject}->Do(SQL => $SQL),
        "#1 Do() CREATE TABLE ($SQL)",
    );
}

$Self->True(
    $Self->{DBObject}->Do(
        SQL => 'INSERT INTO test_a (name_a, name_b) VALUES (\'Some\', \'Lalala\')',
    ),
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
    ),
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
        $Self->{DBObject}->Do(SQL => $SQL),
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
        $Self->{DBObject}->Do(SQL => $SQL),
        "#2 Do() CREATE TABLE ($SQL)",
    );
}

$XML = '
<TableAlter Name="test_a">
    <ColumnAdd Name="test2" Type="varchar" Size="20" Required="true"/>
    <ColumnChange NameOld="test2" NameNew="test3" Type="varchar" Size="30" Required="true"/>
    <ColumnChange NameOld="test3" NameNew="test3" Type="varchar" Size="30" Required="false"/>
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
        $Self->{DBObject}->Do(SQL => $SQL),
        "#2 Do() CREATE TABLE ($SQL)",
    );
}

$Self->True(
    $Self->{DBObject}->Do(
        SQL => 'INSERT INTO test_a (name_a, name_b) VALUES (\'Some\', \'Lalala\')',
    ),
    '#2 Do() INSERT 1',
);
my $String = '';
foreach (1..14) {
    $String .= $String." $_ abcdefghijklmno1234567890";
    $Self->True(
        $Self->{DBObject}->Do(
            SQL => "INSERT INTO test_a (name_a, name_b) VALUES ('Some', 'Lalala $String')",
        ),
        "#2 Do() INSERT 2 - $_ (length:".length($String).")",
    );
}

$Self->True(
    $Self->{DBObject}->Prepare(
        SQL => 'SELECT * FROM test_a WHERE name_a = \'Some\'',
        Limit => 1,
    ),
    '#2 Prepare() SELECT - Prepare',
);

$Self->True(
    ref($Self->{DBObject}->FetchrowArray()) eq '' &&
        ref($Self->{DBObject}->FetchrowArray()) eq '',
    '#2 FetchrowArray () SELECT',
);

$Self->True(
    $Self->{DBObject}->Do(
        SQL => 'DELETE FROM valid WHERE name = \'Some\'',
    ),
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
        $Self->{DBObject}->Do(SQL => $SQL),
        "#2 Do() DROP TABLE ($SQL)",
    );
}

1;
