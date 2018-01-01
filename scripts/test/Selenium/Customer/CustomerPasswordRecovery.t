# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

        # create test customer user and login
        my $TestCustomerUser = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test user";

        # navigate to customer login screen
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?");

        # click on 'Forgot password?'
        $Selenium->find_element( "#ForgotPassword", 'css' )->VerifiedClick();

        # request new password
        $Selenium->find_element( "#ResetUser",                   'css' )->send_keys($TestCustomerUser);
        $Selenium->find_element( "#Reset button[type='submit']", 'css' )->VerifiedClick();

        # check for password recovery message
        $Self->True(
            $Selenium->find_element( ".ErrorBox span", 'css' ),
            "Password recovery message found on screen for valid customer",
        );

        # check if password recovery email is sent
        my $Emails = $TestEmailObject->EmailsGet();
        $Self->Is(
            scalar @{$Emails},
            1,
            "Password recovery email sent for valid customer user $TestCustomerUser",
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

        # update test customer to invalid status
        $Success = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserUpdate(
            Source         => 'CustomerUser',
            ID             => $TestCustomerUser,
            UserCustomerID => $TestCustomerUser,
            UserLogin      => $TestCustomerUser,
            UserFirstname  => $TestCustomerUser,
            UserLastname   => $TestCustomerUser,
            UserPassword   => $TestCustomerUser,
            UserEmail      => $TestCustomerUser . '@localunittest.com',
            ValidID        => 2,
            UserID         => 1,
        );
        $Self->True(
            $Success,
            "$TestCustomerUser set to invalid",
        );

        # click on 'Forgot password?' again
        $Selenium->find_element( "#ForgotPassword", 'css' )->VerifiedClick();

        # request new password
        $Selenium->find_element( "#ResetUser",                   'css' )->send_keys($TestCustomerUser);
        $Selenium->find_element( "#Reset button[type='submit']", 'css' )->VerifiedClick();

        # check for password recovery message for invalid customer user, for security meassures it
        # should be visible
        $Self->True(
            $Selenium->find_element( ".ErrorBox span", 'css' ),
            "Password recovery message found on screen for invalid customer",
        );

        # check if password recovery email is sent to invalid customer user
        $Emails = $TestEmailObject->EmailsGet();
        $Self->Is(
            scalar @{$Emails},
            0,
            "Password recovery email NOT sent for invalid customer user $TestCustomerUser",
        );
    }
);

1;
