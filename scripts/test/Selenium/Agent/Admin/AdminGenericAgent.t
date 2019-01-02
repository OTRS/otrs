# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

        # get needed variable
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

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get test user ID
        my $UserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # get dynamic field object
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
            $DynamicFieldID,
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

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminGenericAgent screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminGenericAgent");

        # check overview AdminGenericAgent
        $Selenium->find_element( "table",             'css' );
        $Selenium->find_element( "table thead tr th", 'css' );
        $Selenium->find_element( "table tbody tr td", 'css' );

        # check add job page
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Update' )]")->VerifiedClick();

        my $Element = $Selenium->find_element( "#Profile", 'css' );
        $Element->is_displayed();
        $Element->is_enabled();

        # Toggle widgets
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');

        # create test job
        my $GenericTicketSearch = "*Ticket $RandomID Generic*";
        my $GenericAgentJob     = "GenericAgent" . $RandomID;
        $Selenium->find_element( "#Profile", 'css' )->send_keys($GenericAgentJob);
        $Selenium->find_element( "#Title",   'css' )->send_keys($GenericTicketSearch);

        # Check 'NewNoteBody' length validation from Add Note section (see bug#13912).
        my $FieldValue = "a" x 201;
        $Selenium->find_element( "#NewNoteBody", 'css' )->send_keys($FieldValue);
        $Selenium->find_element("//button[\@type='submit']")->click();
        $Selenium->WaitFor( JavaScript => "return \$('#NewNoteBody.Error').length === 1;" );

        $Self->True(
            $Selenium->execute_script("return \$('#NewNoteBody.Error').length === 1;"),
            "Validation for 'NewNoteBody' field is correct",
        );
        $Selenium->find_element( "#NewNoteBody", 'css' )->clear();

        # set test dynamic field to date in the past, but do not activate it
        # validation used to kick in even if checkbox in front wasn't activated
        # see bug#12210 for more information
        $Selenium->find_element( "#DynamicField_${DynamicFieldName}Year", 'css' )->send_keys('2015');

        $Selenium->find_element( "#DynamicField_${CheckboxDynamicFieldName}Used1", 'css' )->VerifiedClick();

        # save job
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # check if test job show on AdminGenericAgent
        $Self->True(
            index( $Selenium->get_page_source(), $GenericAgentJob ) > -1,
            "$GenericAgentJob job found on page",
        );

        # edit test job to delete test ticket
        $Selenium->find_element( $GenericAgentJob, 'link_text' )->VerifiedClick();

        # toggle Execute Ticket Commands widget
        $Selenium->execute_script('$(".WidgetSimple.Collapsed .WidgetAction.Toggle a").click();');
        $Selenium->execute_script("\$('#NewDelete').val('1').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

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
        $Selenium->find_element("//a[contains(\@href, \'Subaction=RunNow' )]")->VerifiedClick();

        # set test job to invalid
        $Selenium->find_element( $GenericAgentJob, 'link_text' )->VerifiedClick();

        $Selenium->execute_script("\$('#Valid').val('0').trigger('redraw.InputField').trigger('change');");

        # check if the checkbox from dynamicfield is selected
        $Self->Is(
            $Selenium->find_element( "#DynamicField_${CheckboxDynamicFieldName}Used1", 'css' )->is_selected(),
            1,
            "$CheckboxDynamicFieldName Used1 is selected",
        );

        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # check class of invalid generic job in the overview table
        $Self->True(
            $Selenium->execute_script(
                "return \$('tr.Invalid td:contains($GenericAgentJob)').length"
            ),
            "There is a class 'Invalid' for test generic job",
        );

        # delete test job
        $Selenium->find_element("//a[contains(\@href, \'Subaction=Delete;Profile=$GenericAgentJob\' )]")->click();

        # Accept delete confirmation dialog
        $Selenium->accept_alert();

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' &&  \$('tbody tr:contains($GenericAgentJob)').length === 0;"
        );

        # check overview page
        $Self->True(
            index( $Selenium->get_page_source(), $GenericAgentJob ) == -1,
            'Generic Agent job is deleted - $GenericAgentJob'
        );

        # delete created test dynamic field
        my $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID,
            UserID => $UserID,
        );
        $Self->True(
            $Success,
            "Dynamic field - ID $DynamicFieldID - deleted",
        );
    },

);

1;
