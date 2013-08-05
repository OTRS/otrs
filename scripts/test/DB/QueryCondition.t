# --
# QueryCondition.t - database tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
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
my $DBObject  = Kernel::System::DB->new( %{$Self} );

# ------------------------------------------------------------ #
# QueryCondition tests
# ------------------------------------------------------------ #
my $XML = '
<TableCreate Name="test_condition">
    <Column Name="name_a" Required="true" Size="60" Type="VARCHAR"/>
    <Column Name="name_b" Required="true" Size="60" Type="VARCHAR"/>
</TableCreate>
';
my @XMLARRAY = $XMLObject->XMLParse( String => $XML );
my @SQL = $DBObject->SQLProcessor( Database => \@XMLARRAY );
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
        Query  => 'smith ()',
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
        Key => [ 'name_a', 'name_b', 'name_a', 'name_a' ],
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

1;
