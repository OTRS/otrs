# --
# AgentPreferences.t - frontend tests for AgentPreferences
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

use Kernel::System::UnitTest::Helper;
use Kernel::System::UnitTest::Selenium;

# get needed objects
my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

my $Selenium = Kernel::System::UnitTest::Selenium->new(
    Verbose => 1,
);

$Selenium->RunTest(
    sub {

        my $Helper = Kernel::System::UnitTest::Helper->new(
            RestoreSystemConfiguration => 0,
        );

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
            UserSendNewTicketNotification UserSendFollowUpNotification UserSendLockTimeoutNotification
            UserSendMoveNotification UserSendServiceUpdateNotification QueueID
            ServiceID UserRefreshTime UserCreateNextMask)
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
            "default",
            "#UserSkin stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserSendNewTicketNotification', 'css' )->get_value(),
            0,
            "#UserSendNewTicketNotification stored value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserSendFollowUpNotification', 'css' )->get_value(),
            0,
            "#UserSendFollowUpNotification stored value",
        );

        # edit some of checked stored values
        $Selenium->find_element( "#UserSkin option[value='ivory']", 'css' )->click();
        $Selenium->find_element("//button[\@id='UserSkinUpdate'][\@type='submit']")->click();

        $Selenium->find_element( "#UserSendNewTicketNotification option[value='MyQueues']", 'css' )->click();
        $Selenium->find_element("//button[\@id='UserSendNewTicketNotificationUpdate'][\@type='submit']")->click();

        $Selenium->find_element( "#UserSendFollowUpNotification option[value='MyQueues']", 'css' )->click();
        $Selenium->find_element("//button[\@id='UserSendFollowUpNotificationUpdate'][\@type='submit']")->click();

        # check edited values
        $Self->Is(
            $Selenium->find_element( '#UserSkin', 'css' )->get_value(),
            "ivory",
            "#UserSkin updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserSendNewTicketNotification', 'css' )->get_value(),
            "MyQueues",
            "#UserSendNewTicketNotification updated value",
        );
        $Self->Is(
            $Selenium->find_element( '#UserSendFollowUpNotification', 'css' )->get_value(),
            "MyQueues",
            "#UserSendFollowUpNotification updated value",
        );

        # test different language scenarios
        for my $Language (
            qw(de es ru zh_CN sr_Cyrl en)
            )
        {
            # change AgentPreference language
            $Selenium->find_element( "#UserLanguage option[value='$Language']", 'css' )->click();
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
                index( $Selenium->get_page_source(), $LanguageObject->Translate('Email Settings') ) > -1,
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
