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

my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
my $UserObject    = $Kernel::OM->Get('Kernel::System::User');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

# Create test users and a session for every one.
my @TestUserLogins;
for my $Count ( 1 .. 3 ) {
    my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate();
    push @TestUserLogins, $TestUserLogin;

    my %UserData = $UserObject->GetUserData(
        UserID        => $TestUserID,
        NoOutOfOffice => 1,
    );

    my $NewSessionID = $SessionObject->CreateSessionID(
        %UserData,
        UserLastRequest => $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch(),
        UserType        => 'User',
        SessionSource   => 'AgentInterface',
    );
    $Self->True(
        $NewSessionID,
        "SessionID '$NewSessionID' is created for user '$TestUserLogin'",
    );
}

# Check if all sessions exist.
my @SessionIDs = $SessionObject->GetAllSessionIDs();
my %SessionDataLoginBefore;

for my $SessionID (@SessionIDs) {
    my %SessionData = $SessionObject->GetSessionIDData(
        SessionID => $SessionID,
    );
    $SessionDataLoginBefore{ $SessionData{UserLogin} } = 1;
}

for my $TestUserLogin (@TestUserLogins) {
    $Self->True(
        $SessionDataLoginBefore{$TestUserLogin},
        "User '$TestUserLogin' is found",
    );
}

my $TestUserLoginRemoveSession = $TestUserLogins[0];

# Remove session from one test user.
my $Success = $SessionObject->RemoveSessionByUser(
    UserLogin => $TestUserLoginRemoveSession,
);
$Self->True(
    $Success,
    "Session from user '$TestUserLoginRemoveSession' is deleted",
);

# Check if only appropriate session is removed.
@SessionIDs = $SessionObject->GetAllSessionIDs();
my %SessionDataLoginAfter;

for my $SessionID (@SessionIDs) {
    my %SessionData = $SessionObject->GetSessionIDData(
        SessionID => $SessionID,
    );
    $SessionDataLoginAfter{ $SessionData{UserLogin} } = 1;
}

for my $TestUserLogin (@TestUserLogins) {
    if ( $TestUserLogin eq $TestUserLoginRemoveSession ) {
        $Self->False(
            $SessionDataLoginAfter{$TestUserLogin},
            "User '$TestUserLogin' is not found",
        );
    }
    else {
        $Self->True(
            $SessionDataLoginAfter{$TestUserLogin},
            "User '$TestUserLogin' is found",
        );
    }
}

# Restore to the previous state is done by RestoreDatabase.

1;
