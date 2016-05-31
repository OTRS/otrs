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
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # set fixed time for test purposes
        $Helper->FixedTimeSet(
            $Kernel::OM->Get('Kernel::System::Time')->TimeStamp2SystemTime( String => '2014-12-12 00:00:00' ),
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['users'],
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

        # create test queue
        my $QueueName = "Queue" . $Helper->GetRandomID();
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => 1,
            SolutionTime    => 1,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => $TestUserID,
        );
        $Self->True(
            $QueueID,
            "Queue is created - ID $QueueID",
        );

        # get config object
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentPreferences screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences");

        # set MyQueue preferences
        $Selenium->execute_script("\$('#QueueID').val('$QueueID').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#QueueIDUpdate", 'css' )->VerifiedClick();

        # navigate to AgentDashboard screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            QueueID      => $QueueID,
            Lock         => 'lock',
            Priority     => '3 normal',
            State        => 'pending reminder',
            CustomerID   => '123465',
            CustomerUser => 'customer@example.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # wait 5 minutes to have escalation trigger
        $Helper->FixedTimeAddSeconds(300);

        # create test params
        my @Test = ( "0100-TicketPendingReminder", "0110-TicketEscalation", "0120-TicketNew", "0130-TicketOpen" );

        # test if ticket is shown in each dashboard ticket generic plugin
        for my $DashboardName (@Test) {

            # set ticket state depending on the stage in test
            if ( $DashboardName eq '0120-TicketNew' ) {
                my $Success = $TicketObject->TicketStateSet(
                    State    => 'new',
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );
                $Self->True(
                    $Success,
                    "Changed ticket state to - New"
                );
            }
            if ( $DashboardName eq '0130-TicketOpen' ) {
                my $Success = $TicketObject->TicketStateSet(
                    State    => 'open',
                    TicketID => $TicketID,
                    UserID   => $TestUserID,
                );
                $Self->True(
                    $Success,
                    "Changed ticket state to - Open"
                );
            }

            # get sysconfig object
            my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

            # disable all dashboard plugins
            my $Config = $ConfigObject->Get('DashboardBackend');
            $SysConfigObject->ConfigItemUpdate(
                Valid => 0,
                Key   => 'DashboardBackend',
                Value => \%$Config,
            );

            # enable current needed dashboard plugin sysconfig
            $SysConfigObject->ConfigItemReset(
                Name => "DashboardBackend###" . $DashboardName,
            );

            # refresh dashboard screen and clean it's cache
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => 'Dashboard',
            );

            $Selenium->VerifiedRefresh();

            # click settings wheel
            $Selenium->execute_script("\$('#Dashboard$DashboardName-toggle').trigger('click');");

            # set Priority on visible
            $Selenium->execute_script(
                "\$('.ColumnsJSON').val('{\"Columns\":{\"Priority\":1},\"Order\":[\"Priority\"]}');"
            );

            # submit
            $Selenium->execute_script( "\$('#Dashboard$DashboardName" . "_submit').trigger('click');" );

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('th.Priority #PriorityOverviewControl$DashboardName').length"
            );

            # sort by Priority
            $Selenium->execute_script("\$('th.Priority #PriorityOverviewControl$DashboardName').trigger('click');");

            # wait for AJAX to finish
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $(".DashboardHeader.Priority.SortAscendingLarge").length'
            );

            # validate that Priority sort is working
            $Self->True(
                $Selenium->find_element( ".DashboardHeader.Priority.SortAscendingLarge", 'css' ),
                "Priority sort is working",
            );

            # set filter by MyQueue
            my $Filter = "#Dashboard$DashboardName" . "MyQueues";
            $Selenium->WaitFor( JavaScript => "return \$('$Filter:visible').length" );
            $Selenium->find_element( $Filter, 'css' )->VerifiedClick();

            # check for test ticket on current dashboard plugin
            $Self->True(
                index( $Selenium->get_page_source(), "Action=AgentTicketZoom;TicketID=$TicketID" ) > -1,
                "$DashboardName dashboard plugin test ticket link - found",
            );

        }

        # delete test tickets
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Ticket is deleted - ID $TicketID"
        );

        # get DB object
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # delete MyQueue from personal_queues
        $Success = $DBObject->Do(
            SQL => "DELETE FROM personal_queues WHERE queue_id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete MyQueue from personal_queues - ID $QueueID",
        );

        # delete test queue
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Queue is deleted - ID $QueueID",
        );

        # make sure cache is correct
        for my $Cache (qw(Ticket Queue Dashboard DashboardQueueOverview )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
