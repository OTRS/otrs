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

        # Navigate to AdminQueue screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminQueue");

        # Check overview AdminQueue.
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check breadcrumb on Overview screen.
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # Click 'add new queue' link.
        $Selenium->find_element( "a.Create", 'css' )->VerifiedClick();

        # Check add page.
        for my $ID (
            qw(Name GroupID FollowUpID FollowUpLock SalutationID SystemAddressID SignatureID ValidID)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check breadcrumb on Add screen.
        my $Count = 1;
        for my $BreadcrumbText ( 'Queue Management', 'Add Queue' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Check client side validation.
        my $Element = $Selenium->find_element( "#Name", 'css' );
        $Element->send_keys("");

        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Name.Error").length'
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Navigate to AdminQueue screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminQueue");

        # Create test queue.
        $Selenium->find_element( "a.Create", 'css' )->VerifiedClick();

        # Create a real test queue.
        my $RandomID = "Queue" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name", 'css' )->send_keys($RandomID);
        $Selenium->InputFieldValueSet(
            Element => '#GroupID',
            Value   => 1,
        );
        $Selenium->InputFieldValueSet(
            Element => '#FollowUpID',
            Value   => 1,
        );
        $Selenium->InputFieldValueSet(
            Element => '#SalutationID',
            Value   => 1,
        );
        $Selenium->InputFieldValueSet(
            Element => '#SystemAddressID',
            Value   => 1,
        );
        $Selenium->InputFieldValueSet(
            Element => '#SignatureID',
            Value   => 1,
        );
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 1,
        );
        $Selenium->find_element( "#Comment", 'css' )->send_keys('Selenium test queue');
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        # Navigate to AdminQueue screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminQueue");

        # Check Queue - Responses page.
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            'New queue found on table'
        );
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Go to new queue again.
        $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

        # Check new queue values.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#GroupID', 'css' )->get_value(),
            1,
            "#GroupID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#FollowUpID', 'css' )->get_value(),
            1,
            "#FollowUpID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#FollowUpLock', 'css' )->get_value(),
            0,
            "#FollowUpLock stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#SalutationID', 'css' )->get_value(),
            1,
            "#SalutationID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#SystemAddressID', 'css' )->get_value(),
            1,
            "#SystemAddressID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#SignatureID', 'css' )->get_value(),
            1,
            "#SignatureID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#ValidID', 'css' )->get_value(),
            1,
            "#ValidID stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#Comment', 'css' )->get_value(),
            'Selenium test queue',
            "#Comment stored value",
        );

        # Check breadcrumb on Edit screen.
        $Count = 1;
        for my $BreadcrumbText ( 'Queue Management', 'Edit Queue: ' . $RandomID ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # Set test queue to invalid.
        $Selenium->InputFieldValueSet(
            Element => '#GroupID',
            Value   => 2,
        );
        $Selenium->InputFieldValueSet(
            Element => '#FollowUpLock',
            Value   => 1,
        );
        $Selenium->InputFieldValueSet(
            Element => '#ValidID',
            Value   => 2,
        );
        $Selenium->find_element( "#Comment", 'css' )->clear();
        $Selenium->find_element( "#Submit",  'css' )->VerifiedClick();

        # Check is there notification after queue is updated.
        my $Notification = 'Queue updated!';
        $Self->True(
            $Selenium->execute_script("return \$('.MessageBox.Notice p:contains($Notification)').length"),
            "$Notification - notification is found."
        );

        # Navigate to AdminQueue screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminQueue");

        # Check overview page.
        $Self->True(
            index( $Selenium->get_page_source(), $RandomID ) > -1,
            'New queue found on table'
        );

        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # Check class of invalid Queue in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td a:contains($RandomID)').length"
            ),
            "There is a class 'Invalid' for test Queue",
        );

        # Go to new state again.
        $Selenium->find_element( $RandomID, 'link_text' )->VerifiedClick();

        # Check new queue values.
        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $RandomID,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#GroupID', 'css' )->get_value(),
            2,
            "#GroupID updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#FollowUpLock', 'css' )->get_value(),
            1,
            "#FollowUpLock updated value",
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

        # Since there are no tickets that rely on our test queue, we can remove them again
        # from the DB.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $QueueID  = $Kernel::OM->Get('Kernel::System::Queue')->QueueLookup(
            Queue => $RandomID,
        );
        my $Success = $DBObject->Do(
            SQL => "DELETE FROM queue_preferences WHERE queue_id = $QueueID",
        );
        $Self->True(
            $Success,
            "QueueDelete preferences - $RandomID",
        );
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "QueueDelete - $RandomID",
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Queue',
        );

    }
);

1;
