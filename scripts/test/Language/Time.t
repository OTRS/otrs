# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self %Param));

use Kernel::Language;

my $TimeObject   = $Kernel::OM->Get('Kernel::System::Time');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $LanguageObject = Kernel::Language->new(
    UserLanguage => 'de',
);

TEST:
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

    $HelperObject->FixedTimeSet(
        $TimeObject->TimeStamp2SystemTime( String => $Test->{FixedTimeSet} ),
    );

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
}

1;
