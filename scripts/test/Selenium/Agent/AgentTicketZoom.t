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

my $Hex2RGB = sub {
    my ( $Color, $Alpha ) = @_;

    return if $Color !~ /#[A-F0-9]{3,6}/i;

    # Get RGB values.
    my @Channels;
    my $RGBHex = substr( $Color, 1 );

    # Six character hexadecimal string (eg. #FFFFFF).
    if ( length $RGBHex == 6 ) {
        $Channels[0] = hex substr( $RGBHex, 0, 2 );
        $Channels[1] = hex substr( $RGBHex, 2, 2 );
        $Channels[2] = hex substr( $RGBHex, 4, 2 );
    }

    # Three character hexadecimal string (eg. #FFF).
    elsif ( length $RGBHex == 3 ) {
        $Channels[0] = hex( substr( $RGBHex, 0, 1 ) . substr( $RGBHex, 0, 1 ) );
        $Channels[1] = hex( substr( $RGBHex, 1, 1 ) . substr( $RGBHex, 1, 1 ) );
        $Channels[2] = hex( substr( $RGBHex, 2, 1 ) . substr( $RGBHex, 1, 1 ) );
    }

    else { return; }

    return sprintf( 'rgba(%s, %s, %s, %s)', @Channels, $Alpha ) if defined $Alpha;

    return sprintf( 'rgb(%s, %s, %s)', @Channels );
};

$Selenium->RunTest(
    sub {
        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

        # Overload CustomerUser => Map setting defined in the Defaults.pm.
        my $DefaultCustomerUser = $ConfigObject->Get("CustomerUser");
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

        # Make sure we start with RuntimeDB search.
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

        my $RandomID = $Helper->GetRandomID();

        # Create and login test user.
        my $Language      = 'de';
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'admin', 'users' ],
            Language => $Language,
        ) || die "Did not get test user";

        my $UserObject = $Kernel::OM->Get('Kernel::System::User');

        # Get UserID for later manipulation of preferences.
        my $UserID = $UserObject->UserLookup(
            UserLogin => $TestUserLogin,
        );

        # Set High Contrast skin.
        # See for more information bug#14370.
        my $Success = $UserObject->SetPreferences(
            Key    => 'UserSkin',
            Value  => 'highcontrast',
            UserID => $UserID,
        );
        $Self->True(
            $Success,
            "High Contrast skin is set.",
        );

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        # Create test customer.
        my $TestCustomerUser = $Helper->TestCustomerUserCreate(
        ) || die "Did not get test customer user";

        # Get test customer user ID.
        my %TestCustomerUserID = $Kernel::OM->Get('Kernel::System::CustomerUser')->CustomerUserDataGet(
            User => $TestCustomerUser,
        );

        my $TicketObject = $Kernel::OM->Get('Kernel::System::Ticket');

        # Create test ticket.
        my $TitleRandom  = "Title$RandomID";
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

        # Get image attachment.
        my $AttachmentName = "StdAttachment-Test1.png";
        my $Location       = $ConfigObject->Get('Home')
            . "/scripts/test/sample/StdAttachment/$AttachmentName";
        my $ContentRef = $Kernel::OM->Get('Kernel::System::Main')->FileRead(
            Location => $Location,
            Mode     => 'binmode',
        );
        my $Content   = ${$ContentRef};
        my $ContentID = 'inline173020.131906379.1472199795.695365.264540139@localhost';

        # Create two ticket articles.
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
                Body                 => $ArticleCreate == 1
                ? "<!DOCTYPE html><html><body>Article $ArticleCreate<br><img src=\"cid:$ContentID\" /></body></html>"
                : "Article $ArticleCreate",
                ContentType => $ArticleCreate == 1
                ? 'text/html; charset="utf8"'
                : 'text/plain; charset=ISO-8859-15',
                HistoryType    => 'OwnerUpdate',
                HistoryComment => 'Some free text!',
                UserID         => 1,
                Attachment     => [
                    {
                        Content     => $Content,
                        ContentID   => $ContentID,
                        ContentType => 'image/png; name="' . $AttachmentName . '"',
                        Disposition => 'inline',
                        FileID      => 1,
                        Filename    => $AttachmentName,
                    },
                ],
                NoAgentNotify => 1,
            );
            $Self->True(
                $ArticleID,
                "ArticleCreate - ID $ArticleID",
            );
            push @ArticleIDs, $ArticleID;
        }

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # Navigate to AgentTicketZoom for test created ticket.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID");

        my @Test = (
            {
                Name     => 'Header color',
                Color    => '#fff',
                Selector => '.UseArticleColors #ArticleTable thead a',
            },
            {
                Name     => "Article color",
                Color    => '#000',
                Selector => '.UseArticleColors #ArticleTable tbody a',
            }

        );

        # Check color of data in article table High Contrast skin.
        # See for more information bug#14370.
        for my $Item (@Test) {
            my $Element = $Selenium->find_element( $Item->{Selector}, 'css' );

            my $Color = $Item->{Color};
            if ( $Selenium->{browser_name} eq 'chrome' ) {
                $Self->Is(
                    $Element->get_css_attribute('color') // '',
                    $Hex2RGB->( $Color, 1 ),
                    "$Item->{Name} is correct - $Item->{Color}"
                );
            }
            else {
                $Self->Is(
                    $Element->get_css_attribute('color') // '',
                    $Hex2RGB->($Color),
                    "$Item->{Name} is correct - $Item->{Color}"
                );
            }
        }

        $Self->Is(
            $Selenium->execute_script("return \$('.Headline h1').text().trim();"),
            "TestTicket#::$TicketNumber — $TitleRandom",
            "Ticket::Hook and Ticket::HookDivider found, check ticket title headline",
        );

        # Check page.
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

        # Verify article order in zoom screen.
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

        $Selenium->switch_to_window( $Handles->[0] );

        # Check if the IFRAME element DOES NOT contain the session ID parameter.
        my $IframeElement = $Selenium->find_element('//iframe[not(contains(@id, "AttachmentWindow"))]');
        my $SessionName   = $Selenium->execute_script('return Core.Config.Get("SessionName");');

        $Self->False(
            ( $IframeElement->get_attribute('src') =~ m{$SessionName=} ) // 0,
            'Session ID not present in the IFRAME source URL'
        );

        # Switch off usage of session cookies.
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'SessionUseCookie',
            Value => 0,
        );

        # Get current session ID.
        my $SessionID = $Selenium->execute_script('return Core.Config.Get("SessionID");');

        # Reload the ticket zoom screen, but make sure to append the session ID parameter, as now the cookies will not
        #   be used.
        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AgentTicketZoom;TicketID=$TicketID;ArticleID=$ArticleIDs[0];$SessionName=$SessionID"
        );

        # Check if the IFRAME element now DOES contain the session ID parameter.
        $IframeElement = $Selenium->find_element('//iframe[not(contains(@id, "AttachmentWindow"))]');
        $Self->True(
            ( $IframeElement->get_attribute('src') =~ m{$SessionName=} ) // 0,
            'Session ID present in the IFRAME source URL'
        );

        # Clean up test data from the DB.
        $Success = $TicketObject->TicketDelete(
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

        # Make sure the cache is correct.
        $Kernel::OM->Get('Kernel::System::Cache')->CleanUp( Type => 'Ticket' );

    }
);

1;
