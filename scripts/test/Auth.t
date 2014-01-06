# --
# Auth.t - Authentication tests
# Copyright (C) 2001-2014 OTRS AG, http://otrs.com/
# --
# $Id: Auth.t,v 1.5.4.1 2012-11-26 16:19:08 mh Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;
use vars (qw($Self));

use Kernel::System::Auth;
use Kernel::System::User;
use Kernel::System::Group;

# use local Config object because it will be modified
my $ConfigObject = Kernel::Config->new();

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

my $UserRand1 = 'example-user' . int( rand(1000000) );

# add test user
my $GlobalUserObject = Kernel::System::User->new(
    %{$Self},
    ConfigObject => $ConfigObject,
);

$TestUserID = $GlobalUserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

for my $CryptType (qw(plain crypt md5 sha1 sha2)) {

    $ConfigObject->Set(
        Key   => "AuthModule::DB::CryptType",
        Value => $CryptType
    );

    my $UserObject = Kernel::System::User->new(
        %{$Self},
        ConfigObject => $ConfigObject,
    );

    my $GroupObject = Kernel::System::Group->new(
        %{$Self},
        ConfigObject => $ConfigObject
    );

    my $AuthObject = Kernel::System::Auth->new(
        %{$Self},
        ConfigObject => $ConfigObject,
        UserObject   => $UserObject,
        GroupObject  => $GroupObject,
    );

    # set pw

    my @Tests = (
        {
            Password => 'simple',
            Result   => 1,
        },
        {
            Password => 'very long password line which is unusual',
            Result   => 1,
        },
        {
            Password => 'Переводчик',
            Result   => 1,
        },
        {
            Password => 'كل ما تحب معرفته عن',
            Result   => 1,
        },
        {
            Password => ' ',
            Result   => 1,
        },
        {
            Password => "\n",
            Result   => 1,
        },
        {
            Password => "\t",
            Result   => 1,
        },

        # SQL security tests
        {
            Password => "'UNION'",
            Result   => 1,
        },
        {
            Password => "';",
            Result   => 1,
        },
    );

    for my $Test (@Tests) {

        my $PasswordSet = $UserObject->SetPassword(
            UserLogin => $UserRand1,
            PW        => $Test->{Password},
        );

        $Self->True(
            $PasswordSet,
            "Password set"
        );

        my $AuthResult = $AuthObject->Auth(
            User => $UserRand1,
            Pw   => $Test->{Password},
        );

        $Self->True(
            $AuthResult,
            "CryptType $CryptType Password '$Test->{Password}'",
        );

        $AuthResult = $AuthObject->Auth(
            User => $UserRand1,
            Pw   => $Test->{Password},
        );

        $Self->True(
            $AuthResult,
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

$TestUserID = $GlobalUserObject->UserUpdate(
    UserID        => $TestUserID,
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 2,
    ChangeUserID  => 1,
) || die "Could not invalidate test user";

1;
