# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## no critic (Modules::RequireExplicitPackage)
use strict;
use warnings;
use utf8;

use vars (qw($Self));

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Set fixed time for test purposes.
        $Helper->FixedTimeSet(
            $Kernel::OM->Create(
                'Kernel::System::DateTime',
                ObjectParams => {
                    String => '2014-12-12 00:00:00'
                }
            )->ToEpoch(),
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['users'],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test queue.
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

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # Navigate to AgentPreferences screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=NotificationSettings"
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => '#QueueID',
            Event       => 'change',
        );

        # Set MyQueue preferences.
        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => $QueueID,
        );

        $Self->True(
            $Selenium->execute_script("return \$('#QueueID').val() == $QueueID;"),
            "Queue is set to $QueueID",
        );

        # Save the setting, wait for the ajax call to finish and check if success sign is shown.
        $Selenium->execute_script(
            "\$('#QueueID').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#QueueID').closest('.WidgetSimple').find('.fa-check').length;"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#QueueID').closest('.WidgetSimple').hasClass('HasOverlay');"
        );

        # Navigate to AgentDashboard screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # Create test ticket.
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

        # Discard TicketObject to let event handlers run also for transaction mode 1.
        $Kernel::OM->ObjectsDiscard(
            Objects => ['Kernel::System::Ticket']
        );

        # Wait 5 minutes to have escalation trigger.
        $Helper->FixedTimeAddSeconds(300);

        my %Configs = (
            '0100-TicketPendingReminder' => {
                'Attributes' =>
                    'TicketPendingTimeOlderMinutes=1;StateType=pending reminder;SortBy=PendingTime;OrderBy=Down;',
                'Block'          => 'ContentLarge',
                'CacheTTLLocal'  => '0.5',
                'Default'        => '1',
                'DefaultColumns' => {
                    'Age'                    => '2',
                    'Changed'                => '1',
                    'Created'                => '1',
                    'CustomerCompanyName'    => '1',
                    'CustomerID'             => '1',
                    'CustomerName'           => '1',
                    'CustomerUserID'         => '1',
                    'EscalationResponseTime' => '1',
                    'EscalationSolutionTime' => '1',
                    'EscalationTime'         => '1',
                    'EscalationUpdateTime'   => '1',
                    'Lock'                   => '1',
                    'Owner'                  => '1',
                    'PendingTime'            => '1',
                    'Priority'               => '1',
                    'Queue'                  => '1',
                    'Responsible'            => '1',
                    'SLA'                    => '1',
                    'Service'                => '1',
                    'State'                  => '1',
                    'TicketNumber'           => '2',
                    'Title'                  => '2',
                    'Type'                   => '1'
                },
                'Description' => 'All tickets with a reminder set where the reminder date has been reached',
                'Filter'      => 'Locked',
                'Group'       => '',
                'Limit'       => '10',
                'Module'      => 'Kernel::Output::HTML::Dashboard::TicketGeneric',
                'Permission'  => 'rw',
                'Time'        => 'UntilTime',
                'Title'       => 'Reminder Tickets'
            },
            '0110-TicketEscalation' => {
                'Attributes'     => 'TicketEscalationTimeOlderMinutes=1;SortBy=EscalationTime;OrderBy=Down;',
                'Block'          => 'ContentLarge',
                'CacheTTLLocal'  => '0.5',
                'Default'        => '1',
                'DefaultColumns' => {
                    'Age'                    => '2',
                    'Changed'                => '1',
                    'Created'                => '1',
                    'CustomerCompanyName'    => '1',
                    'CustomerID'             => '1',
                    'CustomerName'           => '1',
                    'CustomerUserID'         => '1',
                    'EscalationResponseTime' => '1',
                    'EscalationSolutionTime' => '1',
                    'EscalationTime'         => '1',
                    'EscalationUpdateTime'   => '1',
                    'Lock'                   => '1',
                    'Owner'                  => '1',
                    'PendingTime'            => '1',
                    'Priority'               => '1',
                    'Queue'                  => '1',
                    'Responsible'            => '1',
                    'SLA'                    => '1',
                    'Service'                => '1',
                    'State'                  => '1',
                    'TicketNumber'           => '2',
                    'Title'                  => '2',
                    'Type'                   => '1'
                },
                'Description' => 'All escalated tickets',
                'Filter'      => 'All',
                'Group'       => '',
                'Limit'       => '10',
                'Module'      => 'Kernel::Output::HTML::Dashboard::TicketGeneric',
                'Permission'  => 'rw',
                'Time'        => 'EscalationTime',
                'Title'       => 'Escalated Tickets'
            },
            '0120-TicketNew' => {
                'Attributes'     => 'StateType=new',
                'Block'          => 'ContentLarge',
                'CacheTTLLocal'  => '0.5',
                'Default'        => '1',
                'DefaultColumns' => {
                    'Age'                    => '2',
                    'Changed'                => '1',
                    'Created'                => '1',
                    'CustomerCompanyName'    => '1',
                    'CustomerID'             => '1',
                    'CustomerName'           => '1',
                    'CustomerUserID'         => '1',
                    'EscalationResponseTime' => '1',
                    'EscalationSolutionTime' => '1',
                    'EscalationTime'         => '1',
                    'EscalationUpdateTime'   => '1',
                    'Lock'                   => '1',
                    'Owner'                  => '1',
                    'PendingTime'            => '1',
                    'Priority'               => '1',
                    'Queue'                  => '1',
                    'Responsible'            => '1',
                    'SLA'                    => '1',
                    'Service'                => '1',
                    'State'                  => '1',
                    'TicketNumber'           => '2',
                    'Title'                  => '2',
                    'Type'                   => '1'
                },
                'Description' => 'All new tickets, these tickets have not been worked on yet',
                'Filter'      => 'All',
                'Group'       => '',
                'Limit'       => '10',
                'Module'      => 'Kernel::Output::HTML::Dashboard::TicketGeneric',
                'Permission'  => 'rw',
                'Time'        => 'Age',
                'Title'       => 'New Tickets'
            },
            '0130-TicketOpen' => {
                'Attributes'     => 'StateType=open',
                'Block'          => 'ContentLarge',
                'CacheTTLLocal'  => '0.5',
                'Default'        => '1',
                'DefaultColumns' => {
                    'Age'                    => '2',
                    'Changed'                => '1',
                    'Created'                => '1',
                    'CustomerCompanyName'    => '1',
                    'CustomerID'             => '1',
                    'CustomerName'           => '1',
                    'CustomerUserID'         => '1',
                    'EscalationResponseTime' => '1',
                    'EscalationSolutionTime' => '1',
                    'EscalationTime'         => '1',
                    'EscalationUpdateTime'   => '1',
                    'Lock'                   => '1',
                    'Owner'                  => '1',
                    'PendingTime'            => '1',
                    'Priority'               => '1',
                    'Queue'                  => '1',
                    'Responsible'            => '1',
                    'SLA'                    => '1',
                    'Service'                => '1',
                    'State'                  => '1',
                    'TicketNumber'           => '2',
                    'Title'                  => '2',
                    'Type'                   => '1'
                },
                'Description' => 'All open tickets, these tickets have already been worked on, but need a response',
                'Filter'      => 'All',
                'Group'       => '',
                'Limit'       => '10',
                'Module'      => 'Kernel::Output::HTML::Dashboard::TicketGeneric',
                'Permission'  => 'rw',
                'Time'        => 'Age',
                'Title'       => 'Open Tickets / Need to be answered'
            },

        );

        # Create test params.
        my @Test = ( "0100-TicketPendingReminder", "0110-TicketEscalation", "0120-TicketNew", "0130-TicketOpen" );

        # Test if ticket is shown in each dashboard ticket generic plugin.
        for my $DashboardName (@Test) {

            $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

            # Set ticket state depending on the stage in test.
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

            # Discard TicketObject to let event handlers run also for transaction mode 1.
            $Kernel::OM->ObjectsDiscard(
                Objects => ['Kernel::System::Ticket']
            );

            # Disable all dashboard plugins.
            my $Config = $ConfigObject->Get('DashboardBackend');
            $Helper->ConfigSettingChange(
                Valid => 0,
                Key   => 'DashboardBackend',
                Value => \%$Config,
            );

            # Enable current needed dashboard plugin sysconfig.
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => "DashboardBackend###" . $DashboardName,
                Value => $Configs{$DashboardName},
            );

            # Refresh dashboard screen and clean it's cache.
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => 'Dashboard',
            );

            $Selenium->VerifiedRefresh();

            # Click settings wheel.
            $Selenium->execute_script("\$('#Dashboard$DashboardName-toggle').trigger('click');");

            # Set Priority on visible.
            $Selenium->execute_script(
                "\$('.ColumnsJSON').val('{\"Columns\":{\"Priority\":1},\"Order\":[\"Priority\"]}');"
            );

            # Submit.
            $Selenium->execute_script( "\$('#Dashboard$DashboardName" . "_submit').trigger('click');" );

            # Wait until block shows.
            $Self->True(
                $Selenium->WaitFor(
                    JavaScript =>
                        "return typeof(\$) === 'function' && \$('th.Priority #PriorityOverviewControl$DashboardName:visible').length"
                    )
                    || '',
                "#PriorityOverviewControl$DashboardName is visible."
            );

            # Sort by Priority.
            $Selenium->execute_script("\$('th.Priority #PriorityOverviewControl$DashboardName').trigger('click');");

            sleep 2;

            # Wait for AJAX to finish.
            $Self->True(
                $Selenium->WaitFor(
                    JavaScript =>
                        'return typeof($) === "function" && $(".DashboardHeader.Priority.SortDescendingLarge:visible").length'
                    )
                    || '',
                ".DashboardHeader.Priority.SortDescendingLarge is visible."
            );

            # Validate that Priority sort is working.
            $Self->True(
                $Selenium->find_element( ".DashboardHeader.Priority.SortDescendingLarge", 'css' ),
                "Priority sort is working",
            );

            # Set filter by MyQueue.
            my $Filter = "#Dashboard$DashboardName" . "MyQueues";
            $Selenium->WaitFor( JavaScript => "return \$('$Filter:visible').length" );
            $Selenium->find_element( $Filter, 'css' )->click();

            my $TicketFound;

            TICKET_WAIT:
            for my $Count ( 0 .. 10 ) {
                $TicketFound
                    = index( $Selenium->get_page_source(), "Action=AgentTicketZoom;TicketID=$TicketID" ) > -1 ? 1 : 0;

                last TICKET_WAIT if $TicketFound;

                # Wait 1 second.
                sleep 1;
            }

            # Check for test ticket on current dashboard plugin.
            $Self->True(
                $TicketFound,
                "$DashboardName dashboard plugin test ticket link - found",
            ) || die "$DashboardName test link NOT found";
        }

        $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Delete test tickets.
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

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete MyQueue from personal_queues.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM personal_queues WHERE queue_id = $QueueID",
        );
        $Self->True(
            $Success,
            "Delete MyQueue from personal_queues - ID $QueueID",
        );

        # Delete test queue.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Queue is deleted - ID $QueueID",
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure cache is correct.
        for my $Cache (qw(Ticket Queue Dashboard DashboardQueueOverview )) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
