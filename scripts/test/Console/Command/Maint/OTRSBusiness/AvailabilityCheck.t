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

use Kernel::System::OTRSBusiness;

## nofilter(TidyAll::Plugin::OTRS::Perl::TestSubs)
# disable redefine warnings in this scope
{
    no warnings 'redefine';

    sub Kernel::System::OTRSBusiness::OTRSBusinessIsAvailable {
        my ( $Self, %Param ) = @_;

        my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

        my $TestCloudServiceCallKey = 'OTRSBusiness::AvailabilityCheck::TestCloudServiceCall';

        if ( defined $SystemDataObject->SystemDataGet( Key => $TestCloudServiceCallKey ) ) {
            $SystemDataObject->SystemDataUpdate(
                Key    => $TestCloudServiceCallKey,
                Value  => 1,
                UserID => 1,
            );
        }
        else {
            $SystemDataObject->SystemDataAdd(
                Key    => $TestCloudServiceCallKey,
                Value  => 1,
                UserID => 1,
            );
        }

        return 1;
    }

    # reset all warnings
}

my $CommandObject = $Kernel::OM->Get('Kernel::System::Console::Command::Maint::OTRSBusiness::AvailabilityCheck');

my $HelperObject     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SystemDataObject = $Kernel::OM->Get('Kernel::System::SystemData');

my $NextUpdateTimeKey       = 'OTRSBusiness::AvailabilityCheck::NextUpdateTime';
my $TestCloudServiceCallKey = 'OTRSBusiness::AvailabilityCheck::TestCloudServiceCall';

my $ResetTestCloudServiceCall = sub {
    my %Param = @_;

    $SystemDataObject->SystemDataUpdate(
        Key    => $TestCloudServiceCallKey,
        Value  => 0,
        UserID => 1,
    );
};

# delete the 'OTRSBusiness::AvailabilityCheck::NextUpdateTime' from the system data, if it already exists in the system
if ( defined $SystemDataObject->SystemDataGet( Key => $NextUpdateTimeKey ) ) {
    $SystemDataObject->SystemDataDelete(
        Key    => $NextUpdateTimeKey,
        UserID => 1,
    );
}

$HelperObject->FixedTimeSet();

my $ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "Maint::OTRSBusiness::AvailabilityCheck exit code",
);

my $TestCloudService = $SystemDataObject->SystemDataGet( Key => $TestCloudServiceCallKey );

$Self->True(
    $TestCloudService,
    "The function 'OTRSBusinessIsAvailable' was called from the console command.",
);

$ResetTestCloudServiceCall->();

# add two hours in seconds to the fixed time
my $FixedTimeAddSeconds = 60 * 60 * 2;

# set the fixed time
$HelperObject->FixedTimeAddSeconds($FixedTimeAddSeconds);

$ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "Maint::OTRSBusiness::AvailabilityCheck exit code",
);

$TestCloudService = $SystemDataObject->SystemDataGet( Key => $TestCloudServiceCallKey );

$Self->False(
    $TestCloudService,
    "The function 'OTRSBusinessIsAvailable' was not called from the console command.",
);

$ResetTestCloudServiceCall->();

$ExitCode = $CommandObject->Execute('--force');

$Self->Is(
    $ExitCode,
    0,
    "Maint::OTRSBusiness::AvailabilityCheck exit code",
);

$TestCloudService = $SystemDataObject->SystemDataGet( Key => $TestCloudServiceCallKey );

$Self->True(
    $TestCloudService,
    "The function 'OTRSBusinessIsAvailable' was called from the console command (with --force).",
);

$ResetTestCloudServiceCall->();

# add 28 hours in seconds to the fixed time
$FixedTimeAddSeconds = 60 * 60 * 28;

# set the fixed time
$HelperObject->FixedTimeAddSeconds($FixedTimeAddSeconds);

$ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "Maint::OTRSBusiness::AvailabilityCheck exit code",
);

$TestCloudService = $SystemDataObject->SystemDataGet( Key => $TestCloudServiceCallKey );

$Self->True(
    $TestCloudService,
    "The function 'OTRSBusinessIsAvailable' was called from the console command (because next update time reached).",
);

$ResetTestCloudServiceCall->();

# add one hours in seconds to the fixed time
$FixedTimeAddSeconds = 60 * 60 * 1;

# set the fixed time
$HelperObject->FixedTimeAddSeconds($FixedTimeAddSeconds);

$ExitCode = $CommandObject->Execute();

$Self->Is(
    $ExitCode,
    0,
    "Maint::OTRSBusiness::AvailabilityCheck exit code",
);

$TestCloudService = $SystemDataObject->SystemDataGet( Key => $TestCloudServiceCallKey );

$Self->False(
    $TestCloudService,
    "The function 'OTRSBusinessIsAvailable' was not called from the console command.",
);

$HelperObject->FixedTimeUnset();

1;
