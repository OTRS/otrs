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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => 'Some Ticket Title',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => $TestCustomerUserLogin,
            CustomerUser => $TestCustomerUserLogin,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $ArticleObject->BackendForChannel( ChannelName => 'Email' );

        # Create test email article, invisible for customer.
        my $InvisibleBody = 'invisible body';
        my $ArticleID     = $ArticleBackendObject->ArticleCreate(
            TicketID             => $TicketID,
            SenderType           => 'agent',
            IsVisibleForCustomer => 0,
            Subject              => 'an article subject',
            Body                 => $InvisibleBody,
            Charset              => 'ISO-8859-15',
            MimeType             => 'text/plain',
            HistoryType          => 'EmailCustomer',
            HistoryComment       => 'Some free text!',
            UserID               => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleCreate - ID $ArticleID",
        );

        # Enable CustomerTicketOverviewSortable.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketOverviewSortable',
            Value => 'Sortable',
        );

        # Do not check RichText.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0,
        );

        # Check if TicketOverview does show articles on ProcessTicket, see bug#14006.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users', ],
        ) || die "Did not get test user";
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Get all processes.
        my $ProcessObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Process');
        my $ProcessList   = $ProcessObject->ProcessListGet(
            UserID => $TestUserID,
        );

        my @DeactivatedProcesses;
        my $ProcessName = "CustomerTicketOverviewProcess";
        my $TestProcessExists;

        # If there had been some active processes before testing, set them to inactive.
        for my $Process ( @{$ProcessList} ) {
            if ( $Process->{State} eq 'Active' ) {
                $ProcessObject->ProcessUpdate(
                    ID            => $Process->{ID},
                    EntityID      => $Process->{EntityID},
                    Name          => $Process->{Name},
                    StateEntityID => 'S2',
                    Layout        => $Process->{Layout},
                    Config        => $Process->{Config},
                    UserID        => $TestUserID,
                );

                # Save process because of restoring on the end of test.
                push @DeactivatedProcesses, $Process;
            }

            # Check if test process already exists.
            if ( $Process->{Name} eq $ProcessName ) {
                $TestProcessExists = 1;
            }
        }

        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
        my $ScriptAlias  = $ConfigObject->Get('ScriptAlias');

        # Import test Selenium Process if it does not exist.
        if ( !$TestProcessExists ) {
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");
            my $Location = $ConfigObject->Get('Home') . "/scripts/test/sample/ProcessManagement/$ProcessName.yml";
            $Selenium->find_element( "#FileUpload", 'css' )->send_keys($Location);

            $Selenium->find_element( "#OverwriteExistingEntitiesImport", 'css' )->click();
            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && !\$('#OverwriteExistingEntitiesImport:checked').length;"
            );
            $Selenium->find_element("//button[\@value='Upload process configuration'][\@type='submit']")
                ->VerifiedClick();
            $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

            # We have to allow a 1 second delay for Apache2::Reload to pick up the changed process cache.
            sleep 1;
        }

        # Get Process list.
        my $List = $ProcessObject->ProcessList(
            UseEntities => 1,
            UserID      => $TestUserID,
        );

        # Get Process entity.
        my %ListReverse = reverse %{$List};

        # Navigate to AgentTicketProcess screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketProcess");

        $Selenium->InputFieldValueSet(
            Element => '#ProcessEntityID',
            Value   => $ListReverse{$ProcessName},
        );
        $Selenium->WaitFor( JavaScript => "return typeof(\$) === 'function' && \$('[type=submit]').length;" );
        $Selenium->find_element( "#CustomerAutoComplete", 'css' )->send_keys($TestCustomerUserLogin);
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("li.ui-menu-item:visible").length;' );
        $Selenium->execute_script("\$('li.ui-menu-item:contains($TestCustomerUserLogin)').click();");
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#CustomerID").val().length;' );
        $Selenium->find_element( ".Primary.CallForAction", 'css' )->VerifiedClick();

        my @Ticket          = split( 'TicketID=', $Selenium->get_current_url() );
        my $TicketIDProcess = $Ticket[1];

        # Navigate to zoom view and create note visible for customer.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDProcess");

        # Force sub menus to be visible in order to be able to click one of the links.
        $Selenium->execute_script(
            '$("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
        );
        $Selenium->WaitFor(
            JavaScript =>
                'return $("#nav-Communication ul").css("opacity") == 1;'
        );

        # Click on 'Note' and switch window.
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketIDProcess' )]")->click();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        # Open collapsed widgets, if necessary.
        $Selenium->execute_script(
            "\$('.WidgetSimple.Collapsed .WidgetAction > a').trigger('click');"
        );

        $Selenium->WaitFor( JavaScript => 'return $(".WidgetSimple.Expanded").length;' );

        # Check page.
        for my $ID (
            qw(Subject RichText FileUpload IsVisibleForCustomer submitRichText)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        my $RandomID   = $Helper->GetRandomID();
        my $TicketBody = "TicketBody$RandomID";

        $Selenium->find_element( "#Subject",              'css' )->send_keys("Subject$RandomID");
        $Selenium->find_element( "#RichText",             'css' )->send_keys($TicketBody);
        $Selenium->find_element( "#IsVisibleForCustomer", 'css' )->click();

        $Selenium->WaitFor( JavaScript => "return \$('#IsVisibleForCustomer:checked').length;" );

        $Selenium->find_element( "#submitRichText", 'css' )->click();

        # Switch window back to agent ticket zoom view of created test ticket.
        $Selenium->WaitFor( WindowCount => 1 );
        $Selenium->switch_to_window( $Handles->[0] );

        # Login test customer user.
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # Search for new created ticket on CustomerTicketOverview screen (default filter is Open)
        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]"),
            "Ticket with ticket number $TicketNumber is found on screen with Open filter"
        );

        # Make sure the article body is not displayed (internal article).
        $Self->True(
            index( $Selenium->get_page_source(), $InvisibleBody ) == -1,
            'Article body is not visible to customer',
        );

        # Check shown title and article body overview for the test email ticket in the table
        # for both Ticket::Frontend::CustomerTicketOverview###ColumnHeader settings.
        for my $ColumnHeader (qw(LastCustomerSubject TicketTitle)) {

            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'Ticket::Frontend::CustomerTicketOverview###ColumnHeader',
                Value => $ColumnHeader,
            );
            sleep 1;

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('table.Overview tbody tr a[href*=\"Action=CustomerTicketZoom;TicketNumber=$TicketNumber\"]').closest('tr').find('td:contains(\"Untitled!\")').length"
                ),
                '1',
                "Customer Ticket Overview table contains 'Untitled!' as ticket title part",
            );
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('table.Overview tbody tr a[href*=\"Action=CustomerTicketZoom;TicketNumber=$TicketNumber\"]').closest('tr').find('td:contains(\"This item has no articles yet.\")').length"
                ),
                '1',
                "Customer Ticket Overview table contains 'This item has no articles yet.' as article body part",
            );
        }

        # check All filter on CustomerTicketOverview screen
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=CustomerTicketOverview;Subaction=MyTickets;Filter=All' )]"
        )->VerifiedClick();

        # Check if table contains article.
        my $TicketNumbeProcess = $TicketObject->TicketNumberLookup(
            TicketID => $TicketIDProcess,
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('table.Overview tbody tr a[href*=\"Action=CustomerTicketZoom;TicketNumber=$TicketNumbeProcess\"]').closest('tr').find('td:contains($TicketBody)').length === 1"
            ),
            '1',
            'Customer Ticket Overview table contain process with visible article',
        );

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]"),
            "Ticket with ticket number $TicketNumber is found on screen with All filter"
        );

        # check if there is the header of overview table for sorting tickets
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#MainBox').hasClass('Sortable')"
            ),
            '1',
            'There is the header of overview table for sorting tickets.',
        );

        # check Close filter on CustomerTicketOverview screen
        # there is only one created ticket, and it should not be on screen with Close filter
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=CustomerTicketOverview;Subaction=MyTickets;Filter=Close' )]"
        )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), "Action=CustomerTicketZoom;TicketNumber=$TicketNumber" ) == -1,
            "Ticket with ticket number $TicketNumber is not found on screen with Close filter"
        );

        # disable CustomerTicketOverviewSortable
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::CustomerTicketOverviewSortable',
            Value => 0
        );

        # check All filter on CustomerTicketOverview screen
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=CustomerTicketOverview;Subaction=MyTickets;Filter=All' )]"
        )->VerifiedClick();

        # check if there is not the header of overview table for sorting tickets
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#MainBox').hasClass('Sortable')"
            ),
            '0',
            'There is not the header of overview table for sorting tickets.',
        );

        # Clean up.
        my $TransitionObject        = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Transition');
        my $ActivityObject          = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::Activity');
        my $TransitionActionsObject = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::TransitionAction');
        my $ActivityDialogObject    = $Kernel::OM->Get('Kernel::System::ProcessManagement::DB::ActivityDialog');

        my $Process = $ProcessObject->ProcessGet(
            EntityID => $ListReverse{$ProcessName},
            UserID   => $TestUserID,
        );

        # Clean up activities.
        my $Success;
        for my $Item ( @{ $Process->{Activities} } ) {
            my $Activity = $ActivityObject->ActivityGet(
                EntityID            => $Item,
                UserID              => $TestUserID,
                ActivityDialogNames => 0,
            );

            # Clean up activity dialogs.
            for my $ActivityDialogItem ( @{ $Activity->{ActivityDialogs} } ) {
                my $ActivityDialog = $ActivityDialogObject->ActivityDialogGet(
                    EntityID => $ActivityDialogItem,
                    UserID   => $TestUserID,
                );

                # Delete test activity dialog.
                $Success = $ActivityDialogObject->ActivityDialogDelete(
                    ID     => $ActivityDialog->{ID},
                    UserID => $TestUserID,
                );
                $Self->True(
                    $Success,
                    "ActivityDialog deleted - $ActivityDialog->{Name},",
                );
            }

            # Delete test activity.
            $Success = $ActivityObject->ActivityDelete(
                ID     => $Activity->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "Activity deleted - $Activity->{Name},",
            );
        }

        # Clean up transition actions.
        for my $Item ( @{ $Process->{TransitionActions} } ) {
            my $TransitionAction = $TransitionActionsObject->TransitionActionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # Delete test transition action.
            $Success = $TransitionActionsObject->TransitionActionDelete(
                ID     => $TransitionAction->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "TransitionAction deleted - $TransitionAction->{Name},",
            );
        }

        # Clean up transition.
        for my $Item ( @{ $Process->{Transitions} } ) {
            my $Transition = $TransitionObject->TransitionGet(
                EntityID => $Item,
                UserID   => $TestUserID,
            );

            # Delete test transition.
            $Success = $TransitionObject->TransitionDelete(
                ID     => $Transition->{ID},
                UserID => $TestUserID,
            );

            $Self->True(
                $Success,
                "Transition deleted - $Transition->{Name},",
            );
        }

        # Delete test process.
        $Success = $ProcessObject->ProcessDelete(
            ID     => $Process->{ID},
            UserID => $TestUserID,
        );

        $Self->True(
            $Success,
            "Process deleted - $Process->{Name},",
        );

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
            "Ticket with ticket number $TicketNumber is deleted"
        );

        # Restore state of process.
        for my $Process (@DeactivatedProcesses) {
            $ProcessObject->ProcessUpdate(
                ID            => $Process->{ID},
                EntityID      => $Process->{EntityID},
                Name          => $Process->{Name},
                StateEntityID => 'S1',
                Layout        => $Process->{Layout},
                Config        => $Process->{Config},
                UserID        => $TestUserID,
            );
        }

        # Dynchronize Process after deleting test Process.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Navigate to AdminProcessManagement screen.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminProcessManagement");

        # Synchronize Process after deleting test Process.
        $Selenium->find_element("//a[contains(\@href, \'Subaction=ProcessSync' )]")->VerifiedClick();

        # Make sure cache is correct.
        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');
        for my $Cache (
            qw(ProcessManagement_Activity ProcessManagement_ActivityDialog ProcessManagement_Process ProcessManagement_Transition ProcessManagement_TransitionAction )
            )
        {
            $CacheObject->CleanUp( Type => $Cache );
        }

    }
);

1;
