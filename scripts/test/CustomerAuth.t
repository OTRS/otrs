# --
# CustomerAuth.t - Customer authentication tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

my $UserRand1 = 'example-user' . int rand 1000000;

my $TestUserID = $GlobalUserObject->CustomerUserAdd(
    UserFirstname  => 'CustomerFirstname Test1',
    UserLastname   => 'CustomerLastname Test1',
    UserCustomerID => 'Customer246',
    UserLogin      => $UserRand1,
    UserEmail      => $UserRand1 . '@example.com',
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

for my $CryptType (qw(plain crypt md5 sha1 sha2 bcrypt)) {

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
            UserLogin => $UserRand1,
            PW        => $Test->{Password},
        );

        $Self->True(
            $PasswordSet,
            "Password set"
        );

        my $CustomerAuthResult = $CustomerAuthObject->Auth(
            User => $UserRand1,
            Pw   => $Test->{Password},
        );

        $Self->True(
            $CustomerAuthResult,
            "CryptType $CryptType Password '$Test->{Password}'",
        );

        $CustomerAuthResult = $CustomerAuthObject->Auth(
            User => $UserRand1,
            Pw   => $Test->{Password},
        );

        $Self->True(
            $CustomerAuthResult,
            "CryptType $CryptType Password '$Test->{Password}' (cached)",
        );

        $CustomerAuthResult = $CustomerAuthObject->Auth(
            User => $UserRand1,
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
    UserLogin      => $UserRand1,
    UserEmail      => $UserRand1 . '@example.com',
    ValidID        => 2,
    UserID         => 1,
);

$Self->True(
    $Success,
    "Invalidating test customer user",
);

1;
