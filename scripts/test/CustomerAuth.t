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

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# configure CustomerAuth backend to db
$ConfigObject->Set( 'CustomerAuthBackend', 'DB' );

# no additional CustomerAuth backends
for my $Count ( 1 .. 10 ) {
    $ConfigObject->Set( "CustomerAuthBackend$Count", '' );
}

# disable email checks to create new user
$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

# add test user
my $GlobalUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

my $UserRand = 'example-user' . $Helper->GetRandomID();

my $TestUserID = $GlobalUserObject->CustomerUserAdd(
    UserFirstname  => 'CustomerFirstname Test1',
    UserLastname   => 'CustomerLastname Test1',
    UserCustomerID => 'Customer246',
    UserLogin      => $UserRand,
    UserEmail      => $UserRand . '@example.com',
    ValidID        => 1,
    UserID         => 1,
);

$Self->True(
    $TestUserID,
    "Creating test customer user",
);

# set pw
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

for my $CryptType (qw(plain crypt apr1 md5 sha1 sha2 sha512 bcrypt)) {

    # make sure that the customer user objects gets recreated for each loop.
    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::CustomerUser',
            'Kernel::System::CustomerAuth',
        ],
    );

    $ConfigObject->Set(
        Key   => "Customer::AuthModule::DB::CryptType",
        Value => $CryptType
    );

    my $UserObject         = $Kernel::OM->Get('Kernel::System::CustomerUser');
    my $CustomerAuthObject = $Kernel::OM->Get('Kernel::System::CustomerAuth');

    for my $Test (@Tests) {

        my $PasswordSet = $UserObject->SetPassword(
            UserLogin => $UserRand,
            PW        => $Test->{Password},
        );

        $Self->True(
            $PasswordSet,
            "Password set"
        );

        my $CustomerAuthResult = $CustomerAuthObject->Auth(
            User => $UserRand,
            Pw   => $Test->{Password},
        );

        $Self->True(
            $CustomerAuthResult,
            "CryptType $CryptType Password '$Test->{Password}'",
        );

        $CustomerAuthResult = $CustomerAuthObject->Auth(
            User => $UserRand,
            Pw   => $Test->{Password},
        );

        $Self->True(
            $CustomerAuthResult,
            "CryptType $CryptType Password '$Test->{Password}' (cached)",
        );

        if ( $CryptType eq 'bcrypt' ) {
            my $OldCost = $ConfigObject->Get('Customer::AuthModule::DB::bcryptCost') // 12;
            my $NewCost = $OldCost + 2;

            # Increase cost and check if old passwords can still be used.
            $ConfigObject->Set(
                Key   => 'Customer::AuthModule::DB::bcryptCost',
                Value => $NewCost,
            );

            $CustomerAuthResult = $CustomerAuthObject->Auth(
                User => $UserRand,
                Pw   => $Test->{Password},
            );

            $Self->Is(
                $CustomerAuthResult,
                $Test->{AuthResult},
                "CryptType $CryptType old Password '$Test->{Password}' with changed default cost ($NewCost)",
            );

            $PasswordSet = $UserObject->SetPassword(
                UserLogin => $UserRand,
                PW        => $Test->{Password},
            );

            $Self->True(
                $PasswordSet,
                "Password set - with new cost $NewCost"
            );

            $CustomerAuthResult = $CustomerAuthObject->Auth(
                User => $UserRand,
                Pw   => $Test->{Password},
            );

            $Self->Is(
                $CustomerAuthResult,
                $Test->{AuthResult},
                "CryptType $CryptType new Password '$Test->{Password}' with changed default cost ($NewCost)",
            );

            # Restore old cost value
            $ConfigObject->Set(
                Key   => 'Customer::AuthModule::DB::bcryptCost',
                Value => $OldCost,
            );
        }

        $CustomerAuthResult = $CustomerAuthObject->Auth(
            User => $UserRand,
            Pw   => 'wrong_pw',
        );

        $Self->False(
            $CustomerAuthResult,
            "CryptType $CryptType Password '$Test->{Password}' (wrong password)",
        );

        $CustomerAuthResult = $CustomerAuthObject->Auth(
            User => 'non_existing_user_id',
            Pw   => $Test->{Password},
        );

        $Self->False(
            $CustomerAuthResult,
            "CryptType $CryptType Password '$Test->{Password}' (wrong user)",
        );
    }
}

my $Success = $GlobalUserObject->CustomerUserUpdate(
    ID             => $TestUserID,
    UserFirstname  => 'CustomerFirstname Test1',
    UserLastname   => 'CustomerLastname Test1',
    UserCustomerID => 'Customer246',
    UserLogin      => $UserRand,
    UserEmail      => $UserRand . '@example.com',
    ValidID        => 2,
    UserID         => 1,
);

$Self->True(
    $Success,
    "Invalidating test customer user",
);

# Check auth for customer user which password is encrypted by crypt algorithm different than system one.
@Tests = (
    {
        Password  => 'test111test111test111',
        UserLogin => 'example-user' . $Helper->GetRandomID(),
        CryptType => 'crypt',
    },
    {
        Password  => 'test222test222test222',
        UserLogin => 'example-user' . $Helper->GetRandomID(),
        CryptType => 'sha1',
    }
);

my $CustomerUserObject;
my $CustomerUserAuthObject;

# Create customer users.
for my $Test (@Tests) {
    my $CustomerUserID = $GlobalUserObject->CustomerUserAdd(
        UserFirstname  => $Test->{CryptType} . '-Firstname',
        UserLastname   => $Test->{CryptType} . '-Lastname',
        UserCustomerID => 'Customer246',
        UserLogin      => $Test->{UserLogin},
        UserEmail      => $Test->{UserLogin} . '@example.com',
        ValidID        => 1,
        UserID         => 1,
    );

    $Self->True(
        $CustomerUserID,
        "CustomerUserID $CustomerUserID is created",
    );

    $Kernel::OM->ObjectsDiscard(
        Objects => [
            'Kernel::System::CustomerUser',
            'Kernel::System::CustomerAuth',
        ],
    );

    $ConfigObject->Set(
        Key   => "Customer::AuthModule::DB::CryptType",
        Value => $Test->{CryptType}
    );

    $CustomerUserObject     = $Kernel::OM->Get('Kernel::System::CustomerUser');
    $CustomerUserAuthObject = $Kernel::OM->Get('Kernel::System::CustomerAuth');

    my $PasswordSet = $CustomerUserObject->SetPassword(
        UserLogin => $Test->{UserLogin},
        PW        => $Test->{Password},
    );

    $Self->True(
        $PasswordSet,
        "Password '$Test->{Password}' is set"
    );
}

# System is set to sha1 crypt type at this moment and
# we try to authenticate first created customer user (password is encrypted by different crypt type).
my $Result = $CustomerUserAuthObject->Auth(
    User => $Tests[0]->{UserLogin},
    Pw   => $Tests[0]->{Password},
);

$Self->True(
    $Result,
    "System crypt type - $Tests[1]->{CryptType}, crypt type for customer password - $Tests[0]->{CryptType}, customer password '$Tests[0]->{Password}'",
);

# cleanup is done by RestoreDatabase

1;
