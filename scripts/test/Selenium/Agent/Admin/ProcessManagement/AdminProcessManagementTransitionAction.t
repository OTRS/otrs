# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ProcessRandom          = 'Process' . $Helper->GetRandomID();
        my $TransitionActionRandom = 'TransitionAction' . $Helper->GetRandomID();

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Create new test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessNew' )]")->VerifiedClick();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

        $Selenium->find_element( "#Name",        'css' )->send_keys($ProcessRandom);
        $Selenium->find_element( "#Description", 'css' )->send_keys("Selenium Test Process");
        $Selenium->find_element( "#Submit",      'css' )->VerifiedClick();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Canvas").length' );

        # Click on Transition Actions dropdown.
        $Selenium->find_element( "Transition Actions", 'link_text' )->click();
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("a[href*=\'Subaction=TransitionActionNew\']:visible").length'
        );

        # Click "Create New Transition Action".
        $Selenium->execute_script("\$('a[href*=\"Subaction=TransitionActionNew\"]').click()");

        # Switch to pop up window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#Name").length && $("#Submit").length'
        );

        # Check AdminProcessManagementTransitionAction screen.
        for my $ID (
            qw(Name Module ConfigKey[1] ConfigValue[1] ConfigAdd Submit)
            )
        {
            my $Element = $Selenium->find_element(".//*[\@id='$ID']");
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Input fields and submit.
        my $TransitionActionModule = "Kernel::System::ProcessManagement::TransitionAction::TicketArticleCreate";
        my $TransitionActionKey    = "Key" . $Helper->GetRandomID();
        my $TransitionActionValue  = "Value" . $Helper->GetRandomID();

        $Selenium->find_element( "#Name", 'css' )->send_keys($TransitionActionRandom);
        $Selenium->execute_script(
            "\$('#Module').val('$TransitionActionModule').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->send_keys($TransitionActionKey);
        $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->send_keys($TransitionActionValue);
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Switch back to main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Check for created test TransitionAction using filter on AdminProcessManagement screen.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('ul#TransitionActions li:contains($TransitionActionRandom)').length"
        );
        $Selenium->find_element( "Transition Actions", 'link_text' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#TransitionActionFilter:visible").length'
        );
        $Selenium->find_element( "#TransitionActionFilter", 'css' )->clear();
        $Selenium->find_element( "#TransitionActionFilter", 'css' )->send_keys($TransitionActionRandom);

        # Wait for filter to kick in.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".OneRow[data-entity*=\'TransitionAction\']:visible").length === 1 && $.active == 0'
        );

        $Self->True(
            $Selenium->find_element("//*[text()=\"$TransitionActionRandom\"]")->is_displayed(),
            "$TransitionActionRandom transition action found on page",
        );

        # Get test TransitionActionID.
        my $DBObject               = $Kernel::OM->Get('Kernel::System::DB');
        my $TransitionActionQuoted = $DBObject->Quote($TransitionActionRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM pm_transition_action WHERE name = ?",
            Bind => [ \$TransitionActionQuoted ]
        );
        my $TransitionActionID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TransitionActionID = $Row[0];
        }

        # Go to edit test TransitionAction screen.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=TransitionActionEdit;ID=$TransitionActionID' )]")
            ->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

        # Check stored value.
        $Self->Is(
            $Selenium->find_element( "#Name", 'css' )->get_value(),
            $TransitionActionRandom,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( "#Module option[value='$TransitionActionModule']", 'css' )->get_value(),
            $TransitionActionModule,
            "#Module stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->get_value(),
            $TransitionActionKey,
            "ConfigKey stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->get_value(),
            $TransitionActionValue,
            "ConfigValue stored value",
        );

        # Try to remove only possible Config Parameters.
        $Selenium->find_element( ".RemoveButton", 'css' )->click();

        $Selenium->WaitFor( AlertPresent => 1 );

        $Self->True(
            $Selenium->accept_alert(),
            "Unable to remove only field - JS is success"
        );

        # Add new Config key and value.
        $Selenium->find_element( "#ConfigAdd", 'css' )->click();

        # Verify newly added fields.
        $Self->True(
            $Selenium->find_element(".//*[\@id='ConfigKey[2]']"),
            "New Config key field is added - JS is success"
        );
        $Self->True(
            $Selenium->find_element(".//*[\@id='ConfigValue[2]']"),
            "New Config value field is added - JS is success"
        );

        $Selenium->execute_script("\$('.RemoveButton:eq(1)').click()");
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.RemoveButton:visible').length === 1"
        );

        # Verify new Config key and value fields is removed.
        $Self->True(
            $Selenium->execute_script('return $(".RemoveButton:visible").length === 1'),
            "New Config key and value fields are removed - JS is success"
        );

        # Edit test TransactionAction values.
        my $TransitionActionKeyEdit   = $TransitionActionKey . "edit";
        my $TransitionActionValueEdit = $TransitionActionValue . "edit";
        $Selenium->find_element( "#Name", 'css' )->send_keys("edit");
        $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->clear();
        $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->send_keys($TransitionActionKeyEdit);
        $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->clear();
        $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->send_keys($TransitionActionValueEdit);
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Return to main window after the popup closed, as the popup sends commands to the main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#TransitionActionFilter').length" );

        # Check for edited test TransitionAction using filter on AdminProcessManagement screen
        my $TransitionActionRandomEdit = $TransitionActionRandom . "edit";
        $Selenium->find_element( "Transition Actions", 'link_text' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#TransitionActionFilter:visible").length'
        );
        $Selenium->find_element( "#TransitionActionFilter", 'css' )->clear();
        $Selenium->find_element( "#TransitionActionFilter", 'css' )->send_keys($TransitionActionRandomEdit);

        # Wait for filter to kick in.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".OneRow[data-entity*=\'TransitionAction\']:visible").length === 1 && $.active == 0'
        );

        $Self->True(
            $Selenium->find_element("//*[text()=\"$TransitionActionRandomEdit\"]")->is_displayed(),
            "Edited $TransitionActionRandomEdit transition action dialog found on page",
        );

        # Go to edit test TransitionAction screen again.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=TransitionActionEdit;ID=$TransitionActionID' )]")
            ->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

        # Check edited values.
        $Self->Is(
            $Selenium->find_element( "#Name", 'css' )->get_value(),
            $TransitionActionRandomEdit,
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->get_value(),
            $TransitionActionKeyEdit,
            "ConfigKey updated value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->get_value(),
            $TransitionActionValueEdit,
            "ConfigValue updated value",
        );

        # Return to main window.
        $Selenium->close();
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Get process id and return to overview afterwards.
        my $ProcessID = $Selenium->execute_script('return $("#ProcessDelete").data("id")') || undef;

        # Delete test transition action.
        my $Success
            = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction')->TransitionActionDelete(
            ID     => $TransitionActionID,
            UserID => $TestUserID,
            );

        $Self->True(
            $Success,
            "Transition action is deleted - $TransitionActionID",
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

        # Navigate to AdminProcessmanagement screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Synchronize process after deleting test process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (
            qw( ProcessManagement_Process ProcessManagement_TransitionAction )
            )
        {
            $CacheObject->CleanUp( Type => $Cache );
        }

    }
);

1;
