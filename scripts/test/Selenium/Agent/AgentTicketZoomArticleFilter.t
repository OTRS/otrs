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

        # Enable article filter.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::TicketArticleFilter',
            Value => 1,
        );

        # Set ZoomExpandSort to reverse.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::ZoomExpandSort',
            Value => 'reverse',
        );

        # Set 3 max article per page.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::MaxArticlesPerPage',
            Value => 3,
        );

        # Get test data.
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

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $TestUserID = $Kernel::OM->Get('Kernel::System::User')->UserLookup(
            UserLogin => $TestUserLogin,
        );

        my $TicketObject  = $Kernel::OM->Get('Kernel::System::Ticket');
        my $ArticleObject = $Kernel::OM->Get('Kernel::System::Ticket::Article');

        # Create test ticket.
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

        # Create test articles.
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

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketZoom for test created ticket (expanded view).
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID;ZoomExpand=1");

        # Verify there are last 3 created articles on first page.
        my @FirstArticles = (
            'Fourth Test Article',
            'Fifth Test Article',
            'Sixth Test Article',
        );
        for my $Article (@FirstArticles) {
            $Self->True(
                $Selenium->execute_script("return \$('#ArticleTable:contains(\"$Article\")').length;"),
                "ZoomExpandSort: reverse - $Article found on first page - article filter off",
            );
        }

        # Verify first 3 articles are not visible, they are on second page.
        my @SecondArticles = (
            'First Test Article',
            'Second Test Article',
            'Third Test Article',
        );

        for my $Article (@SecondArticles) {
            $Self->False(
                $Selenium->execute_script("return \$('#ArticleTable:contains(\"$Article\")').length;"),
                "ZoomExpandSort: reverse - $Article not found first on page - article filter off",
            );
        }

        # Click on second page.
        $Selenium->find_element("//a[contains(\@href, \'TicketID=$TicketID;ArticlePage=2')]")->VerifiedClick();

        # Wait for Asynchronous widget and article filter to load.
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#ArticleTable').length && \$('#SetArticleFilter').length;"
        );

        # Verify there are first 3 created articles on second page.
        for my $Article (@SecondArticles) {
            $Self->True(
                $Selenium->execute_script("return \$('#ArticleTable:contains(\"$Article\")').length;"),
                "ZoomExpandSort: reverse - $Article found on second page - article filter off",
            );
        }

        # Click on article filter, open popup dialog.
        $Selenium->find_element( "#SetArticleFilter", 'css' )->click();

        # Wait for dialog to appear.
        $Selenium->WaitFor(
            JavaScript => 'return $(".Dialog:visible").length === 1;'
        );

        my %CommunicationChannel = $Kernel::OM->Get('Kernel::System::CommunicationChannel')->ChannelGet(
            ChannelName => 'Phone',
        );

        # Get customer ArticleSenderTypeID.
        my $CustomerSenderTypeID = $ArticleObject->ArticleSenderTypeLookup(
            SenderType => 'customer',
        );

        # Select phone backend and customer as article sender type for article filter.
        $Selenium->InputFieldValueSet(
            Element => '#CommunicationChannelFilter',
            Value   => $CommunicationChannel{ChannelID},
        );

        $Selenium->InputFieldValueSet(
            Element => '#ArticleSenderTypeFilter',
            Value   => $CustomerSenderTypeID,
        );

        # Close dropdown menu.
        $Selenium->execute_script("\$('.InputField_ListContainer').css('display', 'none');");

        # Apply filter.
        $Selenium->find_element("//button[\@id='DialogButton1']")->click();

        # Wait for dialog to disappear.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;'
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        # Verify we now only have first and fourth article on screen and there numeration is intact.
        my @ArticlesFilterOn = ( 'First Test Article', 'Fourth Test Article' );
        for my $ArticleFilterOn (@ArticlesFilterOn) {
            $Self->True(
                $Selenium->execute_script("return \$('#ArticleTable:contains(\"$ArticleFilterOn\")').length;"),
                "ZoomExpandSort: reverse - $ArticleFilterOn found on page with original numeration - article filter on",
            );
        }

        # Set ZoomExpandSort to normal.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Frontend::ZoomExpandSort',
            Value => 'normal',
        );

        # Refresh screen.
        $Selenium->VerifiedRefresh();

        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("#ResetArticleFilter").length;' );

        # Reset filter.
        $Selenium->find_element( "#ResetArticleFilter", 'css' )->click();

        # Wait until reset filter button has gone.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && !$("#ResetArticleFilter").length;' );

        # Click on first page.
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $(".ArticlePages a").length === 2;' );
        sleep 1;
        $Selenium->find_element("//a[contains(\@href, \'TicketID=$TicketID;ArticlePage=1')]")->VerifiedClick();

        for my $Article (@SecondArticles) {
            $Self->True(
                $Selenium->execute_script("return \$('#ArticleTable:contains(\"$Article\")').length;"),
                "ZoomExpandSort: normal - $Article found on first page - article filter off",
            );
        }

        # Click on second page.
        $Selenium->find_element("//a[contains(\@href, \'TicketID=$TicketID;ArticlePage=2')]")->VerifiedClick();

        for my $Article (@FirstArticles) {
            $Self->True(
                $Selenium->execute_script("return \$('#ArticleTable:contains(\"$Article\")').length;"),
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

        $Selenium->InputFieldValueSet(
            Element => '#ArticleSenderTypeFilter',
            Value   => "[$AgentSenderTypeID, $CustomerSenderTypeID]",
        );

        $Selenium->find_element("//button[\@id='DialogButton1']")->click();

        # Wait for dialog to disappear.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;'
        );

        # Check if customer and agent articles are shown.
        my %TestArticles = (
            customer => 'Fourth Test Article',
            agent    => 'Sixth Test Article',
        );

        for my $ArticleType ( sort keys %TestArticles ) {
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#ArticleTable:contains(\"$TestArticles{$ArticleType}\")').length;"
                ),
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

        $Selenium->InputFieldValueSet(
            Element => '#ArticleSenderTypeFilter',
            Value   => "[$AgentSenderTypeID, $CustomerSenderTypeID, $SystemSenderTypeID]",
        );

        $Selenium->find_element("//button[\@id='DialogButton1']")->click();

        # Wait for dialog to disappear.
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $(".Dialog:visible").length === 0;'
        );

        # Check if agent, customer and system articles are shown.
        %TestArticles = (
            customer => 'Fourth Test Article',
            system   => 'Fifth Test Article',
            agent    => 'Sixth Test Article',
        );

        for my $ArticleType ( sort keys %TestArticles ) {
            $Self->True(
                $Selenium->execute_script(
                    "return \$('#ArticleTable:contains(\"$TestArticles{$ArticleType}\")').length;"
                ),
                "Article type $ArticleType - \"$TestArticles{$ArticleType}\" found on page",
            );
        }

        # Check article filtering by event types in timeline view (see bug#13836).
        # TimelineView is an OTRSBusiness feature.
        my $OTRSBusinessIsInstalled = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled();

        if ($OTRSBusinessIsInstalled) {

            # Enable TimelineViewEnabled.
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'TimelineViewEnabled',
                Value => 1,
            );

            # Change max article per page config.
            $Helper->ConfigSettingChange(
                Valid => 1,
                Key   => 'Ticket::Frontend::MaxArticlesPerPage',
                Value => 100,
            );

            # Add non 'AddNote' article.
            my $RandomID          = $Helper->GetRandomID();
            my $NonAddNoteSubject = "Subject-$RandomID";
            my $NonAddNoteArticleID
                = $Kernel::OM->Get("Kernel::System::Ticket::Article::Backend::Phone")->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 1,
                SenderType           => 'agent',
                From                 => "From Customer <from$RandomID\@localhost.com>",
                To                   => "To Customer <to$RandomID\@localhost.com>",
                Subject              => $NonAddNoteSubject,
                Body                 => "Body-$RandomID",
                Charset              => 'ISO-8859-15',
                MimeType             => 'text/plain',
                HistoryType          => 'PhoneCallCustomer',
                HistoryComment       => 'Selenium testing',
                UserID               => 1,
                );
            $Self->True(
                $NonAddNoteArticleID,
                "ArticleID $NonAddNoteArticleID is created",
            );

            # Navigate to AgentTicketZoom.
            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

            $Selenium->WaitFor(
                JavaScript => "return typeof(\$) === 'function' && \$.active == 0;"
            );

            $Selenium->WaitForjQueryEventBound(
                CSSSelector => "#ArticleViewSettings",
            );

            # Set timeline view.
            $Selenium->execute_script("\$('#ArticleViewSettings').click();");
            $Selenium->WaitFor( JavaScript => 'return $(".Dialog:visible").length && $("#ArticleView").length;' );

            $Selenium->InputFieldValueSet(
                Element => '#ArticleView',
                Value   => 'Timeline',
            );

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('.TimelineView #ArticleID_$NonAddNoteArticleID').length;"
            );

            # Check last created article (PhoneCallCustomer) is shown in timeline view.
            $Self->True(
                $Selenium->execute_script("return \$('.TimelineView #ArticleID_$NonAddNoteArticleID').length;"),
                "ArticleID $NonAddNoteArticleID is shown in timeline view",
            ) || die;

            # Define article appearances depending on filter.
            my %ArticleFilters = (
                AddNote => {
                    'First Test Article'  => 0,
                    'Second Test Article' => 1,
                    'Third Test Article'  => 1,
                    'Fourth Test Article' => 0,
                    'Fifth Test Article'  => 1,
                    'Sixth Test Article'  => 1,
                    $NonAddNoteSubject    => 0,
                },
                AddNoteCustomer => {
                    'First Test Article'  => 1,
                    'Second Test Article' => 0,
                    'Third Test Article'  => 0,
                    'Fourth Test Article' => 1,
                    'Fifth Test Article'  => 0,
                    'Sixth Test Article'  => 0,
                    $NonAddNoteSubject    => 0,
                },
                PhoneCallCustomer => {
                    'First Test Article'  => 0,
                    'Second Test Article' => 0,
                    'Third Test Article'  => 0,
                    'Fourth Test Article' => 0,
                    'Fifth Test Article'  => 0,
                    'Sixth Test Article'  => 0,
                    $NonAddNoteSubject    => 1,
                },
            );

            $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

            for my $FilterValue ( sort keys %ArticleFilters ) {
                $Selenium->find_element( "#SetArticleFilter", 'css' )->click();
                $Selenium->WaitFor(
                    JavaScript => 'return $(".Dialog:visible").length && $("#EventTypeFilter").length;'
                );

                $Selenium->InputFieldValueSet(
                    Element => '#EventTypeFilter',
                    Value   => $FilterValue,
                );

                $Selenium->find_element( "#DialogButton1", 'css' )->VerifiedClick();

                for my $Subject ( sort keys %{ $ArticleFilters{$FilterValue} } ) {
                    my $Value   = $ArticleFilters{$FilterValue}->{$Subject};
                    my $IsShown = $Value ? 'shown' : 'not shown';

                    $Self->Is(
                        $Selenium->execute_script(
                            "return \$('.TimelineView li.HasArticle:contains(\"$Subject\")').length;"
                        ),
                        $Value,
                        "Timeline view - Filter '$FilterValue' - Article '$Subject' - $IsShown",
                    );
                }
            }
        }

        # Delete test created ticket.
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

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );
    }
);

1;
