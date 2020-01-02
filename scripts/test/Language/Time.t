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

use vars (qw($Self %Param));

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Kernel::OM->ObjectParamAdd(
    'Kernel::Language' => {
        UserLanguage => 'de',
    },
);

my $LanguageObject = $Kernel::OM->Get('Kernel::Language');

my @Tests = (
    {
        Name           => 'Default format',
        DateFormatLong => '%T - %D.%M.%Y',
        FixedTimeSet   => '2014-01-10 11:12:13',
        Data           => {
            Format => 'DateFormatLong',
            Year   => '2014',
            Month  => '01',
            Day    => '10',
            Hour   => '11',
            Minute => '12',
            Second => '13',
        },
        ResultGet    => '11:12:13 - 10.01.2014',
        ResultReturn => '11:12:13 - 10.01.2014',
    },
    {
        Name           => 'All tags test',
        DateFormatLong => '%A %B %T - %D.%M.%Y',
        FixedTimeSet   => '2014-01-10 11:12:13',
        Data           => {
            Format => 'DateFormatLong',
            Year   => '2014',
            Month  => '01',
            Day    => '10',
            Hour   => '11',
            Minute => '12',
            Second => '13',
        },
        ResultGet    => 'Fr Jan 11:12:13 - 10.01.2014',
        ResultReturn => ' Jan 11:12:13 - 10.01.2014',
    },
    {

        Name           => 'All tags test, HTML elements (as used in BuildDateSelection)',
        DateFormatLong => '%A %B %T - %D.%M.%Y',
        FixedTimeSet   => '2014-01-10 11:12:13',
        Data           => {
            Format => 'DateFormatLong',
            Year   => '<input value="2014"/>',
            Month  => '<input value="1"/>',
            Day    => '<input value="10"/>',
            Hour   => '<input value="11"/>',
            Minute => '<input value="12"/>',
            Second => '<input value="13"/>',
        },
        ResultGet => 'Fr Jan 11:12:13 - 10.01.2014',
        ResultReturn =>
            '  <input value="11"/>:<input value="12"/>:<input value="13"/> - <input value="10"/>.<input value="1"/>.<input value="2014"/>',
    },
);

for my $Test (@Tests) {

    $LanguageObject->{DateFormatLong} = $Test->{DateFormatLong};

    my $DateTimeObject = $Kernel::OM->Create(
        'Kernel::System::DateTime',
        ObjectParams => {
            String => $Test->{FixedTimeSet},
        },
    );

    $HelperObject->FixedTimeSet($DateTimeObject);

    my $Result = $LanguageObject->Time(
        %{ $Test->{Data} },
        Mode   => 'NotNumeric',
        Action => 'return',
    );

    $Self->Is(
        $Result,
        $Test->{ResultReturn},
        "$Test->{Name} - return",
    );

    $Result = $LanguageObject->Time(
        %{ $Test->{Data} },
        Action => 'get',
    );

    $Self->Is(
        $Result,
        $Test->{ResultGet},
        "$Test->{Name} - get",
    );

    $HelperObject->FixedTimeUnset();
}

1;
