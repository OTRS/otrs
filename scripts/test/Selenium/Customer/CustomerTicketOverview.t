# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
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

        # Create test customer user.
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

        # Create test email article, invisible for customer.
        my $InvisibleBody = 'invisible body';
        my $ArticleID     = $TicketObject->ArticleCreate(
            TicketID       => $TicketID,
            ArticleType    => 'note-internal',
            SenderType     => 'agent',
            Subject        => 'an article subject',
            Body           => $InvisibleBody,
            Charset        => 'ISO-8859-15',
            MimeType       => 'text/plain',
            HistoryType    => 'EmailCustomer',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        );
        $Self->True(
            $ArticleID,
            "ArticleCreate - ID $ArticleID",
        );

        # Login as test customer user.
        $Selenium->Login(
            Type     => 'Customer',
            User     => $TestCustomerUserLogin,
            Password => $TestCustomerUserLogin,
        );

        # Search for new created ticket on CustomerTicketOverview screen (default filter is Open).
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

        # Check All filter on CustomerTicketOverview screen.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=CustomerTicketOverview;Subaction=MyTickets;Filter=All' )]"
        )->VerifiedClick();

        $Self->True(
            $Selenium->find_element("//a[contains(\@href, \'Action=CustomerTicketZoom;TicketNumber=$TicketNumber' )]"),
            "Ticket with ticket number $TicketNumber is found on screen with All filter"
        );

        # Check Close filter on CustomerTicketOverview screen.
        # There is only one created ticket, and it should not be on screen with Close filter.
        $Selenium->find_element(
            "//a[contains(\@href, \'Action=CustomerTicketOverview;Subaction=MyTickets;Filter=Close' )]"
        )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), "Action=CustomerTicketZoom;TicketNumber=$TicketNumber" ) == -1,
            "Ticket with ticket number $TicketNumber is not found on screen with Close filter"
        );

        # Delete test created ticket.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "Ticket with ticket number $TicketNumber is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
