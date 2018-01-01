# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

my @Tests = (
    {
        Password   => 'simple',
        AuthResult => $UserRand,
    },
    {
        Password   => 'very long password line which is unusual',
        AuthResult => $UserRand,
    },
    {
        Password   => 'Переводчик',
        AuthResult => $UserRand,
    },
    {
        Password   => 'كل ما تحب معرفته عن',
        AuthResult => $UserRand,
    },
    {
        Password   => ' ',
        AuthResult => $UserRand,
    },
    {
        Password   => "\n",
        AuthResult => $UserRand,
    },
    {
        Password   => "\t",
        AuthResult => $UserRand,
    },
    {
        Password   => "a" x 64,    # max length for plain
        AuthResult => $UserRand,
    },

    # SQL security tests
    {
        Password   => "'UNION'",
        AuthResult => $UserRand,
    },
    {
        Password   => "';",
        AuthResult => $UserRand,
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

    # get needed objects
    my $UserObject = $Kernel::OM->Get('Kernel::System::User');
    my $AuthObject = $Kernel::OM->Get('Kernel::System::Auth');

    TEST:
    for my $Test (@Tests) {

        my $PasswordSet = $UserObject->SetPassword(
            UserLogin => $UserRand,
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
            User => $UserRand,
            Pw   => $Test->{Password},
        );

        $Self->Is(
            $AuthResult,
            $Test->{AuthResult},
            "CryptType $CryptType Password '$Test->{Password}'",
        );

        $AuthResult = $AuthObject->Auth(
            User => $UserRand,
            Pw   => $Test->{Password},
        );

        $Self->Is(
            $AuthResult,
            $Test->{AuthResult},
            "CryptType $CryptType Password '$Test->{Password}' (cached)",
        );

        $AuthResult = $AuthObject->Auth(
            User => $UserRand,
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

# cleanup is done by RestoreDatabase

1;
