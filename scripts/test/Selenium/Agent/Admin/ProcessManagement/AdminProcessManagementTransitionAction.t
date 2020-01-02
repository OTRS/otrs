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

        my $RandomID               = $Helper->GetRandomID();
        my $ProcessRandom          = 'Process' . $RandomID;
        my $TransitionActionRandom = 'TransitionAction' . $RandomID;

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

        # Click on Transition Actions accordion element.
        $Selenium->execute_script('$("#ProcessElements .AccordionElement:eq(3) a.AsBlock").click();');
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
        my $TransitionActionKey    = "Key" . $RandomID;
        my $TransitionActionValue  = "Value" . $RandomID;

        $Selenium->find_element( "#Name", 'css' )->send_keys($TransitionActionRandom);
        $Selenium->InputFieldValueSet(
            Element => '#Module',
            Value   => $TransitionActionModule,
        );
        $Selenium->find_element(".//*[\@id='ConfigKey[1]']")->send_keys($TransitionActionKey);
        $Selenium->find_element(".//*[\@id='ConfigValue[1]']")->send_keys($TransitionActionValue);
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Switch back to main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Get test ProcesID.
        my $DBObject            = $Kernel::OM->Get('Kernel::System::DB');
        my $ProcessRandomQuoted = $DBObject->Quote($ProcessRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id, entity_id FROM pm_process WHERE name = ?",
            Bind => [ \$ProcessRandomQuoted ]
        );
        my $ProcessID;
        my $ProcesEntityID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $ProcessID      = $Row[0];
            $ProcesEntityID = $Row[1];
        }

        # Navigate to AdminProcessManagement to edit test process.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminProcessManagement;Subaction=ProcessEdit;ID=$ProcessID;EntityID=$ProcesEntityID"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Canvas").length' );
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#TransitionActionFilter').length" );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#ProcessElements .AccordionElement:eq(3) a.AsBlock',
        );

        # Click on Transition Actions accordion element.
        $Selenium->find_element(" //a[contains(.,\'Transition Actions\')]")->click();

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#TransitionActionFilter:visible").length'
        );
        $Selenium->find_element( "#TransitionActionFilter", 'css' )->clear();
        $Selenium->find_element( "#TransitionActionFilter", 'css' )->send_keys($TransitionActionRandom);

        # Wait for filter to kick in.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".OneRow[data-entity*=\'TransitionAction\']:visible").length === 1 && $.active == 0;',
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return  \$('#TransitionActions li:visible div').length === 1;",
        );

        $Self->True(
            $Selenium->find_element("//*[text()=\"$TransitionActionRandom\"]")->is_displayed(),
            "$TransitionActionRandom transition action found on page",
        );

        $Self->Is(
            $Selenium->execute_script("return  \$('#TransitionActions li:visible div').text();"),
            $TransitionActionRandom,
            "$TransitionActionRandom transition action dialog found on page",
        );

        # Get test TransitionActionID.
        my $TransitionActionQuoted = $DBObject->Quote($TransitionActionRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id, entity_id FROM pm_transition_action WHERE name = ?",
            Bind => [ \$TransitionActionQuoted ]
        );
        my $TransitionActionID;
        my $TransitionActionEntityID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TransitionActionID       = $Row[0];
            $TransitionActionEntityID = $Row[1];
        }

        # Go to edit test TransitionAction screen.
        $Selenium->execute_script(
            "\$('a[href*=\"Subaction=TransitionActionEdit;ID=$TransitionActionID;EntityID=$TransitionActionEntityID\"]').click()"
        );

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

        $Selenium->execute_script("\$('.RemoveButton:eq(1)').click();");
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.RemoveButton:visible').length === 1"
        );

        # Verify new Config key and value fields is removed.
        $Self->True(
            $Selenium->execute_script('return $(".RemoveButton:visible").length === 1;'),
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

        # Navigate to AdminProcessManagement to edit test process.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminProcessManagement;Subaction=ProcessEdit;ID=$ProcessID;EntityID=$ProcesEntityID"
        );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Canvas").length' );
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#TransitionActionFilter').length" );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#ProcessElements .AccordionElement:eq(3) a.AsBlock',
        );

        # Click on Transition Actions accordion element.
        $Selenium->find_element(" //a[contains(.,\'Transition Actions\')]")->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#TransitionActionFilter:visible").length'
        );
        sleep 1;

        # Check for edited test TransitionAction using filter on AdminProcessManagement screen
        my $TransitionActionRandomEdit = $TransitionActionRandom . "edit";
        $Selenium->find_element( "#TransitionActionFilter", 'css' )->clear();
        $Selenium->find_element( "#TransitionActionFilter", 'css' )->send_keys($TransitionActionRandomEdit);

        # Wait for filter to kick in.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".OneRow[data-entity*=\'TransitionAction\']:visible").length === 1 && $.active == 0;',
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return  \$('#TransitionActions li:visible div').length === 1;",
        );

        $Self->Is(
            $Selenium->execute_script("return  \$('#TransitionActions li:visible div').text();"),
            $TransitionActionRandomEdit,
            "Edited $TransitionActionRandomEdit transition action dialog found on page",
        );

        # Go to edit test TransitionAction screen.
        $Selenium->execute_script(
            "\$('a[href*=\"Subaction=TransitionActionEdit;ID=$TransitionActionID;EntityID=$TransitionActionEntityID\"]').click()"
        );

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
