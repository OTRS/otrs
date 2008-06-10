# --
# UnitTest.t - unit tests
# Copyright (C) 2001-2008 OTRS AG, http://otrs.org/
# --
# $Id: UnitTest.t,v 1.1 2008-06-10 10:44:55 martin Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl-2.0.txt.
# --

use Kernel::System::UnitTest;

$Self->{UnitTestObject} = Kernel::System::UnitTest->new(
    %{$Self},
    Output => 'none',
);

my @TestTrueFalse = (
    {
        Name   => 'true value (1)',
        Value  => 1,
        Result => 1,
    },
    {
        Name   => 'true value (" ")',
        Value  => " ",
        Result => 1,
    },
    {
        Name   => 'false value (0)',
        Value  => 0,
        Result => 0,
    },
    {
        Name   => 'false value ("")',
        Value  => '',
        Result => 0,
    },
    {
        Name   => 'false value (undef)',
        Value  => undef,
        Result => 0,
    },
);

for my $Test (@TestTrueFalse) {
    if ( $Test->{Result} ) {
        my $True = $Self->{UnitTestObject}->True(
            $Test->{Value},
            'Test Name',
        );
        $Self->True(
            $True,
            "True() - $Test->{Name}",
        );
        my $False = $Self->{UnitTestObject}->False(
            $Test->{Value},
            'Test Name',
        );
        $Self->False(
            $False,
            "False() - $Test->{Name}",
        );
    }
    else {
        my $True = $Self->{UnitTestObject}->True(
            $Test->{Value},
            'Test Name',
        );
        $Self->True(
            !$True,
            "True() - $Test->{Name}",
        );
        my $False = $Self->{UnitTestObject}->False(
            $Test->{Value},
            'Test Name',
        );
        $Self->False(
            !$False,
            "False() - $Test->{Name}",
        );

    }
}

my @TestIsIsNot = (
    {
        Name   => 'Is (1:1)',
        ValueX => 1,
        ValueY => 1,
        Result => 'Is',
    },
    {
        Name   => 'Is (a:a)',
        ValueX => 'a',
        ValueY => 'a',
        Result => 'Is',
    },
    {
        Name   => 'Is (undef:undef)',
        ValueX => undef,
        ValueY => undef,
        Result => 'Is',
    },
    {
        Name   => 'Is (0:0)',
        ValueX => 0,
        ValueY => 0,
        Result => 'Is',
    },
    {
        Name   => 'IsNot (1:0)',
        ValueX => 1,
        ValueY => 0,
        Result => 'IsNot',
    },
    {
        Name   => 'Is (a:b)',
        ValueX => 'a',
        ValueY => 'b',
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot (1:undef)',
        ValueX => 1,
        ValueY => undef,
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot (undef:1)',
        ValueX => undef,
        ValueY => 1,
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot (0:undef)',
        ValueX => 0,
        ValueY => undef,
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot (undef:0)',
        ValueX => undef,
        ValueY => 0,
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot ("":undef)',
        ValueX => '',
        ValueY => undef,
        Result => 'IsNot',
    },
    {
        Name   => 'IsNot (undef:"")',
        ValueX => undef,
        ValueY => '',
        Result => 'IsNot',
    },
);

for my $Test (@TestIsIsNot) {
    if ( $Test->{Result} eq 'Is' ) {
        my $True = $Self->{UnitTestObject}->Is(
            $Test->{ValueX},
            $Test->{ValueY},
            'Test Name',
        );
        $Self->True(
            $True,
            "Is() - $Test->{Name}",
        );
        my $False = $Self->{UnitTestObject}->IsNot(
            $Test->{ValueX},
            $Test->{ValueY},
            'Test Name',
        );
        $Self->False(
            $False,
            "IsNot() - $Test->{Name}",
        );
    }
    else {
        my $True = $Self->{UnitTestObject}->IsNot(
            $Test->{ValueX},
            $Test->{ValueY},
            'Test Name',
        );
        $Self->True(
            $True,
            "Is() - $Test->{Name}",
        );
        my $False = $Self->{UnitTestObject}->Is(
            $Test->{ValueX},
            $Test->{ValueY},
            'Test Name',
        );
        $Self->False(
            $False,
            "IsNot() - $Test->{Name}",
        );
    }
}

1;
