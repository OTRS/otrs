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

        my $ProcessRandom        = 'Process' . $Helper->GetRandomID();
        my $ActivityDialogRandom = 'ActivityDialog' . $Helper->GetRandomID();
        my $DescriptionShort     = "Selenium ActivityDialog Test";

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Create new test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessNew' )]")->VerifiedClick();
        $Selenium->find_element( "#Name",        'css' )->send_keys($ProcessRandom);
        $Selenium->find_element( "#Description", 'css' )->send_keys("Selenium Test Process");
        $Selenium->find_element( "#Submit",      'css' )->VerifiedClick();

        # Click on ActivityDialog dropdown.
        $Selenium->find_element( "Activity Dialogs", 'link_text' )->click();

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a.AsBlock:contains(\"Activity Dialogs\")').closest('.AccordionElement').hasClass('Active') === true"
        );

        # Click "Create New Activity Dialog".
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityDialogNew' )]")->click();

        # Switch to pop up window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Check AdminProcessManagementActivityDialog screen.
        for my $ID (
            qw(Name Interface DescriptionShort DescriptionLong Permission RequiredLock SubmitAdviceText
            SubmitButtonText FilterAvailableFields AvailableFields AssignedFields Submit)
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

        # Check server side validation and verify JS is still working correct after server error. See bug#14588.
        $Selenium->execute_script("\$('#DescriptionShort').removeClass('Validate_Required');");
        $Selenium->find_element( "#Name",   'css' )->send_keys($ActivityDialogRandom);
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Wait for error dialog to appear.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
        );

        $Selenium->find_element( "#DialogButton1", 'css' )->click();

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;'
        );

        # Input fields and submit.
        $Selenium->find_element( "#DescriptionShort", 'css' )->send_keys($DescriptionShort);
        $Selenium->InputFieldValueSet(
            Element => '#Interface',
            Value   => 'BothInterfaces',
        );
        $Selenium->InputFieldValueSet(
            Element => '#Permission',
            Value   => 'rw',
        );
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Switch back to main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Check for created test activity dialog using filter on AdminProcessManagement screen.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('ul#ActivityDialogs li:contains($ActivityDialogRandom)').length"
        );
        $Selenium->find_element( "Activity Dialogs", 'link_text' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a.AsBlock:contains(\"Activity Dialogs\")').closest('.AccordionElement').hasClass('Active') === true"
        );

        $Selenium->find_element( "#ActivityDialogFilter", 'css' )->send_keys($ActivityDialogRandom);

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ActivityDialogs li:visible').length === 1"
        );

        $Self->True(
            $Selenium->find_element("//*[text()=\"$ActivityDialogRandom\"]")->is_displayed(),
            "$ActivityDialogRandom activity found on page",
        );

        # Get test ActivityDialogID.
        my $DBObject             = $Kernel::OM->Get('Kernel::System::DB');
        my $ActivityDialogQuoted = $DBObject->Quote($ActivityDialogRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM pm_activity_dialog WHERE name = ?",
            Bind => [ \$ActivityDialogQuoted ]
        );
        my $ActivityDialogID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ActivityDialogID = $Row[0];
        }

        # Go to edit test ActivityDialog screen.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityDialogEdit;ID=$ActivityDialogID' )]")
            ->click();
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name').length" );

        # Check stored value.
        $Self->Is(
            $Selenium->find_element( "#Name", 'css' )->get_value(),
            $ActivityDialogRandom,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( "#DescriptionShort", 'css' )->get_value(),
            $DescriptionShort,
            "#DescriptionShort stored value",
        );
        $Self->Is(
            $Selenium->find_element( "#Interface", 'css' )->get_value(),
            "BothInterfaces",
            "#Interface stored value",
        );
        $Self->Is(
            $Selenium->find_element( "#Permission", 'css' )->get_value(),
            "rw",
            "#Permission stored value",
        );

        # Edit test ActivityDialog values.
        $Selenium->find_element( "#Name",             'css' )->send_keys("edit");
        $Selenium->find_element( "#DescriptionShort", 'css' )->send_keys(" Edit");
        $Selenium->InputFieldValueSet(
            Element => '#Interface',
            Value   => 'AgentInterface',
        );
        $Selenium->InputFieldValueSet(
            Element => '#Permission',
            Value   => 'ro',
        );
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Return to main window after the popup closed, as the popup sends commands to the main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Check for edited test ActivityDialog using filter on AdminProcessManagement screen.
        my $ActivityDialogRandomEdit = $ActivityDialogRandom . "edit";
        my $DescriptionShortEdit     = $DescriptionShort . " Edit";

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('ul#ActivityDialogs li:contains($ActivityDialogRandomEdit)').length"
        );
        $Selenium->find_element( "Activity Dialogs", 'link_text' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a.AsBlock:contains(\"Activity Dialogs\")').closest('.AccordionElement').hasClass('Active') === true"
        );

        $Selenium->find_element( "#ActivityDialogFilter", 'css' )->clear();
        $Selenium->find_element( "#ActivityDialogFilter", 'css' )->send_keys($ActivityDialogRandomEdit);

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ActivityDialogs li:visible').length === 1"
        );

        $Self->True(
            $Selenium->find_element("//*[text()=\"$ActivityDialogRandomEdit\"]")->is_displayed(),
            "Edited $ActivityDialogRandomEdit activity dialog found on page",
        );

        # Go to edit test ActivityDialog screen again.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ActivityDialogEdit;ID=$ActivityDialogID' )]")
            ->click();
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#Name').length" );

        # Check edited values.
        $Self->Is(
            $Selenium->find_element( "#Name", 'css' )->get_value(),
            $ActivityDialogRandomEdit,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( "#DescriptionShort", 'css' )->get_value(),
            $DescriptionShortEdit,
            "#DescriptionShort updated value",
        );
        $Self->Is(
            $Selenium->find_element( "#Interface", 'css' )->get_value(),
            "AgentInterface",
            "#Interface updated value",
        );
        $Self->Is(
            $Selenium->find_element( "#Permission", 'css' )->get_value(),
            "ro",
            "#Permission updated value",
        );

        # Return to main window.
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '.ClosePopup',
        );
        $Selenium->find_element( ".ClosePopup", 'css' )->click();
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Verify ActivityDialog filter remains same after popup close, see bug#13824.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ActivityDialogs li:visible').length === 1 && \$.active == 0"
        );

        $Self->Is(
            $Selenium->find_element( "#ActivityDialogFilter", 'css' )->get_value(),
            $ActivityDialogRandomEdit,
            "ActivityDialog filter has correct value - $ActivityDialogRandomEdit",
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#ActivityDialogs li:visible').length"),
            1,
            "ActivityDialog filter filtered correctly after popup closing",
        );

        # Get process id and return to overview afterwards.
        my $ProcessID = $Selenium->execute_script('return $("#ProcessDelete").data("id")') || undef;

        # Delete test activity dialog.
        my $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog')->ActivityDialogDelete(
            ID     => $ActivityDialogID,
            UserID => $TestUserID,
        );

        $Self->True(
            $Success,
            "Activity dialog is deleted - $ActivityDialogID",
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

        # Navigate to AdminProcessManagement screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Synchronize process after deleting test process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(ProcessManagement_ActivityDialog ProcessManagement_Process)) {
            $CacheObject->CleanUp( Type => $Cache );
        }

    }

);

1;
