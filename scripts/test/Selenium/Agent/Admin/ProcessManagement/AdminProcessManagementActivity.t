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

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $ProcessRandom  = 'Process' . $Helper->GetRandomID();
        my $ActivityRandom = 'Activity' . $Helper->GetRandomID();

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Create new test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessNew' )]")->VerifiedClick();
        $Selenium->find_element( "#Name",        'css' )->send_keys($ProcessRandom);
        $Selenium->find_element( "#Description", 'css' )->send_keys("Selenium Test Process");
        $Selenium->find_element( "#Submit",      'css' )->VerifiedClick();

        # Create new test Activity.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityNew' )]")->click();

        # Switch to pop up window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Check AdminProcessManagementActivity screen.
        for my $ID (
            qw(Name FilterAvailableActivityDialogs AvailableActivityDialogs AssignedActivityDialogs)
            )
        {
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length" );
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        $Selenium->find_element( "#Name",   'css' )->clear();
        $Selenium->find_element( "#Submit", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return $("#Name.Error").length' );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Input name field and submit.
        $Selenium->find_element( "#Name",   'css' )->send_keys($ActivityRandom);
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Switch back to main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Check for created test activity using filter on AdminProcessManagement screen.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('ul#Activities li:contains($ActivityRandom)').length"
        );
        $Selenium->find_element( "#ActivityFilter", 'css' )->send_keys($ActivityRandom);
        $Selenium->WaitFor( JavaScript => 'return $("#Activities li:visible").length === 1 && $.active == 0' );

        $Self->True(
            $Selenium->find_element("//*[text()=\"$ActivityRandom\"]")->is_displayed(),
            "$ActivityRandom activity found on page",
        );

        # Get test ActivityID.
        my $DBObject       = $Kernel::OM->Get('Kernel::System::DB');
        my $ActivityQuoted = $DBObject->Quote($ActivityRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM pm_activity WHERE name = ?",
            Bind => [ \$ActivityQuoted ]
        );
        my $ActivityID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ActivityID = $Row[0];
        }

        # Check for stored value and edit test Activity.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityEdit;ID=$ActivityID' )]")->click();
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name').length" );

        $Self->Is(
            $Selenium->find_element( '#Name', 'css' )->get_value(),
            $ActivityRandom,
            "#Name stored value",
        );

        $Selenium->find_element( "#Name",   'css' )->send_keys("edit");
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Return to main window after the popup is closed, as the popup sends commands to the main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Get process id.
        my $ProcessID = $Selenium->execute_script('return $("#ProcessDelete").data("id")') || undef;

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Set process to inactive.
        $Selenium->find_element( $ProcessRandom, 'link_text' )->VerifiedClick();
        $Selenium->InputFieldValueSet(
            Element => '#StateEntityID',
            Value   => 'S2',
        );
        $Selenium->execute_script("\$('#Submit').click()");

        # Test search filter.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Filter").length' );
        $Selenium->find_element( "#Filter", 'css' )->clear();
        $Selenium->find_element( "#Filter", 'css' )->send_keys($ProcessRandom);

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Processes tbody tr:visible").length === 1'
        );

        # Check class of invalid Process in the overview table.
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td:contains($ProcessRandom)').length"
            ),
            "There is a class 'Invalid' for test Process",
        );

        # Delete test activity.
        my $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity')->ActivityDelete(
            ID     => $ActivityID,
            UserID => $TestUserID,
        );
        $Self->True(
            $Success,
            "Activity is deleted - $ActivityID",
        );

        # Delete test process.
        $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process')->ProcessDelete(
            ID     => $ProcessID,
            UserID => $TestUserID,
        );
        $Self->True(
            $Success,
            "Process is deleted - $ProcessID",
        );

        # Synchronize process after deleting test process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(ProcessManagement_Activity ProcessManagement_Process)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
