# --
# UnitTest.t - unit tests
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: UnitTest.t,v 1.3 2010-06-11 14:25:03 cg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

#use Kernel::System::UnitTest;

$Self->{Output} = 'ASCII';

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
        my $True = $Self->True(
            $Test->{Value},
            'Test Name',
        );
        $Self->True(
            $True,
            "True() - $Test->{Name}",
        );
        my $False = $Self->False(
            $Test->{Value},
            'Test Name',
        );
        $Self->False(
            $False,
            "False() - $Test->{Name}",
        );
    }
    else {
        my $True = $Self->True(
            $Test->{Value},
            'Test Name',
        );
        $Self->True(
            !$True,
            "True() - $Test->{Name}",
        );
        my $False = $Self->False(
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
        my $True = $Self->Is(
            $Test->{ValueX},
            $Test->{ValueY},
            'Test Name',
        );
        $Self->True(
            $True,
            "Is() - $Test->{Name}",
        );
        my $False = $Self->IsNot(
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
        my $True = $Self->IsNot(
            $Test->{ValueX},
            $Test->{ValueY},
            'Test Name',
        );
        $Self->True(
            $True,
            "Is() - $Test->{Name}",
        );
        my $False = $Self->Is(
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

#IsDeeply and IsNotDeeply  start

my %hash1 = (
    key1 => '1',
    key2 => '2',
    key3 => '3',
);

my %hash2 = (
    keya => 'A',
    keyb => 'B',
    keyc => 'C',
);

my @TestIsDeeplyIsNotDeeply = (
    {
        Name   => 'IsDeeply(%hash1:%hash1)',
        ValueX => \%hash1,
        ValueY => \%hash1,
        Result => 'IsDeeply',
    },
    {
        Name   => 'IsDeeply(%hash2:%hash2)',
        ValueX => \%hash2,
        ValueY => \%hash2,
        Result => 'IsDeeply',
    },
    {
        Name   => 'IsNotDeeply(%hash1:%hash2)',
        ValueX => \%hash1,
        ValueY => \%hash2,
        Result => 'IsNotDeeply',
    },
);

for my $Test (@TestIsDeeplyIsNotDeeply) {
    if ( $Test->{Result} eq 'IsDeeply' ) {
        my $True = $Self->IsDeeply(
            $Test->{ValueX},
            $Test->{ValueY},
            'Test Name',
        );
        $Self->True(
            $True,
            "Is() - $Test->{Name}",
        );
        my $False = $Self->IsNotDeeply(
            $Test->{ValueX},
            $Test->{ValueY},
            'False Test Name',
        );
        $Self->False(
            $False,
            "IsNot() - $Test->{Name}",
        );
    }
    else {
        my $True = $Self->IsNotDeeply(
            $Test->{ValueX},
            $Test->{ValueY},
            'Test Name',
        );
        $Self->True(
            $True,
            "Is() - $Test->{Name}",
        );
        my $False = $Self->IsDeeply(
            $Test->{ValueX},
            $Test->{ValueY},
            'False Test Name',
        );
        $Self->False(
            $False,
            "IsNot() - $Test->{Name}",
        );
    }
}

1;
