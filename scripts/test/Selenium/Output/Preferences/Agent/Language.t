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

# get selenium object
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['admin'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # go to agent preferences
        $Selenium->get("${ScriptAlias}index.pl?Action=AgentPreferences");

        # change test user language preference to Deutsch
        $Selenium->execute_script("\$('#UserLanguage').val('de').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element( "#UserLanguageUpdate", 'css' )->click();

        # check for update preference message on screen
        my $UpdateMessage = "Benutzereinstellungen erfolgreich aktualisiert!";
        $Self->True(
            index( $Selenium->get_page_source(), $UpdateMessage ) > -1,
            'Agent preference language - updated'
        );
    }
);

1;
