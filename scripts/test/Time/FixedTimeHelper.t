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

# get time object
my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

my $StartSystemTime = $TimeObject->SystemTime();

{
    my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

    $HelperObject->FixedTimeAddSeconds(-10);

    $Self->Is(
        $TimeObject->SystemTime(),
        $FixedTime - 10,
        "Stay with increased fixed time",
    );

    $HelperObject->FixedTimeUnset();

    # Let object be destroyed at the end of this scope
    $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::UnitTest::Helper'] );
}

sleep 1;

$Self->True(
    $TimeObject->SystemTime() >= $StartSystemTime,
    "Back to original time",
);

1;
