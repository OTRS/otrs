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

## nofilter(TidyAll::Plugin::OTRS::Migrations::OTRS6::PermissionDataNotInSession)

use vars (qw($Self));

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
my $DBObject   = $Kernel::OM->Get('Kernel::System::DB');
my $UserObject = $Kernel::OM->Get('Kernel::System::User');

my $DBUpdateObject = $Kernel::OM->Create('scripts::DBUpdateTo6::UpgradeDatabaseStructure::FixUserPreferenceKeys');

my ( $Success, $Result );

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic

    # Check no-op behavior.
    $Success = $DBUpdateObject->Run(
        CommandlineOptions => {
            NonInteractive => 1,
            Verbose        => 1,
        },
    );
}

$Self->True(
    $Success,
    'Migration module ran OK first time'
);

$Self->True(
    ( $Result =~ m{Blacklisted keys not found in user preference tables\.} ) // 0,
    'Found no-op log message'
);

my $RandomID = $Helper->GetRandomID();

# Create test user.
my $TestUserLogin = $Helper->TestUserCreate();
my $TestUserID    = $UserObject->UserLookup( UserLogin => $TestUserLogin );

# Add offending keys with corresponding values to preferences of the test user.
my %UserTestKeys = (
    UserID                 => $RandomID,
    UserLogin              => $RandomID,
    UserPw                 => $RandomID,
    UserFirstname          => $RandomID,
    UserLastname           => $RandomID,
    UserFullname           => $RandomID,
    UserTitle              => $RandomID,
    ChangeTime             => $RandomID,
    CreateTime             => $RandomID,
    ValidID                => $RandomID,
    'UserIsGroup[users]'   => 'yes',
    'UserIsGroupRo[users]' => 'yes',
);

for my $TestKey ( sort keys %UserTestKeys ) {
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO user_preferences
                (user_id, preferences_key, preferences_value)
                VALUES (?, ?, ?)
        ',
        Bind => [
            \$TestUserID, \$TestKey, \$UserTestKeys{$TestKey},
        ],
    );
}

# Sanity check.
for my $TestKey ( sort keys %UserTestKeys ) {
    return if !$DBObject->Prepare(
        SQL => '
            SELECT preferences_value
                FROM user_preferences
                WHERE user_id = ? AND preferences_key = ?
        ',
        Bind => [
            \$TestUserID, \$TestKey,
        ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->Is(
            $Row[0],
            $UserTestKeys{$TestKey},
            "Found '$TestKey' preference value for user $TestUserID"
        );
    }
}

# Get UserEmail preference value.
return if !$DBObject->Prepare(
    SQL => '
        SELECT preferences_value
            FROM user_preferences
            WHERE user_id = ? AND preferences_key = ?
    ',
    Bind => [
        \$TestUserID, \'UserEmail',
    ],
);

my $TestUserEmail;

while ( my @Row = $DBObject->FetchrowArray() ) {
    $TestUserEmail = $Row[0];
}

$Self->True(
    $TestUserEmail // 0,
    "Found 'UserEmail' preference value for user $TestUserID"
);

# Create test customer user.
my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate();

# Add offending keys with corresponding values to preferences of the test customer user.
my %CustomerTestKeys = (
    UserID                 => $RandomID,
    UserLogin              => $RandomID,
    UserPassword           => $RandomID,
    UserFirstname          => $RandomID,
    UserLastname           => $RandomID,
    UserFullname           => $RandomID,
    UserStreet             => $RandomID,
    UserCity               => $RandomID,
    UserZip                => $RandomID,
    UserCountry            => $RandomID,
    UserComment            => $RandomID,
    UserCustomerID         => $RandomID,
    UserTitle              => $RandomID,
    UserEmail              => "$RandomID\@localunittest.com",
    ChangeTime             => $RandomID,
    ChangeBy               => $RandomID,
    CreateTime             => $RandomID,
    CreateBy               => $RandomID,
    UserPhone              => $RandomID,
    UserMobile             => $RandomID,
    UserFax                => $RandomID,
    UserMailString         => "$RandomID\@localunittest.com",
    ValidID                => $RandomID,
    'UserIsGroup[users]'   => 'yes',
    'UserIsGroupRo[users]' => 'yes',
);

for my $TestKey ( sort keys %CustomerTestKeys ) {
    return if !$DBObject->Do(
        SQL => '
            INSERT INTO customer_preferences
                (user_id, preferences_key, preferences_value)
                VALUES (?, ?, ?)
        ',
        Bind => [
            \$TestCustomerUserLogin, \$TestKey, \$CustomerTestKeys{$TestKey},
        ],
    );
}

# Sanity check.
for my $TestKey ( sort keys %CustomerTestKeys ) {
    return if !$DBObject->Prepare(
        SQL => '
            SELECT preferences_value
                FROM customer_preferences
                WHERE user_id = ? AND preferences_key = ?
        ',
        Bind => [
            \$TestCustomerUserLogin, \$TestKey,
        ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->Is(
            $Row[0],
            $CustomerTestKeys{$TestKey},
            "Found '$TestKey' preference value for customer user $TestCustomerUserLogin",
        );
    }
}

{
    local *STDOUT;
    open STDOUT, '>:utf8', \$Result;    ## no critic

    # Fix user preference keys.
    $Success = $DBUpdateObject->Run(
        CommandlineOptions => {
            NonInteractive => 1,
            Verbose        => 1,
        },
    );
}

$Self->True(
    $Success,
    'Migration module ran OK second time'
);

$Self->True(
    ( $Result =~ m{Cleaned up found blacklisted keys from user preference tables\.} ) // 0,
    'Found fixed log message'
);

# Check if user preference keys were cleaned up.
for my $TestKey ( sort keys %UserTestKeys ) {
    return if !$DBObject->Prepare(
        SQL => '
            SELECT COUNT(*)
                FROM user_preferences
                WHERE user_id = ? AND preferences_key = ?
        ',
        Bind => [
            \$TestUserID, \$TestKey,
        ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->False(
            $Row[0] // 1,
            "Offending preference key '$TestKey' not found for user $TestUserID"
        );
    }
}

# Check if UserEmail preference value still exists.
return if !$DBObject->Prepare(
    SQL => '
        SELECT preferences_value
            FROM user_preferences
            WHERE user_id = ? AND preferences_key = ?
    ',
    Bind => [
        \$TestUserID, \'UserEmail',
    ],
);

while ( my @Row = $DBObject->FetchrowArray() ) {
    $Self->Is(
        $Row[0] // '',
        $TestUserEmail,
        "Found 'UserEmail' preference value for user $TestUserID"
    );
}

# Check if customer preference keys were cleaned up.
for my $TestKey ( sort keys %CustomerTestKeys ) {
    return if !$DBObject->Prepare(
        SQL => '
            SELECT COUNT(*)
                FROM customer_preferences
                WHERE user_id = ? AND preferences_key = ?
        ',
        Bind => [
            \$TestCustomerUserLogin, \$TestKey,
        ],
    );

    while ( my @Row = $DBObject->FetchrowArray() ) {
        $Self->False(
            $Row[0] // 1,
            "Offending preference key '$TestKey' not found for customer user $TestCustomerUserLogin"
        );
    }
}

# Cleanup is done by RestoreDatabase.

1;
