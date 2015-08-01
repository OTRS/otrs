# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

local $ENV{TZ} = 'UTC';

use Kernel::System::ObjectManager;
local $Kernel::OM = Kernel::System::ObjectManager->new(
    'Kernel::Output::HTML::Layout' => {
        Lang => 'en',
    },
    'Kernel::System::Auth::TwoFactor::GoogleAuthenticator' => {
        Count => 10,
    },
    'Kernel::System::CustomerAuth::TwoFactor::GoogleAuthenticator' => {
        Count => 10,
    },
);

# get helper object
my $HelperObject = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$ConfigObject->Set(
    Key   => 'TimeZone',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'TimeZoneUser',
    Value => 0,
);
$ConfigObject->Set(
    Key   => 'TimeZoneUserBrowserAutoOffset',
    Value => 0,
);

# set fixed time to have predetermined verifiable results
$HelperObject->FixedTimeSet(0);

# get time object
my $TimeObject = $Kernel::OM->Get('Kernel::System::Time');

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

my $UserRand1     = 'example-user' . int rand 1000000;
my $CustomerRand1 = 'example-customer' . int rand 1000000;

my $UserObject         = $Kernel::OM->Get('Kernel::System::User');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# add test user and customer
my $TestUserID = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";
my $TestCustomerUserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'Firstname Test',
    UserLastname   => 'Lastname Test',
    UserCustomerID => $CustomerRand1,
    UserLogin      => $CustomerRand1,
    UserEmail      => $CustomerRand1 . '@example.com',
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
) || die "Could not create test customer";

# configure two factor auth backend
my %CurrentConfig = (
    'SecretPreferencesKey' => 'UnitTestUserGoogleAuthenticatorSecretKey',
    'AllowEmptySecret'     => 0,
    'AllowPreviousToken'   => 0,
    'TimeZone'             => 0,
    'Secret'               => '',
    'Time'                 => 0,
);
for my $ConfigKey ( sort keys %CurrentConfig ) {
    $ConfigObject->Set(
        Key   => 'AuthTwoFactorModule10::' . $ConfigKey,
        Value => $CurrentConfig{$ConfigKey},
    );
    $ConfigObject->Set(
        Key   => 'Customer::AuthTwoFactorModule10::' . $ConfigKey,
        Value => $CurrentConfig{$ConfigKey},
    );
}

# create google authenticator object
my $AuthTwoFactorObject         = $Kernel::OM->Get('Kernel::System::Auth::TwoFactor::GoogleAuthenticator');
my $CustomerAuthTwoFactorObject = $Kernel::OM->Get('Kernel::System::CustomerAuth::TwoFactor::GoogleAuthenticator');

my @Tests = (
    {
        Name               => 'No secret, AllowEmptySecret = 0',
        ExpectedAuthResult => undef,
        Secret             => undef,
        AllowEmptySecret   => 0,
    },
    {
        Name               => 'No secret, AllowEmptySecret = 1',
        ExpectedAuthResult => 1,
        Secret             => undef,
        AllowEmptySecret   => 1,
    },
    {
        Name               => 'Invalid token',
        ExpectedAuthResult => undef,
        Secret             => 'UNITTESTUNITTEST',
        TwoFactorToken     => '123456',
    },
    {
        Name               => 'Valid token',
        ExpectedAuthResult => 1,
        Secret             => 'UNITTESTUNITTEST',
        TwoFactorToken     => '761321',
    },
    {
        Name               => 'Valid token, different secret',
        ExpectedAuthResult => undef,
        Secret             => 'UNITTESTUNITTESX',
        TwoFactorToken     => '761321',
    },
    {
        Name               => 'Previous token, AllowPreviousToken = 0',
        ExpectedAuthResult => undef,
        Secret             => 'UNITTESTUNITTEST',
        TwoFactorToken     => '761321',
        AllowPreviousToken => 0,
        FixedTimeSet       => 30,
    },
    {
        Name               => 'Previous token, AllowPreviousToken = 1',
        ExpectedAuthResult => 1,
        Secret             => 'UNITTESTUNITTEST',
        TwoFactorToken     => '761321',
        AllowPreviousToken => 1,
        FixedTimeSet       => 30,
    },
    {
        Name               => 'New valid token',
        ExpectedAuthResult => 1,
        Secret             => 'UNITTESTUNITTEST',
        TwoFactorToken     => '002639',
        FixedTimeSet       => 30,
    },
    {
        Name               => 'Even older token, AllowPreviousToken = 1',
        ExpectedAuthResult => undef,
        Secret             => 'UNITTESTUNITTEST',
        TwoFactorToken     => '761321',
        AllowPreviousToken => 1,
        FixedTimeSet       => 60,
    },
    {
        Name               => 'Valid token for different time zone',
        ExpectedAuthResult => 1,
        Secret             => 'UNITTESTUNITTEST',
        TwoFactorToken     => '281099',
        FixedTimeSet       => 0,
        TimeZone           => 1,
    },
);

for my $Test (@Tests) {

    # update secret if necessary
    if ( ( $Test->{Secret} || '' ) ne $CurrentConfig{Secret} && !$Test->{KeepOldSecret} ) {
        $CurrentConfig{Secret} = $Test->{Secret} || '';
        $UserObject->SetPreferences(
            Key    => 'UnitTestUserGoogleAuthenticatorSecretKey',
            Value  => $CurrentConfig{Secret},
            UserID => $TestUserID,
        );
        $CustomerUserObject->SetPreferences(
            Key    => 'UnitTestUserGoogleAuthenticatorSecretKey',
            Value  => $CurrentConfig{Secret},
            UserID => $CustomerRand1,
        );
    }

    # update time zone if necessary
    if ( ( $Test->{TimeZone} || '0' ) ne $CurrentConfig{TimeZone} ) {
        $CurrentConfig{TimeZone} = $Test->{TimeZone} || '0';
        $ConfigObject->Set(
            Key   => 'TimeZone',
            Value => $CurrentConfig{TimeZone},
        );

        # a different timezone config requires a new time object
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::Time'],
        );
    }

    # update config if necessary
    CONFIGKEY:
    for my $ConfigKey (qw(AllowEmptySecret AllowPreviousToken)) {
        next CONFIGKEY if ( $Test->{$ConfigKey} || '' ) eq $CurrentConfig{$ConfigKey};
        $CurrentConfig{$ConfigKey} = $Test->{$ConfigKey} || '';
        $ConfigObject->Set(
            Key   => 'AuthTwoFactorModule10::' . $ConfigKey,
            Value => $CurrentConfig{$ConfigKey},
        );
        $ConfigObject->Set(
            Key   => 'Customer::AuthTwoFactorModule10::' . $ConfigKey,
            Value => $CurrentConfig{$ConfigKey},
        );
    }

    # update time if necessary
    if ( ( $Test->{FixedTimeSet} || 0 ) ne $CurrentConfig{Time} ) {
        $CurrentConfig{Time} = $Test->{FixedTimeSet} || 0;
        $HelperObject->FixedTimeSet( $CurrentConfig{Time} );
    }

    # test agent auth
    my $AuthResult = $AuthTwoFactorObject->Auth(
        User           => $UserRand1,
        UserID         => $TestUserID,
        TwoFactorToken => $Test->{TwoFactorToken},
    );
    $Self->Is(
        $AuthResult,
        $Test->{ExpectedAuthResult},
        $Test->{Name} . ' (agent)',
    );

    # test customer auth
    my $CustomerAuthResult = $CustomerAuthTwoFactorObject->Auth(
        User           => $CustomerRand1,
        TwoFactorToken => $Test->{TwoFactorToken},
    );
    $Self->Is(
        $CustomerAuthResult,
        $Test->{ExpectedAuthResult},
        $Test->{Name} . ' (customer)',
    );
}

$TestUserID = $UserObject->UserUpdate(
    UserID        => $TestUserID,
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand1,
    UserEmail     => $UserRand1 . '@example.com',
    ValidID       => 2,
    ChangeUserID  => 1,
) || die "Could not invalidate test user";
$TestCustomerUserID = $CustomerUserObject->CustomerUserUpdate(
    Source         => 'CustomerUser',
    UserFirstname  => 'Firstname Test',
    UserLastname   => 'Lastname Test',
    UserCustomerID => $CustomerRand1,
    UserLogin      => $CustomerRand1,
    UserEmail      => $CustomerRand1 . '@example.com',
    ValidID        => 2,
    UserID         => 1,
    ID             => $CustomerRand1,
) || die "Could not invalidate test customer";

1;
