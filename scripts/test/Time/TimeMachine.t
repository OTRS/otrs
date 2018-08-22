# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

# set time zone to get correct references
#$ENV{TZ} = 'Europe/Berlin';

use Kernel::System::Time;
use Kernel::System::UnitTest::Helper;

my $ConfigObject = Kernel::Config->new();

my $TimeObject = Kernel::System::Time->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

my $StartSystemTime = $TimeObject->SystemTime();

{
    my $HelperObject = Kernel::System::UnitTest::Helper->new(
        %{$Self},
        UnitTestObject => $Self,
    );

    sleep 1;

    my $FixedTime = $HelperObject->FixedTimeSet();

    sleep 1;

    $Self->Is(
        $TimeObject->SystemTime(),
        $FixedTime,
        "Stay with fixed time",
    );

    sleep 1;

    $Self->Is(
        $TimeObject->SystemTime(),
        $FixedTime,
        "Stay with fixed time",
    );

    $HelperObject->FixedTimeAddSeconds(10);

    $Self->Is(
        $TimeObject->SystemTime(),
        $FixedTime + 10,
        "Stay with increased fixed time",
    );
}

sleep 1;

$Self->True(
    $TimeObject->SystemTime() > $StartSystemTime,
    "Back to original time",
);

1;
