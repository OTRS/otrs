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

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # enable article filter
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::TicketArticleFilter',
            Value => 1,
        );

        # set ZoomExpandSort to reverse
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::ZoomExpandSort',
            Value => 'reverse',
        );

        # set 3 max article per page
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MaxArticlesPerPage',
            Value => 3,
        );

        # get test data
        my @Tests = (
            {
                Backend              => 'Phone',
                IsVisibleForCustomer => 1,
                SenderType           => 'customer',
                Subject              => 'First Test Article',
            },
            {
                Backend              => 'Email',
                IsVisibleForCustomer => 1,
                SenderType           => 'system',
                Subject              => 'Second Test Article',
            },
            {
                Backend              => 'Internal',
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                Subject              => 'Third Test Article',
            },
            {
                Backend              => 'Phone',
                IsVisibleForCustomer => 1,
                SenderType           => 'customer',
                Subject              => 'Fourth Test Article',
            },
            {
                Backend              => 'Email',
                IsVisibleForCustomer => 1,
                SenderType           => 'system',
                Subject              => 'Fifth Test Article',
            },
            {
                Backend              => 'Internal',
                IsVisibleForCustomer => 0,
                SenderType           => 'agent',
                Subject              => 'Sixth Test Article',
            }
        );

        # create and login test user
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

        my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        # create test ticket
        my $TicketID = $TicketObject->TicketCreate(
            Title      => 'Test Selenium Ticket',
            Queue      => 'Raw',
            Lock       => 'unlock',
            Priority   => '3 normal',
            State      => 'open',
            CustomerID => '12345',
            OwnerID    => $TestUserID,
            UserID     => $TestUserID,
        );
        $Self->True(
            $TicketID,
            "Ticket ID $TicketID - created",
        );

        # create test articles
        for my $Test (@Tests) {
            my $ArticleID
                = $Kernel::OM->Get("Kernel::System::Ticket::Article::Backend::$Test->{Backend}")->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => $Test->{IsVisibleForCustomer},
                SenderType           => $Test->{SenderType},
                Subject              => $Test->{Subject},
                Body                 => 'Selenium body article',
                Charset              => 'ISO-8859-15',
                MimeType             => 'text/plain',
                HistoryType          => 'AddNote',
                HistoryComment       => 'Some free text!',
                UserID               => $TestUserID,
                );
            $Self->True(
                $ArticleID,
                "Article $Test->{Subject} - created",
            );
        }

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketZoom for test created ticket (expanded view).
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID;ZoomExpand=1");

        # verify there are last 3 created articles on first page
        my @FirstArticles = (
            '#4 – Fourth Test Article',
            '#5 – Fifth Test Article',
            '#6 – Sixth Test Article',
        );
        for my $Article (@FirstArticles) {

            $Self->True(
                index( $Selenium->get_page_source(), $Article ) > -1,
                "ZoomExpandSort: reverse - $Article found on first page - article filter off",
            );
        }

        # verify first 3 articles are not visible, they are on second page
        my @SecondArticles = (
            '#1 – First Test Article',
            '#2 – Second Test Article',
            '#3 – Third Test Article',
        );

        for my $Article (@SecondArticles) {
            $Self->True(
                index( $Selenium->get_page_source(), $Article ) == -1,
                "ZoomExpandSort: reverse - $Article not found first on page - article filter off",
            );
        }

        # click on second page
        $Selenium->find_element("//a[contains(\@href, \'TicketID=$TicketID;ArticlePage=2')]")->VerifiedClick();

        # verify there are first 3 created articles on second page
        for my $Article (@SecondArticles) {
            $Self->True(
                index( $Selenium->get_page_source(), $Article ) > -1,
                "ZoomExpandSort: reverse - $Article found on second page - article filter off",
            );
        }

        # click on article filter, open popup dialog
        $Selenium->find_element( "#SetArticleFilter", 'css' )->click();

        # Wait for dialog to appear.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
        );

        my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
            ChannelName => 'Phone',
        );

        # get customer ArticleSenderTypeID
        my $CustomerSenderTypeID = $ArticleObject->ArticleSenderTypeLookup(
            SenderType => 'customer',
        );

        # select phone backend and customer as article sender type for article filter
        $Selenium->execute_script(
            "\$('#CommunicationChannelFilter').val('$CommunicationChannel{ChannelID}').trigger('redraw.InputField').trigger('change');"
        );

        $Selenium->execute_script(
            "\$('#ArticleSenderTypeFilter').val('$CustomerSenderTypeID').trigger('redraw.InputField').trigger('change');"
        );

        # close dropdown menu
        $Selenium->execute_script("\$('.InputField_ListContainer').css('display', 'none');");

        # apply filter
        $Selenium->find_element("//button[\@id='DialogButton1']")->click();

        # wait for dialog to disappear
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;'
        );

        # refresh screen
        $Selenium->VerifiedRefresh();

        # verify we now only have first and fourth article on screen and there numeration is intact
        my @ArticlesFilterOn = ( '#1 – First Test Article', '#4 – Fourth Test Article' );
        for my $ArticleFilterOn (@ArticlesFilterOn) {

            $Self->True(
                index( $Selenium->get_page_source(), $ArticleFilterOn ) > -1,
                "ZoomExpandSort: reverse - $ArticleFilterOn found on page with original numeration - article filter on",
            );
        }

        # set ZoomExpandSort to normal
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::ZoomExpandSort',
            Value => 'normal',
        );

        # refresh screen
        $Selenium->VerifiedRefresh();

        # reset filter
        $Selenium->find_element( "#ResetArticleFilter", 'css' )->click();

        # wait until reset filter button has gone
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$("#ResetArticleFilter").length' );

        # click on first page
        $Selenium->find_element("//a[contains(\@href, \'TicketID=$TicketID;ArticlePage=1')]")->VerifiedClick();

        for my $Article (@SecondArticles) {
            $Self->True(
                index( $Selenium->get_page_source(), $Article ) > -1,
                "ZoomExpandSort: normal - $Article found on first page - article filter off",
            );
        }

        # click on second page
        $Selenium->find_element("//a[contains(\@href, \'TicketID=$TicketID;ArticlePage=2')]")->VerifiedClick();

        for my $Article (@FirstArticles) {
            $Self->True(
                index( $Selenium->get_page_source(), $Article ) > -1,
                "ZoomExpandSort: normal - $Article found on second page - article filter off",
            );
        }

        # Change max article per page config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MaxArticlesPerPage',
            Value => 6,
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Open article filter dialog.
        $Selenium->find_element( "#SetArticleFilter", 'css' )->click();

        # Wait for dialog to appear.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
        );

        # Get agent ArticleSenderTypeID.
        my $AgentSenderTypeID = $ArticleObject->ArticleSenderTypeLookup(
            SenderType => 'agent',
        );

        $Selenium->execute_script(
            "\$('#ArticleSenderTypeFilter').val([$AgentSenderTypeID, $CustomerSenderTypeID]).trigger('redraw.InputField').trigger('change');"
        );

        $Selenium->find_element("//button[\@id='DialogButton1']")->VerifiedClick();

        # Check if customer and agent articles are shown.
        my %TestArticles = (
            customer => '#4 – Fourth Test Article',
            agent    => '#6 – Sixth Test Article',
        );

        for my $ArticleType ( sort keys %TestArticles ) {
            $Self->True(
                index( $Selenium->get_page_source(), $TestArticles{$ArticleType} ) > -1,
                "Article type $ArticleType - \"$TestArticles{$ArticleType}\" found on page",
            );
        }

        $Selenium->find_element( "#SetArticleFilter", 'css' )->click();

        # Wait for dialog to appear.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 1;'
        );

        # Get system ArticleSenderTypeID.
        my $SystemSenderTypeID = $ArticleObject->ArticleSenderTypeLookup(
            SenderType => 'system',
        );

        $Selenium->execute_script(
            "\$('#ArticleSenderTypeFilter').val([$AgentSenderTypeID, $CustomerSenderTypeID, $SystemSenderTypeID]).trigger('redraw.InputField').trigger('change');"
        );

        $Selenium->find_element("//button[\@id='DialogButton1']")->VerifiedClick();

        # Check if agent, customer and system articles are shown.
        %TestArticles = (
            customer => '#4 – Fourth Test Article',
            system   => '#5 – Fifth Test Article',
            agent    => '#6 – Sixth Test Article',
        );

        for my $ArticleType ( sort keys %TestArticles ) {
            $Self->True(
                index( $Selenium->get_page_source(), $TestArticles{$ArticleType} ) > -1,
                "Article type $ArticleType - \"$TestArticles{$ArticleType}\" found on page ",
            );
        }

        # delete test created ticket
        my $Success = $Kernel::OM->Get('Kernel::System::Ticket')->TicketDelete(
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
            "Ticket with ticket id $TicketID - deleted"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }

);

1;
