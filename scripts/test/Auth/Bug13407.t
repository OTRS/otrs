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

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# configure auth backend to db
$ConfigObject->Set(
    Key   => 'AuthBackend',
    Value => 'DB',
);

# no additional auth backends
for my $Count ( 1 .. 10 ) {

    $ConfigObject->Set(
        Key   => "AuthBackend$Count",
        Value => '',
    );
}

# disable email checks to create new user
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $TestUserID;
my $UserRand = 'example-user' . $Helper->GetRandomID();

# get user object
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# add test user
$TestUserID = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand,
    UserEmail     => $UserRand . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

# make sure that the customer user objects gets recreated for each loop.
$Kernel::OM->ObjectsDiscard(
    Objects => [
        'Kernel::System::User',
        'Kernel::System::Auth',
    ],
);

my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');

my $PasswordSet = $UserObject->SetPassword(
    UserLogin => $UserRand,
    PW        => '123',
);

$Self->True(
    $PasswordSet,
    "Password set"
);

my $AuthResult = $AuthObject->Auth(
    User => $UserRand,
    Pw   => '123',
);

$Self->Is(
    $AuthResult,
    $UserRand,
    "First authentication ok",
);

$ConfigObject->Get('PreferencesGroups')->{Password}->{PasswordMaxLoginFailed} = 2;

for ( 1 .. 2 ) {
    $AuthResult = $AuthObject->Auth(
        User => $UserRand,
        Pw   => 'wrong',
    );

    $Self->Is(
        $AuthResult,
        undef,
        "Wrong authentication",
    );
}

$AuthResult = $AuthObject->Auth(
    User => $UserRand,
    Pw   => '123',
);

$Self->Is(
    $AuthResult,
    undef,
    "Authentication not possible any more after too many failures",
);

my %User = $UserObject->GetUserData(
    UserID => $TestUserID,
);
delete $User{UserPw};    # Don't update/break password.

my $Update = $UserObject->UserUpdate(
    %User,
    ValidID      => 1,
    ChangeUserID => 1,
);

$Self->True(
    $Update,
    "User revalidated"
);

$AuthResult = $AuthObject->Auth(
    User => $UserRand,
    Pw   => '123',
);

$Self->Is(
    $AuthResult,
    $UserRand,
    "Authentication possible again after revalidation",
);

# cleanup is done by RestoreDatabase

1;
