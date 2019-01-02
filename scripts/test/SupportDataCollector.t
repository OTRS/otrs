# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use File::Basename;
use Time::HiRes ();

use Kernel::System::SupportDataCollector::PluginBase;

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreSystemConfiguration => 1,
    },
);
my $HelperObject               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $SysConfigObject            = $Kernel::OM->Get('Kernel::System::SysConfig');
my $CacheObject                = $Kernel::OM->Get('Kernel::System::Cache');
my $MainObject                 = $Kernel::OM->Get('Kernel::System::Main');
my $SupportDataCollectorObject = $Kernel::OM->Get('Kernel::System::SupportDataCollector');

$SysConfigObject->ConfigItemUpdate(
    Valid => 1,
    Key   => 'SupportDataCollector::DisablePlugins',
    Value => [
        'Kernel::System::SupportDataCollector::Plugin::OTRS::PackageDeployment',
    ],
);
$SysConfigObject->ConfigItemUpdate(
    Valid => 1,
    Key   => 'SupportDataCollector::IdentifierFilterBlacklist',
    Value => [
        'Kernel::System::SupportDataCollector::Plugin::OTRS::TimeSettings::UserDefaultTimeZone',
    ],
);

my $TimeStart = [ Time::HiRes::gettimeofday() ];

my $Success = $SupportDataCollectorObject->CollectAsynchronous();

$Self->Is(
    $Success,
    1,
    "Asynchronous data collection status",
);

my $TimeElapsed = Time::HiRes::tv_interval($TimeStart);

# Look for all plugins in the FS
my @PluginFiles = $MainObject->DirectoryRead(
    Directory => $Kernel::OM->Get('Kernel::Config')->Get('Home')
        . "/Kernel/System/SupportDataCollector/PluginAsynchronous",
    Filter    => "*.pm",
    Recursive => 1,
);

# Execute all Plugins
for my $PluginFile (@PluginFiles) {

    # Convert file name => package name
    $PluginFile =~ s{^.*(Kernel/System.*)[.]pm$}{$1}xmsg;
    $PluginFile =~ s{/+}{::}xmsg;

    if ( !$MainObject->Require($PluginFile) ) {
        return (
            Success      => 0,
            ErrorMessage => "Could not load $PluginFile!",
        );
    }
    my $PluginObject = $PluginFile->new( %{$Self} );

    my $AsynchronousData = $PluginObject->_GetAsynchronousData();

    $Self->True(
        defined $AsynchronousData,
        "$PluginFile - asychronous data exists.",
    );
}

$Self->True(
    $TimeElapsed < 180,
    "CollectAsynchronous() - Should take less than 120 seconds, it took $TimeElapsed"
);

# test the support data collect function

$CacheObject->CleanUp(
    Type => 'SupportDataCollector',
);

$TimeStart = [ Time::HiRes::gettimeofday() ];

my %Result = $SupportDataCollectorObject->Collect(
    WebTimeout => 40,
);

$TimeElapsed = Time::HiRes::tv_interval($TimeStart);

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

# Check if the identifier from the disabled plugions are not present.
for my $DisabledPluginsIdentifier (
    qw(Kernel::System::SupportDataCollector::Plugin::OTRS::PackageDeployment Kernel::System::SupportDataCollector::Plugin::OTRS::PackageDeployment::Verification Kernel::System::SupportDataCollector::Plugin::OTRS::PackageDeployment::FrameworkVersion)
    )
{
    $Self->False(
        $SeenIdentifier{$DisabledPluginsIdentifier},
        "Collect() - SupportDataCollector::DisablePlugins - $DisabledPluginsIdentifier should not be present"
    );
}

# Check if the identifiers from the identifier filter blacklist are not present.
$Self->False(
    $SeenIdentifier{'Kernel::System::SupportDataCollector::Plugin::OTRS::TimeSettings::UserDefaultTimeZone'},
    "Collect() - SupportDataCollector::IdentifierFilterBlacklist - Kernel::System::SupportDataCollector::Plugin::OTRS::TimeSettings::UserDefaultTimeZone should not be present"
);

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
