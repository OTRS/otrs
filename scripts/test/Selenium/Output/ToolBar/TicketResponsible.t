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

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable ticket responsible feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Responsible',
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

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title         => 'Selenium test ticket',
            Queue         => 'Raw',
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'open',
            CustomerID    => 'SeleniumCustomerID',
            CustomerUser  => 'test@localhost.com',
            OwnerID       => 1,
            UserID        => 1,
            ResponsibleID => $TestUserID,
        );

        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID"
        );

        # refresh dashboard page
        $Selenium->VerifiedRefresh();

        # click on tool bar AgentTicketResponsibleView
        $Selenium->find_element("//a[contains(\@title, \'Responsible Tickets Total:\' )]")->VerifiedClick();

        # verify that test is on the correct screen
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        my $ExpectedURL = "${ScriptAlias}index.pl?Action=AgentTicketResponsibleView";

        $Self->True(
            index( $Selenium->get_current_url(), $ExpectedURL ) > -1,
            "ToolBar AgentTicketResponsibleView shortcut - success",
        );

        # delete test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
        }
        $Self->True(
            $Success,
            "Ticket is deleted - ID $TicketID"
        );
    }
);

1;
