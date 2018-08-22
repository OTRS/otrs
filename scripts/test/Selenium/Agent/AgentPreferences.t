# --
# Copyright (C) 2001-2018 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use utf8;

use vars (qw($Self));
use Kernel::Language;

my $Selenium = $Kernel::OM->Get('Kernel::System::UnitTest::Selenium');

$Selenium->RunTest(
    sub {

        my $Helper       = $Kernel::OM->Get('Kernel::System::UnitTest::Helper');
        my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

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

        my $ScriptAlias = $ConfigObject->Get('ScriptAlias');

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
        $Selenium->find_element( "#NotificationEventTransportUpdate", 'css' )->VerifiedClick();

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
        $Selenium->find_element( "#Notification-$NotificationID-Email-checkbox", 'css' )->click();
        $Selenium->find_element( "#NotificationEventTransportUpdate",            'css' )->VerifiedClick();

        $Selenium->execute_script($CheckAlertJS);

        # now that the checkbox is checked, it should not be possible to disable it again
        $Selenium->find_element( "#Notification-$NotificationID-Email-checkbox", 'css' )->click();

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
            $ConfigObject->Get('Loader::Agent::DefaultSelectedSkin'),
            "#UserSkin stored value",
        );

        # edit some of checked stored values
        $Selenium->execute_script("\$('#UserSkin').val('ivory').trigger('redraw.InputField').trigger('change');");
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#UserSkin').val() === 'ivory'"
        );

        $Selenium->find_element( "#UserSkinUpdate", 'css' )->VerifiedClick();
        $Selenium->WaitFor(
            JavaScript =>
                "return typeof(\$) === 'function' && \$('#UserSkin').val() === 'ivory'"
        );

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

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#UserLanguage').val() === '$Language'"
            );

            $Selenium->find_element( "#UserLanguageUpdate", 'css' )->VerifiedClick();

            $Selenium->WaitFor(
                JavaScript =>
                    "return typeof(\$) === 'function' && \$('#UserLanguage').val() === '$Language'"
            );

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
        $Selenium->find_element( "#UserLanguageUpdate", 'css' )->VerifiedClick();

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
