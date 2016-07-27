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

        # create and login test user
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to agent preferences
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences");

        # wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # get current time stamp
        my $TimeStamp = $Kernel::OM->Get('Kernel::System::Time')->CurrentTimestamp();
        my $CurrentYear = substr( $TimeStamp, 0, 4 );

        # change test user out of office preference
        my $EndYear = $CurrentYear + 1;
        $Selenium->find_element( "#OutOfOfficeOn", 'css' )->VerifiedClick();
        $Selenium->execute_script(
            "\$('#OutOfOfficeEndYear').val('$EndYear').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#Update", 'css' )->VerifiedClick();

        # wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # check for update preference message on screen
        my $UpdateMessage = "Preferences updated successfully!";
        $Self->True(
            index( $Selenium->get_page_source(), $UpdateMessage ) > -1,
            'Agent preference out of office time - updated'
        );

        # set start time after end time, see bug #8220
        my $StartYear = $CurrentYear + 2;
        $Selenium->execute_script(
            "\$('#OutOfOfficeStartYear').val('$StartYear').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element( "#Update", 'css' )->VerifiedClick();

        # wait until form has loaded, if neccessary
        $Selenium->WaitFor( JavaScript => 'return typeof($) === "function" && $("body").length' );

        # check for error message on screen
        my $ErrorMessage = "Please specify an end date that is after the start date.";
        $Self->True(
            index( $Selenium->get_page_source(), $ErrorMessage ) > -1,
            'Agent preference out of office time - not updated'
        );
    }
);

1;
