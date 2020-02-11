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

        # Disable autocomplete in login form.
        $Helper->ConfigSettingChange(
            Key   => 'DisableLoginAutocomplete',
            Value => 1,
        );

        # create test customer user
        my $TestCustomerUserLogin = $Helper->TestCustomerUserCreate() || die "Did not get test customer user";

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # first load the page so we can delete any pre-existing cookies
        $Selenium->VerifiedGet("${ScriptAlias}customer.pl");
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
        $Element->send_keys($TestCustomerUserLogin);

        $Element = $Selenium->find_element( 'input#Password', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys($TestCustomerUserLogin);

        # login
        $Selenium->find_element("//button[\@type='submit']")->VerifiedClick();

        # check if login is successful
        $Element = $Selenium->find_element( 'a#LogoutButton', 'css' );

        # Check for version tag in the footer.
        $Self->True(
            index( $Selenium->get_page_source(), "$Product $Version" ) > -1,
            "Version information present ($Product $Version)",
        );

        # Enable autocomplete in login form.
        $Helper->ConfigSettingChange(
            Key   => 'DisableLoginAutocomplete',
            Value => 0,
        );

        # logout again
        $Element->VerifiedClick();

        # Check if autocomplete is enabled in login form.
        $Self->True(
            $Selenium->find_element("//input[\@name=\'User\'][\@autocomplete=\'username\']"),
            'Autocomplete for username input field is enabled.'
        );
        $Self->True(
            $Selenium->find_element("//input[\@name=\'Password\'][\@autocomplete=\'current-password\']"),
            'Autocomplete for password input field is enabled.'
        );

        # check login page
        $Element = $Selenium->find_element( 'input#User', 'css' );
        $Element->is_displayed();
        $Element->is_enabled();
        $Element->send_keys($TestCustomerUserLogin);
    }
);

1;
