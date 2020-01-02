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

        # Disable warn on stop word usage.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::SearchIndex::WarnOnStopWordUsage',
            Value => 0,
        );

        # Enable ModernizeFormFields.
        $Helper->ConfigSettingChange(
            Key   => 'ModernizeFormFields',
            Value => 1,
        );

        my $RandomID = $Helper->GetRandomID();

        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DFTextName         = 'Text' . $RandomID;

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
            Text => {
                Name       => $DFTextName,
                Label      => $DFTextName,
                FieldOrder => 9990,
                FieldType  => 'Text',
                ObjectType => 'Ticket',
                Config     => {
                    DefaultValue => '',
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

        my %LookupDynamicFieldNames = map { $DynamicFields{$_}->{Name} => 1 } sort keys %DynamicFields;

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketSearch###DynamicField',
            Value => \%LookupDynamicFieldNames,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Make sure test ticket create time is influenced by daylight savings time in Europe/Berlin:
        #   - System time: May 4th 2017 23:00:00
        #   - User time: May 5th 2017 01:00:00
        my $SystemTime = $Kernel::OM->Create(
            'Kernel::System::DateTime',
            ObjectParams => {
                String => '2017-05-04 23:00:00',
            },
        );
        $Helper->FixedTimeSet($SystemTime);

        my @TicketIDs;
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
        push @TicketIDs, $TicketID;

        my $MinCharString        = 'ct';
        my $MaxCharString        = $RandomID . ( 't' x 50 );
        my $Subject              = 'Subject' . $RandomID;
        my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Internal' );

        my $ArticleID = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'agent',
            IsVisibleForCustomer => 0,
            Subject              => $Subject,
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

        $ArticleObject->ArticleSearchIndexBuild(
            TicketID  => $TicketID,
            ArticleID => $ArticleID,
            UserID    => 1,
        );

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Go to agent preferences screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

        # Change test user time zone preference to Europe/Berlin.
        $Selenium->InputFieldValueSet(
            Element => '#UserTimeZone',
            Value   => 'Europe/Berlin',
        );
        $Selenium->execute_script(
            "\$('#UserTimeZone').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserTimeZone').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserTimeZone').closest('.WidgetSimple').find('.fa-check').length"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#UserTimeZone').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # Go to ticket search screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
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
        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'TicketNumber',
        );
        $Selenium->find_element( 'TicketNumber',      'name' )->send_keys($TicketNumber);
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->VerifiedClick();

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Input wrong search parameters, result should be 'No ticket data found'.
        $Selenium->find_element( "Fulltext",          'name' )->send_keys('abcdfgh_nonexisting_ticket_text');
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->click();

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#EmptyMessageSmall').text().trim() === 'No ticket data found.'"
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#EmptyMessageSmall').text().trim();"),
            "No ticket data found.",
            "Ticket is not found on page",
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Search for $MaxCharString - ticket will not be found.
        $Selenium->find_element( "Fulltext",          'name' )->send_keys($MaxCharString);
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) == -1,
            "Ticket $TitleRandom not found on search page with string longer then 30 characters",
        );

        # Enable warn on stop word usage.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::SearchIndex::WarnOnStopWordUsage',
            Value => 1,
        );

        # Recreate article object and update article index for static DB.
        $Kernel::OM->ObjectsDiscard( Objects => ['Kernel::System::Ticket::Article'] );
        $Kernel::OM->Get('Kernel::System::Ticket::Article')->ArticleSearchIndexBuild(
            TicketID  => $TicketID,
            ArticleID => $ArticleID,
            UserID    => 1,
        );

        # Navigate to AgentTicketSearch screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Try to search fulltext with string less then 3 characters.
        $Selenium->execute_script(
            "\$('input[name=\"Fulltext\"]').val('$MinCharString');",
        );
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->click();

        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for MinCharString not found';
        sleep 1;

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
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->click();

        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for MaxCharString not found';
        sleep 1;

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
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->click();

        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for stop word not found';

        # Verify the alert message.
        $ExpectedAlertText = "\nFulltext: because";
        $Self->True(
            ( $Selenium->get_alert_text() =~ /$ExpectedAlertText/ ),
            'Stop word search string warning is found',
        );

        # Accept the alert to continue with the tests.
        $Selenium->accept_alert();

        # Add Subject field and try searching subject with 'stop word' search.
        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'MIMEBase_Subject',
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('#SearchInsert input[name=MIMEBase_Subject]').length"
        );

        $Selenium->find_element( "Fulltext",          'name' )->clear();
        $Selenium->find_element( "MIMEBase_Subject",  'name' )->clear();
        $Selenium->find_element( "MIMEBase_Subject",  'name' )->send_keys('because');
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->click();

        $Selenium->WaitFor( AlertPresent => 1 ) || die 'Alert for stop word not found';

        # Verify the alert message.
        $ExpectedAlertText = "\nSubject: because";

        $Self->True(
            ( $Selenium->get_alert_text() =~ /$ExpectedAlertText/ ),
            'Stop word search string warning is found',
        );

        # Accept the alert to continue with the tests.
        $Selenium->accept_alert();

        # Clear Subject field.
        $Selenium->find_element( "MIMEBase_Subject", 'name' )->clear();

        # Search fulltext with correct input.
        $Selenium->execute_script(
            "\$('input[name=\"Fulltext\"]').val('$Subject');",
        );

        $Selenium->find_element( '#SearchFormSubmit', 'css' )->VerifiedClick();

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('div.TicketZoom').length" );

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page with correct search",
        );

        # Navigate to AgentTicketSearch screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Add search filter by ticket create time and run it (May 4th).
        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'TicketCreateTimeSlot',
        );
        for my $Field (qw(Start Stop)) {
            $Selenium->execute_script("\$('#TicketCreateTime${Field}Day:eq(0)').val('4');");
            $Selenium->execute_script("\$('#TicketCreateTime${Field}Month:eq(0)').val('5');");
            $Selenium->execute_script("\$('#TicketCreateTime${Field}Year:eq(0)').val('2017');");
        }
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->click();

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#EmptyMessageSmall').text().trim() === 'No ticket data found.'"
        );
        $Self->Is(
            $Selenium->execute_script("return \$('#EmptyMessageSmall').text().trim();"),
            "No ticket data found.",
            "Ticket is not found on page",
        );

        # Navigate to AgentTicketSearch screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Add search filter by ticket create time and run it (May 5th).
        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'TicketCreateTimeSlot',
        );
        for my $Field (qw(Start Stop)) {
            $Selenium->execute_script("\$('#TicketCreateTime${Field}Day:eq(0)').val('5');");
            $Selenium->execute_script("\$('#TicketCreateTime${Field}Month:eq(0)').val('5');");
            $Selenium->execute_script("\$('#TicketCreateTime${Field}Year:eq(0)').val('2017');");
        }
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->VerifiedClick();

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page"
        );

        # Navigate to AgentTicketSearch screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Add search filter by ticket create time and set it to invalid date (April 31st).
        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'TicketCreateTimeSlot',
        );
        $Selenium->execute_script("\$('#TicketCreateTimeStartDay:eq(0)').val('31');");
        $Selenium->execute_script("\$('#TicketCreateTimeStartMonth:eq(0)').val('4');");
        $Selenium->execute_script("\$('#TicketCreateTimeStartYear:eq(0)').val('2017');");
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#TicketCreateTimeStartDay.Error').length;"
        );

        $Self->True(
            $Selenium->execute_script(
                "return \$('#TicketCreateTimeStartDay.Error').length;"
            ),
            'Invalid date highlighted as an error'
        );

        # Fix the start date and set the end date to one before the start date.
        $Selenium->execute_script("\$('#TicketCreateTimeStartDay:eq(0)').val('5');");
        $Selenium->execute_script("\$('#TicketCreateTimeStartMonth:eq(0)').val('5');");
        $Selenium->execute_script("\$('#TicketCreateTimeStartYear:eq(0)').val('2017');");

        $Selenium->execute_script("\$('#TicketCreateTimeStopDay:eq(0)').val('4');");
        $Selenium->execute_script("\$('#TicketCreateTimeStopMonth:eq(0)').val('5');");
        $Selenium->execute_script("\$('#TicketCreateTimeStopYear:eq(0)').val('2017');");
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#TicketCreateTimeStopDay.Error').length;"
        );

        $Self->True(
            $Selenium->execute_script(
                "return \$('#TicketCreateTimeStopDay.Error').length;"
            ),
            'End date in the past highlighted as an error'
        );

        # Fix the end date, and submit the search again.
        $Selenium->execute_script("\$('#TicketCreateTimeStopDay:eq(0)').val('5');");
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->VerifiedClick();

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page"
        );

        # Navigate to AgentTicketSearch screen again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Add search filter by priority and run it.
        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'PriorityIDs',
        );
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
            $Selenium->InputFieldValueSet(
                Element => '#Attribute',
                Value   => "Search_DynamicField_$DynamicFields{$DynamicFieldType}->{Name}TimeSlot",
            );

            for my $DatePart (qw(StartYear StartMonth StartDay StopYear StopMonth StopDay)) {
                my $Element = $Selenium->find_element(
                    "#Search_DynamicField_$DynamicFields{$DynamicFieldType}->{Name}TimeSlot$DatePart", 'css'
                );
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

        # Test for dynamic field text type search with '||' (see bug#12560).
        # Create two tickets and set two different DF values for them.
        my $TextTypeDynamicFieldConfig = $DynamicFieldObject->DynamicFieldGet(
            Name => $DFTextName,
        );
        my $BackendObject = $Kernel::OM->Get('Kernel::System::DynamicField::Backend');
        my $Success;
        for my $DFValue (qw(GASZ JLEB)) {
            my $Title    = "Title$DFValue" . $RandomID;
            my $Number   = $TicketObject->TicketCreateNumber();
            my $TicketID = $TicketObject->TicketCreate(
                TN         => $Number,
                Title      => $Title,
                Queue      => 'Junk',
                Lock       => 'unlock',
                Priority   => ( $DFValue eq 'GASZ' ) ? '1 very low' : '2 low',
                State      => 'open',
                CustomerID => 'SeleniumCustomer',
                OwnerID    => 1,
                UserID     => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );
            push @TicketIDs, $TicketID;

            $Success = $BackendObject->ValueSet(
                DynamicFieldConfig => $TextTypeDynamicFieldConfig,
                ObjectID           => $TicketID,
                Value              => $DFValue,
                UserID             => 1,
            );
            $Self->True(
                $Success,
                "Value '$DFValue' is set successfully for ticketID $TicketID",
            );
        }

        # Navigate to AgentTicketSearch screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        my $TextFieldID = 'Search_DynamicField_' . $DynamicFields{Text}->{Name};

        # Add search filter by text dynamic field and run it.
        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => $TextFieldID,
        );
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('#SearchInsert #$TextFieldID').length"
        );
        $Selenium->find_element( '#' . $TextFieldID,  'css' )->clear();
        $Selenium->find_element( '#' . $TextFieldID,  'css' )->send_keys('GASZ||JLEB');
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->VerifiedClick();

        # Check if the last two created tickets are in the table.
        $Self->True(
            $Selenium->execute_script("return \$('#OverviewBody tbody tr[id=TicketID_$TicketIDs[1]').length;"),
            "TicketID $TicketIDs[1] is found in the table"
        );
        $Self->True(
            $Selenium->execute_script("return \$('#OverviewBody tbody tr[id=TicketID_$TicketIDs[2]').length;"),
            "TicketID $TicketIDs[2] is found in the table"
        );

        # Test searching by URL (see bug#7988).
        # Search for tickets in Junk queue and with DF values 'GASZ' or 'JLEB' -
        # the last two created tickets should be in the table.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketSearch;Subaction=Search;$TextFieldID=GASZ||JLEB;ShownAttributes=Label$TextFieldID"
        );
        $Self->True(
            $Selenium->execute_script("return \$('#OverviewBody tbody tr[id=TicketID_$TicketIDs[0]').length == 0"),
            "TicketID $TicketIDs[0] is not found in the table"
        );
        $Self->True(
            $Selenium->execute_script("return \$('#OverviewBody tbody tr[id=TicketID_$TicketIDs[1]').length"),
            "TicketID $TicketIDs[1] is found in the table"
        );
        $Self->True(
            $Selenium->execute_script("return \$('#OverviewBody tbody tr[id=TicketID_$TicketIDs[2]').length"),
            "TicketID $TicketIDs[2] is found in the table"
        );

        # Search for tickets with priorities '1 very low' and '2 low' -
        # the last two created tickets should be in the table.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketSearch;Subaction=Search;Priorities=1 very low;Priorities=2 low"
        );
        $Self->True(
            $Selenium->execute_script("return \$('#OverviewBody tbody tr[id=TicketID_$TicketIDs[0]').length == 0"),
            "TicketID $TicketIDs[0] is not found in the table"
        );
        $Self->True(
            $Selenium->execute_script("return \$('#OverviewBody tbody tr[id=TicketID_$TicketIDs[1]').length"),
            "TicketID $TicketIDs[1] is found in the table"
        );
        $Self->True(
            $Selenium->execute_script("return \$('#OverviewBody tbody tr[id=TicketID_$TicketIDs[2]').length"),
            "TicketID $TicketIDs[2] is found in the table"
        );

        # Verify tree selection view in AgentTicketSearch for multiple fields. See bug#14494.
        $Helper->ConfigSettingChange(
            Key   => 'ModernizeFormFields',
            Value => 0,
        );

        # Refresh screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#Attribute',
            Event       => 'change',
        );

        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'QueueIDs',
        );
        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'CreatedQueueIDs',
        );

        # Click to show tree selection for both fields.
        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '.ShowTreeSelection',
        );
        $Selenium->execute_script("\$('.ShowTreeSelection').click();");
        sleep 1;

        my @SearchElements = $Selenium->find_elements("//input[contains(\@placeholder,'Search...')]");

        # Filter by Created in Queue.
        $SearchElements[1]->send_keys('Junk');

        # Verify only one visible entry is found in tree view selection for Created in Queue.
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#CreatedQueueIDs').siblings('.JSTreeField').find('ul li a').hasClass('jstree-search');"
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('#CreatedQueueIDs').siblings('.JSTreeField').find('ul li a').hasClass('jstree-search');"
            ),
            "Tree view filter for Created in Queue correctly found expected value."
        );

        # Filter by Queue.
        $SearchElements[0]->send_keys('Misc');

        # Verify only one visible entry is found in tree view selection for Created in Queue.
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#QueueIDs').siblings('.JSTreeField').find('ul li a').hasClass('jstree-search');"
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('#QueueIDs').siblings('.JSTreeField').find('ul li a').hasClass('jstree-search');"
            ),
            "Tree view filter for Queue correctly found expected value."
        );

        # Click to remove filter for Queue and verify that Created in Queue remained filtered.
        $Selenium->execute_script("\$('#QueueIDs').siblings('.DialogTreeSearch').find('span').click();");
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#QueueIDs').siblings('.JSTreeField').find('ul li a').hasClass('jstree-search');"
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('#CreatedQueueIDs').siblings('.JSTreeField').find('ul li a').hasClass('jstree-search');"
            ),
            "Tree view filter for CreatedQueueIDs correctly found expected value after removing Queue tree view filter."
        );

        # Change test user language and verify searchable Article Fields are translated.
        # See bug#13913 (https://bugs.otrs.org/show_bug.cgi?id=13913).

        # Go to agent preferences screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=UserProfile");

        # Change test user language preference to Deutsch (de).
        my $Language = 'de';
        $Selenium->InputFieldValueSet(
            Element => '#UserLanguage',
            Value   => 'de',
        );
        $Selenium->execute_script(
            "\$('#UserLanguage').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserLanguage').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#UserLanguage').closest('.WidgetSimple').find('.fa-check').length"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#UserLanguage').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # Navigate to AgentTicketSearch screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketSearch");

        # Wait until form and overlay has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#SearchProfile').length" );

        # Select 'Body' field in search.
        $Selenium->InputFieldValueSet(
            Element => '#Attribute',
            Value   => 'MIMEBase_Body',
        );
        $Selenium->WaitFor(
            JavaScript => "return \$('#SearchInsert input[name=MIMEBase_Body]').length"
        );

        # Verify translated 'Body' field label.
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        $Self->Is(
            $Selenium->execute_script(" return \$('#LabelMIMEBase_Body').text()"),
            $LanguageObject->Translate('Body') . ':',
            "Article search field 'Body' translated correctly"
        );

        # Input some text and search.
        $Selenium->find_element( "Fulltext",          'name' )->send_keys('text123456');
        $Selenium->find_element( '#SearchFormSubmit', 'css' )->VerifiedClick();

        # Check for search profile name.
        my $SearchText = $LanguageObject->Translate('Change search options') . ' ('
            . $LanguageObject->Translate('last-search') . ')';

        $Self->Is(
            $Selenium->execute_script("return \$('.ControlRow a:eq(0)').text().trim();"),
            $SearchText,
            "Search profile name 'last-search' found on page",
        );

        # Clean up test data from the DB.
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketID,
                    UserID   => 1,
                );
            }
            $Self->True(
                $Success,
                "Ticket - ID $TicketID - deleted",
            );
        }

        # Delete created test dynamic fields.
        for my $DynamicFieldID (@DynamicFieldIDs) {
            $Success = $DynamicFieldObject->DynamicFieldDelete(
                ID     => $DynamicFieldID,
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Dynamic field - ID $DynamicFieldID - deleted",
            );
        }

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    },
);

1;
