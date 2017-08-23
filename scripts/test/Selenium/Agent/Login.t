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

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

use Kernel::GenericInterface::Operation::Session::Common;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

# Cleanup existing settings to make sure session limit calculations are correct.
my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
for my $SessionID ($AuthSessionObject->GetAllSessionIDs()) {
    $AuthSessionObject->RemoveSessionID( SessionID => $SessionID );
}

$Selenium->RunTest(
    sub {

        # get needed objects
        $Kernel::OM->ObjectParamAdd(
            'Kernel::System::UnitTest::Helper' => {
                RestoreSystemConfiguration => 1,
            },
        );
        my $Helper          = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $SysConfigObject = $Kernel::OM->Get('Kernel::System::SysConfig');

        my @TestUserLogins;

        for ( 0 .. 2 ) {

            # create test user and login
            my $TestUserLogin = $Helper->TestUserCreate(
                Groups => [ 'admin', 'users' ],
            ) || die "Did not get test user";

            push @TestUserLogins, $TestUserLogin;
        }

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        # First load the page so we can delete any pre-existing cookies
        $Selenium->VerifiedGet("${ScriptAlias}index.pl");
        $Selenium->delete_all_cookies();

        # Check Secure::DisableBanner functionality.
        my $Product = $Kernel::OM->Get('Kernel::Config')->Get('Product');
        my $Version = $Kernel::OM->Get('Kernel::Config')->Get('Version');
        for my $Disabled ( reverse 0 .. 1 ) {
            $SysConfigObject->ConfigItemUpdate(
                Valid => 1,
                Key   => 'Secure::DisableBanner',
                Value => $Disabled,
            );

            # Let mod_perl / Apache2::Reload pick up the changed configuration.
            sleep 1;

            $Selenium->VerifiedRefresh();

            if ($Disabled) {
                $Self->False(
                    index( $Selenium->get_page_source(), 'Powered' ) > -1,
                    'Footer banner hidden',
                );
            }
            else {
                $Self->True(
                    index( $Selenium->get_page_source(), 'Powered' ) > -1,
                    'Footer banner shown',
                );

                # Prevent version information disclosure on login page.
                $Self->False(
                    index( $Selenium->get_page_source(), "$Product $Version" ) > -1,
                    "No version information disclosure ($Product $Version)",
                );
            }
        }

        my $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        # login
        $Element->VerifiedSubmit();

        # login succressful?
        $Element = $Selenium->find_element( 'a#LogoutButton', 'css' );

        # Check for version tag in the footer.
        $Self->True(
            index( $Selenium->get_page_source(), "$Product $Version" ) > -1,
            "Version information present ($Product $Version)",
        );

        # logout again
        $Element->VerifiedClick();

        my @SessionIDs;

        my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        for my $Counter ( 1 .. 2 ) {

            # create new session id
            my $NewSessionID = $SessionObject->CreateSessionID(
                UserLogin       => $TestUserLogins[$Counter],
                UserLastRequest => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
                UserType        => 'User',
            );

            $Self->True(
                $NewSessionID,
                "Create SessionID for user '$TestUserLogins[$Counter]'",
            );

            push @SessionIDs, $NewSessionID;
        }

 # Create also two webservice session, to check that the sessions are not influence the active sessions and limit check.
        for my $Counter ( 1 .. 2 ) {

            my $NewSessionID = Kernel::GenericInterface::Operation::Session::Common->CreateSessionID(
                Data => {
                    UserLogin => $TestUserLogins[$Counter],
                    Password  => $TestUserLogins[$Counter],
                },
            );

            $Self->True(
                $NewSessionID,
                "Create webservice SessionID for user '$TestUserLogins[$Counter]'",
            );
        }

        # use test email backend
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'AgentSessionLimitPriorWarning',
            Value => 1,
        );

        # let mod_perl / Apache2::Reload pick up the changed configuration
        sleep 1;

        $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element->VerifiedSubmit();

        $Self->True(
            index( $Selenium->get_page_source(), 'Please note that the session limit is almost reached.' ) > -1,
            "AgentSessionLimitPriorWarning is reached.",
        );

        $Element = $Selenium->find_element( 'a#LogoutButton', 'css' );
        $Element->VerifiedClick();

        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'AgentSessionPerUserLimit',
            Value => 1,
        );

        # let mod_perl / Apache2::Reload pick up the changed configuration
        sleep 1;

        $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[2] );

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[2] );

        $Element->VerifiedSubmit();

        $Self->True(
            index( $Selenium->get_page_source(), 'Session per user limit reached!' ) > -1,
            "AgentSessionPerUserLimit is reached.",
        );

        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'AgentSessionLimit',
            Value => 2,
        );

        # let mod_perl / Apache2::Reload pick up the changed configuration
        sleep 1;

        $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element->VerifiedSubmit();

        $Self->True(
            index( $Selenium->get_page_source(), 'Session limit reached! Please try again later.' ) > -1,
            "AgentSessionLimit is reached.",
        );

        # Check if login works with a higher limit and that the webservice sessions have no influence on the limit.
        $SysConfigObject->ConfigItemUpdate(
            Valid => 1,
            Key   => 'AgentSessionLimit',
            Value => 3,
        );

        # let mod_perl / Apache2::Reload pick up the changed configuration
        sleep 1;

        $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element->VerifiedSubmit();

        # login successful?
        $Element = $Selenium->find_element( 'a#LogoutButton', 'css' );

        $SessionObject->CleanUp();
    }
);

1;
