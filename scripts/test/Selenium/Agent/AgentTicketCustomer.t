# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
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
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # do not check RichText
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
        );

        # do not check service and type
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 0
        );
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Type',
            Value => 0
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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketPhone");

        # get test user ID
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # add test customers for testing
        my @TestCustomers;
        for ( 1 .. 2 )
        {
            my $TestCustomer = 'Customer' . $Helper->GetRandomID();
            my $UserLogin    = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserAdd(
                Source         => 'CustomerUser',
                UserFirstname  => $TestCustomer,
                UserLastname   => $TestCustomer,
                UserCustomerID => $TestCustomer,
                UserLogin      => $TestCustomer,
                UserEmail      => "$TestCustomer\@localhost.com",
                ValidID        => 1,
                UserID         => $TestUserID,
            );

            push @TestCustomers, $TestCustomer;

        }

        # create test phone ticket
        my $AutoCompleteString
            = "\"$TestCustomers[0] $TestCustomers[0]\" <$TestCustomers[0]\@localhost.com> ($TestCustomers[0])";
        my $TicketSubject = "Selenium Ticket";
        my $TicketBody    = "Selenium body test";
        $Selenium->find_element( "#FromCustomer", 'css' )->send_keys( $TestCustomers[0] );
        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length' );

        $Selenium->find_element("//*[text()='$AutoCompleteString']")->click();
        $Selenium->execute_script("\$('#Dest').val('2||Raw').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#Subject",  'css' )->send_keys($TicketSubject);
        $Selenium->find_element( "#RichText", 'css' )->send_keys($TicketBody);

        $Selenium->find_element( "#Subject", 'css' )->submit();

        # Wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return $("form").length' );

        # search for new created ticket on AgentTicketZoom screen
        my %TicketIDs = $Kernel::OM->Get('Kernel::System::Ticket')->TicketSearch(
            Result         => 'HASH',
            Limit          => 1,
            CustomerUserID => $TestCustomers[0],
        );
        my $TicketNumber = (%TicketIDs)[1];
        my $TicketID     = (%TicketIDs)[0];

        $Self->True(
            index( $Selenium->get_page_source(), $TicketNumber ) > -1,
            "Ticket with ticket id $TicketID ($TicketNumber) is created"
        );

        # go to ticket zoom page of created test ticket
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom' )]")->click();

        $Selenium->WaitFor( JavaScript => 'return $("#nav-People ul").css({ "height": "auto", "opacity": "100" });' );

        # go to AgentTicketCustomer
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketCustomer' )]")->click();

        # switch to another window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # set size for small screens, because of sidebar with customer info overflow form for customer data
        $Selenium->set_window_size( 1000, 700 );

        # check AgentTicketCustomer screen
        for my $ID (
            qw(CustomerAutoComplete CustomerID Submit CustomerInfo CustomerTickets)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        $AutoCompleteString
            = "\"$TestCustomers[1] $TestCustomers[1]\" <$TestCustomers[1]\@localhost.com> ($TestCustomers[1])";
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->clear();
        $Selenium->find_element( "#CustomerID",           'css' )->clear();
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->send_keys( $TestCustomers[1] );
        $Selenium->WaitFor( JavaScript => 'return $("li.ui-menu-item:visible").length' );

        $Selenium->find_element("//*[text()='$AutoCompleteString']")->click();

        # wait until customer data is loading (CustomerID is filled after CustomerAutoComplete)
        $Selenium->WaitFor( JavaScript => 'return $("#CustomerID").val().length' );
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->submit();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );
        $Selenium->WaitFor( JavaScript => 'return $("div.MainBox").length' );

        # click on history link and switch window
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");

        # verify that action worked as expected
        my $HistoryText = "CustomerID=$TestCustomers[1];CustomerUser=$TestCustomers[1]";

        $Self->True(
            index( $Selenium->get_page_source(), 'CustomerUpdate' ) > -1,
            "Action AgentTicketCustomer executed correctly",
        );

        # delete created test ticket
        my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket id $TicketID is deleted"
        );

        # delete created test customer users
        for my $TestCustomer (@TestCustomers) {
            my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
            $TestCustomer = $DBObject->Quote($TestCustomer);
            $Success      = $DBObject->Do(
                SQL  => "DELETE FROM customer_user WHERE login = ?",
                Bind => [ \$TestCustomer ],
            );
            $Self->True(
                $Success,
                "Delete customer user - $TestCustomer",
            );
        }

        # make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'CustomerUser' );

    }
);

1;
