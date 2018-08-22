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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Overload CustomerUser => Map setting defined in the Defaults.pm.
        my $DefaultCustomerUser = $Kernel::OM->Get('Kernel::Config')->Get("CustomerUser");
        $DefaultCustomerUser->{Map}->[5] = [
            'UserEmail',
            'Email',
            'email',
            1,
            1,
            'var',
            '[% Env("CGIHandle") %]?Action=AgentTicketCompose;ResponseID=1;TicketID=[% Data.TicketID | uri %];ArticleID=[% Data.ArticleID | uri %]',
            0,
            '',
            'AsPopup OTRSPopup_TicketAction',
        ];
        $Helper->ConfigSettingChange(
            Key   => 'CustomerUser',
            Value => $DefaultCustomerUser,
        );

        # make sure we start with RuntimeDB search
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Hook',
            Value => 'TestTicket#',
        );
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::HookDivider',
            Value => '::',
        );

        # Enable NewArticleIgnoreSystemSender config.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::NewArticleIgnoreSystemSender',
            Value => 1,
        );

        # create and login test user
        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users' ],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # Get language object.
        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # create test customer
        my $TestCustomerUser = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # get test customer user ID
        my %TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $TestCustomerUser,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # create test ticket
        my $TitleRandom  = "Title" . $Helper->GetRandomID();
        my $TicketNumber = $TicketObject->TicketCreateNumber();
        my $TicketID     = $TicketObject->TicketCreate(
            TN           => $TicketNumber,
            Title        => $TitleRandom,
            Queue        => 'Raw',
            Lock         => 'unlock',
            Priority     => '3 normal',
            State        => 'open',
            CustomerID   => $TestCustomerUserID{UserCustomerID},
            CustomerUser => $TestCustomerUser,
            OwnerID      => 1,
            UserID       => 1,
        );
        $Self->True(
            $TicketID,
            "Ticket is created - ID $TicketID",
        );

        my $ArticleBackendObject = $Kernel::OM->Get('Kernel::System::Ticket::Article')->BackendForChannel(
            ChannelName => 'Phone',
        );

        # create two ticket articles
        my @ArticleIDs;
        for my $ArticleCreate ( 1 .. 2 ) {
            my $SenderType = 'agent';
            if ( $ArticleCreate == 2 ) {
                $SenderType = 'system';
            }
            my $ArticleID = $ArticleBackendObject->ArticleCreate(
                TicketID             => $TicketID,
                IsVisibleForCustomer => 1,
                SenderType           => $SenderType,
                Subject              => 'Selenium subject test',
                Body                 => "Article $ArticleCreate",
                ContentType          => 'text/plain; charset=ISO-8859-15',
                HistoryType          => 'OwnerUpdate',
                HistoryComment       => 'Some free text!',
                UserID               => 1,
                NoAgentNotify        => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleCreate - ID $ArticleID",
            );
            push @ArticleIDs, $ArticleID;
        }

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentTicketZoom for test created ticket
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        $Self->True(
            $Selenium->execute_script("return \$('h1:contains(TestTicket#::)')"),
            "Ticket::Hook and Ticket::HookDivider found",
        );

        $Self->True(
            $Selenium->execute_script("return \$('h1:contains($TitleRandom)')"),
            "Ticket $TitleRandom found",
        );

        # check page
        for my $Action (
            qw( AgentTicketLock AgentTicketHistory AgentTicketPrint AgentTicketPriority
            AgentTicketFreeText AgentLinkObject AgentTicketOwner AgentTicketCustomer AgentTicketNote
            AgentTicketPhoneOutbound AgentTicketPhoneInbound AgentTicketEmailOutbound AgentTicketMerge
            AgentTicketPending)
            )
        {
            my $Element = $Selenium->find_element("//a[contains(\@href, \'Action=$Action')]");
            $Element->is_enabled();
            $Element->is_displayed();
        }

        my $OTRSBusinessIsInstalled = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSBusinessIsInstalled();
        my $OBTeaser                = $LanguageObject->Translate('All attachments (OTRS Business Solution™)');
        my $OBTeaserFound           = index( $Selenium->get_page_source(), $OBTeaser ) > -1;
        if ( !$OTRSBusinessIsInstalled ) {
            $Self->True(
                $OBTeaserFound,
                "OTRSBusiness teaser found on page",
            );
        }
        else {
            $Self->False(
                $OBTeaserFound,
                "OTRSBusiness teaser not found on page",
            );
        }

        # verify article order in zoom screen
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\$('table tbody tr')[0]).attr('id')"
            ),
            'Row2',
            "First Article in table is second created article",
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\$('table tbody tr')[1]).attr('id')"
            ),
            'Row1',
            "Second Article in table is first created article",
        );

        # Verify selected article. Config 'NewArticleIgnoreSystemSender' is enable.
        #   Non system sender type article should be selected ( first created article ).
        $Self->True(
            $Selenium->execute_script(
                "return \$('#ArticleItems').find('[name=\"Article$ArticleIDs[0]\"]').length"
            ),
            "First 'agent' sender type article is selected"
        );
        $Self->False(
            $Selenium->execute_script(
                "return \$('#ArticleItems').find('[name=\"Article$ArticleIDs[1]\"]').length"
            ),
            "Second 'system' sender type article is not selected"
        );

        # click to sort by article number
        $Selenium->find_element("//th[\@class='No Sortable tablesorter-header tablesorter-headerUnSorted']")->click();

        # verify change in article order on column header click, test Core.UI.Table.Sort.js
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\$('table tbody tr')[0]).attr('id')"
            ),
            'Row1',
            "First Article in table is first created article - JS success",
        );
        $Self->Is(
            $Selenium->execute_script(
                "return \$(\$('table tbody tr')[1]).attr('id')"
            ),
            'Row2',
            "Second Article in table is second created article - JS success",
        );

        # Try to click on the email (link) that should open a popup window.
        $Selenium->WaitFor(
            JavaScript =>
                'return typeof($) === "function" && $(".SidebarColumn div:nth-of-type(2) a.AsPopup").length'
        );
        $Selenium->find_element( ".SidebarColumn div:nth-of-type(2) a.AsPopup", "css" )->click();

        # Wait for popup and switch.
        $Selenium->WaitFor( WindowCount => 2 );
        my $Handles = $Selenium->get_window_handles();
        $Selenium->switch_to_window( $Handles->[1] );

        # Wait until page has loaded, if necessary.
        $Selenium->WaitFor(
            JavaScript => 'return typeof(Core) == "object" && typeof(Core.App) == "object" && Core.App.PageLoadComplete'
        );

        # close note pop-up window
        $Selenium->close();

        # clean up test data from the DB
        my $Success = $TicketObject->TicketDelete(
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
            "Ticket is deleted - ID $TicketID"
        );

        # make sure the cache is correct
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
