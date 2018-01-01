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
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject    = $Kernel::OM->Get('Kernel::Config');
        my $TestEmailObject = $Kernel::OM->Get('Kernel::System::Email::Test');
        my $MailQueueObject = $Kernel::OM->Get('Kernel::System::MailQueue');

        my %MailQueueCurrentItems = map { $_->{ID} => $_ } @{ $MailQueueObject->List() || [] };

        my $MailQueueClean = sub {
            my $Items = $MailQueueObject->List();
            MAIL_QUEUE_ITEM:
            for my $Item ( @{$Items} ) {
                next MAIL_QUEUE_ITEM if $MailQueueCurrentItems{ $Item->{ID} };
                $MailQueueObject->Delete(
                    ID => $Item->{ID},
                );
            }

            return;
        };

        my $MailQueueProcess = sub {
            my %Param = @_;

            my $EmailObject = $Kernel::OM->Get('Kernel::System::Email');

            # Process all items except the ones already present before the tests.
            my $Items = $MailQueueObject->List();
            MAIL_QUEUE_ITEM:
            for my $Item ( @{$Items} ) {
                next MAIL_QUEUE_ITEM if $MailQueueCurrentItems{ $Item->{ID} };
                $MailQueueObject->Send( %{$Item} );
            }

            # Clean any garbage
            $MailQueueClean->();

            return;
        };

        # Make sure we start with a clean mail queue.
        $MailQueueClean->();

        # use test email backend
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SendmailModule',
            Value => 'Kernel::System::Email::Test',
        );

        $Helper->ConfigSettingChange(
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

        # create test customer user
        my $TestCustomerUser = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to customer login screen
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?");
        $Selenium->delete_all_cookies();

        # click on 'Forgot password?'
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?");
        $Selenium->find_element( "#ForgotPassword", 'css' )->VerifiedClick();

        # request new password
        $Selenium->find_element( "#ResetUser",                   'css' )->send_keys($TestCustomerUser);
        $Selenium->find_element( "#Reset button[type='submit']", 'css' )->VerifiedClick();

        # check for password recovery message
        $Self->True(
            $Selenium->find_element( ".SuccessBox span", 'css' ),
            "Password recovery message found on screen for valid customer",
        );

        # Process mail queue items
        $MailQueueProcess->();

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

        # check for password recovery message for invalid customer user, for security measures it
        # should be visible
        $Self->True(
            $Selenium->find_element( ".SuccessBox span", 'css' ),
            "Password recovery message found on screen for invalid customer",
        );

        # Process mail queue items
        $MailQueueProcess->();

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
