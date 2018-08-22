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

        # Enable tool bar TicketSearchFulltext.
        my %TicketSearchFulltext = (
            Block       => 'ToolBarSearchFulltext',
            CSS         => 'Core.Agent.Toolbar.FulltextSearch.css',
            Description => 'Fulltext search',
            Module      => 'Kernel::Output::HTML::ToolBar::Generic',
            Name        => 'Fulltext search',
            Priority    => '1990020',
            Size        => '10',
        );

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Frontend::ToolBarModule###12-Ticket::TicketSearchFulltext',
            Value => \%TicketSearchFulltext,
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

        # Get test user ID.
        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TicketID = $TicketObject->TicketCreate(
            Title         => "ticket",
            Queue         => 'Raw',
            Lock          => 'unlock',
            Priority      => '3 normal',
            State         => 'open',
            CustomerID    => 'SeleniumCustomerID',
            CustomerUser  => 'test@localhost.com',
            OwnerID       => $TestUserID,
            UserID        => 1,
            ResponsibleID => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - $TicketID"
        );

        my $RandomID  = $Kernel::OM->Get('Kernel::System::UnitTest::Helper')->GetRandomID();
        my $Subject   = "Test subject $RandomID";
        my $ArticleID = $TicketObject->ArticleCreate(
            TicketID       => $TicketID,
            ArticleType    => 'email-internal',
            SenderType     => 'agent',
            From           => 'Some Agent <otrs@example.com>',
            To             => 'Suplier<suplier@example.com>',
            Subject        => $Subject,
            Body           => 'the message text',
            Charset        => 'utf8',
            MimeType       => 'text/plain',
            HistoryType    => 'OwnerUpdate',
            HistoryComment => 'Some free text!',
            UserID         => 1,
        );
        $Self->True(
            $ArticleID,
            "Article is created - $ArticleID"
        );

        # Input test user in search fulltext.
        $Selenium->find_element( "#Fulltext", 'css' )->send_keys( $Subject, "\N{U+E007}" );

        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('tbody tr:contains($Subject)').length;"
        );

        # Verify search.
        $Self->True(
            index( $Selenium->get_page_source(), $Subject ) > -1,
            "Ticket is found by Subject - $Subject",
        );

        # Test for fulltext search in tool bar
        #   does not show warning for stop words Bug#13563
        #   https://bugs.otrs.org/show_bug.cgi?id=13563.

        # Enable warn on stop word usage.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::SearchIndex::WarnOnStopWordUsage',
            Value => 1,
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::SearchIndexModule',
            Value => 'Kernel::System::Ticket::ArticleSearchIndex::StaticDB',
        );

        $Selenium->VerifiedRefresh();

        # Input text in fulltext search and press enter key.
        my $TestText = 'some';
        $Selenium->find_element( "#Fulltext", 'css' )->send_keys( $TestText, "\N{U+E007}" );

        # Wait for alert box to appear.
        $Selenium->WaitFor( AlertPresent => 1 );

        # Verify the alert message.
        my $ExpectedAlertText = "Fulltext: " . $TestText;
        $Self->True(
            $Selenium->get_alert_text() =~ /$ExpectedAlertText/,
            'Stop word search string warning is found in tool bar.',
        );

        # Delete test ticket.
        my $Success = $TicketObject->TicketDelete(
            TicketID => $TicketID,
            UserID   => $TestUserID,
        );

        # Ticket deletion could fail if apache still writes to ticket history. Try again in this case.
        if ( !$Success ) {
            sleep 3;
            $Success = $TicketObject->TicketDelete(
                TicketID => $TicketID,
                UserID   => $TestUserID,
            );
        }
        $Self->True(
            $Success,
            "Ticket is deleted - $TicketID"
        );
    }
);

1;
