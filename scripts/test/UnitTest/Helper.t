# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

use Kernel::Config;

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
my $ReturnValue    = 'Hello, world!';
$Self->False(
    defined &$SubroutinePath,
    "Subroutine $SubroutinePath() is not defined yet",
);

my $CustomCode = <<"EOS";
package $PackageName;
use strict;
use warnings;
## nofilter(TidyAll::Plugin::OTRS::Perl::TestSubs)
sub $SubroutineName {
    return '$ReturnValue';
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

1;
