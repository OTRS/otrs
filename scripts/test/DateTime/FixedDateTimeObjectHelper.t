# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

sleep 1;
my $FixedDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$HelperObject->FixedTimeSet($FixedDateTimeObject);

sleep 1;
my $NewDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$Self->True(
    $FixedDateTimeObject == $NewDateTimeObject,
    'Newly created DateTime object must match date/time of fixed DateTime object.',
);

sleep 1;
$NewDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$Self->True(
    $FixedDateTimeObject == $NewDateTimeObject,
    'Newly created DateTime object must *still* match date/time of fixed DateTime object.',
);

$FixedDateTimeObject->Subtract( Seconds => 10 );
$NewDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$Self->True(
    $FixedDateTimeObject == $NewDateTimeObject,
    'Newly created DateTime object must match date/time of fixed DateTime object minus 10 seconds.',
);

# a newly created DateTime object with current date/time ("without parameters") which will be changed
# must not change the fixed DateTime object.
my $FixedDateTimeObjectEpoch = $FixedDateTimeObject->ToEpoch();
$NewDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$NewDateTimeObject->Add( Seconds => 55 );

$Self->True(
    $NewDateTimeObject->ToEpoch() - 55 == $FixedDateTimeObjectEpoch,
    'Newly created and then changed "current date/time" DateTime object must not influence fixed DateTime object.'
);

$HelperObject->FixedTimeUnset();

sleep 1;
$NewDateTimeObject = $Kernel::OM->Create('Kernel::System::DateTime');
$Self->True(
    $NewDateTimeObject->ToEpoch() > $FixedDateTimeObjectEpoch,
    'Newly created DateTime object must be newer than previous fixed DateTime object.',
);

1;
