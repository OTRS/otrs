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

# Get selenium object.
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper               = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $TicketObject         = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject        = $Kernel::OM->Get('Kernel::System::Ticket::Article');
        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article::Backend::Email');

        # Set zoom sort to reverse.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::ZoomExpandSort',
            Value => 'reverse',
        );

        # Set maximum number of articles per page.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MaxArticlesPerPage',
            Value => 10,
        );

        # Create test customer.
        my $TestCustomerUser = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Get test customer user ID.
        my %TestCustomerUserData = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $TestCustomerUser,
        );

        # Create test user.
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            TN         => $TicketObject->TicketCreateNumber(),
            Title      => 'TestTicketTitle',
            Queue      => 'Raw',
            Lock       => 'unlock',
            Priority   => '3 normal',
            State      => 'open',
            CustomerID => $TestCustomerUserData{UserCustomerID},
            OwnerID    => 1,
            UserID     => 1,
        );
        $Self->True(
            $TicketID,
            "TicketID $TicketID is created",
        );

        # Create ticket articles.
        my @ArticleIDs;
        for my $Count ( 1 .. 15 ) {
            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 1,
                SenderType           => 'customer',
                Subject              => 'Selenium subject test',
                Body                 => "Article $Count",
                ContentType          => 'text/plain; charset=ISO-8859-15',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',
                UserID               => 1,
                NoAgentNotify        => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleID $ArticleID is created",
            );
            push @ArticleIDs, $ArticleID;

            # Set first page articles to 'seen'.
            if ( $Count > 5 ) {
                my $Set = $ArticleObject->ArticleFlagSet(
                    TicketID  => $TicketID,
                    ArticleID => $ArticleID,
                    Key       => 'Seen',
                    Value     => 1,
                    UserID    => $TestUserID,
                );
                $Self->True(
                    $Set,
                    "ArticleID $ArticleID is set to 'Seen'",
                );
            }
        }

        # Login as test user.
        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get script alias.
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketZoom for test created ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        # Check if selected article is in the first row on page 2 - it is the last not seen article (see bug#12663).
        # Check if there are exactly two pages.
        $Self->Is(
            $Selenium->execute_script("return \$('.ArticlePages a[title*=Page]').length;"),
            2,
            "There are 2 article pages",
        );

        # Check if page 2 is active.
        $Self->Is(
            $Selenium->execute_script("return \$('.ArticlePages a.Active').text();"),
            2,
            "Active article page is page 2",
        );

        # Check if active article is in the first row (Article 5).
        $Self->Is(
            $Selenium->execute_script("return \$('#ArticleTable tbody tr:eq(0).Active').attr('id');"),
            'Row5',
            "Active article is in the first table row - Row5",
        );

        # Wait until all current AJAX requests have completed, before cleaning up test entities. Otherwise, it could
        #   happen some asynchronous calls prevent entries from being deleted by running into race conditions.
        #   jQuery property $.active contains number of active AJAX calls on the page.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $.active === 0' );

        # Cleanup.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => 1,
        );
        $Self->True(
            $Success,
            "TicketID $TicketID is deleted"
        );

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
