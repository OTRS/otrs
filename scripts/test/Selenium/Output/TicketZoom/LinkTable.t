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
        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');
        my $LinkObject   = $Kernel::OM->Get('Kernel::System::LinkObject');

        # Disable 'Ticket Information', 'Customer Information' and 'Linked Objects' widgets in AgentTicketZoom screen.
        for my $WidgetDisable (qw(0100-TicketInformation 0200-CustomerInformation 0300-LinkTable)) {
            $Helper->ConfigSettingChange(
                Valid => 0,
                Key   => "Ticket::Frontend::AgentTicketZoom###Widgets###$WidgetDisable",
                Value => '',
            );
        }

        # Set 'Linked Objects' widget to simple view.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'LinkObject::ViewMode',
            Value => 'Simple',
        );

        # Create three test tickets.
        my @TicketTitles;
        my @TicketIDs;
        for my $TicketCreate ( 1 .. 3 ) {
            my $TicketTitle = "Title" . $Helper->GetRandomID();
            my $TicketID    = $TicketObject->TicketCreate(
                Title      => $TicketTitle,
                Queue      => 'Raw',
                Lock       => 'unlock',
                Priority   => '3 normal',
                State      => 'open',
                CustomerID => 'SeleniumCustomer',
                OwnerID    => 1,
                UserID     => 1,
            );
            $Self->True(
                $TicketID,
                "TicketID $TicketID is created",
            );
            push @TicketTitles, $TicketTitle;
            push @TicketIDs,    $TicketID;
        }

        # Link first and second ticket as parent-child.
        my $Success = $LinkObject->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $TicketIDs[0],
            TargetObject => 'Ticket',
            TargetKey    => $TicketIDs[1],
            Type         => 'ParentChild',
            State        => 'Valid',
            UserID       => 1,
        );
        $Self->True(
            $Success,
            "TickedID $TicketIDs[0] and $TicketIDs[1] linked as parent-child"
        );

        # Link second and third ticket as parent-child.
        $Success = $LinkObject->LinkAdd(
            SourceObject => 'Ticket',
            SourceKey    => $TicketIDs[1],
            TargetObject => 'Ticket',
            TargetKey    => $TicketIDs[2],
            Type         => 'ParentChild',
            State        => 'Valid',
            UserID       => 1,
        );
        $Self->True(
            $Success,
            "TickedID $TicketIDs[1] and $TicketIDs[2] linked as parent-child"
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

        # Navigate to AgentTicketZoom for test created second ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[1]");

        # Verify it is right screen.
        $Self->True(
            index( $Selenium->get_page_source(), $TicketTitles[1] ) > -1,
            "Ticket $TicketTitles[1] found on page",
        );

        # Verify there is no 'Linked Objects' widget, it's disabled.
        $Self->True(
            index( $Selenium->get_page_source(), "Linked Objects" ) == -1,
            "Linked Objects widget is disabled",
        );

        # Reset 'Linked Objects' widget sysconfig, enable it and refresh screen.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::AgentTicketZoom###Widgets###0300-LinkTable',
            Value => {
                Module => 'Kernel::Output::HTML::TicketZoom::LinkTable',
            },
        );

        $Selenium->VerifiedRefresh();

        # Verify there is 'Linked Objects' widget, it's enabled.
        $Self->Is(
            $Selenium->find_element( '.Header>h2', 'css' )->get_text(),
            'Linked Objects',
            'Linked Objects widget is enabled',
        );

        # Verify there is link to parent ticket.
        $Self->True(
            $Selenium->find_elements(
                "//a[contains(\@class, 'LinkObjectLink')][contains(\@title, '$TicketTitles[0]')][contains(\@href, 'TicketID=$TicketIDs[0]')]"
            ),
            "Link to parent ticket found",
        );

        # Verify there is link to child ticket.
        $Self->True(
            $Selenium->find_elements(
                "//a[contains(\@class, 'LinkObjectLink')][contains(\@title, '$TicketTitles[2]')][contains(\@href, 'TicketID=$TicketIDs[2]')]"
            ),
            "Link to child ticket found",
        );

        # Verify there is no collapsed elements on the screen.
        $Self->True(
            $Selenium->find_element("//div[contains(\@class, 'WidgetSimple DontPrint Expanded')]"),
            "Linked Objects Widget is expanded",
        );

        # Toggle to collapse 'Linked Objects' widget.
        $Selenium->execute_script(
            "\$('h2:contains(Linked Object)').closest('.WidgetSimple.Expanded').find('.Toggle a').trigger('click')"
        );

        $Selenium->WaitFor(
            JavaScript => "return \$('h2:contains(Linked Object)').closest('.WidgetSimple.Collapsed').length"
        );

        # Verify there is collapsed element on the screen.
        $Self->True(
            $Selenium->execute_script(
                "return \$('h2:contains(Linked Object)').closest('.WidgetSimple.Collapsed').length"
            ),
            "Linked Objects Widget is collapsed",
        );

        # Verify 'Linked Objects' widget is in the side bar with simple view.
        $Self->Is(
            $Selenium->find_element( '.SidebarColumn .Header>h2', 'css' )->get_text(),
            'Linked Objects',
            'Linked Objects widget is positioned in the side bar with simple view',
        );

        # Change view to complex.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'LinkObject::ViewMode',
            Value => 'Complex',
        );

        # Navigate to AgentTicketZoom for test created second ticket again.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketIDs[1]");

        # Verify 'Linked Object' widget is in the main column with complex view.
        $Self->Is(
            $Selenium->find_element( '.ContentColumn #WidgetTicket .Header>h2', 'css' )->get_text(),
            'Linked: Ticket (2)',
            'Linked Objects widget is positioned in the main column with complex view',
        );

        # Cleanup test data.
        # Delete test created tickets.
        for my $TicketDelete (@TicketIDs) {
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketDelete,
                UserID   => 1,
            );

            # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
            if ( !$Success ) {
                sleep 3;
                $Success = $TicketObject->TicketDelete(
                    TicketID => $TicketDelete,
                    UserID   => 1,
                );
            }
            $Self->True(
                $Success,
                "TicketID $TicketDelete is deleted",
            );
        }

        my $CacheObject = $Kernel::OM->Get('Kernel::System::Cache');

        # Make sure the cache is correct.
        for my $Cache (qw(Ticket LinkObject)) {
            $CacheObject->CleanUp( Type => $Cache );
        }
    }
);

1;
