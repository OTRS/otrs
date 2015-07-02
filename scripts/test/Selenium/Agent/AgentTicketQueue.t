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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

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

        # create test queue
        my $QueueName = 'Queue' . $Helper->GetRandomID();
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => $TestUserID,
        );
        $Self->True(
            $QueueID,
            "QueueAdd() successful for test $QueueName ID $QueueID",
        );

        # create params for test tickets
        my @Tests = (
            {
                Queue   => 'Postmaster',
                QueueID => 1,
                Lock    => 'unlock',
            },
            {
                Queue   => 'Raw',
                QueueID => 2,
                Lock    => 'unlock',
            },
            {
                Queue   => 'Junk',
                QueueID => 3,
                Lock    => 'lock',
            },
            {
                Queue   => 'Misc',
                QueueID => 4,
                Lock    => 'lock',
            },
            {
                Queue   => $QueueName,
                QueueID => $QueueID,
                Lock    => 'unlock'
            }
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        for my $TicketCreate (@Tests) {
            my $TicketID = $TicketObject->TicketCreate(
                Title         => 'Selenium Test Ticket',
                Queue         => $TicketCreate->{Queue},
                Lock          => $TicketCreate->{Lock},
                Priority      => '3 normal',
                State         => 'open',
                CustomerID    => $TestCustomer,
                CustomerUser  => "$TestCustomer\@localhost.com",
                OwnerID       => $TestUserID,
                UserID        => $TestUserID,
                ResponsibleID => $TestUserID,
            );

            $Self->True(
                $TicketID,
                "Ticket is create - $TicketID",
            );

            push @TicketIDs, $TicketID;

        }

        # go to AgentTicketQueue
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketQueue");

        # verify that there is no tickets with My Queue filter
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketQueue;QueueID=0;\' )]")->click();
        $Self->True(
            index( $Selenium->get_page_source(), 'No ticket data found.' ) > -1,
            "No tickets found with My Queue filters",
        );

        # return to default queue view
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketQueue;View=Small");

        # test if tickets show with appropriate filters
        for my $Test (@Tests) {

            # check for Queue filter buttons (Postmaster / Raw / Junk / Misc / QueueTest)
            my $Element = $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicketQueue;QueueID=$Test->{QueueID};\' )]"
            );
            $Element->is_enabled();
            $Element->is_displayed();
            $Element->click();

            # check different views for filters
            for my $View (qw(Small Medium Preview)) {

                # return to default small view
                $Selenium->get(
                    "${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$Test->{QueueID};SortBy=Age;OrderBy=Down;View=Small"
                );

                # click on viewer controler
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentTicketQueue;Filter=Unlocked;View=$View;QueueID=$Test->{QueueID};SortBy=Age;OrderBy=Down;View=Small;\' )]"
                )->click();

                # verify that all expected tickets are present
                for my $TicketID (@TicketIDs) {

                    my %TicketData = $TicketObject->TicketGet(
                        TicketID => $TicketID,
                        UserID   => $TestUserID,
                    );

                    # check for locked and unlocked tickets
                    if ( $Test->{Lock} eq 'lock' ) {

                        # for locked tickets we expect no data to be found with 'Available tickets' filter on
                        $Self->True(
                            index( $Selenium->get_page_source(), $TicketData{TicketNumber} ) == -1,
                            "Ticket is not found on page - $TicketData{TicketNumber}",
                        );

                    }

                    elsif ( ( $TicketData{Lock} eq 'unlock' ) && ( $TicketData{QueueID} eq $Test->{QueueID} ) ) {

                        # check for tickets with 'Available tickets' filter on
                        $Self->True(
                            index( $Selenium->get_page_source(), $TicketData{TicketNumber} ) > -1,
                            "Ticket is found on page - $TicketData{TicketNumber} ",
                        );
                    }
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

        # delete created test queue
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete queue - $QueueID",
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
            qw (Ticket CustomerUser Queue)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
