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

my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $RandomID = $Helper->GetRandomID();

        # set generic agent run limit
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentRunLimit',
            Value => 10
        );

        # enable extended condition search for generic agent ticket search
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentTicketSearch###ExtendedSearchCondition',
            Value => 1,
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # get test user ID
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminGenericAgent screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # Check if needed frontend module is registered in sysconfig.
        if ( !$ConfigObject->Get('Frontend::Module')->{AdminGenericAgent} ) {
            $Self->True(
                index(
                    $Selenium->get_page_source(),
                    'Module Kernel::Modules::AdminGenericAgent not registered in Kernel/Config.pm!'
                ) > 0,
                'Module AdminGenericAgent is not registered in sysconfig, skipping test...'
            );

            return 1;
        }

        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        # create test dynamic field of type date
        my $DynamicFieldName = 'Test' . $RandomID;
        my $DynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicFieldName,
            Label      => $DynamicFieldName,
            FieldOrder => 9991,
            FieldType  => 'Date',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue    => 0,
                YearsInFuture   => 0,
                YearsInPast     => 0,
                YearsPeriod     => 0,
                DateRestriction => 'DisablePastDates',    # turn on validation of no past dates
            },
            ValidID => 1,
            UserID  => $UserID,
        );

        $Self->True(
            $DynamicFieldID,
            "Dynamic field $DynamicFieldName - ID $DynamicFieldID - created",
        );

        # create also a dynamic field of type checkbox
        my $CheckboxDynamicFieldName = 'TestCheckbox' . $RandomID;
        my $CheckboxDynamicFieldID   = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $CheckboxDynamicFieldName,
            Label      => $CheckboxDynamicFieldName,
            FieldOrder => 9992,
            FieldType  => 'Checkbox',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue => 0,
            },
            ValidID => 1,
            UserID  => $UserID,
        );

        $Self->True(
            $CheckboxDynamicFieldID,
            "Dynamic field $CheckboxDynamicFieldName - ID $CheckboxDynamicFieldID - created",
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my $TestTicketTitle = "Test Ticket $RandomID Generic Agent";
        my @TicketNumbers;
        for ( 1 .. 20 ) {

            # create Ticket to test AdminGenericAgent frontend
            my $TicketID = $TicketObject->TicketCreate(
                Title        => $TestTicketTitle,
                Queue        => 'Raw',
                Lock         => 'unlock',
                PriorityID   => 1,
                StateID      => 1,
                CustomerNo   => 'SeleniumTestCustomer',
                CustomerUser => 'customerUnitTest@example.com',
                OwnerID      => $UserID,
                UserID       => $UserID,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - $TicketID",
            );

            my $TicketNumber = $TicketObject->TicketNumberLookup(
                TicketID => $TicketID,
                UserID   => 1,
            );

            push @TicketNumbers, $TicketNumber;

        }

        # check overview AdminGenericAgent
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        # check add job page
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->VerifiedClick();

        # check breadcrumb on Add job screen
        my $Count = 1;
        my $IsLinkedBreadcrumbText;
        for my $BreadcrumbText ( 'Generic Agent Job Management', 'Add Job' ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        my $Element = $Selenium->find_element( "#Profile", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();

        # Toggle widgets
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # Add test event.
        $Selenium->InputFieldValueSet(
            Element => '#TicketEvent',
            Value   => 'EscalationResponseTimeStart',
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#EventsTable tbody tr:eq(1)').length"
            ),
            '1',
            'JS function AddEvent() is success',
        );

        # Try to add same event, it should result in an error.
        for my $Event (qw(EscalationResponseTimeNotifyBefore EscalationResponseTimeStart)) {
            $Selenium->InputFieldValueSet(
                Element => '#TicketEvent',
                Value   => $Event,
            );
        }

        # wait for dialog to show up, if necessary
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
        );

        # verify dialog message
        $Self->True(
            index(
                $Selenium->get_page_source(),
                'This event is already attached to the job, Please use a different one.'
            ) > -1,
            "Duplicated event dialog message is found",
        );

        # close dialog
        $Selenium->find_element( "#DialogButton1", 'css' )->click();

        # wait for dialog to disappear, if necessary
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;'
        );

        # click to delete added event, confirmation dialog will appear
        $Selenium->execute_script("\$('#EventsTable tbody tr:eq(2) #DeleteEvent').click();");

        # wait for dialog to show up, if necessary
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
        );

        # verify confirmation dialog message on delete event
        $Self->True(
            index( $Selenium->get_page_source(), 'Do you really want to delete this event trigger?' ) > -1,
            "Delete event dialog message is found",
        );

        # confirm delete event
        $Selenium->find_element( "#DialogButton2", 'css' )->click();

        # wait for dialog to disappear, if necessary
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;'
        );

        # verify delete action event
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#EventsTable tbody tr:eq(2)').length"
            ),
            '0',
            'Added event is deleted',
        );

        # Disable modernize fields to check buttons for clearing selections.
        $Helper->ConfigSettingChange(
            Key   => 'ModernizeFormFields',
            Value => 0,
        );

        # Refresh the page.
        $Selenium->VerifiedRefresh();

        # Toggle all widgets.
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # check AddSelectClearButton() JS function
        $Selenium->find_element( "#PriorityIDs option[value='1']", 'css' )->click();
        $Self->True(
            $Selenium->execute_script(
                "return \$('#PriorityIDs option:eq(0)').is(':selected')"
            ),
            "Priority '1 very low' is selected"
        );

        # click to clear selection for Priority field and verify action
        $Selenium->find_element("//a[contains(\@data-select, \'PriorityIDs' )]")->click();
        $Self->False(
            $Selenium->execute_script(
                "return \$('#PriorityIDs option:eq(0)').is(':selected')"
            ),
            "Priority '1 very low' is no longer selected - JS is success"
        );

        # create test job
        my $GenericTicketSearch = "*Ticket $RandomID Generic*";
        my $GenericAgentJob     = "GenericAgent" . $RandomID;
        $Selenium->find_element( "#Profile", 'css' )->send_keys($GenericAgentJob);
        $Selenium->find_element( "#Title",   'css' )->send_keys($GenericTicketSearch);

        # Check 'NewNoteBody' length validation from Add Note section (see bug#13912).
        my $FieldValue = "a" x 201;
        $Selenium->find_element( "#NewNoteBody", 'css' )->send_keys($FieldValue);
        $Selenium->find_element( "#Submit",      'css' )->click();
        $Selenium->WaitFor( JavaScript => "return \$('#NewNoteBody.Error').length === 1;" );

        $Self->True(
            $Selenium->execute_script("return \$('#NewNoteBody.Error').length === 1;"),
            "Validation for 'NewNoteBody' field is correct",
        );
        $Selenium->find_element( "#NewNoteBody", 'css' )->clear();

        # Insert needed dynamic fields.
        $Selenium->execute_script(
            "\$('#AddNewDynamicFields').val('DynamicField_$CheckboxDynamicFieldName').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#SelectedNewDynamicFields #DynamicField_${CheckboxDynamicFieldName}').length;"
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('#SelectedNewDynamicFields #DynamicField_${CheckboxDynamicFieldName}').length;"
            ),
            "Dynamic field '$CheckboxDynamicFieldName' is added",
        );

        $Selenium->execute_script(
            "\$('#AddNewDynamicFields').val('DynamicField_$DynamicFieldName').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('#SelectedNewDynamicFields #DynamicField_${DynamicFieldName}Used').length;"
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('#SelectedNewDynamicFields #DynamicField_${DynamicFieldName}Used').length;"
            ),
            "Dynamic field '$DynamicFieldName' is added",
        );

        # set test dynamic field to date in the past, but do not activate it
        # validation used to kick in even if checkbox in front wasn't activated
        # see bug#12210 for more information
        $Selenium->find_element( "#DynamicField_${DynamicFieldName}Year", 'css' )->send_keys('2015');

        # save job
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        $Selenium->WaitFor( ElementExists => "//a[contains(.,\'$GenericAgentJob\')]" );

        # check if test job show on AdminGenericAgent
        $Self->True(
            index( $Selenium->get_page_source(), $GenericAgentJob ) > -1,
            "$GenericAgentJob job found on page",
        );

        # verify filter will show no result for invalid input
        my $InvalidName = 'Invalid' . $RandomID;
        $Selenium->find_element( "#FilterGenericAgentJobs", 'css' )->send_keys($InvalidName);

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('table tbody tr td:contains($GenericAgentJob):hidden').length === 1"
        );

        my $CSSDisplay = $Selenium->execute_script(
            "return \$('table tbody tr td:contains($GenericAgentJob)').parent().css('display')"
        );

        $Self->Is(
            $CSSDisplay,
            'none',
            "Generic Agent job $GenericAgentJob is not found in the table"
        );

        # verify filter show correct result for valid input
        $Selenium->find_element( "#FilterGenericAgentJobs", 'css' )->clear();
        $Selenium->find_element( "#FilterGenericAgentJobs", 'css' )->send_keys($GenericAgentJob);
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('table tbody tr td:contains($GenericAgentJob):visible').length === 1"
        );

        $CSSDisplay = $Selenium->execute_script(
            "return \$('table tbody tr td:contains($GenericAgentJob)').parent().css('display')"
        );

        $Self->Is(
            $CSSDisplay,
            'table-row',
            "Generic Agent job $GenericAgentJob is found in the table"
        );

        # edit test job to delete test ticket
        $Selenium->find_element( $GenericAgentJob, 'link_text' )->VerifiedClick();

        # check breadcrumb on Edit job screen
        $Count = 1;
        for my $BreadcrumbText ( 'Generic Agent Job Management', 'Edit Job: ' . $GenericAgentJob ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # toggle Execute Ticket Commands widget
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # Check if the checkbox from dynamicfield is added and not checked.
        $Self->True(
            $Selenium->execute_script(
                "return \$('#SelectedNewDynamicFields #DynamicField_${CheckboxDynamicFieldName}').prop('checked') === false;"
            ),
            "Dynamic field '$CheckboxDynamicFieldName' is added and unchecked",
        );

        $Selenium->InputFieldValueSet(
            Element => '#NewDelete',
            Value   => 1,
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        $Selenium->WaitFor( ElementExists => "//a[contains(.,\'$GenericAgentJob\')]" );

        # run test job
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Run;Profile=$GenericAgentJob' )]")->VerifiedClick();

        # verify there are no tickets found with enabled ExtendedSearchCondition
        $Self->True(
            index( $Selenium->get_page_source(), '0 Tickets affected! What do you want to do?' ) > -1,
            "No tickets found on page with ExtendedSearchCondition enabled",
        );

        # disable extended condition search for generic agent ticket search
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::GenericAgentTicketSearch###ExtendedSearchCondition',
            Value => 0,
        );

        # navigate to AgentGenericAgent screen again
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # run test job
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Run;Profile=$GenericAgentJob' )]")->VerifiedClick();

        # check breadcrumb on Run job screen
        $Count = 1;
        for my $BreadcrumbText ( 'Generic Agent Job Management', 'Run Job: ' . $GenericAgentJob ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $Count++;
        }

        # check if test job show expected result
        for my $TicketNumber (@TicketNumbers) {

            $Self->True(
                index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                "$TicketNumber found on page",
            );

        }

        # check if there is warning message:
        # "Affected more tickets then how many will be executed on run job"
        $Self->True(
            $Selenium->execute_script(
                "return \$('p.Error:contains(tickets affected but only)').length"
            ),
            "RunLimit warning message shown",
        );

        # execute test job
        $Selenium->VerifiedRefresh();
        $Selenium->find_element("//a[contains(\@href, \'Subaction=RunNow' )]")->VerifiedClick();

        # run test job again
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Run;Profile=$GenericAgentJob' )]")->VerifiedClick();

        # check if there is no warning message:
        # "Affected more tickets than how many will be executed on run job"
        $Self->False(
            $Selenium->execute_script(
                "return \$('p.Error:contains(tickets affected but only)').length"
            ),
            "There is no warning message",
        );

        # execute test job
        $Selenium->VerifiedRefresh();
        $Selenium->find_element("//a[contains(\@href, \'Subaction=RunNow' )]")->VerifiedClick();

        # set test job to invalid
        $Selenium->find_element( $GenericAgentJob, 'link_text' )->VerifiedClick();

        $Selenium->InputFieldValueSet(
            Element => '#Valid',
            Value   => 0,
        );

        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();
        $Selenium->WaitFor( ElementExists => "//a[contains(.,\'$GenericAgentJob\')]" );

        # check class of invalid generic job in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td:contains($GenericAgentJob)').length"
            ),
            "There is a class 'Invalid' for test generic job",
        );

        # Delete test job confirmation dialog. See bug#14197.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;Profile=$GenericAgentJob\' )]")->click();
        $Selenium->WaitFor( AlertPresent => 1 );
        $Selenium->accept_alert();

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('table tbody tr td:contains($GenericAgentJob)').length == 0;"
        );
        $Selenium->VerifiedRefresh();

        # Check if GenericAgentJob is deleted.
        $Self->False(
            $Selenium->execute_script(
                "return \$('table tbody tr td:contains($GenericAgentJob)').length"
            ),
            "GenericAgentJob $GenericAgentJob is no found on page",
        );

        # delete created test dynamic fields
        my $Success;
        for my $DynamicFieldDelete ( $DynamicFieldID, $CheckboxDynamicFieldID ) {
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldDelete,
                UserID => $UserID,
            );
            $Self->True(
                $Success,
                "Dynamic field - ID $DynamicFieldDelete - deleted",
            );
        }
    },

);

1;
