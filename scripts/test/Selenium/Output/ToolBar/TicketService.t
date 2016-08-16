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

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # enable tool bar AgentTicketService
        my %AgentTicketQueue = (
            CssClass => 'ServiceView',
            Icon     => 'fa fa-wrench',
            Module   => 'Kernel::Output::HTML::ToolBar::TicketService',
            Priority => '1030035',
        );

        $Helper->ConfigSettingChange(
            Key   => 'Frontend::ToolBarModule###10-Ticket::AgentTicketQueue',
            Value => \%AgentTicketQueue,
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###10-Ticket::AgentTicketQueue',
            Value => \%AgentTicketQueue
        );

        # allows defining services and SLAs for tickets
        $Helper->ConfigSettingChange(
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

        # get user object
        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # get test user ID
        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # create test service
        my $ServiceName = 'Selenium' . $Helper->GetRandomID();
        my $ServiceID   = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(
            Name    => $ServiceName,
            ValidID => 1,
            UserID  => 1,
        );

        $Self->True(
            $ServiceID,
            "Service is created - ID $ServiceID"
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
            ServiceID     => $ServiceID,
            OwnerID       => 1,
            UserID        => $TestUserID,
            ResponsibleID => 1,
        );

        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID"
        );

        # set test user 'My Service' preferences to test service
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentPreferences' )]")->VerifiedClick();
        $Selenium->execute_script("\$('#ServiceID').val('$ServiceID').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#ServiceIDUpdate", 'css' )->VerifiedClick();

        # click on tool bar AgentTicketService
        $Selenium->find_element("//a[contains(\@title, \'Tickets in My Services:\' )]")->VerifiedClick();

        # verify that test is on the correct screen
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');
        my $ExpectedURL = "${ScriptAlias}index.pl?Action=AgentTicketService";

        $Self->True(
            index( $Selenium->get_current_url(), $ExpectedURL ) > -1,
            "ToolBar AgentTicketService shortcut - success",
        );

        # delete test ticket
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Ticket is deleted- $TicketID"
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete personal service from DB
        $Success = $DBObject->Do(
            SQL => "DELETE FROM personal_services WHERE user_id = $TestUserID",
        );
        $Self->True(
            $Success,
            "Deleted personal_service connection",
        );

        # delete test service
        $Success = $DBObject->Do(
            SQL => "DELETE FROM service WHERE id = $ServiceID",
        );
        $Self->True(
            $Success,
            "Service is deleted - ID $ServiceID",
        );

        # make sure the cache is correct
        for my $Cache (
            qw (Ticket Service)
            )
        {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
