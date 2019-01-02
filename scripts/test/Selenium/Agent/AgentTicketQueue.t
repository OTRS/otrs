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

        # get needed objects
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # do not check email addresses
        $Helper->ConfigSettingChange(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # Create test user and login.
        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users' ],
            Language => $Language,
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

        my $QueueObject = $Kernel::OM->Get('Kernel::System::Queue');

        # create test queue
        my @QueueIDs;
        my $QueueName = 'Queue' . $Helper->GetRandomID();
        my $QueueID   = $QueueObject->QueueAdd(
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
            "QueueAdd() successful for test $QueueName - ID $QueueID",
        );
        push @QueueIDs, $QueueID;

        # create test queue 'Delete'
        my $QueueDeleteID = $QueueObject->QueueLookup( Queue => 'Delete' );
        if ( !defined $QueueDeleteID ) {
            $QueueDeleteID = $QueueObject->QueueAdd(
                Name            => 'Delete',
                ValidID         => 1,
                GroupID         => 1,
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                Comment         => 'Selenium Queue',
                UserID          => $TestUserID,
            );
            $Self->True(
                $QueueDeleteID,
                "QueueAdd() successful for test queue 'Delete' - ID $QueueDeleteID",
            );
            push @QueueIDs, $QueueDeleteID;
        }

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
            },
            {
                Queue   => 'Delete',
                QueueID => $QueueDeleteID,
                Lock    => 'unlock'
            }
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # create test tickets
        my @TicketIDs;
        for my $TicketCreate (@Tests) {
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

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentTicketQueue screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketQueue");

        # verify that there is no tickets with My Queue filter
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketQueue;QueueID=0;\' )]")->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), $LanguageObject->Translate('No ticket data found.') ) > -1,
            'No tickets found with My Queue filters',
        );

        # return to default queue view
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketQueue;View=Small");

        # test if tickets show with appropriate filters
        for my $Test (@Tests) {

            # check for Queue filter buttons (Postmaster / Raw / Junk / Misc / QueueTest)
            my $Element = $Selenium->find_element(
                "//a[contains(\@href, \'Action=AgentTicketQueue;QueueID=$Test->{QueueID};\' )]"
            );
            $Element->is_enabled();
            $Element->is_displayed();
            $Element->VerifiedClick();

            # check different views for filters
            for my $View (qw(Small Medium Preview)) {

                # return to default small view
                $Selenium->VerifiedGet(
                    "${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$Test->{QueueID};SortBy=Age;OrderBy=Down;View=Small"
                );

                # click on viewer controller
                $Selenium->find_element(
                    "//a[contains(\@href, \'Action=AgentTicketQueue;Filter=Unlocked;View=$View;QueueID=$Test->{QueueID};SortBy=Age;OrderBy=Down;View=Small;\' )]"
                )->VerifiedClick();

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

        # Go to small view for 'Delete' queue.
        # See Bug 13826 - Queue Names are translated (but should not)
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketQueue;QueueID=$QueueDeleteID;View=Small;Filter=Unlocked"
        );

        $Self->Is(
            $Selenium->execute_script("return \$('.OverviewBox.Small h1').text().trim();"),
            $LanguageObject->Translate('QueueView') . ": Delete",
            "Title for filtered AgentTicketQueue screen is not transleted.",
        );

        # delete created test tickets
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

        # delete created test queue
        for my $QueueDelete (@QueueIDs) {

            $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => "DELETE FROM queue WHERE id = $QueueDelete",
            );
            $Self->True(
                $Success,
                "Delete queue - ID $QueueDelete",
            );
        }

        # make sure the cache is correct
        for my $Cache (
            qw (Ticket Queue)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
