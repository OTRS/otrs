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

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

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

        # check breadcrumb on Add screen
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText ( 'Mail Account Management', 'Add Mail Account' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # add real test mail account
        my $RandomID = "EmailAccount" . $Helper->GetRandomID();
        $Selenium->InputFieldValueSet(
            Element => '#TypeAdd',
            Value   => 'IMAP',
        );
        $Selenium->find_element( "#LoginAdd",    'css' )->send_keys($RandomID);
        $Selenium->find_element( "#PasswordAdd", 'css' )->send_keys("SomePassword");
        $Selenium->find_element( "#HostAdd",     'css' )->send_keys("pop3.example.com");
        $Selenium->InputFieldValueSet(
            Element => '#Trusted',
            Value   => 0,
        );
        $Selenium->InputFieldValueSet(
            Element => '#DispatchingBy',
            Value   => 'Queue',
        );

        $Selenium->find_element( "#Comment", 'css' )->send_keys("Selenium test AdminMailAccount");
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        # check if test mail account is present
        my $TestMailHost = "pop3.example.com / $RandomID";
        $Self->True(
            index( $Selenium->get_page_source(), $TestMailHost ) > -1,
            "$TestMailHost found on page",
        );

        # edit test mail account and set it to invalid
        $Selenium->find_element( $TestMailHost, 'link_text' )->VerifiedClick();

        # check breadcrumb on Edit screen
        $Count = 1;
        for my $BreadcrumbText (
            'Mail Account Management',
            'Edit Mail Account for host "pop3.example.com" and user account "' . $RandomID . '"'
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

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

        # Save current screen.
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Discard the instance of cache object, because of in-memory cache.
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::Cache'],
        );

        # Verify that the password is not changed even though it was not sent to the user.
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
        $Selenium->find_element( "#Submit",       'css' )->VerifiedClick();

        # Discard the instance of cache object, because of in-memory cache.
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::Cache'],
        );

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
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => '2',
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

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

        # test showing IMAP Folder and Queue fields
        $Selenium->find_element( $TestMailHostEdit, 'link_text' )->VerifiedClick();

        my @Tests = (
            {
                Name     => 'Selected option IMAP - IMAP Folder is shown',
                FieldID  => 'Type',
                ForAttr  => 'IMAPFolder',
                Selected => 'IMAP',
                Display  => 'block',
            },
            {
                Name     => 'Selected option IMAPS - IMAP Folder is shown',
                FieldID  => 'Type',
                ForAttr  => 'IMAPFolder',
                Selected => 'IMAPS',
                Display  => 'block',
            },
            {
                Name     => 'Selected option POP3 - IMAP Folder is not shown',
                FieldID  => 'Type',
                ForAttr  => 'IMAPFolder',
                Selected => 'POP3',
                Display  => 'none',
            },
            {
                Name     => 'Selected option POP3S - IMAP Folder is not shown',
                FieldID  => 'Type',
                ForAttr  => 'IMAPFolder',
                Selected => 'POP3S',
                Display  => 'none',
            },
            {
                Name     => 'Selected option POP3TLS - IMAP Folder is not shown',
                FieldID  => 'Type',
                ForAttr  => 'IMAPFolder',
                Selected => 'POP3TLS',
                Display  => 'none',
            },
            {
                Name     => "Selected 'Dispatching by email To: field.' - field Queue is not shown",
                FieldID  => 'DispatchingBy',
                ForAttr  => 'QueueID',
                Selected => 'From',
                Display  => 'none',
            },
            {
                Name     => "Selected 'Dispatching by selected Queue.' - field Queue is shown",
                FieldID  => 'DispatchingBy',
                ForAttr  => 'QueueID',
                Selected => 'Queue',
                Display  => 'block',
            }
        );

        for my $Test (@Tests) {
            my $FieldID = $Test->{FieldID};
            my $ForAttr = $Test->{ForAttr};

            $Selenium->InputFieldValueSet(
                Element => "#$FieldID",
                Value   => $Test->{Selected},
            );
            $Selenium->InputFieldValueSet(
                Element => "#$FieldID",
                Value   => $Test->{Selected},
            );

            $Self->Is(
                $Selenium->execute_script("return \$('label[for=$ForAttr]').parent().css('display');"),
                $Test->{Display},
                $Test->{Name},
            );
        }

        # navigate to AdminMailAccount
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminMailAccount");

        # test mail account delete button
        $Selenium->find_element("//a[contains(\@data-query-string, \'Subaction=Delete;ID=$MailAccountID' )]")->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;' );

        # verify delete dialog message
        my $DeleteMessage = 'Do you really want to delete this mail account?';
        $Self->True(
            index( $Selenium->get_page_source(), $DeleteMessage ) > -1,
            "Delete message is found",
        );

        # confirm delete action
        $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

        # check if mail account is deleted
        $Self->True(
            index( $Selenium->get_page_source(), $TestMailHost ) == -1,
            "$TestMailHost is not found on page after deleting",
        );

    }

);

1;
