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

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Do not check email addresses.
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Change settings Ticket::Frontend::AgentTicketQueue###VisualAlarms to 'Yes'.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###VisualAlarms',
            Value => 1,
        );

        # Change settings Ticket::Frontend::AgentTicketQueue###Blink to 'Yes'.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###Blink',
            Value => 1,
        );

        # Change settings Ticket::Frontend::AgentTicketQueue###HighlightAge1 to 10 minutes.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###HighlightAge1',
            Value => 10,
        );

        # Change settings Ticket::Frontend::AgentTicketQueue###HighlightAge2 to 10 minutes.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketQueue###HighlightAge2',
            Value => 20,
        );

        # Create test user and login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test queues.
        my @Queues;
        for ( 1 .. 2 ) {
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

            push @Queues,
                {
                QueueName => $QueueName,
                QueueID   => $QueueID,
                },
        }

        # Set fixed time to test Visual alarms
        my $FixedTime = $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch();

        # Create params for test tickets
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
                Queue        => $Queues[0]->{QueueName},
                QueueID      => $Queues[0]->{QueueID},
                Lock         => 'unlock',
                FixedTimeSet => $FixedTime - 10 * 60 - 100,
            },
            {
                Queue        => $Queues[1]->{QueueName},
                QueueID      => $Queues[1]->{QueueID},
                Lock         => 'unlock',
                FixedTimeSet => $FixedTime - 20 * 60 - 100,
            }
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test tickets.
        my @TicketIDs;
        for my $TicketCreate (@Tests) {

            $Helper->FixedTimeSet( $TicketCreate->{FixedTimeSet} ) if defined $TicketCreate->{FixedTimeSet};

            my $TicketID = $TicketObject->TicketCreate(
                Title         => 'Selenium Test Ticket',
                Queue         => $TicketCreate->{Queue},
                Lock          => $TicketCreate->{Lock},
                Priority      => '3 normal',
                State         => 'open',
                CustomerID    => 'SeleniumCustomer',
                CustomerUser  => 'SeleniumCustomer@localhost.com',
                OwnerID       => $TestUserID,
                UserID        => $TestUserID,
                ResponsibleID => $TestUserID,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );

            push @TicketIDs, $TicketID;

        }

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AgentTicketQueue screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketQueue");

        # Check Blink visual alarm - Oldest class.
        $Self->True(
            $Selenium->find_element( '.Oldest', 'css' ),
            "Visual alarm Blink is found - Oldest class",
        );

        # Check HighlightAge1 visual alarm - OlderLevel2 class.
        $Self->True(
            $Selenium->find_element( '.OlderLevel1', 'css' ),
            "Visual alarm HighlightAge1 is found - OlderLevel2 class",
        );

        # Check HighlightAge2 visual alarm - OlderLevel2 class.
        $Self->True(
            $Selenium->find_element( '.OlderLevel2', 'css' ),
            "Visual alarm HighlightAge2 is found - OlderLevel2 class",
        );

        # Verify that there is no tickets with My Queue filter.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketQueue;QueueID=0;\' )]")->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), 'No ticket data found.' ) > -1,
            "No tickets found with My Queue filters",
        );

        # Return to default queue view.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketQueue;View=Small");

        # Test if tickets show with appropriate filters.
        for my $Test (@Tests) {

            # Check for Queue filter buttons (Postmaster / Raw / Junk / Misc / QueueTest).
            my $Element = $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicketQueue;QueueID=$Test->{QueueID};\' )]"
            );
            $Element->is_enabled();
            $Element->is_displayed();
            $Element->VerifiedClick();

            # Check different views for filters.
            for my $View (qw(Small Medium Preview)) {

                # Return to default small view.
                $Selenium->VerifiedGet(
                    "${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$Test->{QueueID};SortBy=Age;OrderBy=Down;View=Small"
                );

                # Click on viewer controller.
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentTicketQueue;Filter=Unlocked;View=$View;QueueID=$Test->{QueueID};SortBy=Age;OrderBy=Down;View=Small;\' )]"
                )->VerifiedClick();

                # Verify that all expected tickets are present.
                for my $TicketID (@TicketIDs) {

                    my %TicketData = $TicketObject->TicketGet(
                        TicketID => $TicketID,
                        UserID   => $TestUserID,
                    );

                    # Check for locked and unlocked tickets.
                    if ( $Test->{Lock} eq 'lock' ) {

                        # For locked tickets we expect no data to be found with 'Available tickets' filter on.
                        $Self->True(
                            index( $Selenium->get_page_source(), $TicketData{TicketNumber} ) == -1,
                            "Ticket is not found on page - $TicketData{TicketNumber}",
                        );

                    }

                    elsif ( ( $TicketData{Lock} eq 'unlock' ) && ( $TicketData{QueueID} eq $Test->{QueueID} ) ) {

                        # Check for tickets with 'Available tickets' filter on.
                        $Self->True(
                            index( $Selenium->get_page_source(), $TicketData{TicketNumber} ) > -1,
                            "Ticket is found on page - $TicketData{TicketNumber} ",
                        );
                    }
                }
            }
        }

        # Delete created test tickets.
        my $Success;
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "Delete ticket - ID $TicketID"
            );
        }

        # Delete created test queue.
        for my $Queue (@Queues) {
            $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => "DELETE FROM queue WHERE id = $Queue->{QueueID}",
            );
            $Self->True(
                $Success,
                "Delete queue - ID $Queue->{QueueID}",
            );
        }

        # Make sure the cache is correct.
        for my $Cache (
            qw (Ticket Queue)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

        # Unset fixed time.
        $Helper->FixedTimeUnset();

    }
);

1;
