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

use Kernel::Config;
use Kernel::System::AsynchronousExecutor;

# get helper object
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$Self->True(
    $Helper,
    "Instance created",
);

# GetRandomID
my %SeenRandomIDs;
my $DuplicateIDFound;

LOOP:
for my $I ( 1 .. 1_000_000 ) {
    my $RandomID = $Helper->GetRandomID();
    if ( $SeenRandomIDs{$RandomID}++ ) {
        $Self->True(
            0,
            "GetRandomID iteration $I returned a duplicate RandomID $RandomID",
        );
        $DuplicateIDFound++;
        last LOOP;
    }
}

$Self->False(
    $DuplicateIDFound,
    "GetRandomID() returned no duplicates",
);

# GetRandomNumber
my %SeenRandomNumbers;
my $DuplicateNumbersFound;

LOOP:
for my $I ( 1 .. 1_000_000 ) {
    my $RandomNumber = $Helper->GetRandomNumber();
    if ( $SeenRandomNumbers{$RandomNumber}++ ) {
        $Self->True(
            0,
            "GetRandomNumber iteration $I returned a duplicate RandomNumber $RandomNumber",
        );
        $DuplicateNumbersFound++;
        last LOOP;
    }
}

$Self->False(
    $DuplicateNumbersFound,
    "GetRandomNumber() returned no duplicates",
);

# Test transactions
$Helper->BeginWork();

my $TestUserLogin = $Helper->TestUserCreate();

$Self->True(
    $TestUserLogin,
    'Can create test user',
);

$Helper->Rollback();
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $TestUserLogin,
);

$Self->False(
    $User{UserID},
    'Rollback worked',
);

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
$Self->Is(
    scalar $ConfigObject->Get('nonexisting_dummy'),
    undef,
    "Config setting does not exist yet",
);

my $Value = q$1'"$;

$Helper->ConfigSettingChange(
    Valid => 1,
    Key   => 'nonexisting_dummy',
    Value => $Value,
);

$Self->Is(
    scalar $ConfigObject->Get('nonexisting_dummy'),
    $Value,
    "Runtime config updated",
);

my $NewConfigObject = Kernel::Config->new();
$Self->Is(
    scalar $NewConfigObject->Get('nonexisting_dummy'),
    $Value,
    "System config updated",
);

# Check custom code injection.
my $RandomNumber   = $Helper->GetRandomNumber();
my $PackageName    = "Kernel::Config::Files::ZZZZUnitTest$RandomNumber";
my $SubroutineName = "Sub$RandomNumber";
my $SubroutinePath = "${PackageName}::$SubroutineName";
$Self->False(
    defined &$SubroutinePath,
    "Subroutine $SubroutinePath() is not defined yet",
);

my $CustomCode = <<"EOS";
package $PackageName;
use strict;
use warnings;
## nofilter(TidyAll::Plugin::OTRS::Perl::TestSubs)
sub Load {} # no-op, avoid warning logs
sub $SubroutineName {
    return 'Hello, world!';
}
1;
EOS
$Helper->CustomCodeActivate(
    Code       => $CustomCode,
    Identifier => $RandomNumber,
);

# Require custom code file.
my $Loaded = $Kernel::OM->Get('Kernel::System::Main')->Require($PackageName);
$Self->True(
    $Loaded,
    "Require - $PackageName",
);

$Self->True(
    defined &$SubroutinePath,
    "Subroutine $SubroutinePath() is now defined",
);

$Helper->CustomFileCleanup();

$NewConfigObject = Kernel::Config->new();
$Self->Is(
    scalar $NewConfigObject->Get('nonexisting_dummy'),
    undef,
    "System config reset",
);

$Self->Is(
    scalar $ConfigObject->Get('nonexisting_dummy'),
    $Value,
    "Runtime config still has the changed value, it will be destroyed at the end of every test",
);

# Disable scheduling of asynchronous executor tasks.
$Helper->DisableAsyncCalls();

# Create a new task for the scheduler daemon using AsyncCall method.
my $Success = Kernel::System::AsynchronousExecutor->AsyncCall(
    ObjectName               => 'scripts::test::sample::AsynchronousExecutor::TestAsynchronousExecutor',
    FunctionName             => 'Execute',
    FunctionParams           => {},
    MaximumParallelInstances => 1,
);
$Self->True(
    $Success,
    'Created an asynchronous task'
);

my $SchedulerDBObject = $Kernel::OM->Get('Kernel::System::Daemon::SchedulerDB');

# Check if scheduled asynchronous task is present in DB.
my @TaskIDs;
my @AllTasks = $SchedulerDBObject->TaskList(
    Type => 'AsynchronousExecutor',
);

# Filter test tasks only!
for my $Task (@AllTasks) {
    if ( $Task->{Name} eq 'scripts::test::sample::AsynchronousExecutor::TestAsynchronousExecutor-Execute()' ) {
        push @TaskIDs, $Task->{TaskID};
    }
}

# Our asynchronous task should not be present.
$Self->False(
    scalar @TaskIDs,
    'Asynchronous task not scheduled'
);

1;
