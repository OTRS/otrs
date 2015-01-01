# --
# SupportDataCollector.t - SupportDataCollector tests
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Time::HiRes ();

use Kernel::System::SupportDataCollector::PluginBase;

# get needed objects
my $HelperObject               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $CacheObject                = $Kernel::OM->Get('Kernel::System::Cache');
my $SupportDataCollectorObject = $Kernel::OM->Get('Kernel::System::SupportDataCollector');

$CacheObject->CleanUp(
    Type => 'SupportDataCollector',
);

my $TimeStart = [ Time::HiRes::gettimeofday() ];

my %Result = $SupportDataCollectorObject->Collect(
    WebTimeout => 40,
);

my $TimeElapsed = Time::HiRes::tv_interval($TimeStart);

$Self->Is(
    $Result{Success},
    1,
    "Data collection status",
);

$Self->Is(
    $Result{ErrorMessage},
    undef,
    "There is no error message",
);

$Self->True(
    scalar @{ $Result{Result} || [] } >= 1,
    "Data collection result count",
);

my %SeenIdentifier;

for my $ResultEntry ( @{ $Result{Result} || [] } ) {
    $Self->True(
        (
            $ResultEntry->{Status}
                == $Kernel::System::SupportDataCollector::PluginBase::StatusUnknown
                || $ResultEntry->{Status}
                == $Kernel::System::SupportDataCollector::PluginBase::StatusOK
                || $ResultEntry->{Status}
                == $Kernel::System::SupportDataCollector::PluginBase::StatusWarning
                || $ResultEntry->{Status}
                == $Kernel::System::SupportDataCollector::PluginBase::StatusProblem
                || $ResultEntry->{Status}
                == $Kernel::System::SupportDataCollector::PluginBase::StatusInfo

        ),
        "$ResultEntry->{Identifier} - status ($ResultEntry->{Status}).",
    );

    $Self->Is(
        $SeenIdentifier{ $ResultEntry->{Identifier} }++,
        0,
        "$ResultEntry->{Identifier} - identifier only used once.",
    );
}

# cache tests
my $CacheResult = $CacheObject->Get(
    Type => 'SupportDataCollector',
    Key  => 'DataCollect',
);
$Self->IsDeeply(
    $CacheResult,
    \%Result,
    "Collect() - Cache"
);

$Self->True(
    $TimeElapsed < 30,
    "Collect() - Should take less than 30 seconds, it took $TimeElapsed"
);

my $TimeStartCache = [ Time::HiRes::gettimeofday() ];
%Result = $SupportDataCollectorObject->Collect(
    UseCache => 1,
);
my $TimeElapsedCache = Time::HiRes::tv_interval($TimeStartCache);

$CacheResult = $CacheObject->Get(
    Type => 'SupportDataCollector',
    Key  => 'DataCollect',
);
$Self->IsDeeply(
    $CacheResult,
    \%Result,
    "Collect() - Cache",
);

$Self->True(
    $TimeElapsedCache < $TimeElapsed,
    "Collect() - Should take less than $TimeElapsed seconds, it took $TimeElapsedCache",
);

1;
