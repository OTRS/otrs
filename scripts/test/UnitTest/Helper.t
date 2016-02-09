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

use Kernel::System::UnitTest::Helper;

my $HelperObject = Kernel::System::UnitTest::Helper->new();

$Self->True(
    $HelperObject,
    "Instance created",
);

# GetRandomID

my %SeenRandomIDs;
my $DuplicateIDFound;

LOOP:
for my $I ( 1 .. 1_000_000 ) {
    my $RandomID = $HelperObject->GetRandomID();
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
    my $RandomNumber = $HelperObject->GetRandomNumber();
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

$HelperObject->BeginWork();

my $TestUserLogin = $HelperObject->TestUserCreate();

$Self->True(
    $TestUserLogin,
    'Can create test user',
);

$HelperObject->Rollback();
$Kernel::OM->Get('Kernel::System::Cache')->CleanUp();

my %User = $Kernel::OM->Get('Kernel::System::User')->GetUserData(
    User => $TestUserLogin,
);

$Self->False(
    $User{UserID},
    'Rollback worked',
);

1;
