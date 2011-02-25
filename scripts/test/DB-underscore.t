# --
# DB-underscore.t - database tests using underscores
# Copyright (C) 2001-2011 OTRS AG, http://otrs.org/
# --
# $Id: DB-underscore.t,v 1.1.2.2 2011-02-25 19:40:07 en Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars qw($Self);

use Kernel::System::XML;

my $XMLObject = Kernel::System::XML->new( %{$Self} );

# ------------------------------------------------------------ #
# quoting tests, using underscore
#   quoting in mssql is very special, the underscore has to be
#   surrounded by squared brackets: [_]
# ------------------------------------------------------------ #
my $XML = '
<TableCreate Name="test_a">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
</TableCreate>
';
my @XMLARRAY = $XMLObject->XMLParse( String => $XML );
my @SQL = $Self->{DBObject}->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#1 SQLProcessor() CREATE TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do( SQL => $SQL ) || 0,
        "#1 Do() CREATE TABLE ($SQL)",
    );
}

my $Inserts = [
    "INSERT INTO test_a (name_a, name_b) VALUES ( 'B_lock[1]Block[1]', 'Test1' )",
    "INSERT INTO test_a (name_a, name_b) VALUES ( 'Blo_ck[1]Block[2]', 'Test2' )",
    "INSERT INTO test_a (name_a, name_b) VALUES ( 'Block_[2]Block[1]', 'Test3' )",
    "INSERT INTO test_a (name_a, name_b) VALUES ( 'Block[2]Bl_ock[2]', 'Test4' )",
    "INSERT INTO test_a (name_a, name_b) VALUES ( 'Block[11]Block_[22]', 'Test5' )",
    "INSERT INTO test_a (name_a, name_b) VALUES ( 'Block[22]Block[1_1]', 'Test6' )",
];

for my $Insert ( @{$Inserts} ) {
    $Self->True(
        $Self->{DBObject}->Do( SQL => $Insert ) || 0,
        '#2 Do() INSERT',
    );
}

my $LikeTests = [
    {
        Select => "SELECT name_b FROM test_a WHERE name_a LIKE '"
            . $Self->{DBObject}->Quote( "B_lock[1]Block[1]", 'Like' )
            . "'",
    },
    {
        Select => "SELECT name_b FROM test_a WHERE name_a LIKE '"
            . $Self->{DBObject}->Quote( "Blo_ck[1]Block[2]", 'Like' )
            . "'",
    },
    {
        Select => "SELECT name_b FROM test_a WHERE name_a LIKE '"
            . $Self->{DBObject}->Quote( "Block_[2]Block[1]", 'Like' )
            . "'",
    },
    {
        Select => "SELECT name_b FROM test_a WHERE name_a LIKE '"
            . $Self->{DBObject}->Quote( "Block_[2]Block[1]", 'Like' )
            . "'",
    },
    {
        Select => "SELECT name_b FROM test_a WHERE name_a LIKE '"
            . $Self->{DBObject}->Quote( "Block[11]Block_[22]", 'Like' )
            . "'",
    },
    {
        Select => "SELECT name_b FROM test_a WHERE name_a LIKE '"
            . $Self->{DBObject}->Quote( "Block[22]Block[1_1]", 'Like' )
            . "'",
    },
];

for my $TestRef ( @{$LikeTests} ) {
    my $SQLSelect = $TestRef->{Select};

    $Self->{DBObject}->Prepare( SQL => $SQLSelect );

    my @Row = $Self->{DBObject}->FetchrowArray();

    $Self->True(
        @Row ? @Row : 0,
        "#3 SELECT ... LIKE ...",
    );

    #    for my $Test ( keys %{$Result} ) {
    #        $Self->True( $Test, "#4 SELECT ... LIKE ... - $Test" );
    #        delete $Result->{$Test};
    #    }
}

$XML      = '<TableDrop Name="test_a"/>';
@XMLARRAY = $XMLObject->XMLParse( String => $XML );
@SQL      = $Self->{DBObject}->SQLProcessor( Database => \@XMLARRAY );
$Self->True(
    $SQL[0],
    '#4 SQLProcessor() DROP TABLE',
);

for my $SQL (@SQL) {
    $Self->True(
        $Self->{DBObject}->Do( SQL => $SQL ) || 0,
        "#4 Do() DROP TABLE ($SQL)",
    );
}

1;
