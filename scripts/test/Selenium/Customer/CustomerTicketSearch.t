# --
# Copyright (C) 2001-2016 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
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

        # create test customer user and login
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
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
        my $TitleRandom = 'Title' . $Helper->GetRandomID();
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

        # get test ticket number
        my %Ticket = $TicketObject->TicketGet(
            TicketID => $TicketID,
        );

        # input ticket number as search parameter
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys( $Ticket{TicketNumber} );
        $Selenium->find_element( "#TicketNumber", 'css' )->VerifiedSubmit();

        # check for expected result
        $Self->True(
            index( $Selenium->get_page_source(), $TitleRandom ) > -1,
            "Ticket $TitleRandom found on page",
        );

        # click on '← Change search options'
        $Selenium->find_element( "← Change search options", 'link_text' )->VerifiedClick();

        # input more search filters, result should be 'No data found'
        $Selenium->find_element( "#TicketNumber", 'css' )->clear();
        $Selenium->find_element( "#TicketNumber", 'css' )->send_keys("123456789012345");
        $Selenium->execute_script("\$('#StateIDs').val([1, 4]).trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#PriorityIDs').val([2, 3]).trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#TicketNumber", 'css' )->VerifiedSubmit();

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

        # clean up test data from the DB
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket is deleted - $TicketID"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
