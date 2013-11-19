# --
# 100-AdminSession.t - frontend tests for AdminSession
# Copyright (C) 2001-2013 OTRS AG, http://otrs.com/
# --
# $Id: 100-AdminSession.t,v 1.1.2.2 2011-02-09 15:45:46 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

use strict;
use warnings;

use vars qw($Self);

use Kernel::System::UnitTest::Helper;
use Kernel::System::AuthSession;
use Time::HiRes qw(sleep);

if ( !$Self->{ConfigObject}->Get('SeleniumTestsActive') ) {
    $Self->True( 1, 'Selenium testing is not active' );
    return 1;
}

require Kernel::System::UnitTest::Selenium;

my $Helper = Kernel::System::UnitTest::Helper->new(
    UnitTestObject => $Self,
    %{$Self},
    RestoreSystemConfiguration => 0,
);

my $AuthSessionObject = Kernel::System::AuthSession->new(
    %{$Self},
);

my $TestUserLogin = $Helper->TestUserCreate(
    Groups => ['admin'],
) || die "Did not get test user";

for my $SeleniumScenario ( @{ $Helper->SeleniumScenariosGet() } ) {
    eval {
        my $sel = Kernel::System::UnitTest::Selenium->new(
            Verbose        => 1,
            UnitTestObject => $Self,
            %{$SeleniumScenario},
        );

        eval {

            $sel->Login(
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

            my $ScriptAlias = $Self->{ConfigObject}->Get('ScriptAlias');

            $sel->open_ok("${ScriptAlias}index.pl?Action=AdminSession");
            $sel->wait_for_page_to_load_ok("30000");

            $sel->is_text_present_ok($CurrentSessionID);
            $sel->is_element_present_ok("css=table");

            $sel->open_ok(
                "${ScriptAlias}index.pl?Action=AdminSession;Subaction=Detail;WantSessionID=$CurrentSessionID"
            );
            $sel->wait_for_page_to_load_ok("30000");

            $sel->is_text_present_ok($CurrentSessionID);
            $sel->is_text_present_ok($TestUserLogin);
            $sel->is_text_present_ok('UserIsGroup[admin]');
            $sel->is_text_present_ok('UserIsGroupRo[admin]');
            $sel->is_element_present_ok("css=table");

            # kill current session, this means a logout effectively
            $sel->click_ok("css=a#KillThisSession");
            $sel->wait_for_page_to_load_ok("30000");

            # make sure that we now see the login screen
            $sel->is_element_present_ok("css=#LoginBox");

            return 1;
        } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );

        return 1;

    } || $Self->True( 0, "Exception in Selenium scenario '$SeleniumScenario->{ID}': $@" );
}

1;
