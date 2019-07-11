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

# get needed objects
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

my $UserRand1 = 'example-user' . int rand 1000000;

my $UserObject = $Kernel::OM->Get('Kernel::System::User');

# add test user
$TestUserID = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

my @Tests = (
    {
        Password   => 'simple',
        AuthResult => $UserRand1,
    },
    {
        Password   => 'very long password line which is unusual',
        AuthResult => $UserRand1,
    },
    {
        Password   => 'Переводчик',
        AuthResult => $UserRand1,
    },
    {
        Password   => 'كل ما تحب معرفته عن',
        AuthResult => $UserRand1,
    },
    {
        Password   => ' ',
        AuthResult => $UserRand1,
    },
    {
        Password   => "\n",
        AuthResult => $UserRand1,
    },
    {
        Password   => "\t",
        AuthResult => $UserRand1,
    },
    {
        Password   => "a" x 64,     # max length for plain
        AuthResult => $UserRand1,
    },

    # SQL security tests
    {
        Password   => "'UNION'",
        AuthResult => $UserRand1,
    },
    {
        Password   => "';",
        AuthResult => $UserRand1,
    },
);

for my $CryptType (qw(plain crypt apr1 md5 sha1 sha2 bcrypt)) {

    # make sure that the customer user objects gets recreated for each loop.
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::User',
            'Kernel::System::Auth',
        ],
    );

    $ConfigObject->Set(
        Key   => "AuthModule::DB::CryptType",
        Value => $CryptType
    );

    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');

    TEST:
    for my $Test (@Tests) {

        my $PasswordSet = $UserObject->SetPassword(
            UserLogin => $UserRand1,
            PW        => $Test->{Password},
        );

        if ( $CryptType eq 'plain' && $Test->{PlainFail} ) {
            $Self->False(
                $PasswordSet,
                "Password set"
            );
            next TEST;
        }

        $Self->True(
            $PasswordSet,
            "Password set"
        );

        my $AuthResult = $AuthObject->Auth(
            User => $UserRand1,
            Pw   => $Test->{Password},
        );

        $Self->Is(
            $AuthResult,
            $Test->{AuthResult},
            "CryptType $CryptType Password '$Test->{Password}'",
        );

        $AuthResult = $AuthObject->Auth(
            User => $UserRand1,
            Pw   => $Test->{Password},
        );

        $Self->Is(
            $AuthResult,
            $Test->{AuthResult},
            "CryptType $CryptType Password '$Test->{Password}' (cached)",
        );

        $AuthResult = $AuthObject->Auth(
            User => $UserRand1,
            Pw   => 'wrong_pw',
        );

        $Self->False(
            $AuthResult,
            "CryptType $CryptType Password '$Test->{Password}' (wrong password)",
        );

        $AuthResult = $AuthObject->Auth(
            User => 'non_existing_user_id',
            Pw   => $Test->{Password},
        );

        $Self->False(
            $AuthResult,
            "CryptType $CryptType Password '$Test->{Password}' (wrong user)",
        );
    }
}

# Check auth for user which password is encrypted by crypt algorithm different than system one.
@Tests = (
    {
        Password  => 'test111test111test111',
        UserLogin => 'example-user' . int rand 1000000,
        CryptType => 'crypt',
    },
    {
        Password  => 'test222test222test222',
        UserLogin => 'example-user' . int rand 1000000,
        CryptType => 'sha1',
    }
);

my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');

# Create users.
for my $Test (@Tests) {
    my $UserID = $UserObject->UserAdd(
        UserFirstname => $Test->{CryptType} . '-Firstname',
        UserLastname  => $Test->{CryptType} . '-Lastname',
        UserLogin     => $Test->{UserLogin},
        UserEmail     => $Test->{UserLogin} . '@example.com',
        ValidID       => 1,
        ChangeUserID  => 1,
    );

    $Self->True(
        $UserID,
        "UserID $UserID is created",
    );

    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::User',
            'Kernel::System::Auth',
        ],
    );

    $ConfigObject->Set(
        Key   => "AuthModule::DB::CryptType",
        Value => $Test->{CryptType},
    );

    $UserObject = $Kernel::OM->Get('Kernel::System::User');
    $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');

    my $PasswordSet = $UserObject->SetPassword(
        UserLogin => $Test->{UserLogin},
        PW        => $Test->{Password},
    );

    $Self->True(
        $PasswordSet,
        "Password '$Test->{Password}' is set"
    );
}

# System is set to sha1 crypt type at this moment and
# we try to authenticate first created user (password is encrypted by different crypt type).
my $Result = $AuthObject->Auth(
    User => $Tests[0]->{UserLogin},
    Pw   => $Tests[0]->{Password},
);

$Self->True(
    $Result,
    "System crypt type - $Tests[1]->{CryptType}, crypt type for user password - $Tests[0]->{CryptType}, user password '$Tests[0]->{Password}'",
);

$TestUserID = $UserObject->UserUpdate(
    UserID        => $TestUserID,
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 2,
    ChangeUserID  => 1,
) || die "Could not invalidate test user";

1;
