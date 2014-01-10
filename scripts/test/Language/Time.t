# --
# scripts/test/Language/Time.t - language testscript
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self %Param));

use Kernel::System::UnitTest::Helper;
use Kernel::Language;

my $HelperObject = Kernel::System::UnitTest::Helper->new(
    %$Self,
    UnitTestObject => $Self,
);

my $LanguageObject = Kernel::Language->new(

    #UserTimeZone => $Self->{UserTimeZone},
    UserLanguage => 'de',
    %{$Self},
);

TEST:
my @Tests = (
    {
        Name           => 'Default format',
        DateFormatLong => '%T - %D.%M.%Y',
        FixedTimeSet   => '2014-01-10 11:12:13',
        Data           => {
            Format => 'DateFormatLong',
            Year   => 2014,
            Month  => 1,
            Day    => 10,
            Hour   => 11,
            Minute => 12,
            Second => 13,
        },
        Result => '11:12:13 - 10.01.2014',
    },
    # {
    #     Name           => 'All tags test',
    #     DateFormatLong => '%A %B %T - %D.%M.%Y',
    #     FixedTimeSet   => '2014-01-10 11:12:13',
    #     Data           => {
    #         Format => 'DateFormatLong',
    #         Year   => 2014,
    #         Month  => 1,
    #         Day    => 10,
    #         Hour   => 11,
    #         Minute => 12,
    #         Second => 13,
    #     },
    #     Result => 'Fr Jan 11:12:13 - 10.01.2014',
    # },
);

for my $Test (@Tests) {
    $LanguageObject->{DateFormatLong} = $Test->{DateFormatLong};

    $HelperObject->FixedTimeSet(
        $Self->{TimeObject}->TimeStamp2SystemTime( String => $Test->{FixedTimeSet} ),
    );

    my $Result = $LanguageObject->Time(
        %{ $Test->{Data} },
        Action => 'return',
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - return",
    );

    $Result = $LanguageObject->Time(
        %{ $Test->{Data} },
        Action => 'get',
    );

    $Self->Is(
        $Result,
        $Test->{Result},
        "$Test->{Name} - get",
    );
}

1;
