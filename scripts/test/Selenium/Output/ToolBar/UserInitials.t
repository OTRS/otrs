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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper     = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # Set AvatarEngine to 'none'.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::AvatarEngine',
            Value => 'none',
        );

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test user.
        my $UserID = $UserObject->UserAdd(
            UserFirstname => "Firstname$RandomID",
            UserLastname  => "Lastname$RandomID",
            UserLogin     => "UserLogin$RandomID",
            UserPw        => "UserLogin$RandomID",
            UserEmail     => "UserLogin$RandomID" . '@localunittest.com',
            ValidID       => 1,
            ChangeUserID  => 1,
        );
        $Self->True(
            $UserID,
            "UserID $UserID is created",
        );

        my %User = $UserObject->GetUserData(
            UserID => $UserID,
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $User{UserLogin},
            Password => $User{UserLogin},
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        my %Tests = (
            0 => 'FL',
            1 => 'LF',
            2 => 'FL',
            3 => 'LF',
            4 => 'FL',
            5 => 'LF',
            6 => 'LF',
            7 => 'LF',
            8 => 'LF',
            9 => 'L',
        );

        for my $Order ( sort keys %Tests ) {
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'FirstnameLastnameOrder',
                Value => $Order,
            );
            sleep 1;

            $Selenium->VerifiedGet("${ScriptAlias}index.pl");

            $Self->Is(
                $Selenium->find_element( '.Initials', 'css' )->get_text(),
                $Tests{$Order},
                "Correct initials - order '$Order', initials '$Tests{$Order}'",
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test user.
        my $Success = $DBObject->Do(
            SQL  => "DELETE FROM user_preferences WHERE user_id = ?",
            Bind => [ \$UserID ],
        );
        $Self->True(
            $Success,
            "User preferences for UserID $UserID is deleted",
        );
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM users WHERE id = ?",
            Bind => [ \$UserID ],
        );
        $Self->True(
            $Success,
            "UserID $UserID is deleted",
        );

    }
);

1;
