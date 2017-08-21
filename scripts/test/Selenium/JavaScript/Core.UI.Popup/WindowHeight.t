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

        # do not check RichText
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::RichText',
            Value => 0
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

        # create test ticcket
        my $TicketID = $TicketObject->TicketCreate(
            Title        => 'Selenium Test Ticket',
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'new',
            CustomerID   => 'SeleniumCustomer',
            CustomerUser => 'SeleniumCustomer@localhost.com',
            OwnerID      => $TestUserID,
            UserID       => $TestUserID,
        );

        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID",
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to zoom view of created test ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # test for bug#11205 (http://bugs.otrs.org/show_bug.cgi?id=11205)
        # check screen size to open popup according to available screen height
        # open popup with default height
        # after that open popup with adjusted height
        my $ParentWindowHeight = $Selenium->get_window_size()->{"height"};

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'Note' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")
            ->VerifiedClick();

        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        my $PopupWindowHeight = $Selenium->execute_script(
            "return \$(window).height();"
        );

        $Self->Is(
            $PopupWindowHeight,
            700,
            "Default popup window height"
        );

        # close note window
        $Selenium->find_element( ".CancelClosePopup", 'css' )->click();
        $Selenium->WaitFor( WindowCount => 1 );

        # switch window back to agent ticket zoom view of created test ticket
        $Selenium->switch_to_window( $Handles->[0] );

        # now try to open a popup with a height larger than the screen height (1000)
        # adjust PopupProfile for that
        $Selenium->execute_script(
            "Core.UI.Popup.ProfileAdd('Default', { WindowURLParams: 'dependent=yes,location=no,menubar=no,resizable=yes,scrollbars=yes,status=no,toolbar=no', Left: 100, Top: 100, Width: 1040, Height: 1700 });"
        );

        # force sub menus to be visible in order to be able to click one of the links
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $("#nav-Communication ul").css({ "height": "auto", "opacity": "100" });'
        );

        # click on 'Note' and switch window
        $Selenium->find_element("//a[contains(\@href, \'Action=AgentTicketNote;TicketID=$TicketID' )]")
            ->VerifiedClick();
        $Selenium->WaitFor( WindowCount => 2 );

        $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # wait until page has loaded, if necessary
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".WidgetSimple").length;'
        );

        $PopupWindowHeight = $Selenium->execute_script(
            "return \$(window).height();"
        );

        $Self->True(
            $ParentWindowHeight - $PopupWindowHeight,
            "Popup window height ("
                . $PopupWindowHeight
                . "px) fits into screen height ("
                . $ParentWindowHeight
                . "px), even if defined larger"
        );

        # Wait until all current AJAX requests have completed, before cleaning up test entities. Otherwise, it could
        #   happen some asynchronous calls prevent entries from being deleted by running into race conditions.
        #   jQuery property $.active contains number of active AJAX calls on the page.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $.active === 0' );

        # delete created test tickets
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );
        $Self->True(
            $Success,
            "Ticket is deleted - ID $TicketID"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp(
            Type => 'Ticket',
        );

    }
);

1;
