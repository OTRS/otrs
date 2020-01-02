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

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminMailAccount
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminMailAccount");

        # check AdminMailAccount screen
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check "Add mail account" link
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminMailAccount;Subaction=AddNew' )]")->VerifiedClick();

        for my $ID (
            qw(TypeAdd LoginAdd PasswordAdd HostAdd IMAPFolder Trusted DispatchingBy ValidID Comment)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # add real test mail account
        my $RandomID = "EmailAccount" . $Helper->GetRandomID();
        $Selenium->execute_script("\$('#TypeAdd').val('IMAP').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#LoginAdd",    'css' )->send_keys($RandomID);
        $Selenium->find_element( "#PasswordAdd", 'css' )->send_keys("SomePassword");
        $Selenium->find_element( "#HostAdd",     'css' )->send_keys("pop3.example.com");
        $Selenium->execute_script("\$('#Trusted').val('0').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#DispatchingBy').val('Queue').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Comment", 'css' )->send_keys("Selenium test AdminMailAccount");
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # check if test mail account is present
        my $TestMailHost = "pop3.example.com / $RandomID";
        $Self->True(
            index( $Selenium->get_page_source(), $TestMailHost ) > -1,
            "$TestMailHost found on page",
        );

        # edit test mail account and set it to invalid
        $Selenium->find_element( $TestMailHost, 'link_text' )->VerifiedClick();

        my %Check = (
            Type          => 'IMAP',
            LoginEdit     => $RandomID,
            PasswordEdit  => 'otrs-dummy-password-placeholder',    # real password is not sent to user
            HostEdit      => 'pop3.example.com',
            Trusted       => 0,
            DispatchingBy => 'Queue',
            Comment       => "Selenium test AdminMailAccount",
        );

        for my $CheckKey ( sort keys %Check ) {

            $Self->Is(
                $Selenium->find_element( "#$CheckKey", 'css' )->get_value(),
                $Check{$CheckKey},
                "Value '$CheckKey' of created email account",
            );
        }

        my $MailAccountID = $Selenium->find_element( 'input[name=ID]', 'css' )->get_value();
        my %MailAccount   = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountGet( ID => $MailAccountID );
        $Self->Is(
            scalar $MailAccount{Password},
            'SomePassword',
            'Password after adding',    # make sure real password was stored
        );

        # Save current screen and verify that the password is not changed even though it was not sent to the user.
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminMailAccount;Subaction=Update;ID=$MailAccountID");
        %MailAccount = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountGet( ID => $MailAccountID );
        $Self->Is(
            scalar $MailAccount{Password},
            'SomePassword',
            'Password after edit without change'
        );

        # Update password and verify that it is changed in DB.
        $Selenium->find_element( "#PasswordEdit", 'css' )->clear();
        $Selenium->find_element( "#PasswordEdit", 'css' )->send_keys("SomePassword2");
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        %MailAccount = $Kernel::OM->Get('Kernel::System::MailAccount')->MailAccountGet( ID => $MailAccountID );
        $Self->Is(
            scalar $MailAccount{Password},
            'SomePassword2',
            'Password after change'
        );

        # disable account
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminMailAccount;Subaction=Update;ID=$MailAccountID");
        $Selenium->find_element( "#HostEdit", 'css' )->clear();
        $Selenium->find_element( "#HostEdit", 'css' )->send_keys("pop3edit.example.com");
        $Selenium->execute_script("\$('#ValidID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # check class of invalid EmailAccount in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($RandomID)').length"
            ),
            "There is a class 'Invalid' for test EmailAccount",
        );

        # check for edited mail account
        my $TestMailHostEdit = "pop3edit.example.com / $RandomID";
        $Self->True(
            index( $Selenium->get_page_source(), $TestMailHostEdit ) > -1,
            "$TestMailHostEdit found on page",
        );

        # test mail account delete button
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success  = $DBObject->Prepare(
            SQL => "SELECT id FROM mail_account WHERE login='$RandomID'",
        );

        if ($Success) {
            my $MailAccountID;
            while ( my @Row = $DBObject->FetchrowArray() ) {
                $MailAccountID = $Row[0];
            }
            $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;ID=$MailAccountID' )]")->VerifiedClick();
        }

    }

);

1;
