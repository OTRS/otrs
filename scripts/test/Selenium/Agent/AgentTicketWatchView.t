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

        # enable ticket watcher feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Watcher',
            Value => 1,
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test tickets
        my @TicketIDs;
        for ( 1 .. 3 ) {
            my $TicketID = $TicketObject->TicketCreate(
                Title         => 'Selenium test ticket',
                Queue         => 'Raw',
                Lock          => 'unlock',
                Priority      => '3 normal',
                State         => 'open',
                CustomerID    => 'SeleniumCustomer',
                CustomerUser  => 'SeleniumCustomer@localhost.com',
                OwnerID       => 1,
                UserID        => 1,
                ResponsibleID => 1,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );

            push @TicketIDs, $TicketID;
        }

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        for my $TicketID (@TicketIDs) {

            # go to AgentTicketZoom
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

            # check watcher feature - subscribe ticket to watch it
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketWatcher\' )]")->VerifiedClick();

        }

        # go to AgentTicketWatchView
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketWatchView");

        my $Element = $Selenium->find_element(
            "//a[contains(\@href, \'Action=AgentTicketWatchView;SortBy=Age;OrderBy=Up;View=;Filter=All\' )]"
        );
        $Element->is_enabled();
        $Element->is_displayed();
        $Element->VerifiedClick();

        # check different views for filters
        for my $View (qw(Small Medium Preview)) {

            # click on viewer controller
            $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketWatchView;Filter=All;View=$View;\' )]")
                ->VerifiedClick();

            # check screen output
            $Selenium->find_element( "table",             'css' );
            $Selenium->find_element( "table tbody tr td", 'css' );

            # verify that all tickets are present
            for my $TicketID (@TicketIDs) {

                my $TicketNumber = $TicketObject->TicketNumberLookup(
                    TicketID => $TicketID,
                    UserID   => 1,
                );

                $Self->True(
                    index( $Selenium->get_page_source(), $TicketNumber ) > -1,
                    "Ticket found on page - $TicketNumber ",
                ) || die "Ticket $TicketNumber not found on page";
            }
        }

        # delete created test tickets
        my $Success;
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
                "Ticket is deleted - ID $TicketID"
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
