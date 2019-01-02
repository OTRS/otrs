# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
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

        # enable TimeZoneUser
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeZoneUser',
            Value => 1,
        );

        # disable TimeZoneUserBrowserAutoOffset
        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'TimeZoneUserBrowserAutoOffset',
            Value => 0,
        );

        # create test user and login
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => [ 'admin', 'users' ],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to agent preferences
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences");

        # wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # change test user time zone preference to +6 hours
        $Selenium->execute_script("\$('#UserTimeZone').val('+6').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#UserTimeZoneUpdate", 'css' )->VerifiedClick();

        # wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # check for update preference message on screen
        my $UpdateMessage = "Preferences updated successfully!";
        $Self->True(
            index( $Selenium->get_page_source(), $UpdateMessage ) > -1,
            'Agent preference time zone - updated'
        );
    }
);

1;
