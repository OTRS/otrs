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

        # enable ticket service feature
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1
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
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # add test customer for testing
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

        # create service for test
        my $SrviceName = 'Service' . $Helper->GetRandomID();
        my $ServiceID  = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(
            Name    => $SrviceName,
            ValidID => 1,
            Comment => 'Selenium Test',
            UserID  => $TestUserID,
        );
        $Self->True(
            $ServiceID,
            "Service is created - $ServiceID",
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        for my $Lock (qw( lock unlock)) {
            my $TicketID = $TicketObject->TicketCreate(
                Title         => 'Selenium Test Ticket',
                Queue         => 'Raw',
                Lock          => $Lock,
                Priority      => '3 normal',
                State         => 'open',
                ServiceID     => $ServiceID,
                CustomerID    => $TestCustomer,
                CustomerUser  => "$TestCustomer\@localhost.com",
                OwnerID       => $TestUserID,
                UserID        => $TestUserID,
                ResponsibleID => $TestUserID,
            );

            $Self->True(
                $TicketID,
                "Ticket is created - $TicketID",
            );

            push @TicketIDs, $TicketID;

        }

        # go to AgentTicketService
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketService");

        # verify that there are no tickets with My Service filter
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketService;ServiceID=0;\' )]")->click();
        $Self->True(
            index( $Selenium->get_page_source(), 'No ticket data found.' ) > -1,
            "No tickets found with My Service filter",
        );

        # check for test service filter button
        my $Element = $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicketService;ServiceID=$ServiceID;\' )]"
        );
        $Element->is_enabled();
        $Element->is_displayed();
        $Element->click();

        # check different views for filters
        for my $View (qw(Small Medium Preview)) {

            # go to default small view
            $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketService;ServiceID=$ServiceID;View=Small");

            # click on viewer controler
            $Selenium->find_element(
                "//a[contains(\@href, \'Filter=Unlocked;View=$View;ServiceID=$ServiceID;SortBy=Age;OrderBy=Up;View=Small;\' )]"
            )->click();

            # verify that all expected tickets are present
            for my $TicketID (@TicketIDs) {

                my %TicketData = $TicketObject->TicketGet(
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );

                # check for locked and unlocked tickets
                if ( $TicketData{Lock} eq 'unlock' ) {

                    # click on 'Available ticket' filter
                    $Selenium->find_element(
                        "//a[contains(\@href, \'ServiceID=$ServiceID;SortBy=Age;OrderBy=Up;View=$View;Filter=Unlocked\' )]"
                    )->click();

                    # check for unlocked tickets with 'Available tickets' filter on
                    $Self->True(
                        index( $Selenium->get_page_source(), $TicketData{TicketNumber} ) > -1,
                        "Ticket found on page with 'Available tickets' filter - $TicketData{TicketNumber} ",
                    );

                    # click on 'All ticket' filter
                    $Selenium->find_element(
                        "//a[contains(\@href, \'ServiceID=$ServiceID;SortBy=Age;OrderBy=Up;View=$View;Filter=All\' )]"
                    )->click();

                    # check for unlocked tickets with 'All tickets' filter on
                    $Self->True(
                        index( $Selenium->get_page_source(), $TicketData{TicketNumber} ) > -1,
                        "Ticket found on page with 'All tickets' filter on - $TicketData{TicketNumber} ",
                    );
                }
                else {

                    # click on 'All ticket' filter
                    $Selenium->find_element(
                        "//a[contains(\@href, \'ServiceID=$ServiceID;SortBy=Age;OrderBy=Up;View=$View;Filter=All\' )]"
                    )->click();

                    # check for locked tickets with  'All ticket' filter
                    $Self->True(
                        index( $Selenium->get_page_source(), $TicketData{TicketNumber} ) > -1,
                        "Locked Ticket found on page with 'All tickets' filter on - $TicketData{TicketNumber} ",
                    );

                    # click on 'Available ticket' filter
                    $Selenium->find_element(
                        "//a[contains(\@href, \'ServiceID=$ServiceID;SortBy=Age;OrderBy=Up;View=$View;Filter=Unlocked\' )]"
                    )->click();

                    # check for locked tickets with 'Available tickets' filter on
                    $Self->True(
                        index( $Selenium->get_page_source(), $TicketData{TicketNumber} ) == -1,
                        "Did not find locked ticket - $TicketData{TicketNumber} - with 'Available tickets' filter",
                    );
                }
            }
        }

        # delete created test tickets
        my $Success;
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "Delete ticket - $TicketID"
            );
        }

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete created test service
        $Success = $DBObject->Do(
            SQL => "DELETE FROM service WHERE id = $ServiceID",
        );
        $Self->True(
            $Success,
            "Delete service - $ServiceID",
        );

        # delete created test customer user
        $TestCustomer = $DBObject->Quote($TestCustomer);
        $Success      = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomer ],
        );
        $Self->True(
            $Success,
            "Delete customer user - $TestCustomer",
        );

        # make sure the cache is correct.
        for my $Cache (
            qw (Ticket CustomerUser Service)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

        }
);

1;
