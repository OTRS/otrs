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

local $ENV{TZ} = 'UTC';

# get helper object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 0,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# get config object
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

$ConfigObject->Set(
    Key   => 'OTRSTimeZone',
    Value => 'UTC',
);

# set fixed time to have predetermined verifiable results
$Helper->FixedTimeSet(0);

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

my $UserRand     = 'example-user' . $Helper->GetRandomID();
my $CustomerRand = 'example-customer' . $Helper->GetRandomID();

my $UserObject         = $Kernel::OM->Get('Kernel::System::User');
my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

# add test user and customer
my $TestUserID = $UserObject->UserAdd(
    UserFirstname => 'Firstname Test1',
    UserLastname  => 'Lastname Test1',
    UserLogin     => $UserRand,
    UserEmail     => $UserRand . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
) || die "Could not create test user";

my $TestCustomerUserID = $CustomerUserObject->CustomerUserAdd(
    Source         => 'CustomerUser',
    UserFirstname  => 'Firstname Test',
    UserLastname   => 'Lastname Test',
    UserCustomerID => $CustomerRand,
    UserLogin      => $CustomerRand,
    UserEmail      => $CustomerRand . '@example.com',
    UserPassword   => 'some_pass',
    ValidID        => 1,
    UserID         => 1,
) || die "Could not create test customer";

# configure two factor auth backend
my %CurrentConfig = (
    'SecretPreferencesKey' => 'UnitTestUserGoogleAuthenticatorSecretKey',
    'AllowEmptySecret'     => 0,
    'AllowPreviousToken'   => 0,
    'TimeZone'             => 'UTC',
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

# create Google authenticator object
$Kernel::OM->ObjectParamAdd(
    'Kernel::System::Auth::TwoFactor::GoogleAuthenticator' => {
        Count => 10,
    },
    'Kernel::System::CustomerAuth::TwoFactor::GoogleAuthenticator' => {
        Count => 10,
    },
);
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
        Name               => 'Valid token for different time zone (time zone actually must not matter)',
        ExpectedAuthResult => 1,
        Secret             => 'UNITTESTUNITTEST',
        TwoFactorToken     => '761321',
        FixedTimeSet       => 0,
        TimeZone           => 'Europe/Berlin',
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
            UserID => $CustomerRand,
        );
    }

    # update time zone if necessary
    if ( ( $Test->{TimeZone} || 'UTC' ) ne $CurrentConfig{TimeZone} ) {
        $CurrentConfig{TimeZone} = $Test->{TimeZone} || 'UTC';
        $ConfigObject->Set(
            Key   => 'OTRSTimeZone',
            Value => $CurrentConfig{TimeZone},
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
        $Helper->FixedTimeSet( $CurrentConfig{Time} );
    }

    # test agent auth
    my $AuthResult = $AuthTwoFactorObject->Auth(
        User           => $UserRand,
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
        User           => $CustomerRand,
        TwoFactorToken => $Test->{TwoFactorToken},
    );
    $Self->Is(
        $CustomerAuthResult,
        $Test->{ExpectedAuthResult},
        $Test->{Name} . ' (customer)',
    );
}

# cleanup is done by RestoreDatabase

1;
