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
use Kernel::Language;

# get needed objects
my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        # get helper object
        my $Helper = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');

        $Helper->ConfigSettingChange(
            Valid => 1,
            Key   => 'Ticket::Service',
            Value => 1,
        );

        # create test user and login
        my $Language      = "en";
        my $TestUserLogin = $Helper->TestUserCreate(
            Groups   => [ 'users', 'admin' ],
            Language => $Language,
        ) || die "Did not get test user";

        $Selenium->Login(
            Type     => 'Agent',
            User     => $TestUserLogin,
            Password => $TestUserLogin,
        );

        # add a test notification
        my $RandomID                = $Helper->GetRandomID();
        my $NotificationEventObject = $Kernel::OM->Get('Kernel::System::NotificationEvent');
        my $NotificationID          = $NotificationEventObject->NotificationAdd(
            Name => 'NotificationTest' . $RandomID,
            Data => {
                Events          => ['TicketQueueUpdate'],
                VisibleForAgent => ['2'],
                Transports      => ['Email'],
            },
            Message => {
                en => {
                    Subject     => 'Subject',
                    Body        => 'Body',
                    ContentType => 'text/html',
                },
            },
            ValidID => 1,
            UserID  => 1,
        );

        $Self->True(
            $NotificationID,
            "Created test notification",
        );

        # get script alias
        my $ScriptAlias = $Kernel::OM->Get('Kernel::Config')->Get('ScriptAlias');

        # navigate to AgentPreferences screen
        $Selenium->VerifiedGet("${ScriptAlias}index.pl?Action=AgentPreferences");

        # check overview AgentPreferences screen
        for my $ID (
            qw(CurPw NewPw NewPw1 UserLanguage UserSkin OutOfOfficeOn OutOfOfficeOff
            QueueID ServiceID UserRefreshTime UserCreateNextMask)
            )
        {
            my $Element = $Selenium->find_element( "#$ID", 'css' );
            $Element->is_enabled();
            $Element->is_displayed();
        }

        $Self->True(
            index( $Selenium->get_page_source(), '<span class="Mandatory">* NotificationTest' . $RandomID . '</span>' )
                > -1,
            "Notification correctly marked as mandatory in preferences."
        );

        my $CheckAlertJS = <<"JAVASCRIPT";
(function () {
    var lastAlert = undefined;
    window.alert = function (message) {
        lastAlert = message;
    };
    window.getLastAlert = function () {
        var result = lastAlert;
        lastAlert = undefined;
        return result;
    };
}());
JAVASCRIPT

        $Selenium->execute_script($CheckAlertJS);

        # we should not be able to submit the form without an alert
        $Selenium->find_element("//button[\@id='NotificationEventTransportUpdate'][\@type='submit']")->VerifiedClick();

        my $LanguageObject = Kernel::Language->new(
            UserLanguage => $Language,
        );

        $Self->Is(
            $Selenium->execute_script("return window.getLastAlert()"),
            $LanguageObject->Translate(
                "Sorry, but you can't disable all methods for notifications marked as mandatory."
            ),
            'Alert message shows up correctly',
        );

        # now enable the checkbox and try to submit again, it should work this time
        $Selenium->find_element( "//input[\@id='Notification-" . $NotificationID . "-Email-checkbox']" )
            ->VerifiedClick();
        $Selenium->find_element("//button[\@id='NotificationEventTransportUpdate'][\@type='submit']")->VerifiedClick();

        $Selenium->execute_script($CheckAlertJS);

        # now that the checkbox is checked, it should not be possible to disable it again
        $Selenium->find_element( "//input[\@id='Notification-" . $NotificationID . "-Email-checkbox']" )
            ->VerifiedClick();

        $Self->Is(
            $Selenium->execute_script("return window.getLastAlert()"),
            $LanguageObject->Translate("Sorry, but you can't disable all methods for this notification."),
            'Alert message shows up correctly',
        );

        # delete notificatio entry again
        my $SuccesDelete = $NotificationEventObject->NotificationDelete(
            ID     => $NotificationID,
            UserID => 1,
        );

        $Self->True(
            $SuccesDelete,
            "Delete test notification - $NotificationID",
        );

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
        $Selenium->find_element("//button[\@id='UserSkinUpdate'][\@type='submit']")->VerifiedClick();

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
            $Selenium->execute_script(
                "\$('#UserLanguage').val('$Language').trigger('redraw.InputField').trigger('change');"
            );

            # TODO; It should be improved. There is a problem with redraw InputField
            sleep 3;
            $Selenium->execute_script('$("#UserLanguageUpdate").click()');
            sleep 2;

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
            for my $String ( 'User Profile', 'Notification Settings', 'Other Settings' ) {
                my $Translation = $LanguageObject->Translate($String);
                $Self->True(
                    index( $Selenium->get_page_source(), $Translation ) > -1,
                    "Test widget '$String' found on screen for language $Language ($Translation)"
                ) || die;
            }
        }

        # Inject malicious code in user language variable.
        my $MaliciousCode = 'en\\\'});window.iShouldNotExist=true;Core.Config.AddConfig({a:\\\'';
        $Selenium->execute_script(
            "\$('#UserLanguage').append(
                \$('<option/>', {
                    value: '$MaliciousCode',
                    text: 'Malevolent'
                })
            ).val('$MaliciousCode').trigger('redraw.InputField').trigger('change');"
        );
        $Selenium->find_element("//button[\@id='UserLanguageUpdate'][\@type='submit']")->VerifiedClick();

        # Check if malicious code was sanitized.
        $Self->True(
            $Selenium->execute_script(
                "return typeof window.iShouldNotExist === 'undefined';"
            ),
            'Malicious variable is undefined'
        );
    }
);

1;
