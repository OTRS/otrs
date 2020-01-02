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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminPriority screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminPriority");

        # Check overview AdminPriority.
        $Self->True(
            $Selenium->execute_script("return \$('tr td a:contains(\"3 normal\")').length === 1"),
            '3 normal found on page',
        );

        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click 'add new priority' link.
        $Selenium->find_element("//a[contains(\@href, \'Action=AdminPriority;Subaction=Add' )]")->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Name").length && $("#ValidID").length'
        );

        # Check add page.
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Selenium->find_element( "#ValidID", 'css' );

        # check breadcrumb on Add screen
        my $Count = 1;
        for my $BreadcrumbText ( 'Priority Management', 'Add Priority' ) {
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

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name.Error").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Create a real test priority.
        my $RandomID = "Priority" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name", 'css' )->send_keys($RandomID);
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 1,
        );
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        $Self->True(
            $Selenium->execute_script("return \$('tr td a:contains($RandomID)').length === 1"),
            "$RandomID found on page",
        );

        # Go to new priority again.
        $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Name").length && $("#ValidID").length'
        );

        # Check new priority values.
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

        # check breadcrumb on Edit screen
        $Count = 1;
        for my $BreadcrumbText ( 'Priority Management', 'Edit Priority: ' . $RandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Set test priority to invalid.
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('tr.Invalid td a:contains($RandomID)').length"
        );

        # Check class of invalid Priority in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($RandomID)').length === 1"
            ),
            "There is a class 'Invalid' for test Priority",
        );

        # Go to new priority again.
        $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Name").length && $("#ValidID").length'
        );

        # Check new priority values.
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

        # Since there are no tickets that rely on our test priority, we can remove them again from the DB.
        if ($RandomID) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            $RandomID = $DBObject->Quote($RandomID);
            my $Success = $DBObject->Do(
                SQL  => "DELETE FROM ticket_priority WHERE name = ?",
                Bind => [ \$RandomID ],
            );
            $Self->True(
                $Success,
                "PriorityDelete - $RandomID",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Priority',
        );

    }
);

1;
