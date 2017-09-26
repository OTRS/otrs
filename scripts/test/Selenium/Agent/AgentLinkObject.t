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

        # set link object view mode to simple
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'LinkObject::ViewMode',
            Value => 'Simple',
        );

        # set Ticket::SubjectSize
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::SubjectSize',
            Value => '60',
        );

        # disable Ticket::ArchiveSystem
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::ArchiveSystem',
            Value => 0,
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

        # create test tickets
        my @TicketIDs;
        my @TicketNumbers;
        for my $Ticket ( 1 .. 3 ) {
            my $TicketNumber = $TicketObject->TicketCreateNumber();
            my $TicketID     = $TicketObject->TicketCreate(
                TN           => $TicketNumber,
                Title        => 'Some Ticket Title',
                Queue        => 'Raw',
                Lock         => 'unlock',
                Priority     => '3 normal',
                State        => 'new',
                CustomerID   => '123465',
                CustomerUser => 'customer@example.com',
                OwnerID      => $TestUserID,
                UserID       => $TestUserID,
            );
            $Self->True(
                $TicketID,
                "Created Ticket ID $TicketID - TN $TicketNumber",
            );
            push @TicketIDs,     $TicketID;
            push @TicketNumbers, $TicketNumber;
        }

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to zoom view of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # click on 'Link'
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentLinkObject;SourceObject=Ticket;' )]")
            ->VerifiedClick();

        # switch to link object window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );
        $Selenium->execute_script("\$('#SubmitSearch').click();");

        $Selenium->WaitFor(
            AlertPresent => 1,
        );
        $Selenium->accept_alert();

        # enable Ticket::ArchiveSystem
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::ArchiveSystem',
            Value => 1,
        );

        # search for second created test ticket
        $Selenium->find_element(".//*[\@id='SEARCH::TicketNumber']")->send_keys( $TicketNumbers[1] );
        $Selenium->find_element( '#SubmitSearch', 'css' )->VerifiedClick();

        # link created test tickets
        $Selenium->find_element("//input[\@value='$TicketIDs[1]'][\@type='checkbox']")->VerifiedClick();
        $Selenium->execute_script(
            "\$('#TypeIdentifier').val('ParentChild::Target').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element("//button[\@type='submit'][\@name='AddLinks']")->click();

        # search for third created test ticket
        $Selenium->find_element(".//*[\@id='SEARCH::TicketNumber']")->clear();
        $Selenium->find_element(".//*[\@id='SEARCH::TicketNumber']")->send_keys( $TicketNumbers[2] );
        $Selenium->find_element( '#SubmitSearch', 'css' )->VerifiedClick();

        # link created test tickets
        $Selenium->find_element("//input[\@value='$TicketIDs[2]'][\@type='checkbox']")->VerifiedClick();
        $Selenium->execute_script(
            "\$('#TypeIdentifier').val('Normal::Source').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element("//button[\@type='submit'][\@name='AddLinks']")->click();

        # close link object window and switch back to agent ticket zoom
        if ( scalar( @{ $Selenium->get_window_handles() } ) == 2 ) {
            $Selenium->close();
        }
        $Selenium->switch_to_window( $Handles->[0] );

        # Wait for reload to kick in.
        sleep 1;

        # refresh agent ticket zoom
        $Selenium->VerifiedRefresh();

        # verify that parent test tickets is linked with child test ticket
        $Self->True(
            index( $Selenium->get_page_source(), 'Child' ) > -1,
            "Child - found",
        ) || die;
        $Self->True(
            index( $Selenium->get_page_source(), "T:" . $TicketNumbers[1] ) > -1,
            "TicketNumber $TicketNumbers[1] - found",
        ) || die;

        # verify that third test tickets is linked with the first ticket
        $Self->True(
            index( $Selenium->get_page_source(), 'Normal' ) > -1,
            "Normal - found",
        ) || die;
        $Self->True(
            index( $Selenium->get_page_source(), "T:" . $TicketNumbers[2] ) > -1,
            "TicketNumber $TicketNumbers[2] - found",
        ) || die;

        # click on child ticket
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom;TicketID=$TicketIDs[1]' )]")
            ->VerifiedClick();

        # verify that child test ticket is linked with parent test ticket
        $Self->True(
            index( $Selenium->get_page_source(), 'Parent' ) > -1,
            "Parent - found",
        ) || die;
        $Self->True(
            index( $Selenium->get_page_source(), "T:" . $TicketNumbers[0] ) > -1,
            "TicketNumber $TicketNumbers[0] - found",
        ) || die;

        # test ticket title length in complex view for linked tickets, see bug #11511
        # set link object view mode to complex
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'LinkObject::ViewMode',
            Value => 'Complex',
        );

        # update test ticket title to more then 50 characters (there is 65)
        my $LongTicketTitle = 'This is long test ticket title with more then 50 characters in it';

        # Ticket::SubjectSize is set to 60 at the beginning of test
        my $ShortTitle = substr( $LongTicketTitle, 0, 57 ) . "...";
        my $Success = $TicketObject->TicketTitleUpdate(
            Title    => $LongTicketTitle,
            TicketID => $TicketIDs[1],
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Updated ticket title - $TicketIDs[1]"
        );

        # navigate to AgentTicketZoom screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # check for updated ticket title in linked tickets complex view table
        $Self->True(
            index( $Selenium->get_page_source(), $LongTicketTitle ) > -1,
            "$LongTicketTitle - found in AgentTicketZoom complex view mode",
        ) || die;

        # check for "default" visible columns in the Linked Ticket widget
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(1)').text();"
            ),
            ' Ticket# ',
            'Default 1st column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(2)').text();"
            ),
            ' Title ',
            'Default 2nd column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(3)').text();"
            ),
            ' State ',
            'Default 3th column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(4)').text();"
            ),
            ' Queue ',
            'Default 4th column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(5)').text();"
            ),
            ' Created ',
            'Default 5th column name',
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(6)').text();"
            ),
            ' Linked as ',
            'Default 6th column name',
        );

        # click on the delete link in the of the third test ticket
        $Selenium->find_element(
            "a.InstantLinkDelete[data-delete-link-sourceobject='Ticket'][data-delete-link-sourcekey='$TicketIDs[2]']",
            'css'
        )->click();
        $Selenium->WaitFor(
            AlertPresent => 1,
        );
        $Selenium->accept_alert();

        # navigate to AgentTicketZoom screen again
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[0]");

        # check that link to third test ticket has been deleted
        $Self->False(
            index( $Selenium->get_page_source(), $TicketNumbers[2] ) > -1,
            "TicketNumber $TicketNumbers[2] - found",
        ) || die;

        # show ActionMenu - usually this is done when user hovers, however it's not possible to simulate this behaviour
        $Selenium->execute_script(
            "\$('#WidgetTicket .ActionMenu').show();"
        );

        # check if column settings button is available in the Linked Ticket widget
        $Selenium->find_element( 'a#linkobject-Ticket-toggle', 'css' )->VerifiedClick();

        # Wait for the complete widget to be fully slided in all the way down to the submit button.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#linkobject-Ticket_submit:visible").length;'
        );

        sleep 1;

        # TODO: remove limitation to firefox.
        if ( $Selenium->{browser_name} eq 'firefox' ) {
            $Self->True(
                1,
                "TODO: DragAndDrop is currently disabled in Firefox",
            );
        }
        else {

            # Remove Age from left side, and put it to the right side
            $Selenium->DragAndDrop(
                Element      => '#WidgetTicket #AvailableField-linkobject-Ticket li[data-fieldname="Age"]',
                Target       => '#AssignedFields-linkobject-Ticket',
                TargetOffset => {
                    X => 185,
                    Y => 10,
                },
            );

            # Remove State from right side, and put it to the left side
            $Selenium->DragAndDrop(
                Element      => '#WidgetTicket #AssignedFields-linkobject-Ticket li[data-fieldname="State"]',
                Target       => '#AvailableField-linkobject-Ticket',
                TargetOffset => {
                    X => 185,
                    Y => 10,
                },
            );

            # Put TicketNumber at the end
            $Selenium->DragAndDrop(
                Element      => '#WidgetTicket #AssignedFields-linkobject-Ticket li[data-fieldname="TicketNumber"]',
                Target       => '#AvailableField-linkobject-Ticket',
                TargetOffset => {
                    X => 185,
                    Y => 10,
                },
            );
            $Selenium->DragAndDrop(
                Element      => '#WidgetTicket #AvailableField-linkobject-Ticket li[data-fieldname="TicketNumber"]',
                Target       => '#AssignedFields-linkobject-Ticket',
                TargetOffset => {
                    X => 185,
                    Y => 90,
                },
            );

            # save
            $Selenium->find_element( '#linkobject-Ticket_submit', 'css' )->VerifiedClick();

            # wait for AJAX
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#WidgetTicket .DataTable:visible").length;'
            );

            # check for "updated" visible columns in the Linked Ticket widget
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetTicket .DataTable thead tr th:nth-child(1)').text();"
                ),
                ' Age ',
                'Updated 1st column name',
            );
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetTicket .DataTable thead tr th:nth-child(2)').text();"
                ),
                ' Title ',
                'Updated 2nd column name',
            );
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetTicket .DataTable thead tr th:nth-child(3)').text();"
                ),
                ' Queue ',
                'Updated 3th column name',
            );
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetTicket .DataTable thead tr th:nth-child(4)').text();"
                ),
                ' Created ',
                'Updated 4th column name',
            );
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetTicket .DataTable thead tr th:nth-child(5)').text();"
                ),
                ' Ticket# ',
                'Updated 5th column name',
            );

            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetTicket .DataTable thead tr th:nth-child(6)').text();"
                ),
                ' Linked as ',
                'Updated 6th column name',
            );

         # show ActionMenu - usually this is done when user hovers, however it's not possible to simulate this behaviour
            $Selenium->execute_script(
                "\$('#WidgetTicket .ActionMenu').show();"
            );

            # check if column settings button is available in the Linked Ticket widget
            $Selenium->find_element( 'a#linkobject-Ticket-toggle', 'css' )->VerifiedClick();

            # Wait for the complete widget to be fully slided in all the way down to the submit button.
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#linkobject-Ticket_submit:visible").length;'
            );

            sleep 1;

            # Remove TicketNumber from right side, and put it to the left side
            $Selenium->DragAndDrop(
                Element      => '#WidgetTicket #AssignedFields-linkobject-Ticket li[data-fieldname="TicketNumber"]',
                Target       => '#AvailableField-linkobject-Ticket',
                TargetOffset => {
                    X => 185,
                    Y => 10,
                },
            );

            # save
            $Selenium->find_element( '#linkobject-Ticket_submit', 'css' )->VerifiedClick();

            # wait for AJAX
            $Selenium->WaitFor(
                JavaScript =>
                    'return typeof($) === "function" && $("#WidgetTicket .DataTable:visible").length;'
            );

            # check if TicketNumber is still there
            $Self->Is(
                $Selenium->execute_script(
                    "return \$('#WidgetTicket .DataTable thead tr th:nth-child(1)').text();"
                ),
                ' Ticket# ',
                'Ticket# is still there.',
            );
        }

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->execute_script("\$('.Cluster ul ul').addClass('ForceVisible');");

        # click on 'Link'
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentLinkObject;SourceObject=Ticket;' )]")
            ->VerifiedClick();

        # switch to link object window
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # switch to manage links tab
        $Selenium->find_element("//a[contains(\@href, \'#ManageLinks' )]")->VerifiedClick();

        # wait for the manage links tab to show up
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("div[data-id=ManageLinks]:visible").length && parseInt($("div[data-id=ManageLinks]").css("opacity"), 10) == 1'
        );

        # check for long ticket title in LinkDelete screen
        # this one is displayed on hover
        $Self->True(
            index( $Selenium->get_page_source(), "title=\"$LongTicketTitle\"" ) > -1,
            "\"title=$LongTicketTitle\" - found in LinkDelete screen - which is displayed on hover",
        ) || die;

        # check for short ticket title in LinkDelete screen
        $Self->True(
            index( $Selenium->get_page_source(), $ShortTitle ) > -1,
            "$ShortTitle - found in LinkDelete screen",
        ) || die;

        # select all links
        $Selenium->find_element( ".Tabs div.Active .SelectAll", "css" )->VerifiedClick();

        # make sure it's selected
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SelectAllLinks0:checked").length' );

        # click on delete links
        $Selenium->find_element( ".Tabs div.Active .CallForAction", "css" )->VerifiedClick();

        # switch to add links tab
        $Selenium->find_element("//a[contains(\@href, \'#AddNewLinks' )]")->VerifiedClick();

        # wait for the add new links tab to show up
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("div[data-id=AddNewLinks]:visible").length && parseInt($("div[data-id=AddNewLinks]").css("opacity"), 10) == 1'
        );

        my $SuccessArchived = $TicketObject->TicketArchiveFlagSet(
            ArchiveFlag => 'y',
            TicketID    => $TicketIDs[1],
            UserID      => $TestUserID,
        );

        $Self->True(
            $SuccessArchived,
            "Check if 2nd ticket is archived successfully."
        );

        # check if there is "Search archive" drop-down.
        $Self->True(
            $Selenium->execute_script(
                "return \$('#SEARCH\\\\:\\\\:ArchiveID').length"
            ),
            'Search archive drop-down present.',
        );

        # search for 2nd ticket
        $Selenium->find_element(".//*[\@id='SEARCH::TicketNumber']")->send_keys( $TicketNumbers[1] );
        $Selenium->find_element( '#SubmitSearch', 'css' )->VerifiedClick();

        # make sure there are no results
        $Self->False(
            $Selenium->execute_script(
                "return \$('#WidgetTicket').length"
            ),
            'No result.',
        );

        # click on the Archive search drop-down
        $Selenium->execute_script(
            "\$('#SEARCH\\\\:\\\\:ArchiveID').val('ArchivedTickets').trigger('redraw.InputField').trigger('change');"
        );

        $Selenium->find_element( "#SubmitSearch", "css" )->VerifiedClick();

        # wait till search is loaded
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#SelectAllLinks0").length' );

        # link again
        $Selenium->find_element( ".Tabs div.Active .SelectAll", "css" )->click();
        $Selenium->find_element( "#AddLinks",                   "css" )->VerifiedClick();
        $Selenium->find_element( "#LinkAddCloseLink",           "css" )->click();
        if ( scalar( @{ $Selenium->get_window_handles() } ) == 2 ) {
            $Selenium->close();
        }

        # wait till popup is closed
        $Selenium->WaitFor( WindowCount => 1 );

        # switch to 1st window
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[0] );

        # make sure they are really linked.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#WidgetTicket").length' );
        $Selenium->find_element( "#WidgetTicket", "css" );

        # delete created test tickets
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "Delete ticket - $TicketID",
            );
        }
    }
);

1;
