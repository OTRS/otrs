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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $UserObject   = $Kernel::OM->Get('Kernel::System::User');

$Kernel::OM->ObjectParamAdd(
    'Kernel::System::UnitTest::Helper' => {
        RestoreDatabase => 1,
    },
);
my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

$ConfigObject->Set(
    Key   => 'CheckEmailAddresses',
    Value => 0,
);

my $UserRandom = 'unittest-' . $Helper->GetRandomID();
my $UserID     = $UserObject->UserAdd(
    UserFirstname => 'John',
    UserLastname  => 'Doe',
    UserLogin     => $UserRandom,
    UserEmail     => $UserRandom . '@example.com',
    ValidID       => 1,
    ChangeUserID  => 1,
);

my %UserData = $UserObject->GetUserData(
    UserID => $UserID,
);

KEY:
for my $Key ( sort keys %UserData ) {

    # Skip some data that comes from default values.
    next KEY if $Key =~ m/PageShown$/smx;
    next KEY if $Key =~ m/NextMask$/smx;
    next KEY if $Key =~ m/RefreshTime$/smx;

    # These are actually user preferences.
    next KEY if $Key =~ m/UserEmail$/smx;
    next KEY if $Key =~ m/UserMobile$/smx;

    $Self->False(
        $UserObject->SetPreferences(
            Key    => $Key,
            Value  => '1',
            UserID => $UserID,
        ),
        "Preference for $Key not updated"
    );

    my %NewUserData = $UserObject->GetUserData(
        UserID => $UserID,
    );
    $Self->Is(
        $NewUserData{$Key},
        $UserData{$Key},
        "User data $Key unchanged"
    );
}

# cleanup is done by RestoreDatabase

1;
