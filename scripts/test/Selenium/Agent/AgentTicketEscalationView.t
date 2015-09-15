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

        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Use a calendar with the same business hours for every day so that the UT runs correctly
        #   on every day of the week and outside usual business hours.
        my %Week;
        my @Days = qw(Sun Mon Tue Wed Thu Fri Sat);
        for my $Day (@Days) {
            $Week{$Day} = [ 0 .. 23 ];
        }
        $Kernel::OM->Get('Kernel::Config')->Set(
            Key   => 'TimeWorkingHours',
            Value => \%Week,
        );
        $Kernel::OM->Get('Kernel::System::SysConfig')->ConfigItemUpdate(
            Valid => 1,
            Key   => 'TimeWorkingHours',
            Value => \%Week,
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

        # create params for test tickets
        my @Tests = (

            # default callendar is used for test
            # create queue that will escalate tickets in 1 working hour
            {
                Name         => 'Today',
                Queue        => "Queue" . $Helper->GetRandomID(),
                SolutionTime => 1 * 60,
            },

            # create queue that will escalate tickets in 24 working hours
            {
                Name         => 'Tomorrow',
                Queue        => "Queue" . $Helper->GetRandomID(),
                SolutionTime => 24 * 60,
            },

            # create queue that will escalate tickets in 1 working week
            {
                Name         => 'NextWeek',
                Queue        => "Queue" . $Helper->GetRandomID(),
                SolutionTime => 7 * 24 * 60,
            },

            # create queue that will escalate tickets in 2 working weeks
            {
                Name         => 'AfterNextWeek',
                Queue        => "Queue" . $Helper->GetRandomID(),
                SolutionTime => 14 * 24 * 60,
            },
        );

        # add test queue with escalation timers
        my @QueueIDs;
        for my $QueueCreate (@Tests) {
            my $QueueID = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
                Name            => $QueueCreate->{Queue},
                ValidID         => 1,
                GroupID         => 1,
                SolutionTime    => $QueueCreate->{SolutionTime},
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                Comment         => 'Selenium Queue',
                UserID          => $TestUserID,
            );

            $Self->True(
                $QueueID,
                "QueueAdd() successful for test $QueueCreate->{Queue} ID $QueueID",
            );

            push @QueueIDs, $QueueID;
        }

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        my $Tickets;
        for my $TicketCreate (@Tests) {
            my $TicketID = $TicketObject->TicketCreate(
                Title        => 'Selenium Test Ticket',
                Queue        => $TicketCreate->{Queue},
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'open',
                CustomerID   => $TestCustomer,
                CustomerUser => "$TestCustomer\@localhost.com",
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );

            $Self->True(
                $TicketID,
                "Ticket is created - $TicketID",
            );

            push @TicketIDs, $TicketID;

            # set helper parameter for verifying on what view certain tickets are expected
            $Tickets->{$TicketID} = $TicketCreate->{Name};

        }

        # go to AgentTicketEscalationView
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketEscalationView;SortBy=TicketNumber;OrderBy=Down");

        for my $Test (@Tests) {

            # for ticket in queue that escalate in more then 1 week we want filter to be NextWeek
            my $Filter = $Test->{Name};
            if ( $Test->{Name} eq 'AfterNextWeek' ) {
                $Filter = 'NextWeek';
            }

            # check for escalation filter buttons (Today / Tomorrow / NextWeek)
            my $Element = $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicketEscalationView;SortBy=TicketNumber;OrderBy=Down;View=;Filter=$Filter\' )]"
            );
            $Element->is_enabled();
            $Element->is_displayed();
            $Element->click();

            # check different views
            for my $View (qw(Small Medium Preview)) {

                # switch to view with correct sorting
                $Selenium->get(
                    "${ScriptAlias}index.pl?Action=AgentTicketEscalationView;SortBy=TicketNumber;OrderBy=Down;Filter=$Filter;View=$View"
                );

                # check screen output
                $Selenium->find_element( "table",             'css' );
                $Selenium->find_element( "table tbody tr td", 'css' );

                # verify that all tickets there are present
                for my $TicketID (@TicketIDs) {

                    if ( ( $Tickets->{$TicketID} eq $Test->{Name} ) ) {

                        my $TicketNumber = $TicketObject->TicketNumberLookup(
                            TicketID => $TicketID,
                            UserID   => $TestUserID,
                        );

                        if ( $Test->{Name} ne 'AfterNextWeek' ) {

                            $Self->True(
                                index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                                "$Test->{Name}/$View: Ticket is found on page - $TicketNumber ",
                            );
                        }
                        else {

                    # test created ticket that escalate in more then 1 week and therefore shouldn't be visible on screen
                            $Self->True(
                                index( $Selenium->get_page_source(), $TicketNumber ) == -1,
                                "$Test->{Name}/$View: Ticket is not found on page - $TicketNumber ",
                            );
                        }

                    }
                }
            }

            # switch back to AgentTicketEscalationView
            $Selenium->get("${ScriptAlias}index.pl?Action=AgentTicketEscalationView;SortBy=TicketNumber;OrderBy=Down");
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
        for my $QueueID (@QueueIDs) {
            $Success = $DBObject->Do(
                SQL => "DELETE FROM queue WHERE id = $QueueID",
            );
            $Self->True(
                $Success,
                "Delete queue - $QueueID",
            );
        }

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
