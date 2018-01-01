# --
# Copyright (C) 2001-2018 OTRS AG, http://otrs.com/
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
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $GroupObject  = $Kernel::OM->Get('Kernel::System::Group');

        # Get random variable.
        my $RandomID = $Helper->GetRandomID();

        # Enable AgentTicketService toolbar icon.
        my %AgentTicketService = (
            CssClass => 'ServiceView',
            Icon     => 'fa fa-wrench',
            Module   => 'Kernel::Output::HTML::ToolBar::TicketService',
            Priority => '1030035',
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###10-Ticket::AgentTicketService',
            Value => \%AgentTicketService,
        );

        # Allows defining services for tickets.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1
        );

        # Create test service.
        my $ServiceName = 'Selenium' . $Helper->GetRandomID();
        my $ServiceID   = $Kernel::OM->Get('Kernel::System::Service')->ServiceAdd(
            Name    => $ServiceName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $ServiceID,
            "Service ID $ServiceID is created"
        );

        # Create test group.
        my $GroupName = "Group" . $Helper->GetRandomID();
        my $GroupID   = $GroupObject->GroupAdd(
            Name    => $GroupName,
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $GroupID,
            "Group ID $GroupID is created"
        );

        # Create test queue.
        my $QueueName = 'Queue' . $RandomID;
        my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
            Name            => $QueueName,
            ValidID         => 1,
            GroupID         => $GroupID,
            SystemAddressID => 1,
            SalutationID    => 1,
            SignatureID     => 1,
            Comment         => 'Selenium Queue',
            UserID          => 1,
        );
        $Self->True(
            $QueueID,
            "Queue ID $QueueID is created"
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title         => 'Selenium test ticket',
            Queue         => $QueueName,
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'open',
            CustomerID    => 'SeleniumCustomerID',
            CustomerUser  => 'test@localhost.com',
            ServiceID     => $ServiceID,
            OwnerID       => 1,
            UserID        => 1,
            ResponsibleID => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket ID $TicketID is created"
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', $GroupName ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Update 'My Service' preference for test created user.
        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');
        my $Success  = $DBObject->Do(
            SQL => '
                INSERT INTO personal_services (service_id, user_id)
                VALUES (?, ?)
            ',
            Bind => [ \$ServiceID, \$TestUserID ]
        );
        $Self->True(
            $Success,
            'My service preference updated for test user'
        );

        # Login test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # Click on tool bar AgentTicketService.
        $Selenium->find_element("//a[contains(\@title, \'Tickets in My Services:\' )]")->VerifiedClick();

        # Verify that test is on the correct screen.
        my $ExpectedURL = "${ScriptAlias}index.pl?Action=AgentTicketService";
        $Self->True(
            index( $Selenium->get_current_url(), $ExpectedURL ) > -1,
            "ToolBar icon 'Ticket in my Services' shortcut - success"
        );

        # Return back to dashboard screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentDashboard");

        # Change test user group permission for which queue-ticket is in to RO.
        #   Toolbar icon should be removed, see bug#12269 for more information.
        $Success = $GroupObject->PermissionGroupUserAdd(
            GID        => $GroupID,
            UID        => $TestUserID,
            Permission => {
                ro        => 1,
                move_into => 0,
                create    => 0,
                owner     => 0,
                priority  => 0,
                rw        => 0,
            },
            UserID => 1,
        );
        $Self->True(
            $Success,
            'Changed test user group permission to RO'
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Verified tool bar 'Ticket in my Services' icon is removed.
        $Self->True(
            $Selenium->execute_script("return \$('.ServiceView').length === 0;"),
            "ToolBar icon 'Ticket in my Services' is removed when agent doesn't have RW access to ticket"
        );

        # Change settings Ticket::Frontend::AgentTicketService###ViewAllPossibleTickets to 'Yes'.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketService###ViewAllPossibleTickets',
            Value => 1
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Verified tool bar 'Ticket in my Services' icon is shown.
        $Self->True(
            $Selenium->execute_script("return \$('.ServiceView').length === 1;"),
            "ToolBar icon 'Ticket in my Services' is shown when agent doesn't have RW access to ticket and settings 'ViewAllPossibleTickets' is enabled",
        );

        # Delete test ticket.
        $Success = $TicketObject->TicketDelete(
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
            "Ticket ID $TicketID is deleted"
        );

        # Delete personal service from DB.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM personal_services WHERE user_id = ?",
            Bind => [ \$TestUserID ],
        );
        $Self->True(
            $Success,
            'Personal service connection is deleted'
        );

        # Delete test service.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM service WHERE id = ?",
            Bind => [ \$ServiceID ],
        );
        $Self->True(
            $Success,
            "Service ID $ServiceID is deleted"
        );

        # Delete test queue.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM queue WHERE id = ?",
            Bind => [ \$QueueID ],
        );
        $Self->True(
            $Success,
            "Queue ID $QueueID is deleted"
        );

        # Delete test user from group.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM group_user WHERE group_id = ?",
            Bind => [ \$GroupID ],
        );
        $Self->True(
            $Success,
            "Group $GroupName - TestUser relation is deleted"
        );

        # Delete test group.
        $GroupName = $DBObject->Quote($GroupName);
        $Success   = $DBObject->Do(
            SQL  => "DELETE FROM groups WHERE name = ?",
            Bind => [ \$GroupName ],
        );
        $Self->True(
            $Success,
            "Group $GroupName is deleted"
        );

        # Make sure the cache is correct.
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        for my $Cache (
            qw (Ticket Service Queue Group)
            )
        {
            $CacheObject->CleanUp(
                Type => $Cache,
            );
        }
    }
);

1;
