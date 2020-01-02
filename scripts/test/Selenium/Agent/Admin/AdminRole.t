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

use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => ['admin'],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminRole screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminRole");

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Check roles overview screen,
        # if there are roles, check is there table on screen
        # otherwise check is there a message that no roles are defined.
        my %RoleList = $Kernel::OM->Get('Kernel::System::Group')->RoleList();
        if (%RoleList) {
            $Selenium->find_element( "table",             'css' );
            $Selenium->find_element( "table thead tr th", 'css' );
            $Selenium->find_element( "table tbody tr td", 'css' );
        }
        else {
            $Self->True(
                index(
                    $Selenium->get_page_source(),
                    $LanguageObject->Translate(
                        "There are no roles defined. Please use the 'Add' button to create a new role."
                    )
                ) > -1,
                "There are no roles defined.",
            );
        }

        # Click 'add new role' link.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminRole;Subaction=Add' )]")->VerifiedClick();

        # Check add page.
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#Comment", 'css' );
        $Selenium->find_element( "#ValidID", 'css' );

        # Define translated strings.
        my $RoleManagement = $LanguageObject->Translate('Role Management');

        # Check breadcrumb on Add screen.
        my $Count = 1;
        for my $BreadcrumbText (
            $RoleManagement,
            $LanguageObject->Translate('Add Role')
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check client side validation.
        $Selenium->find_element( "#Name", 'css' )->clear();
        $Selenium->find_element("//button[\@type='submit']")->click();
        $Selenium->WaitFor(
            JavaScript => "return \$('#Name.Error').length"
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Create a real test role.
        my $RandomID = 'TestRole' . $Helper->GetRandomID();
        $Selenium->find_element( "#Name", 'css' )->send_keys($RandomID);
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 1,
        );
        $Selenium->find_element( "#Comment", 'css' )->send_keys('Selenium test role');
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check is there notification 'Role added!' after role is added.
        my $Notification = $LanguageObject->Translate('Role added!');
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Go to new role again.
        $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

        # Check new role values.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium test role',
            "#Comment stored value",
        );

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText (
            $RoleManagement,
            $LanguageObject->Translate('Edit Role') . ': ' . $RandomID
            )
        {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Set test role to invalid.
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # Check overview page.
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            "$RandomID found on page",
        );

        # Check is there notification 'Role updated!' after role is updated.
        $Notification = $LanguageObject->Translate('Role updated!');
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Check class of invalid Role in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($RandomID)').length"
            ),
            "There is a class 'Invalid' for test Role",
        );

        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Go to new role again.
        $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

        # Check new role values.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            2,
            "#ValidID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            '',
            "#Comment updated value",
        );

        # Since there are no tickets that rely on our test roles, we can remove them again
        # from the DB.
        if ($RandomID) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            $RandomID = $DBObject->Quote($RandomID);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM roles WHERE name = ?",
                Bind => [ \$RandomID ],
            );
            $Self->True(
                $Success,
                "RoleDelete - $RandomID",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Group',
        );

    }

);

1;
