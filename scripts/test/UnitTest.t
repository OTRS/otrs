# --
# UnitTest.t - unit tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::UnitTest;

my $UnitTestObject = Kernel::System::UnitTest->new(
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
        my $True = $UnitTestObject->True(
            $Test->{Value},
            'Test Name',
        );
        $Self->True(
            $True,
            "True() - $Test->{Name}",
        );
        my $False = $UnitTestObject->False(
            $Test->{Value},
            'Test Name',
        );
        $Self->False(
            $False,
            "False() - $Test->{Name}",
        );
    }
    else {
        my $True = $UnitTestObject->True(
            $Test->{Value},
            'Test Name',
        );
        $Self->True(
            !$True,
            "True() - $Test->{Name}",
        );
        my $False = $UnitTestObject->False(
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
        my $True = $UnitTestObject->Is(
            $Test->{ValueX},
            $Test->{ValueY},
            'Test Name',
        );
        $Self->True(
            $True,
            "Is() - $Test->{Name}",
        );
        my $False = $UnitTestObject->IsNot(
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
        my $True = $UnitTestObject->IsNot(
            $Test->{ValueX},
            $Test->{ValueY},
            'Test Name',
        );
        $Self->True(
            $True,
            "Is() - $Test->{Name}",
        );
        my $False = $UnitTestObject->Is(
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

#IsDeeply and IsNotDeeply start

my %Hash1 = (
    key1 => '1',
    key2 => '2',
    key3 => {
        test  => 2,
        test2 => [
            1, 2, 3,
        ],
    },
    key4 => undef,
);

my %Hash2 = %Hash1;
$Hash2{AdditionalKey} = 1;

my @List1 = ( 1, 2, 3, );
my @List2 = (
    1,
    2,
    4,
    [ 1, 2, 3 ],
    {
        test => 'test',
    },
);

my $Scalar1 = 1;
my $Scalar2 = {
    test => [ 1, 2, 3 ],
};

my $Count = 0;
for my $Value1 ( \%Hash1, \%Hash2, \@List1, \@List2, \$Scalar1, \$Scalar2 ) {
    $Count++;
    my $IsDeeplyResult = $UnitTestObject->IsDeeply(
        $Value1,
        $Value1,
        'Dummy Test Name' . $Count,
    );
    $Self->True(
        $IsDeeplyResult,
        'IsDeeply() - Dummy Test Name' . $Count,
    );
    my $IsNotDeeplyResult = $UnitTestObject->IsNotDeeply(
        $Value1,
        $Value1,
        'Dummy False Test Name' . $Count,
    );
    $Self->False(
        $IsNotDeeplyResult,
        'IsNotDeeply() - Dummy False Test Name' . $Count,
    );

    my $Count2 = 0;
    VALUE2: for my $Value2 ( \%Hash1, \%Hash2, \@List1, \@List2, \$Scalar1, \$Scalar2 ) {
        if ( $Value2 == $Value1 ) {
            next VALUE2;
        }
        $Count2++;
        my $IsDeeplyResult = $UnitTestObject->IsDeeply(
            $Value1,
            $Value2,
            'Dummy Test Name' . $Count . ':' . $Count2,
        );
        $Self->False(
            $IsDeeplyResult,
            'IsDeeply() - Dummy Test Name' . $Count . ':' . $Count2,
        );
        my $IsNotDeeplyResult = $UnitTestObject->IsNotDeeply(
            $Value1,
            $Value2,
            'Dummy False Test Name' . $Count . ':' . $Count2,
        );
        $Self->True(
            $IsNotDeeplyResult,
            'IsNotDeeply() - Dummy False Test Name' . $Count . ':' . $Count2,
        );
    }
}

1;
