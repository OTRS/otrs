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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get needed objects
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');
        my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');

        # use test email backend
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        $ConfigObject->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # clean up test email
        my $Success = $TestEmailObject->CleanUp();
        $Self->True(
            $Success,
            'Initial cleanup',
        );

        $Self->IsDeeply(
            $TestEmailObject->EmailsGet(),
            [],
            'Test email empty after initial cleanup',
        );

        # clean up test email again (cached)
        $Success = $TestEmailObject->CleanUp();
        $Self->True(
            $Success,
            'Initial cleanup',
        );

        # create test user and login
        my $TestUser = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # navigate to agent login screen
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?");

        # click on 'Lost your password?'
        $Selenium->find_element( "#LostPassword", 'css' )->VerifiedClick();

        # request new password
        $Selenium->find_element( "#PasswordUser",                      'css' )->send_keys($TestUser);
        $Selenium->find_element( "#PasswordBox button[type='submit']", 'css' )->VerifiedClick();

        # check for password recovery message
        $Self->True(
            $Selenium->find_element( "#LoginBox p.Error", 'css' ),
            "Password recovery message found on screen for valid user",
        );

        # check if password recovery email is sent to valid user
        my $Emails = $TestEmailObject->EmailsGet();
        $Self->Is(
            scalar @{$Emails},
            1,
            "Password recovery email sent for valid user $TestUser",
        );

        # clean up test email again
        $Success = $TestEmailObject->CleanUp();
        $Self->True(
            $Success,
            'Second cleanup',
        );

        $Self->IsDeeply(
            $TestEmailObject->EmailsGet(),
            [],
            'Test email empty after second cleanup',
        );

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # get test user ID
        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUser,
        );

        # update user to invalid
        $Success = $UserObject->UserUpdate(
            UserID        => $TestUserID,
            UserFirstname => $TestUser,
            UserLastname  => $TestUser,
            UserLogin     => $TestUser,
            UserPw        => $TestUser,
            UserEmail     => $TestUser . '@localunittest.com',
            ValidID       => 2,
            ChangeUserID  => 1,
        );
        $Self->True(
            $Success,
            "$TestUser set to invalid",
        );

        # click on 'Lost your password?' again
        $Selenium->find_element( "#LostPassword", 'css' )->VerifiedClick();

        # request new password
        $Selenium->find_element( "#PasswordUser",                      'css' )->send_keys($TestUser);
        $Selenium->find_element( "#PasswordBox button[type='submit']", 'css' )->VerifiedClick();

        # check for password recovery message for invalid user, for security meassures it
        # should be visible
        $Self->True(
            $Selenium->find_element( "#LoginBox p.Error", 'css' ),
            "Password recovery message found on screen for invalid user",
        );

        # check if password recovery email is sent to invalid user
        $Emails = $TestEmailObject->EmailsGet();
        $Self->Is(
            scalar @{$Emails},
            0,
            "Password recovery email NOT sent for invalid user $TestUser",
        );
    }
);

1;
