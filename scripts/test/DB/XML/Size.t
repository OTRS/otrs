# --
# Size.t - database tests
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
# XML test 2 (XML:TableCreate, XML:TableAlter, XML:Insert (size check),
# SQL:Insert (size check), SQL:Delete,  XML:TableDrop)
# ------------------------------------------------------------ #
my $XML = '
<TableCreate Name="test_a">
    <Column Name="id" Required="true" PrimaryKey="true" AutoIncrement="true" Type="SMALLINT"/>
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="5000000" Type="VARCHAR"/>
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
    'SQLProcessor() ALTER TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() ALTER TABLE ($SQL)",
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
    'SQLProcessor() INSERT 1',
);

for my $SQL (@SQL) {
    $Self->True(
        $DBObject->Do( SQL => $SQL ) || 0,
        "Do() XML INSERT 1 ($SQL)",
    );
}

$Self->True(
    $DBObject->Do(
        SQL => 'INSERT INTO test_a (name_a, name_b) VALUES (\'Some2\', \'Lalala2\')',
        )
        || 0,
    'Do() SQL INSERT 1',
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
        "SQLProcessor() INSERT 2 - $Count",
    );

    for my $SQL (@SQL) {

        # insert
        $Self->True(
            $DBObject->Do( SQL => $SQL ) || 0,
            "Do() XML INSERT 2 - $Count (length:$Length/$Size)",
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
            "Do() SQL SELECT 2 - $Count",
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
            "Do() SQL SELECT (bind) 2 - $Count",
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
        "Do() SQL INSERT 2 - $Count (length:$Length/$Size)",
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
        "Do() SQL SELECT 2 - $Count",
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
        "Do() SQL INSERT (bind) 2 - $Count (length:$Length/$Size)",
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
        "Do() SQL SELECT 2 - $Count",
    );
}

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_a WHERE name_a = \'Some1\'',
        Limit => 1,
        )
        || 0,
    'Prepare() SELECT - Prepare - Limit 1',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    'FetchrowArray () SELECT - Limit 1',
);

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_a WHERE name_a like \'Some%\'',
        Limit => 1,
        )
        || 0,
    'Prepare() SELECT - Prepare - Limit 1 - like',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    'FetchrowArray () SELECT - Limit 1 - like',
);

$Self->True(
    $DBObject->Prepare(
        SQL   => 'SELECT * FROM test_a WHERE name_a like \'Some%\'',
        Limit => 3,
        )
        || 0,
    'Prepare() SELECT - Prepare - Limit 2 - like',
);

$Self->True(
    ref( $DBObject->FetchrowArray() ) eq ''     &&
        ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '' &&
        ref( $DBObject->FetchrowArray() ) eq '',
    'FetchrowArray () SELECT - Limit 2 - like',
);
$Self->True(
    $DBObject->Do(
        SQL => 'DELETE FROM test_a WHERE name_a like \'Some%\'',
        )
        || 0,
    'Do() DELETE',
);

$XML      = '<TableDrop Name="test_a"/>';
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
