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

        # get sysconfig object
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        # set link object view mode to simple
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'LinkObject::ViewMode',
            Value => 'Simple',
        );

        # set Ticket::SubjectSize
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'Ticket::SubjectSize',
            Value => '60',
        );

        # change resolution (desktop mode)
        $Selenium->set_window_size( 900, 1200 );

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
        for my $Ticket ( 1 .. 2 ) {
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

        # hover on menu bar on the misc cluster
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'Link'
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentLinkObject;SourceObject=Ticket;' )]")->click();

        # switch to link object window
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        $Selenium->find_element( "#SubmitSearch", 'css' )->click();
        sleep 1;
        $Selenium->accept_alert();

        # search for second created test ticket
        $Selenium->find_element(".//*[\@id='SEARCH::TicketNumber']")->send_keys( $TicketNumbers[1] );
        $Selenium->find_element(".//*[\@id='SEARCH::TicketNumber']")->VerifiedSubmit();

        # link created test tickets
        $Selenium->find_element("//input[\@value='$TicketIDs[1]'][\@type='checkbox']")->click();
        $Selenium->execute_script(
            "\$('#TypeIdentifier').val('ParentChild::Target').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element("//button[\@type='submit'][\@name='AddLinks']")->VerifiedClick();

        # close link object window and switch back to agent ticket zoom
        $Selenium->close();
        $Selenium->switch_to_window( $Handles->[0] );

        # refresh agent ticket zoom
        $Selenium->VerifiedRefresh();

        # verify that parent test tickets is linked with child test ticket
        $Self->True(
            index( $Selenium->get_page_source(), 'Child' ) > -1,
            "Child - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "T:" . $TicketNumbers[1] ) > -1,
            "TicketNumber $TicketNumbers[1] - found",
        );

        # click on child ticket
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketZoom;TicketID=$TicketIDs[1]' )]")
            ->VerifiedClick();

        # verify that child test ticket is linked with parent test ticket
        $Self->True(
            index( $Selenium->get_page_source(), 'Parent' ) > -1,
            "Parent - found",
        );
        $Self->True(
            index( $Selenium->get_page_source(), "T:" . $TicketNumbers[0] ) > -1,
            "TicketNumber $TicketNumbers[0] - found",
        );

        # test ticket title length in complex view for linked tickets, see bug #11511
        # set link object view mode to complex
        $SysConfigObject->ConfigItemUpdate(
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
        );

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

        # show ActionMenu - usually this is done when user hovers, however it's not possible to simulate this behaviour
        $Selenium->execute_script(
            "\$('#WidgetTicket .ActionMenu').show();"
        );

        # check if column settings button is available in the Linked Ticket widget
        $Selenium->find_element( 'a#linkobject-Ticket-toggle', 'css' )->VerifiedClick();

        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#linkobject-Ticket-setting:visible").length;'
        );

        # Remove Age from left side, and put it to the right side
        $Selenium->DragAndDrop(
            Element      => '#WidgetTicket li[data-fieldname="Age"]',
            Target       => '#AssignedFields-linkobject-Ticket',
            TargetOffset => {
                X => 185,
                Y => 10,
            },
        );

        # Remove State from right side, and put it to the left side
        $Selenium->DragAndDrop(
            Element      => '#WidgetTicket li[data-fieldname="State"]',
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

        # check for "updated" visible columns in the Linked Ticket widget
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(1)').text();"
            ),
            ' Ticket# ',
            'Updated 1st column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(2)').text();"
            ),
            ' Age ',
            'Updated 2nd column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(3)').text();"
            ),
            ' Title ',
            'Updated 3th column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(4)').text();"
            ),
            ' Queue ',
            'Updated 4th column name',
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(5)').text();"
            ),
            ' Created ',
            'Updated 5th column name',
        );

        $Self->Is(
            $Selenium->execute_script(
                "return \$('#WidgetTicket .DataTable thead tr th:nth-child(6)').text();"
            ),
            ' Linked as ',
            'Updated 6th column name',
        );

        # hover on menu bar on the misc cluster
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Miscellaneous ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'Link'
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentLinkObject;SourceObject=Ticket;' )]")->click();

        # switch to link object window
        $Selenium->WaitFor( WindowCount => 2 );
        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # click on 'go to link delete screen'
        $Selenium->find_element("//a[contains(\@href, \'Subaction=LinkDelete;' )]")->VerifiedClick();

        # check for long ticket title in LinkDelete screen
        # this one is displayed on hover
        $Self->True(
            index( $Selenium->get_page_source(), "title=\"$LongTicketTitle\"" ) > -1,
            "\"title=$LongTicketTitle\" - found in LinkDelete screen - which is displayed on hover",
        );

        # check for short ticket title in LinkDelete screen
        $Self->True(
            index( $Selenium->get_page_source(), $ShortTitle ) > -1,
            "$ShortTitle - found in LinkDelete screen",
        );

        # delete created test tickets
        for my $TicketID (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
            $Self->True(
                $Success,
                "Delete ticket - $TicketID"
            );
        }
    }
);

1;
