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

use Kernel::GenericInterface::Operation::Session::Common;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

# Cleanup existing settings to make sure session limit calculations are correct.
my $AuthSessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');
for my $SessionID ( $AuthSessionObject->GetAllSessionIDs() ) {
    $AuthSessionObject->RemoveSessionID( SessionID => $SessionID );
}

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        # Disable autocomplete in login form.
        $Helper->ConfigSettingChange(
            Key   => 'DisableLoginAutocomplete',
            Value => 1,
        );

        my @TestUserLogins;

        # Create test users.
        for ( 0 .. 2 ) {
            my $TestUserLogin = $Helper->TestUserCreate(
                Groups => [ 'admin', 'users' ],
            ) || die "Did not get test user";

            push @TestUserLogins, $TestUserLogin;
        }

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # First load the page so we can delete any pre-existing cookies.
        $Selenium->VerifiedGet("${ScriptAlias}index.pl");
        $Selenium->delete_all_cookies();

        # Check Secure::DisableBanner functionality.
        my $Product          = $Kernel::OM->Get('Kernel::Config')->Get('Product');
        my $Version          = $Kernel::OM->Get('Kernel::Config')->Get('Version');
        my $STORMInstalled   = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSSTORMIsInstalled();
        my $CONTROLInstalled = $Kernel::OM->Get('Kernel::System::OTRSBusiness')->OTRSCONTROLIsInstalled();

        for my $Disabled ( reverse 0 .. 1 ) {
            $Helper->ConfigSettingChange(
                Key   => 'Secure::DisableBanner',
                Value => $Disabled,
            );
            $Selenium->VerifiedRefresh();

            if ($Disabled) {

                if ($STORMInstalled) {

                    my $STORMFooter = 0;

                    if ( $Selenium->get_page_source() =~ m{ ^ [ ]+ STORM \s powered }xms ) {
                        $STORMFooter = 1;
                    }

                    $Self->False(
                        $STORMFooter,
                        'Footer banner hidden',
                    );
                }
                elsif ($CONTROLInstalled) {

                    my $CONTROLFooter = 0;

                    if ( $Selenium->get_page_source() =~ m{ ^ [ ]+ CONTROL \s powered }xms ) {
                        $CONTROLFooter = 1;
                    }

                    $Self->False(
                        $CONTROLFooter,
                        'Footer banner hidden',
                    );
                }
                else {
                    $Self->False(
                        index( $Selenium->get_page_source(), 'Powered' ) > -1,
                        'Footer banner hidden',
                    );
                }
            }
            else {

                if ($STORMInstalled) {

                    my $STORMFooter = 0;

                    if ( $Selenium->get_page_source() =~ m{ ^ [ ]+ STORM \s powered }xms ) {
                        $STORMFooter = 1;
                    }

                    $Self->True(
                        $STORMFooter,
                        'Footer banner hidden',
                    );
                }
                elsif ($CONTROLInstalled) {

                    my $CONTROLFooter = 0;

                    if ( $Selenium->get_page_source() =~ m{ ^ [ ]+ CONTROL \s powered }xms ) {
                        $CONTROLFooter = 1;
                    }

                    $Self->True(
                        $CONTROLFooter,
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
        }

        # Check if autocomplete is disabled in login form.
        $Self->True(
            $Selenium->find_element("//input[\@name=\'User\'][\@autocomplete=\'off\']"),
            'Autocomplete for username input field is disabled.'
        );
        $Self->True(
            $Selenium->find_element("//input[\@name=\'Password\'][\@autocomplete=\'off\']"),
            'Autocomplete for password input field is disabled.'
        );

        my $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        # Login.
        $Selenium->find_element( '#LoginButton', 'css' )->VerifiedClick();

        # Try to expand the user profile sub menu by clicking the avatar.
        $Selenium->find_element( '.UserAvatar > a', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("li.UserAvatar > div:visible").length'
        );

        # Check if we see the logout button.
        $Element = $Selenium->find_element( 'a#LogoutButton', 'css' );

        # Check for version tag in the footer.
        $Self->True(
            index( $Selenium->get_page_source(), "$Product $Version" ) > -1,
            "Version information present ($Product $Version)",
        );

        # Logout again.
        $Element->VerifiedClick();

        my @SessionIDs;

        my $SessionObject = $Kernel::OM->Get('Kernel::System::AuthSession');

        for my $Counter ( 1 .. 2 ) {

            # Create new session id.
            my $NewSessionID = $SessionObject->CreateSessionID(
                UserLogin       => $TestUserLogins[$Counter],
                UserLastRequest => $Kernel::OM->Create('Kernel::System::DateTime')->ToEpoch(),
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

        $Helper->ConfigSettingChange(
            Key   => 'AgentSessionLimitPriorWarning',
            Value => 1,
        );

        $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Selenium->find_element( '#LoginButton', 'css' )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), 'Please note that the session limit is almost reached.' ) > -1,
            "AgentSessionLimitPriorWarning is reached.",
        );

        # Try to expand the user profile sub menu by clicking the avatar.
        $Selenium->find_element( '.UserAvatar > a', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("li.UserAvatar > div:visible").length'
        );

        # Enable autocomplete in login form.
        $Helper->ConfigSettingChange(
            Key   => 'DisableLoginAutocomplete',
            Value => 0,
        );

        $Element = $Selenium->find_element( 'a#LogoutButton', 'css' );
        $Element->VerifiedClick();

        $Helper->ConfigSettingChange(
            Key   => 'AgentSessionPerUserLimit',
            Value => 1,
        );

        # Check if autocomplete is enabled in login form.
        $Self->True(
            $Selenium->find_element("//input[\@name=\'User\'][\@autocomplete=\'username\']"),
            'Autocomplete for username input field is enabled.'
        );
        $Self->True(
            $Selenium->find_element("//input[\@name=\'Password\'][\@autocomplete=\'current-password\']"),
            'Autocomplete for password input field is enabled.'
        );

        $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[2] );

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[2] );

        $Selenium->find_element( '#LoginButton', 'css' )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), 'Session per user limit reached!' ) > -1,
            "AgentSessionPerUserLimit is reached.",
        );

        $Helper->ConfigSettingChange(
            Key   => 'AgentSessionLimit',
            Value => 2,
        );

        $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Selenium->find_element( '#LoginButton', 'css' )->VerifiedClick();

        $Self->True(
            index( $Selenium->get_page_source(), 'Session limit reached! Please try again later.' ) > -1,
            "AgentSessionLimit is reached.",
        );

        # Check if login works with a higher limit and that the webservice sessions have no influence on the limit.
        $Helper->ConfigSettingChange(
            Key   => 'AgentSessionLimit',
            Value => 3,
        );

        $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys( $TestUserLogins[0] );

        $Selenium->find_element( '#LoginButton', 'css' )->VerifiedClick();

        # Try to expand the user profile sub menu by clicking the avatar.
        $Selenium->find_element( '.UserAvatar > a', 'css' )->click();
        $Selenium->WaitFor(
            JavaScript => 'return typeof($) === "function" && $("li.UserAvatar > div:visible").length'
        );

        # Login successful?
        $Element = $Selenium->find_element( 'a#LogoutButton', 'css' );

        $SessionObject->CleanUp();
    }
);

1;
