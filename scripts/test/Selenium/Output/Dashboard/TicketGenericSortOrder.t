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

# Get selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # Get helper object.
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Reset 'DashboardBackend###0120-TicketNew' SysConfig.
        $Kernel::OM->Get('Kernel::System::SysConfig')->SettingReset(
            Name => 'DashboardBackend###0120-TicketNew',
        );

        # Set 'DashboardBackend###0120-TicketNew' SysConfig.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => "DashboardBackend###0120-TicketNew",
            Value => {
                'Attributes'     => 'StateType=new;SortBy=Priority;OrderBy=Up;',
                'Block'          => 'ContentLarge',
                'CacheTTLLocal'  => '0.001',
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
                    'Priority'               => '2',
                    'Queue'                  => '2',
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
        );

        # Create test user.
        my ( $TestUserLogin, $TestUserID ) = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        );

        # Create test queue.
        my $QueueName = "Queue" . $Helper->GetRandomID();
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
            "Queue ID $QueueID is created",
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create 11 test tickets.
        my @TicketIDs;
        my @TicketNumbers;
        for my $TicketCreate ( 1 .. 11 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => 'Selenium Test Ticket',
                QueueID      => $QueueID,
                Lock         => 'lock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => '123465',
                CustomerUser => 'customer@example.com',
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );
            $Self->True(
                $TicketID,
                "Ticket is created - ID $TicketID",
            );
            push @TicketNumbers, $TicketNumber;
            push @TicketIDs,     $TicketID;
        }

        # Update last ticket to priority '1 very low' for test purpose.
        my $Success = $TicketObject->TicketPrioritySet(
            TicketID => $TicketIDs[10],
            Priority => '1 very low',
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Ticket ID $TicketIDs[10] updated priority to '1 very low'"
        );

        # Login.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentPreferences screen.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentPreferences;Subaction=Group;Group=NotificationSettings"
        );

        # Set MyQueue preferences.
        $Selenium->InputFieldValueSet(
            Element => '#QueueID',
            Value   => $QueueID,
        );

        # Save the setting, wait for the ajax call to finish and check if success sign is shown.
        $Selenium->execute_script(
            "\$('#QueueID').closest('.WidgetSimple').find('.SettingUpdateBox').find('button').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#QueueID').closest('.WidgetSimple').hasClass('HasOverlay')"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return \$('#QueueID').closest('.WidgetSimple').find('.fa-check').length"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return !\$('#QueueID').closest('.WidgetSimple').hasClass('HasOverlay')"
        );

        # Login test user again.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to AgentDashboard screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # Click on 'Tickets in My Queues'.
        $Selenium->find_element( "#Dashboard0120-TicketNewMyQueues", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Loading").length' );

        # Check 'Sorting by' as initial sort on loading page.
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Priority, sorted ascending' )]"),
            "Sorting by priority on loading page",
        );

        # Check if ticket with different priority is found without filter.
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Queue, filter not active' )]"),
            "Filter for queue column is not active",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('#Dashboard0120-TicketNew tbody td a[href*=\"Action=AgentTicketZoom;TicketID=$TicketIDs[10]\"]').length;"
            ),
            "Ticket with priority '1 very low' found without filter",
        );

        # Set test queue as filter.
        $Selenium->find_element("//a[contains(\@title, \'Queue, filter not active' )]")->click();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$(\"#ColumnFilterQueue0120-TicketNew option[value='$QueueID']\").length"
        );

        $Selenium->find_element( "#ColumnFilterQueue0120-TicketNew option[value='$QueueID']", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Loading").length' );

     # Verify ticket with different priority is present on screen with filter, it's still on the first page.
     # See bug#11422 ( http://bugs.otrs.org/show_bug.cgi?id=11422 ), there is no change in order when activating filter.
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Queue, filter active' )]"),
            "Filter for queue column is active",
        );
        $Self->True(
            $Selenium->execute_script(
                "return \$('#Dashboard0120-TicketNew tbody td a[href*=\"Action=AgentTicketZoom;TicketID=$TicketIDs[10]\"]').length;"
            ),
            "Ticket with priority '1 very low' found on screen without filter",
        );

        # Check priority 'Order by' is not changed after filtering.
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Priority, sorted ascending' )]"),
            "Priority column 'Order by' is not changed",
        );

        # Check if priority 'Order by' changed to 'Down' after click (with filtering).
        $Selenium->find_element( "#PriorityOverviewControl0120-TicketNew", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Loading").length' );
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Priority, sorted descending' )]"),
            "Priority column order by is changed",
        );

        # Check if ticket with priority '1 very low' not on screen.
        $Self->False(
            $Selenium->execute_script(
                "return \$('#Dashboard0120-TicketNew tbody td a[href*=\"Action=AgentTicketZoom;TicketID=$TicketIDs[10]\"]').length;"
            ),
            "Ticket with priority '1 very low' not found on screen without filter",
        );

        # Remove queue filter.
        $Selenium->execute_script(
            "\$('#Dashboard0120-TicketNew-box .Header .RemoveFilters').trigger('click');"
        );
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && !$("#Dashboard0120-TicketNew thead .FilterActive.Queue").length;'
        );
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Queue, filter not active' )]"),
            'Filter removed',
        );

        # Check if 'Sort by' and 'Order by' are set to default values after removing filter (Priority, ascending).
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Priority, sorted ascending' )]"),
            "'Order by' is default after removing filter",
        );

        # Check if ticket with priority '1 very low' is on screen.
        $Self->True(
            $Selenium->execute_script(
                "return \$('#Dashboard0120-TicketNew tbody td a[href*=\"Action=AgentTicketZoom;TicketID=$TicketIDs[10]\"]').length;"
            ),
            "Ticket with priority '1 very low' found",
        );

        # Check if priority 'Order by' changed to 'Down' after click (without filtering).
        $Selenium->find_element( "#PriorityOverviewControl0120-TicketNew", 'css' )->click();
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$(".Loading").length' );
        $Self->True(
            $Selenium->find_element("//a[contains(\@title, \'Priority, sorted descending' )]"),
            "Priority column 'Order by' changed",
        );

        # Delete test tickets.
        for my $Ticket (@TicketIDs) {
            my $Success = $TicketObject->TicketDelete(
                TicketID => $Ticket,
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $Ticket,
                    UserID   => 1,
                );
            }
            $Self->True(
                $Success,
                "Ticket ID $Ticket is deleted"
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete personal queue for test agent.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM personal_queues WHERE queue_id = $QueueID",
        );
        $Self->True(
            $Success,
            "Personal queue is deleted",
        );

        # Delete test queue.
        $Success = $DBObject->Do(
            SQL => "DELETE FROM queue WHERE id = $QueueID",
        );
        $Self->True(
            $Success,
            "Queue ID $QueueID is deleted",
        );

        # Make sure cache is correct.
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        for my $Cache (qw(Ticket Queue Dashboard DashboardQueueOverview )) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
