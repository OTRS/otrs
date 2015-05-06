# --
# Copyright (C) 2001-2015 OTRS AG, http://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

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

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AdminSession");

        $Self->True(
            index( $Selenium->get_page_source(), $CurrentSessionID ) > -1,
            'SessionID found on page',
        );
        $Selenium->find_element( "table", 'css' );

        $Selenium->get(
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

        # kill current session, this means a logout effectively
        $Selenium->find_element( "a#KillThisSession", 'css' )->click();

        # make sure that we now see the login screen
        $Selenium->find_element( "#LoginBox", 'css' );
    }
);

1;
