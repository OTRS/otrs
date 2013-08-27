# --
# TimeMachine.t - Time tests
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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
