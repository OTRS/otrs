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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper             = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $GroupObject        = $Kernel::OM->Get('Kernel::System::Group');
        my $UserObject         = $Kernel::OM->Get('Kernel::System::User');
        my $QueueObject        = $Kernel::OM->Get('Kernel::System::Queue');
        my $ConfigObject       = $Kernel::OM->Get('Kernel::Config');
        my $CustomerUserObject = $Kernel::OM->Get('Kernel::System::CustomerUser');

        # do not check email addresses
        $ConfigObject->Set(
            Key   => 'CheckEmailAddresses',
            Value => 0,
        );

        # enable bulk feature
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::BulkFeature',
            Value => 1,
        );

        # enable required lock feature in bulk
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketBulk###RequiredLock',
            Value => 1,
        );

        # Enable ticket responsible feature.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Responsible',
            Value => 1,
        );

        my $Config = $ConfigObject->Get('Ticket::Frontend::AgentTicketResponsible');
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketResponsible',
            Value => {
                %{$Config},
                Note          => 1,
                NoteMandatory => 1,
            },
        );

        # Get needed variables.
        my $RandomNumber = $Helper->GetRandomNumber();
        my $Success;

        # Create groups.
        my @GroupIDs;
        my @GroupNames;
        for my $Count ( 1 .. 2 ) {
            my $GroupID = $GroupObject->GroupAdd(
                Name    => "$Count-Group-$RandomNumber",
                ValidID => 1,
                UserID  => 1,
            );
            $Self->True(
                $GroupID,
                "GroupID $GroupID is created",
            );
            push @GroupIDs, $GroupID;

            my $GroupName = $GroupObject->GroupLookup(
                GroupID => $GroupID,
            );
            push @GroupNames, $GroupName;
        }

        # Create test user for login.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', @GroupNames ],
        ) || die "Did not get test user";

        # get test user ID
        my $TestUserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create users.
        my @UserIDs;
        for my $Count ( 1 .. 3 ) {
            my $UserLogin = "$Count-User-$RandomNumber";
            my $UserID    = $UserObject->UserAdd(
                UserFirstname => $UserLogin,
                UserLastname  => $UserLogin,
                UserLogin     => $UserLogin,
                UserEmail     => "$UserLogin\@example.com",
                ValidID       => 1,
                ChangeUserID  => $TestUserID,
            );
            $Self->True(
                $UserID,
                "UserID $UserID is created",
            );
            push @UserIDs, $UserID;
        }

        # Add groups to the users.
        my @GroupUserRelations = (
            {
                GID => $GroupIDs[0],
                UID => $UserIDs[0],
            },
            {
                GID => $GroupIDs[0],
                UID => $UserIDs[1],
            },
            {
                GID => $GroupIDs[1],
                UID => $UserIDs[2],
            },
        );

        for my $GroupUserRelation (@GroupUserRelations) {
            $Success = $GroupObject->PermissionGroupUserAdd(
                GID        => $GroupUserRelation->{GID},
                UID        => $GroupUserRelation->{UID},
                Permission => {
                    ro        => 1,
                    move_into => 1,
                    create    => 1,
                    owner     => 1,
                    priority  => 1,
                    rw        => 1,
                },
                UserID => 1,
            );
            $Self->True(
                $Success,
                "Test user '$GroupUserRelation->{UID}' set permission for group '$GroupUserRelation->{GID}'"
            );
        }

        # Create queues with test groups.
        my @QueueIDs;
        for my $Count ( 1 .. 2 ) {
            my $QueueID = $QueueObject->QueueAdd(
                Name            => "$Count-Queue-$RandomNumber",
                ValidID         => 1,
                GroupID         => $Count == 1 ? $GroupIDs[0] : $GroupIDs[1],
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                Comment         => 'Comment',
                UserID          => $TestUserID,
            );
            $Self->True(
                $QueueID,
                "QueueID $QueueID is created",
            );
            push @QueueIDs, $QueueID;
        }

        my $TestCustomerUser      = 'User-' . $RandomNumber;
        my $TestCustomerUserEmail = $TestCustomerUser . '@example.com';
        my $TestCustomerUserLogin = $CustomerUserObject->CustomerUserAdd(
            Source         => 'CustomerUser',
            UserFirstname  => $TestCustomerUser,
            UserLastname   => $TestCustomerUser,
            UserCustomerID => $TestCustomerUser,
            UserLogin      => $TestCustomerUser,
            UserEmail      => $TestCustomerUserEmail,
            ValidID        => 1,
            UserID         => 1,
        );
        $Self->True(
            $TestCustomerUserLogin,
            "CustomerUser $TestCustomerUserLogin is created",
        );

        # get ticket object
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        my $QueueRawID = $QueueObject->QueueLookup( Queue => 'Raw' );

        my @Tests = (
            {
                TicketTitle => 'TestTicket-One',
                Lock        => 'lock',
                QueueID     => $QueueRawID,
                OwnerID     => $TestUserID,
                UserID      => $TestUserID,
            },
            {
                TicketTitle => 'TestTicket-Two',
                Lock        => 'unlock',
                QueueID     => $QueueRawID,
                OwnerID     => $TestUserID,
                UserID      => $TestUserID,
            },
            {
                # ticket locked by another agent #1
                TicketTitle => 'TestTicket-Three',
                Lock        => 'lock',
                QueueID     => $QueueRawID,
                OwnerID     => 1,
                UserID      => 1,
            },
            {
                TicketTitle => 'TestTicket-Four',
                Lock        => 'unlock',
                QueueID     => $QueueIDs[0],
                OwnerID     => 1,
                UserID      => $TestUserID,
            },
            {
                TicketTitle => 'TestTicket-Five',
                Lock        => 'unlock',
                QueueID     => $QueueIDs[0],
                OwnerID     => 1,
                UserID      => $TestUserID,
            },
            {
                TicketTitle => 'TestTicket-Six',
                Lock        => 'unlock',
                QueueID     => $QueueIDs[1],
                OwnerID     => 1,
                UserID      => $TestUserID,
            },
            {
                # ticket locked by another agent #2
                TicketTitle => 'TestTicket-Seven',
                Lock        => 'lock',
                QueueID     => $QueueRawID,
                OwnerID     => 1,
                UserID      => 1,
            },
        );

        # Create test tickets.
        my @Tickets;
        for my $Test (@Tests) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => $Test->{TicketTitle},
                QueueID      => $Test->{QueueID},
                Lock         => $Test->{Lock},
                Priority     => '3 normal',
                State        => 'open',
                CustomerID   => $TestCustomerUserLogin,
                CustomerUser => $TestCustomerUserLogin,
                OwnerID      => $Test->{OwnerID},
                UserID       => $Test->{UserID},
            );
            $Self->True(
                $TicketID,
                "Ticket is created - $Test->{TicketTitle}, $TicketNumber",
            );

            my %Ticket = (
                TicketID     => $TicketID,
                TicketNumber => $TicketNumber,
                OwnerID      => $Test->{OwnerID}
            );

            push @Tickets, \%Ticket;
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # navigate to AgentTicketStatusView
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # verify that test tickets are in open state
        for my $Ticket (@Tickets) {
            $Self->True(
                index( $Selenium->get_page_source(), $Ticket->{TicketNumber} ) > -1,
                "Open ticket $Ticket->{TicketNumber} is found on page",
            );
        }

        # select both tickets and click on "bulk"
        # test case for the bug #11805 - http://bugs.otrs.org/show_bug.cgi?id=11805
        $Selenium->find_element("//input[\@value='$Tickets[0]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[1]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[2]->{TicketID}']")->click();
        $Selenium->find_element( "Bulk", 'link_text' )->VerifiedClick();

        # switch to bulk window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#StateID").length' );

        # check ticket bulk page
        for my $ID (
            qw(StateID OwnerID QueueID PriorityID OptionMergeTo MergeTo
            OptionMergeToOldest LinkTogether LinkTogetherParent Unlock submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # click on 'Undo & close' link
        $Selenium->find_element( ".UndoClosePopup", 'css' )->click();

        # return to status view
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # check ticket lock
        $Self->Is(
            $TicketObject->TicketLockGet(
                TicketID => $Tickets[0]->{TicketID},
            ),
            1,
            "Ticket remind locked after undo in bulk feature - $Tickets[0]->{TicketNumber}"
        );

        # select test tickets and click on "bulk"
        $Selenium->find_element("//input[\@value='$Tickets[0]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[1]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[2]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[6]->{TicketID}']")->click();

        $Selenium->find_element( "Bulk", 'link_text' )->click();

        # switch to bulk window
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # check data
        my @ExpectedMessages = (
            "The following tickets were ignored because they are locked by another agent or you don't have write access to these tickets: "
                . $Tickets[2]->{TicketNumber} . ", "
                . $Tickets[6]->{TicketNumber} . ".",
            "The following tickets were locked: " . $Tickets[1]->{TicketNumber} . ".",
        );
        for my $ExpectedMessage (@ExpectedMessages) {
            $Self->True(
                index( $Selenium->get_page_source(), $ExpectedMessage ) > -1,
                $ExpectedMessage,
            ) || die;
        }

        # Check list of recipients in SendEmail widget. See bug#12607 for more information.
        $Selenium->find_element("//a[contains(\@aria-controls, \'Core_UI_AutogeneratedID_1')]")->VerifiedClick();

        # Wait for AJAX finish.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && !$("#EmailRecipientsList i.fa-spinner:visible").length'
        );

        $Self->Is(
            $Selenium->find_element( '#EmailRecipientsList', 'css' )->get_text(),
            $TestCustomerUserEmail,
            'Test customer user email found in recipient list'
        );

        # change state and priority in bulk action for test tickets
        $Selenium->execute_script("\$('#PriorityID').val('4').trigger('redraw.InputField').trigger('change');");
        $Selenium->execute_script("\$('#StateID').val('2').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( '#submitRichText', 'css' )->click();

        # return to status view
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Make sure main window is fully loaded
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketStatusView");

        # select closed view to verify ticket bulk functionality
        $Selenium->find_element("//a[contains(\@href, \'Filter=Closed' )]")->VerifiedClick();

        # verify which tickets are shown in ticket closed view
        for my $Ticket (@Tickets) {
            if ( $Ticket->{OwnerID} != 1 && $Ticket->{Title} !~ m/-Four|-Five|-Six$/ ) {
                $Self->True(
                    index( $Selenium->get_page_source(), $Ticket->{TicketNumber} ) > -1,
                    "Closed ticket $Ticket->{TicketNumber} is found on page",
                ) || die;
            }
            else {

                # ticket is locked by another agent and it was ignored in bulk feature
                $Self->True(
                    index( $Selenium->get_page_source(), $Ticket->{TicketNumber} ) == -1,
                    "Ticket $Ticket->{TicketNumber} is not found on page",
                ) || die;
            }

        }

        # Select view of open tickets in the table.
        $Selenium->find_element("//a[contains(\@href, \'Filter=Open' )]")->VerifiedClick();

        # Check Owner field update after queue select.
        # Select the last three test created tickets and click on "bulk".
        $Selenium->find_element("//input[\@value='$Tickets[3]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[4]->{TicketID}']")->click();
        $Selenium->find_element("//input[\@value='$Tickets[5]->{TicketID}']")->click();
        $Selenium->find_element( "Bulk", 'link_text' )->click();

        # Switch to bulk window.
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#QueueID").length' );

        @Tests = (
            {
                SelectedQueueID => $QueueIDs[0],
                ExpectedOwners  => {
                    $UserIDs[0] => 1,
                    $UserIDs[1] => 1,
                    $UserIDs[2] => 0,
                    }
            },
            {
                SelectedQueueID => $QueueIDs[1],
                ExpectedOwners  => {
                    $UserIDs[0] => 0,
                    $UserIDs[1] => 0,
                    $UserIDs[2] => 1,
                    }
            }
        );

        for my $ConfigValue ( 0 .. 1 ) {

            # Set if everyone or just agents with rw permissions in the queue for the ticket would be shown
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'Ticket::ChangeOwnerToEveryone',
                Value => $ConfigValue,
            );

            for my $Test (@Tests) {

                # Select queue.
                $Selenium->execute_script(
                    "\$('#QueueID').val('$Test->{SelectedQueueID}').trigger('redraw.InputField').trigger('change');"
                );

                # Wait for AJAX finish.
                $Selenium->WaitFor(
                    JavaScript => 'return typeof($) === "function" && !$("#AJAXLoaderOwnerID:visible").length'
                );

                # Check for existence.
                for my $Key ( sort keys %{ $Test->{ExpectedOwners} } ) {
                    my $IsFound = $ConfigValue
                        ?
                        'is found - ChangeOwnerToEveryone'
                        :
                        $Test->{ExpectedOwners}->{$Key} ? 'is found' : 'is not found';
                    my $Exist = $ConfigValue ? 1 : $Test->{ExpectedOwners}->{$Key};

                    $Self->Is(
                        $Selenium->execute_script("return \$('#OwnerID option[value=$Key]').length;"),
                        $Exist,
                        "OwnerID - Test user $IsFound",
                    );

                    $Self->Is(
                        $Selenium->execute_script("return \$('#ResponsibleID option[value=$Key]').length;"),
                        $Exist,
                        "ResponsibleID - Test user $IsFound",
                    );
                }
            }
        }

        # Close popup.
        $Selenium->close();

        # clean up test data from the DB
        for my $Ticket (@Tickets) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $Ticket->{TicketID},
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $Ticket->{TicketID},
                    UserID   => 1,
                );
            }
            $Self->True(
                $Success,
                "Ticket is deleted - $Ticket->{TicketNumber}"
            );
        }

        my $DBObject = $Kernel::OM->Get('Kernel::System::DB');

        # Delete created test customer user.
        $Success = $DBObject->Do(
            SQL  => "DELETE FROM customer_user WHERE login = ?",
            Bind => [ \$TestCustomerUserLogin, ],
        );
        $Self->True(
            $Success,
            "CustomerUser $TestCustomerUserLogin is deleted"
        );

        # Delete test created queues.
        for my $QueueID (@QueueIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM queue WHERE id = ?",
                Bind => [ \$QueueID ],
            );
            $Self->True(
                $Success,
                "QueueID $QueueID is deleted",
            );
        }

        # Delete group-user relations.
        for my $GroupID (@GroupIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM group_user WHERE group_id = ?",
                Bind => [ \$GroupID ],
            );
            $Self->True(
                $Success,
                "Relation for group ID $GroupID is deleted",
            );
        }

        # Delete test created users.
        for my $UserID (@UserIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM user_preferences WHERE user_id = ?",
                Bind => [ \$UserID ],
            );
            $Self->True(
                $Success,
                "User preferences for $UserID is deleted",
            );

            $Success = $DBObject->Do(
                SQL  => "DELETE FROM users WHERE id = ?",
                Bind => [ \$UserID ],
            );
            $Self->True(
                $Success,
                "UserID $UserID is deleted",
            );
        }

        # Delete test created groups.
        for my $GroupID (@GroupIDs) {
            $Success = $DBObject->Do(
                SQL  => "DELETE FROM groups WHERE id = ?",
                Bind => [ \$GroupID ],
            );
            $Self->True(
                $Success,
                "GroupID $GroupID is deleted",
            );
        }

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
