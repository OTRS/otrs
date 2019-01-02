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

        # do not check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # do not check Service
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        # do not check Type
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 1,
        );

        my $RandomID = $Helper->GetRandomID();

        # Create test customer user.
        my $TestCustomerUserLogin = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
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

        $Kernel::OM->Get('Kernel::System::CustomerUser')->SetPreferences(
            UserID => $TestCustomerUserLogin,
            Key    => 'UserLanguage',
            Value  => 'en',
        );

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $RandomID,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to CustomerTicketSearch screen
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        # check overview screen
        for my $ID (
            qw(Profile TicketNumber CustomerID From To Cc Subject Body ServiceIDs TypeIDs PriorityIDs StateIDs
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create ticket for test scenario
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

        # Add test article to the ticket.
        #   Make it email-internal, with sender type customer, in order to check if it's filtered out correctly.
        my $InternalArticleMessage = 'not for the customer';
        my $ArticleID              = $TicketObject->ArticleCreate(
            TicketID       => $TicketID,
            ArticleType    => 'email-internal',
            SenderType     => 'customer',
            Subject        => $TitleRandom,
            Body           => $InternalArticleMessage,
            ContentType    => 'text/plain; charset=ISO-8859-15',
            HistoryType    => 'EmailCustomer',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - ID $ArticleID"
        );

        # get test ticket number
        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
        );

        # input ticket number as search parameter
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys( $Ticket{TicketNumber} );
        $Selenium->find_element( "#Submit",       'css' )->VerifiedClick();

        # check for expected result
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # Check if internal article was not shown.
        $Self->True(
            index( $Selenium->get_page_source(), $InternalArticleMessage ) == -1,
            'Internal article not found on page'
        );

        # click on '← Change search options'
        $Selenium->find_element( "← Change search options", 'link_text' )->VerifiedClick();

        # input more search filters, result should be 'No data found'
        $Selenium->find_element( "#TicketNumber", 'css' )->clear();
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys("123456789012345");
        $Selenium->execute_script("\$('#StateIDs').val([1, 4]).trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#PriorityIDs').val([2, 3]).trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Submit", 'css' )->VerifiedClick();

        # check for expected result
        $Self->True(
            index( $Selenium->get_page_source(), "No data found." ) > -1,
            "Ticket is not found on page",
        );

        # check search filter data
        $Self->True(
            index( $Selenium->get_page_source(), "Search Results for:" ) > -1,
            "Filter data is found - Search Results for:",
        );

        $Self->True(
            index( $Selenium->get_page_source(), "TicketNumber: 123456789012345" ) > -1,
            "Filter data is found - TicketNumber: 123456789012345",
        );

        $Self->True(
            index( $Selenium->get_page_source(), "State: new+open" ) > -1,
            "Filter data is found - State: new+open",
        );

        $Self->True(
            index( $Selenium->get_page_source(), "Priority: 2 low+3 normal" ) > -1,
            "Filter data is found - Priority: 2 low+3 normal",
        );

        # Test without customer company ticket access for bug#12595.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerDisableCompanyTicketAccess',
            Value => 1,
        );

        $Selenium->VerifiedGet("${ScriptAlias}customer.pl?Action=CustomerTicketSearch");

        # input ticket number as search parameter
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys( $Ticket{TicketNumber} );
        $Selenium->find_element( "#Submit",       'css' )->VerifiedClick();

        # check for expected result
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # clean up test data from the DB
        my $Success = $TicketObject->TicketDelete(
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
            "Ticket is deleted - $TicketID"
        );

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete test created customer user.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomerUserLogin ],
        );
        $Self->True(
            $Success,
            "CustomerUser $TestCustomerUserLogin is deleted",
        );

        for my $Cache (qw (Ticket CustomerUser)) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
