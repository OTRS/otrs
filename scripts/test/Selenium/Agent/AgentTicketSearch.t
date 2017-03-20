# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Make sure we start with RuntimeDB search.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::SearchIndexModule',
            Value => 'Kernel::System::Ticket::ArticleSearchIndex::RuntimeDB',
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $RandomID = $Helper->GetRandomID();

        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');

        my %DynamicFields = (
            Date => {
                Name       => 'TestDate' . $RandomID,
                Label      => 'TestDate' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'Date',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue  => 0,
                    YearsInFuture => 0,
                    YearsInPast   => 50,
                    YearsPeriod   => 1,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
            DateTime => {
                Name       => 'TestDateTime' . $RandomID,
                Label      => 'TestDateTime' . $RandomID,
                FieldOrder => 9990,
                FieldType  => 'DateTime',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue  => 0,
                    YearsInFuture => 0,
                    YearsInPast   => 50,
                    YearsPeriod   => 1,
                },
                Reorder => 1,
                ValidID => 1,
                UserID  => 1,
            },
        );

        my @DynamicFieldIDs;

        # Create test dynamic field of type date
        for my $DynamicFieldType ( sort keys %DynamicFields ) {

            my $DynamicFieldID = $DynamicFieldObject->DynamicFieldAdd(
                %{ $DynamicFields{$DynamicFieldType} },
            );

            $Self->True(
                $DynamicFieldID,
                "Dynamic field $DynamicFields{$DynamicFieldType}->{Name} - ID $DynamicFieldID - created",
            );

            push @DynamicFieldIDs, $DynamicFieldID;
        }

        my %LoockupDynamicFieldNames = map { $DynamicFields{$_}->{Name} => 1 } sort keys %DynamicFields;

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketSearch###DynamicField',
            Value => \%LoockupDynamicFieldNames,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $TitleRandom  = "Title" . $RandomID;
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN         => $TicketNumber,
            Title      => $TitleRandom,
            Queue      => 'Raw',
            Lock       => 'unlock',
            Priority   => '3 normal',
            State      => 'open',
            CustomerID => 'SeleniumCustomer',
            OwnerID    => 1,
            UserID     => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        my $MinCharString = 'ct';
        my $MaxCharString = $RandomID . ( 't' x 50 );
        my $Subject       = 'Subject' . $RandomID;
        my $ArticleID     = $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleCreate(
            TicketID    => $TicketID,
            ArticleType => 'note-internal',
            SenderType  => 'agent',
            Subject     => $Subject,
            Body =>
                "'maybe $MinCharString in an abbreviation' this is string with more than 30 characters $MaxCharString",
            ContentType    => 'text/plain; charset=ISO-8859-15',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
            UserID         => 1,
            NoAgentNotify  => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID",
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Check the general fields for ticket search page.
        for my $ID (
            qw(SearchProfile SearchProfileNew Attribute ResultForm SearchFormSubmit)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # Add search filter by ticket number and run it.
        $Selenium->find_element( ".AddButton",   'css' )->click();
        $Selenium->find_element( "TicketNumber", 'name' )->send_keys($TicketNumber);
        $Selenium->find_element( "TicketNumber", 'name' )->VerifiedSubmit();

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Input wrong search parameters, result should be 'No ticket data found'.
        $Selenium->execute_script(
            "\$('input[name=\"Fulltext\"]').val('abcdfgh_nonexisting_ticket_text');",
        );
        $Selenium->find_element( "Fulltext", 'name' )->VerifiedSubmit();

        $Self->True(
            index( $Selenium->get_page_source(), "No ticket data found." ) > -1,
            "Ticket is not found on page",
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Search for $MaxCharString with RuntimeDB - ticket must be found.
        $Selenium->find_element( "Fulltext", 'name' )->send_keys($MaxCharString);
        $Selenium->find_element( "Fulltext", 'name' )->VerifiedSubmit();

        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page with RuntimeDB search with string longer then 30 characters",
        );

        # Change search index module.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::SearchIndexModule',
            Value => 'Kernel::System::Ticket::ArticleSearchIndex::StaticDB',
        );

        # Enable warn on stop word usage.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::SearchIndex::WarnOnStopWordUsage',
            Value => 1,
        );

        # Recreate article object and update article index for static DB.
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket::Article'] );
        $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleIndexBuild(
            ArticleID => $ArticleID,
            UserID    => 1,
        );

        # Navigate to AgentTicketSearch screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Try to search fulltext with string less then 3 characters.
        $Selenium->execute_script(
            "\$('input[name=\"Fulltext\"]').val('$MinCharString');",
        );
        $Selenium->find_element("//button[\@id='SearchFormSubmit']")->click();

        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for MinCharString not found';

        # Verify the alert message.
        my $ExpectedAlertText = "Fulltext: $MinCharString";
        $Self->True(
            ( $Selenium->get_alert_text() =~ /$ExpectedAlertText/ ),
            'Minimum character string search warning is found',
        );

        # Accept the alert to continue with the tests.
        $Selenium->accept_alert();

        # Try to search fulltext with string more than 30 characters.
        $Selenium->find_element( "Fulltext", 'name' )->clear();
        $Selenium->execute_script(
            "\$('input[name=\"Fulltext\"]').val('$MaxCharString');",
        );
        $Selenium->find_element("//button[\@id='SearchFormSubmit']")->click();

        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for MaxCharString not found';

        # Verify the alert message.
        $ExpectedAlertText = "Fulltext: $MaxCharString";
        $Self->True(
            ( $Selenium->get_alert_text() =~ /$ExpectedAlertText/ ),
            'Maximum character string search warning is found',
        );

        # Accept the alert to continue with the tests.
        $Selenium->accept_alert();

        # Try to search fulltext with 'stop word' search.
        $Selenium->find_element( "Fulltext", 'name' )->clear();
        $Selenium->execute_script(
            "\$('input[name=\"Fulltext\"]').val('because');",
        );
        $Selenium->find_element("//button[\@id='SearchFormSubmit']")->click();

        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for stop word not found';

        # Verify the alert message.
        $ExpectedAlertText = "Fulltext: because";
        $Self->True(
            ( $Selenium->get_alert_text() =~ /$ExpectedAlertText/ ),
            'Stop word search string warning is found',
        );

        # Accept the alert to continue with the tests.
        $Selenium->accept_alert();

        # Search fulltext with correct input.
        $Selenium->find_element( "Fulltext", 'name' )->clear();
        $Selenium->execute_script(
            "\$('input[name=\"Fulltext\"]').val('$Subject');",
        );

        $Selenium->find_element("//button[\@id='SearchFormSubmit']")->VerifiedClick();

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('div.TicketZoom').length" );

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page with correct StaticDB search",
        );

        # Navigate to AgentTicketSearch screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if neccessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Add search filter by priority and run it.
        $Selenium->execute_script(
            "\$('#Attribute').val('PriorityIDs').trigger('redraw.InputField').trigger('change');",
        );
        $Selenium->find_element( '.AddButton',          'css' )->click();
        $Selenium->find_element( '#PriorityIDs_Search', 'css' )->click();

        # Wait until drop down list is shown.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.InputField_ListContainer').length"
        );

        # Click on remove button next to priority field.
        $Selenium->find_element( '#PriorityIDs + .RemoveButton', 'css' )->click();

        # Wait until drop down list is hidden.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.InputField_ListContainer').length == 0"
        );

        # Verify dropdown list has been hidden (bug#12243).
        $Self->True(
            index( $Selenium->get_page_source(), 'InputField_ListContainer' ) == -1,
            "InputField list not found on page",
        );

        for my $DynamicFieldType (qw(Date DateTime)) {

            # Add the date dynamic field, to check if the correct years are selectable (bug#12678).
            $Selenium->execute_script(
                "\$('#Attribute').val('Search_DynamicField_$DynamicFields{$DynamicFieldType}->{Name}TimeSlot').trigger('redraw.InputField').trigger('change');",
            );
            $Selenium->find_element( '.AddButton', 'css' )->click();

            for my $DatePart (qw(StartYear StartMonth StartDay StopYear StopMonth StopDay)) {
                my $Element = $Selenium->find_element(
                    "#Search_DynamicField_$DynamicFields{$DynamicFieldType}->{Name}TimeSlot$DatePart", 'css' );
                $Element->is_enabled();
                $Element->is_displayed();
            }

            # Check if the correct count of options in the year dropdown exists.
            for my $DatePart (qw(StartYear StopYear)) {
                $Self->Is(
                    $Selenium->execute_script(
                        "return \$('#Search_DynamicField_$DynamicFields{$DynamicFieldType}->{Name}TimeSlot$DatePart:visible > option').length;"
                    ),
                    51,
                    "DynamicField date $DatePart filtered options count",
                );
            }
        }

        # clean up test data from the DB
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket ID $TicketID is deleted",
        );

        for my $DynamicFieldID (@DynamicFieldIDs) {

            # delete created test dynamic field
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Dynamic field - ID $DynamicFieldID - deleted",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    },
);

1;
