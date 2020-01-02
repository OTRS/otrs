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

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ACLObject    = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Set to change queue for ticket in a new window.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MoveType',
            Value => 'link'
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketMove###Note',
            Value => '1'
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketMove###NoteMandatory',
            Value => '1'
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketMove###Subject',
            Value => 'test subject'
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketMove###Body',
            Value => 'test body'
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => '0'
        );

        # Create two test queues to use as 'Junk' and 'Delete' queue.
        my @QueueNames;
        my @QueueIDs;
        for my $QueueCreate (qw(Delete Junk)) {
            my $QueueName = $QueueCreate . $Helper->GetRandomID();
            my $QueueID   = $Kernel::OM->Get('Kernel::System::Queue')->QueueAdd(
                Name            => $QueueName,
                ValidID         => 1,
                GroupID         => 1,                       # users
                SystemAddressID => 1,
                SalutationID    => 1,
                SignatureID     => 1,
                Comment         => 'Selenium Test Queue',
                UserID          => 1,
            );
            $Self->True(
                $QueueID,
                "QueueID $QueueID is created",
            );
            push @QueueIDs,   $QueueID;
            push @QueueNames, $QueueName;
        }

        # Get sysconfig data.
        my @SysConfigData = (
            {
                MenuModule    => 'Ticket::Frontend::MenuModule###460-Delete',
                OrgQueueLink  => 'Delete',
                TestQueueLink => $QueueNames[0],
            },
            {
                MenuModule    => 'Ticket::Frontend::MenuModule###470-Junk',
                OrgQueueLink  => 'Junk',
                TestQueueLink => $QueueNames[1],
            },
        );

        for my $SysConfigUpdate (@SysConfigData) {

            # Enable menu module and modify destination link.
            my %MenuModuleConfig = $Kernel::OM->Get('Kernel::System::SysConfig')->SettingGet(
                Name    => $SysConfigUpdate->{MenuModule},
                Default => 1,
            );

            my %MenuModuleConfigUpdate = %{ $MenuModuleConfig{EffectiveValue} };
            $MenuModuleConfigUpdate{Link} =~ s/$SysConfigUpdate->{OrgQueueLink}/$SysConfigUpdate->{TestQueueLink}/g;

            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => $SysConfigUpdate->{MenuModule},
                Value => \%MenuModuleConfigUpdate,
            );
        }

        # Set previous ACLs on invalid.
        my $ACLList = $ACLObject->ACLList(
            ValidIDs => ['1'],
            UserID   => 1,
        );

        for my $Item ( sort keys %{$ACLList} ) {

            $ACLObject->ACLUpdate(
                ID   => $Item,
                Name => $ACLList->{$Item},
                ,
                ValidID => 2,
                UserID  => 1,
            );
        }

        # Create test ACL with possible not selection of test queues.
        my $ACLName = 'AACL' . $Helper->GetRandomID();
        my $ACLID   = $ACLObject->ACLAdd(
            Name           => $ACLName,
            Comment        => 'Selenium ACL',
            Description    => 'Description',
            StopAfterMatch => 1,
            ConfigMatch    => '',
            ConfigChange   => {
                Possible    => {},
                PossibleNot => {
                    Ticket => {
                        Queue => [
                            $QueueNames[0], $QueueNames[1]
                        ],
                    },
                },
            },
            ValidID => 1,
            UserID  => 1,
        );
        $Self->True(
            $ACLID,
            "ACLID $ACLID is created",
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title        => "Selenium Test Ticket",
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => "SeleniumCustomer\@example.com",
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AdminACL and synchronize ACL's.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # Click 'Deploy ACLs'.
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        $Self->True(
            $Selenium->find_element("//a[text()=\"$ACLName\"]")->is_displayed(),
            "ACLName '$ACLName' found on page",
        );

        # Navigate to zoom view of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "a[title='Change Queue']",
        );

        # Click on 'Move' and switch window.
        $Selenium->find_element("//a[\@title='Change Queue']")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Check page.
        for my $ID (
            qw(DestQueueID NewUserID NewStateID)
            )
        {
            $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#$ID').length;" );
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
        }

        # Change ticket queue.
        $Selenium->InputFieldValueSet(
            Element => '#DestQueueID',
            Value   => 4,
        );

        $Selenium->WaitForjQueryEventBound(
            CSSSelector => "#submitRichText",
        );

        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Return back to zoom view and click on history and switch to its view.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete;'
        );

        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('#nav-Close').length;" );

        $Self->True(
            $Selenium->execute_script("return \$('#nav-Close').length;"),
            "Close menu found on page",
        );

        # Navigate to AgentTicketHistory of created test ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketHistory;TicketID=$TicketID");
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('.CancelClosePopup').length;" );

        # Confirm ticket move action.
        my $MoveMsg = "Changed queue to \"Misc\" (4) from \"Raw\" (2).";
        $Self->True(
            index( $Selenium->get_page_source(), $MoveMsg ) > -1,
            'Ticket move action completed'
        );

        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('a[title*=\"Delete this ticket\"]').length;"
        );

        my $ErrorMessage
            = "This ticket does not exist, or you don't have permissions to access it in its current state.";

        # Click on 'Delete' and check for ACL error message.
        $Selenium->find_element("//a[contains(\@title, 'Delete this ticket')]")->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), $ErrorMessage ) > -1,
            "ACL restriction error message found for 'Delete' menu",
        );

        # Click to return back to AgentTicketZoom screen.
        $Selenium->find_element( ".ReturnToPreviousPage", 'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('a[title*=\"Mark this ticket as junk!\"]').length;"
        );

        # Click on 'Spam' and check for ACL error message.
        $Selenium->find_element("//a[contains(\@title, 'Mark this ticket as junk!')]")->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), $ErrorMessage ) > -1,
            "ACL restriction error message found for 'Spam' menu",
        );

        # Test for bug#12559 that nothing shpuld happen,
        # if the user click on a disabled queue (only for move type 'form').
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MoveType',
            Value => 'form'
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketMove###Note',
            Value => '0'
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketMove###NoteMandatory',
            Value => '0'
        );

        # Reload the page, to get the new sys config option.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");
        $Selenium->InputFieldValueSet(
            Element => '#DestQueueID',
            Value   => 4,
        );

        # Wait for Asynchronous widget to load.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.SidebarColumn .WidgetSimple').length;"
        );

        # Check that nothing happens, after the queue selection in the dropdown.
        $Self->True(
            index( $Selenium->get_current_url(), "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID" )
                > -1,
            'The current url is the same (no reload happens).',
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('p.Value[title=\"Misc\"]').text();"
            ),
            'Misc',
            'The Queue was not changed.',
        ) || die;

        $Selenium->InputFieldValueSet(
            Element => '#DestQueueID',
            Value   => 2,
        );

        # Wait for reload to kick in.
        $Selenium->WaitFor(
            JavaScript => "return typeof(\$) === 'function' && \$('.SidebarColumn .WidgetSimple').length;"
        );
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(Core) == 'object' && typeof(Core.App) == 'object' && Core.App.PageLoadComplete && \$('p.Value[title=\"Raw\"]').text() === 'Raw';"
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('p.Value[title=\"Raw\"]').text();"
            ),
            'Raw',
            'The Queue was changed.',
        ) || die;

        # Delete test ACL.
        my $Success = $ACLObject->ACLDelete(
            ID     => $ACLID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "ACLID $ACLID is deleted",
        );

        # Navigate to AdminACL to synchronize after test ACL cleanup.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # Click 'Deploy ACLs'.
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        # Delete created test queues.
        for my $QueueDelete (@QueueIDs) {

            $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => "DELETE FROM queue WHERE id = $QueueDelete",
            );
            $Self->True(
                $Success,
                "DeleteID $QueueDelete is deleted",
            );
        }

        # Delete created test tickets.
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
            "Ticket with ticket ID $TicketID is deleted"
        );

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw( Ticket Queue )) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
