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

my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

my @Tests = (
    {
        Description      => 'Test does not contain all necessary data for QueryInCondition',
        Fails            => 1,
        QueryInCondition => {},
        ReferenceData    => undef,
    },
    {
        Description      => 'Test does not contain any values for QueryInCondition',
        Fails            => 1,
        QueryInCondition => {
            Key => 't.id',
        },
        ReferenceData => undef,
    },
    {
        Description      => "Test QueryInCondition with some ids and quote type 'Integer' (BindMode 0)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1, 2, 3, 4, 6, ],
            QuoteType => 'Integer',
            BindMode  => 0,
        },
        ReferenceData => 't.id IN (1, 2, 3, 4, 6)',
    },
    {
        Description      => "Test QueryInCondition with some ids and quote type 'Integer' (BindMode 1)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1, 2, 3, 4, 6, ],
            QuoteType => 'Integer',
            BindMode  => 1,
        },
        ReferenceData => {
            SQL    => 't.id IN (?, ?, ?, ?, ?)',
            Values => [ \1, \2, \3, \4, \6, ],
        },
    },
    {
        Description => "Test QueryInCondition with some ids and quote type 'Integer', but one wrong value (BindMode 0)",
        Fails       => 1,
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1, 2, 3, 4, 'test' ],
            QuoteType => 'Integer',
            BindMode  => 0,
        },
    },
    {
        Description      => "Test QueryInCondition with some numners and quote type 'Number' (BindMode 0)",
        QueryInCondition => {
            Key       => 'ta.time_unit',
            Values    => [ 1.5, 2.75, 3, 444.4, 6, ],
            QuoteType => 'Number',
            BindMode  => 0,
        },
        ReferenceData => 'ta.time_unit IN (1.5, 2.75, 3, 6, 444.4)',
    },
    {
        Description      => "Test QueryInCondition with some numbers and quote type 'Number' (BindMode 1)",
        QueryInCondition => {
            Key       => 'ta.time_unit',
            Values    => [ 1.5, 2.75, 3, 444.4, 6, ],
            QuoteType => 'Number',
            BindMode  => 1,
        },
        ReferenceData => {
            SQL    => 'ta.time_unit IN (?, ?, ?, ?, ?)',
            Values => [ \1.5, \2.75, \3, \6, \444.4, ],
        },
    },
    {
        Description      => "Test QueryInCondition with some strings and quote type 'String' (BindMode 0)",
        QueryInCondition => {
            Key      => 't.tn',
            Values   => [ 'aaa', 'bbb', 'ccc', 'zzz', 'test', ],
            BindMode => 0,
        },
        ReferenceData => "t.tn IN ('aaa', 'bbb', 'ccc', 'test', 'zzz')",
    },
    {
        Description      => "Test QueryInCondition with some strings and quote type 'String' (BindMode 1)",
        QueryInCondition => {
            Key      => 't.tn',
            Values   => [ 'aaa', 'bbb', 'ccc', 'test', 'zzz' ],
            BindMode => 1,
        },
        ReferenceData => {
            SQL    => 't.tn IN (?, ?, ?, ?, ?)',
            Values => [ \'aaa', \'bbb', \'ccc', \'test', \'zzz' ],
        },
    },
    {
        Description      => "Test QueryInCondition with some strings and not allowed quote type 'Like' (BindMode 0)",
        Fails            => 1,
        QueryInCondition => {
            Key       => 't.tn',
            Values    => ['*aaa*'],
            QuoteType => 'Like',
            BindMode  => 0,
        },
    },
    {
        Description      => "Test QueryInCondition with 1000 ids and quote type 'Integer' (BindMode 0)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1 .. 1000 ],
            QuoteType => 'Integer',
            BindMode  => 0,
        },
        ReferenceData => 't.id IN (' . ( join ', ', 1 .. 1000 ) . ')',
    },
    {
        Description      => "Test QueryInCondition with 1000 ids and quote type 'Integer' (BindMode 1)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1 .. 1000 ],
            QuoteType => 'Integer',
            BindMode  => 1,
        },
        ReferenceData => {
            SQL    => 't.id IN (' . ( join ', ', ('?') x 1000 ) . ')',
            Values => [ 1 .. 1000 ],
        },
    },
    {
        Description      => "Test QueryInCondition with over 1000 ids and quote type 'Integer' (BindMode 0)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1 .. 1200 ],
            QuoteType => 'Integer',
            BindMode  => 0,
        },
        ReferenceData       => 't.id IN (' . ( join ', ', 1 .. 1200 ) . ')',
        ReferenceDataOracle => '( t.id IN ('
            . ( join ', ', 1 .. 1000 )
            . ') OR t.id IN ('
            . ( join ', ', 1001 .. 1200 ) . ') )',
    },
    {
        Description      => "Test QueryInCondition with over 1000 ids and quote type 'Integer' (BindMode 1)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1 .. 1200 ],
            QuoteType => 'Integer',
            BindMode  => 1,
        },
        ReferenceData => {
            SQL    => 't.id IN (' . ( join ', ', ('?') x 1200 ) . ')',
            Values => [ 1 .. 1200 ],
        },
        ReferenceDataOracle => {
            SQL => '( t.id IN (' . ( join ', ', ('?') x 1000 ) . ') OR t.id IN (' . ( join ', ', ('?') x 200 ) . ') )',
            Values => [ 1 .. 1200 ],
        },
    },
    {
        Description      => "Test QueryInCondition with 2001 ids and quote type 'Integer' (BindMode 0)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1 .. 2001 ],
            QuoteType => 'Integer',
            BindMode  => 0,
        },
        ReferenceData       => 't.id IN (' . ( join ', ', 1 .. 2001 ) . ')',
        ReferenceDataOracle => '( t.id IN ('
            . ( join ', ', 1 .. 1000 )
            . ') OR t.id IN ('
            . ( join ', ', 1001 .. 2000 )
            . ') OR t.id IN ('
            . ( join ', ', 2001 .. 2001 ) . ') )',
    },

    # Some tests for the negation.
    {
        Description      => "Test QueryInCondition with some ids, quote type 'Integer' and negated (BindMode 0)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1, 2, 3, 4, 6, ],
            QuoteType => 'Integer',
            BindMode  => 0,
            Negate    => 1,
        },
        ReferenceData => 't.id NOT IN (1, 2, 3, 4, 6)',
    },
    {
        Description      => "Test QueryInCondition with some ids, quote type 'Integer' and negated (BindMode 1)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1, 2, 3, 4, 6, ],
            QuoteType => 'Integer',
            BindMode  => 1,
            Negate    => 1,
        },
        ReferenceData => {
            SQL    => 't.id NOT IN (?, ?, ?, ?, ?)',
            Values => [ \1, \2, \3, \4, \6, ],
        },
    },
    {
        Description      => "Test QueryInCondition with over 1000 ids, quote type 'Integer' and negated (BindMode 0)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1 .. 1200 ],
            QuoteType => 'Integer',
            BindMode  => 0,
            Negate    => 1,
        },
        ReferenceData       => 't.id NOT IN (' . ( join ', ', 1 .. 1200 ) . ')',
        ReferenceDataOracle => '( t.id NOT IN ('
            . ( join ', ', 1 .. 1000 )
            . ') AND t.id NOT IN ('
            . ( join ', ', 1001 .. 1200 ) . ') )',
    },
    {
        Description      => "Test QueryInCondition with over 1000 ids, quote type 'Integer' and negated (BindMode 1)",
        QueryInCondition => {
            Key       => 't.id',
            Values    => [ 1 .. 1200 ],
            QuoteType => 'Integer',
            BindMode  => 1,
            Negate    => 1,
        },
        ReferenceData => {
            SQL    => 't.id NOT IN (' . ( join ', ', ('?') x 1200 ) . ')',
            Values => [ 1 .. 1200 ],
        },
        ReferenceDataOracle => {
            SQL => '( t.id NOT IN ('
                . ( join ', ', ('?') x 1000 )
                . ') AND t.id NOT IN ('
                . ( join ', ', ('?') x 200 ) . ') )',
            Values => [ 1 .. 1200 ],
        },
    },
);

my $TestCount = 1;

TEST:
for my $Test (@Tests) {

    if ( !$Test->{QueryInCondition} || ref $Test->{QueryInCondition} ne 'HASH' ) {

        $Self->True(
            0,
            "Test $TestCount: No QueryInCondition found for this test.",
        );

        next TEST;
    }

    my $ReferenceData = $Test->{ReferenceData};

    if ( $DBObject->GetDatabaseFunction('Type') eq 'oracle' && $Test->{ReferenceDataOracle} ) {
        $ReferenceData = $Test->{ReferenceDataOracle};
    }

    # print test case description
    if ( $Test->{Description} ) {
        $Self->True(
            1,
            "Test $TestCount: $Test->{Description}",
        );
    }

    if ( $Test->{QueryInCondition}->{BindMode} ) {

        my %Result = $DBObject->QueryInCondition(
            %{ $Test->{QueryInCondition} },
        );

        if ( $Test->{Fails} ) {
            $Self->False(
                %Result,
                "Test $TestCount: QueryInCondition() - should fail.",
            );
        }
        else {

            $Self->Is(
                $Result{SQL},
                $ReferenceData->{SQL},
                "Test $TestCount: QueryInCondition() - SQL - test the sql string (BindMode 1)",
            );

            $Self->Is(
                scalar @{ $Result{Values} },
                scalar @{ $ReferenceData->{Values} },
                "Test $TestCount: QueryInCondition() - Values - test the value count (BindMode 1)",
            );

            my $Success = $DBObject->Prepare(
                SQL   => 'SELECT t.id, t.tn, ta.time_unit FROM ticket t, time_accounting ta WHERE ' . $Result{SQL},
                Bind  => $Result{Values},
                Limit => 1,
            );

            $Self->True(
                $Success,
                "Test $TestCount: SQL from QueryInCondition - Executed with True (BindMode 1)",
            );
        }
    }
    else {

        my $SQL = $DBObject->QueryInCondition(
            %{ $Test->{QueryInCondition} },
        );

        if ( $Test->{Fails} ) {
            $Self->False(
                $SQL,
                "Test $TestCount: QueryInCondition() - should fail.",
            );
        }
        else {

            $Self->Is(
                $SQL,
                $ReferenceData,
                "Test $TestCount: QueryInCondition() - test the result  (BindMode 0)",
            );

            my $Success = $DBObject->Prepare(
                SQL   => 'SELECT t.id, t.tn, ta.time_unit FROM ticket t, time_accounting ta WHERE ' . $SQL,
                Limit => 1,
            );

            $Self->True(
                $Success,
                "Test $TestCount: SQL from QueryInCondition - Executed with True (BindMode 0)",
            );
        }
    }
}
continue {
    $TestCount++;
}

1;
