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
        my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
            Groups => ['admin'],
        );

        my $ProcessRandom    = 'Process' . $Helper->GetRandomID();
        my $TransitionRandom = 'Transition' . $Helper->GetRandomID();

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # create new test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessNew' )]")->VerifiedClick();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#Name").length' );

        $Selenium->find_element( "#Name",        'css' )->send_keys($ProcessRandom);
        $Selenium->find_element( "#Description", 'css' )->send_keys("Selenium Test Process");
        $Selenium->find_element( "#Submit",      'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("a.AsBlock:contains(Transitions)").length'
        );

        # Click on Transitions dropdown.
        $Selenium->find_element( "Transitions", 'link_text' )->click();

        # Wait to toggle element.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("a[href*=\'Subaction=TransitionNew\']:visible").length'
        );

        # Click on "Create New Transition".
        $Selenium->execute_script(
            "\$('a[href*=\"Subaction=TransitionNew\"]').trigger('click')"
        );

        # Switch to pop up window.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until form has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#TransitionForm #Name").length' );

        # Check AdminProcessManagementTransition screen.
        for my $ID (
            qw(Name OverallConditionLinking ConditionLinking[_INDEX_] ConditionFieldName[1][1]
            ConditionFieldType[_INDEX_][_FIELDINDEX_] ConditionFieldValue[1][1] ConditionAdd)
            )
        {
            my $Element = $Selenium->find_element(".//*[\@id='$ID']");
            $Element->is_enabled();
            $Element->is_displayed();
        }

        for my $Button (
            qw(RemoveButton ConditionFieldAdd RemoveButton)
            )
        {
            my $Element = $Selenium->find_element( ".$Button", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Check client side validation.
        $Selenium->find_element( "#TransitionForm #Name", 'css' )->clear();
        $Selenium->find_element( "#Submit",               'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#TransitionForm #Name.Error").length'
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#TransitionForm #Name').hasClass('Error')"
            ),
            '1',
            'Client side validation correctly detected missing input value',
        );

        # Input fields and submit.
        my $TransitionFieldName = "Field" . $Helper->GetRandomID();
        my $TransitionValueName = "Value" . $Helper->GetRandomID();
        $Selenium->find_element( "#TransitionForm #Name", 'css' )->send_keys($TransitionRandom);
        $Selenium->InputFieldValueSet(
            Element => '#OverallConditionLinking',
            Value   => 'or',
        );
        $Selenium->InputFieldValueSet(
            Element => '#ConditionLinking[_INDEX_]',
            Value   => 'or',
        );

        $Selenium->find_element(".//*[\@id='ConditionFieldName[1][1]']")->send_keys($TransitionFieldName);
        $Selenium->InputFieldValueSet(
            Element => '#ConditionLinking[_INDEX_]',
            Value   => 'String',
        );
        $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][1]']")->send_keys($TransitionValueName);

        # Try to remove Field, expecting JS error.
        $Selenium->find_element("//a[\@title='Remove this Field']")->click();
        $Selenium->WaitFor(
            AlertPresent => 1,
        );
        $Self->True(
            $Selenium->accept_alert(),
            "Unable to remove only field - JS is success"
        );
        sleep 1;

        # Add new Field.
        $Selenium->find_element("//a[\@title='Add a new Field']")->click();

        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#ConditionFieldName\\\\[1\\\\]\\\\[2\\\\]").length'
        );
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#ConditionFieldValue\\\\[1\\\\]\\\\[2\\\\]").length'
        );

        $Selenium->find_element(".//*[\@id='ConditionFieldName[1][2]']")->send_keys( $TransitionFieldName . '2' );
        $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][2]']")->send_keys( $TransitionValueName . '2' );

        # Add new Condition and input fields.
        $Selenium->find_element( "#ConditionAdd", 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#ConditionFieldName\\\\[2\\\\]\\\\[1\\\\]").length'
        );
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("#ConditionFieldValue\\\\[2\\\\]\\\\[1\\\\]").length'
        );

        $Selenium->find_element(".//*[\@id='ConditionFieldName[2][1]']")->send_keys( $TransitionFieldName . '22' );
        $Selenium->find_element(".//*[\@id='ConditionFieldValue[2][1]']")->send_keys( $TransitionValueName . '22' );

        # Submit form.
        $Selenium->find_element( "#Submit", 'css' )->click();

        # Switch back to main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Check for created test Transition using filter on AdminProcessManagement screen.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#Transitions li:contains($TransitionRandom)').length"
        );
        $Selenium->find_element( "Transitions", 'link_text' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#TransitionFilter:visible").length' );

        $Selenium->find_element( "#TransitionFilter", 'css' )->send_keys($TransitionRandom);

        # Wait for filter to kick in.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".OneRow[data-entity*=\'Transition\']:visible").length === 1 && $.active == 0'
        );

        $Self->True(
            $Selenium->find_element("//*[text()=\"$TransitionRandom\"]")->is_displayed(),
            "$TransitionRandom transition found on page",
        );

        # Get test TransitionID.
        my $DBObject         = $Kernel::OM->Get('Kernel::System::DB');
        my $TransitionQuoted = $DBObject->Quote($TransitionRandom);
        $DBObject->Prepare(
            SQL  => "SELECT id FROM pm_transition WHERE name = ?",
            Bind => [ \$TransitionQuoted ]
        );
        my $TransitionID;
        while ( my @Row = $DBObject->FetchrowArray() ) {
            $TransitionID = $Row[0];
        }

        # Go to edit test Transition screen.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=TransitionEdit;ID=$TransitionID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#TransitionForm #Name').length" );

        # Check stored value.
        $Self->Is(
            $Selenium->find_element( "#TransitionForm #Name", 'css' )->get_value(),
            $TransitionRandom,
            "#Name stored value",
        );
        $Self->Is(
            $Selenium->find_element( "#OverallConditionLinking option[value='or']", 'css' )->get_value(),
            "or",
            "#OverallConditionLinking stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionLinking[_INDEX_]']/option[2]")->get_value(),
            "or",
            "ConditionLinking stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionFieldName[1][$TransitionFieldName]']")->get_value(),
            $TransitionFieldName,
            "ConditionFieldName stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionFieldType[1][$TransitionFieldName]']/option[4]")->get_value(),
            "String",
            "ConditionFieldType stored value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][$TransitionFieldName]']")->get_value(),
            $TransitionValueName,
            "ConditionFieldValue stored value",
        );

        # Edit test Transition values.
        my $TransitionFieldNameEdit = $TransitionFieldName . "edit";
        my $TransitionValueNameEdit = $TransitionValueName . "edit";

        $Selenium->find_element( "#TransitionForm #Name", 'css' )->send_keys("edit");
        $Selenium->InputFieldValueSet(
            Element => '#OverallConditionLinking',
            Value   => 'and',
        );
        $Selenium->find_element(".//*[\@id='ConditionFieldName[1][$TransitionFieldName]']")->clear();
        $Selenium->find_element(".//*[\@id='ConditionFieldName[1][$TransitionFieldName]']")
            ->send_keys($TransitionFieldNameEdit);
        $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][$TransitionFieldName]']")->clear();
        $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][$TransitionFieldName]']")
            ->send_keys($TransitionValueNameEdit);

        # Remove Conditions, expecting JS error on last Condition removal.
        $Selenium->find_element("//a[\@name='ConditionRemove[2]']")->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$("#Condition\\\\[2\\\\]").length'
        );

        $Selenium->find_element("//a[\@name='ConditionRemove[1]']")->click();
        $Selenium->WaitFor(
            AlertPresent => 1,
        );
        $Self->True(
            $Selenium->accept_alert(),
            "Unable to remove only condition - JS is success"
        );
        sleep 1;

        $Selenium->find_element( "#Submit", 'css' )->click();

        # Return to main window.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('a[href*=\"Subaction=TransitionEdit;ID=$TransitionID\"]:visible').length && \$.active == 0"
        );

        # Get test ProcesID.
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
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#TransitionFilter').length"
        );
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#ProcessElements .AccordionElement:eq(2) a.AsBlock',
        );

        # Click on Transition accordion element.
        $Selenium->find_element(" //a[contains(.,\'Transition\')]")->click();

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#TransitionFilter").closest(".AccordionElement").hasClass("Active") === true;'
        );
        sleep 1;

        $Selenium->find_element( "#TransitionFilter", 'css' )->clear();
        $Selenium->find_element( "#TransitionFilter", 'css' )->send_keys($TransitionRandom);

        # Wait for filter to kick in.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".OneRow[data-entity*=\'Transition\']:visible").length === 1'
        );
        sleep 2;

        # Go to edit test Transition screen again.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=TransitionEdit;ID=$TransitionID' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#TransitionForm #Name').length" );

        # Check edited values.
        $Self->Is(
            $Selenium->find_element( "#TransitionForm #Name", 'css' )->get_value(),
            $TransitionRandom . 'edit',
            "#Name updated value",
        );
        $Self->Is(
            $Selenium->find_element( "#OverallConditionLinking option[value='and']", 'css' )->get_value(),
            "and",
            "#OverallConditionLinking updated value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionFieldName[1][$TransitionFieldNameEdit]']")->get_value(),
            $TransitionFieldNameEdit,
            "ConditionFieldName updated value",
        );
        $Self->Is(
            $Selenium->find_element(".//*[\@id='ConditionFieldValue[1][$TransitionFieldNameEdit]']")->get_value(),
            $TransitionValueNameEdit,
            "ConditionFieldValue updated value",
        );

        # Return to main window.
        $Selenium->close();
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#ProcessDelete').length" );

        # Delete test transition.
        my $Success = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition')->TransitionDelete(
            ID     => $TransitionID,
            UserID => $TestUserID,
        );

        $Self->True(
            $Success,
            "Transition is deleted - $TransitionID",
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

        # Make sure the cache is correct.
        for my $Cache (qw(ProcessManagement_Process ProcessManagement_Transition))
        {
            $CacheObject->CleanUp( Type => $Cache );
        }

    }

);

1;
