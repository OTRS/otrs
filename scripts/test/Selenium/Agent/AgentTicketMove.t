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

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # set to change queue for ticket in a new window
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MoveType',
            Value => 'link'
        );

        # create two test queues to use as 'Junk' and 'Delete' queue
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

        # get sysconfig data
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

            # enable menu module and modify destination link
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

        # get ACL object
        my $ACLObject = $Kernel::OM->Get('Kernel::System::ACL::DB::ACL');

        # create test ACL with possible not selection of test queues
        my $ACLID = $ACLObject->ACLAdd(
            Name           => 'AACL' . $Helper->GetRandomID(),
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

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => "Selenium Test Ticket",
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => "SeleniumCustomer\@localhost.com",
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminACL and synchronize ACL's
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # click 'Deploy ACLs'
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        # navigate to zoom view of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # click on 'Move' and switch window
        $Selenium->find_element("//a[contains(\@title, \'Change Queue' )]")->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#DestQueueID").length' );

        # check page
        for my $ID (
            qw(DestQueueID NewUserID NewStateID)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
        }

        # change ticket queue
        $Selenium->execute_script("\$('#DestQueueID').val('4').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # return back to zoom view and click on history and switch to its view
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Wait for reload to kick in.
        sleep 1;
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        $Selenium->find_element("//*[text()='History']")->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".CancelClosePopup").length' );

        # confirm ticket move action
        my $MoveMsg = "Changed queue to \"Misc\" (4) from \"Raw\" (2).";
        $Self->True(
            index( $Selenium->get_page_source(), $MoveMsg ) > -1,
            'Ticket move action completed'
        );

        # click on close window and switch back screen
        $Selenium->find_element( ".CancelClosePopup", 'css' )->click();

        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # test bug #11854 ( http://bugs.otrs.org/show_bug.cgi?id=11854 )
        # ACL restriction on queue which is destination queue for 'Spam' menu in AgentTicketZoom
        # get error message
        my $ErrorMessage
            = 'We are sorry, you do not have permissions anymore to access this ticket in its current state';

        # click on 'Delete' and check for ACL error message
        $Selenium->find_element("//a[contains(\@title, 'Delete this ticket')]")->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), $ErrorMessage ) > -1,
            "ACL restriction error message found for 'Delete' menu",
        );

        # click to return back to AgentTicketZoom screen
        $Selenium->find_element( ".ReturnToPreviousPage", 'css' )->VerifiedClick();

        # click on 'Spam' and check for ACL error message
        $Selenium->find_element("//a[contains(\@title, 'Mark this ticket as junk!')]")->VerifiedClick();
        $Self->True(
            index( $Selenium->get_page_source(), $ErrorMessage ) > -1,
            "ACL restriction error message found for 'Spam' menu",
        );

     # Test for bug#12559 that nothing shpuld happen, if the user click on a disabled queue (only for move type 'form').
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MoveType',
            Value => 'form'
        );

        # Reload the page, to get the new sys config option.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");
        $Selenium->execute_script("\$('#DestQueueID').val('4').trigger('redraw.InputField').trigger('change');");

        # Check that nothing happens, after the queue selection in the dropdown.
        $Self->True(
            index( $Selenium->get_current_url(), "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID" )
                > -1,
            'The current url is the same (no reload happens).',
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('p.Value[title=\"Misc\"]').text()"
            ),
            'Misc',
            'The Queue was not changed.',
        );

        $Selenium->execute_script("\$('#DestQueueID').val('2').trigger('redraw.InputField').trigger('change');");

        # Wait for reload to kick in.
        sleep 1;
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('p.Value[title=\"Raw\"]').text()"
            ),
            'Raw',
            'The Queue was changed.',
        );

        # delete test ACL
        my $Success = $ACLObject->ACLDelete(
            ID     => $ACLID,
            UserID => 1,
        );
        $Self->True(
            $Success,
            "ACLID $ACLID is deleted",
        );

        # navigate to AdminACL to synchronize after test ACL cleanup
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminACL");

        # click 'Deploy ACLs'
        $Selenium->find_element("//a[contains(\@href, 'Action=AdminACL;Subaction=ACLDeploy')]")->VerifiedClick();

        # delete created test queues
        for my $QueueDelete (@QueueIDs) {

            $Success = $Kernel::OM->Get('Kernel::System::DB')->Do(
                SQL => "DELETE FROM queue WHERE id = $QueueDelete",
            );
            $Self->True(
                $Success,
                "DeleteID $QueueDelete is deleted",
            );
        }

        # delete created test tickets
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

        # make sure the cache is correct
        for my $Cache (qw( Ticket Queue )) {
            $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
                Type => $Cache,
            );
        }

    }
);

1;
