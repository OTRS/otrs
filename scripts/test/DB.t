# --
# DB.t - database tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# $Id: DB.t,v 1.88.2.3 2012-10-24 13:34:53 ub Exp $
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
# quoting tests
# ------------------------------------------------------------ #
$Self->Is(
    $DBObject->Quote( 0, 'Integer' ),
    0,
    'Quote() Integer - 0',
);
$Self->Is(
    $DBObject->Quote( 1, 'Integer' ),
    1,
    'Quote() Integer - 1',
);
$Self->Is(
    $DBObject->Quote( 123, 'Integer' ),
    123,
    'Quote() Integer - 123',
);
$Self->Is(
    $DBObject->Quote( 61712, 'Integer' ),
    61712,
    'Quote() Integer - 61712',
);
$Self->Is(
    $DBObject->Quote( -61712, 'Integer' ),
    -61712,
    'Quote() Integer - -61712',
);
$Self->Is(
    $DBObject->Quote( '+61712', 'Integer' ),
    '+61712',
    'Quote() Integer - +61712',
);
$Self->Is(
    $DBObject->Quote( '02', 'Integer' ),
    '02',
    'Quote() Integer - 02',
);
$Self->Is(
    $DBObject->Quote( '0000123', 'Integer' ),
    '0000123',
    'Quote() Integer - 0000123',
);

$Self->Is(
    $DBObject->Quote( 123.23, 'Number' ),
    123.23,
    'Quote() Number - 123.23',
);
$Self->Is(
    $DBObject->Quote( 0.23, 'Number' ),
    0.23,
    'Quote() Number - 0.23',
);
$Self->Is(
    $DBObject->Quote( '+123.23', 'Number' ),
    '+123.23',
    'Quote() Number - +123.23',
);
$Self->Is(
    $DBObject->Quote( '+0.23132', 'Number' ),
    '+0.23132',
    'Quote() Number - +0.23132',
);
$Self->Is(
    $DBObject->Quote( '+12323', 'Number' ),
    '+12323',
    'Quote() Number - +12323',
);
$Self->Is(
    $DBObject->Quote( -123.23, 'Number' ),
    -123.23,
    'Quote() Number - -123.23',
);
$Self->Is(
    $DBObject->Quote( -123, 'Number' ),
    -123,
    'Quote() Number - -123',
);
$Self->Is(
    $DBObject->Quote( -0.23, 'Number' ),
    -0.23,
    'Quote() Number - -0.23',
);

if ( $DBObject->GetDatabaseFunction('Type') eq 'postgresql' ) {
    $Self->Is(
        $DBObject->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $DBObject->Quote("Test'l;"),
        'Test\'\'l;',
        'Quote() String - Test\'l;',
    );

    $Self->Is(
        $DBObject->Quote( "Block[12]Block[12]", 'Like' ),
        'Block[12]Block[12]',
        'Quote() Like-String - Block[12]Block[12]',
    );
}
elsif ( $DBObject->GetDatabaseFunction('Type') eq 'postgresql_before_8_2' ) {
    $Self->Is(
        $DBObject->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $DBObject->Quote("Test'l;"),
        'Test\'\'l\\;',
        'Quote() String - Test\'l;',
    );

    $Self->Is(
        $DBObject->Quote( "Block[12]Block[12]", 'Like' ),
        'Block[12]Block[12]',
        'Quote() Like-String - Block[12]Block[12]',
    );
}
elsif ( $DBObject->GetDatabaseFunction('Type') eq 'oracle' ) {
    $Self->Is(
        $DBObject->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $DBObject->Quote("Test'l;"),
        'Test\'\'l;',
        'Quote() String - Test\'l;',
    );

    $Self->Is(
        $DBObject->Quote( "Block[12]Block[12]", 'Like' ),
        'Block[12]Block[12]',
        'Quote() Like-String - Block[12]Block[12]',
    );
}
elsif ( $DBObject->GetDatabaseFunction('Type') eq 'mssql' ) {
    $Self->Is(
        $DBObject->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $DBObject->Quote("Test'l;"),
        'Test\'\'l;',
        'Quote() String - Test\'l;',
    );

    $Self->Is(
        $DBObject->Quote( "Block[12]Block[12]", 'Like' ),
        'Block[[]12]Block[[]12]',
        'Quote() Like-String - Block[12]Block[12]',
    );
}
elsif ( $DBObject->GetDatabaseFunction('Type') eq 'db2' ) {
    $Self->Is(
        $DBObject->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $DBObject->Quote("Test'l;"),
        'Test\'\'l;',
        'Quote() String - Test\'l;',
    );

    $Self->Is(
        $DBObject->Quote( "Block[12]Block[12]", 'Like' ),
        'Block[12]Block[12]',
        'Quote() Like-String - Block[12]Block[12]',
    );
}
elsif ( $DBObject->GetDatabaseFunction('Type') eq 'ingres' ) {
    $Self->Is(
        $DBObject->Quote("Test'l"),
        'Test\'\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $DBObject->Quote("Test'l;"),
        'Test\'\'l;',
        'Quote() String - Test\'l;',
    );

    $Self->Is(
        $DBObject->Quote( "Block[12]Block[12]", 'Like' ),
        'Block[12]Block[12]',
        'Quote() Like-String - Block[12]Block[12]',
    );
}
else {
    $Self->Is(
        $DBObject->Quote("Test'l"),
        'Test\\\'l',
        'Quote() String - Test\'l',
    );

    $Self->Is(
        $DBObject->Quote("Test'l;"),
        'Test\\\'l\\;',
        'Quote() String - Test\'l;',
    );

    $Self->Is(
        $DBObject->Quote( "Block[12]Block[12]", 'Like' ),
        'Block[12]Block[12]',
        'Quote() Like-String - Block[12]Block[12]',
    );
}

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
    '#1 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#1 Do() CREATE TABLE ($SQL)",
    );
}

$Self->True(
    $DBObject->Do(
        SQL => 'INSERT INTO test_a (name_a, name_b) VALUES (\'Some\', \'Lalala\')',
        )
        || 0,
    '#1 Do() INSERT',
);

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_a WHERE name_a = \'Some\'',
        Limit => 1,
    ),
    '#1 Prepare() SELECT - Prepare',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    '#1 FetchrowArray () SELECT',
);

# rename table
$XML      = '<TableAlter NameOld="test_a" NameNew="test_aa"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#1 SQLProcessor() ALTER TABLE',
);
for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#1 Do() ALTER TABLE ($SQL)",
    );
}

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_aa WHERE name_a = \'Some\'',
        Limit => 1,
    ),
    '#1 Prepare() SELECT - Prepare',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    '#1 FetchrowArray () SELECT',
);

$Self->True(
    $DBObject->Do(
        SQL => 'DELETE FROM valid WHERE name = \'Some\'',
        )
        || 0,
    '#1 Do() DELETE',
);

$XML      = '<TableDrop Name="test_aa"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#1 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#1 Do() DROP TABLE ($SQL)",
    );
}

# ------------------------------------------------------------ #
# XML test 2 (XML:TableCreate, XML:TableAlter, XML:Insert (size check),
# SQL:Insert (size check), SQL:Delete,  XML:TableDrop)
# ------------------------------------------------------------ #
$XML = '
<TableCreate Name="test_a">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="SMALLINT"/>
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="5000000" Type="VARCHAR"/>
    <Index Name="index_test_name_a">
        <IndexColumn Name="name_a"/>
    </Index>
</TableCreate>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#2 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#2 Do() CREATE TABLE ($SQL)",
    );
}

$XML = '
<TableAlter Name="test_a">
    <ColumnAdd Name="test2" Type="varchar" Size="20" Required="true"/>
    <ColumnChange NameOld="test2" NameNew="test3" Type="varchar" Size="30" Required="false"/>
    <ColumnChange NameOld="test3" NameNew="test3" Type="varchar" Size="30" Required="true"/>
    <IndexCreate Name="index_test3">
        <IndexColumn Name="test3"/>
    </IndexCreate>
    <IndexDrop Name="index_test3"/>
    <UniqueCreate Name="uniq_test3">
        <UniqueColumn Name="test3"/>
    </UniqueCreate>
    <UniqueDrop Name="uniq_test3"/>
    <ColumnDrop Name="test3"/>
</TableAlter>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#2 SQLProcessor() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#2 Do() ALTER TABLE ($SQL)",
    );
}

$XML = '
<Insert Table="test_a">
    <Data Key="name_a" Type="Quote">Some1</Data>
    <Data Key="name_b" Type="Quote">Lalala1</Data>
</Insert>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#2 SQLProcessor() INSERT 1',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#2 Do() XML INSERT 1 ($SQL)",
    );
}

$Self->True(
    $DBObject->Do(
        SQL => 'INSERT INTO test_a (name_a, name_b) VALUES (\'Some2\', \'Lalala2\')',
        )
        || 0,
    '#2 Do() SQL INSERT 1',
);

# xml
my $String = '';
for my $Count ( 1 .. 6 ) {
    $String .= $String . $Count . "abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxy ";
    my $Length = length($String);
    my $Size   = $Length;
    my $Key    = 'Some116' . $Count;
    if ( $Size > ( 1024 * 1024 ) ) {
        $Size = sprintf "%.1f MBytes", ( $Size / ( 1024 * 1024 ) );
    }
    elsif ( $Size > 1024 ) {
        $Size = sprintf "%.1f KBytes", ( ( $Size / 1024 ) );
    }
    else {
        $Size = $Size . ' Bytes';
    }
    $XML = '
        <Insert Table="test_a">
            <Data Key="name_a" Type="Quote">' . $Key . '</Data>
            <Data Key="name_b" Type="Quote">' . $String . '</Data>
        </Insert>
    ';
    @XMLARRAY = $XMLObject->XMLParse( String => $XML );
    @SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
    $Self->True(
        $SQL[0],
        "#2 SQLProcessor() INSERT 2 - $Count",
    );

    for my $SQL (@SQL) {

        # insert
        $Self->True(
            $DBObject->Do( SQL => $SQL ) || 0,
            "#2 Do() XML INSERT 2 - $Count (length:$Length/$Size)",
        );

        # select
        $DBObject->Prepare(
            SQL => 'SELECT name_b FROM test_a WHERE name_a = \'' . $Key . '\'',
        );
        my $LengthBack = 0;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $LengthBack = length( $Row[0] );
        }
        $Self->Is(
            $LengthBack,
            $Length,
            "#2 Do() SQL SELECT 2 - $Count",
        );

        # select bind
        $DBObject->Prepare(
            SQL  => 'SELECT name_b FROM test_a WHERE name_a = ?',
            Bind => [ \$Key ],
        );
        $LengthBack = 0;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $LengthBack = length( $Row[0] );
        }
        $Self->Is(
            $LengthBack,
            $Length,
            "#2 Do() SQL SELECT (bind) 2 - $Count",
        );
    }
}

# sql
$String = '';
for my $Count ( 1 .. 6 ) {
    $String .= $String . $Count . "abcdefghijklmnopqrstuvwxyz1234567890abcdefghijklmnopqrstuvwxyz";
    my $Length = length($String);
    my $Size   = $Length;
    my $Key    = 'Some216' . $Count;
    if ( $Size > ( 1024 * 1024 ) ) {
        $Size = sprintf "%.1f MBytes", ( $Size / ( 1024 * 1024 ) );
    }
    elsif ( $Size > 1024 ) {
        $Size = sprintf "%.1f KBytes", ( ( $Size / 1024 ) );
    }
    else {
        $Size = $Size . ' Bytes';
    }

    # insert
    $Self->True(
        $DBObject->Do(
            SQL => "INSERT INTO test_a (name_a, name_b) VALUES ('$Key', '$String')",
            )
            || 0,
        "#2 Do() SQL INSERT 2 - $Count (length:$Length/$Size)",
    );

    # select
    $DBObject->Prepare(
        SQL => 'SELECT name_b FROM test_a WHERE name_a = \'' . $Key . '\'',
    );
    my $LengthBack = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $LengthBack = length( $Row[0] );
    }
    $Self->Is(
        $LengthBack,
        $Length,
        "#2 Do() SQL SELECT 2 - $Count",
    );
}

# sql bind
$String = '';
for my $Count ( 1 .. 19 ) {
    $String .= $String . " $Count abcdefghijklmno1234567890";
    my $Length = length($String);
    my $Size   = $Length;
    my $Key    = 'Some119' . $Count;
    if ( $Size > ( 1024 * 1024 ) ) {
        $Size = sprintf "%.1f MBytes", ( $Size / ( 1024 * 1024 ) );
    }
    elsif ( $Size > 1024 ) {
        $Size = sprintf "%.1f KBytes", ( ( $Size / 1024 ) );
    }
    else {
        $Size = $Size . ' Bytes';
    }

    # insert
    $Self->True(
        $DBObject->Do(
            SQL  => "INSERT INTO test_a (name_a, name_b) VALUES ('$Key', ?)",
            Bind => [ \$String ],
            )
            || 0,
        "#2 Do() SQL INSERT (bind) 2 - $Count (length:$Length/$Size)",
    );

    # select
    $DBObject->Prepare(
        SQL => 'SELECT name_b FROM test_a WHERE name_a = \'' . $Key . '\'',
    );
    my $LengthBack = 0;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $LengthBack = length( $Row[0] );
    }
    $Self->Is(
        $LengthBack,
        $Length,
        "#2 Do() SQL SELECT 2 - $Count",
    );
}

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_a WHERE name_a = \'Some1\'',
        Limit => 1,
        )
        || 0,
    '#2 Prepare() SELECT - Prepare - Limit 1',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    '#2 FetchrowArray () SELECT - Limit 1',
);

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_a WHERE name_a like \'Some%\'',
        Limit => 1,
        )
        || 0,
    '#2 Prepare() SELECT - Prepare - Limit 1 - like',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    '#2 FetchrowArray () SELECT - Limit 1 - like',
);

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_a WHERE name_a like \'Some%\'',
        Limit => 3,
        )
        || 0,
    '#2 Prepare() SELECT - Prepare - Limit 2 - like',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq ''     &&
        ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    '#2 FetchrowArray () SELECT - Limit 2 - like',
);
$Self->True(
    $DBObject->Do(
        SQL => 'DELETE FROM test_a WHERE name_a like \'Some%\'',
        )
        || 0,
    '#2 Do() DELETE',
);

$XML      = '<TableDrop Name="test_a"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#2 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#2 Do() DROP TABLE ($SQL)",
    );
}

# ------------------------------------------------------------ #
# XML test 3 (XML:TableCreate, XML:Insert, SQL:Select (Start/Limit checks) XML:TableDrop)
# ------------------------------------------------------------ #
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
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#3 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#3 Do() CREATE TABLE ($SQL)",
    );
}

# xml
for my $Count ( 1 .. 40 ) {
    my $Value  = 'Some140' . $Count;
    my $Length = length($Value);
    $XML = '
        <Insert Table="test_b">
            <Data Key="name_a" Type="Quote">' . $Value . '</Data>
            <Data Key="name_b" Type="Quote">' . $Count . '</Data>
        </Insert>
    ';
    @XMLARRAY = $XMLObject->XMLParse( String => $XML );
    @SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
    $Self->True(
        $SQL[0],
        "#3 SQLProcessor() INSERT - $Count",
    );

    for my $SQL (@SQL) {

        # insert
        $Self->True(
            $DBObject->Do( SQL => $SQL ) || 0,
            "#3 Do() XML INSERT - $Count ",
        );

        # select
        $DBObject->Prepare(
            SQL => 'SELECT name_a FROM test_b WHERE name_b = \'' . $Count . '\'',
        );
        my $LengthBack = 0;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $LengthBack = length( $Row[0] );
        }
        $Self->Is(
            $LengthBack,
            $Length,
            "#3 Do() SQL SELECT - $Count",
        );
    }
}

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_b WHERE name_a like \'Some%\' ORDER BY id',
        Start => 15,
        Limit => 12,
        )
        || 0,
    '#3 Prepare() SELECT - Prepare - Start 15 - Limit 12 - like',
);

my $Count = 0;
my $Start = '';
my $End   = '';
while ( my @Row = $DBObject->FetchrowArray() ) {
    if ( !$Start ) {
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
$End   = '';
$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_b WHERE name_a like \'Some%\' ORDER BY id',
        Start => 15,
        Limit => 40,
        )
        || 0,
    '#3 Prepare() SELECT - Prepare - Start 15 - Limit 40 - like',
);
while ( my @Row = $DBObject->FetchrowArray() ) {
    if ( !$Start ) {
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
$End   = 0;
$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_b WHERE name_a like \'Some%\' ORDER BY id',
        Start => 200,
        Limit => 10,
        )
        || 0,
    '#3 Prepare() SELECT - Prepare - Start 10 - Limit 200 - like',
);
while ( my @Row = $DBObject->FetchrowArray() ) {
    if ( !$Start ) {
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

$XML      = '<TableDrop Name="test_b"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#3 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#3 Do() DROP TABLE ($SQL)",
    );
}

# ------------------------------------------------------------ #
# XML test 4 - SELECT * ... LIKE ...
# ------------------------------------------------------------ #
$XML = '
<TableCreate Name="test_c">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
</TableCreate>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#4 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
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

for my $Insert ( @{$Inserts} ) {
    $Self->True(
        $DBObject->Do( SQL => $Insert ) || 0,
        '#4 Do() INSERT',
    );
}

my $LikeTests = [
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE '"
            . $DBObject->Quote( "Block[%]Block[%]", 'Like' )
            . "'",
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
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE '"
            . $DBObject->Quote( "Block[1]Block[%]", 'Like' )
            . "'",
        Result => {
            Test1 => 1,
            Test2 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE '"
            . $DBObject->Quote( "Block[2]Block[%]", 'Like' )
            . "'",
        Result => {
            Test3 => 1,
            Test4 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE '"
            . $DBObject->Quote( "Block[2]Block[1]", 'Like' )
            . "'",
        Result => {
            Test3 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE '"
            . $DBObject->Quote( "Block[%]Block[1]", 'Like' )
            . "'",
        Result => {
            Test1 => 1,
            Test3 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE '"
            . $DBObject->Quote( "Block[11]Block[%]", 'Like' )
            . "'",
        Result => {
            Test5 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE '"
            . $DBObject->Quote( "Block[22]Block[%]", 'Like' )
            . "'",
        Result => {
            Test6 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE '"
            . $DBObject->Quote( "Block[%]Block[%1]", 'Like' )
            . "'",
        Result => {
            Test1 => 1,
            Test3 => 1,
            Test6 => 1,
        },
    },
    {
        Select => "SELECT name_b FROM test_c WHERE name_a LIKE '"
            . $DBObject->Quote( "Block[12]Block[12]", 'Like' )
            . "'",
        Result => {
            Test7 => 1,
        },
    },
];

for my $TestRef ( @{$LikeTests} ) {
    my $SQLSelect = $TestRef->{Select};
    my $Result    = $TestRef->{Result};

    $DBObject->Prepare( SQL => $SQLSelect );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->True( $Result->{ $Row[0] }, "#4 SELECT ... LIKE ... - $Row[0]" );
        delete $Result->{ $Row[0] };
    }
    for my $Test ( keys %{$Result} ) {
        $Self->False( $Test, "#4 SELECT ... LIKE ... - $Test" );
        delete $Result->{$Test};
    }
}

$XML      = '<TableDrop Name="test_c"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#4 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#4 Do() DROP TABLE ($SQL)",
    );
}

# ------------------------------------------------------------ #
# XML test 5 - INSERT special characters test
# ------------------------------------------------------------ #
$XML = '
<TableCreate Name="test_d">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
</TableCreate>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#5 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#5 Do() CREATE TABLE ($SQL)",
    );
}

my @SpecialCharacters = qw( - _ . : ; ' " \ [ ] { } ( ) < > ? ! $ % & / + * = ' ^ | ö ス);
push @SpecialCharacters, ( ',', '#', 'otrs test', 'otrs_test' );
my $Counter = 0;

for my $Character (@SpecialCharacters) {
    $Self->{EncodeObject}->EncodeInput( \$Character );
    my $name_b = $DBObject->Quote($Character);

    # insert
    my $Result = $DBObject->Do(
        SQL => "INSERT INTO test_d (name_a, name_b) VALUES ( '$Counter', '$name_b' )",
    );
    $Self->True(
        $Result,
        "#5.$Counter Do() INSERT",
    );

    # select = $Counter
    $Result = $DBObject->Prepare(
        SQL   => "SELECT name_b FROM test_d WHERE name_a = '$Counter'",
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter Prepare() SELECT = \$Counter",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->True(
            $Row[0] eq $Character,
            "#5.$Counter Check special character $Character by 'eq' (db returned $Row[0])",
        );
        my $Hit = 0;
        if ( $Row[0] =~ /\Q$Character\E/ ) {
            $Hit = 1;
        }
        $Self->True(
            $Hit || 0,
            "#5.$Counter Check special character $Character by RegExp (db returned $Row[0])",
        );
    }

    # select = value
    $Result = $DBObject->Prepare(
        SQL   => "SELECT name_b FROM test_d WHERE name_b = '$name_b'",
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter Prepare() SELECT = value",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->True(
            $Row[0] eq $Character,
            "#5.$Counter Check special character $Character by 'eq' (db returned $Row[0])",
        );
        my $Hit = 0;
        if ( $Row[0] =~ /\Q$Character\E/ ) {
            $Hit = 1;
        }
        $Self->True(
            $Hit || 0,
            "#5.$Counter Check special character $Character by RegExp (db returned $Row[0])",
        );
    }

    # select like value
    $name_b = $DBObject->Quote( $Character, 'Like' );
    $Result = $DBObject->Prepare(
        SQL   => "SELECT name_b FROM test_d WHERE name_b LIKE '$name_b'",
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter Prepare() SELECT LIKE value",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        next if $Character eq '%';    # do not test %, because it's wanted as % for like
        $Self->True(
            $Row[0] eq $Character,
            "#5.$Counter Check special character $Character by 'eq' (db returned $Row[0])",
        );
        my $Hit = 0;
        if ( $Row[0] =~ /\Q$Character\E/ ) {
            $Hit = 1;
        }
        $Self->True(
            $Hit || 0,
            "#5.$Counter Check special character $Character by RegExp (db returned $Row[0])",
        );
    }

    $Counter++;
}

# special test for like with _ (underscore)
{

    # select like value (with space)
    my $name_b = $DBObject->Quote( 'otrs test', 'Like' );
    my $SQL = "SELECT COUNT(name_b) FROM test_d WHERE name_b LIKE '$name_b'";

    my $Result = $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter Prepare() SELECT COUNT LIKE $name_b (space)",
    );
    my $Count;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
    }
    $Self->Is(
        $Count,
        1,
        "#5.$Counter $SQL (space)",
    );

    # select like value (with underscore)
    $name_b = $DBObject->Quote( 'otrs_test', 'Like' );
    $SQL = "SELECT COUNT(name_b) FROM test_d WHERE name_b LIKE '$name_b'";

    # proof of concept that oracle needs special treatment
    # with underscores in LIKE argument, it always needs the ESCAPE parameter
    # if you want to search for a literal _ (underscore)
    # get like escape string needed for some databases (e.g. oracle)
    # this does no harm for other databases, so it should always be used where
    # a LIKE search is used
    my $LikeEscapeString = $DBObject->GetDatabaseFunction('LikeEscapeString');
    $SQL .= $LikeEscapeString;

    $Result = $DBObject->Prepare(
        SQL   => $SQL,
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter Prepare() SELECT COUNT LIKE $name_b (underscore)",
    );
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Count = $Row[0];
    }
    $Self->Is(
        $Count,
        1,
        "#5.$Counter $SQL (underscore)",
    );

    # do the same again for oracle but without the ESCAPE and expect this to fail
    if ( $DBObject->GetDatabaseFunction('Type') eq 'oracle' ) {
        $SQL    = "SELECT COUNT(name_b) FROM test_d WHERE name_b LIKE '$name_b'";
        $Result = $DBObject->Prepare(
            SQL   => $SQL,
            Limit => 1,
        );
        $Self->True(
            $Result,
            "#5.$Counter Prepare() SELECT COUNT LIKE $name_b (underscore)",
        );
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $Count = $Row[0];
        }
        $Self->IsNot(
            $Count,
            1,
            "#5.$Counter $SQL (underscore)",
        );
    }
}

my @UTF8Tests = (
    {

        # composed UTF8 char (german umlaut a)
        InsertData => Encode::encode( 'UTF8', "\x{E4}" ),
        SelectData => Encode::encode( 'UTF8', "\x{E4}" ),
        ResultData => "\x{E4}",
    },
    {

        # decomposed UTF8 char (german umlaut a)
        InsertData => Encode::encode( 'UTF8', "\x{61}\x{308}" ),
        SelectData => Encode::encode( 'UTF8', "\x{61}\x{308}" ),
        ResultData => "\x{61}\x{308}",
    },
    {

        # decomposed UTF8 char (german umlaut a)
        InsertData => Encode::encode( 'UTF8', "\x{61}\x{308}" ),
        SelectData => Encode::encode( 'UTF8', "\x{E4}" ),
        ResultData => undef,
    },
    {

        # composed UTF8 char (smal a with grave)
        InsertData => Encode::encode( 'UTF8', "\x{E0}" ),
        SelectData => Encode::encode( 'UTF8', "\x{E0}" ),
        ResultData => "\x{E0}",
    },
    {

        # decomposed UTF8 char (smal a with grave)
        InsertData => Encode::encode( 'UTF8', "\x{61}\x{300}" ),
        SelectData => Encode::encode( 'UTF8', "\x{61}\x{300}" ),
        ResultData => "\x{61}\x{300}",
    },
    {

        # decomposed UTF8 char (smal a with grave)
        InsertData => Encode::encode( 'UTF8', "\x{61}\x{300}" ),
        SelectData => Encode::encode( 'UTF8', "\x{E0}" ),
        ResultData => undef,
    },
);

UTF8TEST:
for my $UTF8Test (@UTF8Tests) {

    # extract needed test data
    my %TestData = %{$UTF8Test};

    my $Result = $DBObject->Do(
        SQL  => 'INSERT INTO test_d (name_a, name_b) VALUES (?, ?)',
        Bind => [ \$Counter, \$TestData{InsertData} ],
    );
    $Self->True(
        $Result,
        "#5.$Counter UTF8: insert test",
    );

    # check insert result
    next UTF8TEST if !$Result;

    $Result = $DBObject->Prepare(
        SQL   => 'SELECT name_b FROM test_d WHERE name_a = ? AND name_b = ?',
        Bind  => [ \$Counter, \$TestData{SelectData}, ],
        Limit => 1,
    );
    $Self->True(
        $Result,
        "#5.$Counter UTF8: prepare SELECT stmt",
    );

    # check prepare result
    next UTF8TEST if !$Result;

    my @UTF8ResultSet;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @UTF8ResultSet, $Row[0];
    }

    $Self->Is(
        $UTF8ResultSet[0],
        $TestData{ResultData},
        "#5.$Counter UTF8: check result data",
    );
}
continue {
    $Counter++;
}

$XML      = '<TableDrop Name="test_d"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#5 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#5 Do() DROP TABLE ($SQL)",
    );
}

# ------------------------------------------------------------ #
# XML test 6 - default value test (create table)
# ------------------------------------------------------------ #
$XML = '
<TableCreate Name="test_e">
    <Column Name="id" Required="true" Type="INTEGER"/>
    <Column Name="name_a" Required="false" Default="1" Type="INTEGER" />
    <Column Name="name_b" Required="false" Default="0" Type="INTEGER" />
    <Column Name="name_c" Required="true" Default="2" Type="INTEGER" />
    <Column Name="name_d" Required="true" Default="0" Type="INTEGER" />
    <Column Name="name_e" Required="false" Default="Test1" Size="20" Type="VARCHAR" />
    <Column Name="name_f" Required="false" Default="" Size="20" Type="VARCHAR" />
    <Column Name="name_g" Required="true" Default="Test2" Size="20" Type="VARCHAR" />
    <Column Name="name_h" Required="true" Default="" Size="20" Type="VARCHAR" />
</TableCreate>
';

@XMLARRAY = $XMLObject->XMLParse( String => $XML );

@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#6 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#6 Do() CREATE TABLE ($SQL)",
    );
}

my $DefaultTest = [

    # general function test
    {
        Insert => {
            name_a => 10,
            name_b => 10,
            name_c => 10,
            name_d => 10,
            name_e => q{'Test'},
            name_f => q{'Test'},
            name_g => q{'Test'},
            name_h => q{'Test'},
        },
        Select => {
            name_a => 10,
            name_b => 10,
            name_c => 10,
            name_d => 10,
            name_e => 'Test',
            name_f => 'Test',
            name_g => 'Test',
            name_h => 'Test',
        },
    },

    # check integer columns
    {
        Insert => {
            name_e => q{''},
            name_f => q{''},
            name_g => q{'Test'},
            name_h => q{'Test'},
        },
        Select => {
            name_a => 1,
            name_b => 0,
            name_c => 2,
            name_d => 0,
            name_e => '',
            name_f => '',
            name_g => 'Test',
            name_h => 'Test',
        },
    },

    # check text columns
    {
        Insert => {
            name_a => 0,
            name_b => 0,
            name_c => 0,
            name_d => 0,
        },
        Select => {
            name_a => 0,
            name_b => 0,
            name_c => 0,
            name_d => 0,
            name_e => 'Test1',
            name_f => '',
            name_g => 'Test2',
            name_h => '',
        },
    },
];

my $Counter2 = 1;
for my $Test ( @{$DefaultTest} ) {

    # create unique id
    my $ID = int rand 30_000;

    my @InsertColumnsSorted = sort { $a cmp $b } keys %{ $Test->{Insert} };
    my @InsertValuesSorted  = map  { $Test->{Insert}->{$_} } @InsertColumnsSorted;
    my $InsertColumns = join q{, }, @InsertColumnsSorted;
    my $InsertValues  = join q{, }, @InsertValuesSorted;

    my $SQLInsert = "INSERT INTO test_e (id, $InsertColumns) VALUES ($ID, $InsertValues)";

    $Self->True(
        $DBObject->Do( SQL => $SQLInsert ) || 0,
        "#6.$Counter2 Do() INSERT",
    );

    for my $Column ( sort { $a cmp $b } keys %{ $Test->{Select} } ) {

        my $SelectedValue;
        my $ReferenceValue = $Test->{Select}->{$Column};

        $DBObject->Prepare(
            SQL   => "SELECT $Column FROM test_e WHERE id = $ID",
            Limit => 1,
        );

        while ( my @Row = $DBObject->FetchrowArray() ) {

            $SelectedValue  = defined $Row[0]         ? $Row[0]         : '';
            $ReferenceValue = defined $ReferenceValue ? $ReferenceValue : '';

            $Self->Is(
                $SelectedValue,
                $ReferenceValue,
                "#6.$Counter2 SELECT check selected value of column '$Column':",
            );
        }
    }
}
continue {
    $Counter2++;
}

$XML      = '<TableDrop Name="test_e"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#6 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#6 Do() DROP TABLE ($SQL)",
    );
}

# ------------------------------------------------------------ #
# XML test 7 - default value test (alter table)
# ------------------------------------------------------------ #
$XML = '
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
@XMLARRAY = $XMLObject->XMLParse( String => $XML );

@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#7 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#7 Do() CREATE TABLE ($SQL)",
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
    <ColumnChange NameOld="name_b" NameNew="name_b" Required="false" Type="INTEGER" />
    <ColumnChange NameOld="name_c" NameNew="name_c" Required="false" Default="0" Type="INTEGER" />
    <ColumnChange NameOld="name_d" NameNew="name_d" Required="false" Default="Test1" Size="20" Type="VARCHAR" />
    <ColumnChange NameOld="name_e" NameNew="name_e" Required="false" Size="20" Type="VARCHAR" />
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
    '#7 SQLProcessor() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#7 Do() ALTER TABLE ($SQL)",
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
            name_b  => '',
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
    '#7 SQLProcessor() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#7 Do() ALTER TABLE ($SQL)",
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
    '#7 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#7 Do() DROP TABLE ($SQL)",
    );
}

# ------------------------------------------------------------ #
# QueryCondition tests
# ------------------------------------------------------------ #
$XML = '
<TableCreate Name="test_condition">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
</TableCreate>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#8 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#8 Do() CREATE TABLE ($SQL)",
    );
}

my %Fill = (
    Some1 => 'John Smith',
    Some2 => 'John Meier',
    Some3 => 'Franz Smith',
    Some4 => 'Franz Ferdinand Smith',
    Some5 => 'customer_id_with_underscores',
    Some6 => 'customer&id&with&ampersands',
    Some7 => 'Test (with) (brackets)',
    Some8 => 'Test (with) (brackets) and & and |',
);
for my $Key ( sort keys %Fill ) {
    my $SQL = "INSERT INTO test_condition (name_a, name_b) VALUES ('$Key', '$Fill{$Key}')";
    my $Do  = $DBObject->Do(
        SQL => $SQL,
    );
    $Self->True(
        $Do,
        "#8 Do() INSERT ($SQL)",
    );
}
my @Queries = (
    {
        Query  => 'franz ferdinand',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 1,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
            }
    },
    {
        Query  => 'john+smith',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => 'john+smith+ ',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => 'john+smith+',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '+john+smith',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john+smith)',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john+smith)+',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john&&smith)',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john && smith)',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john && smi*h)',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john && smi**h)',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john||smith)',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 1,
            Some4 => 1,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john || smith)',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 1,
            Some4 => 1,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(smith || john)',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 1,
            Some4 => 1,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john AND smith)',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john AND smith)',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(john AND)',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(franz+)',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 1,
            Some4 => 1,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '((john+smith) OR meier)',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '((john1+smith1) OR meier)',
        Result => {
            Some1 => 0,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => 'fritz',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '!fritz',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 1,
            Some4 => 1,
            Some5 => 1,
            Some6 => 1,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => '!franz',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 1,
            Some6 => 1,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => '!franz*',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 1,
            Some6 => 1,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => '!*franz*',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 1,
            Some6 => 1,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => '*!*franz*',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 1,
            Some6 => 1,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => '*!franz*',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 1,
            Some6 => 1,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => '(!fritz+!bob)',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 1,
            Some4 => 1,
            Some5 => 1,
            Some6 => 1,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => '((!fritz+!bob)+i)',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 1,
            Some4 => 1,
            Some5 => 1,
            Some6 => 1,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => '((john+smith) OR (meier+john))',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '((john+smith)OR(meier+john))',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '((john+smith)  OR     ( meier+ john))',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '((john+smith)  OR     (meier+ john))',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(("john smith")  OR     (meier+ john))',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '"john smith"',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '( "john smith" )',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '"smith john"',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '(("john NOTHING smith")  OR     (meier+ john))',
        Result => {
            Some1 => 0,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '((smith+john)|| (meier+john))',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '((john+smith)||  (meier+john))',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '*',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 1,
            Some4 => 1,
            Some5 => 1,
            Some6 => 1,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => 'Franz Ferdinand',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 1,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => 'ferdinand',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 1,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => 'franz ferdinand smith',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 1,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => 'smith',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 1,
            Some4 => 1,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => 'customer_id_with_underscores',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 1,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => 'customer_*',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 1,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '*_*',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 1,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '_',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 1,
            Some6 => 0,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '!_',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 1,
            Some4 => 1,
            Some5 => 0,
            Some6 => 1,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => 'customer&id&with&ampersands',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 1,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => 'customer&*',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 1,
            Some7 => 0,
            Some8 => 0,
        },
    },
    {
        Query  => '*&*',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 1,
            Some7 => 0,
            Some8 => 1,
        },
    },
    {
        Query  => '&',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 1,
            Some7 => 0,
            Some8 => 1,
        },
    },
    {
        Query  => '!&',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 1,
            Some4 => 1,
            Some5 => 1,
            Some6 => 0,
            Some7 => 1,
            Some8 => 0,
        },
    },
    {
        Query  => '\(with\)',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => 'Test AND ( \(with\) OR \(brackets\) )',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 1,
            Some8 => 1,
        },
    },
    {
        Query  => 'Test AND ( \(with\) OR \(brackets\) ) AND \|',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
            Some4 => 0,
            Some5 => 0,
            Some6 => 0,
            Some7 => 0,
            Some8 => 1,
        },
    },
);

# select's
for my $Query (@Queries) {
    my $Condition = $DBObject->QueryCondition(
        Key          => 'name_b',
        Value        => $Query->{Query},
        SearchPrefix => '*',
        SearchSuffix => '*',
    );
    $DBObject->Prepare(
        SQL => 'SELECT name_a FROM test_condition WHERE ' . $Condition,
    );
    my %Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result{ $Row[0] } = 1;
    }
    for my $Check ( sort keys %{ $Query->{Result} } ) {
        $Self->Is(
            $Result{$Check} || 0,
            $Query->{Result}->{$Check} || 0,
            "#8 Do() SQL SELECT $Query->{Query} / $Check",
        );
    }
}
@Queries = (
    {
        Query  => 'john+smith',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
        },
    },
    {
        Query  => '(john && smi*h)',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
        },
    },
    {
        Query  => '(john && smi**h*)',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
        },
    },
    {
        Query  => '(john+smith+some)',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
        },
    },
    {
        Query  => '(john+smith+!some)',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
        },
    },
    {
        Query  => '(john+smith+(!some1||!some2))',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
        },
    },
    {
        Query  => '(john+smith+(!some1||some))',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
        },
    },
    {
        Query  => '(!smith+some2)',
        Result => {
            Some1 => 0,
            Some2 => 1,
            Some3 => 0,
        },
    },
    {
        Query  => 'smith AND some2 OR some1',
        Result => {
            Some1 => 1,
            Some2 => 0,
            Some3 => 0,
        },
    },
    {
        Query  => '(john+(!max||!hans))',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
        },
    },
    {
        Query  => '(john+(!max&&!hans))',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 0,
        },
    },
    {
        Query  => '((max||hans)&&!kkk)',
        Result => {
            Some1 => 0,
            Some2 => 0,
            Some3 => 0,
        },
    },
    {
        Query  => '*',
        Result => {
            Some1 => 1,
            Some2 => 1,
            Some3 => 1,
        },
    },
);

# select's
for my $Query (@Queries) {
    my $Condition = $DBObject->QueryCondition(
        Key          => [ 'name_a', 'name_b', 'name_a', 'name_a' ],
        Value        => $Query->{Query},
        SearchPrefix => '*',
        SearchSuffix => '*',
    );
    $DBObject->Prepare(
        SQL => 'SELECT name_a FROM test_condition WHERE ' . $Condition,
    );
    my %Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Result{ $Row[0] } = 1;
    }
    for my $Check ( sort keys %{ $Query->{Result} } ) {
        $Self->Is(
            $Result{$Check} || 0,
            $Query->{Result}->{$Check} || 0,
            "#8 Do() SQL SELECT $Query->{Query} / $Check",
        );
    }
}

# Query condition cleanup test - Checks if '* *' is converted correctly to '*'
{
    my $Condition = $DBObject->QueryCondition(
        Key   => 'name_a',
        Value => '* *',
    );
    $DBObject->Prepare(
        SQL => 'SELECT name_a FROM test_condition WHERE ' . $Condition,
    );
    my @Result;
    while ( my @Row = $DBObject->FetchrowArray() ) {
        push @Result, $Row[0];
    }
    $Self->True(
        scalar @Result,
        "#8 QueryCondition cleanup test - Convert '* *' to '*'",
    );
}

$XML      = '<TableDrop Name="test_condition"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#8 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#8 Do() DROP TABLE ($SQL)",
    );
}

# ------------------------------------------------------------ #
# check foreign keys
# ------------------------------------------------------------ #
$XML = '
<SQL>
    <TableCreate Name="test_foreignkeys_1">
        <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="SMALLINT"/>
        <Column Name="name_a" Required="true" Type="INTEGER" />
        <Column Name="name_b" Required="false" Default="0" Type="INTEGER" />
        <Unique>
            <UniqueColumn Name="name_a"/>
        </Unique>
    </TableCreate>
    <TableCreate Name="test_foreignkeys_2">
        <Column Name="name_a" Required="true" Type="INTEGER" />
        <Column Name="name_b" Required="false" Default="0" Type="INTEGER" />
        <ForeignKey ForeignTable="test_foreignkeys_1">
            <Reference Local="name_a" Foreign="name_a"/>
        </ForeignKey>
    </TableCreate>
    <Insert Table="test_foreignkeys_1">
        <Data Key="name_a">1</Data>
        <Data Key="name_b">1</Data>
    </Insert>
    <Insert Table="test_foreignkeys_1">
        <Data Key="name_a">2</Data>
        <Data Key="name_b">2</Data>
    </Insert>
    <Insert Table="test_foreignkeys_1">
        <Data Key="name_a">3</Data>
        <Data Key="name_b">3</Data>
    </Insert>
    <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">1</Data>
        <Data Key="name_b">100</Data>
    </Insert>
        <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">1</Data>
        <Data Key="name_b">101</Data>
    </Insert>
    <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">2</Data>
        <Data Key="name_b">200</Data>
    </Insert>
    <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">2</Data>
        <Data Key="name_b">201</Data>
    </Insert>
    <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">3</Data>
        <Data Key="name_b">300</Data>
    </Insert>
    <Insert Table="test_foreignkeys_2">
        <Data Key="name_a">3</Data>
        <Data Key="name_b">301</Data>
    </Insert>
</SQL>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );

@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#9 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#9 Do() CREATE TABLE ($SQL)",
    );
}

@SQL = $DBObject->SQLProcessorPost();
$Self->True(
    $SQL[0],
    '#9 SQLProcessorPost() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#9 Do() ALTER TABLE ($SQL)",
    );
}

# remove the foreign key
$XML = '
<TableAlter Name="test_foreignkeys_2">
    <ForeignKeyDrop ForeignTable="test_foreignkeys_1">
        <Reference Local="name_a" Foreign="name_a"/>
    </ForeignKeyDrop>
</TableAlter>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );

@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#9 SQLProcessor() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#9 Do() ALTER TABLE ($SQL)",
    );
}

# delete the column
$XML = '
<TableAlter Name="test_foreignkeys_1">
    <ColumnDrop Name="name_a"/>
</TableAlter>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );

@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#9 SQLProcessor() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#9 Do() ALTER TABLE ($SQL)",
    );
}

# drop the test tables
$XML = '
<SQL>
    <TableDrop Name="test_foreignkeys_1"/>
    <TableDrop Name="test_foreignkeys_2"/>
</SQL>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#9 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#9 Do() DROP TABLE ($SQL)",
    );
}

# ------------------------------------------------------------ #
# XML test 10 - SQL functions: LOWER(), UPPER()
# ------------------------------------------------------------ #
# test different sizes up to 3999.
# 4000 is a magic value, beyond which locator objects might be used
# and all bets regarding UPPER and LOWER are off
$XML = '
<TableCreate Name="test_j">
    <Column Name="name_a" Required="true" Size="6"    Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60"   Type="VARCHAR"/>
    <Column Name="name_c" Required="true" Size="600"  Type="VARCHAR"/>
    <Column Name="name_d" Required="true" Size="3998" Type="VARCHAR"/>
</TableCreate>
';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#10 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#10 Do() CREATE TABLE ($SQL)",
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
    "#10 Do() INSERT",
);

my $SQL = 'SELECT LOWER(name_a), LOWER(name_b), LOWER(name_c), LOWER(name_d) FROM test_j';
$Result = $DBObject->Prepare(
    SQL   => $SQL,
    Limit => 1,
);
$Self->True(
    $Result,
    '#10 Prepare() - LOWER() - SELECT',
);
while ( my @Row = $DBObject->FetchrowArray() ) {
    $Self->Is(
        scalar(@Row),
        scalar(@Values),
        "#10 - LOWER() - Check number of fetched elements",
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
    '#10 Prepare() - UPPER() - SELECT',
);
while ( my @Row = $DBObject->FetchrowArray() ) {
    $Self->Is(
        scalar(@Row),
        scalar(@Values),
        "#10 - UPPER() - Check number of fetched elements",
    );

    for my $Index ( 0 .. 3 ) {
        $Self->Is(
            $Row[$Index],
            uc( $Values[$Index] ),
            "#10.$Index - UPPER() - result",
        );
    }
}

$XML      = '<TableDrop Name="test_j"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $DBObject->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#10 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#10 Do() DROP TABLE ($SQL)",
    );
}

#
# Statement size checks
#
for my $QuerySize (
    100, 500, 1_000, 1_050, 2_000, 2_100, 3_000, 3_200,
    4_000, 4_400, 5_000, 10_000, 100_000, 1_000_000
    )
{
    my $SQL = 'SELECT' . ( ' ' x ( $QuerySize - 31 ) ) . '1 FROM valid WHERE id = 1';

    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "#11 QuerySize check for size $QuerySize",
    );
}

my @Tests = (
    {
        Name   => 'empty',
        Data   => '',
        Result => '',
    },
    {
        Name   => 'string',
        Data   => '123 ( (( )) ) & && | ||',
        Result => '123 \( \(\( \)\) \) \& \&\& \| \|\|',
    },
);

for my $Test (@Tests) {
    my $Result = $DBObject->QueryStringEscape(
        QueryString => $Test->{Data}
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        'QueryStringEscape - ' . $Test->{Name}
    );
}

1;
