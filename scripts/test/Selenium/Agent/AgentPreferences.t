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
use Kernel::Language;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');
my $Selenium     = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        my $TestUserLogin = $Helper->TestUserCreate(
            Groups => ['users'],
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

        $Selenium->get("${ScriptAlias}index.pl?Action=AgentPreferences");

        # check AgentPreferences screen
        for my $ID (
            qw(CurPw NewPw NewPw1 UserLanguage UserSkin OutOfOfficeOn OutOfOfficeOff
            QueueID ServiceID UserRefreshTime UserCreateNextMask)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        # check some of AgentPreferences default values
        $Self->Is(
            $Selenium->find_element( '#UserLanguage', 'css' )->get_value(),
            "en",
            "#UserLanguage stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserSkin', 'css' )->get_value(),
            $Kernel::OM->Get('Kernel::Config')->Get('Loader::Agent::DefaultSelectedSkin'),
            "#UserSkin stored value",
        );

        # edit some of checked stored values
        $Selenium->execute_script("\$('#UserSkin').val('ivory').trigger('redraw.InputField').trigger('change');");
        $Selenium->find_element("//button[\@id='UserSkinUpdate'][\@type='submit']")->click();

        # check edited values
        $Self->Is(
            $Selenium->find_element( '#UserSkin', 'css' )->get_value(),
            "ivory",
            "#UserSkin updated value",
        );

        # test different language scenarios
        for my $Language (
            qw(de es ru zh_CN sr_Cyrl en)
            )
        {
            # change AgentPreference language
            $Selenium->execute_script("\$('#UserLanguage').val('$Language').trigger('redraw.InputField').trigger('change');");
            $Selenium->find_element("//button[\@id='UserLanguageUpdate'][\@type='submit']")->click();

            # check edited language value
            $Self->Is(
                $Selenium->find_element( '#UserLanguage', 'css' )->get_value(),
                "$Language",
                "#UserLanguage updated value",
            );

            # create language object
            my $LanguageObject = Kernel::Language->new(
                UserLanguage => "$Language",
            );

            # check for correct translation
            $Self->True(
                index( $Selenium->get_page_source(), $LanguageObject->Translate('User Profile') ) > -1,
                "Test widget 'User Profile' found on screen"
            );
            $Self->True(
                index( $Selenium->get_page_source(), $LanguageObject->Translate('Notification Settings') ) > -1,
                "Test widget 'Email Settings' found on screen"
            );
            $Self->True(
                index( $Selenium->get_page_source(), $LanguageObject->Translate('Other Settings') ) > -1,
                "Test widget 'Other Settings' found on screen"
            );
        }

    }

);

1;
