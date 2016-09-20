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
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get authsession object
        my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        # check current sessions
        my $CurrentSessionID;
        my @SessionIDs = $AuthSessionObject->GetAllSessionIDs();
        SESSION_ID:
        for my $SessionID (@SessionIDs) {
            my %SessionData = $AuthSessionObject->GetSessionIDData(
                SessionID => $SessionID,
            );

            if ( %SessionData && $SessionData{UserLogin} eq $TestUserLogin ) {
                $CurrentSessionID = $SessionID;
                last SESSION_ID;
            }
        }

        $Self->True(
            scalar $CurrentSessionID,
            "Current session ID found for user $TestUserLogin",
        ) || return;

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AdminSession screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AdminSession");

        # check breadcrumb on Overview screen
        $Self->True(
            $Selenium->find_element( '.BreadCrumb', 'css' ),
            "Breadcrumb is found on Overview screen.",
        );

        $Self->True(
            index( $Selenium->get_page_source(), $CurrentSessionID ) > -1,
            'SessionID found on page',
        );
        $Selenium->find_element( "table", 'css' );

        $Selenium->VerifiedGet(
            "${ScriptAlias}index.pl?Action=AdminSession;Subaction=Detail;WantSessionID=$CurrentSessionID"
        );

        $Self->True(
            index( $Selenium->get_page_source(), $CurrentSessionID ) > -1,
            'SessionID found on page',
        );
        $Self->True(
            index( $Selenium->get_page_source(), $TestUserLogin ) > -1,
            'UserLogin found on page',
        );
        $Self->True(
            index( $Selenium->get_page_source(), 'UserIsGroup[admin]' ) > -1,
            'UserIsGroup[admin] found on page',
        );
        $Self->True(
            index( $Selenium->get_page_source(), 'UserIsGroupRo[admin]' ) > -1,
            'UserIsGroupRo[admin] found on page',
        );

        $Selenium->find_element( "table", 'css' );

        # check breadcrumb on detail view screen
        my $Count = 0;
        my $IsLinkedBreadcrumbText;
        my $DetailViewBreadcrumbText = "Detail Session View for User: $TestUserLogin $TestUserLogin";
        for my $BreadcrumbText ( 'You are here:', 'Session Management', $DetailViewBreadcrumbText ) {
            $Self->Is(
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').text().trim()"),
                $BreadcrumbText,
                "Breadcrumb text '$BreadcrumbText' is found on screen"
            );

            $IsLinkedBreadcrumbText =
                $Selenium->execute_script("return \$('.BreadCrumb li:eq($Count)').children('a').length");

            if ( $BreadcrumbText eq 'Session Management' ) {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    1,
                    "Breadcrumb text '$BreadcrumbText' is linked"
                );
            }
            else {
                $Self->Is(
                    $IsLinkedBreadcrumbText,
                    0,
                    "Breadcrumb text '$BreadcrumbText' is not linked"
                );
            }

            $Count++;
        }

        # kill current session, this means a logout effectively
        $Selenium->find_element( "a#KillThisSession", 'css' )->VerifiedClick();

        # make sure that we now see the login screen
        $Selenium->find_element( "#LoginBox", 'css' );
    }
);

1;
