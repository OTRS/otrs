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

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Do not check Service.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        # Do not check Type.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 1,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test DynamicField field.
        my $DynamicFieldObject = $Kernel::OM->Get('Kernel::System::DynamicField');
        my $DynamicFieldName   = 'DFText' . $RandomID;
        my $DynamicFieldID     = $DynamicFieldObject->DynamicFieldAdd(
            Name       => $DynamicFieldName,
            Label      => 'DFlabel' . $RandomID,
            FieldOrder => 9990,
            FieldType  => 'Text',
            ObjectType => 'Ticket',
            Config     => {
                DefaultValue => '',
                Link         => '',
            },
            Reorder => 1,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $DynamicFieldID,
            "DynamicFieldID $DynamicFieldID is created",
        );

        # Enable SearchOverviewDynamicField.
        $Helper->ConfigSettingChange(
            Key   => 'Ticket::Frontend::CustomerTicketSearch###SearchOverviewDynamicField',
            Valid => 1,
            Value => {
                $DynamicFieldName => 1,
            },
        );

        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # Create test customer user.
        my $TestCustomerUserLogin = $CustomerUserObject->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $RandomID,
            UserLastname   => $RandomID,
            UserCustomerID => $RandomID,
            UserLogin      => 'CustomerUser (Example) ' . $RandomID,
            UserPassword   => $RandomID,
            UserEmail      => "$RandomID\@example.com",
            ValidID        => 1,
            UserID         => 1
        );
        $Self->True(
            $TestCustomerUserLogin,
            "CustomerUser $TestCustomerUserLogin is created",
        );

        my $Language = 'de';
        $CustomerUserObject->SetPreferences(
            UserID => $TestCustomerUserLogin,
            Key    => 'UserLanguage',
            Value  => $Language,
        );

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $RandomID,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to CustomerTicketSearch screen.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        # Check overview screen.
        for my $ID (
            qw(Profile TicketNumber CustomerID MIMEBase_From MIMEBase_To MIMEBase_Cc MIMEBase_Subject MIMEBase_Body
            ServiceIDs TypeIDs PriorityIDs StateIDs
            NoTimeSet Date DateRange TicketCreateTimePointStart TicketCreateTimePoint TicketCreateTimePointFormat
            TicketCreateTimeStartMonth TicketCreateTimeStartDay TicketCreateTimeStartYear TicketCreateTimeStartDayDatepickerIcon
            TicketCreateTimeStopMonth TicketCreateTimeStopDay TicketCreateTimeStopYear TicketCreateTimeStopDayDatepickerIcon
            SaveProfile Submit ResultForm)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create ticket for test scenario.
        my $TitleRandom = 'Title' . $RandomID;
        my $TicketID    = $TicketObject->TicketCreate(
            Title        => $TitleRandom,
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket ID $TicketID - created",
        );

        my @TicketIDs = ($TicketID);

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Email',
        );

        # Add test article to the ticket.
        #   Make it not visible for the customer, but with the sender type of customer, in order to check if it's
        #   filtered out correctly.
        my $InternalArticleMessage = 'not for the customer';
        my $ArticleID              = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            IsVisibleForCustomer => 0,
            SenderType           => 'customer',
            Subject              => $TitleRandom,
            Body                 => $InternalArticleMessage,
            ContentType          => 'text/plain; charset=ISO-8859-15',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID"
        );

        # Get test ticket number.
        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
        );

        # Set DynamicField value.
        my $ValueText = 'DFV' . $RandomID;
        my $Success   = $Kernel::OM->Get('Kernel::System::DynamicFieldValue')->ValueSet(
            FieldID    => $DynamicFieldID,
            ObjectType => 'Ticket',
            ObjectID   => $TicketID,
            Value      => [
                {
                    ValueText => $ValueText,
                },
            ],
            UserID => 1,
        );
        $Self->True(
            $Success,
            "Value for DynamicFieldID $DynamicFieldID is set to TicketID $TicketID '$ValueText' successfully",
        );

        # Input ticket number as search parameter.
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys( $Ticket{TicketNumber} );
        $Selenium->find_element( "#Submit",       'css' )->VerifiedClick();

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # Check if internal article was not shown.
        $Self->True(
            index( $Selenium->get_page_source(), $InternalArticleMessage ) == -1,
            'Internal article not found on page'
        );

        # Verify translated 'Body' field label.
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # Check for search profile name.
        my $SearchText = '← '
            . $LanguageObject->Translate('Change search options') . ' ('
            . $LanguageObject->Translate('last-search') . ')';
        $Self->Is(
            $Selenium->execute_script("return \$('.ActionRow a').text().trim()"),
            $SearchText,
            "Search profile name 'last-search' found on page",
        );

        # Check if DynamicField value is available in CustomerTicketSearch result screen.
        # See https://bugs.otrs.org/show_bug.cgi?id=13818.
        $Self->True(
            index( $Selenium->get_page_source(), "$ValueText" ) > -1,
            "DynamicField value is found - $DynamicFieldName:$ValueText",
        );

        # Click on '← Change search options'.
        $Selenium->find_element( $SearchText, 'link_text' )->VerifiedClick();

        # Input more search filters, result should be 'No data found'.
        $Selenium->find_element( "#TicketNumber", 'css' )->clear();
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys("123456789012345");
        $Selenium->InputFieldValueSet(
            Element => '#StateIDs',
            Value   => "[1, 4]",
        );
        $Selenium->InputFieldValueSet(
            Element => '#PriorityIDs',
            Value   => "[2, 3]",
        );
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # Check for expected result.
        $Self->Is(
            $Selenium->execute_script("return \$('#EmptyMessage td').text().trim();"),
            $LanguageObject->Translate('No data found.'),
            "Ticket is not found on page",
        );

        # Check search filter data.
        $Self->Is(
            $Selenium->execute_script("return \$('.SearchTerms h2').text().trim();"),
            $LanguageObject->Translate('Search Results for') . ':',
            "Filter data is found - Search Results for:",
        );

        $Self->Is(
            $Selenium->execute_script("return \$('.SearchTerms span:eq(0)').text().trim();"),
            $LanguageObject->Translate('TicketNumber') . ': 123456789012345',
            "Filter data is found - TicketNumber: 123456789012345",
        );

        $Self->Is(
            $Selenium->execute_script("return \$('.SearchTerms span:eq(1)').text().trim();"),
            $LanguageObject->Translate('State') . ': '
                . $LanguageObject->Translate('new') . '+'
                . $LanguageObject->Translate('open'),
            "Filter data is found - State: new+open",
        );

        $Self->Is(
            $Selenium->execute_script("return \$('.SearchTerms span:eq(2)').text().trim();"),
            $LanguageObject->Translate('Priority') . ': '
                . $LanguageObject->Translate('2 low') . '+'
                . $LanguageObject->Translate('3 normal'),
            "Filter data is found - Priority: 2 low+3 normal",
        );

        # Test without customer company ticket access for bug#12595.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerDisableCompanyTicketAccess',
            Value => 1,
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        # Input ticket number as search parameter.
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys( $Ticket{TicketNumber} );
        $Selenium->find_element( "#Submit",       'css' )->VerifiedClick();

        # Check for expected result.
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # Check if pagination is shown correctly when search limit is used. See bug#14556.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::CustomerTicketSearch::SearchLimit',
            Value => 5,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::CustomerTicketSearch::SearchPageShown',
            Value => 2,
        );

        for my $Item ( 1 .. 4 ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => "Title$Item$RandomID",
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerUser => $TestCustomerUserLogin,
                OwnerID      => 1,
                UserID       => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket ID $TicketID - created",
            );
            push @TicketIDs, $TicketID;
        }

        # Navigate to CustomerTicketSearch screen.
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        # Search all tickets.
        $Selenium->find_element( "#TicketNumber", 'css' )->clear();
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys('*');
        $Selenium->find_element( "#Submit",       'css' )->VerifiedClick();

        # Check if pagination shows correct number of displayed tickets.
        $Self->Is(
            $Selenium->execute_script("return \$('.ActionRow .Tabs.Pagination strong').first().text().trim();"),
            "1-2",
            "Pagination displayed correct number of tickets.",
        );
        $Self->Is(
            $Selenium->execute_script("return \$('.ActionRow .Tabs.Pagination .PaginationLimit').text().trim();"),
            "5",
            "Pagination shows correct limit number of tickets.",
        );

        # Check next result page.
        $Selenium->find_element( ".ActionRow .Tabs.Pagination #CustomerTicketSearchPage2", 'css' )->VerifiedClick();
        $Self->Is(
            $Selenium->execute_script("return \$('.ActionRow .Tabs.Pagination strong').first().text().trim();"),
            "3-4",
            "Second result page, pagination shows correct number of tickets.",
        );

        # Check last result page.
        $Selenium->find_element( ".ActionRow .Tabs.Pagination #CustomerTicketSearchPage3", 'css' )->VerifiedClick();
        $Self->Is(
            $Selenium->execute_script("return \$('.ActionRow .Tabs.Pagination strong').first().text().trim();"),
            "5-5",
            "Last result page, pagination shows correct number of tickets.",
        );

        for my $TicketID (@TicketIDs) {

            # Clean up test data from the DB.
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
                "TicketID $TicketID is deleted"
            );
        }

        # Delete test created DynamicField.
        $Success = $DynamicFieldObject->DynamicFieldDelete(
            ID     => $DynamicFieldID,
            UserID => 1,
        );
        $Self->True(
            $DynamicFieldID,
            "DynamicFieldID $DynamicFieldID is deleted",
        );

        # Delete test created customer user.
        $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "CustomerUser $TestCustomerUserLogin is deleted",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw (Ticket CustomerUser)) {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
